import 'support/settings_navigation.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/settings_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/locale_preference.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/main.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/settings_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Phone widths and text scales the notification settings must fit without
/// a layout exception, in both layouts (review blocker: a trailing sound menu
/// consumed the whole tile at 320 px with 1.3x text and 360 px with 1.5x).
const _matrix = <(double, double, String)>[
  (320, 1.0, 'en'),
  (320, 1.3, 'en'),
  (360, 1.3, 'en'),
  (360, 1.5, 'en'),
  (412, 1.3, 'en'),
  (360, 1.3, 'de'),
];

void _size(WidgetTester tester, double width, double scale) {
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

/// Opens the sound sheet from the tile, checks it fits too, picks Mail and
/// mutes app sounds.
Future<void> _pickMail(WidgetTester tester, String context) async {
  final tile = find.byKey(const ValueKey('completion-sound'));
  await tester.ensureVisible(tile);
  await tester.pumpAndSettle();
  await tester.tap(tile);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull, reason: '$context sheet');
  final mail = find.byKey(const ValueKey('completion-sound-mail'));
  await tester.ensureVisible(mail);
  await tester.tap(mail);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull, reason: '$context after pick');
  expect(notificationPrefs.value.completionSound, WindowsCompletionSound.mail);
  expect(find.byKey(const ValueKey('completion-sound-mail')), findsNothing);
  // The in-app sound mute sits with the choice in both layouts.
  final mute = find.byKey(const ValueKey('mute-app-sounds'));
  await tester.ensureVisible(mute);
  await tester.pumpAndSettle();
  await tester.tap(mute);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull, reason: '$context mute');
  expect(notificationPrefs.value.muteAppSounds, isTrue);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    notificationPrefs.value = NotificationPrefs.defaults;
    PackageInfo.setMockInitialValues(
      appName: 'Ares',
      packageName: 'com.hermesagent.hermes_android',
      version: '5.0.0',
      buildNumber: '5000',
      buildSignature: '',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_tts'),
          (_) async => <Object>[],
        );
  });

  tearDown(() {
    notificationPrefs.value = NotificationPrefs.defaults;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), null);
  });

  for (final (width, scale, locale) in _matrix) {
    final name = '${width.toInt()} px at ${scale}x ($locale)';

    testWidgets('NextGen notification settings fit $name', (tester) async {
      SharedPreferences.setMockInitialValues({});
      _size(tester, width, scale);
      Widget app(Locale locale) => MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: nextGenTheme(Brightness.light, NextGenLook.instance),
        builder: (_, child) => NgLocalizationScope(child: child!),
        home: const Scaffold(
          body: SingleChildScrollView(child: NgNotificationSettings()),
        ),
      );
      // Leave the shared NextGen strings in English for later tests.
      addTearDown(() => tester.pumpWidget(app(const Locale('en'))));
      await tester.pumpWidget(app(Locale(locale)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: name);
      expect(find.byKey(const ValueKey('completion-sound')), findsOneWidget);
      await _pickMail(tester, name);
    });

    testWidgets('Classic notification settings fit $name', (tester) async {
      SharedPreferences.setMockInitialValues({
        if (locale != 'en') LocalePreference.key: locale,
      });
      _size(tester, width, scale);
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(HermesApp(connManager: ConnectionManager(prefs)));
      await tester.pumpAndSettle();
      unawaited(
        Navigator.of(tester.element(find.byType(HomeScreen))).push<void>(
          MaterialPageRoute(
            builder: (_) => SettingsScreen(
              connection: SavedConnection(
                id: 'narrow-settings',
                label: 'Offline',
                host: 'offline.test',
                port: 8642,
                apiKey: 'fixture-only',
              ),
              dashboardClient: DashboardClient(
                host: 'offline.test',
                port: 9119,
                httpClient: MockClient(
                  (_) async => http.Response('offline', 503),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await openSettingsCategory(tester, 'notifications');
      final tile = find.byKey(const ValueKey('completion-sound'));
      final scroll = find
          .descendant(
            of: find.byType(SettingsScreen),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        tile,
        100,
        scrollable: scroll,
        maxScrolls: 200,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: name);
      expect(tile, findsOneWidget);
      await _pickMail(tester, name);
    });
  }
}
