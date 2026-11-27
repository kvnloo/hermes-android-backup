#include "../runner/launch_role.h"
#include <cassert>

int main() {
  using ares::ClassifyLaunch;
  using ares::LaunchRole;
  const std::string marker = "--ares-workspace-chat-v1";
  const std::string pet = "--ares-pet-companion-v1";
  const std::string ticket = "0123456789abcdef0123456789abcdef";
  for (bool packaged : {false, true}) {
    const std::string uri = (packaged ? ares::toast::kPackageScheme : ares::toast::kDirectScheme) + ticket;
    assert(ClassifyLaunch({marker}, true, packaged) == LaunchRole::chat);
    assert(ClassifyLaunch({marker}, false, packaged) == LaunchRole::invalid);
    assert(ClassifyLaunch({pet}, true, packaged) == LaunchRole::pet);
    assert(ClassifyLaunch({pet}, false, packaged) == LaunchRole::invalid);
    for (bool piped : {false, true}) {
      assert(ClassifyLaunch({}, piped, packaged) == LaunchRole::primary);
      assert(ClassifyLaunch({uri}, piped, packaged) == LaunchRole::toast);
      assert(ClassifyLaunch({uri}, piped, !packaged) == LaunchRole::invalid);
      assert(ClassifyLaunch({marker, uri}, piped, packaged) == LaunchRole::invalid);
      assert(ClassifyLaunch({uri, marker}, piped, packaged) == LaunchRole::invalid);
      assert(ClassifyLaunch({"other", marker}, piped, packaged) == LaunchRole::invalid);
      assert(ClassifyLaunch({"other", uri}, piped, packaged) == LaunchRole::invalid);
      assert(ClassifyLaunch({uri + "?x"}, piped, packaged) == LaunchRole::invalid);
      assert(ClassifyLaunch({pet, marker}, piped, packaged) == LaunchRole::invalid);
      assert(ClassifyLaunch({marker, pet}, piped, packaged) == LaunchRole::invalid);
      assert(ClassifyLaunch({"other", pet}, piped, packaged) == LaunchRole::invalid);
      assert(ClassifyLaunch({pet, uri}, piped, packaged) == LaunchRole::invalid);
    }
  }
}
