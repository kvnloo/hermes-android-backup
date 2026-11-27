part of 'remote_workspace.dart';

/// Profile-wide discovery names *stored* conversations, including ones this
/// socket has never attached. Counts are not authority to control anything.
final class WorkspaceWorkerGroup {
  WorkspaceWorkerGroup._(
    this._source,
    this.route,
    this.children,
    this.background,
  ) : _binding = _source._socket.workspaceBinding(route.storedSessionId!);

  final WorkspaceTarget _source;
  final WorkspaceRoute route;
  final int children;
  final int background;
  final WorkspaceRuntime? _binding;
  bool get attached => _binding != null;

  Future<WorkspaceTarget> bind(WorkspacePane pane) async {
    void check() {
      _source.checkCurrent();
      if (!attached) _fail(WorkspaceFailure.unbound);
      if (!identical(
        _source._socket.workspaceBinding(route.storedSessionId!),
        _binding,
      )) {
        _fail(WorkspaceFailure.stale);
      }
    }

    check();
    final target = await pane.bind(route);
    check();
    if (!identical(target._socket, _source._socket) ||
        !identical(target._binding, _binding)) {
      _fail(WorkspaceFailure.stale);
    }
    return target;
  }
}

enum WorkerSteerReceipt { queued, rejected }

/// Issued only by subagent.list on an attached parent. No API accepts a child
/// locator from a widget, transcript, delegation, or a different target.
final class WorkspaceWorker {
  WorkspaceWorker._(this._parent, this.id, Map row)
    : goal = row['goal'] as String?,
      status = row['status'] as String?,
      _accepting = row['accepting_steer'] as bool?,
      _startedAt = row['started_at'] as num?,
      _delegation = row['delegation_id'] as String?;

  final WorkspaceTarget _parent;
  final String id;
  final String? goal, status, _delegation;
  final bool? _accepting;
  final num? _startedAt;
  bool get canSteer =>
      _accepting == true && (status == 'running' || status == 'queued');

  Future<WorkerSteerReceipt> steer(
    String instruction,
  ) => _parent._withOwner(() async {
    final text = instruction.trim();
    if (text.isEmpty) _fail(WorkspaceFailure.invalid);
    if (!canSteer) _fail(WorkspaceFailure.unbound);
    // A dialog may have remained open across a child exit or ID reuse. Read
    // the exact parent's list again. The host still makes the atomic decision:
    // visibility (including via durable lineage) doesn't prove ownership.
    final current = await _parent._readWorkers();
    if (!current.any(
      (w) =>
          w.id == id &&
          w.canSteer &&
          w._startedAt == _startedAt &&
          w._delegation == _delegation,
    )) {
      _fail(WorkspaceFailure.stale);
    }
    await _parent.verifySession();
    final result = await _parent._rpc('subagent.steer', {
      'session_id': _parent.runtimeSessionId!,
      'subagent_id': id,
      'text': text,
    });
    if (result['subagent_id'] != id || result['text'] != text) {
      _fail(WorkspaceFailure.invalid);
    }
    return switch (result['status']) {
      'queued' => WorkerSteerReceipt.queued,
      'rejected' => WorkerSteerReceipt.rejected,
      _ => _fail(WorkspaceFailure.invalid),
    };
  }, live: true);
}

extension WorkspaceWorkers on WorkspaceTarget {
  Future<List<WorkspaceWorkerGroup>> workerGroups() => _withOwner(() async {
    if (route.storedSessionId != null) _fail(WorkspaceFailure.mismatch);
    final result = await _rpc('subagent.roster', {});
    final rows = result['sessions'];
    if (rows is! List) _fail(WorkspaceFailure.invalid);
    final ids = <String>{};
    return List.unmodifiable(
      rows.map((row) {
        if (row is! Map) _fail(WorkspaceFailure.invalid);
        final id = _workerId(row['session_id'], ids);
        final children = row['subagents'], background = row['background'];
        if (children is! int ||
            children < 0 ||
            background is! int ||
            background < 0) {
          _fail(WorkspaceFailure.invalid);
        }
        return WorkspaceWorkerGroup._(
          this,
          _owner.route(storedSessionId: id),
          children,
          background,
        );
      }),
    );
  });

  Future<List<WorkspaceWorker>> workers() =>
      _withOwner(_readWorkers, live: true);

  Future<List<WorkspaceWorker>> _readWorkers() async {
    final result = await _rpc('subagent.list', {
      'session_id': runtimeSessionId!,
    });
    final rows = result['subagents'];
    if (rows is! List) _fail(WorkspaceFailure.invalid);
    final ids = <String>{};
    return List.unmodifiable(
      rows.map((row) {
        if (row is! Map) _fail(WorkspaceFailure.invalid);
        return WorkspaceWorker._(this, _workerId(row['subagent_id'], ids), row);
      }),
    );
  }
}

String _workerId(Object? value, Set<String> seen) {
  if (value is! String ||
      value.isEmpty ||
      value.trim() != value ||
      RegExp(r'[\x00-\x1f\x7f]').hasMatch(value) ||
      !seen.add(value)) {
    _fail(WorkspaceFailure.invalid);
  }
  return value;
}
