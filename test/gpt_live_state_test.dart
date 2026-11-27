// The GPT-Live state pill follows the voice's audio, as Desktop's
// refreshStatus does (use-voice-live-conversation.ts): `speaking` while the
// remote track plays, then back to `listening` (or `thinking` while a
// delegation is still in Hermes), not only when a delegation settles
// (review probe G9). Desktop measures the remote track with an analyser;
// here the inbound audio level comes from the peer's stats, and where a
// platform reports none, the output transcript's pauses stand in.
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/voice_live_engine.dart';

import 'support/fake_live_webrtc.dart';

void main() {
  ({VoiceLiveEngine engine, StartedLive live}) started(FakeAsync async) {
    final live = newFakeLive();
    final engine = VoiceLiveEngine(
      transport: live.transport,
      session: live.conversation,
    );
    bool? ok;
    engine.start().then((value) => ok = value);
    async.flushMicrotasks();
    expect(ok, isTrue);
    return (engine: engine, live: live);
  }

  void finish(FakeAsync async, VoiceLiveEngine engine) {
    engine.dispose();
    async.flushMicrotasks();
    async.elapse(const Duration(seconds: 1));
  }

  test('small talk with no delegation: speaking, then listening once the '
      'voice goes quiet (review probe G9)', () {
    fakeAsync((async) {
      final s = started(async);
      final channel = s.live.peer.channel;

      channel.receive(liveTranscriptDelta('assistant', 'Hi! How ', 0, 500));
      channel.receive(
        liveTranscriptDelta('assistant', 'can I help?', 500, 900),
      );
      expect(s.engine.state, VoiceLiveState.speaking);

      // Still talking while fragments keep arriving.
      async.elapse(const Duration(milliseconds: 800));
      channel.receive(
        liveTranscriptDelta('assistant', ' Ask away.', 900, 1600),
      );
      async.elapse(const Duration(milliseconds: 800));
      expect(s.engine.state, VoiceLiveState.speaking);

      async.elapse(const Duration(seconds: 2));
      expect(s.engine.state, VoiceLiveState.listening);

      // The user answers: nothing sends the pill back to speaking.
      channel.receive(
        liveTranscriptDelta('user', 'Just saying hi', 3000, 4000),
      );
      async.elapse(const Duration(seconds: 2));
      expect(s.engine.state, VoiceLiveState.listening);
      finish(async, s.engine);
    });
  });

  test('while a delegation is still in Hermes, the end of speech returns '
      'to thinking, and settling it to listening', () {
    fakeAsync((async) {
      final s = started(async);
      final channel = s.live.peer.channel;
      s.engine.onDelegation = (_, _) {};

      channel.receive(liveTranscriptDelta('user', 'Check my mail.', 0, 900));
      channel.receive({
        'type': 'session.delegation.created',
        'delegation': {'id': 'dlg_1', 'type': 'delegation', 'target': 'client'},
      });
      expect(s.engine.state, VoiceLiveState.thinking);

      channel.receive(
        liveTranscriptDelta('assistant', 'Checking now.', 1000, 1600),
      );
      expect(s.engine.state, VoiceLiveState.speaking);
      async.elapse(const Duration(seconds: 3));
      expect(s.engine.state, VoiceLiveState.thinking);

      s.engine.settle();
      expect(s.engine.state, VoiceLiveState.listening);
      finish(async, s.engine);
    });
  });

  test("the peer's inbound audio level decides when it reports one: "
      'speaking while audio plays, listening when it stops', () {
    fakeAsync((async) {
      final s = started(async);
      final peer = s.live.peer;
      peer.audioLevel = 0;
      async.elapse(const Duration(milliseconds: 600));
      expect(peer.statsCalls, greaterThan(0));
      expect(s.engine.state, VoiceLiveState.listening);

      peer.audioLevel = 0.4;
      async.elapse(const Duration(milliseconds: 400));
      expect(s.engine.state, VoiceLiveState.speaking);

      // Audio keeps playing long after the last transcript fragment.
      async.elapse(const Duration(seconds: 4));
      expect(s.engine.state, VoiceLiveState.speaking);

      peer.audioLevel = 0.001;
      async.elapse(const Duration(seconds: 1));
      expect(s.engine.state, VoiceLiveState.listening);
      finish(async, s.engine);
    });
  });

  test('the level probe stops with the session', () {
    fakeAsync((async) {
      final s = started(async);
      final peer = s.live.peer;
      peer.audioLevel = 0.4;
      async.elapse(const Duration(milliseconds: 400));

      s.engine.stopNow();
      async.flushMicrotasks();
      final calls = peer.statsCalls;
      async.elapse(const Duration(seconds: 2));

      expect(peer.statsCalls, calls);
      expect(s.engine.state, VoiceLiveState.idle);
      finish(async, s.engine);
    });
  });
}
