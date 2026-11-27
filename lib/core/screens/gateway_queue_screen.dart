import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../l10n/workspace_strings.dart';
import 'package:uuid/uuid.dart';

import '../services/connection_mutation_barrier.dart';
import '../services/remote_workspace.dart';

/// The chat that supplied the entry owns the route. Refresh/reopen reads the
/// server, never drains or replays a local copy of the server's FIFO.
class GatewayQueueScreen extends StatefulWidget {
  const GatewayQueueScreen({
    super.key,
    required this.owner,
    required this.route,
    this.draft = '',
    this.onAdmitted,
  });
  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final String draft;
  final ValueChanged<String>? onAdmitted;

  static Future<void> open(
    BuildContext context,
    RemoteWorkspaceOwner owner,
    WorkspaceRoute route, {
    String draft = '',
    ValueChanged<String>? onAdmitted,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => GatewayQueueScreen(
        owner: owner,
        route: route,
        draft: draft,
        onAdmitted: onAdmitted,
      ),
    ),
  );

  @override
  State<GatewayQueueScreen> createState() => _GatewayQueueScreenState();
}

class _GatewayQueueScreenState extends State<GatewayQueueScreen> {
  late final _pane = widget.owner.pane();
  late final _editor = TextEditingController(text: widget.draft);
  late final _account = ConnectionMutationBarrier.capture(
    widget.route.connectionId,
  );
  WorkspaceTarget? _target;
  GatewayQueue? _queue;
  QueueAdmission? _editing;
  String _previous = '', _request = const Uuid().v4();
  bool _reading = false, _writing = false, _again = false, _closed = false;
  String Function(AppLocalizations)? _message;
  void Function()? _stopWatch;
  bool get _alive => mounted && !_closed;

  @override
  void initState() {
    super.initState();
    ConnectionMutationBarrier.addListener(_accountChanged);
    unawaited(_read());
  }

  void _accountChanged() {
    if (!ConnectionMutationBarrier.isCurrent(
      widget.route.connectionId,
      _account,
    )) {
      _retire();
      if (mounted) {
        setState(() {
          _editor.clear();
          _previous = '';
          _editing = null;
          _queue = null;
          _message = (l10n) => l10n
              .release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat;
        });
      }
    }
  }

  void _retire() {
    _closed = true;
    _pane.close();
    _stopWatch?.call();
    _stopWatch = null;
  }

  @override
  void dispose() {
    _retire();
    ConnectionMutationBarrier.removeListener(_accountChanged);
    _editor.dispose();
    super.dispose();
  }

  Future<void> _read() async {
    if (!_alive) return;
    if (_reading || _writing) {
      _again = true;
      return;
    }
    setState(() => _reading = true);
    try {
      do {
        _again = false;
        var t = _target;
        if (t == null || !t.isCurrent) {
          _stopWatch?.call();
          t = _target = await _pane.bind(widget.route);
          if (!_alive) return;
          if (!t.sessionAuthority) {
            throw const WorkspaceException(WorkspaceFailure.unsupported);
          }
          _stopWatch = t.watchQueue(() {
            if (!_alive) return;
            if (!t!.isCurrent) {
              // Wait for a human refresh after socket loss, never attach in the
              // background simply because an old operation lost its response.
              setState(() {
                _queue = null;
                _message = (l10n) => l10n
                    .release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh;
              });
            } else {
              unawaited(_read());
            }
          });
        }
        final value = await t.busyQueue();
        if (!_alive) return;
        t.checkCurrent();
        // A notification received during this physical read demands a fresh
        // trailing read, not publication of the held earlier snapshot.
        if (!_again) setState(() => _queue = value);
      } while (_again && _alive);
    } on WorkspaceException catch (e) {
      if (_alive) {
        setState(() {
          _queue = null;
          _message = (l10n) =>
              l10n.release_core_gateway_queue_screen_gateway_queue_unavailable(
                workspaceFailureLabel(l10n, e.reason),
              );
        });
      }
    } finally {
      if (_alive) setState(() => _reading = false);
    }
  }

  Future<bool> _perform(
    Future<void> Function() action,
    String Function(AppLocalizations) success,
  ) async {
    if (!_alive || _writing || _reading) return false;
    setState(() => _writing = true);
    var ok = false;
    try {
      await action();
      if (!_alive) return false;
      _target!.checkCurrent();
      ok = true;
      setState(() => _message = success);
    } on WorkspaceException catch (e) {
      if (_alive) {
        setState(
          () => _message = (l10n) => l10n
              .release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
                workspaceFailureLabel(l10n, e.reason),
              ),
        );
      }
    } finally {
      if (_alive) {
        setState(() => _writing = false);
        await _read();
      }
    }
    return ok && _alive;
  }

  void _edit(QueueAdmission row) {
    setState(() {
      _previous = _editor.text;
      _editing = row;
      _editor.text = row.text;
      _request = const Uuid().v4();
    });
  }

  void _finishEdit() {
    _editor.text = _previous;
    _previous = '';
    _editing = null;
    _request = const Uuid().v4();
  }

  Future<void> _save() async {
    final q = _queue, row = _editing;
    final text = _editor.text;
    if (q == null || text.trim().isEmpty) return;
    final request = _request;
    final ok = await _perform(
      () => row == null ? q.enqueue(text, request) : row.replace(text, request),
      (l10n) => row == null
          ? l10n.release_core_gateway_queue_screen_gateway_confirmed_admission
          : l10n.release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the,
    );
    if (!ok || _request != request) return;
    if (row == null) widget.onAdmitted?.call(text);
    setState(() {
      if (row != null) {
        _finishEdit();
      } else {
        _editor.clear();
        _request = const Uuid().v4();
      }
    });
  }

  Future<void> _confirm(QueueAdmission row) async {
    final discard = row.unknown;
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          discard
              ? context
                    .sharedL10n
                    .release_core_gateway_queue_screen_discard_unknown_outcome
              : context
                    .sharedL10n
                    .release_core_gateway_queue_screen_remove_this_entry,
        ),
        content: Text(
          discard
              ? context
                    .sharedL10n
                    .release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting
              : context
                    .sharedL10n
                    .release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              context.sharedL10n.release_core_gateway_queue_screen_keep,
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              discard
                  ? context
                        .sharedL10n
                        .release_core_gateway_queue_screen_discard_and_resume
                  : context
                        .sharedL10n
                        .release_core_gateway_queue_screen_remove_entry,
            ),
          ),
        ],
      ),
    );
    if (yes == true && _alive) {
      await _perform(
        discard ? row.discardUnknown : row.remove,
        (l10n) => discard
            ? l10n.release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent
            : l10n.release_core_gateway_queue_screen_gateway_acknowledged_removal,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _queue;
    final busy = _reading || _writing || _closed;
    return PopScope<void>(
      onPopInvokedWithResult: (popped, _) {
        if (popped) _retire();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.sharedL10n.release_core_gateway_queue_screen_gateway_queue,
          ),
          actions: [
            IconButton(
              tooltip: context
                  .sharedL10n
                  .release_core_gateway_queue_screen_refresh_queue,
              onPressed: busy
                  ? null
                  : () {
                      setState(() => _message = null);
                      _read();
                    },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                [
                  widget.route.connectionId,
                  ?widget.route.profile,
                  ?widget.route.storedSessionId,
                ].join(' · '),
              ),
              if (_reading) const LinearProgressIndicator(),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(_message!(context.sharedL10n)),
                ),
              if (q != null) ...[
                if (q.paused)
                  ListTile(
                    leading: Icon(Icons.pause_circle_outline),
                    title: Text(
                      context
                          .sharedL10n
                          .release_core_gateway_queue_screen_queue_paused_unknown_outcome,
                    ),
                    subtitle: Text(
                      context
                          .sharedL10n
                          .release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is,
                    ),
                  ),
                if (q.entries.isEmpty)
                  ListTile(
                    title: Text(
                      context
                          .sharedL10n
                          .release_core_gateway_queue_screen_no_pending_admissions,
                    ),
                  ),
                for (final row in q.entries)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.text,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '#${row.sequence} · ${gatewayQueueStateLabel(context.sharedL10n, row.state)}',
                          ),
                          Wrap(
                            children: [
                              if (row.unknown)
                                TextButton(
                                  onPressed: busy ? null : () => _confirm(row),
                                  child: Text(
                                    context
                                        .sharedL10n
                                        .release_core_gateway_queue_screen_discard,
                                  ),
                                ),
                              if (row.queued) ...[
                                if (row.controls.contains('replace'))
                                  TextButton(
                                    onPressed: busy || _editing != null
                                        ? null
                                        : () => _edit(row),
                                    child: Text(context.sharedL10n.edit),
                                  ),
                                if (row.controls.contains('steer'))
                                  TextButton(
                                    onPressed: busy
                                        ? null
                                        : () => _perform(
                                            row.steer,
                                            (l10n) => l10n
                                                .release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request,
                                          ),
                                    child: Text(
                                      context
                                          .sharedL10n
                                          .release_core_gateway_queue_screen_steer_running_turn,
                                    ),
                                  ),
                                TextButton(
                                  onPressed: busy ? null : () => _confirm(row),
                                  child: Text(
                                    context
                                        .sharedL10n
                                        .release_core_gateway_queue_screen_remove,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              if (!_closed) ...[
                TextField(
                  controller: _editor,
                  minLines: 1,
                  maxLines: 5,
                  onChanged: (_) => _request = const Uuid().v4(),
                  decoration: InputDecoration(
                    labelText: _editing == null
                        ? context
                              .sharedL10n
                              .release_core_gateway_queue_screen_next_prompt
                        : context
                              .sharedL10n
                              .release_core_gateway_queue_screen_edit_queued_prompt,
                  ),
                ),
                Wrap(
                  children: [
                    FilledButton(
                      onPressed: busy || q == null ? null : _save,
                      child: Text(
                        _editing == null
                            ? context
                                  .sharedL10n
                                  .release_core_gateway_queue_screen_submit_to_gateway_queue
                            : context
                                  .sharedL10n
                                  .release_core_gateway_queue_screen_save_at_queue_end,
                      ),
                    ),
                    if (_editing != null)
                      TextButton(
                        onPressed: _writing
                            ? null
                            : () => setState(_finishEdit),
                        child: Text(
                          context
                              .sharedL10n
                              .release_core_gateway_queue_screen_cancel_edit,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
