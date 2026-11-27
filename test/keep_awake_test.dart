import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/keep_awake.dart';
import 'package:hermes_android/core/services/system_sleep_gate.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    SystemSleepGate.instance.clear();
  });
  tearDown(SystemSleepGate.instance.clear);

  group('KeepAwakePolicyStore', () {
    test('defaults to off when unset', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = KeepAwakePolicyStore(prefs);
      expect(store.read(), KeepAwakeMode.off);
    });

    test('round-trips every mode', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = KeepAwakePolicyStore(prefs);
      for (final mode in KeepAwakeMode.values) {
        await store.write(mode);
        expect(prefs.getString(KeepAwakePolicyStore.preferenceKey), mode.name);
        expect(store.read(), mode);
      }
    });

    test('unknown values fall back to off without erasing storage', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(KeepAwakePolicyStore.preferenceKey, 'forever');
      final store = KeepAwakePolicyStore(prefs);
      expect(store.read(), KeepAwakeMode.off);
    });
  });

  group('KeepAwakeController', () {
    Future<KeepAwakePolicyStore> storeWith(KeepAwakeMode mode) async {
      final prefs = await SharedPreferences.getInstance();
      final store = KeepAwakePolicyStore(prefs);
      await store.write(mode);
      return store;
    }

    test('stays off when mode is off', () async {
      final calls = <bool>[];
      final controller = KeepAwakeController(
        adapter: _RecordingAdapter(calls),
        store: await storeWith(KeepAwakeMode.off),
      );
      controller.setWorking(true);
      expect(calls, isEmpty);
      controller.dispose();
      expect(calls, isEmpty);
    });

    test('whileWorking awakes only during a turn', () async {
      final calls = <bool>[];
      final controller = KeepAwakeController(
        adapter: _RecordingAdapter(calls),
        store: await storeWith(KeepAwakeMode.whileWorking),
      );
      controller.setWorking(true);
      controller.setWorking(false);
      expect(calls, [true, false]);
    });

    test('always awakes on refresh regardless of working flag', () async {
      final calls = <bool>[];
      final controller = KeepAwakeController(
        adapter: _RecordingAdapter(calls),
        store: await storeWith(KeepAwakeMode.always),
      );
      controller.setWorking(false);
      expect(calls.length, 1);
      expect(calls.last, isTrue);
    });

    test(
      'dispose releases the wake flag without touching the stored policy',
      () async {
        final calls = <bool>[];
        final policy = await storeWith(KeepAwakeMode.always);
        final controller = KeepAwakeController(
          adapter: _RecordingAdapter(calls),
          store: policy,
        );
        controller.dispose();
        expect(calls.isNotEmpty, isTrue);
        expect(calls.last, isFalse);
        expect(policy.read(), KeepAwakeMode.always);
      },
    );

    test('every way a turn ends releases whileWorking: finished, failed, '
        'cancelled', () async {
      final calls = <bool>[];
      final controller = KeepAwakeController(
        adapter: _RecordingAdapter(calls),
        store: await storeWith(KeepAwakeMode.whileWorking),
      );
      // The app root reports "no active turn" however the turn settled.
      for (final _ in ['finished', 'failed', 'cancelled']) {
        controller.setWorking(true);
        expect(controller.isAwake, isTrue);
        controller.setWorking(false);
        expect(controller.isAwake, isFalse);
      }
      expect(calls, [true, false, true, false, true, false]);
      controller.dispose();
    });

    test(
      'background releases and resume re-takes only while still wanted',
      () async {
        final calls = <bool>[];
        final controller = KeepAwakeController(
          adapter: _RecordingAdapter(calls),
          store: await storeWith(KeepAwakeMode.whileWorking),
        );
        controller.setWorking(true);
        controller.setBackground(true);
        expect(controller.isAwake, isFalse);
        controller.setBackground(false);
        expect(controller.isAwake, isTrue);
        // The turn ends while backgrounded: resume must not take it again.
        controller.setBackground(true);
        controller.setWorking(false);
        controller.setBackground(false);
        expect(controller.isAwake, isFalse);
        expect(calls, [true, false, true, false]);
        controller.dispose();
      },
    );

    test('always is released in the background too', () async {
      final calls = <bool>[];
      final controller = KeepAwakeController(
        adapter: _RecordingAdapter(calls),
        store: await storeWith(KeepAwakeMode.always),
      );
      controller.setBackground(true);
      controller.setBackground(false);
      expect(calls, [true, false, true]);
      controller.dispose();
    });

    test('a controller created in the background takes nothing', () async {
      final calls = <bool>[];
      final controller = KeepAwakeController(
        adapter: _RecordingAdapter(calls),
        store: await storeWith(KeepAwakeMode.always),
        background: true,
      );
      expect(calls, isEmpty);
      controller.setBackground(false);
      expect(calls, [true]);
      controller.dispose();
    });
  });

  group('KeepAwakeController across sleep and lock (PROBE-3)', () {
    final gate = SystemSleepGate.instance;

    Future<KeepAwakeController> controllerFor(
      KeepAwakeMode mode,
      List<bool> calls,
    ) async {
      final store = KeepAwakePolicyStore(await SharedPreferences.getInstance());
      await store.write(mode);
      final controller = KeepAwakeController(
        adapter: _RecordingAdapter(calls),
        store: store,
      );
      addTearDown(controller.dispose);
      return controller;
    }

    test('PROBE-3 a lock during a turn releases the request: the paused '
        'socket cannot see the turn end', () async {
      final calls = <bool>[];
      final controller = await controllerFor(KeepAwakeMode.whileWorking, calls);
      controller.setWorking(true); // a turn starts
      gate.apply(PowerEvent.lock); // the user locks and leaves
      await pumpEventQueue();
      expect(controller.isAwake, isFalse);
      expect(calls, [true, false]);
      // Sleeping as well changes nothing.
      gate.apply(PowerEvent.suspend);
      expect(calls, [true, false]);
    });

    test('the turn ended unseen: reconcile reports it and nothing is taken '
        'again', () async {
      final calls = <bool>[];
      final controller = await controllerFor(KeepAwakeMode.whileWorking, calls);
      final chat = Object();
      controller.setWorking(true);
      gate.apply(PowerEvent.suspend);
      gate.holdReconcile(chat);
      gate.apply(PowerEvent.resume);
      // Awake again, but the chat has not caught up: still released.
      expect(controller.isAwake, isFalse);
      // It catches up: the turn finished while the computer slept.
      controller.setWorking(false);
      gate.releaseReconcile(chat);
      expect(controller.isAwake, isFalse);
      expect(calls, [true, false]);
    });

    test('the turn still runs after reconcile: taken again then', () async {
      final calls = <bool>[];
      final controller = await controllerFor(KeepAwakeMode.whileWorking, calls);
      final chat = Object();
      controller.setWorking(true);
      gate.apply(PowerEvent.lock);
      gate.holdReconcile(chat);
      gate.apply(PowerEvent.unlock);
      // A stale "still working" report before the chat caught up does not
      // take it (the app's turn state has not changed).
      controller.setWorking(true);
      expect(controller.isAwake, isFalse);
      gate.releaseReconcile(chat);
      expect(controller.isAwake, isTrue);
      expect(calls, [true, false, true]);
    });

    test(
      'with no turn running, a pause reconciles as soon as it lifts',
      () async {
        final calls = <bool>[];
        final controller = await controllerFor(
          KeepAwakeMode.whileWorking,
          calls,
        );
        var reconciled = 0;
        void count() => reconciled++;
        gate.reconciled.addListener(count);
        addTearDown(() => gate.reconciled.removeListener(count));
        gate.apply(PowerEvent.lock);
        gate.apply(PowerEvent.unlock);
        expect(reconciled, 1);
        controller.setWorking(true);
        expect(calls, [true]);
      },
    );

    test('a turn seen to end and a new one to start after the pause need '
        'no reconcile', () async {
      final calls = <bool>[];
      final controller = await controllerFor(KeepAwakeMode.whileWorking, calls);
      final stuck = Object(); // never catches up (its socket stays down)
      controller.setWorking(true);
      gate.apply(PowerEvent.lock);
      gate.holdReconcile(stuck);
      gate.noteUserActivity();
      expect(controller.isAwake, isFalse);
      controller.setWorking(false);
      controller.setWorking(true);
      expect(controller.isAwake, isTrue);
      expect(calls, [true, false, true]);
      gate.releaseReconcile(stuck);
    });

    test('always is released while paused and taken again on wake', () async {
      final calls = <bool>[];
      final controller = await controllerFor(KeepAwakeMode.always, calls);
      expect(controller.isAwake, isTrue);
      gate.apply(PowerEvent.suspend);
      expect(controller.isAwake, isFalse);
      gate.apply(PowerEvent.resume);
      expect(controller.isAwake, isTrue);
      expect(calls, [true, false, true]);
    });

    test('a controller created while locked takes nothing until the pause '
        'lifts', () async {
      gate.apply(PowerEvent.lock);
      final calls = <bool>[];
      final controller = await controllerFor(KeepAwakeMode.always, calls);
      expect(calls, isEmpty);
      gate.apply(PowerEvent.unlock);
      expect(calls, [true]);
      controller.dispose();
      expect(calls, [true, false]);
      // Disposed: later gate changes do nothing.
      gate.apply(PowerEvent.lock);
      gate.apply(PowerEvent.unlock);
      expect(calls, [true, false]);
    });

    test('an owner that holds outside a pause is ignored', () {
      gate.holdReconcile(Object());
      expect(gate.reconcilePending, 0);
    });
  });
}

class _RecordingAdapter implements KeepAwakeAdapter {
  _RecordingAdapter(this.calls);

  final List<bool> calls;

  @override
  void setAwake({required String owner, required bool enabled}) {
    calls.add(enabled);
  }
}
