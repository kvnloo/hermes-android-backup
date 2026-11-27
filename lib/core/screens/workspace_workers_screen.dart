import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/remote_workspace.dart';

/// Both layouts supply the owner and route that produced the entry. The
/// roster screen never resumes a parent to acquire control of its children.
class WorkspaceWorkersScreen extends StatefulWidget {
  const WorkspaceWorkersScreen({
    super.key,
    required this.owner,
    required this.route,
    required this.label,
    this.group,
  });
  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final String label;
  final WorkspaceWorkerGroup? group;

  factory WorkspaceWorkersScreen.capture(
    RemoteWorkspaceOwner owner,
    String label, {
    String? storedSessionId,
  }) => WorkspaceWorkersScreen(
    owner: owner,
    label: label,
    route: owner.route(storedSessionId: storedSessionId),
  );

  void open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => this));

  @override
  State<WorkspaceWorkersScreen> createState() => _WorkspaceWorkersScreenState();
}

typedef _Snapshot = ({
  WorkspaceTarget target,
  List<WorkspaceWorkerGroup> groups,
  List<WorkspaceWorker> workers,
});

class _WorkspaceWorkersScreenState extends State<WorkspaceWorkersScreen> {
  late WorkspacePane _pane;
  late Future<_Snapshot> _snapshot;
  Object? _account;

  @override
  void initState() {
    super.initState();
    _bind();
    ConnectionMutationBarrier.addListener(_onAccountChange);
  }

  void _bind() {
    _pane = widget.owner.pane();
    _account = ConnectionMutationBarrier.capture(widget.route.connectionId);
    _refresh();
  }

  void _refresh() {
    _pane.invalidate();
    _snapshot = _read();
    _snapshot
        .ignore(); // FutureBuilder may not have subscribed to an immediate refusal yet.
  }

  Future<_Snapshot> _read() async {
    final target =
        await (widget.group?.bind(_pane) ?? _pane.bind(widget.route));
    final roster = target.route.storedSessionId == null;
    final groups = roster
        ? await target.workerGroups()
        : const <WorkspaceWorkerGroup>[];
    final workers = roster ? const <WorkspaceWorker>[] : await target.workers();
    target.checkCurrent();
    return (target: target, groups: groups, workers: workers);
  }

  void _onAccountChange() {
    if (!ConnectionMutationBarrier.isCurrent(
      widget.route.connectionId,
      _account,
    )) {
      setState(_refresh);
    }
  }

  @override
  void didUpdateWidget(WorkspaceWorkersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.owner != widget.owner ||
        oldWidget.route != widget.route ||
        oldWidget.group != widget.group) {
      _pane.close();
      _bind();
    }
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(_onAccountChange);
    _pane.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    return PopScope<void>(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _pane.close();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.workspace_workers),
          actions: [
            IconButton(
              tooltip: l.refresh,
              onPressed: () => setState(_refresh),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: FutureBuilder<_Snapshot>(
          future: _snapshot,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.requireData.target.isCurrent) {
              final reason = snapshot.error;
              return Center(
                child: Text(
                  _failure(
                    l,
                    reason is WorkspaceException
                        ? reason.reason
                        : WorkspaceFailure.stale,
                  ),
                ),
              );
            }
            final data = snapshot.requireData;
            final scope = [
              widget.label,
              ?data.target.effectiveProfile,
              ?data.target.route.storedSessionId,
            ].join(' · ');
            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                ListTile(title: Text(scope)),
                if (data.groups.isEmpty && data.workers.isEmpty)
                  ListTile(title: Text(l.ng_slash_command_nothing_running)),
                for (final group in data.groups)
                  ListTile(
                    title: Text(
                      l.task_stored_session(group.route.storedSessionId!),
                    ),
                    subtitle: Text(
                      [
                        l.ng_dock_subagents(group.children),
                        '${l.background_process_report}: ${group.background}',
                        if (!group.attached && group.children > 0)
                          l.workers_unattached,
                      ].join('\n'),
                    ),
                    trailing: group.attached && group.children > 0
                        ? const Icon(Icons.chevron_right)
                        : null,
                    onTap: group.attached && group.children > 0
                        ? () {
                            final page = WorkspaceWorkersScreen(
                              owner: widget.owner,
                              route: group.route,
                              group: group,
                              label: widget.label,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(builder: (_) => page),
                            );
                          }
                        : null,
                  ),
                if (data.workers.isNotEmpty)
                  _WorkerSelection(
                    key: ObjectKey(data.target),
                    target: data.target,
                    workers: data.workers,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

String _failure(AppLocalizations l, WorkspaceFailure why) => switch (why) {
  WorkspaceFailure.unsupported => l.ng_unsupported,
  WorkspaceFailure.denied => l.ng_notify_permission_denied,
  WorkspaceFailure.unbound => l.workers_unattached,
  WorkspaceFailure.stale ||
  WorkspaceFailure.mismatch => l.ng_the_gateway_connection_dropped_try_again,
  WorkspaceFailure.insecure =>
    'HTTPS · ${l.check_the_connection_and_try_again}',
  _ => l.check_the_connection_and_try_again,
};

class _WorkerSelection extends StatefulWidget {
  const _WorkerSelection({
    super.key,
    required this.target,
    required this.workers,
  });
  final WorkspaceTarget target;
  final List<WorkspaceWorker> workers;
  @override
  State<_WorkerSelection> createState() => _WorkerSelectionState();
}

class _WorkerSelectionState extends State<_WorkerSelection> {
  final _draft = TextEditingController();
  WorkspaceWorker? _selected;
  String? _notice;
  bool _sending = false;

  void _select(WorkspaceWorker row) {
    if (_sending || identical(row, _selected)) return;
    setState(() {
      _selected = row;
      _draft.clear(); // Never carry an instruction over to a different worker.
      _notice = null;
    });
  }

  Future<void> _steer(WorkspaceWorker row) async {
    if (_sending || !identical(row, _selected) || _draft.text.trim().isEmpty) {
      return;
    }
    final l = context.sharedL10n;
    setState(() {
      _sending = true;
      _notice = null;
    });
    try {
      final receipt = await row.steer(_draft.text);
      if (!mounted) return;
      widget.target.checkCurrent();
      if (receipt == WorkerSteerReceipt.queued) {
        _draft.clear();
        _notice = l.ng_subagent_queued; // Never claim delivery.
      } else {
        _notice = l.ng_steer_rejected;
      }
    } on WorkspaceException catch (e) {
      if (!mounted) return;
      _notice = switch (e.reason) {
        WorkspaceFailure.unsupported ||
        WorkspaceFailure.denied => _failure(l, e.reason),
        _ => l.running_message_delivery_unknown,
      };
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    return Column(
      children: [
        for (final w in widget.workers) ...[
          ListTile(
            title: Text(w.goal?.isNotEmpty == true ? w.goal! : l.ng_subagent),
            subtitle: Text(
              '${l.task_identity(w.id)} · ${l.task_status(_workerStatusLabel(l, w.status))}',
            ),
            selected: identical(w, _selected),
            trailing: w.canSteer ? const Icon(Icons.edit_outlined) : null,
            onTap: w.canSteer && !_sending ? () => _select(w) : null,
          ),
          if (identical(w, _selected)) ...[
            TextField(
              controller: _draft,
              readOnly: _sending,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(labelText: '${l.ng_steer} · ${w.id}'),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _draft,
              builder: (_, value, _) => FilledButton(
                onPressed: _sending || value.text.trim().isEmpty
                    ? null
                    : () => _steer(w),
                child: Text(l.ng_steer),
              ),
            ),
            if (_notice case final notice?)
              Semantics(liveRegion: true, child: Text(notice)),
          ],
        ],
      ],
    );
  }
}

String _workerStatusLabel(AppLocalizations l10n, String? status) =>
    switch (status) {
      null || '' => l10n.task_not_supplied,
      'queued' || 'requested' => l10n.ng_subagent_queued,
      'running' || 'thinking' || 'tool' => l10n.ng_subagent_running,
      'completed' || 'done' => l10n.ng_subagent_done,
      'failed' || 'error' => l10n.ng_subagent_failed,
      'interrupted' ||
      'cancelled' ||
      'canceled' ||
      'stopped' => l10n.ng_subagent_stopped,
      _ => status,
    };
