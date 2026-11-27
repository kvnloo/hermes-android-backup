import 'dart:async';

import 'package:flutter/material.dart' hide ShortcutRegistry;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/desktop/desktop_integration.dart';
import 'package:hermes_android/core/desktop/desktop_integration_card.dart';
import 'package:hermes_android/core/desktop/desktop_os.dart';
import 'package:hermes_android/core/desktop/global_hotkey.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/shortcuts_store.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_child_process.dart';

const _channel = MethodChannel('test/desktop_hotkey');

/// A fake runner: answers register with [answer] and records calls. The
/// isSupported query is answered with [supported] and kept out of [calls].
class _FakeHotkeyRunner {
  _FakeHotkeyRunner({
    this.answer = 'registered',
    this.missing = false,
    this.supported = true,
  }) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          if (missing) throw MissingPluginException();
          if (call.method == 'isSupported') {
            supportQueries++;
            return supported;
          }
          calls.add(call);
          if (call.method == 'register') return answer;
          return null;
        });
  }

  final List<MethodCall> calls = [];
  String answer;
  final bool missing;
  bool supported;
  int supportQueries = 0;

  List<String> get methods => calls.map((c) => c.method).toList();

  Future<void> press() async {
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          _channel.name,
          const StandardMethodCodec().encodeMethodCall(
            const MethodCall('onHotKey'),
          ),
          (_) {},
        );
  }
}

Future<SharedPreferences> _prefs([Map<String, Object> values = const {}]) {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

const _space = LogicalKeyboardKey.space;

Map<ShortcutAction, KeyChord> _defaults() => {
  for (final action in ShortcutRegistry.actions)
    action: ShortcutRegistry.defaultChord(action),
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  group('checkGlobalHotkey', () {
    HotkeyCheck check(KeyChord chord, TargetPlatform platform) =>
        checkGlobalHotkey(chord, platform: platform, inApp: _defaults());

    test('defaults are valid and differ per platform', () {
      final mac = defaultQuickEntryChord(TargetPlatform.macOS);
      final win = defaultQuickEntryChord(TargetPlatform.windows);
      expect(mac.serialize(), 'meta+shift+space');
      expect(win.serialize(), 'ctrl+shift+space');
      expect(check(mac, TargetPlatform.macOS).isOk, isTrue);
      expect(check(win, TargetPlatform.windows).isOk, isTrue);
      expect(check(win, TargetPlatform.linux).isOk, isTrue);
    });

    test('needs a real modifier and keeps the Super key for the OS', () {
      expect(
        check(
          const KeyChord(key: _space, shift: true),
          TargetPlatform.macOS,
        ).problem,
        HotkeyProblem.noModifier,
      );
      expect(
        check(
          const KeyChord(key: _space, meta: true, shift: true),
          TargetPlatform.windows,
        ).problem,
        HotkeyProblem.superKey,
      );
      expect(
        check(
          const KeyChord(key: _space, meta: true, ctrl: true),
          TargetPlatform.linux,
        ).problem,
        HotkeyProblem.superKey,
      );
    });

    test('rejects chords the system owns', () {
      expect(
        check(
          const KeyChord(key: _space, meta: true),
          TargetPlatform.macOS,
        ).problem,
        HotkeyProblem.reserved,
      );
      expect(
        check(
          const KeyChord(key: LogicalKeyboardKey.tab, alt: true),
          TargetPlatform.windows,
        ).problem,
        HotkeyProblem.reserved,
      );
      expect(
        check(
          const KeyChord(key: LogicalKeyboardKey.keyT, ctrl: true, alt: true),
          TargetPlatform.linux,
        ).problem,
        HotkeyProblem.reserved,
      );
    });

    test('rejects in-app shortcuts, including the Ctrl mirror', () {
      final mac = check(
        const KeyChord(key: LogicalKeyboardKey.keyK, meta: true),
        TargetPlatform.macOS,
      );
      expect(mac.problem, HotkeyProblem.inAppShortcut);
      expect(mac.action, ShortcutAction.commandPalette);
      // Windows answers uncustomized Cmd shortcuts to Ctrl too.
      final win = check(
        const KeyChord(key: LogicalKeyboardKey.keyN, ctrl: true),
        TargetPlatform.windows,
      );
      expect(win.problem, HotkeyProblem.inAppShortcut);
      expect(win.action, ShortcutAction.newChat);
      expect(
        check(
          const KeyChord(key: LogicalKeyboardKey.keyN, ctrl: true),
          TargetPlatform.macOS,
        ).isOk,
        isTrue,
      );
    });
  });

  group('GlobalHotkeyController', () {
    test('is off by default and never registers', () async {
      final runner = _FakeHotkeyRunner();
      var pressed = 0;
      final hotkey = GlobalHotkeyController(
        prefs: DesktopOsPrefs(await _prefs()),
        onPressed: () => pressed++,
        channel: _channel,
        platform: TargetPlatform.windows,
      )..start();
      await hotkey.sync();
      expect(runner.calls, isEmpty);
      expect(hotkey.status.value, HotkeyStatus.off);
      await runner.press();
      expect(pressed, 0);
      await hotkey.dispose();
      expect(runner.calls, isEmpty);
    });

    test('registers on opt-in, remaps, and unregisters on disable', () async {
      final runner = _FakeHotkeyRunner();
      final prefs = DesktopOsPrefs(await _prefs());
      var pressed = 0;
      final hotkey = GlobalHotkeyController(
        prefs: prefs,
        onPressed: () => pressed++,
        channel: _channel,
        platform: TargetPlatform.windows,
      )..start();
      await prefs.setHotkeyEnabled(true);
      await hotkey.sync();
      expect(runner.methods, ['register']);
      expect(runner.calls.single.arguments, {
        'key': 'space',
        'meta': false,
        'ctrl': true,
        'alt': false,
        'shift': true,
      });
      expect(hotkey.status.value, HotkeyStatus.registered);
      await runner.press();
      expect(pressed, 1);

      // Remap: the old chord is released before the new one is taken.
      await prefs.setHotkeyChord('ctrl+alt+keyJ');
      await hotkey.sync();
      expect(runner.methods, ['register', 'unregister', 'register']);
      expect((runner.calls.last.arguments as Map)['key'], 'keyJ');
      // Same chord again: nothing to do.
      await hotkey.sync();
      expect(runner.methods, hasLength(3));

      await prefs.setHotkeyEnabled(false);
      await hotkey.sync();
      expect(runner.methods.last, 'unregister');
      expect(hotkey.status.value, HotkeyStatus.off);
      await runner.press();
      expect(pressed, 1);
      await hotkey.dispose();
    });

    test('reports a chord another app owns as a conflict', () async {
      final runner = _FakeHotkeyRunner(answer: 'conflict');
      final prefs = DesktopOsPrefs(
        await _prefs({DesktopOsPrefs.hotkeyEnabledKey: true}),
      );
      final hotkey = GlobalHotkeyController(
        prefs: prefs,
        onPressed: () {},
        channel: _channel,
        platform: TargetPlatform.linux,
      )..start();
      await hotkey.sync();
      expect(hotkey.status.value, HotkeyStatus.conflict);
      // Nothing was registered, so nothing is unregistered on exit; a
      // later sync may retry in case the other app let go.
      await hotkey.dispose();
      expect(runner.methods, everyElement('register'));
    });

    test('a saved chord that collides in-app is never registered', () async {
      final runner = _FakeHotkeyRunner();
      final prefs = DesktopOsPrefs(
        await _prefs({
          DesktopOsPrefs.hotkeyEnabledKey: true,
          DesktopOsPrefs.hotkeyChordKey: 'ctrl+keyK',
        }),
      );
      final hotkey = GlobalHotkeyController(
        prefs: prefs,
        onPressed: () {},
        channel: _channel,
        platform: TargetPlatform.windows,
      )..start();
      await hotkey.sync();
      expect(runner.calls, isEmpty);
      expect(hotkey.status.value, HotkeyStatus.invalid);
      expect(hotkey.lastCheck.action, ShortcutAction.commandPalette);
      await hotkey.dispose();
    });

    test('rebinding an in-app shortcut onto the hotkey releases it', () async {
      final runner = _FakeHotkeyRunner();
      final preferences = await _prefs({DesktopOsPrefs.hotkeyEnabledKey: true});
      final shortcuts = ShortcutsStore(preferences);
      final hotkey = GlobalHotkeyController(
        prefs: DesktopOsPrefs(preferences),
        shortcuts: shortcuts,
        onPressed: () {},
        channel: _channel,
        platform: TargetPlatform.linux,
      )..start();
      await hotkey.sync();
      expect(hotkey.status.value, HotkeyStatus.registered);
      await shortcuts.setChord(
        ShortcutAction.search,
        const KeyChord(key: _space, ctrl: true, shift: true),
      );
      await hotkey.sync();
      expect(runner.methods, ['register', 'unregister']);
      expect(hotkey.status.value, HotkeyStatus.invalid);
      expect(hotkey.lastCheck.action, ShortcutAction.search);
      await hotkey.dispose();
    });

    test('unsupported desktops and missing runners say so', () async {
      _FakeHotkeyRunner(answer: 'unsupported');
      final prefs = DesktopOsPrefs(
        await _prefs({DesktopOsPrefs.hotkeyEnabledKey: true}),
      );
      final hotkey = GlobalHotkeyController(
        prefs: prefs,
        onPressed: () {},
        channel: _channel,
        platform: TargetPlatform.linux,
      )..start();
      await hotkey.sync();
      expect(hotkey.status.value, HotkeyStatus.unsupported);
      await hotkey.dispose();

      _FakeHotkeyRunner(missing: true);
      final second = GlobalHotkeyController(
        prefs: prefs,
        onPressed: () {},
        channel: _channel,
        platform: TargetPlatform.linux,
      )..start();
      await second.sync();
      expect(second.status.value, HotkeyStatus.unsupported);
      await second.dispose();
    });

    test('asks the runner whether a global shortcut is possible', () async {
      final runner = _FakeHotkeyRunner(supported: false);
      final hotkey = GlobalHotkeyController(
        prefs: DesktopOsPrefs(await _prefs()),
        onPressed: () {},
        channel: _channel,
        platform: TargetPlatform.linux,
      );
      expect(hotkey.supported.value, isNull);
      hotkey.start();
      await pumpEventQueue();
      expect(runner.supportQueries, 1);
      expect(hotkey.supported.value, isFalse);
      await hotkey.dispose();

      _FakeHotkeyRunner(missing: true);
      final missing = GlobalHotkeyController(
        prefs: DesktopOsPrefs(await _prefs()),
        onPressed: () {},
        channel: _channel,
        platform: TargetPlatform.linux,
      )..start();
      await pumpEventQueue();
      expect(missing.supported.value, isFalse);
      await missing.dispose();
    });

    test(
      'a register answered unsupported marks the hotkey unsupported',
      () async {
        _FakeHotkeyRunner(answer: 'unsupported');
        final hotkey = GlobalHotkeyController(
          prefs: DesktopOsPrefs(
            await _prefs({DesktopOsPrefs.hotkeyEnabledKey: true}),
          ),
          onPressed: () {},
          channel: _channel,
          platform: TargetPlatform.linux,
        )..start();
        await hotkey.sync();
        expect(hotkey.status.value, HotkeyStatus.unsupported);
        expect(hotkey.supported.value, isFalse);
        await hotkey.dispose();
      },
    );

    test('exit unregisters a registered hotkey', () async {
      final runner = _FakeHotkeyRunner();
      final hotkey = GlobalHotkeyController(
        prefs: DesktopOsPrefs(
          await _prefs({DesktopOsPrefs.hotkeyEnabledKey: true}),
        ),
        onPressed: () {},
        channel: _channel,
        platform: TargetPlatform.macOS,
      )..start();
      await hotkey.sync();
      expect((runner.calls.single.arguments as Map)['meta'], isTrue);
      await hotkey.dispose();
      expect(runner.methods, ['register', 'unregister']);
    });
  });

  test('the hotkey toggles quick entry through DesktopIntegration', () async {
    final runner = _FakeHotkeyRunner();
    const shell = MethodChannel('test/desktop_hotkey_shell');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(shell, (_) async => null);
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(shell, null),
    );
    final spawned = <FakeChildProcess>[];
    final integration = DesktopIntegration(
      preferences: await _prefs({DesktopOsPrefs.hotkeyEnabledKey: true}),
      shell: const DesktopShell(shell),
      hotkeyChannel: _channel,
      platform: TargetPlatform.windows,
      notifications: ValueNotifier(NotificationPrefs.defaults),
      quickEntryChats: () => const [],
      quickEntrySpawn: () async {
        final process = FakeChildProcess();
        spawned.add(process);
        return process;
      },
      strings: () => lookupAppLocalizations(const Locale('en')),
    )..start();
    await integration.hotkey.sync();
    await runner.press();
    await pumpEventQueue();
    expect(spawned, hasLength(1));
    spawned.single.emit('ARES_QUICK_ENTRY_READY_V1');
    await pumpEventQueue();
    // A second press closes the open window.
    await runner.press();
    await pumpEventQueue();
    expect(spawned.single.killed, isTrue);
    expect(spawned, hasLength(1));
    await integration.dispose();
    expect(runner.methods.last, 'unregister');
  });

  group('settings card', () {
    Future<SharedPreferences> pumpCard(
      WidgetTester tester, {
      Map<String, Object> values = const {},
      DesktopIntegration? integration,
    }) async {
      final preferences = await _prefs(values);
      if (integration == null) {
        // A runner that supports the hotkey; the card offers the switch
        // only once it has said so.
        _FakeHotkeyRunner();
        const shell = MethodChannel('test/desktop_hotkey_card_default_shell');
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              shell,
              (call) async => call.method == 'isTraySupported',
            );
        addTearDown(
          () => TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .setMockMethodCallHandler(shell, null),
        );
        final running = integration = DesktopIntegration(
          preferences: preferences,
          shell: const DesktopShell(shell),
          hotkeyChannel: _channel,
          notifications: ValueNotifier(NotificationPrefs.defaults),
          strings: () => lookupAppLocalizations(const Locale('en')),
        )..start();
        addTearDown(() => unawaited(running.dispose()));
      }
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ListView(
              children: [
                DesktopIntegrationCard(
                  preferences: preferences,
                  integration: integration,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      return preferences;
    }

    testWidgets(
      'turns the hotkey on and remaps it',
      (tester) async {
        final preferences = await pumpCard(tester);
        expect(find.text('Quick entry shortcut'), findsOneWidget);
        expect(find.text('Ctrl + Shift + Space'), findsOneWidget);
        final toggle = find.byKey(const Key('desktop-hotkey-switch'));
        expect(tester.widget<SwitchListTile>(toggle).value, isFalse);
        await tester.tap(toggle);
        await tester.pump();
        expect(preferences.getBool(DesktopOsPrefs.hotkeyEnabledKey), isTrue);

        // The editor starts from Ctrl+Shift+Space; make it Ctrl+Shift+J.
        await tester.tap(find.byKey(const Key('desktop-hotkey-change')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('chord-key-keyJ')));
        await tester.pump();
        await tester.tap(find.byKey(const Key('chord-save-button')));
        await tester.pumpAndSettle();
        expect(
          preferences.getString(DesktopOsPrefs.hotkeyChordKey),
          'ctrl+shift+keyJ',
        );
        // Registered on the runner now, so the status names the new chord.
        expect(
          find.text('Press Ctrl + Shift + J anywhere to open quick entry.'),
          findsOneWidget,
        );
      },
      variant: TargetPlatformVariant.only(TargetPlatform.windows),
    );

    testWidgets(
      'refuses an in-app chord and keeps the saved one',
      (tester) async {
        final preferences = await pumpCard(tester);
        await tester.tap(find.byKey(const Key('desktop-hotkey-change')));
        await tester.pumpAndSettle();
        // From Ctrl+Shift+Space to Ctrl+N, which is New chat in-app.
        await tester.tap(find.byKey(const Key('chord-mod-shift')));
        await tester.tap(find.byKey(const Key('chord-key-keyN')));
        await tester.pump();
        await tester.tap(find.byKey(const Key('chord-save-button')));
        await tester.pumpAndSettle();
        expect(preferences.getString(DesktopOsPrefs.hotkeyChordKey), isNull);
        expect(
          find.text('Ares already uses this shortcut for New chat.'),
          findsOneWidget,
        );
      },
      variant: TargetPlatformVariant.only(TargetPlatform.windows),
    );

    testWidgets('shows the runner status and resets to the default', (
      tester,
    ) async {
      final runner = _FakeHotkeyRunner(answer: 'conflict');
      const shell = MethodChannel('test/desktop_hotkey_card_shell');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(shell, (_) async => null);
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(shell, null),
      );
      final preferences = await _prefs({
        DesktopOsPrefs.hotkeyEnabledKey: true,
        DesktopOsPrefs.hotkeyChordKey: 'ctrl+alt+keyJ',
      });
      // Everything runs under the test clock; pumps flush the runner calls.
      final integration = DesktopIntegration(
        preferences: preferences,
        shell: const DesktopShell(shell),
        hotkeyChannel: _channel,
        platform: TargetPlatform.linux,
        notifications: ValueNotifier(NotificationPrefs.defaults),
        strings: () => lookupAppLocalizations(const Locale('en')),
      )..start();
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ListView(
              children: [
                DesktopIntegrationCard(
                  preferences: preferences,
                  integration: integration,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(
        find.text(
          'Another app already uses Ctrl + Alt + J. Choose a different shortcut.',
        ),
        findsOneWidget,
      );
      runner.answer = 'registered';
      await tester.tap(find.byKey(const Key('desktop-hotkey-reset')));
      await tester.pump();
      await tester.pump();
      expect(preferences.getString(DesktopOsPrefs.hotkeyChordKey), isNull);
      expect(
        find.text('Press Ctrl + Shift + Space anywhere to open quick entry.'),
        findsOneWidget,
      );
      expect(runner.methods, everyElement('register'));
      unawaited(integration.dispose());
      await tester.pump();
      expect(runner.methods.last, 'unregister');
    });
  });
}
