import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';

void main() {
  test(
    'live /api/plugins/kanban/events upgrade uses a single-use ticket without bearer tokens in URL',
    () async {
      Uri? seenWsUri;
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));

      server.listen((req) async {
        if (req.uri.path == '/auth/password-login') {
          req.response.headers.set('set-cookie', 'hermes_session_at=cookie-1');
          req.response.write(jsonEncode({'ok': true}));
          await req.response.close();
          return;
        }
        if (req.uri.path == '/api/auth/ws-ticket') {
          req.response.write(
            jsonEncode({'ticket': 'one-use-kanban-ticket', 'ttl_seconds': 30}),
          );
          await req.response.close();
          return;
        }
        if (req.uri.path == '/api/ws') {
          final ws = await WebSocketTransformer.upgrade(
            req,
            protocolSelector: (_) => 'hermes-gateway-v1',
          );
          ws.add(
            jsonEncode({
              'jsonrpc': '2.0',
              'method': 'event',
              'params': {
                'type': 'gateway.ready',
                'payload': {
                  'replay_epoch': 'fixture',
                  'session_authority': true,
                },
              },
            }),
          );
          ws.listen((raw) {
            final frame = jsonDecode(raw as String) as Map<String, dynamic>;
            ws.add(
              jsonEncode({
                'jsonrpc': '2.0',
                'id': frame['id'],
                'result': <String, dynamic>{},
              }),
            );
          });
          return;
        }
        if (req.uri.path == '/api/plugins/kanban/events') {
          seenWsUri = req.uri;
          final ws = await WebSocketTransformer.upgrade(req);
          ws.add(
            jsonEncode({
              'cursor': 42,
              'events': [
                {
                  'id': 42,
                  'task_id': 't_live_1',
                  'kind': 'completed',
                  'created_at': 1700000000,
                },
              ],
            }),
          );
          return;
        }
        req.response.statusCode = 404;
        await req.response.close();
      });

      final conn = SavedConnection(
        id: 'c-live-kanban',
        label: 'Loopback Kanban',
        host: '127.0.0.1',
        port: server.port,
        apiKey: 'secret-api-key-never-in-url',
        dashboardUsername: 'admin',
        dashboardPassword: 'secret-password',
        dashboardPortOverride: server.port,
        desktopGatewayUrl: 'http://127.0.0.1:${server.port}',
        gatewayProfile: 'work',
      );
      final gateway = DesktopGatewayClient.fromConnection(conn);
      gateway.setReconnectAllowed(false);
      addTearDown(gateway.close);

      final pane = gateway.workspace.pane();
      addTearDown(pane.close);
      final target = await pane.bind(gateway.workspace.route());

      final received = Completer<KanbanEventsFrame>();
      final sub = await target.watchKanbanEvents(
        board: 'ops-board',
        since: 40,
        onFrame: (frame) {
          if (!received.isCompleted) received.complete(frame);
        },
      );
      expect(sub, isNotNull);
      addTearDown(() => sub!.cancel());

      final frame = await received.future.timeout(const Duration(seconds: 5));
      expect(frame.cursor, 42);
      expect(frame.events.single.kind, 'completed');
      expect(seenWsUri, isNotNull);
      expect(seenWsUri!.queryParameters['ticket'], 'one-use-kanban-ticket');
      expect(seenWsUri!.queryParameters['board'], 'ops-board');
      expect(seenWsUri!.queryParameters['since'], '40');
      expect(seenWsUri!.queryParameters['profile'], 'work');
      expect(seenWsUri!.queryParameters.containsKey('token'), isFalse);
      expect('$seenWsUri', isNot(contains('secret')));
    },
  );
}
