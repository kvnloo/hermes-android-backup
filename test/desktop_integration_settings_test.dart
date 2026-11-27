import 'support/settings_navigation.dart';
// The Desktop integration card is reachable from both navigation trees on
// desktop (Classic Settings, NextGen Settings) and absent on phones.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/desktop/desktop_integration.dart';
import 'package:hermes_android/core/desktop/desktop_os.dart';
import 'package:hermes_android/core/screens/settings_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/main.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/settings_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _card = Key('desktop-integration-card');

class _Ng extends NextGenGateway {
  _Ng(super.connection);
  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async => {};
}

Future<void> _pumpClassic(WidgetTester tester) async {
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(HermesApp(connManager: ConnectionManager(prefs)));
  await tester.pumpAndSettle();
  unawaited(
    Navigator.of(tester.element(find.byType(HomeScreen))).push<void>(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          connection: SavedConnection(
            id: 'desktop-settings',
            label: 'Offline',
            host: 'offline.test',
            port: 8642,
            apiKey: 'test-key',
          ),
          dashboardClient: DashboardClient(
            host: 'offline.test',
            port: 9119,
            httpClient: MockClient((_) async => http.Response('offline', 503)),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await openSettingsCategory(tester, 'device');
}

Future<_Ng> _pumpNextGen(WidgetTester tester) async {
  final g = _Ng(
    SavedConnection(
      id: 'desktop-settings-ng',
      label: 'Offline',
      host: '127.0.0.1',
      port: 9,
      apiKey: '',
      dashboardProxied: true,
      dashboardPortOverride: 9,
    ),
  );
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
      home: NgScope(
        connManager: ConnectionManager(await SharedPreferences.getInstance()),
        gateway: g,
        connections: [g.connection],
        switchTo: (_) async {},
        addGateway: () async {},
        signOut: (_) async {},
        reload: () async {},
        signInAgain: () async {},
        child: const Scaffold(body: NgSettingsPage()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await openSettingsCategory(tester, 'device');
  return g;
}

/// What the runner channels answer: tray and hotkey support.
void _runner({required bool tray, required bool hotkey}) {
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(
    DesktopOsChannels.shell,
    (call) async => switch (call.method) {
      'isTraySupported' => tray,
      'setTray' => false,
      _ => null,
    },
  );
  messenger.setMockMethodCallHandler(
    DesktopOsChannels.hotkey,
    (call) async => switch (call.method) {
      'isSupported' => hotkey,
      'register' => hotkey ? 'registered' : 'unsupported',
      _ => null,
    },
  );
}

/// The integration the primary window's app root would run (NextGen tests
/// mount Settings without the root).
Future<DesktopIntegration> _integration(WidgetTester tester) async {
  final integration = DesktopIntegration(
    preferences: await SharedPreferences.getInstance(),
  )..start();
  addTearDown(() => unawaited(integration.dispose()));
  return integration;
}

Future<void> _scrollToCard(WidgetTester tester) => tester.scrollUntilVisible(
  find.byKey(_card),
  300,
  scrollable: find
      .byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      )
      .last,
);

void _expectOnlyHonestRows() {
  // One disabled row each, with the reason; no switch that could only fail
  // after it is turned on, and no Change button.
  for (final key in [
    'desktop-tray-switch',
    'desktop-close-to-tray-switch',
    'desktop-hotkey-switch',
    'desktop-hotkey-change',
  ]) {
    expect(find.byKey(Key(key)), findsNothing, reason: key);
  }
  for (final key in [
    'desktop-tray-unavailable',
    'desktop-hotkey-unavailable',
  ]) {
    final row = find.byKey(Key(key));
    expect(row, findsOneWidget, reason: key);
    expect(
      find.byWidgetPredicate(
        (w) => w is ListTile && w.key == Key(key) && !w.enabled,
      ),
      findsOneWidget,
    );
  }
  expect(
    find.text('This desktop has no system tray Ares can use.'),
    findsOneWidget,
  );
  expect(
    find.text(
      'This desktop does not let apps register a global shortcut (for example on Wayland).',
    ),
    findsOneWidget,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(DesktopOsChannels.shell, null);
    messenger.setMockMethodCallHandler(DesktopOsChannels.hotkey, null);
  });

  setUp(() {
    _runner(tray: true, hotkey: true);
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Ares',
      packageName: 'com.hermesagent.hermes_android',
      version: '5.0.0-test',
      buildNumber: '5000',
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
    'Classic Settings shows the card and the app root runs the integration',
    (tester) async {
      await _pumpClassic(tester);
      expect(DesktopIntegration.current, isNotNull);
      await tester.scrollUntilVisible(
        find.byKey(_card),
        300,
        scrollable: find
            .descendant(
              of: find.byType(SettingsScreen),
              matching: find.byWidgetPredicate(
                (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
              ),
            )
            .first,
      );
      expect(find.byKey(_card), findsOneWidget);
      // The switch writes the device-local preference the root applies.
      tester
          .widget<SwitchListTile>(find.byKey(const Key('desktop-tray-switch')))
          .onChanged!(true);
      await tester.pump();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(DesktopOsPrefs.trayKey), isTrue);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      expect(DesktopIntegration.current, isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.windows),
  );

  testWidgets(
    'NextGen Settings shows the card on desktop',
    (tester) async {
      await _integration(tester);
      final g = await _pumpNextGen(tester);
      await tester.scrollUntilVisible(
        find.byKey(_card),
        300,
        scrollable: find
            .byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
            )
            .first,
      );
      expect(find.byKey(_card), findsOneWidget);
      expect(find.text('Quick entry shortcut'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      g.dispose();
      await tester.pump(const Duration(seconds: 1));
    },
    variant: TargetPlatformVariant.only(TargetPlatform.linux),
  );

  testWidgets('PROBE-6 Classic on a runner with no tray and no global hotkey '
      '(Wayland): one disabled row each, never a switch', (tester) async {
    _runner(tray: false, hotkey: false);
    await _pumpClassic(tester);
    await tester.pump();
    await _scrollToCard(tester);
    _expectOnlyHonestRows();
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }, variant: TargetPlatformVariant.only(TargetPlatform.linux));

  testWidgets('PROBE-6 NextGen on a runner with no tray and no global hotkey '
      '(Wayland): one disabled row each, never a switch', (tester) async {
    _runner(tray: false, hotkey: false);
    await _integration(tester);
    final g = await _pumpNextGen(tester);
    await tester.pump();
    await _scrollToCard(tester);
    _expectOnlyHonestRows();
    await tester.pumpWidget(const SizedBox());
    g.dispose();
    await tester.pump(const Duration(seconds: 1));
  }, variant: TargetPlatformVariant.only(TargetPlatform.linux));

  testWidgets(
    'phones never show the card',
    (tester) async {
      final g = await _pumpNextGen(tester);
      for (var i = 0; i < 20; i++) {
        await tester.drag(
          find
              .byWidgetPredicate(
                (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
              )
              .first,
          const Offset(0, -400),
        );
        await tester.pump();
        expect(find.byKey(_card), findsNothing);
      }
      await tester.pumpWidget(const SizedBox());
      g.dispose();
      await tester.pump(const Duration(seconds: 1));
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );
}
