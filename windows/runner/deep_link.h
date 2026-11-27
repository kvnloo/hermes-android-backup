#pragma once

// hermes:// links on Windows (platform-free so it can be unit-tested on any
// host). The runner never interprets a link: it only decides whether a
// launch argument is one, bounds it, and hands the whole string to Dart's
// validated router (lib/core/services/hermes_deeplink.dart) through the
// PRIMARY window's com.hermesagent.ares/deeplink channel. A second launch
// forwards the link to the running primary window with WM_COPYDATA, the same
// single-instance path the toast tickets use; there is no second activator,
// COM server or window class.

#include <cstddef>
#include <string>
#include <string_view>

namespace ares::deep_link {

// WM_COPYDATA dwData for a forwarded link ('ARLK'; toast tickets use 'ARES').
inline constexpr unsigned long kCopyDataId = 0x41524C4Bul;

// Longest link the runner forwards. Dart caps a prefill at 4,000 characters;
// percent-encoding can triple that.
inline constexpr std::size_t kMaxBytes = 16 * 1024;

// True when |arg| starts with the hermes: scheme (case-insensitive).
inline bool LooksLikeLink(std::string_view arg) {
  constexpr std::string_view scheme = "hermes:";
  if (arg.size() < scheme.size()) return false;
  for (std::size_t i = 0; i < scheme.size(); ++i) {
    char c = arg[i];
    if (c >= 'A' && c <= 'Z') c = static_cast<char>(c - 'A' + 'a');
    if (c != scheme[i]) return false;
  }
  return true;
}

// The whole argument when it is a forwardable link, otherwise empty: a
// hermes: URI of at most kMaxBytes without control characters.
inline std::string Parse(std::string_view arg) {
  if (!LooksLikeLink(arg) || arg.size() > kMaxBytes) return {};
  for (const char c : arg) {
    const auto byte = static_cast<unsigned char>(c);
    if (byte < 0x20 || byte == 0x7f) return {};
  }
  return std::string(arg);
}

}  // namespace ares::deep_link
