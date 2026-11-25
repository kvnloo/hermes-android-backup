// Classic Desktop-gateway client: a request another device answered is
// dropped once the legacy gateway's `open_requests` no longer lists it. That
// gateway settles an answered request without `request.cancel` to the other
// viewers (hermes-agent tui_gateway/server_requests.py::resolve_response).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/ws_client.dart';

const _deadline = Duration(seconds: 5);

void main() {
  late _Gateway gateway;
  late DesktopGatewayClient client;
  late List<StreamEvent> events;

  setUp(() async {
    gateway = await _Gateway.start();
    client = gateway.client();
    events = [];
    client.setAsyncEventListener((_, event) => events.add(event));
    addTearDown(() async {
      client.close();
      await gateway.close();
    });
    await client.ensureSession('local');
  });

  Future<String> ask(String id) async {
    gateway.open[id] = true;
    gateway.request(id, 'clarify', {
      'session_id': 'runtime-local',
      'questions': [
        {'qid': 'q1', 'question': 'Which branch?', 'choices': <String>[]},
      ],
    });
    final deadline = DateTime.now().add(_deadline);
    while (!events.any((e) => e.type == 'clarify.request') &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    final request = events.lastWhere((e) => e.type == 'clarify.request');
    expect(request.data['wire_request_id'], id);
    return request.data['server_request_id'] as String;
  }

  test('a request still open is kept', () async {
    final key = await ask('srq-open');
    await client.revalidateServerRequests();
    expect(client.ownsServerRequest(key, 'clarify'), isTrue);
    expect(events.where((e) => e.type == 'request.cancel'), isEmpty);
    expect(gateway.methods, contains('session.events.since'));
  });

  test('a request answered on another device is withdrawn, never answered '
      'or resent', () async {
    final key = await ask('srq-elsewhere');
    gateway.open.remove('srq-elsewhere'); // answered on Windows; no cancel
    await client.revalidateServerRequests();

    expect(client.ownsServerRequest(key, 'clarify'), isFalse);
    final cancel = events.singleWhere((e) => e.type == 'request.cancel');
    expect(cancel.data['id'], key);
    expect(
      gateway.methods.where(
        (m) =>
            m.startsWith('clarify.') ||
            m.startsWith('approval.') ||
            m == 'prompt.submit',
      ),
      isEmpty,
    );
    expect(gateway.responses, isEmpty, reason: 'no answer frame was sent');
  });
}

class _Gateway {
  _Gateway(this.server);

  final HttpServer server;
  final sockets = <WebSocket>[];
  final methods = <String>[];
  final responses = <Map<String, dynamic>>[];

  /// Server request ids the gateway still waits on.
  final open = <String, bool>{};

  static Future<_Gateway> start() async {
    final gateway = _Gateway(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    gateway.server.listen(gateway._http);
    return gateway;
  }

  DesktopGatewayClient client() => DesktopGatewayClient.fromConnection(
    SavedConnection(
      id: 'remote-answer-fixture',
      label: 'Fixture',
      host: '127.0.0.1',
      port: server.port,
      apiKey: 'k',
      dashboardPortOverride: server.port,
      dashboardProxied: true,
      desktopGatewayUrl: 'http://127.0.0.1:${server.port}',
    ),
  );

  Future<void> _http(HttpRequest request) async {
    if (request.uri.path == '/api/auth/ws-ticket') {
      request.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'ticket': 'fixture-ticket'}));
      await request.response.close();
    } else if (WebSocketTransformer.isUpgradeRequest(request)) {
      final socket = await WebSocketTransformer.upgrade(request);
      sockets.add(socket);
      socket.listen((raw) {
        final frame = Map<String, dynamic>.from(
          jsonDecode(raw as String) as Map,
        );
        final method = frame['method'];
        if (method == null) {
          responses.add(frame);
          return;
        }
        methods.add(method as String);
        final params = Map<String, dynamic>.from(frame['params'] as Map);
        Map<String, dynamic> result = {'ok': true};
        if (method == 'session.create') {
          result = {
            'session_id': 'runtime-local',
            'stored_session_id': 'stored-local',
            'message_count': 0,
            'messages': <dynamic>[],
          };
        } else if (method == 'session.resume') {
          result = {'session_id': 'runtime-local', 'running': true};
        } else if (method == 'session.events.since') {
          result = {
            'events': <dynamic>[],
            'latest_seq': 0,
            'truncated': false,
            'count': 0,
            'epoch': 'e1',
            'open_requests': [
              for (final id in open.keys)
                if (params['session_id'] == 'runtime-local')
                  {
                    'id': id,
                    'method': 'clarify',
                    'params': {'session_id': 'runtime-local'},
                  },
            ],
          };
        }
        socket.add(
          jsonEncode({'jsonrpc': '2.0', 'id': frame['id'], 'result': result}),
        );
      });
    } else {
      request.response.statusCode = 404;
      await request.response.close();
    }
  }

  void request(String id, String method, Map<String, dynamic> params) {
    sockets.last.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'id': id,
        'method': method,
        'params': params,
      }),
    );
  }

  Future<void> close() async {
    for (final socket in sockets) {
      await socket.close();
    }
    await server.close(force: true);
  }
}
