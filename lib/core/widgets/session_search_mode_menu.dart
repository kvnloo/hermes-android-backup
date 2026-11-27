import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/session_search_preferences.dart';

class SessionSearchModeMenu extends StatelessWidget {
  const SessionSearchModeMenu(this.access, {super.key});
  final SessionSearchAccess access;

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final local = l.on_device;
    final gateway = l.release_core_search_gateway_mode(l.full_text);
    return PopupMenuButton<bool>(
      tooltip: l.release_core_search_mode_tooltip(
        l.search_mode,
        access.value ? gateway : local,
      ),
      icon: Icon(access.value ? Icons.manage_search : Icons.phone_android),
      itemBuilder: (_) => [
        CheckedPopupMenuItem(
          value: false,
          checked: !access.value,
          child: Text(local),
        ),
        CheckedPopupMenuItem(
          value: true,
          checked: access.value,
          child: Text(gateway),
        ),
      ],
      onSelected: (enabled) async {
        try {
          await access.setServer(enabled);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l.release_core_session_search_mode_menu_could_not_save_search_mode,
                ),
              ),
            );
          }
        }
      },
    );
  }
}
