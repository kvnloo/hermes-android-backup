// A question or approval answered on ANOTHER device (Ares on Windows, the
// Desktop app, the TUI) must leave this device alone: no "Hermes has a
// question" notification on every trip to the background, no yellow
// needs-you highlight that keeps coming back.
//
// What the server actually does when another client answers (hermes-agent):
// - legacy `/api/ws` sidecar (`tui_gateway/server_requests.py`): the answer's
//   response frame pops the request (`resolve_response`) and the waiter returns;
//   NO `request.cancel` is sent to the other viewers. Only `session.resume` /
//   `session.events.since` `open_requests` say it is gone.
// - session-authority gateway (`gateway/session_server_requests.py::_ask`):
//   publishes `request.cancel {id, method, reason: resolved}` on the session's
//   event stream — to every attached viewer, whether or not it shows the chat.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/sessions_sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/recording_turn_notification_sink.dart';

SavedConnection _conn() => SavedConnection(
  id: 'c1',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: 'k',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
);

/// A legacy (sidecar) gateway whose `session.events.since` answers with what
/// the server has open right now, per runtime session. Requests reach the app
/// through [debugRequest] exactly as a live socket hands them over.
class _ServerStateGateway extends NextGenGateway {
  _ServerStateGateway(super.connection);

  /// Runtime session id → the requests the server still waits on.
  final Map<String, List<Map<String, dynamic>>> open = {};
  final List<String> calls = [];

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    calls.add(method);
    if (method == 'session.events.since') {
      final sid = params['session_id']?.toString() ?? '';
      return {
        'events': const <Object>[],
        'latest_seq': 0,
        'truncated': false,
        'count': 0,
        'epoch': 'e1',
        'open_requests': open[sid] ?? const <Object>[],
      };
    }
    throw StateError('Not connected to the gateway yet.');
  }
}

Map<String, dynamic> _clarify(String id, String sid) => {
  'id': id,
  'method': 'clarify',
  'params': {'session_id': sid, 'question': 'Which branch?'},
};

GatewayServerRequest _request(Map<String, dynamic> snapshot) =>
    GatewayServerRequest.forTesting(
      id: snapshot['id'] as String,
      method: snapshot['method'] as String,
      params: Map<String, dynamic>.from(snapshot['params'] as Map),
      respond: (_) => fail('nothing may answer for the user'),
    );

StreamEvent _cancel(String id, String sid) => StreamEvent(
  type: 'request.cancel',
  data: {'id': id, 'method': 'clarify', 'reason': 'resolved'},
  sessionId: sid,
);

Session _row(String id) => Session(
  id: id,
  title: 'Chat $id',
  model: '',
  source: 'desktop',
  messageCount: 1,
  isActive: true,
  preview: '',
  startedAt: 0,
);

void main() {
  late RecordingTurnNotificationSink sink;
  late _ServerStateGateway gateway;

  Future<void> pumpMain(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      '${NextGenPreferences.lastSessionKeyPrefix}c1': 's1',
    });
    final prefs = await SharedPreferences.getInstance();
    sink = RecordingTurnNotificationSink()..permissionResult = true;
    final service = TurnNotificationService(sink: sink);
    await service.ensureInitialized();
    TurnNotificationService.debugShared = service;
    addTearDown(() => TurnNotificationService.debugShared = null);
    notificationPrefs.value = NotificationPrefs.defaults;
    final conn = _conn();
    gateway = _ServerStateGateway(conn);
    await tester.pumpWidget(
      MaterialApp(
        theme: nextGenTheme(Brightness.light, NextGenLook.instance),
        home: NgScope(
          connManager: ConnectionManager(prefs),
          gateway: gateway,
          connections: [conn],
          switchTo: (_) async {},
          addGateway: () async {},
          signOut: (_) async {},
          reload: () async {},
          signInAgain: () async {},
          child: const NgMainPage(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    gateway.dispose();
    await tester.pump(const Duration(seconds: 30));
  }

  Future<void> background(WidgetTester tester) async {
    for (final s in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    await tester.pump();
    await tester.pump();
  }

  Future<void> foreground(WidgetTester tester) async {
    for (final s in [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    await tester.pump();
    await tester.pump();
  }

  List<TurnNotification> questions() =>
      sink.shown.where((n) => n.title == 'Hermes has a question').toList();

  NgChatAttention attention(WidgetTester tester, String id) {
    final scope = NgScope.of(tester.element(find.byType(NgMainPage)));
    final model = NgSessionsModel(scope);
    addTearDown(model.dispose);
    return model.attentionOf(_row(id));
  }

  testWidgets('request.cancel for a chat that is not open clears the '
      'highlight and never notifies', (tester) async {
    await pumpMain(tester);
    gateway.debugRequest(_request(_clarify('srq-other', 'rt-other')));
    await tester.pump();
    expect(attention(tester, 'rt-other'), NgChatAttention.waiting);

    // Answered on Windows: a session-authority gateway withdraws it from
    // every attached viewer, this one included.
    gateway.debugEmit(_cancel('srq-other', 'rt-other'));
    await tester.pump();
    expect(gateway.openRequests, isEmpty);
    expect(gateway.needsYou, isEmpty);
    expect(attention(tester, 'rt-other'), isNot(NgChatAttention.waiting));

    for (var i = 0; i < 3; i++) {
      await background(tester);
      await foreground(tester);
    }
    expect(questions(), isEmpty, reason: '${sink.shown.map((n) => n.title)}');
    await unmount(tester);
  });

  testWidgets('a question answered elsewhere without request.cancel is '
      're-validated before backgrounding and never notifies', (tester) async {
    await pumpMain(tester);
    gateway.open['rt2'] = [_clarify('srq-2', 'rt2')];
    gateway.debugRequest(_request(_clarify('srq-2', 'rt2')));
    await tester.pump();
    expect(gateway.needsYou, {'rt2'});

    // Answered on Windows; the legacy gateway tells nobody else.
    gateway.open['rt2'] = [];
    for (var i = 0; i < 3; i++) {
      await background(tester);
      await foreground(tester);
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 1100)),
      );
    }

    expect(questions(), isEmpty, reason: '${sink.shown.map((n) => n.title)}');
    expect(gateway.needsYou, isEmpty, reason: 'the yellow highlight clears');
    expect(attention(tester, 'rt2'), isNot(NgChatAttention.waiting));
    expect(gateway.calls, contains('session.events.since'));
    await unmount(tester);
  });

  testWidgets('a question still open notifies once, not on every trip to '
      'the background', (tester) async {
    await pumpMain(tester);
    gateway.open['rt3'] = [_clarify('srq-3', 'rt3')];
    gateway.debugRequest(_request(_clarify('srq-3', 'rt3')));
    await tester.pump();

    for (var i = 0; i < 3; i++) {
      await background(tester);
      await foreground(tester);
      // Real trips are seconds apart: outlast the notification service's
      // 1 s duplicate throttle, which would otherwise hide a repost.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 1100)),
      );
    }

    expect(questions(), hasLength(1), reason: 'exactly once per request');
    expect(sink.cancelled, contains(questions().single.id));
    expect(gateway.needsYou, {'rt3'}, reason: 'it is still waiting');
    await unmount(tester);
  });

  testWidgets('a posted question answered elsewhere comes down once the '
      'agent moves on', (tester) async {
    await pumpMain(tester);
    gateway.open['rt4'] = [_clarify('srq-4', 'rt4')];
    await background(tester);
    gateway.debugRequest(_request(_clarify('srq-4', 'rt4')));
    await tester.pump();
    await tester.pump();
    expect(questions(), hasLength(1));

    // Answered on Windows: the agent carries on, still no request.cancel.
    gateway.open['rt4'] = [];
    gateway.debugEmit(
      StreamEvent(
        type: 'tool.start',
        data: const {'tool_id': 't1', 'name': 'terminal'},
        sessionId: 'rt4',
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(sink.cancelled, contains(questions().single.id));
    expect(gateway.needsYou, isEmpty);
    await foreground(tester);
    await background(tester);
    expect(questions(), hasLength(1), reason: 'never posted again');
    await unmount(tester);
  });

  testWidgets('a dropped socket keeps a still-open question\'s notification '
      'up, and its redelivery does not alert again', (tester) async {
    await pumpMain(tester);
    await background(tester);
    gateway.open['rt5'] = [_clarify('srq-5', 'rt5')];
    gateway.debugRequest(_request(_clarify('srq-5', 'rt5')));
    await tester.pump();
    await tester.pump();
    expect(questions(), hasLength(1));
    final posted = questions().single;

    // The connection drops: nothing was answered.
    gateway.debugDropSocket();
    await tester.pump();
    await tester.pump();
    expect(sink.cancelled, isNot(contains(posted.id)));
    expect(gateway.awaitsAnswer('srq-5'), isTrue);

    // Reconnected: the gateway replays the same request.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 1100)),
    );
    gateway.debugRequest(_request(_clarify('srq-5', 'rt5')));
    await tester.pump();
    await tester.pump();
    expect(questions(), hasLength(1), reason: 'once per request');
    expect(sink.cancelled, isNot(contains(posted.id)));
    expect(gateway.needsYou, {'rt5'});
    await unmount(tester);
  });

  testWidgets('a question answered while the socket was down comes down at '
      'the next authoritative read', (tester) async {
    await pumpMain(tester);
    await background(tester);
    gateway.open['rt6'] = [_clarify('srq-6', 'rt6')];
    gateway.debugRequest(_request(_clarify('srq-6', 'rt6')));
    await tester.pump();
    await tester.pump();
    final posted = questions().single;
    gateway.debugDropSocket();
    await tester.pump();
    expect(sink.cancelled, isNot(contains(posted.id)));

    // Answered on Windows meanwhile; back online, the gateway re-reads the
    // dropped socket's sessions (what a reconnect does on this gateway).
    gateway.open['rt6'] = [];
    await gateway.revalidateOpenRequests();
    await tester.pump();
    await tester.pump();
    expect(sink.cancelled, contains(posted.id));
    expect(gateway.awaitsAnswer('srq-6'), isFalse);
    expect(gateway.needsYou, isEmpty);
    await unmount(tester);
  });
}
