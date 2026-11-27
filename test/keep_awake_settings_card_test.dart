// The Keep awake card exists only where the runner keeps the device awake
// (review of 8d733edd, blocker 3): it asks com.hermesagent.ares/power
// isSupported and renders nothing, header included, until the runner says so.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/keep_awake.dart';
import 'package:hermes_android/core/widgets/keep_awake_settings_card.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestDefaultBinaryMessenger messenger;
  const power = MethodChannel('com.hermesagent.ares/power');

  void runner({required bool supported}) {
    messenger.setMockMethodCallHandler(
      power,
      (call) async => call.method == 'isSupported' ? supported : null,
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  });

  tearDown(() => messenger.setMockMethodCallHandler(power, null));

  Future<void> pumpCard(WidgetTester tester, {Locale? locale}) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: KeepAwakeSettingsCard(
            preferences: prefs,
            header: const Text('section-header'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'a supported runner shows the three modes, default off',
    (tester) async {
      runner(supported: true);
      await pumpCard(tester);
      expect(find.text('section-header'), findsOneWidget);
      expect(find.text('Keep computer awake'), findsOneWidget);
      for (final mode in KeepAwakeMode.values) {
        expect(find.byKey(Key('keep-awake-mode-${mode.name}')), findsOneWidget);
      }
      final offChip = tester.widget<ChoiceChip>(
        find.byKey(const Key('keep-awake-mode-off')),
      );
      expect(offChip.selected, isTrue);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.windows),
  );

  testWidgets('selecting a mode writes the policy store', (tester) async {
    runner(supported: true);
    await pumpCard(tester);
    await tester.tap(find.byKey(const Key('keep-awake-mode-always')));
    await tester.pumpAndSettle();
    final prefs = await SharedPreferences.getInstance();
    expect(KeepAwakePolicyStore(prefs).read(), KeepAwakeMode.always);
  });

  testWidgets('an unsupported runner hides the card and its header', (
    tester,
  ) async {
    runner(supported: false);
    await pumpCard(tester);
    expect(find.byKey(const Key('keep-awake-settings-card')), findsNothing);
    expect(find.text('section-header'), findsNothing);
  });

  testWidgets('a runner without the channel (web, old runner) hides it', (
    tester,
  ) async {
    // No mock handler: MissingPluginException.
    await pumpCard(tester);
    expect(find.byKey(const Key('keep-awake-settings-card')), findsNothing);
  });

  testWidgets('phones and tablets say what actually happens: the screen stays '
      'on', (tester) async {
    runner(supported: true);
    await pumpCard(tester);
    expect(find.text('Keep screen on'), findsOneWidget);
    expect(find.text('Keep computer awake'), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets(
    'the card is localised',
    (tester) async {
      runner(supported: true);
      await pumpCard(tester, locale: const Locale('de'));
      final de = lookupAppLocalizations(const Locale('de'));
      expect(find.text(de.keep_awake_title), findsOneWidget);
      expect(find.text(de.keep_awake_mode_while_working), findsOneWidget);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.linux),
  );
}
