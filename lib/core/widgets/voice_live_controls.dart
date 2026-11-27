import 'dart:async';

import 'package:flutter/material.dart';

import '../../nextgen/ui/session_dock.dart' show ngAboveComposerMaxHeight;
import '../l10n/l10n.dart';
import '../services/voice_live_engine.dart';
import '../services/voice_live_mode.dart';

/// Menu value for the narrow-pane (`< 480 px`) "More chat tools" voice-engine row.
const String voiceEngineToolValue = 'voice-live-engine';

///Localized state label for [VoiceLiveEngine].
String voiceLiveStateLabel(BuildContext context, VoiceLiveEngine engine) {
  final l10n = context.sharedL10n;
  if (engine.muted && engine.state == VoiceLiveState.listening) {
    return l10n.voice_live_muted;
  }
  return switch (engine.state) {
    VoiceLiveState.speaking => l10n.voice_live_speaking,
    VoiceLiveState.thinking => l10n.voice_live_thinking,
    VoiceLiveState.listening ||
    VoiceLiveState.idle => l10n.voice_live_listening,
  };
}

/// What to tell the person when a live session ends without them asking
/// (Desktop's `liveEndedMessage`). `connection_lost` and `closed` are our own
/// machine reasons and get copy; any other reason is server-sent and passes
/// through verbatim. Null when there is nothing to announce: a stop the app
/// made itself, or a failed start (reported by its own error).
String? voiceLiveEndedNotice(BuildContext context, String reason) {
  final l10n = context.sharedL10n;
  final text = reason.trim();
  return switch (text) {
    'close_requested' || 'start_failed' || 'cancelled' || 'disposed' => null,
    'connection_lost' => l10n.voice_live_ended_connection_lost,
    'closed' || '' => l10n.voice_live_ended_closed,
    _ => text,
  };
}

/// Entry for a narrow pane's (`< 480 px`) "More chat tools" menu.
PopupMenuItem<String> voiceEngineToolItem(
  BuildContext context,
  VoiceLiveModeController controller,
) {
  final l10n = context.sharedL10n;
  final isLive = controller.effectiveMode == 'gpt-live';
  final shortName = isLive
      ? l10n.voice_engine_live_short
      : l10n.voice_engine_chained_short;
  final reason = controller.unavailableReason;
  return PopupMenuItem<String>(
    key: const ValueKey('chat-tools-voice-engine'),
    value: voiceEngineToolValue,
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isLive ? Icons.graphic_eq : Icons.record_voice_over_outlined,
        color: isLive ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text('${l10n.voice_engine_title} · $shortName'),
      subtitle: reason == null
          ? null
          : Text(reason, maxLines: 2, overflow: TextOverflow.ellipsis),
    ),
  );
}

/// Opens a compact bottom sheet with the voice-engine selector (mirrors
/// Hermes Desktop's `VoiceEngineRows`), constrained with
/// [ngAboveComposerMaxHeight] so an open keyboard never hides controls.
Future<void> showVoiceEngineSheet(
  BuildContext context, {
  required VoiceLiveModeController controller,
  bool disabled = false,
}) {
  unawaited(controller.refresh());
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      final cap = ngAboveComposerMaxHeight(
        sheetContext,
        available: MediaQuery.sizeOf(sheetContext).height,
        fraction: 0.45,
        withKeyboard: 0.35,
      );
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: cap < 200 ? 200 : cap),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: SingleChildScrollView(
            child: VoiceEngineSettingsPanel(
              controller: controller,
              disabled: disabled,
            ),
          ),
        ),
      );
    },
  );
}

/// Shared voice-engine selector (`chained` vs `gpt-live`) usable in Settings
/// and composer menus. Mirrors Desktop's `voice-engine-rows.tsx`:
/// - Hidden while the backend has not answered (`status == null`), so older
///   gateways never show a broken toggle.
/// - Shows the host's unavailability reason under GPT-Live and falls back to
///   Chained when `available` is false.
class VoiceEngineSettingsPanel extends StatelessWidget {
  const VoiceEngineSettingsPanel({
    super.key,
    required this.controller,
    this.disabled = false,
    this.titleOverride,
    this.subtitleOverride,
  });

  final VoiceLiveModeController controller;
  final bool disabled;
  final String? titleOverride;
  final String? subtitleOverride;

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final status = controller.status;
        if (status == null) return const SizedBox.shrink();
        final scheme = Theme.of(context).colorScheme;
        final effective = controller.effectiveMode;
        final liveAvailable = controller.liveAvailable;
        final reason =
            controller.unavailableReason ?? l10n.voice_engine_live_needs_key;
        final busy = disabled || controller.saving;

        return Column(
          key: const ValueKey('voice-engine-panel'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleOverride ?? l10n.voice_engine_title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 2),
            Text(
              subtitleOverride ?? l10n.voice_engine_subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (controller.fellBackToChained) ...[
              const SizedBox(height: 6),
              Text(
                l10n.voice_engine_fallback_chained(reason),
                key: const ValueKey('voice-engine-fallback-notice'),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 6),
            _EngineRadioRow(
              rowKey: const ValueKey('voice-engine-chained'),
              label: l10n.voice_engine_chained,
              selected: effective == 'chained',
              enabled: !busy,
              onTap: () => unawaited(controller.setMode('chained')),
            ),
            _EngineRadioRow(
              rowKey: const ValueKey('voice-engine-gpt-live'),
              label: l10n.voice_engine_live,
              subtitle: liveAvailable ? null : reason,
              selected: effective == 'gpt-live',
              enabled: !busy && liveAvailable,
              onTap: () => unawaited(controller.setMode('gpt-live')),
            ),
          ],
        );
      },
    );
  }
}

class _EngineRadioRow extends StatelessWidget {
  const _EngineRadioRow({
    required this.rowKey,
    required this.label,
    this.subtitle,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final Key rowKey;
  final String label;
  final String? subtitle;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      key: rowKey,
      inMutuallyExclusiveGroup: true,
      selected: selected,
      enabled: enabled,
      button: true,
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        enabled: enabled,
        leading: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: selected
              ? scheme.primary
              : (enabled ? scheme.onSurfaceVariant : scheme.outline),
        ),
        title: Text(label),
        subtitle: subtitle == null ? null : Text(subtitle!),
        onTap: enabled ? onTap : null,
      ),
    );
  }
}

/// Inline controls rendered inside the composer bar while a GPT-Live session
/// is active (no extra above-composer stack). Surfaces `listening`, `thinking`,
/// and `speaking` states, plus Mute, Interrupt/Respond-now, and Stop.
class VoiceLiveInlineControls extends StatelessWidget {
  const VoiceLiveInlineControls({
    super.key,
    required this.engine,
    required this.onToggleMute,
    required this.onInterrupt,
    required this.onStop,
    this.compact = false,
  });

  final VoiceLiveEngine engine;
  final VoidCallback onToggleMute;
  final VoidCallback onInterrupt;
  final VoidCallback onStop;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: engine,
      builder: (context, _) {
        final l10n = context.sharedL10n;
        final scheme = Theme.of(context).colorScheme;
        final label = voiceLiveStateLabel(context, engine);
        final muted = engine.muted;
        return Row(
          key: const ValueKey('voice-live-inline-controls'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Semantics(
                liveRegion: true,
                label: label,
                child: Container(
                  key: const ValueKey('voice-live-state'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        switch (engine.state) {
                          VoiceLiveState.speaking => Icons.volume_up,
                          VoiceLiveState.thinking => Icons.hourglass_top,
                          VoiceLiveState.listening || VoiceLiveState.idle =>
                            muted ? Icons.mic_off : Icons.graphic_eq,
                        },
                        size: 15,
                        color: scheme.onSecondaryContainer,
                      ),
                      if (!compact) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: scheme.onSecondaryContainer),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              key: const ValueKey('voice-live-mute'),
              visualDensity: VisualDensity.compact,
              tooltip: muted ? l10n.voice_live_unmute : l10n.voice_live_mute,
              icon: Icon(
                muted ? Icons.mic_off : Icons.mic,
                color: muted ? scheme.error : scheme.primary,
              ),
              onPressed: onToggleMute,
            ),
            IconButton(
              key: const ValueKey('voice-live-interrupt'),
              visualDensity: VisualDensity.compact,
              tooltip: l10n.voice_live_interrupt,
              icon: const Icon(Icons.stop_circle_outlined),
              onPressed: onInterrupt,
            ),
            IconButton.filled(
              key: const ValueKey('voice-live-stop'),
              visualDensity: VisualDensity.compact,
              tooltip: l10n.voice_live_stop,
              style: IconButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ),
              icon: const Icon(Icons.call_end, size: 18),
              onPressed: onStop,
            ),
          ],
        );
      },
    );
  }
}
