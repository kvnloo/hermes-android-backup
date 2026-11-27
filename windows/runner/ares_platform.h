#ifndef RUNNER_ARES_PLATFORM_H_
#define RUNNER_ARES_PLATFORM_H_

#include <windows.h>

#include <flutter/encodable_value.h>
#include <flutter/method_call.h>
#include <flutter/method_channel.h>
#include <flutter/method_result.h>

#include <memory>

namespace flutter {
class FlutterEngine;
}

// Windows half of Ares's platform channels.
//
// Registered channels:
//   com.hermesagent.hermes_android/attachment_save  (saveFile)
//
// PDF previews and voice-draft duration/join are implemented in Dart on
// Windows (pdfx / ffmpeg); this class owns the save dialog only, which copies
// an app-cached download to a user-chosen destination without loading it into
// memory.
class AresPlatform {
 public:
  AresPlatform(HWND window, flutter::FlutterEngine* engine);
  ~AresPlatform();

  AresPlatform(const AresPlatform&) = delete;
  AresPlatform& operator=(const AresPlatform&) = delete;

 private:
  void HandleSaveFile(const flutter::MethodCall<flutter::EncodableValue>& call,
                      flutter::MethodResult<flutter::EncodableValue>* result);

  HWND window_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
      save_channel_;
  // The save dialog runs a nested message loop, so a second saveFile call can
  // arrive while one is open. Saves are single-flight (mirrors the Apple
  // implementation).
  bool busy_ = false;
};

#endif  // RUNNER_ARES_PLATFORM_H_
