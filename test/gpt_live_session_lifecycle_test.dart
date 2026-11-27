// GPT-Live session lifecycle over a fake peer: user stop, sign-out,
// connection loss and teardown racing start (review probes G5, G6, G8), with
// Hermes Desktop b7ee21c14e lib/voice-live.ts as the reference. The real
// VoiceLiveEngine and GptLiveConversation run; nothing leaves the test.
import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/gpt_live_conversation.dart';
import 'package:hermes_android/core/services/voice_live_engine.dart';

import 'support/fake_live_webrtc.dart';

/// Whether the session still holds the capture device (wake stays paused).
bool _holdsMicrophone(VoiceLiveEngine engine) =>
    // ignore: avoid_dynamic_calls
    (engine as dynamic).holdsMicrophone as bool;

VoiceLiveEngine _engine(StartedLive live, {String? connectionId}) =>
    VoiceLiveEngine(
      transport: live.transport,
      session: live.conversation,
      connectionId: connectionId,
    );

void main() {
  group('stop', () {
    test('Stop says goodbye, hides the controls and mutes the microphone at '
        "once; the vendor's session.closed releases the microphone and the "
        'peer', () async {
      final live = newFakeLive();
      final engine = _engine(live);
      addTearDown(engine.dispose);
      final announced = <String>[];
      engine.onClosed = announced.add;
      expect(await engine.start(), isTrue);

      await engine.stop();

      final channel = live.peer.channel;
      expect(channel.sent.map((event) => event['type']), ['session.close']);
      // The controls hide and no more audio leaves the device ...
      expect(engine.active, isFalse);
      expect(engine.state, VoiceLiveState.idle);
      expect(live.track.enabled, isFalse);
      // ... while the peer stays up for the vendor's answer, and wake stays
      // paused until the capture device is really free.
      expect(live.peer.closed, isFalse);
      expect(_holdsMicrophone(engine), isTrue);

      var notified = 0;
      engine.addListener(() => notified++);
      channel.receive({
        'type': 'session.closed',
        'reason': 'closed',
        'usage': {'seconds': 12},
      });
      await pumpEventQueue();

      expect(live.track.stopped, isTrue);
      expect(live.peer.closed, isTrue);
      expect(channel.closed, isTrue);
      expect(_holdsMicrophone(engine), isFalse);
      // The composer hears about it (so wake resumes), but a stop the user
      // asked for is not announced as a lost session.
      expect(notified, greaterThan(0));
      expect(announced, isEmpty);
    });

    test("with no answer from the vendor, Desktop's 15 s fallback closes the "
        'peer and stops the tracks (review probe G5)', () {
      fakeAsync((async) {
        final live = newFakeLive();
        final engine = _engine(live);
        bool? started;
        engine.start().then((value) => started = value);
        async.flushMicrotasks();
        expect(started, isTrue);

        engine.stop();
        async.flushMicrotasks();
        expect(engine.active, isFalse);

        async.elapse(const Duration(milliseconds: 14900));
        expect(live.peer.closed, isFalse);
        expect(live.track.stopped, isFalse);

        async.elapse(const Duration(milliseconds: 200));
        expect(live.track.stopped, isTrue);
        expect(live.peer.closed, isTrue);
        expect(live.peer.channel.closed, isTrue);
        expect(engine.active, isFalse);
        expect(_holdsMicrophone(engine), isFalse);

        engine.dispose();
        async.flushMicrotasks();
      });
    });

    test('sign-out or a connection edit closes the peer and the tracks at '
        'once, without the 15 s wait', () async {
      const account = 'live-lifecycle-account';
      final live = newFakeLive();
      final engine = _engine(live, connectionId: account);
      addTearDown(engine.dispose);
      expect(await engine.start(), isTrue);

      final lease = ConnectionMutationBarrier.begin([account]);
      addTearDown(lease.release);
      await pumpEventQueue();

      expect(live.track.stopped, isTrue);
      expect(live.peer.closed, isTrue);
      expect(live.peer.channel.closed, isTrue);
      expect(engine.active, isFalse);
      expect(engine.state, VoiceLiveState.idle);
    });

    test('starting again while the last session is still closing releases '
        'its microphone and peer first: never two captures', () async {
      final transport = FakeLiveTransport();
      final peers = <FakeLivePeer>[];
      final tracks = <FakeLiveTrack>[];
      final conversation = GptLiveConversation(
        transport: transport,
        peerConnectionFactory: () async {
          final peer = FakeLivePeer();
          peers.add(peer);
          return peer;
        },
        microphoneFactory: () async {
          final track = FakeLiveTrack();
          tracks.add(track);
          return FakeLiveStream(track);
        },
      );
      final engine = VoiceLiveEngine(
        transport: transport,
        session: conversation,
      );
      addTearDown(engine.dispose);
      expect(await engine.start(), isTrue);
      await engine.stop();
      expect(peers.single.closed, isFalse);

      expect(await engine.start(), isTrue);

      expect(peers, hasLength(2));
      expect(peers.first.closed, isTrue);
      expect(tracks.first.stopped, isTrue);
      expect(peers.last.closed, isFalse);
      expect(tracks.last.stopped, isFalse);
      expect(engine.active, isTrue);
      expect(transport.sessionCalls, 2);
    });
  });

  group('connection loss', () {
    for (final state in const [
      RTCPeerConnectionState.RTCPeerConnectionStateFailed,
      RTCPeerConnectionState.RTCPeerConnectionStateDisconnected,
    ]) {
      test('peer ${state.name} finishes the session as connection_lost and '
          'stops the microphone (review probe G6)', () async {
        final live = newFakeLive();
        final engine = _engine(live);
        addTearDown(engine.dispose);
        final announced = <String>[];
        engine.onClosed = announced.add;
        expect(await engine.start(), isTrue);
        expect(live.peer.onConnectionState, isNotNull);

        live.peer.onConnectionState!(state);
        await pumpEventQueue();

        expect(announced, ['connection_lost']);
        expect(live.track.stopped, isTrue);
        expect(live.peer.closed, isTrue);
        expect(live.peer.channel.closed, isTrue);
        expect(engine.active, isFalse);
        expect(engine.state, VoiceLiveState.idle);
        expect(_holdsMicrophone(engine), isFalse);
      });
    }

    test('connecting and connected keep the session', () async {
      final live = newFakeLive();
      final engine = _engine(live);
      addTearDown(engine.dispose);
      final announced = <String>[];
      engine.onClosed = announced.add;
      expect(await engine.start(), isTrue);

      live.peer.onConnectionState!(
        RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
      );
      live.peer.onConnectionState!(
        RTCPeerConnectionState.RTCPeerConnectionStateConnected,
      );
      await pumpEventQueue();

      expect(announced, isEmpty);
      expect(engine.active, isTrue);
      expect(live.track.stopped, isFalse);
    });

    test('the data channel closing under the session finishes it as '
        'connection_lost', () async {
      final live = newFakeLive();
      final engine = _engine(live);
      addTearDown(engine.dispose);
      final announced = <String>[];
      engine.onClosed = announced.add;
      expect(await engine.start(), isTrue);
      expect(live.peer.channel.onDataChannelState, isNotNull);

      live.peer.channel.remoteClose();
      await pumpEventQueue();

      expect(announced, ['connection_lost']);
      expect(live.track.stopped, isTrue);
      expect(live.peer.closed, isTrue);
      expect(engine.active, isFalse);
    });

    test('closing the channel ourselves is never reported as a lost '
        'connection', () async {
      final live = await startFakeLive();
      final reasons = <String>[];
      live.conversation.onClosed = (reason, _) => reasons.add(reason);

      // forceClose closes the channel, which reports its closed state.
      await live.conversation.forceClose('stopped');
      await pumpEventQueue();

      expect(live.peer.channel.closed, isTrue);
      expect(reasons, ['stopped']);
      live.conversation.dispose();
    });

    test('nothing is sent once the channel has reported closing', () async {
      final live = await startFakeLive();
      addTearDown(live.conversation.dispose);
      final channel = live.peer.channel;

      channel.onDataChannelState!(RTCDataChannelState.RTCDataChannelClosing);
      live.conversation.instruct('Respond now.');
      live.conversation.speak('A reply.');

      expect(channel.sent, isEmpty);
    });
  });

  group('teardown racing start', () {
    // native: a real flutter_webrtc peer answers calls after close with an
    // error ("peerConnection is null"), which used to skip the track stop.
    for (final native in const [false, true]) {
      test('native=$native: dispose while the microphone prompt is pending '
          'never POSTs the session and stops the late track '
          '(review probe G8)', () async {
        final transport = FakeLiveTransport();
        final peer = FakeLivePeer()..throwWhenClosed = native;
        final track = FakeLiveTrack();
        final microphone = Completer<MediaStream>();
        final conversation = GptLiveConversation(
          transport: transport,
          peerConnectionFactory: () async => peer,
          microphoneFactory: () => microphone.future,
        );
        final engine = VoiceLiveEngine(
          transport: transport,
          session: conversation,
        );
        final started = engine.start();
        await pumpEventQueue();

        // Chat switch, route cover or background while the prompt is up.
        engine.dispose();
        microphone.complete(FakeLiveStream(track));

        expect(await started, isFalse);
        await pumpEventQueue();
        expect(track.stopped, isTrue);
        expect(peer.closed, isTrue);
        expect(transport.sessionCalls, 0);
        expect(conversation.active, isFalse);
      });
    }

    test('teardown while the peer is still being created closes the late '
        'peer and never asks for the microphone', () async {
      final transport = FakeLiveTransport();
      final peer = FakeLivePeer();
      final peerReady = Completer<RTCPeerConnection>();
      var microphoneRequests = 0;
      final conversation = GptLiveConversation(
        transport: transport,
        peerConnectionFactory: () => peerReady.future,
        microphoneFactory: () async {
          microphoneRequests++;
          return FakeLiveStream(FakeLiveTrack());
        },
      );
      final engine = VoiceLiveEngine(
        transport: transport,
        session: conversation,
      );
      addTearDown(engine.dispose);
      final started = engine.start();
      await pumpEventQueue();

      await engine.stopNow('hidden');
      peerReady.complete(peer);

      expect(await started, isFalse);
      await pumpEventQueue();
      expect(peer.closed, isTrue);
      expect(microphoneRequests, 0);
      expect(transport.sessionCalls, 0);
      expect(engine.active, isFalse);
    });

    test('teardown while POST /voice-live/session is in flight: the answer '
        'is not applied and the microphone and peer are released', () async {
      final live = newFakeLive();
      live.transport.sessionGate = Completer<void>();
      final engine = _engine(live);
      addTearDown(engine.dispose);
      final started = engine.start();
      await pumpEventQueue();
      expect(live.transport.sessionCalls, 1);

      await engine.stopNow('hidden');
      live.transport.sessionGate!.complete();

      expect(await started, isFalse);
      await pumpEventQueue();
      expect(live.peer.remote, isNull);
      expect(live.track.stopped, isTrue);
      expect(live.peer.closed, isTrue);
      expect(engine.active, isFalse);
      expect(_holdsMicrophone(engine), isFalse);
    });

    test('a start cancelled by teardown reports nothing as an error, and '
        'the next start opens a fresh session', () async {
      final transport = FakeLiveTransport();
      final peers = <FakeLivePeer>[];
      final tracks = <FakeLiveTrack>[];
      final gates = <Completer<MediaStream>>[];
      final conversation = GptLiveConversation(
        transport: transport,
        peerConnectionFactory: () async {
          final peer = FakeLivePeer();
          peers.add(peer);
          return peer;
        },
        microphoneFactory: () {
          final gate = Completer<MediaStream>();
          gates.add(gate);
          return gate.future;
        },
      );
      final engine = VoiceLiveEngine(
        transport: transport,
        session: conversation,
      );
      addTearDown(engine.dispose);
      final errors = <String>[];
      engine.onError = errors.add;

      final first = engine.start();
      await pumpEventQueue();
      await engine.stopNow('hidden');
      // The person comes back and starts again before the first prompt
      // answered.
      final second = engine.start();
      await pumpEventQueue();
      for (final gate in gates) {
        final track = FakeLiveTrack();
        tracks.add(track);
        gate.complete(FakeLiveStream(track));
      }

      expect(await first, isFalse);
      expect(await second, isTrue);
      await pumpEventQueue();
      expect(errors, isEmpty);
      expect(peers, hasLength(2));
      expect(peers.first.closed, isTrue);
      expect(tracks.first.stopped, isTrue);
      expect(peers.last.closed, isFalse);
      expect(tracks.last.stopped, isFalse);
      expect(transport.sessionCalls, 1);
      expect(engine.active, isTrue);
    });

    test('a double tap on Start joins the start in flight: one peer, one '
        'microphone, one session', () async {
      final transport = FakeLiveTransport();
      final peers = <FakeLivePeer>[];
      final conversation = GptLiveConversation(
        transport: transport,
        peerConnectionFactory: () async {
          final peer = FakeLivePeer();
          peers.add(peer);
          return peer;
        },
        microphoneFactory: () async => FakeLiveStream(FakeLiveTrack()),
      );
      final engine = VoiceLiveEngine(
        transport: transport,
        session: conversation,
      );
      addTearDown(engine.dispose);

      final results = await Future.wait([engine.start(), engine.start()]);

      expect(results, [true, true]);
      expect(peers, hasLength(1));
      expect(peers.single.closed, isFalse);
      expect(transport.sessionCalls, 1);
      expect(engine.active, isTrue);
    });
  });
}
