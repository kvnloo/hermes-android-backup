// Desktop OS strings are localised (review of 8d733edd, PROBE-7) and a
// shortcut bound to a text-editing combination is flagged.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/shortcuts_store.dart';
import 'package:hermes_android/core/widgets/command_palette.dart';
import 'package:hermes_android/core/widgets/keep_awake_settings_card.dart';
import 'package:hermes_android/core/widgets/keyboard_shortcuts_settings_card.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _noop(PaletteAction _) {}

Widget _app(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const power = MethodChannel('com.hermesagent.ares/power');

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(power, (call) async => true);
  });
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(power, null),
  );

  testWidgets(
    'German shows no English desktop OS strings (PROBE-7)',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        _app(
          Column(
            children: [
              KeepAwakeSettingsCard(preferences: prefs),
              KeyboardShortcutsSettingsCard(preferences: prefs),
              const SizedBox(
                height: 500,
                child: CommandPalette(actions: [], onSelected: _noop),
              ),
            ],
          ),
          locale: const Locale('de'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('keep-awake-settings-card')), findsOneWidget);
      final english = [
        'Keep computer awake',
        'While working',
        'Keyboard shortcuts',
        'Command palette',
        'Go to tab 1',
        'No matching actions',
        'Esc to close',
        'Reset to default',
      ].where((s) => find.text(s).evaluate().isNotEmpty).toList();
      expect(english, isEmpty);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.linux),
  );

  test('every desktop OS key is translated in every locale', () {
    final dir = Directory('lib/l10n');
    final en =
        jsonDecode(File('${dir.path}/app_en.arb').readAsStringSync())
            as Map<String, dynamic>;
    final keys = en.keys
        .where(
          (k) =>
              k.startsWith('palette_') ||
              k.startsWith('shortcut') ||
              k.startsWith('keep_awake_') ||
              k.startsWith('deployment_token_') ||
              k.startsWith('custom_headers_') ||
              k == 'keyboard_shortcuts_title' ||
              k == 'deeplink_chat_not_found',
        )
        .toList();
    expect(keys.length, greaterThan(45));
    for (final file in dir.listSync().whereType<File>()) {
      if (!file.path.endsWith('.arb') || file.path.endsWith('app_en.arb')) {
        continue;
      }
      final other = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      for (final key in keys) {
        expect(other[key], isA<String>(), reason: '${file.path} $key');
      }
    }
  });

  testWidgets('a custom shortcut on Ctrl+C is flagged in the card and the '
      'editor warns before saving', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await ShortcutsStore(prefs).setChord(
      ShortcutAction.search,
      const KeyChord(key: LogicalKeyboardKey.keyC, ctrl: true),
    );
    await tester.pumpWidget(
      _app(KeyboardShortcutsSettingsCard(preferences: prefs)),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('shortcuts-text-editing-warning')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('shortcut-rebind-newChat')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chord-text-editing-warning')), findsNothing);
    await tester.tap(find.byKey(const Key('chord-key-keyV')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chord-text-editing-warning')), findsOneWidget);
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));
}
