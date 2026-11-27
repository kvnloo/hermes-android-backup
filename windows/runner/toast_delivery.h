#pragma once

namespace ares::toast {
// What Windows reported after it accepted a toast.
enum class Delivery { shown, blocked, unknown };

inline const char* DeliveryName(Delivery delivery) {
  switch (delivery) {
    case Delivery::shown:
      return "shown";
    case Delivery::blocked:
      return "blocked";
    case Delivery::unknown:
      break;
  }
  return "unknown";
}

// Once Windows has a toast, a throw would make the caller forget a toast that
// may be on screen, leaving it without a ticket. Report the notification
// setting instead, and never throw.
template <typename ReadEnabled>
Delivery AfterShow(ReadEnabled read_enabled) noexcept {
  try {
    return read_enabled() ? Delivery::shown : Delivery::blocked;
  } catch (...) {
    return Delivery::unknown;
  }
}
}  // namespace ares::toast
