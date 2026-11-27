// Every truncating producer, in BOTH layouts, on a 0.23+ session authority:
// the owner's rewind (a fenced `session.mutate`, Desktop's `session.rewind`)
// and then ONE plain `prompt.submit`; on the legacy sidecar the legacy keys.
//
// The layouts run on the REAL transport (WsClient, where the canonical
// redirect lives) over FakeAuthorityGateway, which enforces the gateway's
// contracts: a truncation key on `prompt.submit` is `4001 invalid_params`
// there, exactly what the review captured Ares sending
// (classic_edit_prompt_submit.json, nextgen_edit_prompt_submit.json).
//
//  Classic (ChatScreen): history Edit, history Restore, the bubble's
//    Regenerate. The failure card's Retry and switch-then-retry call the
//    same `_retryPrompt` and builder (`regenerateSubmitParams`) as
//    Regenerate; classic_failure_switch_retry_test covers their flows.
//  NextGen (NgChatView): history Edit, history Restore, composer Retry
//    (`retryLast`, the regenerate that switch-then-retry also runs).
//  The history page's Rewind (one widget for both layouts) is the fenced
//    mutation alone and submits nothing: session_history_authority_test.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/history/canonical_rewind.dart';
import 'package:hermes_android/core/models/projects_tree_overview.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/gateway_turn_coordinator.dart';
import 'package:hermes_android/core/services/normal_gateway_application_session.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_authority_gateway.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _localId = 'layout-classic';
const _profile = 'field-work';

/// The gateway's transcript as the REST history serves it.
List<Map<String, dynamic>> _restRows(FakeAuthorityGateway gateway) => [
  for (final row in gateway.rows)
    {
      'id': row['row_id'],
      'role': row['role'],
      'content': row['text'],
      'timestamp': 1000.0 + (row['row_id'] as int),
      if (row['role'] == 'assistant') 'finish_reason': 'stop',
    },
];

MockClient _rest(FakeAuthorityGateway gateway, {required String rowsKey}) =>
    MockClient((req) async {
      final path = req.url.path;
      if (path.endsWith('/messages')) {
        return http.Response(
          jsonEncode({rowsKey: _restRows(gateway)}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      if (path.endsWith('/mutation-snapshot')) {
        return http.Response(
          jsonEncode({
            'session_id': gateway.sessionId,
            'exists': true,
            'runtime_revision': gateway.revision,
            'runtime_generation': gateway.generation,
          }),
          200,
        );
      }
      if (path == '/api/sessions/${gateway.sessionId}') {
        return http.Response(
          jsonEncode({
            'id': gateway.sessionId,
            'profile': _profile,
            'cwd': '/srv/authority',
          }),
          200,
        );
      }
      if (path == '/api/sessions') {
        return http.Response(jsonEncode({'sessions': <Object>[]}), 200);
      }
      return http.Response(
        jsonEncode({
          'session': {'id': _localId, 'archived': false},
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

DashboardClient _dashboard(FakeAuthorityGateway gateway, String rowsKey) =>
    DashboardClient(
      host: 'authority.invalid',
      port: 443,
      useHttps: true,
      proxied: true,
      gatewayProfile: _profile,
      httpClient: _rest(gateway, rowsKey: rowsKey),
    );

SavedConnection _connection() => SavedConnection(
  id: 'authority-layouts',
  label: 'Authority fixture',
  host: 'authority.invalid',
  port: 443,
  useHttps: true,
  dashboardPortOverride: 443,
  desktopGatewayUrl: 'https://authority.invalid:443',
  gatewayProfile: _profile,
  singleLogin: true,
  signInMethod: 'none',
  apiKey: '',
  dashboardProxied: true,
);

RemoteWorkspaceOwner _owner(
  FakeAuthorityGateway gateway,
  WsClient socket,
  DashboardClient dashboard,
) => RemoteWorkspaceOwner(
  connectionId: 'authority-layouts',
  expectedBaseUrl: dashboard.baseUrl,
  profile: _profile,
  dashboard: dashboard,
  connect: () async => socket,
  ownsSocket: (candidate) => identical(candidate, socket),
);

/// The Classic chat's gateway client, as DesktopGatewayClient is to its
/// socket: a thin binding of the local session to the live one. Every
/// request goes out on the real [WsClient].
class _SocketDesktopClient implements DesktopGatewayClient {
  _SocketDesktopClient(this.gateway, this.socket, this.workspace);

  final FakeAuthorityGateway gateway;
  final WsClient socket;

  @override
  final RemoteWorkspaceOwner workspace;

  DesktopAsyncEventCallback? _sessionEvents;

  @override
  bool get sessionAuthority => socket.sessionAuthority;

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
    final reply = await socket.send(method, {
      ...params,
      'session_id': gateway.sessionId,
    });
    final error = reply['error'];
    if (error is Map) {
      throw JsonRpcError.fromGateway(method, error, fallbackMessage: method);
    }
    final result = reply['result'];
    return result is Map ? Map<String, dynamic>.from(result) : const {};
  }

  @override
  Future<bool> interruptPrompt({required String sessionId}) async {
    await socket.interruptSession(gateway.sessionId);
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
  }) => socket.submitPrompt(
    text,
    sessionId: gateway.sessionId,
    onEvent: (event) => _sessionEvents?.call(sessionId, event),
    onSent: onSent,
    onAccepted: onAccepted,
    submissionId: submissionId,
    beforeLegacy: beforeLegacy,
    extraParams: extraParams,
  );

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

/// NextGen's gateway on the real socket: `call` is the production body
/// (the live socket's `send`, the gateway's refusal as a [JsonRpcError]).
class _SocketNextGenGateway extends NextGenGateway {
  _SocketNextGenGateway(
    this._owner,
    this._socket,
    SavedConnection connection,
    DashboardClient dashboard,
  ) : super(connection, dashboard: dashboard) {
    _socket.onStreamEvent = debugEmit;
  }

  final RemoteWorkspaceOwner _owner;
  final WsClient _socket;

  @override
  RemoteWorkspaceOwner get workspace => _owner;

  @override
  WsClient? get socket => _socket;

  @override
  bool get sessionAuthority => _socket.sessionAuthority;

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
    final reply = await _socket.send(method, params, timeout: timeout);
    final error = reply['error'];
    if (error != null) {
      throw JsonRpcError.fromGateway(
        method,
        error is Map ? error : const {},
        fallbackMessage: method,
      );
    }
    final result = reply['result'];
    return result is Map
        ? Map<String, dynamic>.from(result)
        : <String, dynamic>{};
  }
}

Future<void> _settle(WidgetTester tester, [int rounds = 30]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  }
}

typedef _Classic = ({
  FakeAuthorityGateway gateway,
  _OwnerController controller,
});

Future<_Classic> _pumpClassic(
  WidgetTester tester, {
  required bool authority,
}) async {
  await tester.binding.setSurfaceSize(const Size(800, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final gateway = FakeAuthorityGateway(authority: authority);
  final socket = await gateway.connect();
  final dashboard = _dashboard(gateway, 'data');
  final owner = _owner(gateway, socket, dashboard);
  addTearDown(owner.close);
  final client = _SocketDesktopClient(gateway, socket, owner);
  final connection = _connection();
  final normal = NormalGatewayApplicationSession(
    connection: connection,
    scope: 'layout-classic-${authority ? 'authority' : 'legacy'}',
    client: client,
    resume: ({required localSessionId, required storedSessionId}) async =>
        ResumedGatewaySession(runtimeSessionId: gateway.sessionId),
    history: (_) async => _restRows(gateway),
  );
  final controller = _OwnerController(normal);
  await normal.ready;
  await tester.pumpWidget(
    MaterialApp(
      theme: hermesTheme(Brightness.light),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChatScreen(
        connection: connection,
        session: const Session(
          id: _localId,
          title: 'Layout probe',
          model: 'fixture',
          source: 'desktop',
          messageCount: 4,
          isActive: true,
          preview: '',
          startedAt: 1,
          isLocalDraft: false,
        ),
        turnApplicationController: controller,
        testProjectOverviewLoader: () async => ProjectsTreeOverview.empty,
        testApiClient: ApiClient(
          baseUrl: dashboard.baseUrl,
          apiKey: '',
          httpClient: _rest(gateway, rowsKey: 'data'),
        ),
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
      ),
    ),
  );
  await _settle(tester);
  return (gateway: gateway, controller: controller);
}

Future<void> _closeClassic(WidgetTester tester, _Classic classic) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await classic.controller.close();
  await tester.pump();
}

typedef _NextGen = ({FakeAuthorityGateway gateway, NgChatController chat});

Future<_NextGen> _pumpNextGen(
  WidgetTester tester, {
  required bool authority,
}) async {
  await tester.binding.setSurfaceSize(const Size(800, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final gateway = FakeAuthorityGateway(authority: authority);
  final socket = await gateway.connect(attach: false);
  // NextGen attaches with its own raw `session.resume`.
  final dashboard = _dashboard(gateway, 'messages');
  final owner = _owner(gateway, socket, dashboard);
  final ng = _SocketNextGenGateway(owner, socket, _connection(), dashboard);
  await ng.call('session.resume', {'session_id': gateway.sessionId});
  final chat = NgChatController(ng, sessionId: gateway.sessionId)
    ..runtimeId = gateway.sessionId;
  final connManager = ConnectionManager(await SharedPreferences.getInstance());
  addTearDown(() {
    chat.dispose();
    ng.dispose();
    owner.close();
  });
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
      home: NgScope(
        connManager: connManager,
        gateway: ng,
        connections: [ng.connection],
        switchTo: (_) async {},
        addGateway: () async {},
        signOut: (_) async {},
        reload: () async {},
        signInAgain: () async {},
        child: NgChatView(chat: chat, onOpenSidebar: () {}, onNewChat: () {}),
      ),
    ),
  );
  await chat.open();
  await _settle(tester);
  return (gateway: gateway, chat: chat);
}

/// The canonical sequence: the fenced rewind at [row], then one plain
/// submit, nothing refused, and no method the gateway does not have.
void _expectRewindThenSubmit(
  FakeAuthorityGateway gateway, {
  required int row,
  required String text,
}) {
  const cutAndSend = {'session.mutate', 'prompt.submit', 'session.rewind'};
  expect(
    gateway.refusals.where((refusal) => cutAndSend.contains(refusal.method)),
    isEmpty,
    reason: 'the owner refused neither the cut nor the prompt',
  );
  expect(gateway.calls('session.rewind'), isEmpty);
  expect(gateway.methods.where(cutAndSend.contains), [
    'session.mutate',
    'prompt.submit',
  ]);
  final cut = gateway.calls('session.mutate').single.params;
  expect(cut['operation'], 'rewind');
  expect(cut['payload'], {'target_message_id': row});
  expect(cut['expected_revision'], isA<int>());
  expect(cut['expected_generation'], isA<int>());
  final submit = gateway.calls('prompt.submit').single.params;
  for (final key in truncateKeys) {
    expect(submit.containsKey(key), isFalse, reason: key);
  }
  expect(submit.keys.toSet().difference(canonicalSubmitKeys), isEmpty);
  expect(submit['text'], startsWith(text));
}

/// The legacy sequence: one submit that carries the truncation keys.
void _expectLegacyTruncatingSubmit(
  FakeAuthorityGateway gateway, {
  required int row,
  required bool deep,
}) {
  expect(gateway.calls('session.mutate'), isEmpty);
  final accepted = gateway.calls('prompt.submit').last.params;
  expect(accepted['confirm_truncate'], isTrue);
  expect(accepted['truncate_before_row_id'], row);
  expect(accepted['confirm_empty_truncate'], isTrue);
  expect(accepted['confirm_deep_truncate'], deep ? isTrue : isNull);
  expect(accepted.containsKey('truncate_before_user_ordinal'), isFalse);
}

Future<void> _classicEdit(WidgetTester tester, String turn) async {
  await tester.longPress(find.text(turn, findRichText: true));
  await _settle(tester);
  await tester.tap(find.text('Edit and resend'));
  await _settle(tester);
  await tester.enterText(
    find.byKey(const Key('edit-turn-field')),
    'Edited probe',
  );
  await _settle(tester);
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

  group('Classic on a session authority', () {
    testWidgets('history Edit of an older turn: confirm, rewind, one plain '
        'submit, and the archived turn leaves the transcript', (tester) async {
      final classic = await _pumpClassic(tester, authority: true);
      await _classicEdit(tester, 'Keep this');
      expect(
        classic.gateway.calls('prompt.submit'),
        isEmpty,
        reason: 'the deep cut asks first',
      );
      expect(
        find.text(
          'This will archive later turns from the conversation. '
          'Continue?',
        ),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('restore-turn-confirm')));
      await _settle(tester, 80);

      _expectRewindThenSubmit(classic.gateway, row: 7, text: 'Edited probe');
      expect(
        [for (final row in classic.gateway.rows) row['text']],
        ['Edited probe', 'Fresh reply'],
      );
      expect(find.text('Another question', findRichText: true), findsNothing);
      expect(find.text('Another answer', findRichText: true), findsNothing);
      await _closeClassic(tester, classic);
    });

    testWidgets('history Restore of the newest turn: confirm, rewind, one '
        'plain submit', (tester) async {
      final classic = await _pumpClassic(tester, authority: true);
      await tester.longPress(find.text('Another question', findRichText: true));
      await _settle(tester);
      await tester.tap(find.text('Restore & rerun'));
      await _settle(tester);
      await tester.tap(find.byKey(const Key('restore-turn-confirm')));
      await _settle(tester, 80);

      _expectRewindThenSubmit(
        classic.gateway,
        row: 9,
        text: 'Another question',
      );
      expect(
        [for (final row in classic.gateway.rows) row['text']],
        ['Keep this', 'Noted', 'Another question', 'Fresh reply'],
      );
      await _closeClassic(tester, classic);
    });

    testWidgets('the bubble\'s Regenerate (the Retry and switch-then-retry '
        'producer): rewind, one plain submit', (tester) async {
      final classic = await _pumpClassic(tester, authority: true);
      await tester.longPress(find.text('Another answer', findRichText: true));
      await _settle(tester);
      await tester.tap(find.text('Regenerate response'));
      await _settle(tester, 80);

      _expectRewindThenSubmit(
        classic.gateway,
        row: 9,
        text: 'Another question',
      );
      expect(
        [for (final row in classic.gateway.rows) row['text']],
        ['Keep this', 'Noted', 'Another question', 'Fresh reply'],
      );
      await _closeClassic(tester, classic);
    });
  });

  group('Classic on the legacy sidecar', () {
    testWidgets('history Edit still sends the legacy truncation keys in one '
        'prompt.submit', (tester) async {
      final classic = await _pumpClassic(tester, authority: false);
      await _classicEdit(tester, 'Keep this');
      await tester.tap(find.byKey(const Key('restore-turn-confirm')));
      await _settle(tester, 80);

      _expectLegacyTruncatingSubmit(classic.gateway, row: 7, deep: true);
      expect(
        [for (final row in classic.gateway.rows) row['text']],
        ['Edited probe', 'Fresh reply'],
      );
      await _closeClassic(tester, classic);
    });

    testWidgets('Regenerate still sends the legacy truncation keys', (
      tester,
    ) async {
      final classic = await _pumpClassic(tester, authority: false);
      await tester.longPress(find.text('Another answer', findRichText: true));
      await _settle(tester);
      await tester.tap(find.text('Regenerate response'));
      await _settle(tester, 80);

      _expectLegacyTruncatingSubmit(classic.gateway, row: 9, deep: false);
      await _closeClassic(tester, classic);
    });
  });

  group('NextGen on a session authority', () {
    testWidgets('history Edit of an older turn: confirm, rewind, one plain '
        'submit, and the archived turn leaves the transcript', (tester) async {
      final ng = await _pumpNextGen(tester, authority: true);
      // The list is reversed: the oldest turn's button is the last one.
      await tester.tap(find.byKey(const Key('ng-user-edit')).last);
      await _settle(tester);
      await tester.enterText(
        find.byKey(const Key('edit-turn-field')),
        'Edited probe',
      );
      await _settle(tester);
      await tester.tap(find.byKey(const Key('edit-turn-send')));
      await _settle(tester);
      expect(ng.gateway.calls('prompt.submit'), isEmpty);
      await tester.tap(find.byKey(const Key('restore-turn-confirm')));
      await _settle(tester, 80);

      _expectRewindThenSubmit(ng.gateway, row: 7, text: 'Edited probe');
      expect(find.text('Another question'), findsNothing);
      expect(find.text('Another answer'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('history Restore of the newest turn: confirm, rewind, one '
        'plain submit', (tester) async {
      final ng = await _pumpNextGen(tester, authority: true);
      await tester.tap(find.byKey(const Key('ng-user-restore')).first);
      await _settle(tester);
      await tester.tap(find.byKey(const Key('restore-turn-confirm')));
      await _settle(tester, 80);

      _expectRewindThenSubmit(ng.gateway, row: 9, text: 'Another question');
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('Edit and resend and Restore & rerun sit to the left of the '
        'time on one line, not underneath it', (tester) async {
      await _pumpNextGen(tester, authority: true);
      // The list is reversed: the newest user turn's footer is the first.
      final footer = find.byKey(const ValueKey('ng-user-footer')).first;
      Finder inFooter(Key key) =>
          find.descendant(of: footer, matching: find.byKey(key));
      final time = tester.getRect(inFooter(const ValueKey('ng-user-time')));
      final edit = tester.getRect(inFooter(const Key('ng-user-edit')));
      final restore = tester.getRect(inFooter(const Key('ng-user-restore')));
      expect(edit.right, lessThanOrEqualTo(restore.left));
      expect(restore.right, lessThanOrEqualTo(time.left));
      for (final button in [edit, restore]) {
        expect(button.center.dy, moreOrLessEquals(time.center.dy, epsilon: 1));
      }
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('the footer wraps on a narrow phone at 2x text without '
        'overflowing, and the time stays last', (tester) async {
      await _pumpNextGen(tester, authority: true);
      await tester.binding.setSurfaceSize(const Size(320, 1400));
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await _settle(tester);
      expect(tester.takeException(), isNull);
      final footer = find.byKey(const ValueKey('ng-user-footer')).first;
      Finder inFooter(Key key) =>
          find.descendant(of: footer, matching: find.byKey(key));
      final time = tester.getRect(inFooter(const ValueKey('ng-user-time')));
      final restore = tester.getRect(inFooter(const Key('ng-user-restore')));
      expect(
        time.top > restore.top || time.left >= restore.right,
        isTrue,
        reason: 'the time is after the actions: same line or the next one',
      );
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('composer Retry (retryLast, the regenerate that '
        'switch-then-retry runs): rewind, one plain submit', (tester) async {
      final ng = await _pumpNextGen(tester, authority: true);
      final result = await tester.runAsync(ng.chat.retryLast);
      await _settle(tester, 80);

      expect(result, NgRetryResult.regenerated);
      _expectRewindThenSubmit(ng.gateway, row: 9, text: 'Another question');
      expect(
        [for (final row in ng.gateway.rows) row['text']],
        ['Keep this', 'Noted', 'Another question', 'Fresh reply'],
      );
      await tester.pumpWidget(const SizedBox.shrink());
    });
  });

  group('NextGen on the legacy sidecar', () {
    testWidgets('history Edit still sends the legacy truncation keys in one '
        'prompt.submit', (tester) async {
      final ng = await _pumpNextGen(tester, authority: false);
      await tester.tap(find.byKey(const Key('ng-user-edit')).last);
      await _settle(tester);
      await tester.enterText(
        find.byKey(const Key('edit-turn-field')),
        'Edited probe',
      );
      await _settle(tester);
      await tester.tap(find.byKey(const Key('edit-turn-send')));
      await _settle(tester);
      await tester.tap(find.byKey(const Key('restore-turn-confirm')));
      await _settle(tester, 80);

      _expectLegacyTruncatingSubmit(ng.gateway, row: 7, deep: true);
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('composer Retry still sends the legacy truncation keys', (
      tester,
    ) async {
      final ng = await _pumpNextGen(tester, authority: false);
      final result = await tester.runAsync(ng.chat.retryLast);
      await _settle(tester, 80);

      expect(result, NgRetryResult.regenerated);
      _expectLegacyTruncatingSubmit(ng.gateway, row: 9, deep: false);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  });

  testWidgets('NextGen wide app bar: Session history has its own icon, not '
      'the tree Session files uses', (tester) async {
    await _pumpNextGen(tester, authority: true);
    final history = tester.widget<IconButton>(
      find.byKey(const ValueKey('session-history')),
    );
    final icon = (history.icon as Icon).icon;
    expect(icon, Icons.manage_history);
    expect(icon, isNot(Icons.account_tree_outlined));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  const unsaved =
      'This message is not saved yet. Wait for it to settle, then edit it '
      'again.';

  testWidgets('Classic: a turn the saved transcript does not hold yet is '
      'refused with the localised notice; nothing reaches the wire', (
    tester,
  ) async {
    final classic = await _pumpClassic(tester, authority: true);
    // The gateway's transcript no longer holds the turn on screen.
    classic.gateway.rows
      ..clear()
      ..add({'row_id': 40, 'role': 'user', 'text': 'Something else'});
    await _classicEdit(tester, 'Keep this');
    await _settle(tester, 40);

    expect(find.text(unsaved), findsOneWidget);
    expect(classic.gateway.calls('session.mutate'), isEmpty);
    expect(classic.gateway.calls('prompt.submit'), isEmpty);
    await _closeClassic(tester, classic);
  });

  testWidgets('NextGen: a turn the saved transcript does not hold yet is '
      'refused with the localised notice; nothing reaches the wire', (
    tester,
  ) async {
    final ng = await _pumpNextGen(tester, authority: true);
    ng.gateway.rows
      ..clear()
      ..add({'row_id': 40, 'role': 'user', 'text': 'Something else'});
    await tester.tap(find.byKey(const Key('ng-user-edit')).last);
    await _settle(tester);
    await tester.enterText(
      find.byKey(const Key('edit-turn-field')),
      'Edited probe',
    );
    await _settle(tester);
    await tester.tap(find.byKey(const Key('edit-turn-send')));
    await _settle(tester, 40);

    expect(find.text(unsaved), findsOneWidget);
    expect(ng.gateway.calls('session.mutate'), isEmpty);
    expect(ng.gateway.calls('prompt.submit'), isEmpty);
    // The view's own toast timer.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
