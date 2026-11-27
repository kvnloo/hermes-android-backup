import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/classic_parallel_chat_pane.dart';
import 'package:hermes_android/core/services/completion_cue_player.dart';
import 'package:hermes_android/core/services/completion_tones.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'normal_gateway_alias_handoff_wire_test.dart'
    show BindingServer, send, until;
import 'support/parallel_workspace_fixture.dart';

class _Recorder implements CompletionCueOutput {
  final played = <Uint8List>[];
  @override
  Future<void> play(Uint8List wav) async => played.add(wav);
}

void _choose(WindowsCompletionSound sound, {bool mute = false}) {
  notificationPrefs.value = NotificationPrefs.defaults.copyWith(
    completionSound: sound,
    muteAppSounds: mute,
  );
}

void main() {
  late _Recorder cue;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    notificationPrefs.value = NotificationPrefs.defaults;
    cue = _Recorder();
    CompletionCuePlayer.instance.debugOutput = cue;
  });
  tearDown(() {
    notificationPrefs.value = NotificationPrefs.defaults;
    CompletionCuePlayer.instance.debugOutput = null;
  });

  testWidgets('the in-app cue follows the sound choice, Silent and the mute', (
    tester,
  ) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final player = CompletionCuePlayer.instance;
    for (final (sound, tone) in [
      (WindowsCompletionSound.system, CompletionTone.chime),
      (WindowsCompletionSound.mail, CompletionTone.mail),
      (WindowsCompletionSound.reminder, CompletionTone.reminder),
    ]) {
      _choose(sound);
      player.turnFinished('c|${sound.name}');
      expect(cue.played.last, completionToneWav(tone), reason: sound.name);
    }
    expect(cue.played, hasLength(3));
    _choose(WindowsCompletionSound.silent);
    player.turnFinished('c|silent');
    _choose(WindowsCompletionSound.mail, mute: true);
    player.turnFinished('c|muted');
    expect(cue.played, hasLength(3), reason: 'Silent and the mute play none');
    // One chat's turn end reported twice plays once; another chat plays.
    _choose(WindowsCompletionSound.mail);
    player.turnFinished('c|twice');
    player.turnFinished('c|twice');
    player.turnFinished('other|twice');
    expect(cue.played, hasLength(5));
    // Out of sight the completion notification plays instead.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    player.turnFinished('c|background');
    expect(cue.played, hasLength(5));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  });

  testWidgets('NextGen plays the cue for a live reply, not a stopped or failed '
      'one', (tester) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    _choose(WindowsCompletionSound.reminder);
    final g = ParallelFixtureGateway(
      ParallelFixture(dashboard: true, profile: 'pane-test'),
    );
    addTearDown(g.dispose);
    final chat = NgChatController(g, sessionId: 'alpha');
    addTearDown(chat.dispose);
    await chat.open();
    void emit(String type, [Map<String, dynamic> data = const {}]) =>
        g.debugEmit(
          StreamEvent(type: type, sessionId: 'runtime-alpha', data: data),
        );
    for (final status in ['interrupted', 'error']) {
      emit('message.start');
      emit('message.complete', {'text': 'Partial', 'status': status});
      await tester.pump();
    }
    expect(cue.played, isEmpty);
    // A completion replayed while nothing was running is not a live reply.
    emit('message.complete', {'text': 'Old'});
    await tester.pump();
    expect(cue.played, isEmpty);
    emit('message.start');
    emit('message.delta', {'text': 'Done'});
    emit('message.complete', {'text': 'Done'});
    emit('turn.end');
    await tester.pump();
    expect(cue.played, [completionToneWav(CompletionTone.reminder)]);
  });

  testWidgets('a Classic REST reply plays the cue when its stream completes', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'verbose_mode': true});
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    _choose(WindowsCompletionSound.mail);
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
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'Prompt',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('chat-send-message')));
    await tester.pump();
    stream!.add(
      utf8.encode('data: {"choices":[{"delta":{"content":"Reply"}}]}\n\n'),
    );
    await tester.pump();
    expect(cue.played, isEmpty, reason: 'still streaming');
    stream!
      ..add(utf8.encode('data: [DONE]\n\n'))
      ..close();
    for (var i = 0; owner.hasActiveTurn && i < 12; i++) {
      await tester.pump();
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    }
    await tester.pump();
    expect(cue.played, [completionToneWav(CompletionTone.mail)]);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  group('Classic application session', () {
    HttpOverrides? previous;
    setUp(() {
      previous = HttpOverrides.current;
      HttpOverrides.global = null;
    });
    tearDown(() => HttpOverrides.global = previous);

    for (final background in [false, true]) {
      test('a settled reply plays the cue in front=${!background}', () async {
        TestWidgetsFlutterBinding.ensureInitialized()
            .handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        _choose(WindowsCompletionSound.system);
        final server = await BindingServer.start();
        final controller = GatewayTurnApplicationController();
        addTearDown(() async {
          await controller.close();
          await server.close();
        });
        final session = controller.normalSessionFor(server.connection);
        await session.ready;
        if (background) session.setLifecycle(background: true);
        final local = session.chatFor('local', title: 'Cue');
        final ensuring = session.client!.ensureSession('local');
        ensuring.ignore();
        await server.createEntered.future;
        server.releaseCreate();
        await ensuring;
        final sent = send(local, 'Explicit send');
        await server.untilPrompts(1);
        server.finish('Answer');
        await sent;
        await until(() => !local.snapshot.hasActiveTurn);
        await until(() => background || cue.played.isNotEmpty);
        expect(
          cue.played,
          background ? isEmpty : [completionToneWav(CompletionTone.chime)],
        );
      });
    }
  });

  test('the mute persists and silences the cue', () async {
    await NotificationPrefsStore.setMuteAppSounds(true);
    expect(notificationPrefs.value.muteAppSounds, isTrue);
    expect(
      NotificationPrefs.fromJson(
        notificationPrefs.value.toJson(),
      ).muteAppSounds,
      isTrue,
    );
    expect(CompletionCuePlayer.tone, isNull);
  });
}
