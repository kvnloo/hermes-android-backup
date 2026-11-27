// Classic places the wake-word toggle as NextGen does: in the composer row
// on a wide pane, and in More chat tools on a pane under 480 px (voice
// review of 46683e29, card B item 6).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/gateway_wake_word.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/voice_live_harness.dart';

const _toggle = ValueKey('gateway-wake-toggle');
const _menu = ValueKey('chat-tools-menu');
const _menuItem = ValueKey('chat-tools-wake-word');

/// Offered, off, on the host's microphone; records what the chat asks.
({GatewayWakeWordController controller, List<String> calls}) _offeredWake() {
  final calls = <String>[];
  var listening = false;
  final controller = GatewayWakeWordController(
    resumeRetryDelay: Duration.zero,
    transport: GatewayWakeTransport(
      connectionId: harnessClassicConnection.id,
      profile: null,
      events: const Stream<StreamEvent>.empty(),
      ready: const Stream<void>.empty(),
      isConnected: () => true,
      call: (method, params, {timeout = const Duration(seconds: 30)}) async {
        calls.add(method);
        switch (method) {
          case 'wake.start':
            listening = true;
            return {'started': true, 'capture': 'local'};
          case 'wake.stop':
            listening = false;
            return {'stopped': true};
        }
        return {
          'listening': listening,
          'enabled': listening,
          'available': true,
          'owned_by_caller': true,
          'phrase': 'hey hermes',
          'capture': 'local',
          'sample_rate': 16000,
          'frame_length': 1280,
        };
      },
    ),
  );
  return (controller: controller, calls: calls);
}

Future<void> _pump(WidgetTester tester, double width, Widget app) async {
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(app);
  await settleLive(tester);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
  });

  testWidgets('a pane under 480 px keeps the wake toggle in More chat tools, '
      'and it works from there', (tester) async {
    final wake = _offeredWake();
    addTearDown(wake.controller.dispose);
    await wake.controller.refreshStatus();
    final fixture = ClassicLiveFixture();
    await _pump(tester, 390, fixture.app(wake: wake.controller));

    expect(find.byKey(_toggle), findsNothing);
    expect(find.byKey(_menu), findsOneWidget);
    await tester.tap(find.byKey(_menu));
    await settleLive(tester);
    expect(find.byKey(_menuItem), findsOneWidget);
    await tester.tap(find.byKey(_menuItem));
    await settleLive(tester);
    expect(wake.calls, contains('wake.start'));
    expect(wake.controller.state.listening, isTrue);
    await unmountLive(tester);
  });

  testWidgets('a wide pane keeps the toggle in the composer row', (
    tester,
  ) async {
    final wake = _offeredWake();
    addTearDown(wake.controller.dispose);
    await wake.controller.refreshStatus();
    final fixture = ClassicLiveFixture();
    await _pump(tester, 1050, fixture.app(wake: wake.controller));

    expect(find.byKey(_toggle), findsOneWidget);
    expect(find.byKey(_menuItem), findsNothing);
    await unmountLive(tester);
  });

  testWidgets('nothing about wake shows on a narrow pane the gateway does not '
      'offer it on', (tester) async {
    final controller = GatewayWakeWordController(
      resumeRetryDelay: Duration.zero,
      transport: GatewayWakeTransport(
        connectionId: harnessClassicConnection.id,
        profile: null,
        events: const Stream<StreamEvent>.empty(),
        ready: const Stream<void>.empty(),
        isConnected: () => true,
        call: (method, params, {timeout = const Duration(seconds: 30)}) async =>
            {'available': false, 'enabled': false, 'listening': false},
      ),
    );
    addTearDown(controller.dispose);
    await controller.refreshStatus();
    final fixture = ClassicLiveFixture();
    await _pump(tester, 390, fixture.app(wake: controller));
    expect(find.byKey(_toggle), findsNothing);
    final menu = find.byKey(_menu);
    if (menu.evaluate().isNotEmpty) {
      await tester.tap(menu);
      await settleLive(tester);
    }
    expect(find.byKey(_menuItem), findsNothing);
    await unmountLive(tester);
  });
}
