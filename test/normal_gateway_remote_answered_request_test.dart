// Classic: a question or approval answered on another device must take its
// "Input needed" / "Approval needed" notification down, not leave it behind
// (or let a reconnect replay post a second one for the same request).
import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/normal_gateway_application_session.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/recording_turn_notification_sink.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RecordingTurnNotificationSink sink;
  late NormalGatewayApplicationSession session;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    notificationPrefs.value = NotificationPrefs.defaults;
    sink = RecordingTurnNotificationSink()..permissionResult = true;
    final notifications = TurnNotificationService(sink: sink);
    await notifications.ensureInitialized();
    session = NormalGatewayApplicationSession(
      connection: SavedConnection(
        id: 'classic',
        label: 'Classic',
        host: 'localhost',
        port: 8642,
        apiKey: 'k',
      ),
      scope: 'classic',
      notifications: notifications,
      history: (_) async => const [],
      resume: ({required localSessionId, required storedSessionId}) async =>
          ResumedGatewaySession(runtimeSessionId: 'runtime', running: true),
      submit:
          ({
            required sessionId,
            required text,
            required onEvent,
            required onSent,
          }) async {
            fail('nothing may be submitted for the user');
          },
    );
    addTearDown(session.close);
    await session.ready;
    session.chatFor('local', storedSessionId: 'stored', title: 'Deploy');
    session.setLifecycle(background: true);
  });

  void emit(String type, Map<String, dynamic> data) => session.receiveEvent(
    'local',
    StreamEvent(type: type, data: data, sessionId: 'runtime'),
  );

  Future<void> settle() async {
    for (var i = 0; i < 5; i++) {
      await pumpEventQueue();
    }
  }

  for (final kind in ['clarify', 'approval']) {
    test('a $kind answered elsewhere takes its notification down', () async {
      emit('$kind.request', {
        'server_request_id': 'key-1',
        'request_id': 'key-1',
        if (kind == 'clarify')
          'questions': [
            {'qid': 'q0', 'question': 'Which branch?', 'choices': <String>[]},
          ]
        else
          'command': 'git push',
      });
      await settle();
      expect(sink.shown, hasLength(1));
      final posted = sink.shown.single;

      // Withdrawn by the gateway: another client answered it.
      emit('request.cancel', {
        'id': 'key-1',
        'method': kind,
        'reason': 'resolved',
      });
      await settle();

      expect(sink.cancelled, contains(posted.id));
      expect(
        session.chatFor('local', title: 'Deploy').snapshot.pendingInput,
        isEmpty,
        reason: 'the needs-you state clears with it',
      );
    });
  }

  StreamEvent clarifyRequest(String key, String wire) => StreamEvent(
    type: 'clarify.request',
    data: {
      'server_request_id': key,
      'request_id': key,
      'wire_request_id': wire,
      'questions': [
        {'qid': 'q0', 'question': 'Which branch?', 'choices': <String>[]},
      ],
    },
    sessionId: 'runtime',
  );

  test('a dropped socket keeps a still-open request\'s notification up and '
      'its reconnect replay updates it in place without alerting', () async {
    // The Desktop client namespaces every delivery; after a dropped socket it
    // withdraws the old key (`settled: false`: the server answered nothing)
    // and the resume replays the very same server request under a new one.
    session.receiveEvent('local', clarifyRequest('ns.1.1:srq-1', 'srq-1'));
    await settle();
    expect(sink.shown, hasLength(1));
    final posted = sink.shown.single;
    emit('request.cancel', {
      'id': 'ns.1.1:srq-1',
      'method': 'clarify',
      'settled': false,
    });
    await settle();
    expect(sink.cancelled, isEmpty, reason: 'nothing answered it');

    session.receiveEvent('local', clarifyRequest('ns.2.7:srq-1', 'srq-1'));
    await settle();
    expect(sink.shown, hasLength(2));
    final update = sink.shown.last;
    expect(update.id, posted.id, reason: 'the same notification, in place');
    expect(update.onlyAlertOnce, isTrue, reason: 'no second alert');
    expect(posted.onlyAlertOnce, isFalse);
    expect(
      jsonDecode(update.payload)['requestId'],
      'ns.2.7:srq-1',
      reason: 'its buttons answer the live key',
    );
    expect(sink.cancelled, isEmpty);
    expect(
      session.chatFor('local', title: 'Deploy').snapshot.pendingInput,
      hasLength(1),
      reason: 'still waiting in the app',
    );

    // Answered on another device afterwards: it comes down.
    emit('request.cancel', {
      'id': 'ns.2.7:srq-1',
      'method': 'clarify',
      'reason': 'resolved',
    });
    await settle();
    expect(sink.cancelled, [posted.id]);
  });

  test('a lost connection keeps the notification; only a resume that started '
      'after it and no longer lists the request takes it down', () async {
    final f = _Recovering();
    await f.start();
    addTearDown(f.session.close);
    f.session.setLifecycle(background: true);
    // A recovery read already in flight before the socket drops.
    while (f.resumes.isEmpty) {
      await pumpEventQueue();
    }
    final early = f.resumes.removeAt(0);

    f.session.receiveEvent('local', clarifyRequest('ns.1.1:srq-9', 'srq-9'));
    await settle();
    expect(f.sink.shown, hasLength(1));
    final posted = f.sink.shown.single;

    f.session.connectionChanged(DesktopConnectionState.disconnected);
    await settle();
    expect(
      f.sink.cancelled,
      isEmpty,
      reason: 'a dropped socket answers nothing',
    );
    expect(f.chat.snapshot.pendingInput, isEmpty);

    // That older read cannot speak for a request parked after it started.
    early.complete(
      const ResumedGatewaySession(runtimeSessionId: 'runtime', running: true),
    );
    await settle();
    expect(f.sink.cancelled, isEmpty);

    // Back online: the new resume no longer lists it (answered on Windows).
    f.session.connectionChanged(DesktopConnectionState.connected);
    while (f.resumes.isEmpty) {
      await pumpEventQueue();
    }
    f.resumes
        .removeAt(0)
        .complete(
          const ResumedGatewaySession(
            runtimeSessionId: 'runtime',
            running: true,
            openRequests: [],
          ),
        );
    await settle();
    expect(f.sink.cancelled, [posted.id]);
    expect(f.submits, 1, reason: 'nothing was resent');
  });
}

/// A chat with one submitted, still running turn whose recovery reads
/// (`session.resume`) are held until the test answers them.
class _Recovering {
  final sink = RecordingTurnNotificationSink()..permissionResult = true;
  final resumes = <Completer<ResumedGatewaySession>>[];
  late final NormalGatewayApplicationSession session;
  late final NormalGatewayChatOwner chat;
  final rpc = Completer<void>();
  final sent = Completer<void>();
  var submits = 0;

  Future<void> start() async {
    final notifications = TurnNotificationService(sink: sink);
    await notifications.ensureInitialized();
    session = NormalGatewayApplicationSession(
      connection: SavedConnection(
        id: 'classic',
        label: 'Classic',
        host: 'localhost',
        port: 8642,
        apiKey: 'k',
      ),
      scope: 'classic-recovering',
      notifications: notifications,
      history: (_) async => const [],
      resume: ({required localSessionId, required storedSessionId}) {
        final reply = Completer<ResumedGatewaySession>();
        resumes.add(reply);
        return reply.future;
      },
      submit:
          ({
            required sessionId,
            required text,
            required onEvent,
            required onSent,
          }) {
            submits++;
            onSent();
            sent.complete();
            return rpc.future;
          },
    );
    await session.ready;
    chat = session.chatFor('local', storedSessionId: 'stored', title: 'Deploy');
    chat.observeHistory([
      {'id': 10, 'role': 'assistant', 'content': 'Prior', 'timestamp': 1.0},
    ]);
    chat
        .submitPrepared(
          reservation: chat.reserve()!,
          text: 'Deploy it',
          localContent: 'Deploy it',
        )
        .ignore();
    await sent.future;
    rpc.complete();
  }
}
