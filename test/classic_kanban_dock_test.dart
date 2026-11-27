// Kanban cards above the Classic composer (scope row KDK): the same rows,
// live status and tap-to-open as the NextGen dock. A fake gateway and a fake
// Kanban transport; no live gateway.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/screens/kanban_board_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/widgets/kanban_dock.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/completed_stock_turn.dart';
import 'support/fake_kanban_source.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/kanban_board_fixture.dart';

final _connection = SavedConnection(
  id: 'classic-kanban',
  label: 'Fixture',
  host: 'fixture.invalid',
  port: 8642,
  apiKey: 'fixture',
);

Session _session(String id) => Session(
  id: id,
  title: 'Kanban',
  model: 'fixture',
  source: 'desktop',
  messageCount: 0,
  isActive: false,
  preview: '',
  startedAt: 1,
);

final _en = lookupAppLocalizations(const Locale('en'));

Map<String, dynamic> _task(
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

/// The agent's side of one turn: it creates [cards] and answers.
class _Remote {
  _Remote({this.cards = const []});
  final List<Map<String, dynamic>> cards;
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

Future<void> _open(
  WidgetTester tester, {
  required String session,
  required _Remote remote,
  required GatewayTurnApplicationController controller,
  TestChatKanban? kanban,
  double textScale = 1,
  bool live = true,
}) async {
  const picker = MethodChannel('plugins.flutter.io/image_picker');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(picker, (_) async => null);
  addTearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(picker, null),
  );
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: ChatScreen(
        key: ValueKey('chat-$session'),
        connection: _connection,
        session: _session(session),
        turnApplicationController: controller,
        testApiClient: ApiClient(
          baseUrl: _connection.baseUrl,
          apiKey: 'fixture',
          httpClient: MockClient(
            (_) async => http.Response(
              jsonEncode({'data': remote.history}),
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            ),
          ),
        ),
        testRemotePromptSubmit: live ? completedStockTurn(remote.submit) : null,
        testStoredSessionKey: (_) => session,
        testKanban: kanban,
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _send(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(const Key('chat-message-composer')), text);
  await tester.tap(find.byTooltip('Send'));
  await tester.pumpAndSettle();
}

/// Waits for work that leaves the fake clock (the board's HTTP fixture).
Future<void> _shown(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 40 && finder.evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 15)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  expect(finder, findsWidgets);
}

Future<void> _close(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}

const _dock = ValueKey('classic-kanban-dock');
const _toggle = ValueKey('classic-kanban-dock-toggle');
Finder _row(String id) => find.byKey(ValueKey('kanban-dock-card-$id'));
String _meta(WidgetTester tester, String id) =>
    tester.widget<Text>(find.byKey(ValueKey('kanban-dock-meta-$id'))).data!;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({'verbose_mode': false}));

  testWidgets('kanban_create in a turn makes a row appear with its status, '
      'and a board event updates it', (tester) async {
    tester.view.physicalSize = const Size(412, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final source = FakeKanbanSource();
    final remote = _Remote(
      cards: [
        kanbanCreateEvent(toolId: 'call-1', taskId: 't_1', status: 'todo'),
      ],
    );
    final controller = GatewayTurnApplicationController();
    addTearDown(controller.close);
    await _open(
      tester,
      session: 'chat-a',
      remote: remote,
      controller: controller,
      kanban: TestChatKanban(source: () => source),
    );
    expect(find.byKey(_dock), findsNothing);
    expect(source.watching, isEmpty);

    source.put('default', _task('t_1', status: 'todo'));
    await _send(tester, 'Put that on the board.');
    expect(remote.submissions, 1);
    expect(find.byKey(_dock), findsOneWidget);
    expect(find.text(_en.ng_dock_kanban(1)), findsOneWidget);
    // In the composer's own strip, above the editor.
    expect(
      find.descendant(
        of: find.byKey(const Key('chat-input-bar')),
        matching: find.byKey(_dock),
      ),
      findsOneWidget,
    );
    expect(
      tester.getRect(find.byKey(_dock)).bottom,
      lessThanOrEqualTo(
        tester.getRect(find.byKey(const Key('chat-composer-pill'))).top,
      ),
    );

    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    expect(_row('t_1'), findsOneWidget);
    expect(_meta(tester, 't_1'), 'To do · @builder');
    expect(source.watching, {'default'});

    source.put('default', _task('t_1', status: 'running'));
    source.emit('default', [
      {'id': 11, 'task_id': 't_1', 'kind': 'claimed'},
    ]);
    await tester.pumpAndSettle();
    expect(_meta(tester, 't_1'), 'Running · @builder');

    // Folds like the other status rows.
    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    expect(_row('t_1'), findsNothing);
    expect(find.byKey(_dock), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _close(tester);
    expect(source.watching, isEmpty);
    expect(source.closed, isTrue);
  });

  testWidgets('a tap opens the board on that card through the chat\'s own '
      'owner (narrow: the board\'s pushed route)', (tester) async {
    tester.view.physicalSize = const Size(412, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final source = FakeKanbanSource()
      ..put('default', _task('t_1', status: 'running'));
    final board = KanbanBoardFixture(tasks: [_task('t_1', status: 'running')]);
    final owner = makeKanbanOwner(board.client, connectionId: _connection.id);
    final remote = _Remote()
      ..history = [
        {'id': 1, 'role': 'user', 'content': 'make a card'},
        ...kanbanCreateRows(toolId: 'c1', taskId: 't_1', id: 2),
        {'id': 4, 'role': 'assistant', 'content': 'Done.'},
      ];
    final controller = GatewayTurnApplicationController();
    addTearDown(controller.close);
    await _open(
      tester,
      session: 'chat-a',
      remote: remote,
      controller: controller,
      kanban: TestChatKanban(source: () => source, owner: owner),
    );
    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    await tester.tap(_row('t_1'));
    await _shown(tester, find.byType(KanbanBoardScreen));

    final screen = tester.widget<KanbanBoardScreen>(
      find.byType(KanbanBoardScreen),
    );
    expect(screen.initialBoard, 'default');
    expect(screen.initialCardId, 't_1');
    expect(identical(screen.owner, owner), isTrue);
    expect(screen.route.connectionId, _connection.id);
    expect(screen.onClose, isNull, reason: 'a route, not a pane');
    expect(find.byKey(const ValueKey('kanban-pane')), findsNothing);
    await _shown(tester, find.textContaining('t_1 · Running'));
    expect(tester.takeException(), isNull);
    await _close(tester);
  });

  testWidgets('wide: the board opens as a pane beside the chat', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final source = FakeKanbanSource()
      ..put('default', _task('t_1', status: 'running'));
    final board = KanbanBoardFixture(tasks: [_task('t_1', status: 'running')]);
    final owner = makeKanbanOwner(board.client, connectionId: _connection.id);
    final remote = _Remote();
    final controller = GatewayTurnApplicationController();
    addTearDown(controller.close);
    await _open(
      tester,
      session: 'chat-a',
      remote: remote,
      controller: controller,
      kanban: TestChatKanban(source: () => source, owner: owner),
    );
    // Found by provenance alone: no tool call of this chat is on screen.
    expect(find.text(_en.ng_dock_kanban(1)), findsOneWidget);
    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    await tester.tap(_row('t_1'));
    await _shown(tester, find.byKey(const ValueKey('kanban-pane')));
    final screen = tester.widget<KanbanBoardScreen>(
      find.byType(KanbanBoardScreen),
    );
    expect(screen.initialCardId, 't_1');
    expect(screen.onClose, isNotNull);
    final composer = find.byKey(const Key('chat-message-composer'));
    expect(composer.hitTestable(), findsOneWidget);
    final pane = tester.getRect(find.byKey(const ValueKey('kanban-pane')));
    expect(pane.right, 1280);
    expect(tester.getRect(composer).right, lessThanOrEqualTo(pane.left));
    await _shown(tester, find.textContaining('t_1 · Running'));

    // The sheet belongs to the pane; closing the pane leaves the chat.
    Navigator.of(tester.element(find.textContaining('t_1 · Running'))).pop();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(const Key('kanban-close')));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const ValueKey('kanban-pane')), findsNothing);
    expect(find.byType(KanbanBoardScreen), findsNothing);
    expect(composer.hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _close(tester);
  });

  testWidgets('a card from another chat never shows, and a late answer for '
      'the chat that was left is dropped', (tester) async {
    tester.view.physicalSize = const Size(412, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final hold = Completer<void>();
    final sourceA = FakeKanbanSource()
      ..put('default', _task('t_a', title: 'Card of chat A'));
    final sourceB = FakeKanbanSource()
      ..put('default', _task('t_a', title: 'Card of chat A'));
    final remote = _Remote();
    final controller = GatewayTurnApplicationController();
    addTearDown(controller.close);
    await _open(
      tester,
      session: 'chat-a',
      remote: remote,
      controller: controller,
      kanban: TestChatKanban(source: () => sourceA),
    );
    expect(find.text(_en.ng_dock_kanban(1)), findsOneWidget);
    expect(sourceA.watching, {'default'});

    // A board read of chat A is in flight when chat B replaces it.
    sourceA
      ..hold = hold
      ..put('default', _task('t_a2', title: 'Second of chat A'));
    sourceA.emit('default', [
      {'id': 11, 'task_id': 't_a2', 'kind': 'created'},
    ]);
    await tester.pump();
    await _open(
      tester,
      session: 'chat-b',
      remote: remote,
      controller: controller,
      kanban: TestChatKanban(source: () => sourceB),
    );
    expect(sourceA.closed, isTrue);
    expect(sourceA.watching, isEmpty);
    expect(find.byKey(_dock), findsNothing);

    hold.complete();
    await tester.pumpAndSettle();
    expect(find.byKey(_dock), findsNothing);
    expect(find.text('Card of chat A'), findsNothing);
    expect(sourceB.requests, contains('board:default'));
    expect(tester.takeException(), isNull);
    await _close(tester);
  });

  testWidgets('reopening a chat restores its rows from history; finished '
      'cards are dimmed until dismissed', (tester) async {
    tester.view.physicalSize = const Size(412, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final source = FakeKanbanSource()
      ..put(
        'default',
        _task('t_1', title: 'Still going', status: 'running', session: null),
      )
      ..put(
        'ops-board',
        _task('t_2', title: 'All finished', status: 'done', session: null),
      );
    final remote = _Remote()
      ..history = [
        {'id': 1, 'role': 'user', 'content': 'make two cards'},
        ...kanbanCreateRows(toolId: 'c1', taskId: 't_1', id: 2),
        ...kanbanCreateRows(
          toolId: 'c2',
          taskId: 't_2',
          board: 'ops-board',
          id: 4,
        ),
        {'id': 6, 'role': 'assistant', 'content': 'Both are on the board.'},
      ];
    final controller = GatewayTurnApplicationController();
    addTearDown(controller.close);
    await _open(
      tester,
      session: 'chat-a',
      remote: remote,
      controller: controller,
      kanban: TestChatKanban(source: () => source),
    );
    expect(remote.submissions, 0);
    expect(
      find.text('${_en.ng_dock_kanban(2)} · ${_en.ng_dock_kanban_done(1)}'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    expect(_meta(tester, 't_1'), 'Running · @builder');
    expect(_meta(tester, 't_2'), 'Done · @builder');

    final tokens = HermesTokens.of(tester.element(find.byKey(_dock)));
    Color? ink(String id) => tester
        .widget<Text>(find.byKey(ValueKey('kanban-dock-title-$id')))
        .style
        ?.color;
    expect(ink('t_1'), tokens.onSurface);
    expect(ink('t_2'), tokens.muted, reason: 'a finished card is dimmed');
    expect(find.byKey(const ValueKey('kanban-dock-dismiss-t_1')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('kanban-dock-dismiss-t_2')));
    await tester.pumpAndSettle();
    expect(_row('t_2'), findsNothing);
    expect(_row('t_1'), findsOneWidget);
    expect(find.text(_en.ng_dock_kanban(1)), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _close(tester);
  });

  testWidgets('a connection with no dashboard shows the rows and the reason; '
      'a tap explains instead of doing nothing', (tester) async {
    tester.view.physicalSize = const Size(412, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final remote = _Remote()
      ..history = [
        {'id': 1, 'role': 'user', 'content': 'make a card'},
        ...kanbanCreateRows(toolId: 'c1', taskId: 't_1', id: 2),
        {'id': 4, 'role': 'assistant', 'content': 'Done.'},
      ];
    final controller = GatewayTurnApplicationController();
    addTearDown(controller.close);
    // An API-server connection: no dashboard, so no board transport at all.
    await _open(
      tester,
      session: 'chat-a',
      remote: remote,
      controller: controller,
      live: false,
    );
    expect(find.text(_en.ng_dock_kanban(1)), findsOneWidget);
    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    expect(_meta(tester, 't_1'), 'Ready · @builder');
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('kanban-dock-reason')))
          .data,
      _en.ng_kanban_block_no_dashboard,
    );

    await tester.tap(_row('t_1'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(KanbanBoardScreen), findsNothing);
    expect(
      find.descendant(
        of: find.byType(SnackBar),
        matching: find.text(_en.ng_kanban_block_no_dashboard),
      ),
      findsOneWidget,
    );
    expect(_row('t_1'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _close(tester);
  });

  for (final keyboard in [260.0, 340.0]) {
    testWidgets('320x640 at 2.0x text with a ${keyboard.round()} px '
        'keyboard: the open Kanban strip leaves the composer above it', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final source = FakeKanbanSource();
      for (var i = 1; i <= 6; i++) {
        source.put(
          'default',
          _task(
            't_$i',
            title: 'Verify platform $i of the release checklist end to end',
            status: i.isEven ? 'done' : 'running',
          ),
        );
      }
      final remote = _Remote();
      final controller = GatewayTurnApplicationController();
      addTearDown(controller.close);
      await _open(
        tester,
        session: 'chat-a',
        remote: remote,
        controller: controller,
        kanban: TestChatKanban(source: () => source),
        textScale: 2,
      );
      await tester.ensureVisible(find.byKey(_toggle));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_toggle));
      await tester.pumpAndSettle();
      expect(_row('t_1'), findsOneWidget);
      expect(tester.takeException(), isNull);

      final field = find.byKey(const Key('chat-message-composer'));
      tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
      await tester.pumpAndSettle();
      await tester.enterText(field, 'typed with the cards open');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final keyboardTop = 640 - keyboard;
      expect(
        tester.getRect(find.byTooltip('Send')).bottom,
        lessThanOrEqualTo(keyboardTop),
      );
      expect(tester.getRect(field).bottom, lessThanOrEqualTo(keyboardTop));
      expect(field.hitTestable(), findsOneWidget);
      expect(find.text('typed with the cards open'), findsOneWidget);
      // The rows keep to their share and scroll; the composer keeps its own.
      final rows = tester.getRect(
        find
            .descendant(
              of: find.byKey(_dock),
              matching: find.byType(SingleChildScrollView),
            )
            .first,
      );
      expect(rows.height, lessThanOrEqualTo(keyboardTop * 0.25 + 1));

      tester.view.viewInsets = const FakeViewPadding();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await _close(tester);
    });
  }
}
