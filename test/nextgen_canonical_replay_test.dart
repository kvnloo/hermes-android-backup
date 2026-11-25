// #84: NextGen catch-up on the canonical session authority. Each session's
// replay epoch belongs to its SessionEvents lifetime, not the gateway.ready
// process epoch; `session.events.since` takes that exact epoch and the last
// applied sequence, and `snapshot_required` means a bounded snapshot +
// history reload whose cursor fences the live frames held meanwhile.
//
// Every frame, replay reply and snapshot watermark here was produced by the
// backend itself (`tools/capture_canonical_replay_fixture.py`).
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/canonical_replay_fixture.dart';

Map<String, dynamic> _row(int id, String role, String content) => {
  'id': id,
  'role': role,
  'content': content,
  'timestamp': 1700000000 + id,
};

List<String> _assistantTexts(NgChatController chat) =>
    chat.items.whereType<NgAssistantItem>().map((i) => i.text).toList();

Future<void> _settle() => pumpEventQueue(times: 100);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  final sid = fixtureSessionId;
  final processEpoch = canonicalFixture()['process_epoch'] as String;

  Future<({FixtureGateway gateway, NgChatController chat})> open({
    required Map<String, FixtureHandler> handlers,
    List<Map<String, dynamic>> history = const [],
  }) async {
    final live = await greetingSocket(fixtureMap(['ready_frame']));
    addTearDown(() async {
      live.socket.close();
      await live.server.close(force: true);
    });
    final gateway = FixtureGateway(
      readyFrame: fixtureMap(['ready_frame']),
      liveSocket: live.socket,
      history: history,
      handlers: handlers,
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

  /// A queue of answers for one method; the last one repeats.
  FixtureHandler answers(List<Object> replies) {
    var i = 0;
    return (_) {
      final reply = replies[i < replies.length ? i : replies.length - 1];
      i++;
      if (reply is Exception) throw reply;
      if (reply is Error) throw reply;
      return reply as Map<String, dynamic>;
    };
  }

  test(
    'a gap replays from the snapshot cursor with the session epoch',
    () async {
      final frames = fixtureFrames(['turn', 'frames']);
      final snapshot = fixtureMap(['turn', 'snapshot_running']);
      final o = await open(
        handlers: {
          'session.resume': answers([snapshot]),
          'session.events.since': answers([
            fixtureMap(['turn', 'since_after_2']),
          ]),
        },
      );
      expect(snapshot['replay_epoch'], isNot(processEpoch));

      // Seq 3 never arrived; seq 4 exposes the gap after the snapshot (2).
      o.gateway.debugEmit(fixtureEvent(frames[3]));
      await _settle();

      final since = o.gateway.callsTo('session.events.since').single.params;
      expect(since, {
        'session_id': sid,
        'replay_epoch': snapshot['replay_epoch'],
        'last_sequence': 2,
      });
      // The chat attached mid-turn, so its view never had seq 2's text: the
      // turn's own final text completes the reply instead of a spliced one.
      expect(_assistantTexts(o.chat), ['Autumn moon rises']);
      expect(o.chat.running, isFalse);
      expect(o.gateway.rest.reads, 1, reason: 'no reload when replay works');
      expect(o.gateway.callsTo('session.resume'), hasLength(1));
    },
  );

  test(
    'live frames continue the cursor: a duplicate or covered seq applies once',
    () async {
      final frames = fixtureFrames(['turn', 'frames']);
      final o = await open(
        handlers: {
          'session.resume': answers([
            fixtureMap(['turn', 'snapshot_running']),
          ]),
        },
      );
      // Seqs 1-2 predate the snapshot's watermark; 3 and 4 are new.
      for (final i in [0, 1, 2, 2, 3]) {
        o.gateway.debugEmit(fixtureEvent(frames[i]));
      }
      await _settle();
      expect(_assistantTexts(o.chat), ['moon rises']);
      expect(o.gateway.callsTo('session.events.since'), isEmpty);
    },
  );

  test(
    'a gateway restart (new session epoch) reloads once and fences held frames',
    () async {
      final turn = fixtureFrames(['turn', 'frames']);
      final restart = fixtureFrames(['restart', 'frames']);
      final o = await open(
        history: [_row(1, 'user', 'Write a haiku')],
        handlers: {
          'session.resume': answers([
            fixtureMap(['turn', 'snapshot_running']),
            fixtureMap(['restart', 'snapshot']),
          ]),
          'session.events.since': answers([
            fixtureMap(['restart', 'since_old_epoch']),
          ]),
        },
      );
      o.gateway.debugEmit(fixtureEvent(turn[2]));
      await _settle();
      o.gateway.rest.rows = [
        _row(1, 'user', 'Write a haiku'),
        _row(2, 'assistant', 'Autumn moon rises'),
        _row(3, 'user', 'Again'),
      ];
      // The restarted owner's first frames carry its new epoch.
      o.gateway.debugEmit(fixtureEvent(restart[0]));
      o.gateway.debugEmit(fixtureEvent(restart[1]));
      await _settle();

      final since = o.gateway.callsTo('session.events.since').single.params;
      expect(since['replay_epoch'], turn[2]['params']['replay_epoch']);
      expect(since['last_sequence'], 3);
      expect(o.gateway.callsTo('session.resume'), hasLength(2));
      expect(o.chat.running, isTrue);

      // After the snapshot (last_sequence 2) the new stream continues live;
      // a straggler of the retired stream is dropped without another read.
      o.gateway.debugEmit(fixtureEvent(turn[3]));
      o.gateway.debugEmit(fixtureEvent(restart[2]));
      o.gateway.debugEmit(fixtureEvent(restart[3]));
      await _settle();
      expect(_assistantTexts(o.chat), ['Autumn moon rises', 'After restart']);
      expect(o.chat.running, isFalse);
      expect(o.gateway.callsTo('session.events.since'), hasLength(1));
      expect(o.gateway.callsTo('session.resume'), hasLength(2));
    },
  );

  test(
    'a released stream (new epoch on the same session) reloads, then continues',
    () async {
      final frames = fixtureFrames(['new_stream', 'frames']);
      final o = await open(
        handlers: {
          'session.resume': answers([
            fixtureMap(['new_stream', 'snapshot_before']),
            fixtureMap(['new_stream', 'snapshot']),
          ]),
          'session.events.since': answers([
            fixtureMap(['new_stream', 'since_old_epoch']),
          ]),
        },
      );
      o.gateway.debugEmit(fixtureEvent(frames[1]));
      await _settle();
      expect(_assistantTexts(o.chat), ['Before release']);

      o.gateway.debugEmit(fixtureEvent(frames[2]));
      await _settle();
      final since = o.gateway.callsTo('session.events.since').single.params;
      expect(since, {
        'session_id': sid,
        'replay_epoch': fixtureMap(['new_stream'])['old_epoch'],
        'last_sequence': 2,
      });
      expect(o.gateway.callsTo('session.resume'), hasLength(2));

      o.gateway.debugEmit(fixtureEvent(frames[3]));
      await _settle();
      expect(_assistantTexts(o.chat).last, ' continues');
      expect(o.gateway.callsTo('session.events.since'), hasLength(1));
    },
  );

  test(
    'an overflowed replay ring reloads the snapshot instead of trusting it',
    () async {
      final last = fixtureMap(['overflow', 'last_frame']);
      final snapshot = fixtureMap(['overflow', 'snapshot']);
      final o = await open(
        handlers: {
          'session.resume': answers([
            fixtureMap(['overflow', 'snapshot_before']),
            snapshot,
          ]),
          'session.events.since': answers([
            fixtureMap(['overflow', 'since_after_2']),
          ]),
        },
      );
      o.gateway.debugEmit(fixtureEvent(last));
      await _settle();
      expect(o.gateway.callsTo('session.events.since').single.params, {
        'session_id': sid,
        'replay_epoch': snapshot['replay_epoch'],
        'last_sequence': 2,
      });
      expect(o.gateway.callsTo('session.resume'), hasLength(2));
      expect(o.gateway.rest.reads, 2);
      expect(o.chat.running, isTrue);
      // The held frame is inside the accepted snapshot and is not re-applied.
      expect(_assistantTexts(o.chat).where((t) => t.isNotEmpty), isEmpty);
    },
  );

  test(
    'a replay-gap notice replays what was missed, then re-attaches',
    () async {
      final frames = fixtureFrames(['replay_gap', 'frames']);
      final before = fixtureMap(['replay_gap', 'snapshot_before']);
      final o = await open(
        handlers: {
          'session.resume': answers([
            before,
            fixtureMap(['replay_gap', 'snapshot_after']),
          ]),
          'session.events.since': answers([
            fixtureMap(['replay_gap', 'since_after_2']),
          ]),
        },
      );
      o.gateway.debugEmit(fixtureEvent(fixtureMap(['replay_gap', 'notice'])));
      await _settle();
      expect(o.gateway.callsTo('session.events.since').single.params, {
        'session_id': sid,
        'replay_epoch': before['replay_epoch'],
        'last_sequence': 2,
      });
      expect(_assistantTexts(o.chat), ['replayed']);
      final methods = o.gateway.calls.map((c) => c.method).toList();
      expect(
        methods.lastIndexOf('session.resume'),
        greaterThan(methods.indexOf('session.events.since')),
        reason: 'the retired subscription is re-attached after the replay',
      );
      expect(o.gateway.rest.reads, 1);
      // A frame the re-attachment bridged is not applied twice.
      o.gateway.debugEmit(fixtureEvent(frames[2]));
      await _settle();
      expect(_assistantTexts(o.chat), ['replayed']);
    },
  );

  test(
    'a held terminal frame inside the reload snapshot does not duplicate the reply',
    () async {
      final frames = fixtureFrames(['held_terminal', 'frames']);
      final o = await open(
        history: [_row(1, 'user', 'Do it')],
        handlers: {
          'session.resume': answers([
            fixtureMap(['held_terminal', 'snapshot_start']),
            fixtureMap(['held_terminal', 'snapshot']),
          ]),
          // The link dropped again before the replay could answer.
          'session.events.since': answers([StateError('Not connected')]),
        },
      );
      final chat = o.chat;
      o.gateway.debugEmit(fixtureEvent(frames[1]));
      await _settle();
      expect(_assistantTexts(chat), ['Done ']);
      expect(chat.running, isTrue);

      o.gateway.rest.rows = [
        _row(1, 'user', 'Do it'),
        _row(2, 'assistant', 'Done now'),
      ];
      final hold = Completer<void>();
      o.gateway.rest.hold = hold;
      o.gateway.reconnects.add(null);
      await _settle();
      // The end of the turn arrives while the reload is still reading.
      o.gateway.debugEmit(fixtureEvent(frames[2]));
      o.gateway.debugEmit(fixtureEvent(frames[3]));
      await _settle();
      expect(_assistantTexts(chat), ['Done '], reason: 'live view kept');
      hold.complete();
      o.gateway.rest.hold = null;
      await _settle();

      expect(_assistantTexts(chat), ['Done now']);
      expect(chat.running, isFalse);
      expect(chat.items.whereType<NgUserItem>().map((u) => u.text), ['Do it']);
      expect(o.gateway.callsTo('prompt.submit'), isEmpty);
    },
  );
}
