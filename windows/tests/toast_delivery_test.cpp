#include "../runner/toast_delivery.h"
#include <cassert>
#include <cstring>
#include <stdexcept>
using namespace ares::toast;
int main() {
  assert(AfterShow([] { return true; }) == Delivery::shown);
  assert(AfterShow([] { return false; }) == Delivery::blocked);
  // A setting read that fails once Windows has the toast is reported, never
  // thrown, so the caller keeps or withdraws the toast instead of losing it.
  assert(AfterShow([]() -> bool {
           throw std::runtime_error("ERROR_NOT_FOUND");
         }) == Delivery::unknown);
  assert(AfterShow([]() -> bool { throw 0x80070005u; }) == Delivery::unknown);
  auto read = []() -> bool { throw std::logic_error("setting"); };
  static_assert(noexcept(AfterShow(read)), "never throws");
  assert(AfterShow(read) == Delivery::unknown);
  assert(std::strcmp(DeliveryName(Delivery::shown), "shown") == 0);
  assert(std::strcmp(DeliveryName(Delivery::blocked), "blocked") == 0);
  assert(std::strcmp(DeliveryName(Delivery::unknown), "unknown") == 0);
}
