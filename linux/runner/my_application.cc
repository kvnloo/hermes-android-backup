#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "desktop_os.h"
#include "desktop_os_logic.h"
#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
  // The primary window (weak). A second activation presents it instead of
  // opening another primary.
  GtkWindow* primary;
  // com.hermesagent.ares/deeplink, primary window only. A link that arrives
  // before Dart asked for the initial one waits in |pending_link|.
  FlMethodChannel* deep_links;
  gchar* pending_link;
  gboolean links_ready;
  // Set once Flutter rendered the primary's first frame (which shows it).
  // Before that, an activation or a link leaves showing to first_frame_cb.
  gboolean first_frame_shown;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

static gboolean is_child_launch(char** arguments) {
  if (arguments == nullptr) return FALSE;
  for (char** arg = arguments; *arg != nullptr; ++arg) {
    if (ares::desktop::IsChildWindowMarker(*arg)) return TRUE;
  }
  return FALSE;
}

static void deep_link_call_cb(FlMethodChannel* channel, FlMethodCall* call,
                              gpointer user_data) {
  MyApplication* self = MY_APPLICATION(user_data);
  g_autoptr(FlMethodResponse) response = nullptr;
  if (g_strcmp0(fl_method_call_get_name(call), "getInitialLink") == 0) {
    // Dart listens from here on: later links go straight to it.
    self->links_ready = TRUE;
    g_autoptr(FlValue) value =
        self->pending_link != nullptr ? fl_value_new_string(self->pending_link)
                                      : fl_value_new_null();
    g_clear_pointer(&self->pending_link, g_free);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(value));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }
  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(call, response, &error)) {
    g_warning("deeplink: failed to respond: %s", error->message);
  }
}

// Brings the primary window back: shown even when it was closed to the tray
// (hidden), restored when minimised, and raised.
static void present_primary(MyApplication* self) {
  if (self->primary == nullptr || !self->first_frame_shown) return;
  gtk_widget_show(GTK_WIDGET(self->primary));
  gtk_window_deiconify(self->primary);
  gtk_window_present(self->primary);
}

// Shows the primary window and hands |link| to Dart's validated router, or
// keeps it for getInitialLink.
static void deliver_link(MyApplication* self, const gchar* link) {
  present_primary(self);
  if (self->deep_links != nullptr && self->links_ready) {
    g_autoptr(FlValue) value = fl_value_new_string(link);
    fl_method_channel_invoke_method(self->deep_links, "onDeepLink", value,
                                    nullptr, nullptr, nullptr);
  } else {
    g_free(self->pending_link);
    self->pending_link = g_strdup(link);
  }
}

// Called when first Flutter frame received.
static void first_frame_cb(MyApplication* self, FlView* view) {
  gtk_widget_show(gtk_widget_get_toplevel(GTK_WIDGET(view)));
  self->first_frame_shown = TRUE;
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  // The primary instance is unique: a second launch (or a link) activates
  // this one over D-Bus, which brings its window forward (also out of the
  // tray) instead of opening a second window, tray icon and hotkey. The
  // second process exits without creating a window.
  if (self->primary != nullptr) {
    present_primary(self);
    return;
  }
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "Ares");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "Ares");
  }

  gtk_window_set_default_size(window, 1280, 720);
  if (self->dart_entrypoint_arguments != nullptr) {
    for (char** arg = self->dart_entrypoint_arguments; *arg != nullptr;
         ++arg) {
      if (g_strcmp0(*arg, "--ares-pet-companion-v1") == 0) {
        gtk_window_set_keep_above(window, TRUE);
        gtk_window_set_default_size(window, 360, 520);
        break;
      }
      if (g_strcmp0(*arg, "--ares-quick-entry-v1") == 0) {
        // A small always-on-top panel; it never owns the tray or hotkey.
        gtk_window_set_keep_above(window, TRUE);
        gtk_window_set_default_size(window, 640, 220);
        gtk_window_set_position(window, GTK_WIN_POS_CENTER);
        gtk_window_set_skip_taskbar_hint(window, TRUE);
        gtk_window_set_title(window, "Ares \u2014 Quick entry");
        break;
      }
    }
  }

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(
      project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  GdkRGBA background_color;
  // Background defaults to black, override it here if necessary, e.g. #00000000
  // for transparent.
  gdk_rgba_parse(&background_color, "#000000");
  fl_view_set_background_color(view, &background_color);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  // Show the window when Flutter renders.
  // Requires the view to be realized so we can start rendering.
  g_signal_connect_swapped(view, "first-frame", G_CALLBACK(first_frame_cb),
                           self);
  gtk_widget_realize(GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  // Tray, hotkey, power, capture and deep links belong to the primary
  // window only.
  const bool child = is_child_launch(self->dart_entrypoint_arguments);
  if (!child) {
    ares_desktop_os_attach(view, window);
    self->primary = window;
    g_object_add_weak_pointer(G_OBJECT(window),
                              reinterpret_cast<gpointer*>(&self->primary));
    g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
    self->deep_links = fl_method_channel_new(
        fl_engine_get_binary_messenger(fl_view_get_engine(view)),
        "com.hermesagent.ares/deeplink", FL_METHOD_CODEC(codec));
    fl_method_channel_set_method_call_handler(self->deep_links,
                                              deep_link_call_cb, self, nullptr);
  }

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application,
                                                  gchar*** arguments,
                                                  int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  // Child windows (pop-out chat, companion, quick entry) are separate,
  // non-unique processes that talk to their parent over a pipe. The primary
  // is unique per session: a second launch or a hermes:// link (the desktop
  // file's x-scheme-handler/hermes) goes to the running primary over D-Bus.
  const bool child = is_child_launch(self->dart_entrypoint_arguments);
  g_application_set_flags(application, child ? G_APPLICATION_NON_UNIQUE
                                             : G_APPLICATION_HANDLES_OPEN);
  const gchar* link = nullptr;
  if (!child && g_strv_length(self->dart_entrypoint_arguments) == 1 &&
      ares::desktop::IsDeepLink(self->dart_entrypoint_arguments[0])) {
    link = (*arguments)[1];
    // The link goes to the deep-link channel, never to Dart's entrypoint
    // arguments.
    g_strfreev(self->dart_entrypoint_arguments);
    self->dart_entrypoint_arguments = g_new0(char*, 1);
  }

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }

  if (link != nullptr) {
    g_autoptr(GFile) file = g_file_new_for_uri(link);
    GFile* files[] = {file};
    g_application_open(application, files, 1, "");
  } else {
    g_application_activate(application);
  }
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::open: hermes:// links, from this launch or
// forwarded by a second one.
static void my_application_open(GApplication* application, GFile** files,
                                gint n_files, const gchar* hint) {
  MyApplication* self = MY_APPLICATION(application);
  if (self->primary == nullptr) g_application_activate(application);
  for (gint i = 0; i < n_files; ++i) {
    g_autofree gchar* uri = g_file_get_uri(files[i]);
    if (uri != nullptr && ares::desktop::IsDeepLink(uri)) {
      deliver_link(self, uri);
    }
  }
}

// Implements GApplication::startup.
static void my_application_startup(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  if (self->deep_links != nullptr) {
    fl_method_channel_set_method_call_handler(self->deep_links, nullptr,
                                              nullptr, nullptr);
    g_clear_object(&self->deep_links);
  }
  g_clear_pointer(&self->pending_link, g_free);
  if (self->primary != nullptr) {
    g_object_remove_weak_pointer(G_OBJECT(self->primary),
                                 reinterpret_cast<gpointer*>(&self->primary));
    self->primary = nullptr;
  }
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->open = my_application_open;
  G_APPLICATION_CLASS(klass)->local_command_line =
      my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  // Set the program name to the application ID, which helps various systems
  // like GTK and desktop environments map this running application to its
  // corresponding .desktop file. This ensures better integration by allowing
  // the application to be recognized beyond its binary name.
  g_set_prgname(APPLICATION_ID);

  // Flags are settled in local_command_line (unique primary, non-unique
  // children) before registration.
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID, "flags",
                                     G_APPLICATION_HANDLES_OPEN, nullptr));
}
