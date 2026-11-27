/// Native desktop integration shared by Classic and NextGen: the platform
/// gate, the runner channel names and the device-local preferences.
///
/// Every feature here is opt-in and off by default. Only the primary window
/// talks to these channels; pop-out, companion and quick-entry children run
/// other entry points and never construct the controllers. The runner
/// contract is documented in `docs/desktop-os-native.md`.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// True on the desktop runners (Windows, macOS, Linux). Android and iOS use
/// the narrow-device alternatives (command palette takeover, share sheet).
bool get isDesktopOs =>
    !kIsWeb &&
    switch (defaultTargetPlatform) {
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows => true,
      _ => false,
    };

/// Runner channels. Each is implemented by the primary window only.
abstract final class DesktopOsChannels {
  /// Tray / menu-bar icon and primary-window control.
  static const shell = MethodChannel('com.hermesagent.ares/shell');

  /// System-wide quick-entry hotkey.
  static const hotkey = MethodChannel('com.hermesagent.ares/hotkey');

  /// Keep-awake requests (Dart → runner) and suspend/lock events
  /// (runner → Dart). Shared with `keep_awake.dart`.
  static const power = MethodChannel('com.hermesagent.ares/power');

  /// Screen capture into an attachment draft.
  static const capture = MethodChannel('com.hermesagent.ares/capture');
}

/// Bumped whenever [DesktopOsPrefs] writes, so open settings and the app
/// root re-apply the native state.
final ValueNotifier<int> desktopOsPrefsChanges = ValueNotifier<int>(0);

/// Device-local desktop integration preferences. Never synced or backed up
/// with connection data; every switch defaults to off.
class DesktopOsPrefs {
  DesktopOsPrefs(this._prefs);

  static const trayKey = 'desktop_tray_enabled_v1';
  static const closeToTrayKey = 'desktop_close_to_tray_v1';
  static const hotkeyEnabledKey = 'desktop_quick_entry_hotkey_enabled_v1';
  static const hotkeyChordKey = 'desktop_quick_entry_hotkey_v1';

  final SharedPreferences _prefs;

  SharedPreferences get preferences => _prefs;

  bool get trayEnabled => _prefs.getBool(trayKey) ?? false;

  /// Closing the main window hides it to the tray. Only applies while the
  /// tray icon is on, so the window can always be brought back.
  bool get closeToTray =>
      trayEnabled && (_prefs.getBool(closeToTrayKey) ?? false);

  bool get closeToTraySetting => _prefs.getBool(closeToTrayKey) ?? false;

  bool get hotkeyEnabled => _prefs.getBool(hotkeyEnabledKey) ?? false;

  /// The saved quick-entry chord in `shortcuts_store` notation, or null for
  /// the platform default.
  String? get hotkeyChord => _prefs.getString(hotkeyChordKey);

  Future<void> setTrayEnabled(bool value) => _setBool(trayKey, value);

  Future<void> setCloseToTray(bool value) => _setBool(closeToTrayKey, value);

  Future<void> setHotkeyEnabled(bool value) =>
      _setBool(hotkeyEnabledKey, value);

  Future<void> setHotkeyChord(String? chord) async {
    if (chord == null) {
      await _prefs.remove(hotkeyChordKey);
    } else {
      await _prefs.setString(hotkeyChordKey, chord);
    }
    desktopOsPrefsChanges.value++;
  }

  Future<void> _setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
    desktopOsPrefsChanges.value++;
  }
}

/// Primary-window control through [DesktopOsChannels.shell].
class DesktopShell {
  const DesktopShell([this.channel = DesktopOsChannels.shell]);

  final MethodChannel channel;

  /// Shows, restores and focuses the primary window (also from the tray).
  Future<void> showWindow() => _invoke('showWindow');

  /// Ends the app from the tray. The runner closes the primary window, which
  /// also ends every pop-out child through its closed pipe.
  Future<void> quit() => _invoke('quit');

  /// Lets the child process [pid] (the quick-entry window just started)
  /// take the foreground. Windows only (`AllowSetForegroundWindow(pid)`,
  /// never "any process"); other runners need nothing and ignore it.
  Future<void> allowForeground(int pid) async {
    try {
      await channel.invokeMethod<Object?>('allowForeground', {'pid': pid});
    } on MissingPluginException {
      // macOS and Linux activate the child window themselves.
    } on PlatformException {
      // Never throw into the quick-entry launch.
    }
  }

  Future<void> _invoke(String method) async {
    try {
      await channel.invokeMethod<void>(method);
    } on MissingPluginException {
      // A runner without the shell channel has nothing to show or quit.
    } on PlatformException {
      // Never throw into a menu callback.
    }
  }
}
