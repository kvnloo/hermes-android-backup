/// Edit and restore confirmation surfaces shared by Classic and NextGen.
///
/// The edit surface is a bounded inline composer: it returns the edited text
/// only on Send (never on Cancel or with an empty prompt), so a caller can
/// treat a null result as "no rewind requested". Restore and deep-cut
/// confirmations use the checkpoint copy, matching Desktop's
/// `deepCutConfirmRequest` (rewind.ts).
library;

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class EditTurnDialog extends StatefulWidget {
  const EditTurnDialog({super.key, required this.initialText});

  final String initialText;

  @override
  State<EditTurnDialog> createState() => _EditTurnDialogState();
}

class _EditTurnDialogState extends State<EditTurnDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    return AlertDialog(
      title: Text(l10n.edit_turn_title),
      content: SizedBox(
        width: double.maxFinite,
        child: TextField(
          key: const Key('edit-turn-field'),
          controller: _controller,
          autofocus: true,
          minLines: 4,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            labelText: l10n.edit_turn_body,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          key: const Key('edit-turn-cancel'),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('edit-turn-send'),
          onPressed: () {
            final edited = _controller.text.trim();
            if (edited.isEmpty) return;
            Navigator.of(context).pop(edited);
          },
          child: Text(l10n.edit_turn_send),
        ),
      ],
    );
  }
}

/// Confirmation for restoring a checkpoint or for any rewind that would
/// archive later user turns ([body] replaces the restore copy for an edit).
/// True only when the user chose the confirm action.
Future<bool> showRestoreTurnConfirm(
  BuildContext context, {
  String? body,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final l10n = dialogContext.sharedL10n;
      return AlertDialog(
        title: Text(l10n.restore_turn_title),
        content: Text(body ?? l10n.restore_turn_body),
        actions: [
          TextButton(
            key: const Key('restore-turn-cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const Key('restore-turn-confirm'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.restore_turn_confirm),
          ),
        ],
      );
    },
  );
  return confirmed == true;
}
