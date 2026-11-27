// The independent review's rewind probes (review of 172cfd30, P1-P4), kept
// as permanent regressions. Each failed on 172cfd30:
//  P1 Classic: Edit during a live turn did nothing and said nothing; it now
//     interrupts the turn and sends one truncating submit (Desktop's
//     planEditAfterConfirm).
//  P2 Classic / P3 NextGen: after a confirmed edit the archived turns stayed
//     on screen; they now leave at once (Desktop's applyRewindOptimistic).
//  P4 Classic: after one completed turn the deep-cut confirm was skipped,
//     because "later user turns" was read from the rows of this visit; it is
//     now read from the full session.history.
//
// Fixture rows: two user turns so the first would truncate later turns.
import 'dart:async';
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

List<Map<String, dynamic>> Function() _classicRows = _historyRows;
List<Map<String, dynamic>> Function() _rpcRows = _historyRpcRowsBase;

List<Map<String, dynamic>> _historyRpcRows() => _rpcRows();

List<Map<String, dynamic>> _historyRpcRowsBase() => [
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
  bool endTurns = true;
  bool asyncEvents = false;
  void Function()? onSubmit;
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

  /// Whether an interrupt ends the running turn, as the gateway does (its
  /// terminal frames follow the interrupt). False is a turn that never
  /// answers the interrupt.
  bool interruptEndsTurn = true;

  @override
  Future<bool> interruptPrompt({required String sessionId}) async {
    interrupts.add({'sessionId': sessionId});
    if (interruptEndsTurn) {
      // The gateway saves the interrupted turn as it stands.
      _classicRows = () => [
        ..._historyRows(),
        {'id': 11, 'role': 'user', 'content': 'Live prompt'},
        {
          'id': 12,
          'role': 'assistant',
          'content': 'Edited reply',
          'finish_reason': 'stop',
        },
      ];
      _rpcRows = () => [
        ..._historyRpcRowsBase(),
        {'row_id': 11, 'role': 'user', 'text': 'Live prompt'},
        {'row_id': 12, 'role': 'assistant', 'text': 'Edited reply'},
      ];
      // The interrupt is answered first; the turn's terminal frames follow.
      unawaited(
        Future<void>.delayed(const Duration(milliseconds: 20), () {
          _sessionEvents?.call(
            sessionId,
            StreamEvent(
              type: 'message.complete',
              data: const {'text': 'Edited reply'},
              turnId: _liveTurnId,
            ),
          );
          _sessionEvents?.call(
            sessionId,
            StreamEvent(type: 'turn.end', data: const {}, turnId: _liveTurnId),
          );
          _liveTurn?.complete();
          _liveTurn = null;
        }),
      );
    }
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
    onSubmit?.call();
    onSent();
    onAccepted?.call();
    if (asyncEvents) {
      await Future<void>.delayed(Duration.zero);
      _sessionEvents?.call(
        sessionId,
        StreamEvent(type: 'message.start', data: const {}),
      );
      _sessionEvents?.call(
        sessionId,
        StreamEvent(
          type: 'message.complete',
          data: const {'text': 'Edited reply'},
        ),
      );
      _sessionEvents?.call(
        sessionId,
        StreamEvent(type: 'turn.end', data: const {}),
      );
      return;
    }
    // The gateway stamps each frame with its turn: the terminal frame of
    // the same turn is what settles it.
    final turn = endTurns ? null : 'wire-turn-${submits.length}';
    _sessionEvents?.call(
      sessionId,
      StreamEvent(type: 'message.start', data: const {}, turnId: turn),
    );
    _sessionEvents?.call(
      sessionId,
      StreamEvent(
        type: 'message.delta',
        data: const {'text': 'Edited reply'},
        turnId: turn,
      ),
    );
    if (!endTurns) {
      _liveTurnId = turn;
      // A live turn: the submit stays open until its terminal frame, as
      // the real client's does.
      final done = _liveTurn = Completer<void>();
      await done.future;
      return;
    }
    _sessionEvents?.call(
      sessionId,
      StreamEvent(type: 'turn.end', data: const {}),
    );
  }

  Completer<void>? _liveTurn;
  String? _liveTurnId;

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
            jsonEncode({'data': _classicRows()}),
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
    _classicRows = _historyRows;
    _rpcRows = _historyRpcRowsBase;
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, null);
  });

  testWidgets('P1 Classic: Edit during a live turn interrupts it and sends '
      'one truncating submit', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend(profile: 'field-work');
    addTearDown(backend.close);
    final client = _RecordingDesktopClient(backend.owner)..endTurns = false;
    final normal = NormalGatewayApplicationSession(
      connection: backend.connection,
      scope: 'probe-live-classic',
      client: client,
      resume: ({required localSessionId, required storedSessionId}) async =>
          const ResumedGatewaySession(runtimeSessionId: _runtimeId),
      history: (_) async => _classicRows(),
    );
    final controller = _OwnerController(normal);
    addTearDown(controller.close);
    await normal.ready;
    await tester.pumpWidget(
      _classicApp(backend: backend, client: client, controller: controller),
    );
    await _settle(tester);

    // Start a live turn that does not end.
    final composer = find.byType(TextField).last;
    await tester.enterText(composer, 'Live prompt');
    await _settle(tester);
    await tester.tap(find.byTooltip('Send').hitTestable().first);
    await _settle(tester);
    expect(client.submits, hasLength(1), reason: 'live turn started');

    // Edit an earlier stored turn while the turn streams.
    await tester.longPress(find.text('Keep this', findRichText: true));
    await _settle(tester);
    await tester.tap(find.text('Edit and resend'));
    await _settle(tester);
    await _typeEditedProbe(tester);
    await tester.tap(find.byKey(const Key('edit-turn-send')));
    await _settle(tester);
    // Later turns would be archived: the cut asks first, and nothing has
    // been interrupted or sent before the answer.
    expect(find.byKey(const Key('restore-turn-confirm')), findsOneWidget);
    expect(client.interrupts, isEmpty);
    expect(client.submits, hasLength(1));
    client.endTurns = true;
    await tester.tap(find.byKey(const Key('restore-turn-confirm')));
    await _settle(tester, 160);

    expect(client.interrupts, hasLength(1), reason: 'the live turn is stopped');
    expect(client.submits, hasLength(2), reason: 'then the edit goes out');
    expect(client.submits.last['text'], 'Edited probe');
    expect(client.submits.last['extraParams'], {
      'confirm_truncate': true,
      'truncate_before_row_id': 7,
      'confirm_deep_truncate': true,
      'confirm_empty_truncate': true,
    });

    await tester.pumpWidget(const SizedBox.shrink());
    await controller.close();
    await tester.pump();
  });

  testWidgets('P1b Classic: a live turn that does not stop is never a silent '
      'no-op: the edit says nothing was sent', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend(profile: 'field-work');
    addTearDown(backend.close);
    final client = _RecordingDesktopClient(backend.owner)
      ..endTurns = false
      ..interruptEndsTurn = false;
    final normal = NormalGatewayApplicationSession(
      connection: backend.connection,
      scope: 'probe-stuck-classic',
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
    await tester.enterText(find.byType(TextField).last, 'Live prompt');
    await _settle(tester);
    await tester.tap(find.byTooltip('Send').hitTestable().first);
    await _settle(tester);
    expect(client.submits, hasLength(1));

    await _openClassicEditFlow(tester);
    await tester.tap(find.byKey(const Key('restore-turn-confirm')));
    await _settle(tester, 160);

    expect(client.interrupts, hasLength(1));
    expect(client.submits, hasLength(1), reason: 'nothing was sent');
    expect(
      find.text(
        'The current reply has not stopped yet, so nothing was sent. Try '
        'again in a moment.',
      ),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await controller.close();
    await tester.pump();
  });

  testWidgets('P2 Classic: after a confirmed edit of turn 1 the archived '
      'turn 2 is gone; wire params dumped', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend(profile: 'field-work');
    addTearDown(backend.close);
    final client = _RecordingDesktopClient(backend.owner)..asyncEvents = true;
    // What the server holds after the rewind + new turn.
    client.onSubmit = () {
      _classicRows = () => [
        {'id': 11, 'role': 'user', 'content': 'Edited probe'},
        {
          'id': 12,
          'role': 'assistant',
          'content': 'Edited reply',
          'finish_reason': 'stop',
        },
      ];
      _rpcRows = () => [
        {'row_id': 11, 'role': 'user', 'text': 'Edited probe'},
        {'row_id': 12, 'role': 'assistant', 'text': 'Edited reply'},
      ];
    };
    final normal = NormalGatewayApplicationSession(
      connection: backend.connection,
      scope: 'probe-stale-classic',
      client: client,
      resume: ({required localSessionId, required storedSessionId}) async =>
          const ResumedGatewaySession(runtimeSessionId: _runtimeId),
      history: (_) async => _classicRows(),
    );
    final controller = _OwnerController(normal);
    addTearDown(controller.close);
    await normal.ready;
    await tester.pumpWidget(
      _classicApp(backend: backend, client: client, controller: controller),
    );
    await _settle(tester);
    await _openClassicEditFlow(tester);
    await tester.tap(find.byKey(const Key('restore-turn-confirm')));
    await _settle(tester, 60);
    final submit = client.submits.single;
    // The producer names the bubble's durable row; the transport turns it
    // into the owner's rewind (canonical_rewind_redirect_test).
    expect(submit['text'], 'Edited probe');
    expect(submit['extraParams'], {
      'confirm_truncate': true,
      'truncate_before_row_id': 7,
      'confirm_deep_truncate': true,
      'confirm_empty_truncate': true,
    });
    final staleQ = find.text('Another question', findRichText: true);
    final staleA = find.text('Another answer', findRichText: true);
    expect(staleQ, findsNothing);
    expect(staleA, findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await controller.close();
    await tester.pump();
  });

  testWidgets('P3 NextGen: after a confirmed edit of turn 1 the archived '
      'turn 2 is gone; wire params dumped', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend(profile: 'field-work');
    addTearDown(backend.close);
    var rows = _historyRowsNextGen();
    final httpClient = MockClient((req) async {
      if (req.url.path.contains('/messages')) {
        return http.Response(
          jsonEncode({'messages': rows}),
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
    await _openNextGenEditFlow(tester);
    await tester.tap(find.byKey(const Key('restore-turn-confirm')));
    await _settle(tester, 60);
    final submit = gateway.calls
        .where((c) => c.method == 'prompt.submit')
        .single
        .params;
    expect(submit['text'], 'Edited probe');
    expect(submit['truncate_before_row_id'], 7);
    expect(submit['confirm_deep_truncate'], isTrue);
    expect(submit.containsKey('truncate_before_user_ordinal'), isFalse);
    final staleQ = find.text('Another question');
    final staleA = find.text('Another answer');
    expect(staleQ, findsNothing);
    expect(staleA, findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('P4 Classic: after one completed turn, Edit of an older turn '
      'still asks before the deep cut', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend(profile: 'field-work');
    addTearDown(backend.close);
    final client = _RecordingDesktopClient(backend.owner)..asyncEvents = true;
    // The server persists the ordinary turn with durable ids.
    client.onSubmit = () {
      if (client.submits.length != 1) return;
      _classicRows = () => [
        ..._historyRows(),
        {'id': 11, 'role': 'user', 'content': 'Fresh prompt'},
        {
          'id': 12,
          'role': 'assistant',
          'content': 'Edited reply',
          'finish_reason': 'stop',
        },
      ];
      _rpcRows = () => [
        ..._historyRpcRowsBase(),
        {'row_id': 11, 'role': 'user', 'text': 'Fresh prompt'},
        {'row_id': 12, 'role': 'assistant', 'text': 'Edited reply'},
      ];
    };
    final normal = NormalGatewayApplicationSession(
      connection: backend.connection,
      scope: 'probe-after-turn-classic',
      client: client,
      resume: ({required localSessionId, required storedSessionId}) async =>
          const ResumedGatewaySession(runtimeSessionId: _runtimeId),
      history: (_) async => _classicRows(),
    );
    final controller = _OwnerController(normal);
    addTearDown(controller.close);
    await normal.ready;
    await tester.pumpWidget(
      _classicApp(backend: backend, client: client, controller: controller),
    );
    await _settle(tester);
    await tester.enterText(find.byType(TextField).last, 'Fresh prompt');
    await _settle(tester);
    await tester.tap(find.byTooltip('Send').hitTestable().first);
    await _settle(tester, 60);
    expect(client.submits, hasLength(1));

    await tester.longPress(find.text('Keep this', findRichText: true));
    await _settle(tester);
    await tester.tap(find.text('Edit and resend'));
    await _settle(tester);
    final dialogShown = find
        .byKey(const Key('edit-turn-field'))
        .evaluate()
        .isNotEmpty;
    if (dialogShown) {
      await _typeEditedProbe(tester);
      await tester.tap(find.byKey(const Key('edit-turn-send')));
      await _settle(tester, 80);
    }
    final confirm = find
        .byKey(const Key('restore-turn-confirm'))
        .evaluate()
        .isNotEmpty;
    if (confirm) {
      await tester.tap(find.byKey(const Key('restore-turn-cancel')));
      await _settle(tester);
    }
    expect(confirm, isTrue, reason: 'deep cut must ask first');
    expect(
      client.submits,
      hasLength(1),
      reason: 'nothing sent without confirm',
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await controller.close();
    await tester.pump();
  });
}
