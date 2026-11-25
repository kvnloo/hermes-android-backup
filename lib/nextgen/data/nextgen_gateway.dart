// One signed-in gateway for NextGen: its REST client and one authenticated
// `/api/ws` JSON-RPC connection kept alive with a fresh single-use ticket per
// attempt, exponential backoff, and terminal states for an expired sign-in or
// a Host/Origin guard rejection.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/connection_manager.dart';
import '../../core/services/dashboard_api_client.dart';
import '../../core/services/desktop_gateway_client.dart';
import '../../core/services/hermes_sign_in.dart';
import '../../core/services/ws_client.dart';
import '../nextgen_l10n.dart';
import 'nextgen_projects.dart';

enum NgConnectionPhase {
  idle,
  connecting,
  connected,
  reconnecting,
  sessionExpired,
  failed,
}

@immutable
class NgConnectionState {
  final NgConnectionPhase phase;
  final int attempt;
  final DateTime? retryAt;
  final String? reason;
  const NgConnectionState(
    this.phase, {
    this.attempt = 0,
    this.retryAt,
    this.reason,
  });

  bool get isConnected => phase == NgConnectionPhase.connected;

  String get label => switch (phase) {
    NgConnectionPhase.idle => ngL.ng_offline,
    NgConnectionPhase.connecting => ngL.ng_connecting,
    NgConnectionPhase.connected => ngL.ng_connected,
    NgConnectionPhase.reconnecting => ngL.ng_reconnecting,
    NgConnectionPhase.sessionExpired => ngL.ng_signed_out,
    NgConnectionPhase.failed => ngL.ng_connection_failed,
  };
}

/// A server→client request (approval, clarify, sudo, secret…) routed to the
/// chat whose runtime session it names.
class NgServerRequest {
  final GatewayServerRequest raw;
  final String? sessionId;
  NgServerRequest(this.raw) : sessionId = raw.params['session_id']?.toString();

  String get id => raw.id;
  String get method => raw.method;
  Map<String, dynamic> get params => raw.params;
}

class NextGenGateway extends ChangeNotifier {
  NextGenGateway(this.connection, {DashboardClient? dashboard})
    : url = GatewayUrl.parse(
        connection.singleLoginUrl ??
            DesktopGatewayClient.normalizedGatewayBaseUrl(connection),
      ),
      dashboard = dashboard ?? DashboardClient.fromConnection(connection) {
    // NextGen reads chats from the dashboard for every connection, so stored
    // ids always match the ones its `/api/ws` socket resumes.
    api = DashboardApiClient.withDashboard(this.dashboard, profile: profile);
    writes = DashboardSessionWrites(this.dashboard, profile: profile);
  }

  NgProjects? _projects;

  NgProjects projects(SharedPreferences preferences) =>
      _projects ??= NgProjects(this, preferences);

  final SavedConnection connection;
  final GatewayUrl url;
  final DashboardClient dashboard;

  /// Session/history REST surface (dashboard-backed for single sign-in).
  /// Assignable so tests can serve history pages.
  late DashboardApiClient api;
  late final DashboardSessionWrites writes;

  String? get profile {
    final p = connection.gatewayProfile?.trim();
    return p == null || p.isEmpty ? null : p;
  }

  NgConnectionState _state = const NgConnectionState(NgConnectionPhase.idle);
  NgConnectionState get state => _state;

  WsClient? _ws;
  WsClient? get socket => _ws;
  Map<String, dynamic>? readyFrame;
  bool get sessionAuthority =>
      WsClient.readyFrameHasSessionAuthority(readyFrame);

  final _events = StreamController<StreamEvent>.broadcast();
  final _requests = StreamController<NgServerRequest>.broadcast();
  final _reconnected = StreamController<void>.broadcast();
  final _withdrawn = StreamController<String>.broadcast();

  /// Every server event on the current socket.
  Stream<StreamEvent> get events => _events.stream;

  /// Server→client requests on the current socket.
  Stream<NgServerRequest> get serverRequests => _requests.stream;

  /// Fires after each successful (re)connection, so open chats can resume.
  Stream<void> get reconnected => _reconnected.stream;

  /// Requests not yet answered, by id, so a chat opened later still sees them.
  final Map<String, NgServerRequest> openRequests = {};

  /// Live session id → stored session id, for every chat opened on this
  /// socket, so the sidebar can tell which stored chats are waiting on you.
  final Map<String, String> _storedByRuntime = {};

  void bindRuntime(String runtimeId, String storedId) {
    if (_storedByRuntime[runtimeId] == storedId) return;
    _storedByRuntime[runtimeId] = storedId;
    if (!_disposed) notifyListeners();
  }

  /// The stored session behind live session [runtimeId], when known.
  String? storedIdFor(String runtimeId) => _storedByRuntime[runtimeId];

  /// Stored ids of chats blocked on an approval, question or secret.
  Set<String> get needsYou => {
    for (final r in openRequests.values)
      if (r.sessionId != null) _storedByRuntime[r.sessionId!] ?? r.sessionId!,
  };

  /// Requests a dropped socket took with it, by id → live session id. A
  /// dropped connection is no answer: the server may still wait on each, so
  /// its notification stays up until a redelivery confirms it, or a
  /// `request.cancel` or an authoritative read settles it.
  final Map<String, String> _dropped = {};
  static const _maxDropped = 64;

  /// The socket is gone: its requests can no longer be answered on it.
  void _forgetSocket() {
    _ws = null;
    _rememberDropped();
    openRequests.clear();
    _storedByRuntime.clear();
  }

  /// Drops the socket as a lost connection does (tests only).
  @visibleForTesting
  void debugDropSocket() {
    _forgetSocket();
    if (!_disposed) notifyListeners();
  }

  void _rememberDropped() {
    for (final entry in openRequests.entries) {
      final sid = entry.value.sessionId;
      if (sid != null) _dropped[entry.key] = sid;
    }
    while (_dropped.length > _maxDropped) {
      _dropped.remove(_dropped.keys.first);
    }
  }

  /// Whether [id] may still be waiting for an answer: open on this socket,
  /// or open on a dropped one and not settled since.
  bool awaitsAnswer(String id) =>
      openRequests.containsKey(id) || _dropped.containsKey(id);

  /// Marks [id] answered (or cancelled) and tells listeners.
  void resolveRequest(String id) {
    final open = openRequests.remove(id) != null;
    final dropped = _dropped.remove(id) != null;
    if (!open && !dropped) return;
    if (!_withdrawn.isClosed) _withdrawn.add(id);
    if (open && !_disposed) notifyListeners();
  }

  /// Ids of requests answered, withdrawn by the server, or found settled by
  /// an authoritative read: a chat showing one takes its card down.
  Stream<String> get withdrawnRequests => _withdrawn.stream;

  /// Ids of the cached requests (open, or taken by a dropped socket) that
  /// belong to any of [sessionIds] (runtime or stored ids). Capture this
  /// before an authoritative read so a request that arrives while the read is
  /// in flight is never mistaken for settled.
  Set<String> openRequestIdsFor(Iterable<String?> sessionIds) {
    final ids = sessionIds.whereType<String>().toSet();
    if (ids.isEmpty) return const {};
    return {
      for (final entry in openRequests.entries)
        if (_belongsTo(entry.value.sessionId, ids)) entry.key,
      for (final entry in _dropped.entries)
        if (_belongsTo(entry.value, ids)) entry.key,
    };
  }

  bool _belongsTo(String? sid, Set<String> sessionIds) {
    if (sid == null) return false;
    return sessionIds.contains(sid) ||
        sessionIds.contains(_storedByRuntime[sid]);
  }

  /// Applies the server's authoritative `open_requests` for one session (a
  /// `session.resume` or `session.events.since` reply): every request in
  /// [known] (cached when the read started) that the server no longer lists
  /// was settled — answered on another device, timed out or withdrawn — and
  /// is dropped; the listed ones are (re)delivered. A reply without the list
  /// ([open] not a List) says nothing and changes nothing. Never answers
  /// anything.
  void reconcileOpenRequests(Object? open, {required Set<String> known}) {
    if (open is! List) return;
    _dropUnlisted(open, known);
    if (open.isNotEmpty) socket?.deliverOpenRequests(open);
  }

  void _dropUnlisted(Object? open, Set<String> known) {
    if (open is! List) return;
    final listed = {
      for (final raw in open)
        if (raw is Map && raw['id'] is String) raw['id'] as String,
    };
    for (final id in known) {
      if (!listed.contains(id)) resolveRequest(id);
    }
  }

  /// Re-reads which cached requests the server still has open and drops the
  /// rest. Needed for the legacy sidecar gateway only: when another client
  /// answers, it settles the request without telling the other viewers
  /// (`tui_gateway/server_requests.py` sends `request.cancel` only for a
  /// timeout or withdrawal). A session-authority gateway always withdraws a
  /// settled request with `request.cancel reason: resolved` to every attached
  /// viewer, and its `session.events.since` moves this connection's replay
  /// cursor, so it is not probed. A failed read leaves the cache as it is.
  Future<void> revalidateOpenRequests({Set<String>? sessions}) async {
    if (_disposed || sessionAuthority) return;
    final bySession = <String, Set<String>>{};
    void add(String id, String? sid) {
      if (sid == null || (sessions != null && !sessions.contains(sid))) return;
      bySession.putIfAbsent(sid, () => <String>{}).add(id);
    }

    for (final entry in openRequests.entries) {
      add(entry.key, entry.value.sessionId);
    }
    for (final entry in _dropped.entries) {
      add(entry.key, entry.value);
    }
    await Future.wait([
      for (final entry in bySession.entries)
        _revalidateSession(entry.key, entry.value),
    ]);
  }

  /// Larger than any event seq, so the read carries `open_requests` and no
  /// replayed events.
  static const _probeLastSeen = 9007199254740991;

  Future<void> _revalidateSession(String sessionId, Set<String> known) async {
    final inFlight = _probing[sessionId];
    if (inFlight != null) return inFlight;
    final probe = () async {
      try {
        final reply = await call('session.events.since', {
          'session_id': sessionId,
          'last_seen': _probeLastSeen,
        }, timeout: const Duration(seconds: 10));
        if (_disposed) return;
        final open = reply['open_requests'];
        _dropUnlisted(open, known);
        if (open is List) {
          // A dropped socket's request the server still waits on is
          // answerable again on this one.
          final restore = [
            for (final raw in open)
              if (raw is Map && _dropped.containsKey(raw['id'])) raw,
          ];
          if (restore.isNotEmpty) socket?.deliverOpenRequests(restore);
        }
      } catch (_) {
        // Unknown: keep what the socket delivered.
      }
    }();
    _probing[sessionId] = probe;
    try {
      await probe;
    } finally {
      if (identical(_probing[sessionId], probe)) _probing.remove(sessionId);
    }
  }

  final Map<String, Future<void>> _probing = {};
  final Map<String, Timer> _activityProbes = {};

  /// Every server event on the socket, before chats see it. A withdrawal is
  /// applied here for every session — not only the one whose chat is open —
  /// so the needs-you highlight and notifications follow it. On the legacy
  /// gateway, activity in a session parked on a request (the agent carried
  /// on: someone answered elsewhere) re-reads that session's open requests.
  void _onSocketEvent(StreamEvent event) {
    if (event.type == 'request.cancel') {
      final id = (event.data['id'] ?? event.data['request_id'])?.toString();
      if (id != null && id.isNotEmpty) resolveRequest(id);
    } else {
      _scheduleActivityProbe(event.sessionId);
    }
    if (!_events.isClosed) _events.add(event);
  }

  void _scheduleActivityProbe(String? sessionId) {
    if (sessionId == null || _disposed || sessionAuthority) return;
    if (_activityProbes.containsKey(sessionId)) return;
    if (!openRequests.values.any((r) => r.sessionId == sessionId) &&
        !_dropped.containsValue(sessionId)) {
      return;
    }
    _activityProbes[sessionId] = Timer(const Duration(seconds: 1), () {
      _activityProbes.remove(sessionId);
      unawaited(revalidateOpenRequests(sessions: {sessionId}));
    });
  }

  bool _running = false;
  bool _disposed = false;
  int _attempt = 0;
  int _ticketRejections = 0;
  Completer<void>? _wake;
  final _connectionWaits = <Completer<WsClient>>{};
  DateTime? _connectedAt;

  static const _backoff = [1, 2, 4, 8, 16, 30];
  static const answerableMethods = {
    'approval',
    'clarify',
    'sudo',
    'secret',
    'vault.unlock_prompt',
    'vault.code',
    'vault.save_login',
  };

  void _set(NgConnectionState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Starts keeping the socket alive. Safe to call repeatedly.
  void start() {
    if (_running || _disposed) return;
    _running = true;
    unawaited(_loop());
  }

  /// Skips the current backoff wait, or restarts after a failure.
  void retry() {
    if (!_running) {
      _attempt = 0;
      _ticketRejections = 0;
      start();
      return;
    }
    final wake = _wake;
    if (wake != null && !wake.isCompleted) wake.complete();
  }

  Future<String?> _mintTicket() async {
    final res = await dashboard.apiRequest('POST', 'auth/ws-ticket');
    if (res.statusCode == 401) {
      _set(const NgConnectionState(NgConnectionPhase.sessionExpired));
      _running = false;
      return null;
    }
    if (res.statusCode == 429) {
      throw _Retry(ngL.ng_rate_limited_by_gateway);
    }
    if (res.statusCode != 200) {
      throw _Retry(
        ngL.ng_couldn_t_open_the_chat_connection(dashboardErrorMessage(res)),
      );
    }
    final data = jsonDecode(res.body);
    final ticket = data is Map ? data['ticket'] : null;
    if (ticket is! String || ticket.isEmpty) {
      throw _Retry(ngL.ng_the_gateway_returned_no_websocket_ticket);
    }
    return ticket;
  }

  Future<void> _loop() async {
    while (_running && !_disposed) {
      _attempt++;
      _set(NgConnectionState(NgConnectionPhase.connecting, attempt: _attempt));
      WsClient? client;
      try {
        String? ticket;
        try {
          ticket = await _mintTicket();
        } on DashboardHttpException catch (e) {
          if (e.statusCode == 401) {
            _set(const NgConnectionState(NgConnectionPhase.sessionExpired));
            _running = false;
            return;
          }
          rethrow;
        }
        if (ticket == null || !_running || _disposed) return;
        client = WsClient(
          dashboard.baseUrl,
          ticket: ticket,
          profile: profile,
          clientCertificate: connection.clientCertificate,
          ticketInSubprotocol: true,
        );
        final closed = Completer<void>();
        client.onStreamEvent = _onSocketEvent;
        client.onServerRequest = acceptServerRequest;
        client.onConnectionClosed = () {
          if (!closed.isCompleted) closed.complete();
        };
        await client.connect();
        final ready = await client.waitForGatewayReady();
        if (!_running || _disposed) {
          client.close();
          return;
        }
        readyFrame = ready;
        _ws = client;
        _connectedAt = DateTime.now();
        _ticketRejections = 0;
        _set(const NgConnectionState(NgConnectionPhase.connected));
        if (!_reconnected.isClosed) _reconnected.add(null);
        // Requests the last socket took with it: ask which are still open.
        if (_dropped.isNotEmpty) {
          unawaited(revalidateOpenRequests(sessions: {..._dropped.values}));
        }
        await closed.future;
        _forgetSocket();
        if (!_running || _disposed) return;
        final held =
            _connectedAt != null &&
            DateTime.now().difference(_connectedAt!) >
                const Duration(seconds: 30);
        if (held) _attempt = 0;
        await _backoffWait(ngL.ng_connection_lost);
      } on _Retry catch (e) {
        client?.close();
        if (!_running || _disposed) return;
        await _backoffWait(e.message);
      } catch (e) {
        client?.close();
        _ws = null;
        if (!_running || _disposed) return;
        final message = e.toString();
        final status = RegExp(
          r"(?:status code:? |HTTP |')(\d{3})",
        ).firstMatch(message)?.group(1);
        if (status == '404') {
          _fail(ngL.ng_this_dashboard_has_no_chat_endpoint_2);
          return;
        }
        if (status == '403' || message.contains('4403')) {
          if (++_ticketRejections > 2) {
            _fail(ngL.ng_the_gateway_refused_the_chat_connection_2);
            return;
          }
        }
        if (message.contains('4401')) {
          if (++_ticketRejections > 2) {
            _set(const NgConnectionState(NgConnectionPhase.sessionExpired));
            _running = false;
            return;
          }
        }
        await _backoffWait(_short(message));
      }
    }
  }

  void _fail(String reason) {
    _running = false;
    _set(NgConnectionState(NgConnectionPhase.failed, reason: reason));
  }

  static String _short(String message) {
    final clean = message
        .replaceFirst('Exception: ', '')
        .replaceFirst(RegExp(r'^JsonRpcError\([^)]*\): '), '');
    return clean.length > 160 ? '${clean.substring(0, 160)}…' : clean;
  }

  Future<void> _backoffWait(String reason) async {
    if (!_running || _disposed) return;
    final seconds = _backoff[(_attempt - 1).clamp(0, _backoff.length - 1)];
    final retryAt = DateTime.now().add(Duration(seconds: seconds));
    _set(
      NgConnectionState(
        NgConnectionPhase.reconnecting,
        attempt: _attempt,
        retryAt: retryAt,
        reason: reason,
      ),
    );
    final wake = _wake = Completer<void>();
    final timer = Timer(Duration(seconds: seconds), () {
      if (!wake.isCompleted) wake.complete();
    });
    try {
      await wake.future;
    } finally {
      timer.cancel();
    }
  }

  /// Sends one JSON-RPC call on the live socket and returns its `result`.
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final ws = _ws;
    if (ws == null || !ws.isConnected) {
      throw StateError('Not connected to the gateway yet.');
    }
    final response = await ws.send(method, params, timeout: timeout);
    final error = response['error'];
    if (error != null) {
      throw JsonRpcError.fromGateway(
        method,
        error is Map ? error : const {},
        fallbackMessage: ngL.ng_the_gateway_refused(method),
      );
    }
    final result = response['result'];
    return result is Map<String, dynamic>
        ? result
        : result is Map
        ? Map<String, dynamic>.from(result)
        : <String, dynamic>{};
  }

  /// Waits until connected (or gives up after [timeout]).
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final ws = _ws;
    if (ws != null && ws.isConnected) return ws;
    start();
    retry();
    if (_disposed) {
      throw StateError(ngL.ng_the_gateway_connection_dropped_try_again);
    }
    final done = Completer<WsClient>();
    _connectionWaits.add(done);
    void check() {
      final current = _ws;
      if (current != null && current.isConnected && !done.isCompleted) {
        done.complete(current);
      } else if ((_state.phase == NgConnectionPhase.sessionExpired ||
              _state.phase == NgConnectionPhase.failed) &&
          !done.isCompleted) {
        done.completeError(StateError(_state.reason ?? _state.label));
      }
    }

    addListener(check);
    check();
    try {
      return await done.future.timeout(timeout);
    } on TimeoutException {
      throw StateError(_state.reason ?? "Couldn't reach the gateway.");
    } finally {
      _connectionWaits.remove(done);
      removeListener(check);
    }
  }

  void forgetRequest(String id) => resolveRequest(id);

  /// Takes a request the socket delivered (live or replayed); false when this
  /// client cannot answer its method.
  @visibleForTesting
  bool acceptServerRequest(GatewayServerRequest request) {
    if (!answerableMethods.contains(request.method)) return false;
    final wrapped = NgServerRequest(request);
    _dropped.remove(request.id); // still open: redelivered on this socket
    openRequests[request.id] = wrapped;
    if (!_requests.isClosed) _requests.add(wrapped);
    if (!_disposed) notifyListeners();
    return true;
  }

  /// Feeds a server event as if it arrived on the socket.
  @visibleForTesting
  void debugEmit(StreamEvent event) => _onSocketEvent(event);

  /// Feeds a server request as if it arrived on the socket.
  @visibleForTesting
  void debugRequest(GatewayServerRequest request) {
    final wrapped = NgServerRequest(request);
    _dropped.remove(request.id);
    openRequests[request.id] = wrapped;
    _requests.add(wrapped);
    notifyListeners();
  }

  void stop() {
    _running = false;
    for (final pending in _connectionWaits.toList()) {
      if (!pending.isCompleted) {
        pending.completeError(
          StateError(ngL.ng_the_gateway_connection_dropped_try_again),
        );
      }
    }
    final wake = _wake;
    if (wake != null && !wake.isCompleted) wake.complete();
    _ws?.close();
    _ws = null;
    _set(const NgConnectionState(NgConnectionPhase.idle));
  }

  @override
  void dispose() {
    _projects?.close();
    stop();
    _disposed = true;
    for (final timer in _activityProbes.values) {
      timer.cancel();
    }
    _activityProbes.clear();
    _events.close();
    _requests.close();
    _reconnected.close();
    _withdrawn.close();
    api.close();
    dashboard.close();
    super.dispose();
  }
}

class _Retry implements Exception {
  final String message;
  const _Retry(this.message);
}
