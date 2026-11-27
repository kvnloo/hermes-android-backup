import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hermes_android/core/models/connection.dart';

import 'strict_authority_gateway.dart';

/// Disposable dashboard and JSON-RPC peer, with deliberately distinct stored,
/// runtime, child-control and transcript IDs. No application/provider login.
class WorkerPeer {
  WorkerPeer._(this.server);
  final HttpServer server;
  final sockets = <WebSocket>[];
  final frames = <Map<String, dynamic>>[];

  /// Frames the pinned gateway's contracts refuse (the shared strict fake).
  final refusals = <Map<String, dynamic>>[];
  final tickets = <String>{};
  final held = Completer<void>(), release = Completer<void>();
  String? holdMethod;
  bool dropHeldReply = false;
  int backgroundB = 3;
  bool _closing = false;
  String runtime = 'runtime-A', receipt = 'queued', rowProfile = 'work';
  final replies = <String, Map<String, Object?>>{};
  Map<String, Object?>? Function(String, Map)? handle;
  final rows = <Map<String, Object?>>[
    for (final id in ['first', 'second'])
      {
        'subagent_id': id,
        'child_session_id': 'transcript-$id',
        'delegation_id': 'delegation-$id',
        'status': 'running',
        'started_at': 12.5,
        'goal': 'Task $id',
        'accepting_steer': true,
      },
  ];
  List<Object?> calls(String method) => [
    for (final frame in frames)
      if (frame['method'] == method) frame['params'],
  ];
  SavedConnection get connection => SavedConnection(
    id: 'worker-peer',
    label: 'Worker peer',
    host: '127.0.0.1',
    port: server.port,
    apiKey: '',
    dashboardPassword: 'fixture',
    dashboardUsername: 'fixture',
    dashboardPortOverride: server.port,
    gatewayProfile: 'work',
    desktopGatewayUrl: 'http://127.0.0.1:${server.port}',
  );

  static Future<WorkerPeer> start() async {
    final peer = WorkerPeer._(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    peer.server.listen(peer._http);
    return peer;
  }

  Future<void> _http(HttpRequest req) async {
    final r = req.response;
    final path = req.uri.path;
    if (path == '/auth/password-login' &&
        (jsonDecode(await utf8.decoder.bind(req).join()) as Map)['password'] ==
            'fixture') {
      r.cookies.add(Cookie('hermes_session_at', 'fixture-cookie'));
      r.write('{}');
    } else if (path == '/api/ws' &&
        !req.uri.hasQuery &&
        (req.headers.value('sec-websocket-protocol') ?? '')
            .split(',')
            .any((s) => tickets.remove(s.trim()))) {
      final ws = await WebSocketTransformer.upgrade(
        req,
        protocolSelector: (_) => 'hermes-gateway-v1',
      );
      sockets.add(ws);
      ws.add(
        jsonEncode({
          'jsonrpc': '2.0',
          'method': 'event',
          'params': {
            'type': 'gateway.ready',
            'payload': {'session_authority': true, 'replay_epoch': 'test'},
          },
        }),
      );
      ws.listen(
        (raw) => _rpc(ws, jsonDecode(raw as String) as Map<String, dynamic>),
      );
      return;
    } else if (req.headers.value('cookie') !=
        'hermes_session_at=fixture-cookie') {
      r.statusCode = 401;
    } else if (path == '/api/auth/ws-ticket') {
      final ticket = 'fixture-${sockets.length}';
      tickets.add('hermes-gateway-ticket.$ticket');
      r.write(jsonEncode({'ticket': ticket}));
    } else if (path == '/api/sessions/stored-A' &&
        req.uri.queryParameters['profile'] == 'work') {
      r.write(jsonEncode({'id': 'stored-A', 'profile': rowProfile}));
    } else {
      r.write('{}');
    }
    await r.close();
  }

  Future<void> _rpc(WebSocket ws, Map<String, dynamic> frame) async {
    frames.add(frame);
    final refused = strictAuthorityFrame(frame);
    if (refused != null) {
      refusals.add(frame);
      ws.add(refused);
      return;
    }
    final method = frame['method'] as String;
    final params = frame['params'] as Map;
    final result = switch (method) {
      'subagent.roster' => {
        'sessions': [
          {'session_id': 'stored-A', 'subagents': 2, 'background': 0},
          {'session_id': 'stored-B', 'subagents': 1, 'background': backgroundB},
        ],
      },
      'session.resume' => {
        'session_id': runtime,
        'stored_session_id': 'stored-A',
        'info': {'profile_name': 'work'},
      },
      'subagent.list' => {
        'subagents': rows,
        'delegations': [
          {'delegation_id': 'not-a-child', 'goal': 'not live'},
        ],
      },
      'subagent.steer' => {
        'status': receipt,
        'subagent_id': params['subagent_id'],
        'text': params['text'],
      },
      _ => <String, Object?>{},
    };
    final override = handle?.call(method, params) ?? replies[method];
    final response = jsonEncode({
      'jsonrpc': '2.0',
      'id': frame['id'],
      ...?override,
      if (override == null) 'result': result,
    });
    if (method == holdMethod) {
      holdMethod = null;
      held.complete();
      await release.future;
      if (dropHeldReply) return;
    }
    if (!_closing && ws.readyState == WebSocket.open) ws.add(response);
  }

  Future<void> close() async {
    _closing = true;
    if (!release.isCompleted) release.complete();
    for (final ws in sockets) {
      await ws.close();
    }
    await server.close(force: true);
  }
}
