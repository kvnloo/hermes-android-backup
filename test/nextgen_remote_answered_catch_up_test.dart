// The open chat's own catch-up against a real loopback socket: a question
// answered on another device disappears from a legacy gateway's
// `open_requests` without any `request.cancel`; the next authoritative read
// must take the card and the needs-you highlight down (see
// nextgen_remote_answered_request_test.dart for the server behaviour).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

SavedConnection _conn() => SavedConnection(
  id: 'c1',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: 'k',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
  dashboardProxied: true,
);

Map<String, dynamic> _clarify(String id, String sid) => {
  'id': id,
  'method': 'clarify',
  'params': {'session_id': sid, 'question': 'Which branch?'},
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a resume that no longer lists the question takes the card and the '
      'highlight down', () async {
    final asked = _resume(open: [_clarify('srq-9', 'rt9')]);
    final answered = _resume(open: const []);
    final server = await _server([asked, answered]);
    addTearDown(() => server.close(force: true));
    final o = await _open(server, addTearDown);

    await o.chat.open();
    expect(o.chat.request?.request.id, 'srq-9');
    expect(o.gateway.needsYou, {'stored-9'});

    // Answered on Windows. Back in sight, the chat re-reads the session.
    o.chat.resync();
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while ((o.chat.request != null || o.gateway.openRequests.isNotEmpty) &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    expect(o.chat.request, isNull);
    expect(o.gateway.openRequests, isEmpty);
    expect(o.gateway.needsYou, isEmpty);
  });
}

Map<String, dynamic> _resume({required List<Map<String, dynamic>> open}) => {
  'session_id': 'rt9',
  'stored_session_id': 'stored-9',
  // Idle between turns, so the foreground catch-up re-reads the session.
  'running': false,
  'open_requests': open,
};

/// Loopback gateway: `session.resume` answers with [resumes] in order (the
/// last one repeats); `session.events.since` is refused like an older gateway.
Future<HttpServer> _server(List<Map<String, dynamic>> resumes) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  var resumed = 0;
  server.listen((req) async {
    final ws = await WebSocketTransformer.upgrade(req);
    ws.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'method': 'event',
        'params': {
          'type': 'gateway.ready',
          'payload': {'replay_epoch': 'e1'},
        },
      }),
    );
    ws.listen((raw) {
      final frame = jsonDecode(raw as String) as Map<String, dynamic>;
      final method = frame['method'];
      final id = frame['id'];
      if (method == 'session.resume') {
        final result =
            resumes[resumed < resumes.length ? resumed : resumes.length - 1];
        resumed++;
        ws.add(jsonEncode({'jsonrpc': '2.0', 'id': id, 'result': result}));
      } else if (method == 'session.events.since') {
        ws.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'id': id,
            'error': {'code': 4000, 'message': 'unsupported'},
          }),
        );
      } else if (id != null && method != null) {
        ws.add(jsonEncode({'jsonrpc': '2.0', 'id': id, 'result': {}}));
      }
    });
  });
  return server;
}

class _LiveGateway extends NextGenGateway {
  _LiveGateway(super.connection, this.ws, {super.dashboard}) {
    readyFrame = const {'replay_epoch': 'e1'};
    ws.onServerRequest = acceptServerRequest;
    ws.onStreamEvent = debugEmit;
  }

  final WsClient ws;

  @override
  WsClient? get socket => ws;

  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => ws;

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final response = await ws.send(method, params, timeout: timeout);
    final result = response['result'];
    if (response['error'] != null) throw StateError('${response['error']}');
    return Map<String, dynamic>.from(result as Map);
  }
}

Future<({NgChatController chat, NextGenGateway gateway})> _open(
  HttpServer server,
  void Function(void Function()) addTeardown,
) async {
  final ws = WsClient('http://127.0.0.1:${server.port}');
  final httpClient = MockClient(
    (request) async => http.Response(
      jsonEncode({'messages': const <Object>[]}),
      200,
      headers: {'content-type': 'application/json'},
    ),
  );
  final gateway = _LiveGateway(
    _conn(),
    ws,
    dashboard: DashboardClient(
      host: '10.0.0.5',
      proxied: true,
      httpClient: httpClient,
    ),
  );
  await ws.connect().timeout(const Duration(seconds: 5));
  await ws.waitForGatewayReady().timeout(const Duration(seconds: 5));
  final chat = NgChatController(gateway, sessionId: 'stored-9');
  addTeardown(() {
    chat.dispose();
    gateway.dispose();
    ws.close();
    httpClient.close();
  });
  return (chat: chat, gateway: gateway);
}
