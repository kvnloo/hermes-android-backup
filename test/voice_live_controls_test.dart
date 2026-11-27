// GPT-Live composer controls: start/stop/mute, delegation -> the composer's
// OWN prompt.submit, stop-word teardown, and the reply feed, in both Classic
// and NextGen. Engines are real VoiceLiveEngine instances over a fake WebRTC
// conversation; no packaged build or live gateway is involved.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gpt_live_conversation.dart';
import 'package:hermes_android/core/services/voice_live_engine.dart';
import 'package:hermes_android/core/services/voice_live_mode.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/voice_live_controls.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class _FakeConversation implements LiveConversation {
  bool _active = false;
  String? _delegationId;
  String? _sessionId;
  String? lastSpeakText;
  String? lastThinkText;
  bool lastMuted = false;
  bool closed = false;
  int startCalls = 0;
  List<String> sentInstructions = [];

  @override
  bool get active => _active;
  @override
  String? get sessionId => _sessionId;
  @override
  String? get delegationId => _delegationId;

  @override
  Future<bool> start({List<Map<String, dynamic>>? history}) async {
    startCalls++;
    _active = true;
    return true;
  }

  @override
  void speak(String text, {String? delegationId}) {
    lastSpeakText = text;
  }

  @override
  void think(String text, {String? delegationId}) {
    lastThinkText = text;
  }

  @override
  void instruct(String text) {
    sentInstructions.add(text);
  }

  @override
  void setMuted(bool muted) {
    lastMuted = muted;
  }

  @override
  Future<void> close() async {
    closed = true;
    _active = false;
  }

  @override
  Future<void> forceClose(String reason, [int? usageSeconds]) async {
    closed = true;
    _active = false;
  }

  @override
  void dispose() {
    _active = false;
    closed = true;
  }

  @override
  void Function(String id, Map<String, String> prompt)? onDelegation;
  @override
  void Function(LiveFragment fragment)? onTranscript;
  @override
  void Function(String message, bool fatal)? onError;
  @override
  void Function(String reason, int? usageSeconds)? onClosed;

  void fireDelegation(String id, String prompt, {String? context}) {
    _delegationId = id;
    onDelegation?.call(id, {
      'prompt': prompt,
      'context': context ?? 'Some prior exchange',
    });
  }
}

class _LiveTransport implements GptLiveTransport {
  _LiveTransport({this.seededStatus});

  final GptLiveStatus? seededStatus;

  @override
  Future<Object?> status() async => {
    'ok': true,
    'mode': seededStatus?.isLive == true ? 'gpt-live' : 'chained',
    'available': seededStatus?.available ?? false,
    'reason': seededStatus?.reason,
  };

  @override
  Future<Object?> createSession({
    required String sdp,
    List<Map<String, dynamic>>? history,
  }) async => {
    'ok': true,
    'session': {'id': 'test-live-session', 'sdp': 'answer'},
    'transport': {'sdp': 'answer'},
  };

  @override
  void dispose() {}
}

/// Gateway that serves an acceptable `prompt.submit` so the delegation path
/// runs its wire leg without a live socket. Everything else is empty.
class _FakeGateway extends NextGenGateway {
  _FakeGateway(super.connection);

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (method == 'prompt.submit') return {'status': 'ok'};
    return {};
  }

  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => throw StateError('not connected');
}

/// Builds the NextGen chat-view tree without requiring a group-local capture.
Future<void> _pumpNextGen(
  WidgetTester tester, {
  required NgChatController chat,
  required _FakeConversation conversation,
  required _LiveTransport transport,
  required SavedConnection conn,
  required _FakeGateway gateway,
}) async {
  final prefs = await SharedPreferences.getInstance();
  _capturedChat = chat;
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
            voiceModeController: VoiceLiveModeController(
              connectionId: 'c1',
              transport: transport,
            ),
            voiceLiveEngineFactory: (transport) {
              final engine = VoiceLiveEngine(
                transport: transport,
                session: conversation,
              );
              _capturedEngine = engine;
              return engine;
            },
          ),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

/// The engine the view created in the current test. The composer widgets
/// construct the engine themselves, so the widget-under-test hands it to this
/// variable via the factory hook.
VoiceLiveEngine? _capturedEngine;

/// The last NextGen chat instance the widget drove.
NgChatController? _capturedChat;

GptLiveStatus _liveStatus() => const GptLiveStatus(
  mode: 'gpt-live',
  available: true,
  reason: null,
  model: 'gpt-live-1',
  voice: 'marin',
);

class _EmptyChatHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode({'error': 'unexpected request'}))),
      404,
      headers: {'content-type': 'application/json'},
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
    _capturedEngine = null;
    _capturedChat = null;
  });

  group('Classic composer', () {
    Future<void> pumpChat(
      WidgetTester tester, {
      required _FakeConversation conversation,
      required _LiveTransport transport,
      String? Function({required String sessionId, required String text})?
      onSubmit,
    }) async {
      final apiClient = ApiClient(
        baseUrl: 'http://voice.fixture',
        apiKey: 'synthetic-key',
        httpClient: _EmptyChatHttpClient(),
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChatScreen(
            connection: SavedConnection(
              id: 'voice-fixture',
              label: 'Voice fixture',
              host: 'voice.fixture',
              port: 8642,
              apiKey: 'synthetic-key',
            ),
            session: const Session(
              id: 'voice-session',
              title: 'Voice chat',
              model: 'fixture-model',
              source: 'test',
              messageCount: 0,
              isActive: true,
              preview: '',
              startedAt: 1,
            ),
            testApiClient: apiClient,
            testRemotePromptSubmit:
                ({
                  required sessionId,
                  required text,
                  required onEvent,
                  required onSent,
                }) async {
                  if (onSubmit != null) {
                    onSubmit(sessionId: sessionId, text: text);
                  }
                  onSent();
                },
            testVoiceLiveMode: VoiceLiveModeController(
              connectionId: 'voice-fixture',
              transport: transport,
            ),
            testVoiceLiveEngineFactory: (transport) {
              final engine = VoiceLiveEngine(
                transport: transport,
                session: conversation,
              );
              _capturedEngine = engine;
              return engine;
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
    }

    testWidgets(
      'start shows inline controls, mute toggles, stop ends the session',
      (tester) async {
        final conversation = _FakeConversation();
        final transport = _LiveTransport(seededStatus: _liveStatus());
        await pumpChat(
          tester,
          conversation: conversation,
          transport: transport,
        );

        await tester.tap(find.byKey(const ValueKey('voice-live-start')));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        expect(conversation.startCalls, 1);
        expect(
          find.byKey(const ValueKey('voice-live-inline-controls')),
          findsOneWidget,
        );

        final engine = _capturedEngine!;
        expect(engine.muted, isFalse);
        await tester.tap(find.byKey(const ValueKey('voice-live-mute')));
        await tester.pump();
        expect(conversation.lastMuted, isTrue);
        expect(engine.muted, isTrue);

        await tester.tap(find.byKey(const ValueKey('voice-live-stop')));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));
        expect(conversation.closed, isTrue);
        expect(
          find.byKey(const ValueKey('voice-live-inline-controls')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'delegation routes the utterance to the composer exactly once',
      (tester) async {
        final conversation = _FakeConversation();
        final transport = _LiveTransport(seededStatus: _liveStatus());
        String? submittedText;
        await pumpChat(
          tester,
          conversation: conversation,
          transport: transport,
          onSubmit: ({required sessionId, required text}) =>
              submittedText = text,
        );

        await tester.tap(find.byKey(const ValueKey('voice-live-start')));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        conversation.fireDelegation('delegation-1', 'What is on the agenda?');
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        expect(submittedText, 'What is on the agenda?');
      },
    );

    testWidgets('stop-word transcript tears the session down', (tester) async {
      final conversation = _FakeConversation();
      final transport = _LiveTransport(seededStatus: _liveStatus());
      await pumpChat(tester, conversation: conversation, transport: transport);

      await tester.tap(find.byKey(const ValueKey('voice-live-start')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      conversation.onTranscript?.call(
        const LiveFragment(speaker: 'user', text: 'stop'),
      );
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pump(const Duration(milliseconds: 300));

      expect(conversation.closed, isTrue);
    });

    testWidgets('background closes the live session', (tester) async {
      final conversation = _FakeConversation();
      final transport = _LiveTransport(seededStatus: _liveStatus());
      await pumpChat(tester, conversation: conversation, transport: transport);

      await tester.tap(find.byKey(const ValueKey('voice-live-start')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      expect(conversation.active, isTrue);

      WidgetsBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.paused,
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(conversation.closed, isTrue);
    });
  });

  group('Engine selector panel', () {
    testWidgets(
      'unavailable gpt-live shows the host reason and falls back to chained',
      (tester) async {
        final transport = _LiveTransport(
          seededStatus: const GptLiveStatus(
            mode: 'gpt-live',
            available: false,
            reason: 'Host has no GPT-Live key',
            model: 'gpt-live-1',
            voice: 'marin',
          ),
        );
        final controller = VoiceLiveModeController(
          connectionId: 'fixture-unavailable',
          transport: transport,
          registerShared: false,
        );
        await controller.refresh();
        await tester.pumpWidget(
          MaterialApp(
            theme: nextGenTheme(Brightness.light, NextGenLook.instance),
            home: Scaffold(
              body: VoiceEngineSettingsPanel(controller: controller),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 200));

        expect(
          find.byKey(const ValueKey('voice-engine-fallback-notice')),
          findsOneWidget,
        );
        expect(find.textContaining('Host has no GPT-Live key'), findsWidgets);
        expect(controller.effectiveMode, 'chained');
        controller.dispose();
      },
    );
  });

  group('NextGen composer', () {
    Future<void> pumpChat(
      WidgetTester tester, {
      required _FakeConversation conversation,
      required _LiveTransport transport,
    }) async {
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
      final gateway = _FakeGateway(conn);
      final chat = NgChatController(gateway, sessionId: 'stored')
        ..runtimeId = 'stored';
      chat.debugApplyHistory(const []);
      await _pumpNextGen(
        tester,
        chat: chat,
        conversation: conversation,
        transport: transport,
        conn: conn,
        gateway: gateway,
      );
    }

    testWidgets('start shows inline controls, stop ends the session', (
      tester,
    ) async {
      final conversation = _FakeConversation();
      final transport = _LiveTransport(seededStatus: _liveStatus());
      await pumpChat(tester, conversation: conversation, transport: transport);

      await tester.tap(find.byKey(const ValueKey('voice-live-start')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(conversation.startCalls, 1);
      expect(
        find.byKey(const ValueKey('voice-live-inline-controls')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('voice-live-stop')));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(conversation.closed, isTrue);
    });

    testWidgets(
      'delegation sends prompt.submit with surface voice-live and voice_context',
      (tester) async {
        final conversation = _FakeConversation();
        final transport = _LiveTransport(seededStatus: _liveStatus());
        await pumpChat(
          tester,
          conversation: conversation,
          transport: transport,
        );

        await tester.tap(find.byKey(const ValueKey('voice-live-start')));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        conversation.fireDelegation(
          'delegation-1',
          'What is on the agenda?',
          context: 'User asked about the agenda',
        );
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        final chat = _capturedChat!;
        final userItems = chat.items.whereType<NgUserItem>().toList();
        expect(userItems, isNotEmpty);
        final last = userItems.last;
        expect(last.promptParams['surface'], 'voice-live');
        expect(
          last.promptParams['voice_context'],
          'User asked about the agenda',
        );
        expect(last.text, 'What is on the agenda?');
      },
    );

    testWidgets('the reply feed speaks the assistant reply and settles', (
      tester,
    ) async {
      final conversation = _FakeConversation();
      final transport = _LiveTransport(seededStatus: _liveStatus());
      await pumpChat(tester, conversation: conversation, transport: transport);

      await tester.tap(find.byKey(const ValueKey('voice-live-start')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      conversation.fireDelegation('delegation-feed', 'give me the status');
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(conversation.lastSpeakText, isNull);

      _capturedChat!.debugApplyHistory(const [
        {'role': 'user', 'content': 'give me the status'},
        {
          'role': 'assistant',
          'content': 'Here is the status. Everything is green.',
        },
      ]);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 250));
      }

      expect(conversation.lastSpeakText, isNotNull);
      expect(conversation.lastSpeakText, contains('status'));
    });

    testWidgets('stop-word transcript tears the session down', (tester) async {
      final conversation = _FakeConversation();
      final transport = _LiveTransport(seededStatus: _liveStatus());
      await pumpChat(tester, conversation: conversation, transport: transport);

      await tester.tap(find.byKey(const ValueKey('voice-live-start')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      conversation.onTranscript?.call(
        const LiveFragment(speaker: 'user', text: 'stop it'),
      );
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pump(const Duration(milliseconds: 300));

      expect(conversation.closed, isTrue);
    });

    testWidgets('switch chat mid-session drops the old session', (
      tester,
    ) async {
      final conversation = _FakeConversation();
      final transport = _LiveTransport(seededStatus: _liveStatus());
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
      final gateway = _FakeGateway(conn);
      final chatA = NgChatController(gateway, sessionId: 'stored')
        ..runtimeId = 'stored';
      final chatB = NgChatController(gateway, sessionId: 'stored2')
        ..runtimeId = 'stored2';
      chatA.debugApplyHistory(const []);
      chatB.debugApplyHistory(const []);
      await _pumpNextGen(
        tester,
        chat: chatA,
        conversation: conversation,
        transport: transport,
        conn: conn,
        gateway: gateway,
      );
      await tester.tap(find.byKey(const ValueKey('voice-live-start')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      expect(conversation.startCalls, 1);
      final oldEngine = _capturedEngine!;

      await _pumpNextGen(
        tester,
        chat: chatB,
        conversation: conversation,
        transport: transport,
        conn: conn,
        gateway: gateway,
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(oldEngine.active, isFalse);
      expect(_capturedEngine, isNot(same(oldEngine)));
      expect(conversation.active, isFalse);

      conversation.fireDelegation('late-1', 'late utterance');
      await tester.pump(const Duration(milliseconds: 100));
      expect(chatA.items.whereType<NgUserItem>(), isEmpty);
      expect(chatB.items.whereType<NgUserItem>(), isEmpty);
    });

    testWidgets('background closes the live session', (tester) async {
      final conversation = _FakeConversation();
      final transport = _LiveTransport(seededStatus: _liveStatus());
      await pumpChat(tester, conversation: conversation, transport: transport);

      await tester.tap(find.byKey(const ValueKey('voice-live-start')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      expect(conversation.active, isTrue);

      WidgetsBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.paused,
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(conversation.closed, isTrue);
    });
  });
}
