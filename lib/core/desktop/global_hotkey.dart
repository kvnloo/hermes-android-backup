/// Opt-in, remappable system-wide hotkey that toggles quick entry.
///
/// Dart validates the chord (a real modifier, not a reserved OS chord, not
/// an in-app shortcut) before the runner registers it; the runner reports a
/// chord another app owns as a conflict. The hotkey is unregistered when it
/// is turned off, remapped, and when the app exits.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../services/shortcuts_store.dart';
import 'desktop_os.dart';

enum HotkeyStatus {
  /// Off (the default).
  off,

  /// Registered with the OS.
  registered,

  /// Another app already owns the chord.
  conflict,

  /// The desktop cannot register a global hotkey (e.g. Wayland).
  unsupported,

  /// Dart rejected the chord before asking the OS ([HotkeyCheck.problem]).
  invalid,
}

enum HotkeyProblem {
  /// Needs Cmd, Ctrl or Alt so ordinary typing never triggers it.
  noModifier,

  /// The Windows / Super key belongs to the OS shell on Windows and Linux.
  superKey,

  /// The system uses this chord (app switching, Spotlight, …).
  reserved,

  /// The chord is one of Ares' own in-app shortcuts.
  inAppShortcut,
}

@immutable
class HotkeyCheck {
  const HotkeyCheck(this.problem, [this.action]);

  static const ok = HotkeyCheck(null);

  final HotkeyProblem? problem;

  /// The in-app action the chord collides with.
  final ShortcutAction? action;

  bool get isOk => problem == null;
}

bool _isApple(TargetPlatform platform) =>
    platform == TargetPlatform.macOS || platform == TargetPlatform.iOS;

/// Cmd+Shift+Space on macOS, Ctrl+Shift+Space elsewhere (Desktop's default).
KeyChord defaultQuickEntryChord(TargetPlatform platform) => _isApple(platform)
    ? const KeyChord(key: LogicalKeyboardKey.space, meta: true, shift: true)
    : const KeyChord(key: LogicalKeyboardKey.space, ctrl: true, shift: true);

const _reservedApple = {
  'meta+space', // Spotlight
  'ctrl+space', // input source
  'meta+alt+space', // Finder search
  'meta+keyQ',
  'meta+keyW',
  'meta+keyH',
  'meta+keyM',
  'meta+tab',
  'meta+shift+tab',
  'meta+backquote',
  'meta+shift+digit3',
  'meta+shift+digit4',
  'meta+shift+digit5',
  'meta+ctrl+keyQ', // lock screen
  'meta+ctrl+space', // character viewer
};

const _reservedOther = {
  'alt+tab',
  'alt+shift+tab',
  'alt+space', // window menu
  'alt+escape',
  'ctrl+escape', // Start menu
  'ctrl+shift+escape', // Task Manager
  'ctrl+alt+delete',
  'ctrl+alt+keyT', // terminal on many Linux desktops
  'ctrl+alt+keyL', // lock on many Linux desktops
};

/// Checks [chord] as a global hotkey on [platform] against [inApp] (the
/// effective in-app shortcuts). On Windows and Linux an uncustomized Cmd
/// shortcut also answers to Ctrl, so both forms collide.
HotkeyCheck checkGlobalHotkey(
  KeyChord chord, {
  required TargetPlatform platform,
  required Map<ShortcutAction, KeyChord> inApp,
}) {
  final apple = _isApple(platform);
  if (!apple && chord.meta) return const HotkeyCheck(HotkeyProblem.superKey);
  if (!(chord.meta || chord.ctrl || chord.alt)) {
    return const HotkeyCheck(HotkeyProblem.noModifier);
  }
  final serialized = chord.serialize();
  if ((apple ? _reservedApple : _reservedOther).contains(serialized)) {
    return const HotkeyCheck(HotkeyProblem.reserved);
  }
  for (final entry in inApp.entries) {
    final binding = entry.value;
    if (binding == chord) {
      return HotkeyCheck(HotkeyProblem.inAppShortcut, entry.key);
    }
    if (!apple && binding.meta && !binding.ctrl) {
      final mirror = KeyChord(
        key: binding.key,
        ctrl: true,
        shift: binding.shift,
        alt: binding.alt,
      );
      if (mirror == chord) {
        return HotkeyCheck(HotkeyProblem.inAppShortcut, entry.key);
      }
    }
  }
  return HotkeyCheck.ok;
}

class GlobalHotkeyController {
  GlobalHotkeyController({
    required this._prefs,
    required this._onPressed,
    this._shortcuts,
    this._channel = DesktopOsChannels.hotkey,
    TargetPlatform? platform,
  }) : _platform = platform ?? defaultTargetPlatform;

  final DesktopOsPrefs _prefs;
  final VoidCallback _onPressed;
  final ShortcutsStore? _shortcuts;
  final MethodChannel _channel;
  final TargetPlatform _platform;

  final ValueNotifier<HotkeyStatus> status = ValueNotifier(HotkeyStatus.off);

  /// Whether the runner can register a global shortcut on this desktop
  /// (`isSupported`; false on Wayland and without a runner): null until it
  /// answers. Settings offers the switch only when this is true.
  final ValueNotifier<bool?> supported = ValueNotifier(null);

  /// Why the saved chord was rejected, when [status] is invalid.
  HotkeyCheck lastCheck = HotkeyCheck.ok;

  Future<void> _queue = Future<void>.value();
  KeyChord? _registered;
  bool _started = false;
  bool _disposed = false;

  TargetPlatform get platform => _platform;

  /// The saved chord, or the platform default.
  KeyChord get chord =>
      KeyChord.parse(_prefs.hotkeyChord) ?? defaultQuickEntryChord(_platform);

  /// Validates a candidate chord against the current in-app shortcuts.
  HotkeyCheck check(KeyChord candidate) => checkGlobalHotkey(
    candidate,
    platform: _platform,
    inApp: _shortcuts?.allBindings() ?? _defaultBindings(),
  );

  static Map<ShortcutAction, KeyChord> _defaultBindings() => {
    for (final action in ShortcutRegistry.actions)
      action: ShortcutRegistry.defaultChord(action),
  };

  void start() {
    if (_started || _disposed) return;
    _started = true;
    _channel.setMethodCallHandler(_onCall);
    desktopOsPrefsChanges.addListener(_refresh);
    shortcutsStoreChanges.addListener(_refresh);
    unawaited(querySupport());
    _refresh();
  }

  /// Asks the runner whether this desktop allows a global shortcut.
  Future<bool> querySupport() async {
    bool answer;
    try {
      answer = await _channel.invokeMethod<bool>('isSupported') == true;
    } on MissingPluginException {
      answer = false;
    } on PlatformException {
      answer = false;
    }
    if (!_disposed) supported.value = answer;
    return answer;
  }

  void _refresh() => unawaited(sync());

  /// Applies the saved preference; calls run in order and the last wins.
  Future<void> sync() => _queue = _queue.then((_) => _apply());

  Future<void> _apply() async {
    if (_disposed || !_prefs.hotkeyEnabled) {
      await _unregister();
      if (!_disposed) status.value = HotkeyStatus.off;
      return;
    }
    final wanted = chord;
    final verdict = check(wanted);
    lastCheck = verdict;
    if (!verdict.isOk) {
      await _unregister();
      status.value = HotkeyStatus.invalid;
      return;
    }
    if (_registered == wanted) {
      status.value = HotkeyStatus.registered;
      return;
    }
    await _unregister();
    String? result;
    try {
      result = await _channel.invokeMethod<String>('register', {
        'key': wanted.keyName,
        'meta': wanted.meta,
        'ctrl': wanted.ctrl,
        'alt': wanted.alt,
        'shift': wanted.shift,
      });
    } on MissingPluginException {
      result = 'unsupported';
    } on PlatformException {
      result = 'unsupported';
    }
    if (_disposed) {
      if (result == 'registered') {
        _registered = wanted;
        await _unregister();
      }
      return;
    }
    switch (result) {
      case 'registered':
        _registered = wanted;
        status.value = HotkeyStatus.registered;
      case 'conflict':
        status.value = HotkeyStatus.conflict;
      case 'invalid':
        status.value = HotkeyStatus.invalid;
      default:
        status.value = HotkeyStatus.unsupported;
        supported.value = false;
    }
  }

  Future<void> _unregister() async {
    if (_registered == null) return;
    _registered = null;
    try {
      await _channel.invokeMethod<void>('unregister');
    } on MissingPluginException {
      // Nothing was registered natively.
    } on PlatformException {
      // The runner releases the hotkey when the window closes anyway.
    }
  }

  Future<Object?> _onCall(MethodCall call) async {
    if (call.method == 'onHotKey' && !_disposed && _registered != null) {
      _onPressed();
    }
    return null;
  }

  /// Unregisters the hotkey and stops listening (app exit).
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    desktopOsPrefsChanges.removeListener(_refresh);
    shortcutsStoreChanges.removeListener(_refresh);
    _channel.setMethodCallHandler(null);
    await (_queue = _queue.then((_) => _apply()));
  }
}
