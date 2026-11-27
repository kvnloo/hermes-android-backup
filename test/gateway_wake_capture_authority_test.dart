import 'support/settings_navigation.dart';
// The wake capture-mode setting on a 0.23+ session-authority gateway.
//
// The owner's closed `config.set` contract (`CanonicalConfigSetParams`,
// Desktop's `CANONICAL_CONFIG_KEYS`) has no `wake_word.capture`, and Desktop
// has no such control: the wire guard refuses the request by name. Settings
// in both layouts therefore disable the three capture chips there and say
// why, and the controller never sends the change. A legacy gateway keeps the
// chips and takes the change as before.
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/settings_screen.dart';
import 'package:hermes_android/core/services/canonical_wire.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/gateway_wake_word.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/services/voice_live_mode.dart';
import 'package:hermes_android/core/services/ws_client.dart';
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

import 'support/strict_authority_server.dart';
import 'support/voice_live_harness.dart';

/// A wake gateway that serves `wake.status` and `config.set`, on a socket
/// that is (or is not) a session authority.
class _ScriptedWake {
  _ScriptedWake({required String connectionId, required bool authority}) {
    controller = GatewayWakeWordController(
      transport: GatewayWakeTransport(
        connectionId: connectionId,
        profile: null,
        events: const Stream<StreamEvent>.empty(),
        ready: const Stream<void>.empty(),
        isConnected: () => true,
        sessionAuthority: () => authority,
        call: (method, params, {timeout = const Duration(seconds: 30)}) async {
          calls.add((method, Map<String, dynamic>.from(params)));
          return switch (method) {
            'wake.status' => {
              'available': true,
              'enabled': false,
              'listening': false,
              'capture': 'auto',
            },
            'config.set' => {'key': params['key'], 'value': params['value']},
            _ => <String, dynamic>{},
          };
        },
      ),
    );
  }

  final calls = <(String, Map<String, dynamic>)>[];
  late final GatewayWakeWordController controller;

  List<Map<String, dynamic>> get configSets => [
    for (final (method, params) in calls)
      if (method == 'config.set') params,
  ];
}

const _chips = [
  'gateway-wake-capture-auto',
  'gateway-wake-capture-client',
  'gateway-wake-capture-local',
];
const _reason = ValueKey('gateway-wake-capture-unavailable');

Finder _scrollable(Type page) => find
    .descendant(
      of: find.byType(page),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    )
    .first;

/// Checks the capture row the Settings page shows for [wake], then taps
/// "This device's microphone".
Future<void> _expectCaptureRow(
  WidgetTester tester,
  _ScriptedWake wake, {
  required bool authority,
  required Type page,
}) async {
  final client = find.byKey(const ValueKey('gateway-wake-capture-client'));
  await tester.scrollUntilVisible(
    client,
    120,
    scrollable: _scrollable(page),
    maxScrolls: 200,
  );
  await tester.pump();

  // The switch itself is still offered: only the capture setting is not.
  expect(find.byKey(const ValueKey('gateway-wake-switch')), findsOneWidget);
  for (final key in _chips) {
    final chip = tester.widget<ChoiceChip>(find.byKey(ValueKey(key)));
    expect(
      chip.onSelected == null,
      authority,
      reason: '$key enabled: ${!authority}',
    );
  }
  if (authority) {
    expect(find.byKey(_reason), findsOneWidget);
    final l10n = AppLocalizations.of(tester.element(client))!;
    expect(
      tester.widget<Text>(find.byKey(_reason)).data,
      l10n.wake_word_capture_unavailable,
    );
    expect(l10n.wake_word_capture_unavailable, contains('wake_word.capture'));
  } else {
    expect(find.byKey(_reason), findsNothing);
  }

  wake.calls.clear();
  await tester.tap(client);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));

  if (authority) {
    expect(wake.configSets, isEmpty);
  } else {
    expect(wake.configSets, [
      {'key': 'wake_word.capture', 'value': 'client'},
    ]);
    // The gateway's answer is read back.
    expect(wake.calls.map((call) => call.$1), contains('wake.status'));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the owner contract has no wake_word.capture', () {
    expect(canonicalConfigAvailable('wake_word.capture'), isFalse);
  });

  group('both layouts\' wake transports carry the socket\'s authority', () {
    HttpOverrides? previous;
    setUp(() {
      previous = HttpOverrides.current;
      HttpOverrides.global = null;
      SharedPreferences.setMockInitialValues(<String, Object>{});
      HermesSignInVault.resetForTesting(MemorySignInSecretStore());
    });
    tearDown(() {
      HermesSignInVault.resetForTesting();
      HttpOverrides.global = previous;
    });

    for (final authority in [true, false]) {
      test(authority ? 'session authority' : 'legacy gateway', () async {
        final gateway = await StrictAuthorityGateway.start(
          ready: authority ? const {} : const {'session_authority': false},
        );
        final classic = DesktopGatewayClient.fromConnection(
          gateway.connection(id: 'wake-classic-$authority'),
        );
        final nextgen = NextGenGateway(
          gateway.connection(id: 'wake-nextgen-$authority'),
        )..start();
        try {
          await nextgen.connected();
          // Dials Classic's socket.
          await classic.wakeWord.refreshStatus();

          for (final controller in [classic.wakeWord, nextgen.wakeWord]) {
            expect(controller.transport.sessionAuthority, authority);
          }
          if (!authority) return;

          // A capture change on an authority socket is never sent, and the
          // caller sees no refusal: there was nothing to refuse.
          for (final controller in [classic.wakeWord, nextgen.wakeWord]) {
            await controller.setCapturePreference('client');
          }
          expect(gateway.calls('config.set'), isEmpty);
          expect(
            gateway.refused.map((frame) => frame.method),
            isNot(contains('config.set')),
          );
        } finally {
          classic.close();
          nextgen.dispose();
          await gateway.close();
        }
      });
    }
  });

  group('NextGen Settings', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
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

    for (final authority in [true, false]) {
      testWidgets(
        authority
            ? 'a session authority disables the capture chips and says why'
            : 'a legacy gateway offers the capture chips and takes a change',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(420, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final gateway = HarnessGateway(harnessNextGenConnection());
          gateway.debugVoiceLiveMode = VoiceLiveModeController(
            connectionId: gateway.connection.id,
            transport: HarnessLiveTransport(),
            registerShared: false,
          );
          final wake = _ScriptedWake(
            connectionId: 'ng-wake-$authority',
            authority: authority,
          );
          gateway.debugWakeWord = wake.controller;
          addTearDown(gateway.dispose);
          await wake.controller.refreshStatus();
          final prefs = await SharedPreferences.getInstance();

          await tester.pumpWidget(
            MaterialApp(
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: nextGenTheme(Brightness.light, NextGenLook.instance),
              home: NgScope(
                connManager: ConnectionManager(prefs),
                gateway: gateway,
                connections: [gateway.connection],
                switchTo: (_) async {},
                addGateway: () async {},
                signOut: (_) async {},
                reload: () async {},
                signInAgain: () async {},
                child: const NgSettingsPage(),
              ),
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          await openSettingsCategory(tester, 'voice');
          await _expectCaptureRow(
            tester,
            wake,
            authority: authority,
            page: NgSettingsPage,
          );
          await tester.pumpWidget(const SizedBox.shrink());
        },
      );
    }
  });

  group('Classic Settings', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      PackageInfo.setMockInitialValues(
        appName: 'Ares',
        packageName: 'com.hermesagent.hermes_android',
        version: '5.0.0',
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

    for (final authority in [true, false]) {
      testWidgets(
        authority
            ? 'a session authority disables the capture chips and says why'
            : 'a legacy gateway offers the capture chips and takes a change',
        (tester) async {
          final connection = SavedConnection(
            id: 'classic-wake-$authority',
            label: 'Wake fixture',
            host: 'offline.test',
            port: 8642,
            apiKey: 'fixture-key',
            desktopGatewayUrl: 'http://offline.test:9119',
          );
          // The chat's controller, which Settings reuses for its connection.
          final wake = _ScriptedWake(
            connectionId: connection.id,
            authority: authority,
          );
          addTearDown(wake.controller.dispose);
          final prefs = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            HermesApp(connManager: ConnectionManager(prefs)),
          );
          await tester.pumpAndSettle();
          unawaited(
            Navigator.of(tester.element(find.byType(HomeScreen))).push<void>(
              MaterialPageRoute(
                builder: (_) => SettingsScreen(
                  connection: connection,
                  dashboardClient: DashboardClient(
                    host: 'offline.test',
                    port: 9119,
                    httpClient: MockClient(
                      (_) async => http.Response('offline', 503),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          await openSettingsCategory(tester, 'voice');
          await _expectCaptureRow(
            tester,
            wake,
            authority: authority,
            page: SettingsScreen,
          );
        },
      );
    }
  });
}
