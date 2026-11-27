part of 'remote_workspace.dart';

/// The wire's ref.profile_id is the server's opaque identity, not its profile
/// display name. The client never constructs an admission or an action target
/// from saved text, a list index, a runtime singleton, or a submission UUID.
final class QueueAdmission {
  QueueAdmission._(
    this.queue,
    this.id,
    this.inputId,
    this.sequence,
    this.state,
    this.text,
    this.generation,
    this.profileId,
    this.controls,
  );
  final GatewayQueue queue;
  final String id, inputId, state, text, profileId;
  final int sequence;
  final int? generation;
  final Set<String> controls;
  bool get unknown => state == 'unknown';
  bool get queued => state == 'queued';

  Future<void> discardUnknown() => queue._change(
    this,
    'prompt.resolve_unknown',
    {'execution_generation': generation},
  );
  Future<void> remove() => queue._change(this, 'prompt.cancel', {});
  Future<void> steer() => queue._change(this, 'prompt.steer_queued', {});
  Future<void> replace(String text, String submissionId) => queue._change(
    this,
    'prompt.replace_queued',
    {'text': text, 'submission_id': submissionId},
  );
}

final class GatewayQueue {
  GatewayQueue._(this._target, this.epoch, this.replay, this.position);
  final WorkspaceTarget _target;
  final int epoch, position;
  final String replay;
  late final String? _profileId;
  late final List<QueueAdmission> entries;
  bool get paused => entries.any((row) => row.unknown);

  Future<void> enqueue(String text, String submissionId) =>
      _target._withOwner(() async {
        if (text.trim().isEmpty || submissionId.isEmpty) {
          _fail(WorkspaceFailure.invalid);
        }
        await _write('prompt.submit', {
          'text': text,
          'queued': true,
          'submission_id': submissionId,
        });
      }, live: true);

  Future<void> _change(
    QueueAdmission row,
    String method,
    Map<String, dynamic> params,
  ) => _target._withOwner(() async {
    // An editor/confirmation can outlive the row. The host makes the final
    // atomic decision; cancel can interrupt this exact row if it just started.
    final fresh = await _target._readQueue();
    if (fresh.epoch != epoch ||
        fresh.replay != replay ||
        fresh.position < position) {
      _fail(WorkspaceFailure.stale);
    }
    final found = fresh.entries.where((r) => r.id == row.id).firstOrNull;
    if (found == null ||
        found.state != row.state ||
        found.profileId != row.profileId ||
        found.text != row.text ||
        found.inputId != row.inputId ||
        found.generation != row.generation ||
        found.sequence != row.sequence) {
      _fail(WorkspaceFailure.stale);
    }
    final allowed = switch (method) {
      'prompt.resolve_unknown' => found.unknown && found.generation != null,
      'prompt.cancel' => found.queued,
      'prompt.steer_queued' => found.queued && found.controls.contains('steer'),
      'prompt.replace_queued' =>
        found.queued &&
            found.controls.contains('replace') &&
            (params['text'] as String).trim().isNotEmpty &&
            (params['submission_id'] as String).isNotEmpty,
      _ => false,
    };
    if (!allowed) _fail(WorkspaceFailure.unsupported);
    await _write(method, {'admission_id': row.id, ...params}, row: row);
  }, live: true);

  Future<void> _write(
    String method,
    Map<String, dynamic> params, {
    QueueAdmission? row,
  }) async {
    final sid = _target.runtimeSessionId!;
    final ack = await _target._rpc(method, {'session_id': sid, ...params});
    final id = ack['admission_id'];
    final ref = ack['ref'];
    if (id is! String ||
        id.isEmpty ||
        ref is! Map ||
        ref['session_id'] != sid ||
        ref['profile_id'] is! String ||
        (ref['profile_id'] as String).isEmpty ||
        (_profileId != null && ref['profile_id'] != _profileId) ||
        ack['sequence'] is! int ||
        !const {
          'started',
          'queued',
          'unknown',
          'terminal',
        }.contains(ack['status'])) {
      _fail(WorkspaceFailure.invalid);
    }
    if (row != null &&
        (method == 'prompt.replace_queued' ? row.id == id : row.id != id)) {
      _fail(WorkspaceFailure.mismatch);
    }
    if (method == 'prompt.resolve_unknown' && ack['status'] != 'terminal') {
      _fail(WorkspaceFailure.invalid);
    }
    // An admission may start or settle before the verification. Its identity
    // and FIFO sequence do not change. Never repeat a write after a lost reply.
    final receipt = await _target._rpc('prompt.receipt', {
      'session_id': sid,
      'admission_id': id,
    });
    final verified = receipt['ref'];
    if (verified is! Map ||
        verified['profile_id'] != ref['profile_id'] ||
        verified['session_id'] != sid ||
        receipt['admission_id'] != id ||
        receipt['sequence'] != ack['sequence'] ||
        (ack['status'] == 'terminal' &&
            (receipt['status'] != 'terminal' ||
                receipt['outcome'] != ack['outcome'])) ||
        !const {
          'started',
          'queued',
          'unknown',
          'terminal',
        }.contains(receipt['status'])) {
      _fail(WorkspaceFailure.mismatch);
    }
  }
}

extension WorkspaceBusyQueue on WorkspaceTarget {
  Future<GatewayQueue> busyQueue() => _withOwner(_readQueue, live: true);

  /// The event is only a hint to read again. Never trust an unqualified event
  /// from a sibling profile as the data for this pane.
  void Function() watchQueue(void Function() changed) {
    checkCurrent();
    if (runtimeSessionId == null || !sessionAuthority) {
      _fail(WorkspaceFailure.unbound);
    }
    return _socket.observeQueueChanges(runtimeSessionId!, changed);
  }

  Future<GatewayQueue> _readQueue() async {
    if (!sessionAuthority) _fail(WorkspaceFailure.unsupported);
    final stored = route.storedSessionId!;
    final result = await _rpc('session.resume', {
      'session_id': stored,
      'omit_messages': true,
    });
    if (result['stored_session_id'] != stored ||
        result['session_id'] != runtimeSessionId) {
      _fail(WorkspaceFailure.mismatch);
    }
    final pending = result['pending'],
        epoch = result['authority_epoch'],
        replay = result['replay_epoch'],
        seq = result['last_sequence'];
    final info = result['info'];
    if (pending is! List ||
        epoch is! int ||
        replay is! String ||
        replay.isEmpty ||
        seq is! int ||
        info is! Map) {
      _fail(WorkspaceFailure.invalid);
    }
    String? profile = info['profile_id'] as String?;
    final queue = GatewayQueue._(this, epoch, replay, seq);
    final ids = <String>{}, positions = <int>{};
    final entries = <QueueAdmission>[];
    for (final r in pending) {
      if (r is! Map) _fail(WorkspaceFailure.invalid);
      final ref = r['ref'],
          id = r['admission_id'],
          input = r['input_id'],
          index = r['sequence'];
      final state = r['status'],
          text = r['text'],
          gen = r['execution_generation'],
          controls = r['controls'];
      if (ref is! Map ||
          ref['session_id'] != runtimeSessionId ||
          ref['profile_id'] is! String ||
          (ref['profile_id'] as String).isEmpty ||
          (profile != null && ref['profile_id'] != profile)) {
        _fail(WorkspaceFailure.mismatch);
      }
      profile ??= ref['profile_id'] as String;
      if (id is! String ||
          id.isEmpty ||
          !ids.add(id) ||
          input is! String ||
          input.isEmpty ||
          index is! int ||
          !positions.add(index) ||
          text is! String ||
          state is! String ||
          !const {'started', 'queued', 'unknown'}.contains(state) ||
          (gen != null && gen is! int) ||
          (state == 'unknown' && gen == null) ||
          (controls != null &&
              (controls is! List || !controls.every((c) => c is String)))) {
        _fail(WorkspaceFailure.invalid);
      }
      entries.add(
        QueueAdmission._(
          queue,
          id,
          input,
          index,
          state,
          text,
          gen as int?,
          profile,
          Set.unmodifiable((controls as List? ?? const []).cast<String>()),
        ),
      );
    }
    entries.sort((a, b) => a.sequence.compareTo(b.sequence));
    queue.entries = List.unmodifiable(entries);
    queue._profileId = profile;
    return queue;
  }
}
