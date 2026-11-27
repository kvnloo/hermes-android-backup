// Host-side unit tests for linux/runner/desktop_os_logic.h.
// Build and run: tool/native_tests/run.sh

#include "../../linux/runner/desktop_os_logic.h"

#include <cstdio>
#include <string>

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

using ares::desktop::CleanLabel;

void TestLabels() {
  CHECK(CleanLabel("Open Ares", 64) == "Open Ares");
  CHECK(CleanLabel("\xD0\x9D\xD0\xBE\xD0\xB2\xD1\x8B\xD0\xB9", 64) ==
        "\xD0\x9D\xD0\xBE\xD0\xB2\xD1\x8B\xD0\xB9");  // Новый
  CHECK(CleanLabel("a\nb\x1b[0m\x7f", 64) == "ab[0m");
  CHECK(CleanLabel("a\xC2\x9B" "b", 64) == "ab");  // C1 CSI
  CHECK(CleanLabel("a\xFF\xFE" "b", 64) == "ab");
  CHECK(CleanLabel("a\xE3\x82", 64) == "a");
  CHECK(CleanLabel("\xC0\xAF", 64).empty());          // overlong
  CHECK(CleanLabel("\xED\xA0\x80", 64).empty());      // surrogate
  CHECK(CleanLabel("abcdef", 3) == "abc");
  // Bounded by characters, never splitting a multi-byte sequence.
  CHECK(CleanLabel("\xE6\x96\xB0\xE8\x81\x8A\xE5\xA4\xA9", 2) ==
        "\xE6\x96\xB0\xE8\x81\x8A");
  CHECK(CleanLabel("a\xF0\x9F\x98\x80" "b", 2) == "a\xF0\x9F\x98\x80");
}

void TestIds() {
  using ares::desktop::IsChildWindowMarker;
  using ares::desktop::ValidTrayItemId;
  CHECK(ValidTrayItemId("quick-entry"));
  CHECK(!ValidTrayItemId("quick_entry"));
  CHECK(!ValidTrayItemId(""));
  CHECK(!ValidTrayItemId(std::string(33, 'q')));
  CHECK(IsChildWindowMarker("--ares-workspace-chat-v1"));
  CHECK(IsChildWindowMarker("--ares-pet-companion-v1"));
  CHECK(IsChildWindowMarker("--ares-quick-entry-v1"));
  CHECK(!IsChildWindowMarker("--ares-quick-entry-v2"));
  CHECK(!IsChildWindowMarker("hermes://launch"));
}

void TestHotkey() {
  using namespace ares::desktop;
  CHECK(X11KeysymName("keyA") == "a");
  CHECK(X11KeysymName("keyZ") == "z");
  CHECK(X11KeysymName("digit7") == "7");
  CHECK(X11KeysymName("space") == "space");
  CHECK(X11KeysymName("quoteSingle") == "apostrophe");
  CHECK(X11KeysymName("pageDown") == "Next");
  CHECK(X11KeysymName("enter") == "Return");
  CHECK(X11KeysymName("keya").empty());
  CHECK(X11KeysymName("f1").empty());
  CHECK(X11KeysymName("").empty());

  CHECK(X11HotkeyModifiers(false, true, false, true) ==
        (kControlMask | kShiftMask));
  CHECK(X11HotkeyModifiers(false, false, true, false) == kMod1Mask);
  CHECK(X11HotkeyModifiers(true, true, false, false) == 0u);   // Super
  CHECK(X11HotkeyModifiers(false, false, false, true) == 0u);  // Shift only

  const unsigned mods = kControlMask | kShiftMask;
  CHECK(X11StateMatches(mods, mods));
  CHECK(X11StateMatches(mods | kLockMask, mods));              // Caps Lock
  CHECK(X11StateMatches(mods | kMod2Mask, mods));              // Num Lock
  CHECK(!X11StateMatches(mods | kMod1Mask, mods));             // extra Alt
  CHECK(!X11StateMatches(mods | kMod4Mask, mods));             // extra Super
  CHECK(!X11StateMatches(kControlMask, mods));
}

void TestDeepLinks() {
  using ares::desktop::IsDeepLink;
  CHECK(IsDeepLink("hermes://session/abc"));
  CHECK(IsDeepLink("HERMES://open/chat?prefill=a%20b"));
  CHECK(IsDeepLink("hermes:launch"));
  CHECK(!IsDeepLink("hermes"));
  CHECK(!IsDeepLink("hermesx://launch"));
  CHECK(!IsDeepLink("https://example.com"));
  CHECK(!IsDeepLink("--ares-quick-entry-v1"));
  CHECK(!IsDeepLink(std::string("hermes://open") + '\n'));
  CHECK(!IsDeepLink(std::string("hermes://open") + '\x7f'));
  CHECK(!IsDeepLink("hermes://open?prefill=" + std::string(16 * 1024, 'a')));
}

void TestLockTracker() {
  using ares::desktop::LockTracker;
  using Source = LockTracker::Source;
  auto same = [](const char* a, const char* b) {
    return (a == nullptr && b == nullptr) ||
           (a != nullptr && b != nullptr && std::string(a) == b);
  };
  LockTracker tracker;
  CHECK(!tracker.Locked());
  // Nothing to report while every source says unlocked.
  CHECK(same(tracker.Update(Source::kLockedHint, false), nullptr));
  CHECK(same(tracker.Update(Source::kScreenSaver, false), nullptr));
  // LockedHint is the state: lock, then a local unlock clears it.
  CHECK(same(tracker.Update(Source::kLockedHint, true), "lock"));
  CHECK(tracker.Locked());
  CHECK(same(tracker.Update(Source::kLockedHint, true), nullptr));
  CHECK(same(tracker.Update(Source::kLockedHint, false), "unlock"));
  CHECK(!tracker.Locked());
  // Either source locks; the session is unlocked only when both clear.
  CHECK(same(tracker.Update(Source::kScreenSaver, true), "lock"));
  CHECK(same(tracker.Update(Source::kLockedHint, true), nullptr));
  CHECK(same(tracker.Update(Source::kScreenSaver, false), nullptr));
  CHECK(tracker.Locked());
  CHECK(same(tracker.Update(Source::kLockedHint, false), "unlock"));
  // A screensaver that blanks and wakes again pauses and resumes.
  CHECK(same(tracker.Update(Source::kScreenSaver, true), "lock"));
  CHECK(same(tracker.Update(Source::kScreenSaver, false), "unlock"));
  CHECK(!tracker.Locked());
}

}  // namespace

int main() {
  TestLockTracker();
  TestDeepLinks();
  TestLabels();
  TestIds();
  TestHotkey();
  std::printf("linux desktop_os_logic: %d checks, %d failures\n", checks,
              failures);
  return failures == 0 ? 0 : 1;
}
