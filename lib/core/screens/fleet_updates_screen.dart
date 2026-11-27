import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../l10n/workspace_strings.dart';

import '../services/gateway_fleet.dart';

/// The check and confirmation name exact owners. No fan-out over a list that
/// is re-resolved after the dialog closes. Each target settles independently.
class FleetUpdatesScreen extends StatefulWidget {
  const FleetUpdatesScreen({super.key, required this.fleet});
  final GatewayFleet fleet;
  @override
  State<FleetUpdatesScreen> createState() => _FleetUpdatesScreenState();
}

class _FleetUpdatesScreenState extends State<FleetUpdatesScreen> {
  List<FleetUpdateRow> rows = [];
  bool busy = false;
  Future<void> check() async {
    setState(() => busy = true);
    final result = await widget.fleet.checkUpdates();
    if (mounted) {
      setState(() {
        rows = result;
        busy = false;
      });
    }
  }

  Future<void> apply() async {
    final selected = rows.where((r) => r.canStart).toList();
    if (selected.isEmpty) return;
    setState(() => busy = true);
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(
          context
              .sharedL10n
              .release_core_fleet_updates_screen_update_these_remote_gateways,
        ),
        content: SingleChildScrollView(
          child: Text(
            context.sharedL10n
                .release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
                  (selected.map((r) => r.description).join('\n')).toString(),
                ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(context.sharedL10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(
              context
                  .sharedL10n
                  .release_core_fleet_updates_screen_update_listed_gateways,
            ),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (yes == true) await Future.wait(selected.map((r) => r.start()));
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.sharedL10n.release_core_fleet_screen_fleet_updates),
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context
              .sharedL10n
              .release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries,
        ),
        TextButton(
          onPressed: busy ? null : check,
          child: Text(
            context
                .sharedL10n
                .release_core_fleet_updates_screen_check_connected_gateways,
          ),
        ),
        for (final row in rows)
          ListTile(
            title: Text(row.description),
            subtitle: Text(
              fleetUpdateStateLabel(context.sharedL10n, row.state),
            ),
            trailing: row.hasReceipt
                ? IconButton(
                    tooltip: context
                        .sharedL10n
                        .release_core_fleet_updates_screen_read_update_receipt,
                    icon: const Icon(Icons.receipt_long),
                    onPressed: busy
                        ? null
                        : () async {
                            setState(() => busy = true);
                            await row.refreshReceipt();
                            if (mounted) setState(() => busy = false);
                          },
                  )
                : null,
          ),
        if (rows.any((r) => r.canStart))
          FilledButton(
            onPressed: busy ? null : apply,
            child: Text(
              context
                  .sharedL10n
                  .release_core_fleet_updates_screen_review_eligible_updates,
            ),
          ),
        if (busy) const LinearProgressIndicator(),
      ],
    ),
  );
}
