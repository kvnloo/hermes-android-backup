// The bubble's "Regenerate response" in a Classic chat whose transport
// cannot truncate: REST, and a stock owner with no Desktop client. Main
// (a7b2bd83) offered it on every assistant reply and asked again; 8819dc5c
// took the action away wherever the truncating regenerate does not run.
// It is offered there again (message sheet and quick action) and sends the
// reply's prompt as exactly one new turn. A newer draft stays in the
// composer. The failure card's Retry is not this action: on these
// transports it still sends nothing (probe C1,
// composer_review_regression_classic_test.dart).
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _composerKey = Key('chat-message-composer');
const _question = 'Earlier question';
const _reply = 'Earlier answer';
const _draft = 'my newer unsent draft';

Widget _app(Widget home) => MaterialApp(
  theme: hermesTheme(Brightness.light),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

const _session = Session(
  id: 'regenerate-stored',
  title: 'Stored',
  model: 'fixture',
  source: 'api_server',
  messageCount: 2,
  isActive: false,
  preview: '',
  startedAt: 1,
);

SavedConnection _conn(String id) => SavedConnection(
  id: id,
  label: id,
  host: 'regenerate.fixture',
  port: 8642,
  apiKey: 'fixture-key',
);

String _composer(WidgetTester tester) =>
    tester.widget<TextField>(find.byKey(_composerKey)).controller!.text;

/// The saved chat: one prompt and its reply. A regenerate that reaches the
/// REST transport is recorded in [posts] and answered with a short stream.
class _Rest {
  final posts = <http.Request>[];
  final rows = <Map<String, dynamic>>[
    {'id': 1, 'role': 'user', 'content': _question},
    {'id': 2, 'role': 'assistant', 'content': _reply, 'finish_reason': 'stop'},
  ];

  Future<http.Response> respond(http.Request request) async {
    if (request.method == 'POST') {
      posts.add(request);
      if (request.url.path != '/v1/chat/completions') {
        return http.Response('{}', 404);
      }
      rows.addAll([
        {'id': 3, 'role': 'user', 'content': _question},
        {
          'id': 4,
          'role': 'assistant',
          'content': 'Second answer',
          'finish_reason': 'stop',
        },
      ]);
      String frame(Map<String, dynamic> choice) =>
          'data: ${jsonEncode({
            'choices': [choice],
          })}\n\n';
      return http.Response(
        '${frame({
          'delta': {'content': 'Second answer'},
        })}'
        '${frame({'delta': <String, dynamic>{}, 'finish_reason': 'stop'})}'
        'data: [DONE]\n\n',
        200,
        headers: {'content-type': 'text/event-stream'},
      );
    }
    if (request.url.path.endsWith('/messages')) {
      return http.Response(
        jsonEncode({'data': rows}),
        200,
        headers: {'content-type': 'application/json'},
      );
    }
    return http.Response('{}', 404);
  }

  ApiClient get client => ApiClient(
    baseUrl: 'http://regenerate.fixture',
    apiKey: 'fixture-key',
    httpClient: MockClient(respond),
  );
}

Finder _bubble(String content) => find.descendant(
  of: find.byWidgetPredicate(
    (widget) =>
        widget is MessageBubble && !widget.isUser && widget.content == content,
  ),
  matching: find.byKey(const Key('message-bubble')),
);

/// Long-presses the saved reply and chooses Regenerate from its sheet.
Future<void> _regenerateFromSheet(WidgetTester tester) async {
  final reply = _bubble(_reply);
  await tester.ensureVisible(reply);
  await tester.pumpAndSettle();
  expect(reply.hitTestable(), findsOneWidget);
  await tester.longPress(reply);
  await tester.pumpAndSettle();
  expect(
    find.text('Regenerate response'),
    findsOneWidget,
    reason: 'the message sheet offers Regenerate on this transport',
  );
  await tester.tap(find.text('Regenerate response'));
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockChatImageRecovery();
  });

  testWidgets('REST: Regenerate on a reply asks again as one new turn and '
      'keeps the newer draft', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final rest = _Rest();
    await tester.pumpWidget(
      _app(
        ChatScreen(
          connection: _conn('regenerate-rest'),
          session: _session,
          testApiClient: rest.client,
          testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
        ),
      ),
    );
    await pumpChatUpdates(tester);
    expect(_bubble(_reply), findsOneWidget);
    // The last reply's quick action is offered too.
    expect(find.byTooltip('Regenerate response'), findsOneWidget);

    await tester.enterText(find.byKey(_composerKey), _draft);
    await tester.pump();
    await _regenerateFromSheet(tester);
    for (var i = 0; i < 20 && rest.posts.isEmpty; i++) {
      await pumpChatUpdates(tester);
    }
    await pumpChatUpdates(tester);

    expect(rest.posts, hasLength(1), reason: 'exactly one new turn');
    expect(rest.posts.single.url.path, '/v1/chat/completions');
    final sent =
        (jsonDecode(rest.posts.single.body) as Map<String, dynamic>)['messages']
            as List;
    // Asked again after the saved turn: nothing is cut on this transport.
    expect(sent, hasLength(3));
    expect(sent[0], {'role': 'user', 'content': _question});
    expect(sent[1], {'role': 'assistant', 'content': _reply});
    expect((sent[2] as Map)['role'], 'user');
    expect((sent[2] as Map)['content'], startsWith(_question));
    expect(
      (sent[2] as Map)['content'],
      isNot(contains(_draft)),
      reason: 'the draft is not what Regenerate sends',
    );
    expect(_composer(tester), _draft, reason: 'the newer draft stays');
    expect(
      find.textContaining('Retry cannot replace a turn'),
      findsNothing,
      reason: 'the bubble action runs here; it is not refused',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('a stock owner with no Desktop client: Regenerate submits the '
      'prompt once and keeps the newer draft', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final rest = _Rest();
    final submitted = <String>[];
    final controller = GatewayTurnApplicationController();
    try {
      await tester.pumpWidget(
        _app(
          ChatScreen(
            connection: _conn('regenerate-owner'),
            session: _session,
            turnApplicationController: controller,
            testApiClient: rest.client,
            testRemotePromptSubmit:
                ({
                  required sessionId,
                  required text,
                  required onEvent,
                  required onSent,
                }) async {
                  submitted.add(text);
                },
            testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_bubble(_reply), findsOneWidget);

      await tester.enterText(find.byKey(_composerKey), _draft);
      await tester.pump();
      await _regenerateFromSheet(tester);
      for (var i = 0; i < 10 && submitted.isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(submitted, hasLength(1), reason: 'exactly one new turn');
      expect(submitted.single, startsWith(_question));
      expect(submitted.single, isNot(contains(_draft)));
      expect(rest.posts, isEmpty, reason: 'not a second, REST, send');
      expect(_composer(tester), _draft, reason: 'the newer draft stays');
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await controller.close();
      await tester.pump();
    }
  });
}
