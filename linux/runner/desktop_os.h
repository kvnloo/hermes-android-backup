#ifndef RUNNER_DESKTOP_OS_H_
#define RUNNER_DESKTOP_OS_H_

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

// The primary window's desktop integration (docs/desktop-os-native.md):
//
//   com.hermesagent.ares/shell   setTray, showWindow, quit; onTrayAction
//   com.hermesagent.ares/hotkey  register, unregister; onHotKey (X11)
//   com.hermesagent.ares/power   isSupported, setAwake; onPowerEvent
//   com.hermesagent.ares/capture status, capture (xdg-desktop-portal)
//
// Created only for the primary window; child window processes never own a
// tray icon.
typedef struct _AresDesktopOs AresDesktopOs;

// Attaches the integration to the primary window. It frees itself when the
// window is destroyed.
void ares_desktop_os_attach(FlView* view, GtkWindow* window);

#endif  // RUNNER_DESKTOP_OS_H_
