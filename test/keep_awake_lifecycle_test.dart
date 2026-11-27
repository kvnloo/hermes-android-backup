// Keep-awake at the app root (review of 8d733edd, blocker 3): HermesApp takes
// the wake request while a turn runs, releases it when the turn ends, when
// the app goes to the background (paused) and on exit, and takes it again on
// resume while the turn is still running. A minimised desktop window (hidden)
// keeps it.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/keep_awake.dart';
import 'package:hermes_android/main.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Ares',
      packageName: 'com.hermesagent.hermes_android',
      version: '5.0.0-test',
      buildNumber: '5000',
      buildSignature: '',
    );
  });

  Future<void> lifecycle(
    WidgetTester tester,
    List<AppLifecycleState> steps,
  ) async {
    for (final state in steps) {
      tester.binding.handleAppLifecycleStateChanged(state);
      await tester.pump();
    }
  }

  testWidgets('whileWorking: turn start takes it, background releases, resume '
      're-takes, minimise keeps, turn end and exit release', (tester) async {
    final awake = <bool>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(MethodChannelKeepAwakeAdapter.channel, (
      call,
    ) async {
      if (call.method == 'isSupported') return true;
      if (call.method == 'setAwake') {
        awake.add((call.arguments as Map)['enabled'] as bool);
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(
        MethodChannelKeepAwakeAdapter.channel,
        null,
      ),
    );
    SharedPreferences.setMockInitialValues(<String, Object>{
      KeepAwakePolicyStore.preferenceKey: KeepAwakeMode.whileWorking.name,
    });
    final prefs = await SharedPreferences.getInstance();
    await NextGenPreferences.setEnabled(prefs, false);
    addTearDown(() => nextGenTurnActive.value = false);

    await tester.pumpWidget(HermesApp(connManager: ConnectionManager(prefs)));
    await tester.pumpAndSettle();
    expect(awake, isEmpty, reason: 'idle: nothing to keep awake for');

    nextGenTurnActive.value = true;
    await tester.pump();
    expect(awake, [true]);

    // Phone/tablet background: inactive -> hidden -> paused.
    await lifecycle(tester, const [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
    ]);
    expect(awake, [true], reason: 'a minimised desktop window keeps it');
    await lifecycle(tester, const [AppLifecycleState.paused]);
    expect(awake, [true, false]);

    // Resume while the turn still runs takes it again.
    await lifecycle(tester, const [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]);
    expect(awake, [true, false, true]);

    // The turn ends (finished, failed or cancelled all clear the flag).
    nextGenTurnActive.value = false;
    await tester.pump();
    expect(awake, [true, false, true, false]);

    // Another turn, then the app goes away.
    nextGenTurnActive.value = true;
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(awake, [true, false, true, false, true, false]);
    expect(KeepAwakePolicyStore(prefs).read(), KeepAwakeMode.whileWorking);
  });
}
