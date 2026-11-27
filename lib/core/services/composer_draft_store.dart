import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// An unavailable read is not evidence that a draft is absent. Keep provider
/// details out of this public error, including paths and stored values.
class ComposerDraftReadException implements Exception {
  const ComposerDraftReadException();

  @override
  String toString() => 'Composer draft is unavailable.';
}

/// A route's write authority, independent of its composer edit revision. A
/// replacement route owns later writes; disposing the old route cannot erase
/// the replacement's draft. This handle contains no widget or callback.
class ComposerDraftHandle {
  final String connectionId;
  final String sessionId;
  final int _owner;
  final String? recoveryScope;
  final bool _deviceLocal;

  ComposerDraftHandle._(
    this.connectionId,
    this.sessionId,
    this._owner,
    this.recoveryScope,
    this._deviceLocal,
  );

  /// An explicit edit may take ownership back, including a deliberate clear.
  void edited() => ComposerDraftStore._claim(this);

  Future<bool> ownsLease() => ComposerDraftStore._serialized(
    (prefs) async =>
        ComposerDraftStore._owners[ComposerDraftStore._resolve(
          prefs,
          connectionId,
          sessionId,
        )] ==
        _owner,
  ).catchError((Object _) => false);

  /// Transfer only a participating lease after a verified durable alias. This
  /// does not manufacture user intent or reclaim an unrelated newer writer.
  Future<void> handoffFrom(
    Iterable<ComposerDraftHandle> participants, {
    required String canonicalSessionId,
    required bool Function() isCurrent,
  }) => ComposerDraftStore._serialized((prefs) async {
    if (!isCurrent()) return;
    final key = ComposerDraftStore._resolve(prefs, connectionId, sessionId);
    final canonical = ComposerDraftStore._resolve(
      prefs,
      connectionId,
      canonicalSessionId,
    );
    if (key != canonical) return; // failed alias publication is not a handoff
    final owner = ComposerDraftStore._owners[key];
    if (participants.any(
      (handle) => handle.connectionId == connectionId && handle._owner == owner,
    )) {
      ComposerDraftStore._owners[key] = _owner;
    }
  }).catchError((Object _) {});

  Future<void> save(String text, {bool Function()? isCurrent}) =>
      ComposerDraftStore._save(
        connectionId: connectionId,
        sessionId: sessionId,
        text: text,
        owner: _owner,
        recoveryScope: recoveryScope,
        deviceLocal: _deviceLocal,
        isCurrent: isCurrent,
      );
}

/// Connection-scoped composer drafts and durable local -> stored aliases.
/// All reads, writes, and alias migrations share one physical queue, including
/// writes from an old route during replacement. Empty strings are tombstones:
/// an intentional canonical clear must not resurrect an older local draft.
abstract final class ComposerDraftStore {
  static const _prefix = 'composer_draft';
  static const _aliasPrefix = 'composer_draft_alias';
  static const _writtenPrefix = 'composer_draft_written';
  static const _recoveryPrefix = 'composer_draft_recovery';
  static const _heldPrefix = 'client_held_queue';

  // The slash disambiguates this client-only namespace from a server ID.
  static String newLocalKey() => 'local-draft/${const Uuid().v4()}';
  static bool isLocalKey(String id) => RegExp(
    r'^local-draft/[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$',
  ).hasMatch(id);

  static Future<void>? _tail;
  static int _nextOwner = 0;
  static final Map<String, int> _owners = {};
  static SharedPreferences? _ownerPreferences;

  static String _key(String connectionId, String sessionId) {
    final namespace = base64Url
        .encode(utf8.encode('$connectionId\u0000$sessionId'))
        .replaceAll('=', '');
    return '$_prefix.$namespace';
  }

  static String _aliasKey(String key) =>
      '$_aliasPrefix.${key.substring(_prefix.length + 1)}';

  static String _resolve(
    SharedPreferences prefs,
    String connectionId,
    String sessionId,
  ) {
    var key = _key(connectionId, sessionId);
    final seen = <String>{};
    while (seen.add(key)) {
      final target = prefs.getString(_aliasKey(key));
      if (target == null) return key;
      key = _key(connectionId, target);
    }
    throw StateError('Cyclic composer draft alias.');
  }

  static Future<T> _serialized<T>(
    Future<T> Function(SharedPreferences) action,
  ) {
    Future<T> perform() async {
      final prefs = await SharedPreferences.getInstance();
      if (!identical(_ownerPreferences, prefs)) {
        _owners.clear();
        _ownerPreferences = prefs;
      }
      return action(prefs);
    }

    final previous = _tail;
    final flight = previous == null
        ? perform()
        : previous.then((_) => perform());
    final tail = flight.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    _tail = tail;
    tail.whenComplete(() {
      if (identical(_tail, tail)) _tail = null;
    }).ignore();
    return flight;
  }

  static ComposerDraftHandle open({
    required String connectionId,
    required String sessionId,
    String? recoveryScope,
    bool deviceLocal = false,
  }) {
    final handle = ComposerDraftHandle._(
      connectionId,
      sessionId,
      ++_nextOwner,
      recoveryScope,
      deviceLocal,
    );
    _claim(handle);
    return handle;
  }

  static void _claim(ComposerDraftHandle handle) {
    _serialized((prefs) async {
      _owners[_resolve(prefs, handle.connectionId, handle.sessionId)] =
          handle._owner;
    }).ignore();
  }

  /// Copy before publishing the alias, with best-effort physical rollback.
  /// Existing canonical text/clear wins; retain the public legacy source copy.
  /// This shares the same physical queue and writer ownership as normal saves.
  static Future<void> bind({
    required String connectionId,
    required String localSessionId,
    required String storedSessionId,
    bool Function()? isCurrent,
  }) async {
    try {
      await _serialized((prefs) async {
        // Activity/WAL reloads can roll back the speculative cache during a
        // draft write. Join draft writes, then read the physical source,
        // canonical value and clear marker before migrating.
        await prefs.reload();
        if (isCurrent?.call() == false) return;
        final local = _resolve(prefs, connectionId, localSessionId);
        final stored = _resolve(prefs, connectionId, storedSessionId);
        if (local == stored) return;
        final targetMarker = _writtenKey(stored);
        final aliasKey = _aliasKey(local);
        final oldAlias = prefs.getString(aliasKey);
        final oldText = prefs.getString(stored);
        final oldMarker = prefs.getBool(targetMarker);
        final canonicalExists = oldText != null || oldMarker == true;
        var copied = false;
        try {
          if (!canonicalExists) {
            final draft = prefs.getString(local);
            if (draft != null || prefs.getBool(_writtenKey(local)) == true) {
              await _write(prefs, stored, draft ?? '');
              copied = true;
              await _restoreValue(
                prefs,
                _recoveryKey(stored),
                prefs
                    .getString(_recoveryKey(local))
                    ?.replaceFirst(RegExp(r':local$'), ''),
              );
            }
          }
          if (isCurrent?.call() == false ||
              !await prefs.setString(aliasKey, storedSessionId)) {
            throw StateError('Composer draft alias was not committed.');
          }
        } catch (_) {
          await _restoreValue(prefs, aliasKey, oldAlias);
          await prefs.reload();
          // A physically committed alias after ACK loss and rejected rollback
          // retains its copied target AND joins the same ownership handoff.
          if (prefs.getString(aliasKey) != storedSessionId) {
            if (copied) {
              await _restoreValue(prefs, stored, oldText);
              await _restoreValue(prefs, targetMarker, oldMarker);
            }
            await prefs.reload();
            return;
          }
        }
        // Never let an old local checkpoint/rejection steal a canonical draft.
        // Only an explicit later edit can claim this shared lease again.
        _owners[stored] ??= canonicalExists ? 0 : _owners[local] ?? 0;
        _owners.remove(local);
        final targetHeld = _heldStorageKey(stored);
        if (prefs.getString(targetHeld) == null) {
          final held = prefs.getString(_heldStorageKey(local));
          if (held != null && held.isNotEmpty) {
            await prefs.setString(targetHeld, held);
          }
        }
      });
    } catch (_) {
      // Best-effort; the untouched source remains available to retry migration.
    }
  }

  /// Returns null only after successfully observing no nonempty draft. Throws
  /// [ComposerDraftReadException] if storage or alias resolution is unavailable.
  static Future<String?> read({
    required String connectionId,
    required String sessionId,
    String? expectedScope,
  }) async {
    try {
      return await _serialized((prefs) async {
        // Remount hydration must observe physical drafts, not a process-wide
        // cache that an older unrelated reload may have replaced during save.
        await prefs.reload();
        final key = _resolve(prefs, connectionId, sessionId);
        final value = prefs.getString(key);
        if (expectedScope != null && value != null) {
          final proof = _proof(expectedScope, value);
          final stamp = prefs.getString(_recoveryKey(key));
          if (stamp != proof && stamp != '$proof:local') return null;
        }
        return (value == null || value.isEmpty) ? null : value;
      });
    } catch (_) {
      throw const ComposerDraftReadException();
    }
  }

  static Future<void> save({
    required String connectionId,
    required String sessionId,
    required String text,
    bool Function()? isCurrent,
  }) => _save(
    connectionId: connectionId,
    sessionId: sessionId,
    text: text,
    isCurrent: isCurrent,
  );

  static Future<void> _save({
    required String connectionId,
    required String sessionId,
    required String text,
    int? owner,
    String? recoveryScope,
    bool deviceLocal = false,
    bool Function()? isCurrent,
  }) async {
    try {
      await _serialized((prefs) async {
        if (isCurrent?.call() == false) return;
        final key = _resolve(prefs, connectionId, sessionId);
        if (owner != null && _owners[key] != owner) return;
        if (owner == null) _owners[key] = 0;
        await _write(prefs, key, text);
        // Cross-chat discovery requires provenance that exact-chat legacy
        // reads never recorded. Bind the proof to these exact bytes so a
        // failed/partial publication cannot lend an old scope to new text.
        if (recoveryScope != null && text.isNotEmpty) {
          final local = deviceLocal && key == _key(connectionId, sessionId);
          final proof = _proof(recoveryScope, text);
          await prefs.setString(
            _recoveryKey(key),
            local ? '$proof:local' : proof,
          );
        } else if (prefs.containsKey(_recoveryKey(key))) {
          await prefs.remove(_recoveryKey(key));
        }
      });
    } catch (_) {
      // Best-effort: a failed save must never break the screen.
    }
  }

  static Future<void> _write(
    SharedPreferences prefs,
    String key,
    String text,
  ) async {
    // A clear is a deliberate value, even though the string entry is removed.
    // Without this marker, a delayed local alias migration can resurrect it.
    final marker = _writtenKey(key);
    final oldText = prefs.getString(key);
    final oldMarker = prefs.getBool(marker);
    try {
      // Whitespace may be the literal body of a recovered paste. Only an
      // explicit empty string is a clear; keep all nonempty draft bytes.
      final saved = text.isEmpty
          ? await prefs.remove(key)
          : await prefs.setString(key, text);
      if (!saved || !await prefs.setBool(marker, true)) {
        throw StateError('Composer draft write was rejected.');
      }
    } catch (_) {
      // SharedPreferences updates its cache even when the platform rejects a
      // write. Restore that cache as well as making a best-effort disk rollback.
      if (oldText == null) {
        await prefs.remove(key);
      } else {
        await prefs.setString(key, oldText);
      }
      if (oldMarker == null) {
        await prefs.remove(marker);
      } else {
        await prefs.setBool(marker, oldMarker);
      }
      rethrow;
    }
  }

  static String _writtenKey(String key) =>
      "$_writtenPrefix.${key.substring(_prefix.length + 1)}";

  static String _recoveryKey(String key) =>
      '$_recoveryPrefix.${key.substring(_prefix.length + 1)}';
  static String _proof(String scope, String text) =>
      '$scope:${sha256.convert(utf8.encode(text))}';

  /// Only canonical, nonempty drafts written under this account can cross
  /// into a different chat. A legacy unscoped draft remains in its own chat.
  static Future<List<String>> recoveryCandidates(ComposerDraftHandle target) =>
      _serialized((prefs) async {
        await prefs.reload();
        final scope = target.recoveryScope;
        if (scope == null) return [];
        final prefix = '${target.connectionId}\u0000';
        final excluded = _resolve(prefs, target.connectionId, target.sessionId);
        return [
          for (final key in prefs.getKeys())
            if (key.startsWith('$_prefix.') &&
                key != excluded &&
                prefs.getString(_aliasKey(key)) == null &&
                prefs.getString(_recoveryKey(key))?.startsWith('$scope:') ==
                    true)
              if (_decode(key, _prefix) case final value?)
                if (value.startsWith(prefix) &&
                    !value.substring(prefix.length).contains('\u0000'))
                  value.substring(prefix.length),
        ]..sort();
      });

  static Future<String?> recoveryText(
    ComposerDraftHandle target,
    String sourceId,
  ) => _serialized((prefs) async {
    await prefs.reload();
    final scope = target.recoveryScope;
    final targetKey = _resolve(prefs, target.connectionId, target.sessionId);
    final sourceKey = _key(target.connectionId, sourceId);
    if (scope == null ||
        targetKey == sourceKey ||
        _owners[targetKey] != target._owner ||
        prefs.containsKey(_aliasKey(sourceKey))) {
      return null;
    }
    final text = prefs.getString(sourceKey);
    if (text == null || text.isEmpty) return null;
    final proof = _proof(scope, text);
    // Never bypass a server lookup based on just the spelling of a stored ID.
    final expected = isLocalKey(sourceId) ? '$proof:local' : proof;
    return prefs.getString(_recoveryKey(sourceKey)) == expected ? text : null;
  });

  static Future<void> _restoreValue(
    SharedPreferences prefs,
    String key,
    Object? value,
  ) async {
    try {
      if (value == null) {
        await prefs.remove(key);
      } else if (value is String) {
        await prefs.setString(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      }
    } catch (_) {
      // Continue restoring the other transaction keys if one rollback fails.
    }
  }

  /// Clear through aliases too; retain a tombstone against stale migration.
  static Future<void> remove({
    required String connectionId,
    required String sessionId,
  }) async {
    await save(connectionId: connectionId, sessionId: sessionId, text: '');
    await saveHeldPrompts(
      connectionId: connectionId,
      sessionId: sessionId,
      texts: const [],
    );
  }

  /// Prompt texts only. Same owner and session resolution as a draft. No
  /// credentials and no attachments.
  static Future<List<String>> readHeldPrompts({
    required String connectionId,
    required String sessionId,
  }) async {
    try {
      return await _serialized((prefs) async {
        await prefs.reload();
        final raw = prefs.getString(
          _heldStorageKey(_resolve(prefs, connectionId, sessionId)),
        );
        if (raw == null || raw.isEmpty) return const <String>[];
        final decoded = jsonDecode(raw);
        if (decoded is! List) return const <String>[];
        return [
          for (final item in decoded)
            if (item is String && item.trim().isNotEmpty) item,
        ];
      });
    } catch (_) {
      return const <String>[];
    }
  }

  static Future<void> saveHeldPrompts({
    required String connectionId,
    required String sessionId,
    required List<String> texts,
  }) async {
    try {
      await _serialized((prefs) async {
        final key = _heldStorageKey(_resolve(prefs, connectionId, sessionId));
        final body = [
          for (final text in texts)
            if (text.trim().isNotEmpty) text,
        ];
        if (body.isEmpty) {
          if (prefs.containsKey(key)) await prefs.remove(key);
          return;
        }
        final saved = await prefs.setString(key, jsonEncode(body));
        if (!saved) {
          throw StateError('Client-held queue write was rejected.');
        }
      });
    } catch (_) {
      // Best-effort, same as a draft save.
    }
  }

  static String _heldStorageKey(String resolvedDraftKey) =>
      '$_heldPrefix.${resolvedDraftKey.substring(_prefix.length + 1)}';

  /// Drops every draft and alias for this connection only.
  static Future<void> removeConnection(String connectionId) async {
    try {
      await _serialized((prefs) async {
        final marker = '$connectionId\u0000';
        for (final key in prefs.getKeys()) {
          final prefix = key.startsWith('$_prefix.')
              ? _prefix
              : key.startsWith('$_aliasPrefix.')
              ? _aliasPrefix
              : key.startsWith('$_writtenPrefix.')
              ? _writtenPrefix
              : key.startsWith('$_recoveryPrefix.')
              ? _recoveryPrefix
              : key.startsWith('$_heldPrefix.')
              ? _heldPrefix
              : null;
          if (prefix == null) continue;
          final decoded = _decode(key, prefix);
          if (decoded != null && decoded.startsWith(marker)) {
            await prefs.remove(key);
            _owners.remove(key);
          }
        }
      });
    } catch (_) {
      // Best-effort.
    }
  }

  static String? _decode(String key, String prefix) {
    final encoded = key.substring(prefix.length + 1);
    try {
      return utf8.decode(base64Url.decode(base64Url.normalize(encoded)));
    } catch (_) {
      return null;
    }
  }
}
