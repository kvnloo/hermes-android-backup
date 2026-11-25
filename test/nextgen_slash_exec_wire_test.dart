// NextGen's slash commands over a real `/api/ws` socket (loopback): the
// frames carry the connection's Hermes profile the way every NextGen call
// does, a structured refusal reaches `command.dispatch`, and a gateway with
// no `slash.exec` is remembered for that socket only.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/data/slash_exec.dart';
import 'package:shared_preferences/shared_preferences.dart';

SavedConnection _connection() => SavedConnection(
  id: 'wire',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: '',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
  dashboardProxied: true,
  gatewayProfile: 'work',
);

/// A reply frame body, or null to never answer.
typedef _Reply = Map<String, dynamic>? Function(Map<String, dynamic> params);

/// Loopback gateway: records every request frame and answers from [replies]
/// (`{'result': …}` or `{'error': …}`), or `{}` for anything else.
final _serverSockets = Expando<List<WebSocket>>('server sockets');

/// Drops every upgraded socket [server] accepted (closing the server alone
/// leaves upgraded WebSockets open).
Future<void> _drop(HttpServer server) async {
  for (final ws in _serverSockets[server] ?? const <WebSocket>[]) {
    await ws.close();
  }
  await server.close(force: true);
}

Future<(HttpServer, List<Map<String, dynamic>>)> _server(
  Map<String, _Reply> replies,
) async {
  final frames = <Map<String, dynamic>>[];
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final sockets = _serverSockets[server] = <WebSocket>[];
  server.listen((req) async {
    final ws = await WebSocketTransformer.upgrade(req);
    sockets.add(ws);
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
      final id = frame['id'];
      if (id == null) return;
      frames.add(frame);
      final params = Map<String, dynamic>.from(frame['params'] as Map);
      final handler = replies[frame['method']];
      final reply = handler == null ? {'result': {}} : handler(params);
      if (reply == null) return;
      ws.add(jsonEncode({'jsonrpc': '2.0', 'id': id, ...reply}));
    });
  });
  return (server, frames);
}

/// The socket is a real [WsClient]; `call` is [NextGenGateway.call]'s body.
class _LiveGateway extends NextGenGateway {
  _LiveGateway(this.ws) : super(_connection());

  WsClient ws;

  @override
  WsClient? get socket => ws;

  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

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
    final error = response['error'];
    if (error != null) {
      throw JsonRpcError.fromGateway(
        method,
        error is Map ? error : const {},
        fallbackMessage: 'refused',
      );
    }
    final result = response['result'];
    return result is Map ? Map<String, dynamic>.from(result) : {};
  }
}

Future<WsClient> _socket(HttpServer server) async {
  final ws = WsClient('http://127.0.0.1:${server.port}', profile: 'work');
  await ws.connect().timeout(const Duration(seconds: 5));
  await ws.waitForGatewayReady().timeout(const Duration(seconds: 5));
  return ws;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<(NgChatController, _LiveGateway, List<Map<String, dynamic>>)> open(
    Map<String, _Reply> replies,
  ) async {
    final (server, frames) = await _server(replies);
    final ws = await _socket(server);
    final gateway = _LiveGateway(ws);
    final chat = NgChatController(gateway, sessionId: 'stored-1')
      ..runtimeId = 'rt-1';
    addTearDown(() async {
      chat.dispose();
      gateway.dispose();
      gateway.ws.close();
      await _drop(server);
    });
    return (chat, gateway, frames);
  }

  test('slash.exec carries the session and the connection profile', () async {
    final (chat, _, frames) = await open({
      'slash.exec': (p) => {
        'result': {'output': 'Title: Trip'},
      },
    });

    final outcome = await chat.runCommand(NgSlashLine.parse('/title')!);

    expect(outcome.result, NgCommandResult.done);
    expect(frames.map((f) => f['method']), ['slash.exec']);
    expect(frames.single['params'], {
      'session_id': 'rt-1',
      'command': 'title',
      'profile': 'work',
    });
    expect(chat.items.whereType<NgCommandItem>().single.output, 'Title: Trip');
  });

  test('a structured refusal goes to command.dispatch with the same '
      'scoping; nothing is prompted', () async {
    final (chat, _, frames) = await open({
      'slash.exec': (p) => {
        'error': {
          'code': 4001,
          'message': 'unsupported_command',
          'data': {'reason': 'unsupported_command'},
        },
      },
      'command.dispatch': (p) => {
        'result': {
          'type': 'skill',
          'message': 'SKILL BODY',
          'display': '/review the diff',
        },
      },
      'prompt.submit': (p) => {
        'result': {'status': 'started'},
      },
    });

    final outcome = await chat.runCommand(
      NgSlashLine.parse('/review the diff')!,
    );

    expect(outcome.result, NgCommandResult.sentAsPrompt);
    expect(frames.map((f) => f['method']), [
      'slash.exec',
      'command.dispatch',
      'prompt.submit',
    ]);
    expect(frames[1]['params'], {
      'session_id': 'rt-1',
      'name': 'review',
      'arg': 'the diff',
      'profile': 'work',
    });
    expect(frames[2]['params']['text'], 'SKILL BODY');
    expect(frames[2]['params']['profile'], 'work');
    final bubble = chat.items.whereType<NgUserItem>().single;
    expect(bubble.text, '/review the diff');
    expect(bubble.sentText, 'SKILL BODY');
  });

  test('a gateway error shows without a fallback; a dropped socket is '
      'neither dispatched nor prompted', () async {
    final (chat, gateway, frames) = await open({
      'slash.exec': (p) => {
        'error': {'code': 5030, 'message': 'slash worker start failed'},
      },
    });
    final failed = await chat.runCommand(NgSlashLine.parse('/help')!);
    expect(failed.result, NgCommandResult.failed);
    expect(frames.map((f) => f['method']), ['slash.exec']);

    // A gateway that takes the command and never answers, then drops.
    final (silent, silentFrames) = await _server({'slash.exec': (p) => null});
    gateway.ws.close();
    gateway.ws = await _socket(silent);
    final pending = chat.runCommand(NgSlashLine.parse('/help')!);
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (silentFrames.isEmpty && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(silentFrames.map((f) => f['method']), ['slash.exec']);
    await _drop(silent);
    final lost = await pending.timeout(const Duration(seconds: 5));
    expect(lost.result, NgCommandResult.deliveryUnknown);
    expect(lost.item!.failed, isTrue);
    expect(silentFrames, hasLength(1), reason: 'no dispatch, no prompt');
    expect(chat.items.whereType<NgUserItem>(), isEmpty);
  });

  test('-32601 is remembered for that socket only', () async {
    final (chat, gateway, frames) = await open({
      'slash.exec': (p) => {
        'error': {'code': -32601, 'message': 'unknown method: slash.exec'},
      },
    });

    final first = await chat.runCommand(NgSlashLine.parse('/help')!);
    expect(first.result, NgCommandResult.unsupported);
    expect(chat.items.whereType<NgCommandItem>(), isEmpty);
    final again = await chat.runCommand(NgSlashLine.parse('/status')!);
    expect(again.result, NgCommandResult.unsupported);
    expect(frames, hasLength(1), reason: 'not asked twice on one socket');

    // A reconnect may be an upgraded gateway.
    final (upgraded, upgradedFrames) = await _server({
      'slash.exec': (p) => {
        'result': {'output': 'help text'},
      },
    });
    addTearDown(() => _drop(upgraded));
    gateway.ws.close();
    gateway.ws = await _socket(upgraded);
    final third = await chat.runCommand(NgSlashLine.parse('/help')!);
    expect(third.result, NgCommandResult.done);
    expect(upgradedFrames.single['params']['profile'], 'work');
  });
}
