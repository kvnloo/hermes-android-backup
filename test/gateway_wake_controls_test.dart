// Focused rendering tests for the shared wake controls used by both layouts.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/gateway_wake_word.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/gateway_wake_controls.dart';

class _HarnessTransport {
  final events = StreamController<StreamEvent>.broadcast();
  final ready = StreamController<void>.broadcast();
  final calls = <String>[];
  Map<String, dynamic> status = const {
    'available': true,
    'enabled': false,
    'listening': false,
  };

  GatewayWakeTransport get transport => GatewayWakeTransport(
    connectionId: 'controls-test',
    profile: null,
    events: events.stream,
    ready: ready.stream,
    isConnected: () => true,
    call: (method, params, {timeout = const Duration(seconds: 30)}) async {
      calls.add(method);
      if (method == 'wake.status') return status;
      if (method == 'wake.start') {
        return {'started': true, 'phrase': 'hey hermes'};
      }
      return {'ok': true};
    },
  );

  void dispose() {
    events.close();
    ready.close();
  }
}

class _SilentPcmSource implements WakeClientPcmSource {
  @override
  Future<bool> hasPermission({bool request = false}) async => true;
  @override
  Future<List<WakeClientInputDevice>> listInputDevices() async => const [];
  @override
  Future<WakeClientPcmSession> startStream({
    required int sampleRate,
    WakeClientInputDevice? device,
  }) async => _NoFrames();
}

class _NoFrames implements WakeClientPcmSession {
  final _controller = StreamController<int>();
  @override
  Stream<Uint8List> get pcmInt16Le => const Stream<Uint8List>.empty();
  @override
  Future<void> stop() async => _controller.close();
}

void main() {
  testWidgets(
    'the wake toggle is opt-in and a tap persists an explicit start',
    (tester) async {
      final gateway = _HarnessTransport();
      final controller = GatewayWakeWordController(
        transport: gateway.transport,
        pcmSource: _SilentPcmSource(),
      );
      addTearDown(() {
        controller.dispose();
        gateway.dispose();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GatewayWakeToolbarButton(
              controller: controller,
              sessionId: 'session-1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.state.listening, isFalse);
      expect(find.byKey(const ValueKey('gateway-wake-toggle')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('gateway-wake-toggle')));
      await tester.pumpAndSettle();

      expect(gateway.calls, contains('wake.start'));
      expect(controller.state.listening, isTrue);
    },
  );

  testWidgets('the listening banner announces the phrase and can stop', (
    tester,
  ) async {
    final gateway = _HarnessTransport()
      ..status = const {
        'available': true,
        'enabled': true,
        'listening': true,
        'phrase': 'hey hermes',
      };
    final controller = GatewayWakeWordController(
      transport: gateway.transport,
      pcmSource: _SilentPcmSource(),
    );
    addTearDown(() {
      controller.dispose();
      gateway.dispose();
    });
    await controller.refreshStatus();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GatewayWakeListeningBanner(
            controller: controller,
            available: 600,
            sessionId: 'session-1',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('hey hermes'), findsWidgets);
    expect(find.text('Stop wake word'), findsOneWidget);
  });

  testWidgets('the narrow-pane menu exposes the wake tool', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PopupMenuButton<String>(
            key: const ValueKey('chat-tools-menu'),
            itemBuilder: (context) => [
              wakeWordToolItem(context, const GatewayWakeState()),
            ],
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('chat-tools-menu')));
    await tester.pumpAndSettle();

    expect(wakeWordToolValue, 'gateway-wake-word');
    expect(
      find.ancestor(
        of: find.textContaining('Wake word'),
        matching: find.byType(PopupMenuItem<String>),
      ),
      findsOneWidget,
    );
  });
}
