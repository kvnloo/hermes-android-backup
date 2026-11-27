#ifndef RUNNER_DESKTOP_OS_LOGIC_H_
#define RUNNER_DESKTOP_OS_LOGIC_H_

// Platform-free rules for the Linux desktop integration. No GTK here, so
// this header is unit-tested with clang++ -std=c++17 -Wall -Wextra -Werror
// on any host (tool/native_tests/run.sh).

#include <cstddef>
#include <string>
#include <string_view>

namespace ares::desktop {

// Item ids are Dart-defined action names: lower-case words and hyphens.
inline bool ValidTrayItemId(std::string_view id) {
  if (id.empty() || id.size() > 32) return false;
  for (char c : id) {
    if (!((c >= 'a' && c <= 'z') || c == '-')) return false;
  }
  return true;
}

// Keeps valid UTF-8 only, drops C0/C1 controls and DEL, and keeps at most
// [max_chars] characters. GTK labels require valid UTF-8.
inline std::string CleanLabel(std::string_view text, size_t max_chars) {
  std::string out;
  size_t chars = 0;
  size_t i = 0;
  while (i < text.size() && chars < max_chars) {
    const auto b0 = static_cast<unsigned char>(text[i]);
    size_t len = b0 < 0x80             ? 1
                 : (b0 & 0xE0) == 0xC0 ? 2
                 : (b0 & 0xF0) == 0xE0 ? 3
                 : (b0 & 0xF8) == 0xF0 ? 4
                                       : 0;
    char32_t cp = len == 1   ? b0
                  : len == 2 ? (b0 & 0x1F)
                  : len == 3 ? (b0 & 0x0F)
                             : (b0 & 0x07);
    bool valid = len != 0 && i + len <= text.size();
    for (size_t k = 1; valid && k < len; ++k) {
      const auto b = static_cast<unsigned char>(text[i + k]);
      valid = (b & 0xC0) == 0x80;
      cp = (cp << 6) | (b & 0x3F);
    }
    if (valid && ((len == 2 && cp < 0x80) || (len == 3 && cp < 0x800) ||
                  (len == 4 && cp < 0x10000) || cp > 0x10FFFF ||
                  (cp >= 0xD800 && cp <= 0xDFFF))) {
      valid = false;
    }
    if (!valid) {
      i += 1;  // Drop the stray byte.
      continue;
    }
    if (!(cp < 0x20 || (cp >= 0x7F && cp < 0xA0))) {
      out.append(text.substr(i, len));
      ++chars;
    }
    i += len;
  }
  return out;
}

// True for the arguments of a child window process (pop-out chat, companion
// or quick entry). Children never own a tray icon, hotkey or power watcher.
inline bool IsChildWindowMarker(std::string_view arg) {
  return arg == "--ares-workspace-chat-v1" ||
         arg == "--ares-pet-companion-v1" || arg == "--ares-quick-entry-v1";
}

// True for a hermes: link the runner may hand to Dart's validated router
// (lib/core/services/hermes_deeplink.dart): the scheme in any case, at most
// 16 KiB, no control characters. The runner never interprets the link.
inline bool IsDeepLink(std::string_view arg) {
  constexpr std::string_view scheme = "hermes:";
  if (arg.size() < scheme.size() || arg.size() > 16 * 1024) return false;
  for (std::size_t i = 0; i < scheme.size(); ++i) {
    char c = arg[i];
    if (c >= 'A' && c <= 'Z') c = static_cast<char>(c - 'A' + 'a');
    if (c != scheme[i]) return false;
  }
  for (const char c : arg) {
    const auto byte = static_cast<unsigned char>(c);
    if (byte < 0x20 || byte == 0x7f) return false;
  }
  return true;
}

// The X keysym name (XStringToKeysym) for a shortcuts_store key name, or
// an empty string.
inline std::string X11KeysymName(std::string_view name) {
  if (name.size() == 4 && name.substr(0, 3) == "key" && name[3] >= 'A' &&
      name[3] <= 'Z') {
    return std::string(1, static_cast<char>(name[3] - 'A' + 'a'));
  }
  if (name.size() == 6 && name.substr(0, 5) == "digit" && name[5] >= '0' &&
      name[5] <= '9') {
    return std::string(1, name[5]);
  }
  struct Entry {
    std::string_view name;
    std::string_view keysym;
  };
  static constexpr Entry kTable[] = {
      {"space", "space"},           {"enter", "Return"},
      {"escape", "Escape"},         {"tab", "Tab"},
      {"comma", "comma"},           {"period", "period"},
      {"slash", "slash"},           {"semicolon", "semicolon"},
      {"quoteSingle", "apostrophe"}, {"backslash", "backslash"},
      {"minus", "minus"},           {"equal", "equal"},
      {"bracketLeft", "bracketleft"}, {"bracketRight", "bracketright"},
      {"backquote", "grave"},       {"arrowLeft", "Left"},
      {"arrowRight", "Right"},      {"arrowUp", "Up"},
      {"arrowDown", "Down"},        {"home", "Home"},
      {"end", "End"},               {"pageUp", "Prior"},
      {"pageDown", "Next"},         {"insert", "Insert"},
      {"delete", "Delete"},
  };
  for (const auto& entry : kTable) {
    if (entry.name == name) return std::string(entry.keysym);
  }
  return std::string();
}

// X modifier masks (X.h): the chord's modifiers, and the lock bits a grab
// must also cover so Caps Lock or Num Lock never disable the hotkey.
inline constexpr unsigned kShiftMask = 1u << 0;
inline constexpr unsigned kLockMask = 1u << 1;
inline constexpr unsigned kControlMask = 1u << 2;
inline constexpr unsigned kMod1Mask = 1u << 3;  // Alt
inline constexpr unsigned kMod2Mask = 1u << 4;  // Num Lock
inline constexpr unsigned kMod4Mask = 1u << 6;  // Super

// The grab modifiers for a chord: 0 when it is not allowed (Super belongs
// to the desktop; Ctrl or Alt is required).
inline unsigned X11HotkeyModifiers(bool meta, bool ctrl, bool alt,
                                   bool shift) {
  if (meta || !(ctrl || alt)) return 0;
  return (ctrl ? kControlMask : 0) | (alt ? kMod1Mask : 0) |
         (shift ? kShiftMask : 0);
}

// Whether a KeyPress state matches the grabbed modifiers, ignoring locks.
inline bool X11StateMatches(unsigned state, unsigned modifiers) {
  const unsigned relevant = kShiftMask | kControlMask | kMod1Mask | kMod4Mask;
  return (state & relevant) == modifiers;
}

// The session's lock state, from its two sources of truth: logind's
// Session.LockedHint property and the screensaver's ActiveChanged
// (org.freedesktop.ScreenSaver / org.gnome.ScreenSaver). logind's
// Session.Lock and Unlock signals are only requests (Unlock is sent only for
// `loginctl unlock-session`; swaylock, i3lock and IdleAction=lock unlock
// locally), so they never set the state: the runner re-reads the sources.
class LockTracker {
 public:
  enum class Source { kLockedHint, kScreenSaver };

  // Records one source's state. Returns "lock" or "unlock" when the combined
  // state changed and Dart must hear it, otherwise nullptr.
  const char* Update(Source source, bool active) {
    (source == Source::kLockedHint ? hint_ : saver_) = active;
    const bool locked = hint_ || saver_;
    if (locked == reported_) return nullptr;
    reported_ = locked;
    return locked ? "lock" : "unlock";
  }

  bool Locked() const { return hint_ || saver_; }

 private:
  bool hint_ = false;
  bool saver_ = false;
  bool reported_ = false;
};

}  // namespace ares::desktop

#endif  // RUNNER_DESKTOP_OS_LOGIC_H_
