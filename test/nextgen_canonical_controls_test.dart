// #84: NextGen Stop and Steer on the canonical session authority carry the
// exact execution generation the chat last admitted (snapshot or event
// stamp), and only there; legacy gateways keep their exact shapes, which
// their strict params refuse to widen. A fenced refusal is a visible,
// non-retrying failure. Wire shapes come from the backend's own handlers
// (`test/fixtures/canonical_replay_contract.json`).
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/canonical_replay_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  final controls = fixtureMap(['controls']);
  final turnFrames = fixtureFrames(['turn', 'frames']);
  final sid = fixtureSessionId;

  /// A chat attached to a canonical gateway whose authority holds
  /// [serverGeneration]; Stop/Steer for any other generation is refused the
  /// way `SessionAuthority.interrupt` / `correct()` refuse it.
  Future<({FixtureGateway gateway, NgChatController chat})> canonicalChat({
    required int Function() serverGeneration,
    Map<String, dynamic>? steerAck,
    Completer<void>? holdControl,
    Map<String, dynamic>? snapshot,
  }) async {
    final live = await greetingSocket(fixtureMap(['ready_frame']));
    addTearDown(() async {
      live.socket.close();
      await live.server.close(force: true);
    });
    Future<Map<String, dynamic>> fenced(
      String method,
      Map<String, dynamic> params,
      Map<String, dynamic> ack,
    ) async {
      await holdControl?.future;
      final generation = params['execution_generation'];
      if (method == 'session.steer' && generation is! int) {
        throw fixtureRefusal(method, controls['steer_without_generation']);
      }
      if (generation != serverGeneration()) {
        throw fixtureRefusal(
          method,
          method == 'session.steer'
              ? controls['stale_steer']
              : controls['stale_interrupt'],
        );
      }
      return ack;
    }

    final gateway = FixtureGateway(
      readyFrame: fixtureMap(['ready_frame']),
      liveSocket: live.socket,
      handlers: {
        'session.resume': (_) =>
            snapshot ?? fixtureMap(['turn', 'snapshot_running']),
        'session.interrupt': (p) =>
            fenced('session.interrupt', p, controls['interrupt_ack']),
        'session.steer': (p) => fenced(
          'session.steer',
          p,
          steerAck ?? controls['steer_queued'] as Map<String, dynamic>,
        ),
        'session.events.since': (_) =>
            fixtureMap(['turn', 'since_without_epoch']),
      },
    );
    final chat = NgChatController(gateway, sessionId: sid);
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    await chat.open();
    expect(chat.runtimeId, sid);
    return (gateway: gateway, chat: chat);
  }

  group('canonical Stop', () {
    test('sends the generation of the latest admitted event', () async {
      final o = await canonicalChat(serverGeneration: () => 4);
      // The rest of turn 3, then the claim of generation 4 (`message.start`).
      for (final frame in turnFrames.skip(2)) {
        o.gateway.debugEmit(fixtureEvent(frame));
      }
      await pumpEventQueue();
      expect(o.chat.running, isTrue);

      await o.chat.stop();

      final stop = o.gateway.callsTo('session.interrupt').single.params;
      expect(stop, controls['canonical_params']['interrupt']);
      expect(stop, {'session_id': sid, 'execution_generation': 4});
      expect(o.chat.error, isNull);
    });

    test('sends the snapshot generation before any event arrives', () async {
      final o = await canonicalChat(serverGeneration: () => 3);
      await o.chat.stop();
      expect(o.gateway.callsTo('session.interrupt').single.params, {
        'session_id': sid,
        'execution_generation': 3,
      });
    });

    test(
      'a stale generation fails visibly once and never re-targets the newer turn',
      () async {
        var server = 3;
        final hold = Completer<void>();
        final o = await canonicalChat(
          serverGeneration: () => server,
          holdControl: hold,
        );
        final stopping = o.chat.stop();
        // The owner claims the next turn while the user's Stop is in flight;
        // the app learns it from the next frame's stamp.
        server = 4;
        o.gateway.debugEmit(fixtureEvent(turnFrames[2]));
        o.gateway.debugEmit(fixtureEvent(turnFrames[3]));
        o.gateway.debugEmit(fixtureEvent(turnFrames[4]));
        o.gateway.debugEmit(fixtureEvent(turnFrames[5]));
        await pumpEventQueue();
        hold.complete();
        await stopping;
        await pumpEventQueue(times: 50);

        final interrupts = o.gateway.callsTo('session.interrupt');
        expect(interrupts, hasLength(1), reason: 'never replayed');
        expect(interrupts.single.params['execution_generation'], 3);
        expect(o.chat.error, ngL.ng_couldn_t_stop(ngL.ng_turn_changed));
        expect(o.chat.running, isTrue, reason: 'generation 4 still runs');
        expect(o.gateway.callsTo('prompt.submit'), isEmpty);
      },
    );

    test('an unknown generation sends nothing and says so', () async {
      final snapshot = fixtureMap(['turn', 'snapshot_running'])
        ..remove('execution_generation');
      final o = await canonicalChat(
        serverGeneration: () => 3,
        snapshot: snapshot,
      );
      await o.chat.stop();
      expect(o.gateway.callsTo('session.interrupt'), isEmpty);
      expect(o.chat.error, ngL.ng_couldn_t_stop(ngL.ng_turn_not_known_yet));
    });
  });

  group('canonical Steer', () {
    test('sends the exact generation, then shows the guidance', () async {
      final o = await canonicalChat(serverGeneration: () => 4);
      for (final frame in turnFrames.skip(2)) {
        o.gateway.debugEmit(fixtureEvent(frame));
      }
      await pumpEventQueue();
      await o.chat.steer('  Focus  ');
      expect(
        o.gateway.callsTo('session.steer').single.params,
        controls['canonical_params']['steer'],
      );
      final guidance = o.chat.items.whereType<NgUserItem>().single;
      expect(guidance.steered, isTrue);
      expect(guidance.pending, isFalse);
      expect(guidance.failure, isNull);
    });

    test('a stale generation is a failure and is never re-sent', () async {
      final o = await canonicalChat(serverGeneration: () => 4);
      await o.chat.steer('Focus');
      await pumpEventQueue(times: 50);
      final steers = o.gateway.callsTo('session.steer');
      expect(steers, hasLength(1));
      expect(steers.single.params['execution_generation'], 3);
      final guidance = o.chat.items.whereType<NgUserItem>().single;
      expect(guidance.failure, ngL.ng_turn_changed);
      expect(o.gateway.callsTo('prompt.submit'), isEmpty);
      expect(o.gateway.callsTo('session.interrupt'), isEmpty);
    });

    test('a rejected acknowledgement is not shown as delivered', () async {
      final o = await canonicalChat(
        serverGeneration: () => 3,
        steerAck: Map<String, dynamic>.from(controls['steer_rejected'] as Map)
          ..['execution_generation'] = 3,
      );
      await o.chat.steer('Focus');
      final guidance = o.chat.items.whereType<NgUserItem>().single;
      expect(guidance.failure, ngL.ng_steer_rejected);
      expect(o.gateway.callsTo('session.steer'), hasLength(1));
      expect(o.gateway.callsTo('prompt.submit'), isEmpty);
    });

    test('an unknown generation sends nothing and says so', () async {
      final snapshot = fixtureMap(['turn', 'snapshot_running'])
        ..remove('execution_generation');
      final o = await canonicalChat(
        serverGeneration: () => 3,
        snapshot: snapshot,
      );
      await o.chat.steer('Focus');
      expect(o.gateway.callsTo('session.steer'), isEmpty);
      expect(
        o.chat.items.whereType<NgUserItem>().single.failure,
        ngL.ng_turn_not_known_yet,
      );
    });
  });

  group('legacy gateways keep their exact shapes', () {
    Future<({FixtureGateway gateway, NgChatController chat})>
    legacyChat() async {
      final ready = fixtureMap(['legacy', 'ready_frame']);
      final live = await greetingSocket(ready);
      addTearDown(() async {
        live.socket.close();
        await live.server.close(force: true);
      });
      final legacy = fixtureMap(['legacy', 'controls']);
      // The legacy dispatcher's own refusal for any key its params lack.
      Map<String, dynamic> strict(
        String method,
        Map<String, dynamic> params,
        Set<String> allowed,
        Map<String, dynamic> result,
      ) {
        if (params.keys.any((k) => !allowed.contains(k))) {
          throw fixtureRefusal(
            method,
            (method == 'session.steer'
                    ? legacy['steer_with_generation']
                    : legacy['interrupt_with_generation'])['error']
                as Map<String, dynamic>,
          );
        }
        return result;
      }

      final gateway = FixtureGateway(
        readyFrame: ready,
        liveSocket: live.socket,
        handlers: {
          'session.resume': (_) => {
            'session_id': 'legacy-runtime-1',
            'running': true,
            // A shared-shape field must not switch the legacy path over.
            'execution_generation': 2,
          },
          'session.interrupt': (p) => strict(
            'session.interrupt',
            p,
            {'session_id'},
            {'status': 'interrupted'},
          ),
          'session.steer': (p) => strict(
            'session.steer',
            p,
            {'session_id', 'text'},
            {'status': 'queued', 'text': p['text']},
          ),
        },
      );
      final chat = NgChatController(gateway, sessionId: 'stored-legacy');
      addTearDown(() {
        chat.dispose();
        gateway.dispose();
      });
      await chat.open();
      return (gateway: gateway, chat: chat);
    }

    test('Stop sends only the session id', () async {
      final o = await legacyChat();
      await o.chat.stop();
      expect(o.gateway.callsTo('session.interrupt').single.params, {
        'session_id': 'legacy-runtime-1',
      });
      expect(o.chat.error, isNull);
    });

    test('Steer sends only the session id and text', () async {
      final o = await legacyChat();
      await o.chat.steer('Focus');
      expect(o.gateway.callsTo('session.steer').single.params, {
        'session_id': 'legacy-runtime-1',
        'text': 'Focus',
      });
      expect(o.chat.items.whereType<NgUserItem>().single.failure, isNull);
    });
  });

  test('the fixture proves legacy handlers refuse the canonical keys', () {
    final legacy = fixtureMap(['legacy', 'controls']);
    for (final response in legacy.values) {
      final error = (response as Map)['error'] as Map;
      expect(error['code'], 4000);
      expect(error['message'], contains('Extra inputs are not permitted'));
    }
  });
}
