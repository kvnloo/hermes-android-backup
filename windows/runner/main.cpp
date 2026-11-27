#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

// These rely on types from windows.h and must come after it.
#include <appmodel.h>
#include <shobjidl.h>

#include "flutter_window.h"
#include "utils.h"
#include "toast_identity.h"
#include "launch_role.h"
#include <roapi.h>

namespace {

// True when running with MSIX package identity (Microsoft Store / sideload).
bool HasPackageIdentity() {
  UINT32 length = 0;
  return ::GetCurrentPackageFullName(&length, nullptr) !=
         APPMODEL_ERROR_NO_PACKAGE;
}

}  // namespace

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  auto args = GetCommandLineArguments();
  const bool packaged = HasPackageIdentity();
  const auto role = ares::ClassifyLaunch(args,
      ::GetFileType(::GetStdHandle(STD_INPUT_HANDLE)) == FILE_TYPE_PIPE, packaged);
  if (role == ares::LaunchRole::invalid) return EXIT_FAILURE;
  const bool chat_child = role == ares::LaunchRole::chat;
  const bool quick_entry = role == ares::LaunchRole::quick_entry;
  // The pet companion and quick entry are child processes too: no console,
  // no single-instance mutex, no toast routing, no tray or hotkey, and a
  // window class Home launches never target.
  const bool pet_child =
      chat_child || quick_entry || role == ares::LaunchRole::pet;
  Win32Window::SetChatPopoutProcess(pet_child);
  // Preserve inherited IPC handles. A pop-out must not attach a console.
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!pet_child && !::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  if (FAILED(RoInitialize(RO_INIT_SINGLETHREADED))) return EXIT_FAILURE;
  auto token = role == ares::LaunchRole::toast ? ares::toast::ParseActivation(args.front(), packaged) : "";
  // A hermes:// link goes to the primary window's deep-link channel, never
  // to Dart's entrypoint arguments; Dart validates it before any UI changes.
  std::string link = role == ares::LaunchRole::deep_link
      ? ares::deep_link::Parse(args.front()) : std::string();

  // One Ares instance per user: a second launch focuses the running window
  // and exits instead of opening a second chat session.
  HANDLE single_instance = pet_child ? nullptr :
      ::CreateMutexW(nullptr, TRUE, (ares::toast::WindowClass() + L".mutex").c_str());
  if (!pet_child && !single_instance) { RoUninitialize(); return EXIT_FAILURE; }
  if (!pet_child && ::GetLastError() == ERROR_ALREADY_EXISTS) {
    HWND existing = nullptr;
    // A chat pop-out registers a different Win32 class. Never forward a toast
    // or a second launch to the most recently focused child instead of Home.
    for (int i = 0; i < 100 && !existing; ++i) {
      existing = ::FindWindowW(Win32Window::WindowClassName(), nullptr);
      if (!existing) Sleep(20);
    }
    if (existing) {
      if (!token.empty()) {
        DWORD pid = 0;
        GetWindowThreadProcessId(existing, &pid);
        AllowSetForegroundWindow(pid);
        COPYDATASTRUCT data{0x41524553, static_cast<DWORD>(token.size()), token.data()};
        DWORD_PTR received = 0;
        SendMessageTimeoutW(existing, WM_COPYDATA, 0, reinterpret_cast<LPARAM>(&data),
                            SMTO_ABORTIFHUNG, 2000, &received);
      } else if (!link.empty()) {
        // Same single-instance path as toast tickets: the primary window
        // (found by its own class, never a pop-out) shows itself and passes
        // the link to Dart.
        DWORD pid = 0;
        GetWindowThreadProcessId(existing, &pid);
        AllowSetForegroundWindow(pid);
        COPYDATASTRUCT data{ares::deep_link::kCopyDataId,
                            static_cast<DWORD>(link.size()), link.data()};
        DWORD_PTR received = 0;
        SendMessageTimeoutW(existing, WM_COPYDATA, 0, reinterpret_cast<LPARAM>(&data),
                            SMTO_ABORTIFHUNG, 2000, &received);
      } else if (args.empty()) {
        ::ShowWindow(existing, IsIconic(existing) ? SW_RESTORE : SW_SHOW);
        ::SetForegroundWindow(existing);
      }
    }
    if (single_instance) ::CloseHandle(single_instance);
    RoUninitialize();
    return EXIT_SUCCESS;
  }

  // Group the taskbar button under one app identity. Packaged (Store/MSIX)
  // builds get their identity from the package manifest instead.
  if (!HasPackageIdentity()) {
    ::SetCurrentProcessExplicitAppUserModelID(L"com.hermesagent.ares");
  }

  flutter::DartProject project(L"data");
  // The validated pop-out marker goes to Dart, never an activation URI.
  if (role != ares::LaunchRole::toast && role != ares::LaunchRole::deep_link) {
    project.set_dart_entrypoint_arguments(std::move(args));
  }
  FlutterWindow window(project, std::move(token), !pet_child, std::move(link));
  Win32Window::Point origin(10, 10);
  const wchar_t* title = chat_child    ? L"Ares - Chat"
                         : quick_entry ? L"Ares - Quick entry"
                         : pet_child   ? L"Ares - Companion"
                                       : L"Ares";
  Win32Window::Size size = quick_entry ? Win32Window::Size(640, 220)
                           : pet_child && !chat_child
                               ? Win32Window::Size(360, 520)
                               : Win32Window::Size(1280, 720);
  if (!window.Create(title, origin, size)) {
    return EXIT_FAILURE;
  }
  if (pet_child && !chat_child) {
    HWND companion = window.GetHandle();
    if (companion) {
      ::SetWindowPos(companion, HWND_TOPMOST, 0, 0, 0, 0,
                     SWP_NOMOVE | SWP_NOSIZE);
    }
    if (companion && quick_entry) {
      // Centred on the monitor under the pointer, a fifth of the way down,
      // in physical pixels (works for monitors left of or above the primary).
      POINT cursor{};
      RECT frame{};
      MONITORINFO info{};
      info.cbSize = sizeof(info);
      if (::GetCursorPos(&cursor) && ::GetWindowRect(companion, &frame) &&
          ::GetMonitorInfoW(
              ::MonitorFromPoint(cursor, MONITOR_DEFAULTTONEAREST), &info)) {
        const RECT& work = info.rcWork;
        const LONG width = frame.right - frame.left;
        const LONG x = work.left + (work.right - work.left - width) / 2;
        const LONG y = work.top + (work.bottom - work.top) / 5;
        ::SetWindowPos(companion, HWND_TOPMOST, x, y, 0, 0, SWP_NOSIZE);
      }
    }
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  if (single_instance) {
    ::ReleaseMutex(single_instance);
    ::CloseHandle(single_instance);
  }
  RoUninitialize();
  return EXIT_SUCCESS;
}
