/// Suspend/resume and lock/unlock events from the desktop runners.
///
/// The runners call `onPowerEvent` on `com.hermesagent.ares/power` with
/// `suspend`, `resume`, `lock` or `unlock`. The events feed
/// [SystemSleepGate], which pauses the gateway sockets until the computer
/// is awake and unlocked again. The same channel carries the keep-awake
/// requests (`keep_awake.dart`), which run while a turn is active if the
/// user chose that.
///
/// The pause never outlives the user's return: the listener also watches
/// the primary window for focus and pointer or key input, which lift it
/// ([SystemSleepGate.noteUserActivity]), and answers the gate's lock probe
/// with the runner's `isLocked` (null where a runner cannot tell).
library;

import 'dart:ui' show ViewFocusEvent, ViewFocusState;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../services/system_sleep_gate.dart';
import 'desktop_os.dart';

class PowerEventsListener with WidgetsBindingObserver {
  PowerEventsListener({
    this._channel = DesktopOsChannels.power,
    SystemSleepGate? gate,
  }) : _gate = gate ?? SystemSleepGate.instance;

  final MethodChannel _channel;
  final SystemSleepGate _gate;
  bool _started = false;
  bool _disposed = false;

  void start() {
    if (_started || _disposed) return;
    _started = true;
    _channel.setMethodCallHandler(_onCall);
    _gate.lockProbe = _probeLock;
    WidgetsBinding.instance.addObserver(this);
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  Future<Object?> _onCall(MethodCall call) async {
    if (_disposed || call.method != 'onPowerEvent') return null;
    final event = PowerEvent.fromWire(call.arguments);
    if (event != null) _gate.apply(event);
    return null;
  }

  Future<bool?> _probeLock() async {
    if (_disposed) return null;
    try {
      return await _channel.invokeMethod<bool>('isLocked');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// The window regained focus: the user is back.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_disposed && state == AppLifecycleState.resumed) {
      _gate.noteUserActivity();
    }
  }

  @override
  void didChangeViewFocus(ViewFocusEvent event) {
    if (!_disposed && event.state == ViewFocusState.focused) {
      _gate.noteUserActivity();
    }
  }

  void _onPointer(PointerEvent event) {
    if (!_disposed && event is PointerDownEvent) _gate.noteUserActivity();
  }

  bool _onKey(KeyEvent event) {
    if (!_disposed && event is KeyDownEvent) _gate.noteUserActivity();
    return false; // Observe only; the key still reaches the app.
  }

  /// Stops listening and lifts any pause, so sockets never stay paused
  /// without a runner to report the wake.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    if (_started) {
      _channel.setMethodCallHandler(null);
      if (_gate.lockProbe == _probeLock) _gate.lockProbe = null;
      WidgetsBinding.instance.removeObserver(this);
      GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
      HardwareKeyboard.instance.removeHandler(_onKey);
    }
    _gate.clear();
  }
}
