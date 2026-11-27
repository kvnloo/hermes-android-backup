import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/remote_workspace.dart';
import 'fleet_screen.dart' show fleetError;
import 'fleet_ssh_screen.dart';

/// No device SSH dependency: all operations run on the originating gateway.
class FleetManagedSshScreen extends StatefulWidget {
  const FleetManagedSshScreen({
    super.key,
    required this.owner,
    required this.label,
  });
  final RemoteWorkspaceOwner owner;
  final String label;
  @override
  State<FleetManagedSshScreen> createState() => _FleetManagedSshScreenState();
}

class _FleetManagedSshScreenState extends State<FleetManagedSshScreen> {
  late WorkspacePane pane = widget.owner.pane();
  WorkspaceTarget? target;
  List<ManagedSshHost> hosts = const [];
  final statuses = <ManagedSshHost, ManagedSshStatus?>{};
  final changed = <ManagedSshHost>{};
  Object? error;
  bool busy = false;
  final elapsed = Stopwatch();
  Timer? timer;
  Object generation = Object();

  @override
  void didUpdateWidget(FleetManagedSshScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.owner, widget.owner)) {
      pane.close();
      pane = widget.owner.pane();
      generation = Object();
      target = null;
      hosts = const [];
      statuses.clear();
      changed.clear();
      error = null;
      busy = false;
      timer?.cancel();
      elapsed.stop();
    }
  }

  @override
  void dispose() {
    generation = Object();
    pane.close();
    timer?.cancel();
    super.dispose();
  }

  Future<void> run(Future<void> Function(WorkspaceTarget) job) async {
    if (busy) return;
    final flight = generation;
    final origin = widget.owner;
    setState(() {
      busy = true;
      error = null;
    });
    elapsed
      ..reset()
      ..start();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && identical(flight, generation)) setState(() {});
    });
    try {
      final t = target ?? await pane.bind(origin.route());
      t.checkCurrent();
      if (!mounted || !identical(flight, generation)) return;
      target = t;
      await job(t);
      t.checkCurrent();
    } catch (e) {
      if (mounted &&
          identical(flight, generation) &&
          !(e is WorkspaceException && e.reason == WorkspaceFailure.stale)) {
        setState(() => error = e);
      }
    } finally {
      if (mounted && identical(flight, generation)) {
        timer?.cancel();
        elapsed.stop();
        setState(() => busy = false);
      }
    }
  }

  Future<void> operate(ManagedSshHost row, String method) async {
    final t = target;
    if (busy || t == null || !t.isCurrent) return;
    final l = context.sharedL10n;
    if (method != 'GET') {
      final yes = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          scrollable: true,
          title: Text('${row.host}:${row.port}'),
          content: Text(
            method == 'DELETE'
                ? l.fleet_managed_ssh_disconnect_warning
                : changed.contains(row)
                ? l.fleet_managed_ssh_changed
                : l.fleet_managed_ssh_trust,
          ),
          actions: [
            if (method == 'POST')
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx, false);
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const FleetSshScreen(),
                    ),
                  );
                },
                child: Text(l.fleet_managed_ssh_verify),
              ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                method == 'DELETE'
                    ? l.fleet_managed_ssh_disconnect
                    : changed.contains(row)
                    ? l.retry
                    : l.connect,
              ),
            ),
          ],
        ),
      );
      if (yes != true || !mounted || !identical(target, t) || !t.isCurrent) {
        return;
      }
    }
    await run((owner) async {
      try {
        final status = await owner.managedSsh(row, method: method);
        owner.checkCurrent();
        if (!mounted || !identical(target, owner)) return;
        statuses[row] = status;
        if (method == 'POST' && status != null) changed.remove(row);
      } on ManagedSshKeyChanged {
        owner.checkCurrent();
        if (!mounted || !identical(target, owner)) return;
        statuses.remove(row);
        changed.add(row);
        rethrow;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.fleet_managed_ssh_title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('${widget.label} · ${widget.owner.profile ?? ""}'),
              Text(l.fleet_managed_ssh_intro),
              TextButton(
                onPressed: busy
                    ? null
                    : () => run((t) async {
                        final rows = await t.managedSshHosts();
                        t.checkCurrent();
                        if (mounted && identical(target, t)) {
                          hosts = rows;
                          statuses.removeWhere((row, _) => !rows.contains(row));
                          changed.removeWhere((row) => !rows.contains(row));
                        }
                      }),
                child: Text(l.fleet_managed_ssh_read),
              ),
              if (busy) ...[
                const LinearProgressIndicator(),
                Text(l.fleet_managed_ssh_pending(elapsed.elapsed.inSeconds)),
              ],
              if (error case final e?)
                Text(
                  e is ManagedSshKeyChanged
                      ? l.fleet_managed_ssh_changed
                      : fleetError(e, l),
                ),
              for (final row in hosts)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(row.label),
                        SelectableText('${row.host}:${row.port}'),
                        if (changed.contains(row))
                          Text(l.fleet_managed_ssh_changed),
                        if (statuses.containsKey(row) && statuses[row] == null)
                          Text(l.release_core_fleet_state_idle),
                        if (statuses[row] case final s?)
                          Text(
                            l.fleet_managed_ssh_status(
                              s.host,
                              s.localPort,
                              s.remotePort,
                              s.version,
                              s.reused.toString(),
                            ),
                          ),
                        Wrap(
                          children: [
                            TextButton(
                              onPressed: busy
                                  ? null
                                  : () => operate(row, 'GET'),
                              child: Text(l.refresh),
                            ),
                            FilledButton(
                              onPressed: busy
                                  ? null
                                  : () => operate(row, 'POST'),
                              child: Text(
                                changed.contains(row) ? l.retry : l.connect,
                              ),
                            ),
                            if (statuses[row] != null)
                              TextButton(
                                onPressed: busy
                                    ? null
                                    : () => operate(row, 'DELETE'),
                                child: Text(l.fleet_managed_ssh_disconnect),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              TextButton(
                onPressed: busy
                    ? null
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const FleetSshScreen(),
                        ),
                      ),
                child: Text(l.fleet_managed_ssh_verify),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
