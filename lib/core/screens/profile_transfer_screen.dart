import '../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/connection_manager.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/desktop_gateway_client.dart';
import '../services/remote_workspace.dart';
import 'profile_admin_panel.dart' show profileError;

class ProfileTransferScreen extends StatefulWidget {
  const ProfileTransferScreen({
    super.key,
    required this.source,
    required this.label,
  });
  final RemoteProfileAdmin source;
  final String label;
  @override
  State<ProfileTransferScreen> createState() => _ProfileTransferState();
}

class _ProfileTransferState extends State<ProfileTransferScreen> {
  CloudDirectory? directory;
  CloudAgent? agent;
  AgentTransfer? op;
  DesktopGatewayClient? dest;
  final typed = TextEditingController();
  String message = '';
  bool busy = false, revoked = false;
  Object? destEpoch;
  String? destId;
  SharedPreferences? prefs;
  Future<bool>? savingReceipt;
  bool priorReceipt = false;
  @override
  void initState() {
    super.initState();
    ConnectionMutationBarrier.addListener(_changed);
  }

  void _changed() {
    try {
      widget.source.check();
      if (destId != null &&
          !ConnectionMutationBarrier.isCurrent(destId!, destEpoch)) {
        throw StateError('changed');
      }
    } catch (_) {
      dest?.close();
      if (mounted) setState(() => revoked = true);
    }
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(_changed);
    op?.cancel();
    dest?.close();
    typed.dispose();
    super.dispose();
  }

  void redraw() {
    final current = op;
    final proof = current?.undoFingerprint;
    if (current != null &&
        proof != null &&
        prefs != null &&
        savingReceipt == null) {
      savingReceipt = prefs!.setString(current.receiptKey, proof);
      savingReceipt!.ignore();
    }
    if (mounted) setState(() {});
  }

  Future<void> run(Future<void> Function() work) async {
    final l = context.sharedL10n;
    if (busy || revoked) return;
    setState(() {
      busy = true;
      message = '';
    });
    try {
      widget.source.check();
      await work();
    } catch (e) {
      message = profileError(e, l);
    } finally {
      busy = false;
      redraw();
    }
  }

  Future<void> discover([String? org]) async {
    final l = context.sharedL10n;
    directory = await widget.source.cloudAgents(org: org);
    if (directory!.teams.isEmpty && directory!.agents.isEmpty) {
      message = l.rel_admin_no_available_cloud_agents_in_this_account;
    }
  }

  Future<void> select(CloudAgent row) async {
    final l = context.sharedL10n;
    final manager = ConnectionManager(
      prefs = await SharedPreferences.getInstance(),
    );
    if (!mounted) return;
    widget.source.check();
    Iterable<SavedConnection> matches() => manager.getConnections().where(
      (c) =>
          cloudAgentOrigin(DesktopGatewayClient.normalizedGatewayBaseUrl(c)) ==
          row.origin,
    );
    final list = matches().toList();
    if (list.length != 1) {
      message = l.rel_admin_transfer_sign_in(row.origin);
      return;
    }
    final id = list.single.id;
    final epoch = ConnectionMutationBarrier.capture(id);
    await manager.refreshConnectionCredentials(id);
    if (!mounted) return;
    widget.source.check();
    if (!ConnectionMutationBarrier.isCurrent(id, epoch)) {
      throw const WorkspaceException(WorkspaceFailure.stale);
    }
    final c = matches().single;
    if (c.id != id ||
        (!c.usesBrowserSignIn &&
            (c.dashboardPassword ?? '').isEmpty &&
            c.clientCertificate == null)) {
      throw const WorkspaceException(WorkspaceFailure.denied);
    }
    final d = DesktopGatewayClient.fromConnection(
      c.copyWith(gatewayProfile: 'default'),
    );
    dest?.close();
    dest = d;
    destId = id;
    destEpoch = epoch;
    final t = await d.workspace.pane().bind(d.workspace.route());
    final roster = await ProfileRoster.read(t);
    final target = await roster.settings(t, 'default');
    final transfer = await AgentTransfer.prepare(widget.source, target, row);
    final previous = prefs!.getString(transfer.receiptKey);
    if (!mounted) return;
    agent = row;
    op = transfer;
    priorReceipt = previous != null;
    if (previous != null) {
      try {
        await transfer.recoverUndo(previous);
      } on WorkspaceException {
        message =
            l.rel_admin_the_previous_undo_receipt_could_not_be_verified_no;
      }
    }
  }

  String _phaseLabel(AgentTransferPhase phase) => switch (phase) {
    AgentTransferPhase.prepared => context.sharedL10n.rel_admin_phase_prepared,
    AgentTransferPhase.backup => context.sharedL10n.rel_admin_phase_backup,
    AgentTransferPhase.upload => context.sharedL10n.rel_admin_phase_upload,
    AgentTransferPhase.restore => context.sharedL10n.rel_admin_phase_restore,
    AgentTransferPhase.finished => context.sharedL10n.rel_admin_phase_finished,
    AgentTransferPhase.failed => context.sharedL10n.rel_admin_phase_failed,
    AgentTransferPhase.undo => context.sharedL10n.rel_admin_phase_undo,
    AgentTransferPhase.undone => context.sharedL10n.rel_admin_phase_undone,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final current = op;
    final row = agent;
    return Scaffold(
      appBar: AppBar(title: Text(l.rel_admin_transfer_to_cloud)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.rel_admin_transfer_source(widget.label, widget.source.name)),
          if (revoked)
            Text(
              l.rel_admin_connection_changed_leave_this_page_a_restore_already_submitted,
            )
          else ...[
            if (busy)
              LinearProgressIndicator(
                value: current?.phase == AgentTransferPhase.upload
                    ? current?.fraction
                    : null,
              ),
            if (message.isNotEmpty) Text(message),
            if (current == null || row == null) ...[
              TextButton(
                onPressed: busy ? null : () => run(discover),
                child: Text(l.rel_admin_find_my_cloud_agents),
              ),
              for (final t
                  in directory?.teams.entries ?? <MapEntry<String, String>>[])
                ListTile(
                  title: Text(t.value),
                  subtitle: Text(t.key),
                  onTap: busy ? null : () => run(() => discover(t.key)),
                ),
              for (final a in directory?.agents ?? <CloudAgent>[])
                ListTile(
                  title: Text(a.name),
                  subtitle: Text('${a.origin} · ${a.id}'),
                  onTap: busy ? null : () => run(() => select(a)),
                ),
            ] else ...[
              Text(l.rel_admin_transfer_destination(row.name, row.origin)),
              Text(l.rel_admin_agent_id(row.id)),
              Text(l.rel_admin_transfer_status(_phaseLabel(current.phase))),
              if (current.phase == AgentTransferPhase.upload)
                Text(
                  l.rel_admin_copied_percent(
                    ((current.fraction ?? 0) * 100).floor().toString(),
                  ),
                ),
              if (current.phase == AgentTransferPhase.prepared ||
                  current.canUndo) ...[
                Text(
                  current.canUndo
                      ? l.rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup
                      : l.rel_admin_replace_this_cloud_agent_with_the_entire_source_home,
                ),
                TextField(
                  controller: typed,
                  enabled: !busy,
                  decoration: InputDecoration(
                    labelText: l.rel_admin_type_destination_agent_id,
                  ),
                ),
                FilledButton(
                  onPressed: busy || (priorReceipt && !current.canUndo)
                      ? null
                      : () => run(() async {
                          final value = typed.text;
                          typed.clear();
                          if (current.canUndo) {
                            await current.undo(value, redraw);
                            await savingReceipt;
                            if (!await prefs!.remove(current.receiptKey)) {
                              throw StateError('Receipt not cleared');
                            }
                          } else {
                            try {
                              await current.replace(value, redraw);
                            } finally {
                              if (await savingReceipt == false) {
                                message = l
                                    .rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open;
                              }
                            }
                          }
                        }),
                  child: Text(
                    current.canUndo
                        ? l.rel_admin_undo_transfer
                        : l.rel_admin_replace_cloud_agent,
                  ),
                ),
                if (priorReceipt)
                  TextButton(
                    onPressed: busy
                        ? null
                        : () => run(() async {
                            if (typed.text != row.id) {
                              throw const WorkspaceException(
                                WorkspaceFailure.mismatch,
                              );
                            }
                            if (!await prefs!.remove(current.receiptKey)) {
                              throw StateError('Receipt not cleared');
                            }
                            typed.clear();
                            op = null;
                            agent = null;
                            priorReceipt = false;
                            savingReceipt = null;
                            dest?.close();
                            dest = null;
                            message = l
                                .rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed;
                          }),
                    child: Text(l.rel_admin_forget_local_undo_receipt_only),
                  ),
              ],
              if (busy &&
                  {
                    AgentTransferPhase.backup,
                    AgentTransferPhase.upload,
                  }.contains(current.phase))
                TextButton(
                  onPressed: current.cancel,
                  child: Text(l.rel_admin_stop_before_restore),
                ),
              if (current.phase == AgentTransferPhase.restore ||
                  current.phase == AgentTransferPhase.undo)
                Text(l.rel_admin_do_not_close_this_page_restore_runs_on_the),
              if (current.undoArchive != null)
                SelectableText(l.rel_admin_undo_point(current.undoArchive!)),
              if (current.gatewayDown)
                Text(
                  l.rel_admin_files_restored_destination_gateway_needs_attention,
                ),
              if (current.messagingOff.isNotEmpty)
                Text(
                  l.rel_admin_messaging_disabled(
                    current.messagingOff.join(', '),
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }
}
