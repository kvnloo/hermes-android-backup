// /resume in a Classic chat opened by /new (or by the failure card's New
// chat, which opens the same fresh draft): the draft gets its host's open
// path, so /resume shows the picker, not a notice, and the pick opens the
// host's way in the draft's place (the draft's route leaves first).
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _composerKey = Key('chat-message-composer');

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

Future<void> _command(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(_composerKey).last, text);
  await tester.pump();
  await tester.tap(find.byKey(const Key('chat-send-message')).last);
  await _settle(tester);
}

ChatScreen _parent(List<String> opened) => ChatScreen(
  connection: SavedConnection(
    id: 'resume-fresh',
    label: 'resume-fresh',
    host: 'resume.fixture',
    port: 8642,
    apiKey: 'fixture',
  ),
  session: const Session(
    id: 'first',
    title: 'Chat first',
    model: 'm',
    source: 'api_server',
    messageCount: 1,
    isActive: false,
    preview: '',
    startedAt: 1,
  ),
  testApiClient: ApiClient(
    baseUrl: 'http://resume.fixture',
    apiKey: 'fixture',
    httpClient: _api(),
  ),
  testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
  onOpenSession: (s) async => opened.add(s.id),
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockChatImageRecovery();
  });

  testWidgets('/resume in a chat opened by /new shows the picker and opens '
      'the pick through the host, in the new chat\'s place', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 1400);
    addTearDown(tester.view.reset);
    final opened = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: hermesTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: _parent(opened),
      ),
    );
    await _settle(tester);
    await _command(tester, '/new');
    await tester.pump(const Duration(seconds: 1));
    final screens = find.byType(ChatScreen, skipOffstage: false);
    expect(screens, findsNWidgets(2));
    expect(
      tester
          .widget<ChatScreen>(find.byType(ChatScreen).last)
          .session
          .isLocalDraft,
      isTrue,
    );
    await _command(tester, '/resume');
    expect(find.text('Resume a chat'), findsOneWidget, reason: 'no picker');
    expect(
      find.textContaining('Open the session list to choose a chat'),
      findsNothing,
    );
    await tester.tap(find.text('Chat other').last);
    await _settle(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(opened, ['other'], reason: 'the host opens the pick');
    expect(
      find.byType(ChatScreen, skipOffstage: false),
      findsOneWidget,
      reason: 'the new chat left for the pick',
    );
    expect(
      tester.widget<ChatScreen>(find.byType(ChatScreen)).session.id,
      'first',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('a host with no open path: the new chat has none either '
      '(/resume keeps its notice there)', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 1400);
    addTearDown(tester.view.reset);
    final parent = _parent([]);
    await tester.pumpWidget(
      MaterialApp(
        theme: hermesTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatScreen(
          connection: parent.connection,
          session: parent.session,
          testApiClient: parent.testApiClient,
          testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
        ),
      ),
    );
    await _settle(tester);
    await _command(tester, '/new');
    await tester.pump(const Duration(seconds: 1));
    expect(
      tester.widget<ChatScreen>(find.byType(ChatScreen).last).onOpenSession,
      isNull,
    );
  });
}
