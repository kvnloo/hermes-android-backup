#ifndef RUNNER_FLUTTER_WINDOW_H_
#define RUNNER_FLUTTER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/encodable_value.h>
#include <flutter/flutter_view_controller.h>
#include <flutter/method_channel.h>

#include <memory>
#include <string>

#include "ares_platform.h"
#include "desktop_os.h"
#include "toast_channel.h"
#include "win32_window.h"

// A window that does nothing but host a Flutter view.
class FlutterWindow : public Win32Window {
 public:
  // Creates a new FlutterWindow hosting a Flutter view running |project|.
  // |initial_link| is a hermes:// link from this launch's command line
  // (deep_link.h), delivered once to Dart through getInitialLink.
  FlutterWindow(const flutter::DartProject& project, std::string initial_toast,
                bool accepts_toasts, std::string initial_link = {});
  virtual ~FlutterWindow();

 protected:
  // Win32Window:
  bool OnCreate() override;
  void OnDestroy() override;
  LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept override;

 private:
  // The project to run.
  flutter::DartProject project_;

  // The Flutter instance hosted by this window.
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;

  // Ares platform channels (attachment save dialog).
  std::unique_ptr<AresPlatform> platform_;
  std::string initial_toast_;
  const bool accepts_toasts_;
  std::unique_ptr<ToastChannel> toasts_;
  // Tray, hotkey, power and capture: primary window only.
  std::unique_ptr<DesktopOs> desktop_;
  // com.hermesagent.ares/deeplink: primary window only. A link that arrives
  // before Dart asked for the initial one waits here (the latest wins).
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> deep_links_;
  std::string pending_link_;
  bool links_ready_ = false;

  // Shows the primary window and hands |link| to Dart (or keeps it pending).
  void DeliverLink(std::string link);
};

#endif  // RUNNER_FLUTTER_WINDOW_H_
