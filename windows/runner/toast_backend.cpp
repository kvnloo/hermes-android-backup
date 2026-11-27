#include "toast_backend.h"
#include "toast_identity.h"
#include <shlwapi.h>
#include <winrt/Windows.Data.Xml.Dom.h>
#include <winrt/Windows.UI.Notifications.h>

namespace ares::toast {
using namespace winrt;
using namespace Windows::Data::Xml::Dom;
using namespace Windows::UI::Notifications;
namespace {
constexpr wchar_t kGroup[] = L"AresTurns";

// Portable copies do not own the Inno installation's protocol handler. Never
// post from one under someone else's AUMID, even if both builds are present.
bool OwnsProtocol() {
  if (!Family().empty()) return true;
  wchar_t handler[32768], exe[32768];
  DWORD count = ARRAYSIZE(handler);
  return SUCCEEDED(AssocQueryStringW(ASSOCF_IS_PROTOCOL, ASSOCSTR_EXECUTABLE,
      L"ares-notification", L"open", handler, &count)) &&
      GetModuleFileNameW(nullptr, exe, ARRAYSIZE(exe)) &&
      _wcsicmp(handler, exe) == 0;
}
ToastNotifier Notifier() {
  if (!OwnsProtocol()) throw hresult_error(E_ACCESSDENIED);
  return Family().empty() ? ToastNotificationManager::CreateToastNotifier(kDirectId)
                          : ToastNotificationManager::CreateToastNotifier();
}
// A newly registered desktop sender has no WPN settings row until its first
// Show. Only that specific absence is an eligible first submission. The OS
// still enforces user/policy settings; other failures are never a grant.
bool AllowsSubmission(const ToastNotifier& notifier) {
  try { return notifier.Setting() == NotificationSetting::Enabled; }
  catch (const hresult_error& error) {
    if (error.code() == HRESULT_FROM_WIN32(ERROR_NOT_FOUND)) return true;
    throw;
  }
}
}
bool Enabled() { return OwnsProtocol() && AllowsSubmission(Notifier()); }
Delivery Show(int id, const std::string& token, const std::string& body,
              const std::string& sound, bool suppress_popup) {
  if (!ValidToken(token)) throw hresult_invalid_argument();
  auto notifier = Notifier();
  if (!AllowsSubmission(notifier)) throw hresult_access_denied();
  XmlDocument doc;
  doc.LoadXml(L"<toast activationType='protocol'><visual><binding template='ToastGeneric'><text>Ares</text><text/></binding></visual><audio/></toast>");
  auto root = doc.DocumentElement();
  const bool packaged = !Family().empty();
  root.SetAttribute(L"launch", to_hstring((packaged ? kPackageScheme : kDirectScheme) + token));
  if (packaged) root.SetAttribute(L"protocolActivationTargetApplicationPfn", Family());
  doc.GetElementsByTagName(L"text").Item(1).AppendChild(doc.CreateTextNode(to_hstring(body)));
  auto audio = doc.GetElementsByTagName(L"audio").Item(0).as<XmlElement>();
  if (sound == "silent") audio.SetAttribute(L"silent", L"true");
  if (sound == "mail") audio.SetAttribute(L"src", L"ms-winsoundevent:Notification.Mail");
  if (sound == "reminder") audio.SetAttribute(L"src", L"ms-winsoundevent:Notification.Reminder");
  ToastNotification toast(doc);
  toast.Group(kGroup);
  toast.Tag(to_hstring(id));
  toast.SuppressPopup(suppress_popup);
  notifier.Show(toast);
  // Now that the sender exists, report the actual policy, not optimistic
  // success. The caller withdraws a toast Windows will not display.
  return AfterShow([&notifier] {
    return notifier.Setting() == NotificationSetting::Enabled;
  });
}
void Cancel(int id) {
  if (!OwnsProtocol()) return;
  auto history = ToastNotificationManager::History();
  if (Family().empty()) history.Remove(to_hstring(id), kGroup, kDirectId);
  else history.Remove(to_hstring(id), kGroup);
}
void CancelAll() {
  if (!OwnsProtocol()) return;
  auto history = ToastNotificationManager::History();
  if (Family().empty()) history.RemoveGroup(kGroup, kDirectId);
  else history.RemoveGroup(kGroup);
}
}  // namespace ares::toast
