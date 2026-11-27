// The manage_catalog answer and retry on the wire: connection.respond is
// owned by the chat's runtime session over a real loopback socket, and a
// settled plugin retry installs by catalog name into the row's profile.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/capabilities/capability_admin.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';

const _deadline = Duration(seconds: 5);

void main() {
  group('catalog wire', () {
    test('connection.respond is owned by the chat runtime session', () async {
      final gateway = await _LoopbackGateway.start();
      final client = gateway.client();
      addTearDown(() async {
        client.close();
        await gateway.close();
      });
      client.setAsyncEventListener((_, _) {});
      await client.ensureSession('local');
      expect(
        await client.respondToConnection(
          sessionId: 'local',
          opId: 'op-1',
          result: const {
            'targets': [
              {'name': 'blender', 'status': 'approved'},
            ],
          },
        ),
        isTrue,
      );
      final rpc = await gateway.take('connection.respond');
      expect(rpc, {
        'owner': {'type': 'session', 'session_id': 'runtime-local'},
        'op_id': 'op-1',
        'result': {
          'targets': [
            {'name': 'blender', 'status': 'approved'},
          ],
        },
      });
      // A chat with no runtime session on this connection sends nothing.
      expect(
        await client.respondToConnection(
          sessionId: 'other-chat',
          opId: 'op-1',
          result: const {},
        ),
        isFalse,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(gateway.calls('connection.respond'), hasLength(1));
    });

    test(
      'a catalog retry installs by catalog name into that profile',
      () async {
        final sent = <(String, Map<String, dynamic>)>[];
        final admin = CapabilityAdmin(
          profile: 'default',
          rest: (method, path, {query, body, timeout}) =>
              throw StateError('no REST'),
          rpc: (method, params) async {
            sent.add((method, params));
            return {'ok': true};
          },
        );
        final result = await admin.installCatalogPlugin(
          'blender',
          profile: 'work',
          force: true,
          ref: 'abc',
        );
        expect(result.ok, isTrue);
        expect(sent.single.$1, 'plugins.manage');
        expect(sent.single.$2, {
          'action': 'install',
          'identifier': '',
          'catalog_name': 'blender',
          'force': true,
          'enable': true,
          'ref': 'abc',
          'profile': 'work',
        });
      },
    );
  });
}

/// Real loopback HTTP ticket + WebSocket JSON-RPC that records calls.
class _LoopbackGateway {
  _LoopbackGateway(this.server);

  final HttpServer server;
  final sockets = <WebSocket>[];
  final requests = <Map<String, dynamic>>[];
  final _received = StreamController<Map<String, dynamic>>.broadcast(
    sync: true,
  );

  static Future<_LoopbackGateway> start() async {
    final gateway = _LoopbackGateway(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    gateway.server.listen(gateway._http);
    return gateway;
  }

  DesktopGatewayClient client() => DesktopGatewayClient.fromConnection(
    SavedConnection(
      id: 'catalog-fixture',
      label: 'Fixture',
      host: '127.0.0.1',
      port: server.port,
      apiKey: 'fixture-key',
      dashboardPortOverride: server.port,
      dashboardProxied: true,
      desktopGatewayUrl: 'http://127.0.0.1:${server.port}',
    ),
  );

  Iterable<Map<String, dynamic>> calls(String method) =>
      requests.where((frame) => frame['method'] == method);

  Future<Map<String, dynamic>> take(String method) async {
    for (final frame in requests) {
      if (frame['method'] == method) {
        return Map<String, dynamic>.from(frame['params'] as Map);
      }
    }
    final frame = await _received.stream
        .firstWhere((frame) => frame['method'] == method)
        .timeout(_deadline);
    return Map<String, dynamic>.from(frame['params'] as Map);
  }

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
        if (method == null) return;
        requests.add(frame);
        _received.add(frame);
        final params = frame['params'];
        final result = switch (method) {
          'session.resume' => {
            'session_id': 'runtime-${(params as Map)['session_id']}',
            'running': false,
            'status': 'idle',
          },
          'connection.respond' => {'status': 'ok', 'settled': false},
          _ => {'ok': true},
        };
        socket.add(
          jsonEncode({'jsonrpc': '2.0', 'id': frame['id'], 'result': result}),
        );
      });
    } else {
      request.response.statusCode = 404;
      await request.response.close();
    }
  }

  Future<void> close() async {
    for (final socket in sockets) {
      await socket.close();
    }
    await server.close(force: true);
    await _received.close();
  }
}
