// Kanban cards in the NextGen chat dock (scope row KDK): rows for the cards
// a chat sent to Kanban, live status, and a tap that opens the board on the
// card. A fake gateway and a fake Kanban transport; no live gateway.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/kanban_board_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/data/session_control.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_kanban_source.dart';
import 'support/kanban_board_fixture.dart';

SavedConnection _connection() => SavedConnection(
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

final _en = lookupAppLocalizations(const Locale('en'));

Map<String, dynamic> _task(
  String id, {
  String title = 'Ship the dock',
  String status = 'ready',
  String? session = 'chat-a',
  String? board,
}) => {
  'id': id,
  'title': title,
  'status': status,
  'assignee': 'builder',
  'session_id': session,
  'board': ?board,
};

StreamEvent _ev(
  String type,
  String runtime, [
  Map<String, dynamic> data = const {},
]) => StreamEvent(type: type, data: data, sessionId: runtime);

NgChatController _chat(
  NextGenGateway gateway,
  String session,
  FakeKanbanSource? source,
) {
  final chat = NgChatController(gateway, sessionId: session)
    ..runtimeId = 'rt-$session'
    ..model = 'model-a';
  if (source != null) chat.debugKanbanSource = () => source;
  return chat;
}

Future<void> _show(
  WidgetTester tester,
  NextGenGateway gateway,
  NgChatController chat, {
  double textScale = 1,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
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
  await _settle(tester);
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 60));
  }
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

Future<void> _close(WidgetTester tester, NextGenGateway gateway) async {
  await tester.pumpWidget(const SizedBox());
  gateway.dispose();
  await tester.pump(const Duration(seconds: 30));
}

/// A 320x640 chat with its dock sections open and the keyboard up: where the
/// composer and dock end up, and how far anything overflowed.
Future<({Rect field, Rect dock, double overflow, bool reachable, bool typed})>
_withKeyboard(
  WidgetTester tester, {
  required bool kanban,
  required double scale,
  required double keyboard,
}) async {
  tester.view.physicalSize = const Size(320, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final gateway = NextGenGateway(_connection());
  final source = FakeKanbanSource();
  if (kanban) {
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
  }
  final chat = _chat(gateway, 'chat-a', source)
    ..control = NgSessionControl.parse({
      'revision': 'r1',
      'goal': {
        'title': 'Ship the release with every platform verified',
        'status': 'active',
        'turns_used': 4,
        'max_turns': 20,
      },
    })
    ..todos = NgTodoList.parse({
      'revision': 1,
      'todos': [
        for (var i = 0; i < 8; i++)
          {
            'id': '${i + 1}',
            'content': 'Step $i of the release checklist',
            'status': i < 3 ? 'completed' : 'pending',
          },
      ],
    })
    ..todosLive = true;
  var overflow = 0.0;
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final match = RegExp(
      r'overflowed by ([\d.]+) pixels',
    ).firstMatch(details.exceptionAsString());
    if (match == null) return previous?.call(details);
    final pixels = double.parse(match[1]!);
    if (pixels > overflow) overflow = pixels;
  };
  try {
    await _show(tester, gateway, chat, textScale: scale);
    expect(find.byKey(const ValueKey('ng-dock')), findsOneWidget);
    final field = find.byKey(const ValueKey('ng-composer-field'));
    await tester.tap(field, warnIfMissed: false);
    tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    for (final key in [
      'ng-dock-goal',
      'ng-dock-tasks',
      if (kanban) 'ng-dock-kanban',
    ]) {
      await tester.ensureVisible(find.byKey(ValueKey(key)));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.byKey(ValueKey(key)), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300));
    }
    if (kanban) {
      await tester.ensureVisible(_row('t_1'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(_row('t_1'), findsOneWidget);
    }
    final reachable = field.hitTestable().evaluate().isNotEmpty;
    var typed = false;
    if (reachable) {
      await tester.enterText(field, 'typed with the dock open');
      await tester.pump();
      typed = find.text('typed with the dock open').evaluate().isNotEmpty;
    }
    return (
      field: tester.getRect(field),
      dock: tester.getRect(find.byKey(const ValueKey('ng-dock'))),
      overflow: overflow,
      reachable: reachable,
      typed: typed,
    );
  } finally {
    tester.view.resetViewInsets();
    await _close(tester, gateway);
    FlutterError.onError = previous;
  }
}

const _section = ValueKey('ng-dock-kanban');
Finder _row(String id) => find.byKey(ValueKey('kanban-dock-card-$id'));
String _meta(WidgetTester tester, String id) =>
    tester.widget<Text>(find.byKey(ValueKey('kanban-dock-meta-$id'))).data!;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('kanban_create in a turn makes a row appear with its status, '
      'and a board event updates it', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final gateway = NextGenGateway(_connection());
    final source = FakeKanbanSource();
    final chat = _chat(gateway, 'chat-a', source);
    await _show(tester, gateway, chat);
    expect(find.byKey(_section), findsNothing);
    // A chat with nothing on the board keeps no stream open.
    expect(source.watching, isEmpty);

    source.put('default', _task('t_1', status: 'todo'));
    final call = kanbanCreateEvent(
      toolId: 'call-1',
      taskId: 't_1',
      status: 'todo',
    );
    gateway
      ..debugEmit(_ev('message.start', 'rt-chat-a'))
      ..debugEmit(
        _ev('tool.start', 'rt-chat-a', {
          'tool_id': 'call-1',
          'name': 'kanban_create',
          'args': call['args'],
        }),
      );
    await _settle(tester);
    // Still running: the gateway has not answered with a card yet.
    expect(find.byKey(_section), findsNothing);

    gateway.debugEmit(_ev('tool.complete', 'rt-chat-a', call));
    await _settle(tester);
    expect(find.byKey(_section), findsOneWidget);
    expect(find.text(_en.ng_dock_kanban(1)), findsOneWidget);

    await tester.tap(find.byKey(_section));
    await _settle(tester);
    expect(_row('t_1'), findsOneWidget);
    expect(find.text('Ship the dock'), findsWidgets);
    expect(_meta(tester, 't_1'), 'To do · @builder');
    expect(source.watching, {'default'});

    source.put('default', _task('t_1', status: 'running'));
    source.emit('default', [
      {'id': 11, 'task_id': 't_1', 'kind': 'claimed'},
    ]);
    await _settle(tester);
    expect(_meta(tester, 't_1'), 'Running · @builder');

    source.put('default', _task('t_1', status: 'blocked'));
    source.emit('default', [
      {'id': 12, 'task_id': 't_1', 'kind': 'blocked'},
    ]);
    await _settle(tester);
    expect(_meta(tester, 't_1'), 'Blocked · @builder');
    expect(tester.takeException(), isNull);
    await _close(tester, gateway);
    expect(source.watching, isEmpty);
  });

  testWidgets('the dock reads over the chat\'s own socket and never opens '
      'one itself', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final gateway = NextGenGateway(_connection());
    // No fake transport: the real one, over a gateway nobody started.
    final chat = _chat(gateway, 'chat-a', null)
      ..debugApplyHistory([
        {'id': 1, 'role': 'user', 'content': 'make a card'},
        ...kanbanCreateRows(toolId: 'c1', taskId: 't_1', id: 2),
      ]);
    await _show(tester, gateway, chat);
    // The row is there from the transcript; the gateway was left alone.
    expect(find.text(_en.ng_dock_kanban(1)), findsOneWidget);
    expect(gateway.state.phase, NgConnectionPhase.idle);
    expect(gateway.socket, isNull);
    expect(chat.kanban.block, isNull);
    await tester.pumpWidget(const SizedBox());
    gateway.dispose();
    // No reconnect timer was left behind: the test ends without draining.
  });

  testWidgets('a tap opens the board on that card, on the same connection '
      'and profile (narrow: the board\'s pushed route)', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final gateway = NextGenGateway(_connection());
    final source = FakeKanbanSource()
      ..put('default', _task('t_1', status: 'running'));
    final board = KanbanBoardFixture(
      tasks: [
        _task('t_1', status: 'running'),
        _task('t_other', title: 'Someone else', session: 'chat-z'),
      ],
    );
    final chat = _chat(gateway, 'chat-a', source)
      ..debugKanbanOwner = makeKanbanOwner(
        board.client,
        connectionId: gateway.connection.id,
      )
      ..debugApplyHistory([
        {'id': 1, 'role': 'user', 'content': 'make a card'},
        ...kanbanCreateRows(toolId: 'c1', taskId: 't_1', id: 2),
      ]);
    await _show(tester, gateway, chat);
    await tester.tap(find.byKey(_section));
    await _settle(tester);
    await tester.tap(_row('t_1'));
    await _shown(tester, find.byType(KanbanBoardScreen));

    final screen = tester.widget<KanbanBoardScreen>(
      find.byType(KanbanBoardScreen),
    );
    expect(screen.initialBoard, 'default');
    expect(screen.initialCardId, 't_1');
    expect(screen.initialCardFilter, isNull);
    expect(identical(screen.owner, chat.kanbanOwner), isTrue);
    expect(screen.route.connectionId, 'kanban-dock');
    expect(screen.route.profile, isNull);
    expect(screen.onClose, isNull, reason: 'a route, not a pane');
    expect(find.byKey(const ValueKey('kanban-pane')), findsNothing);

    // The card's detail sheet is open on the board.
    await _shown(tester, find.textContaining('t_1 · Running'));
    expect(find.text('Kanban · default'), findsOneWidget);
    expect(
      board.requests.where(
        (r) => r.startsWith('GET /api/plugins/kanban/tasks/t_1?'),
      ),
      isNotEmpty,
    );
    expect(tester.takeException(), isNull);
    await _close(tester, gateway);
  });

  testWidgets('wide: the board opens as a pane beside the chat; only five '
      'rows show and "show all" filters the board to this chat', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final gateway = NextGenGateway(_connection());
    final mine = [
      for (var i = 1; i <= 7; i++)
        _task(
          't_$i',
          title: 'Card number $i',
          status: i <= 4
              ? 'running'
              : i == 7
              ? 'archived'
              : 'done',
        ),
    ];
    final source = FakeKanbanSource();
    for (final task in mine) {
      source.put('default', task);
    }
    final board = KanbanBoardFixture(
      tasks: [
        ...mine,
        _task(
          't_other',
          title: 'Someone else',
          status: 'running',
          session: 'chat-z',
        ),
      ],
    );
    final chat = _chat(gateway, 'chat-a', source)
      ..debugKanbanOwner = makeKanbanOwner(
        board.client,
        connectionId: gateway.connection.id,
      )
      // The archived card is only known from the transcript.
      ..debugApplyHistory([
        {'id': 1, 'role': 'user', 'content': 'make cards'},
        ...kanbanCreateRows(toolId: 'c7', taskId: 't_7', id: 2),
      ]);
    await _show(tester, gateway, chat);
    expect(
      find.text('${_en.ng_dock_kanban(7)} · ${_en.ng_dock_kanban_done(3)}'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(_section));
    await _settle(tester);
    // Unfinished cards first; the rest wait behind "show all".
    for (final id in ['t_1', 't_2', 't_3', 't_4', 't_7']) {
      expect(_row(id), findsOneWidget, reason: id);
    }
    expect(_row('t_5'), findsNothing);
    expect(_row('t_6'), findsNothing);
    final showAll = find.byKey(const ValueKey('kanban-dock-show-all'));
    expect(find.text(_en.ng_kanban_show_all(7)), findsOneWidget);

    await tester.tap(showAll);
    await _shown(tester, find.byKey(const ValueKey('kanban-pane')));
    var screen = tester.widget<KanbanBoardScreen>(
      find.byType(KanbanBoardScreen),
    );
    expect(screen.initialCardFilter, {for (final task in mine) task['id']});
    expect(screen.initialBoard, 'default');
    expect(screen.initialIncludeArchived, isTrue);
    expect(screen.onClose, isNotNull);
    // The chat is still on screen beside the board.
    final field = find.byKey(const ValueKey('ng-composer-field'));
    expect(field.hitTestable(), findsOneWidget);
    final pane = tester.getRect(find.byKey(const ValueKey('kanban-pane')));
    expect(pane.right, 1280);
    expect(tester.getRect(field).right, lessThanOrEqualTo(pane.left));

    await _shown(tester, find.byKey(const Key('kanban-chat-filter')));
    expect(find.text(_en.ng_kanban_this_chat(7)), findsOneWidget);
    await _shown(tester, find.byKey(const Key('kanban-card-t_1')));
    // Running cards of this chat only: another chat's card is filtered out.
    expect(find.byKey(const Key('kanban-card-t_other')), findsNothing);

    await tester.tap(find.byKey(const Key('kanban-close')));
    await _settle(tester);
    expect(find.byKey(const ValueKey('kanban-pane')), findsNothing);
    expect(find.byType(KanbanBoardScreen), findsNothing);

    // A row opens the pane on its own card.
    await tester.tap(_row('t_2'));
    await _shown(tester, find.byKey(const ValueKey('kanban-pane')));
    screen = tester.widget<KanbanBoardScreen>(find.byType(KanbanBoardScreen));
    expect(screen.initialCardId, 't_2');
    expect(screen.initialCardFilter, isNull);
    await _shown(tester, find.textContaining('t_2 · Running'));
    expect(tester.takeException(), isNull);
    await _close(tester, gateway);
  });

  testWidgets('a card from another chat never shows, and a chat that is '
      'switched away from stops listening', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final gateway = NextGenGateway(_connection());
    final hold = Completer<void>();
    final sourceA = FakeKanbanSource()
      ..put('default', _task('t_a', title: 'Card of chat A'));
    // Chat B reads a board that holds chat A's card.
    final sourceB = FakeKanbanSource()
      ..put('default', _task('t_a', title: 'Card of chat A'))
      ..put('default', _task('t_a2', title: 'Second of chat A'));
    final chatA = _chat(gateway, 'chat-a', sourceA);
    final chatB = _chat(gateway, 'chat-b', sourceB);

    await _show(tester, gateway, chatA);
    expect(find.text(_en.ng_dock_kanban(1)), findsOneWidget);
    expect(sourceA.watching, {'default'});

    // Chat A has a board read in flight when the user switches to chat B.
    sourceA
      ..hold = hold
      ..put('default', _task('t_a2', title: 'Second of chat A'));
    unawaited(chatA.kanban.refresh());
    await tester.pump();
    await _show(tester, gateway, chatB);
    expect(sourceA.watching, isEmpty);
    expect(sourceA.closed, isTrue);
    expect(find.byKey(_section), findsNothing);

    // Chat A's turn keeps making cards; its late read comes back.
    gateway.debugEmit(
      _ev(
        'tool.complete',
        'rt-chat-a',
        kanbanCreateEvent(toolId: 'call-9', taskId: 't_a9'),
      ),
    );
    hold.complete();
    await _settle(tester);
    expect(find.byKey(_section), findsNothing);
    expect(find.text('Card of chat A'), findsNothing);
    expect(chatB.kanban.cards, isEmpty);
    // The late read was dropped; chat A only learnt of its own tool call.
    expect([for (final card in chatA.kanban.cards) card.id], ['t_a', 't_a9']);
    expect(sourceB.requests, isNot(contains('card:default/t_a')));
    expect(tester.takeException(), isNull);
    await _close(tester, gateway);
    expect(sourceB.closed, isTrue);
  });

  testWidgets('reopening a chat restores its rows from history; finished '
      'cards are dimmed until dismissed', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final gateway = NextGenGateway(_connection());
    final source = FakeKanbanSource()
      ..put('default', _task('t_1', title: 'Still going', status: 'running'))
      ..put(
        'ops-board',
        _task('t_2', title: 'All finished', status: 'done', session: null),
      );
    final history = [
      {'id': 1, 'role': 'user', 'content': 'make two cards'},
      ...kanbanCreateRows(toolId: 'c1', taskId: 't_1', id: 2),
      ...kanbanCreateRows(
        toolId: 'c2',
        taskId: 't_2',
        board: 'ops-board',
        id: 4,
      ),
    ];
    final chat = _chat(gateway, 'chat-a', source)..debugApplyHistory(history);
    await _show(tester, gateway, chat);
    expect(
      find.text('${_en.ng_dock_kanban(2)} · ${_en.ng_dock_kanban_done(1)}'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(_section));
    await _settle(tester);
    expect(_meta(tester, 't_1'), 'Running · @builder');
    expect(_meta(tester, 't_2'), 'Done · @builder');
    // Only the board with unfinished work is followed.
    expect(source.watching, {'default'});

    final colors = NgColors.of(tester.element(find.byKey(_section)));
    Color? ink(String id) => tester
        .widget<Text>(find.byKey(ValueKey('kanban-dock-title-$id')))
        .style
        ?.color;
    expect(ink('t_1'), colors.text);
    expect(ink('t_2'), colors.text3, reason: 'a finished card is dimmed');
    expect(find.byKey(const ValueKey('kanban-dock-dismiss-t_1')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('kanban-dock-dismiss-t_2')));
    await _settle(tester);
    expect(_row('t_2'), findsNothing);
    expect(_row('t_1'), findsOneWidget);
    expect(find.text(_en.ng_dock_kanban(1)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());

    // The same chat loaded again: the row is back, the dismissal kept.
    final reopened = FakeKanbanSource()..boards.addAll(source.boards);
    final again = _chat(gateway, 'chat-a', reopened)
      ..debugApplyHistory(history);
    await _show(tester, gateway, again);
    expect(find.text(_en.ng_dock_kanban(1)), findsOneWidget);
    await tester.tap(find.byKey(_section));
    await _settle(tester);
    expect(_row('t_1'), findsOneWidget);
    expect(_row('t_2'), findsNothing);
    expect(tester.takeException(), isNull);
    await _close(tester, gateway);
  });

  testWidgets('when the board cannot open, the reason is shown and the row '
      'stays: no dead tap', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final gateway = NextGenGateway(_connection());
    final source = FakeKanbanSource()..failure = WorkspaceFailure.unsupported;
    final chat = _chat(gateway, 'chat-a', source)
      ..debugApplyHistory([
        {'id': 1, 'role': 'user', 'content': 'make a card'},
        ...kanbanCreateRows(toolId: 'c1', taskId: 't_1', id: 2),
      ]);
    await _show(tester, gateway, chat);
    await tester.tap(find.byKey(_section));
    await _settle(tester);
    // What the tool call said, with why it is not live.
    expect(_meta(tester, 't_1'), 'Ready · @builder');
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('kanban-dock-reason')))
          .data,
      _en.ng_kanban_block_unsupported,
    );

    final reads = source.count('boards');
    await tester.tap(_row('t_1'));
    await _settle(tester);
    // The tap asked again before answering.
    expect(source.count('boards'), reads + 1);
    expect(find.byType(KanbanBoardScreen), findsNothing);
    expect(
      find.descendant(
        of: find.byType(SnackBar),
        matching: find.text(_en.ng_kanban_block_unsupported),
      ),
      findsOneWidget,
    );
    expect(_row('t_1'), findsOneWidget);

    // Each refusal has its own words.
    for (final (failure, reason) in [
      (WorkspaceFailure.denied, _en.ng_kanban_block_denied),
      (WorkspaceFailure.insecure, _en.ng_kanban_block_insecure),
      (WorkspaceFailure.unavailable, _en.ng_kanban_block_unreachable),
    ]) {
      source.failure = failure;
      unawaited(chat.kanban.refresh());
      await _settle(tester);
      expect(
        tester
            .widget<Text>(find.byKey(const ValueKey('kanban-dock-reason')))
            .data,
        reason,
      );
    }
    expect(tester.takeException(), isNull);
    await _close(tester, gateway);
  });

  testWidgets('320x640 with a 260 px keyboard: every section open, Kanban '
      'included, and the composer stays above the keyboard', (tester) async {
    final seen = await _withKeyboard(
      tester,
      kanban: true,
      scale: 1,
      keyboard: 260,
    );
    const keyboardTop = 640 - 260.0;
    expect(seen.overflow, 0);
    expect(seen.field.bottom, lessThanOrEqualTo(keyboardTop));
    expect(seen.reachable, isTrue);
    // The dock, Kanban rows and all, keeps to its share above the keyboard.
    expect(seen.dock.height, lessThanOrEqualTo(keyboardTop * 0.25 + 1));
    expect(seen.typed, isTrue);
  });

  // At 2.0x text the composer of this branch is itself taller than the room
  // a 320x640 window leaves above a keyboard (the composer lane owns that
  // fix). So the dock is held to this: the Kanban rows change nothing about
  // where the composer ends up, and wherever the composer fits without them
  // it fits with them.
  for (final keyboard in [260.0, 340.0]) {
    testWidgets('320x640 at 2.0x text with a ${keyboard.round()} px '
        'keyboard: Kanban rows never push the composer further down', (
      tester,
    ) async {
      final without = await _withKeyboard(
        tester,
        kanban: false,
        scale: 2,
        keyboard: keyboard,
      );
      final withRows = await _withKeyboard(
        tester,
        kanban: true,
        scale: 2,
        keyboard: keyboard,
      );
      final keyboardTop = 640 - keyboard;
      expect(withRows.dock.height, lessThanOrEqualTo(keyboardTop * 0.25 + 1));
      expect(withRows.dock.height, lessThanOrEqualTo(without.dock.height + 1));
      expect(
        withRows.field.bottom,
        lessThanOrEqualTo(without.field.bottom + 0.5),
        reason: 'the Kanban rows pushed the composer down',
      );
      expect(withRows.overflow, lessThanOrEqualTo(without.overflow + 0.5));
      if (without.overflow == 0 && without.field.bottom <= keyboardTop) {
        expect(withRows.overflow, 0);
        expect(withRows.field.bottom, lessThanOrEqualTo(keyboardTop));
        expect(withRows.reachable, isTrue);
      }
    });
  }

  testWidgets('a narrow chat (320 px) opens the card as the board\'s pushed '
      'route, never a pane', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final gateway = NextGenGateway(_connection());
    final source = FakeKanbanSource()
      ..put('default', _task('t_1', status: 'running'));
    final board = KanbanBoardFixture(tasks: [_task('t_1', status: 'running')]);
    final chat = _chat(gateway, 'chat-a', source)
      ..debugKanbanOwner = makeKanbanOwner(
        board.client,
        connectionId: gateway.connection.id,
      );
    await _show(tester, gateway, chat);
    await tester.tap(find.byKey(_section));
    await _settle(tester);
    await tester.tap(_row('t_1'));
    await _shown(tester, find.byType(KanbanBoardScreen));
    expect(find.byKey(const ValueKey('kanban-pane')), findsNothing);
    final screen = tester.widget<KanbanBoardScreen>(
      find.byType(KanbanBoardScreen),
    );
    expect(screen.initialCardId, 't_1');
    expect(screen.onClose, isNull);
    await _shown(tester, find.textContaining('t_1 · Running'));
    expect(tester.takeException(), isNull);
    await _close(tester, gateway);
  });

  test('every dock string is translated in every locale', () {
    final dir = Directory('lib/l10n');
    Map<String, dynamic> arb(String name) =>
        jsonDecode(File('${dir.path}/$name').readAsStringSync())
            as Map<String, dynamic>;
    final en = arb('app_en.arb');
    final keys = [
      for (final key in en.keys)
        if (key.startsWith('ng_kanban_') ||
            key.startsWith('ng_dock_kanban') ||
            key == 'ng_show_kanban' ||
            key == 'ng_hide_kanban')
          key,
    ];
    expect(keys, hasLength(23));
    final files = [
      for (final file in dir.listSync().whereType<File>())
        if (file.path.endsWith('.arb') && !file.path.endsWith('app_en.arb'))
          file.uri.pathSegments.last,
    ];
    expect(files.length, greaterThanOrEqualTo(13));
    for (final file in files) {
      final other = arb(file);
      for (final key in keys) {
        final value = other[key];
        expect(value, isA<String>(), reason: '$file $key');
        expect((value as String).trim(), isNotEmpty, reason: '$file $key');
        expect(value, isNot(en[key]), reason: '$file $key is still English');
      }
    }
  });
}
