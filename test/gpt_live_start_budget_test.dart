// What one GPT-Live start costs on the wire, against Hermes Desktop
// b7ee21c14e (lib/voice-live.ts, store/voice-live.ts): the session POST
// waits up to Desktop's 45 s (the host dials the vendor), and a start reads
// /voice-live/status once, not once per layer.
import 'dart:async';
import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gpt_live_conversation.dart';
import 'package:hermes_android/core/services/voice_live_engine.dart';
import 'package:http/http.dart' as http;

import 'support/fake_live_webrtc.dart';

/// Answers status at once and holds the session POST until released.
class _SlowHost extends http.BaseClient {
  final paths = <String>[];
  final session = Completer<http.StreamedResponse>();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    paths.add(request.url.path);
    if (request.url.path.endsWith('voice-live/session')) return session.future;
    return Future.value(
      http.StreamedResponse(
        Stream.value(
          utf8.encode(
            jsonEncode({'ok': true, 'mode': 'gpt-live', 'available': true}),
          ),
        ),
        200,
      ),
    );
  }
}

GptLiveGatewayTransport _transport(_SlowHost host) =>
    GptLiveGatewayTransport.fromDashboard(
      DashboardClient(host: 'gateway.invalid', proxied: true, httpClient: host),
      ownsDashboard: true,
    );

void main() {
  test("the session POST waits Desktop's 45 s before giving up", () {
    fakeAsync((async) {
      final host = _SlowHost();
      final transport = _transport(host);
      Object? outcome;
      var settled = false;
      transport
          .createSession(sdp: 'v=0\r\n')
          .then((value) => outcome = value, onError: (Object e) => outcome = e)
          .whenComplete(() => settled = true);

      async.elapse(const Duration(seconds: 44));
      expect(settled, isFalse);
      expect(host.paths.single, endsWith('/api/audio/voice-live/session'));

      async.elapse(const Duration(seconds: 2));
      expect(settled, isTrue);
      expect(outcome, isA<TimeoutException>());
      transport.dispose();
    });
  });

  test('a start through the engine reads the status once', () async {
    final live = newFakeLive();
    final engine = VoiceLiveEngine(
      transport: live.transport,
      session: live.conversation,
    );
    addTearDown(engine.dispose);

    expect(await engine.start(), isTrue);

    expect(live.transport.statusCalls, 1);
    expect(live.transport.sessionCalls, 1);
  });

  test('a status the composer has just read is used as is: no second '
      'read', () async {
    final live = newFakeLive();
    final engine = VoiceLiveEngine(
      transport: live.transport,
      session: live.conversation,
    );
    addTearDown(engine.dispose);
    final status = parseGptLiveStatus(await live.transport.status())!;
    expect(live.transport.statusCalls, 1);

    expect(await engine.start(status: status), isTrue);

    expect(live.transport.statusCalls, 1);
    expect(engine.startable, isTrue);
  });

  test('a host that says GPT-Live is off is not dialled', () async {
    final live = newFakeLive();
    final engine = VoiceLiveEngine(
      transport: live.transport,
      session: live.conversation,
    );
    addTearDown(engine.dispose);
    final errors = <String>[];
    engine.onError = errors.add;

    final started = await engine.start(
      status: parseGptLiveStatus({
        'ok': true,
        'mode': 'chained',
        'available': true,
      }),
    );

    expect(started, isFalse);
    expect(live.transport.statusCalls, 0);
    expect(live.transport.sessionCalls, 0);
    expect(errors, hasLength(1));
  });
}
