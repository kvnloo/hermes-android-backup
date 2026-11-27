// The wake-word banner on a narrow pane with large text, and with the soft
// keyboard up: it wraps or ellipsizes, its Stop is always reachable, and the
// composer with its Stop and Send stays above the keyboard; with the keyboard
// up the banner folds to a compact chip (voice review of 46683e29, probes K2
// and U5), in both layouts.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/l10n/l10n.dart';
import 'package:hermes_android/core/services/gateway_wake_word.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/gateway_wake_controls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/voice_live_harness.dart';

const _banner = ValueKey('gateway-wake-banner');
const _chip = ValueKey('gateway-wake-chip');
const _stop = ValueKey('gateway-wake-stop');

/// A wake controller the gateway reports as listening, on its own mic.
GatewayWakeWordController _listening({String phrase = 'hey hermes'}) =>
    GatewayWakeWordController(
      resumeRetryDelay: Duration.zero,
      transport: GatewayWakeTransport(
        connectionId: 'c1',
        profile: null,
        events: const Stream<StreamEvent>.empty(),
        ready: const Stream<void>.empty(),
        isConnected: () => true,
        call: (method, params, {timeout = const Duration(seconds: 30)}) async {
          if (method == 'wake.status') {
            return {
              'listening': true,
              'enabled': true,
              'available': true,
              'owned_by_caller': true,
              'phrase': phrase,
              'capture': 'local',
              'sample_rate': 16000,
              'frame_length': 1280,
            };
          }
          return {'started': true, 'capture': 'local'};
        },
      ),
    );

List<String> _exceptions(WidgetTester tester) {
  final errors = <String>[];
  Object? error;
  while ((error = tester.takeException()) != null) {
    errors.add(error.toString());
  }
  return errors;
}

void _narrow(WidgetTester tester) {
  tester.view.physicalSize = const Size(320, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Widget _large(Widget child) => Builder(
  builder: (context) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: const TextScaler.linear(2)),
    child: child,
  ),
);

void _expectAboveKeyboard(WidgetTester tester, Finder finder, String what) {
  expect(finder, findsOneWidget, reason: what);
  final rect = tester.getRect(finder);
  expect(rect.bottom, lessThanOrEqualTo(640 - 260 + 0.5), reason: what);
  expect(rect.right, lessThanOrEqualTo(320 + 0.5), reason: what);
  expect(rect.left, greaterThanOrEqualTo(-0.5), reason: what);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
  });

  testWidgets('the banner fits a 320 px pane at 2.0x text, Stop reachable '
      '(probe K2)', (tester) async {
    _narrow(tester);
    final wake = _listening(phrase: 'hey hermes, are you there');
    addTearDown(wake.dispose);
    await wake.refreshStatus();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: _large(
          Scaffold(
            body: Column(
              children: [
                const Spacer(),
                GatewayWakeListeningBanner(controller: wake, available: 380),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(_exceptions(tester), isEmpty);
    expect(find.byKey(_banner), findsOneWidget);
    final stop = find.byKey(_stop);
    expect(stop.hitTestable(), findsOneWidget);
    final rect = tester.getRect(stop);
    expect(rect.right, lessThanOrEqualTo(320.5));
    expect(rect.bottom, lessThanOrEqualTo(640.5));
    await tester.tap(stop);
    await tester.pump();
    expect(_exceptions(tester), isEmpty);
  });

  for (final live in [false, true]) {
    final variant = live ? 'live+wake' : 'wake';
    testWidgets('NextGen $variant: with a 260 px keyboard at 320x640 and '
        '2.0x text the banner is a chip and the composer, Stop and Send stay '
        'above the keyboard (probe U5)', (tester) async {
      _narrow(tester);
      final wake = _listening();
      addTearDown(wake.dispose);
      await wake.refreshStatus();
      final fixture = NextGenLiveFixture(wake: wake);
      await tester.pumpWidget(_large(await fixture.app()));
      await settleLive(tester);
      if (live) await startLiveFromComposer(tester);
      expect(find.byKey(_banner), findsOneWidget);
      expect(find.byKey(_chip), findsNothing);
      expect(_exceptions(tester), isEmpty);

      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await settleLive(tester);
      expect(_exceptions(tester), isEmpty);
      expect(find.byKey(_banner), findsNothing);
      _expectAboveKeyboard(tester, find.byKey(_chip), 'wake chip');
      _expectAboveKeyboard(
        tester,
        find.byKey(const ValueKey('ng-composer-field')),
        'composer',
      );
      _expectAboveKeyboard(
        tester,
        find.byKey(ValueKey(live ? 'voice-live-stop' : 'voice-live-start')),
        live ? 'live Stop' : 'live Start',
      );
      // A live session replaces Send with its own controls.
      if (!live) {
        _expectAboveKeyboard(tester, find.byTooltip('Send').first, 'Send');
      }
      // The chip keeps the wake word's own Stop in reach.
      expect(find.byKey(_stop).hitTestable(), findsOneWidget);

      // Keyboard down: the full banner is back.
      tester.view.viewInsets = FakeViewPadding.zero;
      await settleLive(tester);
      expect(find.byKey(_banner), findsOneWidget);
      expect(find.byKey(_chip), findsNothing);
      expect(_exceptions(tester), isEmpty);
      await unmountLive(tester);
    });
  }

  for (final live in [false, true]) {
    final variant = live ? 'wake+live' : 'wake';
    testWidgets('Classic $variant: with a 260 px keyboard at 320x640 and 2.0x '
        'text the composer and its controls stay above the keyboard', (
      tester,
    ) async {
      _narrow(tester);
      final wake = _listening();
      addTearDown(wake.dispose);
      await wake.refreshStatus();
      final fixture = ClassicLiveFixture();
      await tester.pumpWidget(_large(fixture.app(wake: wake)));
      await settleLive(tester);
      if (live) await startLiveFromComposer(tester);
      expect(_exceptions(tester), isEmpty);

      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await settleLive(tester);
      expect(_exceptions(tester), isEmpty);
      _expectAboveKeyboard(
        tester,
        find.byKey(const Key('chat-message-composer')),
        'composer',
      );
      _expectAboveKeyboard(
        tester,
        find.byKey(ValueKey(live ? 'voice-live-stop' : 'voice-live-start')),
        live ? 'live Stop' : 'live Start',
      );
      if (!live) {
        _expectAboveKeyboard(
          tester,
          find.byKey(const Key('chat-send-message')),
          'Send',
        );
      }
      // The wake Stop is in the composer's bounded area: reachable by
      // scrolling it, never under the keyboard.
      final wakeStop = find.byKey(_stop);
      expect(wakeStop, findsOneWidget);
      await tester.ensureVisible(wakeStop);
      await tester.pump();
      _expectAboveKeyboard(tester, wakeStop, 'wake Stop');
      expect(_exceptions(tester), isEmpty);
      await unmountLive(tester);
    });
  }
}
