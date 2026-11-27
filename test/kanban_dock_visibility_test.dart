// The Kanban dock reads the board only while it is on screen
// (docs/kanban-chat-dock.md, "Live status"; review of deb6f558, PROBE A-L1
// NextGen, A-L2 Classic and the hidden-pane case). A route over the chat
// (the board the dock itself opens, on a phone) or a hidden pane of the
// Classic shell's IndexedStack lets go of the board's event stream; coming
// back follows it again after one read.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/kanban_board_screen.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/widgets/hermes_shell.dart';
import 'package:hermes_android/core/widgets/kanban_dock.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_kanban_source.dart';
import 'support/kanban_board_fixture.dart';
import 'support/kanban_dock_review_harness.dart';

/// The board reads one refresh makes: `GET /boards` and `GET /board`.
({int boards, int board}) _reads(FakeKanbanSource source) =>
    (boards: source.count('boards'), board: source.count('board:default'));

void main() {
  group('NextGen', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    testWidgets('A-L1: the board pushed from the dock (narrow) covers the '
        'chat: the dock stops following, and follows again after one read '
        'when the board is closed', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final gateway = NextGenGateway(ngDockConnection());
      final source = FakeKanbanSource()
        ..put('default', dockTask('t_1', status: 'running'));
      final board = KanbanBoardFixture(
        tasks: [dockTask('t_1', status: 'running')],
      );
      final chat = ngDockChat(gateway, 'chat-a', source)
        ..debugKanbanOwner = makeKanbanOwner(
          board.client,
          connectionId: gateway.connection.id,
        );
      await showNgDockChat(tester, gateway, chat);
      expect(source.watching, {'default'});
      await tester.tap(find.byKey(ngDockKanbanSection));
      await dockSettle(tester);
      await tester.tap(dockRow('t_1'));
      await dockShown(tester, find.byType(KanbanBoardScreen));
      await dockSettle(tester);
      expect(
        source.watching,
        isEmpty,
        reason: 'the board route covers the chat and opens its own stream',
      );
      expect(chat.kanban.debugWatching, isFalse);
      final before = _reads(source);

      // Back to the chat: one read, then the stream again.
      Navigator.of(
        tester.element(find.byType(KanbanBoardScreen)),
      ).popUntil((route) => route.isFirst);
      // The page transition out takes longer than one settle.
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byType(KanbanBoardScreen), findsNothing);
      expect(source.watching, {'default'});
      expect(_reads(source), (
        boards: before.boards + 1,
        board: before.board + 1,
      ));
      await closeNgDockChat(tester, gateway);
    });

    testWidgets('a sheet over the chat detaches the dock too; its rows stay', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final gateway = NextGenGateway(ngDockConnection());
      final source = FakeKanbanSource()
        ..put('default', dockTask('t_1', status: 'running'));
      final chat = ngDockChat(gateway, 'chat-a', source);
      await showNgDockChat(tester, gateway, chat);
      expect(source.watching, {'default'});
      final context = tester.element(find.byKey(ngDockKanbanSection));
      unawaited(
        showModalBottomSheet<void>(
          context: context,
          builder: (_) => const SizedBox(height: 200, child: Text('sheet')),
        ),
      );
      await dockSettle(tester);
      expect(source.watching, isEmpty);
      expect([for (final card in chat.kanban.cards) card.id], ['t_1']);
      Navigator.of(tester.element(find.text('sheet'))).pop();
      await dockSettle(tester);
      expect(source.watching, {'default'});
      await closeNgDockChat(tester, gateway);
    });

    testWidgets('a chat in a hidden IndexedStack pane lets go of the board', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final gateway = NextGenGateway(ngDockConnection());
      final source = FakeKanbanSource()
        ..put('default', dockTask('t_1', status: 'running'));
      final chat = ngDockChat(gateway, 'chat-a', source);
      final pane = ValueNotifier<int>(0);
      addTearDown(pane.dispose);
      await showNgDockChat(
        tester,
        gateway,
        chat,
        wrap: (view) => ValueListenableBuilder<int>(
          valueListenable: pane,
          builder: (_, index, _) => IndexedStack(
            index: index,
            children: [view, const Text('another pane')],
          ),
        ),
      );
      expect(source.watching, {'default'});
      pane.value = 1;
      await dockSettle(tester);
      expect(source.watching, isEmpty);
      final before = _reads(source);
      pane.value = 0;
      await dockSettle(tester);
      expect(source.watching, {'default'});
      expect(_reads(source), (
        boards: before.boards + 1,
        board: before.board + 1,
      ));
      await closeNgDockChat(tester, gateway);
    });

    testWidgets('A-O1: a tap whose refresh is still running when the user '
        'switches chat opens nothing', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final gateway = NextGenGateway(ngDockConnection());
      final board = KanbanBoardFixture(
        tasks: [dockTask('t_1', status: 'running')],
      );
      final sourceA = FakeKanbanSource()
        ..put('default', dockTask('t_1', status: 'running'))
        ..failure = WorkspaceFailure.unavailable;
      final chatA = ngDockChat(gateway, 'chat-a', sourceA)
        ..debugKanbanOwner = makeKanbanOwner(
          board.client,
          connectionId: gateway.connection.id,
        )
        ..debugApplyHistory([
          {'id': 1, 'role': 'user', 'content': 'make a card'},
          ...kanbanCreateRows(toolId: 'c1', taskId: 't_1', id: 2),
        ]);
      final chatB = ngDockChat(gateway, 'chat-b', FakeKanbanSource());
      await showNgDockChat(tester, gateway, chatA);
      expect(chatA.kanban.block, isNotNull);
      await tester.tap(find.byKey(ngDockKanbanSection));
      await dockSettle(tester);
      // The board answers again, slowly: the tap's re-ask is in flight.
      final hold = Completer<void>();
      sourceA
        ..failure = null
        ..hold = hold;
      await tester.tap(dockRow('t_1'));
      await tester.pump();
      await showNgDockChat(tester, gateway, chatB);
      hold.complete();
      await dockSettle(tester);
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await dockSettle(tester);
      expect(find.byType(KanbanBoardScreen), findsNothing);
      await closeNgDockChat(tester, gateway);
    });
  });

  group('Classic', () {
    setUp(
      () => SharedPreferences.setMockInitialValues({'verbose_mode': false}),
    );

    ClassicDockRemote remoteWithCard() => ClassicDockRemote()
      ..history = [
        {'id': 1, 'role': 'user', 'content': 'make a card'},
        ...kanbanCreateRows(toolId: 'c1', taskId: 't_1', id: 2),
        {'id': 4, 'role': 'assistant', 'content': 'Done.'},
      ];

    testWidgets('A-L2: the board pushed from the strip (narrow) covers the '
        'chat: the strip stops following, and follows again after one read '
        'when the board is closed', (tester) async {
      tester.view.physicalSize = const Size(412, 860);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final source = FakeKanbanSource()
        ..put('default', dockTask('t_1', status: 'running'));
      final board = KanbanBoardFixture(
        tasks: [dockTask('t_1', status: 'running')],
      );
      final owner = makeKanbanOwner(
        board.client,
        connectionId: classicDockConnection.id,
      );
      final controller = GatewayTurnApplicationController();
      addTearDown(controller.close);
      await openClassicDockChat(
        tester,
        session: 'chat-a',
        remote: remoteWithCard(),
        controller: controller,
        kanban: TestChatKanban(
          source: () => source..closed = false,
          owner: owner,
        ),
      );
      expect(source.watching, {'default'});
      await tester.tap(find.byKey(classicDockToggle));
      await tester.pumpAndSettle();
      await tester.tap(dockRow('t_1'));
      await dockShown(tester, find.byType(KanbanBoardScreen));
      await tester.pump(const Duration(milliseconds: 400));
      expect(source.watching, isEmpty);
      final before = _reads(source);

      Navigator.of(
        tester.element(find.byType(KanbanBoardScreen)),
      ).popUntil((route) => route.isFirst);
      await tester.pumpAndSettle();
      expect(find.byType(KanbanBoardScreen), findsNothing);
      expect(source.watching, {'default'});
      expect(_reads(source), (
        boards: before.boards + 1,
        board: before.board + 1,
      ));
      await closeClassicDockChat(tester);
    });

    testWidgets('a chat in a hidden pane of the Classic shell (IndexedStack) '
        'lets go of the board, and follows it again after one read', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(412, 860);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final source = FakeKanbanSource()
        ..put('default', dockTask('t_1', status: 'running'));
      final controller = GatewayTurnApplicationController();
      addTearDown(controller.close);
      final shell = GlobalKey<HermesShellState>();
      final remote = remoteWithCard();
      await openClassicDockChat(
        tester,
        session: 'chat-a',
        remote: remote,
        controller: controller,
        kanban: TestChatKanban(source: () => source..closed = false),
        theme: hermesTheme(Brightness.light),
        wrap: (chat) => HermesShell(
          key: shell,
          builder: (context, destination) =>
              destination == HermesDestination.chats
              ? chat
              : Center(child: Text(destination.name)),
        ),
      );
      expect(find.byKey(classicDockStrip), findsOneWidget);
      expect(source.watching, {'default'});

      final other = HermesDestination.values.firstWhere(
        (destination) => destination != HermesDestination.chats,
      );
      shell.currentState!.select(other);
      await tester.pumpAndSettle();
      // Still mounted (the shell keeps visited panes), but not on screen.
      expect(find.byKey(classicDockStrip, skipOffstage: false), findsOneWidget);
      expect(source.watching, isEmpty);
      final before = _reads(source);

      shell.currentState!.select(HermesDestination.chats);
      await tester.pumpAndSettle();
      expect(source.watching, {'default'});
      expect(_reads(source), (
        boards: before.boards + 1,
        board: before.board + 1,
      ));
      await closeClassicDockChat(tester);
    });
  });
}
