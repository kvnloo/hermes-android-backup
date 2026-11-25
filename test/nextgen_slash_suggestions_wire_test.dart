// `complete.slash` over a real `/api/ws` socket (loopback): the frame
// carries the connection's Hermes profile the way every NextGen call does
// (the gateway uses it for a draft with no session), a method-not-found
// answer is remembered for that socket only, and the gateway's reply shapes
// (command names, TUI extras, glyphs, argument stubs) parse.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/data/slash_suggest.dart';
import 'package:shared_preferences/shared_preferences.dart';

SavedConnection _connection() => SavedConnection(
  id: 'suggest-wire',
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

typedef _Reply = Map<String, dynamic>? Function(Map<String, dynamic> params);

final _serverSockets = Expando<List<WebSocket>>('server sockets');

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

  Future<(_LiveGateway, List<Map<String, dynamic>>)> open(
    Map<String, _Reply> replies,
  ) async {
    final (server, frames) = await _server(replies);
    final gateway = _LiveGateway(await _socket(server));
    addTearDown(() async {
      gateway.dispose();
      gateway.ws.close();
      await _drop(server);
    });
    return (gateway, frames);
  }

  test('a live chat sends its session, a draft only the profile', () async {
    final (gateway, frames) = await open({
      'complete.slash': (p) => {
        'result': {
          'items': [
            // The exact-match form carries a trailing space; the TUI extras
            // carry their slash; skills, bundles and plugins a glyph.
            {
              'text': 'title ',
              'display': '/title',
              'meta': 'Set a title',
              'kind': 'command',
            },
            {
              'text': '/details',
              'display': '/details',
              'meta': 'Control agent detail visibility',
              'kind': 'command',
            },
            {
              'text': 'tidy',
              'display': '/tidy',
              'meta': '⚡ Tidy the repo',
              'kind': 'skill',
            },
          ],
          'replace_from': 1,
        },
      },
    });

    final live = await ngCompleteSlash(gateway, '/ti', sessionId: 'rt-1');
    final draft = await ngCompleteSlash(gateway, '/ti');
    expect(frames.map((f) => f['params']), [
      {'text': '/ti', 'session_id': 'rt-1', 'profile': 'work'},
      {'text': '/ti', 'profile': 'work'},
    ]);
    expect(draft, isNotNull);
    expect(live!.isArgument, isFalse);
    expect(live.items.map((i) => (i.label, i.insert, i.description, i.kind)), [
      ('/title', '/title', 'Set a title', NgSlashSuggestionKind.command),
      (
        '/details',
        '/details',
        'Control agent detail visibility',
        NgSlashSuggestionKind.command,
      ),
      ('/tidy', '/tidy', 'Tidy the repo', NgSlashSuggestionKind.skill),
    ]);
  });

  test('-32601 is remembered for that socket only', () async {
    final (gateway, frames) = await open({
      'complete.slash': (p) => {
        'error': {'code': -32601, 'message': 'unknown method: complete.slash'},
      },
    });
    await expectLater(
      ngCompleteSlash(gateway, '/ti'),
      throwsA(isA<JsonRpcError>()),
    );
    expect(frames, hasLength(1));
    expect(ngCompleteSlashUnsupported(gateway.ws), isTrue);

    final (upgraded, upgradedFrames) = await _server({
      'complete.slash': (p) => {
        'result': {'items': <Object>[], 'replace_from': 1},
      },
    });
    addTearDown(() => _drop(upgraded));
    gateway.ws.close();
    gateway.ws = await _socket(upgraded);
    expect(ngCompleteSlashUnsupported(gateway.ws), isFalse);
    final answer = await ngCompleteSlash(gateway, '/ti');
    expect(answer!.items, isEmpty);
    expect(upgradedFrames.single['params']['profile'], 'work');
  });

  group('drafts', () {
    NgSlashQuery? q(String text, [int? caret]) => NgSlashQuery.of(
      TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: caret ?? text.length),
      ),
    );

    test('the leading token on the first line, or a one-line argument', () {
      expect(q('/')!.name, '');
      expect(q('/ti')!.name, 'ti');
      expect(q('  /ti')!.text, '/ti');
      expect(q('/title Trip', 3)!.text, '/ti');
      expect(q('/title Trip', 3)!.isArgument, isFalse);
      expect(q('/personality al')!.isArgument, isTrue);
      expect(q('/personality al')!.name, 'personality');
      for (final prose in [
        'hello',
        'please /help',
        '/usr/bin',
        '//x',
        '\n/ti',
        '/title Trip\nmore',
      ]) {
        expect(q(prose), isNull, reason: prose);
      }
      expect(q('/title Trip', 8), isNull, reason: 'caret inside the argument');
      expect(
        NgSlashQuery.of(
          const TextEditingValue(
            text: '/ti',
            selection: TextSelection(baseOffset: 1, extentOffset: 3),
          ),
        ),
        isNull,
        reason: 'a selection',
      );
    });

    test('accepting replaces the token or the argument and adds one space', () {
      const title = NgSlashSuggestion(label: '/title', insert: '/title');
      expect(q('/ti')!.apply('/ti', title).text, '/title ');
      expect(q('/ti')!.apply('/ti', title).selection.baseOffset, 7);
      final mid = q('/ti now', 2)!;
      expect(mid.apply('/ti now', title).text, '/title now');
      expect(mid.apply('/ti now', title).selection.baseOffset, 7);

      const alice = NgSlashSuggestion(
        label: 'alice',
        insert: 'alice',
        kind: NgSlashSuggestionKind.option,
      );
      final arg = q('/personality al')!;
      final filled = arg.apply('/personality al', alice, replaceFrom: 13);
      expect(filled.text, '/personality alice ');
      expect(filled.selection.baseOffset, 19);

      // `/details` answers with a leading space and replace_from at the end.
      final details = NgSlashCompletion.parse('/details', {
        'items': [
          {'text': ' tools', 'display': ' tools', 'meta': 'Tool rows'},
        ],
        'replace_from': 8,
      })!;
      expect(details.isArgument, isTrue);
      expect(details.items.single.label, 'tools');
      expect(
        q(
          '/details',
        )!.apply('/details', details.items.single, replaceFrom: 8).text,
        '/details tools ',
      );
    });

    test('a reply without items is unusable', () {
      expect(NgSlashCompletion.parse('/ti', const {}), isNull);
      expect(NgSlashCompletion.parse('/ti', null), isNull);
    });
  });
}
