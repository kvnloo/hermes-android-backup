/// The More destination pane.
///
/// The fifth top-level destination (Chats / Crons / Projects / Activity / More).
/// Groups Workspace, Agent and System capabilities, with a Dashboard fallback
/// for functionality that does not yet have a native screen. Roadmap-only
/// organisation placeholders are omitted from the menu.
///
/// Two rules drive this file:
///
/// 1. **Keep supported capabilities discoverable.** A surface the current
///    connection cannot serve stays disabled *with a precise reason*.
///    Capabilities exposed in other destinations need not be duplicated here.
/// 2. **Explain, do not crash.** Availability is data, so tests can assert it
///    without pumping a widget, and the pane simply renders it.
library;

import 'package:flutter/material.dart';

import '../theme/hermes_theme.dart';
import '../screens/parallel_workspace_entry.dart';
import 'hermes_components.dart';

import 'package:hermes_android/core/l10n/l10n.dart';

const providerTitles = <String, String>{
  'openrouter': 'OpenRouter',
  'openai': 'OpenAI',
  'anthropic': 'Claude (Anthropic)',
  'deepseek': 'DeepSeek',
};

/// Whether a More entry can be opened right now, and why not when it cannot.
enum MoreEntryAvailability {
  /// Usable now.
  available,

  /// Native surface not implemented yet; listed so it stays discoverable.
  comingSoon,

  /// The connected Hermes instance cannot serve it (for example: no
  /// reachable dashboard). Disabled with an explanation, never hidden.
  unavailable,
}

/// One row of the More pane.
@immutable
class MoreEntry {
  /// Stable identifier used for routing and tests. Never localized.
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final MoreEntryAvailability availability;

  /// Why the entry is disabled. Required for [MoreEntryAvailability.unavailable]
  /// so the UI can always tell the user what to fix.
  final String? unavailableReason;

  const MoreEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.availability = MoreEntryAvailability.available,
    this.unavailableReason,
  }) : assert(
         availability != MoreEntryAvailability.unavailable ||
             unavailableReason != null,
         'A disabled entry must explain itself',
       );

  bool get isSelectable => availability == MoreEntryAvailability.available;
}

/// A titled group of [MoreEntry] rows.
@immutable
class MoreSection {
  final String title;
  final List<MoreEntry> entries;

  const MoreSection({required this.title, required this.entries});
}

/// Builds the More menu for the current connection.
///
/// [dashboardReachable] gates the surfaces served by the Hermes Dashboard.
/// Local device settings stay reachable regardless, so the user can always
/// repair a broken connection from inside the app.
///
/// [providerIds] is a model-catalog hint, not an account-capability inventory.
/// Usage stays discoverable regardless of empty, partial or alias-only catalogs.
List<MoreSection> buildMoreSections({
  required bool dashboardReachable,
  bool workspaceAvailable = false,
  required AppLocalizations l10n,
  bool profileScopedHistory = true,
  Set<String> providerIds = const {},
}) {
  MoreEntryAvailability dashboardBacked() => dashboardReachable
      ? MoreEntryAvailability.available
      : MoreEntryAvailability.unavailable;
  String? dashboardReason() => dashboardReachable
      ? null
      : l10n.needs_a_reachable_hermes_dashboard_check_the_host_port_and;

  return [
    MoreSection(
      title: l10n.workspace,
      entries: [
        MoreEntry(
          id: 'gateway-fleet',
          title: l10n.release_core_more_pane_gateway_fleet,
          subtitle: l10n
              .release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp,
          icon: Icons.hub_outlined,
        ),
        MoreEntry(
          id: 'unassigned',
          title: l10n.unassigned_chats,
          subtitle: l10n.chats_that_are_not_assigned_to_a_project,
          icon: Icons.inbox_outlined,
        ),
        MoreEntry(
          id: 'files',
          title: l10n.files,
          subtitle: l10n.browse_the_miniserver_folders_behind_your_projects,
          icon: Icons.folder_open_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'projects-root',
          title: l10n.projects_root_title,
          subtitle: l10n.projects_root_more_subtitle,
          icon: Icons.folder_special_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'assets',
          title: l10n.assets,
          subtitle: l10n.assets_recent_subtitle,
          icon: Icons.image_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'parallel-workspace',
          title: parallelWorkspaceEntryTitle,
          subtitle: parallelWorkspaceEntrySubtitle,
          icon: Icons.view_week_outlined,
          availability: profileScopedHistory
              ? MoreEntryAvailability.available
              : MoreEntryAvailability.unavailable,
          unavailableReason: profileScopedHistory
              ? null
              : l10n.release_core_more_pane_use_dashboard_sign_in_for_a_named_profile,
        ),
      ],
    ),
    MoreSection(
      title: l10n.agent,
      entries: [
        MoreEntry(
          id: 'workspace-profiles',
          title: l10n.ng_profiles,
          subtitle: l10n.ng_agent_gateway,
          icon: Icons.people_outline,
          availability: workspaceAvailable
              ? MoreEntryAvailability.available
              : MoreEntryAvailability.unavailable,
          unavailableReason: workspaceAvailable
              ? null
              : l10n.desktop_gateway_is_not_configured_for_this_connection,
        ),
        MoreEntry(
          id: 'workspace-workers',
          title: l10n.workspace_workers,
          subtitle: l10n.ng_show_subagents,
          icon: Icons.account_tree_outlined,
          availability: workspaceAvailable
              ? MoreEntryAvailability.available
              : MoreEntryAvailability.unavailable,
          unavailableReason: workspaceAvailable
              ? null
              : l10n.desktop_gateway_is_not_configured_for_this_connection,
        ),
        MoreEntry(
          id: 'kanban',
          title: l10n.ng_more_kanban,
          subtitle: l10n.ng_more_kanban_subtitle,
          icon: Icons.view_kanban_outlined,
          availability: workspaceAvailable
              ? MoreEntryAvailability.available
              : MoreEntryAvailability.unavailable,
          unavailableReason: workspaceAvailable
              ? null
              : l10n.desktop_gateway_is_not_configured_for_this_connection,
        ),
        MoreEntry(
          id: 'bots',
          title: l10n.ng_more_bots,
          subtitle: l10n.ng_more_bots_subtitle,
          icon: Icons.pets_outlined,
          availability: workspaceAvailable
              ? MoreEntryAvailability.available
              : MoreEntryAvailability.unavailable,
          unavailableReason: workspaceAvailable
              ? null
              : l10n.desktop_gateway_is_not_configured_for_this_connection,
        ),
        MoreEntry(
          id: 'model',
          title: l10n.model,
          subtitle: l10n.model_management_subtitle,
          icon: Icons.smart_toy_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'cron',
          title: l10n.cron,
          subtitle: l10n.scheduled_jobs_and_their_last_runs,
          icon: Icons.schedule_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'skills',
          title: l10n.skills_and_tools,
          subtitle: l10n.what_hermes_knows_how_to_do,
          icon: Icons.auto_awesome_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'capability-admin',
          title: l10n.release_core_more_pane_capabilities,
          subtitle: l10n
              .release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool,
          icon: Icons.extension_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'browser-vault',
          title: l10n.release_core_more_pane_browser_vault,
          subtitle: l10n
              .release_core_more_pane_site_logins_addresses_cards_and_credential_sources,
          icon: Icons.vpn_key_outlined,
          availability: workspaceAvailable
              ? MoreEntryAvailability.available
              : MoreEntryAvailability.unavailable,
          unavailableReason: workspaceAvailable
              ? null
              : l10n.desktop_gateway_is_not_configured_for_this_connection,
        ),
        MoreEntry(
          id: 'agent-policy',
          title: l10n.release_core_more_pane_agent_policy,
          subtitle: l10n
              .release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics,
          icon: Icons.admin_panel_settings_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'memory',
          title: l10n.memory,
          subtitle: l10n.durable_facts_hermes_keeps_about_you,
          icon: Icons.psychology_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'host-operations',
          title: l10n.host,
          subtitle: l10n
              .release_core_more_pane_remote_logs_health_maintenance_and_update,
          icon: Icons.monitor_heart_outlined,
          availability: workspaceAvailable
              ? MoreEntryAvailability.available
              : MoreEntryAvailability.unavailable,
          unavailableReason: workspaceAvailable
              ? null
              : l10n.desktop_gateway_is_not_configured_for_this_connection,
        ),
        MoreEntry(
          id: 'schedule-desk',
          title: l10n.release_core_more_pane_schedules,
          subtitle: l10n
              .release_core_more_pane_all_profiles_blueprints_catch_up_and_stop,
          icon: Icons.event_note_outlined,
          availability: workspaceAvailable
              ? MoreEntryAvailability.available
              : MoreEntryAvailability.unavailable,
          unavailableReason: workspaceAvailable
              ? null
              : l10n.desktop_gateway_is_not_configured_for_this_connection,
        ),
        MoreEntry(
          id: 'memory-graph',
          title: l10n.release_core_more_pane_memory_graph,
          subtitle:
              l10n.release_core_more_pane_timeline_edits_and_memory_providers,
          icon: Icons.hub_outlined,
          availability: workspaceAvailable
              ? MoreEntryAvailability.available
              : MoreEntryAvailability.unavailable,
          unavailableReason: workspaceAvailable
              ? null
              : l10n.desktop_gateway_is_not_configured_for_this_connection,
        ),
      ],
    ),
    MoreSection(
      title: l10n.usage,
      entries: [
        MoreEntry(
          id: 'provider-sign-in',
          title: l10n.provider_oauth_title,
          subtitle: l10n.provider_oauth_more_subtitle,
          icon: Icons.login,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'nous-portal',
          title: l10n.nous_portal,
          subtitle: l10n.portal_menu_subtitle,
          icon: Icons.public,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'provider-admin',
          title: l10n.release_core_more_pane_providers_and_routes,
          subtitle: l10n
              .release_core_more_pane_keys_endpoints_delegation_and_mixtures,
          icon: Icons.key_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        MoreEntry(
          id: 'nous-billing',
          title: l10n.release_core_more_pane_credits_and_plans,
          subtitle: l10n
              .release_core_more_pane_consented_nous_billing_when_the_account_allows_it,
          icon: Icons.account_balance_wallet_outlined,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
        // Account usage capability is independent of the current model catalog.
        // Keep a stable list even when discovery fails or only returns aliases
        // such as openai-codex; route OpenAI through the canonical openai ID.
        for (final provider in providerTitles.entries)
          MoreEntry(
            id: provider.key,
            title: provider.value,
            subtitle: l10n.provider_usage,
            icon: Icons.public,
            availability: dashboardBacked(),
            unavailableReason: dashboardReason(),
          ),
      ],
    ),
    MoreSection(
      title: l10n.system,
      entries: [
        MoreEntry(
          id: 'settings',
          title: l10n.settings,
          subtitle: l10n.connection_appearance_and_device_preferences,
          icon: Icons.settings_outlined,
        ),
        MoreEntry(
          id: 'dashboard',
          title: l10n.open_the_hermes_dashboard,
          subtitle:
              l10n.everything_not_yet_native_in_the_authenticated_web_dashboard,
          icon: Icons.open_in_new,
          availability: dashboardBacked(),
          unavailableReason: dashboardReason(),
        ),
      ],
    ),
  ];
}

/// Renders the More menu.
class MorePane extends StatelessWidget {
  final List<MoreSection> sections;
  final ValueChanged<MoreEntry> onSelect;

  const MorePane({required this.sections, required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: HermesSpacing.xl),
      children: [
        for (final section in sections) ...[
          SectionHeader(title: section.title),
          for (final entry in section.entries)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                HermesSpacing.lg,
                0,
                HermesSpacing.lg,
                HermesSpacing.md,
              ),
              child: _MoreEntryCard(entry: entry, onSelect: onSelect),
            ),
        ],
      ],
    );
  }
}

class _MoreEntryCard extends StatelessWidget {
  final MoreEntry entry;
  final ValueChanged<MoreEntry> onSelect;

  const _MoreEntryCard({required this.entry, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final tokens = HermesTokens.of(context);
    final dimmed = !entry.isSelectable;
    final titleColor = dimmed ? tokens.muted : tokens.onSurface;

    return Semantics(
      button: entry.isSelectable,
      enabled: entry.isSelectable,
      label: entry.title,
      child: HermesCard(
        onTap: entry.isSelectable ? () => onSelect(entry) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: dimmed ? tokens.raised : tokens.accentContainer,
                borderRadius: BorderRadius.circular(HermesRadius.sm),
              ),
              child: Icon(
                entry.icon,
                size: 20,
                color: dimmed ? tokens.muted : tokens.onAccentContainer,
              ),
            ),
            const SizedBox(width: HermesSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A Wrap rather than a Row: at a large text scale the badge
                  // moves to its own line instead of overflowing the card.
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: HermesSpacing.sm,
                    runSpacing: HermesSpacing.xs,
                    children: [
                      Text(
                        entry.title,
                        style: tokens.typography.section.copyWith(
                          color: titleColor,
                        ),
                      ),
                      if (entry.availability ==
                          MoreEntryAvailability.comingSoon)
                        StatusChip(
                          status: HermesStatus.idle,
                          label: context.l10n.coming_next,
                        ),
                    ],
                  ),
                  const SizedBox(height: HermesSpacing.xs),
                  Text(
                    entry.subtitle,
                    style: tokens.typography.body.copyWith(color: tokens.muted),
                  ),
                  if (entry.availability ==
                      MoreEntryAvailability.unavailable) ...[
                    const SizedBox(height: HermesSpacing.xs),
                    Text(
                      entry.unavailableReason!,
                      style: tokens.typography.label.copyWith(
                        color: tokens.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
