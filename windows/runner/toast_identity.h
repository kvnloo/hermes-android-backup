#pragma once
#include <windows.h>
#include <appmodel.h>
#include <string>

#include "toast_activation.h"

namespace ares::toast {
inline std::wstring PackageValue(LONG (WINAPI* query)(UINT32*, PWSTR)) {
  UINT32 length = 0;
  if (query(&length, nullptr) != ERROR_INSUFFICIENT_BUFFER || !length) return {};
  std::wstring value(length, L'\0');
  if (query(&length, value.data()) != ERROR_SUCCESS) return {};
  value.resize(length - 1);
  return value;
}
inline const std::wstring& Family() {
  static const auto family = PackageValue(GetCurrentPackageFamilyName);
  return family;
}
inline const std::wstring& WindowClass() {
  static const auto name = L"Ares.Notification.Window." +
      (Family().empty() ? std::wstring(kDirectId) : Family());
  return name;
}
}  // namespace ares::toast
