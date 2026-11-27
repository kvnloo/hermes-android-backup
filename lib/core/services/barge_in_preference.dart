import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether speaking during read-aloud playback cuts the playback.
///
/// Opt-in, off by default: asking for the microphone to stay live while the
/// engine speaks is a visible side effect, so it never turns on by default.
/// Stored in [SharedPreferences] so it survives restarts and never leaves the
/// device. Distinct from the auto-read toggle — this only interrupts an
/// existing read, it never starts a turn.
final ValueNotifier<bool> bargeInEnabled = ValueNotifier(false);

/// Loads and persists [bargeInEnabled] on this device.
abstract final class BargeInPreferenceStore {
  static const storageKey = 'hermes_barge_in_enabled';

  static Future<void> load() async {
    try {
      final store = await SharedPreferences.getInstance();
      final value = store.getBool(storageKey);
      if (value != null) bargeInEnabled.value = value;
    } catch (_) {
      // A failed read must never block startup; the default stays in place.
    }
  }

  static Future<void> setEnabled(bool enabled) async {
    bargeInEnabled.value = enabled;
    try {
      final store = await SharedPreferences.getInstance();
      await store.setBool(storageKey, enabled);
    } catch (_) {
      // The live value already changed; persistence can retry on a later write.
    }
  }
}
