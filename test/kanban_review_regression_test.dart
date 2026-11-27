// Regression tests cut from the independent review of v5/bots @ d74ba224
// (evidence/bots-review-d74ba224, probes K1-K6). Each test failed on the
// reviewed code and names the probe it replaces.
import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/kanban_review_fixture.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<KanbanReviewApi> openRunningCard(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final api = KanbanReviewApi();
    final owner = kanbanReviewOwner(api.client);
    addTearDown(owner.close);
    await tester.pumpWidget(kanbanReviewApp(owner));
    await kanbanShown(tester, find.byKey(const Key('kanban-card-t_run_1')));
    await tester.tap(find.byKey(const Key('kanban-card-t_run_1')));
    await kanbanShown(tester, find.byKey(const Key('kanban-detail-decompose')));
    await tester.ensureVisible(
      find.byKey(const Key('kanban-detail-decompose')),
    );
    return api;
  }

  group('K3 decompose result (plugin_api.py:1600-1607)', () {
    testWidgets('child_ids are counted', (tester) async {
      final api = await openRunningCard(tester);
      await tester.tap(find.byKey(const Key('kanban-detail-decompose')));
      await kanbanStep(tester);
      expect(api.count('POST', '/tasks/t_run_1/decompose'), 1);
      expect(find.text('Decomposed into 3 child tasks'), findsWidgets);
      expect(find.textContaining('0 child'), findsNothing);
    });

    testWidgets('ok:false shows the reason as an error, not a success', (
      tester,
    ) async {
      final api = await openRunningCard(tester);
      api.decomposeReply = {
        'ok': false,
        'task_id': 't_run_1',
        'reason': 'auxiliary client unavailable',
        'fanout': false,
        'child_ids': <String>[],
        'new_title': null,
      };
      await tester.tap(find.byKey(const Key('kanban-detail-decompose')));
      await kanbanStep(tester);
      expect(find.textContaining('auxiliary client unavailable'), findsWidgets);
      expect(find.textContaining('Decomposed into'), findsNothing);
      // The sheet keeps the refusal on screen in its error line too.
      expect(find.byKey(const Key('kanban-detail-error')), findsOneWidget);
    });

    testWidgets('ok without fan-out says no child tasks were created', (
      tester,
    ) async {
      final api = await openRunningCard(tester);
      api.decomposeReply = {
        'ok': true,
        'task_id': 't_run_1',
        'reason': 'single task; title tightened',
        'fanout': false,
        'child_ids': <String>[],
        'new_title': 'Tighter title',
      };
      await tester.tap(find.byKey(const Key('kanban-detail-decompose')));
      await kanbanStep(tester);
      expect(find.textContaining('single task; title tightened'), findsWidgets);
      expect(find.textContaining('Decomposed into'), findsNothing);
      expect(find.byKey(const Key('kanban-detail-error')), findsNothing);
    });
  });

  group('destructive Kanban actions ask first; Cancel sends nothing', () {
    Future<KanbanReviewApi> openBoard(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final api = KanbanReviewApi();
      final owner = kanbanReviewOwner(api.client);
      addTearDown(owner.close);
      await tester.pumpWidget(kanbanReviewApp(owner));
      await kanbanShown(tester, find.byKey(const Key('kanban-card-t_ready_0')));
      await kanbanStep(tester);
      return api;
    }

    final dialog = find.byKey(const Key('kanban-confirm-dialog'));
    Future<void> answer(WidgetTester tester, {required bool ok}) async {
      expect(dialog, findsOneWidget);
      await tester.tap(
        find.byKey(Key(ok ? 'kanban-confirm-ok' : 'kanban-confirm-cancel')),
      );
      await kanbanStep(tester);
      expect(dialog, findsNothing);
    }

    List<Map<String, dynamic>?> bulks(KanbanReviewApi api) => [
      for (final c in api.calls)
        if (c.path.endsWith('/tasks/bulk')) c.body,
    ];

    Future<void> selectTwo(WidgetTester tester) async {
      await tester.longPress(find.byKey(const Key('kanban-card-t_ready_0')));
      await kanbanStep(tester);
      await tester.tap(find.byKey(const Key('kanban-card-t_ready_1')));
      await kanbanStep(tester);
      expect(find.text('2 selected'), findsOneWidget);
    }

    testWidgets('K1 archive board', (tester) async {
      final api = await openBoard(tester);
      await tester.tap(find.byKey(const Key('kanban-board-switcher')));
      await kanbanStep(tester);
      Future<void> pickArchive() async {
        await tester.tap(find.byKey(const Key('kanban-board-menu-ops-board')));
        await kanbanStep(tester);
        await tester.tap(find.text('Archive board'));
        await kanbanStep(tester);
      }

      await pickArchive();
      expect(find.textContaining('Archive board ops-board?'), findsOneWidget);
      expect(api.count('DELETE', '/boards/ops-board'), 0);
      await answer(tester, ok: false);
      expect(api.count('DELETE', '/boards/ops-board'), 0);
      await pickArchive();
      await answer(tester, ok: true);
      expect(api.count('DELETE', '/boards/ops-board'), 1);
    });

    testWidgets('K2 bulk move, bulk archive and bulk assign', (tester) async {
      final api = await openBoard(tester);
      await selectTwo(tester);

      Future<void> pickMove() async {
        await tester.tap(find.byKey(const Key('kanban-bulk-move')));
        await kanbanStep(tester);
        await tester.tap(find.text('Move to Triage').last);
        await kanbanStep(tester);
      }

      await pickMove();
      expect(find.text('Move 2 cards to Triage?'), findsOneWidget);
      await answer(tester, ok: false);
      expect(bulks(api), isEmpty);
      expect(find.text('2 selected'), findsOneWidget);
      await pickMove();
      await answer(tester, ok: true);
      expect(bulks(api).single, {
        'ids': ['t_ready_0', 't_ready_1'],
        'status': 'triage',
      });

      await selectTwo(tester);
      await tester.tap(find.byKey(const Key('kanban-bulk-archive')));
      await kanbanStep(tester);
      expect(find.text('Archive 2 cards?'), findsOneWidget);
      await answer(tester, ok: false);
      expect(bulks(api), hasLength(1));
      await tester.tap(find.byKey(const Key('kanban-bulk-archive')));
      await kanbanStep(tester);
      await answer(tester, ok: true);
      expect(bulks(api).last, containsPair('archive', true));

      await selectTwo(tester);
      Future<void> pickAssign() async {
        await tester.tap(find.byKey(const Key('kanban-bulk-assign')));
        await kanbanStep(tester);
        await tester.tap(find.text('@reviewer').last);
        await kanbanStep(tester);
      }

      await pickAssign();
      expect(find.text('Assign 2 cards to @reviewer?'), findsOneWidget);
      expect(find.textContaining('workers are stopped'), findsOneWidget);
      await answer(tester, ok: false);
      expect(bulks(api), hasLength(2));
      await pickAssign();
      await answer(tester, ok: true);
      expect(bulks(api).last, containsPair('assignee', 'reviewer'));
      expect(bulks(api).last, containsPair('reclaim_first', true));
    });

    testWidgets('K3 requeue, and reassigning a running card', (tester) async {
      final api = await openRunningCard(tester);
      Future<void> pickRequeue() async {
        await tester.ensureVisible(
          find.byKey(const Key('kanban-detail-reclaim')),
        );
        await tester.tap(find.byKey(const Key('kanban-detail-reclaim')));
        await kanbanStep(tester);
      }

      await pickRequeue();
      expect(find.text('Requeue t_run_1?'), findsOneWidget);
      await answer(tester, ok: false);
      expect(api.count('POST', '/tasks/t_run_1/reclaim'), 0);
      await pickRequeue();
      await answer(tester, ok: true);
      expect(api.count('POST', '/tasks/t_run_1/reclaim'), 1);

      Future<void> pickReviewer() async {
        await tester.tap(find.byKey(const Key('kanban-detail-assignee')));
        await kanbanStep(tester);
        await tester.tap(find.text('@reviewer').last);
        await kanbanStep(tester);
      }

      await pickReviewer();
      expect(find.text('Reassign t_run_1 to @reviewer?'), findsOneWidget);
      await answer(tester, ok: false);
      expect(api.count('POST', '/tasks/t_run_1/reassign'), 0);
      // The dropdown is back on the assignee the card still has.
      expect(
        find.descendant(
          of: find.byKey(const Key('kanban-detail-assignee')),
          matching: find.text('@work'),
        ),
        findsOneWidget,
      );
      await pickReviewer();
      await answer(tester, ok: true);
      final reassign = api.calls.singleWhere(
        (c) => c.path.endsWith('/tasks/t_run_1/reassign'),
      );
      expect(reassign.body, containsPair('profile', 'reviewer'));
      expect(reassign.body, containsPair('reclaim_first', true));
    });
  });

  group('K6 live events', () {
    late KanbanEventsServer events;

    /// `board:id,id` per batch the board passed on.
    late List<String> delivered;

    Future<KanbanReviewApi> openLive(
      WidgetTester tester,
      Future<void> Function(WebSocket socket, Uri uri, int index) onSocket,
    ) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      events = await KanbanEventsServer.start(tester);
      events.onSocket = onSocket;
      delivered = [];
      final api = KanbanReviewApi();
      final owner = kanbanReviewOwner(api.client, port: events.port);
      addTearDown(owner.close);
      await tester.pumpWidget(
        kanbanReviewApp(
          owner,
          live: true,
          onLiveEvents: (board, batch) =>
              delivered.add('$board:${batch.map((e) => e.id).join(',')}'),
        ),
      );
      return api;
    }

    Future<void> leave(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox());
      // dart:io waits up to 5 s for the server's close frame.
      await kanbanLive(tester, const Duration(seconds: 6));
      await events.close(tester);
    }

    testWidgets('a stream the server closes is dialled again from the last '
        'event seen; a repeated event is applied once', (tester) async {
      final api = await openLive(tester, (socket, uri, index) async {
        if (index == 0) {
          socket.add(
            kanbanEventsFrame([
              {'id': 13, 'task_id': 't_run_1', 'kind': 'heartbeat'},
            ], 13),
          );
        } else if (index == 1) {
          // Event 13 again (already seen), then a new one.
          socket.add(
            kanbanEventsFrame([
              {'id': 13, 'task_id': 't_run_1', 'kind': 'heartbeat'},
              {'id': 14, 'task_id': 't_run_1', 'kind': 'completed'},
            ], 14),
          );
        } else {
          return; // stays open
        }
        await Future<void>.delayed(const Duration(milliseconds: 40));
        await socket.close(WebSocketStatus.goingAway);
      });
      await kanbanLive(tester, const Duration(seconds: 6));
      expect(events.dials, [
        {'profile': 'work', 'since': '12'},
        {'profile': 'work', 'since': '13'},
        {'profile': 'work', 'since': '14'},
      ]);
      expect(events.open, hasLength(1));
      expect(delivered, ['default:13', 'default:14']);
      // Two batches, two debounced board reads; nothing else reloaded.
      expect(api.count('GET', '/plugins/kanban/board'), 1 + 2);
      expect(api.count('GET', '/plugins/kanban/profiles'), 1);
      await leave(tester);
    });

    testWidgets('a burst of frames is applied in one board read, not a full '
        'reload per frame', (tester) async {
      final api = await openLive(tester, (socket, uri, index) async {
        for (var id = 13; id < 18; id++) {
          socket.add(
            kanbanEventsFrame([
              {'id': id, 'task_id': 't_ready_0', 'kind': 'commented'},
            ], id),
          );
        }
      });
      await kanbanLive(tester, const Duration(seconds: 2));
      expect(delivered.join(';'), contains('default:13'));
      expect(
        delivered.map((d) => d.split(':').last).join(','),
        '13,14,15,16,17',
      );
      expect(api.count('GET', '/plugins/kanban/board'), 1 + 1);
      for (final path in ['/boards', '/profiles', '/projects']) {
        expect(api.count('GET', '/plugins/kanban$path'), 1, reason: path);
      }
      await leave(tester);
    });

    testWidgets('leaving the board closes its stream and dials nothing more', (
      tester,
    ) async {
      await openLive(tester, (socket, uri, index) async {});
      await kanbanLive(tester, const Duration(seconds: 1));
      expect(events.open, hasLength(1));
      await tester.pumpWidget(const SizedBox());
      await kanbanLive(tester, const Duration(seconds: 40));
      expect(events.open, isEmpty);
      expect(events.upgrades, hasLength(1));
      await events.close(tester);
    });

    testWidgets('a fast board switch does not leave the first board’s socket '
        'open', (tester) async {
      final api = KanbanReviewApi();
      final hold = Completer<void>();
      // The first board's ticket is slow: the switch lands before it.
      api.holds['POST /api/auth/ws-ticket'] = hold;
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      events = await KanbanEventsServer.start(tester);
      delivered = [];
      final owner = kanbanReviewOwner(api.client, port: events.port);
      addTearDown(owner.close);
      await tester.pumpWidget(kanbanReviewApp(owner, live: true));
      await kanbanShown(tester, find.byKey(const Key('kanban-card-t_ready_0')));
      await kanbanLive(tester, const Duration(milliseconds: 300));
      expect(api.count('POST', '/api/auth/ws-ticket'), 1);

      await tester.tap(find.byKey(const Key('kanban-board-switcher')));
      await kanbanStep(tester);
      await tester.tap(find.byKey(const Key('kanban-board-row-ops-board')));
      await kanbanStep(tester);
      await kanbanShown(tester, find.byKey(const Key('kanban-card-t_ops_0')));
      await kanbanLive(tester, const Duration(milliseconds: 500));
      hold.complete();
      await kanbanLive(tester, const Duration(seconds: 2));

      expect(events.upgrades, hasLength(2));
      expect(events.open.values.map((u) => u.queryParameters['board']), [
        'ops-board',
      ]);
      await leave(tester);
    });
  });

  testWidgets('a bulk action that finishes after a board switch leaves the '
      'new board’s selection alone', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final api = KanbanReviewApi();
    final owner = kanbanReviewOwner(api.client);
    addTearDown(owner.close);
    await tester.pumpWidget(kanbanReviewApp(owner));
    await kanbanShown(tester, find.byKey(const Key('kanban-card-t_ready_0')));
    await tester.longPress(find.byKey(const Key('kanban-card-t_ready_0')));
    await kanbanStep(tester);
    final hold = Completer<void>();
    api.holds['POST /api/plugins/kanban/tasks/bulk'] = hold;
    await tester.tap(find.byKey(const Key('kanban-bulk-archive')));
    await kanbanStep(tester);
    await tester.tap(find.byKey(const Key('kanban-confirm-ok')));
    await kanbanStep(tester);

    await tester.tap(find.byKey(const Key('kanban-board-switcher')));
    await kanbanStep(tester);
    await tester.tap(find.byKey(const Key('kanban-board-row-ops-board')));
    await kanbanShown(tester, find.byKey(const Key('kanban-card-t_ops_0')));
    await tester.longPress(find.byKey(const Key('kanban-card-t_ops_0')));
    await kanbanStep(tester);
    expect(find.text('1 selected'), findsOneWidget);

    hold.complete();
    await kanbanStep(tester);
    expect(find.text('1 selected'), findsOneWidget);
    expect(find.text('Archived selected cards'), findsNothing);
    final archived = api.calls.singleWhere(
      (c) => c.path.endsWith('/tasks/bulk'),
    );
    // It went to the board it was started on.
    expect(archived.query['board'], isNull);
    expect(archived.body?['ids'], ['t_ready_0']);
  });

  group('K4 touch: a swipe on a card scrolls, a long press drags', () {
    Future<KanbanReviewApi> open(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final api = KanbanReviewApi(readyCount: 25);
      final owner = kanbanReviewOwner(api.client);
      addTearDown(owner.close);
      await tester.pumpWidget(kanbanReviewApp(owner));
      await kanbanShown(tester, find.byKey(const Key('kanban-card-t_ready_0')));
      await kanbanStep(tester);
      return api;
    }

    Future<double> swipeUp(WidgetTester tester, Finder card) async {
      final list = find
          .ancestor(of: card, matching: find.byType(Scrollable))
          .first;
      // Held: the card itself scrolls out of the lazy list.
      final scroll = tester.state<ScrollableState>(list);
      final before = scroll.position.pixels;
      final gesture = await tester.startGesture(
        tester.getCenter(card),
        kind: PointerDeviceKind.touch,
      );
      for (var i = 0; i < 10; i++) {
        await gesture.moveBy(const Offset(0, -30));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 300));
      return scroll.position.pixels - before;
    }

    testWidgets('narrow (one column): the swipe scrolls the column', (
      tester,
    ) async {
      await open(tester, const Size(390, 700));
      // The card menu still moves a card.
      expect(find.byKey(const Key('kanban-move-t_ready_0')), findsOneWidget);
      final moved = await swipeUp(
        tester,
        find.byKey(const Key('kanban-card-t_ready_0')),
      );
      expect(moved, greaterThan(100));
    });

    testWidgets('wide: the swipe scrolls the column; long press, move and '
        'drop moves the card; long press alone selects it', (tester) async {
      final api = await open(tester, const Size(1280, 700));
      final card = find.byKey(const Key('kanban-card-t_ready_0'));
      final column = tester.state<ScrollableState>(
        find.ancestor(of: card, matching: find.byType(Scrollable)).first,
      );
      expect(await swipeUp(tester, card), greaterThan(100));
      column.position.jumpTo(0);
      await tester.pump();

      final from = tester.getCenter(card);
      final to = tester.getCenter(find.byKey(const Key('kanban-column-todo')));
      final gesture = await tester.startGesture(
        from,
        kind: PointerDeviceKind.touch,
      );
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
      for (var i = 1; i <= 10; i++) {
        await gesture.moveTo(Offset.lerp(from, to, i / 10)!);
        await tester.pump(const Duration(milliseconds: 16));
      }
      await gesture.up();
      await kanbanStep(tester);
      final patch = api.calls.singleWhere(
        (c) => c.method == 'PATCH' && c.path.endsWith('/tasks/t_ready_0'),
      );
      expect(patch.body, containsPair('status', 'todo'));

      await tester.longPress(find.byKey(const Key('kanban-card-t_ready_1')));
      await kanbanStep(tester);
      expect(find.text('1 selected'), findsOneWidget);
    });
  });
}
