/// App-wide "the computer is asleep or the session is locked" signal.
///
/// The desktop runners report suspend/resume and lock/unlock on
/// `com.hermesagent.ares/power` (see `lib/core/desktop/power_events.dart`).
/// While [value] is true, gateway clients close their live sockets and stop
/// reconnecting; when it turns false they reconnect and re-bind stored
/// sessions with `session.resume`. Nothing is replayed: a prompt whose
/// submission was in flight is reconciled from history by the existing
/// recovery journal, never sent again.
///
/// The gate fails safe: a lock with no matching unlock (a locker that
/// unlocks without telling the session manager) never keeps the sockets
/// paused while the user is visibly using the app. Focus, pointer or key
/// input in the app lifts the pause ([noteUserActivity]), and a resume
/// re-reads the lock state from the runner ([lockProbe]).
///
/// A paused socket cannot see a turn end, so anything that follows turn
/// state across a pause (keep-awake) waits for [reconciled]: chats with a
/// running turn [holdReconcile] when the pause starts and
/// [releaseReconcile] once they have read their state again after it.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

enum PowerEvent {
  suspend,
  resume,
  lock,
  unlock;

  static PowerEvent? fromWire(Object? name) {
    for (final event in values) {
      if (event.name == name) return event;
    }
    return null;
  }
}

/// Asks the runner whether the session is locked right now: true or false,
/// or null when it cannot tell.
typedef LockStateProbe = Future<bool?> Function();

class SystemSleepGate extends ChangeNotifier implements ValueListenable<bool> {
  SystemSleepGate._();

  static final SystemSleepGate instance = SystemSleepGate._();

  bool _suspended = false;
  bool _locked = false;

  /// Set by the power listener of the primary window; null without a
  /// runner that can answer.
  LockStateProbe? lockProbe;

  /// True while sockets should stay paused.
  @override
  bool get value => _suspended || _locked;

  bool get suspended => _suspended;
  bool get locked => _locked;

  final Set<Object> _reconciling = <Object>{};
  bool _awaitingReconcile = false;
  final ValueNotifier<int> _reconciled = ValueNotifier<int>(0);

  /// Bumps once after each pause, when the pause has lifted and every chat
  /// that had a running turn when it started has read its state again
  /// (re-attached and caught up, or recovered from history). Until then
  /// nothing seen before the pause says whether that turn still runs.
  ValueListenable<int> get reconciled => _reconciled;

  /// Chats still to read their state again after the last pause.
  @visibleForTesting
  int get reconcilePending => _reconciling.length;

  /// Whether [owner] still has to read its state again after the pause.
  bool reconcilePendingFor(Object owner) => _reconciling.contains(owner);

  /// [owner] had a running turn when the pause started and will call
  /// [releaseReconcile] once it has read its state again. Only counts
  /// during a pause or before the reconcile that follows it.
  void holdReconcile(Object owner) {
    if (!value && !_awaitingReconcile) return;
    _reconciling.add(owner);
  }

  /// [owner] has read its state again after the pause, its turn ended, or
  /// it is gone. Safe to call for an owner that never held.
  void releaseReconcile(Object owner) {
    if (!_reconciling.remove(owner)) return;
    _finishReconcile();
  }

  void apply(PowerEvent event) {
    final before = value;
    switch (event) {
      case PowerEvent.suspend:
        _suspended = true;
      case PowerEvent.resume:
        // Waking does not unlock a session that locked on the way down, but
        // the lock state is read again: a lock whose unlock was never
        // reported must not outlive the wake.
        _suspended = false;
      case PowerEvent.lock:
        _locked = true;
      case PowerEvent.unlock:
        _locked = false;
    }
    _publish(before);
    if (event == PowerEvent.resume) unawaited(recheckLock());
  }

  /// The user is visibly using the app (it regained focus, or got pointer or
  /// key input): the computer is awake and the session unlocked, whatever
  /// the last event said.
  void noteUserActivity() {
    final before = value;
    _suspended = false;
    _locked = false;
    _publish(before);
  }

  /// Re-reads the lock state from the runner. An unlocked answer lifts the
  /// lock; an unknown answer keeps it until the user is back in the app.
  Future<void> recheckLock() async {
    final probe = lockProbe;
    if (probe == null || !_locked) return;
    bool? locked;
    try {
      locked = await probe();
    } catch (_) {
      locked = null;
    }
    if (locked == false && _locked) apply(PowerEvent.unlock);
  }

  void _publish(bool before) {
    final now = value;
    if (now == before) return;
    if (now) _awaitingReconcile = true;
    notifyListeners();
    // Listeners (sockets) have started reconnecting; owners that held
    // release as they catch up. With none holding, it is reconciled now.
    if (!now) _finishReconcile();
  }

  void _finishReconcile() {
    if (value || !_awaitingReconcile || _reconciling.isNotEmpty) return;
    _awaitingReconcile = false;
    _reconciled.value++;
  }

  /// Clears both flags and any pending reconcile (listener shutdown,
  /// tests).
  void clear() {
    final before = value;
    _suspended = false;
    _locked = false;
    _reconciling.clear();
    _publish(before);
    _finishReconcile();
  }
}
