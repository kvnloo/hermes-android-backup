// The Kanban dock's data: which cards belong to a chat, how their status
// stays live, and that nothing crosses chats. Fake transport only.
import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/chat_kanban_dock.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_kanban_source.dart';

ChatKanbanDockController _dock(
  FakeKanbanSource? source, {
  String connection = 'conn-a',
  String? profile = 'work',
  String? session = 'chat-a',
}) {
  final dock = ChatKanbanDockController(
    connectionId: connection,
    profile: profile,
    openSource: () => source,
  );
  addTearDown(dock.dispose);
  if (session != null) dock.setChat(primaryId: session);
  return dock;
}

Map<String, dynamic> _task(
  String id, {
  String title = 'Ship the dock',
  String status = 'ready',
  String? assignee = 'builder',
  String? session,
}) => {
  'id': id,
  'title': title,
  'status': status,
  'assignee': assignee,
  'session_id': session,
};

List<String> _ids(ChatKanbanDockController dock) => [
  for (final card in dock.cards) card.id,
];

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('tool calls', () {
    test('kanban_create yields the card the gateway answered with', () {
      final event = kanbanCreateEvent(
        toolId: 'call-1',
        taskId: 't_1a2b3c4d',
        board: 'ops-board',
      );
      final seeds = chatKanbanSeedsFromToolCall(
        name: 'kanban_create',
        args: event['args'],
        result: event['result'],
      );
      expect(seeds, hasLength(1));
      expect(seeds.single.taskId, 't_1a2b3c4d');
      expect(seeds.single.board, 'ops-board');
      expect(seeds.single.title, 'Ship the dock');
      expect(seeds.single.assignee, 'builder');
      expect(seeds.single.status, 'ready');
      expect(seeds.single.linked, isFalse);
    });

    test('arguments and results may be JSON text, and the name prefixed', () {
      final seeds = chatKanbanSeedsFromToolCall(
        name: 'mcp__hermes__kanban_create',
        args: jsonEncode({'title': 'From text', 'assignee': 'qa'}),
        result: jsonEncode({'ok': true, 'task_id': 't_text', 'status': 'todo'}),
      );
      expect(seeds.single.taskId, 't_text');
      expect(seeds.single.title, 'From text');
      expect(seeds.single.status, 'todo');
      expect(seeds.single.board, isNull);
    });

    test('a refused, running or foreign call yields nothing', () {
      expect(
        chatKanbanSeedsFromToolCall(
          name: 'kanban_create',
          args: const {'title': 'x'},
          result: const {'error': 'assignee is required'},
        ),
        isEmpty,
      );
      expect(
        chatKanbanSeedsFromToolCall(
          name: 'kanban_create',
          args: const {'title': 'x'},
          result: null,
        ),
        isEmpty,
      );
      expect(
        chatKanbanSeedsFromToolCall(
          name: 'kanban_create',
          args: const {'title': 'x'},
          result: const {'ok': true, 'task_id': '../etc/passwd'},
        ),
        isEmpty,
      );
      expect(
        chatKanbanSeedsFromToolCall(
          name: 'kanban_comment',
          args: const {'task_id': 't_1', 'body': 'hi'},
          result: const {'ok': true, 'task_id': 't_1'},
        ),
        isEmpty,
      );
    });

    test('kanban_link yields both cards, marked as linked', () {
      final seeds = chatKanbanSeedsFromToolCall(
        name: 'kanban_link',
        args: const {'parent_id': 't_parent', 'child_id': 't_child'},
        result: const {
          'ok': true,
          'parent_id': 't_parent',
          'child_id': 't_child',
          'gated': true,
        },
      );
      expect([for (final s in seeds) s.taskId], ['t_parent', 't_child']);
      expect(seeds.every((s) => s.linked), isTrue);
    });

    test('history rows join each call to its answer', () {
      final seeds = chatKanbanSeedsFromHistoryRows([
        {'id': 1, 'role': 'user', 'content': 'make two cards'},
        ...kanbanCreateRows(toolId: 'c1', taskId: 't_one', id: 2),
        ...kanbanCreateRows(
          toolId: 'c2',
          taskId: 't_two',
          title: 'Second',
          board: 'ops-board',
          id: 4,
        ),
        // A read of another tool with a look-alike result is not a card.
        {
          'id': 6,
          'role': 'assistant',
          'tool_calls': [
            {
              'id': 'c3',
              'function': {'name': 'kanban_show', 'arguments': '{}'},
            },
          ],
        },
        {
          'id': 7,
          'role': 'tool',
          'tool_call_id': 'c3',
          'content': '{"ok": true, "task_id": "t_shown"}',
        },
      ]);
      expect([for (final s in seeds) s.taskId], ['t_one', 't_two']);
      expect(seeds.last.title, 'Second');
      expect(seeds.last.board, 'ops-board');
    });
  });

  group('cards', () {
    test('a created card shows at once and the board confirms it', () async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_1', title: 'Board title', status: 'running'));
      final dock = _dock(source)..attach();
      await pumpEventQueue();

      final event = kanbanCreateEvent(toolId: 'c1', taskId: 't_1');
      dock.observeToolCall(
        name: 'kanban_create',
        args: event['args'],
        result: event['result'],
      );
      // Before any read: what the tool call said.
      expect(dock.cards.single.title, 'Ship the dock');
      expect(dock.cards.single.status, 'ready');
      expect(dock.cards.single.confirmed, isFalse);

      await pumpEventQueue();
      final card = dock.cards.single;
      expect(card.title, 'Board title');
      expect(card.status, 'running');
      expect(card.assignee, 'builder');
      expect(card.board, 'default');
      expect(card.confirmed, isTrue);
      expect(source.watching, {'default'});
      expect(source.requests, contains('watch:default@10'));
    });

    test('a status event updates the row; other cards do not', () async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_1', status: 'ready', session: 'chat-a'))
        ..put('default', _task('t_other', status: 'ready', session: 'chat-z'));
      final dock = _dock(source)..attach();
      await pumpEventQueue();
      expect(dock.cards.single.status, 'ready');
      final reads = source.count('board:default');

      // Someone else's card moves: not this dock's business.
      source.put(
        'default',
        _task('t_other', status: 'done', session: 'chat-z'),
      );
      source.emit('default', [
        {'id': 11, 'task_id': 't_other', 'kind': 'completed'},
      ]);
      await pumpEventQueue();
      expect(source.count('board:default'), reads);

      source.put('default', _task('t_1', status: 'blocked', session: 'chat-a'));
      source.emit('default', [
        {'id': 12, 'task_id': 't_1', 'kind': 'blocked'},
      ]);
      await pumpEventQueue();
      expect(dock.cards.single.status, 'blocked');
      expect(source.count('board:default'), reads + 1);
    });

    test('provenance finds this chat\'s cards and no one else\'s', () async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_mine', session: 'chat-a'))
        ..put('default', _task('t_theirs', session: 'chat-b'))
        ..put('default', _task('t_cli'));
      final mine = _dock(source)..attach();
      await pumpEventQueue();
      expect(_ids(mine), ['t_mine']);

      final other = _dock(
        FakeKanbanSource()..boards.addAll(source.boards),
        session: 'chat-b',
      )..attach();
      await pumpEventQueue();
      expect(_ids(other), ['t_theirs']);

      // A worker fans out under the same session: the new card appears.
      source.put('default', _task('t_child', session: 'chat-a'));
      source.emit('default', [
        {'id': 13, 'task_id': 't_child', 'kind': 'created'},
      ]);
      await pumpEventQueue();
      expect(_ids(mine), ['t_mine', 't_child']);
      expect(_ids(other), ['t_theirs']);
    });

    test('a resumed continuation id counts as the same chat', () async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_before', session: 'chat-a'))
        ..put('default', _task('t_after', session: 'chat-a-tip'));
      final dock = _dock(source)..attach();
      await pumpEventQueue();
      expect(_ids(dock), ['t_before']);
      dock.setChat(primaryId: 'chat-a', aliases: ['chat-a-tip', null, ' ']);
      await pumpEventQueue();
      expect(_ids(dock), ['t_before', 't_after']);
    });

    test('the transcript and provenance name one card once', () async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_1', session: 'chat-a'));
      final dock = _dock(source)..attach();
      await pumpEventQueue();
      expect(_ids(dock), ['t_1']);
      dock
        ..observeHistoryRows(kanbanCreateRows(toolId: 'c1', taskId: 't_1'))
        ..observeHistoryRows(kanbanCreateRows(toolId: 'c1', taskId: 't_1'));
      await pumpEventQueue();
      expect(_ids(dock), ['t_1']);
      // The board's word stands over the stored tool call.
      expect(dock.cards.single.confirmed, isTrue);
    });

    test('a card on a named board is read and followed there', () async {
      final source = FakeKanbanSource()
        ..put('ops-board', _task('t_ops', status: 'running'));
      final dock = _dock(source)..attach();
      dock.observeHistoryRows(
        kanbanCreateRows(toolId: 'c1', taskId: 't_ops', board: 'ops-board'),
      );
      await pumpEventQueue();
      expect(dock.cards.single.board, 'ops-board');
      expect(dock.cards.single.status, 'running');
      expect(source.watching, {'ops-board'});
      expect(dock.boardFor(dock.cards.single), 'ops-board');
    });

    test('finished cards stay, sorted last, until dismissed', () async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_done', status: 'done', session: 'chat-a'))
        ..put('default', _task('t_arch', status: 'archived', session: 'x'))
        ..put('default', _task('t_live', status: 'running', session: 'chat-a'));
      final dock = _dock(source)..attach();
      // The archived card is known from the transcript only.
      dock.observeHistoryRows(kanbanCreateRows(toolId: 'c9', taskId: 't_arch'));
      await pumpEventQueue();
      expect(_ids(dock), ['t_live', 't_arch', 't_done']);
      final archived = dock.cards[1];
      expect(archived.archived, isTrue);
      expect(archived.status, 'archived');
      expect(archived.settled, isTrue);
      // Only unfinished cards keep a stream open.
      expect(source.watching, {'default'});

      // An unfinished card cannot be dismissed.
      dock.dismiss(dock.cards.first);
      await pumpEventQueue();
      expect(_ids(dock), ['t_live', 't_arch', 't_done']);

      dock.dismiss(archived);
      await pumpEventQueue();
      expect(_ids(dock), ['t_live', 't_done']);
      // Show all still names every card of the chat.
      expect(dock.showAll.ids, {'t_live', 't_arch', 't_done'});
      expect(dock.showAll.board, 'default');
      expect(dock.showAll.archived, isTrue);

      // An archived card is not read again on every refresh.
      final reads = source.count('card:default/t_arch');
      await dock.refresh();
      expect(source.count('card:default/t_arch'), reads);
    });

    test('a dismissal is kept for the chat and lifted by a reopen', () async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_done', status: 'done', session: 'chat-a'));
      final first = _dock(source)..attach();
      await pumpEventQueue();
      first.dismiss(first.cards.single);
      await pumpEventQueue();
      expect(first.cards, isEmpty);

      // The same chat opened again: still dismissed.
      final again = _dock(FakeKanbanSource()..boards.addAll(source.boards))
        ..attach();
      await pumpEventQueue();
      expect(again.cards, isEmpty);

      // Another chat, connection or profile never inherits it.
      for (final (connection, profile, session) in [
        ('conn-a', 'work', 'chat-b'),
        ('conn-b', 'work', 'chat-a'),
        ('conn-a', 'home', 'chat-a'),
      ]) {
        final other = _dock(
          FakeKanbanSource()
            ..put('default', _task('t_done', status: 'done', session: session)),
          connection: connection,
          profile: profile,
          session: session,
        )..attach();
        await pumpEventQueue();
        expect(_ids(other), ['t_done'], reason: '$connection $profile');
      }

      // Reopened on the board: it is news again.
      source.put('default', _task('t_done', status: 'todo', session: 'chat-a'));
      await first.refresh();
      await pumpEventQueue();
      expect(_ids(first), ['t_done']);
      expect(first.cards.single.settled, isFalse);
    });

    test('a deleted card leaves the dock', () async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_1', session: 'chat-a'));
      final dock = _dock(source)..attach();
      await pumpEventQueue();
      expect(_ids(dock), ['t_1']);
      source.remove('default', 't_1');
      source.emit('default', [
        {'id': 20, 'task_id': 't_1', 'kind': 'deleted'},
      ]);
      await pumpEventQueue();
      expect(dock.cards, isEmpty);
      expect(source.watching, isEmpty);

      // The transcript still names it on every reload: it stays gone, and
      // nothing more is asked of the board for it.
      final reads = source.requests.length;
      dock.observeHistoryRows(kanbanCreateRows(toolId: 'c1', taskId: 't_1'));
      await pumpEventQueue();
      expect(dock.cards, isEmpty);
      expect(source.requests, hasLength(reads));
    });

    test('a linked card shows no status until the board reports one', () async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_parent', title: 'Parent', status: 'running'));
      final dock = _dock(source, session: null);
      dock.observeToolCall(
        name: 'kanban_link',
        args: const {'parent_id': 't_parent', 'child_id': 't_child'},
        result: const {
          'ok': true,
          'parent_id': 't_parent',
          'child_id': 't_child',
        },
      );
      await pumpEventQueue();
      expect(_ids(dock), ['t_parent', 't_child']);
      expect(dock.cards.every((card) => card.linked), isTrue);
      expect(dock.cards.first.status, isEmpty);
      expect(dock.cards.first.title, 't_parent');

      dock.attach();
      await pumpEventQueue();
      expect(dock.cards.first.title, 'Parent');
      expect(dock.cards.first.status, 'running');
      // Not on the current board, and no board was named: left as it is.
      expect(dock.cards.last.status, isEmpty);
      expect(dock.cards.last.confirmed, isFalse);
    });
  });

  group('owner', () {
    test('a late answer for a chat that left the screen is dropped', () async {
      final hold = Completer<void>();
      final source = FakeKanbanSource()
        ..hold = hold
        ..put('default', _task('t_1', session: 'chat-a'));
      final dock = _dock(source)..attach();
      await pumpEventQueue();
      expect(source.requests, ['boards', 'board:default']);

      dock.detach();
      expect(source.closed, isTrue);
      hold.complete();
      await pumpEventQueue();
      expect(dock.cards, isEmpty);
      expect(source.requests, isNot(contains('watch:default@10')));
      expect(dock.debugWatching, isFalse);
    });

    test('a disposed dock ignores what still arrives', () async {
      final hold = Completer<void>();
      final source = FakeKanbanSource()
        ..hold = hold
        ..put('default', _task('t_1', session: 'chat-a'));
      final dock = ChatKanbanDockController(
        connectionId: 'conn-a',
        profile: 'work',
        openSource: () => source,
      );
      var notified = 0;
      dock
        ..addListener(() => notified++)
        ..setChat(primaryId: 'chat-a')
        ..attach();
      await pumpEventQueue();
      dock.dispose();
      hold.complete();
      await pumpEventQueue();
      expect(notified, 0);
      expect(source.closed, isTrue);
    });

    test('leaving the screen ends the stream; coming back resumes', () async {
      final sources = <FakeKanbanSource>[];
      FakeKanbanSource open() {
        final source = FakeKanbanSource()
          ..put('default', _task('t_1', session: 'chat-a'));
        sources.add(source);
        return source;
      }

      final dock = ChatKanbanDockController(
        connectionId: 'conn-a',
        profile: 'work',
        openSource: open,
      )..setChat(primaryId: 'chat-a');
      addTearDown(dock.dispose);
      dock.attach();
      await pumpEventQueue();
      expect(sources.single.watching, {'default'});
      expect(dock.debugWatching, isTrue);

      dock.detach();
      await pumpEventQueue();
      expect(sources.single.watching, isEmpty);
      expect(sources.single.closed, isTrue);
      expect(dock.debugWatching, isFalse);
      // The row itself is kept for when the chat is shown again.
      expect(_ids(dock), ['t_1']);

      dock.attach();
      await pumpEventQueue();
      expect(sources, hasLength(2));
      expect(sources.last.watching, {'default'});
    });

    test('two docks on one chat share one read loop each', () async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_1', session: 'chat-a'));
      final dock = _dock(source)
        ..attach()
        ..attach();
      await pumpEventQueue();
      expect(source.count('board:default'), 1);
      dock.detach();
      await pumpEventQueue();
      expect(source.watching, {'default'});
      dock.detach();
      await pumpEventQueue();
      expect(source.watching, isEmpty);
    });
  });

  group('access', () {
    test('no dashboard: the rows stay and the reason is known', () async {
      final dock = _dock(null)..attach();
      dock.observeHistoryRows(kanbanCreateRows(toolId: 'c1', taskId: 't_1'));
      await pumpEventQueue();
      expect(_ids(dock), ['t_1']);
      expect(dock.cards.single.status, 'ready');
      expect(dock.block, ChatKanbanBlock.noDashboard);
      expect(dock.block!.refusesOpen, isTrue);
      expect(dock.debugWatching, isFalse);
    });

    test('no Kanban plugin: the rows stay and nothing is followed', () async {
      final source = FakeKanbanSource()..failure = WorkspaceFailure.unsupported;
      final dock = _dock(source)..attach();
      dock.observeHistoryRows(kanbanCreateRows(toolId: 'c1', taskId: 't_1'));
      await pumpEventQueue();
      expect(_ids(dock), ['t_1']);
      expect(dock.block, ChatKanbanBlock.unsupported);
      expect(dock.debugWatching, isFalse);

      // The plugin is enabled: the next read clears the reason.
      source
        ..failure = null
        ..put('default', _task('t_1', status: 'running'));
      await dock.refresh();
      await pumpEventQueue();
      expect(dock.block, isNull);
      expect(dock.cards.single.status, 'running');
    });

    test('each refusal maps to its reason', () async {
      for (final (failure, block) in [
        (WorkspaceFailure.denied, ChatKanbanBlock.denied),
        (WorkspaceFailure.insecure, ChatKanbanBlock.insecure),
        (WorkspaceFailure.stale, ChatKanbanBlock.stale),
        (WorkspaceFailure.mismatch, ChatKanbanBlock.stale),
        (WorkspaceFailure.unavailable, ChatKanbanBlock.unreachable),
        (WorkspaceFailure.invalid, ChatKanbanBlock.unreachable),
      ]) {
        final dock = _dock(FakeKanbanSource()..failure = failure)..attach();
        await pumpEventQueue();
        expect(dock.block, block, reason: failure.name);
      }
      expect(ChatKanbanBlock.unreachable.refusesOpen, isFalse);
    });

    test('the dock never reads while the chat\'s socket is down', () async {
      var online = false;
      final source = FakeKanbanSource()
        ..put('default', _task('t_1', status: 'running', session: 'chat-a'));
      final dock = ChatKanbanDockController(
        connectionId: 'conn-a',
        profile: 'work',
        openSource: () => source,
        online: () => online,
      )..setChat(primaryId: 'chat-a');
      addTearDown(dock.dispose);
      dock.attach();
      dock.observeHistoryRows(kanbanCreateRows(toolId: 'c1', taskId: 't_1'));
      await pumpEventQueue();
      // Nothing was asked of the gateway, and that is not a failure to show.
      expect(source.requests, isEmpty);
      expect(dock.block, isNull);
      expect(dock.debugWatching, isFalse);
      expect(_ids(dock), ['t_1']);
      dock.turnEnded();
      await pumpEventQueue();
      expect(source.requests, isEmpty);

      // The chat's socket came up and the chat said so.
      online = true;
      await dock.refresh();
      await pumpEventQueue();
      expect(source.requests, contains('board:default'));
      expect(dock.cards.single.status, 'running');
      expect(source.watching, {'default'});

      // No dashboard is still said while offline: it needs no request.
      final none = ChatKanbanDockController(
        connectionId: 'conn-a',
        profile: 'work',
        openSource: () => null,
        online: () => false,
      )..setChat(primaryId: 'chat-a');
      addTearDown(none.dispose);
      none.attach();
      await pumpEventQueue();
      expect(none.block, ChatKanbanBlock.noDashboard);
    });

    test('a chat with no session and no cards asks nothing', () async {
      final source = FakeKanbanSource();
      final dock = _dock(source, session: null)..attach();
      await pumpEventQueue();
      expect(source.requests, isEmpty);
      expect(dock.block, isNull);
      // A chat created just now has no cards to look for either.
      dock.setChat(primaryId: 'chat-new', discover: false);
      await pumpEventQueue();
      expect(source.requests, isEmpty);
    });
  });

  testWidgets('without an event stream the dock polls, never faster than '
      'the board screen', (tester) async {
    final source = FakeKanbanSource()
      ..streams = false
      ..put('default', _task('t_1', status: 'running', session: 'chat-a'));
    final dock = ChatKanbanDockController(
      connectionId: 'conn-a',
      profile: 'work',
      openSource: () => source,
    )..setChat(primaryId: 'chat-a');
    dock.attach();
    await tester.pump();
    await tester.pump();
    expect(dock.cards.single.status, 'running');
    expect(dock.pollInterval, const Duration(seconds: 15));
    final reads = source.count('board:default');

    await tester.pump(const Duration(seconds: 14));
    expect(source.count('board:default'), reads);
    source.put('default', _task('t_1', status: 'done', session: 'chat-a'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(source.count('board:default'), reads + 1);
    expect(dock.cards.single.status, 'done');

    // Nothing unfinished is left: the poll stops.
    await tester.pump(const Duration(seconds: 60));
    expect(source.count('board:default'), reads + 1);
    expect(dock.debugWatching, isFalse);

    // A turn that ends with no stream reads once.
    source.put('default', _task('t_1', status: 'todo', session: 'chat-a'));
    dock.turnEnded();
    await tester.pump();
    await tester.pump();
    expect(source.count('board:default'), reads + 1, reason: 'all settled');
    dock.dispose();
  });

  group('load (review of deb6f558, item 3)', () {
    ChatKanbanDockController followed(
      FakeKanbanSource source, {
      Duration pollInterval = const Duration(seconds: 15),
    }) => ChatKanbanDockController(
      connectionId: 'conn-a',
      profile: 'work',
      openSource: () => source,
      pollInterval: pollInterval,
    )..setChat(primaryId: 'chat-a');

    int dials(FakeKanbanSource source) =>
        source.requests.where((r) => r.startsWith('watch:')).length;

    testWidgets('frames within 300 ms share one read, of their own board '
        'only, and never GET /boards', (tester) async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_1', status: 'ready', session: 'chat-a'))
        ..put('ops-board', _task('t_ops', status: 'running'));
      final dock = followed(source)
        ..observeHistoryRows(
          kanbanCreateRows(toolId: 'c1', taskId: 't_ops', board: 'ops-board'),
        )
        ..attach();
      await tester.pump();
      await tester.pump();
      expect(source.watching, {'default', 'ops-board'});
      final boards = source.count('boards');
      final ops = source.count('board:ops-board');
      final own = source.count('board:default');

      // A burst of moves on the default board, 50 ms apart.
      for (final (i, status) in const [
        'running',
        'blocked',
        'running',
        'review',
        'done',
      ].indexed) {
        source.put('default', _task('t_1', status: status, session: 'chat-a'));
        source.emit('default', [
          {'id': 30 + i, 'task_id': 't_1', 'kind': 'status'},
        ]);
        await tester.pump(const Duration(milliseconds: 50));
      }
      // The first frame was read at once; the four after it wait for the
      // window to end.
      expect(source.count('board:default'), own + 1);
      expect(dock.cards.firstWhere((c) => c.id == 't_1').status, 'running');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();
      expect(source.count('board:default'), own + 2);
      expect(dock.cards.firstWhere((c) => c.id == 't_1').status, 'done');
      // Nothing else was read for them.
      expect(source.count('board:ops-board'), ops);
      expect(source.count('boards'), boards);

      // A frame on the other board reads that board only.
      await tester.pump(const Duration(seconds: 1));
      source.put('ops-board', _task('t_ops', status: 'blocked'));
      source.emit('ops-board', [
        {'id': 40, 'task_id': 't_ops', 'kind': 'blocked'},
      ]);
      await tester.pump();
      expect(source.count('board:ops-board'), ops + 1);
      expect(source.count('board:default'), own + 2);
      expect(source.count('boards'), boards);
      expect(dock.cards.firstWhere((c) => c.id == 't_ops').status, 'blocked');
      dock.dispose();
    });

    testWidgets('a frame naming a card missing from its board asks for that '
        'card only', (tester) async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_1', status: 'running', session: 'chat-a'))
        ..put('default', _task('t_2', status: 'running', session: 'chat-a'));
      final dock = followed(source)..attach();
      await tester.pump();
      await tester.pump();
      expect(_ids(dock), ['t_1', 't_2']);
      // Both leave the open board, but the frame names only one of them.
      source
        ..remove('default', 't_1')
        ..remove('default', 't_2');
      source.emit('default', [
        {'id': 30, 'task_id': 't_1', 'kind': 'deleted'},
      ]);
      await tester.pump();
      expect(source.requests, contains('card:default/t_1'));
      expect(source.requests, isNot(contains('card:default/t_2')));
      expect(_ids(dock), ['t_2']);
      dock.dispose();
    });

    testWidgets('a dropped stream is dialled again after 1, 2, 4 … 32 s from '
        'its cursor, as the board screen does', (tester) async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_1', status: 'running', session: 'chat-a'));
      final dock = followed(source, pollInterval: const Duration(hours: 1))
        ..attach();
      await tester.pump();
      await tester.pump();
      expect(source.requests.last, 'watch:default@10');
      // Someone else's card moves: the cursor follows, nothing is read.
      source.emit('default', [
        {'id': 11, 'task_id': 't_other', 'kind': 'commented'},
      ]);
      await tester.pump();
      final reads = source.requests.length;
      var dialled = dials(source);

      for (final wait in const [1, 2, 4, 8, 16, 32, 32]) {
        unawaited(source.drop('default'));
        await tester.pump();
        expect(source.watching, isEmpty);
        expect(dock.debugWatching, isTrue, reason: 'a re-dial is due');
        await tester.pump(Duration(seconds: wait) - const Duration(seconds: 1));
        await tester.pump(const Duration(milliseconds: 999));
        expect(dials(source), dialled, reason: 'not before $wait s');
        await tester.pump(const Duration(milliseconds: 1));
        await tester.pump();
        dialled++;
        expect(dials(source), dialled, reason: 'at $wait s');
        expect(source.requests.last, 'watch:default@11');
        expect(source.watching, {'default'});
      }
      // The stream replays from the cursor: no board was read meanwhile.
      expect(source.requests.length, reads + 7);

      // Open for 30 s: the next drop waits 1 s again.
      await tester.pump(const Duration(seconds: 30));
      unawaited(source.drop('default'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(dials(source), dialled + 1);
      expect(source.watching, {'default'});

      // Leaving the screen cancels a re-dial that is due.
      unawaited(source.drop('default'));
      await tester.pump();
      dock.detach();
      await tester.pump(const Duration(minutes: 2));
      expect(dials(source), dialled + 1);
      expect(dock.debugWatching, isFalse);
      dock.dispose();
    });

    testWidgets('while a dropped stream waits to be dialled again, the poll '
        'reads that board on its own', (tester) async {
      final source = FakeKanbanSource()
        ..put('default', _task('t_1', status: 'running', session: 'chat-a'));
      final dock = followed(
        source,
        pollInterval: const Duration(milliseconds: 600),
      )..attach();
      await tester.pump();
      await tester.pump();
      // Five drops: the next re-dial waits 32 s.
      for (final wait in const [1, 2, 4, 8, 16]) {
        unawaited(source.drop('default'));
        await tester.pump();
        await tester.pump(Duration(seconds: wait));
        await tester.pump();
      }
      expect(source.watching, {'default'});
      final boards = source.count('boards');
      final own = source.count('board:default');
      unawaited(source.drop('default'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
      expect(source.count('board:default'), own + 5);
      expect(source.count('boards'), boards);
      expect(source.watching, isEmpty);
      // Dialled again at 32 s: the poll stops.
      await tester.pump(const Duration(seconds: 29));
      await tester.pump();
      expect(source.watching, {'default'});
      final polled = source.count('board:default');
      await tester.pump(const Duration(seconds: 5));
      expect(source.count('board:default'), polled);
      dock.dispose();
    });
  });

  test('the dock keeps a bounded number of cards', () async {
    final dock = _dock(null);
    dock.observeSeeds([
      for (var i = 0; i < 260; i++)
        ChatKanbanSeed(taskId: 't_$i', status: i.isEven ? 'done' : 'ready'),
    ]);
    await pumpEventQueue();
    expect(dock.cards.length, 200);
    // Finished cards go first; the newest stay.
    expect(_ids(dock), contains('t_259'));
    expect(_ids(dock), isNot(contains('t_0')));
  });
}
