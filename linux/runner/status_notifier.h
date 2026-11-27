#ifndef RUNNER_STATUS_NOTIFIER_H_
#define RUNNER_STATUS_NOTIFIER_H_

// A tray icon as a StatusNotifierItem (org.kde.StatusNotifierItem) with its
// menu as com.canonical.dbusmenu, over GDBus only: no GTK and no extra
// library. KDE Plasma, GNOME with the AppIndicator extension, Xfce, MATE,
// Cinnamon, Budgie, LXQt and the wlroots bars host these on X11 and on
// Wayland. The runner falls back to GtkStatusIcon (XEmbed) on X11 when no
// StatusNotifierWatcher is on the session bus.
//
// The item owns org.kde.StatusNotifierItem-<pid>-<n>, exports
// /StatusNotifierItem and /MenuBar, and registers with the watcher whenever
// one appears (a shell restart re-registers it). Shown() is true only while
// the watcher accepted the item and reports a registered host.

#include <gio/gio.h>

#include <cstdint>
#include <functional>
#include <string>
#include <vector>

namespace ares::tray {

struct MenuEntry {
  std::string id;     // Dart's action id, reported back on a click.
  std::string label;  // Already cleaned (valid UTF-8, no controls).
  bool has_check = false;
  bool checked = false;
  bool separator_before = false;
};

// One ARGB32 image, pixels in network byte order (A, R, G, B), as the
// IconPixmap property carries it.
struct Pixmap {
  int width = 0;
  int height = 0;
  std::vector<uint8_t> argb;
};

class StatusNotifier {
 public:
  struct Callbacks {
    std::function<void()> activate;                       // Left click.
    std::function<void(const std::string& id)> menu;      // A menu item.
    std::function<void(bool shown)> shown_changed;        // Host state.
  };

  StatusNotifier(GDBusConnection* bus, std::string id, std::string title,
                 std::vector<Pixmap> icon, Callbacks callbacks);
  ~StatusNotifier();

  StatusNotifier(const StatusNotifier&) = delete;
  StatusNotifier& operator=(const StatusNotifier&) = delete;

  void SetTooltip(const std::string& tooltip);
  void SetMenu(std::vector<MenuEntry> entries);

  // True while a StatusNotifierWatcher accepted the item and a host shows
  // it.
  bool Shown() const { return registered_ && host_; }

  // The bus name the item registered under (tests).
  const std::string& bus_name() const { return bus_name_; }

  // Whether a StatusNotifierWatcher owns its name on |bus| right now.
  // Asynchronous; |done| runs on the main context.
  static void QueryWatcher(GDBusConnection* bus, GCancellable* cancellable,
                           std::function<void(bool has_host)> done);

  // D-Bus plumbing (public for the C callbacks).
  void HandleItemCall(const gchar* method, GVariant* parameters,
                      GDBusMethodInvocation* invocation);
  GVariant* ItemProperty(const gchar* name);
  void HandleMenuCall(const gchar* method, GVariant* parameters,
                      GDBusMethodInvocation* invocation);
  GVariant* MenuProperty(const gchar* name);
  void WatcherAppeared();
  void WatcherVanished();
  void Registered(bool ok);
  void HostChanged(bool host);

 private:
  GVariant* Layout(int32_t parent, int32_t depth);
  GVariant* ItemProperties(int32_t id);
  void Register();
  void ReadHost();
  void SetState(bool registered, bool host);
  void EmitItem(const char* signal, GVariant* parameters);

  GDBusConnection* bus_ = nullptr;
  GCancellable* cancellable_ = nullptr;
  std::string id_;
  std::string title_;
  std::string tooltip_;
  std::vector<Pixmap> icon_;
  std::vector<MenuEntry> entries_;
  Callbacks callbacks_;
  std::string bus_name_;
  guint owner_id_ = 0;
  guint watch_id_ = 0;
  guint item_object_ = 0;
  guint menu_object_ = 0;
  guint host_signal_ = 0;
  uint32_t revision_ = 1;
  bool registered_ = false;
  bool host_ = false;
};

}  // namespace ares::tray

#endif  // RUNNER_STATUS_NOTIFIER_H_
