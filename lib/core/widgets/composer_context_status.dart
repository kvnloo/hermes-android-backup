import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../composer/context_status.dart';

/// Customisable live status. Hidden items stay off until chosen. A visible
/// item with no reported figure says so in the menu and stays off the bar.
///
/// It sits above the composer, so its height is bounded by [maxHeight]
/// (the caller passes its keyboard-aware share) and it scrolls inside. With
/// [showMenu] false the Status control lives in the composer's own menu
/// ([showComposerStatusSheet]) and nothing shows until an item is on, so
/// the composer is no taller by default. On a [compact] (narrow) pane the
/// context breakdown starts folded.
class ComposerContextStatus extends StatefulWidget {
  const ComposerContextStatus({
    super.key,
    required this.layout,
    required this.usage,
    required this.onLayout,
    this.breakdown,
    this.breakdownLoading = false,
    this.runningSinceMs,
    this.sessionSinceMs,
    this.nowMs,
    this.compact = false,
    this.showMenu = true,
    this.maxHeight = double.infinity,
  });

  final StatusBarLayout layout;
  final UsageReading usage;
  final ContextReading? breakdown;
  final bool breakdownLoading;
  final int? runningSinceMs;
  final int? sessionSinceMs;
  final int? nowMs;
  final ValueChanged<StatusBarLayout> onLayout;
  final bool compact;
  final bool showMenu;
  final double maxHeight;

  @override
  State<ComposerContextStatus> createState() => _ComposerContextStatusState();
}

/// The Status choices as a sheet: the composer menu's entry on a compact
/// pane, where an always-visible Status control would crowd the editor.
Future<void> showComposerStatusSheet({
  required BuildContext context,
  required StatusBarLayout layout,
  required UsageReading usage,
  required ContextReading? breakdown,
  required int? runningSinceMs,
  required int? sessionSinceMs,
  required ValueChanged<StatusBarLayout> onLayout,
}) async {
  final l10n = context.sharedL10n;
  var current = layout;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (sheetContext, setSheet) {
        void toggle(String id) {
          current = current.setVisible(id, !current.visible(id));
          setSheet(() {});
          onLayout(current);
        }

        final items = _statusItems(
          l10n,
          usage: usage,
          breakdown: breakdown,
          runningSinceMs: runningSinceMs,
          sessionSinceMs: sessionSinceMs,
        );
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(title: Text(l10n.composer_status)),
                for (final item in items)
                  CheckboxListTile(
                    key: ValueKey('composer-status-${item.id}'),
                    value: current.visible(item.id),
                    title: Text(item.label),
                    subtitle: item.reported
                        ? null
                        : Text(l10n.composer_status_not_reported),
                    onChanged: (_) => toggle(item.id),
                  ),
                ListTile(
                  title: Text(l10n.composer_status_reset),
                  onTap: () {
                    current = current.reset();
                    setSheet(() {});
                    onLayout(current);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

/// The Status control on its own, for a row the composer already has (the
/// Classic model row), so it adds no height.
class ComposerStatusMenu extends StatelessWidget {
  const ComposerStatusMenu({
    super.key,
    required this.layout,
    required this.usage,
    required this.onLayout,
    this.breakdown,
    this.runningSinceMs,
    this.sessionSinceMs,
  });

  final StatusBarLayout layout;
  final UsageReading usage;
  final ContextReading? breakdown;
  final int? runningSinceMs;
  final int? sessionSinceMs;
  final ValueChanged<StatusBarLayout> onLayout;

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    return PopupMenuButton<String>(
      key: const ValueKey('composer-status-menu'),
      tooltip: l10n.composer_status,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Align(
            widthFactor: 1,
            child: Text(l10n.composer_status, overflow: TextOverflow.fade),
          ),
        ),
      ),
      itemBuilder: (context) => [
        for (final item in _statusItems(
          l10n,
          usage: usage,
          breakdown: breakdown,
          runningSinceMs: runningSinceMs,
          sessionSinceMs: sessionSinceMs,
        ))
          PopupMenuItem(
            value: item.id,
            child: Text(
              '${item.label} ${layout.visible(item.id) ? '\u2713' : ''}'
              '${item.reported ? '' : ' \u00b7 ${l10n.composer_status_not_reported}'}',
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'reset', child: Text(l10n.composer_status_reset)),
      ],
      onSelected: (id) {
        if (id == 'reset') {
          onLayout(layout.reset());
          return;
        }
        onLayout(layout.setVisible(id, !layout.visible(id)));
      },
    );
  }
}

typedef _StatusItem = ({String id, String label, bool reported});

/// The Status choices. The session timer is offered only when the gateway
/// reports when the session started.
List<_StatusItem> _statusItems(
  AppLocalizations l10n, {
  required UsageReading usage,
  required ContextReading? breakdown,
  required int? runningSinceMs,
  required int? sessionSinceMs,
}) => [
  (
    id: 'context-usage',
    label: l10n.composer_status_context,
    reported:
        (breakdown != null && breakdown.usable) ||
        contextSummary(usage).isNotEmpty,
  ),
  (
    id: 'cache-hit-rate',
    label: l10n.composer_status_cache,
    reported: cacheHitLabel(usage.cacheHitPct).isNotEmpty,
  ),
  (
    id: 'tokens-per-second',
    label: l10n.composer_status_throughput,
    reported: tokensPerSecondLabel(usage.avgTps).isNotEmpty,
  ),
  (
    id: 'running-timer',
    label: l10n.composer_status_running,
    reported: runningSinceMs != null,
  ),
  if (sessionSinceMs != null)
    (id: 'session-timer', label: l10n.composer_status_session, reported: true),
];

class _ComposerContextStatusState extends State<ComposerContextStatus> {
  Timer? _tick;
  int _now = 0;
  bool? _expanded;

  @override
  void initState() {
    super.initState();
    _now = widget.nowMs ?? DateTime.now().millisecondsSinceEpoch;
    _arm();
  }

  @override
  void didUpdateWidget(covariant ComposerContextStatus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nowMs != null) _now = widget.nowMs!;
    _arm();
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _arm() {
    final live =
        widget.nowMs == null &&
        ((widget.layout.visible('running-timer') &&
                widget.runningSinceMs != null) ||
            (widget.layout.visible('session-timer') &&
                widget.sessionSinceMs != null));
    if (!live) {
      _tick?.cancel();
      _tick = null;
      return;
    }
    _tick ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now().millisecondsSinceEpoch);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    final reading = widget.breakdown != null && widget.breakdown!.usable
        ? UsageReading(
            cacheHitPct: widget.usage.cacheHitPct,
            avgTps: widget.usage.avgTps,
            contextUsed:
                widget.breakdown!.contextUsed ?? widget.usage.contextUsed,
            contextMax: widget.breakdown!.contextMax ?? widget.usage.contextMax,
            contextPercent:
                widget.breakdown!.contextPercent ?? widget.usage.contextPercent,
            estimated: widget.breakdown!.estimated || widget.usage.estimated,
            compressions: widget.usage.compressions,
          )
        : widget.usage;
    final chips = <Widget>[
      if (widget.layout.visible('context-usage') &&
          contextSummary(reading).isNotEmpty)
        _chip(l10n.composer_status_context, contextSummary(reading)),
      if (widget.layout.visible('cache-hit-rate') &&
          cacheHitLabel(reading.cacheHitPct).isNotEmpty)
        _chip(l10n.composer_status_cache, cacheHitLabel(reading.cacheHitPct)),
      if (widget.layout.visible('tokens-per-second') &&
          tokensPerSecondLabel(reading.avgTps).isNotEmpty)
        _chip(
          l10n.composer_status_throughput,
          tokensPerSecondLabel(reading.avgTps),
        ),
      if (widget.layout.visible('running-timer') &&
          widget.runningSinceMs != null)
        _chip(
          l10n.composer_status_running,
          formatDuration(_now - widget.runningSinceMs!),
        ),
      if (widget.layout.visible('session-timer') &&
          widget.sessionSinceMs != null)
        _chip(
          l10n.composer_status_session,
          formatDuration(_now - widget.sessionSinceMs!),
        ),
    ];
    final showBreakdown = widget.layout.visible('context-usage');
    if (!widget.showMenu && chips.isEmpty && !showBreakdown) {
      return const SizedBox.shrink();
    }
    final expanded = _expanded ?? !widget.compact;
    final bar = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        ...chips,
        if (widget.showMenu) _menu(l10n),
        if (showBreakdown)
          TextButton.icon(
            key: const ValueKey('composer-context-breakdown-toggle'),
            onPressed: () => setState(() => _expanded = !expanded),
            icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
            label: Text(l10n.composer_status_context),
          ),
      ],
    );
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: SingleChildScrollView(
        key: const ValueKey('composer-context-status'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [bar, if (showBreakdown && expanded) _breakdown(l10n)],
        ),
      ),
    );
  }

  Widget _menu(AppLocalizations l10n) => ComposerStatusMenu(
    layout: widget.layout,
    usage: widget.usage,
    breakdown: widget.breakdown,
    runningSinceMs: widget.runningSinceMs,
    sessionSinceMs: widget.sessionSinceMs,
    onLayout: widget.onLayout,
  );

  Widget _breakdown(AppLocalizations l10n) {
    final breakdown = widget.breakdown;
    if (widget.breakdownLoading && (breakdown == null || !breakdown.usable)) {
      return Text(l10n.composer_status_loading);
    }
    if (breakdown == null ||
        !breakdown.usable ||
        breakdown.categories.isEmpty) {
      return Text(l10n.composer_status_empty);
    }
    return Column(
      key: const ValueKey('composer-context-breakdown'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final category in breakdown.categories)
          Text('${category.label} ${category.tokens}'),
      ],
    );
  }

  Widget _chip(String label, String value) =>
      Chip(label: Text('$label $value'));
}
