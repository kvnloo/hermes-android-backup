// Host-side unit tests for windows/runner/launch_role.h: the quick-entry
// window is a child role like a pop-out, never an activation path.
// Build and run: tool/native_tests/run.sh

#include "../../windows/runner/launch_role.h"

#include <cstdio>
#include <string>
#include <vector>

namespace {
int failures = 0;
int checks = 0;

void Check(bool ok, const char* what, int line) {
  ++checks;
  if (!ok) {
    ++failures;
    std::fprintf(stderr, "FAIL line %d: %s\n", line, what);
  }
}
#define CHECK(expr) Check((expr), #expr, __LINE__)

using ares::ClassifyLaunch;
using ares::LaunchRole;
using Args = std::vector<std::string>;

void TestQuickEntryRole() {
  const std::string token(32, 'a');
  CHECK(ClassifyLaunch({}, false, false) == LaunchRole::primary);
  // Only with a parent pipe on stdin, and only alone.
  CHECK(ClassifyLaunch(Args{"--ares-quick-entry-v1"}, true, false) ==
        LaunchRole::quick_entry);
  CHECK(ClassifyLaunch(Args{"--ares-quick-entry-v1"}, true, true) ==
        LaunchRole::quick_entry);
  CHECK(ClassifyLaunch(Args{"--ares-quick-entry-v1"}, false, false) ==
        LaunchRole::invalid);
  CHECK(ClassifyLaunch(Args{"--ares-quick-entry-v1", "x"}, true, false) ==
        LaunchRole::invalid);
  CHECK(ClassifyLaunch(Args{"x", "--ares-quick-entry-v1"}, true, false) ==
        LaunchRole::invalid);
  CHECK(ClassifyLaunch(Args{"--ares-quick-entry-v2"}, true, false) ==
        LaunchRole::primary);
  // Existing roles are unchanged.
  CHECK(ClassifyLaunch(Args{"--ares-workspace-chat-v1"}, true, false) ==
        LaunchRole::chat);
  CHECK(ClassifyLaunch(Args{"--ares-pet-companion-v1"}, true, false) ==
        LaunchRole::pet);
  CHECK(ClassifyLaunch(Args{"ares-notification:" + token}, false, false) ==
        LaunchRole::toast);
  CHECK(ClassifyLaunch(Args{"ares-notification:" + token,
                            "--ares-quick-entry-v1"},
                       true, false) == LaunchRole::invalid);
}

void TestDeepLinkRole() {
  const std::string token(32, 'a');
  // The sole argument, any case of the scheme.
  CHECK(ClassifyLaunch(Args{"hermes://session/abc"}, false, false) ==
        LaunchRole::deep_link);
  CHECK(ClassifyLaunch(Args{"HERMES://open/chat?prefill=hi"}, false, true) ==
        LaunchRole::deep_link);
  CHECK(ClassifyLaunch(Args{"hermes:launch"}, false, false) ==
        LaunchRole::deep_link);
  // Never mixed with anything else, in either position.
  CHECK(ClassifyLaunch(Args{"hermes://launch", "x"}, false, false) ==
        LaunchRole::invalid);
  CHECK(ClassifyLaunch(Args{"x", "hermes://launch"}, false, false) ==
        LaunchRole::invalid);
  CHECK(ClassifyLaunch(Args{"--ares-quick-entry-v1", "hermes://launch"}, true,
                       false) == LaunchRole::invalid);
  CHECK(ClassifyLaunch(Args{"ares-notification:" + token, "hermes://launch"},
                       false, false) == LaunchRole::invalid);
  // Control characters or an oversized argument are refused outright.
  CHECK(ClassifyLaunch(Args{std::string("hermes://open%0Ax")}, false,
                       false) == LaunchRole::deep_link);  // encoded is text
  CHECK(ClassifyLaunch(Args{std::string("hermes://open") + '\n'}, false,
                       false) == LaunchRole::invalid);
  CHECK(ClassifyLaunch(Args{std::string("hermes://open") + '\x7f'}, false,
                       false) == LaunchRole::invalid);
  CHECK(ClassifyLaunch(
            Args{"hermes://open/chat?prefill=" +
                 std::string(ares::deep_link::kMaxBytes, 'a')},
            false, false) == LaunchRole::invalid);
  // Other schemes are not links (and stay ordinary arguments).
  CHECK(ClassifyLaunch(Args{"hermesx://launch"}, false, false) ==
        LaunchRole::primary);
  CHECK(ClassifyLaunch(Args{"https://example.com"}, false, false) ==
        LaunchRole::primary);
  // Parse returns the whole link unchanged; the runner never interprets it.
  CHECK(ares::deep_link::Parse("hermes://session/abc?prefill=a%20b") ==
        "hermes://session/abc?prefill=a%20b");
  CHECK(ares::deep_link::Parse("hermes").empty());
  CHECK(ares::deep_link::kCopyDataId != 0x41524553ul);  // not the toast id
}

}  // namespace

int main() {
  TestQuickEntryRole();
  TestDeepLinkRole();
  std::printf("windows launch_role: %d checks, %d failures\n", checks,
              failures);
  return failures == 0 ? 0 : 1;
}
