// `wake.detected` owner routing in Classic, and the one-shot request that
// carries a wake word to the chat that must answer it (Desktop
// app/contrib/wiring.tsx and store/composer.ts at b7ee21c14e). A phrase of
// profile B is answered in a fresh chat on B's saved connection; a fresh
// session is a new chat. The chat that merely heard the phrase never opens a
// microphone or starts a turn.
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/auto_speak_replies.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/wake_voice_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/voice_live_harness.dart';

SavedConnection _classic(String id, String? profile, {String? host}) =>
    SavedConnection(
      id: id,
      label: 'Voice fixture $id',
      host: host ?? 'voice.fixture',
      port: 8642,
      apiKey: 'synthetic-key',
      gatewayProfile: profile,
    );

/// Every mounted chat, bottom first (a covered route is offstage).
List<ChatScreen> _chats(WidgetTester tester) => tester
    .widgetList<ChatScreen>(find.byType(ChatScreen, skipOffstage: false))
    .toList();

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
    autoSpeakRepliesEnabled.value = false;
    WakeVoiceRequest.clear();
    WakeVoiceRequest.clock = DateTime.now;
  });

  group('WakeVoiceRequest', () {
    test('is taken once, only by its owner', () {
      WakeVoiceRequest.request(
        connectionId: 'conn-beta',
        profile: 'beta',
        freshSession: false,
      );

      expect(
        WakeVoiceRequest.take(
          connectionId: 'conn-alpha',
          profile: 'alpha',
          isNewChat: true,
        ),
        isFalse,
      );
      expect(
        WakeVoiceRequest.take(
          connectionId: 'conn-beta',
          profile: 'alpha',
          isNewChat: true,
        ),
        isFalse,
      );
      expect(
        WakeVoiceRequest.take(
          connectionId: 'conn-beta',
          profile: 'beta',
          isNewChat: false,
        ),
        isTrue,
      );
      expect(
        WakeVoiceRequest.take(
          connectionId: 'conn-beta',
          profile: 'beta',
          isNewChat: false,
        ),
        isFalse,
      );
    });

    test('a fresh-session request waits for a chat with no session yet', () {
      WakeVoiceRequest.request(
        connectionId: 'conn',
        profile: null,
        freshSession: true,
      );

      expect(
        WakeVoiceRequest.take(
          connectionId: 'conn',
          profile: 'default',
          isNewChat: false,
        ),
        isFalse,
      );
      expect(
        WakeVoiceRequest.pendingFor(connectionId: 'conn', profile: ''),
        isNotNull,
      );
      expect(
        WakeVoiceRequest.take(
          connectionId: 'conn',
          profile: ' ',
          isNewChat: true,
        ),
        isTrue,
      );
    });

    test('expires: a switch that never lands opens no microphone later', () {
      var now = DateTime(2026, 11, 26, 12);
      WakeVoiceRequest.clock = () => now;
      WakeVoiceRequest.request(
        connectionId: 'conn',
        profile: 'beta',
        freshSession: false,
      );

      now = now.add(WakeVoiceRequest.lifetime + const Duration(seconds: 1));

      expect(
        WakeVoiceRequest.take(
          connectionId: 'conn',
          profile: 'beta',
          isNewChat: true,
        ),
        isFalse,
      );
    });

    test('the owner of a profile is a saved connection on the same gateway '
        'only', () {
      final alpha = _classic('conn-alpha', 'alpha');
      final beta = _classic('conn-beta', 'beta');
      final plain = _classic('conn-plain', null);
      final far = _classic('conn-far', 'beta', host: 'elsewhere.fixture');

      expect(
        wakeConnectionForProfile(
          [alpha, far, beta],
          from: alpha,
          profile: ' beta ',
        )?.id,
        'conn-beta',
      );
      expect(
        wakeConnectionForProfile([alpha, far], from: alpha, profile: 'beta'),
        isNull,
      );
      // An unpinned connection is the gateway's `default` profile.
      expect(
        wakeConnectionForProfile(
          [alpha, plain],
          from: alpha,
          profile: 'default',
        )?.id,
        'conn-plain',
      );
      expect(wakeProfileKey(null), 'default');
      expect(wakeProfileKey('  '), 'default');
      expect(wakeProfileKey(' sol '), 'sol');
    });
  });

  group('Classic', () {
    testWidgets("profile B's wake never starts voice or a turn in profile "
        "A's chat: a fresh chat on B's saved connection answers it", (
      tester,
    ) async {
      final alpha = _classic('conn-alpha', 'alpha');
      final beta = _classic('conn-beta', 'beta');
      final wake = HarnessWake(connectionId: alpha.id, profile: 'alpha');
      addTearDown(wake.dispose);
      final fixture = ClassicLiveFixture();
      await tester.pumpWidget(
        fixture.app(
          connection: alpha,
          wake: wake.controller,
          saved: [alpha, beta],
        ),
      );
      await settleLive(tester);

      wake.detect(profile: 'beta');
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      await settleLive(tester);

      final chats = _chats(tester);
      expect(chats, hasLength(2));
      expect(chats.first.connection.id, 'conn-alpha');
      expect(chats.last.connection.id, 'conn-beta');
      expect(chats.last.session.isLocalDraft, isTrue);
      // One session per chat: A's never started, B's fresh chat is live.
      expect(fixture.conversations, hasLength(2));
      expect(fixture.conversations.first.starts, 0);
      expect(fixture.conversations.last.starts, 1);
      expect(fixture.conversations.last.active, isTrue);
      expect(fixture.dictation.listenCount, 0);
      await unmountLive(tester);
    });

    testWidgets('with no saved connection for that profile nothing starts '
        'and the person is told which profile it was', (tester) async {
      final alpha = _classic('conn-alpha', 'alpha');
      final wake = HarnessWake(connectionId: alpha.id, profile: 'alpha');
      addTearDown(wake.dispose);
      final fixture = ClassicLiveFixture();
      await tester.pumpWidget(
        fixture.app(connection: alpha, wake: wake.controller, saved: [alpha]),
      );
      await settleLive(tester);
      wake.calls.clear();

      wake.detect(profile: 'beta');
      await settleLive(tester);

      expect(_chats(tester), hasLength(1));
      expect(fixture.conversation.starts, 0);
      expect(fixture.dictation.listenCount, 0);
      expect(find.textContaining('"beta"'), findsOneWidget);
      expect(wake.calls, contains('wake.resume'));
      await unmountLive(tester);
    });

    testWidgets('same profile, fresh session wanted: a new chat opens (as '
        '/new) and only it starts voice', (tester) async {
      final alpha = _classic('conn-alpha', 'alpha');
      final wake = HarnessWake(connectionId: alpha.id, profile: 'alpha');
      addTearDown(wake.dispose);
      final fixture = ClassicLiveFixture();
      await tester.pumpWidget(
        fixture.app(connection: alpha, wake: wake.controller, saved: [alpha]),
      );
      await settleLive(tester);

      wake.detect(profile: 'alpha');
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      await settleLive(tester);

      final chats = _chats(tester);
      expect(chats, hasLength(2));
      expect(chats.last.connection.id, 'conn-alpha');
      expect(chats.last.session.isLocalDraft, isTrue);
      expect(chats.last.session.id, isNot(chats.first.session.id));
      expect(fixture.conversations.first.starts, 0);
      expect(fixture.conversations.last.starts, 1);
      expect(fixture.conversations.last.active, isTrue);
      await unmountLive(tester);
    });

    testWidgets('start_new_session false answers in the open chat', (
      tester,
    ) async {
      final alpha = _classic('conn-alpha', 'alpha');
      final wake = HarnessWake(connectionId: alpha.id, profile: 'alpha');
      addTearDown(wake.dispose);
      final fixture = ClassicLiveFixture();
      await tester.pumpWidget(
        fixture.app(connection: alpha, wake: wake.controller, saved: [alpha]),
      );
      await settleLive(tester);

      wake.detect(profile: 'alpha', startNewSession: false);
      await settleLive(tester);

      expect(_chats(tester), hasLength(1));
      expect(fixture.conversation.starts, 1);
      expect(fixture.conversation.active, isTrue);
      await unmountLive(tester);
    });
  });
}
