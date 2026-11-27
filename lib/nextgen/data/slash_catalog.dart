// The gateway's slash-command catalogue for the NextGen composer: it decides
// which typed `/command` is highlighted, described on tap and, on send, run
// on the gateway instead of going out as a prompt. Running a command is the
// chat controller's job; nothing here dispatches one.
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/models/slash_command.dart';
import '../../core/widgets/slash_command_highlight.dart';
import 'nextgen_gateway.dart';
import 'slash_exec.dart';

/// A cached, scoped `commands.catalog` reader for one composer.
///
/// Answers are cached per gateway (one connection) and per profile and live
/// session, since the server binds skills to the session's profile and
/// workspace. One request is in flight per scope; a failure leaves the
/// composer working with no highlight and is retried no sooner than
/// [retryAfter], on the next typed slash. A reconnect marks cached answers
/// stale so a restarted gateway's new commands appear.
class NgSlashCatalog extends ChangeNotifier {
  NgSlashCatalog({this.retryAfter = const Duration(seconds: 30)});

  final Duration retryAfter;

  static final Expando<Map<String, _NgCatalogEntry>> _cache = Expando(
    'nextgen slash catalogue',
  );

  static final Expando<StreamSubscription<void>> _reconnects = Expando(
    'nextgen slash catalogue reconnects',
  );

  /// Forgets every cached answer for [gateway].
  @visibleForTesting
  static void clearCache(NextGenGateway gateway) => _cache[gateway] = null;

  /// The cache for [gateway]. A (re)connection may be a restarted gateway
  /// with new plugins or skills, so each one marks that gateway's answers
  /// stale: they keep highlighting until the next typed slash refetches.
  static Map<String, _NgCatalogEntry> _entriesFor(NextGenGateway gateway) {
    _reconnects[gateway] ??= gateway.reconnected.listen((_) {
      for (final entry
          in _cache[gateway]?.values ?? const <_NgCatalogEntry>[]) {
        entry
          ..stale = true
          ..failedAt = null;
      }
    });
    return _cache[gateway] ??= <String, _NgCatalogEntry>{};
  }

  NextGenGateway? _gateway;
  String? _sessionId;
  String _key = '';
  bool _disposed = false;

  /// The loaded lookup for the current scope, or null.
  SlashCommandLookup? get lookup => _entry?.lookup;

  /// The loaded commands for the current scope, in the gateway's order, or
  /// null before the catalogue loads. Skills carry the `Skills` category.
  List<SlashCommand>? get commands => _entry?.catalog?.commands;

  /// The loaded alias map (bare lower-case alias → canonical name).
  Map<String, String> get aliases => _entry?.aliases ?? const {};

  /// Whether a catalogue read for the current scope is in flight.
  bool get isLoading => _entry?.flight != null;

  _NgCatalogEntry? get _entry {
    final gateway = _gateway;
    return gateway == null ? null : _cache[gateway]?[_key];
  }

  /// Points this reader at [gateway] and the chat's live [sessionId].
  void scopeTo(NextGenGateway gateway, {String? sessionId}) {
    final key = '${gateway.profile ?? ''}\u0000${sessionId ?? ''}';
    if (identical(gateway, _gateway) && key == _key) return;
    final before = lookup;
    _gateway = gateway;
    _sessionId = sessionId;
    _key = key;
    if (!identical(before, lookup)) _notify();
  }

  /// Whether `slash.exec` is known to be missing on the current connection.
  bool get _execUnsupported {
    final gateway = _gateway;
    return gateway != null && ngSlashExecUnsupported(gateway.socket ?? gateway);
  }

  /// Highlights exactly what a send would run as a command, now:
  ///
  /// * NextGen's own `/new`, `/reset`, `/stop` and `/model` always, and
  ///   `/kanban` and `/bots`, which open a screen;
  /// * with a loaded catalogue, the names it knows (aliases via `canon`,
  ///   skills, plugin commands);
  /// * before it loads, or when it cannot, Classic's reviewed
  ///   [kSlashExecutableCommands] fallback;
  /// * nothing else once this connection said it has no `slash.exec`.
  SlashCommandTokenInfo? resolve(String name) {
    final bare = name.toLowerCase();
    final known = lookup?.resolve(name);
    if (kNgLocalSlashCommands.contains(bare)) {
      return known ?? SlashCommandTokenInfo(typed: name, canonical: bare);
    }
    if (kNgScreenSlashCommands[bare] case final description?) {
      return known ??
          SlashCommandTokenInfo(
            typed: name,
            canonical: bare,
            description: description,
          );
    }
    if (_execUnsupported) return null;
    if (lookup != null) return known;
    if (!kSlashExecutableCommands.contains(bare)) return null;
    return SlashCommandTokenInfo(
      typed: name,
      canonical: bare,
      detailsPending: true,
    );
  }

  /// Whether a sent `/name` runs on the gateway rather than going out as a
  /// prompt. The same rule as [resolve], after waiting up to [wait] for a
  /// catalogue that is loading (or stale after a reconnect): when it has
  /// not arrived by then, Classic's fallback set decides.
  Future<bool> runsOnGateway(
    String name, {
    Duration wait = kNgSlashCatalogWait,
  }) async {
    if (_execUnsupported) return false;
    try {
      await ensureLoaded().timeout(wait);
    } on TimeoutException {
      // Decide with what is known now; the load carries on for next time.
    }
    if (_disposed) return false;
    return resolve(name) != null;
  }

  /// Loads the catalogue for the current scope unless it is cached, loading,
  /// or failed recently.
  Future<void> ensureLoaded() {
    final gateway = _gateway;
    // Offline is not a failure: the next typed slash after connecting asks.
    if (gateway == null || _disposed || !gateway.state.isConnected) {
      return Future<void>.value();
    }
    final entry = _entriesFor(gateway)[_key] ??= _NgCatalogEntry();
    final flight = entry.flight;
    if (flight != null) return flight;
    final failedAt = entry.failedAt;
    if ((entry.lookup != null && !entry.stale) ||
        (failedAt != null &&
            DateTime.now().difference(failedAt) < retryAfter)) {
      return Future<void>.value();
    }
    final done = Completer<void>();
    entry.flight = done.future;
    unawaited(_load(gateway, entry, _sessionId, done));
    return done.future;
  }

  Future<void> _load(
    NextGenGateway gateway,
    _NgCatalogEntry entry,
    String? sessionId,
    Completer<void> done,
  ) async {
    try {
      // The socket adds the connection's profile to every call; a live
      // session also binds the server to its workspace's skills.
      final result = await gateway.call('commands.catalog', {
        'session_id': ?sessionId,
      });
      entry
        ..lookup = SlashCommandLookup.fromCatalogResult(result)
        ..catalog = SlashCommandCatalog.fromResult(result)
        ..aliases = _aliasesOf(result)
        ..stale = false
        ..failedAt = null;
    } catch (_) {
      entry.failedAt = DateTime.now();
    } finally {
      entry.flight = null;
      done.complete();
      _notify();
    }
  }

  /// `canon` without its identity rows: `{bg: background}`.
  static Map<String, String> _aliasesOf(Object? result) {
    final canon = result is Map ? result['canon'] : null;
    if (canon is! Map) return const {};
    String bare(Object? v) => v is String
        ? v.trim().replaceFirst(RegExp(r'^/+'), '').toLowerCase()
        : '';
    return {
      for (final entry in canon.entries)
        if (bare(entry.key).isNotEmpty &&
            bare(entry.value).isNotEmpty &&
            bare(entry.key) != bare(entry.value) &&
            !bare(entry.key).contains(RegExp(r'[\s/]')))
          bare(entry.key): bare(entry.value),
    };
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _NgCatalogEntry {
  SlashCommandLookup? lookup;
  SlashCommandCatalog? catalog;
  Map<String, String> aliases = const {};

  /// Loaded before the latest reconnect: still shown, refetched on demand.
  bool stale = false;
  Future<void>? flight;
  DateTime? failedAt;
}
