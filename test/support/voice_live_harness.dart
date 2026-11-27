// Widget harness for GPT-Live in both layouts: the real VoiceLiveEngine over
// a fake LiveConversation, mounted in Classic's ChatScreen and NextGen's
// NgChatView. No WebRTC plugin, no gateway socket, no network.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/controllers/hands_free_conversation_controller.dart'
    show HandsFreeSpeechOutcome;
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_wake_word.dart';
import 'package:hermes_android/core/services/gpt_live_conversation.dart';
import 'package:hermes_android/core/services/hands_free_speech.dart';
import 'package:hermes_android/core/services/voice_live_engine.dart';
import 'package:hermes_android/core/services/voice_live_mode.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_voice_composer_adapter.dart';

/// A live conversation that only records what the engine asked of it.
class HarnessConversation implements LiveConversation {
  bool _active = false;
  int starts = 0;
  int gracefulCloses = 0;
  final forcedCloses = <String>[];
  bool disposed = false;

  /// Holds [start] open until completed (a pending microphone prompt).
  Future<void>? startGate;

  /// True once the session has been ended by any path.
  bool get ended => gracefulCloses > 0 || forcedCloses.isNotEmpty || disposed;

  @override
  bool get active => _active;
  @override
  String? get sessionId => 'harness-session';
  @override
  String? get delegationId => null;

  @override
  Future<bool> start({List<Map<String, dynamic>>? history}) async {
    starts++;
    final closesBefore = forcedCloses.length + gracefulCloses;
    await startGate;
    // Torn down while the prompt was up: this start is cancelled.
    if (disposed || forcedCloses.length + gracefulCloses != closesBefore) {
      return false;
    }
    _active = true;
    return true;
  }

  @override
  void speak(String text, {String? delegationId}) {}
  @override
  void think(String text, {String? delegationId}) {}
  @override
  void instruct(String text) {}
  @override
  void setMuted(bool muted) {}

  @override
  Future<void> close() async {
    gracefulCloses++;
    _active = false;
  }

  @override
  Future<void> forceClose(String reason, [int? usageSeconds]) async {
    forcedCloses.add(reason);
    _active = false;
  }

  @override
  void dispose() {
    disposed = true;
    _active = false;
  }

  /// The vendor (or the transport) ended the session under the engine.
  void endFromOutside(String reason) {
    _active = false;
    onClosed?.call(reason, null);
  }

  @override
  void Function(String id, Map<String, String> prompt)? onDelegation;
  @override
  void Function(LiveFragment fragment)? onTranscript;
  @override
  void Function(String message, bool fatal)? onError;
  @override
  void Function(String reason, int? usageSeconds)? onClosed;
}

/// Host status: GPT-Live selected and available.
class HarnessLiveTransport implements GptLiveTransport {
  int statusCalls = 0;

  @override
  Future<Object?> status() async {
    statusCalls++;
    return {'ok': true, 'mode': 'gpt-live', 'available': true};
  }

  @override
  Future<Object?> createSession({
    required String sdp,
    List<Map<String, dynamic>>? history,
  }) async => null;

  @override
  void dispose() {}
}

class HarnessReplySpeaker implements VoiceReplySpeaker {
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

/// NextGen gateway with no socket: records `prompt.submit`, answers the rest
/// with an empty result.
class HarnessGateway extends NextGenGateway {
  HarnessGateway(super.connection);

  final submits = <Map<String, dynamic>>[];
  final calls = <String>[];

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    calls.add(method);
    if (method == 'prompt.submit') {
      submits.add(Map<String, dynamic>.from(params));
      return {'status': 'streaming'};
    }
    return {};
  }

  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => throw StateError('not connected');
}

class _NotFoundHttp extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      http.StreamedResponse(
        Stream.value(utf8.encode('{}')),
        404,
        headers: {'content-type': 'application/json'},
      );
}

SavedConnection harnessNextGenConnection({String id = 'c1'}) => SavedConnection(
  id: id,
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: '',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
);

final harnessClassicConnection = SavedConnection(
  id: 'voice-fixture',
  label: 'Voice fixture',
  host: 'voice.fixture',
  port: 8642,
  apiKey: 'synthetic-key',
);

/// One Classic chat's live-voice seams. Keep the instance across re-pumps
/// (for example `active: false`) so the State sees the same collaborators.
class ClassicLiveFixture {
  ClassicLiveFixture({HarnessConversation? conversation})
    : conversation = conversation ?? HarnessConversation();

  final HarnessConversation conversation;
  final transport = HarnessLiveTransport();

  /// The chained dictation microphone; untouched while GPT-Live is the mode.
  final dictation = FakeVoiceComposerAdapter();
  late final mode = VoiceLiveModeController(
    connectionId: harnessClassicConnection.id,
    transport: transport,
    registerShared: false,
  );
  VoiceLiveEngine? engine;

  /// One conversation per engine a view created, in order: every chat view
  /// (and every rebind) owns its own session, as in production. The first
  /// is [conversation].
  final conversations = <HarnessConversation>[];

  VoiceLiveEngine engineFactory(GptLiveTransport transport) {
    final session = conversations.isEmpty
        ? conversation
        : HarnessConversation();
    conversations.add(session);
    return engine = VoiceLiveEngine(transport: transport, session: session);
  }

  /// [wake] overrides the gateway's wake-word controller; [saved] is what a
  /// wake phrase of another profile is routed among; [connection] is the
  /// chat's owner (the fixture connection by default).
  Widget app({
    bool active = true,
    GlobalKey<NavigatorState>? navigatorKey,
    String sessionId = 'voice-session',
    GatewayWakeWordController? wake,
    List<SavedConnection>? saved,
    SavedConnection? connection,
  }) => MaterialApp(
    navigatorKey: navigatorKey,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: ChatScreen(
      active: active,
      connection: connection ?? harnessClassicConnection,
      testWakeController: wake,
      testSavedConnections: saved == null ? null : () async => saved,
      session: Session(
        id: sessionId,
        title: 'Voice chat',
        model: 'fixture-model',
        source: 'test',
        messageCount: 0,
        isActive: true,
        preview: '',
        startedAt: 1,
      ),
      testApiClient: ApiClient(
        baseUrl: 'http://voice.fixture',
        apiKey: 'synthetic-key',
        httpClient: _NotFoundHttp(),
      ),
      testVoiceComposerAdapter: dictation,
      testVoiceReplySpeaker: HarnessReplySpeaker(),
      testVoiceLiveMode: mode,
      testVoiceLiveEngineFactory: engineFactory,
    ),
  );
}

/// A wake-word controller whose gateway is a script: the host arms on its
/// own microphone (no client capture) and the test delivers `wake.detected`.
class HarnessWake {
  HarnessWake({String connectionId = 'c1', String? profile}) {
    controller = GatewayWakeWordController(
      resumeRetryDelay: Duration.zero,
      transport: GatewayWakeTransport(
        connectionId: connectionId,
        profile: profile,
        events: _events.stream,
        ready: const Stream<void>.empty(),
        isConnected: () => true,
        call: (method, params, {timeout = const Duration(seconds: 30)}) async {
          calls.add(method);
          if (method == 'wake.status') {
            return {
              'listening': true,
              'enabled': true,
              'available': true,
              'owned_by_caller': true,
              'phrase': 'hey hermes',
              'capture': 'local',
              'sample_rate': 16000,
              'frame_length': 1280,
            };
          }
          return {'started': true, 'capture': 'local'};
        },
      ),
    );
  }

  final _events = StreamController<StreamEvent>.broadcast();
  final calls = <String>[];
  late final GatewayWakeWordController controller;

  /// The gateway heard a wake phrase. [profile] names the profile whose
  /// phrase matched; [startNewSession] is omitted when null (the host
  /// default is a fresh session).
  void detect({String? profile, bool? startNewSession}) => _events.add(
    StreamEvent(
      type: 'wake.detected',
      data: {
        'phrase': 'hey hermes',
        'profile': profile,
        'start_new_session': ?startNewSession,
      },
    ),
  );

  void dispose() {
    controller.dispose();
    unawaited(_events.close());
  }
}

/// One NextGen chat's live-voice seams.
class NextGenLiveFixture {
  NextGenLiveFixture({
    HarnessConversation? conversation,
    HarnessGateway? gateway,
    this.wake,
    List<SavedConnection>? connections,
  }) : conversation = conversation ?? HarnessConversation(),
       gateway = gateway ?? HarnessGateway(harnessNextGenConnection()) {
    this.connections = connections ?? [this.gateway.connection];
  }

  final HarnessConversation conversation;
  final HarnessGateway gateway;
  final GatewayWakeWordController? wake;
  late final List<SavedConnection> connections;
  final transport = HarnessLiveTransport();
  late final mode = VoiceLiveModeController(
    connectionId: gateway.connection.id,
    transport: transport,
    registerShared: false,
  );

  /// An existing chat (it has a stored session).
  late final chat = NgChatController(gateway, sessionId: 'stored')
    ..runtimeId = 'stored'
    ..debugApplyHistory(const []);

  /// A fresh chat: no stored session yet.
  late final freshChat = NgChatController(gateway);
  VoiceLiveEngine? engine;

  /// Connection ids the view asked the shell to switch to.
  final switchedTo = <String>[];

  /// How often the view asked the shell for a new chat.
  int newChats = 0;

  /// One conversation per engine a view created, in order: every chat view
  /// (and every rebind) owns its own session, as in production. The first
  /// is [conversation].
  final conversations = <HarnessConversation>[];

  VoiceLiveEngine engineFactory(GptLiveTransport transport) {
    final session = conversations.isEmpty
        ? conversation
        : HarnessConversation();
    conversations.add(session);
    return engine = VoiceLiveEngine(transport: transport, session: session);
  }

  /// [showing] defaults to the existing chat. The view is keyed by its chat
  /// as the main page keys it, so another chat is another view.
  Future<Widget> app({
    GlobalKey<NavigatorState>? navigatorKey,
    NgChatController? showing,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final shown = showing ?? chat;
    return MaterialApp(
      navigatorKey: navigatorKey,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: nextGenTheme(Brightness.light, NextGenLook.instance),
      home: NgScope(
        connManager: ConnectionManager(prefs),
        gateway: gateway,
        connections: connections,
        switchTo: (id) async => switchedTo.add(id),
        addGateway: () async {},
        signOut: (_) async {},
        reload: () async {},
        signInAgain: () async {},
        child: Scaffold(
          body: NgChatView(
            key: ObjectKey(shown),
            chat: shown,
            onOpenSidebar: () {},
            onNewChat: () => newChats++,
            wakeController: wake,
            voiceModeController: mode,
            voiceLiveEngineFactory: engineFactory,
          ),
        ),
      ),
    );
  }
}

/// Bounded settle: live controls and banners never reach `pumpAndSettle`.
Future<void> settleLive(WidgetTester tester, {int frames = 6}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Taps the composer's live Start and waits for the session to open.
Future<void> startLiveFromComposer(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('voice-live-start')));
  await settleLive(tester);
}

/// Unmounts the tree and drains its teardown timers.
Future<void> unmountLive(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await settleLive(tester);
}
