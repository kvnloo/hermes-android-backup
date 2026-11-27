import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../l10n/workspace_strings.dart';

import '../services/connection_mutation_barrier.dart';
import '../services/gateway_fleet.dart';
import '../services/remote_workspace.dart';
import 'fleet_screen.dart' show enrollFleetAddress, fleetError;

class FleetWebappScreen extends StatefulWidget {
  const FleetWebappScreen({
    super.key,
    required this.owner,
    required this.label,
    required this.fleet,
  });
  final RemoteWorkspaceOwner owner;
  final String label;
  final GatewayFleet fleet;
  @override
  State<FleetWebappScreen> createState() => _FleetWebappScreenState();
}

class _FleetWebappScreenState extends State<FleetWebappScreen> {
  late final pane = widget.owner.pane();
  late final epoch = ConnectionMutationBarrier.capture(
    widget.owner.connectionId,
  );
  WorkspaceTarget? target;
  String Function(AppLocalizations)? message;
  CloudInventory? cloud;
  WebappRegistry? registry;
  WebappDirection? direction;
  bool busy = false;
  @override
  void initState() {
    super.initState();
    ConnectionMutationBarrier.addListener(changed);
  }

  void changed() {
    if (!ConnectionMutationBarrier.isCurrent(
      widget.owner.connectionId,
      epoch,
    )) {
      pane.invalidate();
      if (mounted) {
        setState(() {
          cloud = null;
          target = null;
          registry = null;
          direction = null;
          message = (l10n) => l10n
              .release_core_fleet_webapp_screen_account_changed_reopen_this_page;
        });
      }
    }
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(changed);
    pane.close();
    super.dispose();
  }

  Future<void> run(
    Future<void> Function(WorkspaceTarget) job, {
    bool fresh = false,
  }) async {
    if (busy) return;
    setState(() {
      busy = true;
      message = null;
      if (fresh) {
        cloud = null;
        registry = null;
        direction = null;
        target = null;
      }
    });
    try {
      final t = target ?? await pane.bind(widget.owner.route());
      t.checkCurrent();
      target = t;
      await job(t);
      t.checkCurrent();
    } catch (e) {
      if (mounted) {
        setState(() {
          message = (l10n) => fleetError(e, l10n);
          if (target?.isCurrent != true) {
            cloud = null;
            registry = null;
            direction = null;
            target = null;
          }
        });
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> confirmPrimary(WorkspaceTarget t, WebappGateway row) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          context
              .sharedL10n
              .release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway,
        ),
        content: Text(
          context.sharedL10n
              .release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
                (widget.label).toString(),
                (row.label).toString(),
                (row.id).toString(),
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.sharedL10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              context.sharedL10n.release_core_fleet_webapp_screen_set_primary,
            ),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    t.checkCurrent();
    registry = await t.setWebappPrimary(row);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        context.sharedL10n.release_core_fleet_screen_cloud_and_desktop_webapp,
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text(widget.label),
          subtitle: Text(
            widget.owner.profile ??
                context
                    .sharedL10n
                    .release_core_fleet_webapp_screen_serving_profile,
          ),
        ),
        Text(context.sharedL10n.release_core_fleet_webapp_screen_hermes_cloud),
        TextButton(
          onPressed: busy
              ? null
              : () => run((t) async {
                  cloud = await t.discoverCloud();
                }, fresh: true),
          child: Text(
            context
                .sharedL10n
                .release_core_fleet_webapp_screen_discover_signed_in_agents,
          ),
        ),
        if (cloud case final c?) ...[
          if (c.org case final org?)
            ListTile(
              title: Text(
                context.sharedL10n
                    .release_core_fleet_webapp_screen_organisation(
                      (org.name).toString(),
                    ),
              ),
            ),
          for (final o in c.choices)
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: Text(o.name),
              subtitle: Text(o.id),
              onTap: busy
                  ? null
                  : () => run((t) async {
                      cloud = null;
                      cloud = await t.discoverCloud(orgId: o.id);
                    }),
            ),
          for (final a in c.agents)
            ListTile(
              title: Text(a.name),
              subtitle: Text(
                [
                  cloudAgentStatusLabel(context.sharedL10n, a.status),
                  a.address?.toString() ??
                      context.sharedL10n.release_core_fleet_no_address,
                ].join(' · '),
              ),
              onTap: a.address == null || busy
                  ? null
                  : () => run((t) async {
                      final latest = await t.discoverCloud(orgId: c.org?.id);
                      t.checkCurrent();
                      if (latest.org?.id != c.org?.id ||
                          !latest.agents.contains(a)) {
                        throw const WorkspaceException(
                          WorkspaceFailure.mismatch,
                        );
                      }
                      if (context.mounted) {
                        await enrollFleetAddress(
                          context,
                          widget.fleet,
                          address: a.address,
                          label: a.name,
                        );
                      }
                    }),
            ),
          if (c.agents.isEmpty && c.choices.isEmpty)
            Text(
              context
                  .sharedL10n
                  .release_core_fleet_webapp_screen_no_agents_available,
            ),
        ],
        const Divider(),
        Text(
          context
              .sharedL10n
              .release_core_fleet_webapp_screen_existing_desktop_webapp,
        ),
        TextButton(
          onPressed: busy
              ? null
              : () => run((t) async {
                  final d = await t.fleetDiagnostics();
                  t.checkCurrent();
                  message = (l10n) =>
                      l10n.release_core_fleet_diagnostics(d.version, d.access);
                }, fresh: true),
          child: Text(
            context
                .sharedL10n
                .release_core_fleet_webapp_screen_check_gateway_and_web_access_status,
          ),
        ),
        Text(
          context
              .sharedL10n
              .release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this,
        ),
        TextButton(
          onPressed: busy
              ? null
              : () => run((t) async {
                  registry = await t.webappRegistry();
                }, fresh: true),
          child: Text(
            context
                .sharedL10n
                .release_core_fleet_webapp_screen_read_webapp_gateway_registry,
          ),
        ),
        if (registry case final r?)
          for (final entry in r.entries)
            ListTile(
              title: Text(entry.label),
              subtitle: Text(
                [
                  entry.kind,
                  entry.id,
                  if (r.lastUsed == entry.id)
                    context
                        .sharedL10n
                        .release_core_fleet_webapp_screen_last_used,
                  if (r.primary == entry.id)
                    context.sharedL10n.release_core_fleet_webapp_screen_primary,
                ].join(' · '),
              ),
              trailing: IconButton(
                tooltip: context.sharedL10n
                    .release_core_fleet_webapp_screen_set_primary_2(
                      (entry.label).toString(),
                    ),
                icon: Icon(
                  r.primary == entry.id ? Icons.star : Icons.star_border,
                ),
                onPressed: busy || r.primary == entry.id
                    ? null
                    : () => run((t) => confirmPrimary(t, entry)),
              ),
            ),
        TextButton(
          onPressed: busy
              ? null
              : () => run((t) async {
                  direction = await t.webappDirection();
                }, fresh: true),
          child: Text(
            context
                .sharedL10n
                .release_core_fleet_webapp_screen_read_shared_display_preferences,
          ),
        ),
        if (direction case final value?)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context
                    .sharedL10n
                    .release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop,
              ),
              Wrap(
                children: [
                  for (final d in WebappDirection.values)
                    ChoiceChip(
                      label: Text(
                        d.name == 'auto'
                            ? context.sharedL10n.appearance_automatic
                            : d.name.toUpperCase(),
                      ),
                      selected: value == d,
                      onSelected: busy || d == value
                          ? null
                          : (_) => run((t) async {
                              direction = await t.setWebappDirection(d);
                            }),
                    ),
                ],
              ),
            ],
          ),
        if (busy) const LinearProgressIndicator(),
        if (message case final msg?) Text(msg(context.sharedL10n)),
      ],
    ),
  );
}
