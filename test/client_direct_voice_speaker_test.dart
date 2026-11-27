// Client-direct playback: direct wire wins, relay is the floor, stop cancels.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/controllers/hands_free_conversation_controller.dart';
import 'package:hermes_android/core/services/client_direct_voice.dart';
import 'package:hermes_android/core/services/client_direct_voice_speaker.dart';
import 'package:hermes_android/core/services/hands_free_speech.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _FakeSink implements DirectVoiceAudioSink {
  Uint8List? played;
  Completer<HandsFreeSpeechOutcome>? active;
  @override
  Future<HandsFreeSpeechOutcome> play(Uint8List bytes) async {
    played = bytes;
    active = Completer();
    return active!.future;
  }

  @override
  Future<void> stop() async {
    if (active != null && !active!.isCompleted) {
      active!.complete(HandsFreeSpeechOutcome.canceled);
    }
  }
}

class _FakeSpeaker implements VoiceReplySpeaker {
  var calls = 0;
  var stopped = 0;
  @override
  Future<bool> prepare() async => true;
  @override
  Future<HandsFreeSpeechOutcome> speak(
    String text, {
    required bool Function() isCurrent,
  }) async {
    calls++;
    return HandsFreeSpeechOutcome.completed;
  }

  @override
  Future<void> stop() async => stopped++;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late VoiceClientConfigStore store;
  late _FakeSink sink;
  late _FakeSpeaker fallback;
  late ClientDirectVoiceReplySpeaker speaker;

  setUp(() {
    store = VoiceClientConfigStore(
      fetchConfig: () async => {
        'ok': true,
        'stt': {'mode': 'relay'},
        'tts': {
          'mode': 'direct',
          'wire': 'openai-speech',
          'provider': 'openai',
          'base_url': 'https://tts.invalid/v1',
          'api_key': 'fixture-key',
          'model': 'gpt-4o-mini-tts',
          'voice': 'alloy',
        },
      },
      httpClient: MockClient((_) async => http.Response('direct-mp3', 200)),
    );
    sink = _FakeSink();
    fallback = _FakeSpeaker();
    speaker = ClientDirectVoiceReplySpeaker(
      store: store,
      scopeKey: 'test',
      fallback: fallback,
      sink: sink,
    );
  });

  tearDown(() {
    store.dispose();
  });

  test('a configured provider synthesises locally, no relay call', () async {
    final future = speaker.speak('Hello.', isCurrent: () => true);
    await Future<void>.delayed(Duration.zero);
    expect(sink.played, isNotNull);
    expect(fallback.calls, 0);
    sink.active!.complete(HandsFreeSpeechOutcome.completed);
    expect(await future, HandsFreeSpeechOutcome.completed);
  });

  test('a relay config delegates to the existing speaker', () async {
    store.clear();
    final relayStore = VoiceClientConfigStore(
      fetchConfig: () async => {
        'ok': true,
        'stt': {'mode': 'relay'},
        'tts': {'mode': 'relay'},
      },
      httpClient: MockClient((_) async => http.Response('', 200)),
    );
    addTearDown(relayStore.dispose);
    final relaySpeaker = ClientDirectVoiceReplySpeaker(
      store: relayStore,
      scopeKey: 'test',
      fallback: fallback,
      sink: sink,
    );
    expect(
      await relaySpeaker.speak('Hello.', isCurrent: () => true),
      HandsFreeSpeechOutcome.completed,
    );
    expect(fallback.calls, 1);
    expect(sink.played, isNull);
  });

  test(
    'a warmed relay answer speaks without asking the gateway again',
    () async {
      var fetches = 0;
      final relayStore = VoiceClientConfigStore(
        fetchConfig: () async {
          fetches++;
          return null; // An older backend answers 404: relay.
        },
        httpClient: MockClient((_) async => http.Response('', 200)),
      );
      addTearDown(relayStore.dispose);
      final relaySpeaker = ClientDirectVoiceReplySpeaker(
        store: relayStore,
        scopeKey: 'test',
        fallback: fallback,
        sink: sink,
      );
      relaySpeaker.warm();
      await Future<void>.delayed(Duration.zero);
      expect(fetches, 1);

      expect(
        await relaySpeaker.speak('Hello.', isCurrent: () => true),
        HandsFreeSpeechOutcome.completed,
      );
      expect(
        await relaySpeaker.speak('Again.', isCurrent: () => true),
        HandsFreeSpeechOutcome.completed,
      );
      expect(fetches, 1);
      expect(fallback.calls, 2);
    },
  );

  test('stop cancels playback and the delegate', () async {
    final future = speaker.speak('Hello.', isCurrent: () => true);
    await Future<void>.delayed(Duration.zero);
    await speaker.stop();
    expect(await future, HandsFreeSpeechOutcome.canceled);
    expect(fallback.stopped, 1);
  });
}
