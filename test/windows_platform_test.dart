import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/utils/platform_capabilities.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test(
    'Android-only features are off but local notifications work on Windows',
    () {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      expect(isWindowsPlatform, isTrue);
      expect(isApplePlatform, isFalse);
      expect(supportsAndroidBackgroundWork, isFalse);
      expect(supportsEmbeddedMobilePush, isFalse);
      expect(supportsHandsFreeWakeService, isFalse);
      expect(supportsLocalNotifications, isTrue);
    },
  );

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

  test('Windows routes to the native sink, not the FLN plugin', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    expect(defaultTurnNotificationSink(), isA<WindowsToastSink>());
  });
}
