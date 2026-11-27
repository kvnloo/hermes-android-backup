/// The primary window's native desktop integration: one owner for the tray,
/// quick entry, the global hotkey and power events, created by the app root
/// on Windows, macOS and Linux only.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/connection.dart';
import '../services/hermes_deeplink.dart';
import '../services/locale_preference.dart';
import '../services/notification_prefs.dart';
import '../services/shortcuts_store.dart';
import '../services/turn_notification_service.dart' show notificationStrings;
import '../widgets/desktop_shortcuts.dart';
import 'desktop_os.dart';
import 'global_hotkey.dart';
import 'power_events.dart';
import 'quick_entry.dart';
import 'tray_controller.dart';

class DesktopIntegration {
  DesktopIntegration({
    required SharedPreferences preferences,
    DesktopShell shell = const DesktopShell(),
    VoidCallback? onNewChat,
    Future<void> Function(bool enabled)? setNotificationsEnabled,
    ValueListenable<NotificationPrefs>? notifications,
    this._deepLinks,
    List<QuickEntryChat> Function()? quickEntryChats,
    HermesLinkOwner? Function()? quickEntryOwner,
    QuickEntrySpawn? quickEntrySpawn,
    this._connections,
    this._openOwner,
    MethodChannel hotkeyChannel = DesktopOsChannels.hotkey,
    MethodChannel powerChannel = DesktopOsChannels.power,
    TargetPlatform? platform,
    this._strings,
  }) : prefs = DesktopOsPrefs(preferences),
       _shell = shell,
       _onNewChat = onNewChat ?? _fireNewChat,
       _setNotificationsEnabled =
           setNotificationsEnabled ?? NotificationPrefsStore.setEnabled,
       _notifications = notifications ?? notificationPrefs {
    quickEntry = QuickEntryLauncher(
      chats: quickEntryChats ?? QuickEntryTargets.current,
      owner:
          quickEntryOwner ??
          (quickEntryChats == null ? QuickEntryTargets.currentOwner : null),
      locale: () => strings().localeName,
      onPrefill: _routePrefill,
      // Windows: the primary had the foreground right (hotkey press or
      // tray choice) and passes it to this one child pid, never to any
      // process. macOS and Linux activate the child window themselves.
      onSpawned: (platform ?? defaultTargetPlatform) == TargetPlatform.windows
          ? (pid) => unawaited(_shell.allowForeground(pid))
          : null,
      spawn: quickEntrySpawn,
    );
    power = PowerEventsListener(channel: powerChannel);
    hotkey = GlobalHotkeyController(
      prefs: prefs,
      shortcuts: ShortcutsStore(preferences),
      onPressed: () => unawaited(quickEntry.toggle()),
      channel: hotkeyChannel,
      platform: platform,
    );
    tray = TrayController(
      prefs: prefs,
      labels: _trayLabels,
      onAction: handleTrayAction,
      notificationsPaused: () => !_notifications.value.enabled,
      quickEntryAvailable: () => true,
      refreshOn: _notifications,
      channel: shell.channel,
    );
  }

  /// The running integration, for settings screens and the command
  /// palette. Null on phones, in tests that do not create one, and in child
  /// windows.
  static DesktopIntegration? current;

  final DesktopOsPrefs prefs;
  final DesktopShell _shell;
  final VoidCallback _onNewChat;
  final Future<void> Function(bool enabled) _setNotificationsEnabled;
  final ValueListenable<NotificationPrefs> _notifications;
  final HermesDeepLinkService? _deepLinks;
  final AppLocalizations Function()? _strings;

  /// The saved connections now, to check a quick-entry owner still exists.
  final List<SavedConnection> Function()? _connections;

  /// Brings the shell for [connection] forward (the app root switches
  /// NextGen's connection or opens Classic's workspace for it) so the
  /// owned link can be consumed there.
  final void Function(SavedConnection connection)? _openOwner;

  late final TrayController tray;
  late final QuickEntryLauncher quickEntry;
  late final GlobalHotkeyController hotkey;

  /// Suspend/lock events that pause the gateway sockets.
  late final PowerEventsListener power;

  bool _disposed = false;

  static void _fireNewChat() => fireDesktopShortcut(DesktopShortcut.newChat);

  void start() {
    if (_disposed) return;
    current = this;
    tray.start();
    hotkey.start();
    power.start();
  }

  AppLocalizations strings() {
    final custom = _strings;
    if (custom != null) return custom();
    final chosen = LocalePreference.read(prefs.preferences);
    if (chosen != null && AppLocalizations.delegate.isSupported(chosen)) {
      return lookupAppLocalizations(chosen);
    }
    return notificationStrings();
  }

  TrayLabels _trayLabels() {
    final l = strings();
    return TrayLabels(
      tooltip: 'Ares',
      open: l.desktop_tray_open,
      newChat: l.desktop_tray_new_chat,
      quickEntry: l.desktop_tray_quick_entry,
      pauseNotifications: l.desktop_tray_pause_notifications,
      quit: l.desktop_tray_quit,
    );
  }

  /// Opens quick entry (command palette); false when it could not open.
  Future<bool> openQuickEntry() =>
      _disposed ? Future.value(false) : quickEntry.show();

  /// The hand-back from the quick-entry window: show the main window and
  /// route a prefill-only link through the validated deep-link router, to
  /// the connection and profile whose chats were offered. When that owner no
  /// longer exists (connection removed, or now on another profile) the text
  /// is kept as a new draft in whichever chat list is showing: never sent,
  /// never lost, never put into a chat of another connection.
  void _routePrefill(QuickEntryPrefill prefill) {
    if (_disposed) return;
    unawaited(_shell.showWindow());
    final links = _deepLinks ?? HermesDeepLinkService.shared;
    final owner = prefill.owner;
    if (owner == null) {
      links.handleRawLink(prefill.toDeepLink());
      return;
    }
    final connections = _connections;
    final SavedConnection? target;
    if (connections == null) {
      target = null;
    } else {
      final found = connections()
          .where((c) => c.id == owner.connectionId)
          .firstOrNull;
      target = found != null && owner.matches(found.id, found.gatewayProfile)
          ? found
          : null;
      if (target == null) {
        links.handleRawLink(QuickEntryPrefill(text: prefill.text).toDeepLink());
        return;
      }
    }
    links.handleRawLink(prefill.toDeepLink(), owner: owner);
    if (target != null) _openOwner?.call(target);
  }

  @visibleForTesting
  void handleTrayAction(TrayAction action) {
    if (_disposed) return;
    switch (action) {
      case TrayAction.open:
        unawaited(_shell.showWindow());
      case TrayAction.newChat:
        unawaited(_shell.showWindow());
        _onNewChat();
      case TrayAction.quickEntry:
        unawaited(quickEntry.toggle());
      case TrayAction.pauseNotifications:
        unawaited(_setNotificationsEnabled(!_notifications.value.enabled));
      case TrayAction.quit:
        unawaited(quit());
    }
  }

  /// Tears the integration down (tray icon, hotkey, quick entry), then asks
  /// the runner to close the primary window.
  Future<void> quit() async {
    await dispose();
    await _shell.quit();
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    if (identical(current, this)) current = null;
    quickEntry.dispose();
    power.dispose();
    await hotkey.dispose();
    await tray.dispose();
  }
}
