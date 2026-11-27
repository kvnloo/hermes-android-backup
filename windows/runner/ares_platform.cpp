#include "ares_platform.h"

#include <shobjidl.h>
#include <wrl/client.h>

#include <flutter/flutter_engine.h>
#include <flutter/standard_method_codec.h>

#include <algorithm>
#include <cwctype>
#include <string>
#include <variant>

namespace {

using flutter::EncodableMap;
using flutter::EncodableValue;

constexpr size_t kPathBufferSize = 4096;

std::wstring ToWide(const std::string& text) {
  if (text.empty()) return L"";
  const int size = static_cast<int>(text.size());
  const int len =
      ::MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, text.c_str(), size,
                            nullptr, 0);
  if (len <= 0) return L"";
  std::wstring wide(static_cast<size_t>(len), L'\0');
  ::MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, text.c_str(), size,
                        wide.data(), len);
  return wide;
}

std::string ToUtf8(const std::wstring& wide) {
  if (wide.empty()) return "";
  const int size = static_cast<int>(wide.size());
  const int len = ::WideCharToMultiByte(CP_UTF8, 0, wide.c_str(), size, nullptr,
                                        0, nullptr, nullptr);
  if (len <= 0) return "";
  std::string text(static_cast<size_t>(len), '\0');
  ::WideCharToMultiByte(CP_UTF8, 0, wide.c_str(), size, text.data(), len,
                        nullptr, nullptr);
  return text;
}

// Absolute path with `.`/`..` collapsed and 8.3 short names expanded, so the
// cache-root comparison below compares like with like. Empty on failure.
std::wstring NormalizePath(const std::wstring& path) {
  if (path.empty()) return L"";
  std::wstring full(kPathBufferSize, L'\0');
  DWORD len = ::GetFullPathNameW(path.c_str(), static_cast<DWORD>(full.size()),
                                 full.data(), nullptr);
  if (len == 0 || len >= full.size()) return L"";
  full.resize(len);

  std::wstring expanded(kPathBufferSize, L'\0');
  len = ::GetLongPathNameW(full.c_str(), expanded.data(),
                           static_cast<DWORD>(expanded.size()));
  if (len == 0 || len >= expanded.size()) return full;
  expanded.resize(len);
  return expanded;
}

// The per-user temp directory, normalised, always ending in a backslash.
std::wstring TempRoot() {
  std::wstring buffer(kPathBufferSize, L'\0');
  const DWORD len =
      ::GetTempPathW(static_cast<DWORD>(buffer.size()), buffer.data());
  if (len == 0 || len >= buffer.size()) return L"";
  buffer.resize(len);
  std::wstring root = NormalizePath(buffer);
  if (root.empty()) return L"";
  if (root.back() != L'\\') root.push_back(L'\\');
  return root;
}

bool StartsWithIgnoreCase(const std::wstring& path, const std::wstring& root) {
  if (path.size() <= root.size()) return false;
  return std::equal(root.begin(), root.end(), path.begin(),
                    [](wchar_t a, wchar_t b) {
                      return std::towlower(a) == std::towlower(b);
                    });
}

// Only regular files the Dart side staged under the temp directory may be
// exported through the channel. Returns the normalised source path, or empty.
std::wstring CachedSourcePath(const std::wstring& path) {
  const std::wstring root = TempRoot();
  if (root.empty()) return L"";
  const std::wstring full = NormalizePath(path);
  if (full.empty() || !StartsWithIgnoreCase(full, root)) return L"";
  const DWORD attrs = ::GetFileAttributesW(full.c_str());
  if (attrs == INVALID_FILE_ATTRIBUTES) return L"";
  if (attrs & (FILE_ATTRIBUTE_DIRECTORY | FILE_ATTRIBUTE_REPARSE_POINT)) {
    return L"";
  }
  return full;
}

// The suggested name comes from attachment metadata. Keep the last path
// component only and replace characters Windows does not allow in file names,
// so the dialog can never be pre-filled with a path outside the folder the
// user is looking at.
std::wstring SafeFileName(const std::wstring& name) {
  const size_t slash = name.find_last_of(L"\\/");
  std::wstring base = slash == std::wstring::npos ? name : name.substr(slash + 1);
  for (wchar_t& c : base) {
    if (c < 0x20 || c == L'<' || c == L'>' || c == L':' || c == L'"' ||
        c == L'|' || c == L'?' || c == L'*') {
      c = L'_';
    }
  }
  while (!base.empty() && (base.back() == L'.' || base.back() == L' ')) {
    base.pop_back();
  }
  if (base.size() > 200) base.resize(200);
  return base.empty() ? L"attachment" : base;
}

std::string StringArgument(const EncodableMap& map, const char* key) {
  const auto it = map.find(EncodableValue(key));
  if (it == map.end()) return "";
  const auto* value = std::get_if<std::string>(&it->second);
  return value ? *value : "";
}

}  // namespace

AresPlatform::AresPlatform(HWND window, flutter::FlutterEngine* engine)
    : window_(window) {
  save_channel_ = std::make_unique<flutter::MethodChannel<EncodableValue>>(
      engine->messenger(), "com.hermesagent.hermes_android/attachment_save",
      &flutter::StandardMethodCodec::GetInstance());
  save_channel_->SetMethodCallHandler(
      [this](const flutter::MethodCall<EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<EncodableValue>> result) {
        if (call.method_name() == "saveFile") {
          HandleSaveFile(call, result.get());
          return;
        }
        result->NotImplemented();
      });
}

AresPlatform::~AresPlatform() {
  // The handler captures |this|; detach it before the object goes away.
  save_channel_->SetMethodCallHandler(nullptr);
}

void AresPlatform::HandleSaveFile(
    const flutter::MethodCall<EncodableValue>& call,
    flutter::MethodResult<EncodableValue>* result) {
  if (busy_) {
    result->Error("busy", "Another save is in progress");
    return;
  }

  const auto* arguments = call.arguments();
  const auto* map =
      arguments ? std::get_if<EncodableMap>(arguments) : nullptr;
  if (!map) {
    result->Error("invalid_source", "Only downloaded cache files can be saved");
    return;
  }
  const std::wstring source =
      CachedSourcePath(ToWide(StringArgument(*map, "path")));
  if (source.empty()) {
    result->Error("invalid_source", "Only downloaded cache files can be saved");
    return;
  }
  const std::wstring suggested =
      SafeFileName(ToWide(StringArgument(*map, "filename")));

  // COM is initialised for this (platform) thread in wWinMain.
  Microsoft::WRL::ComPtr<IFileSaveDialog> dialog;
  HRESULT hr = ::CoCreateInstance(CLSID_FileSaveDialog, nullptr,
                                  CLSCTX_INPROC_SERVER,
                                  IID_PPV_ARGS(dialog.GetAddressOf()));
  if (FAILED(hr) || !dialog) {
    result->Error("unavailable", "The save dialog is not available");
    return;
  }

  FILEOPENDIALOGOPTIONS options = 0;
  if (SUCCEEDED(dialog->GetOptions(&options))) {
    dialog->SetOptions(options | FOS_FORCEFILESYSTEM | FOS_OVERWRITEPROMPT |
                       FOS_PATHMUSTEXIST);
  }
  dialog->SetFileName(suggested.c_str());

  busy_ = true;
  hr = dialog->Show(window_);
  busy_ = false;

  if (hr == HRESULT_FROM_WIN32(ERROR_CANCELLED)) {
    // Cancel is a normal outcome: null destination, same as other platforms.
    result->Success();
    return;
  }
  if (FAILED(hr)) {
    result->Error("unavailable", "The save dialog could not be shown");
    return;
  }

  Microsoft::WRL::ComPtr<IShellItem> selected;
  PWSTR raw_destination = nullptr;
  if (FAILED(dialog->GetResult(selected.GetAddressOf())) || !selected ||
      FAILED(selected->GetDisplayName(SIGDN_FILESYSPATH, &raw_destination)) ||
      !raw_destination) {
    result->Error("write_failed", "The chosen location cannot be written to");
    return;
  }
  const std::wstring destination(raw_destination);
  ::CoTaskMemFree(raw_destination);

  // CopyFileW replaces an existing destination itself (the dialog has already
  // asked the user to confirm the overwrite), and leaves the source in place.
  if (!::CopyFileW(source.c_str(), destination.c_str(), FALSE)) {
    result->Error("write_failed", "The file could not be saved");
    return;
  }
  result->Success(EncodableValue(ToUtf8(destination)));
}
