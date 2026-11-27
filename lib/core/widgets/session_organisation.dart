import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/session.dart';
import '../l10n/service_strings.dart';

enum SessionSort {
  recent,
  created,
  status,
  tokens,
  cost;

  String label(AppLocalizations l10n) => switch (this) {
    recent => l10n.release_core_session_sort_recent,
    created => l10n.release_core_session_sort_created,
    status => l10n.release_core_session_sort_status,
    tokens => l10n.release_core_session_sort_tokens,
    cost => l10n.release_core_session_sort_cost,
  };
  List<Session> apply(List<Session> rows) {
    if (this == recent) {
      return rows; // Keep the browser's native recent/rank order.
    }
    num? value(Session s) => switch (this) {
      created => s.startedAt,
      status => s.isActive ? 1 : 0,
      tokens => s.totalTokens,
      cost => s.costUsd,
      recent => s.lastActive,
    };
    return [...rows]..sort((a, b) {
      final x = value(a), y = value(b);
      final result = x == null
          ? (y == null ? 0 : 1)
          : y == null
          ? -1
          : y.compareTo(x);
      return result != 0 ? result : b.lastActive.compareTo(a.lastActive);
    });
  }
}

enum SessionGroup {
  standard,
  status,
  project;

  String label(AppLocalizations l10n) => switch (this) {
    standard => l10n.release_core_session_group_standard,
    status => l10n.release_core_session_group_status,
    project => l10n.release_core_session_group_project,
  };
}

class SessionOrganisationMenu extends StatelessWidget {
  const SessionOrganisationMenu({
    required this.sort,
    required this.group,
    required this.rows,
    required this.details,
    required this.onSort,
    required this.onGroup,
    required this.onDetails,
    this.projects = false,
    super.key,
  });
  final SessionSort sort;
  final SessionGroup group;
  final bool details, projects;
  final List<Session> rows;
  final ValueChanged<SessionSort> onSort;
  final ValueChanged<SessionGroup> onGroup;
  final VoidCallback onDetails;
  @override
  Widget build(BuildContext context) => PopupMenuButton<Object>(
    tooltip:
        context.sharedL10n.release_core_session_organisation_organise_chats,
    icon: const Icon(Icons.tune),
    onSelected: (choice) {
      switch (choice) {
        case SessionSort s:
          onSort(s);
        case SessionGroup g:
          onGroup(g);
        default:
          onDetails();
      }
    },
    itemBuilder: (context) => [
      for (final s in SessionSort.values)
        CheckedPopupMenuItem(
          value: s,
          checked: sort == s,
          enabled:
              s == sort ||
              switch (s) {
                SessionSort.tokens => rows.any((r) => r.totalTokens != null),
                SessionSort.cost => rows.any((r) => r.costUsd != null),
                _ => true,
              },
          child: Text(s.label(context.sharedL10n)),
        ),
      const PopupMenuDivider(),
      for (final g in SessionGroup.values)
        if (g != SessionGroup.project || projects)
          CheckedPopupMenuItem(
            value: g,
            checked: group == g,
            child: Text(g.label(context.sharedL10n)),
          ),
      const PopupMenuDivider(),
      CheckedPopupMenuItem(
        value: 'details',
        checked: details,
        child: Text(
          context
              .sharedL10n
              .release_core_session_organisation_show_model_and_usage,
        ),
      ),
    ],
  );
}

String sessionDetails(Session row, [AppLocalizations? strings]) => [
  if (row.model.isNotEmpty) row.model,
  if (row.totalTokens case final n?)
    (strings ?? serviceStrings).release_core_session_tokens(n),
  if (row.costUsd case final c?) '\$${c.toStringAsFixed(4)}',
].join(' · ');
Map<String, List<Session>> labelledGroups(
  Iterable<Session> rows,
  String Function(Session) label,
) {
  final groups = <String, List<Session>>{};
  for (final s in rows) {
    (groups[label(s)] ??= []).add(s);
  }
  return groups;
}
