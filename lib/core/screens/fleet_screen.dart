import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../l10n/service_strings.dart';
import '../l10n/workspace_strings.dart';

import '../../nextgen/data/chat_controller.dart';
import '../../nextgen/ui/connect_screen.dart';
import '../services/gateway_fleet.dart';
import '../services/remote_workspace.dart';
import 'fleet_managed_ssh_screen.dart';
import 'fleet_webapp_screen.dart';
import 'fleet_ssh_screen.dart';
import 'fleet_updates_screen.dart';

/// Owned above navigation: switching visible gateways doesn't reroute or close
/// an attached conversation. Only explicit disconnect/account edits end it.
class FleetScope extends InheritedWidget {
  const FleetScope({super.key, required this.fleet, required super.child});
  final GatewayFleet fleet;
  static GatewayFleet of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FleetScope>()!.fleet;
  @override
  bool updateShouldNotify(FleetScope oldWidget) => fleet != oldWidget.fleet;
}

String fleetError(Object e, [AppLocalizations? strings]) {
  final l10n = strings ?? serviceStrings;
  return switch (e) {
    WorkspaceException(reason: WorkspaceFailure.unsupported) =>
      l10n.release_core_fleet_screen_this_gateway_does_not_offer_this_service,
    WorkspaceException(reason: WorkspaceFailure.denied) =>
      l10n.release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway,
    WorkspaceException(reason: WorkspaceFailure.insecure) =>
      l10n.release_core_fleet_screen_a_secure_gateway_address_is_required,
    WorkspaceException(
      reason: WorkspaceFailure.stale || WorkspaceFailure.mismatch,
    ) =>
      l10n.release_core_fleet_screen_the_owner_changed_refresh_before_continuing,
    _ =>
      l10n.release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway,
  };
}

void _notice(BuildContext context, Object e) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(fleetError(e, context.sharedL10n))));

Future<void> enrollFleetAddress(
  BuildContext context,
  GatewayFleet fleet, {
  Uri? address,
  String? label,
}) async {
  // A discovered URL only pre-fills the ordinary new-account flow. Never pass
  // the discovery gateway's SavedConnection, certificate or Portal session.
  await Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (ctx) => NgConnectScreen(
        connManager: fleet.manager,
        firstRun: false,
        fleetEnrollment: true,
        initialAddress: address,
        initialLabel: label,
        onCancel: () => Navigator.pop(ctx),
        onConnected: (_) => Navigator.pop(ctx),
      ),
    ),
  );
}

class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key, required this.serving, required this.label});
  final RemoteWorkspaceOwner? serving;
  final String label;
  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  @override
  Widget build(BuildContext context) {
    final fleet = FleetScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.sharedL10n.release_core_more_pane_gateway_fleet),
      ),
      body: ListenableBuilder(
        listenable: fleet,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ListTile(
              leading: const Icon(Icons.key_outlined),
              title: Text(
                context.sharedL10n.release_core_fleet_screen_verified_ssh,
              ),
              subtitle: Text(
                context
                    .sharedL10n
                    .release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const FleetSshScreen()),
              ),
            ),
            if (widget.serving case final owner?)
              ListTile(
                leading: const Icon(Icons.cloud_sync_outlined),
                title: Text(context.sharedL10n.fleet_managed_ssh_title),
                subtitle: Text(widget.label),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => FleetManagedSshScreen(
                      owner: owner,
                      label: widget.label,
                    ),
                  ),
                ),
              ),
            if (widget.serving case final owner?)
              ListTile(
                leading: const Icon(Icons.dns_outlined),
                title: Text(
                  context
                      .sharedL10n
                      .release_core_fleet_screen_cloud_and_desktop_webapp,
                ),
                subtitle: Text(widget.label),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => FleetWebappScreen(
                      owner: owner,
                      label: widget.label,
                      fleet: fleet,
                    ),
                  ),
                ),
              ),
            ListTile(
              leading: const Icon(Icons.add_link),
              title: Text(
                context
                    .sharedL10n
                    .release_core_fleet_screen_register_an_existing_gateway_or_webapp,
              ),
              subtitle: Text(
                context
                    .sharedL10n
                    .release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted,
              ),
              onTap: () async {
                await enrollFleetAddress(context, fleet);
                if (mounted) setState(() {});
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                context.sharedL10n.release_core_fleet_screen_fleet_updates,
              ),
              leading: const Icon(Icons.system_update_alt),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => FleetUpdatesScreen(fleet: fleet),
                ),
              ),
            ),
            for (final c in fleet.manager.getConnections())
              if (fleet.host(c.id) case final h?)
                _GatewayGroup(key: ObjectKey(h), host: h, fleet: fleet)
              else
                ListTile(
                  title: Text(c.label),
                  subtitle: Text(c.gatewayProfile ?? c.host),
                  trailing: TextButton(
                    onPressed: c.hasDashboardAuth
                        ? () async {
                            try {
                              await fleet.attach(c.id);
                            } catch (e) {
                              if (context.mounted) _notice(context, e);
                            }
                          }
                        : null,
                    child: Text(context.sharedL10n.connect),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _GatewayGroup extends StatelessWidget {
  const _GatewayGroup({
    super.key,
    required this.host,
    required this.fleet,
    this.childProfile = false,
  });
  final bool childProfile;
  final FleetHost host;
  final GatewayFleet fleet;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: host,
    builder: (context, _) {
      final target = host.target;
      final c = host.gateway.connection;
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(c.label),
              subtitle: Text(
                [
                  c.gatewayProfile ??
                      context
                          .sharedL10n
                          .release_core_fleet_webapp_screen_serving_profile,
                  fleetGatewayStateLabel(
                    context.sharedL10n,
                    host.gateway.state.phase.name,
                  ),
                ].join(' · '),
              ),
              trailing: Wrap(
                children: [
                  IconButton(
                    tooltip: context
                        .sharedL10n
                        .release_core_fleet_screen_refresh_roster,
                    onPressed: host.loading ? null : host.refresh,
                    icon: const Icon(Icons.refresh),
                  ),
                  if (!childProfile)
                    IconButton(
                      tooltip: context.sharedL10n
                          .release_core_fleet_screen_disconnect(
                            (c.label).toString(),
                          ),
                      onPressed: () => fleet.detach(c.id),
                      icon: const Icon(Icons.link_off),
                    ),
                ],
              ),
            ),
            if (host.loading)
              const LinearProgressIndicator()
            else if (!childProfile)
              CheckboxListTile(
                title: Text(
                  context
                      .sharedL10n
                      .release_core_fleet_screen_open_this_gateway_on_launch,
                ),
                subtitle: Text(
                  context
                      .sharedL10n
                      .release_core_fleet_screen_primary_for_ares_does_not_change_the_last,
                ),
                value: GatewayFleet.primaryId(fleet.manager, [c]) == c.id,
                onChanged: (_) async {
                  try {
                    await fleet.togglePrimary(host);
                  } catch (e) {
                    if (context.mounted) _notice(context, e);
                  }
                },
              ),
            if (!childProfile)
              SwitchListTile(
                title: Text(
                  context
                      .sharedL10n
                      .release_core_fleet_screen_reconnect_in_fleet_on_launch,
                ),
                value: fleet.remembered(c.id),
                onChanged: (v) async {
                  try {
                    await fleet.remember(host, v);
                  } catch (e) {
                    if (context.mounted) _notice(context, e);
                  }
                },
              ),
            if (host.loading)
              const SizedBox.shrink()
            else if (host.failure case final why?)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  fleetError(WorkspaceException(why), context.sharedL10n),
                ),
              )
            else if (target != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: childProfile
                    ? Text(c.gatewayProfile!)
                    : Wrap(
                        children: [
                          for (final name in host.profiles)
                            ActionChip(
                              label: Text(name),
                              onPressed: name == c.gatewayProfile
                                  ? null
                                  : () {
                                      try {
                                        host.attachProfile(name, target);
                                      } catch (e) {
                                        _notice(context, e);
                                      }
                                    },
                            ),
                        ],
                      ),
              ),
              for (final r in host.sessions)
                ListTile(
                  leading: const Icon(Icons.chat_outlined),
                  title: Text(r.title),
                  subtitle: Text(r.profile),
                  onTap: () async {
                    try {
                      // The default profile can change on the server. Attach a
                      // named owner before opening any conversation on it.
                      if (c.gatewayProfile == null) {
                        host.attachProfile(r.profile, target);
                        return;
                      }
                      final chat = await host.openSession(r, target);
                      if (context.mounted && host.current) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => _FleetChat(
                              fleet: fleet,
                              host: host,
                              row: r,
                              chat: chat,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) _notice(context, e);
                    }
                  },
                ),
              if (host.sessions.isEmpty)
                ListTile(
                  title: Text(
                    context
                        .sharedL10n
                        .release_core_fleet_screen_no_sessions_for_this_profile,
                  ),
                ),
              if (host.hasMore)
                TextButton(
                  onPressed: () => host.refresh(more: true),
                  child: Text(
                    context.sharedL10n.release_core_fleet_screen_more_sessions,
                  ),
                ),
            ],
            if (!childProfile)
              for (final p in host.attachedProfiles)
                _GatewayGroup(
                  key: ObjectKey(p),
                  host: p,
                  fleet: fleet,
                  childProfile: true,
                ),
          ],
        ),
      );
    },
  );
}

class _FleetChat extends StatefulWidget {
  const _FleetChat({
    required this.fleet,
    required this.host,
    required this.row,
    required this.chat,
  });
  final GatewayFleet fleet;
  final FleetHost host;
  final FleetSession row;
  final NgChatController chat;
  @override
  State<_FleetChat> createState() => _FleetChatState();
}

class _FleetChatState extends State<_FleetChat> {
  final input = TextEditingController();
  bool sending = false;
  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  Future<void> send(WorkspaceTarget displayed) async {
    if (sending || input.text.trim().isEmpty) return;
    setState(() => sending = true);
    final text = input.text;
    try {
      if (!await widget.host.send(widget.row, widget.chat, text, displayed)) {
        throw const WorkspaceException(WorkspaceFailure.unavailable);
      }
      if (mounted && input.text == text) input.clear();
    } catch (e) {
      if (mounted) _notice(context, e);
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        '${widget.host.gateway.connection.label} / ${widget.row.profile}',
      ),
    ),
    body: ListenableBuilder(
      listenable: widget.fleet,
      builder: (context, _) {
        if (!widget.host.current) {
          return Center(
            child: Text(
              context
                  .sharedL10n
                  .release_core_fleet_screen_this_gateway_was_disconnected,
            ),
          );
        }
        final chat = widget.chat;
        return ListenableBuilder(
          listenable: Listenable.merge([chat, widget.host]),
          builder: (context, _) => SafeArea(
            child: Column(
              children: [
                ListTile(
                  title: Text(widget.row.title),
                  subtitle: Text(widget.row.id),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final item in chat.items)
                        if (item is NgUserItem || item is NgAssistantItem)
                          ListTile(
                            title: Text(
                              item is NgUserItem
                                  ? context.sharedL10n.history_role_user
                                  : context.sharedL10n.task_role_assistant,
                            ),
                            subtitle: SelectableText(
                              item is NgUserItem
                                  ? item.text
                                  : (item as NgAssistantItem).text,
                            ),
                          ),
                      if (chat.historyError != null || chat.error != null)
                        Text(
                          context
                              .sharedL10n
                              .release_core_fleet_screen_some_conversation_data_could_not_be_loaded,
                        ),
                    ],
                  ),
                ),
                if (chat.running) const LinearProgressIndicator(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: input,
                        decoration: InputDecoration(
                          hintText: context
                              .sharedL10n
                              .release_core_fleet_screen_message_this_session,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: context
                          .sharedL10n
                          .release_core_fleet_screen_send_to_this_session,
                      onPressed: switch (widget.host.target) {
                        final target?
                            when chat.runtimeId != null &&
                                !chat.running &&
                                !sending =>
                          () => send(target),
                        _ => null,
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
