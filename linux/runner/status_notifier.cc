#include "status_notifier.h"

#include <unistd.h>

#include <atomic>
#include <map>
#include <utility>

namespace ares::tray {

namespace {

constexpr char kWatcherName[] = "org.kde.StatusNotifierWatcher";
constexpr char kWatcherPath[] = "/StatusNotifierWatcher";
constexpr char kItemPath[] = "/StatusNotifierItem";
constexpr char kItemInterface[] = "org.kde.StatusNotifierItem";
constexpr char kMenuPath[] = "/MenuBar";
constexpr char kMenuInterface[] = "com.canonical.dbusmenu";

// Menu items keep their dbusmenu id for the item's lifetime, keyed by the
// Dart action id, so a click on a menu the host built from an older layout
// still names the action it showed. Separators use ids from here up.
constexpr int32_t kFirstSeparatorId = 10000;

constexpr char kIntrospection[] = R"XML(
<node>
  <interface name="org.kde.StatusNotifierItem">
    <property name="Category" type="s" access="read"/>
    <property name="Id" type="s" access="read"/>
    <property name="Title" type="s" access="read"/>
    <property name="Status" type="s" access="read"/>
    <property name="WindowId" type="i" access="read"/>
    <property name="IconName" type="s" access="read"/>
    <property name="IconThemePath" type="s" access="read"/>
    <property name="IconPixmap" type="a(iiay)" access="read"/>
    <property name="OverlayIconName" type="s" access="read"/>
    <property name="OverlayIconPixmap" type="a(iiay)" access="read"/>
    <property name="AttentionIconName" type="s" access="read"/>
    <property name="AttentionIconPixmap" type="a(iiay)" access="read"/>
    <property name="AttentionMovieName" type="s" access="read"/>
    <property name="ToolTip" type="(sa(iiay)ss)" access="read"/>
    <property name="ItemIsMenu" type="b" access="read"/>
    <property name="Menu" type="o" access="read"/>
    <method name="ContextMenu"><arg type="i" direction="in"/><arg type="i" direction="in"/></method>
    <method name="Activate"><arg type="i" direction="in"/><arg type="i" direction="in"/></method>
    <method name="SecondaryActivate"><arg type="i" direction="in"/><arg type="i" direction="in"/></method>
    <method name="Scroll"><arg type="i" direction="in"/><arg type="s" direction="in"/></method>
    <signal name="NewTitle"/>
    <signal name="NewIcon"/>
    <signal name="NewAttentionIcon"/>
    <signal name="NewOverlayIcon"/>
    <signal name="NewToolTip"/>
    <signal name="NewStatus"><arg type="s"/></signal>
  </interface>
  <interface name="com.canonical.dbusmenu">
    <property name="Version" type="u" access="read"/>
    <property name="TextDirection" type="s" access="read"/>
    <property name="Status" type="s" access="read"/>
    <property name="IconThemePath" type="as" access="read"/>
    <method name="GetLayout">
      <arg type="i" direction="in"/><arg type="i" direction="in"/>
      <arg type="as" direction="in"/>
      <arg type="u" direction="out"/><arg type="(ia{sv}av)" direction="out"/>
    </method>
    <method name="GetGroupProperties">
      <arg type="ai" direction="in"/><arg type="as" direction="in"/>
      <arg type="a(ia{sv})" direction="out"/>
    </method>
    <method name="GetProperty">
      <arg type="i" direction="in"/><arg type="s" direction="in"/>
      <arg type="v" direction="out"/>
    </method>
    <method name="Event">
      <arg type="i" direction="in"/><arg type="s" direction="in"/>
      <arg type="v" direction="in"/><arg type="u" direction="in"/>
    </method>
    <method name="EventGroup">
      <arg type="a(isvu)" direction="in"/><arg type="ai" direction="out"/>
    </method>
    <method name="AboutToShow">
      <arg type="i" direction="in"/><arg type="b" direction="out"/>
    </method>
    <method name="AboutToShowGroup">
      <arg type="ai" direction="in"/>
      <arg type="ai" direction="out"/><arg type="ai" direction="out"/>
    </method>
    <signal name="ItemsPropertiesUpdated">
      <arg type="a(ia{sv})"/><arg type="a(ias)"/>
    </signal>
    <signal name="LayoutUpdated"><arg type="u"/><arg type="i"/></signal>
    <signal name="ItemActivationRequested"><arg type="i"/><arg type="u"/></signal>
  </interface>
</node>
)XML";

GDBusNodeInfo* NodeInfo() {
  static GDBusNodeInfo* info =
      g_dbus_node_info_new_for_xml(kIntrospection, nullptr);
  return info;
}

std::atomic<int> g_instances{0};

// Stable dbusmenu ids per Dart action id, for the process lifetime.
int32_t IdFor(const std::string& action) {
  static std::map<std::string, int32_t> ids;
  auto it = ids.find(action);
  if (it != ids.end()) return it->second;
  const int32_t next = static_cast<int32_t>(ids.size()) + 1;
  ids.emplace(action, next);
  return next;
}

// An async call's context: the item may be gone when it completes.
struct Pending {
  StatusNotifier* self;
  GCancellable* cancellable;
};

Pending* NewPending(StatusNotifier* self, GCancellable* cancellable) {
  return new Pending{self, G_CANCELLABLE(g_object_ref(cancellable))};
}

bool Gone(Pending* pending) {
  return g_cancellable_is_cancelled(pending->cancellable);
}

void FreePending(Pending* pending) {
  g_object_unref(pending->cancellable);
  delete pending;
}

void ItemMethodCb(GDBusConnection*, const gchar*, const gchar*, const gchar*,
                  const gchar* method, GVariant* parameters,
                  GDBusMethodInvocation* invocation, gpointer user_data) {
  static_cast<StatusNotifier*>(user_data)->HandleItemCall(method, parameters,
                                                          invocation);
}

GVariant* ItemPropertyCb(GDBusConnection*, const gchar*, const gchar*,
                         const gchar*, const gchar* name, GError**,
                         gpointer user_data) {
  return static_cast<StatusNotifier*>(user_data)->ItemProperty(name);
}

void MenuMethodCb(GDBusConnection*, const gchar*, const gchar*, const gchar*,
                  const gchar* method, GVariant* parameters,
                  GDBusMethodInvocation* invocation, gpointer user_data) {
  static_cast<StatusNotifier*>(user_data)->HandleMenuCall(method, parameters,
                                                          invocation);
}

GVariant* MenuPropertyCb(GDBusConnection*, const gchar*, const gchar*,
                         const gchar*, const gchar* name, GError**,
                         gpointer user_data) {
  return static_cast<StatusNotifier*>(user_data)->MenuProperty(name);
}

const GDBusInterfaceVTable kItemVTable = {ItemMethodCb, ItemPropertyCb,
                                          nullptr, {nullptr}};
const GDBusInterfaceVTable kMenuVTable = {MenuMethodCb, MenuPropertyCb,
                                          nullptr, {nullptr}};

void WatcherAppearedCb(GDBusConnection*, const gchar*, const gchar*,
                       gpointer user_data) {
  static_cast<StatusNotifier*>(user_data)->WatcherAppeared();
}

void WatcherVanishedCb(GDBusConnection*, const gchar*, gpointer user_data) {
  static_cast<StatusNotifier*>(user_data)->WatcherVanished();
}

void HostSignalCb(GDBusConnection*, const gchar*, const gchar*, const gchar*,
                  const gchar* signal, GVariant*, gpointer user_data) {
  auto* self = static_cast<StatusNotifier*>(user_data);
  if (g_strcmp0(signal, "StatusNotifierHostRegistered") == 0) {
    self->HostChanged(true);
  } else if (g_strcmp0(signal, "StatusNotifierHostUnregistered") == 0) {
    // Another host may remain: the watcher's property says.
    self->WatcherAppeared();
  }
}

GVariant* PixmapArray(const std::vector<Pixmap>& icon) {
  GVariantBuilder builder;
  g_variant_builder_init(&builder, G_VARIANT_TYPE("a(iiay)"));
  for (const Pixmap& pixmap : icon) {
    if (pixmap.width <= 0 || pixmap.height <= 0 ||
        pixmap.argb.size() != static_cast<size_t>(pixmap.width) *
                                  static_cast<size_t>(pixmap.height) * 4) {
      continue;
    }
    GVariant* bytes = g_variant_new_fixed_array(
        G_VARIANT_TYPE_BYTE, pixmap.argb.data(), pixmap.argb.size(), 1);
    g_variant_builder_add(&builder, "(ii@ay)", pixmap.width, pixmap.height,
                          bytes);
  }
  return g_variant_builder_end(&builder);
}

GVariant* EmptyPixmaps() {
  return g_variant_new_array(G_VARIANT_TYPE("(iiay)"), nullptr, 0);
}

}  // namespace

StatusNotifier::StatusNotifier(GDBusConnection* bus, std::string id,
                               std::string title, std::vector<Pixmap> icon,
                               Callbacks callbacks)
    : bus_(G_DBUS_CONNECTION(g_object_ref(bus))),
      cancellable_(g_cancellable_new()),
      id_(std::move(id)),
      title_(std::move(title)),
      icon_(std::move(icon)),
      callbacks_(std::move(callbacks)) {
  GDBusNodeInfo* info = NodeInfo();
  item_object_ = g_dbus_connection_register_object(
      bus_, kItemPath,
      g_dbus_node_info_lookup_interface(info, kItemInterface), &kItemVTable,
      this, nullptr, nullptr);
  menu_object_ = g_dbus_connection_register_object(
      bus_, kMenuPath,
      g_dbus_node_info_lookup_interface(info, kMenuInterface), &kMenuVTable,
      this, nullptr, nullptr);
  host_signal_ = g_dbus_connection_signal_subscribe(
      bus_, kWatcherName, kWatcherName, nullptr, kWatcherPath, nullptr,
      G_DBUS_SIGNAL_FLAGS_NONE, HostSignalCb, this, nullptr);
  bus_name_ = "org.kde.StatusNotifierItem-" + std::to_string(getpid()) + "-" +
              std::to_string(++g_instances);
  // The name is requested before registering with any watcher; the
  // watcher checks that the registered name has an owner.
  owner_id_ = g_bus_own_name_on_connection(
      bus_, bus_name_.c_str(), G_BUS_NAME_OWNER_FLAGS_DO_NOT_QUEUE, nullptr,
      nullptr, nullptr, nullptr);
  watch_id_ = g_bus_watch_name_on_connection(
      bus_, kWatcherName, G_BUS_NAME_WATCHER_FLAGS_NONE, WatcherAppearedCb,
      WatcherVanishedCb, this, nullptr);
}

StatusNotifier::~StatusNotifier() {
  g_cancellable_cancel(cancellable_);
  if (watch_id_ != 0) g_bus_unwatch_name(watch_id_);
  if (owner_id_ != 0) g_bus_unown_name(owner_id_);
  if (host_signal_ != 0) {
    g_dbus_connection_signal_unsubscribe(bus_, host_signal_);
  }
  if (item_object_ != 0) {
    g_dbus_connection_unregister_object(bus_, item_object_);
  }
  if (menu_object_ != 0) {
    g_dbus_connection_unregister_object(bus_, menu_object_);
  }
  g_object_unref(cancellable_);
  g_object_unref(bus_);
}

void StatusNotifier::SetTooltip(const std::string& tooltip) {
  if (tooltip == tooltip_) return;
  tooltip_ = tooltip;
  EmitItem("NewToolTip", nullptr);
}

void StatusNotifier::SetMenu(std::vector<MenuEntry> entries) {
  entries_ = std::move(entries);
  ++revision_;
  g_dbus_connection_emit_signal(bus_, nullptr, kMenuPath, kMenuInterface,
                                "LayoutUpdated",
                                g_variant_new("(ui)", revision_, 0), nullptr);
}

void StatusNotifier::EmitItem(const char* signal, GVariant* parameters) {
  g_dbus_connection_emit_signal(bus_, nullptr, kItemPath, kItemInterface,
                                signal, parameters, nullptr);
}

void StatusNotifier::HandleItemCall(const gchar* method, GVariant*,
                                    GDBusMethodInvocation* invocation) {
  if (g_strcmp0(method, "Activate") == 0 ||
      g_strcmp0(method, "SecondaryActivate") == 0) {
    if (callbacks_.activate) callbacks_.activate();
  }
  // ContextMenu: the host draws the dbusmenu itself. Scroll: nothing.
  g_dbus_method_invocation_return_value(invocation, nullptr);
}

GVariant* StatusNotifier::ItemProperty(const gchar* name) {
  const std::string property(name);
  if (property == "Category") return g_variant_new_string("ApplicationStatus");
  if (property == "Id") return g_variant_new_string(id_.c_str());
  if (property == "Title") return g_variant_new_string(title_.c_str());
  if (property == "Status") return g_variant_new_string("Active");
  if (property == "WindowId") return g_variant_new_int32(0);
  if (property == "IconPixmap") return PixmapArray(icon_);
  if (property == "OverlayIconPixmap" || property == "AttentionIconPixmap") {
    return EmptyPixmaps();
  }
  if (property == "IconName" || property == "IconThemePath" ||
      property == "OverlayIconName" || property == "AttentionIconName" ||
      property == "AttentionMovieName") {
    return g_variant_new_string("");
  }
  if (property == "ToolTip") {
    const std::string& text = tooltip_.empty() ? title_ : tooltip_;
    return g_variant_new("(s@a(iiay)ss)", "", EmptyPixmaps(), title_.c_str(),
                         text == title_ ? "" : text.c_str());
  }
  if (property == "ItemIsMenu") return g_variant_new_boolean(FALSE);
  if (property == "Menu") return g_variant_new_object_path(kMenuPath);
  return nullptr;
}

GVariant* StatusNotifier::ItemProperties(int32_t id) {
  GVariantBuilder props;
  g_variant_builder_init(&props, G_VARIANT_TYPE("a{sv}"));
  if (id == 0) {
    g_variant_builder_add(&props, "{sv}", "children-display",
                          g_variant_new_string("submenu"));
    return g_variant_builder_end(&props);
  }
  if (id >= kFirstSeparatorId) {
    g_variant_builder_add(&props, "{sv}", "type",
                          g_variant_new_string("separator"));
    return g_variant_builder_end(&props);
  }
  for (const MenuEntry& entry : entries_) {
    if (IdFor(entry.id) != id) continue;
    g_variant_builder_add(&props, "{sv}", "label",
                          g_variant_new_string(entry.label.c_str()));
    g_variant_builder_add(&props, "{sv}", "enabled",
                          g_variant_new_boolean(TRUE));
    g_variant_builder_add(&props, "{sv}", "visible",
                          g_variant_new_boolean(TRUE));
    if (entry.has_check) {
      g_variant_builder_add(&props, "{sv}", "toggle-type",
                            g_variant_new_string("checkmark"));
      g_variant_builder_add(&props, "{sv}", "toggle-state",
                            g_variant_new_int32(entry.checked ? 1 : 0));
    }
    break;
  }
  return g_variant_builder_end(&props);
}

GVariant* StatusNotifier::Layout(int32_t parent, int32_t depth) {
  GVariantBuilder children;
  g_variant_builder_init(&children, G_VARIANT_TYPE("av"));
  if (parent == 0 && depth != 0) {
    for (size_t i = 0; i < entries_.size(); ++i) {
      const MenuEntry& entry = entries_[i];
      if (entry.separator_before && i > 0) {
        const int32_t separator = kFirstSeparatorId + static_cast<int32_t>(i);
        g_variant_builder_add(
            &children, "v",
            g_variant_new("(i@a{sv}@av)", separator,
                          ItemProperties(separator),
                          g_variant_new_array(G_VARIANT_TYPE_VARIANT, nullptr,
                                              0)));
      }
      const int32_t id = IdFor(entry.id);
      g_variant_builder_add(
          &children, "v",
          g_variant_new("(i@a{sv}@av)", id, ItemProperties(id),
                        g_variant_new_array(G_VARIANT_TYPE_VARIANT, nullptr,
                                            0)));
    }
  }
  return g_variant_new("(i@a{sv}@av)", parent, ItemProperties(parent),
                       g_variant_builder_end(&children));
}

void StatusNotifier::HandleMenuCall(const gchar* method, GVariant* parameters,
                                    GDBusMethodInvocation* invocation) {
  const std::string call(method);
  if (call == "GetLayout") {
    gint32 parent = 0;
    gint32 depth = -1;
    g_autoptr(GVariant) names = nullptr;
    g_variant_get(parameters, "(ii@as)", &parent, &depth, &names);
    g_dbus_method_invocation_return_value(
        invocation,
        g_variant_new("(u@(ia{sv}av))", revision_, Layout(parent, depth)));
    return;
  }
  if (call == "GetGroupProperties") {
    g_autoptr(GVariant) ids = nullptr;
    g_autoptr(GVariant) names = nullptr;
    g_variant_get(parameters, "(@ai@as)", &ids, &names);
    GVariantBuilder result;
    g_variant_builder_init(&result, G_VARIANT_TYPE("a(ia{sv})"));
    std::vector<int32_t> wanted;
    gsize count = 0;
    const gint32* raw = static_cast<const gint32*>(
        g_variant_get_fixed_array(ids, &count, sizeof(gint32)));
    for (gsize i = 0; i < count; ++i) wanted.push_back(raw[i]);
    if (wanted.empty()) {
      wanted.push_back(0);
      for (size_t i = 0; i < entries_.size(); ++i) {
        wanted.push_back(IdFor(entries_[i].id));
      }
    }
    for (int32_t id : wanted) {
      g_variant_builder_add(&result, "(i@a{sv})", id, ItemProperties(id));
    }
    g_dbus_method_invocation_return_value(
        invocation, g_variant_new("(@a(ia{sv}))",
                                  g_variant_builder_end(&result)));
    return;
  }
  if (call == "GetProperty") {
    gint32 id = 0;
    const gchar* name = nullptr;
    g_variant_get(parameters, "(i&s)", &id, &name);
    g_autoptr(GVariant) props = g_variant_ref_sink(ItemProperties(id));
    g_autoptr(GVariant) value =
        g_variant_lookup_value(props, name, nullptr);
    if (value == nullptr) {
      g_dbus_method_invocation_return_dbus_error(
          invocation, "org.freedesktop.DBus.Error.InvalidArgs",
          "No such property");
      return;
    }
    g_dbus_method_invocation_return_value(
        invocation, g_variant_new("(v)", value));
    return;
  }
  auto click = [this](gint32 id, const gchar* event) {
    if (g_strcmp0(event, "clicked") != 0 || !callbacks_.menu) return;
    for (const MenuEntry& entry : entries_) {
      if (IdFor(entry.id) == id) {
        // A copy: the action may replace the menu.
        const std::string action = entry.id;
        callbacks_.menu(action);
        return;
      }
    }
  };
  if (call == "Event") {
    gint32 id = 0;
    const gchar* event = nullptr;
    g_variant_get(parameters, "(i&svu)", &id, &event, nullptr, nullptr);
    // Answer first: the action may rebuild the menu.
    g_dbus_method_invocation_return_value(invocation, nullptr);
    click(id, event);
    return;
  }
  if (call == "EventGroup") {
    g_autoptr(GVariant) events = nullptr;
    g_variant_get(parameters, "(@a(isvu))", &events);
    std::vector<std::pair<gint32, std::string>> clicks;
    GVariantIter iter;
    g_variant_iter_init(&iter, events);
    gint32 id = 0;
    const gchar* event = nullptr;
    while (g_variant_iter_next(&iter, "(i&svu)", &id, &event, nullptr,
                               nullptr)) {
      clicks.emplace_back(id, event);
    }
    g_dbus_method_invocation_return_value(
        invocation,
        g_variant_new("(@ai)", g_variant_new_array(G_VARIANT_TYPE_INT32,
                                                   nullptr, 0)));
    for (const auto& [clicked, name] : clicks) click(clicked, name.c_str());
    return;
  }
  if (call == "AboutToShow") {
    g_dbus_method_invocation_return_value(invocation,
                                          g_variant_new("(b)", FALSE));
    return;
  }
  if (call == "AboutToShowGroup") {
    GVariant* none[] = {
        g_variant_new_array(G_VARIANT_TYPE_INT32, nullptr, 0),
        g_variant_new_array(G_VARIANT_TYPE_INT32, nullptr, 0)};
    g_dbus_method_invocation_return_value(invocation,
                                          g_variant_new_tuple(none, 2));
    return;
  }
  g_dbus_method_invocation_return_dbus_error(
      invocation, "org.freedesktop.DBus.Error.UnknownMethod", method);
}

GVariant* StatusNotifier::MenuProperty(const gchar* name) {
  const std::string property(name);
  if (property == "Version") return g_variant_new_uint32(3);
  if (property == "TextDirection") return g_variant_new_string("ltr");
  if (property == "Status") return g_variant_new_string("normal");
  if (property == "IconThemePath") {
    return g_variant_new_strv(nullptr, 0);
  }
  return nullptr;
}

void StatusNotifier::WatcherAppeared() { Register(); }

void StatusNotifier::WatcherVanished() { SetState(false, false); }

void StatusNotifier::Register() {
  g_dbus_connection_call(
      bus_, kWatcherName, kWatcherPath, kWatcherName,
      "RegisterStatusNotifierItem", g_variant_new("(s)", bus_name_.c_str()),
      nullptr, G_DBUS_CALL_FLAGS_NO_AUTO_START, 5000, cancellable_,
      [](GObject* source, GAsyncResult* result, gpointer user_data) {
        auto* pending = static_cast<Pending*>(user_data);
        g_autoptr(GVariant) reply = g_dbus_connection_call_finish(
            G_DBUS_CONNECTION(source), result, nullptr);
        if (!Gone(pending)) pending->self->Registered(reply != nullptr);
        FreePending(pending);
      },
      NewPending(this, cancellable_));
}

void StatusNotifier::Registered(bool ok) {
  if (!ok) {
    SetState(false, false);
    return;
  }
  registered_ = true;
  ReadHost();
}

void StatusNotifier::ReadHost() {
  g_dbus_connection_call(
      bus_, kWatcherName, kWatcherPath, "org.freedesktop.DBus.Properties",
      "Get",
      g_variant_new("(ss)", kWatcherName, "IsStatusNotifierHostRegistered"),
      G_VARIANT_TYPE("(v)"), G_DBUS_CALL_FLAGS_NO_AUTO_START, 5000,
      cancellable_,
      [](GObject* source, GAsyncResult* result, gpointer user_data) {
        auto* pending = static_cast<Pending*>(user_data);
        g_autoptr(GVariant) reply = g_dbus_connection_call_finish(
            G_DBUS_CONNECTION(source), result, nullptr);
        if (!Gone(pending)) {
          bool host = false;
          if (reply != nullptr) {
            g_autoptr(GVariant) boxed = nullptr;
            g_variant_get(reply, "(v)", &boxed);
            host = boxed != nullptr &&
                   g_variant_is_of_type(boxed, G_VARIANT_TYPE_BOOLEAN) &&
                   g_variant_get_boolean(boxed);
          }
          pending->self->HostChanged(host);
        }
        FreePending(pending);
      },
      NewPending(this, cancellable_));
}

void StatusNotifier::HostChanged(bool host) {
  if (host && !registered_) {
    // A host appeared before this item registered: register now.
    Register();
    return;
  }
  SetState(registered_, host);
}

void StatusNotifier::SetState(bool registered, bool host) {
  const bool before = Shown();
  registered_ = registered;
  host_ = host;
  if (Shown() != before && callbacks_.shown_changed) {
    callbacks_.shown_changed(Shown());
  }
}

void StatusNotifier::QueryWatcher(GDBusConnection* bus,
                                  GCancellable* cancellable,
                                  std::function<void(bool)> done) {
  struct Query {
    GCancellable* cancellable;
    std::function<void(bool)> done;
  };
  auto* query = new Query{G_CANCELLABLE(g_object_ref(cancellable)),
                          std::move(done)};
  g_dbus_connection_call(
      bus, kWatcherName, kWatcherPath, "org.freedesktop.DBus.Properties",
      "Get",
      g_variant_new("(ss)", kWatcherName, "IsStatusNotifierHostRegistered"),
      G_VARIANT_TYPE("(v)"), G_DBUS_CALL_FLAGS_NO_AUTO_START, 2000,
      cancellable,
      [](GObject* source, GAsyncResult* result, gpointer user_data) {
        auto* query = static_cast<Query*>(user_data);
        g_autoptr(GVariant) reply = g_dbus_connection_call_finish(
            G_DBUS_CONNECTION(source), result, nullptr);
        bool host = false;
        if (reply != nullptr) {
          g_autoptr(GVariant) boxed = nullptr;
          g_variant_get(reply, "(v)", &boxed);
          host = boxed != nullptr &&
                 g_variant_is_of_type(boxed, G_VARIANT_TYPE_BOOLEAN) &&
                 g_variant_get_boolean(boxed);
        }
        if (!g_cancellable_is_cancelled(query->cancellable)) query->done(host);
        g_object_unref(query->cancellable);
        delete query;
      },
      query);
}

}  // namespace ares::tray
