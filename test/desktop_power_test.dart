import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/desktop/desktop_os.dart';
import 'package:hermes_android/core/desktop/power_events.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/keep_awake.dart';
import 'package:hermes_android/core/services/system_sleep_gate.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A loopback gateway: hands out tickets, accepts sockets, answers every
/// request, and records socket opens/closes and every method it receives.
class _Gateway {
  _Gateway._(this.server);

  final HttpServer server;
  final methods = <String>[];
  int opened = 0;
  int closed = 0;
  int ticketRequests = 0;
  int upgradeRequests = 0;

  /// Holds the ws-ticket answer, or the WebSocket upgrade, until completed.
  Completer<void>? holdTicket;
  Completer<void>? holdUpgrade;
  final _changes = StreamController<void>.broadcast();

  String get baseUrl => 'http://127.0.0.1:${server.port}';
  int get live => opened - closed;
  int get promptSubmissions =>
      methods.where((m) => m.contains('prompt')).length;

  static Future<_Gateway> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final gateway = _Gateway._(server);
    server.listen((req) async {
      if (req.uri.path == '/api/ws' &&
          WebSocketTransformer.isUpgradeRequest(req)) {
        gateway.upgradeRequests++;
        gateway._changes.add(null);
        final upgrade = gateway.holdUpgrade;
        if (upgrade != null) await upgrade.future;
        final ws = await WebSocketTransformer.upgrade(
          req,
          protocolSelector: (protocols) =>
              protocols.contains('hermes-gateway-v1')
              ? 'hermes-gateway-v1'
              : null,
        );
        gateway.opened++;
        gateway._changes.add(null);
        ws.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'method': 'event',
            'params': {
              'type': 'gateway.ready',
              'payload': {
                'protocol': {'name': 'hermes-jsonrpc', 'major': 2},
              },
            },
          }),
        );
        ws.listen(
          (raw) {
            final msg = jsonDecode(raw as String) as Map<String, dynamic>;
            final method = msg['method'] as String?;
            if (method != null) gateway.methods.add(method);
            gateway._changes.add(null);
            if (msg.containsKey('id')) {
              ws.add(
                jsonEncode({
                  'jsonrpc': '2.0',
                  'id': msg['id'],
                  'result': switch (method) {
                    'session.resume' || 'session.create' => {
                      'session_id': 'rt-alpha',
                      'stored_session_id': 's-alpha',
                    },
                    _ => <String, Object>{},
                  },
                }),
              );
            }
          },
          onDone: () {
            gateway.closed++;
            gateway._changes.add(null);
          },
        );
        return;
      }
      if (req.uri.path == '/api/auth/ws-ticket') {
        gateway.ticketRequests++;
        gateway._changes.add(null);
        final ticket = gateway.holdTicket;
        if (ticket != null) await ticket.future;
      }
      req.response.headers.contentType = ContentType.json;
      req.response.write(
        jsonEncode(
          req.uri.path == '/api/auth/ws-ticket'
              ? {'ticket': 'fixture-ws-ticket'}
              : <String, Object>{},
        ),
      );
      await req.response.close();
    });
    return gateway;
  }

  /// Waits (real time) until [condition] holds.
  Future<void> until(bool Function() condition) async {
    final deadline = DateTime.now().add(const Duration(seconds: 10));
    while (!condition()) {
      if (DateTime.now().isAfter(deadline)) {
        throw TimeoutException('gateway condition not met');
      }
      await Future.any([
        _changes.stream.first,
        Future<void>.delayed(const Duration(milliseconds: 50)),
      ]);
    }
  }

  SavedConnection connection() => SavedConnection(
    id: 'power-fixture',
    label: 'Power fixture',
    host: '127.0.0.1',
    port: server.port,
    dashboardPortOverride: server.port,
    dashboardProxied: true,
    apiKey: '',
    desktopGatewayUrl: baseUrl,
    singleLogin: true,
    signInMethod: 'none',
  );

  Future<void> close() async {
    await server.close(force: true);
    await _changes.close();
  }
}

const _power = MethodChannel('test/desktop_power');

Future<void> _send(String method, Object? arguments) =>
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          _power.name,
          const StandardMethodCodec().encodeMethodCall(
            MethodCall(method, arguments),
          ),
          (_) {},
        );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SystemSleepGate.instance.clear();
  });
  tearDown(SystemSleepGate.instance.clear);

  group('SystemSleepGate', () {
    test('pauses for sleep or lock and lifts only when both clear', () {
      final gate = SystemSleepGate.instance;
      var changes = 0;
      void count() => changes++;
      gate.addListener(count);
      addTearDown(() => gate.removeListener(count));
      expect(gate.value, isFalse);
      gate.apply(PowerEvent.lock);
      gate.apply(PowerEvent.suspend);
      expect(gate.value, isTrue);
      gate.apply(PowerEvent.resume);
      // Woke onto the lock screen: still paused.
      expect(gate.value, isTrue);
      gate.apply(PowerEvent.unlock);
      expect(gate.value, isFalse);
      // A second resume or unlock changes nothing.
      gate.apply(PowerEvent.resume);
      gate.apply(PowerEvent.unlock);
      expect(changes, 2);
    });
  });

  group('a lock with no matching unlock (PROBE-2)', () {
    // logind sends Session.Lock for `loginctl lock-session` and IdleAction,
    // but Unlock only for `loginctl unlock-session`: swaylock and i3lock
    // unlock locally. The pause must not outlive the user's return.
    test('app focus, pointer and key input lift the pause', () async {
      final listener = PowerEventsListener(channel: _power)..start();
      addTearDown(listener.dispose);
      final gate = SystemSleepGate.instance;
      final binding = TestWidgetsFlutterBinding.instance;

      await _send('onPowerEvent', 'lock');
      expect(gate.value, isTrue);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      expect(gate.value, isTrue, reason: 'losing focus is not a return');
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      expect(gate.value, isFalse, reason: 'the window regained focus');

      await _send('onPowerEvent', 'lock');
      await _send('onPowerEvent', 'suspend');
      binding.handlePointerEvent(const PointerHoverEvent());
      expect(gate.value, isTrue, reason: 'hover is not input');
      binding.handlePointerEvent(const PointerDownEvent());
      binding.handlePointerEvent(const PointerUpEvent());
      expect(gate.value, isFalse);
      expect(gate.suspended, isFalse);

      await _send('onPowerEvent', 'lock');
      await simulateKeyDownEvent(LogicalKeyboardKey.keyA);
      await simulateKeyUpEvent(LogicalKeyboardKey.keyA);
      expect(gate.value, isFalse);
    });

    test('a resume re-reads the lock state from the runner', () async {
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      bool? locked = true;
      var asked = 0;
      messenger.setMockMethodCallHandler(_power, (call) async {
        if (call.method != 'isLocked') return null;
        asked++;
        return locked;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(_power, null));
      final listener = PowerEventsListener(channel: _power)..start();
      addTearDown(listener.dispose);
      final gate = SystemSleepGate.instance;

      await _send('onPowerEvent', 'lock');
      await _send('onPowerEvent', 'suspend');
      await _send('onPowerEvent', 'resume');
      await pumpEventQueue();
      expect(asked, 1);
      expect(gate.value, isTrue, reason: 'still on the lock screen');

      await _send('onPowerEvent', 'suspend');
      locked = null; // A runner that cannot tell keeps the pause.
      await _send('onPowerEvent', 'resume');
      await pumpEventQueue();
      expect(asked, 2);
      expect(gate.value, isTrue);

      await _send('onPowerEvent', 'suspend');
      locked = false; // Unlocked locally while asleep: no unlock event.
      await _send('onPowerEvent', 'resume');
      await pumpEventQueue();
      expect(asked, 3);
      expect(gate.value, isFalse);
    });

    test('a runner without isLocked degrades to the activity check', () async {
      final listener = PowerEventsListener(channel: _power)..start();
      addTearDown(listener.dispose);
      await _send('onPowerEvent', 'lock');
      await _send('onPowerEvent', 'resume');
      await pumpEventQueue();
      expect(SystemSleepGate.instance.value, isTrue);
      SystemSleepGate.instance.noteUserActivity();
      expect(SystemSleepGate.instance.value, isFalse);
    });

    test('dispose stops watching activity and drops the probe', () async {
      final listener = PowerEventsListener(channel: _power)..start();
      expect(SystemSleepGate.instance.lockProbe, isNotNull);
      listener.dispose();
      expect(SystemSleepGate.instance.lockProbe, isNull);
      SystemSleepGate.instance.apply(PowerEvent.lock);
      TestWidgetsFlutterBinding.instance.handlePointerEvent(
        const PointerDownEvent(),
      );
      expect(SystemSleepGate.instance.value, isTrue);
    });
  });

  group('PowerEventsListener', () {
    test('feeds runner events into the gate and ignores others', () async {
      final listener = PowerEventsListener(channel: _power)..start();
      await _send('onPowerEvent', 'suspend');
      expect(SystemSleepGate.instance.suspended, isTrue);
      await _send('onPowerEvent', 'hibernate');
      await _send('onPowerEvent', 7);
      await _send('onTrayAction', 'resume');
      expect(SystemSleepGate.instance.suspended, isTrue);
      await _send('onPowerEvent', 'resume');
      await _send('onPowerEvent', 'lock');
      expect(SystemSleepGate.instance.value, isTrue);
      // Shutting down lifts the pause: no runner is left to report a wake.
      listener.dispose();
      expect(SystemSleepGate.instance.value, isFalse);
      await _send('onPowerEvent', 'suspend');
      expect(SystemSleepGate.instance.value, isFalse);
    });

    test(
      'keep-awake requests and power events share the runner channel',
      () async {
        const channel = MethodChannelKeepAwakeAdapter.channel;
        expect(channel.name, DesktopOsChannels.power.name);
        final calls = <MethodCall>[];
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        messenger.setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return call.method == 'isSupported' ? true : null;
        });
        addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
        final listener = PowerEventsListener()..start();
        addTearDown(listener.dispose);

        final store = KeepAwakePolicyStore(
          await SharedPreferences.getInstance(),
        );
        await store.write(KeepAwakeMode.whileWorking);
        final controller = KeepAwakeController(
          adapter: const MethodChannelKeepAwakeAdapter(),
          store: store,
        );
        expect(await isKeepAwakeChannelSupported(channel), isTrue);
        controller.setWorking(true);
        await pumpEventQueue();
        // A runner event arrives on the same channel while a turn runs.
        await messenger.handlePlatformMessage(
          channel.name,
          const StandardMethodCodec().encodeMethodCall(
            MethodCall('onPowerEvent', 'lock'),
          ),
          (_) {},
        );
        expect(SystemSleepGate.instance.locked, isTrue);
        controller.setWorking(false);
        controller.dispose();
        await pumpEventQueue();
        final awake = calls.where((c) => c.method == 'setAwake').toList();
        expect(awake.map((c) => (c.arguments as Map)['enabled']), [
          true,
          false,
        ]);
      },
    );
  });

  group('gateway sockets', () {
    // The test binding answers every HTTP request with 400; these tests use
    // a real loopback gateway instead.
    HttpOverrides? previous;
    setUpAll(() {
      previous = HttpOverrides.current;
      HttpOverrides.global = null;
    });
    tearDownAll(() => HttpOverrides.global = previous);

    test(
      'NextGen stops on sleep, reconnects on wake, sends nothing again',
      () async {
        final gateway = await _Gateway.start();
        addTearDown(gateway.close);
        final ng = NextGenGateway(gateway.connection());
        addTearDown(ng.dispose);
        var reconnects = 0;
        final sub = ng.reconnected.listen((_) => reconnects++);
        addTearDown(sub.cancel);
        ng.start();
        await gateway.until(() => gateway.live == 1);
        await _waitFor(() => ng.state.phase == NgConnectionPhase.connected);
        expect(reconnects, 1);

        SystemSleepGate.instance.apply(PowerEvent.suspend);
        await gateway.until(() => gateway.live == 0);
        expect(ng.state.phase, NgConnectionPhase.idle);
        expect(ng.socket, isNull);
        // Nothing redials while asleep, even when asked.
        ng.start();
        await Future<void>.delayed(const Duration(milliseconds: 300));
        expect(gateway.opened, 1);

        SystemSleepGate.instance.apply(PowerEvent.resume);
        await gateway.until(() => gateway.live == 1 && gateway.opened == 2);
        await _waitFor(() => ng.state.phase == NgConnectionPhase.connected);
        expect(reconnects, 2);
        expect(gateway.promptSubmissions, 0);
      },
    );

    test(
      'a NextGen socket the user stopped stays stopped after wake',
      () async {
        final gateway = await _Gateway.start();
        addTearDown(gateway.close);
        final ng = NextGenGateway(gateway.connection());
        addTearDown(ng.dispose);
        ng.start();
        await gateway.until(() => gateway.live == 1);
        SystemSleepGate.instance.apply(PowerEvent.lock);
        await gateway.until(() => gateway.live == 0);
        ng.stop();
        SystemSleepGate.instance.apply(PowerEvent.unlock);
        await Future<void>.delayed(const Duration(milliseconds: 300));
        expect(gateway.opened, 1);
      },
    );

    test(
      'Classic client closes on lock, re-binds stored chats on unlock',
      () async {
        final gateway = await _Gateway.start();
        addTearDown(gateway.close);
        final client = DesktopGatewayClient.fromConnection(
          gateway.connection(),
        );
        addTearDown(client.close);
        final states = <DesktopConnectionState>[];
        client.setConnectionListener(states.add);
        client.bindStoredSession('local-alpha', 's-alpha');
        await client.call('projects.list', {});
        expect(gateway.live, 1);

        SystemSleepGate.instance.apply(PowerEvent.lock);
        await gateway.until(() => gateway.live == 0);
        expect(states.last, DesktopConnectionState.disconnected);
        // Calls fail fast instead of dialling while locked.
        await expectLater(
          client.call('projects.list', {}),
          throwsA(isA<StateError>()),
        );
        await Future<void>.delayed(const Duration(milliseconds: 300));
        expect(gateway.opened, 1);

        final before = gateway.methods.length;
        SystemSleepGate.instance.apply(PowerEvent.unlock);
        await gateway.until(() => gateway.live == 1 && gateway.opened == 2);
        await gateway.until(
          () => gateway.methods.skip(before).contains('session.resume'),
        );
        expect(states.last, DesktopConnectionState.connected);
        expect(gateway.promptSubmissions, 0);
      },
    );

    test('PROBE-2 a lock with no matching unlock, then app activity: Classic '
        'and NextGen resume without resending anything', () async {
      final gateway = await _Gateway.start();
      addTearDown(gateway.close);
      final listener = PowerEventsListener(channel: _power)..start();
      addTearDown(listener.dispose);
      final ng = NextGenGateway(gateway.connection());
      addTearDown(ng.dispose);
      final client = DesktopGatewayClient.fromConnection(gateway.connection());
      addTearDown(client.close);
      ng.start();
      await _waitFor(() => ng.state.phase == NgConnectionPhase.connected);
      client.bindStoredSession('local-alpha', 's-alpha');
      await client.call('projects.list', {});
      await gateway.until(() => gateway.live == 2);
      final openedBefore = gateway.opened;

      // logind Lock request; the locker unlocks locally and never says so.
      await _send('onPowerEvent', 'lock');
      await _send('onPowerEvent', 'suspend');
      await _send('onPowerEvent', 'resume');
      await gateway.until(() => gateway.live == 0);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(SystemSleepGate.instance.value, isTrue);
      expect(gateway.opened, openedBefore);

      // The user is back in the window.
      final methodsBefore = gateway.methods.length;
      TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      );
      expect(SystemSleepGate.instance.value, isFalse);
      await gateway.until(() => gateway.live == 2);
      await _waitFor(() => ng.state.phase == NgConnectionPhase.connected);
      await gateway.until(
        () => gateway.methods.skip(methodsBefore).contains('session.resume'),
      );
      await client.call('projects.list', {});
      expect(gateway.promptSubmissions, 0);
    });

    for (final stage in ['ticket', 'upgrade']) {
      test('PROBE-1 a Classic dial in flight when the lock lands (held at the '
          '$stage) leaves no live socket during the pause and reconnects on '
          'unlock', () async {
        final gateway = await _Gateway.start();
        addTearDown(gateway.close);
        final client = DesktopGatewayClient.fromConnection(
          gateway.connection(),
        );
        addTearDown(client.close);
        final hold = Completer<void>();
        if (stage == 'ticket') {
          gateway.holdTicket = hold;
        } else {
          gateway.holdUpgrade = hold;
        }
        final call = client.call('projects.list', {});
        await gateway.until(
          () => stage == 'ticket'
              ? gateway.ticketRequests == 1
              : gateway.upgradeRequests == 1,
        );
        // The session locks while the dial is outstanding.
        SystemSleepGate.instance.apply(PowerEvent.lock);
        gateway.holdTicket = null;
        gateway.holdUpgrade = null;
        hold.complete();
        await expectLater(call, throwsA(isA<StateError>()));
        await Future<void>.delayed(const Duration(milliseconds: 300));
        expect(SystemSleepGate.instance.value, isTrue);
        await gateway.until(() => gateway.live == 0);
        expect(gateway.live, 0, reason: 'no live socket while locked');
        final openedDuringPause = gateway.opened;

        // The dial was live intent: the unlock reconnects on its own.
        SystemSleepGate.instance.apply(PowerEvent.unlock);
        await gateway.until(
          () => gateway.live == 1 && gateway.opened == openedDuringPause + 1,
        );
        await client.call('projects.list', {});
        expect(gateway.promptSubmissions, 0);
      });
    }

    test(
      'an idle Classic client stays idle on wake and dials lazily',
      () async {
        final gateway = await _Gateway.start();
        addTearDown(gateway.close);
        final client = DesktopGatewayClient.fromConnection(
          gateway.connection(),
        );
        addTearDown(client.close);
        SystemSleepGate.instance.apply(PowerEvent.suspend);
        SystemSleepGate.instance.apply(PowerEvent.resume);
        await Future<void>.delayed(const Duration(milliseconds: 300));
        expect(gateway.opened, 0);
        await client.call('projects.list', {});
        expect(gateway.opened, 1);
      },
    );
  });
}

Future<void> _waitFor(bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 10));
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('condition not met');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}
