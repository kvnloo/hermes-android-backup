import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/shortcuts_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  test('chord serialization round-trips', () {
    const chord = KeyChord(
      key: LogicalKeyboardKey.keyK,
      meta: true,
      shift: true,
    );
    final serialized = chord.serialize();
    expect(serialized, 'meta+shift+keyK');
    expect(KeyChord.parse(serialized), chord);
  });

  test('parse rejects invalid values', () {
    for (final raw in [
      null,
      '',
      'meta',                  // no key
      'meta+ctrl+keyK+keyN',   // two keys
      'meta+nonexistent',      // unknown key
      'weird+keyK',            // unknown modifier + unknown key
    ]) {
      expect(KeyChord.parse(raw), isNull, reason: '$raw');
    }
  });

  test('default chords parse and are distinct', () {
    final chords = <String>{};
    for (final action in ShortcutRegistry.actions) {
      final chord = ShortcutRegistry.defaultChord(action);
      expect(chord.keyName, isNotEmpty);
      expect(chords.add(chord.serialize()), isTrue);
    }
  });

  test('store reads defaults when nothing is persisted', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = ShortcutsStore(prefs);
    for (final action in ShortcutRegistry.actions) {
      expect(store.chordFor(action), ShortcutRegistry.defaultChord(action));
    }
  });

  test('store round-trips a rebound chord and ignores invalid persisted values',
      () async {
    final prefs = await SharedPreferences.getInstance();
    final store = ShortcutsStore(prefs);
    await store.setChord(
      ShortcutAction.commandPalette,
      const KeyChord(key: LogicalKeyboardKey.keyP, meta: true),
    );
    expect(
      store.chordFor(ShortcutAction.commandPalette),
      const KeyChord(key: LogicalKeyboardKey.keyP, meta: true),
    );

    // Invalid persisted value falls back to the default.
    await prefs.setString(ShortcutsStore.preferenceKey, 'not-json');
    expect(
      store.chordFor(ShortcutAction.commandPalette),
      ShortcutRegistry.defaultChord(ShortcutAction.commandPalette),
    );
  });

  test('resetToDefaults removes the persisted map', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = ShortcutsStore(prefs);
    await store.setChord(
      ShortcutAction.settings,
      const KeyChord(key: LogicalKeyboardKey.keyH, meta: true),
    );
    expect(prefs.getString(ShortcutsStore.preferenceKey), isNotNull);
    await store.resetToDefaults();
    expect(prefs.getString(ShortcutsStore.preferenceKey), isNull);
    expect(
      store.chordFor(ShortcutAction.settings),
      ShortcutRegistry.defaultChord(ShortcutAction.settings),
    );
  });

  test('conflicts report shared chords between actions', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = ShortcutsStore(prefs);
    await store.setChord(
      ShortcutAction.newChat,
      const KeyChord(key: LogicalKeyboardKey.keyK, meta: true),
    );
    final conflicts = store.conflicts();
    expect(conflicts, isNotEmpty);
    final entry = conflicts.first;
    expect(entry[2], 'meta+keyK');
    expect({entry[0], entry[1]}, {ShortcutAction.newChat, ShortcutAction.commandPalette});
  });
}
