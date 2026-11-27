/// Platform capability reporting for features that only exist on Android.
///
/// Apple builds keep the shared chat/gateway code but must not offer Android
/// foreground services, battery-optimisation prompts, or the
/// embedded Android push bridge. Nothing here changes Android behaviour.
library;

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;

/// True when the app is running on iOS or macOS.
bool get isApplePlatform =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.macOS;

/// True when the app is running on Windows.
bool get isWindowsPlatform => defaultTargetPlatform == TargetPlatform.windows;

/// Windows implements local toasts in the runner rather than FLN v18.
bool get supportsLocalNotifications => true;

/// Android foreground service / battery-optimisation background work.
bool get supportsAndroidBackgroundWork =>
    defaultTargetPlatform == TargetPlatform.android;

/// Embedded FCM / companion push app is an Android-only transport.
bool get supportsEmbeddedMobilePush =>
    defaultTargetPlatform == TargetPlatform.android;

/// The Android hands-free wake word service. Voice replies themselves use
/// flutter_tts and work on every platform.
bool get supportsHandsFreeWakeService =>
    defaultTargetPlatform == TargetPlatform.android;
