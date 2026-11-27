/// Opt-in tray / menu-bar icon for the primary window.
///
/// Dart owns the policy (whether the icon shows, its localized menu, what an
/// item does); the runner only draws the icon and reports which item the
/// user chose through `onTrayAction`. Off by default.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'desktop_os.dart';

/// What a tray menu item does. The wire id is what the runner reports.
enum TrayAction {
  open('open'),
  newChat('new-chat'),
  quickEntry('quick-entry'),
  pauseNotifications('pause-notifications'),
  quit('quit');

  const TrayAction(this.wireId);

  final String wireId;

  static TrayAction? fromWire(Object? id) {
    for (final action in values) {
      if (action.wireId == id) return action;
    }
    return null;
  }
}

/// The menu text, resolved by the caller in the device language.
@immutable
class TrayLabels {
  const TrayLabels({
    required this.tooltip,
    required this.open,
    required this.newChat,
    required this.quickEntry,
    required this.pauseNotifications,
    required this.quit,
  });

  final String tooltip;
  final String open;
  final String newChat;
  final String quickEntry;
  final String pauseNotifications;
  final String quit;
}

enum TrayStatus {
  /// The user has not turned the icon on (the default).
  off,

  /// The runner reports the icon is installed.
  shown,

  /// The icon is on but this desktop has no tray the runner can use.
  unsupported,
}

class TrayController {
  TrayController({
    required this._prefs,
    required this._labels,
    required this._onAction,
    required this._notificationsPaused,
    this._quickEntryAvailable,
    this._refreshOn,
    this._channel = DesktopOsChannels.shell,
  });

  final DesktopOsPrefs _prefs;
  final TrayLabels Function() _labels;
  final void Function(TrayAction action) _onAction;
  final bool Function() _notificationsPaused;
  final bool Function()? _quickEntryAvailable;
  final Listenable? _refreshOn;
  final MethodChannel _channel;

  final ValueNotifier<TrayStatus> status = ValueNotifier(TrayStatus.off);

  /// Whether the runner can show a tray icon on this desktop
  /// (`isTraySupported`): null until it answers, false without a runner.
  /// Settings offers the tray switches only when this is true.
  final ValueNotifier<bool?> supported = ValueNotifier(null);

  Future<void> _queue = Future<void>.value();
  bool _started = false;
  bool _disposed = false;
  bool _installed = false;

  void start() {
    if (_started || _disposed) return;
    _started = true;
    _channel.setMethodCallHandler(_onCall);
    desktopOsPrefsChanges.addListener(_refresh);
    _refreshOn?.addListener(_refresh);
    unawaited(querySupport());
    _refresh();
  }

  /// Asks the runner whether this desktop has a usable tray.
  Future<bool> querySupport() async {
    bool answer;
    try {
      answer = await _channel.invokeMethod<bool>('isTraySupported') == true;
    } on MissingPluginException {
      answer = false;
    } on PlatformException {
      answer = false;
    }
    if (!_disposed) supported.value = answer;
    return answer;
  }

  void _refresh() => unawaited(sync());

  /// Applies the saved preference. Calls run in order, and each reads the
  /// state when it runs, so the last change wins.
  Future<void> sync() => _queue = _queue.then((_) => _apply());

  /// The menu sent to the runner for the current state.
  @visibleForTesting
  List<Map<String, Object>> menuItems() {
    final labels = _labels();
    return [
      {'id': TrayAction.open.wireId, 'label': labels.open},
      {'id': TrayAction.newChat.wireId, 'label': labels.newChat},
      if (_quickEntryAvailable?.call() ?? false)
        {'id': TrayAction.quickEntry.wireId, 'label': labels.quickEntry},
      {
        'id': TrayAction.pauseNotifications.wireId,
        'label': labels.pauseNotifications,
        'checked': _notificationsPaused(),
      },
      {
        'id': TrayAction.quit.wireId,
        'label': labels.quit,
        'separatorBefore': true,
      },
    ];
  }

  Future<void> _apply() async {
    final enabled = !_disposed && _prefs.trayEnabled;
    if (!enabled && !_installed) {
      if (!_disposed) status.value = TrayStatus.off;
      return;
    }
    final arguments = enabled
        ? <String, Object>{
            'enabled': true,
            'closeToTray': _prefs.closeToTray,
            'tooltip': _labels().tooltip,
            'items': menuItems(),
          }
        : const <String, Object>{'enabled': false, 'closeToTray': false};
    bool shown;
    try {
      shown = await _channel.invokeMethod<bool>('setTray', arguments) == true;
    } on MissingPluginException {
      shown = false;
    } on PlatformException {
      shown = false;
    }
    _installed = enabled && shown;
    if (_disposed) return;
    status.value = !enabled
        ? TrayStatus.off
        : shown
        ? TrayStatus.shown
        : TrayStatus.unsupported;
  }

  Future<Object?> _onCall(MethodCall call) async {
    if (_disposed) return null;
    if (call.method == 'onTrayStatus') {
      // The icon appeared or went away after setTray answered (a tray host
      // started late, or the desktop shell restarted).
      if (!_prefs.trayEnabled) return null;
      final shown = call.arguments == true;
      _installed = shown;
      status.value = shown ? TrayStatus.shown : TrayStatus.unsupported;
      if (shown) supported.value = true;
      return null;
    }
    if (call.method != 'onTrayAction') return null;
    final action = TrayAction.fromWire(call.arguments);
    // Unknown ids (or a quick-entry item that is not offered) do nothing.
    if (action == null) return null;
    if (action == TrayAction.quickEntry &&
        !(_quickEntryAvailable?.call() ?? false)) {
      return null;
    }
    _onAction(action);
    return null;
  }

  /// Removes the icon and stops listening. Safe to call more than once.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    desktopOsPrefsChanges.removeListener(_refresh);
    _refreshOn?.removeListener(_refresh);
    _channel.setMethodCallHandler(null);
    await (_queue = _queue.then((_) => _apply()));
  }
}
