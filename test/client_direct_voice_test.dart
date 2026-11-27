// Client-direct voice: provider wire formats, relay fallback and key hygiene.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/client_direct_voice.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _configJson = {
  'ok': true,
  'stt': {
    'mode': 'direct',
    'wire': 'openai-multipart',
    'provider': 'openai',
    'base_url': 'https://stt.invalid/v1/',
    'api_key': 'fixture-stt-key',
    'model': 'whisper-1',
    'language': 'en',
    'timeout_s': 12,
    'hallucination_filter': {
      'phrases': ['thank you', 'thanks'],
      'repeat_regex': r'^(?:thank you|thanks|ok)[.,!\s]+$',
    },
  },
  'tts': {
    'mode': 'direct',
    'wire': 'openai-speech',
    'provider': 'openai',
    'base_url': 'https://tts.invalid/v1',
    'api_key': 'fixture-tts-key',
    'model': 'gpt-4o-mini-tts',
    'voice': 'alloy',
    'speed': 1.25,
    'extra_body': {'lang_code': 'en'},
  },
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory fixtureDir;

  setUp(() {
    fixtureDir = Directory('build/client-direct-voice-test')
      ..createSync(recursive: true);
    File(
      '${fixtureDir.path}/recording.m4a',
    ).writeAsBytesSync([0x00, 0x01, 0x02, 0x03]);
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    if (fixtureDir.existsSync()) fixtureDir.deleteSync(recursive: true);
  });

  test('relay (unknown provider, old backend) keeps both directions null', () {
    expect(parseVoiceClientConfig(null), isNull);
    expect(parseVoiceClientConfig({'ok': false}), isNull);
    final relay = parseVoiceClientConfig({
      'ok': true,
      'stt': {'mode': 'relay', 'reason': 'local provider'},
      'tts': {'mode': 'relay', 'reason': 'no credentials'},
    });
    expect(relay?.sttIsDirect, isFalse);
    expect(relay?.ttsIsDirect, isFalse);
    final unknown = parseVoiceClientConfig({
      'ok': true,
      'stt': {
        'mode': 'direct',
        'wire': 'mystery',
        'base_url': 'https://x.invalid',
        'api_key': 'k',
      },
      'tts': {'mode': 'relay'},
    });
    expect(unknown?.sttIsDirect, isFalse);
  });

  test(
    'STT uses the profile wire, normalises JSON bodies and filters silence',
    () async {
      final seen = <http.Request>[];
      final client = MockClient((request) async {
        seen.add(request);
        return http.Response('{"text":"  hello there  "}', 200);
      });
      final store = VoiceClientConfigStore(
        fetchConfig: () async => _configJson,
        httpClient: client,
      );
      addTearDown(store.dispose);
      final config = await store.configFor('conn::profile');

      final transcript = await store.transcribe(
        '${fixtureDir.path}/recording.m4a',
        fileName: 'recording.m4a',
        mimeType: 'audio/mp4',
        config: config,
      );
      expect(transcript, 'hello there');
      expect(seen.single.method, 'POST');
      expect(
        seen.single.url.toString(),
        'https://stt.invalid/v1/audio/transcriptions',
      );
      expect(seen.single.headers['Authorization'], 'Bearer fixture-stt-key');
      expect(
        seen.single.headers['Content-Type'],
        contains('multipart/form-data'),
      );
      final body = seen.single.body;
      expect(body, contains('whisper-1'));
      expect(body, contains('response_format'));
    },
  );

  test('known hallucinations become silence; real repeats are kept', () async {
    final store = VoiceClientConfigStore(
      fetchConfig: () async => _configJson,
      httpClient: MockClient((_) async => http.Response('Thank you.', 200)),
    );
    addTearDown(store.dispose);
    final config = await store.configFor('conn::profile');
    expect(
      await store.transcribe(
        '${fixtureDir.path}/recording.m4a',
        fileName: 'recording.m4a',
        mimeType: 'audio/mp4',
        config: config,
      ),
      isEmpty,
    );
    expect(isSilenceHallucination('Thank. you.', config!.stt!), isFalse);
  });

  test('TTS posts the profile model/voice and returns audio bytes', () async {
    http.Request? seen;
    final client = MockClient((request) async {
      seen = request;
      return http.Response('mp3-bytes', 200);
    });
    final store = VoiceClientConfigStore(
      fetchConfig: () async => _configJson,
      httpClient: client,
    );
    addTearDown(store.dispose);
    final config = await store.configFor('conn::profile');

    final audio = await store.synthesize('A reply.', config: config);
    expect(utf8.decode(audio!), 'mp3-bytes');
    expect(seen!.url.toString(), 'https://tts.invalid/v1/audio/speech');
    expect(seen!.headers['Authorization'], 'Bearer fixture-tts-key');
    final body = jsonDecode(seen!.body) as Map<String, dynamic>;
    expect(body['voice'], 'alloy');
    expect(body['speed'], 1.25);
    expect(body['lang_code'], 'en');
    expect(body['response_format'], 'mp3');
  });

  test('provider rejection throws and is never silently relayed', () async {
    final store = VoiceClientConfigStore(
      fetchConfig: () async => _configJson,
      httpClient: MockClient((_) async => http.Response('bad key', 401)),
    );
    addTearDown(store.dispose);
    final config = await store.configFor('conn::profile');
    expect(
      () => store.transcribe(
        '${fixtureDir.path}/recording.m4a',
        fileName: 'recording.m4a',
        mimeType: 'audio/mp4',
        config: config,
      ),
      throwsA(
        isA<ClientDirectVoiceException>().having(
          (error) => error.message,
          'message',
          contains('HTTP 401'),
        ),
      ),
    );
  });

  test(
    'credentials stay in memory: no prefs write and cache drops on clear',
    () async {
      var fetches = 0;
      final store = VoiceClientConfigStore(
        fetchConfig: () async {
          fetches++;
          return _configJson;
        },
        httpClient: MockClient((_) async => http.Response('ok', 200)),
      );
      addTearDown(store.dispose);
      await store.configFor('conn::profile');
      await store.configFor('conn::profile');
      expect(fetches, 1);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys(), isEmpty);

      store.clear();
      await store.configFor('conn::profile');
      expect(fetches, 2);
      final source = File(
        'lib/core/services/client_direct_voice.dart',
      ).readAsStringSync();
      expect(source, isNot(contains('SharedPreferences')));
      expect(source, isNot(contains('FlutterSecureStorage')));
      expect(source, isNot(contains('print(')));
    },
  );

  test(
    'backgrounding drops the cache, even on a resumed-to-paused jump',
    () async {
      var fetches = 0;
      final store = VoiceClientConfigStore(
        fetchConfig: () async {
          fetches++;
          return _configJson;
        },
        httpClient: MockClient((_) async => http.Response('ok', 200)),
      );
      addTearDown(store.dispose);
      final binding = TestWidgetsFlutterBinding.instance;
      addTearDown(
        () => binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed),
      );
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await store.configFor('conn::profile');
      expect(fetches, 1);

      // No inactive/hidden in between: the store must neither assert on the
      // order nor keep credentials across it.
      binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await store.configFor('conn::profile');
      expect(fetches, 2);
    },
  );

  test(
    'a relay answer is kept for the TTL; a failed fetch is retried',
    () async {
      var fetches = 0;
      var fail = false;
      final store = VoiceClientConfigStore(
        fetchConfig: () async {
          fetches++;
          if (fail) throw const SocketException('unreachable');
          return null; // An older backend: 404, so relay.
        },
        httpClient: MockClient((_) async => http.Response('ok', 200)),
      );
      addTearDown(store.dispose);
      expect(await store.configFor('conn::profile'), isNull);
      expect(await store.configFor('conn::profile'), isNull);
      expect(fetches, 1);

      store.clear();
      fail = true;
      expect(await store.configFor('conn::profile'), isNull);
      expect(await store.configFor('conn::profile'), isNull);
      expect(fetches, 3);
    },
  );

  test('scope switch never reuses another profile\'s credentials', () async {
    var key = 'first';
    final store = VoiceClientConfigStore(
      fetchConfig: () async => {
        ..._configJson,
        'stt': {..._configJson['stt'] as Map, 'api_key': key},
      },
      httpClient: MockClient((_) async => http.Response('ok', 200)),
    );
    addTearDown(store.dispose);
    expect((await store.configFor('conn::first'))?.stt?.apiKey, 'first');
    key = 'second';
    expect((await store.configFor('conn::second'))?.stt?.apiKey, 'second');
  });

  test('toString never leaks the key', () {
    final config = parseVoiceClientConfig(_configJson)!;
    expect(config.stt!.toString(), isNot(contains('fixture')));
    expect(config.tts!.toString(), isNot(contains('fixture')));
  });
}
