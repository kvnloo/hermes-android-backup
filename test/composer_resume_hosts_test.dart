// Re-check of v5/composer at a3437ec5: Classic `/resume` showed a notice
// instead of the picker wherever the host passed no open path: parallel
// panes, pop-out windows, cron runs and notification-opened chats. Each
// host now opens the pick its own way and stays:
//   * a parallel pane opens it as another pane of the workspace;
//   * a cron run, a notification or a pop-out opens it in the chat route's
//     place (resumableChatRoute), the routes under it kept.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/screens/classic_parallel_workspace.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/workspace/popout_bootstrap.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/parallel_workspace_fixture.dart';
import 'support/pump_chat_updates.dart';

const _composerKey = Key('chat-message-composer');

Session _row(String id) => Session(
  id: id,
  title: 'Chat $id',
  model: 'm',
  source: 'api_server',
  messageCount: 1,
  isActive: false,
  preview: '',
  startedAt: 1,
);

/// The sessions list the picker reads, and empty histories.
MockClient _api() => MockClient((request) async {
  final path = request.url.path;
  Object body = {'data': const <Object>[]};
  if (path == '/api/sessions') {
    body = {
      'data': [
        for (final id in ['first', 'other'])
          {
            'id': id,
            'title': 'Chat $id',
            'source': 'desktop',
            'started_at': 1700000000,
            'message_count': 1,
          },
      ],
      'has_more': false,
    };
  }
  return http.Response(
    jsonEncode(body),
    200,
    headers: {'content-type': 'application/json'},
  );
});

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump(const Duration(milliseconds: 60));
  }
}

Future<void> _resume(WidgetTester tester, Finder composer) async {
  await tester.enterText(composer, '/resume');
  await tester.pump();
  await tester.tap(find.byKey(const Key('chat-send-message')));
  await _settle(tester);
}

/// Each `[name](...)` (default `ChatScreen(...)`) in [source], as written.
List<String> _chatScreenCalls(String source, {String name = 'ChatScreen'}) {
  final calls = <String>[];
  final pattern = RegExp('\\b$name\\(');
  for (
    var at = source.indexOf(pattern);
    at >= 0;
    at = source.indexOf(pattern, at + 1)
  ) {
    var depth = 0;
    final open = source.indexOf('(', at);
    for (var i = open; i < source.length; i++) {
      if (source[i] == '(') depth++;
      if (source[i] == ')' && --depth == 0) {
        calls.add(source.substring(at, i + 1));
        break;
      }
    }
  }
  return calls;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockChatImageRecovery();
  });

  test('every ChatScreen built anywhere in lib/ gets an open path', () {
    // A chat built without onOpenSession answers /resume with a notice
    // instead of the picker. Every construction in lib/ passes one, unless
    // it is listed here with the reason it cannot (none today).
    const allowlist = <String, String>{
      // 'lib/path/to/file.dart': 'why this chat has nowhere to open a pick',
    };
    final checked = <String>[];
    for (final file
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      final path = file.path.replaceAll(r'\', '/');
      // Whole-line comments may name ChatScreen( in prose.
      final source = file
          .readAsLinesSync()
          .where((line) => !line.trimLeft().startsWith('//'))
          .join('\n');
      for (final name in ['ChatScreen', 'buildWorkspaceChatScreen']) {
        for (final call in _chatScreenCalls(source, name: name)) {
          // The declarations themselves (named parameters follow `({`).
          if (call.startsWith('$name({')) continue;
          checked.add(path);
          if (allowlist.containsKey(path)) continue;
          expect(call, contains('onOpenSession:'), reason: '$path: $call');
        }
      }
    }
    // The scan really reads the hosts (pane, pop-out, cron, notifications,
    // session lists, the /new and failure-card New chat draft).
    expect(
      checked.toSet(),
      containsAll([
        'lib/core/screens/chat_screen.dart',
        'lib/core/screens/classic_parallel_chat_pane.dart',
        'lib/core/screens/cron_screen.dart',
        'lib/core/screens/session_list_screen.dart',
        'lib/core/screens/workspace_screen.dart',
        'lib/core/workspace/popout_bootstrap.dart',
        'lib/main.dart',
      ]),
    );
  });

  testWidgets('a Classic parallel pane opens the pick as another pane; the '
      'workspace stays', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1400, 1000);
    addTearDown(tester.view.reset);
    final f = ParallelFixture();
    await tester.pumpWidget(
      MaterialApp(
        theme: hermesTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ClassicParallelWorkspace(
          connection: f.connection,
          clientFactory: f.api,
        ),
      ),
    );
    await _settle(tester);
    await tester.tap(find.byTooltip('Add chat'));
    await _settle(tester);
    await tester.tap(find.text('Chat alpha').last);
    await _settle(tester);
    expect(find.byType(ChatScreen), findsOneWidget);

    await _resume(tester, find.byKey(_composerKey));
    expect(find.text('Resume a chat'), findsOneWidget);
    await tester.tap(find.text('Chat beta').last);
    await _settle(tester);

    expect(find.text('Parallel workspace'), findsOneWidget);
    expect(
      tester.widget<ChatScreen>(find.byType(ChatScreen)).session.id,
      'beta',
    );
    // Both chats are panes of the workspace now.
    expect(find.widgetWithText(InputChip, 'Chat alpha'), findsOneWidget);
    expect(find.widgetWithText(InputChip, 'Chat beta'), findsOneWidget);
  });

  testWidgets('a pushed chat (cron run, notification) opens the pick in its '
      'place: the host under it stays and the new route is reported', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 1400);
    addTearDown(tester.view.reset);
    final connection = SavedConnection(
      id: 'resume-route',
      label: 'route',
      host: 'resume.fixture',
      port: 8642,
      apiKey: 'fixture',
    );
    final replaced = <String>[];
    final client = _api();
    Widget build(Session session, Future<void> Function(Session) open) =>
        ChatScreen(
          connection: connection,
          session: session,
          testApiClient: ApiClient(
            baseUrl: 'http://resume.fixture',
            apiKey: 'fixture',
            httpClient: client,
          ),
          testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
          onOpenSession: open,
        );
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        theme: hermesTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: Text('HOST-SHELL')),
      ),
    );
    unawaited(
      navigator.currentState!.push(
        resumableChatRoute(
          _row('first'),
          build,
          onReplaced: (route, session, closed) => replaced.add(session.id),
        ),
      ),
    );
    await _settle(tester);
    expect(
      tester.widget<ChatScreen>(find.byType(ChatScreen)).session.id,
      'first',
    );

    await _resume(tester, find.byKey(_composerKey));
    expect(find.text('Resume a chat'), findsOneWidget);
    await tester.tap(find.text('Chat other').last);
    await _settle(tester);
    // The sheet closes, then the routes change.
    await tester.pump(const Duration(seconds: 1));

    expect(
      tester.widget<ChatScreen>(find.byType(ChatScreen)).session.id,
      'other',
    );
    expect(replaced, ['other']);
    // The picked chat took the first one's place: Back is the host.
    navigator.currentState!.pop();
    await _settle(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(ChatScreen), findsNothing);
    expect(find.text('HOST-SHELL'), findsOneWidget);
  });

  testWidgets('a Classic pop-out window opens the pick over its own chat; '
      'the window and its chat stay', (tester) async {
    final previous = HttpOverrides.current;
    HttpOverrides.global = null;
    addTearDown(() => HttpOverrides.global = previous);
    late HttpServer server;
    await tester.runAsync(() async {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((req) async {
        final path = req.uri.path;
        req.response.headers.contentType = ContentType.json;
        if (path == '/api/sessions') {
          req.response.write(
            jsonEncode({
              'object': 'list',
              'data': [
                {
                  'id': 'other',
                  'title': 'Chat other',
                  'model': 'm',
                  'message_count': 1,
                  'started_at': 1.7e9,
                  'ended_at': null,
                  'preview': 'hi',
                  'source': 'cli',
                },
              ],
              'has_more': false,
            }),
          );
        } else if (path.endsWith('/messages')) {
          req.response.write(jsonEncode({'data': []}));
        } else {
          req.response.statusCode = 404;
          req.response.write('{}');
        }
        await req.response.close();
      });
    });
    addTearDown(() async {
      await tester.runAsync(() => server.close(force: true));
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 1400);
    addTearDown(tester.view.reset);
    final connection = SavedConnection(
      id: 'resume-popout',
      label: 'popout',
      host: '127.0.0.1',
      port: server.port,
      dashboardPortOverride: server.port,
      apiKey: 'fixture',
    );
    final manager = ConnectionManager(await SharedPreferences.getInstance());
    await tester.pumpWidget(
      PopoutChatApp(
        manager: manager,
        connection: connection,
        session: _row('first'),
        gateway: null,
      ),
    );
    await _settle(tester);
    await _resume(tester, find.byKey(_composerKey));
    expect(find.text('Resume a chat'), findsOneWidget);
    await tester.tap(find.text('Chat other').last);
    await _settle(tester);
    // The sheet closes, then the routes change.
    await tester.pump(const Duration(seconds: 1));

    expect(
      tester.widget<ChatScreen>(find.byType(ChatScreen)).session.id,
      'other',
    );
    final windowChat = find.byWidgetPredicate(
      (w) => w is ChatScreen && w.session.id == 'first',
      skipOffstage: false,
    );
    expect(windowChat, findsOneWidget);
    await tester.binding.handlePopRoute();
    await _settle(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(
      tester.widget<ChatScreen>(find.byType(ChatScreen)).session.id,
      'first',
    );
  });
}
