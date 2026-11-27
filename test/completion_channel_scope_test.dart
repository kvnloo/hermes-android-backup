import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/widgets/completion_sound_settings.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _plugin = MethodChannel('dexterous.com/flutter/local_notifications');

/// Channel ids the Android plugin was asked to delete.
List<String> _recordDeletes() {
  final deleted = <String>[];
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_plugin, (call) async {
        if (call.method == 'deleteNotificationChannel') {
          deleted.add(call.arguments as String);
        }
        return switch (call.method) {
          'getActiveNotifications' => <Object>[],
          _ => true,
        };
      });
  return deleted;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    notificationPrefs.value = NotificationPrefs.defaults;
  });
  tearDown(() {
    notificationPrefs.value = NotificationPrefs.defaults;
    debugDefaultTargetPlatformOverride = null;
    TurnNotificationService.debugShared = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_plugin, null);
  });

  test('Android deletes the choice channels the current choice does not use; '
      'the historical channel stays', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    final deleted = _recordDeletes();
    final service = TurnNotificationService(sink: PluginTurnNotificationSink());
    for (final (sound, expected) in [
      (
        WindowsCompletionSound.reminder,
        ['hermes_turn_notifications_mail', 'hermes_turn_notifications_silent'],
      ),
      (
        WindowsCompletionSound.system,
        [
          'hermes_turn_notifications_mail',
          'hermes_turn_notifications_reminder',
          'hermes_turn_notifications_silent',
        ],
      ),
      (
        WindowsCompletionSound.silent,
        [
          'hermes_turn_notifications_mail',
          'hermes_turn_notifications_reminder',
        ],
      ),
    ]) {
      deleted.clear();
      notificationPrefs.value = NotificationPrefs.defaults.copyWith(
        completionSound: sound,
      );
      await service.pruneCompletionChannels();
      expect(deleted, unorderedEquals(expected), reason: sound.name);
      expect(deleted, isNot(contains('hermes_turn_notifications')));
    }
    // Startup cleans up too, after a successful initialisation.
    deleted.clear();
    notificationPrefs.value = NotificationPrefs.defaults.copyWith(
      completionSound: WindowsCompletionSound.mail,
    );
    final fresh = TurnNotificationService(sink: PluginTurnNotificationSink());
    await fresh.ensureInitialized(refreshPermission: false);
    expect(
      deleted,
      unorderedEquals([
        'hermes_turn_notifications_reminder',
        'hermes_turn_notifications_silent',
      ]),
    );
  });

  test('other platforms delete nothing', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final deleted = _recordDeletes();
    await TurnNotificationService(
      sink: PluginTurnNotificationSink(),
    ).pruneCompletionChannels();
    expect(deleted, isEmpty);
  });

  for (final platform in [TargetPlatform.android, TargetPlatform.linux]) {
    testWidgets('choosing a sound on ${platform.name} prunes channels and the '
        'hint states what it does not cover', (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      if (platform == TargetPlatform.android) {
        AndroidFlutterLocalNotificationsPlugin.registerWith();
      }
      final deleted = _recordDeletes();
      TurnNotificationService.debugShared = TurnNotificationService(
        sink: PluginTurnNotificationSink(),
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ValueListenableBuilder<NotificationPrefs>(
              valueListenable: notificationPrefs,
              builder: (_, prefs, _) => CompletionSoundSettings(prefs: prefs),
            ),
          ),
        ),
      );
      final android = platform == TargetPlatform.android;
      expect(
        find.textContaining('Android Auto messages keep their usual sound'),
        android ? findsOneWidget : findsNothing,
      );
      expect(
        find.textContaining(
          'Approvals and other alerts keep their usual sound',
        ),
        android ? findsNothing : findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('completion-sound')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('completion-sound-mail')));
      await tester.pumpAndSettle();
      expect(
        notificationPrefs.value.completionSound,
        WindowsCompletionSound.mail,
      );
      expect(find.text('Mail'), findsOneWidget);
      expect(
        deleted,
        android
            ? unorderedEquals([
                'hermes_turn_notifications_reminder',
                'hermes_turn_notifications_silent',
              ])
            : isEmpty,
      );
      debugDefaultTargetPlatformOverride = null;
    });
  }
}
