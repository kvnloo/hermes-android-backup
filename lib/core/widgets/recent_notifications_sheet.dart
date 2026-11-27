import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/notification_prefs.dart';
import '../services/turn_notification_service.dart';

/// Classic Settings' notification diagnostics: what Ares tried to post lately
/// and what came of it, including earlier runs' stored entries (kind, id,
/// outcome and error class only), so a notification that never showed or
/// never opened its chat can be explained on the device.
class RecentNotificationsSheet extends StatelessWidget {
  const RecentNotificationsSheet({super.key});

  static Future<void> show(BuildContext context) {
    unawaited(TurnNotificationService.loadRecentAttempts());
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const RecentNotificationsSheet(),
    );
  }

  static String _stamp(BuildContext context, DateTime at) {
    final local = at.toLocal();
    final strings = MaterialLocalizations.of(context);
    final time = strings.formatTimeOfDay(
      TimeOfDay.fromDateTime(local),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    return '${strings.formatShortDate(local)}, $time';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final service = TurnNotificationService.shared;
    return SafeArea(
      child: ValueListenableBuilder<List<NotificationAttempt>>(
        valueListenable: TurnNotificationService.recentAttempts,
        builder: (context, attempts, _) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.7,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Text(
                context.l10n.ng_recent_notifications,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                [
                  service.permissionGranted
                      ? context.l10n.ng_notify_permission_granted
                      : context.l10n.ng_notify_permission_denied,
                  notificationPrefs.value.enabled
                      ? context.l10n.ng_notify_master_on
                      : context.l10n.ng_notify_master_off,
                ].join(' · '),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              if (attempts.isEmpty)
                Text(
                  context.l10n.ng_recent_notifications_empty,
                  style: theme.textTheme.bodySmall,
                ),
              for (final a in attempts)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    a.succeeded
                        ? Icons.check_circle_outline
                        : switch (a.outcome) {
                            'skipped' => Icons.remove_circle_outline,
                            'unknown' => Icons.help_outline,
                            _ => Icons.error_outline,
                          },
                    color: a.succeeded
                        ? scheme.primary
                        : a.outcome == 'failed'
                        ? scheme.error
                        : scheme.onSurfaceVariant,
                  ),
                  title: Text(
                    '${_stamp(context, a.at)} · ${a.kind} · ${a.outcome}',
                  ),
                  subtitle: switch ([
                    if (a.title.isNotEmpty) a.title,
                    if (a.reference.isNotEmpty) a.reference,
                    if (a.detail != null)
                      TurnNotificationService.localizedAttemptDetail(
                        context.sharedL10n,
                        a.detail!,
                      ),
                  ]) {
                    final lines when lines.isNotEmpty => Text(
                      lines.join('\n'),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    _ => null,
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
