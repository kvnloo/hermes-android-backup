import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/parked_automotive.dart';
import 'package:hermes_android/core/settings/settings_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'support/settings_fixture.dart';

void main() {
  for (final mode in SettingsMode.values) {
    testWidgets(
      '${mode.name} respects native and parked capabilities',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        SettingsFixture.platforms();
        final fixture = SettingsFixture(await SharedPreferences.getInstance());
        addTearDown(fixture.dispose);
        await tester.pumpWidget(fixture.app(mode));
        await tester.pumpAndSettle();
        final browser = tester.widget<SettingsBrowser>(
          find.byType(SettingsBrowser),
        );
        final ids = browser.items
            .where((e) => e.visibleIn(mode))
            .map((e) => e.id)
            .toSet();
        final android = defaultTargetPlatform == TargetPlatform.android;
        final desktop = {
          TargetPlatform.linux,
          TargetPlatform.macOS,
          TargetPlatform.windows,
        }.contains(defaultTargetPlatform);
        expect(
          ids.contains('notifications.push'),
          android && !isParkedAutomotive,
        );
        expect(ids.contains('background'), android);
        expect(ids.contains('voice.reply'), !isParkedAutomotive);
        expect(ids.contains('voice.gateway'), !isParkedAutomotive);
        expect(ids.contains('notifications'), !isParkedAutomotive);
        expect(ids.contains('desktop'), desktop);
        expect(ids.contains('shortcuts'), desktop);
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant({
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.linux,
        TargetPlatform.macOS,
        TargetPlatform.windows,
      }),
    );
  }
}
