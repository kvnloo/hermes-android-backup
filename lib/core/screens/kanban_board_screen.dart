import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../services/connection_manager.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/remote_workspace.dart';

/// Native Kanban workspace (`F12`): boards, columns, drag/move transitions,
/// multi-select bulk actions, dependencies, comments, runs, worker logs, and
/// orchestration/worker profile settings, scoped to [owner] and [route].
class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({
    super.key,
    required this.owner,
    required this.route,
    required this.connection,
    this.enableLivePolling = true,

    /// Board the board opens on. When null, the stored pref (or the server
    /// default) is used. Transient: never overwrites the saved selection.
    this.initialBoard,

    /// Card id to open in the detail sheet once the board has loaded. The dock
    /// (t_7b7d44f3) reuses this entry point to open the card it created.
    this.initialCardId,

    /// Limits the board to these card ids until the user clears the chip: the
    /// chat dock's "show all" opens the board on the cards of one chat.
    this.initialCardFilter,

    /// Starts with archived cards shown (a chat's finished cards).
    this.initialIncludeArchived = false,

    /// When set, the board is a pane beside a chat rather than a route: the
    /// app bar gets a close button that calls this instead of a back arrow.
    this.onClose,
    this.onLiveEvents,
  });

  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final SavedConnection connection;
  final bool enableLivePolling;

  /// Board the board opens on; null means "stored pref or server default".
  final String? initialBoard;

  /// Card id to open in the detail sheet once the board has a snapshot.
  final String? initialCardId;

  /// Card ids the board starts filtered to; null shows every card.
  final Set<String>? initialCardFilter;
  final bool initialIncludeArchived;

  /// Closes the board when it is shown as a pane.
  final VoidCallback? onClose;

  /// Each batch of new live events, once and in order: an event the stream
  /// sends again after a re-dial is not passed on twice.
  final void Function(String board, List<KanbanEventRecord> events)?
  onLiveEvents;

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

/// Asks before an action that stops a worker or takes work off the board.
/// False on Cancel or dismissal: the caller then sends nothing.
Future<bool> _confirmKanbanAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      key: const Key('kanban-confirm-dialog'),
      scrollable: true,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          key: const Key('kanban-confirm-cancel'),
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(ctx.sharedL10n.cancel),
        ),
        FilledButton(
          key: const Key('kanban-confirm-ok'),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return ok == true;
}

String _kanbanCardCount(BuildContext context, int count) =>
    context.sharedL10n.ng_board_card_count(count);

/// A linked card's column, or `?` before the board has reported it.
String _linkedStatus(BuildContext context, KanbanLinkedTask? task) =>
    task == null ? '?' : _columnLabel(context, task.status);

/// A workflow column's name in the app's language (`ng_kanban_status_*`).
String _columnLabel(BuildContext context, String status) {
  final l = context.sharedL10n;
  return switch (status) {
    'triage' => l.ng_kanban_status_triage,
    'todo' => l.ng_kanban_status_todo,
    'scheduled' => l.ng_kanban_status_scheduled,
    'ready' => l.ng_kanban_status_ready,
    'running' => l.ng_kanban_status_running,
    'blocked' => l.ng_kanban_status_blocked,
    'review' => l.ng_kanban_status_review,
    'done' => l.ng_kanban_status_done,
    'archived' => l.ng_kanban_status_archived,
    _ => status,
  };
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  WorkspacePane? _pane;
  WorkspaceTarget? _target;
  Object? _account;
  Object _loadToken = Object();

  KanbanBoardPreferences? _prefs;
  String _boardSlug = '';
  List<String> _pinnedBoards = const [];
  bool _includeArchived = false;
  bool _lanesByProfile = false;
  Map<String, bool> _collapsedLanes = const {};
  int _narrowColumnIndex = 3; // Default to 'ready' on phone widths.

  /// The cards the board is limited to (one chat's), until cleared.
  Set<String>? _cardFilter;

  /// The narrow board follows the opened card or filter to its column until
  /// the user picks a column.
  bool _narrowColumnPicked = false;

  bool _loading = true;
  WorkspaceFailure? _failure;
  String? _errorDetail;

  List<KanbanBoardMeta> _boards = const [];
  String _serverCurrentBoard = 'default';
  KanbanBoardSnapshot? _snapshot;
  List<KanbanProfileEntry> _profiles = const [];
  List<KanbanProjectEntry> _projects = const [];
  KanbanOrchestration? _orchestration;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _assigneeFilter = '';
  final Set<String> _selectedIds = <String>{};
  bool _selectionMode = false;

  final Map<String, int> _cursorByBoard = <String, int>{};
  StreamSubscription<KanbanEventsFrame>? _eventsSub;
  Timer? _pollTimer;

  /// Bumped whenever the live stream is cancelled or re-bound: a socket, a
  /// frame or a re-dial from an older binding is dropped on arrival.
  int _realtimeGeneration = 0;
  Timer? _redialTimer;
  int _redialAttempt = 0;

  /// A stream that stays up this long earns a short wait on its next drop;
  /// one that keeps closing at once is dialled ever more slowly.
  Timer? _stableTimer;

  /// Frames are applied in one board read once they stop arriving.
  Timer? _frameReload;
  static const _frameDebounce = Duration(milliseconds: 400);

  /// Bumped when the board shown changes; an action started on the old
  /// board finishes without touching the new one.
  int _boardEpoch = 0;

  /// Card id from the widget to open in the detail sheet once the snapshot
  /// carries it. Sticky across reloads until consumed or cancelled.
  String? _pendingInitialCardId;

  /// Board slug the pending card belongs to. When null the card may open on
  /// any board (the open is scoped to the board it is actually found on).
  String? _pendingInitialBoard;

  String get _effectiveSlug =>
      _boardSlug.isEmpty ? _serverCurrentBoard : _boardSlug;

  String? get _queryBoard => _boardSlug.isEmpty ? null : _boardSlug;

  @override
  void initState() {
    super.initState();
    _account = ConnectionMutationBarrier.capture(widget.route.connectionId);
    ConnectionMutationBarrier.addListener(_onAccountChanged);
    _cardFilter = widget.initialCardFilter;
    _includeArchived = widget.initialIncludeArchived;
    final initialCard = widget.initialCardId?.trim();
    _pendingInitialCardId = (initialCard == null || initialCard.isEmpty)
        ? null
        : initialCard;
    final initialBoard = widget.initialBoard?.trim();
    _pendingInitialBoard = (initialBoard == null || initialBoard.isEmpty)
        ? null
        : initialBoard;
    _searchController.addListener(() {
      final next = _searchController.text.trim();
      if (next != _searchQuery && mounted) {
        setState(() => _searchQuery = next);
      }
    });
    unawaited(_initAndLoad());
  }

  void _onAccountChanged() {
    if (ConnectionMutationBarrier.isCurrent(
      widget.route.connectionId,
      _account,
    )) {
      return;
    }
    _pane?.invalidate();
    _target = null;
    _cancelRealtime();
    if (mounted) {
      setState(() {
        _loading = false;
        _failure = WorkspaceFailure.stale;
        _snapshot = null;
      });
    }
  }

  @override
  void didUpdateWidget(covariant KanbanBoardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.owner != widget.owner || oldWidget.route != widget.route) {
      _pane?.close();
      _pane = null;
      _target = null;
      _account = ConnectionMutationBarrier.capture(widget.route.connectionId);
      _cancelRealtime();
      _cardFilter = widget.initialCardFilter;
      _includeArchived = widget.initialIncludeArchived;
      _narrowColumnPicked = false;
      final initialCard = widget.initialCardId?.trim();
      _pendingInitialCardId = (initialCard == null || initialCard.isEmpty)
          ? null
          : initialCard;
      final initialBoard = widget.initialBoard?.trim();
      _pendingInitialBoard = (initialBoard == null || initialBoard.isEmpty)
          ? null
          : initialBoard;
      unawaited(_initAndLoad());
    }
    if (oldWidget.initialCardId != widget.initialCardId ||
        oldWidget.initialBoard != widget.initialBoard) {
      final initialCard = widget.initialCardId?.trim();
      _pendingInitialCardId = (initialCard == null || initialCard.isEmpty)
          ? null
          : initialCard;
      final initialBoard = widget.initialBoard?.trim();
      _pendingInitialBoard = (initialBoard == null || initialBoard.isEmpty)
          ? null
          : initialBoard;
    }
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(_onAccountChanged);
    _cancelRealtime();
    _searchController.dispose();
    _pane?.close();
    super.dispose();
  }

  void _cancelRealtime() {
    _realtimeGeneration++;
    _pollTimer?.cancel();
    _pollTimer = null;
    _redialTimer?.cancel();
    _redialTimer = null;
    _stableTimer?.cancel();
    _stableTimer = null;
    _frameReload?.cancel();
    _frameReload = null;
    final sub = _eventsSub;
    _eventsSub = null;
    if (sub != null) unawaited(sub.cancel());
  }

  Future<WorkspaceTarget> _bound() async {
    final existing = _target;
    if (existing != null && existing.isCurrent) return existing;
    _pane?.close();
    final pane = _pane = widget.owner.pane();
    final bound = await pane.bind(widget.route);
    _target = bound;
    return bound;
  }

  Future<void> _initAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final store = KanbanBoardPreferences(
      prefs,
      connectionId: widget.route.connectionId,
      profile: widget.route.profile,
    );
    _prefs = store;
    final requestedBoard = widget.initialBoard?.trim();
    _boardSlug = (requestedBoard == null || requestedBoard.isEmpty)
        ? store.selectedBoard
        : requestedBoard;
    _pinnedBoards = store.pinnedBoards;
    _lanesByProfile = store.lanesByProfile;
    _collapsedLanes = store.collapsedLanes;
    await _reload(rebindEvents: true);
  }

  Future<void> _reload({bool rebindEvents = false, bool silent = false}) async {
    final token = _loadToken = Object();
    if (!silent && mounted) {
      setState(() {
        _loading = true;
        _failure = null;
        _errorDetail = null;
      });
    }
    try {
      final target = await _bound();
      final boardsRes = await target.kanbanBoards();
      var querySlug = _queryBoard;
      KanbanBoardSnapshot snap;
      try {
        snap = await target.kanbanBoardSnapshot(
          board: querySlug,
          includeArchived: _includeArchived,
        );
      } on KanbanBoardNotFoundException {
        // Saved local board was archived/deleted on the server; reset cleanly.
        _boardSlug = '';
        await _prefs?.setSelectedBoard('');
        querySlug = null;
        snap = await target.kanbanBoardSnapshot(
          board: null,
          includeArchived: _includeArchived,
        );
      }
      final profiles = await target.kanbanProfiles();
      List<KanbanProjectEntry> projects = const [];
      try {
        projects = await target.kanbanProjects();
      } catch (_) {}
      KanbanOrchestration? orchestration;
      try {
        orchestration = await target.kanbanOrchestration();
      } catch (_) {}
      target.checkCurrent();
      if (!mounted || !identical(token, _loadToken)) return;

      final liveIds = {for (final t in snap.allTasks) t.id};
      _selectedIds.removeWhere((id) => !liveIds.contains(id));
      if (_selectedIds.isEmpty) _selectionMode = false;

      final resolvedSlug = querySlug ?? boardsRes.current;
      _cursorByBoard.putIfAbsent(resolvedSlug, () => snap.latestEventId);

      setState(() {
        _boards = boardsRes.boards;
        _serverCurrentBoard = boardsRes.current;
        _snapshot = snap;
        _profiles = profiles;
        _projects = projects;
        _orchestration = orchestration;
        _loading = false;
        _failure = null;
        _errorDetail = null;
      });

      _followToColumn(snap);
      _maybeFocusInitialCard(snap);

      if (rebindEvents && widget.enableLivePolling) {
        _bindRealtime(target, resolvedSlug, snap.latestEventId);
      }
    } on WorkspaceException catch (e) {
      if (!mounted || !identical(token, _loadToken)) return;
      setState(() {
        _loading = false;
        _failure = e.reason;
        _errorDetail = null;
      });
    } on KanbanActionRefusedException catch (e) {
      if (!mounted || !identical(token, _loadToken)) return;
      setState(() {
        _loading = false;
        _failure = WorkspaceFailure.unavailable;
        _errorDetail = e.detail;
      });
    } catch (_) {
      if (!mounted || !identical(token, _loadToken)) return;
      setState(() {
        _loading = false;
        _failure = WorkspaceFailure.unavailable;
      });
    }
  }

  /// Follows `/api/plugins/kanban/events` for [slug] from its cursor. A
  /// closed or refused stream is dialled again with backoff from the last
  /// event seen, so nothing is missed and nothing is applied twice; a board
  /// switch or leaving the board cancels it, including a dial still in
  /// flight. The 15 s poll stands in only while no stream is open.
  void _bindRealtime(WorkspaceTarget target, String slug, int initialCursor) {
    _cancelRealtime();
    _redialAttempt = 0;
    _cursorByBoard.putIfAbsent(slug, () => initialCursor);
    _dialEvents(target, slug, _realtimeGeneration, _queryBoard);
    final generation = _realtimeGeneration;
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (generation != _realtimeGeneration) return;
      if (_eventsSub == null && mounted && target.isCurrent) {
        unawaited(_reload(silent: true));
      }
    });
  }

  bool _liveCurrent(WorkspaceTarget target, int generation) =>
      mounted && generation == _realtimeGeneration && target.isCurrent;

  void _dialEvents(
    WorkspaceTarget target,
    String slug,
    int generation,
    String? queryBoard,
  ) {
    unawaited(() async {
      StreamSubscription<KanbanEventsFrame>? sub;
      var closed = false;
      sub = await target.watchKanbanEvents(
        board: queryBoard,
        since: _cursorByBoard[slug] ?? 0,
        onFrame: (frame) {
          if (!_liveCurrent(target, generation)) return;
          _onEventsFrame(target, slug, frame);
        },
        onClosed: () {
          closed = true;
          if (!_liveCurrent(target, generation)) return;
          if (identical(_eventsSub, sub)) {
            _eventsSub = null;
            _stableTimer?.cancel();
            _stableTimer = null;
          }
          _scheduleRedial(target, slug, generation, queryBoard);
        },
      );
      if (!_liveCurrent(target, generation)) {
        // The board changed (or was left) while this socket was dialling.
        await sub?.cancel();
        return;
      }
      if (sub == null || closed) {
        _scheduleRedial(target, slug, generation, queryBoard);
        return;
      }
      _eventsSub = sub;
      _stableTimer?.cancel();
      _stableTimer = Timer(const Duration(seconds: 30), () {
        if (generation == _realtimeGeneration) _redialAttempt = 0;
      });
    }());
  }

  void _scheduleRedial(
    WorkspaceTarget target,
    String slug,
    int generation,
    String? queryBoard,
  ) {
    if (_redialTimer?.isActive == true) return;
    final seconds = 1 << _redialAttempt.clamp(0, 5);
    _redialAttempt++;
    _redialTimer = Timer(Duration(seconds: seconds), () {
      _redialTimer = null;
      if (!_liveCurrent(target, generation)) return;
      _dialEvents(target, slug, generation, queryBoard);
    });
  }

  void _onEventsFrame(
    WorkspaceTarget target,
    String slug,
    KanbanEventsFrame frame,
  ) {
    final seen = _cursorByBoard[slug] ?? 0;
    final fresh = [
      for (final event in frame.events)
        if (event.id == null || event.id! > seen) event,
    ];
    var cursor = seen;
    for (final event in fresh) {
      if (event.id != null && event.id! > cursor) cursor = event.id!;
    }
    if (frame.cursor > cursor) cursor = frame.cursor;
    _cursorByBoard[slug] = cursor;
    if (fresh.isEmpty) return;
    widget.onLiveEvents?.call(slug, List.unmodifiable(fresh));
    _notifyTerminalEvents(fresh);
    _frameReload?.cancel();
    final generation = _realtimeGeneration;
    _frameReload = Timer(_frameDebounce, () {
      _frameReload = null;
      if (_liveCurrent(target, generation)) unawaited(_refreshSnapshot());
    });
  }

  /// One board read for the live stream, instead of the full five-request
  /// reload: the cards move, the board list and profiles stay as they are.
  Future<void> _refreshSnapshot() async {
    final token = _loadToken = Object();
    final epoch = _boardEpoch;
    try {
      final target = await _bound();
      final snap = await target.kanbanBoardSnapshot(
        board: _queryBoard,
        includeArchived: _includeArchived,
      );
      if (!mounted ||
          !identical(token, _loadToken) ||
          epoch != _boardEpoch ||
          !target.isCurrent) {
        return;
      }
      final liveIds = {for (final t in snap.allTasks) t.id};
      setState(() {
        _snapshot = snap;
        _selectedIds.removeWhere((id) => !liveIds.contains(id));
        if (_selectedIds.isEmpty) _selectionMode = false;
      });
      _maybeFocusInitialCard(snap);
    } catch (_) {
      // The next frame or the poll tries again.
    }
  }

  void _notifyTerminalEvents(List<KanbanEventRecord> events) {
    const terminalKinds = {
      'completed',
      'blocked',
      'block_loop_detected',
      'crashed',
      'gave_up',
      'timed_out',
    };
    for (final ev in events) {
      if (!terminalKinds.contains(ev.kind)) continue;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.sharedL10n.ng_board_event_toast(
              ev.taskId ?? context.sharedL10n.ng_board_task,
              ev.kind.replaceAll('_', ' '),
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      break;
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _describeError(Object error) => switch (error) {
    KanbanActionRefusedException(:final detail, :final statusCode) =>
      detail.isNotEmpty
          ? detail
          : context.sharedL10n.ng_board_refused_http('$statusCode'),
    WorkspaceException(:final reason) => switch (reason) {
      WorkspaceFailure.unsupported =>
        context.sharedL10n.ng_board_err_unsupported,
      WorkspaceFailure.denied => context.sharedL10n.ng_board_err_denied,
      WorkspaceFailure.stale ||
      WorkspaceFailure.mismatch => context.sharedL10n.ng_board_err_stale,
      WorkspaceFailure.insecure => context.sharedL10n.ng_board_err_insecure,
      _ => context.sharedL10n.ng_board_err_unreachable,
    },
    _ => context.sharedL10n.ng_board_err_failed,
  };

  Future<void> _selectBoard(String slug) async {
    final normalized = slug == _serverCurrentBoard ? slug : slug.trim();
    _pendingInitialCardId = null;
    _pendingInitialBoard = null;
    _boardEpoch++;
    _cancelRealtime();
    setState(() {
      // The chat filter names cards of the board it was opened on.
      if (normalized != _effectiveSlug) _cardFilter = null;
      _boardSlug = normalized;
      _selectedIds.clear();
      _selectionMode = false;
    });
    await _prefs?.setSelectedBoard(normalized);
    await _reload(rebindEvents: true);
  }

  Future<void> _togglePinBoard(String slug) async {
    final nextPinned = !_pinnedBoards.contains(slug);
    await _prefs?.setBoardPinned(slug, nextPinned);
    if (!mounted) return;
    setState(() => _pinnedBoards = _prefs?.pinnedBoards ?? const []);
  }

  /// On a narrow board, shows the column that holds the opened card or the
  /// first card of the chat filter, instead of the default column.
  void _followToColumn(KanbanBoardSnapshot snap) {
    if (_narrowColumnPicked) return;
    final wanted = <String>{...?_cardFilter, ?_pendingInitialCardId};
    if (wanted.isEmpty) return;
    final index = snap.columns.indexWhere(
      (column) => column.tasks.any((task) => wanted.contains(task.id)),
    );
    if (index < 0 || index == _narrowColumnIndex) return;
    setState(() => _narrowColumnIndex = index);
  }

  List<KanbanTaskCard> _filterTasks(List<KanbanTaskCard> input) {
    final only = _cardFilter;
    return [
      for (final task in input)
        if ((only == null || only.contains(task.id)) &&
            (_assigneeFilter.isEmpty ||
                (_assigneeFilter == '__unassigned__'
                    ? task.assignee == null
                    : task.assignee == _assigneeFilter)) &&
            (_searchQuery.isEmpty ||
                task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                task.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (task.assignee?.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ??
                    false)))
          task,
    ];
  }

  Future<void> _moveTaskToStatus(
    KanbanTaskCard task,
    String targetStatus,
  ) async {
    if (task.status == targetStatus) return;
    String? blockReason;
    String? reviewSummary;
    if (targetStatus == 'blocked') {
      blockReason = await _promptText(
        title: context.sharedL10n.ng_board_block_title(task.id),
        label: context.sharedL10n.ng_board_block_reason,
        hint: context.sharedL10n.ng_board_block_hint,
      );
      if (blockReason == null || blockReason.trim().isEmpty) return;
    } else if (targetStatus == 'review') {
      reviewSummary = await _promptText(
        title: context.sharedL10n.ng_board_review_title(task.id),
        label: context.sharedL10n.ng_board_review_summary,
        hint: context.sharedL10n.ng_board_review_hint,
      );
      if (reviewSummary == null || reviewSummary.trim().isEmpty) return;
    }
    try {
      final target = await _bound();
      await target.kanbanPatchTask(
        taskId: task.id,
        board: _queryBoard,
        status: targetStatus,
        blockReason: blockReason,
        summary: reviewSummary,
      );
      if (!mounted || !target.isCurrent) return;
      await _reload(silent: true);
    } catch (e) {
      _toast(_describeError(e));
    }
  }

  Future<String?> _promptText({
    required String title,
    required String label,
    String? hint,
    String initial = '',
  }) async {
    final controller = TextEditingController(text: initial);
    try {
      return await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: InputDecoration(labelText: label, hintText: hint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(ctx.sharedL10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: Text(ctx.sharedL10n.save),
            ),
          ],
        ),
      );
    } finally {
      controller.dispose();
    }
  }

  Future<bool> _confirmDestructive({
    required String title,
    required String message,
    required String confirmLabel,
  }) => _confirmKanbanAction(
    context,
    title: title,
    message: message,
    confirmLabel: confirmLabel,
  );

  Future<void> _runBulkMove(String targetStatus) async {
    final ids = _selectedIds.toList();
    if (ids.isEmpty) return;
    final label = _columnLabel(context, targetStatus);
    final confirmed = await _confirmDestructive(
      title: context.sharedL10n.ng_board_move_title(
        _kanbanCardCount(context, ids.length),
        label,
      ),
      message: context.sharedL10n.ng_board_move_body(_effectiveSlug),
      confirmLabel: context.sharedL10n.ng_board_move,
    );
    if (!confirmed || !mounted) return;
    final epoch = _boardEpoch;
    final board = _queryBoard;
    try {
      final target = await _bound();
      final results = await target.kanbanBulkUpdate(
        board: board,
        ids: ids,
        status: targetStatus,
      );
      if (!mounted || !target.isCurrent || epoch != _boardEpoch) return;
      _applyBulkResults(
        results,
        context.sharedL10n.ng_board_moved(_columnLabel(context, targetStatus)),
      );
      await _reload(silent: true);
    } catch (e) {
      if (epoch == _boardEpoch) _toast(_describeError(e));
    }
  }

  Future<void> _runBulkAssign(String assignee) async {
    final ids = _selectedIds.toList();
    if (ids.isEmpty) return;
    // The request carries reclaim_first: a running card's worker is stopped.
    final confirmed = await _confirmDestructive(
      title: assignee.isEmpty
          ? context.sharedL10n.ng_board_unassign_title(
              _kanbanCardCount(context, ids.length),
            )
          : context.sharedL10n.ng_board_assign_title(
              _kanbanCardCount(context, ids.length),
              assignee,
            ),
      message: context.sharedL10n.ng_board_assign_body,
      confirmLabel: assignee.isEmpty
          ? context.sharedL10n.ng_board_unassign
          : context.sharedL10n.ng_board_assign,
    );
    if (!confirmed || !mounted) return;
    final epoch = _boardEpoch;
    final board = _queryBoard;
    try {
      final target = await _bound();
      final results = await target.kanbanBulkUpdate(
        board: board,
        ids: ids,
        assignee: assignee,
        reclaimFirst: true,
      );
      if (!mounted || !target.isCurrent || epoch != _boardEpoch) return;
      _applyBulkResults(
        results,
        assignee.isEmpty
            ? context.sharedL10n.ng_board_unassigned_done
            : context.sharedL10n.ng_board_assigned_done(assignee),
      );
      await _reload(silent: true);
    } catch (e) {
      if (epoch == _boardEpoch) _toast(_describeError(e));
    }
  }

  Future<void> _runBulkArchive() async {
    final ids = _selectedIds.toList();
    if (ids.isEmpty) return;
    final confirmed = await _confirmDestructive(
      title: context.sharedL10n.ng_board_archive_title(
        _kanbanCardCount(context, ids.length),
      ),
      message: context.sharedL10n.ng_board_archive_body(_effectiveSlug),
      confirmLabel: context.sharedL10n.ng_archive,
    );
    if (!confirmed || !mounted) return;
    final epoch = _boardEpoch;
    final board = _queryBoard;
    try {
      final target = await _bound();
      final results = await target.kanbanBulkUpdate(
        board: board,
        ids: ids,
        archive: true,
      );
      if (!mounted || !target.isCurrent || epoch != _boardEpoch) return;
      _applyBulkResults(results, context.sharedL10n.ng_board_archived_done);
      await _reload(silent: true);
    } catch (e) {
      if (epoch == _boardEpoch) _toast(_describeError(e));
    }
  }

  Future<void> _runBulkDelete() async {
    final ids = _selectedIds.toList();
    if (ids.isEmpty) return;
    final confirmed = await _confirmDestructive(
      title: context.sharedL10n.ng_board_delete_title(
        _kanbanCardCount(context, ids.length),
      ),
      message: context.sharedL10n.ng_board_delete_body(_effectiveSlug),
      confirmLabel: context.sharedL10n.ng_delete,
    );
    if (!confirmed || !mounted) return;
    final epoch = _boardEpoch;
    final board = _queryBoard;
    try {
      final target = await _bound();
      final failed = <String>[];
      String? firstError;
      for (final id in ids) {
        try {
          await target.kanbanDeleteTask(taskId: id, board: board);
        } catch (e) {
          failed.add(id);
          firstError ??= _describeError(e);
        }
      }
      if (!mounted || !target.isCurrent || epoch != _boardEpoch) return;
      setState(() {
        _selectedIds
          ..clear()
          ..addAll(failed);
        if (_selectedIds.isEmpty) _selectionMode = false;
      });
      if (failed.isEmpty) {
        _toast(
          context.sharedL10n.ng_board_deleted(
            _kanbanCardCount(context, ids.length),
          ),
        );
      } else {
        _toast(
          context.sharedL10n.ng_board_partial_failure(
            '${failed.length}',
            '${ids.length}',
            firstError ?? context.sharedL10n.ng_board_refused,
          ),
        );
      }
      await _reload(silent: true);
    } catch (e) {
      if (epoch == _boardEpoch) _toast(_describeError(e));
    }
  }

  void _applyBulkResults(List<KanbanBulkResult> results, String okMessage) {
    final failed = [
      for (final r in results)
        if (!r.ok) r,
    ];
    setState(() {
      _selectedIds
        ..clear()
        ..addAll(failed.map((f) => f.id));
      if (_selectedIds.isEmpty) _selectionMode = false;
    });
    if (failed.isEmpty) {
      _toast(okMessage);
    } else {
      _toast(
        context.sharedL10n.ng_board_partial_failure(
          '${failed.length}',
          '${results.length}',
          failed.first.error ?? context.sharedL10n.ng_board_refused,
        ),
      );
    }
  }

  Future<void> _dispatchNow() async {
    try {
      final target = await _bound();
      final receipt = await target.kanbanDispatchNow(board: _queryBoard);
      if (!mounted || !target.isCurrent) return;
      _toast(
        context.sharedL10n.ng_board_dispatched(
          '${receipt.spawnedCount}',
          '${receipt.promoted}',
          '${receipt.reclaimed}',
        ),
      );
      await _reload(silent: true);
    } catch (e) {
      _toast(_describeError(e));
    }
  }

  Future<void> _openBoardSwitcher() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _BoardSwitcherSheet(
        boards: _boards,
        activeSlug: _effectiveSlug,
        pinnedSlugs: _pinnedBoards,
        projects: _projects,
        onSelect: (slug) {
          Navigator.pop(ctx);
          unawaited(_selectBoard(slug));
        },
        onTogglePin: (slug) async {
          await _togglePinBoard(slug);
        },
        onMovePin: (slug, target) async {
          await _prefs?.movePinnedBoard(slug, target);
          if (mounted) {
            setState(() => _pinnedBoards = _prefs?.pinnedBoards ?? const []);
          }
        },
        onCreateBoard: (slug, name, projectId, workdir) async {
          final target = await _bound();
          final created = await target.kanbanCreateBoard(
            slug: slug,
            name: name,
            projectId: projectId,
            defaultWorkdir: workdir,
          );
          if (!mounted || !target.isCurrent) return;
          await _selectBoard(created.slug);
        },
        onPatchBoard: (slug, name, desc, workdir, projectId) async {
          final target = await _bound();
          await target.kanbanPatchBoard(
            slug: slug,
            name: name,
            description: desc,
            defaultWorkdir: workdir,
            projectId: projectId,
          );
          if (!mounted || !target.isCurrent) return;
          await _reload(silent: true);
        },
        onArchiveBoard: (slug) async {
          final l10n = context.sharedL10n;
          final target = await _bound();
          final path = await target.kanbanArchiveBoard(slug);
          if (!mounted || !target.isCurrent) return;
          if (_effectiveSlug == slug) {
            _boardEpoch++;
            _cancelRealtime();
            _boardSlug = '';
            await _prefs?.setSelectedBoard('');
          }
          await _prefs?.setBoardPinned(slug, false);
          _pinnedBoards = _prefs?.pinnedBoards ?? const [];
          _toast(
            path == null
                ? l10n.ng_board_board_archived(slug)
                : l10n.ng_board_board_archived_to(path),
          );
          await _reload(rebindEvents: true);
        },
        onExportBoard: (slug, output) async {
          final target = await _bound();
          final exported = await target.kanbanExportBoard(
            slug: slug,
            output: output,
          );
          if (!mounted || !target.isCurrent) return;
          _toast(
            context.sharedL10n.ng_board_exported(
              exported.board,
              exported.archive,
            ),
          );
        },
        onImportBoard: (archive) async {
          final target = await _bound();
          final imported = await target.kanbanImportBoard(archive: archive);
          if (!mounted || !target.isCurrent) return;
          final warn = imported.warnings.isEmpty
              ? ''
              : ' (${imported.warnings.join('; ')})';
          _toast(context.sharedL10n.ng_board_imported(imported.board, warn));
          await _selectBoard(imported.board);
        },
      ),
    );
  }

  Future<void> _openNewTaskDialog({String initialColumn = 'ready'}) async {
    final currentBoardMeta = _boards
        .where((b) => b.slug == _effectiveSlug)
        .firstOrNull;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _NewTaskDialog(
        boardMeta: currentBoardMeta,
        initialColumn: initialColumn,
        profiles: _profiles,
        projects: _projects,
        existingTasks: _snapshot?.allTasks ?? const [],
        orchestration: _orchestration,
        onEstimate: (title, body) async {
          final target = await _bound();
          return target.kanbanEstimateDraft(title: title, body: body);
        },
        onCreate: (spec) async {
          final target = await _bound();
          final created = await target.kanbanCreateTask(
            board: _queryBoard,
            title: spec.title,
            body: spec.body,
            assignee: spec.assignee,
            priority: spec.priority,
            workspaceKind: spec.workspaceKind,
            workspacePath: spec.workspacePath,
            parents: spec.parentId == null ? null : [spec.parentId!],
            triage: spec.targetColumn == 'triage',
            skills: spec.skills,
            goalMode: spec.goalMode,
            goalMaxTurns: spec.goalMaxTurns,
            modelOverride: spec.modelOverride,
            providerOverride: spec.providerOverride,
            reasoningEffort: spec.reasoningEffort,
            projectId: spec.projectId,
          );
          if (spec.targetColumn != 'triage' &&
              created.task.status != spec.targetColumn &&
              !kanbanLockedDragColumns.contains(spec.targetColumn)) {
            try {
              await target.kanbanPatchTask(
                taskId: created.task.id,
                board: _queryBoard,
                status: spec.targetColumn,
              );
            } catch (_) {}
          }
          if (!mounted || !target.isCurrent) return;
          if (created.warning != null && created.warning!.isNotEmpty) {
            _toast(created.warning!);
          } else {
            _toast(context.sharedL10n.ng_board_created(created.task.id));
          }
          await _reload(silent: true);
        },
      ),
    );
  }

  Future<void> _openOrchestrationSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _OrchestrationSheet(
        initial: _orchestration ?? const KanbanOrchestration(),
        profiles: _profiles,
        onSaveOrchestration: (orch, defAssignee, autoDecompose) async {
          final target = await _bound();
          final updated = await target.kanbanSaveOrchestration(
            orchestratorProfile: orch,
            defaultAssignee: defAssignee,
            autoDecompose: autoDecompose,
          );
          if (mounted && target.isCurrent) {
            setState(() => _orchestration = updated);
            _toast(context.sharedL10n.ng_board_orchestration_saved);
          }
          return updated;
        },
        onSaveProfileDescription: (name, description) async {
          final target = await _bound();
          await target.kanbanSaveProfileDescription(
            name: name,
            description: description,
          );
          if (mounted && target.isCurrent) {
            await _reload(silent: true);
          }
        },
        onAutoDescribeProfile: (name) async {
          final target = await _bound();
          final res = await target.kanbanDescribeProfileAuto(name);
          if (mounted && target.isCurrent) {
            if (!res.ok) {
              _toast(
                res.reason ??
                    context.sharedL10n.ng_board_auto_describe_unavailable,
              );
            } else {
              _toast(context.sharedL10n.ng_board_description_updated(name));
              await _reload(silent: true);
            }
          }
          return res.description;
        },
      ),
    );
  }

  void _maybeFocusInitialCard(KanbanBoardSnapshot snap) {
    final id = _pendingInitialCardId;
    if (id == null) return;
    final wantedBoard = _pendingInitialBoard;
    if (wantedBoard != null && _effectiveSlug != wantedBoard) return;
    final card = snap.allTasks.where((t) => t.id == id).firstOrNull;
    if (card == null) return; // Not loaded yet; next reload retries.
    _pendingInitialCardId = null;
    _pendingInitialBoard = null;
    unawaited(_openTaskDetail(card));
  }

  Future<void> _openTaskDetail(KanbanTaskCard summary) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _KanbanTaskDetailSheet(
        taskId: summary.id,
        board: _queryBoard,
        allTasks: _snapshot?.allTasks ?? const [],
        profiles: _profiles,
        enableLivePolling: widget.enableLivePolling,
        boundTarget: _bound,
        describeError: _describeError,
        onChanged: () => _reload(silent: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    final snap = _snapshot;
    final activeCount = snap?.activeWorkCount ?? 0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.onClose == null,
        leading: widget.onClose == null
            ? null
            : IconButton(
                key: const Key('kanban-close'),
                tooltip: l10n.ng_kanban_close,
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
              ),
        title: InkWell(
          key: const Key('kanban-board-switcher'),
          borderRadius: BorderRadius.circular(8),
          onTap: _failure == null ? _openBoardSwitcher : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    context.sharedL10n.ng_board_title(_effectiveSlug),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.expand_more, size: 18),
                if (activeCount > 0) ...[
                  const SizedBox(width: 8),
                  // On a phone or in the chat's side pane the title shares
                  // a narrow bar with three actions: the badge gives way
                  // instead of overflowing.
                  Flexible(
                    child: Container(
                      key: const Key('kanban-active-count'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        context.sharedL10n.ng_board_active('$activeCount'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            key: const Key('kanban-dispatch-button'),
            tooltip: context.sharedL10n.ng_board_dispatch,
            icon: const Icon(Icons.play_circle_outline),
            onPressed: snap == null ? null : _dispatchNow,
          ),
          IconButton(
            key: const Key('kanban-orchestration-button'),
            tooltip: context.sharedL10n.ng_board_orchestration,
            icon: const Icon(Icons.tune),
            onPressed: snap == null ? null : _openOrchestrationSheet,
          ),
          IconButton(
            key: const Key('kanban-refresh-button'),
            tooltip: l10n.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => _reload(rebindEvents: true),
          ),
        ],
      ),
      floatingActionButton: snap == null
          ? null
          : FloatingActionButton.extended(
              key: const Key('kanban-new-task-button'),
              onPressed: _openNewTaskDialog,
              icon: const Icon(Icons.add),
              label: Text(context.sharedL10n.ng_board_new_task),
            ),
      bottomNavigationBar: _selectedIds.isEmpty ? null : _buildSelectionBar(),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading && _snapshot == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_failure != null && _snapshot == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.view_kanban_outlined, size: 48),
              const SizedBox(height: 12),
              Text(
                _errorDetail ?? _describeError(WorkspaceException(_failure!)),
                textAlign: TextAlign.center,
              ),
              if (_failure == WorkspaceFailure.unsupported) ...[
                const SizedBox(height: 8),
                Text(
                  context.sharedL10n.ng_board_enable_plugin,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _reload(rebindEvents: true),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    final snap = _snapshot!;
    return LayoutBuilder(
      builder: (context, body) => Column(
        children: [
          // The pinned boards and filters never take more than about a third
          // of the board: with large text or the keyboard up they scroll.
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: body.maxHeight * 0.35),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_pinnedBoards.isNotEmpty) _buildPinnedTabs(),
                  _buildFilterBar(snap),
                ],
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 640) {
                  return _buildNarrowBoard(snap);
                }
                return _buildWideBoard(snap);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          for (final slug in _pinnedBoards)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: InputChip(
                key: Key('kanban-pinned-tab-$slug'),
                selected: slug == _effectiveSlug,
                label: Text(slug),
                onSelected: (_) => _selectBoard(slug),
                onDeleted: () => _togglePinBoard(slug),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(KanbanBoardSnapshot snap) {
    final assignees = <String>{
      ...snap.assignees,
      for (final p in _profiles) p.name,
    }.toList()..sort();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 210,
            child: TextField(
              key: const Key('kanban-search'),
              controller: _searchController,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(Icons.search, size: 18),
                hintText: context.sharedL10n.ng_board_filter,
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: _searchController.clear,
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          // Bounded, so a long name or large text is cut short rather than
          // overflowing a narrow board (a phone, the chat's side pane).
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                key: const Key('kanban-assignee-filter'),
                isExpanded: true,
                value: _assigneeFilter,
                hint: Text(context.sharedL10n.ng_board_all_assignees),
                items: [
                  DropdownMenuItem(
                    value: '',
                    child: Text(
                      context.sharedL10n.ng_board_all_assignees,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DropdownMenuItem(
                    value: '__unassigned__',
                    child: Text(
                      context.sharedL10n.ng_board_unassigned,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  for (final name in assignees)
                    DropdownMenuItem(
                      value: name,
                      child: Text('@$name', overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (v) => setState(() => _assigneeFilter = v ?? ''),
              ),
            ),
          ),
          if (_cardFilter case final only?)
            InputChip(
              key: const Key('kanban-chat-filter'),
              avatar: const Icon(Icons.forum_outlined, size: 16),
              label: Text(context.sharedL10n.ng_kanban_this_chat(only.length)),
              onDeleted: () => setState(() => _cardFilter = null),
            ),
          FilterChip(
            key: const Key('kanban-archived-toggle'),
            label: Text(context.sharedL10n.ng_kanban_status_archived),
            selected: _includeArchived,
            onSelected: (v) {
              setState(() => _includeArchived = v);
              unawaited(_reload(rebindEvents: true));
            },
          ),
          FilterChip(
            key: const Key('kanban-lanes-by-profile'),
            label: Text(context.sharedL10n.ng_board_running_by_profile),
            selected: _lanesByProfile,
            onSelected: (v) {
              setState(() => _lanesByProfile = v);
              unawaited(_prefs?.setLanesByProfile(v));
            },
          ),
          FilterChip(
            key: const Key('kanban-multiselect-toggle'),
            label: Text(
              _selectedIds.isEmpty
                  ? context.sharedL10n.ng_board_select
                  : context.sharedL10n.ng_board_selected_chip(
                      '${_selectedIds.length}',
                    ),
            ),
            selected: _selectionMode || _selectedIds.isNotEmpty,
            onSelected: (v) {
              setState(() {
                _selectionMode = v;
                if (!v) _selectedIds.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWideBoard(KanbanBoardSnapshot snap) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
      children: [
        for (final col in snap.columns) _buildColumnWidget(col, wide: true),
      ],
    );
  }

  Widget _buildNarrowBoard(KanbanBoardSnapshot snap) {
    final safeIdx = _narrowColumnIndex.clamp(0, snap.columns.length - 1);
    final col = snap.columns[safeIdx];
    return Column(
      children: [
        // Sized by its chips, so large text makes the row taller rather
        // than clipping it.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
          child: Row(
            children: [
              for (var idx = 0; idx < snap.columns.length; idx++)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    key: Key('kanban-tab-${snap.columns[idx].name}'),
                    selected: idx == safeIdx,
                    label: Text(
                      '${_columnLabel(context, snap.columns[idx].name)} '
                      '(${_filterTasks(snap.columns[idx].tasks).length})',
                    ),
                    onSelected: (_) => setState(() {
                      _narrowColumnPicked = true;
                      _narrowColumnIndex = idx;
                    }),
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: _buildColumnWidget(col, wide: false)),
      ],
    );
  }

  Widget _buildColumnWidget(KanbanColumn col, {required bool wide}) {
    final tasks = _filterTasks(col.tasks);
    final overrideCollapsed = _collapsedLanes[col.name];
    final collapsed =
        wide && (overrideCollapsed ?? (tasks.isEmpty && col.isDragLocked));

    if (collapsed) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: InkWell(
          key: Key('kanban-collapsed-${col.name}'),
          onTap: () {
            setState(
              () => _collapsedLanes = {..._collapsedLanes, col.name: false},
            );
            unawaited(_prefs?.setLaneCollapsed(col.name, false));
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                const Icon(Icons.unfold_more, size: 16),
                const SizedBox(height: 8),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    '${_columnLabel(context, col.name)} (${tasks.length})',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final columnContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 6),
          child: Row(
            children: [
              if (col.isDragLocked) ...[
                Tooltip(
                  message: context.sharedL10n.ng_board_locked_column,
                  child: Icon(Icons.lock_outline, size: 15),
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  '${_columnLabel(context, col.name)} · ${tasks.length}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (!col.isDragLocked)
                IconButton(
                  tooltip: context.sharedL10n.ng_board_add_to(
                    _columnLabel(context, col.name),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _openNewTaskDialog(initialColumn: col.name),
                ),
              if (wide)
                IconButton(
                  tooltip: context.sharedL10n.ng_board_collapse(
                    _columnLabel(context, col.name),
                  ),
                  icon: const Icon(Icons.unfold_less, size: 16),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    setState(
                      () => _collapsedLanes = {
                        ..._collapsedLanes,
                        col.name: true,
                      },
                    );
                    unawaited(_prefs?.setLaneCollapsed(col.name, true));
                  },
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Text(
                    col.isDragLocked
                        ? context.sharedL10n.ng_board_column_empty(
                            _columnLabel(context, col.name),
                          )
                        : context.sharedL10n.ng_board_drop_here,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              : _buildTaskList(col, tasks, wide: wide),
        ),
      ],
    );

    if (wide) {
      return DragTarget<KanbanTaskCard>(
        key: Key('kanban-column-${col.name}'),
        onWillAcceptWithDetails: (details) =>
            !col.isDragLocked && details.data.status != col.name,
        onAcceptWithDetails: (details) =>
            _moveTaskToStatus(details.data, col.name),
        builder: (context, candidates, rejected) {
          final highlighted = candidates.isNotEmpty;
          return Container(
            width: 292,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: highlighted
                  ? Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.25)
                  : Theme.of(context).colorScheme.surfaceContainerLow,
              border: Border.all(
                color: highlighted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: columnContent,
          );
        },
      );
    }
    return columnContent;
  }

  Widget _buildTaskList(
    KanbanColumn col,
    List<KanbanTaskCard> tasks, {
    required bool wide,
  }) {
    if (col.name == 'running' && _lanesByProfile) {
      final grouped = <String, List<KanbanTaskCard>>{};
      for (final t in tasks) {
        grouped.putIfAbsent(t.assignee ?? '', () => []).add(t);
      }
      final keys = grouped.keys.toList()..sort();
      return ListView(
        padding: const EdgeInsets.all(8),
        children: [
          for (final profile in keys) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                profile.isEmpty
                    ? '${context.sharedL10n.ng_board_unassigned} '
                          '(${grouped[profile]!.length})'
                    : '@$profile (${grouped[profile]!.length})',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            for (final task in grouped[profile]!)
              _buildDraggableCard(task, wide: wide),
          ],
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (context, index) =>
          _buildDraggableCard(tasks[index], wide: wide),
    );
  }

  /// Phones and tablets drag with a long press, so a swipe that starts on a
  /// card still scrolls its column (and the board); a mouse drags at once.
  static bool get _touchDrag => switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.fuchsia => true,
    _ => false,
  };

  Widget _buildDraggableCard(KanbanTaskCard task, {required bool wide}) {
    final card = _buildTaskCard(task, includeKeys: true, touchDrag: wide);
    // One column at a time has nowhere to drop: the card's menu moves it.
    if (!wide) return card;
    final ghost = _buildTaskCard(task, includeKeys: false);
    final feedback = Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(width: 268, child: ghost),
    );
    final dimmed = Opacity(opacity: 0.4, child: ghost);
    if (!_touchDrag) {
      return Draggable<KanbanTaskCard>(
        data: task,
        feedback: feedback,
        childWhenDragging: dimmed,
        child: card,
      );
    }
    // A long press picks the card up. Let go without moving and it is a
    // plain long press after all: the card is selected.
    return Builder(
      builder: (context) {
        Offset? origin;
        return LongPressDraggable<KanbanTaskCard>(
          data: task,
          feedback: feedback,
          childWhenDragging: dimmed,
          hapticFeedbackOnStart: true,
          onDragStarted: () {
            final box = context.findRenderObject();
            origin = box is RenderBox && box.hasSize
                ? box.localToGlobal(Offset.zero)
                : null;
          },
          onDragEnd: (details) {
            final start = origin;
            if (details.wasAccepted || start == null || !mounted) return;
            if ((details.offset - start).distance < kTouchSlop) {
              _selectCard(task);
            }
          },
          child: card,
        );
      },
    );
  }

  void _selectCard(KanbanTaskCard task) {
    setState(() {
      _selectionMode = true;
      _selectedIds.add(task.id);
    });
  }

  /// [touchDrag]: the card sits in a long-press draggable on a touch screen,
  /// which owns the long press (see [_buildDraggableCard]).
  Widget _buildTaskCard(
    KanbanTaskCard task, {
    required bool includeKeys,
    bool touchDrag = false,
  }) {
    final selected = _selectedIds.contains(task.id);
    final allowedMoves = kanbanAllowedManualTargets(task.status);
    return Card(
      key: includeKeys ? Key('kanban-card-${task.id}') : null,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: selected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (_selectionMode || _selectedIds.isNotEmpty) {
            setState(() {
              if (selected) {
                _selectedIds.remove(task.id);
              } else {
                _selectedIds.add(task.id);
              }
            });
          } else {
            unawaited(_openTaskDetail(task));
          }
        },
        onLongPress: touchDrag && _touchDrag ? null : () => _selectCard(task),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (_selectionMode || _selectedIds.isNotEmpty)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        key: includeKeys
                            ? Key('kanban-select-${task.id}')
                            : null,
                        value: selected,
                        onChanged: (v) {
                          setState(() {
                            if (v == true) {
                              _selectedIds.add(task.id);
                            } else {
                              _selectedIds.remove(task.id);
                            }
                          });
                        },
                      ),
                    ),
                  Expanded(
                    child: Text(
                      task.id,
                      style: Theme.of(context).textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (task.priority != 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        'P${task.priority}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  PopupMenuButton<String>(
                    key: includeKeys ? Key('kanban-move-${task.id}') : null,
                    tooltip: context.sharedL10n.ng_board_card_actions,
                    icon: const Icon(Icons.more_horiz, size: 18),
                    padding: EdgeInsets.zero,
                    onSelected: (action) {
                      if (action == '__open__') {
                        unawaited(_openTaskDetail(task));
                      } else if (action == '__select__') {
                        _selectCard(task);
                      } else if (action.startsWith('move:')) {
                        unawaited(_moveTaskToStatus(task, action.substring(5)));
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: '__open__',
                        child: Text(context.sharedL10n.ng_board_open_details),
                      ),
                      PopupMenuItem(
                        value: '__select__',
                        child: Text(context.sharedL10n.ng_board_select_card),
                      ),
                      const PopupMenuDivider(),
                      for (final target in allowedMoves)
                        PopupMenuItem(
                          value: 'move:$target',
                          child: Text(
                            context.sharedL10n.ng_board_move_to(
                              _columnLabel(context, target),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                task.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Chip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Text(
                      task.assignee == null
                          ? context.sharedL10n.ng_board_parked
                          : '@${task.assignee}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  if (task.openParentCount > 0)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        context.sharedL10n.ng_board_blocked_by(
                          '${task.openParentCount}',
                        ),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  if (task.modelOverride != null &&
                      task.modelOverride!.isNotEmpty)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        task.modelOverride!,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  if (task.goalMode)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        context.sharedL10n.ng_board_goal_loop,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionBar() {
    final unlockedTargets = [
      for (final col in kanbanWorkflowColumns)
        if (!kanbanLockedDragColumns.contains(col)) col,
    ];
    return Material(
      key: const Key('kanban-selection-bar'),
      elevation: 8,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                context.sharedL10n.ng_board_selected('${_selectedIds.length}'),
              ),
              PopupMenuButton<String>(
                key: const Key('kanban-bulk-move'),
                onSelected: _runBulkMove,
                itemBuilder: (_) => [
                  for (final col in unlockedTargets)
                    PopupMenuItem(
                      value: col,
                      child: Text(
                        context.sharedL10n.ng_board_move_to(
                          _columnLabel(context, col),
                        ),
                      ),
                    ),
                ],
                child: Chip(label: Text(context.sharedL10n.ng_board_move_menu)),
              ),
              PopupMenuButton<String>(
                key: const Key('kanban-bulk-assign'),
                onSelected: _runBulkAssign,
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: '',
                    child: Text(context.sharedL10n.ng_board_unassign),
                  ),
                  for (final p in _profiles)
                    PopupMenuItem(value: p.name, child: Text('@${p.name}')),
                ],
                child: Chip(
                  label: Text(context.sharedL10n.ng_board_assign_menu),
                ),
              ),
              ActionChip(
                key: const Key('kanban-bulk-archive'),
                label: Text(context.sharedL10n.ng_archive),
                onPressed: _runBulkArchive,
              ),
              ActionChip(
                key: const Key('kanban-bulk-delete'),
                label: Text(context.sharedL10n.ng_delete),
                onPressed: _runBulkDelete,
              ),
              TextButton(
                onPressed: () => setState(() {
                  _selectedIds.clear();
                  _selectionMode = false;
                }),
                child: Text(context.sharedL10n.ng_clear),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoardSwitcherSheet extends StatefulWidget {
  const _BoardSwitcherSheet({
    required this.boards,
    required this.activeSlug,
    required this.pinnedSlugs,
    required this.projects,
    required this.onSelect,
    required this.onTogglePin,
    required this.onMovePin,
    required this.onCreateBoard,
    required this.onPatchBoard,
    required this.onArchiveBoard,
    required this.onExportBoard,
    required this.onImportBoard,
  });

  final List<KanbanBoardMeta> boards;
  final String activeSlug;
  final List<String> pinnedSlugs;
  final List<KanbanProjectEntry> projects;
  final ValueChanged<String> onSelect;
  final Future<void> Function(String slug) onTogglePin;
  final Future<void> Function(String slug, String target) onMovePin;
  final Future<void> Function(
    String slug,
    String name,
    String? projectId,
    String? workdir,
  )
  onCreateBoard;
  final Future<void> Function(
    String slug,
    String? name,
    String? desc,
    String? workdir,
    String? projectId,
  )
  onPatchBoard;
  final Future<void> Function(String slug) onArchiveBoard;
  final Future<void> Function(String slug, String? output) onExportBoard;
  final Future<void> Function(String archive) onImportBoard;

  @override
  State<_BoardSwitcherSheet> createState() => _BoardSwitcherSheetState();
}

class _BoardSwitcherSheetState extends State<_BoardSwitcherSheet> {
  String _search = '';
  late final List<String> _pins = List<String>.from(widget.pinnedSlugs);

  Future<void> _showCreateDialog() async {
    final slugCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final workdirCtrl = TextEditingController();
    String? projectId;
    try {
      final created = await showDialog<bool>(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setModal) => AlertDialog(
            title: Text(context.sharedL10n.ng_board_new_board_title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    key: const Key('kanban-create-board-slug'),
                    controller: slugCtrl,
                    decoration: InputDecoration(
                      labelText: context.sharedL10n.ng_board_slug,
                    ),
                  ),
                  TextField(
                    key: const Key('kanban-create-board-name'),
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: context.sharedL10n.ng_board_display_name,
                    ),
                  ),
                  if (widget.projects.isNotEmpty)
                    DropdownButtonFormField<String?>(
                      isExpanded: true,
                      initialValue: projectId,
                      decoration: InputDecoration(
                        labelText: context.sharedL10n.ng_board_linked_project,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            context.sharedL10n.ng_board_none,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        for (final p in widget.projects)
                          DropdownMenuItem(
                            value: p.id,
                            child: Text(
                              p.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (v) => setModal(() => projectId = v),
                    ),
                  TextField(
                    controller: workdirCtrl,
                    decoration: InputDecoration(
                      labelText: context.sharedL10n.ng_board_default_workdir,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(ctx.sharedL10n.cancel),
              ),
              FilledButton(
                key: const Key('kanban-create-board-submit'),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(context.sharedL10n.ng_create),
              ),
            ],
          ),
        ),
      );
      if (created != true || !mounted) return;
      final slug = slugCtrl.text.trim();
      final name = nameCtrl.text.trim().isEmpty ? slug : nameCtrl.text.trim();
      await widget.onCreateBoard(
        slug,
        name,
        projectId,
        workdirCtrl.text.trim().isEmpty ? null : workdirCtrl.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } finally {
      slugCtrl.dispose();
      nameCtrl.dispose();
      workdirCtrl.dispose();
    }
  }

  Future<void> _showImportDialog() async {
    final pathCtrl = TextEditingController();
    try {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(context.sharedL10n.ng_board_import_title),
          content: TextField(
            key: const Key('kanban-import-board-path'),
            controller: pathCtrl,
            decoration: InputDecoration(
              labelText: context.sharedL10n.ng_board_import_path,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(ctx.sharedL10n.cancel),
            ),
            FilledButton(
              key: const Key('kanban-import-board-submit'),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(context.sharedL10n.ng_board_import),
            ),
          ],
        ),
      );
      if (ok == true && pathCtrl.text.trim().isNotEmpty && mounted) {
        await widget.onImportBoard(pathCtrl.text.trim());
        if (mounted) Navigator.pop(context);
      }
    } finally {
      pathCtrl.dispose();
    }
  }

  Future<void> _showEditBoardDialog(KanbanBoardMeta board) async {
    final nameCtrl = TextEditingController(text: board.name);
    final descCtrl = TextEditingController(text: board.description);
    final workdirCtrl = TextEditingController(text: board.defaultWorkdir ?? '');
    try {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(context.sharedL10n.ng_board_edit_board(board.slug)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: context.sharedL10n.ng_board_name,
                  ),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: InputDecoration(
                    labelText: context.sharedL10n.ng_board_description,
                  ),
                ),
                TextField(
                  controller: workdirCtrl,
                  decoration: InputDecoration(
                    labelText: context.sharedL10n.ng_board_workdir_clear,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(ctx.sharedL10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(ctx.sharedL10n.save),
            ),
          ],
        ),
      );
      if (ok == true && mounted) {
        await widget.onPatchBoard(
          board.slug,
          nameCtrl.text.trim(),
          descCtrl.text.trim(),
          workdirCtrl.text.trim(),
          null,
        );
        if (mounted) Navigator.pop(context);
      }
    } finally {
      nameCtrl.dispose();
      descCtrl.dispose();
      workdirCtrl.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = [
      for (final b in widget.boards)
        if (_search.isEmpty ||
            b.slug.toLowerCase().contains(_search.toLowerCase()) ||
            b.name.toLowerCase().contains(_search.toLowerCase()))
          b,
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.sharedL10n.ng_board_boards,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  key: const Key('kanban-import-board-btn'),
                  onPressed: _showImportDialog,
                  icon: const Icon(Icons.file_upload_outlined, size: 18),
                  label: Text(context.sharedL10n.ng_board_import),
                ),
                FilledButton.tonalIcon(
                  key: const Key('kanban-new-board-btn'),
                  onPressed: _showCreateDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(context.sharedL10n.ng_board_new_board),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(Icons.search, size: 18),
                hintText: context.sharedL10n.ng_board_search_boards,
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _search = v.trim()),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: visible.length,
                itemBuilder: (ctx, idx) {
                  final board = visible[idx];
                  final pinned = _pins.contains(board.slug);
                  return ListTile(
                    key: Key('kanban-board-row-${board.slug}'),
                    selected: board.slug == widget.activeSlug,
                    title: Text('${board.name} (${board.slug})'),
                    subtitle: Text(
                      '${_kanbanCardCount(context, board.total)} · ${context.sharedL10n.ng_board_active('${board.activeWorkCount}')} · ${_workspaceKindLabel(context.sharedL10n, board.defaultWorkspaceKind)}',
                    ),
                    onTap: () => widget.onSelect(board.slug),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          key: Key('kanban-pin-${board.slug}'),
                          tooltip: pinned
                              ? context.sharedL10n.ng_board_unpin
                              : context.sharedL10n.ng_board_pin,
                          icon: Icon(
                            pinned ? Icons.push_pin : Icons.push_pin_outlined,
                            size: 18,
                          ),
                          onPressed: () async {
                            await widget.onTogglePin(board.slug);
                            setState(() {
                              if (pinned) {
                                _pins.remove(board.slug);
                              } else {
                                _pins.add(board.slug);
                              }
                            });
                          },
                        ),
                        PopupMenuButton<String>(
                          key: Key('kanban-board-menu-${board.slug}'),
                          onSelected: (action) async {
                            if (action == 'edit') {
                              await _showEditBoardDialog(board);
                            } else if (action == 'export') {
                              await widget.onExportBoard(board.slug, '');
                              if (context.mounted) Navigator.pop(context);
                            } else if (action == 'archive') {
                              final confirmed = await _confirmKanbanAction(
                                context,
                                title: context.sharedL10n
                                    .ng_board_archive_board_title(board.slug),
                                message: context.sharedL10n
                                    .ng_board_archive_board_body(
                                      _kanbanCardCount(context, board.total),
                                    ),
                                confirmLabel: context.sharedL10n.ng_archive,
                              );
                              if (!confirmed || !context.mounted) return;
                              await widget.onArchiveBoard(board.slug);
                              if (context.mounted) Navigator.pop(context);
                            } else if (action == 'left' && pinned) {
                              final i = _pins.indexOf(board.slug);
                              if (i > 0) {
                                final prev = _pins[i - 1];
                                await widget.onMovePin(board.slug, prev);
                                setState(() {
                                  _pins.removeAt(i);
                                  _pins.insert(i - 1, board.slug);
                                });
                              }
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(
                                context.sharedL10n.ng_board_edit_metadata,
                              ),
                            ),
                            PopupMenuItem(
                              value: 'export',
                              child: Text(context.sharedL10n.ng_board_export),
                            ),
                            if (pinned && _pins.indexOf(board.slug) > 0)
                              PopupMenuItem(
                                value: 'left',
                                child: Text(
                                  context.sharedL10n.ng_board_move_pin_left,
                                ),
                              ),
                            if (board.slug != 'default')
                              PopupMenuItem(
                                value: 'archive',
                                child: Text(
                                  context.sharedL10n.ng_board_archive_board,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _workspaceKindLabel(AppLocalizations l10n, String kind) =>
    switch (kind) {
      'scratch' => l10n.ng_board_scratch,
      'worktree' => l10n.ng_board_worktree,
      'dir' => l10n.ng_board_shared_dir,
      _ => kind,
    };

class _NewTaskSpec {
  const _NewTaskSpec({
    required this.title,
    this.body,
    required this.targetColumn,
    this.assignee,
    required this.priority,
    required this.workspaceKind,
    this.workspacePath,
    this.projectId,
    this.parentId,
    this.skills,
    required this.goalMode,
    this.goalMaxTurns,
    this.providerOverride,
    this.modelOverride,
    this.reasoningEffort,
  });

  final String title;
  final String? body;
  final String targetColumn;
  final String? assignee;
  final int priority;
  final String workspaceKind;
  final String? workspacePath;
  final String? projectId;
  final String? parentId;
  final List<String>? skills;
  final bool goalMode;
  final int? goalMaxTurns;
  final String? providerOverride;
  final String? modelOverride;
  final String? reasoningEffort;
}

class _NewTaskDialog extends StatefulWidget {
  const _NewTaskDialog({
    required this.boardMeta,
    required this.initialColumn,
    required this.profiles,
    required this.projects,
    required this.existingTasks,
    required this.orchestration,
    required this.onEstimate,
    required this.onCreate,
  });

  final KanbanBoardMeta? boardMeta;
  final String initialColumn;
  final List<KanbanProfileEntry> profiles;
  final List<KanbanProjectEntry> projects;
  final List<KanbanTaskCard> existingTasks;
  final KanbanOrchestration? orchestration;
  final Future<KanbanTaskEstimate> Function(String title, String? body)
  onEstimate;
  final Future<void> Function(_NewTaskSpec spec) onCreate;

  @override
  State<_NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<_NewTaskDialog> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _priority = TextEditingController(text: '0');
  late final TextEditingController _workspacePath = TextEditingController(
    text: widget.boardMeta?.defaultWorkdir ?? '',
  );
  final _skills = TextEditingController();
  final _provider = TextEditingController();
  final _model = TextEditingController();
  final _goalTurns = TextEditingController();

  late String _column = kanbanLockedDragColumns.contains(widget.initialColumn)
      ? 'ready'
      : widget.initialColumn;
  late String _assignee =
      widget.orchestration?.resolvedDefaultAssignee ??
      (widget.profiles.isNotEmpty ? widget.profiles.first.name : '');
  late String _workspaceKind =
      widget.boardMeta?.defaultWorkspaceKind ?? 'scratch';
  late final String? _projectId = widget.boardMeta?.projectId;
  String? _parentId;
  String _reasoningEffort = '';
  bool _goalMode = false;
  bool _submitting = false;
  KanbanTaskEstimate? _estimate;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _priority.dispose();
    _workspacePath.dispose();
    _skills.dispose();
    _provider.dispose();
    _model.dispose();
    _goalTurns.dispose();
    super.dispose();
  }

  Future<void> _estimateComplexity() async {
    if (_title.text.trim().isEmpty) return;
    final res = await widget.onEstimate(_title.text.trim(), _body.text.trim());
    if (mounted) setState(() => _estimate = res);
  }

  Future<void> _submit() async {
    final title = _title.text.trim();
    if (title.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    try {
      final rawSkills = _skills.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      await widget.onCreate(
        _NewTaskSpec(
          title: title,
          body: _body.text.trim().isEmpty ? null : _body.text.trim(),
          targetColumn: _column,
          assignee: _assignee == '__parked__' || _assignee.isEmpty
              ? null
              : _assignee,
          priority: int.tryParse(_priority.text.trim()) ?? 0,
          workspaceKind: _workspaceKind,
          workspacePath:
              _workspaceKind == 'scratch' || _workspacePath.text.trim().isEmpty
              ? null
              : _workspacePath.text.trim(),
          projectId: _projectId,
          parentId: _parentId,
          skills: rawSkills.isEmpty ? null : rawSkills,
          goalMode: _goalMode,
          goalMaxTurns: int.tryParse(_goalTurns.text.trim()),
          providerOverride: _provider.text.trim().isEmpty
              ? null
              : _provider.text.trim(),
          modelOverride: _model.text.trim().isEmpty ? null : _model.text.trim(),
          reasoningEffort: _reasoningEffort.isEmpty ? null : _reasoningEffort,
        ),
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    return AlertDialog(
      // Title, fields and buttons scroll as one, above the keyboard.
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      title: Text(context.sharedL10n.ng_board_new_task_title),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('kanban-new-title'),
              controller: _title,
              autofocus: true,
              decoration: InputDecoration(
                labelText: context.sharedL10n.ng_board_title_required,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('kanban-new-body'),
              controller: _body,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: context.sharedL10n.ng_board_spec,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton.icon(
                  key: Key('kanban-new-estimate'),
                  onPressed: _estimateComplexity,
                  icon: Icon(Icons.analytics_outlined, size: 18),
                  label: Text(context.sharedL10n.ng_board_estimate),
                ),
                if (_estimate != null)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      _estimate!.ok
                          ? context.sharedL10n.ng_board_estimate_draft(
                              _estimate!.complexity ?? '?',
                              '${_estimate!.estTokens ?? 0}',
                            )
                          : (_estimate!.reason ??
                                context
                                    .sharedL10n
                                    .ng_board_estimate_unavailable),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
            DropdownButtonFormField<String>(
              isExpanded: true,
              key: Key('kanban-new-column'),
              initialValue: _column,
              decoration: InputDecoration(
                labelText: context.sharedL10n.ng_board_initial_column,
              ),
              items: [
                DropdownMenuItem(
                  value: 'ready',
                  child: Text(
                    context.sharedL10n.ng_kanban_status_ready,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'todo',
                  child: Text(
                    context.sharedL10n.ng_kanban_status_todo,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'triage',
                  child: Text(
                    context.sharedL10n.ng_kanban_status_triage,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'blocked',
                  child: Text(
                    context.sharedL10n.ng_kanban_status_blocked,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              onChanged: (v) => setState(() => _column = v ?? 'ready'),
            ),
            DropdownButtonFormField<String>(
              isExpanded: true,
              key: const Key('kanban-new-assignee'),
              initialValue: widget.profiles.any((p) => p.name == _assignee)
                  ? _assignee
                  : '__parked__',
              decoration: InputDecoration(
                labelText: context.sharedL10n.ng_board_worker_assignee,
              ),
              items: [
                DropdownMenuItem(
                  value: '__parked__',
                  child: Text(
                    context.sharedL10n.ng_board_parked_unassigned,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                for (final p in widget.profiles)
                  DropdownMenuItem(
                    value: p.name,
                    child: Text('@${p.name}', overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) => setState(() => _assignee = v ?? '__parked__'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('kanban-new-priority'),
                    controller: _priority,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.sharedL10n.ng_board_priority,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    key: Key('kanban-new-workspace-kind'),
                    initialValue: _workspaceKind,
                    decoration: InputDecoration(
                      labelText: context.sharedL10n.ng_board_workspace,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'scratch',
                        child: Text(
                          context.sharedL10n.ng_board_scratch,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'worktree',
                        child: Text(
                          context.sharedL10n.ng_board_worktree,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'dir',
                        child: Text(
                          context.sharedL10n.ng_board_shared_dir,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => _workspaceKind = v ?? 'scratch'),
                  ),
                ),
              ],
            ),
            if (_workspaceKind != 'scratch')
              TextField(
                key: Key('kanban-new-workspace-path'),
                controller: _workspacePath,
                decoration: InputDecoration(
                  labelText: context.sharedL10n.ng_board_workspace_path,
                ),
              ),
            if (widget.existingTasks.isNotEmpty)
              DropdownButtonFormField<String?>(
                key: Key('kanban-new-parent'),
                initialValue: _parentId,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: context.sharedL10n.ng_board_parent,
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                      context.sharedL10n.ng_board_none,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  for (final t in widget.existingTasks)
                    DropdownMenuItem(
                      value: t.id,
                      child: Text(
                        '${t.id}: ${t.title}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _parentId = v),
              ),
            TextField(
              key: Key('kanban-new-skills'),
              controller: _skills,
              decoration: InputDecoration(
                labelText: context.sharedL10n.ng_board_skills,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: Key('kanban-new-provider'),
                    controller: _provider,
                    decoration: InputDecoration(
                      labelText: context.sharedL10n.ng_board_provider_override,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    key: Key('kanban-new-model'),
                    controller: _model,
                    decoration: InputDecoration(
                      labelText: context.sharedL10n.ng_board_model_override,
                    ),
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _reasoningEffort,
              decoration: InputDecoration(
                labelText: context.sharedL10n.ng_board_reasoning,
              ),
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text(
                    context.sharedL10n.ng_board_profile_default,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'none',
                  child: Text(
                    context.sharedL10n.ng_board_none,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'minimal',
                  child: Text(
                    context.sharedL10n.ng_minimal,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'low',
                  child: Text(
                    context.sharedL10n.ng_low,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'medium',
                  child: Text(
                    context.sharedL10n.ng_medium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'high',
                  child: Text(
                    context.sharedL10n.ng_high,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'xhigh',
                  child: Text(
                    context.sharedL10n.ng_board_xhigh,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              onChanged: (v) => setState(() => _reasoningEffort = v ?? ''),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.sharedL10n.ng_board_goal_mode),
              value: _goalMode,
              onChanged: (v) => setState(() => _goalMode = v),
            ),
            if (_goalMode)
              TextField(
                controller: _goalTurns,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.sharedL10n.ng_board_goal_turns,
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('kanban-new-submit'),
          onPressed: _submitting ? null : _submit,
          child: Text(context.sharedL10n.ng_board_create_task),
        ),
      ],
    );
  }
}

class _OrchestrationSheet extends StatefulWidget {
  const _OrchestrationSheet({
    required this.initial,
    required this.profiles,
    required this.onSaveOrchestration,
    required this.onSaveProfileDescription,
    required this.onAutoDescribeProfile,
  });

  final KanbanOrchestration initial;
  final List<KanbanProfileEntry> profiles;
  final Future<KanbanOrchestration> Function(
    String orchestrator,
    String defaultAssignee,
    bool autoDecompose,
  )
  onSaveOrchestration;
  final Future<void> Function(String name, String description)
  onSaveProfileDescription;
  final Future<String> Function(String name) onAutoDescribeProfile;

  @override
  State<_OrchestrationSheet> createState() => _OrchestrationSheetState();
}

class _OrchestrationSheetState extends State<_OrchestrationSheet> {
  late String _orchestrator = widget.initial.orchestratorProfile ?? '';
  late String _defaultAssignee = widget.initial.defaultAssignee ?? '';
  late bool _autoDecompose = widget.initial.autoDecompose;
  late final Map<String, TextEditingController> _descControllers = {
    for (final p in widget.profiles)
      p.name: TextEditingController(text: p.description),
  };

  @override
  void dispose() {
    for (final c in _descControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final names = {for (final p in widget.profiles) p.name};
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.sharedL10n.ng_board_orchestration_title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                isExpanded: true,
                key: const Key('kanban-orch-profile'),
                initialValue: names.contains(_orchestrator)
                    ? _orchestrator
                    : '',
                decoration: InputDecoration(
                  labelText: context.sharedL10n.ng_board_orchestrator(
                    widget.initial.resolvedOrchestratorProfile ?? 'default',
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: '',
                    child: Text(
                      context.sharedL10n.ng_board_inherit_default,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  for (final p in widget.profiles)
                    DropdownMenuItem(
                      value: p.name,
                      child: Text(
                        '@${p.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _orchestrator = v ?? ''),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                isExpanded: true,
                key: const Key('kanban-default-assignee'),
                initialValue: names.contains(_defaultAssignee)
                    ? _defaultAssignee
                    : '',
                decoration: InputDecoration(
                  labelText: context.sharedL10n.ng_board_default_assignee(
                    widget.initial.resolvedDefaultAssignee ?? 'default',
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: '',
                    child: Text(
                      context.sharedL10n.ng_board_inherit_default,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  for (final p in widget.profiles)
                    DropdownMenuItem(
                      value: p.name,
                      child: Text(
                        '@${p.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _defaultAssignee = v ?? ''),
              ),
              SwitchListTile(
                key: const Key('kanban-auto-decompose'),
                contentPadding: EdgeInsets.zero,
                title: Text(context.sharedL10n.ng_board_auto_decompose),
                subtitle: Text(context.sharedL10n.ng_board_auto_decompose_help),
                value: _autoDecompose,
                onChanged: (v) => setState(() => _autoDecompose = v),
              ),
              FilledButton(
                key: const Key('kanban-save-orchestration'),
                onPressed: () async {
                  await widget.onSaveOrchestration(
                    _orchestrator,
                    _defaultAssignee,
                    _autoDecompose,
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text(context.sharedL10n.ng_board_save_orchestration),
              ),
              const Divider(height: 28),
              Text(
                context.sharedL10n.ng_board_worker_descriptions,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              for (final p in widget.profiles)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: Key('kanban-worker-desc-${p.name}'),
                          controller: _descControllers[p.name],
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: context.sharedL10n.ng_board_worker_label(
                              p.name,
                              p.model ??
                                  context.sharedL10n.ng_board_default_model,
                              context.sharedL10n.ng_bots_skill_count(
                                p.skillCount,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        key: Key('kanban-worker-save-${p.name}'),
                        tooltip: context.sharedL10n.ng_board_save_description,
                        icon: const Icon(Icons.check, size: 18),
                        onPressed: () => widget.onSaveProfileDescription(
                          p.name,
                          _descControllers[p.name]!.text.trim(),
                        ),
                      ),
                      IconButton(
                        key: Key('kanban-worker-auto-${p.name}'),
                        tooltip: context.sharedL10n.ng_board_auto_describe,
                        icon: const Icon(Icons.auto_awesome, size: 18),
                        onPressed: () async {
                          final next = await widget.onAutoDescribeProfile(
                            p.name,
                          );
                          if (mounted && next.isNotEmpty) {
                            setState(
                              () => _descControllers[p.name]!.text = next,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KanbanTaskDetailSheet extends StatefulWidget {
  const _KanbanTaskDetailSheet({
    required this.taskId,
    required this.board,
    required this.allTasks,
    required this.profiles,
    required this.enableLivePolling,
    required this.boundTarget,
    required this.describeError,
    required this.onChanged,
  });

  final String taskId;
  final String? board;
  final List<KanbanTaskCard> allTasks;
  final List<KanbanProfileEntry> profiles;
  final bool enableLivePolling;
  final Future<WorkspaceTarget> Function() boundTarget;
  final String Function(Object error) describeError;
  final Future<void> Function() onChanged;

  @override
  State<_KanbanTaskDetailSheet> createState() => _KanbanTaskDetailSheetState();
}

class _KanbanTaskDetailSheetState extends State<_KanbanTaskDetailSheet> {
  KanbanTaskDetail? _detail;
  KanbanWorkerLog? _log;
  KanbanTaskEstimate? _estimate;
  bool _loading = true;
  String? _error;
  Timer? _logTimer;

  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _priorityCtrl = TextEditingController();
  final _providerCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();
  String _reasoningEffort = '';
  bool _seededEditors = false;

  /// Bumped to rebuild the assignee dropdown after a cancelled reassign.
  int _assigneeRevision = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAll());
  }

  @override
  void dispose() {
    _logTimer?.cancel();
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _priorityCtrl.dispose();
    _providerCtrl.dispose();
    _modelCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll({bool silent = false}) async {
    if (!silent && mounted) setState(() => _loading = true);
    try {
      final target = await widget.boundTarget();
      final detail = await target.kanbanTaskDetail(
        taskId: widget.taskId,
        board: widget.board,
      );
      final log = await target.kanbanTaskLog(
        taskId: widget.taskId,
        board: widget.board,
      );
      if (!mounted || !target.isCurrent) return;
      if (!_seededEditors) {
        _seededEditors = true;
        _titleCtrl.text = detail.task.title;
        _bodyCtrl.text = detail.task.body;
        _priorityCtrl.text = '${detail.task.priority}';
        _providerCtrl.text = detail.task.providerOverride ?? '';
        _modelCtrl.text = detail.task.modelOverride ?? '';
        _reasoningEffort = detail.task.reasoningEffort ?? '';
      }
      setState(() {
        _detail = detail;
        _log = log;
        _loading = false;
        _error = null;
      });
      _configureLogPolling(detail.task.status == 'running');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = widget.describeError(e);
      });
    }
  }

  void _configureLogPolling(bool isRunning) {
    _logTimer?.cancel();
    if (!widget.enableLivePolling) return;
    _logTimer = Timer.periodic(
      Duration(seconds: isRunning ? 3 : 15),
      (_) => unawaited(_refreshLogOnly()),
    );
  }

  Future<void> _refreshLogOnly() async {
    try {
      final target = await widget.boundTarget();
      final log = await target.kanbanTaskLog(
        taskId: widget.taskId,
        board: widget.board,
      );
      if (mounted && target.isCurrent) {
        setState(() => _log = log);
      }
    } catch (_) {}
  }

  void _msg(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _changeStatus(String nextStatus) async {
    final l10n = context.sharedL10n;
    final current = _detail?.task;
    if (current == null || current.status == nextStatus) return;
    try {
      final target = await widget.boundTarget();
      await target.kanbanPatchTask(
        taskId: widget.taskId,
        board: widget.board,
        status: nextStatus,
        blockReason: nextStatus == 'blocked'
            ? l10n.ng_board_manual_block
            : null,
        summary: nextStatus == 'review' ? l10n.ng_board_requested_review : null,
      );
      if (!mounted || !target.isCurrent) return;
      await widget.onChanged();
      await _loadAll(silent: true);
    } catch (e) {
      final text = widget.describeError(e);
      setState(() => _error = text);
      _msg(text);
    }
  }

  /// Stopping a worker is never silent.
  Future<bool> _confirmRequeue() => _confirmKanbanAction(
    context,
    title: context.sharedL10n.ng_board_requeue_title(widget.taskId),
    message: context.sharedL10n.ng_board_requeue_body,
    confirmLabel: context.sharedL10n.ng_board_requeue,
  );

  Future<void> _changeAssignee(String profile) async {
    final current = _detail?.task;
    if (current == null) return;
    if (current.status == 'running' && profile.isNotEmpty) {
      // Reassigning a running card reclaims it first.
      final confirmed = await _confirmKanbanAction(
        context,
        title: context.sharedL10n.ng_board_reassign_title(
          widget.taskId,
          profile,
        ),
        message: context.sharedL10n.ng_board_reassign_body,
        confirmLabel: context.sharedL10n.ng_board_reassign,
      );
      if (!mounted) return;
      if (!confirmed) {
        // Put the dropdown back on the assignee the card still has.
        setState(() => _assigneeRevision++);
        return;
      }
    }
    try {
      final target = await widget.boundTarget();
      if (current.status == 'running' && profile.isNotEmpty) {
        await target.kanbanReassignTask(
          taskId: widget.taskId,
          board: widget.board,
          profile: profile,
          reclaimFirst: true,
        );
      } else {
        await target.kanbanPatchTask(
          taskId: widget.taskId,
          board: widget.board,
          assignee: profile,
        );
      }
      if (!mounted || !target.isCurrent) return;
      await widget.onChanged();
      await _loadAll(silent: true);
    } catch (e) {
      _msg(widget.describeError(e));
    }
  }

  Future<void> _saveTaskEdits({bool clearModel = false}) async {
    try {
      final target = await widget.boundTarget();
      final model = _modelCtrl.text.trim();
      final provider = _providerCtrl.text.trim();
      await target.kanbanPatchTask(
        taskId: widget.taskId,
        board: widget.board,
        title: _titleCtrl.text.trim(),
        body: _bodyCtrl.text,
        priority: int.tryParse(_priorityCtrl.text.trim()) ?? 0,
        modelOverride: clearModel || model.isEmpty ? null : model,
        providerOverride: clearModel || provider.isEmpty ? null : provider,
        clearModelOverride: clearModel,
        reasoningEffort: _reasoningEffort.isEmpty ? null : _reasoningEffort,
        clearReasoningEffort: _reasoningEffort.isEmpty,
      );
      if (!mounted || !target.isCurrent) return;
      if (clearModel) {
        _modelCtrl.clear();
        _providerCtrl.clear();
      }
      _msg(context.sharedL10n.ng_board_saved_task(widget.taskId));
      await widget.onChanged();
      await _loadAll(silent: true);
    } catch (e) {
      _msg(widget.describeError(e));
    }
  }

  Future<void> _postComment({required bool requeueAfter}) async {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;
    if (requeueAfter && (!await _confirmRequeue() || !mounted)) return;
    try {
      final target = await widget.boundTarget();
      await target.kanbanAddComment(
        taskId: widget.taskId,
        board: widget.board,
        body: text,
      );
      if (requeueAfter) {
        await target.kanbanReclaimTask(
          taskId: widget.taskId,
          board: widget.board,
        );
      }
      if (!mounted || !target.isCurrent) return;
      _commentCtrl.clear();
      _msg(
        requeueAfter
            ? context.sharedL10n.ng_board_commented_requeued
            : context.sharedL10n.ng_board_commented,
      );
      await widget.onChanged();
      await _loadAll(silent: true);
    } catch (e) {
      _msg(widget.describeError(e));
    }
  }

  Future<void> _reclaimOnly() async {
    if (!await _confirmRequeue() || !mounted) return;
    try {
      final target = await widget.boundTarget();
      await target.kanbanReclaimTask(
        taskId: widget.taskId,
        board: widget.board,
      );
      if (!mounted || !target.isCurrent) return;
      _msg(context.sharedL10n.ng_board_requeued(widget.taskId));
      await widget.onChanged();
      await _loadAll(silent: true);
    } catch (e) {
      _msg(widget.describeError(e));
    }
  }

  Future<void> _decomposeTask() async {
    try {
      final target = await widget.boundTarget();
      final outcome = await target.kanbanDecomposeTask(
        taskId: widget.taskId,
        board: widget.board,
      );
      if (!mounted || !target.isCurrent) return;
      if (!outcome.ok) {
        // A refusal is a 200 with ok:false: show its reason, change nothing.
        final text = outcome.reason == null
            ? context.sharedL10n.ng_board_decompose_failed
            : context.sharedL10n.ng_board_decompose_failed_reason(
                outcome.reason!,
              );
        setState(() => _error = text);
        _msg(text);
        return;
      }
      final count = outcome.childIds.length;
      _msg(
        outcome.fanout && count > 0
            ? context.sharedL10n.ng_board_decomposed(count)
            : (outcome.reason == null
                  ? context.sharedL10n.ng_board_no_children
                  : context.sharedL10n.ng_board_no_children_reason(
                      outcome.reason!,
                    )),
      );
      await widget.onChanged();
      await _loadAll(silent: true);
    } catch (e) {
      _msg(widget.describeError(e));
    }
  }

  Future<void> _estimateTask() async {
    try {
      final target = await widget.boundTarget();
      final est = await target.kanbanEstimateTask(
        taskId: widget.taskId,
        board: widget.board,
      );
      if (!mounted || !target.isCurrent) return;
      setState(() => _estimate = est);
    } catch (e) {
      _msg(widget.describeError(e));
    }
  }

  Future<void> _uploadAttachment() async {
    try {
      final picked = await FilePicker.platform.pickFiles(withData: true);
      final file = picked?.files.firstOrNull;
      if (file == null || file.bytes == null || !mounted) return;
      final target = await widget.boundTarget();
      await target.kanbanUploadAttachment(
        taskId: widget.taskId,
        board: widget.board,
        filename: file.name,
        bytes: file.bytes!,
      );
      if (!mounted || !target.isCurrent) return;
      _msg(context.sharedL10n.ng_board_uploaded(file.name));
      await _loadAll(silent: true);
    } catch (e) {
      _msg(widget.describeError(e));
    }
  }

  Future<void> _addParentLink(String parentId) async {
    try {
      final target = await widget.boundTarget();
      await target.kanbanAddLink(
        board: widget.board,
        parentId: parentId,
        childId: widget.taskId,
      );
      if (!mounted || !target.isCurrent) return;
      _msg(context.sharedL10n.ng_board_linked_parent(parentId));
      await widget.onChanged();
      await _loadAll(silent: true);
    } catch (e) {
      _msg(widget.describeError(e));
    }
  }

  Future<void> _removeParentLink(String parentId) async {
    try {
      final target = await widget.boundTarget();
      await target.kanbanRemoveLink(
        board: widget.board,
        parentId: parentId,
        childId: widget.taskId,
      );
      if (!mounted || !target.isCurrent) return;
      _msg(context.sharedL10n.ng_board_unlinked_parent(parentId));
      await widget.onChanged();
      await _loadAll(silent: true);
    } catch (e) {
      _msg(widget.describeError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.88,
      child: _loading && detail == null
          ? const Center(child: CircularProgressIndicator())
          : detail == null
          ? Center(
              child: Text(
                _error ?? context.sharedL10n.ng_board_task_load_failed,
              ),
            )
          : DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${detail.task.id} · '
                            '${_columnLabel(context, detail.task.status)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          tooltip: context.sharedL10n.ng_board_refresh_task,
                          icon: const Icon(Icons.refresh),
                          onPressed: _loadAll,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Text(
                        _error!,
                        key: const Key('kanban-detail-error'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: context.sharedL10n.ng_board_tab_overview),
                      Tab(text: context.sharedL10n.ng_board_tab_comments),
                      Tab(text: context.sharedL10n.ng_board_tab_runs),
                      Tab(text: context.sharedL10n.ng_board_tab_events),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildOverviewTab(detail),
                        _buildCommentsLinksTab(detail),
                        _buildRunsLogTab(detail),
                        _buildEventsTab(detail),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewTab(KanbanTaskDetail detail) {
    final task = detail.task;
    final allowedStatuses = <String>{
      task.status,
      ...kanbanAllowedManualTargets(task.status),
    }.toList();
    final profileNames = {
      for (final p in widget.profiles) p.name,
      if (task.assignee != null) task.assignee!,
    }.toList()..sort();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final diag in detail.diagnostics)
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: ListTile(
              dense: true,
              title: Text(diag.title),
              subtitle: Text(diag.detail),
            ),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              key: const Key('kanban-detail-reclaim'),
              avatar: const Icon(Icons.replay, size: 16),
              label: Text(context.sharedL10n.ng_board_requeue),
              onPressed: _reclaimOnly,
            ),
            ActionChip(
              key: const Key('kanban-detail-decompose'),
              avatar: const Icon(Icons.account_tree_outlined, size: 16),
              label: Text(context.sharedL10n.ng_board_decompose),
              onPressed: _decomposeTask,
            ),
            ActionChip(
              key: const Key('kanban-detail-estimate'),
              avatar: const Icon(Icons.analytics_outlined, size: 16),
              label: Text(context.sharedL10n.ng_board_estimate),
              onPressed: _estimateTask,
            ),
            ActionChip(
              avatar: const Icon(Icons.attach_file, size: 16),
              label: Text(context.sharedL10n.ng_board_attach),
              onPressed: _uploadAttachment,
            ),
          ],
        ),
        if (_estimate != null) ...[
          const SizedBox(height: 8),
          Text(
            _estimate!.ok
                ? context.sharedL10n.ng_board_estimate_task(
                    _estimate!.complexity ?? '?',
                    '${_estimate!.estTokens ?? 0}',
                    _estimate!.rationale ??
                        context.sharedL10n.ng_board_no_rationale,
                  )
                : (_estimate!.reason ??
                      context.sharedL10n.ng_board_estimate_unavailable),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                key: const Key('kanban-detail-status'),
                // The sheet is also opened on phones and in the chat's
                // side pane: the chosen value must fit half its width.
                isExpanded: true,
                initialValue: task.status,
                decoration: InputDecoration(
                  labelText: context.sharedL10n.ng_board_status,
                ),
                items: [
                  for (final s in allowedStatuses)
                    DropdownMenuItem(
                      value: s,
                      child: Text(
                        _columnLabel(context, s),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) {
                  if (v != null) unawaited(_changeStatus(v));
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: KeyedSubtree(
                key: ValueKey('kanban-assignee-$_assigneeRevision'),
                child: DropdownButtonFormField<String>(
                  key: const Key('kanban-detail-assignee'),
                  isExpanded: true,
                  initialValue: task.assignee ?? '',
                  decoration: InputDecoration(
                    labelText: context.sharedL10n.ng_board_assignee,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(
                        context.sharedL10n.ng_board_unassigned,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    for (final name in profileNames)
                      DropdownMenuItem(
                        value: name,
                        child: Text('@$name', overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: (v) {
                    if (v != null) unawaited(_changeAssignee(v));
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('kanban-detail-title'),
          controller: _titleCtrl,
          decoration: InputDecoration(
            labelText: context.sharedL10n.ng_board_title_label,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('kanban-detail-body'),
          controller: _bodyCtrl,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: context.sharedL10n.ng_board_body,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _priorityCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.sharedL10n.ng_board_priority,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                key: const Key('kanban-detail-provider'),
                controller: _providerCtrl,
                decoration: InputDecoration(
                  labelText: context.sharedL10n.ng_board_provider_override,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                key: const Key('kanban-detail-model'),
                controller: _modelCtrl,
                decoration: InputDecoration(
                  labelText: context.sharedL10n.ng_board_model_override,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            FilledButton(
              key: const Key('kanban-detail-save'),
              onPressed: _saveTaskEdits,
              child: Text(context.sharedL10n.ng_board_save_changes),
            ),
            const SizedBox(width: 8),
            if (task.modelOverride != null)
              TextButton(
                onPressed: () => _saveTaskEdits(clearModel: true),
                child: Text(context.sharedL10n.ng_board_clear_model),
              ),
          ],
        ),
        if (task.blockReason != null && task.blockReason!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(context.sharedL10n.ng_board_blocked_reason(task.blockReason!)),
        ],
        if (task.result != null && task.result!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(context.sharedL10n.ng_board_result(task.result!)),
        ],
      ],
    );
  }

  Widget _buildCommentsLinksTab(KanbanTaskDetail detail) {
    final candidateParents = [
      for (final t in widget.allTasks)
        if (t.id != widget.taskId && !detail.parents.contains(t.id)) t,
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.sharedL10n.ng_board_parents('${detail.parents.length}'),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            if (candidateParents.isNotEmpty)
              PopupMenuButton<String>(
                key: const Key('kanban-add-parent-btn'),
                onSelected: _addParentLink,
                itemBuilder: (_) => [
                  for (final c in candidateParents)
                    PopupMenuItem(
                      value: c.id,
                      child: Text('${c.id}: ${c.title}'),
                    ),
                ],
                child: Chip(
                  label: Text(context.sharedL10n.ng_board_add_parent),
                ),
              ),
          ],
        ),
        for (final pid in detail.parents)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(detail.linkedTasks[pid]?.title ?? pid),
            subtitle: Text(
              '$pid · ${_linkedStatus(context, detail.linkedTasks[pid])}',
            ),
            trailing: IconButton(
              key: Key('kanban-unlink-parent-$pid'),
              icon: const Icon(Icons.link_off, size: 18),
              onPressed: () => _removeParentLink(pid),
            ),
          ),
        if (detail.children.isNotEmpty) ...[
          const Divider(),
          Text(
            context.sharedL10n.ng_board_children('${detail.children.length}'),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final cid in detail.children)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(detail.linkedTasks[cid]?.title ?? cid),
              subtitle: Text(
                '$cid · ${_linkedStatus(context, detail.linkedTasks[cid])}',
              ),
            ),
        ],
        if (detail.attachments.isNotEmpty) ...[
          const Divider(),
          Text(
            context.sharedL10n.ng_board_attachments(
              '${detail.attachments.length}',
            ),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final att in detail.attachments)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.attach_file, size: 18),
              title: Text(att.filename),
              subtitle: Text(
                '${att.size} B · ${att.uploadedBy ?? context.sharedL10n.ng_board_worker}',
              ),
            ),
        ],
        const Divider(),
        Text(
          context.sharedL10n.ng_board_comments('${detail.comments.length}'),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        for (final c in detail.comments)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              title: Text('@${c.author}'),
              subtitle: Text(c.body),
            ),
          ),
        TextField(
          key: const Key('kanban-comment-input'),
          controller: _commentCtrl,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: context.sharedL10n.ng_board_comment_hint,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilledButton(
              key: const Key('kanban-comment-submit'),
              onPressed: () => _postComment(requeueAfter: false),
              child: Text(context.sharedL10n.ng_board_post_comment),
            ),
            OutlinedButton(
              key: const Key('kanban-comment-requeue'),
              onPressed: () => _postComment(requeueAfter: true),
              child: Text(context.sharedL10n.ng_board_comment_requeue),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRunsLogTab(KanbanTaskDetail detail) {
    final log = _log;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.sharedL10n.ng_board_runs('${detail.runs.length}'),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        if (detail.runs.isEmpty)
          Text(context.sharedL10n.ng_board_no_runs)
        else
          for (final run in detail.runs)
            Card(
              margin: const EdgeInsets.only(bottom: 6),
              child: ListTile(
                dense: true,
                title: Text(
                  context.sharedL10n.ng_board_run_title(
                    '${run.id}',
                    run.profile,
                    run.outcome ?? run.status,
                  ),
                ),
                subtitle: Text(
                  [
                    if (run.summary != null && run.summary!.isNotEmpty)
                      run.summary!,
                    if (run.error != null && run.error!.isNotEmpty)
                      context.sharedL10n.ng_board_run_error(run.error!),
                  ].join('\n'),
                ),
              ),
            ),
        const Divider(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                log?.truncated == true
                    ? context.sharedL10n.ng_board_log_tail_truncated(
                        '${log?.sizeBytes ?? 0}',
                      )
                    : context.sharedL10n.ng_board_log_tail(
                        '${log?.sizeBytes ?? 0}',
                      ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            IconButton(
              key: const Key('kanban-refresh-log'),
              tooltip: context.sharedL10n.ng_board_refresh_log,
              icon: const Icon(Icons.refresh, size: 18),
              onPressed: _refreshLogOnly,
            ),
          ],
        ),
        Container(
          key: const Key('kanban-worker-log'),
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            log == null || !log.exists || log.content.isEmpty
                ? context.sharedL10n.ng_board_no_log
                : log.content,
            style: const TextStyle(fontFamily: 'GeistMono', fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsTab(KanbanTaskDetail detail) {
    if (detail.events.isEmpty) {
      return Center(child: Text(context.sharedL10n.ng_board_no_events));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: detail.events.length,
      itemBuilder: (ctx, idx) {
        final ev = detail.events[idx];
        return ListTile(
          dense: true,
          leading: const Icon(Icons.bolt_outlined, size: 18),
          title: Text(ev.kind),
          subtitle: ev.payload == null ? null : Text('${ev.payload}'),
        );
      },
    );
  }
}
