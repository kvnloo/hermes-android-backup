// #84: the canonical `session.events.since` reply is trusted only for the
// exact per-session epoch and contiguous sequence the client asked from.
// Replies are the backend handler's own (`canonical_replay_contract.json`).
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';

import 'support/canonical_replay_fixture.dart';

void main() {
  final sid = fixtureSessionId;
  final processEpoch = canonicalFixture()['process_epoch'] as String;
  final frames = fixtureFrames(['turn', 'frames']);
  final epoch = frames.first['params']['replay_epoch'] as String;

  test('the gateway.ready process epoch is not a session epoch', () {
    final ready = fixtureMap(['ready_frame']);
    expect(
      ((ready['params'] as Map)['payload'] as Map)['replay_epoch'],
      processEpoch,
    );
    for (final frame in frames) {
      expect((frame['params'] as Map)['replay_epoch'], epoch);
    }
    expect(epoch, isNot(processEpoch));
    // The backend answers a missing or process epoch with a snapshot demand.
    for (final key in ['since_process_epoch', 'since_without_epoch']) {
      final reply = fixtureMap(['turn', key]);
      expect(reply['snapshot_required'], isTrue, reason: key);
      expect(reply['events'], isEmpty, reason: key);
    }
  });

  test('an exact replay comes back in order', () {
    final events = ngParseCanonicalReplay(
      fixtureMap(['turn', 'since_after_2']),
      sid,
      epoch,
      2,
    )!;
    expect(events.map((e) => e.seq), [3, 4, 5]);
    expect(events.map((e) => e.type), [
      'message.delta',
      'message.delta',
      'message.complete',
    ]);
    expect(events.last.data['text'], 'Autumn moon rises');
    expect(events.first.envelope['execution_generation'], 3);
  });

  test('anything but an exact, complete replay asks for a snapshot', () {
    final exact = fixtureMap(['turn', 'since_after_2']);
    expect(ngParseCanonicalReplay(exact, sid, processEpoch, 2), isNull);
    expect(ngParseCanonicalReplay(exact, sid, epoch, 1), isNull);
    expect(ngParseCanonicalReplay(exact, 'another-session', epoch, 2), isNull);
    for (final path in [
      ['turn', 'since_without_epoch'],
      ['restart', 'since_old_epoch'],
      ['new_stream', 'since_old_epoch'],
      ['overflow', 'since_after_2'],
    ]) {
      final reply = fixtureMap(path);
      expect(
        ngParseCanonicalReplay(reply, sid, epoch, 2),
        isNull,
        reason: path.join('.'),
      );
    }
    final prefix = fixtureMap(['turn', 'since_after_2']);
    (prefix['events'] as List).removeLast();
    expect(
      ngParseCanonicalReplay(prefix, sid, epoch, 2),
      isNull,
      reason: 'last_sequence 5 says seq 5 is still owed',
    );
    final foreign = fixtureMap(['turn', 'since_after_2']);
    ((foreign['events'] as List).first as Map)['replay_epoch'] = processEpoch;
    expect(ngParseCanonicalReplay(foreign, sid, epoch, 2), isNull);
  });

  test('the legacy parser keeps the process-epoch contract', () {
    final legacy = fixtureMap(['legacy']);
    final reply = Map<String, dynamic>.from(
      (legacy['since_after_1'] as Map)['result'] as Map,
    );
    final events = ngParseReplay(
      reply,
      'legacy-runtime-1',
      1,
      ((legacy['ready_frame']['params'] as Map)['payload']
              as Map)['replay_epoch']
          as String,
    )!;
    expect(events.map((e) => e.seq), [2, 3, 4]);
  });
}
