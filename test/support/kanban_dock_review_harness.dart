// Shared harness for the Kanban dock regression tests of the dock + F11
// review (deb6f558): a NextGen chat over a fake gateway, and a Classic
// ChatScreen over a fake remote, each with a fake Kanban transport. Copied
// from test/nextgen_kanban_dock_test.dart and
// test/classic_kanban_dock_test.dart.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/kanban_dock.dart';
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

import 'completed_stock_turn.dart';
import 'fake_kanban_source.dart';
import 'fake_voice_composer_adapter.dart';

Map<String, dynamic> dockTask(
  String id, {
  String title = 'Ship the dock',
  String status = 'ready',
  String? session = 'chat-a',
}) => {
  'id': id,
  'title': title,
  'status': status,
  'assignee': 'builder',
  'session_id': session,
};

Finder dockRow(String id) => find.byKey(ValueKey('kanban-dock-card-$id'));

/// Pumps fake time in small steps, as the NextGen dock tests do.
Future<void> dockSettle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 60));
  }
}

/// Waits for work that leaves the fake clock (the board's HTTP fixture).
Future<void> dockShown(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 40 && finder.evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 15)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  expect(finder, findsWidgets);
}

// ── NextGen ──────────────────────────────────────────────────────────────

SavedConnection ngDockConnection() => SavedConnection(
  id: 'kanban-dock',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: '',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
  dashboardProxied: true,
);

StreamEvent ngDockEvent(
  String type,
  String runtime, [
  Map<String, dynamic> data = const {},
]) => StreamEvent(type: type, data: data, sessionId: runtime);

NgChatController ngDockChat(
  NextGenGateway gateway,
  String session,
  FakeKanbanSource? source,
) {
  final chat = NgChatController(gateway, sessionId: session)
    ..runtimeId = 'rt-$session'
    ..model = 'model-a';
  // Each attach opens the transport afresh, as the app's own source does.
  if (source != null) chat.debugKanbanSource = () => source..closed = false;
  return chat;
}

/// The NextGen chat view of [chat], wrapped by [wrap] (the route or pane
/// it sits in) when given.
Widget ngDockApp(
  SharedPreferences prefs,
  NextGenGateway gateway,
  NgChatController chat, {
  Widget Function(Widget chatView)? wrap,
}) {
  final view = NgChatView(
    key: ObjectKey(chat),
    chat: chat,
    onOpenSidebar: () {},
    onNewChat: () {},
  );
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
    home: NgScope(
      connManager: ConnectionManager(prefs),
      gateway: gateway,
      connections: [gateway.connection],
      switchTo: (_) async {},
      addGateway: () async {},
      signOut: (_) async {},
      reload: () async {},
      signInAgain: () async {},
      child: Scaffold(body: wrap == null ? view : wrap(view)),
    ),
  );
}

Future<void> showNgDockChat(
  WidgetTester tester,
  NextGenGateway gateway,
  NgChatController chat, {
  Widget Function(Widget chatView)? wrap,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(ngDockApp(prefs, gateway, chat, wrap: wrap));
  await dockSettle(tester);
}

Future<void> closeNgDockChat(
  WidgetTester tester,
  NextGenGateway gateway,
) async {
  await tester.pumpWidget(const SizedBox());
  gateway.dispose();
  await tester.pump(const Duration(seconds: 30));
}

// ── Classic ──────────────────────────────────────────────────────────────

final classicDockConnection = SavedConnection(
  id: 'classic-kanban',
  label: 'Fixture',
  host: 'fixture.invalid',
  port: 8642,
  apiKey: 'fixture',
);

Session classicDockSession(String id) => Session(
  id: id,
  title: 'Kanban',
  model: 'fixture',
  source: 'desktop',
  messageCount: 0,
  isActive: false,
  preview: '',
  startedAt: 1,
);

/// The agent's side of one Classic turn: it emits [before] (for example a
/// `session.info` after compression), creates [cards] and answers.
class ClassicDockRemote {
  ClassicDockRemote({this.cards = const [], this.before = const []});
  final List<Map<String, dynamic>> cards;
  final List<StreamEvent> before;
  List<Map<String, dynamic>> history = [];
  int submissions = 0;

  Future<void> submit({
    required String sessionId,
    required String text,
    required StreamCallback onEvent,
    required void Function() onSent,
  }) async {
    submissions++;
    onSent();
    before.forEach(onEvent);
    for (final card in cards) {
      onEvent(
        StreamEvent(
          type: 'tool.start',
          data: {
            'tool_id': card['tool_id'],
            'name': 'kanban_create',
            'args': card['args'],
          },
        ),
      );
      onEvent(StreamEvent(type: 'tool.complete', data: card));
    }
    onEvent(
      StreamEvent(type: 'message.complete', data: const {'text': 'Done.'}),
    );
  }
}

/// A Classic ChatScreen for [session], wrapped by [wrap] when given.
Widget classicDockChat({
  required String session,
  required ClassicDockRemote remote,
  required GatewayTurnApplicationController controller,
  TestChatKanban? kanban,
}) => ChatScreen(
  key: ValueKey('chat-$session'),
  connection: classicDockConnection,
  session: classicDockSession(session),
  turnApplicationController: controller,
  testApiClient: ApiClient(
    baseUrl: classicDockConnection.baseUrl,
    apiKey: 'fixture',
    httpClient: MockClient(
      (_) async => http.Response(
        jsonEncode({'data': remote.history}),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
    ),
  ),
  testRemotePromptSubmit: completedStockTurn(remote.submit),
  testStoredSessionKey: (_) => session,
  testKanban: kanban,
  testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
);

void mockClassicImagePicker() {
  const picker = MethodChannel('plugins.flutter.io/image_picker');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(picker, (_) async => null);
  addTearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(picker, null),
  );
}

Future<void> openClassicDockChat(
  WidgetTester tester, {
  required String session,
  required ClassicDockRemote remote,
  required GatewayTurnApplicationController controller,
  TestChatKanban? kanban,
  ThemeData? theme,
  Widget Function(Widget chat)? wrap,
}) async {
  mockClassicImagePicker();
  final chat = classicDockChat(
    session: session,
    remote: remote,
    controller: controller,
    kanban: kanban,
  );
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme,
      home: wrap == null ? chat : wrap(chat),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> sendClassicDockMessage(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(const Key('chat-message-composer')), text);
  await tester.tap(find.byTooltip('Send'));
  await tester.pumpAndSettle();
}

Future<void> closeClassicDockChat(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}

const classicDockStrip = ValueKey('classic-kanban-dock');
const classicDockToggle = ValueKey('classic-kanban-dock-toggle');
const ngDockKanbanSection = ValueKey('ng-dock-kanban');
