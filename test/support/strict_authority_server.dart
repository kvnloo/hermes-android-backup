// A loopback session-authority gateway for tests that drive the real
// clients (WsClient, DesktopGatewayClient, NextGenGateway) end to end.
//
// It greets `/api/ws` with `session_authority: true`, refuses every request
// the pinned gateway refuses ([strictAuthorityRefusal]) and answers the rest
// with canonical-shaped results, so a legacy shape that slips past the
// client's guard fails the test the way it fails in production.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';

import 'strict_authority_gateway.dart';

/// One request the gateway received.
class StrictFrame {
  StrictFrame(this.method, this.params, this.refusal);
  final String method;
  final Map<String, dynamic> params;

  /// The error it was answered with by the contract check, when refused.
  final Map<String, dynamic>? refusal;
}

/// What a [StrictAuthorityGateway] handler answers with: a result map, a
/// JSON-RPC error map under `error`, or null for the gateway's standard
/// answer ([StrictAuthorityGateway.standardAnswer]).
typedef StrictHandler =
    FutureOr<Object?> Function(String method, Map<String, dynamic> params);

/// Answers a REST request on the same loopback port: a status and a JSON
/// body, or null for `404 {"detail": "Not Found"}`.
typedef StrictHttpHandler =
    FutureOr<(int, Object?)?> Function(HttpRequest request);

class StrictAuthorityGateway {
  StrictAuthorityGateway._(this._server, this.handler, this.http, this._ready);

  final HttpServer _server;
  final Map<String, dynamic> _ready;

  /// Answers an accepted request; a null answer falls back to
  /// [standardAnswer].
  StrictHandler? handler;

  /// Answers REST requests (the dashboard API the clients also read).
  StrictHttpHandler? http;

  /// Every request frame, in arrival order, refused ones included.
  final frames = <StrictFrame>[];

  /// Sessions `session.resume` answers `not_found` for, as the owner does
  /// for an id it never stored.
  final unknownSessions = <String>{};

  /// The owning profile's home, as receipts name it.
  String profileHome = '/home/hermes/.hermes';
  final _sockets = <WebSocket>[];
  final _revisions = <String, int>{};
  final _generations = <String, int>{};
  var _minted = 0;

  static const token = 'strict-deployment-token';

  String get baseUrl => 'http://127.0.0.1:${_server.port}';
  int get port => _server.port;

  /// Requests the contract check refused.
  List<StrictFrame> get refused => [
    for (final frame in frames)
      if (frame.refusal != null) frame,
  ];

  /// The params of every [method] request received.
  List<Map<String, dynamic>> calls(String method) => [
    for (final frame in frames)
      if (frame.method == method) frame.params,
  ];

  static Future<StrictAuthorityGateway> start({
    StrictHandler? handler,
    StrictHttpHandler? http,
    Map<String, dynamic> ready = const {},
  }) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final gateway = StrictAuthorityGateway._(server, handler, http, ready);
    server.listen(gateway._serve);
    return gateway;
  }

  /// A saved gateway both layouts can open: the socket is dialled with the
  /// deployment token, so no sign-in or ticket is needed.
  SavedConnection connection({String id = 'strict', String? profile}) =>
      SavedConnection(
        id: id,
        label: 'Strict authority',
        host: '127.0.0.1',
        port: port,
        dashboardPortOverride: port,
        apiKey: 'fixture-api-key',
        desktopGatewayUrl: baseUrl,
        singleLogin: true,
        signInMethod: 'token',
        deploymentToken: token,
        gatewayProfile: profile,
      );

  /// A connected [WsClient] on this gateway that has seen `gateway.ready`.
  Future<WsClient> connect({String? profile}) async {
    final client = WsClient(
      baseUrl,
      token: token,
      profile: profile,
      heartbeatInterval: Duration.zero,
    );
    await client.connect();
    await client.waitForGatewayReady();
    return client;
  }

  int revisionOf(String sessionId) => _revisions[sessionId] ?? 1;
  int generationOf(String sessionId) => _generations[sessionId] ?? 1;

  /// A new turn claim: later controls must name this generation.
  int advanceGeneration(String sessionId) =>
      _generations[sessionId] = generationOf(sessionId) + 1;

  /// Another viewer's committed edit: this socket's revision is now stale.
  int advanceRevision(String sessionId) =>
      _revisions[sessionId] = revisionOf(sessionId) + 1;

  /// The attach snapshot `session.resume` / `session.create` answer with
  /// (`gateway/session_controls.py::AuthorityConnection.resume`).
  Map<String, dynamic> snapshot(
    String sessionId, {
    List<Map<String, dynamic>> prompts = const [],
    List<Map<String, dynamic>> openRequests = const [],
    bool running = false,
  }) => {
    'session_id': sessionId,
    'stored_session_id': sessionId,
    'messages': const <Object>[],
    'message_count': 0,
    'todo_state': null,
    'running': running,
    'authority_epoch': 1,
    'replay_epoch': 'strict-epoch',
    'last_sequence': 0,
    'subscription_id': 'sub-$sessionId',
    'revision': revisionOf(sessionId),
    'execution_generation': generationOf(sessionId),
    'pending': const <Object>[],
    'prompts': prompts,
    'info': {
      'desktop_protocol': 'hermes-gateway-v1',
      'model': 'gpt-test',
      'provider': 'openai',
      'cwd': '/work',
    },
    'pending_connection': null,
    'open_requests': openRequests,
  };

  static Map<String, dynamic> _refusal(
    String reason, [
    Map<String, dynamic> data = const {},
  ]) => {
    'error': {
      'code': 4001,
      'message': reason,
      'data': {'reason': reason, ...data},
    },
  };

  /// A canonical-shaped answer for the verbs the clients read results from;
  /// `{}` for anything else.
  Object? standardAnswer(String method, Map<String, dynamic> params) {
    final sessionId = params['session_id']?.toString() ?? '';
    switch (method) {
      case 'session.create':
        return snapshot('local-${++_minted}');
      case 'session.resume':
        return unknownSessions.contains(sessionId)
            ? _refusal('not_found')
            : snapshot(sessionId);
      case 'session.mutate':
        final operation = params['operation'];
        final payload = params['payload'] as Map;
        if (params['expected_revision'] != revisionOf(sessionId)) {
          return _refusal('revision_conflict', {
            'revision': revisionOf(sessionId),
            'execution_generation': generationOf(sessionId),
          });
        }
        return {
          'session_id': sessionId,
          'operation': operation,
          'revision': advanceRevision(sessionId),
          'status': 'applied',
          ...switch (operation) {
            'branch' => {
              'branched_session_id': 'local-${++_minted}',
              'copied_messages': 2,
            },
            'compress' => {'message_count': 3, 'target_session_id': sessionId},
            _ => Map<String, dynamic>.from(payload),
          },
        };
      case 'prompt.submit' ||
          'prompt.replace_queued' ||
          'prompt.steer_queued' ||
          'prompt.cancel' ||
          'prompt.receipt' ||
          'prompt.resolve_unknown':
        final settled = method == 'prompt.resolve_unknown';
        return {
          'admission_id':
              params['admission_id'] ??
              'adm-${params['submission_id'] ?? params['input_id']}',
          'ref': {'profile_id': profileHome, 'session_id': sessionId},
          'sequence': 1,
          'status': settled ? 'terminal' : 'started',
          'outcome': settled ? 'discarded' : null,
          'execution_generation': generationOf(sessionId),
        };
      case 'session.steer' || 'session.redirect':
        return {'status': 'queued', 'text': params['text']};
      case 'session.interrupt':
        return {
          'session_id': sessionId,
          'execution_state': 'idle',
          'execution_generation': generationOf(sessionId),
        };
      case 'file.attach':
        return {
          'attached': true,
          'ref_text': '@file:${params['name'] ?? 'file'}',
          'name': params['name'],
          'path': '/work/${params['name'] ?? 'file'}',
          'uploaded': true,
        };
      case 'image.attach_bytes':
        return {
          'attached': true,
          'path': '$profileHome/cache/images/${params['filename']}',
          'mime': 'image/png',
        };
      case 'config.get':
        return {'key': params['key'], 'value': 'medium'};
      case 'config.set':
        return {'key': params['key'], 'value': params['value']};
      case 'commands.catalog':
        return {
          'pairs': const <Object>[],
          'categories': const <Object>[],
          'canon': const <String, Object>{},
          'sub': const <String, Object>{},
        };
      case 'complete.slash' || 'complete.path':
        return {'items': const <Object>[]};
      case 'slash.exec' || 'command.dispatch':
        return {'type': 'exec', 'output': 'ok'};
      case 'approval.respond' || 'clarify.respond':
        return {'prompt_id': params['prompt_id'], 'status': 'resolved'};
      case 'clarify.lock':
        return {'status': 'ok', 'remaining': const <Object>[]};
      case 'session.events.since':
        return {
          'events': const <Object>[],
          'replay_epoch': 'strict-epoch',
          'latest_seq': params['last_sequence'] ?? 0,
          'snapshot_required': false,
          'open_requests': const <Object>[],
        };
      case 'client.capabilities':
        return {
          'server_requests': const ['clarify', 'sudo', 'secret'],
          'client_activity': true,
        };
      case 'session.history':
        return {'count': 0, 'messages': const <Object>[]};
      case 'subagent.list':
        return {'subagents': const <Object>[]};
      case 'process.list':
        return {'processes': const <Object>[]};
      case 'approval.pending':
        return {'approvals': const <Object>[]};
      case 'connection.respond' || 'connectors.operation.wake':
        return {'status': 'ok'};
    }
    return const <String, dynamic>{};
  }

  /// Sends a server event to every connected client.
  void emit(
    String type, {
    String? sessionId,
    Map<String, dynamic> payload = const {},
    Map<String, dynamic> envelope = const {},
  }) {
    for (final socket in _sockets) {
      socket.add(
        jsonEncode({
          'jsonrpc': '2.0',
          'method': 'event',
          'params': {
            'type': type,
            'session_id': ?sessionId,
            'payload': payload,
            ...envelope,
          },
        }),
      );
    }
  }

  /// Publishes an approval the way the owner does (`PendingControls`): an
  /// `approval.request` event that `approval.respond` answers by prompt id.
  void requestApproval(
    String sessionId,
    String promptId, {
    String command = 'rm -rf build',
    List<String> choices = const ['once', 'deny', 'session', 'always'],
  }) => emit(
    'approval.request',
    sessionId: sessionId,
    payload: {
      'kind': 'approval',
      'prompt_id': promptId,
      'execution_generation': generationOf(sessionId),
      'command': command,
      'description': 'Run a shell command',
      'choices': choices,
    },
  );

  /// Publishes one question the way the owner does for a viewer that did
  /// not ask for a batch: a `clarify.request` event.
  void requestClarify(
    String sessionId,
    String promptId, {
    String question = 'Which branch?',
    List<String> choices = const ['main', 'dev'],
  }) => emit(
    'clarify.request',
    sessionId: sessionId,
    payload: {
      'kind': 'clarify',
      'prompt_id': promptId,
      'execution_generation': generationOf(sessionId),
      'question': question,
      'choices': choices,
      'multi_select': false,
    },
  );

  Future<void> _serve(HttpRequest request) async {
    if (!WebSocketTransformer.isUpgradeRequest(request)) {
      final answer = await http?.call(request);
      request.response.statusCode = answer?.$1 ?? HttpStatus.notFound;
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode(answer == null ? {'detail': 'Not Found'} : answer.$2),
      );
      await request.response.close();
      return;
    }
    final offered = request.headers.value('sec-websocket-protocol');
    final socket = await WebSocketTransformer.upgrade(
      request,
      protocolSelector: offered == null ? null : (_) => 'hermes-gateway-v1',
    );
    _sockets.add(socket);
    socket.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'method': 'event',
        'params': {
          'type': 'gateway.ready',
          'payload': {
            'change_events': true,
            'heartbeat': true,
            'replay_epoch': 'strict-epoch',
            'session_authority': true,
            ..._ready,
          },
        },
      }),
    );
    socket.listen((raw) async {
      final frame = jsonDecode(raw as String);
      if (frame is! Map || frame['method'] is! String) return; // a response
      final method = frame['method'] as String;
      final id = frame['id'];
      final rawParams = frame['params'];
      final params = rawParams is Map
          ? Map<String, dynamic>.from(rawParams)
          : <String, dynamic>{};
      final refusal = strictAuthorityRefusal(method, rawParams);
      if (method != 'gateway.ping') {
        frames.add(StrictFrame(method, params, refusal));
      }
      void reply(Map<String, dynamic> body) {
        if (socket.readyState != WebSocket.open) return;
        socket.add(jsonEncode({'jsonrpc': '2.0', 'id': id, ...body}));
      }

      if (refusal != null) {
        reply({'error': refusal});
        return;
      }
      if (method == 'gateway.ping') {
        reply({
          'result': {'ok': true},
        });
        return;
      }
      final answer =
          await handler?.call(method, params) ?? standardAnswer(method, params);
      if (answer is Map && answer['error'] is Map) {
        reply({'error': answer['error']});
      } else {
        reply({'result': answer ?? const <String, dynamic>{}});
      }
    }, onDone: () => _sockets.remove(socket));
  }

  Future<void> close() async {
    for (final socket in List.of(_sockets)) {
      await socket.close();
    }
    await _server.close(force: true);
  }
}
