// The manage_catalog install card (connection.request / connection.update /
// connection.respond) in Classic and NextGen, plus the wire: answers are
// owned by the chat's runtime session, frames only move forward, and a
// settled failed plugin is tried again through the capabilities install
// into the row's own target profile.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/render/catalog_install.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/services/ws_client.dart';
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

import 'support/fake_voice_composer_adapter.dart';
import 'support/inert_turn_application_session.dart';
import 'support/pump_chat_updates.dart';

Map<String, dynamic> _blender({
  String state = 'pending',
  String? detail,
  bool? enabled,
  String? phase,
  bool? resolved,
  List<String>? tools,
}) => {
  'name': 'blender',
  'kind': 'plugin',
  'action': 'install',
  'state': state,
  'display': 'Blender',
  'description': 'Model and render scenes from chat.',
  'tier': 'official',
  'platforms': ['darwin', 'linux'],
  'repo': 'NousResearch/hermes-blender',
  'sha': '0123456789abcdef',
  'scan': {'status': 'passed', 'summary': 'No findings'},
  'target_profile': 'work',
  'detail': ?detail,
  'enabled': ?enabled,
  'phase': ?phase,
  'resolved': ?resolved,
  'tools': ?tools,
};

Map<String, dynamic> _pdf({String state = 'pending', bool? resolved}) => {
  'name': 'pdf-tools',
  'kind': 'skill',
  'action': 'install',
  'state': state,
  'resolved': ?resolved,
  'display': 'PDF tools',
  'tier': 'community',
  'target_profile': 'work',
};

Map<String, dynamic> _frame(
  int seq,
  List<Map<String, dynamic>> targets, {
  String opId = 'op-1',
  bool settled = false,
}) => {
  'op_id': opId,
  'seq': seq,
  'deadline_at': 0,
  'timeout_seconds': 600,
  'tool_call_id': 'call-1',
  'targets': targets,
  if (settled) 'settled': true,
};

SavedConnection _ngConnection(String id, {String? profile}) => SavedConnection(
  id: id,
  label: 'Home $id',
  host: '10.0.0.5',
  port: 9119,
  apiKey: 'k',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
  gatewayProfile: profile,
);

/// Records gateway calls; answers connection.respond and plugins.manage.
class _Gateway extends NextGenGateway {
  _Gateway(String id, {String? profile})
    : super(_ngConnection(id, profile: profile));

  final calls = <(String, Map<String, dynamic>)>[];
  Map<String, dynamic> install = {'ok': true};

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    calls.add((method, params));
    return switch (method) {
      'connection.respond' => {'status': 'ok', 'settled': false},
      'plugins.manage' => install,
      _ => <String, dynamic>{},
    };
  }

  void frame(String runtime, String type, Map<String, dynamic> payload) =>
      debugEmit(StreamEvent(type: type, data: payload, sessionId: runtime));
}

Future<void> _pumpNg(
  WidgetTester tester,
  NextGenGateway gateway,
  NgChatController chat,
) async {
  final prefs = await SharedPreferences.getInstance();
  await tester.binding.setSurfaceSize(const Size(900, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: nextGenTheme(Brightness.light, NextGenLook.instance),
      home: NgScope(
        connManager: ConnectionManager(prefs),
        gateway: gateway,
        connections: [gateway.connection],
        switchTo: (_) async {},
        addGateway: () async {},
        signOut: (_) async {},
        reload: () async {},
        signInAgain: () async {},
        child: Scaffold(
          body: NgChatView(
            key: ObjectKey(chat),
            chat: chat,
            onOpenSidebar: () {},
            onNewChat: () {},
          ),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

NgChatController _ngChat(NextGenGateway gateway, String id) {
  final chat = NgChatController(gateway, sessionId: id)..runtimeId = 'rt-$id';
  chat.debugApplyHistory([
    {'role': 'user', 'content': 'install blender'},
  ]);
  addTearDown(chat.dispose);
  return chat;
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await tester.ensureVisible(finder);
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump();
}

/// A Classic recovery session that routes events by local chat id and
/// records connection answers for chats it owns.
class _Session extends InertTurnApplicationSession
    implements GatewaySetupBeatResponder {
  final listeners = <String, DesktopAsyncEventCallback>{};
  final owned = <String>{};
  final answers = <String>[];

  @override
  Object setAsyncEventListener(
    String localSessionId,
    DesktopAsyncEventCallback listener,
  ) {
    listeners[localSessionId] = listener;
    return Object();
  }

  void frame(String chat, String type, Map<String, dynamic> payload) {
    owned.add(chat);
    listeners[chat]?.call(chat, StreamEvent(type: type, data: payload));
  }

  @override
  Future<bool> tryRespondToConnection({
    required String sessionId,
    required String opId,
    required Map<String, dynamic> result,
  }) async {
    if (!owned.contains(sessionId)) return false;
    answers.add('$sessionId|$opId|${jsonEncode(result)}');
    return true;
  }

  @override
  bool tryRespondToSetupBeat({
    required String sessionId,
    required String requestId,
    required Map<String, dynamic> result,
  }) => false;

  @override
  bool holdsSetupBeat({required String sessionId, required String requestId}) =>
      false;
}

Widget _classic(String connectionId, String chatId, _Session session) =>
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChatScreen(
        key: ValueKey('$connectionId/$chatId'),
        connection: SavedConnection(
          id: connectionId,
          label: 'Fixture $connectionId',
          host: 'fixture.invalid',
          port: 8000,
          apiKey: 'fixture-key',
          desktopGatewayUrl: 'http://127.0.0.1:9',
        ),
        session: Session(
          id: chatId,
          title: 'Chat $chatId',
          model: 'fixture',
          source: 'test',
          messageCount: 0,
          isActive: true,
          preview: '',
          startedAt: 1,
        ),
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
        testDesktopAsyncEventHook: TestDesktopAsyncEventHook(),
        testTurnApplicationSession: session,
        testApiClient: ApiClient(
          baseUrl: 'https://fixture.invalid',
          apiKey: 'fixture-key',
          httpClient: MockClient(
            (_) async => http.Response(jsonEncode({'data': []}), 200),
          ),
        ),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(mockChatImageRecovery);
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
  });

  group('model', () {
    test('only catalog rows open a card; frames only move forward', () {
      expect(
        CatalogOperation.parse({
          'op_id': 'op-c',
          'seq': 1,
          'targets': [
            {'name': 'github', 'kind': 'connector', 'state': 'pending'},
          ],
        }),
        isNull,
      );
      final first = CatalogOperation.merge(
        null,
        _frame(2, [_blender()]),
        opens: true,
      )!;
      expect(first.rows.single.title, 'Blender');
      expect(first.rows.single.targetProfile, 'work');
      final stale = CatalogOperation.merge(
        first,
        _frame(1, [_blender(state: 'failed')]),
        opens: false,
      );
      expect(identical(stale, first), isTrue);
      expect(
        CatalogOperation.merge(null, _frame(3, [_blender()]), opens: false),
        isNull,
        reason: 'an update for an operation never seen opens nothing',
      );
      expect(CatalogOperation.answer(first.rows.single, approve: true), {
        'targets': [
          {'name': 'blender', 'status': 'approved'},
        ],
      });
    });
  });

  group('NextGen', () {
    testWidgets('the card shows the host rows and answers for its chat', (
      tester,
    ) async {
      final gateway = _Gateway('c1');
      addTearDown(gateway.dispose);
      final a = _ngChat(gateway, 'chat-a');
      final b = _ngChat(gateway, 'chat-b');
      await _pumpNg(tester, gateway, b);
      gateway.frame(
        'rt-chat-a',
        'connection.request',
        _frame(1, [_blender(), _pdf()]),
      );
      await tester.pump();
      expect(find.text('Blender'), findsNothing, reason: 'chat B');
      expect(b.catalog, isNull);

      await _pumpNg(tester, gateway, a);
      expect(find.text('Blender'), findsOneWidget);
      expect(find.text('Model and render scenes from chat.'), findsOneWidget);
      expect(find.text('Official'), findsOneWidget);
      expect(find.text('Plugin'), findsOneWidget);
      expect(find.text('Skill'), findsOneWidget);
      expect(find.text('Security scan: passed. No findings'), findsOneWidget);
      expect(
        find.text('NousResearch/hermes-blender at 0123456'),
        findsOneWidget,
      );
      expect(find.text('Installs into the work profile'), findsOneWidget);

      await _tapKey(tester, 'catalog-install-blender');
      expect(gateway.calls.single.$1, 'connection.respond');
      expect(gateway.calls.single.$2, {
        'owner': {'type': 'session', 'session_id': 'rt-chat-a'},
        'op_id': 'op-1',
        'result': {
          'targets': [
            {'name': 'blender', 'status': 'approved'},
          ],
        },
      });
      // Held until the next frame: a second tap does not answer twice.
      final install = tester.widget<FilledButton>(
        find.byKey(const Key('catalog-install-blender')),
      );
      expect(install.onPressed, isNull);

      gateway.frame('rt-chat-a', 'connection.update', {
        ..._frame(2, [
          _blender(
            state: 'connected',
            detail: 'Installed blender 1.2 in work.',
            enabled: true,
          ),
          _pdf(),
        ]),
        'owner': {'type': 'session', 'session_id': 'rt-chat-a'},
      });
      await tester.pump();
      expect(
        tester
            .widget<Text>(find.byKey(const Key('catalog-state-blender')))
            .data,
        'Installed',
      );
      expect(find.text('Installed blender 1.2 in work.'), findsOneWidget);

      await _tapKey(tester, 'catalog-skip-pdf-tools');
      expect(gateway.calls.last.$2['result'], {
        'targets': [
          {'name': 'pdf-tools', 'status': 'skipped'},
        ],
      });
      // An older frame moves nothing.
      gateway.frame(
        'rt-chat-a',
        'connection.update',
        _frame(1, [_blender(state: 'failed'), _pdf()]),
      );
      await tester.pump();
      expect(
        tester
            .widget<Text>(find.byKey(const Key('catalog-state-blender')))
            .data,
        'Installed',
      );
      gateway.frame(
        'rt-chat-a',
        'connection.update',
        _frame(3, [
          _blender(state: 'connected', enabled: true),
          _pdf(state: 'skipped'),
        ], settled: true),
      );
      await tester.pump();
      expect(
        tester
            .widget<Text>(find.byKey(const Key('catalog-state-pdf-tools')))
            .data,
        'Skipped',
      );
      expect(find.byKey(const Key('catalog-install-pdf-tools')), findsNothing);
      await _tapKey(tester, 'catalog-dismiss');
      expect(find.text('Blender'), findsNothing);
      expect(b.catalog, isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('another connection with the same chat ids sees no card', (
      tester,
    ) async {
      final first = _Gateway('c1');
      final second = _Gateway('c2');
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      final onFirst = _ngChat(first, 'chat-a');
      final onSecond = _ngChat(second, 'chat-a');
      first.frame('rt-chat-a', 'connection.request', _frame(1, [_blender()]));
      await _pumpNg(tester, second, onSecond);
      expect(find.text('Blender'), findsNothing);
      expect(onSecond.catalog, isNull);
      expect(
        await onSecond.respondCatalog(onFirst.catalog!, const {}),
        isFalse,
      );
      expect(second.calls, isEmpty);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('a settled failed plugin is tried again by catalog name', (
      tester,
    ) async {
      final gateway = _Gateway('c1');
      addTearDown(gateway.dispose);
      final chat = _ngChat(gateway, 'chat-a');
      await _pumpNg(tester, gateway, chat);
      gateway.frame(
        'rt-chat-a',
        'connection.request',
        _frame(5, [
          _blender(state: 'failed', detail: 'Clone timed out.'),
        ], settled: true),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text('Clone timed out.'), findsOneWidget);
      expect(find.byKey(const Key('catalog-install-blender')), findsNothing);
      await _tapKey(tester, 'catalog-retry-button-blender');
      await tester.pump();
      final (method, params) = gateway.calls.single;
      expect(method, 'plugins.manage');
      expect(params['catalog_name'], 'blender');
      expect(params['profile'], 'work');
      expect(params['action'], 'install');
      expect(
        tester
            .widget<Text>(find.byKey(const Key('catalog-state-blender')))
            .data,
        'Installed',
      );
      // The settled operation is not answered again.
      expect(
        gateway.calls.where((call) => call.$1 == 'connection.respond'),
        isEmpty,
      );
      await tester.pumpWidget(const SizedBox());
    });

    // Desktop's retrySettled installs through the owner of the request's
    // session (connectionOwnerFor), not the active connection: a chat on
    // another connection than the selected one installs on its own.
    testWidgets('Try again installs through the chat connection, not the '
        'active one', (tester) async {
      final active = _Gateway('active', profile: 'active-profile');
      final own = _Gateway('own', profile: 'chat-profile');
      addTearDown(active.dispose);
      addTearDown(own.dispose);
      final chat = _ngChat(own, 'chat-a');
      await _pumpNg(tester, active, chat);
      // No target profile on the row: the install goes to the chat's own
      // profile.
      final row = _blender(state: 'failed', detail: 'Clone timed out.')
        ..remove('target_profile');
      own.frame(
        'rt-chat-a',
        'connection.request',
        _frame(5, [row], settled: true),
      );
      await tester.pump();
      await tester.pump();
      await _tapKey(tester, 'catalog-retry-button-blender');
      await tester.pump();
      expect(active.calls, isEmpty, reason: 'the active connection');
      final (method, params) = own.calls.single;
      expect(method, 'plugins.manage');
      expect(params['catalog_name'], 'blender');
      expect(params['profile'], 'chat-profile');
      expect(
        tester
            .widget<Text>(find.byKey(const Key('catalog-state-blender')))
            .data,
        'Installed',
      );
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('Classic', () {
    Future<void> show(WidgetTester tester, Widget app) async {
      await tester.binding.setSurfaceSize(const Size(900, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(app);
      await pumpChatUpdates(tester);
    }

    testWidgets('the card answers through the chat that owns it', (
      tester,
    ) async {
      final session = _Session();
      await show(tester, _classic('cx', 'chat-b', session));
      session.frame('chat-a', 'connection.request', _frame(1, [_blender()]));
      await tester.pump();
      expect(find.text('Blender'), findsNothing);

      await show(tester, _classic('cx', 'chat-a', session));
      session.frame('chat-a', 'connection.request', _frame(1, [_blender()]));
      await tester.pump();
      expect(find.text('Blender'), findsOneWidget);
      expect(find.text('Installs into the work profile'), findsOneWidget);
      await _tapKey(tester, 'catalog-install-blender');
      await tester.pump();
      expect(session.answers, [
        'chat-a|op-1|{"targets":[{"name":"blender","status":"approved"}]}',
      ]);
      session.frame('chat-a', 'connection.update', {
        ..._frame(2, [
          _blender(state: 'connected', detail: 'Installed.', enabled: false),
        ], settled: true),
        'owner': {'type': 'session', 'session_id': 'runtime-a'},
      });
      await tester.pump();
      expect(
        tester
            .widget<Text>(find.byKey(const Key('catalog-state-blender')))
            .data,
        'Installed, not turned on',
      );
    });

    testWidgets('another connection with the same chat id sees no card', (
      tester,
    ) async {
      final onX = _Session();
      final onY = _Session();
      await show(tester, _classic('cy', 'chat-a', onY));
      onX.frame('chat-a', 'connection.request', _frame(1, [_blender()]));
      await tester.pump();
      expect(find.text('Blender'), findsNothing);
      expect(onY.answers, isEmpty);
    });
  });

  // Desktop's CatalogInstallCard offers Continue while any row is unresolved
  // and the operation open (continueConnectionRequest sends
  // {settled_by: continue}, catalog.py apply_answer settles it), and an
  // installed row words how many tools went live.
  group('Continue and tool count', () {
    testWidgets('NextGen', (tester) async {
      final gateway = _Gateway('c1');
      addTearDown(gateway.dispose);
      final chat = _ngChat(gateway, 'chat-a');
      await _pumpNg(tester, gateway, chat);
      gateway.frame(
        'rt-chat-a',
        'connection.request',
        _frame(1, [_blender(), _pdf()]),
      );
      await tester.pump();
      await tester.pump();
      await _tapKey(tester, 'catalog-continue');
      expect(gateway.calls.single.$1, 'connection.respond');
      expect(gateway.calls.single.$2['result'], {'settled_by': 'continue'});
      // Held until the host's next frame.
      expect(
        tester
            .widget<TextButton>(find.byKey(const Key('catalog-continue')))
            .onPressed,
        isNull,
      );

      gateway.frame(
        'rt-chat-a',
        'connection.update',
        _frame(2, [
          _blender(
            state: 'connected',
            enabled: true,
            resolved: true,
            tools: ['render', 'export', 'import'],
          ),
          _pdf(state: 'skipped', resolved: true),
        ]),
      );
      await tester.pump();
      expect(find.byKey(const Key('catalog-continue')), findsNothing);
      expect(
        tester
            .widget<Text>(find.byKey(const Key('catalog-tools-blender')))
            .data,
        '3 tools',
      );
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Classic', (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final session = _Session();
      await tester.pumpWidget(_classic('cx', 'chat-a', session));
      await pumpChatUpdates(tester);
      session.frame(
        'chat-a',
        'connection.request',
        _frame(1, [
          _blender(
            state: 'connected',
            enabled: true,
            resolved: true,
            tools: ['render'],
          ),
          _pdf(),
        ]),
      );
      await tester.pump();
      expect(
        tester
            .widget<Text>(find.byKey(const Key('catalog-tools-blender')))
            .data,
        '1 tool',
      );
      await _tapKey(tester, 'catalog-continue');
      await tester.pump();
      expect(session.answers, ['chat-a|op-1|{"settled_by":"continue"}']);
      session.frame(
        'chat-a',
        'connection.update',
        _frame(2, [
          _blender(state: 'connected', enabled: true, resolved: true),
          _pdf(resolved: false),
        ], settled: true),
      );
      await tester.pump();
      expect(find.byKey(const Key('catalog-continue')), findsNothing);
    });
  });

  // While the host installs a row (state `initiated`, contract.py:62), the
  // card shows Installing… with progress and offers neither Install nor
  // Skip: the host accepts initiated -> skipped from the user and then drops
  // the finished install (catalog.py:289), as Desktop's
  // catalog-install-tool.tsx guards at its `initiated || sending` branch.
  group('initiated', () {
    String stateText(WidgetTester tester) => tester
        .widget<Text>(find.byKey(const Key('catalog-state-blender')))
        .data!;

    void expectInstalling(WidgetTester tester, String phase) {
      expect(stateText(tester), 'Installing…');
      expect(find.byKey(const Key('catalog-progress-blender')), findsOneWidget);
      expect(
        tester
            .widget<Text>(find.byKey(const Key('catalog-phase-blender')))
            .data,
        phase,
      );
      expect(find.byKey(const Key('catalog-install-blender')), findsNothing);
      expect(find.byKey(const Key('catalog-skip-blender')), findsNothing);
      expect(
        find.byKey(const Key('catalog-retry-button-blender')),
        findsNothing,
      );
    }

    void expectInstalled(WidgetTester tester) {
      expect(stateText(tester), 'Installed');
      expect(find.byKey(const Key('catalog-progress-blender')), findsNothing);
      expect(find.byKey(const Key('catalog-install-blender')), findsNothing);
      expect(find.byKey(const Key('catalog-skip-blender')), findsNothing);
    }

    testWidgets('NextGen: pending, then initiated, then connected', (
      tester,
    ) async {
      final gateway = _Gateway('c1');
      addTearDown(gateway.dispose);
      final chat = _ngChat(gateway, 'chat-a');
      await _pumpNg(tester, gateway, chat);
      gateway.frame('rt-chat-a', 'connection.request', _frame(1, [_blender()]));
      await tester.pump();
      await tester.pump();
      expect(stateText(tester), 'Waiting for your choice');
      await _tapKey(tester, 'catalog-install-blender');
      expect(gateway.calls.single.$2['result'], {
        'targets': [
          {'name': 'blender', 'status': 'approved'},
        ],
      });

      gateway.frame(
        'rt-chat-a',
        'connection.update',
        _frame(2, [_blender(state: 'initiated', phase: 'downloading')]),
      );
      await tester.pump();
      expectInstalling(tester, 'Downloading…');
      gateway.frame(
        'rt-chat-a',
        'connection.update',
        _frame(3, [_blender(state: 'initiated', phase: 'python_packages')]),
      );
      await tester.pump();
      expectInstalling(tester, 'Installing Python packages…');
      gateway.frame(
        'rt-chat-a',
        'connection.update',
        _frame(4, [_blender(state: 'initiated', phase: 'loading_tools')]),
      );
      await tester.pump();
      expectInstalling(tester, 'Loading its tools…');

      gateway.frame(
        'rt-chat-a',
        'connection.update',
        _frame(5, [_blender(state: 'connected', enabled: true)]),
      );
      await tester.pump();
      expectInstalled(tester);
      // Only the approval was ever sent: nothing could skip the install.
      expect(gateway.calls.map((call) => call.$1), ['connection.respond']);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Classic: pending, then initiated, then connected', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(900, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final session = _Session();
      await tester.pumpWidget(_classic('cx', 'chat-a', session));
      await pumpChatUpdates(tester);
      session.frame('chat-a', 'connection.request', _frame(1, [_blender()]));
      await tester.pump();
      expect(stateText(tester), 'Waiting for your choice');
      await _tapKey(tester, 'catalog-install-blender');
      await tester.pump();
      expect(session.answers, [
        'chat-a|op-1|{"targets":[{"name":"blender","status":"approved"}]}',
      ]);

      session.frame(
        'chat-a',
        'connection.update',
        _frame(2, [_blender(state: 'initiated', phase: 'downloading')]),
      );
      await tester.pump();
      expectInstalling(tester, 'Downloading…');
      session.frame(
        'chat-a',
        'connection.update',
        _frame(3, [_blender(state: 'initiated', phase: 'python_packages')]),
      );
      await tester.pump();
      expectInstalling(tester, 'Installing Python packages…');

      session.frame(
        'chat-a',
        'connection.update',
        _frame(4, [_blender(state: 'connected', enabled: true)]),
      );
      await tester.pump();
      expectInstalled(tester);
      expect(session.answers, hasLength(1));
    });
  });
}
