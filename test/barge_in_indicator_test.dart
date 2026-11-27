// Barge-in privacy: while barge-in listens during read-aloud the microphone
// is on, so both layouts show it, and Settings says so before it is enabled
// (voice review of 46683e29, card B item 1).
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/controllers/hands_free_conversation_controller.dart'
    show HandsFreeSpeechOutcome;
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/auto_speak_replies.dart';
import 'package:hermes_android/core/services/barge_in_monitor.dart';
import 'package:hermes_android/core/services/barge_in_preference.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hands_free_route_observer.dart';
import 'package:hermes_android/core/services/hands_free_speech.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/data/read_aloud.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';

const _micLive = ValueKey('barge-in-mic-live');

class _HeldSpeaker implements VoiceReplySpeaker {
  final spoken = <String>[];
  Completer<HandsFreeSpeechOutcome>? held;

  @override
  Future<bool> prepare() async => true;

  @override
  Future<HandsFreeSpeechOutcome> speak(
    String text, {
    required bool Function() isCurrent,
  }) {
    spoken.add(text);
    if (!isCurrent()) return Future.value(HandsFreeSpeechOutcome.canceled);
    return (held = Completer<HandsFreeSpeechOutcome>()).future;
  }

  void finish() {
    final c = held;
    held = null;
    if (c != null && !c.isCompleted) {
      c.complete(HandsFreeSpeechOutcome.completed);
    }
  }

  @override
  Future<void> stop() async {
    final c = held;
    held = null;
    if (c != null && !c.isCompleted) {
      c.complete(HandsFreeSpeechOutcome.canceled);
    }
  }
}

/// A monitor whose microphone opens (or refuses to) as told.
class _Monitor implements BargeInMonitor {
  _Monitor({this.opens = true});
  final bool opens;
  bool live = false;
  int stops = 0;

  @override
  Future<bool> start({
    required void Function() onInterrupt,
    String? echoText,
    bool Function()? isCurrent,
  }) async {
    live = opens;
    return opens;
  }

  @override
  Future<void> stop() async {
    stops++;
    live = false;
  }
}

Map<String, dynamic> _arb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const ttsChannel = MethodChannel('flutter_tts');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
    bargeInEnabled.value = false;
    autoSpeakRepliesEnabled.value = false;
    // The read configures its voice first; answer like an engine would.
    messenger.setMockMethodCallHandler(
      ttsChannel,
      (call) async => call.method == 'getMaxSpeechInputLength' ? 4000 : 1,
    );
  });

  tearDown(() {
    bargeInEnabled.value = false;
    autoSpeakRepliesEnabled.value = false;
    messenger.setMockMethodCallHandler(ttsChannel, null);
  });

  group('NgReadAloud', () {
    test('the barge-in mic is live only while its monitor listens', () async {
      bargeInEnabled.value = true;
      final speaker = _HeldSpeaker();
      final monitors = <_Monitor>[];
      final reader = NgReadAloud(
        speaker: speaker,
        bargeInMonitor: () {
          final monitor = _Monitor();
          monitors.add(monitor);
          return monitor;
        },
      );
      addTearDown(reader.dispose);
      var notified = 0;
      reader.addListener(() => notified++);
      expect(reader.bargeInListening, isFalse);

      final reading = reader.read('a', 'Hello there.');
      await pumpEventQueue();
      expect(monitors.single.live, isTrue);
      expect(reader.bargeInListening, isTrue);
      expect(notified, greaterThan(0));

      speaker.finish();
      await reading;
      expect(monitors.single.live, isFalse);
      expect(reader.bargeInListening, isFalse);
    });

    test(
      'no live mic when barge-in is off or the monitor cannot open',
      () async {
        final speaker = _HeldSpeaker();
        final reader = NgReadAloud(
          speaker: speaker,
          bargeInMonitor: () => _Monitor(opens: false),
        );
        addTearDown(reader.dispose);

        var reading = reader.read('a', 'Off.');
        await pumpEventQueue();
        expect(reader.bargeInListening, isFalse);
        speaker.finish();
        await reading;

        bargeInEnabled.value = true;
        reading = reader.read('b', 'Refused.');
        await pumpEventQueue();
        expect(reader.bargeInListening, isFalse);
        speaker.finish();
        await reading;
      },
    );

    test(
      'a newer read keeps its own live mic when the old read unwinds',
      () async {
        bargeInEnabled.value = true;
        final speaker = _HeldSpeaker();
        final reader = NgReadAloud(
          speaker: speaker,
          bargeInMonitor: () => _Monitor(),
        );
        addTearDown(reader.dispose);

        final first = reader.read('a', 'First.');
        await pumpEventQueue();
        final second = reader.read('b', 'Second.');
        await first;
        await pumpEventQueue();
        expect(reader.readingKey, 'b');
        expect(reader.bargeInListening, isTrue);
        await reader.stop();
        await second;
        expect(reader.bargeInListening, isFalse);
      },
    );
  });

  group('NextGen', () {
    Future<(NgChatController, NextGenGateway, _HeldSpeaker)> pumpChat(
      WidgetTester tester,
    ) async {
      final prefs = await SharedPreferences.getInstance();
      final conn = SavedConnection(
        id: 'c1',
        label: 'Home',
        host: '10.0.0.5',
        port: 9119,
        apiKey: '',
        desktopGatewayUrl: 'http://10.0.0.5:9119',
        singleLogin: true,
        signInMethod: 'none',
      );
      final gateway = NextGenGateway(conn);
      final chat = NgChatController(gateway, sessionId: 'stored')
        ..runtimeId = 'stored';
      chat.debugApplyHistory(const [
        {'role': 'user', 'content': 'Q1'},
        {'role': 'assistant', 'content': 'A1'},
      ]);
      final speaker = _HeldSpeaker();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: nextGenTheme(Brightness.light, NextGenLook.instance),
          home: NgScope(
            connManager: ConnectionManager(prefs),
            gateway: gateway,
            connections: [conn],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: Scaffold(
              body: NgChatView(
                chat: chat,
                onOpenSidebar: () {},
                onNewChat: () {},
                readAloudFactory: () =>
                    NgReadAloud(speaker: speaker, bargeInMonitor: _Monitor.new),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      return (chat, gateway, speaker);
    }

    Future<void> teardown(
      WidgetTester tester,
      NgChatController chat,
      NextGenGateway gateway,
    ) async {
      await tester.pumpWidget(const SizedBox());
      chat.dispose();
      gateway.dispose();
    }

    testWidgets('the composer shows the live mic while barge-in listens', (
      tester,
    ) async {
      bargeInEnabled.value = true;
      final (chat, gateway, _) = await pumpChat(tester);
      expect(find.byKey(_micLive), findsNothing);

      await tester.tap(find.byTooltip('Read aloud'));
      for (var i = 0; i < 3; i++) {
        await tester.pump();
      }
      expect(find.byKey(_micLive), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(_micLive),
          matching: find.byIcon(Icons.mic),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byTooltip('Stop'));
      await tester.pump();
      await tester.pump();
      expect(find.byKey(_micLive), findsNothing);
      await teardown(tester, chat, gateway);
    });

    testWidgets('no indicator when barge-in is off', (tester) async {
      final (chat, gateway, _) = await pumpChat(tester);
      await tester.tap(find.byTooltip('Read aloud'));
      for (var i = 0; i < 3; i++) {
        await tester.pump();
      }
      expect(find.byTooltip('Stop'), findsOneWidget);
      expect(find.byKey(_micLive), findsNothing);
      await teardown(tester, chat, gateway);
    });
  });

  testWidgets('Classic shows the live mic while barge-in listens over an '
      'auto-read reply', (tester) async {
    bargeInEnabled.value = true;
    autoSpeakRepliesEnabled.value = true;
    final speaker = _HeldSpeaker();
    final monitors = <_Monitor>[];
    StreamCallback? emit;
    final done = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [handsFreeRouteObserver],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatScreen(
          connection: SavedConnection(
            id: 'barge-fixture',
            label: 'Barge',
            host: 'voice.fixture',
            port: 8642,
            apiKey: 'synthetic-key',
          ),
          session: const Session(
            id: 'barge-chat',
            title: 'Barge',
            model: 'm',
            source: 'test',
            messageCount: 0,
            isActive: true,
            preview: '',
            startedAt: 1,
          ),
          testApiClient: ApiClient(
            baseUrl: 'http://voice.fixture',
            apiKey: 'synthetic-key',
            httpClient: MockClient(
              (_) async => http.Response(jsonEncode({'data': []}), 200),
            ),
          ),
          testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
          testVoiceReplySpeaker: speaker,
          testBargeInMonitor: () {
            final monitor = _Monitor();
            monitors.add(monitor);
            return monitor;
          },
          testRemotePromptSubmit:
              ({
                required sessionId,
                required text,
                required onEvent,
                required onSent,
              }) async {
                emit = onEvent;
                onSent();
                onEvent(
                  StreamEvent(
                    type: 'message.start',
                    data: const {},
                    turnId: 'barge-turn',
                  ),
                );
                await done.future;
              },
          testNormalResume:
              ({required localSessionId, required storedSessionId}) async =>
                  const ResumedGatewaySession(
                    runtimeSessionId: 'barge-runtime',
                    running: false,
                  ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(_micLive), findsNothing);
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'hello',
    );
    await tester.tap(find.byKey(const Key('chat-send-message')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    const reply = 'Here is the reply.';
    for (final event in [
      StreamEvent(
        type: 'message.complete',
        data: const {'text': reply, 'status': 'completed'},
        turnId: 'barge-turn',
      ),
      StreamEvent(
        type: 'turn.end',
        data: const {'status': 'completed'},
        turnId: 'barge-turn',
      ),
    ]) {
      emit!(event);
    }
    done.complete();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(speaker.spoken, contains(reply));
    expect(monitors, isNotEmpty);
    expect(find.byKey(_micLive), findsOneWidget);

    speaker.finish();
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byKey(_micLive), findsNothing);
    expect(monitors.every((m) => !m.live), isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  test('Settings says the microphone stays on while replies are read', () {
    final en = _arb('en');
    for (final key in ['barge_in_subtitle', 'ng_barge_in_subtitle']) {
      expect(
        (en[key] as String).toLowerCase(),
        contains('microphone stays on'),
        reason: key,
      );
    }
    for (final locale in [
      'ar',
      'de',
      'es',
      'fr',
      'ja',
      'ko',
      'pt',
      'pt_BR',
      'ru',
      'uk',
      'zh',
      'zh_Hans',
      'zh_Hant',
    ]) {
      final arb = _arb(locale);
      for (final key in [
        'barge_in_subtitle',
        'ng_barge_in_subtitle',
        'barge_in_mic_live',
        'ng_barge_in_mic_live',
      ]) {
        expect(arb[key], isA<String>(), reason: '$locale $key');
        expect(arb[key], isNot(en[key]), reason: '$locale $key');
      }
    }
  });
}
