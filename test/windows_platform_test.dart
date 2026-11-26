import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/utils/platform_capabilities.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('Android-only features and notifications are off on Windows', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    expect(isWindowsPlatform, isTrue);
    expect(isApplePlatform, isFalse);
    expect(supportsAndroidBackgroundWork, isFalse);
    expect(supportsEmbeddedMobilePush, isFalse);
    expect(supportsHandsFreeWakeService, isFalse);
    expect(supportsLocalNotifications, isFalse);
  });

  test('other platforms keep notifications', () {
    for (final platform in [
      TargetPlatform.android,
      TargetPlatform.iOS,
      TargetPlatform.macOS,
    ]) {
      debugDefaultTargetPlatformOverride = platform;
      expect(isWindowsPlatform, isFalse);
      expect(supportsLocalNotifications, isTrue);
      expect(defaultTurnNotificationSink(), isA<PluginTurnNotificationSink>());
    }
  });

  test('Windows never reaches the notification plugin', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    final sink = defaultTurnNotificationSink();
    expect(sink, isA<SilentTurnNotificationSink>());

    await sink.initialize();
    expect(await sink.checkPermission(), isNull);
    expect(await sink.requestPermission(), isNull);
    expect(await sink.takeInitialLaunchResponse(), isNull);
    await sink.show(
      const TurnNotification(
        id: 1,
        title: 'Done',
        body: 'Finished',
        payload: '{}',
        channel: TurnNotificationChannel(
          id: 'test',
          name: 'Test',
          description: 'Test channel',
        ),
      ),
    );
    await sink.cancel(1);
    await sink.cancelAll();
  });
}
