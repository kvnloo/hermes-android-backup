import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../models/session.dart';

/// A temporary draft ID is not a shareable gateway identifier.
bool canCopySessionId(Session session) =>
    !session.isLocalDraft && session.id.trim().isNotEmpty;

Future<void> copySessionId(BuildContext context, Session session) async {
  if (!canCopySessionId(session)) return;
  var copied = false;
  try {
    await Clipboard.setData(ClipboardData(text: session.id));
    copied = true;
  } on PlatformException {
    // Clipboard access can be denied by the host.
  } on MissingPluginException {
    // A client without a clipboard backend must not claim success.
  }
  if (!context.mounted) return;
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      content: Text(
        copied ? context.l10n.ng_copied : context.l10n.copy_session_id_failed,
      ),
    ),
  );
}
