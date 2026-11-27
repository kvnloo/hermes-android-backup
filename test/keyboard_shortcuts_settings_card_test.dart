import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hermes_android/core/services/shortcuts_store.dart'
    as shortcuts_store;
import 'package:hermes_android/core/widgets/keyboard_shortcuts_settings_card.dart';

// The card only exists where the bindings fire (the desktop runners).
final _desktop = TargetPlatformVariant.only(TargetPlatform.linux);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  testWidgets('renders every action with its label and chord', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: KeyboardShortcutsSettingsCard(preferences: prefs),
          ),
        ),
      ),
    );
    for (final action in shortcuts_store.ShortcutRegistry.actions) {
      expect(
        find.text(shortcuts_store.ShortcutRegistry.label(action)),
        findsOneWidget,
      );
    }
    expect(find.text('Cmd/Ctrl + K'), findsWidgets);
    expect(
      find.byKey(const Key('keyboard-shortcuts-settings-card')),
      findsOneWidget,
    );
  }, variant: _desktop);

  testWidgets('rebinding a chord writes the store', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: KeyboardShortcutsSettingsCard(preferences: prefs),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('shortcut-rebind-commandPalette')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('chord-key-keyP')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('chord-save-button')));
    await tester.pumpAndSettle();

    final chord = shortcuts_store.ShortcutsStore(
      prefs,
    ).chordFor(shortcuts_store.ShortcutAction.commandPalette);
    expect(chord.keyName, 'keyP');
    expect(chord.meta, isTrue);
  }, variant: _desktop);

  testWidgets('conflict banner appears when two actions share a chord', (
    tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final store = shortcuts_store.ShortcutsStore(prefs);
    await store.setChord(
      shortcuts_store.ShortcutAction.newChat,
      const shortcuts_store.KeyChord(key: LogicalKeyboardKey.keyK, meta: true),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: KeyboardShortcutsSettingsCard(preferences: prefs),
          ),
        ),
      ),
    );
    expect(find.byKey(const Key('shortcuts-conflict-banner')), findsOneWidget);
    expect(find.textContaining('Conflict:'), findsOneWidget);
  }, variant: _desktop);

  testWidgets('reset-all clears stored bindings', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final store = shortcuts_store.ShortcutsStore(prefs);
    await store.setChord(
      shortcuts_store.ShortcutAction.search,
      const shortcuts_store.KeyChord(
        key: LogicalKeyboardKey.keyS,
        meta: true,
        shift: true,
      ),
    );
    expect(store.readMap(), isNotEmpty);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: KeyboardShortcutsSettingsCard(preferences: prefs),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('shortcuts-reset-all')));
    await tester.pumpAndSettle();
    expect(store.readMap(), isEmpty);
  }, variant: _desktop);
}
