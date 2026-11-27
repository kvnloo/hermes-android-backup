import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';

TurnNotification _done() => TurnNotification(
  id: 1,
  title: 't',
  body: 'b',
  payload: '{}',
  channel: TurnNotificationService.turnChannel,
  kind: HermesNotificationKind.turnDone,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => notificationPrefs.value = NotificationPrefs.defaults);

  test('the sound and activity strings have platform-neutral keys', () {
    final en =
        jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
            as Map<String, dynamic>;
    for (final key in [
      'chat_activity_share',
      'chat_activity_share_hint',
      'completion_sound',
      'completion_sound_system',
      'completion_sound_mail',
      'completion_sound_reminder',
      'completion_sound_silent',
      'completion_sound_scope',
      'completion_sound_scope_android',
      'app_sounds_mute',
      'app_sounds_mute_hint',
      'notification_open_action',
    ]) {
      expect(en[key], isA<String>(), reason: key);
    }
    for (final file in Directory('lib/l10n').listSync()) {
      if (!file.path.endsWith('.arb')) continue;
      final text = File(file.path).readAsStringSync();
      expect(
        RegExp(
          r'"windows_(window_activity|completion_sound|sound_)',
        ).hasMatch(text),
        isFalse,
        reason: file.path,
      );
    }
  });

  test('Android channel suffixes and the Linux open action are localised', () {
    for (final (sound, label) in [
      (WindowsCompletionSound.mail, 'Mail'),
      (WindowsCompletionSound.reminder, 'Reminder'),
      (WindowsCompletionSound.silent, 'Silent'),
    ]) {
      notificationPrefs.value = NotificationPrefs.defaults.copyWith(
        completionSound: sound,
      );
      final details = turnNotificationDetails(_done());
      final strings = notificationStrings();
      expect(details.android!.channelName, 'Ares Turns ($label)');
      expect(
        details.android!.channelName,
        contains(switch (sound) {
          WindowsCompletionSound.mail => strings.completion_sound_mail,
          WindowsCompletionSound.reminder => strings.completion_sound_reminder,
          _ => strings.completion_sound_silent,
        }),
      );
      expect(details.linux!.defaultActionName, 'Open');
    }
    notificationPrefs.value = NotificationPrefs.defaults;
    expect(
      turnNotificationDetails(_done()).android!.channelName,
      'Ares Turns',
      reason: 'System default keeps the historical channel',
    );
  });
}
