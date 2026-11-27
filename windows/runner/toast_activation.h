#pragma once

#include <algorithm>
#include <string>
#include <string_view>

namespace ares::toast {
// Separate schemes: installing both builds must not introduce a handler chooser.
inline constexpr char kDirectScheme[] = "ares-notification:";
inline constexpr char kPackageScheme[] = "ares-msix-notification:";
inline constexpr wchar_t kDirectId[] = L"com.hermesagent.ares";
inline constexpr size_t kTokenSize = 32;
inline bool ValidToken(std::string_view token) {
  return token.size() == kTokenSize &&
         std::all_of(token.begin(), token.end(), [](char c) {
           return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f');
         });
}
inline std::string ParseActivation(std::string_view arg, bool packaged) {
  std::string_view prefix = packaged ? kPackageScheme : kDirectScheme;
  if (arg.substr(0, prefix.size()) != prefix) return {};
  auto token = arg.substr(prefix.size());
  return ValidToken(token) ? std::string(token) : std::string();
}
}  // namespace ares::toast
