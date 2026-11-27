import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/completion_cue.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/widgets/completion_sound_settings.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

TurnNotification _notice({
  HermesNotificationKind? kind,
  String payload = '{}',
  bool silent = false,
  bool onlyAlertOnce = false,
  bool ongoing = false,
  TurnNotificationChannel? channel,
}) {
  return TurnNotification(
    id: 7,
    title: 't',
    body: 'b',
    payload: payload,
    channel: channel ?? TurnNotificationService.turnChannel,
    kind: kind,
    silent: silent,
    onlyAlertOnce: onlyAlertOnce,
    ongoing: ongoing,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    notificationPrefs.value = NotificationPrefs.defaults;
  });

  test('completion choices keep the Windows toast sound names', () {
    notificationPrefs.value = NotificationPrefs.defaults.copyWith(
      completionSound: WindowsCompletionSound.mail,
    );
    final mail = CompletionCue.resolve(
      silent: false,
      onlyAlertOnce: false,
      ongoing: false,
      payload: '{}',
      kind: HermesNotificationKind.turnDone,
    );
    expect(mail.channelSuffix, WindowsCompletionSound.mail.name);
    expect(mail.androidRaw, 'ares_mail');
    expect(mail.darwinFile, 'ares_mail.wav');
    expect(mail.linuxTheme, 'message-new-email');

    notificationPrefs.value = NotificationPrefs.defaults.copyWith(
      completionSound: WindowsCompletionSound.reminder,
    );
    final testAlert = CompletionCue.resolve(
      silent: false,
      onlyAlertOnce: false,
      ongoing: false,
      payload: 'test',
      kind: null,
    );
    expect(testAlert.channelSuffix, WindowsCompletionSound.reminder.name);
    expect(testAlert.androidRaw, 'ares_reminder');

    final approval = CompletionCue.resolve(
      silent: false,
      onlyAlertOnce: true,
      ongoing: false,
      payload: '{}',
      kind: HermesNotificationKind.approval,
    );
    expect(approval.audible, isTrue);
    expect(approval.channelSuffix, isEmpty);
    expect(approval.androidRaw, isNull);
  });

  test('only a completion or test alert changes sound', () {
    notificationPrefs.value = NotificationPrefs.defaults.copyWith(
      completionSound: WindowsCompletionSound.mail,
    );
    final done = turnNotificationDetails(
      _notice(kind: HermesNotificationKind.turnDone),
    );
    expect(done.android!.channelId, 'hermes_turn_notifications_mail');
    expect(done.android!.playSound, isTrue);
    expect(
      (done.android!.sound! as RawResourceAndroidNotificationSound).sound,
      'ares_mail',
    );
    expect(done.iOS!.presentAlert, isTrue);
    expect(done.iOS!.presentSound, isTrue);
    expect(done.iOS!.sound, 'ares_mail.wav');
    expect(done.macOS!.sound, 'ares_mail.wav');
    expect(done.linux!.suppressSound, isFalse);
    expect((done.linux!.sound! as ThemeLinuxSound).name, 'message-new-email');

    final approval = turnNotificationDetails(
      _notice(
        kind: HermesNotificationKind.approval,
        channel: TurnNotificationService.attentionChannel,
      ),
    );
    expect(approval.android!.channelId, 'hermes_attention');
    expect(approval.android!.sound, isNull);
    expect(approval.android!.playSound, isTrue);
    expect(approval.iOS!.sound, isNull);
    expect(approval.iOS!.presentSound, isTrue);
    expect(approval.linux!.sound, isNull);

    notificationPrefs.value = NotificationPrefs.defaults.copyWith(
      completionSound: WindowsCompletionSound.silent,
    );
    final quiet = turnNotificationDetails(
      _notice(kind: HermesNotificationKind.turnDone),
    );
    expect(quiet.android!.channelId, 'hermes_turn_notifications_silent');
    expect(quiet.android!.playSound, isFalse);
    expect(quiet.android!.enableVibration, isFalse);
    expect(quiet.iOS!.presentAlert, isTrue);
    expect(quiet.iOS!.presentSound, isFalse);
    expect(quiet.linux!.suppressSound, isTrue);

    final ongoing = turnNotificationDetails(
      _notice(
        silent: true,
        onlyAlertOnce: true,
        ongoing: true,
        channel: TurnNotificationService.ongoingChannel,
      ),
    );
    expect(ongoing.android!.channelId, 'hermes_ongoing_chats');
    expect(ongoing.android!.playSound, isFalse);
    expect(ongoing.android!.enableVibration, isFalse);
    expect(ongoing.android!.silent, isTrue);
  });

  test('Android posts the selected raw completion tone', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    const channel = MethodChannel('dexterous.com/flutter/local_notifications');
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return true;
    });
    addTearDown(() {
      messenger.setMockMethodCallHandler(channel, null);
      debugDefaultTargetPlatformOverride = null;
    });
    notificationPrefs.value = NotificationPrefs.defaults.copyWith(
      completionSound: WindowsCompletionSound.reminder,
    );
    await PluginTurnNotificationSink().show(
      _notice(kind: HermesNotificationKind.turnDone),
    );
    final args =
        calls.singleWhere((call) => call.method == 'show').arguments as Map;
    final android = args['platformSpecifics'] as Map;
    expect(android['channelId'], 'hermes_turn_notifications_reminder');
    expect(android['sound'], 'ares_reminder');
    expect(android['playSound'], isTrue);
  });

  testWidgets('settings offer activity sharing and a system sound', (t) async {
    SharedPreferences.setMockInitialValues({});
    notificationPrefs.value = NotificationPrefs.defaults;
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: CompletionSoundSettings(prefs: NotificationPrefs.defaults),
        ),
      ),
    );
    expect(find.text('Share chat activity'), findsOneWidget);
    expect(find.text('System default'), findsOneWidget);
    expect(find.text('Completion sound'), findsOneWidget);
    expect(find.text('Windows default'), findsNothing);
  });
}
