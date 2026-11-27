import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/widgets/chat_presence.dart';
import 'package:hermes_android/core/widgets/hermes_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/presence_socket.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    notificationPrefs.value = NotificationPrefs.defaults;
  });
  tearDown(() => notificationPrefs.value = NotificationPrefs.defaults);

  testWidgets(
    'presence needs opt-in, a capable session and actual chat input; leaving withdraws once',
    (t) async {
      final a = PresenceSocket(), b = PresenceSocket(capable: true);
      var target = (a as WsClient, 'one');
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await t.pumpWidget(
        MaterialApp(
          home: ChatPresence(
            target: () => target,
            child: const ColoredBox(key: Key('chat'), color: Colors.black),
          ),
        ),
      );
      Future<void> touch() async {
        await t.tap(find.byKey(const Key('chat')));
        await t.pump();
      }

      await touch();
      expect(a.reports, isEmpty);
      await NotificationPrefsStore.setShareWindowActivity(true);
      await touch();
      expect(a.reports, isEmpty);
      a.capable = true;
      await touch();
      await touch();
      expect(a.reports.single, {
        'sessions': ['one'],
        'basis': 'page',
        'idle_seconds': 0,
        'can_alert': true,
      });
      // Leaving the screen withdraws without claiming the device is away:
      // only a locked or suspending device is away.
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await t.pump();
      expect(a.reports, hasLength(2));
      expect(a.reports.last['sessions'], isEmpty);
      expect(a.reports.last.containsKey('away'), isFalse);
      target = (b, 'two');
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await t.pump(const Duration(seconds: 11));
      expect(b.reports, isEmpty, reason: 'input from before leaving is gone');
      expect(a.reports, hasLength(2));
      await touch();
      expect(b.reports.single['sessions'], ['two']);
      await NotificationPrefsStore.setShareWindowActivity(false);
      expect(b.reports.last['sessions'], isEmpty);
      expect(b.reports.last.containsKey('away'), isFalse);
      await touch();
      expect(b.reports.length, 2);
      await t.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'review probe: panes sharing a socket report only the newest input pane',
    (t) async {
      // Before the fix: t=0 [b]; t=3 [a]; t=49 [a] idle 47; t=49 [b] idle 50
      // (the stale pane re-claimed); t=59 sessions [] away:true (it cleared
      // the active pane).
      await NotificationPrefsStore.setShareWindowActivity(true);
      final socket = PresenceSocket(capable: true);
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await t.pumpWidget(
        MaterialApp(
          home: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final id in ['a', 'b'])
                Expanded(
                  child: ChatPresence(
                    target: () => (socket, id),
                    child: ColoredBox(
                      key: Key('pane-$id'),
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
      await t.tap(find.byKey(const Key('pane-b')));
      await t.pump();
      await waitRealSeconds(t, 3);
      await t.tap(find.byKey(const Key('pane-a')));
      await t.pump();
      await waitRealSeconds(t, 61);
      expectNewestPaneOnly(socket, older: 'b', newer: 'a');
      await t.pumpWidget(const SizedBox());
      expect(socket.reports.last['sessions'], isEmpty, reason: 'closed');
      expect(socket.reports.last.containsKey('away'), isFalse);
    },
  );

  testWidgets(
    'soft-keyboard edits and composer focus count as input; restored text does not',
    (t) async {
      await NotificationPrefsStore.setShareWindowActivity(true);
      final a = PresenceSocket(capable: true),
          b = PresenceSocket(capable: true);
      var target = (a, 'a');
      final focus = FocusNode();
      final controller = TextEditingController();
      addTearDown(focus.dispose);
      addTearDown(controller.dispose);
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await t.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatPresence(
              target: () => target,
              child: ChatPresenceComposer(
                builder: (_, input) => TextField(
                  focusNode: focus,
                  controller: controller,
                  onChanged: (_) => input(),
                ),
              ),
            ),
          ),
        ),
      );
      // A restored draft is not the user.
      controller.text = 'Restored draft';
      await t.pump();
      expect(a.reports, isEmpty);
      // Focus alone (no pointer, no key event) is input.
      focus.requestFocus();
      await t.pump();
      expect(a.reports.single['sessions'], ['a']);
      // A soft keyboard edit is input: no pointer, no hardware key event.
      target = (b, 'b');
      t.testTextInput.enterText('typed on a phone');
      await t.pump();
      expect(controller.text, 'typed on a phone');
      expect(b.reports.single['sessions'], ['b']);
      expect(a.reports.last['sessions'], isEmpty);
      await t.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'a hidden shell destination withdraws at once and input claims it again',
    (t) async {
      // The Classic shell's IndexedStack keeps the pane mounted with its
      // tickers running; only HermesPaneVisibility says it is hidden.
      await NotificationPrefsStore.setShareWindowActivity(true);
      final socket = PresenceSocket(capable: true);
      final active = ValueNotifier(true);
      addTearDown(active.dispose);
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await t.pumpWidget(
        MaterialApp(
          home: ValueListenableBuilder<bool>(
            valueListenable: active,
            builder: (_, visible, child) =>
                HermesPaneVisibility(active: visible, child: child!),
            child: ChatPresence(
              target: () => (socket, 'a'),
              child: const ColoredBox(key: Key('chat'), color: Colors.black),
            ),
          ),
        ),
      );
      await t.tap(find.byKey(const Key('chat')));
      await t.pump();
      expect(socket.reports.single['sessions'], ['a']);
      active.value = false;
      await t.pump();
      expect(socket.reports, hasLength(2), reason: socket.log());
      expect(socket.reports.last['sessions'], isEmpty);
      expect(socket.reports.last.containsKey('away'), isFalse);
      await t.pump(const Duration(seconds: 11));
      expect(socket.reports, hasLength(2), reason: 'no tick claims it');
      active.value = true;
      await t.pump();
      await t.tap(find.byKey(const Key('chat')));
      await t.pump();
      expect(socket.reports.last['sessions'], ['a'], reason: socket.log());
      await t.pumpWidget(const SizedBox());
    },
  );

  testWidgets('a pushed route withdraws at once, without waiting for a tick', (
    t,
  ) async {
    await NotificationPrefsStore.setShareWindowActivity(true);
    final socket = PresenceSocket(capable: true);
    final navigator = GlobalKey<NavigatorState>();
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await t.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        home: ChatPresence(
          target: () => (socket, 'a'),
          child: const ColoredBox(key: Key('chat'), color: Colors.black),
        ),
      ),
    );
    await t.tap(find.byKey(const Key('chat')));
    await t.pump();
    expect(socket.reports.single['sessions'], ['a']);
    navigator.currentState!.push<void>(
      MaterialPageRoute(builder: (_) => const Text('Settings')),
    );
    await t.pump();
    expect(socket.reports, hasLength(2), reason: socket.log());
    expect(socket.reports.last['sessions'], isEmpty);
    expect(socket.reports.last.containsKey('away'), isFalse);
    await t.pumpAndSettle();
    // Back on the chat with fresh input: claimed again at once.
    navigator.currentState!.pop();
    await t.pumpAndSettle();
    expect(socket.reports.last['sessions'], ['a'], reason: socket.log());
    await t.pumpWidget(const SizedBox());
  });
}
