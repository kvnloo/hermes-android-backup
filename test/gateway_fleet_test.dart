import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/gateway_fleet.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_origin_test.dart' show MemoryCredentials;
import 'support/fleet_fixture.dart';
import 'support/mtls_fixture.dart';

Future<void> until(bool Function() ready) async {
  final clock = Stopwatch()..start();
  while (!ready() && clock.elapsed < const Duration(seconds: 8)) {
    await Future<void>.delayed(const Duration(milliseconds: 8));
  }
  expect(ready(), isTrue);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late GatewayFleet fleet;
  late ConnectionManager manager;
  late FleetFixture a, b;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    manager = ConnectionManager(
      await SharedPreferences.getInstance(),
      credentialStore: MemoryCredentials(),
      nativePushSupported: false,
    );
    fleet = GatewayFleet(manager);
    a = await FleetFixture.start('A');
    b = await FleetFixture.start('B');
    for (final f in [a, b]) {
      final c = f.connection;
      await manager.saveConnection(
        c.label,
        c.host,
        c.port,
        '',
        dashboardPort: c.port,
        dashboardUsername: 'test',
        dashboardPassword: c.dashboardPassword,
        gatewayProfile: 'work',
        desktopGatewayUrl: c.desktopGatewayUrl,
      );
    }
  });
  tearDown(() async {
    fleet.dispose();
    await a.close();
    await b.close();
  });
  test(
    'agent account verification never follows a bearer-bearing cross-origin redirect',
    () => withPlatformTrust(() async {
      final redirect = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      var gotAuth = false;
      redirect.listen((req) async {
        gotAuth = req.headers.value('Authorization') == 'Bearer fixture-only';
        req.response.statusCode = 302;
        req.response.headers.set(
          'Location',
          'http://127.0.0.1:${b.server.port}/unrelated',
        );
        await req.response.close();
      });
      try {
        expect(
          await HermesSignIn().me(
            GatewayUrl.parse('http://127.0.0.1:${redirect.port}'),
            authHeaders: {'Authorization': 'Bearer fixture-only'},
          ),
          isNull,
        );
        expect(gotAuth, isTrue);
        expect(b.requests, isEmpty);
      } finally {
        await redirect.close(force: true);
      }
    }),
  );
  Future<FleetHost> attach(String name) => fleet.attach(
    manager.getConnections().singleWhere((c) => c.label == 'Gateway $name').id,
  );
  test(
    'restart restores only explicit fleet consent; account replacement and import revoke it',
    () => withPlatformTrust(() async {
      final first = await attach('A');
      final id = first.gateway.connection.id;
      await until(() => first.target != null);
      await fleet.remember(first, true);
      expect(fleet.remembered(id), isTrue);
      fleet.dispose();
      fleet = GatewayFleet(manager);
      await fleet.restore();
      await until(() => fleet.host(id)?.target != null);
      expect(a.issued, 2);
      expect(b.requests, isEmpty);
      expect(a.prompts, isEmpty);
      final saved = fleet.host(id)!.gateway.connection;
      await manager.updateDashboardAuth(
        id,
        username: 'test',
        password: 'different fixture',
        dashboardPort: a.server.port,
      );
      expect(fleet.remembered(id), isFalse);
      expect(fleet.host(id), isNull);
      await fleet.restore();
      expect(a.issued, 2);
      await manager.importConnections([
        saved.copyWith(fleetReconnect: true),
      ], replaceExisting: false);
      expect(fleet.remembered(id), isFalse);
      await fleet.restore();
      expect(a.issued, 2);
    }),
  );
  test(
    'profile owners and machine-scoped update receipts stay separate',
    () => withPlatformTrust(() async {
      Future<FleetHost> register(FleetFixture f, String kind) async {
        final c = f.connection;
        final saved = await manager.saveSingleLoginConnection(
          url: GatewayUrl.parse(c.desktopGatewayUrl!),
          signInMethod: 'password',
          username: 'test',
          password: c.dashboardPassword,
          profile: 'work',
          fleetKind: kind,
        );
        return fleet.attach(saved.id);
      }

      final direct = await register(a, 'direct'),
          cloud = await register(b, 'cloud');
      await until(() => direct.target != null && cloud.target != null);
      direct.attachProfile('studio', direct.target!);
      final scoped = direct.attachedProfiles.single;
      await until(() => scoped.target != null);
      expect(scoped.sessions.single.profile, 'studio');
      expect(direct.sessions.single.profile, 'work');
      final plan = await fleet.checkUpdates();
      final eligible = plan.singleWhere((o) => o.canStart);
      expect(plan.singleWhere((o) => !o.canStart).state, contains('Cloud'));
      expect(b.requests.where((r) => r.uri.path.contains('update')), isEmpty);
      final second = (await fleet.checkUpdates()).singleWhere(
        (r) => r.canStart,
      );
      await Future.wait([eligible.start(), second.start()]);
      expect(eligible.state, 'Awaiting matching receipt');
      expect(
        a.requests.where((r) => r.uri.path == '/api/hermes/update'),
        hasLength(1),
      );
      a.receipt = '1' * 32;
      await eligible.refreshReceipt();
      expect(eligible.state, 'Updated');
    }),
  );
  test(
    'reconnect recovers a gateway whose first roster read failed',
    () => withPlatformTrust(() async {
      a.refuseRoster = true;
      final [ha, hb] = await Future.wait([attach('A'), attach('B')]);
      await until(() => ha.failure != null && !ha.loading && hb.target != null);
      expect(ha.target, isNull);
      expect(ha.sessions, isEmpty);
      expect(
        a.rosterRequests,
        1,
        reason: 'No polling loop on a healthy socket',
      );
      final siblingTarget = hb.target!;
      a.refuseRoster = false;
      await a.sockets.single.close();
      await until(() => a.sockets.length == 2 && ha.target != null);
      expect(ha.failure, isNull);
      expect(ha.sessions.single.title, 'Session on A');
      expect(a.rosterRequests, 2);
      expect(hb.target, same(siblingTarget));
      expect(b.rosterRequests, 1);
      expect(a.prompts, isEmpty);
      expect(b.prompts, isEmpty);
    }),
  );
  test(
    'two peers with colliding IDs keep separate transcripts and reconnect without resubmitting',
    () => withPlatformTrust(() async {
      final [ha, hb] = await Future.wait([attach('A'), attach('B')]);
      await until(() => ha.target != null && hb.target != null);
      final ta = ha.target!, tb = hb.target!;
      await manager.prefs.setString(
        'last_connection_id',
        hb.gateway.connection.id,
      );
      await fleet.togglePrimary(ha);
      expect(
        GatewayFleet.primaryId(manager, manager.getConnections()),
        ha.gateway.connection.id,
      );
      expect(
        manager.prefs.getString('last_connection_id'),
        hb.gateway.connection.id,
      );
      final ra = ha.sessions.single, rb = hb.sessions.single;
      await expectLater(
        ha.openSession(rb, tb),
        throwsA(isA<WorkspaceException>()),
      );
      final [ca, cb] = await Future.wait([
        ha.openSession(ra, ta),
        hb.openSession(rb, tb),
      ]);
      await until(() => ca.runtimeId == 'runtime' && cb.runtimeId == 'runtime');
      expect(
        await Future.wait([
          ha.send(ra, ca, 'alpha', ta),
          hb.send(rb, cb, 'beta', tb),
        ]),
        [true, true],
      );
      a.event('message.delta', {'text': 'one'});
      b.event('message.delta', {'text': 'two'});
      String output(NgChatController c) =>
          c.items.whereType<NgAssistantItem>().map((i) => i.text).join();
      await until(() => output(ca) == 'one' && output(cb) == 'two');
      await a.sockets.single.close();
      b.event('message.delta', {'text': '!'});
      await until(() => !ta.isCurrent && output(cb) == 'two!');
      await until(() => a.issued == 2 && ha.target != null);
      expect(hb.target, same(tb));
      await expectLater(
        ha.send(ra, ca, 'stale', ta),
        throwsA(isA<WorkspaceException>()),
      );
      expect(a.prompts, ['alpha']);
      expect(b.prompts, ['beta']);
      final lease = ConnectionMutationBarrier.begin([ha.gateway.connection.id]);
      lease.release();
      expect(ha.current, isFalse);
      expect(fleet.host(ha.gateway.connection.id), isNull);
      expect(hb.current, isTrue);
    }),
  );
  test(
    'Cloud organisation receipt, safe URL, registry primary and single-key PATCH use the serving owner',
    () => withPlatformTrust(() async {
      final host = await attach('A');
      await until(() => host.target != null);
      final t = host.target!;
      final org = (await t.discoverCloud()).choices.single;
      expect(org.name, 'Fixture team');
      expect(
        (await t.discoverCloud(orgId: org.id)).agents.single.address,
        Uri.parse('https://agent.invalid'),
      );
      a.orgEcho = 'elsewhere';
      await expectLater(
        t.discoverCloud(orgId: org.id),
        throwsA(isA<WorkspaceException>()),
      );
      a.orgEcho = 'team';
      a.agentUrl = 'https://agent.invalid/?ticket=example';
      await expectLater(
        t.discoverCloud(orgId: org.id),
        throwsA(isA<WorkspaceException>()),
      );
      final reg = await t.webappRegistry();
      expect(reg.toString(), isNot(contains('never-render')));
      final after = await t.setWebappPrimary(reg.entries.last);
      expect(after.primary, 'other');
      expect(after.lastUsed, 'local');
      expect(await t.webappDirection(), WebappDirection.auto);
      expect(
        await t.setWebappDirection(WebappDirection.rtl),
        WebappDirection.rtl,
      );
      expect(
        await t.setWebappDirection(WebappDirection.auto),
        WebappDirection.auto,
      );
      expect(a.writes.last.body, {
        'values': {'hermes.desktop.textDirection': null},
        'seed': false,
      });
      expect(a.writes.length, 3);
      expect(b.requests, isEmpty);
    }),
  );
}
