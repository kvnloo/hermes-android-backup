import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/auto_messaging_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/mobile_push_service.dart';
import 'package:hermes_android/core/services/normal_gateway_application_session.dart';
import 'package:hermes_android/core/services/normal_gateway_pending_store.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/recording_turn_notification_sink.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    notificationPrefs.value = NotificationPrefs.defaults;
    HttpOverrides.global = null;
  });

  test(
    'real Desktop ticket completion cannot resume or submit after revocation',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final entered = Completer<void>();
      final release = Completer<void>();
      var upgrades = 0;
      addTearDown(() => server.close(force: true));
      server.listen((request) async {
        if (request.uri.path == '/api/auth/ws-ticket') {
          entered.complete();
          await release.future;
          request.response.headers.contentType = ContentType.json;
          request.response.write('{"ticket":"fixture"}');
          await request.response.close();
        } else {
          upgrades++;
          request.response.statusCode = 404;
          await request.response.close();
        }
      });
      final c = SavedConnection(
        id: 'ticket-c',
        label: 'C',
        host: '127.0.0.1',
        port: server.port,
        apiKey: '',
        dashboardPortOverride: server.port,
        dashboardProxied: true,
        gatewayProfile: 'profile-a',
      );
      final client = DesktopGatewayClient.fromConnection(c);
      addTearDown(client.close);
      client.bindStoredSession('stored', 'stored');
      bool valid = true;
      final flight = client.submitPrompt(
        sessionId: 'stored',
        text: 'dictated',
        onEvent: (_) {},
        onSent: () {},
        beforeSend: () async => valid,
      );
      final rejected = expectLater(flight, throwsStateError);
      await entered.future;
      valid = false;
      release.complete();
      await rejected;
      expect(upgrades, 0);
    },
  );

  test(
    'production dashboard pagination stops after native revocation, before page two',
    () async {
      final f = await Fixture.create();
      addTearDown(f.close);
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      final entered = Completer<void>();
      final release = Completer<void>();
      final requests = <Uri>[];
      server.listen((request) async {
        requests.add(request.uri);
        entered.complete();
        await release.future;
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode({
            'sessions': List.generate(
              50,
              (i) => {
                'id': 'other-$i',
                'title': 'Other',
                'model': '',
                'source': 'mobile',
                'message_count': 1,
                'is_active': false,
                'preview': '',
                'started_at': 1,
              },
            ),
            'total': 100,
          }),
        );
        await request.response.close();
      });
      await f.session.ready;
      final c = f.manager.getConnections().single.copyWith(
        host: '127.0.0.1',
        port: server.port,
        dashboardPortOverride: server.port,
        dashboardProxied: true,
      );
      await f.manager.prefs.setStringList('saved_connections', [
        jsonEncode(c.toMap()),
      ]);
      f.service.dispose();
      f.service = AutoMessagingService(
        manager: f.manager,
        turns: f.turns,
        channel: f.service.channel,
        supported: true,
        sessionFor: (_) => f.session,
      );
      final flight = f.service.drain();
      await Future.any([
        entered.future,
        flight.then(
          (_) => throw StateError(
            'drained before request; finished=${f.finished}, lookups=${f.lookups}',
          ),
        ),
      ]);
      f.nativeCurrent = false;
      release.complete();
      await flight;
      expect(requests.map((u) => u.queryParameters['offset']), ['0']);
      expect(requests.single.queryParameters['profile'], 'profile-a');
      expect(f.sent, isEmpty);
    },
  );

  test(
    'reply uses exact saved profile and existing application owner once',
    () async {
      final f = await Fixture.create();
      addTearDown(f.close);
      await f.service.drain();
      await f.service.drain();
      expect(f.sent, ['stored:dictated']);
      expect(f.lookups, ['c:profile-a:stored']);
      expect(f.session.findChat('stored')!.snapshot.wireEmitted, isTrue);
      expect(f.finished, 1);
    },
  );
  test('revocation during real owner baseline prevents submission', () async {
    final f = await Fixture.create();
    addTearDown(f.close);
    final entered = Completer<void>();
    final release = Completer<List<Map<String, dynamic>>>();
    f.history = (_) {
      entered.complete();
      return release.future;
    };
    final flight = f.service.drain();
    await entered.future;
    f.nativeCurrent = false;
    release.complete([]);
    await flight;
    expect(f.sent, isEmpty);
    expect(await NormalGatewayPendingStore().load('auto-test'), isEmpty);
  });
  test(
    'revoke during held native true result is fenced by synchronous mutation',
    () async {
      final f = await Fixture.create();
      addTearDown(f.close);
      final entered = Completer<void>();
      final release = Completer<bool>();
      f.nativeGate = () {
        if (!entered.isCompleted) entered.complete();
        return release.future;
      };
      final flight = f.service.drain();
      await entered.future;
      final lease = ConnectionMutationBarrier.begin(['c']);
      lease.release();
      release.complete(true);
      await flight;
      expect(f.lookups, isEmpty);
      expect(f.sent, isEmpty);
    },
  );
  test(
    'credential replacement and missing session never fall back or create',
    () async {
      final f = await Fixture.create();
      addTearDown(f.close);
      f.secrets.value = jsonEncode({'api_key': 'changed'});
      await f.service.drain();
      expect(f.lookups, isEmpty);
      expect(f.sent, isEmpty);
      final g = await Fixture.create();
      addTearDown(g.close);
      g.missing = true;
      await g.service.drain();
      expect(g.sent, isEmpty);
      expect(g.session.chats, isEmpty);
    },
  );
  test(
    'existing pending/uncertain turn rejects a new reply without retries',
    () async {
      final f = await Fixture.create();
      addTearDown(f.close);
      await f.session.ready;
      final chat = f.session.chatFor(
        'stored',
        storedSessionId: 'stored',
        title: 'Chat',
      );
      chat.reserve();
      await f.service.drain();
      expect(f.sent, isEmpty);
      expect(chat.snapshot.hasActiveTurn, isTrue);
    },
  );
  test('mark read uses exact local watermark and sends no prompt', () async {
    final f = await Fixture.create(kind: 'read');
    addTearDown(f.close);
    await f.service.drain();
    expect(f.sent, isEmpty);
    final seen =
        jsonDecode(f.manager.prefs.getString('nextgen.seen_chats.c')!) as Map;
    expect((seen['chats'] as Map).keys, ['stored']);
  });
  test(
    'disposal during held lookup cannot obtain an application owner',
    () async {
      final f = await Fixture.create();
      addTearDown(f.close);
      final entered = Completer<void>();
      final release = Completer<void>();
      f.lookupGate = () async {
        entered.complete();
        await release.future;
      };
      final flight = f.service.drain();
      await entered.future;
      f.service.dispose();
      release.complete();
      await flight;
      expect(f.session.chats, isEmpty);
      expect(f.sent, isEmpty);
    },
  );
  test(
    'plugin sink carries only hashed/nonsecret authority, and stale post is rejected',
    () async {
      final f = await Fixture.create();
      addTearDown(f.close);
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(AutoMessagingService.platform, (
            call,
          ) async {
            calls.add(call);
            return call.method == 'ticket' ? 2 : true;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(AutoMessagingService.platform, null),
      );
      final c = f.manager.getConnections().single;
      final target = TurnNotificationService.conversationTarget(
        f.manager,
        c,
        'stored',
      )!;
      final n = TurnNotification(
        id: 0x10000001,
        title: 'Chat',
        body: 'Answer',
        payload: '',
        channel: TurnNotificationService.turnChannel,
        conversation: target,
      );
      await PluginTurnNotificationSink().show(n);
      expect(calls.map((c) => c.method), ['ticket', 'show']);
      expect(
        jsonEncode(calls.last.arguments),
        isNot(contains('fixture-secret')),
      );
      final lease = ConnectionMutationBarrier.begin(['c']);
      lease.release();
      await expectLater(PluginTurnNotificationSink().show(n), throwsStateError);
      expect(calls.length, 2);
    },
  );
  test(
    'actual WsClient checks native guard after config await and before wire',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final sockets = <WebSocket>[];
      final frames = <Map>[];
      addTearDown(() async {
        for (final s in sockets) {
          await s.close();
        }
        await server.close(force: true);
      });
      server.listen((req) async {
        final ws = await WebSocketTransformer.upgrade(req);
        sockets.add(ws);
        ws.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'method': 'event',
            'params': {
              'type': 'gateway.ready',
              'protocol_version': 1,
              'capabilities': ['prompt.submit'],
            },
          }),
        );
        ws.listen((raw) {
          frames.add(jsonDecode(raw as String) as Map);
        });
      });
      final client = WsClient(
        'http://127.0.0.1:${server.port}',
        profile: 'profile-a',
      );
      addTearDown(client.close);
      await client.connect();
      await expectLater(
        client.submitPrompt(
          'dictated',
          sessionId: 'runtime',
          onEvent: (_) {},
          beforeSend: () async => false,
        ),
        throwsStateError,
      );
      await Future<void>.delayed(Duration.zero);
      expect(frames.where((f) => f['method'] == 'prompt.submit'), isEmpty);
    },
  );

  test(
    'native conversation owner is proven by a platform claim, cleared on absence and disposal',
    () async {
      final f = await Fixture.create();
      addTearDown(f.close);
      addTearDown(() => AutoMessagingService.debugOwnerAvailable = false);
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      addTearDown(
        () => messenger.setMockMethodCallHandler(
          AutoMessagingService.platform,
          null,
        ),
      );
      AutoMessagingService owner() => AutoMessagingService(
        manager: f.manager,
        turns: f.turns,
        supported: true,
      );
      // No owner registered in this engine: absence is not a failure, and
      // never proves conversation authority.
      final absent = owner()..initialize();
      await absent.drain();
      expect(AutoMessagingService.ownerAvailable, isFalse);
      absent.dispose();
      final claims = <String>[];
      messenger.setMockMethodCallHandler(AutoMessagingService.platform, (
        call,
      ) async {
        claims.add(call.method);
        return null;
      });
      final present = owner()..initialize();
      await present.drain();
      expect(claims, contains('claim'));
      expect(AutoMessagingService.ownerAvailable, isTrue);
      present.dispose();
      expect(AutoMessagingService.ownerAvailable, isFalse);
      // A private test channel never stands in for the platform owner.
      await f.service.drain();
      expect(AutoMessagingService.ownerAvailable, isFalse);
    },
  );

  group('conversation fallback keeps exactly one completion alert', () {
    late Fixture f;
    late ConversationNotificationTarget target;
    setUp(() async {
      f = await Fixture.create();
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      target = TurnNotificationService.conversationTarget(
        f.manager,
        f.manager.getConnections().single,
        'stored',
      )!;
    });
    tearDown(() async {
      debugDefaultTargetPlatformOverride = null;
      AutoMessagingService.debugOwnerAvailable = false;
      await f.close();
    });

    test('other platforms never mint a conversation target', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(
        TurnNotificationService.conversationTarget(
          f.manager,
          f.manager.getConnections().single,
          'stored',
        ),
        isNull,
      );
    });

    test(
      'absent owner: ordinary alert only, without touching the car path',
      () async {
        final sink = _ConversationSink();
        final service = TurnNotificationService(sink: sink);
        await service.showTurnCompleted(
          title: 'Chat',
          turnSummary: 'Answer',
          turnId: 'next-1',
          sessionId: 'stored',
          connectionId: 'c',
          conversation: target,
        );
        expect(sink.shown.map((n) => n.conversation), [isNull]);
        expect(sink.shown.single.title, 'Chat');
        final handled = await service.showConversationReply(
          title: 'Chat',
          body: 'Answer',
          turnId: 'classic-1',
          sessionId: 'stored',
          connectionId: 'c',
          conversation: target,
        );
        expect(handled, isFalse, reason: 'caller must keep its generic alert');
        expect(sink.shown, hasLength(1));
      },
    );

    test('posted conversation replaces, never duplicates, the alert', () async {
      AutoMessagingService.debugOwnerAvailable = true;
      final sink = _ConversationSink();
      final service = TurnNotificationService(sink: sink);
      await service.showTurnCompleted(
        title: 'Chat',
        turnSummary: 'Answer',
        turnId: 'next-1',
        sessionId: 'stored',
        connectionId: 'c',
        conversation: target,
      );
      expect(sink.shown.map((n) => n.conversation), [same(target)]);
      expect(
        await service.showConversationReply(
          title: 'Chat',
          body: 'Answer',
          turnId: 'classic-1',
          sessionId: 'stored',
          connectionId: 'c',
          conversation: target,
        ),
        isTrue,
      );
      expect(sink.shown.map((n) => n.conversation), [
        same(target),
        same(target),
      ]);
      // A replayed settlement is throttled and is still "handled".
      expect(
        await service.showConversationReply(
          title: 'Chat',
          body: 'Answer',
          turnId: 'classic-1',
          sessionId: 'stored',
          connectionId: 'c',
          conversation: target,
        ),
        isTrue,
      );
      expect(sink.shown, hasLength(2));
    });

    test('rejected conversation falls back to the ordinary alert', () async {
      AutoMessagingService.debugOwnerAvailable = true;
      final sink = _ConversationSink()
        ..reject = StateError('Conversation account changed');
      final service = TurnNotificationService(sink: sink);
      await service.showTurnCompleted(
        title: 'Chat',
        turnSummary: 'Answer',
        turnId: 'next-1',
        sessionId: 'stored',
        connectionId: 'c',
        conversation: target,
      );
      expect(sink.attempts, 1);
      expect(sink.shown.map((n) => n.conversation), [isNull]);
      expect(
        await service.showConversationReply(
          title: 'Chat',
          body: 'Answer',
          turnId: 'classic-1',
          sessionId: 'stored',
          connectionId: 'c',
          conversation: target,
        ),
        isFalse,
      );
      expect(sink.attempts, 2);
      expect(sink.shown, hasLength(1));
    });

    for (final all in [false, true]) {
      test(
        'cancellation during a held conversation post suppresses fallback all=$all',
        () async {
          AutoMessagingService.debugOwnerAvailable = true;
          final sink = _ConversationSink()..hold = Completer<void>();
          final service = TurnNotificationService(sink: sink);
          await service.ensureInitialized();
          final posted = service.showTurnCompleted(
            title: 'Chat',
            turnSummary: 'Answer',
            turnId: 'next-1',
            sessionId: 'stored',
            connectionId: 'c',
            conversation: target,
          );
          await pumpEventQueue();
          expect(sink.attempts, 1);
          if (all) {
            await service.cancelAll();
          } else {
            await service.cancelTurnCompleted(
              'next-1',
              sessionId: 'stored',
              connectionId: 'c',
            );
          }
          // The native epoch fence rejects the held post.
          sink.hold!.completeError(
            StateError('Conversation authority unavailable'),
          );
          await posted;
          expect(sink.shown, isEmpty);
        },
      );
    }
  });

  group('plugin sink cleanup is independent of the car owner', () {
    const plugin = MethodChannel('dexterous.com/flutter/local_notifications');
    final pluginCalls = <MethodCall>[];
    final autoCalls = <MethodCall>[];
    late TestDefaultBinaryMessenger messenger;
    setUp(() {
      messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      pluginCalls.clear();
      autoCalls.clear();
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      AndroidFlutterLocalNotificationsPlugin.registerWith();
      messenger.setMockMethodCallHandler(plugin, (call) async {
        pluginCalls.add(call);
        return null;
      });
    });
    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
      messenger.setMockMethodCallHandler(plugin, null);
      messenger.setMockMethodCallHandler(AutoMessagingService.platform, null);
    });
    void autoOwner(Object? error) {
      messenger.setMockMethodCallHandler(AutoMessagingService.platform, (
        call,
      ) async {
        autoCalls.add(call);
        if (error != null) throw error;
        return null;
      });
    }

    test('ongoing IDs never reach the car owner or bump its epoch', () async {
      autoOwner(null);
      final ongoing = TurnNotificationService.ongoingChatNotificationIdFor(
        connectionId: 'c',
        localSessionId: 'local',
      );
      await PluginTurnNotificationSink().cancel(ongoing);
      expect(autoCalls, isEmpty);
      expect(pluginCalls.map((c) => c.method), ['cancel']);
      expect((pluginCalls.single.arguments as Map)['id'], ongoing);
    });

    test('absent owner still cancels the ordinary terminal record', () async {
      final id = TurnNotificationService.notificationIdFor('terminal');
      await PluginTurnNotificationSink().cancel(id);
      await PluginTurnNotificationSink().cancelAll();
      expect(pluginCalls.map((c) => c.method), ['cancel', 'cancelAll']);
      expect((pluginCalls.first.arguments as Map)['id'], id);
    });

    test(
      'failing owner fence is reported only after ordinary cleanup',
      () async {
        autoOwner(PlatformException(code: 'auto_unavailable'));
        final id = TurnNotificationService.notificationIdFor('terminal');
        await expectLater(
          PluginTurnNotificationSink().cancel(id),
          throwsA(isA<PlatformException>()),
        );
        await expectLater(
          PluginTurnNotificationSink().cancelAll(),
          throwsA(isA<PlatformException>()),
        );
        expect(autoCalls.map((c) => c.method), ['cancel', 'cancelAll']);
        expect((autoCalls.first.arguments as Map)['id'], id);
        expect(pluginCalls.map((c) => c.method), ['cancel', 'cancelAll']);
      },
    );
  });
}

/// Simulates the native conversation owner behind the sink: conversation posts
/// can be held or rejected; ordinary posts are recorded as shown.
class _ConversationSink extends RecordingTurnNotificationSink {
  Object? reject;
  Completer<void>? hold;
  int attempts = 0;
  @override
  Future<void> show(TurnNotification notification) async {
    if (notification.conversation != null) {
      attempts++;
      final held = hold;
      if (held != null) await held.future;
      final error = reject;
      if (error != null) throw error;
    }
    await super.show(notification);
  }
}

class Secrets implements CredentialStore {
  String? value = jsonEncode({'api_key': 'fixture-secret'});
  String? cached;
  @override
  String? readCached(String key) => cached;
  @override
  Future<String?> read(String key) async => cached = value;
  @override
  Future<void> write(String key, String v) async {
    value = v;
  }

  @override
  Future<void> delete(String key) async {
    value = null;
    cached = null;
  }
}

class Fixture {
  final secrets = Secrets();
  final turns = GatewayTurnApplicationController();
  late ConnectionManager manager;
  late AutoMessagingService service;
  late NormalGatewayApplicationSession session;
  final sent = <String>[];
  final lookups = <String>[];
  bool nativeCurrent = true;
  bool missing = false;
  int finished = 0;
  Future<bool> Function()? nativeGate;
  Future<void> Function()? lookupGate;
  Future<List<Map<String, dynamic>>> Function(String) history = (_) async => [];
  static Future<Fixture> create({String kind = 'reply'}) async {
    final f = Fixture();
    final c = SavedConnection(
      id: 'c',
      label: 'C',
      host: 'fixture.invalid',
      port: 8642,
      apiKey: '',
      gatewayProfile: 'profile-a',
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_connections', [jsonEncode(c.toMap())]);
    f.manager = ConnectionManager(prefs, credentialStore: f.secrets);
    await f.manager.refreshConnectionCredentials('c');
    final channel = MethodChannel('auto-test-${identityHashCode(f)}');
    bool claimed = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'claim') {
            if (claimed) return null;
            claimed = true;
            return {
              'token': 'token',
              'connectionId': 'c',
              'sessionId': 'stored',
              'binding': MobilePushService.binding(
                f.manager.getConnections().single,
              ),
              'kind': kind,
              'text': 'dictated',
            };
          }
          if (call.method == 'current') {
            return f.nativeGate?.call() ?? f.nativeCurrent;
          }
          if (call.method == 'finish') f.finished++;
          return null;
        });
    f.session = NormalGatewayApplicationSession(
      connection: f.manager.getConnections().single,
      scope: 'auto-test',
      submit:
          ({
            required sessionId,
            required text,
            required onEvent,
            required onSent,
          }) async {
            f.sent.add('$sessionId:$text');
            onSent();
            throw StateError('fixture post-wire loss');
          },
      resume: ({required localSessionId, required storedSessionId}) async =>
          throw StateError('fixture offline'),
      history: (id) => f.history(id),
    );
    f.service = AutoMessagingService(
      manager: f.manager,
      turns: f.turns,
      channel: channel,
      supported: true,
      sessionFor: (_) => f.session,
      lookup: (c, id, allowed, current) async {
        f.lookups.add('${c.id}:${c.gatewayProfile}:$id');
        await f.lookupGate?.call();
        if (!await allowed() || !current() || f.missing) return null;
        return Session(
          id: id,
          title: 'Chat',
          model: '',
          source: 'mobile',
          messageCount: 1,
          isActive: false,
          preview: '',
          startedAt: 1,
        );
      },
    );
    return f;
  }

  Future<void> close() async {
    service.dispose();
    await session.close();
    await turns.close();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(service.channel, null);
  }
}
