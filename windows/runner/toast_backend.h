#pragma once
#include <string>

#include "toast_delivery.h"

namespace ares::toast {
// Caller must initialise an STA. WinRT failures before Windows accepts the
// toast are propagated to the channel; Show never throws after that point.
bool Enabled();
Delivery Show(int id, const std::string& token, const std::string& body,
              const std::string& sound, bool suppress_popup);
void Cancel(int id);
void CancelAll();
}  // namespace ares::toast
