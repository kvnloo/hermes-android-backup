import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/settings_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/support/settings_navigation.dart';

void main() {
  test('this suite runs as a Play build', () {
    // This opt-in suite intentionally lives outside test/ so the ordinary
    // suite runs it only with ARES_PLAY_BUILD=true.
    expect(const bool.fromEnvironment('ARES_PLAY_BUILD'), isTrue);
  });

  testWidgets(
    'Play Settings have no update controls and keep the privacy link',
    (tester) async {
      // This opt-in suite intentionally lives outside test/ so the ordinary
      // suite runs it only with ARES_PLAY_BUILD=true.
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(HermesApp(connManager: ConnectionManager(prefs)));
      await tester.pumpAndSettle();
      unawaited(
        Navigator.of(tester.element(find.byType(HomeScreen))).push(
          MaterialPageRoute<void>(
            builder: (_) => SettingsScreen(
              connection: SavedConnection(
                id: 'play',
                label: 'Play',
                host: '127.0.0.1',
                port: 8642,
                dashboardPortOverride: 1,
                apiKey: '',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await openSettingsCategory(tester, 'about');
      await tester.scrollUntilVisible(
        find.text('Privacy policy'),
        300,
        scrollable: find
            .descendant(
              of: find.byType(SettingsScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Privacy policy'), findsOneWidget);
      expect(find.text('Check for updates'), findsNothing);
      expect(find.text('Check for updates on launch'), findsNothing);
    },
  );
}
