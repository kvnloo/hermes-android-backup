// setup_beat over a real loopback gateway (HTTP ticket + WebSocket JSON-RPC):
// the card's answer is the JSON-RPC response to the server's request, sent
// only for the chat that owns it and only while it is still open.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/render/setup_beat.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/ws_client.dart';

const _deadline = Duration(seconds: 5);

void main() {
  late _Gateway gateway;
  late DesktopGatewayClient client;
  late StreamController<(String, StreamEvent)> events;

  setUp(() async {
    gateway = await _Gateway.start();
    client = gateway.client();
    events = StreamController<(String, StreamEvent)>.broadcast(sync: true);
    client.setAsyncEventListener((session, event) {
      events.add((session, event));
    });
    await client.ensureSession('local');
  });

  tearDown(() async {
    client.close();
    await events.close();
    await gateway.close();
  });

  Future<(String, StreamEvent)> next(String type) => events.stream
      .firstWhere((entry) => entry.$2.type == type)
      .timeout(_deadline);

  Future<SetupBeatRequest> raise(String id, Map<String, dynamic> card) async {
    final received = next('setup_beat.request');
    gateway.request(id, 'setup_beat', {
      'session_id': 'runtime-local',
      'beat': 'build',
      'question': 'What should we build first?',
      'tool_call_id': 'call-$id',
      'card': card,
    });
    final (session, event) = await received;
    expect(session, 'local');
    final request = SetupBeatRequest.parse(
      event.data['request_id'] as String,
      event.data,
    );
    expect(request, isNotNull);
    return request!;
  }

  const options = {
    'options': [
      {'id': 'site', 'label': 'A website'},
      {'id': 'own', 'label': 'Something else'},
    ],
  };

  test('a pick is the response to that request, on its socket', () async {
    final card = await raise('sb-1', options);
    expect(card.beat, SetupBeatKind.build);
    expect(card.toolCallId, 'call-sb-1');
    expect(card.options.map((option) => option.label), [
      'A website',
      'Something else',
    ]);
    final responded = gateway.response('sb-1');
    expect(
      client.respondToSetupBeat(
        sessionId: 'local',
        requestId: card.requestId,
        result: card.answerFor(card.options.first),
      ),
      isTrue,
    );
    expect((await responded)['result'], {
      'answer': {'build': 'site', 'label': 'A website'},
    });
    // Answered once: a second tap sends nothing.
    expect(
      client.respondToSetupBeat(
        sessionId: 'local',
        requestId: card.requestId,
        result: const {},
      ),
      isFalse,
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(
      gateway.responses.where((frame) => frame['id'] == 'sb-1'),
      hasLength(1),
    );
  });

  test('closing the card answers {} as the Desktop does', () async {
    final card = await raise('sb-close', options);
    final responded = gateway.response('sb-close');
    expect(
      client.respondToSetupBeat(
        sessionId: 'local',
        requestId: card.requestId,
        result: const {},
      ),
      isTrue,
    );
    expect((await responded)['result'], <String, dynamic>{});
  });

  test('a withdrawn request is never answered', () async {
    final card = await raise('sb-2', options);
    final cancelled = next('request.cancel');
    gateway.event('request.cancel', {'id': 'sb-2', 'reason': 'timeout'});
    final (session, cancel) = await cancelled;
    expect(session, 'local');
    expect(cancel.data['id'], card.requestId);
    expect(
      client.respondToSetupBeat(
        sessionId: 'local',
        requestId: card.requestId,
        result: card.answerFor(card.options.first),
      ),
      isFalse,
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(gateway.responses.where((frame) => frame['id'] == 'sb-2'), isEmpty);
  });

  test('another chat cannot answer the card', () async {
    final card = await raise('sb-3', options);
    expect(
      client.respondToSetupBeat(
        sessionId: 'other-chat',
        requestId: card.requestId,
        result: card.answerFor(card.options.first),
      ),
      isFalse,
    );
    // A wire id is not a handle: only the local key this chat received is.
    expect(
      client.respondToSetupBeat(
        sessionId: 'local',
        requestId: 'sb-3',
        result: const {},
      ),
      isFalse,
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(gateway.responses.where((frame) => frame['id'] == 'sb-3'), isEmpty);
    expect(client.ownsServerRequest(card.requestId, 'setup_beat'), isTrue);
  });

  test('a second connection never holds the first one\'s card', () async {
    final card = await raise('sb-4', options);
    final second = gateway.client(id: 'second-connection');
    addTearDown(second.close);
    second.setAsyncEventListener((_, _) {});
    expect(
      second.respondToSetupBeat(
        sessionId: 'local',
        requestId: card.requestId,
        result: const {},
      ),
      isFalse,
    );
    expect(second.ownsServerRequest(card.requestId, 'setup_beat'), isFalse);
  });

  test('every beat parses to its own card shape', () {
    SetupBeatRequest? parse(String beat, Map<String, dynamic> card) =>
        SetupBeatRequest.parse('k', {'beat': beat, 'card': card});
    expect(
      parse('name', {'suggested': 'Ada Lovelace'})?.suggestedName,
      'Ada Lovelace',
    );
    expect(parse('name', {})?.answerable, isTrue);
    expect(parse('theme', {'picker': 'accent'})?.answerable, isFalse);
    expect(
      parse('plugins', {
        'plugins': ['blender', 'figma'],
      })?.names,
      ['blender', 'figma'],
    );
    expect(
      parse('connectors', {
        'suggested': ['github'],
      })?.names,
      ['github'],
    );
    final layout = parse('layout', {
      'options': [
        {'id': 'sidebar-left', 'label': 'Basic'},
      ],
    })!;
    expect(layout.answerFor(layout.options.single), {
      'answer': {'layout': 'sidebar-left'},
    });
    final tour = parse('tour', {
      'options': [
        {'id': 'quick', 'label': 'Quick tour'},
      ],
    })!;
    expect(tour.answerFor(tour.options.single), {
      'answer': {'tour': 'quick', 'label': 'Quick tour'},
    });
    expect(parse('dance', {}), isNull);
    expect(SetupBeatRequest.parse('', {'beat': 'name', 'card': {}}), isNull);
  });
}

/// Real loopback HTTP ticket mint + WebSocket JSON-RPC that records the
/// client's responses to server requests.
class _Gateway {
  _Gateway(this.server);

  final HttpServer server;
  final sockets = <WebSocket>[];
  final responses = <Map<String, dynamic>>[];
  final _responses = StreamController<Map<String, dynamic>>.broadcast(
    sync: true,
  );

  static Future<_Gateway> start() async {
    final gateway = _Gateway(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    gateway.server.listen(gateway._http);
    return gateway;
  }

  DesktopGatewayClient client({String id = 'setup-fixture'}) =>
      DesktopGatewayClient.fromConnection(
        SavedConnection(
          id: id,
          label: 'Fixture',
          host: '127.0.0.1',
          port: server.port,
          apiKey: 'fixture-key',
          dashboardPortOverride: server.port,
          dashboardProxied: true,
          desktopGatewayUrl: 'http://127.0.0.1:${server.port}',
        ),
      );

  Future<Map<String, dynamic>> response(String id) {
    for (final frame in responses) {
      if (frame['id'] == id) return Future.value(frame);
    }
    return _responses.stream
        .firstWhere((frame) => frame['id'] == id)
        .timeout(_deadline);
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
        if (method == null) {
          responses.add(frame);
          _responses.add(frame);
          return;
        }
        final params = frame['params'];
        final result = switch (method) {
          'session.resume' => {
            'session_id': 'runtime-${(params as Map)['session_id']}',
            'running': false,
            'status': 'idle',
          },
          'session.create' => {
            'session_id': 'runtime-local',
            'stored_session_id': 'stored-local',
            'message_count': 0,
            'messages': <dynamic>[],
          },
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

  void event(String type, Map<String, dynamic> payload) {
    sockets.last.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'method': 'event',
        'params': {
          'type': type,
          'session_id': 'runtime-local',
          'payload': payload,
        },
      }),
    );
  }

  Future<void> close() async {
    for (final socket in sockets) {
      await socket.close();
    }
    await server.close(force: true);
    await _responses.close();
  }
}
