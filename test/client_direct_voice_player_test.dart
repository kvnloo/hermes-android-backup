// Client-direct playback opens its audio player on first playback, never at
// chat mount, gives every player its own id, and releases it on dispose
// (review of 46683e29: the eager player broke chat_history_widget_test).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/client_direct_voice.dart';
import 'package:hermes_android/core/services/client_direct_voice_speaker.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hands_free_speech.dart';
import 'package:hermes_android/core/controllers/hands_free_conversation_controller.dart'
    show HandsFreeSpeechOutcome;
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';

/// Records what reaches the audioplayers platform channels.
class _AudioChannels {
  final created = <String>[];
  final disposed = <String>[];
  final globalCalls = <String>[];

  static const _players = MethodChannel('xyz.luan/audioplayers');
  static const _global = MethodChannel('xyz.luan/audioplayers.global');
  static const _globalEvents = EventChannel(
    'xyz.luan/audioplayers.global/events',
  );

  TestDefaultBinaryMessenger get _messenger =>
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void install() {
    _messenger.setMockMethodCallHandler(_global, (call) async {
      globalCalls.add(call.method);
      return null;
    });
    _messenger.setMockStreamHandler(
      _globalEvents,
      MockStreamHandler.inline(onListen: (_, _) {}),
    );
    _messenger.setMockMethodCallHandler(_players, (call) async {
      final args = (call.arguments as Map?) ?? const {};
      final id = args['playerId']?.toString() ?? '';
      switch (call.method) {
        case 'create':
          created.add(id);
          _messenger.setMockStreamHandler(
            EventChannel('xyz.luan/audioplayers/events/$id'),
            MockStreamHandler.inline(onListen: (_, _) {}),
          );
        case 'dispose':
          disposed.add(id);
      }
      return null;
    });
  }

  void uninstall() {
    _messenger.setMockMethodCallHandler(_players, null);
    _messenger.setMockMethodCallHandler(_global, null);
    _messenger.setMockStreamHandler(_globalEvents, null);
  }
}

class _Relay implements VoiceReplySpeaker {
  @override
  Future<bool> prepare() async => true;
  @override
  Future<HandsFreeSpeechOutcome> speak(
    String text, {
    required bool Function() isCurrent,
  }) async => HandsFreeSpeechOutcome.completed;
  @override
  Future<void> stop() async {}
}

class _NotFound extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      http.StreamedResponse(const Stream.empty(), 404);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _AudioChannels channels;

  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
    channels = _AudioChannels()..install();
  });

  tearDown(() => channels.uninstall());

  // First: audioplayers keeps process-wide platform state, so the screen
  // check runs before any test here creates a player.
  testWidgets('a Classic chat opens no audio player when it mounts', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatScreen(
          connection: SavedConnection(
            id: 'player-fixture',
            label: 'Player fixture',
            host: 'player.fixture',
            port: 8642,
            apiKey: 'synthetic-key',
          ),
          session: const Session(
            id: 'player-session',
            title: 'Player chat',
            model: 'fixture-model',
            source: 'test',
            messageCount: 0,
            isActive: true,
            preview: '',
            startedAt: 1,
          ),
          testApiClient: ApiClient(
            baseUrl: 'http://player.fixture',
            apiKey: 'synthetic-key',
            httpClient: _NotFound(),
          ),
          testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
        ),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(channels.created, isEmpty);
    expect(channels.globalCalls, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(channels.created, isEmpty);
  });

  test('a sink opens no player until it plays', () async {
    final sink = FlutterDirectVoiceAudioSink();
    await pumpEventQueue();
    await sink.stop();
    await pumpEventQueue();
    expect(channels.created, isEmpty);
    expect(channels.globalCalls, isEmpty);
    await sink.dispose();
    expect(channels.disposed, isEmpty);
  });

  test(
    'every sink plays on a player id of its own, released on dispose',
    () async {
      final first = FlutterDirectVoiceAudioSink();
      final second = FlutterDirectVoiceAudioSink();
      final bytes = Uint8List.fromList(const [1, 2, 3]);
      // Playback never finishes against the mocked platform; only the player
      // creation matters here.
      first.play(bytes).ignore();
      second.play(bytes).ignore();
      await pumpEventQueue();
      expect(channels.created, hasLength(2));
      expect(channels.created.toSet(), hasLength(2));
      for (final id in channels.created) {
        expect(id, startsWith('ares-direct-voice-'));
      }
      await first.dispose();
      await second.dispose();
      await pumpEventQueue();
      expect(channels.disposed.toSet(), channels.created.toSet());
    },
  );

  test(
    'the speaker disposes the sink it created, not an injected one',
    () async {
      final store = VoiceClientConfigStore(
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
      addTearDown(store.dispose);
      final speaker = ClientDirectVoiceReplySpeaker(
        store: store,
        scopeKey: 'test',
        fallback: _Relay(),
      );
      expect(channels.created, isEmpty);
      speaker.speak('Hello.', isCurrent: () => true).ignore();
      await pumpEventQueue();
      expect(channels.created, hasLength(1));
      await speaker.dispose();
      await pumpEventQueue();
      expect(channels.disposed, channels.created);
    },
  );
}
