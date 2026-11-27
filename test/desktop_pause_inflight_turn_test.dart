// An in-flight streaming turn across a sleep/lock pause and resume, in both
// layouts: nothing is applied twice, the prompt is never submitted again,
// and keep-awake's reconcile waits for the chat to catch up.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/normal_gateway_application_session.dart';
import 'package:hermes_android/core/services/normal_gateway_pending_store.dart';
import 'package:hermes_android/core/services/system_sleep_gate.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/canonical_replay_fixture.dart';

/// A loopback legacy gateway with a replay ring: it streams a turn's events
/// live, keeps every event for `session.events.since`, and records each
/// method it is asked.
class _StreamingGateway {
  _StreamingGateway._(this.server);

  final HttpServer server;
  final methods = <String>[];
  final replayCalls = <Map<String, dynamic>>[];
  final _ring = <Map<String, dynamic>>[];
  final _sockets = <WebSocket>{};
  final _changes = StreamController<void>.broadcast();
  bool running = false;
  int opened = 0;

  /// The legacy dispatcher's ready frame (one epoch per server process).
  final ready = fixtureMap(['legacy', 'ready_frame']);
  String get epoch =>
      ((ready['params'] as Map)['payload'] as Map)['replay_epoch'] as String;

  int get live => _sockets.length;
  int count(String method) => methods.where((m) => m == method).length;

  static Future<_StreamingGateway> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final gateway = _StreamingGateway._(server);
    server.listen(gateway._handle);
    return gateway;
  }

  Future<void> _handle(HttpRequest req) async {
    if (req.uri.path == '/api/ws' &&
        WebSocketTransformer.isUpgradeRequest(req)) {
      final ws = await WebSocketTransformer.upgrade(
        req,
        protocolSelector: (protocols) => protocols.contains('hermes-gateway-v1')
            ? 'hermes-gateway-v1'
            : null,
      );
      opened++;
      _sockets.add(ws);
      _changes.add(null);
      ws.add(jsonEncode(ready));
      ws.listen(
        (raw) => _onMessage(ws, jsonDecode(raw as String) as Map),
        onDone: () {
          _sockets.remove(ws);
          _changes.add(null);
        },
      );
      return;
    }
    req.response.headers.contentType = ContentType.json;
    req.response.write(
      jsonEncode(
        req.uri.path == '/api/auth/ws-ticket'
            ? {'ticket': 'fixture-ws-ticket'}
            : <String, Object>{},
      ),
    );
    await req.response.close();
  }

  void _onMessage(WebSocket ws, Map message) {
    final method = message['method'] as String?;
    if (method != null) methods.add(method);
    _changes.add(null);
    if (!message.containsKey('id')) return;
    final params = (message['params'] as Map?)?.cast<String, dynamic>() ?? {};
    final Object result = switch (method) {
      'session.resume' => {
        'session_id': 'rt',
        'running': running,
        'info': <String, Object>{},
        'open_requests': <Object>[],
      },
      'session.events.since' => _replay(params),
      'prompt.submit' => <String, Object>{},
      _ => <String, Object>{},
    };
    ws.add(
      jsonEncode({'jsonrpc': '2.0', 'id': message['id'], 'result': result}),
    );
    if (method == 'prompt.submit') {
      // The turn starts streaming right after the submission is accepted.
      running = true;
      scheduleMicrotask(() {
        produce('message.start');
        produce('message.delta', {'text': 'Hel'});
        produce('message.delta', {'text': 'lo'});
      });
    }
  }

  Map<String, Object> _replay(Map<String, dynamic> params) {
    replayCalls.add(Map.of(params));
    final from = (params['last_seen'] as num).toInt();
    // Deliberately starts one event early: a replay may repeat what the
    // client already applied, and it must not apply it twice.
    final events = _ring.where((e) => (e['seq'] as int) >= from).toList();
    return {
      'events': events,
      'latest_seq': _ring.isEmpty ? 0 : _ring.last['seq'] as int,
      'truncated': false,
      'epoch': epoch,
    };
  }

  /// Appends one event to the ring and streams it to every live socket.
  void produce(String type, [Map<String, dynamic>? payload]) {
    final event = {
      'type': type,
      'session_id': 'rt',
      'payload': payload ?? <String, Object>{},
      'seq': _ring.length + 1,
    };
    _ring.add(event);
    for (final ws in _sockets) {
      ws.add(
        jsonEncode({'jsonrpc': '2.0', 'method': 'event', 'params': event}),
      );
    }
  }

  Future<void> until(bool Function() condition) async {
    final deadline = DateTime.now().add(const Duration(seconds: 10));
    while (!condition()) {
      if (DateTime.now().isAfter(deadline)) {
        throw TimeoutException('gateway condition not met');
      }
      await Future.any([
        _changes.stream.first,
        Future<void>.delayed(const Duration(milliseconds: 20)),
      ]);
    }
  }

  SavedConnection connection() => SavedConnection(
    id: 'pause-turn',
    label: 'Pause turn',
    host: '127.0.0.1',
    port: server.port,
    dashboardPortOverride: server.port,
    dashboardProxied: true,
    apiKey: 'k',
    desktopGatewayUrl: 'http://127.0.0.1:${server.port}',
    singleLogin: true,
    signInMethod: 'none',
  );

  Future<void> close() async {
    for (final ws in _sockets.toList()) {
      await ws.close();
    }
    await server.close(force: true);
    await _changes.close();
  }
}

Future<void> _waitFor(bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 10));
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('condition not met');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

Future<void> _flush() async {
  for (var i = 0; i < 12; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final gate = SystemSleepGate.instance;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    gate.clear();
  });
  tearDown(gate.clear);

  group('NextGen', () {
    HttpOverrides? previous;
    setUpAll(() {
      previous = HttpOverrides.current;
      HttpOverrides.global = null;
    });
    tearDownAll(() => HttpOverrides.global = previous);

    test('a turn streaming when the session locks finishes from the replay '
        'after unlock: every event once, the prompt sent once', () async {
      final server = await _StreamingGateway.start();
      addTearDown(server.close);
      final gateway = NextGenGateway(server.connection());
      final chat = NgChatController(gateway, sessionId: 'stored');
      addTearDown(() {
        chat.dispose();
        gateway.dispose();
      });
      var reconciled = 0;
      void count() => reconciled++;
      gate.reconciled.addListener(count);
      addTearDown(() => gate.reconciled.removeListener(count));

      gateway.start();
      await _waitFor(() => gateway.state.phase == NgConnectionPhase.connected);
      await server.until(() => server.count('session.resume') == 1);
      await _waitFor(() => chat.runtimeId == 'rt');

      expect(await chat.send('private prompt'), isTrue);
      await _waitFor(
        () =>
            chat.items.whereType<NgAssistantItem>().singleOrNull?.text ==
            'Hello',
      );
      expect(chat.running, isTrue);

      // The session locks mid-turn: the socket closes and nothing redials.
      gate.apply(PowerEvent.lock);
      await server.until(() => server.live == 0);
      expect(gate.reconcilePending, 1, reason: 'the running chat holds');
      // The turn goes on and ends on the server while the client is away.
      server.produce('message.delta', {'text': ' world'});
      server.running = false;
      server.produce('message.complete', {'status': 'complete'});
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(server.opened, 1);
      expect(chat.items.whereType<NgAssistantItem>().single.text, 'Hello');

      gate.apply(PowerEvent.unlock);
      await server.until(() => server.live == 1 && server.opened == 2);
      await _waitFor(() => !chat.running);
      await _waitFor(() => gate.reconcilePending == 0);

      // Caught up from the replay after the last applied event.
      expect(server.replayCalls, isNotEmpty);
      expect(server.replayCalls.first['last_seen'], 3);
      final replies = chat.items.whereType<NgAssistantItem>().toList();
      expect(replies, hasLength(1), reason: 'one reply, not two');
      expect(replies.single.text, 'Hello world');
      expect(chat.items.whereType<NgUserItem>(), hasLength(1));
      expect(server.count('prompt.submit'), 1, reason: 'never sent again');
      expect(reconciled, 1, reason: 'keep-awake may decide again now');
    });
  });

  group('Classic', () {
    test('a turn streaming when the session locks is recovered from the '
        'gateway after unlock: one reply, the prompt sent once', () async {
      final store = NormalGatewayPendingStore();
      var submissions = 0;
      var resumes = 0;
      bool? running = true;
      final rpc = Completer<void>();
      var rows = <Map<String, dynamic>>[
        {'id': 10, 'role': 'assistant', 'content': 'Before'},
      ];
      final session = NormalGatewayApplicationSession(
        connection: SavedConnection(
          id: 'pause-classic',
          label: 'Pause',
          host: 'pause.fixture',
          port: 8642,
          apiKey: 'k',
        ),
        scope: 'scope',
        pendingStore: store,
        submit:
            ({
              required sessionId,
              required text,
              required onEvent,
              required onSent,
            }) async {
              submissions++;
              onSent();
              return rpc.future;
            },
        resume: ({required localSessionId, required storedSessionId}) async {
          resumes++;
          return ResumedGatewaySession(
            runtimeSessionId: 'runtime',
            running: running,
            status: running == false ? 'completed' : null,
          );
        },
        history: (id) async => rows,
      );
      addTearDown(() async {
        await session.close();
        if (!rpc.isCompleted) rpc.complete();
      });
      var reconciled = 0;
      void count() => reconciled++;
      gate.reconciled.addListener(count);
      addTearDown(() => gate.reconciled.removeListener(count));

      await session.ready;
      final owner = session.chatFor(
        'local',
        storedSessionId: 'stored',
        title: 'local',
      );
      owner.observeHistory([
        {'id': 10, 'role': 'assistant', 'content': 'Before'},
      ]);
      owner
          .submitPrepared(
            reservation: owner.reserve()!,
            text: 'private prompt',
            localContent: 'private prompt',
          )
          .ignore();
      await _flush();
      void emit(String type, Map<String, dynamic> data) => session.receiveEvent(
        'local',
        StreamEvent(type: type, data: data, turnId: 'turn-1'),
      );
      emit('turn.start', {});
      emit('message.delta', {'text': 'Hel'});
      emit('message.delta', {'text': 'lo'});
      await _flush();
      expect(owner.snapshot.hasActiveTurn, isTrue);
      expect(owner.snapshot.displayRows.last['content'], 'Hello');
      final resumesBefore = resumes;

      // The session locks: the socket (and the submit RPC on it) is gone.
      gate.apply(PowerEvent.lock);
      rpc.completeError(StateError('socket closed for the pause'));
      await _flush();
      expect(gate.reconcilePending, 1, reason: 'the running chat holds');
      expect(resumes, resumesBefore, reason: 'no recovery while paused');
      // The turn ends on the server while the client is away.
      rows = [
        {'id': 10, 'role': 'assistant', 'content': 'Before'},
        {'id': 11, 'role': 'user', 'content': 'private prompt'},
        {'id': 12, 'role': 'assistant', 'content': 'Hello world'},
      ];
      running = false;

      gate.apply(PowerEvent.unlock);
      for (var i = 0; i < 20 && owner.snapshot.hasActiveTurn; i++) {
        await _flush();
      }
      expect(owner.snapshot.hasActiveTurn, isFalse);
      expect(resumes, greaterThan(resumesBefore));
      expect(submissions, 1, reason: 'never sent again');
      expect(gate.reconcilePending, 0);
      expect(reconciled, 1);
      final replies = owner.snapshot.historyRows
          .where((row) => row['content'] == 'Hello world')
          .toList();
      expect(replies, hasLength(1), reason: 'one reply, not two');
      // What streamed live was applied once (one received row, not the
      // deltas twice); the saved reply is the recovered history row.
      final received = owner.snapshot.displayRows
          .where((row) => row['role'] == 'assistant')
          .map((row) => row['content'])
          .toList();
      expect(received, ['Hello']);
      expect(
        owner.snapshot.displayRows.where((row) => row['role'] == 'user'),
        hasLength(1),
      );
    });
  });
}
