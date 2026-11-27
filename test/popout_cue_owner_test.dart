import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/classic_parallel_chat_pane.dart';
import 'package:hermes_android/core/services/completion_cue_player.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/chat_presence.dart';
import 'package:hermes_android/core/workspace/popout_bootstrap.dart';
import 'package:hermes_android/core/workspace/popout_protocol.dart';
import 'package:hermes_android/core/workspace/workspace_popout.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/parallel_chat_pane.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/parallel_workspace_fixture.dart';
import 'support/presence_socket.dart';

/// Review re-check of 5eedcb09: a chat open in both the main window and a
/// pop-out (its own process) could play the completion cue twice, since
/// the 5 s repeat guard is per process. Desktop gives each cue to one
/// window (`ownsAmbientCue`). Here the window that holds presence for the
/// chat plays it, else the main window, else (main does not show the chat)
/// the pop-out.

class _Recorder implements CompletionCueOutput {
  final played = <Uint8List>[];
  @override
  Future<void> play(Uint8List wav) async => played.add(wav);
}

class _PresenceGateway extends ParallelFixtureGateway {
  _PresenceGateway(super.f);
  final presence = PresenceSocket(capable: true);
  @override
  WsClient? get socket => presence;
}

/// Sharing on (presence needs it), Mail as the cue, Ares in front.
Future<void> _setUp(WidgetTester tester) async {
  await NotificationPrefsStore.setShareWindowActivity(true);
  notificationPrefs.value = notificationPrefs.value.copyWith(
    completionSound: WindowsCompletionSound.mail,
  );
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
}

void main() {
  late _Recorder cue;
  setUp(() {
    notificationPrefs.value = NotificationPrefs.defaults;
    cue = _Recorder();
    CompletionCuePlayer.instance.debugOutput = cue;
  });
  tearDown(() {
    notificationPrefs.value = NotificationPrefs.defaults;
    CompletionCuePlayer.instance.debugOutput = null;
    CompletionCuePlayer.instance.ownership = null;
  });

  /// A new turn end for the same chat inside the 5 s repeat guard would be
  /// dropped by the guard, not by ownership; start each phase clean, with
  /// an empty record.
  void freshGuard() =>
      CompletionCuePlayer.instance.debugOutput = cue = _Recorder();

  /// Records each turn end that reaches the window's ownership check, so a
  /// quiet window is shown to have given the cue away, not to have missed
  /// the turn.
  List<String> spyOwnership() {
    final asked = <String>[];
    final real = CompletionCuePlayer.instance.ownership!;
    CompletionCuePlayer.instance.ownership = (key) {
      asked.add(key);
      return real(key);
    };
    return asked;
  }

  testWidgets(
    'NextGen main window: a chat also open in a pop-out plays its cue in one window',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await _setUp(tester);
      final manager = ConnectionManager(await SharedPreferences.getInstance());
      final fixture = ParallelFixture(dashboard: true, profile: 'pane-test');
      final g = _PresenceGateway(fixture);
      addTearDown(g.dispose);
      final row = (await g.api.getSessionsPage()).sessions.first;
      final shown = ValueNotifier(true);
      addTearDown(shown.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NgScope(
            connManager: manager,
            gateway: g,
            connections: [fixture.connection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: ValueListenableBuilder<bool>(
              valueListenable: shown,
              builder: (_, show, _) => show
                  ? NgParallelChatPane(gateway: g, session: row, close: () {})
                  : const SizedBox(),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      Future<void> reply() async {
        void emit(String type, [Map<String, dynamic> data = const {}]) =>
            g.debugEmit(
              StreamEvent(
                type: type,
                sessionId: 'runtime-${row.id}',
                data: data,
              ),
            );
        emit('message.start');
        emit('message.delta', {'text': 'Done'});
        emit('message.complete', {'text': 'Done'});
        emit('turn.end');
        await tester.pump();
      }

      // Control: without a pop-out the main window plays it.
      await reply();
      expect(cue.played, hasLength(1));
      freshGuard();

      final lines = <String>[];
      final link = linkPopoutCue(
        PopoutTarget(
          connectionId: fixture.connection.id,
          sessionId: row.id,
          profile: 'pane-test',
          nextGen: true,
        ),
        lines.add,
      );
      addTearDown(link.close);
      final key = '${fixture.connection.id}|${row.id}';
      final asked = spyOwnership();
      // The main window shows the chat and nobody holds presence: main.
      expect(lines, [workspacePopoutCueMain]);
      // The pop-out holds presence (newest input there): only it plays.
      link.childPresence(true);
      expect(lines.last, workspacePopoutCuePopout);
      await reply();
      expect(asked, [key], reason: 'the turn end reached the decision');
      expect(cue.played, isEmpty, reason: 'the pop-out plays this one');
      freshGuard();
      // Input in the main window's copy: it holds presence too, and a tie
      // goes to the main window.
      await tester.tap(find.byType(NgParallelChatPane));
      await tester.pump();
      expect(lines.last, workspacePopoutCueMain);
      await reply();
      expect(cue.played, hasLength(1), reason: 'the main window plays it');
      freshGuard();
      // The pop-out lets go and the main window stops showing the chat:
      // the pop-out is then the only window with it.
      link.childPresence(false);
      shown.value = false;
      await tester.pump();
      expect(lines.last, workspacePopoutCuePopout);
      expect(lines, [
        workspacePopoutCueMain,
        workspacePopoutCuePopout,
        workspacePopoutCueMain,
        workspacePopoutCuePopout,
      ], reason: 'one line per change');
      // The pop-out closes: the cue is the main window's again.
      link.close();
      CompletionCuePlayer.instance.turnFinished(key);
      expect(cue.played, hasLength(1));
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'Classic main window: a chat also open in a pop-out plays its cue in one window',
    (tester) async {
      SharedPreferences.setMockInitialValues({'verbose_mode': true});
      await _setUp(tester);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(900, 900);
      addTearDown(tester.view.reset);
      final f = ParallelFixture();
      final roster = f.api();
      addTearDown(roster.close);
      final row = (await roster.getSessionsPage()).sessions.first;
      StreamController<List<int>>? stream;
      ApiClient paneApi() => ApiClient.forConnection(
        f.connection,
        httpClient: MockClient.streaming((req, body) async {
          if (req.method == 'POST' && req.url.path == '/v1/chat/completions') {
            stream = StreamController<List<int>>();
            return http.StreamedResponse(
              stream!.stream,
              200,
              headers: {'content-type': 'text/event-stream'},
            );
          }
          return http.StreamedResponse(
            Stream.value(utf8.encode('{"data":[]}')),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final owner = GatewayTurnApplicationController();
      addTearDown(owner.close);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ClassicParallelChatPane(
            connection: f.connection,
            session: row,
            controller: owner,
            testClientFactory: paneApi,
            close: () {},
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      Future<void> reply(String prompt) async {
        await tester.enterText(
          find.byKey(const Key('chat-message-composer')),
          prompt,
        );
        await tester.pump();
        await tester.tap(find.byKey(const Key('chat-send-message')));
        await tester.pump();
        stream!
          ..add(
            utf8.encode(
              'data: {"choices":[{"delta":{"content":"Reply"}}]}\n\n',
            ),
          )
          ..add(utf8.encode('data: [DONE]\n\n'))
          ..close();
        for (var i = 0; owner.hasActiveTurn && i < 12; i++) {
          await tester.pump();
          await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        }
        await tester.pump();
      }

      final lines = <String>[];
      final link = linkPopoutCue(
        PopoutTarget(
          connectionId: f.connection.id,
          sessionId: row.id,
          profile: '',
          nextGen: false,
        ),
        lines.add,
      );
      addTearDown(link.close);
      final key = '${f.connection.id}|${row.id}';
      final asked = spyOwnership();
      // The main window shows the chat and nobody holds presence: main.
      expect(lines, [workspacePopoutCueMain]);
      // The user is in the pop-out (it holds presence); the main window is
      // only covered, which counts as in front everywhere but Windows, and
      // its copy of the chat finishes a turn: the pop-out plays it.
      link.childPresence(true);
      expect(lines.last, workspacePopoutCuePopout);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      await reply('First');
      expect(asked, [key], reason: 'the turn end reached the decision');
      expect(lines.last, workspacePopoutCuePopout);
      expect(cue.played, isEmpty, reason: 'the pop-out plays this one');
      // Back in the main window, typing there takes presence; a tie goes to
      // the main window.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(lines.last, workspacePopoutCuePopout, reason: 'no input yet');
      await reply('Second');
      expect(lines.last, workspacePopoutCueMain);
      expect(cue.played, hasLength(1), reason: 'the main window plays it');
      link.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    },
  );

  testWidgets(
    'a pop-out reports its presence and plays only while the main window gives it the cue',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await _setUp(tester);
      const key = 'c|s-1';
      final follower = PopoutCueFollower(key);
      addTearDown(follower.dispose);
      final player = CompletionCuePlayer.instance;
      // Until the main window says otherwise, its only window plays it.
      player.turnFinished(key);
      expect(cue.played, hasLength(1));
      freshGuard();
      follower.plays = false;
      player.turnFinished(key);
      expect(cue.played, isEmpty, reason: 'the main window plays this one');
      follower.plays = true;
      player.turnFinished(key);
      expect(cue.played, hasLength(1));

      final socket = PresenceSocket(capable: true);
      await tester.pumpWidget(
        MaterialApp(
          home: ChatPresence(
            target: () => (socket, 'runtime-s-1'),
            cueKey: () => key,
            child: const ColoredBox(key: Key('chat'), color: Colors.black),
          ),
        ),
      );
      final written = <String>[];
      follower.report(written.add);
      expect(written, [workspacePopoutPresenceFree]);
      await tester.tap(find.byKey(const Key('chat')));
      await tester.pump();
      expect(written.last, workspacePopoutPresenceHeld);
      // Leaving the front lets presence go.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      expect(written, [
        workspacePopoutPresenceFree,
        workspacePopoutPresenceHeld,
        workspacePopoutPresenceFree,
      ]);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      follower.dispose();
      expect(player.ownership, isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  test(
    'after the launch frame a pop-out accepts the two cue lines only',
    () async {
      final launch = utf8.encode('{"target":1}\n');
      Future<List<Object>> read(
        List<List<int>> input, {
        bool cue = true,
      }) async {
        final events = <Object>[];
        await watchPopoutPipe(
          Stream.fromIterable(input),
          onLaunch: (m) => events.add(m),
          onRevoked: () => events.add('revoked'),
          onStopActivity: () => events.add('stop'),
          onCue: cue
              ? (popout) => events.add(popout ? 'popout' : 'main')
              : null,
        );
        return events;
      }

      List<int> line(String text) => utf8.encode('$text\n');
      expect(
        await read([
          launch,
          line(workspacePopoutCueMain),
          line(workspacePopoutCuePopout),
          line(workspacePopoutStopActivity),
          line(workspacePopoutCueMain).sublist(0, 4),
          line(workspacePopoutCueMain).sublist(4),
        ]),
        [
          {'target': 1},
          'main',
          'popout',
          'stop',
          'main',
          'revoked',
        ],
      );
      for (final other in [
        '{"cue":"both"}\n',
        '{"cue":"main"} \n',
        '{"cue":true}\n',
        '$workspacePopoutPresenceHeld\n',
      ]) {
        expect(await read([launch, utf8.encode(other)]), [
          {'target': 1},
          'revoked',
        ], reason: other);
      }
      // Without a cue handler a cue line is a protocol violation.
      expect(await read([launch, line(workspacePopoutCueMain)], cue: false), [
        {'target': 1},
        'revoked',
      ]);
    },
  );
}
