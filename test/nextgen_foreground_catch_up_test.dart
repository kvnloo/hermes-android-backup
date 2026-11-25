// #84: coming back to the foreground mid-turn must reconcile the open chat
// even when the replay cannot. A turn that finished while the phone slept
// sends no further frame; the old `keep = foreground && running` path left it
// running without its final text. Driven through the real NgMainPage
// lifecycle → NgChatController.resync() path with backend-produced shapes.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/canonical_replay_fixture.dart';
import 'support/recording_turn_notification_sink.dart';

Map<String, dynamic> _row(int id, String role, String content) => {
  'id': id,
  'role': role,
  'content': content,
  'timestamp': 1700000000 + id,
};

void main() {
  final sid = fixtureSessionId;
  final frames = fixtureFrames(['held_terminal', 'frames']);

  /// The backend's answer to `session.events.since`: the exact session epoch
  /// and sequence replay; anything else needs a snapshot.
  Map<String, dynamic> backendSince(Map<String, dynamic> params) {
    final exact = fixtureMap(['held_terminal', 'since_after_2']);
    return params['replay_epoch'] == exact['replay_epoch'] &&
            params['last_sequence'] == 2
        ? exact
        : fixtureMap(['held_terminal', 'since_without_epoch']);
  }

  Future<({FixtureGateway gateway, NgChatController chat})> pumpMain(
    WidgetTester tester, {
    required List<Object> resumes,
    required FixtureHandler since,
    List<Map<String, dynamic>>? history,
    List<Map<String, dynamic>>? streamed,
    String shown = 'Done ',
  }) async {
    SharedPreferences.setMockInitialValues({
      '${NextGenPreferences.lastSessionKeyPrefix}c1': sid,
    });
    final prefs = await SharedPreferences.getInstance();
    final sink = RecordingTurnNotificationSink()..permissionResult = true;
    final service = TurnNotificationService(sink: sink);
    await service.ensureInitialized();
    TurnNotificationService.debugShared = service;
    addTearDown(() => TurnNotificationService.debugShared = null);
    notificationPrefs.value = NotificationPrefs.defaults;

    final live = (await tester.runAsync(
      () => greetingSocket(fixtureMap(['ready_frame'])),
    ))!;
    var resumed = 0;
    final gateway = FixtureGateway(
      readyFrame: fixtureMap(['ready_frame']),
      liveSocket: live.socket,
      history: history ?? [_row(1, 'user', 'Do it')],
      handlers: {
        'session.resume': (_) async {
          final next =
              resumes[resumed < resumes.length ? resumed : resumes.length - 1];
          resumed++;
          if (next is Completer<Map<String, dynamic>>) return next.future;
          return next as Map<String, dynamic>;
        },
        'session.events.since': since,
      },
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      gateway.dispose();
      await tester.runAsync(() async {
        live.socket.close();
        await live.server.close(force: true);
      });
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: nextGenTheme(Brightness.light, NextGenLook.instance),
        home: NgScope(
          connManager: ConnectionManager(prefs),
          gateway: gateway,
          connections: [fixtureConnection()],
          switchTo: (_) async {},
          addGateway: () async {},
          signOut: (_) async {},
          reload: () async {},
          signInAgain: () async {},
          child: const NgMainPage(),
        ),
      ),
    );
    await _pumps(tester);
    final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
    expect(chat.storedId, sid);
    expect(chat.runtimeId, sid);
    // The turn streams its first words while the app is in sight.
    for (final frame in streamed ?? [frames[1]]) {
      gateway.debugEmit(fixtureEvent(frame));
    }
    await _pumps(tester);
    expect(_assistantTexts(chat), [shown]);
    expect(chat.running, isTrue);
    return (gateway: gateway, chat: chat);
  }

  Future<void> away(WidgetTester tester) async {
    for (final s in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    await tester.pump();
  }

  Future<void> back(WidgetTester tester) async {
    for (final s in [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    await _pumps(tester);
  }

  testWidgets(
    'back in sight after the turn ended silently: reconcile, one reply, no resend',
    (tester) async {
      final finished = Completer<Map<String, dynamic>>();
      final o = await pumpMain(
        tester,
        resumes: [
          fixtureMap(['held_terminal', 'snapshot_start']),
          finished,
        ],
        // Replay unavailable (an owner that cannot answer it).
        since: (_) => throw JsonRpcError(
          'session.events.since',
          'unknown method',
          code: -32601,
        ),
      );
      await away(tester);
      // The turn finished while the phone slept; its frames never came.
      o.gateway.rest.rows = [
        _row(1, 'user', 'Do it'),
        _row(2, 'assistant', 'Done now'),
      ];
      await back(tester);

      expect(o.gateway.callsTo('session.events.since'), hasLength(1));
      expect(
        o.gateway.callsTo('session.resume'),
        hasLength(2),
        reason: 'the authoritative state is read even though it is running',
      );
      // Until that read is admitted the live presentation stays.
      expect(_assistantTexts(o.chat), ['Done ']);
      expect(o.chat.running, isTrue);

      finished.complete(fixtureMap(['held_terminal', 'snapshot']));
      await _pumps(tester);
      expect(_assistantTexts(o.chat), ['Done now']);
      expect(o.chat.running, isFalse);
      expect(o.chat.items.whereType<NgUserItem>().map((u) => u.text), [
        'Do it',
      ]);
      expect(find.text('Done now'), findsOneWidget);
      expect(o.gateway.callsTo('prompt.submit'), isEmpty);
      expect(o.gateway.callsTo('session.interrupt'), isEmpty);
    },
  );

  testWidgets(
    'back in sight with the session epoch: the exact replay finishes the turn',
    (tester) async {
      final o = await pumpMain(
        tester,
        resumes: [
          fixtureMap(['held_terminal', 'snapshot_start']),
        ],
        since: backendSince,
      );
      await away(tester);
      await back(tester);
      final since = o.gateway.callsTo('session.events.since').single.params;
      expect(since, {
        'session_id': sid,
        'replay_epoch': frames.first['params']['replay_epoch'],
        'last_sequence': 2,
      });
      expect(_assistantTexts(o.chat), ['Done now']);
      expect(o.chat.running, isFalse);
      // No snapshot reload was needed (the only later history read is the
      // finished turn adopting its stored row ids).
      expect(o.gateway.callsTo('session.resume'), hasLength(1));
      expect(o.chat.items.whereType<NgAssistantItem>(), hasLength(1));
    },
  );

  testWidgets(
    'back in sight while it still runs: keep the live reply, then finish it once',
    (tester) async {
      final o = await pumpMain(
        tester,
        resumes: [
          fixtureMap(['held_terminal', 'snapshot_start']),
          fixtureMap(['held_terminal', 'snapshot_running']),
        ],
        since: (_) => fixtureMap(['held_terminal', 'since_without_epoch']),
      );
      await away(tester);
      await back(tester);
      expect(o.gateway.callsTo('session.resume'), hasLength(2));
      expect(o.gateway.rest.reads, 1, reason: 'the live reply is kept');
      expect(_assistantTexts(o.chat), ['Done ']);
      expect(o.chat.running, isTrue);

      o.gateway.debugEmit(fixtureEvent(frames[2]));
      o.gateway.debugEmit(fixtureEvent(frames[3]));
      await _pumps(tester);
      expect(_assistantTexts(o.chat), ['Done now']);
      expect(o.chat.running, isFalse);
      expect(o.gateway.callsTo('prompt.submit'), isEmpty);
    },
  );

  testWidgets(
    'back in sight while a newer turn runs: reload it, never continue the old reply',
    (tester) async {
      final turn = fixtureFrames(['turn', 'frames']);
      final o = await pumpMain(
        tester,
        history: [_row(1, 'user', 'Write a haiku')],
        streamed: [turn[2]],
        shown: 'moon ',
        resumes: [
          fixtureMap(['turn', 'snapshot_running']),
          fixtureMap(['turn', 'snapshot_next']),
        ],
        since: (_) => throw JsonRpcError(
          'session.events.since',
          'unknown method',
          code: -32601,
        ),
      );
      await away(tester);
      // Generation 3 finished and generation 4 started while away.
      o.gateway.rest.rows = [
        _row(1, 'user', 'Write a haiku'),
        _row(2, 'assistant', 'Autumn moon rises'),
        _row(3, 'user', 'Another'),
      ];
      await back(tester);
      expect(o.gateway.callsTo('session.resume'), hasLength(2));
      expect(o.chat.running, isTrue);
      expect(_assistantTexts(o.chat), ['Autumn moon rises', '']);
      expect(o.chat.items.whereType<NgUserItem>().map((u) => u.text), [
        'Write a haiku',
        'Another',
      ]);
      await o.chat.stop();
      expect(
        o.gateway.callsTo('session.interrupt').single.params,
        containsPair('execution_generation', 4),
      );
      expect(o.gateway.callsTo('prompt.submit'), isEmpty);
    },
  );
}

List<String> _assistantTexts(NgChatController chat) =>
    chat.items.whereType<NgAssistantItem>().map((i) => i.text).toList();

Future<void> _pumps(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}
