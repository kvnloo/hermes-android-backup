import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/workspace/popout_bootstrap.dart';
import 'package:hermes_android/core/workspace/popout_protocol.dart';
import 'package:hermes_android/core/workspace/workspace_popout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'support/parallel_workspace_fixture.dart';
import 'support/presence_socket.dart';

final _target = PopoutTarget(
  connectionId: 'c',
  sessionId: 's-1',
  profile: 'work',
  nextGen: true,
);
final _connection = SavedConnection(
  id: 'c',
  label: 'Fixture',
  host: 'fixture.invalid',
  port: 9119,
  apiKey: 'fixture-only',
  gatewayProfile: 'work',
  singleLogin: true,
  desktopGatewayUrl: 'https://fixture.invalid',
);

class _PresenceGateway extends ParallelFixtureGateway {
  _PresenceGateway(super.f);
  final presence = PresenceSocket(capable: true);
  @override
  WsClient? get socket => presence;
}

void main() {
  setUp(() => notificationPrefs.value = NotificationPrefs.defaults);
  tearDown(() => notificationPrefs.value = NotificationPrefs.defaults);

  test('review probe: the pop-out store carries the activity opt-in', () async {
    final opted = NotificationPrefs.defaults.copyWith(
      shareWindowActivity: true,
      completionSound: WindowsCompletionSound.mail,
    );
    final source = <String, Object>{
      'flutter.saved_connections': <String>[jsonEncode(_connection.toMap())],
      'flutter.${NotificationPrefsStore.storageKey}': jsonEncode(
        opted.toJson(),
      ),
      'flutter.drafts': 'never copied',
    };
    final child = popoutPreferences(source, _target);
    expect(
      child.keys,
      unorderedEquals([
        'flutter.saved_connections',
        'flutter.${NotificationPrefsStore.storageKey}',
      ]),
    );
    SharedPreferencesStorePlatform.instance =
        InMemorySharedPreferencesStore.withData(child);
    await SharedPreferences.getInstance().then((p) => p.reload());
    await NotificationPrefsStore.load();
    expect(notificationPrefs.value.shareWindowActivity, isTrue);
    expect(
      notificationPrefs.value.completionSound,
      WindowsCompletionSound.mail,
    );
  });

  test(
    'after the launch frame only an activity opt-out is accepted; anything else revokes at once',
    () async {
      final launch = utf8.encode('{"target":1}\n');
      final stop = utf8.encode('$workspacePopoutStopActivity\n');
      Future<List<Object>> read(List<List<int>> input) async {
        final events = <Object>[];
        await watchPopoutPipe(
          Stream.fromIterable(input),
          onLaunch: (m) => events.add(m),
          onRevoked: () => events.add('revoked'),
          onStopActivity: () => events.add('stop'),
        );
        return events;
      }

      expect(await read([launch, stop, stop]), [
        {'target': 1},
        'stop',
        'stop',
        'revoked',
      ]);
      // Split across chunks still reads as one line.
      expect(await read([launch, stop.sublist(0, 5), stop.sublist(5)]), [
        {'target': 1},
        'stop',
        'revoked',
      ]);
      for (final other in [
        '{"share_activity":true}\n',
        '{}\n',
        '$workspacePopoutStopActivity $workspacePopoutStopActivity\n',
      ]) {
        expect(await read([launch, utf8.encode(other)]), [
          {'target': 1},
          'revoked',
        ], reason: other);
      }
      // Before launch it is only a launch frame, which the child rejects
      // (it needs target, nonce and proof); no opt-out handler runs.
      expect(await read([stop]), [
        {'share_activity': false},
        'revoked',
      ]);
      // A wrong byte revokes without waiting for the end of the line.
      final pipe = StreamController<List<int>>();
      final events = <Object>[];
      final watching = watchPopoutPipe(
        pipe.stream,
        onLaunch: events.add,
        onRevoked: () => events.add('revoked'),
        onStopActivity: () => events.add('stop'),
      );
      pipe.add(launch);
      pipe.add(utf8.encode('{"share_activity":tr'));
      await watching;
      expect(events, [
        {'target': 1},
        'revoked',
      ]);
      await pipe.close();
      // Without an opt-out handler, the old one-frame rule stands.
      final strict = <Object>[];
      await watchPopoutPipe(
        Stream.fromIterable([launch, stop]),
        onLaunch: strict.add,
        onRevoked: () => strict.add('revoked'),
      );
      expect(strict, [
        {'target': 1},
        'revoked',
      ]);
    },
  );

  test(
    'an opt-out line changes only the live value, never stored prefs',
    () async {
      // It can arrive before the child installs its in-memory store, when the
      // platform store is still the main app's real one.
      final stored = jsonEncode(
        NotificationPrefs.defaults
            .copyWith(completionSound: WindowsCompletionSound.reminder)
            .toJson(),
      );
      final real = InMemorySharedPreferencesStore.withData({
        'flutter.${NotificationPrefsStore.storageKey}': stored,
      });
      SharedPreferencesStorePlatform.instance = real;
      notificationPrefs.value = NotificationPrefs.defaults.copyWith(
        shareWindowActivity: true,
      );
      stopPopoutActivity();
      await pumpEventQueue();
      expect(notificationPrefs.value.shareWindowActivity, isFalse);
      expect(await real.getAll(), {
        'flutter.${NotificationPrefsStore.storageKey}': stored,
      });
    },
  );

  test('the main window forwards every opt-out to an open pop-out', () async {
    final written = StreamController<List<int>>();
    final lines = <String>[];
    written.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(lines.add);
    final stdin = IOSink(written.sink);
    notificationPrefs.value = NotificationPrefs.defaults.copyWith(
      shareWindowActivity: true,
    );
    final stop = forwardActivityOptOut(stdin);
    await pumpEventQueue();
    expect(lines, isEmpty);
    notificationPrefs.value = notificationPrefs.value.copyWith(
      shareWindowActivity: false,
    );
    await pumpEventQueue();
    expect(lines, [workspacePopoutStopActivity]);
    notificationPrefs.value = notificationPrefs.value.copyWith(
      completionSound: WindowsCompletionSound.reminder,
    );
    await pumpEventQueue();
    expect(lines, hasLength(1), reason: 'told once per opt-out');
    notificationPrefs.value = notificationPrefs.value.copyWith(
      shareWindowActivity: true,
    );
    notificationPrefs.value = notificationPrefs.value.copyWith(
      shareWindowActivity: false,
    );
    await pumpEventQueue();
    expect(lines, [workspacePopoutStopActivity, workspacePopoutStopActivity]);
    stop();
    notificationPrefs.value = notificationPrefs.value.copyWith(
      shareWindowActivity: true,
    );
    notificationPrefs.value = notificationPrefs.value.copyWith(
      shareWindowActivity: false,
    );
    await pumpEventQueue();
    expect(lines, hasLength(2));
    // A pop-out opened while sharing is off is told straight away.
    final late = forwardActivityOptOut(stdin);
    await pumpEventQueue();
    expect(lines, hasLength(3));
    late();
    await stdin.close();
  });

  testWidgets('a NextGen pop-out reports through its own socket and stops', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await NotificationPrefsStore.setShareWindowActivity(true);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final fixture = ParallelFixture(dashboard: true, profile: 'pane-test');
    final gateway = _PresenceGateway(fixture);
    final rows = (await gateway.api.getSessionsPage()).sessions;
    final manager = ConnectionManager(await SharedPreferences.getInstance());
    await tester.pumpWidget(
      PopoutChatApp(
        manager: manager,
        connection: fixture.connection,
        session: rows.first,
        gateway: gateway,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(const Offset(400, 300));
    await tester.pump();
    final runtime = 'runtime-${rows.first.id}';
    expect(gateway.presence.reports.single, {
      'sessions': [runtime],
      'basis': 'page',
      'idle_seconds': 0,
      'can_alert': isA<bool>(),
    });
    // The parent's opt-out line lands here as the same setter.
    await NotificationPrefsStore.setShareWindowActivity(false);
    expect(gateway.presence.reports.last['sessions'], isEmpty);
    expect(gateway.presence.reports.last.containsKey('away'), isFalse);
    await tester.tapAt(const Offset(400, 300));
    await tester.pump();
    expect(gateway.presence.reports, hasLength(2));
    await tester.pumpWidget(const SizedBox());
  });
}
