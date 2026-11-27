// The setup_beat card in Classic and NextGen: drawn only in the chat whose
// request it is, answered through that chat's server-request reply, closed
// with {} like the Desktop, and never answered once withdrawn or stale.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/gateway_turn_coordinator.dart';
import 'package:hermes_android/core/services/gateway_turn_recovery.dart';
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

const _question = 'Pick a first build';
const _notWaiting = 'This setup card is no longer waiting for an answer.';
const _notSent = 'Your answer was not sent. Try again.';

Map<String, dynamic> _buildCard(String runtime) => {
  'session_id': runtime,
  'beat': 'build',
  'question': _question,
  'tool_call_id': 'call-1',
  'card': {
    'options': [
      {'id': 'site', 'label': 'A website'},
      {'id': 'own', 'label': 'Something else'},
    ],
  },
};

SavedConnection _ngConnection(String id) => SavedConnection(
  id: id,
  label: 'Home $id',
  host: '10.0.0.5',
  port: 9119,
  apiKey: 'k',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
);

Future<void> _pumpNg(
  WidgetTester tester,
  NextGenGateway gateway,
  NgChatController chat,
) async {
  final prefs = await SharedPreferences.getInstance();
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
    {'role': 'user', 'content': 'set me up'},
  ]);
  addTearDown(chat.dispose);
  return chat;
}

/// Raises a setup_beat request on [gateway]; its answers land in [answers].
void _raise(
  NextGenGateway gateway,
  String id,
  Map<String, dynamic> params,
  List<Map<String, dynamic>> answers,
) {
  gateway.debugRequest(
    GatewayServerRequest.forTesting(
      id: id,
      method: 'setup_beat',
      params: params,
      respond: (result) {
        answers.add(result);
        return true;
      },
    ),
  );
}

/// A Classic recovery session that routes requests by local chat id and
/// answers only the setup cards it holds open for that chat.
class _SetupSession extends InertTurnApplicationSession
    implements GatewaySetupBeatResponder {
  final listeners = <String, DesktopAsyncEventCallback>{};
  final open = <String, Set<String>>{};
  final answers = <String>[];

  /// Answers and prompt submissions, in the order they left.
  final log = <String>[];

  /// The socket is down: a card stays held but no answer goes out.
  var offline = false;

  /// Re-delivers the cards still open for a chat when its screen listens
  /// again, as GatewayTurnApplicationController does on a reopened route.
  var replayOnListen = false;
  final _raised = <String, StreamEvent>{};

  @override
  Object setAsyncEventListener(
    String localSessionId,
    DesktopAsyncEventCallback listener,
  ) {
    listeners[localSessionId] = listener;
    if (replayOnListen) {
      for (final id in open[localSessionId] ?? const <String>{}) {
        final event = _raised[id];
        if (event != null) listener(localSessionId, event);
      }
    }
    return Object();
  }

  void raise(String chat, String requestId, Map<String, dynamic> params) {
    (open[chat] ??= {}).add(requestId);
    final event = StreamEvent(
      type: 'setup_beat.request',
      data: {...params, 'request_id': requestId},
    );
    _raised[requestId] = event;
    listeners[chat]?.call(chat, event);
  }

  @override
  Future<GatewayTurnRecoveryState> submit({
    required String localSessionId,
    required String text,
    List<GatewayTurnAttachmentReceipt> attachments = const [],
    GatewayTurnStateCallback? onState,
  }) {
    log.add('submit:$localSessionId|$text');
    return Completer<GatewayTurnRecoveryState>().future;
  }

  @override
  bool holdsSetupBeat({required String sessionId, required String requestId}) =>
      open[sessionId]?.contains(requestId) ?? false;

  void withdraw(String chat, String requestId) {
    open[chat]?.remove(requestId);
    listeners[chat]?.call(
      chat,
      StreamEvent(
        type: 'request.cancel',
        data: {'id': requestId, 'method': 'setup_beat'},
      ),
    );
  }

  @override
  Future<bool> tryRespondToConnection({
    required String sessionId,
    required String opId,
    required Map<String, dynamic> result,
  }) async => false;

  @override
  bool tryRespondToSetupBeat({
    required String sessionId,
    required String requestId,
    required Map<String, dynamic> result,
  }) {
    if (offline) return false;
    if (!(open[sessionId]?.remove(requestId) ?? false)) return false;
    answers.add('$sessionId|$requestId|${jsonEncode(result)}');
    log.add('answer:$sessionId|$requestId|${jsonEncode(result)}');
    return true;
  }
}

/// A NextGen gateway that records calls and accepts every prompt.
class _CallsGateway extends NextGenGateway {
  _CallsGateway(String id) : super(_ngConnection(id));

  final calls = <(String, Map<String, dynamic>)>[];

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    calls.add((method, params));
    return {'status': 'queued'};
  }
}

Widget _classic(String connectionId, String chatId, _SetupSession session) =>
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

  group('NextGen', () {
    testWidgets('a pick answers the request of the chat that shows it', (
      tester,
    ) async {
      final gateway = NextGenGateway(_ngConnection('c1'));
      addTearDown(gateway.dispose);
      final a = _ngChat(gateway, 'chat-a');
      final b = _ngChat(gateway, 'chat-b');
      final answers = <Map<String, dynamic>>[];
      await _pumpNg(tester, gateway, b);
      _raise(gateway, 'sb-1', _buildCard('rt-chat-a'), answers);
      await tester.pump();
      // Chat B sees nothing and cannot answer chat A's card.
      expect(find.text(_question), findsNothing);
      expect(b.answerSetupBeat('sb-1', const {}), isFalse);

      await _pumpNg(tester, gateway, a);
      expect(find.text(_question), findsOneWidget);
      await tester.tap(find.byKey(const Key('setup-beat-option-site')));
      await tester.pump();
      expect(answers, [
        {
          'answer': {'build': 'site', 'label': 'A website'},
        },
      ]);
      expect(find.text(_question), findsNothing);
      expect(a.answerSetupBeat('sb-1', const {}), isFalse);
      expect(answers, hasLength(1));
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('another connection with the same chat ids sees no card', (
      tester,
    ) async {
      final first = NextGenGateway(_ngConnection('c1'));
      final second = NextGenGateway(_ngConnection('c2'));
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      final onFirst = _ngChat(first, 'chat-a');
      final onSecond = _ngChat(second, 'chat-a');
      final answers = <Map<String, dynamic>>[];
      _raise(first, 'sb-1', _buildCard('rt-chat-a'), answers);
      await _pumpNg(tester, second, onSecond);
      expect(find.text(_question), findsNothing);
      expect(onSecond.answerSetupBeat('sb-1', const {}), isFalse);
      await _pumpNg(tester, first, onFirst);
      expect(find.text(_question), findsOneWidget);
      expect(answers, isEmpty);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('a withdrawn card disappears and is never answered', (
      tester,
    ) async {
      final gateway = NextGenGateway(_ngConnection('c1'));
      addTearDown(gateway.dispose);
      final chat = _ngChat(gateway, 'chat-a');
      final answers = <Map<String, dynamic>>[];
      await _pumpNg(tester, gateway, chat);
      _raise(gateway, 'sb-2', _buildCard('rt-chat-a'), answers);
      await tester.pump();
      expect(find.text(_question), findsOneWidget);
      gateway.debugEmit(
        StreamEvent(
          type: 'request.cancel',
          data: const {'id': 'sb-2', 'reason': 'timeout'},
          sessionId: 'rt-chat-a',
        ),
      );
      await tester.pump();
      expect(find.text(_question), findsNothing);
      expect(chat.answerSetupBeat('sb-2', const {}), isFalse);
      expect(answers, isEmpty);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('name, close and computer-only beats answer as the Desktop', (
      tester,
    ) async {
      final gateway = NextGenGateway(_ngConnection('c1'));
      addTearDown(gateway.dispose);
      final chat = _ngChat(gateway, 'chat-a');
      final answers = <Map<String, dynamic>>[];
      await _pumpNg(tester, gateway, chat);
      _raise(gateway, 'name-1', {
        'session_id': 'rt-chat-a',
        'beat': 'name',
        'question': 'What should I call you?',
        'card': {'suggested': 'Ada Lovelace'},
      }, answers);
      await tester.pump();
      await tester.tap(find.byKey(const Key('setup-beat-suggested-name')));
      await tester.pump();
      _raise(gateway, 'name-2', {
        'session_id': 'rt-chat-a',
        'beat': 'name',
        'question': 'What should I call you?',
        'card': <String, dynamic>{},
      }, answers);
      await tester.pump();
      await tester.enterText(find.byKey(const Key('setup-beat-name')), ' Sam ');
      await tester.pump();
      await tester.tap(find.byKey(const Key('setup-beat-name-continue')));
      await tester.pump();
      _raise(gateway, 'tour-1', {
        'session_id': 'rt-chat-a',
        'beat': 'tour',
        'question': 'Want a tour?',
        'card': {
          'options': [
            {'id': 'quick', 'label': 'Quick tour'},
          ],
        },
      }, answers);
      await tester.pump();
      await tester.tap(find.byKey(const Key('setup-beat-close')));
      await tester.pump();
      _raise(gateway, 'theme-1', {
        'session_id': 'rt-chat-a',
        'beat': 'theme',
        'question': 'Pick an accent',
        'card': {'picker': 'accent'},
      }, answers);
      await tester.pump();
      expect(
        find.text(
          'This step is done in Hermes on the computer it runs on. '
          'Continue keeps what is set up there.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('setup-beat-close')));
      await tester.pump();
      expect(answers, [
        {
          'answer': {'name': 'Ada Lovelace'},
        },
        {
          'answer': {'name': 'Sam'},
        },
        <String, dynamic>{},
        <String, dynamic>{},
      ]);
      await tester.pumpWidget(const SizedBox());
    });

    // Desktop's setup-beat store clears a card only once its answer is sent,
    // so a failed send leaves it on screen to answer again.
    testWidgets('a failed send keeps the card to answer again', (tester) async {
      final gateway = NextGenGateway(_ngConnection('c1'));
      addTearDown(gateway.dispose);
      final chat = _ngChat(gateway, 'chat-a');
      final answers = <Map<String, dynamic>>[];
      var online = false;
      await _pumpNg(tester, gateway, chat);
      gateway.debugRequest(
        GatewayServerRequest.forTesting(
          id: 'sb-f',
          method: 'setup_beat',
          params: _buildCard('rt-chat-a'),
          respond: (result) {
            if (!online) return false;
            answers.add(result);
            return true;
          },
        ),
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('setup-beat-option-site')));
      await tester.pump();
      expect(answers, isEmpty);
      expect(find.text(_question), findsOneWidget);
      expect(find.text(_notSent), findsOneWidget);

      online = true;
      await tester.tap(find.byKey(const Key('setup-beat-option-site')));
      await tester.pump();
      expect(answers, [
        {
          'answer': {'build': 'site', 'label': 'A website'},
        },
      ]);
      expect(find.text(_question), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });

    // Desktop's yieldSetupBeatToMessage: a message sent while the card waits
    // closes it with {wrote_instead: true}; the backend ends the card's turn
    // and the message runs as the next turn, never a steer.
    testWidgets('a message sent while the card waits closes it', (
      tester,
    ) async {
      final gateway = _CallsGateway('c1');
      addTearDown(gateway.dispose);
      final chat = _ngChat(gateway, 'chat-a');
      final answers = <Map<String, dynamic>>[];
      await _pumpNg(tester, gateway, chat);
      gateway.debugEmit(
        StreamEvent(
          type: 'message.start',
          data: const {},
          sessionId: 'rt-chat-a',
        ),
      );
      _raise(gateway, 'sb-w', _buildCard('rt-chat-a'), answers);
      await tester.pump();
      expect(find.text(_question), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('ng-composer-field')),
        'Actually, help me with my CV',
      );
      await tester.pump();
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      await tester.pump();
      expect(answers, [
        {'wrote_instead': true},
      ]);
      expect(find.text(_question), findsNothing);
      expect(gateway.calls.map((call) => call.$1), isNot(contains('steer')));
      expect(chat.queued.single.text, 'Actually, help me with my CV');

      gateway.debugEmit(
        StreamEvent(
          type: 'message.complete',
          data: const {},
          sessionId: 'rt-chat-a',
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(
        gateway.calls
            .where((call) => call.$1 == 'prompt.submit')
            .single
            .$2['text'],
        'Actually, help me with my CV',
      );
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('Classic', () {
    Future<void> show(WidgetTester tester, Widget app) async {
      await tester.binding.setSurfaceSize(const Size(900, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(app);
      await pumpChatUpdates(tester);
    }

    testWidgets('a pick answers through the chat that owns the card', (
      tester,
    ) async {
      final session = _SetupSession();
      await show(tester, _classic('cx', 'chat-b', session));
      session.raise('chat-a', 'k1', _buildCard('runtime-a'));
      await tester.pump();
      expect(find.text(_question), findsNothing);
      // The screen also ignores an event addressed to another chat.
      session.listeners['chat-b']!(
        'chat-a',
        StreamEvent(
          type: 'setup_beat.request',
          data: {..._buildCard('runtime-a'), 'request_id': 'k1'},
        ),
      );
      await tester.pump();
      expect(find.text(_question), findsNothing);

      await show(tester, _classic('cx', 'chat-a', session));
      session.raise('chat-a', 'k1', _buildCard('runtime-a'));
      await tester.pump();
      expect(find.text(_question), findsOneWidget);
      await tester.tap(find.byKey(const Key('setup-beat-option-own')));
      await tester.pump();
      expect(session.answers, [
        'chat-a|k1|{"answer":{"build":"own","label":"Something else"}}',
      ]);
      expect(find.text(_question), findsNothing);
    });

    testWidgets('another connection with the same chat id sees no card', (
      tester,
    ) async {
      final onX = _SetupSession();
      final onY = _SetupSession();
      await show(tester, _classic('cy', 'chat-a', onY));
      onX.raise('chat-a', 'k1', _buildCard('runtime-a'));
      await tester.pump();
      expect(find.text(_question), findsNothing);
      expect(
        onY.tryRespondToSetupBeat(
          sessionId: 'chat-a',
          requestId: 'k1',
          result: const {},
        ),
        isFalse,
      );
      await show(tester, _classic('cx', 'chat-a', onX));
      onX.raise('chat-a', 'k1', _buildCard('runtime-a'));
      await tester.pump();
      expect(find.text(_question), findsOneWidget);
      expect(onX.answers, isEmpty);
    });

    testWidgets('withdrawn and stale cards are never answered', (tester) async {
      final session = _SetupSession();
      await show(tester, _classic('cx', 'chat-a', session));
      session.raise('chat-a', 'k1', _buildCard('runtime-a'));
      await tester.pump();
      expect(find.text(_question), findsOneWidget);
      session.withdraw('chat-a', 'k1');
      await tester.pump();
      expect(find.text(_question), findsNothing);

      // Settled elsewhere with no cancel reaching this screen: the tap finds
      // the request gone, sends nothing and says so.
      session.raise('chat-a', 'k2', _buildCard('runtime-a'));
      await tester.pump();
      session.open['chat-a']!.remove('k2');
      await tester.tap(find.byKey(const Key('setup-beat-option-site')));
      await tester.pump();
      expect(session.answers, isEmpty);
      expect(find.text(_question), findsNothing);
      expect(find.text(_notWaiting), findsOneWidget);
    });

    testWidgets('closing the card answers {}', (tester) async {
      final session = _SetupSession();
      await show(tester, _classic('cx', 'chat-a', session));
      session.raise('chat-a', 'k3', {
        'session_id': 'runtime-a',
        'beat': 'plugins',
        'question': 'Add plugins?',
        'card': {
          'plugins': ['blender'],
        },
      });
      await tester.pump();
      expect(find.text('blender'), findsOneWidget);
      await tester.tap(find.byKey(const Key('setup-beat-close')));
      await tester.pump();
      expect(session.answers, ['chat-a|k3|{}']);
    });

    testWidgets('a failed send keeps the card to answer again', (tester) async {
      final session = _SetupSession();
      await show(tester, _classic('cx', 'chat-a', session));
      session.raise('chat-a', 'k4', _buildCard('runtime-a'));
      await tester.pump();
      session.offline = true;
      await tester.tap(find.byKey(const Key('setup-beat-option-site')));
      await tester.pump();
      expect(session.answers, isEmpty);
      expect(find.text(_question), findsOneWidget);
      expect(find.text(_notSent), findsOneWidget);
      expect(find.text(_notWaiting), findsNothing);

      session.offline = false;
      await tester.tap(find.byKey(const Key('setup-beat-option-site')));
      await tester.pump();
      expect(session.answers, [
        'chat-a|k4|{"answer":{"build":"site","label":"A website"}}',
      ]);
      expect(find.text(_question), findsNothing);
    });

    // Desktop re-delivers a session's open requests when it is resumed; a
    // card still waiting comes back when its chat is opened again.
    testWidgets('an open card returns when the chat is reopened', (
      tester,
    ) async {
      final session = _SetupSession()..replayOnListen = true;
      await show(tester, _classic('cx', 'chat-a', session));
      session.raise('chat-a', 'k5', _buildCard('runtime-a'));
      await tester.pump();
      expect(find.text(_question), findsOneWidget);
      await show(tester, _classic('cx', 'chat-b', session));
      expect(find.text(_question), findsNothing);
      await show(tester, _classic('cx', 'chat-a', session));
      expect(find.text(_question), findsOneWidget);
      await tester.tap(find.byKey(const Key('setup-beat-option-own')));
      await tester.pump();
      expect(session.answers, [
        'chat-a|k5|{"answer":{"build":"own","label":"Something else"}}',
      ]);
    });

    testWidgets('a message sent while the card waits closes it first', (
      tester,
    ) async {
      final session = _SetupSession();
      await show(tester, _classic('cx', 'chat-a', session));
      session.raise('chat-a', 'k6', _buildCard('runtime-a'));
      await tester.pump();
      expect(find.text(_question), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('chat-message-composer')),
        'Actually, help me with my CV',
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('chat-send-message')));
      await tester.pump();
      await tester.pump();
      expect(session.log, [
        'answer:chat-a|k6|{"wrote_instead":true}',
        'submit:chat-a|Actually, help me with my CV',
      ]);
      expect(find.text(_question), findsNothing);
      expect(find.text(_notWaiting), findsNothing);
    });
  });
}
