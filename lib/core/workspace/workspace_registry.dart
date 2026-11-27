import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../l10n/service_strings.dart';
import 'package:flutter/services.dart';

import '../models/connection.dart';
import '../models/session.dart';
import '../render/contributions_page.dart';
import '../render/render_scope.dart';
import 'terminal_chat_link.dart';
import 'terminal_page.dart';

/// Runtime-only context for trusted, compiled-in client features. Recheck
/// [current] after awaiting consent or resolving a remote capability. A page
/// must never substitute a globally selected account for [connection].
class WorkspaceTarget {
  const WorkspaceTarget(
    this.connection,
    this.session,
    this.nextGen,
    this.current, [
    this.chatLink,
  ]);
  final SavedConnection connection;
  final Session? session;
  final bool nextGen;
  final bool Function() current;
  final TerminalChatLink? chatLink;
}

typedef WorkspaceAvailability = String? Function(WorkspaceTarget);
typedef WorkspacePageBuilder = Widget Function(BuildContext, WorkspaceTarget);
typedef WorkspaceActionHandler =
    FutureOr<void> Function(BuildContext, WorkspaceTarget);

sealed class WorkspaceContribution {
  const WorkspaceContribution(
    this.id,
    this.label,
    this.icon, {
    this.requiresSession = true,
    this.unavailable,
  });
  final String id;
  final String label;
  String localizedLabel(AppLocalizations l10n) => switch (id) {
    'chat.terminals' => l10n.release_core_workspace_label_terminals,
    'chat.details' => l10n.release_core_workspace_registry_chat_details,
    'chat.copy-id' => l10n.release_core_workspace_label_copy_id,
    'extensions.contributions' =>
      l10n.release_core_workspace_label_contributions,
    _ => label,
  };
  final IconData icon;
  final bool requiresSession;
  final WorkspaceAvailability? unavailable;
  String? reason(WorkspaceTarget target, [AppLocalizations? strings]) =>
      !target.current()
      ? (strings ?? serviceStrings).release_core_workspace_owner_inactive
      : requiresSession && target.session == null
      ? (strings ?? serviceStrings).release_core_workspace_select_chat
      : unavailable?.call(target);
}

class WorkspacePage extends WorkspaceContribution {
  const WorkspacePage(
    super.id,
    super.label,
    super.icon,
    this.build, {
    super.requiresSession,
    super.unavailable,
  });
  final WorkspacePageBuilder build;
}

class WorkspaceAction extends WorkspaceContribution {
  const WorkspaceAction(
    super.id,
    super.label,
    super.icon,
    this.run, {
    super.requiresSession,
    super.unavailable,
  });
  final WorkspaceActionHandler run;
}

/// Construct once at the composition root. IDs are stable persistence keys;
/// duplicate IDs are errors in release builds too. This is not a script or
/// plugin loader, and remote strings cannot register callbacks.
class WorkspaceRegistry {
  WorkspaceRegistry(Iterable<WorkspaceContribution> entries) {
    for (final entry in entries) {
      if (!RegExp(r'^[a-z][a-z0-9.-]{0,95}$').hasMatch(entry.id) ||
          _entries.containsKey(entry.id)) {
        throw ArgumentError(
          'Invalid or duplicate workspace contribution: ${entry.id}',
        );
      }
      _entries[entry.id] = entry;
    }
  }
  final _entries = <String, WorkspaceContribution>{};
  Iterable<WorkspaceContribution> get entries => _entries.values;
  WorkspacePage? page(String id) => switch (_entries[id]) {
    final WorkspacePage p => p,
    _ => null,
  };
}

Future<void> _copySession(BuildContext context, WorkspaceTarget target) async {
  final l10n = context.sharedL10n;
  await Clipboard.setData(ClipboardData(text: target.session!.id));
  if (context.mounted && target.current()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.release_core_workspace_registry_session_id_copied),
      ),
    );
  }
}

Widget _sessionDetails(BuildContext context, WorkspaceTarget target) {
  final row = target.session!;
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text(
        context.sharedL10n.release_core_workspace_registry_chat_details,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      for (final field in [
        (context.sharedL10n.connection_section, target.connection.label),
        (
          context.sharedL10n.profile,
          target.connection.gatewayProfile ??
              context.sharedL10n.release_core_workspace_registry_server_default,
        ),
        (context.sharedL10n.release_core_workspace_registry_session_id, row.id),
        (context.sharedL10n.release_core_workspace_registry_title, row.title),
        (context.sharedL10n.model, row.model),
        (context.sharedL10n.markdown_source, row.source),
        if (row.hasKnownMessageCount)
          (context.sharedL10n.history_messages, '${row.messageCount}'),
      ])
        if (field.$2.isNotEmpty)
          ListTile(title: Text(field.$1), subtitle: SelectableText(field.$2)),
    ],
  );
}

Widget _contributionsPage(BuildContext context, WorkspaceTarget target) {
  return ContributionsPage(scope: renderConnectionKey(target.connection));
}

final aresWorkspaceRegistry = WorkspaceRegistry(const [
  WorkspacePage(
    'chat.terminals',
    'Terminals',
    Icons.terminal,
    buildTerminalPage,
  ),
  WorkspacePage(
    'chat.details',
    'Chat details',
    Icons.info_outline,
    _sessionDetails,
  ),
  WorkspaceAction('chat.copy-id', 'Copy session ID', Icons.copy, _copySession),
  WorkspacePage(
    'extensions.contributions',
    'Contributions',
    Icons.extension_outlined,
    _contributionsPage,
    requiresSession: false,
  ),
]);
