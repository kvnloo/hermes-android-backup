// WebSocket client for the Hermes gateway JSON-RPC API (/api/ws).
// Supports both request-response calls AND server-pushed streaming events.
//
// Wire protocol: newline-delimited JSON-RPC 2.0, same as the TUI gateway.
// After submitting a prompt, the server pushes stream events and finally
// a JSON-RPC response with the same id.
import 'dart:async';

import 'preview_peer.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/client_certificate.dart';
import '../models/slash_command.dart';
import 'canonical_wire.dart';
import 'gateway_headers.dart';
import 'hermes_sign_in.dart';
import 'tls_client_factory.dart';
import '../history/canonical_rewind.dart';
import '../history/rewind_submit.dart'
    show isRejectedDeepTruncatePayload, stripRejectedDeepTruncate;

Object? _deepFreezeJson(Object? value) {
  if (value is Map) {
    final copy = <String, dynamic>{};
    for (final entry in value.entries) {
      if (entry.key is! String) continue;
      copy[entry.key as String] = _deepFreezeJson(entry.value);
    }
    return Map<String, dynamic>.unmodifiable(copy);
  }
  if (value is List) {
    return List<dynamic>.unmodifiable(value.map(_deepFreezeJson));
  }
  return value;
}

Map<String, dynamic> _deepFreezeJsonMap(Map<String, dynamic> value) {
  return _deepFreezeJson(value)! as Map<String, dynamic>;
}

Object? _canonicalJsonValue(Object? value) {
  if (value is Map) {
    final keys = value.keys.whereType<String>().toList()..sort();
    return <String, dynamic>{
      for (final key in keys) key: _canonicalJsonValue(value[key]),
    };
  }
  if (value is List) return value.map(_canonicalJsonValue).toList();
  return value;
}

String _canonicalJson(Object? value) => jsonEncode(_canonicalJsonValue(value));

/// A JSON-RPC error response from the gateway.
class JsonRpcError implements Exception {
  final String method;
  final String message;
  final int? code;
  final String? reason;
  final Map<String, dynamic> data;

  JsonRpcError(
    this.method,
    this.message, {
    this.code,
    this.reason,
    Map<String, dynamic>? data,
  }) : data = _deepFreezeJsonMap(data ?? const <String, dynamic>{});

  factory JsonRpcError.fromGateway(
    String method,
    Map<dynamic, dynamic> error, {
    required String fallbackMessage,
  }) {
    final rawData = error['data'];
    final data = rawData is Map
        ? <String, dynamic>{
            for (final entry in rawData.entries)
              if (entry.key is String) entry.key as String: entry.value,
          }
        : const <String, dynamic>{};
    return JsonRpcError(
      method,
      error['message'] is String ? error['message'] as String : fallbackMessage,
      code: error['code'] is int ? error['code'] as int : null,
      reason: data['reason'] is String ? data['reason'] as String : null,
      data: data,
    );
  }

  /// Server guidance only. Callers must never automatically resubmit a turn.
  bool get safeToResubmit => data['safe_to_resubmit'] == true;

  @override
  String toString() => 'JsonRpcError($method): $message';
}

JsonRpcError _gatewayResponseError(
  String method,
  Object? error, {
  required String fallbackMessage,
}) {
  if (error is Map) {
    return JsonRpcError.fromGateway(
      method,
      error,
      fallbackMessage: fallbackMessage,
    );
  }
  return JsonRpcError(method, fallbackMessage);
}

/// Returns true when a legacy gateway rejects `submission_id` as an
/// unsupported parameter on `prompt.submit`, so the caller can retry once
/// without it.
bool isRejectedSubmissionIdError(JsonRpcError error) {
  // Defensive branch for fork/legacy gateways that refuse the parameter with
  // 4094. Stock pre-0.23 gateways answer 4000 with the field path (below);
  // 0.23+ answers 4001 without naming the field and is satisfied by the id.
  // Any such refusal means no turn started, so the one-shot retry is safe.
  if (error.code == 4094) return true;
  if (error.code != 4000 && error.code != -32602) return false;
  final lower = error.message.toLowerCase();
  return lower.contains('submission_id') &&
      (lower.contains('extra') ||
          lower.contains('not permitted') ||
          lower.contains('unexpected') ||
          lower.contains('unknown'));
}

/// Event types streamed from the gateway during a prompt submission.
class StreamEvent {
  final String type; // 'tool_call', 'tool_result', 'assistant', 'session', etc.
  final Map<String, dynamic> data;
  final bool isComplete; // true when the assistant message is done
  final String? sessionId;
  final String? turnId;
  final int? seq;
  final String? messageId;
  final Map<String, dynamic> envelope;

  StreamEvent({
    required this.type,
    required Map<String, dynamic> data,
    this.isComplete = false,
    this.sessionId,
    this.turnId,
    this.seq,
    this.messageId,
    Map<String, dynamic>? envelope,
  }) : data = _deepFreezeJsonMap(data),
       envelope = _deepFreezeJsonMap(envelope ?? const <String, dynamic>{});
}

/// Gateway-side file reference returned by `file.attach`.
class RemoteFileAttachment {
  final String name;
  final String path;
  final String refText;
  final bool uploaded;
  final bool? atlasIntakeAccepted;
  final String? atlasIntakeStatus;
  final String? atlasRelativePath;

  const RemoteFileAttachment({
    required this.name,
    required this.path,
    required this.refText,
    required this.uploaded,
    this.atlasIntakeAccepted,
    this.atlasIntakeStatus,
    this.atlasRelativePath,
  });
}

/// Both identities minted by the stock Hermes `session.create` contract.
///
/// The runtime id addresses calls on the current socket. The stored id is the
/// durable identity required by `session.resume` after that socket disconnects.
class CreatedGatewaySession {
  final String runtimeSessionId;
  final String storedSessionId;
  final bool hasEmptyHistory;

  const CreatedGatewaySession({
    required this.runtimeSessionId,
    required this.storedSessionId,
    this.hasEmptyHistory = false,
  });
}

/// Runtime binding and recovery state returned by `session.resume`.
///
/// Stock Hermes includes retained in-flight failure details here so a client
/// that missed the terminal event while disconnected can stop recovery and
/// surface the failure instead of polling history forever.
class ResumedGatewaySession {
  final String runtimeSessionId;
  final bool? running;
  final String? status;
  final Map<String, dynamic>? inflight;
  final List<dynamic> openRequests;

  /// Canonical session authority only (absent on legacy gateways): the
  /// session's current execution claim, which Stop and Steer must name.
  final int? executionGeneration;

  /// Canonical only: the snapshot's position in this session's own event
  /// stream (its SessionEvents epoch, not the `gateway.ready` epoch).
  final String? replayEpoch;
  final int? lastSequence;

  /// Canonical only: admissions not yet settled, as the owner lists them.
  final List<Map<String, dynamic>> pending;

  const ResumedGatewaySession({
    required this.runtimeSessionId,
    this.running,
    this.status,
    this.inflight,
    this.openRequests = const [],
    this.executionGeneration,
    this.replayEpoch,
    this.lastSequence,
    this.pending = const [],
  });
}

typedef StreamCallback = void Function(StreamEvent event);
typedef ConnectionCallback = void Function(bool connected);
typedef GatewayReadyCallback = void Function(Map<String, dynamic> frame);
typedef ServerRequestCallback = bool Function(GatewayServerRequest request);

/// A JSON-RPC request initiated by the Hermes gateway.
///
/// Unlike an `event` notification, this frame carries a string request ID and
/// must be answered with a JSON-RPC response carrying that same ID. The first
/// [respond] or [fail] call wins so a replayed card cannot answer twice.
class GatewayServerRequest {
  final String id;
  final String method;
  final Map<String, dynamic> params;
  final bool replayed;
  final bool Function(Map<String, dynamic> result) _respond;
  final bool Function(int code, String message) _fail;
  bool _settled = false;

  GatewayServerRequest._({
    required this.id,
    required this.method,
    required this.params,
    required this.replayed,
    required this._respond,
    required this._fail,
  });

  /// A request whose answers go to [respond]; for tests of the UI layers.
  @visibleForTesting
  factory GatewayServerRequest.forTesting({
    required String id,
    required String method,
    Map<String, dynamic> params = const {},
    bool Function(Map<String, dynamic> result)? respond,
  }) => GatewayServerRequest._(
    id: id,
    method: method,
    params: params,
    replayed: false,
    respond: respond ?? (_) => true,
    fail: (_, _) => true,
  );

  bool respond(Map<String, dynamic> result) {
    if (_settled) return false;
    if (!_respond(result)) return false;
    _settled = true;
    return true;
  }

  bool fail(int code, String message) {
    if (_settled) return false;
    if (!_fail(code, message)) return false;
    _settled = true;
    return true;
  }
}

/// dart:io WebSocket.connect opens a GET through customClient.openUrl. Never
/// forward its credential-bearing protocol/header set on an HTTP redirect.
final class _UpgradeClient implements HttpClient {
  _UpgradeClient(this.inner);
  final HttpClient inner;
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      (await inner.openUrl(method, url))..followRedirects = false;
  @override
  void close({bool force = false}) => inner.close(force: force);
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Not an upgrade operation');
}

/// A live binding observed on this exact socket, never a persisted locator.
final class WorkspaceRuntime {
  WorkspaceRuntime._(this.runtimeId, this.profile, this.cwd, this.backend);

  /// A binding for a fake socket in tests; a real one is only ever made by
  /// the socket that received the resume receipt.
  @visibleForTesting
  WorkspaceRuntime.forTest(
    this.runtimeId, {
    this.profile,
    this.cwd,
    this.backend,
  });
  final String runtimeId;
  final String? profile;
  final String? cwd;
  final String? backend;
}

/// WebSocket client for the Hermes JSON-RPC gateway.
class WsClient {
  final previewPeers = PreviewPeers();
  int get socketEpoch => _connectionGeneration;
  final _workspaceBindings = <String, WorkspaceRuntime>{};
  final _workspaceObservers = <void Function()>{};

  /// Invalidation only; observers never receive another profile's payload.
  void Function() observeWorkspaceBindings(void Function() changed) {
    _workspaceObservers.add(changed);
    return () => _workspaceObservers.remove(changed);
  }

  void _notifyWorkspaceBindings() {
    for (final changed in List.of(_workspaceObservers)) {
      try {
        changed();
      } catch (_) {
        /* Optional observers do not own RPC progress. */
      }
    }
  }

  // Retain per-socket fences even after close/rebinding: a delayed older
  // acknowledgement cannot resurrect authority cleared by the newer one.
  final _workspaceReceipt = <String, int>{};
  WorkspaceRuntime? workspaceBinding(String storedId) =>
      _workspaceBindings[storedId];

  /// Replace only the cwd of a binding this socket already holds, after a
  /// confirmed workspace mutate for that same stored session. A missing
  /// binding is left missing: this never invents authority.
  void adoptConfirmedWorkspaceCwd(String storedId, String cwd) {
    final old = _workspaceBindings[storedId];
    if (old == null || old.cwd == cwd) return;
    _workspaceBindings[storedId] = WorkspaceRuntime._(
      old.runtimeId,
      old.profile,
      cwd,
      old.backend,
    );
    _notifyWorkspaceBindings();
  }

  final String baseUrl;
  final String? _token;
  final String? _ticket;
  final String? _profile;
  WebSocketChannel? _channel;

  /// Test seam: dials the gateway socket in place of the platform
  /// WebSocket, so a test can put an in-memory gateway under the real
  /// transport. Null (always, outside tests) dials the platform socket.
  @visibleForTesting
  static WebSocketChannel Function(Uri uri)? debugDial;
  bool _connected = false;
  int _nextId = 1;
  int _connectionGeneration = 0;
  int _nextConnectionClosedListenerToken = 1;

  /// Pending requests: id -> (completer, timer).
  final Map<int, _Pending> _pending = {};

  /// Active stream subscriptions: id -> callback.
  final Map<int, List<StreamCallback>> _streams = {};

  /// Gateway events are emitted independently of a JSON-RPC request ID. Keep
  /// per-session listeners so one active session cannot consume another one's
  /// streamed response.
  final Map<String, List<StreamCallback>> _sessionStreams = {};

  /// An invalidation only: never pass an event's contents across profile
  /// boundaries on a multiplexed socket. Consumers read the scoped snapshot.
  void Function() observeQueueChanges(String session, void Function() changed) {
    final listeners = _sessionStreams.putIfAbsent(session, () => []);
    void notify(StreamEvent event) {
      if (event.type == 'session.info' && event.data['pending'] is List) {
        changed();
      }
    }

    listeners.add(notify);
    final close = _addConnectionClosedListener(changed);
    return () {
      _removeConnectionClosedListener(close);
      listeners.remove(notify);
      if (listeners.isEmpty && identical(listeners, _sessionStreams[session])) {
        _sessionStreams.remove(session);
      }
    };
  }

  /// Canonical session authority: the newest execution generation this
  /// socket admitted per runtime session (resume/create snapshot, submit
  /// receipt, or an event's stamp). Stop and Steer name it; it is never
  /// guessed or advanced to a claim the socket has not seen.
  final Map<String, int> _executionGenerations = {};

  /// The guard every request on a session-authority socket goes through
  /// ([send]): revisions, open prompts and unanswered edits of this socket.
  /// A new connection starts with none.
  late CanonicalWire _canonical = _newCanonicalWire();
  CanonicalWire _newCanonicalWire() =>
      CanonicalWire(generationFor: (id) => _executionGenerations[id]);

  /// The CAS revision this socket was last told for each session on the
  /// canonical session authority: a fenced mutation (rewind) presents it.
  final CanonicalSessionRevisions _sessionRevisions =
      CanonicalSessionRevisions();
  final Map<int, _ConnectionClosedListener> _connectionClosedListeners = {};
  Completer<Map<String, dynamic>>? _gatewayReadyCompleter;
  Map<String, dynamic>? _gatewayReadyFrame;
  String? _gatewayReadyCanonical;
  JsonRpcError? _gatewayReadyFailure;
  bool _serverRequestsAdvertised = false;
  bool _activityAccepted = false;
  bool get acceptsWindowActivity => _connected && _activityAccepted;

  /// Global stream listener (receives all untargeted events).
  StreamCallback? onStreamEvent;
  ServerRequestCallback? onServerRequest;

  /// Extra observers of every pushed event, beside the one [onStreamEvent]
  /// slot its owner (the chat) holds. App-level events such as
  /// `display.install.log` carry no session, so no session listener sees them.
  final List<StreamCallback> _eventTaps = [];

  /// Observes every pushed event until the returned function is called.
  void Function() watchEvents(StreamCallback listener) {
    _eventTaps.add(listener);
    return () => _eventTaps.remove(listener);
  }

  /// Handlers for one server→client request method, asked before
  /// [onServerRequest]: a screen that started an operation answers the
  /// prompt that operation raises (e.g. `display.install.sudo`).
  final Map<String, List<ServerRequestCallback>> _requestHandlers = {};

  /// Answers [method] requests until the returned function is called. The
  /// handler returns true once it has taken the request.
  void Function() handleServerRequests(
    String method,
    ServerRequestCallback handler,
  ) {
    _requestHandlers.putIfAbsent(method, () => []).add(handler);
    if (_connected) _advertiseServerRequestSupport();
    return () {
      final handlers = _requestHandlers[method];
      handlers?.remove(handler);
      if (handlers != null && handlers.isEmpty) _requestHandlers.remove(method);
    };
  }

  ConnectionCallback? onConnectionChanged;
  void Function()? onConnectionClosed;
  GatewayReadyCallback? onGatewayReady;

  factory WsClient(
    String baseUrl, {
    String? token,
    String? ticket,
    String? profile,
    ClientCertificateConfig? clientCertificate,
    Map<String, String> customHeaders = const <String, String>{},
    TlsClientFactory tlsClientFactory = const TlsClientFactory(),
    Duration heartbeatInterval = defaultHeartbeatInterval,
    Duration heartbeatDeadline = defaultHeartbeatDeadline,
    bool ticketInSubprotocol = false,
  }) {
    return WsClient._(
      baseUrl,
      token,
      ticket,
      profile,
      clientCertificate,
      normalizeRemoteHeaders(customHeaders),
      tlsClientFactory,
      heartbeatInterval,
      heartbeatDeadline,
      ticketInSubprotocol,
    );
  }

  WsClient._(
    this.baseUrl,
    this._token,
    this._ticket,
    this._profile,
    this._clientCertificate,
    this._customHeaders,
    this._tlsClientFactory,
    this.heartbeatInterval,
    this.heartbeatDeadline,
    this.ticketInSubprotocol,
  );

  /// Send the single-use ticket as the `hermes-gateway-ticket.<ticket>`
  /// subprotocol (as Hermes Desktop does) so it never lands in URLs or proxy
  /// logs. Gateways accept it there or as `?ticket=`.
  final bool ticketInSubprotocol;

  static const gatewayProtocol = 'hermes-gateway-v1';
  static const ticketProtocolPrefix = 'hermes-gateway-ticket.';

  final ClientCertificateConfig? _clientCertificate;
  final Map<String, String> _customHeaders;
  final TlsClientFactory _tlsClientFactory;

  /// Keepalive cadence mirroring the desktop client
  /// (`apps/shared/src/json-rpc-channel.ts` DEFAULT_HEARTBEAT_*): a
  /// `gateway.ping` every 15s, dead-socket verdict after 45s of silence.
  static const defaultHeartbeatInterval = Duration(seconds: 15);
  static const defaultHeartbeatDeadline = Duration(seconds: 45);

  final Duration heartbeatInterval;
  final Duration heartbeatDeadline;
  Timer? _heartbeatTimer;
  int _heartbeatSeq = 0;
  int _lastLivenessMs = 0;

  /// Connect to the WebSocket gateway.
  Future<void> connect() async {
    if (_connected) return;
    if (_channel != null) {
      throw StateError('A WebSocket connection is already in progress');
    }
    final generation = ++_connectionGeneration;
    _gatewayReadyFrame = null;
    _gatewayReadyCanonical = null;
    _gatewayReadyFailure = null;
    _serverRequestsAdvertised = false;
    _activityAccepted = false;
    final readyCompleter = Completer<Map<String, dynamic>>();
    _gatewayReadyCompleter = readyCompleter;
    // A transport can close before a caller starts waiting for gateway.ready.
    // Observe that error future immediately; the waiter still receives it.
    readyCompleter.future.ignore();
    final ticket = _ticket?.trim() ?? '';
    final useProtocol = ticketInSubprotocol && ticket.isNotEmpty;
    final wsUrl = useProtocol
        ? '${baseUrl.replaceFirst('http://', 'ws://').replaceFirst('https://', 'wss://')}/api/ws'
        : buildWebSocketUrl(baseUrl, token: _token, ticket: _ticket);
    final accessHeaders = HermesSignInVault.instance.accessHeadersFor(
      Uri.parse(wsUrl),
    );
    final upgradeHeaders = <String, String>{
      ..._customHeaders,
      ...accessHeaders,
    };
    // Ticket-bearing upgrades require a no-redirect client even without mTLS.
    // Preserve platform trust and the exact configured client identity.
    final customClient =
        useProtocol || _clientCertificate != null || upgradeHeaders.isNotEmpty
        ? _UpgradeClient(_tlsClientFactory.createHttpClient(_clientCertificate))
        : null;
    final dial = debugDial;
    final WebSocketChannel channel = dial != null
        ? dial(Uri.parse(wsUrl))
        : IOWebSocketChannel.connect(
            Uri.parse(wsUrl),
            customClient: customClient,
            headers: upgradeHeaders.isEmpty ? null : upgradeHeaders,
            protocols: useProtocol
                ? [gatewayProtocol, '$ticketProtocolPrefix$ticket']
                : null,
          );
    _channel = channel;
    channel.stream.listen(
      (message) => _handleMessage(message, generation),
      onError: (_) => _handleClosedConnection(generation),
      onDone: () {
        _handleClosedConnection(generation);
      },
    );
    try {
      await channel.ready.timeout(const Duration(seconds: 15));
      if (generation != _connectionGeneration || _channel != channel) {
        throw JsonRpcError(
          'connect',
          'Connection closed during WebSocket setup',
          reason: 'connection_closed',
        );
      }
      _connected = true;
      _startHeartbeat(generation);
      try {
        onConnectionChanged?.call(true);
      } catch (_) {
        // Transport observers cannot turn a live socket into setup failure.
      }
    } catch (_) {
      _handleClosedConnection(generation);
      try {
        await channel.sink.close();
      } catch (_) {
        // Preserve the original setup failure after closing this exact socket.
      }
      rethrow;
    } finally {
      // The upgraded socket has detached from this HTTP client.
      customClient?.close();
    }
  }

  void _handleClosedConnection(int generation) {
    if (generation != _connectionGeneration) return;
    // Invalidate this socket before any completion or observer can enqueue
    // more work. Buffered callbacks from it now fail the generation guard.
    _connectionGeneration = generation + 1;
    _stopHeartbeat();
    final wasConnected = _connected || _channel != null;
    _connected = false;
    _channel = null;
    _workspaceBindings.clear();
    _notifyWorkspaceBindings();
    previewPeers.clear();
    _workspaceReceipt.clear();
    // Reject all pending request-response calls.
    for (var entry in _pending.values) {
      entry.timer?.cancel();
      if (!entry.completer.isCompleted) {
        entry.completer.completeError(
          JsonRpcError(
            entry.method,
            'Desktop gateway connection closed',
            reason: 'connection_closed',
          ),
        );
      }
    }
    _pending.clear();
    final closeError =
        _gatewayReadyFailure ??
        JsonRpcError(
          'gateway.ready',
          'Connection closed before gateway.ready',
          reason: 'connection_closed',
        );
    _gatewayReadyFailure = closeError;
    _gatewayReadyFrame = null;
    _gatewayReadyCanonical = null;
    final ready = _gatewayReadyCompleter;
    if (ready != null && !ready.isCompleted) {
      ready.completeError(closeError);
    }
    _gatewayReadyCompleter = null;
    final listenersToNotify = _connectionClosedListeners.entries
        .where((entry) => entry.value.generation == generation)
        .map((entry) => entry.value.callback)
        .toList(growable: false);
    _connectionClosedListeners.removeWhere(
      (_, listener) => listener.generation == generation,
    );
    _streams.clear();
    _sessionStreams.clear();
    _executionGenerations.clear();
    _canonical = _newCanonicalWire();
    _sessionRevisions.clear();
    for (final listener in listenersToNotify) {
      try {
        listener();
      } catch (_) {
        // One watcher cannot prevent the remaining close cleanup.
      }
    }
    if (wasConnected) {
      try {
        onConnectionClosed?.call();
      } catch (_) {
        // Cleanup observers cannot keep a rejected socket logically active.
      }
      try {
        onConnectionChanged?.call(false);
      } catch (_) {
        // Observer failures cannot keep a rejected socket logically active.
      }
    }
  }

  int _addConnectionClosedListener(void Function() callback) {
    final token = _nextConnectionClosedListenerToken++;
    _connectionClosedListeners[token] = _ConnectionClosedListener(
      _connectionGeneration,
      callback,
    );
    return token;
  }

  void _removeConnectionClosedListener(int token) {
    _connectionClosedListeners.remove(token);
  }

  /// Keepalive loop mirroring the desktop `JsonRpcChannel.startHeartbeat`.
  /// Every [heartbeatInterval] sends a `gateway.ping` (answered cheaply on
  /// the gateway's WS reader thread, even while every agent is mid-turn);
  /// if nothing has been received for [heartbeatDeadline] the socket is
  /// declared half-open and torn down, which starts the owner's reconnect
  /// instead of leaving later RPCs parked on a dead pipe.
  void _startHeartbeat(int generation) {
    _stopHeartbeat();
    if (heartbeatInterval.inMilliseconds <= 0 ||
        heartbeatDeadline.inMilliseconds <= 0) {
      return;
    }
    _lastLivenessMs = DateTime.now().millisecondsSinceEpoch;
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (_) {
      if (generation != _connectionGeneration || !_connected) return;
      final silenceMs = DateTime.now().millisecondsSinceEpoch - _lastLivenessMs;
      if (silenceMs >= heartbeatDeadline.inMilliseconds) {
        // Half-open socket (phone slept, NAT dropped the mapping, proxy
        // died): close it so the close path rejects pending calls and the
        // owner can reconnect on a fresh ticket. 4000 = private close
        // code (the channel rejects 1001).
        _channel?.sink.close(4000, 'heartbeat timeout');
        _handleClosedConnection(generation);
        return;
      }
      _heartbeatSeq++;
      try {
        _channel?.sink.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'id': 'heartbeat-$_heartbeatSeq',
            'method': 'gateway.ping',
            'params': <String, dynamic>{},
          }),
        );
      } catch (_) {
        _channel?.sink.close(4000, 'heartbeat send failed');
        _handleClosedConnection(generation);
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Produces the gateway `/api/ws` URL. Secured Desktop gateways use a
  /// single-use ticket; insecure legacy gateways still use a session token.
  static String buildWebSocketUrl(
    String baseUrl, {
    String? token,
    String? ticket,
  }) {
    final socketBase = baseUrl
        .replaceFirst('http://', 'ws://')
        .replaceFirst('https://', 'wss://');
    final uri = Uri.parse('$socketBase/api/ws');
    final credential = ticket?.trim().isNotEmpty == true
        ? {'ticket': ticket!.trim()}
        : token?.trim().isNotEmpty == true
        ? {'token': token!.trim()}
        : const <String, String>{};
    return uri.replace(queryParameters: credential).toString();
  }

  /// Adds the connection's Hermes profile to a JSON-RPC params map.
  ///
  /// A machine-level `hermes dashboard` / `hermes serve` hosts every profile
  /// on the machine and scopes each RPC by `params['profile']`
  /// (`_profile_db` / `_profile_scoped` on the server; `session.create` and
  /// `session.resume` store it on the session so later turns re-bind to that
  /// profile's home). The socket URL carries no profile. Hermes Desktop sends
  /// the field on every scoped request, so this does the same. A blank
  /// profile sends nothing and the server keeps its own default; a caller that
  /// already set `profile` wins.
  static Map<String, dynamic> withProfile(
    Map<String, dynamic> params,
    String? profile,
  ) {
    final name = profile?.trim() ?? '';
    if (name.isEmpty || params.containsKey('profile')) return params;
    return <String, dynamic>{...params, 'profile': name};
  }

  /// Handle inbound messages.
  void _handleMessage(dynamic msg, int generation) {
    if (generation != _connectionGeneration) return;
    // Any inbound frame proves the socket is alive ('any-inbound' liveness,
    // matching the desktop channel): streaming events keep the heartbeat
    // deadline reset even if the pong for one ping raced past it.
    _lastLivenessMs = DateTime.now().millisecondsSinceEpoch;
    try {
      Map<String, dynamic> data;
      if (msg is String) {
        data = jsonDecode(msg) as Map<String, dynamic>;
      } else if (msg is Map<String, dynamic>) {
        data = msg;
      } else {
        return;
      }

      final id = data['id'];
      final method = data['method'] as String?;
      final params = data['params'];

      // JSON-RPC is peer-to-peer. Hermes uses string IDs (`srq-...`) for
      // server→client requests so they cannot collide with our integer IDs.
      // Route these before the normal response path; treating them as an
      // unknown response silently drops clarify/approval/secret prompts.
      if (id is String && method != null && method != 'event') {
        _deliverServerRequest(
          id,
          method,
          params is Map<String, dynamic> ? params : const {},
        );
        return;
      }

      // Server-pushed events have the JSON-RPC method `event` and carry their
      // actual type/session/payload inside params.
      if (method == 'event' && id == null && params is Map<String, dynamic>) {
        if (params['type'] == 'gateway.ready') {
          _handleGatewayReady(data, generation);
          _advertiseServerRequestSupport();
          return;
        }
        final event = parseGatewayEvent(params);
        if (event != null) _dispatchEvent(event);
        return;
      }

      // Response to a request (has id, may have method for streaming completion)
      if (id != null) {
        final pending = _pending[id];
        if (pending != null) {
          _pending.remove(id);
          pending.timer?.cancel();
          if (method == null || params == null) {
            _streams.remove(id);
          }
          _noteSessionFences(pending, data);
          pending.completer.complete(data);
          // Internal request state is terminal before observers see the final
          // stream event. Observer failures cannot retain a pending request.
          if (method != null && params != null) {
            _dispatchStreamEvent(
              id,
              method,
              params is Map<String, dynamic> ? params : {},
            );
          }
          return;
        }
      }
    } catch (_) {
      // Ignore parse errors
    }
  }

  void _advertiseServerRequestSupport() {
    // Never claim support unless this socket can actually route the requests.
    // A recovery socket without a handler would otherwise make the gateway
    // send prompts that this client immediately rejects with -32601.
    if (_serverRequestsAdvertised ||
        (onServerRequest == null && _requestHandlers.isEmpty)) {
      return;
    }
    _serverRequestsAdvertised = true;
    // This method is connection-scoped, not profile-scoped. Older gateways
    // answer -32601; deliberately ignore that response so they keep working.
    final generation = _connectionGeneration;
    unawaited(
      send('client.capabilities', const {
        'server_requests': true,
      }, includeProfile: false).then<void>((reply) {
        if (_connectionGeneration == generation) {
          _activityAccepted = switch (reply['result']) {
            {'client_activity': true} => true,
            _ => false,
          };
        }
      }, onError: (_, _) {}),
    );
  }

  /// Whether a view took the request.
  bool _deliverServerRequest(
    String id,
    String method,
    Map<String, dynamic> params, {
    bool replayed = false,
  }) {
    // A canonical approval or question is not a request frame: the owner
    // published it as an event and takes its answer as `approval.respond` /
    // `clarify.respond`. It cannot be failed either: other viewers may still
    // answer it.
    final prompt = sessionAuthority && _canonical.holdsPrompt(id);
    final request = GatewayServerRequest._(
      id: id,
      method: method,
      params: Map<String, dynamic>.from(params),
      replayed: replayed,
      respond: prompt
          ? (result) => _answerCanonicalPrompt(id, method, result)
          : (result) => _sendServerResponse(id, result: result),
      fail: prompt
          ? (_, _) => true
          : (code, message) => _sendServerResponse(
              id,
              error: {'code': code, 'message': message},
            ),
    );
    if (method == 'preview.read' || method == 'preview.act') {
      try {
        final answer = previewPeers.answer(method, params, replayed: replayed);
        if (answer != null) {
          request.respond(answer);
        } else {
          request.fail(-32601, 'No shared preview for this operation');
        }
      } catch (_) {
        request.fail(-32603, 'Preview unavailable');
      }
      return true;
    }
    for (final handler in List.of(_requestHandlers[method] ?? const [])) {
      try {
        if (handler(request)) return true;
      } catch (_) {
        // A scoped handler that throws leaves the request to the next one.
      }
    }
    final listener = onServerRequest;
    if (listener == null) {
      request.fail(-32601, 'no handler for server request: $method');
      return false;
    }
    try {
      if (!listener(request)) {
        request.fail(-32601, 'no handler for server request: $method');
        return false;
      }
      return true;
    } catch (_) {
      request.fail(-32603, 'server request handler crashed: $method');
      return false;
    }
  }

  /// Answers a canonical prompt a view was handed as a server request. The
  /// view's result is the legacy response body (`{choice}`, `{answer}` or a
  /// one-question `{answers}`); [send] turns it into the owner's contract.
  bool _answerCanonicalPrompt(
    String id,
    String kind,
    Map<String, dynamic> result,
  ) {
    if (!_connected || _channel == null) return false;
    final Map<String, dynamic> params;
    if (kind == 'approval') {
      final choice = result['choice'];
      params = {
        'prompt_id': id,
        'choice': choice is String && choice.isNotEmpty ? choice : 'deny',
      };
    } else {
      final answers = result['answers'];
      final answer =
          result['answer'] ??
          (answers is Map
              ? answers[id] ?? (answers.isEmpty ? null : answers.values.first)
              : null);
      params = {'prompt_id': id, 'answer': answer?.toString() ?? ''};
    }
    unawaited(
      send(
        kind == 'approval' ? 'approval.respond' : 'clarify.respond',
        params,
      ).then<void>((_) {}, onError: (_, _) {}),
    );
    return true;
  }

  /// Re-deliver unanswered requests returned by `session.resume` or event
  /// replay after the caller has restored its runtime-to-local session map.
  void deliverOpenRequests(Iterable<dynamic> snapshots) {
    for (final raw in snapshots) {
      if (raw is! Map) continue;
      final entry = Map<String, dynamic>.from(raw);
      final id = entry['id'];
      final method = entry['method'];
      final rawParams = entry['params'];
      if (id is! String || method is! String) continue;
      _deliverServerRequest(
        id,
        method,
        rawParams is Map ? Map<String, dynamic>.from(rawParams) : const {},
        replayed: true,
      );
    }
  }

  bool _sendServerResponse(
    String id, {
    Map<String, dynamic>? result,
    Map<String, dynamic>? error,
  }) {
    final channel = _channel;
    if (channel == null || channel.closeCode != null) return false;
    channel.sink.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'id': id,
        if (error != null) 'error': error else 'result': result ?? const {},
      }),
    );
    return true;
  }

  void _handleGatewayReady(Map<String, dynamic> data, int generation) {
    if (generation != _connectionGeneration) return;
    final frame = _deepFreezeJsonMap(data);
    final canonical = _canonicalJson(frame);
    final pinned = _gatewayReadyCanonical;
    if (pinned == null) {
      _gatewayReadyCanonical = canonical;
      _gatewayReadyFrame = frame;
      final ready = _gatewayReadyCompleter;
      if (ready != null && !ready.isCompleted) ready.complete(frame);
      try {
        onGatewayReady?.call(frame);
      } catch (_) {
        // Capability observers cannot change the pinned socket authority.
      }
      return;
    }
    if (pinned == canonical) return;

    _gatewayReadyFailure = JsonRpcError(
      'gateway.ready',
      'Gateway ready frame changed on the active connection',
      reason: 'gateway_ready_drift',
    );
    final channel = _channel;
    _handleClosedConnection(generation);
    channel?.sink.close();
  }

  /// Dispatch a server-pushed event to registered listeners.
  static StreamEvent? parseGatewayEvent(Map<String, dynamic> params) {
    final rawType = params['type'];
    if (rawType is! String || rawType.isEmpty) return null;
    final payload = params['payload'];
    final data = payload is Map<String, dynamic>
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{};
    final sessionCandidates = <Object?>[params['session_id'], params['sid']];
    String? sessionId;
    for (final candidate in sessionCandidates) {
      if (candidate is String &&
          candidate.isNotEmpty &&
          candidate.length <= 256 &&
          candidate.trim() == candidate &&
          !candidate.codeUnits.any(
            (unit) => unit < 32 || unit >= 127 && unit <= 159,
          )) {
        sessionId = candidate;
        break;
      }
    }
    if (sessionId != null && sessionId.isNotEmpty) {
      data['session_id'] = sessionId;
    }
    final rawTurnId = params['turn_id'];
    final rawSeq = params['seq'];
    final rawMessageId = params['message_id'];
    final turnId =
        rawTurnId is String &&
            rawTurnId.isNotEmpty &&
            rawTurnId.length <= 256 &&
            rawTurnId.trim() == rawTurnId &&
            !rawTurnId.codeUnits.any(
              (unit) => unit < 32 || unit >= 127 && unit <= 159,
            )
        ? rawTurnId
        : null;
    final messageId =
        rawMessageId is String &&
            rawMessageId.isNotEmpty &&
            rawMessageId.length <= 256 &&
            rawMessageId.trim() == rawMessageId &&
            !rawMessageId.codeUnits.any(
              (unit) => unit < 32 || unit >= 127 && unit <= 159,
            )
        ? rawMessageId
        : null;
    return StreamEvent(
      type: rawType,
      data: data,
      isComplete:
          rawType == 'message.complete' ||
          rawType == 'error' ||
          rawType == 'turn.end' ||
          rawType == 'turn.error',
      sessionId: sessionId,
      turnId: turnId,
      seq: rawSeq is int && rawSeq > 0 ? rawSeq : null,
      messageId: messageId,
      envelope: params,
    );
  }

  /// Whether a `gateway.ready` frame advertises the canonical session
  /// authority (Hermes 0.23+). The gateway nests the flag inside the ready
  /// frame's `params.payload`; a top-level read never matches the real wire
  /// (#291).
  static bool readyFrameHasSessionAuthority(Map<String, dynamic>? frame) {
    final params = frame?['params'];
    final payload = params is Map<String, dynamic> ? params['payload'] : null;
    return payload is Map<String, dynamic> &&
        payload['session_authority'] == true;
  }

  /// Whether this socket's gateway routes session RPCs through the canonical
  /// session authority (Hermes 0.23+). Its params models forbid legacy-only
  /// keys (`inline_images` on resume) and enum values (`source: 'desktop'`
  /// on create), so callers must send the canonical shapes instead (#291).
  bool get sessionAuthority =>
      readyFrameHasSessionAuthority(_gatewayReadyFrame);

  /// Wait for the capability-bearing greeting emitted by this exact socket.
  Future<Map<String, dynamic>> waitForGatewayReady({
    Duration timeout = const Duration(seconds: 15),
  }) {
    final failure = _gatewayReadyFailure;
    if (failure != null) return Future<Map<String, dynamic>>.error(failure);
    final frame = _gatewayReadyFrame;
    if (frame != null) return Future<Map<String, dynamic>>.value(frame);
    final ready = _gatewayReadyCompleter;
    if (ready == null) {
      throw StateError('connect must run before waiting for gateway.ready');
    }
    return ready.future.timeout(timeout);
  }

  /// An independent observer, never a replacement for the active turn reader.
  void Function() watchSessionEvents(
    String runtimeId,
    StreamCallback listener,
  ) {
    final list = _sessionStreams.putIfAbsent(runtimeId, () => []);
    list.add(listener);
    return () {
      list.remove(listener);
      if (list.isEmpty && identical(_sessionStreams[runtimeId], list)) {
        _sessionStreams.remove(runtimeId);
      }
    };
  }

  void _dispatchEvent(StreamEvent event) {
    _noteExecutionGeneration(
      event.sessionId,
      event.envelope['execution_generation'],
    );
    _sessionRevisions.noteEvent(event.type, event.sessionId, event.data);
    if (sessionAuthority) {
      final canonical = _canonical;
      canonical.noteEvent(event.type, event.sessionId, event.data);
      // The owner publishes an approval or a question as an event carrying
      // its prompt id. Both layouts already show the legacy server request
      // of the same kind, so hand them that (as Hermes Desktop projects it)
      // and answer by prompt id.
      final prompt = onServerRequest == null
          ? null
          : canonical.adoptPromptEvent(
              event.type,
              event.sessionId,
              event.data,
              event.envelope['execution_generation'],
            );
      if (prompt != null) {
        _noteExecutionGeneration(
          event.sessionId,
          event.data['execution_generation'],
        );
        if (_deliverServerRequest(prompt.id, prompt.method, prompt.params)) {
          return;
        }
      }
      final settled = canonical.settlePromptEvent(event.type, event.data);
      if (settled != null) {
        _dispatchToListeners(event);
        // Answered here or by another viewer: the card comes down.
        _dispatchToListeners(
          StreamEvent(
            type: 'request.cancel',
            data: {
              'id': settled,
              'request_id': settled,
              'reason': 'resolved',
              'session_id': ?event.sessionId,
            },
            sessionId: event.sessionId,
            envelope: event.envelope,
          ),
        );
        return;
      }
    }
    _dispatchToListeners(event);
  }

  void _dispatchToListeners(StreamEvent event) {
    try {
      onStreamEvent?.call(event);
    } catch (_) {
      // Global observers cannot block the session-scoped listener chain.
    }
    for (final tap in List.of(_eventTaps)) {
      try {
        tap(event);
      } catch (_) {
        // Nor can one tap block another.
      }
    }
    final sessionId = event.sessionId;
    if (sessionId == null || sessionId.isEmpty) return;
    final listeners = _sessionStreams[sessionId];
    if (listeners == null) return;
    for (final listener in List<StreamCallback>.from(listeners)) {
      try {
        listener(event);
      } catch (_) {
        // One session observer cannot block other listeners or cleanup.
      }
    }
  }

  /// The execution generation this socket last admitted for [sessionId] on
  /// the canonical session authority, or null when none was seen.
  int? executionGenerationFor(String sessionId) =>
      _executionGenerations[sessionId];

  void _noteExecutionGeneration(String? sessionId, Object? value) {
    if (sessionId == null || sessionId.isEmpty || value is! int) return;
    final known = _executionGenerations[sessionId];
    if (known == null || value > known) {
      _executionGenerations[sessionId] = value;
    }
  }

  /// The revision this socket was last told for [sessionId] on the canonical
  /// session authority, or null when none was seen.
  int? sessionRevisionFor(String sessionId) => _sessionRevisions.of(sessionId);

  /// A reply's fences: a snapshot or receipt names the session's revision,
  /// and a fence refusal names the owner's current revision and generation
  /// (Desktop's `CanonicalDesktopProtocol.result` / `failure`).
  void _noteSessionFences(_Pending pending, Map<String, dynamic> reply) {
    final result = reply['result'];
    _sessionRevisions.noteResult(pending.method, result);
    if (result is Map) {
      // A snapshot or receipt names its session and the execution it
      // belongs to; an admission receipt names the session in `ref`. A
      // caller that sends these verbs raw (NextGen) learns them here.
      final ref = result['ref'];
      final sessionId =
          result['session_id'] ?? (ref is Map ? ref['session_id'] : null);
      if (sessionId is String) {
        _noteExecutionGeneration(sessionId, result['execution_generation']);
      }
    }
    final error = reply['error'];
    final data = error is Map ? error['data'] : null;
    if (data is! Map || !isFenceRefusal(data)) return;
    _sessionRevisions.noteRefusal(pending.sessionId, data);
    _noteExecutionGeneration(pending.sessionId, data['execution_generation']);
  }

  /// The generation a canonical Stop/Steer for [sessionId] must carry,
  /// captured before anything awaits; null on a legacy gateway, whose strict
  /// params refuse the key. A canonical socket that has admitted no
  /// generation for the session refuses locally rather than guess one.
  int? _controlGeneration(String method, String sessionId) {
    if (!sessionAuthority) return null;
    final generation = _executionGenerations[sessionId];
    if (generation == null) {
      throw JsonRpcError(
        method,
        'The running turn is not known yet.',
        reason: 'execution_generation_unknown',
      );
    }
    return generation;
  }

  /// Dispatch a streaming event to a specific request's subscribers.
  void _dispatchStreamEvent(int id, String type, Map<String, dynamic> data) {
    final listeners = _streams.remove(id);
    if (listeners == null) return;
    final event = StreamEvent(
      type: type,
      data: data,
      isComplete: type == 'done' || type == 'error',
    );
    for (final listener in List<StreamCallback>.from(listeners)) {
      try {
        listener(event);
      } catch (_) {
        // Stream observers run only after internal completion and cleanup.
      }
    }
  }

  /// Send a JSON-RPC method call and wait for response.
  ///
  /// On a session-authority socket a truncating `prompt.submit` (edit,
  /// regenerate, restore) is first split as Hermes Desktop's
  /// `canonicalRedirect` does: the owner's rewind, then the plain submit.
  /// Every other request goes through the canonical guard
  /// ([CanonicalWire]): a legacy shape the owner has a canonical form for
  /// is translated, and one it has none for is answered here with a
  /// [canonicalRefusalCode] error, never sent. A legacy socket sends
  /// [params] as given.
  Future<Map<String, dynamic>> send(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
    void Function()? onSent,
    bool includeProfile = true,
  }) {
    if (!sessionAuthority) {
      return _sendRequest(
        method,
        params,
        timeout: timeout,
        onSent: onSent,
        includeProfile: includeProfile,
      );
    }
    if (method == 'prompt.submit') {
      final RewindSubmitSplit? split;
      try {
        split = splitRewindSubmit(params);
      } on RewindTargetUnsaved {
        return Future.error(
          JsonRpcError(
            method,
            rewindTargetUnsavedMessage,
            reason: rewindTargetUnsavedReason,
          ),
        );
      }
      if (split != null) {
        return _sendRewindSubmit(
          split,
          timeout: timeout,
          onSent: onSent,
          includeProfile: includeProfile,
        );
      }
    }
    return _sendCanonical(
      method,
      params,
      timeout: timeout,
      onSent: onSent,
      includeProfile: includeProfile,
    );
  }

  Future<Map<String, dynamic>> _sendCanonical(
    String method,
    Map<String, dynamic> params, {
    required Duration timeout,
    required void Function()? onSent,
    required bool includeProfile,
  }) {
    if (!_connected || _channel == null) {
      return Future.error(Exception('Not connected'));
    }
    final canonical = _canonical;
    return canonical.run(
      method,
      params,
      // The caller's own request reports when it was written; a read the
      // guard adds first (the session's fences) does not.
      wire: (wireMethod, wireParams, {required bool own}) => _sendRequest(
        wireMethod,
        wireParams,
        timeout: timeout,
        onSent: own ? onSent : null,
        includeProfile: includeProfile,
      ),
      noteGeneration: _noteExecutionGeneration,
      // A replaced socket starts with no canonical state: an answer from
      // the old one is passed through untouched.
      current: () => identical(canonical, _canonical),
    );
  }

  /// Desktop's `canonicalRedirect` for a truncating submit: its
  /// `session.rewind` (on the wire a `session.mutate` with operation
  /// `rewind`, fenced by the session's revision and generation), then the
  /// submit without any truncation key. A refused rewind wrote nothing and
  /// is returned as the answer: the prompt is not submitted after it.
  Future<Map<String, dynamic>> _sendRewindSubmit(
    RewindSubmitSplit split, {
    required Duration timeout,
    required void Function()? onSent,
    required bool includeProfile,
  }) async {
    final rewind = split.rewind;
    if (rewind != null) {
      final sessionId = rewind['session_id'];
      final revision = sessionId is String
          ? _sessionRevisions.of(sessionId)
          : null;
      final generation = sessionId is String
          ? _executionGenerations[sessionId]
          : null;
      if (revision == null || generation == null) {
        // Never a guessed fence: the owner would refuse it, or worse, a
        // stale one could cut a transcript another viewer has moved on.
        throw JsonRpcError(
          'session.rewind',
          rewindFencesUnknownMessage,
          reason: rewindFencesUnknownReason,
        );
      }
      final cut = await _sendRequest(
        'session.mutate',
        rewindMutation(
          rewind,
          requestId: const Uuid().v4(),
          revision: revision,
          generation: generation,
        ),
        timeout: timeout,
        includeProfile: includeProfile,
      );
      if (cut['error'] != null) return cut;
    }
    // The plain submit still goes through the guard (it is identified
    // input on the owner: a submission id is added when missing).
    return _sendCanonical(
      'prompt.submit',
      split.submit,
      timeout: timeout,
      onSent: onSent,
      includeProfile: includeProfile,
    );
  }

  Future<Map<String, dynamic>> _sendRequest(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
    void Function()? onSent,
    bool includeProfile = true,
  }) async {
    if (!_connected || _channel == null) {
      throw Exception('Not connected');
    }

    final id = _nextId++;
    final completer = Completer<Map<String, dynamic>>();
    final generation = _connectionGeneration;
    final isBinding = method == 'session.create' || method == 'session.resume';
    final requestedId = params['session_id'];
    final requestedProfile =
        params['profile'] ?? (includeProfile ? _profile?.trim() : null);
    final timer = Timer(timeout, () {
      _pending.remove(id);
      if (!completer.isCompleted) {
        completer.completeError(JsonRpcError(method, 'Timeout'));
      }
    });

    _pending[id] = _Pending(
      method,
      completer,
      timer,
      sessionId: requestedId is String ? requestedId : null,
    );
    try {
      _channel!.sink.add(
        jsonEncode({
          'jsonrpc': '2.0',
          'method': method,
          'params': includeProfile ? withProfile(params, _profile) : params,
          'id': id,
        }),
      );
    } catch (_) {
      timer.cancel();
      _pending.remove(id);
      rethrow;
    }
    try {
      onSent?.call();
    } catch (_) {
      // A local observer must not turn a successfully emitted RPC into an
      // apparent transport failure.
    }
    if (!isBinding && method != 'session.close') return completer.future;
    final reply = await completer.future;
    if (generation != _connectionGeneration || reply['error'] != null) {
      return reply;
    }
    if (!isBinding) {
      if (requestedId is String) _noteWorkspaceReceipt(id, [requestedId]);
      _workspaceBindings.removeWhere(
        (id, b) => id == requestedId || b.runtimeId == requestedId,
      );
    } else {
      _noteWorkspaceBinding(
        id,
        reply['result'],
        method == 'session.resume' ? requestedId : null,
        requestedProfile,
      );
    }
    _notifyWorkspaceBindings();
    return reply;
  }

  // Evidence on THIS socket only. A session coordinator can use its own
  // independent socket; its IDs must not leak into workspace dispatch.
  void _noteWorkspaceBinding(
    int requestId,
    Object? result,
    Object? expectedId,
    Object? requestedProfile,
  ) {
    if (result is! Map) return;
    final runtime = result['session_id'];
    final info = result['info'];
    final infoId = info is Map ? info['stored_session_id'] : null;
    final stored = result['stored_session_id'] ?? infoId;
    if (runtime is! String || runtime.isEmpty) return;
    final ids = {
      runtime,
      if (stored is String) stored,
      if (expectedId is String) expectedId,
    };
    if (!_noteWorkspaceReceipt(requestId, ids)) {
      // Completion order disagrees with request order. Neither ordering is
      // server-side proof: require a new receipt, don't pick a winner.
      _workspaceBindings.removeWhere(
        (id, b) => ids.contains(id) || ids.contains(b.runtimeId),
      );
      return;
    }
    _workspaceBindings.removeWhere(
      (id, b) => b.runtimeId == runtime && id != stored,
    );
    if (stored is! String || stored.isEmpty) return;
    final reportedProfile = info is Map ? info['profile_name'] : null;
    final profile = reportedProfile ?? requestedProfile;
    final cwd = info is Map ? info['cwd'] : null;
    final backend = info is Map ? info['terminal_backend'] : null;
    if ((infoId != null && stored != infoId) ||
        (requestedProfile != null &&
            reportedProfile != null &&
            reportedProfile != requestedProfile) ||
        (expectedId != null && stored != expectedId) ||
        (profile != null && profile is! String) ||
        (cwd != null && cwd is! String) ||
        (backend != null && backend is! String)) {
      _workspaceBindings.remove(stored);
      _workspaceBindings.remove(expectedId);
      return;
    }
    final old = _workspaceBindings[stored];
    if (old == null ||
        old.runtimeId != runtime ||
        old.profile != profile ||
        old.cwd != cwd ||
        old.backend != backend) {
      _workspaceBindings[stored] = WorkspaceRuntime._(
        runtime,
        profile as String?,
        cwd as String?,
        backend as String?,
      );
    }
  }

  bool _noteWorkspaceReceipt(int requestId, Iterable<String> ids) {
    var ordered = true;
    for (final id in ids) {
      if ((_workspaceReceipt[id] ?? -1) > requestId) {
        ordered = false;
      } else {
        _workspaceReceipt[id] = requestId;
      }
    }
    return ordered;
  }

  /// Send a JSON-RPC method call and receive streaming events.
  /// Returns the final response when the stream completes.
  Future<Map<String, dynamic>> sendStreaming(
    String method,
    Map<String, dynamic> params, {
    StreamCallback? onEvent,
    Duration timeout = const Duration(seconds: 120),
  }) async {
    if (!_connected || _channel == null) {
      throw Exception('Not connected');
    }

    final id = _nextId++;
    if (onEvent != null) {
      _streams[id] = [onEvent];
    }
    final completer = Completer<Map<String, dynamic>>();
    final timer = Timer(timeout, () {
      _pending.remove(id);
      _streams.remove(id);
      if (!completer.isCompleted) {
        completer.completeError(JsonRpcError(method, 'Timeout'));
      }
    });

    _pending[id] = _Pending(method, completer, timer);
    _channel!.sink.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'method': method,
        'params': withProfile(params, _profile),
        'id': id,
      }),
    );
    return completer.future;
  }

  /// Sends `prompt.submit`, then waits for the gateway's terminal turn event.
  /// The RPC acknowledgement only confirms that the turn was accepted; it is
  /// not the end of streamed model output.
  Future<void> submitPrompt(
    String message, {
    required String sessionId,
    required StreamCallback onEvent,
    void Function()? onSent,
    void Function()? onAccepted,
    bool Function()? maySend,
    Future<bool> Function()? beforeSend,
    String? submissionId,
    Future<void> Function()? beforeLegacy,
    Future<void> Function(Object?, String)? onReceipt,
    Duration timeout = const Duration(minutes: 10),
    Map<String, Object?> extraParams = const {},
  }) async {
    final source = _channel;
    final promptText = await _androidPromptText(message);
    if (beforeSend != null && !await beforeSend()) {
      throw StateError('Notification admission revoked');
    }
    // The read-only configuration lookup is an async boundary, not admission
    // authority. Never lend its result to a replacement socket or stale owner.
    if (!_connected || !identical(source, _channel)) {
      throw JsonRpcError(
        'prompt.submit',
        'Desktop gateway connection closed',
        reason: 'connection_closed',
      );
    }
    if (maySend?.call() == false) {
      throw StateError('Prompt admission is no longer owned.');
    }
    final completion = Completer<void>();
    final terminalFuture = completion.future;
    // A close before the RPC acknowledgement rejects both the pending request
    // and this terminal watcher. Observe the secondary future immediately so
    // the request error remains the single surfaced failure.
    terminalFuture.ignore();
    late final StreamCallback listener;
    Timer? timer;
    final closeListenerToken = _addConnectionClosedListener(() {
      if (!completion.isCompleted) {
        completion.completeError(
          JsonRpcError(
            'prompt.submit',
            'Desktop gateway connection closed',
            reason: 'connection_closed',
          ),
        );
      }
    });

    listener = (event) {
      if (event.isComplete && !completion.isCompleted) {
        if (event.type == 'error' || event.type == 'turn.error') {
          completion.completeError(
            JsonRpcError(
              'prompt.submit',
              event.data['message']?.toString() ?? 'Gateway turn failed',
              // A session event has no request correlation. The application
              // owner must reconcile it, not attribute its error text to the
              // prompt whose terminal watcher happened to receive it.
              reason: 'stream_terminal',
            ),
          );
        } else {
          completion.complete();
        }
      }
      try {
        onEvent(event);
      } catch (_) {
        // Terminal state and other session listeners remain authoritative.
      }
    };

    final listeners = _sessionStreams.putIfAbsent(sessionId, () => []);
    listeners.add(listener);
    timer = Timer(timeout, () {
      if (!completion.isCompleted) {
        completion.completeError(JsonRpcError('prompt.submit', 'Timeout'));
      }
    });

    try {
      final effectiveSubmissionId = submissionId ?? const Uuid().v4();
      final baseParams = <String, dynamic>{
        // A regenerate's truncation target (Desktop's truncateSubmitParams),
        // or a voice-live delegation's surface and context.
        ...extraParams,
        'session_id': sessionId,
        'text': promptText,
        // Stock gateways use this only for title generation. The app's note
        // must not become the subject of an otherwise short user prompt.
        if (promptText != message) 'title_preview': message,
      };
      var response = await send('prompt.submit', {
        ...baseParams,
        'submission_id': effectiveSubmissionId,
      }, onSent: onSent);
      var error = response['error'];
      if (error != null) {
        final rpcError = _gatewayResponseError(
          'prompt.submit',
          error,
          fallbackMessage: 'Unknown error',
        );
        // Backends predating confirm_deep_truncate reject it at contract
        // admission (4000, handler never runs). The user already confirmed
        // the deep cut, so retry once without only that field — mirror of
        // Desktop's runRewindSubmit (rewind.ts).
        final sent = <String, dynamic>{
          ...baseParams,
          'submission_id': effectiveSubmissionId,
        };
        if (isRejectedDeepTruncatePayload(
          code: rpcError.code,
          message: rpcError.message,
          sentParams: sent,
        )) {
          response = await send(
            'prompt.submit',
            stripRejectedDeepTruncate(sent),
            onSent: onSent,
          );
          error = response['error'];
          if (error != null) {
            throw _gatewayResponseError(
              'prompt.submit',
              error,
              fallbackMessage: 'Unknown error',
            );
          }
        } else if (isRejectedSubmissionIdError(rpcError)) {
          if (beforeLegacy != null) await beforeLegacy();
          // The refusal crossed an async boundary: re-validate admission and
          // socket ownership before the compatibility retry writes again, so
          // a stale owner or a replacement socket never receives the prompt.
          if (beforeSend != null && !await beforeSend()) {
            throw StateError('Notification admission revoked');
          }
          if (!_connected || !identical(source, _channel)) {
            throw JsonRpcError(
              'prompt.submit',
              'Desktop gateway connection closed',
              reason: 'connection_closed',
            );
          }
          if (maySend?.call() == false) {
            throw StateError('Prompt admission is no longer owned.');
          }
          response = await send('prompt.submit', baseParams);
          error = response['error'];
          if (error != null) {
            throw _gatewayResponseError(
              'prompt.submit',
              error,
              fallbackMessage: 'Unknown error',
            );
          }
        } else {
          throw rpcError;
        }
      }
      // Stock typed voice controls acknowledge without starting an agent turn
      // or emitting a terminal frame. Do not wait ten minutes for one.
      final result = response['result'];
      if (onReceipt != null) await onReceipt(result, sessionId);
      if (result is Map) {
        // A canonical receipt names the execution its admission started.
        _noteExecutionGeneration(sessionId, result['execution_generation']);
      }
      if (result is Map &&
          (result['voice_stopped'] == true ||
              const {
                'streaming',
                'queued',
                'steered',
                'interrupted',
                // The canonical admission receipt: the turn was admitted
                // and its execution started (`AdmissionStatus.status`).
                'started',
              }.contains(result['status']))) {
        try {
          onAccepted?.call();
        } catch (_) {
          /* View callbacks never change a receipt. */
        }
      }
      if (result is Map && result['voice_stopped'] == true) return;
      await terminalFuture;
    } finally {
      timer.cancel();
      _removeConnectionClosedListener(closeListenerToken);
      final current = _sessionStreams[sessionId];
      current?.remove(listener);
      if (current != null && current.isEmpty) {
        _sessionStreams.remove(sessionId);
      }
    }
  }

  /// Queues guidance at a safe boundary without interrupting the active turn.
  /// Never retry this RPC automatically: it has no idempotency key. On the
  /// canonical session authority it names the execution generation this
  /// socket last admitted for [sessionId]; a turn that changed meanwhile
  /// refuses it (`stale_generation`), which is surfaced, not retried.
  Future<bool> steerSession(String sessionId, String text) async {
    final guidance = text.trim();
    if (guidance.isEmpty) return false;
    final generation = _controlGeneration('session.steer', sessionId);
    final response = await send('session.steer', {
      'session_id': sessionId,
      'execution_generation': ?generation,
      'text': guidance,
    });
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'session.steer',
        error,
        fallbackMessage: 'Gateway steer failed',
      );
    }
    final result = response['result'];
    if (result is Map && result['status'] == 'rejected') return false;
    if (result is! Map ||
        result['status'] != 'queued' ||
        result['text'] != guidance) {
      throw JsonRpcError('session.steer', 'Invalid steering acknowledgement');
    }
    return true;
  }

  /// Reads the gateway's slash-command catalogue for [sessionId], or the
  /// profile default when the session is not bound yet. Read-only: never
  /// retried automatically.
  Future<SlashCommandCatalog> commandsCatalog(String? sessionId) async {
    final response = await send('commands.catalog', {'session_id': ?sessionId});
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'commands.catalog',
        error,
        fallbackMessage: 'Gateway command catalogue failed',
      );
    }
    return SlashCommandCatalog.fromResult(response['result']);
  }

  /// Prefix completion from the gateway's own slash completer. Only meaningful
  /// once the catalogue advertises the command; failures are the caller's to
  /// absorb, never a prompt-submission error.
  Future<Map<String, dynamic>> completeSlash(
    String text,
    String? sessionId,
  ) async {
    final response = await send('complete.slash', {
      'text': text,
      'session_id': ?sessionId,
    });
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'complete.slash',
        error,
        fallbackMessage: 'Gateway slash completion failed',
      );
    }
    final result = response['result'];
    return result is Map
        ? Map<String, dynamic>.from(result)
        : const <String, dynamic>{};
  }

  /// Runs one reviewed slash command server-side. `slash.exec` is dispatched
  /// by the same handler as the TUI, so [command] is the text as typed,
  /// including its leading slash. Never retried: the server owns the effects.
  Future<SlashCommandResult> slashExec(
    String sessionId,
    String command, {
    void Function()? onSent,
  }) async {
    final response = await send('slash.exec', {
      'session_id': sessionId,
      'command': command,
    }, onSent: onSent);
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'slash.exec',
        error,
        fallbackMessage: 'Gateway slash command failed',
      );
    }
    return SlashCommandResult.fromResult(response['result']);
  }

  // Kyllene-style delivery: `source: desktop` on session.create/resume
  // selects stock Hermes' desktop platform hint, which already teaches the
  // agent to deliver files as `MEDIA:/absolute/path`. The desktop gateway
  // needs no per-message Android note, so the typed text goes out unchanged.
  // Older saved turns that carried the note are still decoded for display.
  Future<String> _androidPromptText(String message) async => message;

  /// Cooperatively interrupts the active turn for one gateway session. On
  /// the canonical session authority it names the execution generation this
  /// socket last admitted, so a later claim is never stopped by it; its
  /// `stale_generation` refusal is surfaced, never retried against the newer
  /// turn. Legacy gateways keep the bare shape their params require.
  Future<void> interruptSession(String sessionId) async {
    final generation = _controlGeneration('session.interrupt', sessionId);
    final response = await send('session.interrupt', {
      'session_id': sessionId,
      'execution_generation': ?generation,
    });
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'session.interrupt',
        error,
        fallbackMessage: 'Gateway interrupt failed',
      );
    }
  }

  /// Resolves the single in-flight Hermes approval for one gateway session.
  Future<void> respondToApproval({
    required String sessionId,
    required String choice,
  }) async {
    const allowedChoices = {'once', 'session', 'always', 'deny'};
    if (!allowedChoices.contains(choice)) {
      throw ArgumentError.value(
        choice,
        'choice',
        'Unsupported approval choice',
      );
    }
    final response = await send('approval.respond', {
      'session_id': sessionId,
      'choice': choice,
    });
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'approval.respond',
        error,
        fallbackMessage: 'Gateway approval failed',
      );
    }
  }

  Future<void> respondToSudo({
    required String requestId,
    required String password,
  }) {
    return _respondToSensitivePrompt(
      method: 'sudo.respond',
      requestId: requestId,
      valueKey: 'password',
      value: password,
    );
  }

  Future<void> respondToSecret({
    required String requestId,
    required String value,
  }) {
    return _respondToSensitivePrompt(
      method: 'secret.respond',
      requestId: requestId,
      valueKey: 'value',
      value: value,
    );
  }

  Future<Map<String, dynamic>> respondToClarify({
    required String requestId,
    required String answer,
    String? questionId,
    bool lockAnswer = false,
  }) async {
    if (requestId.trim().isEmpty) {
      throw ArgumentError.value(
        requestId,
        'requestId',
        'A Hermes request ID is required',
      );
    }
    final params = <String, dynamic>{'request_id': requestId, 'answer': answer};
    final hasQuestionId = questionId != null && questionId.trim().isNotEmpty;
    if (hasQuestionId) {
      params['question_id'] = questionId;
    }
    if (lockAnswer && !hasQuestionId) {
      throw ArgumentError('questionId is required to lock a clarify answer');
    }
    final method = lockAnswer ? 'clarify.lock' : 'clarify.respond';
    final response = await send(method, params);
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        method,
        error,
        fallbackMessage: 'Gateway clarification failed',
      );
    }
    final rawResult = response['result'];
    return rawResult is Map
        ? Map<String, dynamic>.from(rawResult)
        : const <String, dynamic>{};
  }

  Future<void> _respondToSensitivePrompt({
    required String method,
    required String requestId,
    required String valueKey,
    required String value,
  }) async {
    if (requestId.trim().isEmpty) {
      throw ArgumentError.value(
        requestId,
        'requestId',
        'A Hermes request ID is required',
      );
    }
    final response = await send(method, {
      'request_id': requestId,
      valueKey: value,
    });
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        method,
        error,
        fallbackMessage: 'Gateway response failed',
      );
    }
  }

  /// Resume an existing session while preserving retained turn state.
  Future<ResumedGatewaySession> resumeSessionDetails(String sessionId) async {
    final result = await send('session.resume', {
      'session_id': sessionId,
      // Stock Hermes calls its attachment-capable graphical chat surface
      // "desktop". Omission inherits the server's launch surface, often TUI,
      // whose prompt explicitly tells the agent it cannot send attachments.
      'source': 'desktop',
      // Session attachment must not carry the rendered transcript. Android
      // hydrates its visible history through bounded REST requests; returning
      // it here duplicates a potentially multi-megabyte transfer and can make
      // the attach RPC itself exceed the request deadline.
      'omit_messages': true,
      'defer_history': true,
      // The canonical resume model (0.23+ session authority) has no
      // inline_images field and refuses unknown keys; legacy gateways
      // still accept it (#291).
      if (!sessionAuthority) 'inline_images': false,
    });
    if (result['error'] != null) {
      throw _gatewayResponseError(
        'session.resume',
        result['error'],
        fallbackMessage: 'Unknown error',
      );
    }
    final rawPayload = result['result'];
    if (rawPayload is! Map) {
      throw StateError('session.resume succeeded without a result payload.');
    }
    // A different stored_session_id is not a different chat: the gateway
    // follows a compressed chat to its lineage tip (tui_gateway
    // methods_session._resume_follow_tip), so resuming the original id
    // legitimately returns the continuation's id.
    final payload = Map<String, dynamic>.from(rawPayload);
    final runtimeSessionId = payload['session_id'] as String?;
    if (runtimeSessionId == null || runtimeSessionId.isEmpty) {
      throw StateError(
        'session.resume succeeded without a session_id — refusing to bind '
        'the caller-supplied id, which may not be the runtime session the '
        'gateway resumed.',
      );
    }
    final rawInflight = payload['inflight'];
    final generation = payload['execution_generation'];
    final replayEpoch = payload['replay_epoch'];
    final lastSequence = payload['last_sequence'];
    final pending = payload['pending'];
    _noteExecutionGeneration(runtimeSessionId, generation);
    return ResumedGatewaySession(
      runtimeSessionId: runtimeSessionId,
      running: payload['running'] as bool?,
      status: payload['status']?.toString(),
      inflight: rawInflight is Map
          ? Map<String, dynamic>.from(rawInflight)
          : null,
      openRequests: payload['open_requests'] is List
          ? List<dynamic>.from(payload['open_requests'] as List)
          : const [],
      executionGeneration: generation is int ? generation : null,
      replayEpoch: replayEpoch is String ? replayEpoch : null,
      lastSequence: lastSequence is int ? lastSequence : null,
      pending: pending is List
          ? [
              for (final row in pending)
                if (row is Map) Map<String, dynamic>.from(row),
            ]
          : const [],
    );
  }

  /// Backward-compatible runtime-id-only resume helper.
  Future<String> resumeSession(String sessionId) async {
    return (await resumeSessionDetails(sessionId)).runtimeSessionId;
  }

  Future<void> setSessionTitle(String sessionId, String title) async {
    final response = await send('session.title', {
      'session_id': sessionId,
      'title': title,
    });
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'session.title',
        error,
        fallbackMessage: 'Could not rename session',
      );
    }
  }

  Future<Map<String, dynamic>> branchSession(
    String sessionId, {
    required String name,
  }) async {
    final response = await send('session.branch', {
      'session_id': sessionId,
      'name': name,
    });
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'session.branch',
        error,
        fallbackMessage: 'Could not branch session',
      );
    }
    final result = response['result'];
    if (result is Map<String, dynamic>) return result;
    throw JsonRpcError('session.branch', 'Gateway returned no branch');
  }

  /// Submit a message to the active session with streaming.
  /// Returns the final response and streams events via callback.
  Future<String> sendMessageStreaming(
    String message, {
    required String sessionId,
    StreamCallback? onEvent,
  }) async {
    await submitPrompt(
      message,
      sessionId: sessionId,
      onEvent: onEvent ?? (_) {},
    );
    return sessionId;
  }

  /// Submit a message to the active session (non-streaming, backward-compatible).
  Future<String> sendMessage(String message) async {
    throw UnsupportedError(
      'Use sendMessageStreaming with a gateway session ID instead.',
    );
  }

  /// Uploads one file or image to a remote Desktop gateway and returns the
  /// canonical `@file:` reference that must be included in the following turn.
  ///
  /// The wire params are exactly the stock gateway's `FileAttachParams`
  /// (`extra="forbid"`: session_id/profile/path/data_url/name). An earlier
  /// revision also sent `source_channel`/`source_profile`; those exist only
  /// in the repo's fixture gateway and stock Hermes rejects them with
  /// "invalid params for file.attach: source_channel: Extra inputs are not
  /// permitted", so they must never go on the wire.
  Future<RemoteFileAttachment> attachFile({
    required String sessionId,
    required String name,
    required String dataUrl,
    String path = '',
  }) async {
    final params = <String, dynamic>{
      'session_id': sessionId,
      'name': name,
      'path': path,
      'data_url': dataUrl,
    };
    final response = await send('file.attach', params);
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'file.attach',
        error,
        fallbackMessage: 'Unknown error',
      );
    }
    final result = response['result'];
    if (result is! Map<String, dynamic> || result['attached'] != true) {
      throw JsonRpcError('file.attach', 'Gateway did not attach the file');
    }
    final refText = result['ref_text']?.toString() ?? '';
    if (refText.isEmpty) {
      throw JsonRpcError('file.attach', 'Gateway returned no file reference');
    }
    final atlasIntake = result['atlas_intake'];
    return RemoteFileAttachment(
      name: result['name']?.toString() ?? name,
      path: result['path']?.toString() ?? path,
      refText: refText,
      uploaded: result['uploaded'] == true,
      atlasIntakeAccepted: atlasIntake is Map<String, dynamic>
          ? atlasIntake['accepted'] == true
          : null,
      atlasIntakeStatus: atlasIntake is Map<String, dynamic>
          ? atlasIntake['status']?.toString()
          : null,
      atlasRelativePath: atlasIntake is Map<String, dynamic>
          ? atlasIntake['relative_path']?.toString()
          : null,
    );
  }

  /// Create a new chat session using the stock Hermes `session.create`
  /// contract.
  ///
  /// The gateway owns the new runtime session id. [workingDirectory] is sent
  /// as `cwd` so Hermes can associate the session with the matching Project.
  Future<CreatedGatewaySession> createSession({
    String? model,
    String? workingDirectory,
  }) async {
    // CanonicalCreateParams.source only accepts cli/tui/gui/acp/tool/oneshot;
    // 'desktop' is the legacy surface hint and is refused on the authority
    // route (#291). 'gui' is the canonical graphical-chat surface.
    final params = <String, dynamic>{
      'source': sessionAuthority ? 'gui' : 'desktop',
    };
    if (model != null) params['model'] = model;
    final cwd = workingDirectory?.trim();
    if (cwd != null && cwd.isNotEmpty) params['cwd'] = cwd;
    final result = await send('session.create', params);
    if (result['error'] != null) {
      throw _gatewayResponseError(
        'session.create',
        result['error'],
        fallbackMessage: 'Unknown error',
      );
    }
    final payload = result['result'];
    if (payload is! Map) {
      throw JsonRpcError('session.create', 'Gateway returned no session');
    }
    final runtimeSessionId = payload['session_id']?.toString().trim() ?? '';
    final storedSessionId =
        payload['stored_session_id']?.toString().trim() ?? '';
    if (runtimeSessionId.isEmpty || storedSessionId.isEmpty) {
      throw JsonRpcError(
        'session.create',
        'Gateway returned incomplete session identities',
      );
    }
    // A canonical create attaches with the resume snapshot's fields.
    _noteExecutionGeneration(runtimeSessionId, payload['execution_generation']);
    return CreatedGatewaySession(
      runtimeSessionId: runtimeSessionId,
      storedSessionId: storedSessionId,
      // Only explicit, well-typed creation evidence proves an empty baseline.
      // Older gateways may omit these fields; that remains unknown history.
      hasEmptyHistory:
          payload['message_count'] is int &&
          payload['message_count'] == 0 &&
          payload['messages'] is List &&
          (payload['messages'] as List).isEmpty,
    );
  }

  /// Applies a model only to one live gateway session.  Hermes interprets the
  /// `--session` flag as a persistent per-session override; it must never be
  /// replaced with a profile-wide config write from the mobile client.
  Future<void> setSessionModel({
    required String sessionId,
    required String provider,
    required String model,
  }) async {
    final result = await send('config.set', {
      'session_id': sessionId,
      'key': 'model',
      'value': buildSessionModelValue(provider: provider, model: model),
    });
    if (result['error'] != null) {
      throw _gatewayResponseError(
        'config.set',
        result['error'],
        fallbackMessage: 'Model switch failed',
      );
    }
    final payload = result['result'];
    if (payload is Map && payload['confirm_required'] == true) {
      throw JsonRpcError(
        'config.set',
        payload['confirm_message']?.toString() ??
            'This model needs confirmation before it can be selected.',
      );
    }
  }

  /// Returns the effective reasoning effort for one live gateway session.
  Future<String> getSessionReasoning(String sessionId) async {
    final response = await send('config.get', {
      'session_id': sessionId,
      'key': 'reasoning',
    });
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'config.get',
        error,
        fallbackMessage: 'Could not read reasoning effort',
      );
    }
    final result = response['result'];
    if (result is! Map) {
      throw JsonRpcError('config.get', 'Gateway returned no reasoning effort');
    }
    return normalizeReasoningEffort(result['value']);
  }

  /// Applies reasoning effort only to one live gateway session.
  Future<void> setSessionReasoning({
    required String sessionId,
    required String effort,
  }) async {
    final normalized = effort.trim().toLowerCase();
    if (!validReasoningEfforts.contains(normalized)) {
      throw ArgumentError.value(
        effort,
        'effort',
        'Unsupported reasoning effort',
      );
    }
    final response = await send('config.set', {
      'session_id': sessionId,
      'key': 'reasoning',
      'value': normalized,
    });
    final error = response['error'];
    if (error != null) {
      throw _gatewayResponseError(
        'config.set',
        error,
        fallbackMessage: 'Reasoning effort switch failed',
      );
    }
  }

  static const validReasoningEfforts = <String>{
    'none',
    'minimal',
    'low',
    'medium',
    'high',
    'xhigh',
    'max',
    'ultra',
  };

  static String normalizeReasoningEffort(Object? value) {
    final normalized = value?.toString().trim().toLowerCase() ?? '';
    return validReasoningEfforts.contains(normalized) ? normalized : 'medium';
  }

  /// Builds the gateway `/model` value used for one live session.
  ///
  /// A bare `custom` provider represents the endpoint already stored in the
  /// profile's `model.base_url`; it is not a resolvable named provider before
  /// the deferred agent build finishes. Omitting the redundant provider flag
  /// lets Hermes resolve that endpoint from the active profile immediately.
  static String buildSessionModelValue({
    required String provider,
    required String model,
  }) {
    final normalizedProvider = provider.trim();
    final modelValue = model.trim();
    if (normalizedProvider.isEmpty || normalizedProvider == 'custom') {
      return '$modelValue --session';
    }
    return '$modelValue --provider $normalizedProvider --session';
  }

  bool get isConnected => _connected;

  /// Close the connection.
  void close() {
    if (!_connected && _channel == null) return;
    final generation = _connectionGeneration;
    final channel = _channel;
    _handleClosedConnection(generation);
    channel?.sink.close();
  }
}

class _Pending {
  final String method;
  final Completer<Map<String, dynamic>> completer;
  final Timer? timer;

  /// The session the request named, for a refusal that carries its fences.
  final String? sessionId;
  _Pending(this.method, this.completer, this.timer, {this.sessionId});
}

class _ConnectionClosedListener {
  final int generation;
  final void Function() callback;

  const _ConnectionClosedListener(this.generation, this.callback);
}
