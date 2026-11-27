// Host-side unit tests for windows/runner/desktop_os_logic.h.
// Build and run: tool/native_tests/run.sh

#include "../../windows/runner/desktop_os_logic.h"

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

using ares::desktop::MenuTextFromUtf8;

void TestMenuText() {
  CHECK(MenuTextFromUtf8("Open Ares", 64) == u"Open Ares");
  // Multi-byte and astral characters survive; controls are dropped.
  CHECK(MenuTextFromUtf8("Ares \xE3\x82\x92\xE9\x96\x8B\xE3\x81\x8F", 64) ==
        u"Ares \u3092\u958B\u304F");
  CHECK(MenuTextFromUtf8("a\xF0\x9F\x98\x80" "b", 64) == u"a\U0001F600b");
  CHECK(MenuTextFromUtf8("a\nb\tc\x1b[31m", 64) == u"abc[31m");
  CHECK(MenuTextFromUtf8("a\xC2\x85" "b", 64) == u"ab");  // C1 NEL
  // Invalid, truncated and overlong sequences become U+FFFD.
  CHECK(MenuTextFromUtf8("a\xFF" "b", 64) == u"a\uFFFDb");
  CHECK(MenuTextFromUtf8("a\xE3\x82", 64) == u"a\uFFFD\uFFFD");
  CHECK(MenuTextFromUtf8("\xC0\xAF", 64) == u"\uFFFD\uFFFD");
  CHECK(MenuTextFromUtf8("\xED\xA0\x80", 64) == u"\uFFFD\uFFFD\uFFFD");
  // Length bound in UTF-16 units, never splitting a surrogate pair.
  CHECK(MenuTextFromUtf8("abcdef", 4) == u"abcd");
  CHECK(MenuTextFromUtf8("abc\xF0\x9F\x98\x80", 4) == u"abc");
  CHECK(MenuTextFromUtf8("ab\xF0\x9F\x98\x80" "c", 4) == u"ab\U0001F600");
  CHECK(MenuTextFromUtf8("", 4).empty());
}

void TestTrayItems() {
  using ares::desktop::TrayIndexForCommand;
  using ares::desktop::ValidTrayItemId;
  using ares::desktop::kTrayFirstCommand;
  CHECK(ValidTrayItemId("open"));
  CHECK(ValidTrayItemId("pause-notifications"));
  CHECK(!ValidTrayItemId(""));
  CHECK(!ValidTrayItemId("Open"));
  CHECK(!ValidTrayItemId("open now"));
  CHECK(!ValidTrayItemId("a/b"));
  CHECK(!ValidTrayItemId(std::string(33, 'a')));
  CHECK(!TrayIndexForCommand(0, 5));
  CHECK(!TrayIndexForCommand(kTrayFirstCommand - 1, 5));
  CHECK(TrayIndexForCommand(kTrayFirstCommand, 5) == 0u);
  CHECK(TrayIndexForCommand(kTrayFirstCommand + 4, 5) == 4u);
  CHECK(!TrayIndexForCommand(kTrayFirstCommand + 5, 5));
  CHECK(!TrayIndexForCommand(kTrayFirstCommand, 0));
}

void TestTrayRetryAndForeground() {
  using ares::desktop::TrayRetryDelayMs;
  using ares::desktop::ValidForegroundPid;
  // A short backoff, growing, that gives up after about a minute.
  unsigned total = 0;
  unsigned previous = 0;
  unsigned attempt = 0;
  for (; TrayRetryDelayMs(attempt) != 0; ++attempt) {
    CHECK(TrayRetryDelayMs(attempt) > previous);
    previous = TrayRetryDelayMs(attempt);
    total += previous;
  }
  CHECK(attempt == 6);
  CHECK(TrayRetryDelayMs(0) == 1000);
  CHECK(total == 60000);
  CHECK(TrayRetryDelayMs(100) == 0);
  CHECK(ares::desktop::kTrayRetryTimerId != ares::desktop::kHotkeyId);
  // Only a real child pid; never "any process".
  CHECK(ValidForegroundPid(4242));
  CHECK(!ValidForegroundPid(0));
  CHECK(!ValidForegroundPid(-1));
  CHECK(!ValidForegroundPid(0xFFFFFFFFLL));  // ASFW_ANY
  CHECK(!ValidForegroundPid(0x100000000LL));
}

void TestHotkey() {
  using ares::desktop::HotkeyFor;
  using ares::desktop::VirtualKeyForName;
  CHECK(VirtualKeyForName("keyA") == 0x41u);
  CHECK(VirtualKeyForName("keyZ") == 0x5Au);
  CHECK(VirtualKeyForName("digit0") == 0x30u);
  CHECK(VirtualKeyForName("digit9") == 0x39u);
  CHECK(VirtualKeyForName("space") == 0x20u);
  CHECK(VirtualKeyForName("comma") == 0xBCu);
  CHECK(VirtualKeyForName("backquote") == 0xC0u);
  CHECK(VirtualKeyForName("arrowDown") == 0x28u);
  CHECK(VirtualKeyForName("delete") == 0x2Eu);
  CHECK(!VirtualKeyForName("keya"));
  CHECK(!VirtualKeyForName("key1"));
  CHECK(!VirtualKeyForName("digitA"));
  CHECK(!VirtualKeyForName("f4"));
  CHECK(!VirtualKeyForName(""));

  // Default chord: Ctrl+Shift+Space, never auto-repeating.
  const auto def = HotkeyFor("space", false, true, false, true);
  CHECK(def.has_value());
  CHECK(def && def->vk == 0x20u);
  CHECK(def && def->modifiers == (0x0002u | 0x0004u | 0x4000u));
  const auto alt = HotkeyFor("keyQ", false, false, true, false);
  CHECK(alt && alt->modifiers == (0x0001u | 0x4000u));
  // The Windows key is the shell's; Shift alone is ordinary typing.
  CHECK(!HotkeyFor("space", true, true, false, true));
  CHECK(!HotkeyFor("space", false, false, false, true));
  CHECK(!HotkeyFor("space", false, false, false, false));
  CHECK(!HotkeyFor("f13", false, true, false, false));
}

void TestPower() {
  using ares::desktop::AwakeOwners;
  using ares::desktop::PowerEventName;
  auto name = [](unsigned message, unsigned long long wparam) {
    const char* event = PowerEventName(message, wparam);
    return std::string(event ? event : "");
  };
  CHECK(name(0x0218, 0x0004) == "suspend");
  CHECK(name(0x0218, 0x0007) == "resume");
  CHECK(name(0x0218, 0x0012) == "resume");
  CHECK(name(0x0218, 0x000A).empty());  // PBT_APMPOWERSTATUSCHANGE
  CHECK(name(0x02B1, 0x7) == "lock");
  CHECK(name(0x02B1, 0x8) == "unlock");
  CHECK(name(0x02B1, 0x5).empty());  // WTS_SESSION_LOGON
  CHECK(name(0x0312, 0x7).empty());  // WM_HOTKEY

  AwakeOwners owners;
  CHECK(!owners.Any());
  CHECK(owners.Set("keep-awake-1", true));    // off -> on
  CHECK(!owners.Set("keep-awake-1", true));   // repeat: no change
  CHECK(!owners.Set("keep-awake-2", true));   // still on
  CHECK(!owners.Set("keep-awake-1", false));  // 2 still wants it
  CHECK(owners.Any());
  CHECK(owners.Set("keep-awake-2", false));   // on -> off
  CHECK(!owners.Set("unknown", false));
  CHECK(!owners.Any());
}

}  // namespace

int main() {
  TestMenuText();
  TestTrayItems();
  TestTrayRetryAndForeground();
  TestHotkey();
  TestPower();
  std::printf("windows desktop_os_logic: %d checks, %d failures\n", checks,
              failures);
  return failures == 0 ? 0 : 1;
}
