import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/connection_manager.dart';
import '../services/remote_workspace.dart';

/// Remote-host logs, health, maintenance, Curator and update. This is not the
/// Ares client update check and it does not operate this device.
class HostOperationsScreen extends StatefulWidget {
  const HostOperationsScreen({
    super.key,
    required this.owner,
    required this.route,
    required this.connection,
  });

  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final SavedConnection connection;

  @override
  State<HostOperationsScreen> createState() => _HostOperationsScreenState();
}

class _HostOperationsScreenState extends State<HostOperationsScreen> {
  // These are log identifiers and wire-level severity tokens, not UI labels.
  static const _files = ['agent', 'errors', 'gateway', 'desktop'];
  WorkspacePane? _pane;
  WorkspaceTarget? _target;
  var _file = 'gateway';
  String? _level;
  final _search = TextEditingController();
  var _consent = false;
  var _busy = false;
  Object? _error;
  // Resolve at render time, including when the locale changes after an action.
  // Async operations (and _open from initState) never read inherited strings.
  String Function(AppLocalizations)? _output;
  RemoteHostStatus? _status;
  RemoteHostLogs? _logs;
  HostUpdateEligibility? _eligibility;
  RemoteComputerUse? _computer;
  RemoteCuratorStatus? _curator;
  String? _launchedUpdate;

  @override
  void initState() {
    super.initState();
    _open();
  }

  @override
  void dispose() {
    _search.dispose();
    _pane?.close();
    super.dispose();
  }

  Future<WorkspaceTarget> _bound() async {
    final current = _target;
    if (current != null && current.isCurrent) return current;
    _pane?.close();
    final pane = _pane = widget.owner.pane();
    final target = await pane.bind(widget.route);
    _target = target;
    return target;
  }

  Future<void> _open() async {
    // Snapshot input before awaiting: its controller may be disposed meanwhile.
    final search = _search.text.trim();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final target = await _bound();
      final status = await target.hostStatus();
      final logs = await target.hostLogs(
        file: _file,
        level: _level,
        search: search.isEmpty ? null : search,
      );
      final eligibility = await target.updateEligibility();
      final computer = await target.computerUse();
      final curator = await target.curatorStatus();
      if (!mounted) return;
      setState(() {
        _status = status;
        _logs = logs;
        _eligibility = eligibility;
        _computer = computer;
        _curator = curator;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _errorText(AppLocalizations l, Object error) {
    // Do not surface client service exception prose or raw FormatExceptions.
    // WorkspaceException exposes the structured reason without server text.
    if (error is WorkspaceException) {
      return switch (error.reason) {
        WorkspaceFailure.stale => l.rel_ops_host_error_stale,
        WorkspaceFailure.mismatch => l.rel_ops_host_error_mismatch,
        WorkspaceFailure.unbound => l.rel_ops_host_error_unbound,
        WorkspaceFailure.unsupported => l.rel_ops_host_error_unsupported,
        WorkspaceFailure.denied => l.rel_ops_host_error_denied,
        WorkspaceFailure.ineligible => l.rel_ops_host_error_ineligible,
        WorkspaceFailure.unavailable => l.rel_ops_host_error_unavailable,
        WorkspaceFailure.invalid => l.rel_ops_host_error_invalid,
        WorkspaceFailure.insecure => l.rel_ops_host_error_insecure,
      };
    }
    return l.rel_ops_host_error_request;
  }

  String _refusalText(AppLocalizations l, String refusal) {
    // The service mixes local admission messages and server refusal text in
    // this field. Map its known local fallbacks; preserve other server prose.
    return switch (refusal) {
      'This installation is unknown, so the update was not sent' =>
        l.rel_ops_host_update_unknown_installation,
      'A chat on this installation is running' =>
        l.rel_ops_host_update_busy_installation,
      'Remote update refused' => l.rel_ops_host_update_refused,
      _ => refusal,
    };
  }

  Future<bool> _confirm(String title, String body) async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.sharedL10n.rel_ops_host_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.sharedL10n.rel_ops_host_confirm),
          ),
        ],
      ),
    );
    return answer == true && mounted;
  }

  Future<void> _update() async {
    final eligibility = _eligibility;
    if (eligibility == null || !hostUpdateMayStart(eligibility)) return;
    final l = context.sharedL10n;
    final agreed = await _confirm(
      l.rel_ops_host_update,
      l.rel_ops_host_update_confirmation('${widget.route.profile}'),
    );
    if (!agreed) return;
    await _guard(() async {
      final target = await _bound();
      final launch = await target.startHostUpdate();
      if (launch.refused != null) {
        final refusal = launch.refused!;
        _output = (l) => _refusalText(l, refusal);
        return;
      }
      await _readUpdate(target, launch.actionId!);
    });
  }

  Future<void> _recheckUpdate() async {
    final actionId = _launchedUpdate;
    if (actionId == null) return;
    await _guard(() async {
      await _readUpdate(await _bound(), actionId);
    });
  }

  /// Reads the receipt for [actionId]. Does not send another update.
  Future<void> _readUpdate(WorkspaceTarget target, String actionId) async {
    final status = await target.actionStatus('hermes-update');
    final verdict = judgeHostUpdate(
      actionId: actionId,
      running: status.running,
      receipt: status.receipt,
    );
    final unmatched =
        status.receipt == null || status.receipt!.actionId != actionId;
    _launchedUpdate = actionId;
    _output = (l) => unmatched && status.running
        ? l.rel_ops_host_update_awaiting
        : switch (verdict) {
            HostUpdateVerdict.success => l.rel_ops_host_receipt_success,
            HostUpdateVerdict.partial => l.rel_ops_host_receipt_partial,
            HostUpdateVerdict.failed => l.rel_ops_host_receipt_failed,
            HostUpdateVerdict.refused => l.rel_ops_host_receipt_refused,
            HostUpdateVerdict.pending => l.rel_ops_host_update_running,
            HostUpdateVerdict.unknown => l.rel_ops_host_update_unknown,
          };
  }

  Future<void> _restart() async {
    final shared = _status?.sharedWith ?? const <String>[];
    final l = context.sharedL10n;
    final profile = widget.route.profile ?? l.rel_ops_host_default_profile;
    final agreed = await _confirm(
      l.rel_ops_host_restart,
      shared.length > 1
          ? l.rel_ops_host_restart_shared_confirmation(shared.join(', '))
          : l.rel_ops_host_restart_confirmation(profile),
    );
    if (!agreed) return;
    await _guard(() async {
      final target = await _bound();
      await target.restartHost();
      final status = await target.actionStatus('gateway-restart');
      _output = (l) => status.running
          ? l.rel_ops_host_restart_running
          : status.exitCode == 0
          ? l.rel_ops_host_restart_finished
          : l.rel_ops_host_restart_failed;
    });
  }

  Future<void> _maintenance(String name) async {
    await _guard(() async {
      final target = await _bound();
      final status = await target.startMaintenance(name);
      _output = (l) {
        // name is the exact command identifier; diagnostics are server output.
        final head = status.running
            ? l.rel_ops_host_maintenance_running(name)
            : status.exitCode == 0
            ? l.rel_ops_host_maintenance_finished(name)
            : l.rel_ops_host_maintenance_failed(name);
        return '$head\n${status.lines.join('\n')}';
      };
    });
  }

  Future<void> _pauseCurator(bool paused) async {
    await _guard(() async {
      final target = await _bound();
      _curator = await target.setCuratorPaused(paused);
      _output = (l) => paused
          ? l.rel_ops_host_curator_paused_result
          : l.rel_ops_host_curator_resumed_result;
    });
  }

  Future<void> _reset(String targetName) async {
    final l = context.sharedL10n;
    final agreed = await _confirm(
      l.rel_ops_host_reset,
      l.rel_ops_host_reset_confirmation(targetName, '${widget.route.profile}'),
    );
    if (!agreed) return;
    await _guard(() async {
      final target = await _bound();
      final deleted = await target.resetMemoryFiles(targetName);
      _output = (l) => l.rel_ops_host_reset_result(targetName, deleted.length);
    });
  }

  Future<void> _share() async {
    if (!_consent) return;
    await _guard(() async {
      final target = await _bound();
      final share = await target.shareDiagnostics(consent: true);
      if (!share.redacted) {
        _output = (l) => l.rel_ops_host_share_not_redacted;
        return;
      }
      // Bundle identifiers and URLs come from the server and remain verbatim.
      final links = share.urls.entries
          .map((e) => '${e.key}: ${e.value}')
          .join('\n');
      _output = (_) => links;
    });
  }

  Future<void> _guard(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (error) {
      if (mounted) _error = error;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final scheme = Theme.of(context).colorScheme;
    final eligibility = _eligibility;
    final mayUpdate = eligibility != null && hostUpdateMayStart(eligibility);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.rel_ops_host_title),
        actions: [
          IconButton(
            tooltip: l.rel_ops_host_refresh,
            onPressed: _busy ? null : _open,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l.rel_ops_host_scope(
              widget.connection.label,
              widget.route.profile ?? l.rel_ops_host_default_profile,
            ),
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          if (_error != null)
            Text(_errorText(l, _error!), key: const Key('host-error')),
          if (_status != null)
            Text(
              _status!.running
                  ? l.rel_ops_host_health_running(
                      _status!.version,
                      _status!.activeSessions,
                    )
                  : l.rel_ops_host_health_stopped(
                      _status!.version,
                      _status!.activeSessions,
                    ),
              key: const Key('host-health'),
            ),
          if (_status?.heartbeatStaleSeconds != null)
            Text(
              l.rel_ops_host_heartbeat_stale(_status!.heartbeatStaleSeconds!),
            ),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                key: const Key('host-restart'),
                onPressed: _busy ? null : _restart,
                child: Text(l.rel_ops_host_restart),
              ),
              FilledButton(
                key: const Key('host-update'),
                onPressed: _busy || !mayUpdate ? null : _update,
                child: Text(l.rel_ops_host_update),
              ),
              OutlinedButton(
                onPressed: _busy ? null : () => _maintenance('doctor'),
                child: Text(l.rel_ops_host_doctor),
              ),
              OutlinedButton(
                onPressed: _busy ? null : () => _maintenance('security-audit'),
                child: Text(l.rel_ops_host_security_audit),
              ),
            ],
          ),
          // Eligibility message, logs, driver checks and last-run timestamp are
          // explicit backend diagnostics, not client-authored status labels.
          if (eligibility?.message != null)
            Text(eligibility!.message!, key: const Key('host-update-message')),
          Text(_output?.call(l) ?? '', key: const Key('host-output')),
          if (_launchedUpdate != null)
            OutlinedButton(
              key: const Key('host-update-recheck'),
              onPressed: _busy ? null : _recheckUpdate,
              child: Text(l.rel_ops_host_check_receipt),
            ),
          const SizedBox(height: 12),
          Text(l.rel_ops_host_logs),
          Wrap(
            spacing: 8,
            children: [
              for (final file in _files)
                ChoiceChip(
                  label: Text(file),
                  selected: _file == file,
                  onSelected: _busy
                      ? null
                      : (_) {
                          setState(() => _file = file);
                          _open();
                        },
                ),
              for (final level in ['INFO', 'WARNING', 'ERROR'])
                ChoiceChip(
                  label: Text(level),
                  selected: _level == level,
                  onSelected: _busy
                      ? null
                      : (selected) {
                          setState(() => _level = selected ? level : null);
                          _open();
                        },
                ),
            ],
          ),
          TextField(
            controller: _search,
            decoration: InputDecoration(labelText: l.rel_ops_host_search_logs),
            onSubmitted: (_) => _open(),
          ),
          Text(_logs?.lines.join('\n') ?? '', key: const Key('host-logs')),
          const SizedBox(height: 12),
          Text(l.rel_ops_host_driver),
          Text(l.rel_ops_host_driver_scope),
          if (_computer != null)
            Text(
              l.rel_ops_host_computer_status(
                _computer!.platform,
                _computer!.installed
                    ? l.rel_ops_host_true
                    : l.rel_ops_host_false,
                switch (_computer!.ready) {
                  true => l.rel_ops_host_true,
                  false => l.rel_ops_host_false,
                  null => l.rel_ops_host_null,
                },
              ),
              key: const Key('host-computer-use'),
            ),
          for (final check in _computer?.checks ?? const [])
            Text('${check.label}: ${check.status}. ${check.message}'),
          const SizedBox(height: 12),
          Text(l.rel_ops_host_curator),
          if (_curator != null)
            SwitchListTile(
              key: const Key('host-curator-paused'),
              title: Text(
                _curator!.paused
                    ? l.rel_ops_host_curator_paused
                    : l.rel_ops_host_curator_running,
              ),
              subtitle: Text(_curator!.lastRunAt ?? l.rel_ops_host_no_run),
              value: _curator!.paused,
              onChanged: _busy ? null : _pauseCurator,
            ),
          OutlinedButton(
            onPressed: _busy ? null : () => _maintenance('curator-run'),
            child: Text(l.rel_ops_host_run_curator),
          ),
          const SizedBox(height: 12),
          Text(l.rel_ops_host_reset),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                key: const Key('host-reset-memory'),
                onPressed: _busy ? null : () => _reset('memory'),
                child: Text(l.rel_ops_host_reset_memory),
              ),
              OutlinedButton(
                onPressed: _busy ? null : () => _reset('user'),
                child: Text(l.rel_ops_host_reset_user),
              ),
              OutlinedButton(
                onPressed: _busy ? null : () => _reset('all'),
                child: Text(l.rel_ops_host_reset_both),
              ),
            ],
          ),
          CheckboxListTile(
            key: const Key('host-consent'),
            value: _consent,
            onChanged: _busy
                ? null
                : (value) => setState(() => _consent = value ?? false),
            title: Text(l.rel_ops_host_share_consent),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          FilledButton(
            key: const Key('host-share'),
            onPressed: _busy || !_consent ? null : _share,
            child: Text(l.rel_ops_host_share),
          ),
        ],
      ),
    );
  }
}
