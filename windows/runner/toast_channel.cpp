#include "toast_channel.h"
#include "toast_activation.h"
#include "toast_backend.h"
#include <winrt/base.h>

using Value = flutter::EncodableValue;
using Map = flutter::EncodableMap;

ToastChannel::ToastChannel(flutter::FlutterEngine* engine, std::string initial, HWND window)
    : channel_(engine->messenger(), "ares/windows_toast", &flutter::StandardMethodCodec::GetInstance()),
      pending_(std::move(initial)) {
  channel_.SetMethodCallHandler([this, window](const auto& call, auto result) {
    try {
      const auto& method = call.method_name();
      if (method == "listen") {
        listening_ = true;
        result->Success(Value(std::exchange(pending_, {})));
      } else if (method == "permission") {
        result->Success(Value(ares::toast::Enabled()));
      } else if (method == "focus") {
        ShowWindow(window, IsIconic(window) ? SW_RESTORE : SW_SHOW);
        SetForegroundWindow(window);
        result->Success();
      } else if (method == "show") {
        auto& args = std::get<Map>(*call.arguments());
        const auto delivery = ares::toast::Show(std::get<int>(args.at(Value("id"))),
          std::get<std::string>(args.at(Value("ticket"))), std::get<std::string>(args.at(Value("body"))),
          std::get<std::string>(args.at(Value("sound"))), std::get<bool>(args.at(Value("quiet"))));
        result->Success(Value(std::string(ares::toast::DeliveryName(delivery))));
      } else if (method == "cancel") {
        ares::toast::Cancel(std::get<int>(*call.arguments()));
        result->Success();
      } else if (method == "cancelAll") {
        ares::toast::CancelAll();
        result->Success();
      } else { result->NotImplemented(); }
    } catch (const winrt::hresult_error& error) {
      // Never echo a ticket, toast text, credentials or incoming payload.
      result->Error("windows_toast", "Windows notification error " + std::to_string(error.code().value));
    } catch (...) { result->Error("windows_toast", "Invalid notification request"); }
  });
}
void ToastChannel::Activate(std::string token) {
  if (!ares::toast::ValidToken(token)) return;
  if (!listening_) pending_ = std::move(token);
  else channel_.InvokeMethod("activate", std::make_unique<Value>(std::move(token)));
}
