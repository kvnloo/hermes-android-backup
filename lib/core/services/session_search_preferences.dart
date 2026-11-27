import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/connection.dart';

/// Consent belongs to one saved connection AND its exact profile selector.
/// A structured, versioned identity cannot collide on separators or reuse the
/// old gateway-wide key. No legacy grant is migrated: the inspected Desktop
/// search hook has no equivalent consent migration, so each scope opts in anew.
String sessionSearchIdentity(SavedConnection connection) {
  final scope = [
    connection.id,
    connection.baseUrl,
    connection.gatewayPrefix,
    connection.desktopGatewayUrl,
    connection.dashboardPrefix,
    connection.dashboardPort,
    connection.gatewayProfile,
  ];
  return 'v2:${jsonEncode(scope)}';
}

/// How the session list search bar resolves a query.
enum SessionSearchMode {
  /// Filter the already-loaded session list on the device. Matches titles,
  /// previews, and model names only — no network call, no message bodies.
  local,

  /// Ask the dashboard's `GET /api/sessions/search` endpoint, which runs an
  /// FTS5 full-text query across stored message content and returns snippets.
  server,

  /// First ask a selected inexpensive model to rewrite a natural-language
  /// question into a focused FTS5 query, then run the same server search.
  ai,
}

extension SessionSearchModeCodec on SessionSearchMode {
  String get storageValue => switch (this) {
    SessionSearchMode.local => 'local',
    SessionSearchMode.server => 'server',
    SessionSearchMode.ai => 'ai',
  };

  static SessionSearchMode fromStorage(String? raw) {
    return switch (raw?.trim()) {
      'server' => SessionSearchMode.server,
      'ai' => SessionSearchMode.ai,
      _ => SessionSearchMode.local,
    };
  }
}

/// Model selected for the inexpensive natural-language query rewrite.
class AiSearchModel {
  final String provider;
  final String model;

  const AiSearchModel({required this.provider, required this.model});

  bool get isRecommended => model.toLowerCase().contains('gpt-oss-20b');

  /// Returns configured provider/model pairs, with the inexpensive GPT-OSS
  /// recommendation first and all other choices sorted predictably.
  static List<AiSearchModel> configuredFromOptions(
    Map<String, dynamic> options,
  ) {
    final choices = <AiSearchModel>[];
    final providers = options['providers'];
    if (providers is List) {
      for (final rawProvider in providers.whereType<Map>()) {
        if (rawProvider['authenticated'] != true) continue;
        final provider = rawProvider['slug']?.toString().trim() ?? '';
        final models = rawProvider['models'];
        if (provider.isEmpty || models is! List) continue;
        for (final rawModel in models) {
          final model = rawModel?.toString().trim() ?? '';
          if (model.isNotEmpty) {
            choices.add(AiSearchModel(provider: provider, model: model));
          }
        }
      }
    }
    choices.sort((a, b) {
      final byRecommendation = (b.isRecommended ? 1 : 0).compareTo(
        a.isRecommended ? 1 : 0,
      );
      if (byRecommendation != 0) return byRecommendation;
      final byProvider = a.provider.compareTo(b.provider);
      return byProvider != 0 ? byProvider : a.model.compareTo(b.model);
    });
    return choices;
  }
}

/// Persists search choices per saved connection and profile.
///
/// [SessionSearchMode.local] stays the default. Versioned scoped identities
/// deliberately leave legacy gateway-wide choices behind rather than granting
/// access to another profile on upgrade.
class SessionSearchPreferences {
  static const _prefix = 'session_search';
  static final _modeChanges =
      StreamController<({String identity, SessionSearchMode mode})>.broadcast(
        sync: true,
      );

  // Share ordering across retained/replacement browsers addressing one scope.
  // Remove settled tails so a completed widget-test zone is never retained.
  static final _modeWrites = <String, Future<void>>{};
  static final _failedModes = <String>{};

  final SharedPreferences _preferences;

  SessionSearchPreferences(this._preferences);

  static Future<SessionSearchPreferences> open() async {
    return SessionSearchPreferences(await SharedPreferences.getInstance());
  }

  SessionSearchMode readMode({required String connectionIdentity}) {
    if (_modeWrites.containsKey(connectionIdentity) ||
        _failedModes.contains(connectionIdentity)) {
      return SessionSearchMode.local;
    }
    return SessionSearchModeCodec.fromStorage(switch (_preferences.get(
      _key(connectionIdentity, 'mode'),
    )) {
      String value => value,
      _ => null,
    });
  }

  Future<void> saveMode({
    required String connectionIdentity,
    required SessionSearchMode mode,
    bool Function()? maySave,
  }) {
    if (maySave?.call() == false) return Future<void>.value();
    final key = _key(connectionIdentity, 'mode');
    final previous = _modeWrites[connectionIdentity];
    final ready = previous == null
        ? Future<void>.value()
        : previous.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    late final Future<void> operation;
    operation = ready
        .then((_) async {
          if (maySave?.call() == false) return;
          try {
            // A legacy preference reload replaces the entire cache. Establish the
            // baseline inside this key's queue, never before acquiring its turn.
            await _preferences.reload();
            if (maySave?.call() == false) return;
            if (!await _preferences.setString(key, mode.storageValue)) {
              throw StateError('Search mode was not saved.');
            }
            // A completed write is not yet an accepted grant. Recheck both after
            // the write and after exact physical readback. A departed prompt can
            // only retract its own captured key, never the newly selected scope.
            if (maySave?.call() != false) await _preferences.reload();
            if (maySave?.call() == false && mode != SessionSearchMode.local) {
              if (!await _preferences.setString(
                key,
                SessionSearchMode.local.storageValue,
              )) {
                throw StateError('Stale search mode could not be withdrawn.');
              }
              await _preferences.reload();
              if (_preferences.getString(key) !=
                  SessionSearchMode.local.storageValue) {
                throw StateError('Stale search mode could not be verified.');
              }
            } else if (_preferences.getString(key) != mode.storageValue) {
              throw StateError('Search mode could not be verified.');
            }
            _failedModes.remove(connectionIdentity);
          } catch (_) {
            // setString updates the cache before physical acknowledgement. Never
            // let a failed grant become authority for a retained/new browser.
            _failedModes.add(connectionIdentity);
            rethrow;
          }
        })
        .whenComplete(() {
          if (!identical(_modeWrites[connectionIdentity], operation)) return;
          _modeWrites.remove(connectionIdentity);
          _modeChanges.add((
            identity: connectionIdentity,
            mode: readMode(connectionIdentity: connectionIdentity),
          ));
        });
    _modeWrites[connectionIdentity] = operation;
    // Revoke before any await. Only confirmed readback can publish a grant.
    _modeChanges.add((
      identity: connectionIdentity,
      mode: SessionSearchMode.local,
    ));
    return operation;
  }

  AiSearchModel? readAiModel({required String connectionIdentity}) {
    final provider = _preferences.getString(
      _key(connectionIdentity, 'ai_provider'),
    );
    final model = _preferences.getString(_key(connectionIdentity, 'ai_model'));
    if (provider == null ||
        provider.trim().isEmpty ||
        model == null ||
        model.trim().isEmpty) {
      return null;
    }
    return AiSearchModel(provider: provider.trim(), model: model.trim());
  }

  Future<void> saveAiModel({
    required String connectionIdentity,
    required AiSearchModel selection,
  }) async {
    await Future.wait([
      _preferences.setString(
        _key(connectionIdentity, 'ai_provider'),
        selection.provider.trim(),
      ),
      _preferences.setString(
        _key(connectionIdentity, 'ai_model'),
        selection.model.trim(),
      ),
    ]);
  }

  Future<void> clear({required String connectionIdentity}) async {
    // Queue withdrawal behind an already-dispatched grant; direct removal can
    // otherwise finish first and be overwritten by its late acknowledgement.
    await saveMode(
      connectionIdentity: connectionIdentity,
      mode: SessionSearchMode.local,
    );
    await Future.wait([
      _preferences.remove(_key(connectionIdentity, 'ai_provider')),
      _preferences.remove(_key(connectionIdentity, 'ai_model')),
    ]);
  }

  /// Namespaces keys by connection so identical hosts across profiles cannot
  /// collide, without writing gateway URLs into preference key names.
  static String _key(String connectionIdentity, String field) {
    final namespace = Uri.encodeComponent(connectionIdentity);
    return '$_prefix.$namespace.$field';
  }
}

/// The active browsers offer literal dashboard search, not AI rewriting.
/// Only the explicit server mode authorizes sending the original query.
class SessionSearchAccess extends ValueNotifier<bool> {
  SessionSearchAccess(this._preferences, this._identity)
    : super(
        _preferences.readMode(connectionIdentity: _identity) ==
            SessionSearchMode.server,
      ) {
    _subscription = SessionSearchPreferences._modeChanges.stream.listen((
      change,
    ) {
      if (change.identity == _identity) {
        value = change.mode == SessionSearchMode.server;
      }
    });
  }

  final SessionSearchPreferences _preferences;
  final String _identity;
  late final StreamSubscription<({String identity, SessionSearchMode mode})>
  _subscription;
  bool _closed = false;

  String get identity => _identity;
  bool get isActive => !_closed;

  Future<void> setServer(bool enabled) async {
    if (_closed) return;
    await _preferences.saveMode(
      connectionIdentity: _identity,
      mode: enabled ? SessionSearchMode.server : SessionSearchMode.local,
      // Withdrawal is durable even when the user leaves immediately. Only a
      // new grant requires the original prompt/browser to remain current.
      maySave: enabled ? () => !_closed : null,
    );
  }

  @override
  void dispose() {
    if (_closed) return;
    _closed = true;
    _subscription.cancel();
    super.dispose();
  }
}
