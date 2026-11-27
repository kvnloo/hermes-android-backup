#include "flutter_window.h"

#include <optional>

#include <flutter/standard_method_codec.h>

#include "flutter/generated_plugin_registrant.h"
#include "ares_platform.h"
#include "deep_link.h"
#include "toast_activation.h"

FlutterWindow::FlutterWindow(const flutter::DartProject& project, std::string initial_toast,
                             bool accepts_toasts, std::string initial_link)
    : project_(project), initial_toast_(std::move(initial_toast)), accepts_toasts_(accepts_toasts),
      pending_link_(accepts_toasts ? std::move(initial_link) : std::string()) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  platform_ = std::make_unique<AresPlatform>(GetHandle(),
                                             flutter_controller_->engine());
  if (accepts_toasts_) {
    toasts_ = std::make_unique<ToastChannel>(flutter_controller_->engine(),
        std::move(initial_toast_), GetHandle());
  }
  if (accepts_toasts_) {
    desktop_ = std::make_unique<DesktopOs>(GetHandle(),
                                           flutter_controller_->engine());
    deep_links_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        flutter_controller_->engine()->messenger(), "com.hermesagent.ares/deeplink",
        &flutter::StandardMethodCodec::GetInstance());
    deep_links_->SetMethodCallHandler([this](const auto& call, auto result) {
      if (call.method_name() != "getInitialLink") {
        result->NotImplemented();
        return;
      }
      // Dart is listening from here on: later links go straight to it.
      links_ready_ = true;
      std::string link = std::move(pending_link_);
      pending_link_.clear();
      if (link.empty()) {
        result->Success();
      } else {
        result->Success(flutter::EncodableValue(std::move(link)));
      }
    });
  }
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::DeliverLink(std::string link) {
  HWND window = GetHandle();
  if (window) {
    // The window may be minimised or hidden in the tray.
    ::ShowWindow(window, ::IsIconic(window) ? SW_RESTORE : SW_SHOW);
    ::SetForegroundWindow(window);
  }
  if (deep_links_ && links_ready_) {
    deep_links_->InvokeMethod(
        "onDeepLink", std::make_unique<flutter::EncodableValue>(std::move(link)));
  } else {
    pending_link_ = std::move(link);
  }
}

void FlutterWindow::OnDestroy() {
  // Release the channels before the engine they speak through.
  if (deep_links_) deep_links_->SetMethodCallHandler(nullptr);
  deep_links_ = nullptr;
  desktop_ = nullptr;
  toasts_ = nullptr;
  platform_ = nullptr;
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  if (message == WM_COPYDATA) {
    if (!accepts_toasts_) return FALSE;
    const auto* data = reinterpret_cast<const COPYDATASTRUCT*>(lparam);
    if (data && data->dwData == ares::deep_link::kCopyDataId) {
      if (!data->lpData || data->cbData == 0 ||
          data->cbData > ares::deep_link::kMaxBytes) return FALSE;
      std::string link = ares::deep_link::Parse(std::string_view(
          static_cast<const char*>(data->lpData), data->cbData));
      if (link.empty()) return FALSE;
      DeliverLink(std::move(link));
      return TRUE;
    }
    if (!data || data->dwData != 0x41524553 || !data->lpData ||
        data->cbData != ares::toast::kTokenSize) return FALSE;
    std::string token(static_cast<const char*>(data->lpData), data->cbData);
    if (!ares::toast::ValidToken(token)) return FALSE;
    if (toasts_) toasts_->Activate(std::move(token));
    else initial_toast_ = std::move(token);
    return TRUE;
  }
  if (desktop_) {
    if (auto handled = desktop_->HandleMessage(hwnd, message, wparam, lparam)) {
      return *handled;
    }
  }
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
