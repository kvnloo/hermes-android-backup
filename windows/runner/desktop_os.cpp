#include "desktop_os.h"

#include <shellapi.h>
#include <windowsx.h>
#include <wtsapi32.h>

#include <flutter/flutter_engine.h>
#include <flutter/standard_method_codec.h>

#include <string>
#include <variant>

#include "resource.h"
#include "screen_capture.h"

namespace {

using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;

constexpr UINT kTrayCallback = WM_APP + 0x41;
constexpr UINT kCapturePicked = WM_APP + 0x42;
constexpr UINT kCaptureDone = WM_APP + 0x43;
constexpr UINT kTrayIconId = 1;

const EncodableValue* Field(const EncodableMap& map, const char* key) {
  auto it = map.find(EncodableValue(key));
  return it == map.end() ? nullptr : &it->second;
}

bool BoolField(const EncodableMap& map, const char* key) {
  const auto* value = Field(map, key);
  const auto* flag = value ? std::get_if<bool>(value) : nullptr;
  return flag && *flag;
}

std::string StringField(const EncodableMap& map, const char* key) {
  const auto* value = Field(map, key);
  const auto* text = value ? std::get_if<std::string>(value) : nullptr;
  return text ? *text : std::string();
}

std::wstring Wide(const std::u16string& text) {
  return std::wstring(text.begin(), text.end());
}

std::wstring WideFromUtf8(const std::string& text) {
  if (text.empty()) return std::wstring();
  const int size = static_cast<int>(text.size());
  const int length = ::MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS,
                                           text.c_str(), size, nullptr, 0);
  if (length <= 0) return std::wstring();
  std::wstring wide(static_cast<size_t>(length), L'\0');
  ::MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, text.c_str(), size,
                        wide.data(), length);
  return wide;
}

}  // namespace

DesktopOs::DesktopOs(HWND window, flutter::FlutterEngine* engine)
    : window_(window),
      taskbar_created_(::RegisterWindowMessageW(L"TaskbarCreated")) {
  shell_ = std::make_unique<flutter::MethodChannel<EncodableValue>>(
      engine->messenger(), "com.hermesagent.ares/shell",
      &flutter::StandardMethodCodec::GetInstance());
  shell_->SetMethodCallHandler([this](const auto& call, auto result) {
    HandleShell(call, std::move(result));
  });
  hotkey_ = std::make_unique<flutter::MethodChannel<EncodableValue>>(
      engine->messenger(), "com.hermesagent.ares/hotkey",
      &flutter::StandardMethodCodec::GetInstance());
  hotkey_->SetMethodCallHandler([this](const auto& call, auto result) {
    HandleHotkey(call, std::move(result));
  });
  power_ = std::make_unique<flutter::MethodChannel<EncodableValue>>(
      engine->messenger(), "com.hermesagent.ares/power",
      &flutter::StandardMethodCodec::GetInstance());
  power_->SetMethodCallHandler([this](const auto& call, auto result) {
    HandlePower(call, std::move(result));
  });
  capture_ = std::make_unique<flutter::MethodChannel<EncodableValue>>(
      engine->messenger(), "com.hermesagent.ares/capture",
      &flutter::StandardMethodCodec::GetInstance());
  capture_->SetMethodCallHandler([this](const auto& call, auto result) {
    HandleCapture(call, std::move(result));
  });
  // Lock/unlock arrive as WM_WTSSESSION_CHANGE; suspend/resume as
  // WM_POWERBROADCAST, which every top-level window receives.
  session_notifications_ =
      ::WTSRegisterSessionNotification(window_, NOTIFY_FOR_THIS_SESSION) !=
      FALSE;
}

DesktopOs::~DesktopOs() {
  // Exit releases the hotkey even if Dart never got to unregister it.
  UnregisterHotkey();
  tray_wanted_ = false;
  StopTrayRetry();
  RemoveTray();
  if (session_notifications_) ::WTSUnRegisterSessionNotification(window_);
  if (awake_.Any()) ::SetThreadExecutionState(ES_CONTINUOUS);
  if (capture_result_) capture_result_->Error("cancelled", "window closed");
  if (capture_) capture_->SetMethodCallHandler(nullptr);
  if (power_) power_->SetMethodCallHandler(nullptr);
  if (hotkey_) hotkey_->SetMethodCallHandler(nullptr);
  if (shell_) shell_->SetMethodCallHandler(nullptr);
  if (tray_icon_) ::DestroyIcon(tray_icon_);
}

void DesktopOs::HandleShell(
    const flutter::MethodCall<EncodableValue>& call, Result result) {
  const std::string& method = call.method_name();
  if (method == "showWindow") {
    ShowMain();
    result->Success();
    return;
  }
  if (method == "quit") {
    // Closing from inside a channel callback would destroy the engine that
    // is dispatching it; post the close instead. Close-to-tray is off now.
    close_to_tray_ = false;
    tray_wanted_ = false;
    StopTrayRetry();
    RemoveTray();
    ::PostMessageW(window_, WM_CLOSE, 0, 0);
    result->Success();
    return;
  }
  if (method == "isTraySupported") {
    result->Success(EncodableValue(true));
    return;
  }
  if (method == "allowForeground") {
    // Quick entry started as this child process: only it may take the
    // foreground (never ASFW_ANY). The primary holds the right just after
    // the hotkey press or the tray menu choice that opened it.
    const auto* args = std::get_if<EncodableMap>(call.arguments());
    const auto* value = args ? Field(*args, "pid") : nullptr;
    long long pid = 0;
    if (value) {
      // (Not "small": rpcndr.h defines it as a macro for char.)
      if (const auto* as_int32 = std::get_if<int32_t>(value)) pid = *as_int32;
      if (const auto* as_int64 = std::get_if<int64_t>(value)) pid = *as_int64;
    }
    const bool allowed =
        ares::desktop::ValidForegroundPid(pid) &&
        ::AllowSetForegroundWindow(static_cast<DWORD>(pid)) != FALSE;
    result->Success(EncodableValue(allowed));
    return;
  }
  if (method != "setTray") {
    result->NotImplemented();
    return;
  }
  const auto* args = std::get_if<EncodableMap>(call.arguments());
  if (!args) {
    result->Error("bad-args", "setTray expects a map");
    return;
  }
  if (!BoolField(*args, "enabled")) {
    close_to_tray_ = false;
    tray_wanted_ = false;
    StopTrayRetry();
    RemoveTray();
    tray_reported_ = false;
    result->Success(EncodableValue(false));
    return;
  }
  std::vector<ares::desktop::TrayItem> items;
  const auto* list_value = Field(*args, "items");
  const auto* list = list_value ? std::get_if<EncodableList>(list_value) : nullptr;
  if (list) {
    for (const auto& entry : *list) {
      const auto* map = std::get_if<EncodableMap>(&entry);
      if (!map || items.size() >= ares::desktop::kTrayMaxItems) continue;
      ares::desktop::TrayItem item;
      item.id = StringField(*map, "id");
      item.label = ares::desktop::MenuTextFromUtf8(
          StringField(*map, "label"), ares::desktop::kTrayLabelUnits);
      if (!ares::desktop::ValidTrayItemId(item.id) || item.label.empty()) {
        continue;
      }
      item.checked = BoolField(*map, "checked");
      item.separator_before = BoolField(*map, "separatorBefore");
      items.push_back(std::move(item));
    }
  }
  items_ = std::move(items);
  tooltip_ = ares::desktop::MenuTextFromUtf8(StringField(*args, "tooltip"),
                                             ares::desktop::kTrayTipUnits);
  if (tooltip_.empty()) tooltip_ = u"Ares";
  tray_wanted_ = true;
  // Applies only while the icon is installed (WM_CLOSE checks both), so a
  // retry that installs it later also brings close-to-tray back.
  close_to_tray_ = BoolField(*args, "closeToTray");
  const bool shown = InstallTray();
  if (shown) {
    StopTrayRetry();
  } else if (!tray_retry_pending_) {
    // Explorer may still be starting (sign-in): retry on a short backoff,
    // and on TaskbarCreated. Dart hears onTrayStatus when it works.
    tray_retry_attempt_ = 0;
    ScheduleTrayRetry();
  }
  tray_reported_ = shown;
  result->Success(EncodableValue(shown));
}

void DesktopOs::HandleHotkey(
    const flutter::MethodCall<EncodableValue>& call, Result result) {
  const std::string& method = call.method_name();
  if (method == "isSupported") {
    // RegisterHotKey works in every interactive Windows session.
    result->Success(EncodableValue(true));
    return;
  }
  if (method == "unregister") {
    UnregisterHotkey();
    result->Success();
    return;
  }
  if (method != "register") {
    result->NotImplemented();
    return;
  }
  const auto* args = std::get_if<EncodableMap>(call.arguments());
  if (!args) {
    result->Error("bad-args", "register expects a map");
    return;
  }
  const auto request = ares::desktop::HotkeyFor(
      StringField(*args, "key"), BoolField(*args, "meta"),
      BoolField(*args, "ctrl"), BoolField(*args, "alt"),
      BoolField(*args, "shift"));
  if (!request) {
    result->Success(EncodableValue("invalid"));
    return;
  }
  UnregisterHotkey();
  if (::RegisterHotKey(window_, ares::desktop::kHotkeyId, request->modifiers,
                       request->vk)) {
    hotkey_registered_ = true;
    result->Success(EncodableValue("registered"));
    return;
  }
  const DWORD error = ::GetLastError();
  result->Success(EncodableValue(
      error == ERROR_HOTKEY_ALREADY_REGISTERED ? "conflict" : "unsupported"));
}

void DesktopOs::HandlePower(
    const flutter::MethodCall<EncodableValue>& call, Result result) {
  const std::string& method = call.method_name();
  if (method == "isSupported") {
    result->Success(EncodableValue(true));
    return;
  }
  if (method != "setAwake") {
    result->NotImplemented();
    return;
  }
  const auto* args = std::get_if<EncodableMap>(call.arguments());
  const std::string owner = args ? StringField(*args, "owner") : std::string();
  if (owner.empty() || owner.size() > 128) {
    result->Error("bad-args", "setAwake expects {owner, enabled}");
    return;
  }
  if (awake_.Set(owner, BoolField(*args, "enabled"))) {
    // Keeps the system (not the display) awake while any owner asks.
    ::SetThreadExecutionState(awake_.Any()
                                  ? (ES_CONTINUOUS | ES_SYSTEM_REQUIRED)
                                  : ES_CONTINUOUS);
  }
  result->Success();
}

void DesktopOs::HandleCapture(
    const flutter::MethodCall<EncodableValue>& call, Result result) {
  const std::string& method = call.method_name();
  if (method == "status" || method == "requestPermission") {
    // The Graphics Capture picker is the consent for each capture.
    result->Success(EncodableValue(EncodableMap{
        {EncodableValue("supported"),
         EncodableValue(ares::capture::Supported())},
        {EncodableValue("permission"), EncodableValue("not-required")},
    }));
    return;
  }
  if (method == "openSettings") {
    result->Success(EncodableValue(false));
    return;
  }
  if (method != "capture") {
    result->NotImplemented();
    return;
  }
  const auto* args = std::get_if<EncodableMap>(call.arguments());
  const std::wstring directory =
      WideFromUtf8(args ? StringField(*args, "directory") : std::string());
  const DWORD attributes =
      directory.empty() ? INVALID_FILE_ATTRIBUTES
                        : ::GetFileAttributesW(directory.c_str());
  if (attributes == INVALID_FILE_ATTRIBUTES ||
      !(attributes & FILE_ATTRIBUTE_DIRECTORY)) {
    result->Error("bad-args", "capture expects {directory}");
    return;
  }
  if (!ares::capture::Supported()) {
    result->Error("unsupported", "Windows Graphics Capture is unavailable");
    return;
  }
  if (capture_result_) {
    result->Error("failed", "busy");
    return;
  }
  capture_result_ = std::move(result);
  capture_directory_ = directory;
  if (!ares::capture::Pick(window_, kCapturePicked)) {
    FinishCapture(std::string(), "failed");
  }
}

void DesktopOs::FinishCapture(const std::string& path,
                              const std::string& error) {
  Result result = std::move(capture_result_);
  capture_result_ = nullptr;
  capture_directory_.clear();
  if (!result) return;
  if (!error.empty()) {
    result->Error(error, error);
  } else {
    result->Success(EncodableValue(path));
  }
}

void DesktopOs::UnregisterHotkey() {
  if (!hotkey_registered_) return;
  ::UnregisterHotKey(window_, ares::desktop::kHotkeyId);
  hotkey_registered_ = false;
}

bool DesktopOs::InstallTray() {
  if (!tray_icon_) {
    tray_icon_ = static_cast<HICON>(::LoadImageW(
        ::GetModuleHandleW(nullptr), MAKEINTRESOURCEW(IDI_APP_ICON), IMAGE_ICON,
        ::GetSystemMetrics(SM_CXSMICON), ::GetSystemMetrics(SM_CYSMICON), 0));
  }
  NOTIFYICONDATAW data{};
  data.cbSize = sizeof(data);
  data.hWnd = window_;
  data.uID = kTrayIconId;
  data.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP | NIF_SHOWTIP;
  data.uCallbackMessage = kTrayCallback;
  data.hIcon = tray_icon_;
  const std::wstring tip = Wide(tooltip_);
  ::wcsncpy_s(data.szTip, tip.c_str(), _TRUNCATE);
  if (tray_installed_) {
    tray_installed_ = ::Shell_NotifyIconW(NIM_MODIFY, &data) != FALSE;
    if (tray_installed_) return true;
  }
  if (!::Shell_NotifyIconW(NIM_ADD, &data)) return false;
  data.uVersion = NOTIFYICON_VERSION_4;
  ::Shell_NotifyIconW(NIM_SETVERSION, &data);
  tray_installed_ = true;
  return true;
}

void DesktopOs::ScheduleTrayRetry() {
  const unsigned delay = ares::desktop::TrayRetryDelayMs(tray_retry_attempt_);
  if (delay == 0) {
    // The timer gives up; TaskbarCreated still re-adds the icon.
    tray_retry_pending_ = false;
    return;
  }
  ++tray_retry_attempt_;
  tray_retry_pending_ =
      ::SetTimer(window_, ares::desktop::kTrayRetryTimerId, delay, nullptr) !=
      0;
}

void DesktopOs::StopTrayRetry() {
  if (tray_retry_pending_) {
    ::KillTimer(window_, ares::desktop::kTrayRetryTimerId);
  }
  tray_retry_pending_ = false;
  tray_retry_attempt_ = 0;
}

void DesktopOs::RetryTray() {
  if (!tray_wanted_) {
    StopTrayRetry();
    return;
  }
  if (InstallTray()) {
    StopTrayRetry();
    ReportTrayStatus();
    return;
  }
  // An icon Dart was told is shown is gone (Explorer restarted and the
  // re-add failed): say so, and keep trying.
  ReportTrayStatus();
  ScheduleTrayRetry();
}

// The icon appeared (or went away) after setTray answered: tell Dart.
void DesktopOs::ReportTrayStatus() {
  const bool shown = tray_wanted_ && tray_installed_;
  if (shown == tray_reported_ || !shell_) return;
  tray_reported_ = shown;
  shell_->InvokeMethod("onTrayStatus", std::make_unique<EncodableValue>(shown));
}

void DesktopOs::RemoveTray() {
  if (!tray_installed_) return;
  NOTIFYICONDATAW data{};
  data.cbSize = sizeof(data);
  data.hWnd = window_;
  data.uID = kTrayIconId;
  ::Shell_NotifyIconW(NIM_DELETE, &data);
  tray_installed_ = false;
}

void DesktopOs::ShowMain() {
  if (!::IsWindowVisible(window_)) ::ShowWindow(window_, SW_SHOW);
  if (::IsIconic(window_)) ::ShowWindow(window_, SW_RESTORE);
  ::SetForegroundWindow(window_);
}

void DesktopOs::ShowMenu(int x, int y) {
  if (menu_open_ || items_.empty()) return;
  // The menu loop below pumps messages, so a setTray can replace items_
  // while it is open. The chosen command maps back through this snapshot of
  // what was shown, never through the newer list.
  const std::vector<ares::desktop::TrayItem> shown = items_;
  HMENU menu = ::CreatePopupMenu();
  if (!menu) return;
  for (size_t i = 0; i < shown.size(); ++i) {
    const auto& item = shown[i];
    if (item.separator_before && i > 0) {
      ::AppendMenuW(menu, MF_SEPARATOR, 0, nullptr);
    }
    const std::wstring label = Wide(item.label);
    ::AppendMenuW(menu, MF_STRING | (item.checked ? MF_CHECKED : MF_UNCHECKED),
                  static_cast<UINT_PTR>(ares::desktop::kTrayFirstCommand + i),
                  label.c_str());
  }
  // The menu closes on an outside click only if the owner is foreground.
  ::SetForegroundWindow(window_);
  menu_open_ = true;
  const UINT align = ::GetSystemMetrics(SM_MENUDROPALIGNMENT)
                         ? TPM_RIGHTALIGN
                         : TPM_LEFTALIGN;
  const BOOL command = ::TrackPopupMenuEx(
      menu, TPM_RETURNCMD | TPM_NONOTIFY | TPM_RIGHTBUTTON | align, x, y,
      window_, nullptr);
  menu_open_ = false;
  ::PostMessageW(window_, WM_NULL, 0, 0);
  ::DestroyMenu(menu);
  const auto index = ares::desktop::TrayIndexForCommand(
      static_cast<unsigned>(command), shown.size());
  if (index && shell_) {
    // A quick-entry window this starts gets the foreground through
    // allowForeground with its own pid, once Dart has started it.
    shell_->InvokeMethod(
        "onTrayAction", std::make_unique<EncodableValue>(shown[*index].id));
  }
}

std::optional<LRESULT> DesktopOs::HandleMessage(HWND, UINT message,
                                                WPARAM wparam, LPARAM lparam) {
  if (message == kTrayCallback) {
    switch (LOWORD(lparam)) {
      case NIN_SELECT:
      case NIN_KEYSELECT:
        ShowMain();
        break;
      case WM_CONTEXTMENU:
        ShowMenu(GET_X_LPARAM(wparam), GET_Y_LPARAM(wparam));
        break;
      default:
        break;
    }
    return 0;
  }
  if (taskbar_created_ != 0 && message == taskbar_created_) {
    // Explorer (re)started: its notification area forgot the icon, or it
    // was not ready when setTray first asked (sign-in). Add it now if Dart
    // wants it, installed before or never.
    if (tray_wanted_) {
      tray_installed_ = false;
      tray_retry_attempt_ = 0;
      RetryTray();
    }
    return std::nullopt;
  }
  if (message == WM_TIMER &&
      wparam == static_cast<WPARAM>(ares::desktop::kTrayRetryTimerId)) {
    ::KillTimer(window_, ares::desktop::kTrayRetryTimerId);
    tray_retry_pending_ = false;
    RetryTray();
    return 0;
  }
  if (message == kCapturePicked) {
    auto* picked = reinterpret_cast<ares::capture::Picked*>(lparam);
    if (!capture_result_) {
      ares::capture::Release(picked);
    } else if (!picked) {
      FinishCapture(std::string(), "cancelled");
    } else {
      ares::capture::CaptureAsync(window_, kCaptureDone, picked,
                                  capture_directory_);
    }
    return 0;
  }
  if (message == kCaptureDone) {
    std::unique_ptr<ares::capture::Outcome> outcome(
        reinterpret_cast<ares::capture::Outcome*>(lparam));
    if (outcome && capture_result_) {
      FinishCapture(outcome->path, outcome->error);
    }
    return 0;
  }
  if (const char* event = ares::desktop::PowerEventName(
          message, static_cast<unsigned long long>(wparam))) {
    if (power_) {
      power_->InvokeMethod("onPowerEvent",
                           std::make_unique<EncodableValue>(event));
    }
    return std::nullopt;  // Default handling still applies.
  }
  if (message == WM_HOTKEY &&
      wparam == static_cast<WPARAM>(ares::desktop::kHotkeyId)) {
    if (hotkey_registered_ && hotkey_) {
      // Quick entry starts as a child process; Dart passes its pid to
      // allowForeground so only that process may take the foreground.
      hotkey_->InvokeMethod("onHotKey", nullptr);
    }
    return 0;
  }
  if (message == WM_CLOSE && close_to_tray_ && tray_installed_) {
    ::ShowWindow(window_, SW_HIDE);
    return 0;
  }
  return std::nullopt;
}
