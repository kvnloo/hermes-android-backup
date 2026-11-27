import 'package:flutter/material.dart';

import '../models/gateway_approval.dart';

import 'package:hermes_android/core/l10n/l10n.dart';

typedef ApprovalResponder = Future<void> Function(GatewayApprovalChoice choice);

class GatewayApprovalDialog extends StatefulWidget {
  final GatewayApprovalRequest request;
  final ApprovalResponder onRespond;

  const GatewayApprovalDialog({
    required this.request,
    required this.onRespond,
    super.key,
  });

  @override
  State<GatewayApprovalDialog> createState() => _GatewayApprovalDialogState();
}

class _GatewayApprovalDialogState extends State<GatewayApprovalDialog> {
  GatewayApprovalChoice? _submitting;
  bool _confirmAlways = false;
  String? _error;

  Future<void> _respond(GatewayApprovalChoice choice) async {
    if (_submitting != null) return;
    if (choice == GatewayApprovalChoice.always && !_confirmAlways) {
      setState(() {
        _confirmAlways = true;
        _error = null;
      });
      return;
    }

    final route = ModalRoute.of(context);
    setState(() {
      _submitting = choice;
      _error = null;
    });
    try {
      await widget.onRespond(choice);
      // Normal-owner cleanup may already have removed this dialog's route.
      if (!mounted || route?.isActive != true) return;
      final navigator = route!.navigator;
      if (route.isCurrent) {
        navigator?.pop(true);
      } else {
        // A newer prompt may be above this one; close only our own route.
        navigator?.removeRoute(route, true);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = null;
        _error = context.sharedL10n.could_not_send_the_approval(error);
      });
    }
  }

  String _labelFor(GatewayApprovalChoice choice) {
    return switch (choice) {
      GatewayApprovalChoice.once => context.sharedL10n.allow_once,
      GatewayApprovalChoice.session =>
        context.sharedL10n.allow_for_this_session,
      GatewayApprovalChoice.always =>
        _confirmAlways
            ? context.sharedL10n.confirm_always_allow
            : context.sharedL10n.always_allow,
      GatewayApprovalChoice.deny => context.sharedL10n.deny,
    };
  }

  String _scopeFor(GatewayApprovalChoice choice) {
    final request = widget.request;
    final l = context.sharedL10n;
    if (request.kind == GatewayApprovalKind.access) {
      return switch (choice) {
        GatewayApprovalChoice.once => l.allow_folder_until_sandbox_off,
        GatewayApprovalChoice.session => l.rel_svc_misc_allow_folder_session,
        GatewayApprovalChoice.always => l.rel_svc_misc_save_folder_grant,
        GatewayApprovalChoice.deny => l.rel_svc_misc_deny_folder_grant,
      };
    }
    if (request.kind == GatewayApprovalKind.network) {
      return switch (choice) {
        GatewayApprovalChoice.once => l.allow_website_until_sandbox_off,
        GatewayApprovalChoice.session => l.rel_svc_misc_allow_website_session,
        GatewayApprovalChoice.always => l.rel_svc_misc_save_website_grant,
        GatewayApprovalChoice.deny => l.rel_svc_misc_deny_website_grant,
      };
    }
    return switch (choice) {
      GatewayApprovalChoice.once => l.run_only_this_command,
      GatewayApprovalChoice.session =>
        l.allow_matching_commands_until_this_hermes_session_ends,
      GatewayApprovalChoice.always =>
        l.save_a_permanent_rule_in_the_hermes_configuration,
      GatewayApprovalChoice.deny => l.do_not_run_this_command,
    };
  }

  IconData _iconFor(GatewayApprovalChoice choice) {
    return switch (choice) {
      GatewayApprovalChoice.once => Icons.play_arrow_rounded,
      GatewayApprovalChoice.session => Icons.timer_outlined,
      GatewayApprovalChoice.always => Icons.verified_user_outlined,
      GatewayApprovalChoice.deny => Icons.block_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.sharedL10n;
    final request = widget.request;
    final busy = _submitting != null;

    final title = switch (request.kind) {
      GatewayApprovalKind.access => l.ng_folder_access,
      GatewayApprovalKind.network => l.ng_website_access,
      GatewayApprovalKind.command => l.approval_needed,
    };
    final accessLabel = switch (request.folderAccess) {
      'read' => l.ng_folder_read_only,
      'read_write' => l.ng_folder_read_write,
      _ => l.ng_folder_access_unspecified,
    };

    // Back is a denial only before submission. Once a response is in flight,
    // dismissing would race that response against the route owner's denial.
    return PopScope(
      canPop: !busy,
      child: AlertDialog(
        icon: Icon(
          request.kind == GatewayApprovalKind.command
              ? Icons.gpp_maybe_outlined
              : Icons.folder_shared_outlined,
        ),
        title: Text(title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(request.description),
                if (request.kind == GatewayApprovalKind.access) ...[
                  const SizedBox(height: 16),
                  Text(
                    l.release_core_project_settings_view_folder,
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    request.folderPath?.isNotEmpty == true
                        ? request.folderPath!
                        : l.rel_svc_misc_gateway_folder_unnamed,
                  ),
                  const SizedBox(height: 8),
                  Text(accessLabel, key: const Key('approval-access')),
                ],
                if (request.kind == GatewayApprovalKind.network) ...[
                  const SizedBox(height: 16),
                  Text(
                    l.rel_svc_misc_website,
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    request.host?.isNotEmpty == true
                        ? request.host!
                        : l.rel_svc_misc_gateway_website_unnamed,
                    key: const Key('approval-host'),
                  ),
                ],
                if (request.kind == GatewayApprovalKind.command &&
                    request.command.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(l.command, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SelectableText(
                      request.command,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
                if (_confirmAlways) ...[
                  const SizedBox(height: 14),
                  Text(
                    l.this_creates_a_permanent_rule_in_hermes_review_the_full,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    _error!,
                    key: const Key('approval-error'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                for (final choice in request.choices) ...[
                  OutlinedButton.icon(
                    key: Key('approval-${choice.wireValue}'),
                    onPressed: busy ? null : () => _respond(choice),
                    icon: _submitting == choice
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(_iconFor(choice)),
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_labelFor(choice)),
                          Text(
                            _scopeFor(choice),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    style: choice == GatewayApprovalChoice.deny
                        ? OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                          )
                        : null,
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
