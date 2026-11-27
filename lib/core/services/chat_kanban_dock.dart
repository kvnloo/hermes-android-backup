/// The Kanban cards one chat sent to the board, for the dock above its
/// composer. See docs/kanban-chat-dock.md.
///
/// Two sources, joined by board and task id:
///  1. the chat's own `kanban_create` / `kanban_link` tool calls (live events
///     and stored history rows), and
///  2. Hermes provenance: the board API returns each task's `session_id`, the
///     session whose agent loop created it.
///
/// One controller belongs to one chat on one connection and profile. It reads
/// through that chat's own [RemoteWorkspaceOwner] only while a dock is on
/// screen, and every answer is checked against the request's epoch before it
/// is applied, so a late result for a chat that was closed or switched away
/// from is dropped.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'connection_manager.dart' show KanbanBoardNotFoundException;
import 'remote_workspace.dart';

final _taskIdShape = RegExp(r'^[A-Za-z0-9][A-Za-z0-9_.:-]{0,127}$');
final _boardShape = RegExp(r'^[a-z0-9][a-z0-9_-]{0,63}$');

/// Which Kanban tool [name] is, when it creates or links a card: `create`,
/// `link`, or null for every other tool. A toolset or server prefix
/// (`mcp__hermes__kanban_create`) names the same tool.
String? chatKanbanToolKind(String name) {
  final bare = name.trim().toLowerCase();
  final cut = bare.lastIndexOf('__');
  final leaf = cut < 0 ? bare : bare.substring(cut + 2);
  return switch (leaf) {
    'kanban_create' => 'create',
    'kanban_link' => 'link',
    _ => null,
  };
}

/// One card as a tool call of this chat reported it.
@immutable
class ChatKanbanSeed {
  const ChatKanbanSeed({
    required this.taskId,
    this.board,
    this.title,
    this.assignee,
    this.status,
    this.linked = false,
  });

  final String taskId;

  /// The board the call named. Null when it named none: the gateway then
  /// used the board that was current at the time.
  final String? board;
  final String? title;
  final String? assignee;
  final String? status;

  /// Linked by this chat (`kanban_link`) rather than created by it.
  final bool linked;
}

Map<String, dynamic>? _jsonMap(Object? raw) {
  Object? value = raw;
  if (value is List) {
    // Content parts: the text of the first part that parses.
    for (final part in value) {
      final text = part is Map ? part['text'] : part;
      final parsed = _jsonMap(text);
      if (parsed != null) return parsed;
    }
    return null;
  }
  if (value is String) {
    final text = value.trim();
    if (!text.startsWith('{')) return null;
    try {
      value = jsonDecode(text);
    } catch (_) {
      return null;
    }
  }
  if (value is! Map) return null;
  return {
    for (final entry in value.entries)
      if (entry.key is String) entry.key as String: entry.value,
  };
}

String? _text(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String? _taskId(Object? value) {
  final id = _text(value);
  return id != null && _taskIdShape.hasMatch(id) ? id : null;
}

String? _board(Object? value) {
  final slug = _text(value);
  return slug != null && _boardShape.hasMatch(slug) ? slug : null;
}

/// The cards a finished Kanban tool call made or linked. Nothing for another
/// tool, a call still running, or a refused one: a card appears only once the
/// gateway has answered with its id.
List<ChatKanbanSeed> chatKanbanSeedsFromToolCall({
  required String name,
  Object? args,
  Object? result,
}) {
  final kind = chatKanbanToolKind(name);
  if (kind == null) return const [];
  final answer = _jsonMap(result);
  if (answer == null ||
      answer['ok'] == false ||
      answer['success'] == false ||
      answer['error'] != null) {
    return const [];
  }
  final call = _jsonMap(args) ?? const <String, dynamic>{};
  final board = _board(answer['board']) ?? _board(call['board']);
  if (kind == 'create') {
    final id = _taskId(answer['task_id']);
    if (id == null) return const [];
    return [
      ChatKanbanSeed(
        taskId: id,
        board: board,
        title: _text(answer['title']) ?? _text(call['title']),
        assignee: _text(answer['assignee']) ?? _text(call['assignee']),
        status: _text(answer['status']),
      ),
    ];
  }
  return [
    for (final key in const ['parent_id', 'child_id'])
      if (_taskId(answer[key] ?? call[key]) case final id?)
        ChatKanbanSeed(taskId: id, board: board, linked: true),
  ];
}

/// The cards the Kanban tool calls in stored history [rows] made or linked:
/// each assistant row's `tool_calls` joined to the tool row that answers it.
List<ChatKanbanSeed> chatKanbanSeedsFromHistoryRows(
  Iterable<Map<dynamic, dynamic>> rows,
) {
  final calls = <String, ({String name, Object? args})>{};
  final seeds = <ChatKanbanSeed>[];
  for (final row in rows) {
    final role = row['role']?.toString();
    if (role == 'assistant' || role == 'agent') {
      final list = row['tool_calls'];
      if (list is! List) continue;
      for (final call in list) {
        if (call is! Map) continue;
        final fn = call['function'];
        final name = (fn is Map ? fn['name'] : call['name'])?.toString();
        final id = call['id']?.toString();
        if (name == null || id == null || chatKanbanToolKind(name) == null) {
          continue;
        }
        calls[id] = (
          name: name,
          args: fn is Map ? fn['arguments'] : call['arguments'],
        );
      }
    } else if (role == 'tool') {
      final call = calls[row['tool_call_id']?.toString()];
      final name =
          call?.name ??
          (row['name'] ?? row['tool_name'] ?? row['toolCallName'])?.toString();
      if (name == null) continue;
      seeds.addAll(
        chatKanbanSeedsFromToolCall(
          name: name,
          args: call?.args,
          result: row['content'],
        ),
      );
    }
  }
  return seeds;
}

/// One row of the dock.
@immutable
class ChatKanbanCard {
  const ChatKanbanCard({
    required this.id,
    required this.board,
    required this.title,
    required this.status,
    required this.assignee,
    required this.archived,
    required this.linked,
    required this.confirmed,
  });

  final String id;

  /// The board the card is on, once known.
  final String? board;
  final String title;

  /// `triage`, `todo`, `scheduled`, `ready`, `running`, `blocked`, `review`,
  /// `done` or `archived`; empty while nothing has said (a linked card the
  /// board has not reported yet).
  final String status;
  final String? assignee;
  final bool archived;
  final bool linked;

  /// The board itself has reported this card; otherwise the row still shows
  /// what the tool call said.
  final bool confirmed;

  /// Finished work: drawn dimmed, and the only rows that can be dismissed.
  bool get settled => archived || status == 'done';
}

/// Why the board cannot be read or opened for a chat.
enum ChatKanbanBlock {
  /// The connection has no dashboard (a REST-only connection).
  noDashboard,

  /// The dashboard has no Kanban plugin.
  unsupported,
  denied,
  insecure,
  unreachable,

  /// The connection was edited or signed out under the chat.
  stale,
}

extension ChatKanbanBlockX on ChatKanbanBlock {
  /// The board cannot open at all, so a tap explains instead of navigating.
  /// A board that was only unreachable may answer by the time it is opened.
  bool get refusesOpen => switch (this) {
    ChatKanbanBlock.noDashboard ||
    ChatKanbanBlock.unsupported ||
    ChatKanbanBlock.denied ||
    ChatKanbanBlock.insecure ||
    ChatKanbanBlock.stale => true,
    ChatKanbanBlock.unreachable => false,
  };
}

/// The board reads the dock needs. The app's own is
/// [WorkspaceChatKanbanSource]; tests supply a fake.
abstract class ChatKanbanSource {
  /// The board the gateway treats as current.
  Future<String> currentBoard();

  /// The cards on [board] that are not archived.
  Future<KanbanBoardSnapshot> snapshot(String board);

  /// One card, archived or not. Null when [board] has no such card.
  Future<KanbanTaskCard?> card(String board, String taskId);

  /// The board's live event stream from [since]. Null when the host offers
  /// none; the dock then re-reads no faster than the board screen polls.
  Future<StreamSubscription<KanbanEventsFrame>?> watch(
    String board, {
    required int since,
    required void Function(KanbanEventsFrame frame) onFrame,
    void Function()? onClosed,
  });

  void close();
}

/// Reads through the chat's own gateway owner, with the same fenced target
/// the Kanban board screen (F12) uses.
class WorkspaceChatKanbanSource implements ChatKanbanSource {
  WorkspaceChatKanbanSource(this.owner);
  final RemoteWorkspaceOwner owner;
  WorkspacePane? _pane;
  WorkspaceTarget? _target;
  bool _closed = false;

  Future<WorkspaceTarget> _bound() async {
    if (_closed) throw const WorkspaceException(WorkspaceFailure.stale);
    final existing = _target;
    if (existing != null && existing.isCurrent) return existing;
    _pane?.close();
    final pane = _pane = owner.pane();
    return _target = await pane.bind(owner.route());
  }

  @override
  Future<String> currentBoard() async =>
      (await (await _bound()).kanbanBoards()).current;

  @override
  Future<KanbanBoardSnapshot> snapshot(String board) async =>
      (await _bound()).kanbanBoardSnapshot(board: board);

  @override
  Future<KanbanTaskCard?> card(String board, String taskId) async {
    final target = await _bound();
    try {
      return (await target.kanbanTaskDetail(taskId: taskId, board: board)).task;
    } on WorkspaceException catch (e) {
      // The board answered just before, so the router exists: a 404 here is
      // this card, not the plugin.
      if (e.reason == WorkspaceFailure.unsupported) return null;
      rethrow;
    }
  }

  @override
  Future<StreamSubscription<KanbanEventsFrame>?> watch(
    String board, {
    required int since,
    required void Function(KanbanEventsFrame frame) onFrame,
    void Function()? onClosed,
  }) async => (await _bound()).watchKanbanEvents(
    board: board,
    since: since,
    onFrame: onFrame,
    onClosed: onClosed,
  );

  @override
  void close() {
    _closed = true;
    _pane?.close();
    _pane = null;
    _target = null;
  }
}

class _Entry {
  _Entry(this.id);
  final String id;
  String? board;
  String title = '';
  String status = '';
  String? assignee;
  bool archived = false;
  bool linked = false;
  bool confirmed = false;

  /// Reads that found no such card on the board tried.
  int misses = 0;

  bool get settled => archived || status == 'done';

  ChatKanbanCard get card => ChatKanbanCard(
    id: id,
    board: board,
    title: title.isEmpty ? id : title,
    status: archived ? 'archived' : status,
    assignee: assignee,
    archived: archived,
    linked: linked,
    confirmed: confirmed,
  );
}

/// Where "show all" opens: the board holding most of this chat's cards.
typedef ChatKanbanShowAll = ({String? board, Set<String> ids, bool archived});

class ChatKanbanDockController extends ChangeNotifier {
  ChatKanbanDockController({
    required this.connectionId,
    required String? profile,
    required this._openSource,
    this._online,
    Future<SharedPreferences> Function()? preferences,
    this.pollInterval = const Duration(seconds: 15),
    this.frameWindow = const Duration(milliseconds: 300),
  }) : profile = profile?.trim().isEmpty ?? true ? null : profile!.trim(),
       _preferences = preferences ?? SharedPreferences.getInstance;

  /// The connection and profile this chat talks to. Cards are only ever read
  /// through this chat's own owner; these name the scope for stored state.
  final String connectionId;
  final String? profile;

  /// The board screen's own fallback poll interval; the dock never re-reads
  /// faster, and only polls a board whose event stream is unavailable.
  final Duration pollInterval;

  /// Event frames within this window share one read: the first frame after
  /// a quiet spell reads at once, the ones after it in the window are read
  /// together when it ends.
  final Duration frameWindow;

  /// A dropped event stream is dialled again after 1, 2, 4 … 32 s, as the
  /// board screen does; one that stayed open this long starts again at 1 s.
  static const _stableStream = Duration(seconds: 30);
  static const _maxRedialShift = 5;

  static const _maxEntries = 200;
  static const _maxCardReads = 8;
  static const _maxMisses = 3;
  static const _dismissedKey = 'kanban_dock.dismissed.v1';
  static const _maxDismissedChats = 60;
  static const _maxDismissedPerChat = 200;

  final ChatKanbanSource? Function() _openSource;

  /// Whether the chat's own gateway socket is up. The dock never opens a
  /// connection: while this is false it reads nothing, and the chat calls
  /// [refresh] when its socket comes up.
  final bool Function()? _online;
  final Future<SharedPreferences> Function() _preferences;

  final List<_Entry> _entries = [];

  /// Cards the board said it does not have (deleted). The transcript still
  /// names them on every reload; they must not come back as rows.
  final Set<String> _gone = {};
  final Set<String> _sessionIds = {};
  final Set<String> _dismissed = {};
  String? _primaryId;

  ChatKanbanSource? _source;
  String? _currentBoard;
  ChatKanbanBlock? _block;
  final Map<String, StreamSubscription<KanbanEventsFrame>> _subs = {};
  final Map<String, int> _cursors = {};
  final Set<String> _noStream = {};

  /// Dropped streams waiting to be dialled again, by board, and how many
  /// times each has been dialled since it last stayed open.
  final Map<String, Timer> _redials = {};
  final Map<String, int> _redialAttempts = {};
  final Map<String, Timer> _stable = {};

  /// Reads the boards with no open stream (none offered, or a dropped one
  /// waiting to be dialled again).
  Timer? _poll;

  /// Reads everything again while the board is unreachable.
  Timer? _retry;

  int _views = 0;
  Object _epoch = Object();
  bool _disposed = false;
  Future<void>? _reading;

  /// Reads waiting for the read loop: everything, or the named boards (with
  /// the cards their frames named).
  bool _dueFull = false;
  final Map<String, Set<String>> _dueBoards = {};

  /// The open frame window, and the frames that arrived in it.
  Timer? _window;
  final Map<String, Set<String>> _heldBoards = {};
  bool _notifyQueued = false;

  /// The rows to draw: unfinished cards first, each group in the order the
  /// chat made them; dismissed ones left out.
  List<ChatKanbanCard> get cards => [
    for (final e in _entries)
      if (!e.settled && !_dismissed.contains(e.id)) e.card,
    for (final e in _entries)
      if (e.settled && !_dismissed.contains(e.id)) e.card,
  ];

  /// Why live status and the board are unavailable, when they are.
  ChatKanbanBlock? get block => _block;

  /// The board [card] is on: its own, else the gateway's current board.
  String? boardFor(ChatKanbanCard card) => card.board ?? _currentBoard;

  /// Every card of this chat on the board that holds most of them,
  /// dismissed ones included.
  ChatKanbanShowAll get showAll {
    final counts = <String?, int>{};
    for (final e in _entries) {
      final board = e.board ?? _currentBoard;
      counts[board] = (counts[board] ?? 0) + 1;
    }
    String? best;
    var most = -1;
    counts.forEach((board, count) {
      if (count > most) {
        most = count;
        best = board;
      }
    });
    final mine = [
      for (final e in _entries)
        if ((e.board ?? _currentBoard) == best) e,
    ];
    return (
      board: best,
      ids: {for (final e in mine) e.id},
      archived: mine.any((e) => e.archived),
    );
  }

  @visibleForTesting
  bool get debugWatching =>
      _subs.isNotEmpty ||
      _redials.isNotEmpty ||
      _poll != null ||
      _retry != null;

  bool get _attached => _views > 0 && !_disposed;

  void _changed() {
    if (_disposed || _notifyQueued) return;
    _notifyQueued = true;
    // Seeds arrive from inside other owners' updates; never notify mid-build.
    scheduleMicrotask(() {
      _notifyQueued = false;
      if (!_disposed) notifyListeners();
    });
  }

  /// A dock showing this chat came on screen: read the board and follow it.
  void attach() {
    if (_disposed) return;
    _views++;
    if (_views != 1) return;
    _noStream.clear();
    _redialAttempts.clear();
    // Follow from the board as it is now, not from where an earlier visit
    // stopped: the read that comes first already covers what happened since.
    _cursors.clear();
    scheduleMicrotask(() => unawaited(refresh()));
  }

  /// The dock left the screen (the chat was closed, switched away from,
  /// covered by a route or hidden): stop following the board. The rows are
  /// kept for when it comes back.
  void detach() {
    if (_views == 0) return;
    _views--;
    if (_views == 0) _stop();
  }

  void _stop() {
    _epoch = Object();
    _unfollow();
    _retry?.cancel();
    _retry = null;
    _window?.cancel();
    _window = null;
    _heldBoards.clear();
    _dueBoards.clear();
    _dueFull = false;
    _source?.close();
    _source = null;
  }

  /// Lets go of every stream, pending re-dial and poll.
  void _unfollow() {
    _poll?.cancel();
    _poll = null;
    for (final sub in _subs.values) {
      unawaited(sub.cancel());
    }
    _subs.clear();
    for (final timer in [..._redials.values, ..._stable.values]) {
      timer.cancel();
    }
    _redials.clear();
    _stable.clear();
  }

  @override
  void dispose() {
    _disposed = true;
    _views = 0;
    _stop();
    super.dispose();
  }

  /// Names the chat. [primaryId] is its stored session id; [aliases] are the
  /// other ids the gateway knows the same chat by (a resumed continuation).
  /// A task whose `session_id` is one of these was created by this chat.
  /// [discover] is false for a chat created just now, which has no cards.
  void setChat({
    required String? primaryId,
    Iterable<String?> aliases = const [],
    bool discover = true,
  }) {
    if (_disposed) return;
    var added = false;
    for (final raw in [primaryId, ...aliases]) {
      final id = raw?.trim() ?? '';
      if (id.isNotEmpty && _sessionIds.add(id)) added = true;
    }
    final primary = primaryId?.trim() ?? '';
    if (_primaryId == null && primary.isNotEmpty) {
      _primaryId = primary;
      unawaited(_loadDismissed());
    }
    if (added && discover && _attached) unawaited(refresh());
  }

  /// Takes cards this chat's own tool calls reported.
  void observeSeeds(Iterable<ChatKanbanSeed> seeds) {
    if (_disposed) return;
    var added = false;
    var changed = false;
    for (final seed in seeds) {
      if (_gone.contains(seed.taskId)) continue;
      var entry = _find(seed.taskId, seed.board);
      if (entry == null) {
        entry = _Entry(seed.taskId)..linked = seed.linked;
        _add(entry);
        added = true;
      }
      if (entry.board == null && seed.board != null) {
        entry.board = seed.board;
        changed = true;
      }
      if (!seed.linked && entry.linked) {
        entry.linked = false;
        changed = true;
      }
      // The board outranks the transcript once it has reported the card.
      if (entry.confirmed) continue;
      if (seed.title != null && entry.title != seed.title) {
        entry.title = seed.title!;
        changed = true;
      }
      if (seed.assignee != null && entry.assignee != seed.assignee) {
        entry.assignee = seed.assignee;
        changed = true;
      }
      if (seed.status != null && entry.status != seed.status) {
        entry.status = seed.status!;
        changed = true;
      }
    }
    if (added || changed) _changed();
    if (added && _attached) unawaited(refresh());
  }

  void observeToolCall({required String name, Object? args, Object? result}) {
    if (chatKanbanToolKind(name) == null) return;
    observeSeeds(
      chatKanbanSeedsFromToolCall(name: name, args: args, result: result),
    );
  }

  void observeHistoryRows(Iterable<Map<dynamic, dynamic>> rows) =>
      observeSeeds(chatKanbanSeedsFromHistoryRows(rows));

  /// A turn of this chat ended. With a live event stream the board has
  /// already said what changed; without one, read once now.
  void turnEnded() {
    if (!_attached || _entries.isEmpty) return;
    final streamed = _entries.every(
      (e) => e.settled || (e.board != null && _subs.containsKey(e.board)),
    );
    if (!streamed) unawaited(refresh());
  }

  /// Hides a finished card from this chat's dock. It returns if the card is
  /// reopened; the board still lists it.
  void dismiss(ChatKanbanCard card) {
    if (_disposed || !card.settled || !_dismissed.add(card.id)) return;
    _changed();
    unawaited(_saveDismissed());
  }

  _Entry? _find(String id, String? board) {
    _Entry? unplaced;
    _Entry? any;
    for (final e in _entries) {
      if (e.id != id) continue;
      if (board != null && e.board == board) return e;
      if (e.board == null) unplaced ??= e;
      any ??= e;
    }
    // A card with no board yet is the same card wherever it turns up; with
    // none named, any card of that id is it.
    return board == null ? any : unplaced;
  }

  void _add(_Entry entry) {
    _entries.add(entry);
    if (_entries.length <= _maxEntries) return;
    final drop = _entries.indexWhere((e) => e.settled);
    _entries.removeAt(drop < 0 ? 0 : drop);
  }

  /// Reads the board for this chat's cards and follows it: `GET /boards`,
  /// then each board the chat has cards on. Calls made while a read is
  /// running share it and cause one more afterwards.
  Future<void> refresh() {
    if (!_attached) return Future.value();
    _dueFull = true;
    // A full read covers whatever the frames held in a window asked for.
    _heldBoards.clear();
    return _drain();
  }

  /// Runs the reads that are due, one at a time.
  Future<void> _drain() {
    final running = _reading;
    if (running != null) return running;
    if (!_attached || !(_dueFull || _dueBoards.isNotEmpty)) {
      return Future.value();
    }
    late final Future<void> mine;
    mine = () async {
      try {
        while (_attached && (_dueFull || _dueBoards.isNotEmpty)) {
          if (_dueFull) {
            _dueFull = false;
            _dueBoards.clear();
            await _read();
          } else {
            final boards = {
              for (final MapEntry(:key, :value) in _dueBoards.entries)
                key: {...value},
            };
            _dueBoards.clear();
            await _readBoards(boards);
          }
        }
      } finally {
        if (identical(_reading, mine)) _reading = null;
      }
    }();
    return _reading = mine;
  }

  /// An event frame on [board] concerns this chat ([ids] are the cards it
  /// named): read that board only. The first frame after a quiet spell reads
  /// at once; frames in the [frameWindow] after it are read together when
  /// the window ends.
  void _frameRead(String board, Set<String> ids) {
    if (!_attached) return;
    if (_window != null) {
      (_heldBoards[board] ??= {}).addAll(ids);
      return;
    }
    (_dueBoards[board] ??= {}).addAll(ids);
    _openWindow();
    unawaited(_drain());
  }

  void _openWindow() {
    _window = Timer(frameWindow, () {
      _window = null;
      if (!_attached || _heldBoards.isEmpty) return;
      for (final MapEntry(:key, :value) in _heldBoards.entries) {
        (_dueBoards[key] ??= {}).addAll(value);
      }
      _heldBoards.clear();
      _openWindow();
      unawaited(_drain());
    });
  }

  ChatKanbanBlock _blockFor(WorkspaceException e) => switch (e.reason) {
    WorkspaceFailure.unsupported => ChatKanbanBlock.unsupported,
    WorkspaceFailure.denied => ChatKanbanBlock.denied,
    WorkspaceFailure.insecure => ChatKanbanBlock.insecure,
    WorkspaceFailure.stale ||
    WorkspaceFailure.mismatch => ChatKanbanBlock.stale,
    _ => ChatKanbanBlock.unreachable,
  };

  void _blocked(ChatKanbanBlock block) {
    // A board that cannot be read is not followed; unfinished cards on an
    // unreachable one are tried again at the board screen's poll interval.
    _unfollow();
    _retry?.cancel();
    _retry = null;
    if (block == ChatKanbanBlock.unreachable &&
        _entries.any((e) => !e.settled)) {
      _retry = Timer.periodic(pollInterval, (_) => unawaited(refresh()));
    }
    if (_block == block) return;
    _block = block;
    _changed();
  }

  /// Everything: the current board, then every board the chat has cards on.
  Future<void> _read() async {
    final epoch = _epoch;
    bool stale() => _disposed || !identical(epoch, _epoch);
    if (stale() || (_sessionIds.isEmpty && _entries.isEmpty)) return;
    final source = _source ??= _openSource();
    if (source == null) {
      _blocked(ChatKanbanBlock.noDashboard);
      return;
    }
    if (!(_online?.call() ?? true)) return;
    try {
      final current = await source.currentBoard();
      if (stale()) return;
      _currentBoard = current;
      final boards = <String>{current, for (final e in _entries) ?e.board};
      for (final board in boards) {
        if (!await _readBoard(source, board, stale)) return;
      }
      _retry?.cancel();
      _retry = null;
      if (_block != null) _block = null;
      await _follow(source, stale);
      if (stale()) return;
      _changed();
    } on WorkspaceException catch (e) {
      if (stale()) return;
      _blocked(_blockFor(e));
    } catch (_) {
      if (stale()) return;
      _blocked(ChatKanbanBlock.unreachable);
    }
  }

  /// Only [boards], each for the cards its frames named: no `GET /boards`
  /// and no other board.
  Future<void> _readBoards(Map<String, Set<String>> boards) async {
    final epoch = _epoch;
    bool stale() => _disposed || !identical(epoch, _epoch);
    if (stale() || (_sessionIds.isEmpty && _entries.isEmpty)) return;
    final source = _source;
    if (source == null || _currentBoard == null) {
      // Nothing has been read yet: read everything.
      return _read();
    }
    if (!(_online?.call() ?? true)) return;
    try {
      for (final MapEntry(key: board, value: ids) in boards.entries) {
        if (!await _readBoard(source, board, stale, concerned: ids)) return;
      }
      if (_block != null) _block = null;
      await _follow(source, stale);
      if (stale()) return;
      _changed();
    } on WorkspaceException catch (e) {
      if (stale()) return;
      _blocked(_blockFor(e));
    } catch (_) {
      if (stale()) return;
      _blocked(ChatKanbanBlock.unreachable);
    }
  }

  /// Reads [board]'s open cards for this chat's (its own and provenance),
  /// then asks for its tracked cards missing from them one by one: all of
  /// them, or only those in [concerned] (the cards a frame named). False
  /// when the read went stale.
  Future<bool> _readBoard(
    ChatKanbanSource source,
    String board,
    bool Function() stale, {
    Set<String>? concerned,
  }) async {
    final current = _currentBoard;
    final KanbanBoardSnapshot snap;
    try {
      snap = await source.snapshot(board);
    } on KanbanBoardNotFoundException {
      if (stale()) return false;
      // The board was archived or deleted with its cards.
      for (final e in _entries.where((e) => e.board == board).toList()) {
        _forget(e);
      }
      return true;
    }
    if (stale()) return false;
    final seen = <String>{};
    for (final task in snap.allTasks) {
      final mine =
          task.sessionId != null && _sessionIds.contains(task.sessionId);
      var entry = _find(task.id, board);
      if (entry == null) {
        if (!mine) continue;
        _gone.remove(task.id);
        entry = _Entry(task.id);
        _add(entry);
      }
      seen.add(task.id);
      _take(entry, board, task);
    }
    _cursors.putIfAbsent(board, () => snap.latestEventId);
    // Not among the open cards: archived, deleted, or on another board.
    final absent = [
      for (final e in _entries)
        if (!seen.contains(e.id) &&
            (concerned == null || concerned.contains(e.id)) &&
            !(e.archived && e.confirmed) &&
            e.misses < _maxMisses &&
            (e.board == board || (e.board == null && board == current)))
          e,
    ];
    for (final entry in absent.take(_maxCardReads)) {
      final task = await source.card(board, entry.id);
      if (stale()) return false;
      if (task != null) {
        _take(entry, board, task);
      } else if (entry.board == board) {
        _forget(entry);
      } else {
        entry.misses++;
      }
    }
    return true;
  }

  /// The board has no such card any more.
  void _forget(_Entry entry) {
    _entries.remove(entry);
    _gone.add(entry.id);
    if (_gone.length > _maxEntries) _gone.remove(_gone.first);
  }

  void _take(_Entry entry, String board, KanbanTaskCard task) {
    entry
      ..board = board
      ..title = task.title
      ..status = task.status
      ..assignee = task.assignee
      ..archived = task.archived
      ..confirmed = true
      ..misses = 0;
    // A reopened card is news again.
    if (!entry.settled && _dismissed.remove(entry.id)) {
      unawaited(_saveDismissed());
    }
  }

  /// The boards with an unfinished card of this chat.
  Set<String> get _wanted => {
    for (final e in _entries)
      if (!e.settled && e.board != null) e.board!,
  };

  /// Follows every board that still has unfinished cards of this chat, and
  /// lets go of the others.
  Future<void> _follow(ChatKanbanSource source, bool Function() stale) async {
    final wanted = _wanted;
    for (final board in _subs.keys.toList()) {
      if (wanted.contains(board)) continue;
      unawaited(_subs.remove(board)?.cancel());
      _stable.remove(board)?.cancel();
    }
    for (final board in _redials.keys.toList()) {
      if (wanted.contains(board)) continue;
      _redials.remove(board)?.cancel();
      _redialAttempts.remove(board);
    }
    for (final board in wanted) {
      if (_subs.containsKey(board) ||
          _noStream.contains(board) ||
          _redials.containsKey(board)) {
        continue;
      }
      if (!await _dial(source, board, stale)) return;
    }
    _pollUnfollowed();
  }

  /// Opens [board]'s event stream from its cursor. False when the read that
  /// asked went stale.
  Future<bool> _dial(
    ChatKanbanSource source,
    String board,
    bool Function() stale,
  ) async {
    final epoch = _epoch;
    var closed = false;
    final sub = await source.watch(
      board,
      since: _cursors[board] ?? 0,
      onFrame: (frame) => _onFrame(epoch, board, frame),
      onClosed: () {
        closed = true;
        _onClosed(epoch, board);
      },
    );
    if (stale()) {
      unawaited(sub?.cancel());
      return false;
    }
    if (sub == null) {
      // The host offers no event stream: the poll reads this board.
      _noStream.add(board);
    } else if (!closed) {
      // Closed while dialling: [_onClosed] has already set the re-dial.
      _subs[board] = sub;
      _stable[board]?.cancel();
      _stable[board] = Timer(_stableStream, () {
        _stable.remove(board);
        _redialAttempts.remove(board);
      });
    }
    return true;
  }

  /// Boards with unfinished cards of this chat and no open stream (the host
  /// offers none, or a dropped one waits to be dialled again) are read at
  /// the board screen's poll interval, on their own.
  void _pollUnfollowed() {
    final unfollowed = {
      for (final board in _wanted)
        if (!_subs.containsKey(board) &&
            (_noStream.contains(board) || _redials.containsKey(board)))
          board,
    };
    if (unfollowed.isEmpty) {
      _poll?.cancel();
      _poll = null;
      return;
    }
    _poll ??= Timer.periodic(pollInterval, (_) {
      if (!_attached) return;
      final boards = {
        for (final board in _wanted)
          if (!_subs.containsKey(board) &&
              (_noStream.contains(board) || _redials.containsKey(board)))
            board,
      };
      if (boards.isEmpty) {
        _poll?.cancel();
        _poll = null;
        return;
      }
      for (final board in boards) {
        _dueBoards[board] ??= {};
      }
      unawaited(_drain());
    });
  }

  void _onFrame(Object epoch, String board, KanbanEventsFrame frame) {
    if (_disposed || !identical(epoch, _epoch)) return;
    _cursors[board] = frame.cursor;
    // A new card may be this chat's (provenance); other cards' events are not
    // this dock's business.
    var relevant = false;
    final ids = <String>{};
    for (final event in frame.events) {
      final id = event.taskId;
      final tracked = id != null && _entries.any((e) => e.id == id);
      if (event.kind == 'created' || tracked) {
        relevant = true;
        if (tracked) ids.add(id);
      }
    }
    if (relevant) _frameRead(board, ids);
  }

  /// [board]'s stream closed: dial it again from its cursor after 1, 2, 4 …
  /// 32 s, as the board screen does. The events in between come with it,
  /// and the poll stands in meanwhile.
  void _onClosed(Object epoch, String board) {
    if (_disposed || !identical(epoch, _epoch)) return;
    _subs.remove(board);
    _stable.remove(board)?.cancel();
    if (_redials.containsKey(board)) return;
    final attempt = _redialAttempts[board] ?? 0;
    _redialAttempts[board] = attempt + 1;
    final wait = Duration(seconds: 1 << math.min(attempt, _maxRedialShift));
    _redials[board] = Timer(wait, () {
      _redials.remove(board);
      unawaited(_redial(epoch, board));
    });
    _pollUnfollowed();
  }

  Future<void> _redial(Object epoch, String board) async {
    bool stale() => _disposed || !identical(epoch, _epoch);
    final source = _source;
    if (stale() || !_attached || source == null) return;
    if (!_wanted.contains(board) || _subs.containsKey(board)) {
      _pollUnfollowed();
      return;
    }
    // Offline: the chat refreshes the dock when its socket is up again.
    if (!(_online?.call() ?? true)) return;
    try {
      if (await _dial(source, board, stale)) _pollUnfollowed();
    } on WorkspaceException catch (e) {
      if (!stale()) _blocked(_blockFor(e));
    } catch (_) {
      if (!stale()) _blocked(ChatKanbanBlock.unreachable);
    }
  }

  String? get _dismissedScope {
    final id = _primaryId;
    return id == null ? null : '$connectionId|${profile ?? ''}|$id';
  }

  Future<void> _loadDismissed() async {
    final scope = _dismissedScope;
    if (scope == null) return;
    try {
      final prefs = await _preferences();
      if (_disposed || scope != _dismissedScope) return;
      final all = _jsonMap(prefs.getString(_dismissedKey));
      final mine = all?[scope];
      if (mine is! List) return;
      var changed = false;
      for (final id in mine) {
        if (id is String && _dismissed.add(id)) changed = true;
      }
      if (changed) _changed();
    } catch (_) {
      // Dismissals are a convenience: without them the rows simply return.
    }
  }

  Future<void> _saveDismissed() async {
    final scope = _dismissedScope;
    if (scope == null) return;
    final mine = _dismissed.toList();
    try {
      final prefs = await _preferences();
      final all = _jsonMap(prefs.getString(_dismissedKey)) ?? {};
      all.remove(scope);
      if (mine.isNotEmpty) {
        all[scope] = mine.length > _maxDismissedPerChat
            ? mine.sublist(mine.length - _maxDismissedPerChat)
            : mine;
      }
      // Oldest chats first: keep the most recently touched.
      while (all.length > _maxDismissedChats) {
        all.remove(all.keys.first);
      }
      await prefs.setString(_dismissedKey, jsonEncode(all));
    } catch (_) {}
  }
}
