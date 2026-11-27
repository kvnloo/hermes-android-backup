#include "../runner/toast_activation.h"
#include <cassert>
using namespace ares::toast;
int main() {
  const std::string token = "0123456789abcdef0123456789abcdef";
  assert(ValidToken(token));
  for (bool packaged : {false, true}) {
    const auto uri = (packaged ? kPackageScheme : kDirectScheme) + token;
    assert(ParseActivation(uri, packaged) == token);
    assert(ParseActivation(uri, !packaged).empty());
    assert(ParseActivation(uri.substr(0, uri.size() - 1), packaged).empty());
    assert(ParseActivation(uri + "?approve=1", packaged).empty());
    assert(ParseActivation(uri + std::string(1, '\0'), packaged).empty());
    assert(ParseActivation("approve", packaged).empty());
    assert(ParseActivation("ares-notification://chat/target", packaged).empty());
  }
}
