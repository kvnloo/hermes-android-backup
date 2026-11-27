import 'dart:async';

import 'package:hermes_android/core/services/chat_kanban_dock.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';

/// A Kanban board in memory: the fake transport behind a chat's dock. Tests
/// change cards with [put] and push the board's event stream with [emit].
class FakeKanbanSource implements ChatKanbanSource {
  FakeKanbanSource({this.current = 'default'});

  String current;

  /// Board slug -> task rows as the dashboard API serialises them.
  final Map<String, List<Map<String, dynamic>>> boards = {};

  /// Thrown by every read while set.
  WorkspaceFailure? failure;

  /// False: the host offers no event stream, so the dock must poll.
  bool streams = true;
  int latestEventId = 10;

  /// When set, board reads wait for it.
  Completer<void>? hold;

  /// Every request, in order: `boards`, `board:<slug>`, `card:<slug>/<id>`,
  /// `watch:<slug>@<since>`.
  final List<String> requests = [];
  final Map<String, StreamController<KanbanEventsFrame>> _watchers = {};
  bool closed = false;

  int count(String request) => requests.where((r) => r == request).length;

  /// Boards with an open event stream.
  Set<String> get watching => {
    for (final entry in _watchers.entries)
      if (entry.value.hasListener) entry.key,
  };

  void put(String board, Map<String, dynamic> task) {
    final rows = boards.putIfAbsent(board, () => []);
    rows.removeWhere((row) => row['id'] == task['id']);
    rows.add(task);
  }

  void remove(String board, String id) =>
      boards[board]?.removeWhere((row) => row['id'] == id);

  /// Pushes one frame of board events, as the gateway's event tail does.
  void emit(String board, List<Map<String, dynamic>> events) {
    latestEventId += events.length;
    _watchers[board]?.add(
      KanbanEventsFrame(
        events: [for (final event in events) KanbanEventRecord.fromJson(event)],
        cursor: latestEventId,
      ),
    );
  }

  /// Ends the event stream of [board], as a dropped socket does.
  Future<void> drop(String board) async => _watchers.remove(board)?.close();

  void _check() {
    if (closed) throw const WorkspaceException(WorkspaceFailure.stale);
    final failed = failure;
    if (failed != null) throw WorkspaceException(failed);
  }

  @override
  Future<String> currentBoard() async {
    requests.add('boards');
    _check();
    return current;
  }

  @override
  Future<KanbanBoardSnapshot> snapshot(String board) async {
    requests.add('board:$board');
    _check();
    await hold?.future;
    _check();
    final rows = boards[board] ?? const <Map<String, dynamic>>[];
    return KanbanBoardSnapshot.fromJson({
      'columns': [
        for (final column in kanbanWorkflowColumns)
          {
            'name': column,
            'tasks': [
              for (final row in rows)
                if (row['status'] == column) row,
            ],
          },
      ],
      'latest_event_id': latestEventId,
      'now': 1700000000,
    });
  }

  @override
  Future<KanbanTaskCard?> card(String board, String taskId) async {
    requests.add('card:$board/$taskId');
    _check();
    for (final row in boards[board] ?? const <Map<String, dynamic>>[]) {
      if (row['id'] == taskId) return KanbanTaskCard.fromJson(row);
    }
    return null;
  }

  @override
  Future<StreamSubscription<KanbanEventsFrame>?> watch(
    String board, {
    required int since,
    required void Function(KanbanEventsFrame frame) onFrame,
    void Function()? onClosed,
  }) async {
    requests.add('watch:$board@$since');
    _check();
    if (!streams) return null;
    final controller = StreamController<KanbanEventsFrame>();
    _watchers[board] = controller;
    return controller.stream.listen(onFrame, onDone: onClosed);
  }

  @override
  void close() => closed = true;
}

/// A `kanban_create` tool call as `tool.complete` carries it.
Map<String, dynamic> kanbanCreateEvent({
  required String toolId,
  required String taskId,
  String title = 'Ship the dock',
  String assignee = 'builder',
  String status = 'ready',
  String? board,
}) => {
  'tool_id': toolId,
  'name': 'kanban_create',
  'args': {'title': title, 'assignee': assignee, 'board': ?board},
  'result': {
    'ok': true,
    'task_id': taskId,
    'status': status,
    'workspace_kind': 'scratch',
    'workspace_path': null,
    'project_id': null,
    'gated': false,
    'subscribed': false,
  },
  'duration_s': 0.2,
};

/// The same call as two stored history rows.
List<Map<String, dynamic>> kanbanCreateRows({
  required String toolId,
  required String taskId,
  String title = 'Ship the dock',
  String assignee = 'builder',
  String status = 'ready',
  String? board,
  int id = 1,
}) => [
  {
    'id': id,
    'role': 'assistant',
    'content': '',
    'tool_calls': [
      {
        'id': toolId,
        'type': 'function',
        'function': {
          'name': 'kanban_create',
          'arguments':
              '{"title":"$title","assignee":"$assignee"'
              '${board == null ? '' : ',"board":"$board"'}}',
        },
      },
    ],
  },
  {
    'id': id + 1,
    'role': 'tool',
    'tool_call_id': toolId,
    'content':
        '{"ok": true, "task_id": "$taskId", "status": "$status", '
        '"gated": false, "subscribed": false}',
  },
];
