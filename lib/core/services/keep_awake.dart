/// Opt-in "keep the computer awake" policy.
///
/// The policy is device-local, off by default, and documented as opt-in by
/// the user in Settings. Every runner implements the
/// `com.hermesagent.ares/power` MethodChannel (`isSupported`, `setAwake`):
///
///  - Windows: `SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED)`;
///  - macOS: an `IOPMAssertion` (PreventUserIdleSystemSleep);
///  - Linux: the xdg-desktop-portal `Inhibit` request (suspend), or
///    `org.freedesktop.ScreenSaver.Inhibit` without a portal; unsupported
///    when neither answers;
///  - Android: `FLAG_KEEP_SCREEN_ON` on the activity window;
///  - iOS: `UIApplication.isIdleTimerDisabled`.
///
/// Settings shows the card only when the runner answers `isSupported` with
/// true, so a platform without a working mechanism never offers it.
library;

import 'dart:async';

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'system_sleep_gate.dart';

/// Broadcasts whenever [KeepAwakePolicyStore.write] updates the saved policy.
final ValueNotifier<int> keepAwakePolicyChanges = ValueNotifier<int>(0);

/// How long the computer is kept awake while Ares is working.
enum KeepAwakeMode {
  /// Never keep the computer awake.
  off,

  /// Keep awake only during an active turn (a turn in progress).
  whileWorking,

  /// Keep awake for as long as Ares is running.
  always,
}

/// Device-local policy store. Values round-trip as stable strings so a future
/// store can share a single preferences file.
class KeepAwakePolicyStore {
  KeepAwakePolicyStore(this._prefs);

  /// Preference key — stable and never reused for anything else.
  static const preferenceKey = 'keep_awake_mode';

  final SharedPreferences _prefs;

  KeepAwakeMode read() {
    final raw = _prefs.getString(preferenceKey);
    for (final mode in KeepAwakeMode.values) {
      if (raw == mode.name) return mode;
    }
    return KeepAwakeMode.off;
  }

  Future<void> write(KeepAwakeMode mode) async {
    await _prefs.setString(preferenceKey, mode.name);
    keepAwakePolicyChanges.value++;
  }
}

/// Probes whether the current platform runner implements `com.hermesagent.ares/power`.
///
/// Returns `false` when the native channel is absent (degrading to a safe no-op
/// while still persisting the user's device-local preference).
Future<bool> isKeepAwakeChannelSupported([
  MethodChannel channel = MethodChannelKeepAwakeAdapter.channel,
]) async {
  try {
    final supported = await channel.invokeMethod<bool>('isSupported');
    return supported ?? false;
  } on MissingPluginException {
    return false;
  } on PlatformException {
    return false;
  } catch (_) {
    return false;
  }
}

/// The native seam. A runner that implements the channel receives one
/// `setAwake` call with `{owner, enabled}` per state change; a runner that
/// does not implement it is a no-op.
abstract class KeepAwakeAdapter {
  /// Idempotent request: the channel may be absent (headless test or a
  /// platform without a runner implementation). Never throws.
  void setAwake({required String owner, required bool enabled});
}

/// Default adapter using a MethodChannel. Implements the documented
/// `com.hermesagent.ares/power` contract when a native runner provides it.
class MethodChannelKeepAwakeAdapter implements KeepAwakeAdapter {
  const MethodChannelKeepAwakeAdapter();

  /// Channel contract: `setAwake {owner, enabled}` → void.
  static const channel = MethodChannel('com.hermesagent.ares/power');

  @override
  void setAwake({required String owner, required bool enabled}) {
    unawaited(_send(owner, enabled));
  }

  Future<void> _send(String owner, bool enabled) async {
    try {
      await channel.invokeMethod<void>('setAwake', {
        'owner': owner,
        'enabled': enabled,
      });
    } on MissingPluginException {
      // No native implementation — a wake request is not an error.
    } on PlatformException {
      // Same reasoning.
    } on Exception {
      // Never throw into a turn.
    }
  }
}

/// Applies the policy for the active session. A single controller owns the
/// OS-level wake flag: closing an old chat cannot release a newer chat's flag.
///
/// The request is released while the computer sleeps or the session is
/// locked ([SystemSleepGate]): the sockets are paused then, so a turn that
/// ends meanwhile is never seen, and a "while working" request would
/// otherwise stay held until unlock. After the pause it is taken again only
/// once the chats have reconciled ([SystemSleepGate.reconciled]) and the
/// turn still runs, or when a turn is seen to start or end afterwards.
class KeepAwakeController {
  KeepAwakeController({
    required this._adapter,
    required this._store,
    this._background = false,
    SystemSleepGate? sleepGate,
  }) : _gate = sleepGate ?? SystemSleepGate.instance {
    _paused = _gate.value;
    _confirmed = !_paused;
    _gate.addListener(_onSleepGate);
    _gate.reconciled.addListener(_onReconciled);
    final mode = _store?.read() ?? KeepAwakeMode.off;
    _apply(mode, working: false);
  }

  final KeepAwakeAdapter _adapter;
  final KeepAwakePolicyStore? _store;
  final SystemSleepGate _gate;
  final String _owner = 'keep-awake-${DateTime.now().microsecondsSinceEpoch}';
  bool _awake = false;
  bool _busy = false;
  bool _background;
  bool _disposed = false;

  /// True while the computer sleeps or the session is locked.
  bool _paused = false;

  /// False from a pause until the turn state is known again: a turn that
  /// was running when the sockets paused may have ended unseen.
  bool _confirmed = true;

  /// Current policy, mirroring the store.
  KeepAwakeMode get mode => _store?.read() ?? KeepAwakeMode.off;

  /// Whether the OS is currently told to stay awake.
  bool get isAwake => _awake;

  /// Whether the app is in the background (mobile `paused`, or the app is
  /// going away). A backgrounded app never holds the wake request; it is
  /// taken again on resume if the policy and the work still call for it.
  /// A minimised desktop window is `hidden`, not `paused`, and keeps it: the
  /// point of the setting is that a long turn finishes while you are away.
  void setBackground(bool background) {
    if (_background == background) return;
    _background = background;
    _apply(_store?.read() ?? KeepAwakeMode.off, working: _busy);
  }

  /// Begin/end a turn. A turn in flight keeps the computer awake when the
  /// policy is `whileWorking` or `always`. Every way a turn ends (finished,
  /// failed, cancelled or interrupted) reports `false` here and releases it.
  /// A change seen after a pause is current again, so it also ends the wait
  /// for [SystemSleepGate.reconciled].
  void setWorking(bool working) {
    if (_busy == working) return;
    _busy = working;
    if (!_paused) _confirmed = true;
    _apply(_store?.read() ?? KeepAwakeMode.off, working: working);
  }

  /// Re-read the policy and re-apply it (call after a preference change).
  void refresh() {
    _apply(_store?.read() ?? KeepAwakeMode.off, working: _busy);
  }

  /// Refreshes the policy from the store — safe to call when the store is
  /// absent (headless test or an unsupported platform).
  void refreshFromStore() {
    _apply(_store?.read() ?? KeepAwakeMode.off, working: _busy);
  }

  void _onSleepGate() {
    final paused = _gate.value;
    if (paused == _paused) return;
    _paused = paused;
    if (paused) _confirmed = false;
    _apply(_store?.read() ?? KeepAwakeMode.off, working: _busy);
  }

  void _onReconciled() {
    if (_paused) return;
    _confirmed = true;
    _apply(_store?.read() ?? KeepAwakeMode.off, working: _busy);
  }

  void _apply(KeepAwakeMode mode, {required bool working}) {
    final shouldAwake =
        !_disposed &&
        !_background &&
        !_paused &&
        switch (mode) {
          KeepAwakeMode.off => false,
          KeepAwakeMode.whileWorking => working && _confirmed,
          KeepAwakeMode.always => true,
        };
    if (_awake == shouldAwake) return;
    _awake = shouldAwake;
    _adapter.setAwake(owner: _owner, enabled: shouldAwake);
  }

  /// Clean up: release the wake flag without touching the stored policy.
  void dispose() {
    if (_disposed) return;
    _gate.removeListener(_onSleepGate);
    _gate.reconciled.removeListener(_onReconciled);
    _apply(KeepAwakeMode.off, working: false);
    _disposed = true;
  }
}
