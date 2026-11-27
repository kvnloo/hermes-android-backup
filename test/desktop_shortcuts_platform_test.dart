// Regressions from the review of 8d733edd: the in-app shortcuts must match
// what actually fires on each platform.
//
// PROBE-4: on Windows/Linux the automatic Ctrl twin of a default takes part
// in the conflict check, so rebinding the palette to Ctrl+N is reported and
// New chat keeps Ctrl+N.
// PROBE-10: Android and iOS have no shortcut bindings (DesktopShortcuts is a
// passthrough), so the Keyboard shortcuts card must not be offered there.
// PROBE-5: macOS gets no automatic Ctrl twins, so Ctrl+K in a text field stays
// Cocoa's delete-to-end-of-line instead of opening the palette.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/shortcuts_store.dart';
import 'package:hermes_android/core/widgets/desktop_shortcuts.dart';
import 'package:hermes_android/core/widgets/keyboard_shortcuts_settings_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<DesktopShortcut>> _press(
  WidgetTester tester,
  LogicalKeyboardKey modifier,
  LogicalKeyboardKey key,
) async {
  final fired = <DesktopShortcut>[];
  final sub = desktopShortcutBus.stream.listen(fired.add);
  await tester.sendKeyDownEvent(modifier);
  await tester.sendKeyEvent(key);
  await tester.sendKeyUpEvent(modifier);
  await tester.pump();
  unawaited(sub.cancel());
  return fired;
}

Future<TextEditingController> _pumpComposer(
  WidgetTester tester,
  ShortcutsStore store,
) async {
  final controller = TextEditingController(text: 'hello world');
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) =>
          DesktopShortcuts(forceEnabled: true, store: store, child: child!),
      home: Scaffold(body: TextField(controller: controller)),
    ),
  );
  await tester.tap(find.byType(TextField));
  await tester.pump();
  return controller;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  testWidgets(
    'macOS: Ctrl+K in a text field is not stolen by the palette; Cmd+K still '
    'opens it (PROBE-5)',
    (tester) async {
      final store = ShortcutsStore(await SharedPreferences.getInstance());
      await _pumpComposer(tester, store);
      expect(
        await _press(
          tester,
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.keyK,
        ),
        isEmpty,
      );
      expect(
        await _press(
          tester,
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.keyN,
        ),
        isEmpty,
      );
      expect(
        await _press(
          tester,
          LogicalKeyboardKey.metaLeft,
          LogicalKeyboardKey.keyK,
        ),
        [DesktopShortcut.commandPalette],
      );
    },
    variant: TargetPlatformVariant.only(TargetPlatform.macOS),
  );

  testWidgets(
    'Windows and Linux: the Ctrl twin of each default still fires',
    (tester) async {
      final store = ShortcutsStore(await SharedPreferences.getInstance());
      await _pumpComposer(tester, store);
      expect(
        await _press(
          tester,
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.keyK,
        ),
        [DesktopShortcut.commandPalette],
      );
      expect(
        await _press(
          tester,
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.keyN,
        ),
        [DesktopShortcut.newChat],
      );
    },
    variant: TargetPlatformVariant.only(TargetPlatform.windows),
  );

  test('Ctrl twins are a Windows/Linux/Android convention, never Apple', () {
    expect(shortcutsAddCtrlTwins(TargetPlatform.windows), isTrue);
    expect(shortcutsAddCtrlTwins(TargetPlatform.linux), isTrue);
    expect(shortcutsAddCtrlTwins(TargetPlatform.android), isTrue);
    expect(shortcutsAddCtrlTwins(TargetPlatform.macOS), isFalse);
    expect(shortcutsAddCtrlTwins(TargetPlatform.iOS), isFalse);
  });

  testWidgets(
    'Windows: Command palette on Ctrl+N conflicts with the Ctrl twin of New '
    'chat; New chat keeps Ctrl+N and the palette keeps its default (PROBE-4)',
    (tester) async {
      final store = ShortcutsStore(await SharedPreferences.getInstance());
      await store.setChord(
        ShortcutAction.commandPalette,
        const KeyChord(key: LogicalKeyboardKey.keyN, ctrl: true),
      );
      expect(store.conflicts(), [
        [ShortcutAction.commandPalette, ShortcutAction.newChat, 'ctrl+keyN'],
      ]);
      await _pumpComposer(tester, store);
      expect(
        await _press(
          tester,
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.keyN,
        ),
        [DesktopShortcut.newChat],
      );
      expect(
        await _press(
          tester,
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.keyK,
        ),
        [DesktopShortcut.commandPalette],
      );
    },
    variant: TargetPlatformVariant.only(TargetPlatform.windows),
  );

  testWidgets(
    'macOS: Ctrl+N for the palette is no conflict (no twins); Cmd+N stays New '
    'chat',
    (tester) async {
      final store = ShortcutsStore(await SharedPreferences.getInstance());
      await store.setChord(
        ShortcutAction.commandPalette,
        const KeyChord(key: LogicalKeyboardKey.keyN, ctrl: true),
      );
      expect(store.conflicts(), isEmpty);
      await _pumpComposer(tester, store);
      expect(
        await _press(
          tester,
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.keyN,
        ),
        [DesktopShortcut.commandPalette],
      );
      expect(
        await _press(
          tester,
          LogicalKeyboardKey.metaLeft,
          LogicalKeyboardKey.keyN,
        ),
        [DesktopShortcut.newChat],
      );
    },
    variant: TargetPlatformVariant.only(TargetPlatform.macOS),
  );

  test('a revert that frees a default twin exposes the next collision', () {
    // Palette → Ctrl+N collides with New chat's twin, so the palette reverts
    // to Cmd+K and its twin Ctrl+K, which Settings → Ctrl+K now collides with.
    final plan = ShortcutPlan.resolve({
      'commandPalette': 'ctrl+keyN',
      'settings': 'ctrl+keyK',
    }, TargetPlatform.linux);
    expect(plan.reverted, {
      ShortcutAction.commandPalette,
      ShortcutAction.settings,
    });
    expect(
      plan.conflicts.map((c) => c.chord.serialize()),
      containsAll(['ctrl+keyN', 'ctrl+keyK']),
    );
    final firing = plan.firing.map((k, v) => MapEntry(k.serialize(), v));
    expect(firing['ctrl+keyN'], ShortcutAction.newChat);
    expect(firing['ctrl+keyK'], ShortcutAction.commandPalette);
    expect(firing['ctrl+comma'], ShortcutAction.settings);
    // Every chord fires exactly one action.
    expect(
      plan.bindings.map((b) => b.chord.serialize()).toSet(),
      hasLength(plan.bindings.length),
    );
  });

  test('swapping two Ctrl chords is not a conflict', () {
    final plan = ShortcutPlan.resolve({
      'commandPalette': 'ctrl+keyN',
      'newChat': 'ctrl+keyK',
    }, TargetPlatform.windows);
    expect(plan.conflicts, isEmpty);
    final firing = plan.firing.map((k, v) => MapEntry(k.serialize(), v));
    expect(firing['ctrl+keyN'], ShortcutAction.commandPalette);
    expect(firing['ctrl+keyK'], ShortcutAction.newChat);
  });

  test('the hidden search alias yields without a conflict', () {
    final plan = ShortcutPlan.resolve({
      'settings': 'ctrl+shift+keyF',
    }, TargetPlatform.windows);
    expect(plan.conflicts, isEmpty);
    expect(
      plan.firing.map((k, v) => MapEntry(k.serialize(), v))['ctrl+shift+keyF'],
      ShortcutAction.settings,
    );
  });

  test('text-editing chords are recognised', () {
    for (final raw in [
      'meta+keyC',
      'ctrl+keyV',
      'ctrl+keyX',
      'meta+shift+keyZ',
      'ctrl+keyA',
      'ctrl+keyY',
    ]) {
      expect(isTextEditingChord(KeyChord.parse(raw)!), isTrue, reason: raw);
    }
    for (final raw in ['meta+keyK', 'ctrl+alt+keyC', 'alt+keyV', 'ctrl+keyN']) {
      expect(isTextEditingChord(KeyChord.parse(raw)!), isFalse, reason: raw);
    }
  });

  testWidgets(
    'Android and iOS: the Keyboard shortcuts card is not offered (PROBE-10)',
    (tester) async {
      final prefs = await SharedPreferences.getInstance();
      final fired = <DesktopShortcut>[];
      final sub = desktopShortcutBus.stream.listen(fired.add);
      addTearDown(() => unawaited(sub.cancel()));
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              DesktopShortcuts(store: ShortcutsStore(prefs), child: child!),
          home: Scaffold(
            body: SingleChildScrollView(
              child: KeyboardShortcutsSettingsCard(preferences: prefs),
            ),
          ),
        ),
      );
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      expect(fired, isEmpty, reason: 'DesktopShortcuts is a passthrough');
      expect(
        find.byKey(const Key('keyboard-shortcuts-settings-card')),
        findsNothing,
      );
      expect(desktopShortcutsAvailable(), isFalse);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );

  testWidgets(
    'iOS: no Keyboard shortcuts card either (PROBE-10)',
    (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardShortcutsSettingsCard(preferences: prefs),
          ),
        ),
      );
      expect(
        find.byKey(const Key('keyboard-shortcuts-settings-card')),
        findsNothing,
      );
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  testWidgets(
    'desktop: the card is offered where the bindings fire',
    (tester) async {
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
      expect(
        find.byKey(const Key('keyboard-shortcuts-settings-card')),
        findsOneWidget,
      );
    },
    variant: TargetPlatformVariant.only(TargetPlatform.windows),
  );
}
