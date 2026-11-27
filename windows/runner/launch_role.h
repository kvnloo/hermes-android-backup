#pragma once

#include <string>
#include <vector>
#include "deep_link.h"
#include "toast_activation.h"

namespace ares {
// deep_link: the sole argument is a hermes:// link (shell or browser open).
enum class LaunchRole { primary, chat, pet, quick_entry, toast, deep_link, invalid };

inline constexpr char kChatPopoutMarker[] = "--ares-workspace-chat-v1";
inline constexpr char kPetCompanionMarker[] = "--ares-pet-companion-v1";
// The quick-entry window: a child like a pop-out, never an activator.
inline constexpr char kQuickEntryMarker[] = "--ares-quick-entry-v1";

inline LaunchRole ClassifyLaunch(const std::vector<std::string>& args,
                                 bool pipe_input, bool packaged) {
  if (args.empty()) return LaunchRole::primary;
  if (args.front() == kChatPopoutMarker) {
    return args.size() == 1 && pipe_input ? LaunchRole::chat : LaunchRole::invalid;
  }
  if (args.front() == kPetCompanionMarker) {
    return args.size() == 1 && pipe_input ? LaunchRole::pet : LaunchRole::invalid;
  }
  if (args.front() == kQuickEntryMarker) {
    return args.size() == 1 && pipe_input ? LaunchRole::quick_entry
                                          : LaunchRole::invalid;
  }
  if (args.front().rfind("ares-", 0) == 0) {
    return args.size() == 1 && !toast::ParseActivation(args.front(), packaged).empty()
        ? LaunchRole::toast : LaunchRole::invalid;
  }
  if (deep_link::LooksLikeLink(args.front())) {
    return args.size() == 1 && !deep_link::Parse(args.front()).empty()
        ? LaunchRole::deep_link : LaunchRole::invalid;
  }
  for (const auto& arg : args) {
    if (arg == kChatPopoutMarker || arg == kPetCompanionMarker ||
        arg == kQuickEntryMarker || arg.rfind("ares-", 0) == 0 ||
        deep_link::LooksLikeLink(arg)) {
      return LaunchRole::invalid;  // Reserved arguments cannot be mixed with others.
    }
  }
  return LaunchRole::primary;
}
}  // namespace ares
