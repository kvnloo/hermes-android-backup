// Focused contract tests for the gateway-backed wake-word controller.
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/gateway_wake_word.dart';
import 'package:hermes_android/core/services/ws_client.dart';

class _Call {
  _Call(this.method, this.params);
  final String method;
  final Map<String, dynamic> params;
}

class _FakeTransport {
  _FakeTransport({this.status = const <String, dynamic>{}})
    : startResult = const {'started': true, 'phrase': 'hey hermes'},
      events = StreamController<StreamEvent>.broadcast(),
      ready = StreamController<void>.broadcast();

  Map<String, dynamic> status;
  Map<String, dynamic> startResult;
  final StreamController<StreamEvent> events;
  final StreamController<void> ready;
  final calls = <_Call>[];

  List<_Call> callsTo(String method) =>
      calls.where((call) => call.method == method).toList();

  GatewayWakeTransport get transport => GatewayWakeTransport(
    connectionId: 'test-connection',
    profile: 'fixture-profile',
    events: events.stream,
    ready: ready.stream,
    isConnected: () => true,
    call: (method, params, {timeout = const Duration(seconds: 30)}) async {
      calls.add(_Call(method, params));
      return switch (method) {
        'wake.status' => status,
        'wake.start' => startResult,
        'wake.feed' => {'fed': true},
        _ => {'ok': true},
      };
    },
  );

  void dispose() {
    events.close();
    ready.close();
  }
}

class _FakeSession implements WakeClientPcmSession {
  _FakeSession(this._pcm);
  final Stream<Uint8List> _pcm;

  @override
  Stream<Uint8List> get pcmInt16Le => _pcm;

  var stopped = false;
  @override
  Future<void> stop() async => stopped = true;
}

class _FakePcmSource implements WakeClientPcmSource {
  final pcm = StreamController<Uint8List>.broadcast();
  final starts = <int>[];
  var granted = true;
  _FakeSession? session;

  @override
  Future<bool> hasPermission({bool request = false}) async => granted;

  @override
  Future<List<WakeClientInputDevice>> listInputDevices() async => const [
    WakeClientInputDevice(id: 'mic-1', label: 'Fixture microphone'),
  ];

  @override
  Future<WakeClientPcmSession> startStream({
    required int sampleRate,
    WakeClientInputDevice? device,
  }) async {
    starts.add(sampleRate);
    session = _FakeSession(pcm.stream);
    return session!;
  }

  void emitFrame(Uint8List bytes) => pcm.add(bytes);

  void dispose() => pcm.close();
}

GatewayWakeWordController _controller(
  _FakeTransport transport,
  _FakePcmSource pcm,
) {
  return GatewayWakeWordController(
    transport: transport.transport,
    pcmSource: pcm,
    wakeStartTimeout: const Duration(seconds: 1),
    stallTimeout: const Duration(seconds: 30),
  );
}

Uint8List _loudFrame(int sampleCount) {
  final bytes = ByteData(sampleCount * 2);
  for (var i = 0; i < sampleCount; i++) {
    bytes.setInt16(i * 2, i.isEven ? 1000 : -1000, Endian.little);
  }
  return bytes.buffer.asUint8List();
}

void main() {
  tearDown(() async {
    // Controllers dispose their fakes; nothing here touches real credentials.
    await Future<void>.delayed(Duration.zero);
  });

  test('refusal codes carry Desktop wording, including the owning surface', () {
    expect(formatWakeRefusalReason('unavailable'), contains('unavailable'));
    expect(formatWakeRefusalReason('disabled'), contains('tap to enable'));
    expect(
      formatWakeRefusalReason('disabled_for_surface'),
      contains('another surface'),
    );
    expect(
      formatWakeRefusalReason('owned', ownerSurface: 'cli'),
      contains('cli'),
    );
    expect(formatWakeRefusalReason(null), isEmpty);
  });

  test(
    'explicit start persists, is scoped to the profile and session, and arms',
    () async {
      // The host says the wake word can run here (the toggle is offered).
      final gateway = _FakeTransport(status: const {'available': true});
      final pcm = _FakePcmSource();
      final controller = _controller(gateway, pcm);
      addTearDown(() {
        controller.dispose();
        gateway.dispose();
        pcm.dispose();
      });
      controller.bindSessionId('session-1');
      await controller.refreshStatus();

      expect(await controller.startExplicit(), isTrue);
      final start = gateway.callsTo('wake.start').single;
      expect(start.params['persist'], isTrue);
      expect(start.params['surface'], 'gui');
      expect(start.params['client_capture'], isTrue);
      expect(start.params['profile'], 'fixture-profile');
      expect(start.params['session_id'], 'session-1');
      expect(controller.state.listening, isTrue);
      expect(controller.state.notice, isEmpty);

      expect(await controller.stopExplicit(), isTrue);
      final stop = gateway.callsTo('wake.stop').last;
      expect(stop.params['persist'], isTrue);
      expect(controller.state.listening, isFalse);
    },
  );

  test(
    'status refresh never persists and surfaces a gateway refusal',
    () async {
      final gateway = _FakeTransport(
        status: const {
          'available': false,
          'enabled': false,
          'listening': false,
          'reason': 'owned',
          'owner_surface': 'cli',
        },
      );
      final pcm = _FakePcmSource();
      final controller = _controller(gateway, pcm);
      addTearDown(() {
        controller.dispose();
        gateway.dispose();
        pcm.dispose();
      });

      final state = await controller.refreshStatus();
      expect(state.available, isFalse);
      expect(state.listening, isFalse);
      expect(state.notice, contains('cli'));
      final statuses = gateway.callsTo('wake.status');
      expect(statuses, isNotEmpty);
      for (final status in statuses) {
        expect(status.params.containsKey('persist'), isFalse);
        expect(status.params['surface'], 'gui');
      }
      expect(gateway.callsTo('wake.start'), isEmpty);
    },
  );

  test(
    'foreground and voice activity pause and resume without persisting',
    () async {
      final gateway = _FakeTransport(
        status: const {'available': true, 'enabled': true, 'listening': true},
      );
      final pcm = _FakePcmSource();
      final controller = _controller(gateway, pcm);
      addTearDown(() {
        controller.dispose();
        gateway.dispose();
        pcm.dispose();
      });
      await controller.refreshStatus();

      await controller.pauseForVoice();
      expect(controller.state.paused, isTrue);
      expect(controller.state.listening, isFalse);
      expect(
        gateway.callsTo('wake.pause').single.params.containsKey('persist'),
        isFalse,
      );
      expect(pcm.starts, isEmpty); // host capture: no client mic is opened

      controller.setPausedForVoice(false);
      expect(gateway.callsTo('wake.resume'), hasLength(1));
      expect(
        gateway.callsTo('wake.resume').single.params.containsKey('persist'),
        isFalse,
      );

      controller.setAppForeground(false);
      expect(controller.state.paused, isTrue);
      controller.setAppForeground(true);
      expect(gateway.callsTo('wake.resume'), hasLength(2));
    },
  );

  test('a wake event reports the phrase and stops capture', () async {
    final gateway = _FakeTransport(
      status: const {
        'available': true,
        'enabled': true,
        'listening': true,
        'capture': 'client',
        'sample_rate': 16000,
        'frame_length': 1280,
      },
    );
    final pcm = _FakePcmSource();
    WakeDetectedEvent? detected;
    final controller = GatewayWakeWordController(
      transport: gateway.transport,
      pcmSource: pcm,
      onWakeDetected: (event) => detected = event,
    );
    addTearDown(() {
      controller.dispose();
      gateway.dispose();
      pcm.dispose();
    });
    await controller.refreshStatus();
    await controller.pauseForVoice();
    controller.setPausedForVoice(false);
    await Future<void>.delayed(Duration.zero);

    expect(pcm.starts, isNotEmpty);
    expect(pcm.starts, everyElement(16000));
    expect(controller.state.clientCaptureActive, isTrue);
    gateway.events.add(
      StreamEvent(
        type: 'wake.detected',
        data: {'phrase': 'hey hermes', 'start_new_session': false},
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(detected?.phrase, 'hey hermes');
    expect(detected?.startNewSession, isFalse);
    expect(controller.state.clientCaptureActive, isFalse);
    expect(controller.state.paused, isTrue);
    expect(pcm.session?.stopped, isTrue);
  });

  test('remote capture streams 16 kHz frames through wake.feed', () async {
    final gateway = _FakeTransport(
      status: const {
        'available': true,
        'enabled': true,
        'listening': true,
        'capture': 'remote',
        'sample_rate': 16000,
        'frame_length': 1280,
      },
    );
    final pcm = _FakePcmSource();
    final controller = _controller(gateway, pcm);
    addTearDown(() {
      controller.dispose();
      gateway.dispose();
      pcm.dispose();
    });
    await controller.refreshStatus();
    await Future<void>.delayed(Duration.zero);

    expect(pcm.starts, [16000]);
    final frame = _loudFrame(1280);
    pcm.emitFrame(frame);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final feeds = gateway.callsTo('wake.feed');
    expect(feeds, isNotEmpty);
    expect(feeds.first.params['sample_rate'], 16000);
    expect(base64.decode(feeds.first.params['pcm'] as String), equals(frame));
    final feed = feeds.first.params;
    expect(feed.containsKey('persist'), isFalse);
    expect(feed.containsKey('surface'), isFalse);
  });

  test(
    'permission denial leaves wake off and never opens the microphone',
    () async {
      // The host is asked first and the permission only once it armed client
      // capture (Desktop's order, review K1); a refusal then undoes the
      // saved enable, so wake stays off.
      final gateway = _FakeTransport(
        status: const {'available': true, 'enabled': false},
      )..startResult = const {'started': true, 'capture': 'client'};
      final pcm = _FakePcmSource()..granted = false;
      final controller = _controller(gateway, pcm);
      addTearDown(() {
        controller.dispose();
        gateway.dispose();
        pcm.dispose();
      });
      await controller.refreshStatus();

      expect(await controller.startExplicit(), isFalse);
      expect(gateway.callsTo('wake.start'), hasLength(1));
      expect(gateway.callsTo('wake.stop').last.params['persist'], isTrue);
      expect(pcm.starts, isEmpty);
      expect(controller.state.listening, isFalse);
      expect(controller.state.enabled, isFalse);
      expect(controller.state.notice, contains('Microphone'));
    },
  );

  test('shared controllers are keyed by connection and removed on dispose', () {
    final gateway = _FakeTransport();
    final pcm = _FakePcmSource();
    final controller = _controller(gateway, pcm);
    expect(
      GatewayWakeWordController.sharedForConnection('test-connection'),
      same(controller),
    );
    controller.dispose();
    expect(
      GatewayWakeWordController.sharedForConnection('test-connection'),
      isNull,
    );
    gateway.dispose();
    pcm.dispose();
  });
}
