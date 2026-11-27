import 'support/settings_navigation.dart';
import 'package:hermes_android/core/widgets/theme_palette_picker.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/settings_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/main.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Ares',
      packageName: 'com.hermesagent.hermes_android',
      version: '4.0.0-rc.6',
      buildNumber: '3042',
      buildSignature: '',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_tts'),
          (_) async => <Object>[],
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), null);
  });

  testWidgets(
    'Classic categories contain live Classic controls and shared appearance',
    (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(HermesApp(connManager: ConnectionManager(prefs)));
      await tester.pumpAndSettle();
      unawaited(
        Navigator.of(tester.element(find.byType(HomeScreen))).push<void>(
          MaterialPageRoute(
            builder: (_) => SettingsScreen(
              connection: SavedConnection(
                id: 'classic-labels',
                label: 'Offline',
                host: 'offline.test',
                port: 8642,
                apiKey: 'test-only',
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
      expect(find.text('Classic Settings'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('settings-control-ng.theme')),
        findsNothing,
      );
      await openSettingsCategory(tester, 'appearance');
      expect(find.byType(ThemeAppearanceSettings), findsOneWidget);
      expect(
        find.byKey(const ValueKey('settings-control-text-size')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('settings-control-classic.chat.density')),
        findsNothing,
      );
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await openSettingsCategory(tester, 'chat');
      expect(
        find.byKey(const ValueKey('settings-control-classic.chat.density')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('settings-control-classic.session.sources')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('ng-reopen-chat')), findsNothing);
      expect(prefs.getBool('nextgen_enabled'), isNot(true));
      expect(tester.takeException(), isNull);
    },
  );
}
