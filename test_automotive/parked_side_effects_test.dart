// Run with --dart-define=ARES_PARKED_AUTOMOTIVE=true, outside the phone suite.
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hermes_android/core/controllers/hands_free_conversation_controller.dart';
import 'package:hermes_android/core/parked_automotive.dart';
import 'package:hermes_android/core/services/apk_update_installer.dart';
import 'package:hermes_android/core/services/app_update_service.dart';
import 'package:hermes_android/core/services/attachment_video_service.dart';
import 'package:hermes_android/core/services/hands_free_speech.dart';
import 'package:hermes_android/core/services/hands_free_voice_platform.dart';
import 'package:hermes_android/core/services/local_voice_recorder.dart';
import 'package:hermes_android/core/services/mobile_push_service.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/voice_composer_adapter.dart';
import 'package:hermes_android/nextgen/data/read_aloud.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => expect(isParkedAutomotive, isTrue));
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  List<String> watch(String channel) {
    final calls = <String>[];
    final target = MethodChannel(channel);
    messenger.setMockMethodCallHandler(target, (call) async {
      calls.add(call.method);
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(target, null));
    return calls;
  }

  test(
    'wake, dictation and capture never reach a permission prompt or recognizer',
    () async {
      const channel = 'com.hermesagent.hermes_android/voice';
      final calls = watch(channel);
      final eventCalls = watch('$channel/events');
      final platform = MethodChannelHandsFreeVoicePlatform();
      expect(await platform.events.isEmpty, isTrue);
      expect(await platform.requestRecordPermission(), isFalse);
      await expectLater(platform.capabilities(), throwsUnsupportedError);
      await expectLater(
        platform.armWake(ownerId: 'chat', generation: 1, armId: 'arm'),
        throwsUnsupportedError,
      );
      await expectLater(
        platform.recognizeOnce(
          ownerId: 'chat',
          generation: 1,
          requestId: 'manual',
          purpose: VoiceRecognitionPurpose.manual,
          localeId: null,
          listenForMs: 1000,
          pauseForMs: 100,
          noSpeechTimeoutMs: null,
        ),
        throwsUnsupportedError,
      );
      expect(calls, isEmpty);
      expect(eventCalls, isEmpty);
      final alternate = SpeechToTextVoiceComposerAdapter();
      expect(await alternate.hasPermission, isFalse);
      expect(
        await alternate.initialize(onStatus: (_) {}, onError: (_) {}),
        isFalse,
      );
      await expectLater(
        alternate.listen(
          onResult: ({required transcript, required isFinal}) {},
        ),
        throwsUnsupportedError,
      );
      alternate.dispose();
    },
  );

  test('record and playback do not even open voice draft storage', () async {
    final recorder = LocalVoiceRecorder(
      'session',
      supportDirectory: () => fail('Touched voice files'),
    );
    expect(await recorder.hasPermission(request: true), isFalse);
    expect(await recorder.restore(), isFalse);
    await expectLater(recorder.start(), throwsUnsupportedError);
    await expectLater(recorder.resumeRecording(), throwsUnsupportedError);
    await expectLater(recorder.play(() {}), throwsUnsupportedError);
    await recorder.close();
  });

  test(
    'reading a reply never configures, starts or stops a TTS engine',
    () async {
      final calls = watch('flutter_tts');
      final speaker = FlutterVoiceReplySpeaker(FlutterTts());
      expect(await speaker.prepare(), isFalse);
      expect(
        await speaker.speak('reply', isCurrent: () => true),
        HandsFreeSpeechOutcome.unavailable,
      );
      await speaker.stop();
      for (final android in [true, false]) {
        final nextGen = NgReadAloud(android: android);
        await nextGen.read('message', 'reply');
        expect(nextGen.readingKey, isNull);
        await nextGen.stop();
        nextGen.dispose();
      }
      expect(calls, isEmpty);
    },
  );

  test('a foreground playback grant cannot stage or open a video', () async {
    final session = AttachmentVideoSession(
      fileStore: AttachmentVideoFileStore(
        temporaryDirectoryProvider: () => fail('Staged a video'),
      ),
    );
    await session.setPlaybackAllowed(true);
    await expectLater(
      session.open(Uint8List.fromList([1]), 'mp4'),
      throwsUnsupportedError,
    );
    await session.play();
    expect(session.controller, isNull);
    await session.close();
  });

  test(
    'cached launch opt-in and manual checks cannot fetch or install an APK',
    () async {
      // The analyzer does not recognize test_automotive as a test directory.
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({
        AppUpdateService.checkOnLaunchKey: true,
      });
      var requests = 0;
      final service = AppUpdateService(
        client: MockClient((_) async {
          requests++;
          throw StateError('Unexpected update request');
        }),
      );
      expect(await service.checkOnLaunchEnabled(), isFalse);
      expect(
        await service.launchPromptRelease(currentVersion: '1.0.0'),
        isNull,
      );
      expect(
        (await service.checkForUpdate(
          currentVersion: '1.0.0',
          force: true,
        )).outcome,
        AppUpdateOutcome.failed,
      );
      expect(requests, 0);
      final calls = watch('com.hermesagent.hermes_android/apk_update');
      final installer = ApkUpdateInstaller();
      final apk = AppReleaseApk(
        abi: 'arm64-v8a',
        name: 'test.apk',
        url: Uri.parse('https://example.invalid/test.apk'),
        sha256: '0' * 64,
        size: 8,
      );
      expect(installer.supported, isFalse);
      expect(await installer.supportedAbis(), isEmpty);
      expect(await installer.hasPreparedUpdate(apk, 'v1'), isFalse);
      await expectLater(
        installer.download(apk: apk, tag: 'v1', onProgress: (_, _) {}),
        throwsUnsupportedError,
      );
      expect(await installer.install(), 'failed');
      await installer.cancel();
      expect(calls, isEmpty);
    },
  );

  test(
    'the manifest without notification permission never prompts or posts',
    () async {
      final calls = watch('dexterous.com/flutter/local_notifications');
      final service = TurnNotificationService();
      await service.ensureInitialized(requestPermission: true);
      await service.refreshAuthorization();
      expect(await service.takeInitialNotificationResponse(), isNull);
      expect(
        await service.sendTestNotification(title: 'test', body: 'test'),
        isFalse,
      );
      expect(service.permissionGranted, isFalse);
      expect(MobilePushService().supported, isFalse);
      expect(calls, isEmpty);
    },
  );
}
