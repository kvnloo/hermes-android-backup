// hermes:// links reach the app on every platform (review of 8d733edd,
// blocker 2 / PROBE-3): each runner registers the scheme and implements
// com.hermesagent.ares/deeplink (getInitialLink for a cold launch, onDeepLink
// for a warm one), and the Dart service routes both through the validated
// parser. Native code is compile-checked separately (tool/native_tests).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hermes_deeplink.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/utils/home_turn_signals.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _read(String path) => File(path).readAsStringSync();

const _channelName = 'com.hermesagent.ares/deeplink';

/// Delivers [link] the way a runner does for a warm launch.
Future<void> _warmLink(String link) async {
  const codec = StandardMethodCodec();
  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .handlePlatformMessage(
        _channelName,
        codec.encodeMethodCall(MethodCall('onDeepLink', link)),
        (_) {},
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('every runner registers hermes:// and implements the channels', () {
    test('Android: VIEW intent filter, built-in route push off, channel', () {
      final manifest = _read('android/app/src/main/AndroidManifest.xml');
      expect(manifest, contains('android:scheme="hermes"'));
      expect(manifest, contains('android.intent.category.BROWSABLE'));
      expect(
        manifest,
        matches(
          RegExp(
            r'flutter_deeplinking_enabled"\s*android:value="false"',
            multiLine: true,
          ),
        ),
      );
      final activity = _read(
        'android/app/src/main/kotlin/com/hermesagent/hermes_android/'
        'MainActivity.kt',
      );
      expect(activity, contains('"$_channelName"'));
      expect(activity, contains('"getInitialLink"'));
      expect(activity, contains('"onDeepLink"'));
      expect(activity, contains('override fun onNewIntent'));
      expect(activity, contains('"com.hermesagent.ares/power"'));
    });

    test('iOS and macOS: CFBundleURLSchemes, shared inbox, both events', () {
      for (final plist in [
        'ios/Runner/Info.plist',
        'macos/Runner/Info.plist',
      ]) {
        final text = _read(plist);
        expect(text, contains('<key>CFBundleURLSchemes</key>'), reason: plist);
        expect(
          RegExp(
            r'<key>CFBundleURLSchemes</key>\s*<array>\s*<string>hermes</string>',
          ).hasMatch(text),
          isTrue,
          reason: plist,
        );
      }
      expect(
        _read('ios/Runner/Info.plist'),
        matches(RegExp(r'<key>FlutterDeepLinkingEnabled</key>\s*<false/>')),
      );
      final shared = _read('apple/AresApple.swift');
      expect(shared, contains('"$_channelName"'));
      expect(shared, contains('"getInitialLink"'));
      expect(shared, contains('"onDeepLink"'));
      final scene = _read('ios/Runner/SceneDelegate.swift');
      expect(scene, contains('connectionOptions.urlContexts')); // cold
      expect(scene, contains('openURLContexts')); // warm
      expect(scene, contains('"com.hermesagent.ares/power"'));
      final appDelegate = _read('macos/Runner/AppDelegate.swift');
      expect(appDelegate, contains('open urls: [URL]'));
      expect(appDelegate, contains('AresProcessRole.isChild'));
    });

    test('Windows: Inno + MSIX protocol, primary-window routing only', () {
      final iss = _read('windows/installer/ares.iss');
      expect(iss, contains(r'Software\Classes\hermes"'));
      expect(iss, contains(r'Software\Classes\hermes\shell\open\command'));
      final msix = RegExp(
        r'protocol_activation:\s*(.+)',
      ).firstMatch(_read('pubspec.yaml'))!.group(1)!;
      expect(msix.split(',').map((p) => p.trim()), contains('hermes'));
      final window = _read('windows/runner/flutter_window.cpp');
      expect(window, contains('"$_channelName"'));
      expect(window, contains('"getInitialLink"'));
      expect(window, contains('"onDeepLink"'));
      final main = _read('windows/runner/main.cpp');
      // The forward goes to the primary window class over the existing
      // single-instance path; no second activator or COM server.
      expect(main, contains('ares::deep_link::kCopyDataId'));
      expect(main, contains('FindWindowW(Win32Window::WindowClassName()'));
      expect(main, isNot(contains('CoRegisterClassObject')));
      expect(
        _read('windows/runner/launch_role.h'),
        contains('LaunchRole::deep_link'),
      );
    });

    test('Linux: desktop file scheme handler, unique primary, channel', () {
      final desktop = _read('linux/packaging/com.hermesagent.ares.desktop');
      expect(desktop, contains('MimeType=x-scheme-handler/hermes;'));
      expect(desktop, contains('Exec=ares %u'));
      expect(
        _read('linux/CMakeLists.txt'),
        contains(r'packaging/${APPLICATION_ID}.desktop'),
      );
      final app = _read('linux/runner/my_application.cc');
      expect(app, contains('"$_channelName"'));
      expect(app, contains('"getInitialLink"'));
      expect(app, contains('"onDeepLink"'));
      expect(app, contains('G_APPLICATION_HANDLES_OPEN'));
      expect(app, contains('->open = my_application_open'));
      expect(
        _read('linux/runner/desktop_os.cc'),
        contains('"com.hermesagent.ares/power"'),
      );
    });
  });

  group('HermesDeepLinkService over a fake runner channel', () {
    late HermesDeepLinkService service;
    String? initial;

    setUp(() {
      initial = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            HermesDeepLinkService.defaultChannel,
            (call) async => call.method == 'getInitialLink' ? initial : null,
          );
      service = HermesDeepLinkService();
    });

    tearDown(() {
      service.dispose();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(HermesDeepLinkService.defaultChannel, null);
    });

    test('cold: the runner\'s initial link is published once', () async {
      initial = 'hermes://session/s-cold?prefill=From+the+link';
      await service.initialize();
      final link = service.takePendingLink()!;
      expect(link.kind, HermesDeepLinkKind.session);
      expect(link.sessionId, 's-cold');
      expect(link.prefill, 'From the link');
      expect(service.pendingLink.value, isNull);
    });

    test(
      'warm: onDeepLink from the runner is validated and published',
      () async {
        await service.initialize();
        expect(service.pendingLink.value, isNull);
        await _warmLink('hermes://open/chat?prefill=hi');
        expect(service.pendingLink.value?.kind, HermesDeepLinkKind.open);
        expect(service.pendingLink.value?.prefill, 'hi');
        service.takePendingLink();
        // A malformed or foreign link from the runner is dropped.
        await _warmLink('https://evil.example/session/abc');
        await _warmLink('hermes://approve/abc');
        expect(service.pendingLink.value, isNull);
      },
    );
  });

  group('warm link into a running Classic shell', () {
    late HermesDeepLinkService previous;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      HermesSignInVault.resetForTesting(MemorySignInSecretStore());
      PackageInfo.setMockInitialValues(
        appName: 'Ares',
        packageName: 'com.hermesagent.hermes_android',
        version: '5.0.0-test',
        buildNumber: '5000',
        buildSignature: '',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        ..setMockMethodCallHandler(
          const MethodChannel('flutter_tts'),
          (_) async => <Object>[],
        )
        ..setMockMethodCallHandler(
          HermesDeepLinkService.defaultChannel,
          (call) async => null,
        );
      previous = HermesDeepLinkService.shared;
      HermesDeepLinkService.shared = HermesDeepLinkService();
    });

    tearDown(() {
      // Not disposed: the unmounted shell may still detach its listener.
      HermesDeepLinkService.shared = previous;
      HermesSignInVault.resetForTesting();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(HermesDeepLinkService.defaultChannel, null);
    });

    testWidgets('opens the chat with the prefill in its composer and sends '
        'nothing', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final posts = <String>[];
      await HermesDeepLinkService.shared.initialize();
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: WorkspaceScreen(
            connection: SavedConnection(
              id: 'classic-warm',
              label: 'Classic Phone',
              host: 'offline.test',
              port: 8642,
              apiKey: 'fixture',
            ),
            sessionsLoader: () async => [
              Session(
                id: 's-warm',
                title: 'Warm Chat',
                source: 'desktop',
                model: 'gpt-test',
                messageCount: 2,
                isActive: false,
                preview: 'hello',
                startedAt: 1700000000,
                lastActive: 1700000100,
                endedAt: null,
              ),
            ],
            turnSignalsLoader: (_) async => HomeTurnSignals.empty,
            testChatApiClientFactory: () => ApiClient(
              baseUrl: 'http://offline.test:8642',
              apiKey: 'fixture',
              httpClient: MockClient((req) async {
                if (req.method == 'POST') posts.add(req.url.path);
                return http.Response(
                  jsonEncode(
                    req.url.path.contains('/sessions/')
                        ? {
                            'session': {'id': 's-warm', 'title': 'Warm Chat'},
                            'messages': <Object>[],
                          }
                        : {'sessions': <Object>[], 'has_more': false},
                  ),
                  200,
                  headers: {'content-type': 'application/json'},
                );
              }),
            ),
            testDashboardHttpClient: MockClient(
              (_) async => http.Response(
                jsonEncode({'sessions': <Object>[], 'total': 0}),
                200,
                headers: {'content-type': 'application/json'},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsNothing);

      await _warmLink('hermes://session/s-warm?prefill=Check+the+logs');
      await tester.pumpAndSettle();

      expect(find.byType(ChatScreen), findsOneWidget);
      final composer = tester.widget<TextField>(
        find.byKey(const Key('chat-message-composer')),
      );
      expect(composer.controller?.text, 'Check the logs');
      expect(posts, isEmpty, reason: 'a link never sends');
    });
  });
}
