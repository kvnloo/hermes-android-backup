// `wake.detected` carries the profile whose phrase matched and whether a
// fresh session is wanted (host tui_gateway/methods_voice.py, Desktop
// app/contrib/wiring.tsx at b7ee21c14e). NextGen must answer in THAT
// profile's fresh chat, after the switch, and never open a microphone or
// start a turn in the chat that merely heard the phrase.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/auto_speak_replies.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/voice_live_harness.dart';

SavedConnection _connection(String id, String? profile, {String? host}) =>
    harnessNextGenConnection(id: id).copyWith(
      gatewayProfile: profile,
      host: host,
      desktopGatewayUrl: host == null ? null : 'http://$host:9119',
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
    autoSpeakRepliesEnabled.value = false;
  });

  testWidgets("profile B's wake never starts voice or a turn in profile A's "
      "chat: NextGen switches to B's saved gateway and the NEW view starts "
      'voice there', (tester) async {
    final alpha = _connection('conn-alpha', 'alpha');
    final beta = _connection('conn-beta', 'beta');
    final wake = HarnessWake(connectionId: alpha.id, profile: 'alpha');
    addTearDown(wake.dispose);
    final a = NextGenLiveFixture(
      gateway: HarnessGateway(alpha),
      wake: wake.controller,
      connections: [alpha, beta],
    );
    await tester.pumpWidget(await a.app());
    await settleLive(tester);

    wake.detect(profile: 'beta');
    await settleLive(tester);

    expect(a.conversation.starts, 0);
    expect(a.gateway.submits, isEmpty);
    expect(a.newChats, 0);
    expect(a.switchedTo, [beta.id]);
    expect(
      find.byKey(const ValueKey('voice-live-inline-controls')),
      findsNothing,
    );

    // The shell switched: profile B's gateway now shows its fresh chat.
    final wakeB = HarnessWake(connectionId: beta.id, profile: 'beta');
    addTearDown(wakeB.dispose);
    final b = NextGenLiveFixture(
      gateway: HarnessGateway(beta),
      wake: wakeB.controller,
      connections: [alpha, beta],
    );
    await tester.pumpWidget(await b.app(showing: b.freshChat));
    await settleLive(tester);

    expect(b.conversation.starts, 1);
    expect(b.conversation.active, isTrue);
    expect(a.conversation.starts, 0);
    expect(a.gateway.submits, isEmpty);
    await unmountLive(tester);
  });

  testWidgets('with no saved gateway for that profile nothing starts, the '
      'person is told which profile it was, and wake listens again', (
    tester,
  ) async {
    final alpha = _connection('conn-alpha', 'alpha');
    // Same profile name on ANOTHER machine is not the owner.
    final elsewhere = _connection('conn-far', 'beta', host: '10.9.9.9');
    final wake = HarnessWake(connectionId: alpha.id, profile: 'alpha');
    addTearDown(wake.dispose);
    final a = NextGenLiveFixture(
      gateway: HarnessGateway(alpha),
      wake: wake.controller,
      connections: [alpha, elsewhere],
    );
    await tester.pumpWidget(await a.app());
    await settleLive(tester);
    wake.calls.clear();

    wake.detect(profile: 'beta');
    await settleLive(tester);

    expect(a.conversation.starts, 0);
    expect(a.gateway.submits, isEmpty);
    expect(a.switchedTo, isEmpty);
    expect(find.textContaining('"beta"'), findsOneWidget);
    expect(wake.calls, contains('wake.resume'));
    await tester.pump(const Duration(seconds: 6));
    await unmountLive(tester);
  });

  testWidgets('same profile, fresh session wanted, an existing chat open: '
      'the shell opens a new chat and only THAT view starts voice', (
    tester,
  ) async {
    final alpha = _connection('conn-alpha', 'alpha');
    final wake = HarnessWake(connectionId: alpha.id, profile: 'alpha');
    addTearDown(wake.dispose);
    final a = NextGenLiveFixture(
      gateway: HarnessGateway(alpha),
      wake: wake.controller,
    );
    await tester.pumpWidget(await a.app());
    await settleLive(tester);

    // The host default: start_new_session is true unless it says false.
    wake.detect(profile: 'alpha');
    await settleLive(tester);

    expect(a.newChats, 1);
    expect(a.conversation.starts, 0);
    expect(a.gateway.submits, isEmpty);

    await tester.pumpWidget(await a.app(showing: a.freshChat));
    await settleLive(tester);

    // Two views, two sessions: the old chat's never started.
    expect(a.conversations, hasLength(2));
    expect(a.conversations.first.starts, 0);
    expect(a.conversations.last.starts, 1);
    expect(a.conversations.last.active, isTrue);
    await unmountLive(tester);
  });

  testWidgets('start_new_session false answers in the open chat', (
    tester,
  ) async {
    final alpha = _connection('conn-alpha', 'alpha');
    final wake = HarnessWake(connectionId: alpha.id, profile: 'alpha');
    addTearDown(wake.dispose);
    final a = NextGenLiveFixture(
      gateway: HarnessGateway(alpha),
      wake: wake.controller,
    );
    await tester.pumpWidget(await a.app());
    await settleLive(tester);

    wake.detect(profile: 'alpha', startNewSession: false);
    await settleLive(tester);

    expect(a.newChats, 0);
    expect(a.conversation.starts, 1);
    expect(a.conversation.active, isTrue);
    await unmountLive(tester);
  });

  testWidgets('an unnamed profile means this one, and a chat that is '
      'already fresh answers in place', (tester) async {
    // A connection with no pinned profile is the gateway's `default`.
    final plain = _connection('conn-plain', null);
    final wake = HarnessWake(connectionId: plain.id);
    addTearDown(wake.dispose);
    final a = NextGenLiveFixture(
      gateway: HarnessGateway(plain),
      wake: wake.controller,
    );
    await tester.pumpWidget(await a.app(showing: a.freshChat));
    await settleLive(tester);

    wake.detect(profile: 'default');
    await settleLive(tester);

    expect(a.newChats, 0);
    expect(a.switchedTo, isEmpty);
    expect(a.conversation.starts, 1);
    await unmountLive(tester);
  });
}
