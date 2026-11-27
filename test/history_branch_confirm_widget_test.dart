// Branch-confirmation probes for the F17 rewind flow (Edit/Restore) plus the
// narrow-pane history entry — Classic and NextGen layouts.
//
// Proves, with an in-memory fake gateway and no live personal endpoints:
//  - the destructive-cut confirm appears when later user turns would be
//    archived,
//  - Cancel sends nothing,
//  - Confirm sends exactly one prompt.submit with confirm_truncate and the
//    durable target (truncate_before_row_id), after interrupting the turn,
//  - under 480 px the history action lives inside "More chat tools".
//
// Fixture rows: two user turns so the first would truncate later turns.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/projects_tree_overview.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/normal_gateway_application_session.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/core/services/gateway_turn_coordinator.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_history_owner.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _classicId = 'probe-history-classic';
const _storedId = 'stored-1';
const _runtimeId = 'rt-confirm';

/// Two user turns + two replies so editing the first archives the second.
List<Map<String, dynamic>> _historyRows() => [
  {'id': 7, 'role': 'user', 'content': 'Keep this'},
  {'id': 8, 'role': 'assistant', 'content': 'Noted', 'finish_reason': 'stop'},
  {'id': 9, 'role': 'user', 'content': 'Another question'},
  {
    'id': 10,
    'role': 'assistant',
    'content': 'Another answer',
    'finish_reason': 'stop',
  },
];

List<Map<String, dynamic>> _historyRowsNextGen() => [
  {'id': 7, 'role': 'user', 'content': 'Keep this', 'timestamp': 1000.0},
  {'id': 8, 'role': 'assistant', 'content': 'Noted', 'timestamp': 1001.0},
  {'id': 9, 'role': 'user', 'content': 'Another question', 'timestamp': 1002.0},
  {
    'id': 10,
    'role': 'assistant',
    'content': 'Another answer',
    'timestamp': 1003.0,
  },
];

List<Map<String, dynamic>> _historyRpcRows() => [
  {'row_id': 7, 'role': 'user', 'text': 'Keep this'},
  {'row_id': 8, 'role': 'assistant', 'text': 'Noted'},
  {'row_id': 9, 'role': 'user', 'text': 'Another question'},
  {'row_id': 10, 'role': 'assistant', 'text': 'Another answer'},
];

/// Mirrors DesktopGatewayClient for the Classic path: records every wire
/// call so the probe can assert the exact submit payload and the interrupt.
class _RecordingDesktopClient implements DesktopGatewayClient {
  _RecordingDesktopClient(this.workspace);

  @override
  final RemoteWorkspaceOwner workspace;

  final List<Map<String, dynamic>> submits = [];
  final List<Map<String, dynamic>> interrupts = [];
  final List<({String method, Map<String, dynamic> params})> rpcCalls = [];
  DesktopAsyncEventCallback? _sessionEvents;

  @override
  bool get sessionAuthority => true;

  @override
  bool get slashCommandsSupported => false;

  @override
  void setSessionBoundListener(
    GatewayTurnSessionBoundCallback? listener, {
    GatewayTurnSessionBoundCallback? onCreated,
  }) {}

  @override
  void setSessionEventListener(DesktopAsyncEventCallback? listener) {
    _sessionEvents = listener;
  }

  @override
  void setAsyncEventListener(
    DesktopAsyncEventCallback? listener, {
    DesktopAsyncEventSessionPredicate? acceptsSession,
  }) {}

  @override
  void setConnectionListener(DesktopConnectionCallback? listener) {}

  @override
  void setReconnectAllowed(bool allowed) {}

  @override
  void bindStoredSession(String localSessionId, String storedSessionId) {}

  @override
  void close() {}

  @override
  String? storedSessionKeyFor(String mobileSessionId) => mobileSessionId;

  @override
  String? boundTerminalBackend(String storedSessionId) => null;

  @override
  bool hasLiveSession(String mobileSessionId) => true;

  @override
  Future<Map<String, dynamic>> requestSessionRpc(
    String method,
    Map<String, dynamic> params,
  ) async {
    rpcCalls.add((method: method, params: Map<String, dynamic>.from(params)));
    if (method == 'session.history') {
      return {'messages': _historyRpcRows()};
    }
    return const <String, dynamic>{};
  }

  @override
  Future<bool> interruptPrompt({required String sessionId}) async {
    interrupts.add({'sessionId': sessionId});
    return true;
  }

  @override
  Future<void> submitPrompt({
    required String sessionId,
    required String text,
    required StreamCallback onEvent,
    required void Function() onSent,
    bool Function()? maySend,
    Future<bool> Function()? beforeSend,
    void Function()? onAccepted,
    String? submissionId,
    Future<void> Function()? beforeLegacy,
    Future<void> Function(Object?, String)? onReceipt,
    Map<String, Object?> extraParams = const {},
  }) async {
    submits.add({
      'sessionId': sessionId,
      'text': text,
      'extraParams': Map<String, Object?>.of(extraParams),
    });
    onSent();
    onAccepted?.call();
    _sessionEvents?.call(
      sessionId,
      StreamEvent(type: 'message.start', data: const {}),
    );
    _sessionEvents?.call(
      sessionId,
      StreamEvent(type: 'message.delta', data: const {'text': 'Edited reply'}),
    );
    _sessionEvents?.call(
      sessionId,
      StreamEvent(type: 'turn.end', data: const {}),
    );
  }

  @override
  Future<void> ensureSession(
    String sessionId, {
    String? workingDirectory,
  }) async {}

  @override
  bool ownsApprovalRequest(String sessionId, {String? requestId}) => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnsupportedError(
    'Unexpected DesktopGatewayClient.${invocation.memberName}',
  );
}

class _OwnerController extends GatewayTurnApplicationController {
  _OwnerController(this.normal);

  final NormalGatewayApplicationSession normal;

  @override
  NormalGatewayApplicationSession normalSessionFor(
    SavedConnection connection, {
    NormalGatewayPromptSubmit? submit,
    NormalGatewaySteer? steer,
    NormalGatewayResume? resume,
    NormalGatewayHistory? history,
    TurnNotificationService? notifications,
  }) => normal;

  @override
  Future<void> close() async {
    await normal.close();
    await super.close();
  }
}

/// Records every prompt.submit and answers canned RPCs for the NextGen path.
class _NextGenBranchGateway extends NextGenGateway {
  _NextGenBranchGateway(
    RemoteWorkspaceOwner owner,
    SavedConnection connection,
    DashboardClient dashboard,
  ) : _owner = owner,
      super(connection, dashboard: dashboard) {
    _socket = WsClient(connection.desktopGatewayUrl!);
  }

  final RemoteWorkspaceOwner _owner;
  late final WsClient _socket;

  final calls = <({String method, Map<String, dynamic> params})>[];

  @override
  RemoteWorkspaceOwner get workspace => _owner;

  @override
  WsClient? get socket => _socket;

  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => _socket;

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    calls.add((method: method, params: Map<String, dynamic>.from(params)));
    switch (method) {
      case 'prompt.submit':
        return {'status': 'started'};
      case 'session.interrupt':
        return {'status': 'interrupted'};
      case 'session.resume':
        return {'session_id': _runtimeId};
      case 'session.history':
        return {'messages': _historyRpcRows()};
    }
    return const <String, dynamic>{};
  }
}

Future<void> _settle(WidgetTester tester, [int rounds = 30]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  }
}

Future<void> _typeEditedProbe(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('edit-turn-field')),
    'Edited probe',
  );
  await _settle(tester);
}

Widget _classicApp({
  required FakeHistoryBackend backend,
  required _RecordingDesktopClient client,
  required _OwnerController controller,
}) => MaterialApp(
  theme: hermesTheme(Brightness.light),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: ChatScreen(
    connection: backend.connection,
    session: Session(
      id: _classicId,
      title: 'Branch probe',
      model: 'fixture',
      source: 'desktop',
      messageCount: 2,
      isActive: true,
      preview: '',
      startedAt: 1,
      isLocalDraft: false,
    ),
    turnApplicationController: controller,
    testProjectOverviewLoader: () async => ProjectsTreeOverview.empty,
    testApiClient: ApiClient(
      baseUrl: backend.dashboard.baseUrl,
      apiKey: '',
      httpClient: MockClient((req) async {
        if (req.url.path.contains('/messages')) {
          return http.Response(
            jsonEncode({'data': _historyRows()}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'session': {'id': _classicId, 'archived': false},
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    ),
    testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
  ),
);

Widget _nextGenApp({
  required _NextGenBranchGateway gateway,
  required NgChatController chat,
  required ConnectionManager connManager,
}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
  home: NgScope(
    connManager: connManager,
    gateway: gateway,
    connections: [gateway.connection],
    switchTo: (_) async {},
    addGateway: () async {},
    signOut: (_) async {},
    reload: () async {},
    signInAgain: () async {},
    child: NgChatView(chat: chat, onOpenSidebar: () {}, onNewChat: () {}),
  ),
);

Future<void> _openClassicEditFlow(WidgetTester tester) async {
  await tester.longPress(find.text('Keep this', findRichText: true));
  await _settle(tester);
  await tester.tap(find.text('Edit and resend'));
  await _settle(tester);
  await _typeEditedProbe(tester);
  await tester.tap(find.byKey(const Key('edit-turn-send')));
  await _settle(tester);
}

Future<void> _openNextGenEditFlow(WidgetTester tester) async {
  // NextGen's chat ListView uses reverse: true, so the earliest stored user
  // turn ('Keep this') is the last 'ng-user-edit' button in widget order.
  await tester.tap(find.byKey(const Key('ng-user-edit')).last);
  await _settle(tester);
  await _typeEditedProbe(tester);
  await tester.tap(find.byKey(const Key('edit-turn-send')));
  await _settle(tester);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, (_) async => null);
    mockChatImageRecovery();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, null);
  });

  testWidgets('Classic: edit confirm appears on later turns; cancel sends '
      'nothing; confirm sends one truncating submit', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend(profile: 'field-work');
    addTearDown(backend.close);
    final client = _RecordingDesktopClient(backend.owner);
    final normal = NormalGatewayApplicationSession(
      connection: backend.connection,
      scope: 'history-branch-confirm-classic',
      client: client,
      resume: ({required localSessionId, required storedSessionId}) async =>
          const ResumedGatewaySession(runtimeSessionId: _runtimeId),
      history: (_) async => _historyRows(),
    );
    final controller = _OwnerController(normal);
    addTearDown(controller.close);
    await normal.ready;

    await tester.pumpWidget(
      _classicApp(backend: backend, client: client, controller: controller),
    );
    await _settle(tester);

    // Rows render.
    expect(find.text('Noted', findRichText: true), findsOneWidget);
    expect(find.text('Another question', findRichText: true), findsOneWidget);

    // Edit the FIRST user turn: later user turns would be archived.
    await _openClassicEditFlow(tester);

    // The destructive-cut confirm appears.
    expect(
      find.byKey(const Key('restore-turn-confirm')),
      findsOneWidget,
      reason: 'confirm must appear when later user turns would be archived',
    );

    // Cancel: nothing sent.
    await tester.tap(find.byKey(const Key('restore-turn-cancel')));
    await _settle(tester);
    expect(client.submits, isEmpty, reason: 'cancel must send nothing');
    expect(client.interrupts, isEmpty);

    // Edit again and confirm this time.
    await _openClassicEditFlow(tester);
    await tester.tap(find.byKey(const Key('restore-turn-confirm')));
    await _settle(tester);

    expect(find.byKey(const Key('restore-turn-confirm')), findsNothing);
    expect(
      client.interrupts,
      hasLength(1),
      reason: 'the live turn must be interrupted before the truncation',
    );
    expect(
      client.submits,
      hasLength(1),
      reason: 'confirm must send exactly one prompt.submit',
    );
    final submit = client.submits.single;
    expect(submit['text'], 'Edited probe');
    final params = submit['extraParams'] as Map<String, Object?>;
    expect(params['confirm_truncate'], isTrue);
    expect(params['truncate_before_row_id'], 7);
    expect(params['confirm_deep_truncate'], isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await controller.close();
    await tester.pump();
  });

  testWidgets('NextGen: edit confirm appears on later turns; cancel sends '
      'nothing; confirm sends one truncating submit', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend(profile: 'field-work');
    addTearDown(backend.close);
    final httpClient = MockClient((req) async {
      if (req.url.path.contains('/messages')) {
        return http.Response(
          jsonEncode({'messages': _historyRowsNextGen()}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      return http.Response('{}', 200);
    });
    final gateway = _NextGenBranchGateway(
      backend.owner,
      backend.connection,
      DashboardClient(host: '10.0.0.5', proxied: true, httpClient: httpClient),
    );
    final chat = NgChatController(gateway, sessionId: _storedId)
      ..runtimeId = _runtimeId;
    final connManager = ConnectionManager(
      (await SharedPreferences.getInstance()),
    );
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });

    await tester.pumpWidget(
      _nextGenApp(gateway: gateway, chat: chat, connManager: connManager),
    );
    await chat.open();
    await _settle(tester);

    expect(find.text('Noted'), findsOneWidget);
    expect(find.text('Another question'), findsOneWidget);

    // Edit the first user turn (later turns would be archived).
    await _openNextGenEditFlow(tester);

    expect(
      find.byKey(const Key('restore-turn-confirm')),
      findsOneWidget,
      reason: 'confirm must appear when later user turns would be archived',
    );

    // Cancel: nothing sent.
    await tester.tap(find.byKey(const Key('restore-turn-cancel')));
    await _settle(tester);
    expect(
      gateway.calls.where((c) => c.method == 'prompt.submit'),
      isEmpty,
      reason: 'cancel must send nothing',
    );
    expect(
      gateway.calls.where((c) => c.method == 'session.interrupt'),
      isEmpty,
    );

    // Edit again and confirm this time.
    await _openNextGenEditFlow(tester);
    await tester.tap(find.byKey(const Key('restore-turn-confirm')));
    await _settle(tester);

    expect(find.byKey(const Key('restore-turn-confirm')), findsNothing);
    expect(
      gateway.calls.where((c) => c.method == 'session.interrupt'),
      hasLength(1),
      reason: 'the live turn must be interrupted before the truncation',
    );
    final submits = gateway.calls
        .where((c) => c.method == 'prompt.submit')
        .toList();
    expect(
      submits,
      hasLength(1),
      reason: 'confirm must send exactly one prompt.submit',
    );
    final params = submits.single.params;
    expect(params['confirm_truncate'], isTrue);
    expect(params['truncate_before_row_id'], 7);
    expect(params['confirm_deep_truncate'], isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Classic: narrow pane (<480 px) keeps history in More chat '
      'tools', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 900);
    addTearDown(tester.view.reset);

    final backend = FakeHistoryBackend(profile: 'field-work');
    addTearDown(backend.close);
    final client = _RecordingDesktopClient(backend.owner);
    final normal = NormalGatewayApplicationSession(
      connection: backend.connection,
      scope: 'history-narrow-classic',
      client: client,
      resume: ({required localSessionId, required storedSessionId}) async =>
          const ResumedGatewaySession(runtimeSessionId: _runtimeId),
      history: (_) async => _historyRows(),
    );
    final controller = _OwnerController(normal);
    addTearDown(controller.close);

    await tester.pumpWidget(
      _classicApp(backend: backend, client: client, controller: controller),
    );
    await _settle(tester);

    expect(find.byKey(const ValueKey('session-history')), findsNothing);
    expect(find.byKey(const ValueKey('chat-tools-menu')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('chat-tools-menu')));
    await _settle(tester);
    await tester.tap(find.text('Session history'));
    await _settle(tester);

    expect(
      find.byKey(const ValueKey('history-refresh')),
      findsOneWidget,
      reason: 'the history page must open from the narrow-pane menu',
    );

    // Select saved row 7: Cancel sends no branch mutation; Continue sends one.
    await tester.tap(find.byKey(const ValueKey('history-message-7')));
    await _settle(tester);
    await tester.tap(find.byKey(const ValueKey('history-branch')));
    await _settle(tester);
    expect(find.byKey(const ValueKey('history-confirm')), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await _settle(tester);
    expect(backend.mutations, isEmpty);

    await tester.tap(find.byKey(const ValueKey('history-branch')));
    await _settle(tester);
    await tester.tap(find.byKey(const ValueKey('history-confirm')));
    await _settle(tester);
    expect(backend.mutations, hasLength(1));
    expect(backend.mutations.single['operation'], 'branch');
    expect(
      (backend.mutations.single['payload'] as Map)['through_message_id'],
      7,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await controller.close();
    await tester.pump();
  });

  testWidgets('NextGen: narrow pane (<480 px) keeps history in More chat '
      'tools', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 900);
    addTearDown(tester.view.reset);

    final backend = FakeHistoryBackend(profile: 'field-work');
    addTearDown(backend.close);

    final httpClient = MockClient((req) async {
      if (req.url.path.contains('/messages')) {
        return http.Response(
          jsonEncode({'messages': _historyRowsNextGen()}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      return http.Response('{}', 200);
    });
    final gateway = _NextGenBranchGateway(
      backend.owner,
      backend.connection,
      DashboardClient(host: '10.0.0.5', proxied: true, httpClient: httpClient),
    );
    final chat = NgChatController(gateway, sessionId: _storedId)
      ..runtimeId = _runtimeId;
    final connManager = ConnectionManager(
      await SharedPreferences.getInstance(),
    );
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });

    await tester.pumpWidget(
      _nextGenApp(gateway: gateway, chat: chat, connManager: connManager),
    );
    await chat.open();
    await _settle(tester);

    expect(find.byKey(const ValueKey('session-history')), findsNothing);
    expect(find.byKey(const ValueKey('chat-tools-menu')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('chat-tools-menu')));
    await _settle(tester);
    await tester.tap(find.text('Session history'));
    await _settle(tester);

    expect(
      find.byKey(const ValueKey('history-refresh')),
      findsOneWidget,
      reason: 'the history page must open from the narrow-pane menu',
    );

    // Select saved row 7: Cancel sends no branch mutation; Continue sends one.
    await tester.tap(find.byKey(const ValueKey('history-message-7')));
    await _settle(tester);
    await tester.tap(find.byKey(const ValueKey('history-branch')));
    await _settle(tester);
    expect(find.byKey(const ValueKey('history-confirm')), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await _settle(tester);
    expect(backend.mutations, isEmpty);

    await tester.tap(find.byKey(const ValueKey('history-branch')));
    await _settle(tester);
    await tester.tap(find.byKey(const ValueKey('history-confirm')));
    await _settle(tester);
    expect(backend.mutations, hasLength(1));
    expect(backend.mutations.single['operation'], 'branch');
    expect(
      (backend.mutations.single['payload'] as Map)['through_message_id'],
      7,
    );

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
