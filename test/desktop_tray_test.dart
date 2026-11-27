import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/desktop/desktop_integration.dart';
import 'package:hermes_android/core/desktop/desktop_integration_card.dart';
import 'package:hermes_android/core/desktop/desktop_os.dart';
import 'package:hermes_android/core/desktop/tray_controller.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _channel = MethodChannel('test/desktop_shell');

/// A fake runner for the shell channel: records calls and answers setTray.
class _FakeShell {
  _FakeShell({this.shows = true, this.missing = false, this.supported = true}) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          if (missing) throw MissingPluginException();
          // The support query is kept out of [calls].
          if (call.method == 'isTraySupported') {
            supportQueries++;
            return supported;
          }
          calls.add(call);
          if (call.method == 'setTray') {
            return (call.arguments as Map)['enabled'] == true && shows;
          }
          return null;
        });
  }

  final List<MethodCall> calls = [];
  bool shows;
  final bool missing;
  bool supported;
  int supportQueries = 0;

  List<MethodCall> named(String method) =>
      calls.where((c) => c.method == method).toList();

  Future<void> send(String method, Object? arguments) async {
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          _channel.name,
          const StandardMethodCodec().encodeMethodCall(
            MethodCall(method, arguments),
          ),
          (_) {},
        );
  }
}

const _labels = TrayLabels(
  tooltip: 'Ares',
  open: 'Open Ares',
  newChat: 'New chat',
  quickEntry: 'Quick entry…',
  pauseNotifications: 'Pause notifications',
  quit: 'Quit Ares',
);

Future<SharedPreferences> _prefs([Map<String, Object> values = const {}]) {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  group('TrayController', () {
    test('is off by default and never asks the runner for an icon', () async {
      final shell = _FakeShell();
      final prefs = DesktopOsPrefs(await _prefs());
      final actions = <TrayAction>[];
      final tray = TrayController(
        prefs: prefs,
        labels: () => _labels,
        onAction: actions.add,
        notificationsPaused: () => false,
        channel: _channel,
      )..start();
      await tray.sync();
      expect(prefs.trayEnabled, isFalse);
      expect(prefs.closeToTray, isFalse);
      expect(shell.named('setTray'), isEmpty);
      expect(tray.status.value, TrayStatus.off);
      await tray.dispose();
      expect(shell.named('setTray'), isEmpty);
    });

    test(
      'opting in installs the localized menu; opting out removes it',
      () async {
        final shell = _FakeShell();
        final prefs = DesktopOsPrefs(await _prefs());
        var paused = false;
        final tray = TrayController(
          prefs: prefs,
          labels: () => _labels,
          onAction: (_) {},
          notificationsPaused: () => paused,
          channel: _channel,
        )..start();
        await prefs.setTrayEnabled(true);
        await tray.sync();
        final install = shell.named('setTray').last.arguments as Map;
        expect(install['enabled'], isTrue);
        expect(install['closeToTray'], isFalse);
        expect(install['tooltip'], 'Ares');
        final items = (install['items'] as List).cast<Map>();
        expect(items.map((i) => i['id']), [
          'open',
          'new-chat',
          'pause-notifications',
          'quit',
        ]);
        expect(items.map((i) => i['label']), [
          'Open Ares',
          'New chat',
          'Pause notifications',
          'Quit Ares',
        ]);
        expect(items[2]['checked'], isFalse);
        expect(items[3]['separatorBefore'], isTrue);
        expect(tray.status.value, TrayStatus.shown);

        paused = true;
        await prefs.setCloseToTray(true);
        await tray.sync();
        final update = shell.named('setTray').last.arguments as Map;
        expect(update['closeToTray'], isTrue);
        expect(((update['items'] as List)[2] as Map)['checked'], isTrue);

        await prefs.setTrayEnabled(false);
        await tray.sync();
        expect(shell.named('setTray').last.arguments, {
          'enabled': false,
          'closeToTray': false,
        });
        expect(tray.status.value, TrayStatus.off);
        // Close-to-tray never applies without the icon.
        expect(prefs.closeToTray, isFalse);
        await tray.dispose();
      },
    );

    test('reports unsupported when the runner cannot show an icon', () async {
      _FakeShell(shows: false);
      final prefs = DesktopOsPrefs(
        await _prefs({DesktopOsPrefs.trayKey: true}),
      );
      final tray = TrayController(
        prefs: prefs,
        labels: () => _labels,
        onAction: (_) {},
        notificationsPaused: () => false,
        channel: _channel,
      )..start();
      await tray.sync();
      expect(tray.status.value, TrayStatus.unsupported);
      await tray.dispose();
    });

    test('asks the runner whether this desktop has a usable tray', () async {
      for (final (answer, missing) in [
        (true, false),
        (false, false),
        (false, true),
      ]) {
        final shell = _FakeShell(supported: answer, missing: missing);
        final tray = TrayController(
          prefs: DesktopOsPrefs(await _prefs()),
          labels: () => _labels,
          onAction: (_) {},
          notificationsPaused: () => false,
          channel: _channel,
        );
        expect(tray.supported.value, isNull);
        tray.start();
        await pumpEventQueue();
        expect(tray.supported.value, answer, reason: 'missing=$missing');
        expect(shell.supportQueries, missing ? 0 : 1);
        await tray.dispose();
      }
    });

    test(
      'a tray host that takes the icon later is reported by the runner',
      () async {
        final shell = _FakeShell(shows: false);
        final prefs = DesktopOsPrefs(
          await _prefs({DesktopOsPrefs.trayKey: true}),
        );
        final tray = TrayController(
          prefs: prefs,
          labels: () => _labels,
          onAction: (_) {},
          notificationsPaused: () => false,
          channel: _channel,
        )..start();
        await tray.sync();
        expect(tray.status.value, TrayStatus.unsupported);
        await shell.send('onTrayStatus', true);
        expect(tray.status.value, TrayStatus.shown);
        await shell.send('onTrayStatus', false);
        expect(tray.status.value, TrayStatus.unsupported);
        // Turned off: a late report changes nothing.
        await prefs.setTrayEnabled(false);
        await tray.sync();
        await shell.send('onTrayStatus', true);
        expect(tray.status.value, TrayStatus.off);
        await tray.dispose();
      },
    );

    test('a runner without the channel degrades to unsupported', () async {
      _FakeShell(missing: true);
      final prefs = DesktopOsPrefs(
        await _prefs({DesktopOsPrefs.trayKey: true}),
      );
      final tray = TrayController(
        prefs: prefs,
        labels: () => _labels,
        onAction: (_) {},
        notificationsPaused: () => false,
        channel: _channel,
      )..start();
      await tray.sync();
      expect(tray.status.value, TrayStatus.unsupported);
      await tray.dispose();
    });

    test('routes runner menu choices and ignores unknown ids', () async {
      final shell = _FakeShell();
      final prefs = DesktopOsPrefs(
        await _prefs({DesktopOsPrefs.trayKey: true}),
      );
      final actions = <TrayAction>[];
      var quickEntry = false;
      final tray = TrayController(
        prefs: prefs,
        labels: () => _labels,
        onAction: actions.add,
        notificationsPaused: () => false,
        quickEntryAvailable: () => quickEntry,
        channel: _channel,
      )..start();
      await tray.sync();
      await shell.send('onTrayAction', 'open');
      await shell.send('onTrayAction', 'new-chat');
      await shell.send('onTrayAction', 'rm -rf');
      await shell.send('onTrayAction', 42);
      await shell.send('onTrayAction', 'quick-entry');
      await shell.send('somethingElse', 'quit');
      expect(actions, [TrayAction.open, TrayAction.newChat]);

      quickEntry = true;
      await tray.sync();
      final items =
          ((shell.named('setTray').last.arguments as Map)['items'] as List)
              .cast<Map>();
      expect(items.map((i) => i['id']), contains('quick-entry'));
      await shell.send('onTrayAction', 'quick-entry');
      expect(actions.last, TrayAction.quickEntry);

      await tray.dispose();
      // The icon is removed and later runner calls are ignored.
      expect(shell.named('setTray').last.arguments, {
        'enabled': false,
        'closeToTray': false,
      });
      actions.clear();
      await shell.send('onTrayAction', 'open');
      expect(actions, isEmpty);
    });
  });

  group('DesktopIntegration tray actions', () {
    Future<(DesktopIntegration, _FakeShell, List<String>)> start({
      bool notificationsOn = true,
    }) async {
      final shell = _FakeShell();
      final log = <String>[];
      final notifications = ValueNotifier(
        NotificationPrefs.defaults.copyWith(enabled: notificationsOn),
      );
      final integration = DesktopIntegration(
        preferences: await _prefs({DesktopOsPrefs.trayKey: true}),
        shell: const DesktopShell(_channel),
        onNewChat: () => log.add('new-chat'),
        setNotificationsEnabled: (enabled) async {
          log.add('notifications:$enabled');
          notifications.value = notifications.value.copyWith(enabled: enabled);
        },
        notifications: notifications,
        strings: () => lookupAppLocalizations(const Locale('de')),
      )..start();
      await integration.tray.sync();
      return (integration, shell, log);
    }

    test('menu labels follow the app language', () async {
      final (integration, shell, _) = await start();
      final items =
          ((shell.named('setTray').last.arguments as Map)['items'] as List)
              .cast<Map>();
      expect(items.first['label'], 'Ares öffnen');
      expect(items.last['label'], 'Ares beenden');
      expect(DesktopIntegration.current, same(integration));
      await integration.dispose();
      expect(DesktopIntegration.current, isNull);
    });

    test('open, new chat and pause act on the primary window', () async {
      final (integration, shell, log) = await start();
      await shell.send('onTrayAction', 'open');
      expect(shell.named('showWindow'), hasLength(1));
      await shell.send('onTrayAction', 'new-chat');
      expect(shell.named('showWindow'), hasLength(2));
      expect(log, ['new-chat']);
      await shell.send('onTrayAction', 'pause-notifications');
      await integration.tray.sync();
      expect(log.last, 'notifications:false');
      // The menu now shows notifications as paused.
      final items =
          ((shell.named('setTray').last.arguments as Map)['items'] as List)
              .cast<Map>();
      expect(
        items.firstWhere((i) => i['id'] == 'pause-notifications')['checked'],
        isTrue,
      );
      await shell.send('onTrayAction', 'pause-notifications');
      expect(log.last, 'notifications:true');
      await integration.dispose();
    });

    test('quit removes the icon before asking the runner to quit', () async {
      final (integration, shell, _) = await start();
      await shell.send('onTrayAction', 'quit');
      await pumpEventQueue();
      final methods = shell.calls.map((c) => c.method).toList();
      final removed = shell.calls.lastIndexWhere(
        (c) =>
            c.method == 'setTray' && (c.arguments as Map)['enabled'] == false,
      );
      expect(removed, greaterThanOrEqualTo(0));
      expect(methods.last, 'quit');
      expect(removed, lessThan(methods.length - 1));
      expect(DesktopIntegration.current, isNull);
      await integration.dispose();
    });
  });

  group('DesktopIntegrationCard', () {
    testWidgets('edits the device-local tray preferences', (tester) async {
      _FakeShell();
      final preferences = await _prefs();
      final integration = DesktopIntegration(
        preferences: preferences,
        shell: const DesktopShell(_channel),
        hotkeyChannel: const MethodChannel('test/desktop_tray_no_hotkey'),
        notifications: ValueNotifier(NotificationPrefs.defaults),
        strings: () => lookupAppLocalizations(const Locale('en')),
      )..start();
      addTearDown(() => unawaited(integration.dispose()));
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
      expect(find.text('Desktop integration'), findsOneWidget);
      SwitchListTile tile(String key) =>
          tester.widget<SwitchListTile>(find.byKey(Key(key)));
      expect(tile('desktop-tray-switch').value, isFalse);
      // Close-to-tray needs the icon first.
      expect(tile('desktop-close-to-tray-switch').onChanged, isNull);

      await tester.tap(find.byKey(const Key('desktop-tray-switch')));
      await tester.pump();
      expect(preferences.getBool(DesktopOsPrefs.trayKey), isTrue);
      expect(tile('desktop-tray-switch').value, isTrue);
      expect(tile('desktop-close-to-tray-switch').onChanged, isNotNull);

      await tester.tap(find.byKey(const Key('desktop-close-to-tray-switch')));
      await tester.pump();
      expect(preferences.getBool(DesktopOsPrefs.closeToTrayKey), isTrue);
    });

    testWidgets('says when this desktop has no usable tray', (tester) async {
      _FakeShell(shows: false);
      final preferences = await _prefs({DesktopOsPrefs.trayKey: true});
      final integration = DesktopIntegration(
        preferences: preferences,
        shell: const DesktopShell(_channel),
        notifications: ValueNotifier(NotificationPrefs.defaults),
        strings: () => lookupAppLocalizations(const Locale('en')),
      )..start();
      await tester.runAsync(() => integration.tray.sync());
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: DesktopIntegrationCard(
              preferences: preferences,
              integration: integration,
            ),
          ),
        ),
      );
      expect(find.byKey(const Key('desktop-tray-unsupported')), findsOneWidget);
      await tester.runAsync(integration.dispose);
    });
  });
}
