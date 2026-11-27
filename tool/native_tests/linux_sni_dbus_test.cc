// Runtime test for linux/runner/status_notifier.cc on a private session bus:
// a fake StatusNotifierWatcher and a host-side client exercise the item and
// its dbusmenu exactly as a desktop shell would. Needs GIO and dbus-daemon,
// no display. Run with tool/native_tests/linux_sni_check.sh (container), or
// on a Linux host: dbus-run-session -- ./linux_sni_dbus_test
#include "../../linux/runner/status_notifier.h"

#include <gio/gio.h>

#include <cstdio>
#include <functional>
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

bool SpinUntil(const std::function<bool()>& done, int ms = 5000) {
  const gint64 deadline = g_get_monotonic_time() + ms * 1000;
  while (!done()) {
    if (g_get_monotonic_time() > deadline) return false;
    g_main_context_iteration(nullptr, FALSE);
    g_usleep(1000);
  }
  return true;
}

GDBusConnection* NewConnection() {
  g_autoptr(GError) error = nullptr;
  g_autofree gchar* address =
      g_dbus_address_get_for_bus_sync(G_BUS_TYPE_SESSION, nullptr, &error);
  if (address == nullptr) return nullptr;
  return g_dbus_connection_new_for_address_sync(
      address,
      static_cast<GDBusConnectionFlags>(
          G_DBUS_CONNECTION_FLAGS_AUTHENTICATION_CLIENT |
          G_DBUS_CONNECTION_FLAGS_MESSAGE_BUS_CONNECTION),
      nullptr, nullptr, &error);
}

// A fake org.kde.StatusNotifierWatcher with one registered host.
struct Watcher {
  GDBusConnection* bus = nullptr;
  guint object = 0;
  guint owner = 0;
  std::vector<std::string> registered;
};

constexpr char kWatcherXml[] = R"XML(
<node>
  <interface name="org.kde.StatusNotifierWatcher">
    <method name="RegisterStatusNotifierItem">
      <arg type="s" direction="in"/>
    </method>
    <property name="IsStatusNotifierHostRegistered" type="b" access="read"/>
    <signal name="StatusNotifierItemRegistered"><arg type="s"/></signal>
    <signal name="StatusNotifierHostRegistered"/>
  </interface>
</node>
)XML";

void WatcherCall(GDBusConnection*, const gchar* sender, const gchar*,
                 const gchar*, const gchar* method, GVariant* parameters,
                 GDBusMethodInvocation* invocation, gpointer user_data) {
  auto* watcher = static_cast<Watcher*>(user_data);
  if (g_strcmp0(method, "RegisterStatusNotifierItem") == 0) {
    const gchar* service = nullptr;
    g_variant_get(parameters, "(&s)", &service);
    watcher->registered.push_back(service);
    (void)sender;
  }
  g_dbus_method_invocation_return_value(invocation, nullptr);
}

GVariant* WatcherProperty(GDBusConnection*, const gchar*, const gchar*,
                          const gchar*, const gchar*, GError**, gpointer) {
  return g_variant_new_boolean(TRUE);
}

const GDBusInterfaceVTable kWatcherVTable = {WatcherCall, WatcherProperty,
                                             nullptr, {nullptr}};

void StartWatcher(Watcher* watcher) {
  static GDBusNodeInfo* info = g_dbus_node_info_new_for_xml(kWatcherXml, nullptr);
  watcher->object = g_dbus_connection_register_object(
      watcher->bus, "/StatusNotifierWatcher", info->interfaces[0],
      &kWatcherVTable, watcher, nullptr, nullptr);
  watcher->owner = g_bus_own_name_on_connection(
      watcher->bus, "org.kde.StatusNotifierWatcher",
      G_BUS_NAME_OWNER_FLAGS_NONE, nullptr, nullptr, nullptr, nullptr);
}

void StopWatcher(Watcher* watcher) {
  g_bus_unown_name(watcher->owner);
  g_dbus_connection_unregister_object(watcher->bus, watcher->object);
  watcher->owner = 0;
  watcher->object = 0;
}

// The item answers on this thread's main context, so the "host" calls it
// asynchronously and spins the loop (a sync call would block the answer).
GVariant* Call(GDBusConnection* bus, const std::string& name,
               const char* path, const char* iface, const char* method,
               GVariant* parameters) {
  struct Result {
    bool done = false;
    GVariant* reply = nullptr;
    std::string error;
  } result;
  g_dbus_connection_call(
      bus, name.c_str(), path, iface, method, parameters, nullptr,
      G_DBUS_CALL_FLAGS_NONE, 3000, nullptr,
      [](GObject* source, GAsyncResult* async, gpointer user_data) {
        auto* out = static_cast<Result*>(user_data);
        g_autoptr(GError) error = nullptr;
        out->reply = g_dbus_connection_call_finish(G_DBUS_CONNECTION(source),
                                                   async, &error);
        if (out->reply == nullptr) out->error = error->message;
        out->done = true;
      },
      &result);
  SpinUntil([&] { return result.done; }, 4000);
  if (result.reply == nullptr) {
    std::fprintf(stderr, "call %s failed: %s\n", method,
                 result.error.c_str());
  }
  return result.reply;
}

GVariant* Property(GDBusConnection* bus, const std::string& name,
                   const char* path, const char* iface, const char* property) {
  g_autoptr(GVariant) reply =
      Call(bus, name, path, "org.freedesktop.DBus.Properties", "Get",
           g_variant_new("(ss)", iface, property));
  if (reply == nullptr) return nullptr;
  GVariant* value = nullptr;
  g_variant_get(reply, "(v)", &value);
  return value;
}

struct MenuItem {
  int32_t id;
  std::string label;
  std::string type;
  int32_t toggle_state;
  bool checkmark;
};

std::vector<MenuItem> Layout(GDBusConnection* host, const std::string& name,
                             uint32_t* revision) {
  std::vector<MenuItem> items;
  const gchar* none[] = {nullptr};
  g_autoptr(GVariant) reply =
      Call(host, name, "/MenuBar", "com.canonical.dbusmenu", "GetLayout",
           g_variant_new("(ii^as)", 0, -1, none));
  if (reply == nullptr) return items;
  g_autoptr(GVariant) root = nullptr;
  g_variant_get(reply, "(u@(ia{sv}av))", revision, &root);
  g_autoptr(GVariant) children = g_variant_get_child_value(root, 2);
  for (gsize i = 0; i < g_variant_n_children(children); ++i) {
    g_autoptr(GVariant) boxed = g_variant_get_child_value(children, i);
    g_autoptr(GVariant) child = g_variant_get_variant(boxed);
    MenuItem item{};
    g_autoptr(GVariant) props = nullptr;
    g_autoptr(GVariant) grandchildren = nullptr;
    g_variant_get(child, "(i@a{sv}@av)", &item.id, &props, &grandchildren);
    const gchar* text = nullptr;
    if (g_variant_lookup(props, "label", "&s", &text)) item.label = text;
    if (g_variant_lookup(props, "type", "&s", &text)) item.type = text;
    if (g_variant_lookup(props, "toggle-type", "&s", &text)) {
      item.checkmark = std::string(text) == "checkmark";
    }
    g_variant_lookup(props, "toggle-state", "i", &item.toggle_state);
    items.push_back(item);
  }
  return items;
}

int32_t IdOf(const std::vector<MenuItem>& items, const std::string& label) {
  for (const auto& item : items) {
    if (item.label == label) return item.id;
  }
  return -1;
}

}  // namespace

int main() {
  GDBusConnection* item_bus = NewConnection();
  GDBusConnection* watcher_bus = NewConnection();
  GDBusConnection* host_bus = NewConnection();
  if (item_bus == nullptr || watcher_bus == nullptr || host_bus == nullptr) {
    std::fprintf(stderr, "no session bus (run under dbus-run-session)\n");
    return 2;
  }

  // No watcher yet: the item waits and is not shown.
  std::vector<std::string> clicks;
  int activations = 0;
  std::vector<bool> shown_changes;
  ares::tray::Pixmap pixmap{2, 1, {255, 1, 2, 3, 128, 4, 5, 6}};
  auto* item = new ares::tray::StatusNotifier(
      item_bus, "com.hermesagent.ares", "Ares", {pixmap},
      {[&] { ++activations; },
       [&](const std::string& id) { clicks.push_back(id); },
       [&](bool shown) { shown_changes.push_back(shown); }});
  item->SetTooltip("Ares");
  item->SetMenu({{"open", "Open Ares", false, false, false},
                 {"pause-notifications", "Pause notifications", true, true,
                  false},
                 {"quit", "Quit Ares", false, false, true}});
  SpinUntil([] { return false; }, 200);
  CHECK(!item->Shown());

  bool queried = false;
  bool query_host = true;
  GCancellable* cancellable = g_cancellable_new();
  ares::tray::StatusNotifier::QueryWatcher(item_bus, cancellable,
                                           [&](bool host) {
                                             queried = true;
                                             query_host = host;
                                           });
  CHECK(SpinUntil([&] { return queried; }));
  CHECK(!query_host);

  // A watcher with a host appears: the item registers and is shown.
  Watcher watcher;
  watcher.bus = watcher_bus;
  StartWatcher(&watcher);
  CHECK(SpinUntil([&] { return item->Shown(); }));
  CHECK(watcher.registered.size() == 1);
  CHECK(!watcher.registered.empty() &&
        watcher.registered.back() == item->bus_name());
  CHECK(shown_changes == std::vector<bool>{true});

  queried = false;
  ares::tray::StatusNotifier::QueryWatcher(item_bus, cancellable,
                                           [&](bool host) {
                                             queried = true;
                                             query_host = host;
                                           });
  CHECK(SpinUntil([&] { return queried; }));
  CHECK(query_host);

  // The host reads the item as a shell would.
  const std::string name = item->bus_name();
  {
    g_autoptr(GVariant) title = Property(host_bus, name, "/StatusNotifierItem",
                                         "org.kde.StatusNotifierItem", "Title");
    CHECK(title != nullptr && std::string(g_variant_get_string(title, nullptr)) == "Ares");
    g_autoptr(GVariant) menu = Property(host_bus, name, "/StatusNotifierItem",
                                        "org.kde.StatusNotifierItem", "Menu");
    CHECK(menu != nullptr && std::string(g_variant_get_string(menu, nullptr)) == "/MenuBar");
    g_autoptr(GVariant) status = Property(host_bus, name, "/StatusNotifierItem",
                                          "org.kde.StatusNotifierItem", "Status");
    CHECK(status != nullptr && std::string(g_variant_get_string(status, nullptr)) == "Active");
    g_autoptr(GVariant) pixmaps = Property(
        host_bus, name, "/StatusNotifierItem", "org.kde.StatusNotifierItem",
        "IconPixmap");
    CHECK(pixmaps != nullptr && g_variant_n_children(pixmaps) == 1);
    if (pixmaps != nullptr && g_variant_n_children(pixmaps) == 1) {
      gint32 width = 0;
      gint32 height = 0;
      g_autoptr(GVariant) bytes = nullptr;
      g_variant_get_child(pixmaps, 0, "(ii@ay)", &width, &height, &bytes);
      CHECK(width == 2 && height == 1 && g_variant_n_children(bytes) == 8);
    }
    g_autoptr(GVariant) tooltip = Property(
        host_bus, name, "/StatusNotifierItem", "org.kde.StatusNotifierItem",
        "ToolTip");
    CHECK(tooltip != nullptr &&
          g_variant_is_of_type(tooltip, G_VARIANT_TYPE("(sa(iiay)ss)")));
    g_autoptr(GVariant) version = Property(host_bus, name, "/MenuBar",
                                           "com.canonical.dbusmenu", "Version");
    CHECK(version != nullptr && g_variant_get_uint32(version) == 3);
  }

  uint32_t revision = 0;
  auto items = Layout(host_bus, name, &revision);
  CHECK(items.size() == 4);  // Three items and the separator before Quit.
  CHECK(IdOf(items, "Open Ares") > 0);
  const int32_t quit_id = IdOf(items, "Quit Ares");
  CHECK(quit_id > 0);
  bool found_separator = false;
  for (const auto& entry : items) {
    if (entry.type == "separator") found_separator = true;
    if (entry.label == "Pause notifications") {
      CHECK(entry.checkmark);
      CHECK(entry.toggle_state == 1);
    }
  }
  CHECK(found_separator);

  // A left click shows the window; a menu click names the action.
  g_autoptr(GVariant) activated =
      Call(host_bus, name, "/StatusNotifierItem", "org.kde.StatusNotifierItem",
           "Activate", g_variant_new("(ii)", 0, 0));
  CHECK(activated != nullptr);
  CHECK(SpinUntil([&] { return activations == 1; }));
  g_autoptr(GVariant) event = Call(
      host_bus, name, "/MenuBar", "com.canonical.dbusmenu", "Event",
      g_variant_new("(isvu)", quit_id, "clicked", g_variant_new_int32(0), 0u));
  CHECK(event != nullptr);
  CHECK(SpinUntil([&] { return clicks.size() == 1; }));
  CHECK(!clicks.empty() && clicks.back() == "quit");

  // The menu changes (another order, a label update): LayoutUpdated, a new
  // revision, and an id the host still holds keeps naming the same action.
  int layout_updates = 0;
  const guint layout_signal = g_dbus_connection_signal_subscribe(
      host_bus, name.c_str(), "com.canonical.dbusmenu", "LayoutUpdated",
      "/MenuBar", nullptr, G_DBUS_SIGNAL_FLAGS_NONE,
      [](GDBusConnection*, const gchar*, const gchar*, const gchar*,
         const gchar*, GVariant*, gpointer user_data) {
        ++*static_cast<int*>(user_data);
      },
      &layout_updates, nullptr);
  item->SetMenu({{"quit", "Quit Ares", false, false, false},
                 {"new-chat", "New chat", false, false, true},
                 {"open", "Open Ares", false, false, false}});
  CHECK(SpinUntil([&] { return layout_updates == 1; }));
  uint32_t next_revision = 0;
  items = Layout(host_bus, name, &next_revision);
  CHECK(next_revision > revision);
  CHECK(IdOf(items, "Quit Ares") == quit_id);
  g_autoptr(GVariant) stale = Call(
      host_bus, name, "/MenuBar", "com.canonical.dbusmenu", "Event",
      g_variant_new("(isvu)", quit_id, "clicked", g_variant_new_int32(0), 0u));
  CHECK(stale != nullptr);
  CHECK(SpinUntil([&] { return clicks.size() == 2; }));
  CHECK(clicks.size() == 2 && clicks.back() == "quit");
  // An unknown id does nothing.
  g_autoptr(GVariant) unknown = Call(
      host_bus, name, "/MenuBar", "com.canonical.dbusmenu", "Event",
      g_variant_new("(isvu)", 9999, "clicked", g_variant_new_int32(0), 0u));
  CHECK(unknown != nullptr);
  SpinUntil([] { return false; }, 100);
  CHECK(clicks.size() == 2);
  g_dbus_connection_signal_unsubscribe(host_bus, layout_signal);

  // The shell restarts: the item is not shown, then registers again.
  StopWatcher(&watcher);
  CHECK(SpinUntil([&] { return !item->Shown(); }));
  StartWatcher(&watcher);
  CHECK(SpinUntil([&] { return item->Shown(); }));
  CHECK(watcher.registered.size() == 2);
  CHECK((shown_changes == std::vector<bool>{true, false, true}));

  // Removing the item releases its name.
  delete item;
  bool released = false;
  CHECK(SpinUntil([&] {
    g_autoptr(GVariant) owned = g_dbus_connection_call_sync(
        host_bus, "org.freedesktop.DBus", "/org/freedesktop/DBus",
        "org.freedesktop.DBus", "NameHasOwner",
        g_variant_new("(s)", name.c_str()), G_VARIANT_TYPE("(b)"),
        G_DBUS_CALL_FLAGS_NONE, 1000, nullptr, nullptr);
    gboolean has = TRUE;
    if (owned != nullptr) g_variant_get(owned, "(b)", &has);
    released = !has;
    return released;
  }));

  g_cancellable_cancel(cancellable);
  g_object_unref(cancellable);
  StopWatcher(&watcher);
  g_object_unref(item_bus);
  g_object_unref(watcher_bus);
  g_object_unref(host_bus);
  std::printf("linux status_notifier (D-Bus): %d checks, %d failures\n", checks,
              failures);
  return failures == 0 ? 0 : 1;
}
