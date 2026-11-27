import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'petdex.dart';
import 'presentation_scope.dart';
import 'radio.dart';
import 'transcript_reading.dart';

/// Status-bar companion and radio. Both stay absent until the reader opts in,
/// so existing chrome is unchanged for a fresh install.
///
/// On a narrow pane ([compact]) the radio's controls are not drawn here: the
/// chat's "More chat tools" menu offers them through [radioToolItem] instead,
/// and the companion stays as a single status icon.
class PresentationChrome extends StatelessWidget {
  const PresentationChrome({
    super.key,
    this.activity = PetActivity.idle,
    this.unread = false,
    this.onCompose,
    this.compact = false,
  });

  final PetActivity activity;
  final bool unread;
  final VoidCallback? onCompose;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final host = PresentationScope.maybeOf(context);
    if (host == null) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: Listenable.merge([host.pet, host.radio, host.reading]),
      builder: (context, _) {
        final pet = host.pet.enabled;
        final radio = host.radio.enabled && !compact;
        if (!pet && !radio) return const SizedBox.shrink();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (radio) AresRadioBar(radio: host.radio),
            if (pet)
              PetCompanion.compact(
                controller: host.pet,
                activity: activity,
                anyUnread: unread,
                onCompose: onCompose,
              ),
            if (pet) CelebrationHearts(play: unread),
          ],
        );
      },
    );
  }
}

/// Notifies when the radio is switched on or off, so a narrow pane can add or
/// drop its tools-menu entry.
Listenable presentationToolsListenable(BuildContext context) =>
    Listenable.merge([PresentationScope.maybeOf(context)?.radioEnabled]);

/// The radio, when a narrow pane's tools menu should offer it.
AresRadio? compactRadioTool(BuildContext context) {
  final radio = PresentationScope.maybeOf(context)?.radio;
  return radio != null && radio.enabled ? radio : null;
}

/// Menu value of [radioToolItem].
const radioToolValue = 'presentation-radio';

/// The "Radio" entry of a narrow pane's "More chat tools" menu. Choosing it
/// opens the radio sheet with the station, play and next controls.
PopupMenuItem<String> radioToolItem(BuildContext context) => PopupMenuItem(
  value: radioToolValue,
  child: ListTile(
    leading: const Icon(Icons.radio_outlined),
    title: Text(context.sharedL10n.appearance_radio),
  ),
);
