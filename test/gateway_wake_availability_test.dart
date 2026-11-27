// Wake word on gateways that do not serve it. A 0.23+ session-authority
// gateway answers every wake.* call with -32601 (review probe K1): the
// toggle stays hidden as Desktop's does until wake.status says the feature
// can run, availability is probed without asking for the microphone, and
// the microphone prompt comes only after the host has armed client capture.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/gateway_wake_word.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/gateway_wake_controls.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

class _Pcm implements WakeClientPcmSource {
  final log = <String>[];

  @override
  Future<bool> hasPermission({bool request = false}) async {
    log.add(request ? 'prompt' : 'check');
    return true;
  }

  @override
  Future<List<WakeClientInputDevice>> listInputDevices() async => const [];

  @override
  Future<WakeClientPcmSession> startStream({
    required int sampleRate,
    WakeClientInputDevice? device,
  }) async {
    log.add('capture');
    return _Session();
  }
}

class _Session implements WakeClientPcmSession {
  @override
  Stream<Uint8List> get pcmInt16Le => const Stream<Uint8List>.empty();
  @override
  Future<void> stop() async {}
}

/// Scripted gateway: [answer] decides each wake.* reply; every call is
/// logged next to the microphone events, so their order can be checked.
class _Gateway {
  _Gateway(this.log, this.answer);
  final List<String> log;
  final FutureOr<Map<String, dynamic>> Function(
    String method,
    Map<String, dynamic> params,
  )
  answer;

  GatewayWakeTransport get transport => GatewayWakeTransport(
    connectionId: 'wake-availability',
    profile: null,
    events: const Stream<StreamEvent>.empty(),
    ready: const Stream<void>.empty(),
    isConnected: () => true,
    call: (method, params, {timeout = const Duration(seconds: 30)}) async {
      log.add(method);
      return answer(method, params);
    },
  );
}

Never _unknownMethod(String method) => throw JsonRpcError(
  method,
  'unknown method: $method — not available on this Hermes backend',
  code: -32601,
  reason: 'unknown_method',
);

Widget _app(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('a session-authority gateway (wake.* answers -32601) shows no '
      'wake toggle, menu entry or settings switch, and never prompts for '
      'the microphone (review probe K1)', (tester) async {
    final log = <String>[];
    final pcm = _Pcm();
    final controller = GatewayWakeWordController(
      pcmSource: pcm,
      transport: _Gateway(log, (method, _) => _unknownMethod(method)).transport,
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _app(
        Column(
          children: [
            GatewayWakeToolbarButton(controller: controller, sessionId: 's'),
            GatewayWakeSettingsPanel(controller: controller),
            GatewayWakeListeningBanner(controller: controller),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    await controller.refreshStatus();
    await tester.pump(const Duration(milliseconds: 50));

    expect(log, everyElement('wake.status'));
    expect(controller.state.offered, isFalse);
    expect(find.byKey(const ValueKey('gateway-wake-toggle')), findsNothing);
    expect(find.byKey(const ValueKey('gateway-wake-switch')), findsNothing);
    expect(find.byKey(const ValueKey('gateway-wake-banner')), findsNothing);
    expect(pcm.log, isEmpty);

    // Even asked directly, nothing prompts and nothing is armed.
    expect(await controller.toggle(sessionId: 's'), isFalse);
    expect(pcm.log, isEmpty);
    expect(log, isNot(contains('wake.start')));
  });

  testWidgets('the toggle appears once wake.status says the feature can '
      'run, and stays hidden while the gateway has not answered', (
    tester,
  ) async {
    final log = <String>[];
    final status = Completer<Map<String, dynamic>>();
    final controller = GatewayWakeWordController(
      pcmSource: _Pcm(),
      transport: _Gateway(log, (method, _) {
        if (method == 'wake.status') return status.future;
        return {'started': false, 'reason': 'disabled'};
      }).transport,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _app(GatewayWakeToolbarButton(controller: controller)),
    );
    await tester.pump();
    expect(find.byKey(const ValueKey('gateway-wake-toggle')), findsNothing);

    status.complete({
      'available': true,
      'enabled': false,
      'listening': false,
      'capture': 'client',
    });
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byKey(const ValueKey('gateway-wake-toggle')), findsOneWidget);
  });

  test('a deliberate start asks the host first and prompts for the '
      'microphone only after it armed client capture', () async {
    final log = <String>[];
    final pcm = _Pcm();
    final controller = GatewayWakeWordController(
      pcmSource: pcm,
      transport: _Gateway(log, (method, _) {
        return switch (method) {
          'wake.status' => {
            'available': true,
            'enabled': false,
            'listening': false,
            'capture': 'client',
          },
          'wake.start' => {
            'started': true,
            'capture': 'client',
            'sample_rate': 16000,
            'frame_length': 1280,
          },
          _ => {'ok': true},
        };
      }).transport,
    );
    addTearDown(controller.dispose);
    await controller.refreshStatus();
    log.clear();

    expect(await controller.startExplicit(sessionId: 's'), isTrue);

    final events = [...log, ...pcm.log];
    expect(log.first, 'wake.start');
    expect(pcm.log, ['prompt', 'capture']);
    expect(events, isNotEmpty);
  });

  test(
    'a host that refuses to arm never leads to a microphone prompt',
    () async {
      final log = <String>[];
      final pcm = _Pcm();
      final controller = GatewayWakeWordController(
        pcmSource: pcm,
        transport: _Gateway(log, (method, _) {
          return switch (method) {
            'wake.status' => {
              'available': true,
              'enabled': false,
              'listening': false,
              'capture': 'client',
            },
            'wake.start' => {'started': false, 'reason': 'owned'},
            _ => {'ok': true},
          };
        }).transport,
      );
      addTearDown(controller.dispose);
      await controller.refreshStatus();

      expect(await controller.startExplicit(sessionId: 's'), isFalse);
      expect(pcm.log, isEmpty);
      expect(controller.state.notice, isNotEmpty);
    },
  );

  test('a start the gateway does not serve (-32601) never prompts', () async {
    final log = <String>[];
    final pcm = _Pcm();
    final controller = GatewayWakeWordController(
      pcmSource: pcm,
      transport: _Gateway(log, (method, _) {
        if (method == 'wake.status') {
          return {'available': true, 'enabled': false, 'capture': 'client'};
        }
        return _unknownMethod(method);
      }).transport,
    );
    addTearDown(controller.dispose);
    await controller.refreshStatus();

    expect(await controller.startExplicit(sessionId: 's'), isFalse);
    expect(pcm.log, isEmpty);
    // The gateway proved it cannot arm: the toggle goes away.
    expect(controller.state.offered, isFalse);
  });
}
