#ifndef RUNNER_DESKTOP_OS_H_
#define RUNNER_DESKTOP_OS_H_

#include <windows.h>

#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>

#include <memory>
#include <optional>
#include <string>
#include <vector>

#include "desktop_os_logic.h"

namespace flutter {
class FlutterEngine;
}

// The primary window's desktop integration (docs/desktop-os-native.md):
//
//   com.hermesagent.ares/shell   setTray, showWindow, quit, isTraySupported,
//                                allowForeground; onTrayAction, onTrayStatus
//   com.hermesagent.ares/hotkey  register, unregister; onHotKey
//   com.hermesagent.ares/power   isSupported, setAwake; onPowerEvent
//   com.hermesagent.ares/capture status, capture (Windows Graphics Capture)
//
// Created only for the primary window. Pop-out, companion and quick-entry
// children never construct it, so they own no tray icon. Activation stays
// primary-only: this adds no activator, COM server or second instance path.
class DesktopOs {
 public:
  DesktopOs(HWND window, flutter::FlutterEngine* engine);
  ~DesktopOs();

  DesktopOs(const DesktopOs&) = delete;
  DesktopOs& operator=(const DesktopOs&) = delete;

  // Window messages the integration owns (tray callbacks, close-to-tray).
  std::optional<LRESULT> HandleMessage(HWND window, UINT message, WPARAM wparam,
                                       LPARAM lparam);

 private:
  using Result = std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>;

  void HandleShell(const flutter::MethodCall<flutter::EncodableValue>& call,
                   Result result);
  void HandleHotkey(const flutter::MethodCall<flutter::EncodableValue>& call,
                    Result result);
  void UnregisterHotkey();
  void HandlePower(const flutter::MethodCall<flutter::EncodableValue>& call,
                   Result result);
  void HandleCapture(const flutter::MethodCall<flutter::EncodableValue>& call,
                     Result result);
  void FinishCapture(const std::string& path, const std::string& error);
  bool InstallTray();
  void RemoveTray();
  // A wanted icon that NIM_ADD could not install (Explorer not ready at
  // sign-in): retried on a backoff timer and on TaskbarCreated.
  void ScheduleTrayRetry();
  void StopTrayRetry();
  void RetryTray();
  void ReportTrayStatus();
  void ShowMenu(int x, int y);
  void ShowMain();

  HWND window_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> shell_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> hotkey_;
  bool hotkey_registered_ = false;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> power_;
  ares::desktop::AwakeOwners awake_;
  bool session_notifications_ = false;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> capture_;
  // The capture in progress: its pending result and target folder.
  Result capture_result_;
  std::wstring capture_directory_;

  bool tray_installed_ = false;
  // Dart asked for the icon (setTray enabled), installed or not yet.
  bool tray_wanted_ = false;
  // The shown state Dart last heard (setTray's answer or onTrayStatus).
  bool tray_reported_ = false;
  unsigned tray_retry_attempt_ = 0;
  bool tray_retry_pending_ = false;
  // Close-to-tray as Dart asked; it applies only while tray_installed_.
  bool close_to_tray_ = false;
  bool menu_open_ = false;
  std::u16string tooltip_;
  std::vector<ares::desktop::TrayItem> items_;
  HICON tray_icon_ = nullptr;
  UINT taskbar_created_ = 0;
};

#endif  // RUNNER_DESKTOP_OS_H_
