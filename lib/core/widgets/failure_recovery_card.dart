import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../composer/failure_recovery.dart';

class FailureRecoveryCard extends StatefulWidget {
  const FailureRecoveryCard({
    super.key,
    required this.message,
    required this.recovery,
    required this.diagnosticsText,
    this.showDiagnostics = true,
    this.resetsAt,
    this.nowMs,
    this.onRetry,
    this.onCompress,
    this.onChooseModel,
    this.onSwitchTo,
    this.switchRetries = true,
    this.onNewSession,
    this.onEdit,
    this.onDismiss,
  });

  final String message;
  final PresentedRecovery recovery;
  final String diagnosticsText;
  final bool showDiagnostics;
  final int? resetsAt;

  /// Fixed clock for tests. A null clock uses the device clock and a timer.
  final int? nowMs;
  final VoidCallback? onRetry;
  final Future<void> Function()? onCompress;
  final VoidCallback? onChooseModel;
  final Future<void> Function(ModelSuggestion suggestion)? onSwitchTo;

  /// Whether [onSwitchTo] runs the failed turn again after switching. Where
  /// it cannot (a transport with no regenerate), the card and its confirm
  /// say so before the switch.
  final bool switchRetries;
  final VoidCallback? onNewSession;
  final VoidCallback? onEdit;
  final VoidCallback? onDismiss;

  @override
  State<FailureRecoveryCard> createState() => _FailureRecoveryCardState();
}

class _FailureRecoveryCardState extends State<FailureRecoveryCard> {
  bool _details = false;
  Timer? _retry;
  int? _firesAt;

  @override
  void dispose() {
    _retry?.cancel();
    super.dispose();
  }

  int get _now => widget.nowMs ?? DateTime.now().millisecondsSinceEpoch;

  /// A Switch to button that will not re-run the failed turn.
  bool get _switchOnly =>
      !widget.switchRetries &&
      widget.onSwitchTo != null &&
      widget.recovery.suggestion != null &&
      (widget.recovery.primary == RecoveryAction.switchToModel ||
          widget.recovery.secondary == RecoveryAction.switchToModel);

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.errorContainer,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(widget.message)),
                if (widget.onDismiss != null)
                  IconButton(
                    tooltip: l10n.dismiss,
                    onPressed: widget.onDismiss,
                    icon: const Icon(Icons.close, size: 18),
                  ),
              ],
            ),
            if (widget.recovery.omittedExternal)
              Text(
                widget.recovery.primary == null
                    ? l10n.composer_failure_account_only
                    : l10n.composer_failure_account,
              ),
            Wrap(
              spacing: 8,
              children: [
                if (_firesAt != null)
                  TextButton(
                    onPressed: () {
                      _retry?.cancel();
                      setState(() => _firesAt = null);
                    },
                    child: Text(l10n.cancel),
                  )
                else ...[
                  ?_button(widget.recovery.primary, primary: true),
                  ?_button(widget.recovery.secondary, primary: false),
                ],
              ],
            ),
            if (_switchOnly)
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 4),
                child: Text(
                  l10n.composer_failure_switch_no_retry,
                  key: const ValueKey('failure-card-switch-no-retry'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            if (widget.showDiagnostics)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => setState(() => _details = !_details),
                  child: Text(
                    _details
                        ? l10n.composer_failure_hide_details
                        : l10n.composer_failure_details,
                  ),
                ),
              ),
            if (widget.showDiagnostics && _details) ...[
              SelectableText(widget.diagnosticsText),
              TextButton(
                onPressed: () => Clipboard.setData(
                  ClipboardData(text: widget.diagnosticsText),
                ),
                child: Text(l10n.composer_failure_copy),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget? _button(RecoveryAction? action, {required bool primary}) {
    if (action == null) return null;
    final l10n = context.sharedL10n;
    final label = _label(l10n, action);
    final VoidCallback? onPressed = switch (action) {
      RecoveryAction.retry => widget.onRetry,
      RecoveryAction.retryAtReset => widget.onRetry == null ? null : _schedule,
      RecoveryAction.compress => widget.onCompress == null ? null : _compress,
      RecoveryAction.chooseModel ||
      RecoveryAction.switchProvider ||
      RecoveryAction.openModelSettings => widget.onChooseModel,
      RecoveryAction.switchToModel =>
        widget.onSwitchTo == null || widget.recovery.suggestion == null
            ? widget.onChooseModel
            : _switchTo,
      RecoveryAction.startNewSession => widget.onNewSession,
      RecoveryAction.editMessage ||
      RecoveryAction.continueReply => widget.onEdit,
      _ => null,
    };
    if (onPressed == null || label == null) return null;
    return primary
        ? FilledButton(onPressed: onPressed, child: Text(label))
        : TextButton(onPressed: onPressed, child: Text(label));
  }

  String? _label(AppLocalizations l10n, RecoveryAction action) {
    return switch (action) {
      RecoveryAction.retry => l10n.composer_failure_retry,
      RecoveryAction.retryAtReset =>
        widget.resetsAt == null
            ? l10n.composer_failure_retry
            : l10n.composer_failure_retry_at(
                formatResetClock(widget.resetsAt!),
              ),
      RecoveryAction.compress => l10n.composer_failure_compress,
      RecoveryAction.chooseModel ||
      RecoveryAction.switchProvider ||
      RecoveryAction.openModelSettings => l10n.composer_failure_switch_model,
      RecoveryAction.switchToModel =>
        widget.recovery.suggestion == null
            ? l10n.composer_failure_switch_model
            : l10n.composer_failure_switch_to(
                widget.recovery.suggestion!.label,
              ),
      RecoveryAction.startNewSession => l10n.composer_failure_new_chat,
      RecoveryAction.editMessage ||
      RecoveryAction.continueReply => l10n.composer_failure_edit,
      _ => null,
    };
  }

  void _schedule() {
    final delay = scheduledRetryDelayMs(widget.resetsAt, _now);
    if (delay == null) {
      widget.onRetry?.call();
      return;
    }
    _retry?.cancel();
    setState(() => _firesAt = _now + delay);
    _retry = Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      setState(() => _firesAt = null);
      widget.onRetry?.call();
    });
  }

  Future<void> _compress() async {
    final l10n = context.sharedL10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.composer_failure_confirm_compress),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.composer_failure_compress),
          ),
        ],
      ),
    );
    if (confirmed == true) await widget.onCompress?.call();
  }

  Future<void> _switchTo() async {
    final suggestion = widget.recovery.suggestion;
    final compress = widget.onSwitchTo;
    if (suggestion == null || compress == null) {
      widget.onChooseModel?.call();
      return;
    }
    final l10n = context.sharedL10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          [
            l10n.composer_failure_confirm_model(suggestion.label),
            if (!widget.switchRetries) l10n.composer_failure_switch_no_retry,
          ].join('\n\n'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.composer_failure_switch_model),
          ),
        ],
      ),
    );
    if (confirmed == true) await compress(suggestion);
  }
}
