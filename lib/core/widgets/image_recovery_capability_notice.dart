import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../l10n/service_strings.dart';

/// Why this composer cannot restore an image together with its text.
///
/// Stock canonical sends keep a frozen receipt. These two transports do not,
/// and the composer says so instead of offering a control that cannot work.
enum ImageRecoveryGap { restSse, recoveryV2 }

/// One line above a composer holding an image; tap for the full explanation. On a
/// phone with large text a full paragraph pushed the composer, its model
/// chip and the hands-free controls off the usable area.
class ImageRecoveryCapabilityNotice extends StatefulWidget {
  const ImageRecoveryCapabilityNotice({super.key, required this.gap});

  final ImageRecoveryGap gap;

  static String get restExplanation =>
      serviceStrings.rel_svc_misc_image_recovery_rest_gap;

  static String get recoveryExplanation =>
      serviceStrings.rel_svc_misc_image_recovery_companion_gap;

  @override
  State<ImageRecoveryCapabilityNotice> createState() =>
      _ImageRecoveryCapabilityNoticeState();
}

class _ImageRecoveryCapabilityNoticeState
    extends State<ImageRecoveryCapabilityNotice> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final text = switch (widget.gap) {
      ImageRecoveryGap.restSse => l.rel_svc_misc_image_recovery_rest_gap,
      ImageRecoveryGap.recoveryV2 =>
        l.rel_svc_misc_image_recovery_companion_gap,
    };
    final style = Theme.of(context).textTheme.bodySmall;
    return Semantics(
      button: true,
      expanded: _expanded,
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6, top: 1),
                child: Icon(Icons.info_outline, size: 16, color: style?.color),
              ),
              Expanded(
                child: Text(
                  text,
                  key: ValueKey('image-recovery-gap-${widget.gap.name}'),
                  style: style,
                  maxLines: _expanded ? null : 1,
                  overflow: _expanded ? null : TextOverflow.ellipsis,
                ),
              ),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: style?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
