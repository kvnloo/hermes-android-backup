#pragma once
#include <flutter/flutter_engine.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

class ToastChannel {
 public:
  ToastChannel(flutter::FlutterEngine* engine, std::string initial, HWND window);
  void Activate(std::string token);
 private:
  flutter::MethodChannel<flutter::EncodableValue> channel_;
  std::string pending_;
  bool listening_ = false;
};
