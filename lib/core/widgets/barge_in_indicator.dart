import 'package:flutter/material.dart';

/// Shown above the composer while barge-in listens during read-aloud: the
/// microphone is on for as long as a reply is being read, so the chat says
/// so (both layouts). Bounded by [maxHeight] and scrolling inside it, so an
/// open keyboard never pushes the composer off screen.
class BargeInMicLiveIndicator extends StatelessWidget {
  const BargeInMicLiveIndicator({
    super.key,
    required this.label,
    this.maxHeight = double.infinity,
  });

  final String label;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Semantics(
          liveRegion: true,
          label: label,
          excludeSemantics: true,
          child: Container(
            key: const ValueKey('barge-in-mic-live'),
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: scheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: scheme.tertiary.withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.mic, size: 18, color: scheme.onTertiaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
