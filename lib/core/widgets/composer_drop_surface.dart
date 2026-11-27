import 'package:flutter/material.dart';

import '../composer/composer_drag.dart';
import '../l10n/l10n.dart';

class ComposerDropSurface extends StatelessWidget {
  const ComposerDropSurface({
    super.key,
    required this.child,
    required this.onDrop,
  });

  final Widget child;
  final ValueChanged<ComposerDrag> onDrop;

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    return DragTarget<ComposerDrag>(
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidate, rejected) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (candidate.isNotEmpty)
              Text(
                candidate.first?.onGateway == true ||
                        candidate.first?.directory == true
                    ? l10n.composer_drop_reference
                    : l10n.composer_drop_attach,
              ),
            child,
          ],
        );
      },
    );
  }
}
