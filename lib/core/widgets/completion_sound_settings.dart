import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../l10n/l10n.dart';
import '../services/notification_prefs.dart';
import '../services/turn_notification_service.dart';

/// Activity sharing and the completion sound, shared by the Classic and
/// NextGen notification settings (both already listen to
/// [NotificationPrefsStore]). The same control is shown on every platform.
///
/// The sound picker never sits in a [ListTile]'s `trailing` slot: on a narrow
/// phone with large text a trailing menu takes the whole tile width. The tile
/// shows the current choice as its subtitle and opens a sheet that wraps.
class CompletionSoundSettings extends StatelessWidget {
  const CompletionSoundSettings({super.key, required this.prefs});
  final NotificationPrefs prefs;

  static String soundLabel(AppLocalizations l, WindowsCompletionSound sound) =>
      switch (sound) {
        WindowsCompletionSound.system => l.completion_sound_system,
        WindowsCompletionSound.mail => l.completion_sound_mail,
        WindowsCompletionSound.reminder => l.completion_sound_reminder,
        WindowsCompletionSound.silent => l.completion_sound_silent,
      };

  static Future<void> _choose(WindowsCompletionSound sound) async {
    await NotificationPrefsStore.setWindowsSound(sound);
    await TurnNotificationService.shared.pruneCompletionChannels();
  }

  Future<void> _pick(BuildContext context) {
    final l = context.sharedL10n;
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.completion_sound,
                  style: Theme.of(sheet).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                RadioGroup<WindowsCompletionSound>(
                  groupValue: prefs.completionSound,
                  onChanged: (value) {
                    if (value != null) unawaited(_choose(value));
                    Navigator.of(sheet).pop();
                  },
                  child: Column(
                    children: [
                      for (final sound in WindowsCompletionSound.values)
                        RadioListTile<WindowsCompletionSound>(
                          key: ValueKey('completion-sound-${sound.name}'),
                          value: sound,
                          title: Text(soundLabel(l, sound)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    return Column(
      children: [
        SwitchListTile(
          key: const ValueKey('share-chat-activity'),
          title: Text(l.chat_activity_share),
          subtitle: Text(l.chat_activity_share_hint),
          value: prefs.shareWindowActivity,
          onChanged: NotificationPrefsStore.setShareWindowActivity,
        ),
        ListTile(
          key: const ValueKey('completion-sound'),
          title: Text(l.completion_sound),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(soundLabel(l, prefs.completionSound)),
              Text(
                defaultTargetPlatform == TargetPlatform.android
                    ? l.completion_sound_scope_android
                    : l.completion_sound_scope,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_drop_down),
          onTap: () => _pick(context),
        ),
        SwitchListTile(
          key: const ValueKey('mute-app-sounds'),
          title: Text(l.app_sounds_mute),
          subtitle: Text(l.app_sounds_mute_hint),
          value: prefs.muteAppSounds,
          onChanged: NotificationPrefsStore.setMuteAppSounds,
        ),
      ],
    );
  }
}
