// #84: Classic Stop and Steer (DesktopGatewayClient → WsClient) on the
// canonical session authority carry the execution generation this socket
// last admitted for the session; legacy gateways keep their exact shapes.
// Real loopback ticket + WebSocket JSON-RPC; the owner's answers, refusals
// and frames are the backend's own (`canonical_replay_contract.json`).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/canonical_replay_fixture.dart';
import 'support/strict_authority_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides? overrides;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    overrides = HttpOverrides.current;
    HttpOverrides.global = null;
  });
  tearDown(() => HttpOverrides.global = overrides);

  final controls = fixtureMap(['controls']);
  final sid = fixtureSessionId;

  Future<({_Owner owner, DesktopGatewayClient client})> attach({
    required bool authority,
  }) async {
    final owner = await _Owner.start(authority: authority);
    final client = owner.client();
    addTearDown(() async {
      client.close();
      await owner.close();
    });
    await client.ensureSession('mobile');
    return (owner: owner, client: client);
  }

  group('canonical', () {
    test('Stop and Steer carry the resume snapshot generation', () async {
      final o = await attach(authority: true);
      expect(
        await o.client.steerPrompt(sessionId: 'mobile', text: ' Focus '),
        isTrue,
      );
      expect(await o.client.interruptPrompt(sessionId: 'mobile'), isTrue);
      expect(o.owner.params('session.steer').single, {
        'session_id': sid,
        'execution_generation': 3,
        'text': 'Focus',
      });
      expect(o.owner.params('session.interrupt').single, {
        'session_id': sid,
        'execution_generation': 3,
      });
    });

    test('a newer claim learned from a frame stamp is the one sent', () async {
      final o = await attach(authority: true);
      final turn = fixtureFrames(['turn', 'frames']);
      o.owner.generation = 4;
      // The rest of generation 3, then generation 4's claim.
      for (final frame in turn.skip(2)) {
        o.owner.send(frame);
      }
      // A reply on the same socket is ordered after those frames.
      await o.client.fetchSlashCommands(sessionId: 'mobile');
      expect(await o.client.interruptPrompt(sessionId: 'mobile'), isTrue);
      expect(
        o.owner.params('session.interrupt').single['execution_generation'],
        4,
      );
    });

    test(
      'a stale generation fails once and is never re-sent for the newer turn',
      () async {
        final o = await attach(authority: true);
        // The owner moved on without this socket seeing the claim's frame.
        o.owner.generation = 4;
        await expectLater(
          o.client.interruptPrompt(sessionId: 'mobile'),
          throwsA(
            isA<JsonRpcError>().having(
              (e) => e.reason,
              'reason',
              'stale_generation',
            ),
          ),
        );
        await expectLater(
          o.client.steerPrompt(sessionId: 'mobile', text: 'Focus'),
          throwsA(
            isA<JsonRpcError>().having(
              (e) => e.reason,
              'reason',
              'stale_generation',
            ),
          ),
        );
        await _settle();
        expect(o.owner.params('session.interrupt'), hasLength(1));
        expect(o.owner.params('session.steer'), hasLength(1));
        expect(
          o.owner.params('session.interrupt').single['execution_generation'],
          3,
        );
        expect(o.owner.params('prompt.submit'), isEmpty);
        expect(o.owner.params('session.resume'), hasLength(1));
      },
    );

    test(
      'the resume projection keeps the canonical claim and cursor',
      () async {
        final o = await attach(authority: true);
        o.owner.snapshot = fixtureMap(['controls', 'snapshot_with_pending']);
        final resumed = await o.client.resumeSubmittedSession(
          localSessionId: 'second',
          storedSessionId: 'stored-second',
        );
        final expected = o.owner.snapshot!;
        expect(resumed.runtimeSessionId, sid);
        expect(resumed.executionGeneration, expected['execution_generation']);
        expect(resumed.replayEpoch, expected['replay_epoch']);
        expect(resumed.lastSequence, expected['last_sequence']);
        expect(resumed.pending, expected['pending']);
        expect(resumed.pending.single['status'], 'queued');
      },
    );

    test('a rejected steer is reported as not accepted', () async {
      final o = await attach(authority: true);
      o.owner.steerAck = Map<String, dynamic>.from(
        controls['steer_rejected'] as Map,
      )..['execution_generation'] = 3;
      expect(
        await o.client.steerPrompt(sessionId: 'mobile', text: 'Focus'),
        isFalse,
      );
      expect(o.owner.params('session.steer'), hasLength(1));
    });
  });

  group('legacy', () {
    test('Stop and Steer keep the exact legacy shapes', () async {
      final o = await attach(authority: false);
      expect(
        await o.client.steerPrompt(sessionId: 'mobile', text: 'Focus'),
        isTrue,
      );
      expect(await o.client.interruptPrompt(sessionId: 'mobile'), isTrue);
      expect(o.owner.params('session.steer').single, {
        'session_id': 'legacy-runtime-1',
        'text': 'Focus',
      });
      expect(o.owner.params('session.interrupt').single, {
        'session_id': 'legacy-runtime-1',
      });
    });
  });
}

Future<void> _settle() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

/// A loopback owner: real ticket mint and WebSocket JSON-RPC answering with
/// the captured canonical (or legacy) shapes and fences.
class _Owner {
  _Owner(this.server, this.authority);

  final HttpServer server;
  final bool authority;
  final requests = <Map<String, dynamic>>[];
  WebSocket? socket;
  int generation = 3;
  Map<String, dynamic>? steerAck;
  Map<String, dynamic>? snapshot;

  static Future<_Owner> start({required bool authority}) async {
    final owner = _Owner(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
      authority,
    );
    owner.server.listen(owner._http);
    return owner;
  }

  DesktopGatewayClient client() => DesktopGatewayClient.fromConnection(
    SavedConnection(
      id: 'canonical-controls',
      label: 'Fixture',
      host: '127.0.0.1',
      port: server.port,
      apiKey: 'fixture',
      dashboardPortOverride: server.port,
      dashboardProxied: true,
      desktopGatewayUrl: 'http://127.0.0.1:${server.port}',
    ),
  );

  List<Map<String, dynamic>> params(String method) => [
    for (final r in requests)
      if (r['method'] == method)
        Map<String, dynamic>.from(r['params'] as Map)..remove('profile'),
  ];

  void send(Map<String, dynamic> frame) => socket!.add(jsonEncode(frame));

  Future<void> _http(HttpRequest request) async {
    if (request.uri.path == '/api/auth/ws-ticket') {
      request.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'ticket': 'fixture-ticket'}));
      await request.response.close();
      return;
    }
    if (!WebSocketTransformer.isUpgradeRequest(request)) {
      request.response.statusCode = 404;
      await request.response.close();
      return;
    }
    final ws = socket = await WebSocketTransformer.upgrade(request);
    ws.add(
      jsonEncode(
        authority
            ? fixtureMap(['ready_frame'])
            : fixtureMap(['legacy', 'ready_frame']),
      ),
    );
    ws.listen((raw) {
      final frame = Map<String, dynamic>.from(jsonDecode(raw as String) as Map);
      if (frame['method'] == null) return;
      requests.add(frame);
      if (authority) {
        final refused = strictAuthorityFrame(frame);
        if (refused != null) {
          ws.add(refused);
          return;
        }
      }
      final params = Map<String, dynamic>.from(frame['params'] as Map? ?? {})
        ..remove('profile');
      final reply = _answer(frame['method'] as String, params);
      ws.add(jsonEncode({'jsonrpc': '2.0', 'id': frame['id'], ...reply}));
    });
  }

  Map<String, dynamic> _answer(String method, Map<String, dynamic> params) {
    final controls = fixtureMap(['controls']);
    final legacy = fixtureMap(['legacy', 'controls']);
    Map<String, dynamic> legacyStrict(Set<String> allowed, String refusal) =>
        params.keys.every(allowed.contains)
        ? const {}
        : {'error': (legacy[refusal] as Map)['error']};
    switch (method) {
      case 'session.resume':
        return {
          'result': authority
              ? (snapshot ??
                    (fixtureMap(['turn', 'snapshot_running'])
                      ..['execution_generation'] = 3))
              : {'session_id': 'legacy-runtime-1', 'running': true},
        };
      case 'session.interrupt':
        if (!authority) {
          final refused = legacyStrict({
            'session_id',
          }, 'interrupt_with_generation');
          return refused.isNotEmpty
              ? refused
              : {
                  'result': {'status': 'interrupted'},
                };
        }
        if (params.keys.toSet().difference({
          'session_id',
          'execution_generation',
        }).isNotEmpty) {
          return {'error': controls['steer_without_generation']};
        }
        return params['execution_generation'] == generation
            ? {'result': controls['interrupt_ack']}
            : {'error': controls['stale_interrupt']};
      case 'session.steer':
        if (!authority) {
          final refused = legacyStrict({
            'session_id',
            'text',
          }, 'steer_with_generation');
          return refused.isNotEmpty
              ? refused
              : {
                  'result': {'status': 'queued', 'text': params['text']},
                };
        }
        if (params['execution_generation'] is! int ||
            params.keys.toSet().difference({
              'session_id',
              'execution_generation',
              'text',
            }).isNotEmpty) {
          return {'error': controls['steer_without_generation']};
        }
        if (params['execution_generation'] != generation) {
          return {'error': controls['stale_steer']};
        }
        return {
          'result':
              steerAck ??
              (Map<String, dynamic>.from(controls['steer_queued'] as Map)
                ..['text'] = params['text']
                ..['execution_generation'] = generation),
        };
      default:
        return {'result': <String, dynamic>{}};
    }
  }

  Future<void> close() async {
    await socket?.close();
    await server.close(force: true);
  }
}
