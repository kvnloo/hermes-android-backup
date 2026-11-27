import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Per-process ordering for the one on-disk Windows activation ledger. All
/// sinks and saved-account transactions must participate, not just one window.
abstract final class WindowsToastLedger {
  static const key = 'windows_toast_tickets_v1';
  static Future<void>? _tail;

  static Future<T> serialized<T>(Future<T> Function() action) async {
    final previous = _tail;
    final release = Completer<void>();
    _tail = release.future;
    try {
      if (previous != null) await previous;
      return await action();
    } finally {
      if (identical(_tail, release.future)) _tail = null;
      release.complete();
    }
  }

  /// Commit revocation *before* any saved-account data changes. Restoring an
  /// old credential value must never bring its original tickets back to life.
  static Future<void> revokeConnections(Iterable<String> changed) {
    final ids = changed.toSet();
    return serialized(() async {
      if (ids.isEmpty) return;
      final prefs = await SharedPreferences.getInstance();
      // An unacknowledged setString may have changed the preferences cache.
      await prefs.reload();
      final raw = prefs.getString(key);
      if (raw == null) return;
      final entries = jsonDecode(raw) as Map<String, dynamic>;
      final count = entries.length;
      entries.removeWhere((_, row) {
        if (row is! Map) return true;
        final target = row['target'];
        return target is Map && ids.contains(target['connection']);
      });
      if (entries.length == count) return;
      if (!await prefs.setString(key, jsonEncode(entries))) {
        throw StateError('Windows notification revocation failed');
      }
    });
  }
}
