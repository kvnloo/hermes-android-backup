import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';

import 'support/strict_authority_gateway.dart';

Matcher fails(WorkspaceFailure why) =>
    throwsA(isA<WorkspaceException>().having((e) => e.reason, 'reason', why));

void main() {
  test(
    'ticket-bearing upgrade refuses a redirect before its destination',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final paths = <String>[];
      server.listen((request) async {
        paths.add(request.uri.path);
        request.response.statusCode = request.uri.path == '/api/ws' ? 302 : 404;
        request.response.headers.set('Location', '/not-the-owner');
        await request.response.close();
      });
      final ws = WsClient(
        'http://127.0.0.1:${server.port}',
        ticket: 'fixture',
        ticketInSubprotocol: true,
      );
      try {
        await expectLater(ws.connect(), throwsException);
        expect(paths, ['/api/ws']);
      } finally {
        ws.close();
        await server.close(force: true);
      }
    },
  );
  for (final classic in [true, false]) {
    group(classic ? 'Classic' : 'NextGen', () {
      late _Fixture server;
      late RemoteWorkspaceOwner owner;
      late WorkspacePane pane;
      late WorkspaceRoute route, host;
      late Future<void> Function() attach;
      late void Function() dispose;
      setUp(() async {
        server = await _Fixture.start();
        if (classic) {
          final gateway = DesktopGatewayClient.fromConnection(
            server.connection,
          );
          gateway.setReconnectAllowed(false);
          owner = gateway.workspace;
          attach = () async {
            await gateway.resumeSubmittedSession(
              localSessionId: 'local',
              storedSessionId: 'stored',
            );
          };
          dispose = gateway.close;
        } else {
          final gateway = NextGenGateway(server.connection);
          owner = gateway.workspace;
          attach = () async {
            await gateway.connected();
            await gateway.call('session.resume', {
              'session_id': 'stored',
              'omit_messages': true,
            });
          };
          dispose = gateway.dispose;
        }
        pane = owner.pane();
        route = owner.route(storedSessionId: 'stored');
        host = owner.route();
      });
      tearDown(() async {
        pane.close();
        dispose();
        await server.close();
      });

      test(
        'password → cookie → one-use ticket; host, session and cwd reads',
        () async {
          final fleet = await pane.bind(host);
          expect(
            (await fleet.read(WorkspaceRead.profiles) as Map)['install_id'],
            'machine-fixture',
          );
          expect(await fleet.read(WorkspaceRead.dashboardPlugins), [
            {'name': 'fixture-plugin'},
          ]);
          expect(await fleet.read(WorkspaceRead.defaultDirectory), {
            'cwd': '/default',
            'branch': null,
          });
          expect(await fleet.read(WorkspaceRead.hostTerminalTicket), true);
          expect(await fleet.read(WorkspaceRead.terminalBackends), {
            'active': 'local',
            'backends': [],
          });
          expect(
            await fleet.probe(WorkspaceRead.pendingApprovals),
            WorkspaceFailure.unbound,
          );
          final unopened = await pane.bind(route);
          expect(
            await unopened.probe(WorkspaceRead.pendingApprovals),
            WorkspaceFailure.unbound,
          );
          expect(
            server.rpc.where((r) => r['method'] == 'session.resume'),
            isEmpty,
          );
          await attach();
          final chat = await pane.bind(route, expectedCwd: '/srv/repo');
          expect(chat.runtimeSessionId, 'runtime');
          expect(chat.canonicalCwd, '/srv/repo');
          expect(await chat.read(WorkspaceRead.pendingApprovals), {
            'approvals': [],
          });
          expect(await chat.read(WorkspaceRead.processes), {'processes': []});
          expect(await chat.read(WorkspaceRead.gitStatus), {
            'changed': 0,
            'files': [],
          });
          expect(
            server.rpc
                .where((r) => r['method'] == 'approval.pending')
                .single['params'],
            {'session_id': 'runtime', 'profile': 'work'},
          );
          expect(
            server.rpc
                .where((r) => r['method'] == 'profiles.list')
                .single['params'],
            {'include_sessions': false, 'profile': 'work'},
          );
          expect(
            server.api
                .singleWhere((u) => u.path.endsWith('/git/status'))
                .queryParameters,
            {'profile': 'work', 'path': '/srv/repo'},
          );
          expect(
            server.api
                .where((u) => u.path.endsWith('/sessions/stored'))
                .every((u) => u.queryParameters['profile'] == 'work'),
            isTrue,
          );
          expect(server.sockets, hasLength(1));
          expect(
            server.api.every((u) => !u.toString().contains('secret-')),
            isTrue,
          );
        },
      );

      test(
        'mismatched route/row/namespace or noncanonical cwd fails closed',
        () async {
          for (final bad in [
            (
              issuer: route.issuer,
              connectionId: 'other',
              profile: 'work',
              storedSessionId: 'stored',
            ),
            (
              issuer: route.issuer,
              connectionId: 'fixture',
              profile: 'other',
              storedSessionId: 'stored',
            ),
          ]) {
            await expectLater(pane.bind(bad), fails(WorkspaceFailure.mismatch));
          }
          expect(server.api, isEmpty);
          final replacement = DesktopGatewayClient.fromConnection(
            server.connection,
          );
          addTearDown(replacement.close);
          final sameIds = replacement.workspace.route(
            storedSessionId: 'stored',
          );
          await expectLater(
            pane.bind(sameIds),
            fails(WorkspaceFailure.mismatch),
          );
          expect(server.api, isEmpty);
          await expectLater(
            pane.bind(route, expectedCwd: '/other'),
            fails(WorkspaceFailure.mismatch),
          );
          server.row['profile'] = 'other';
          await expectLater(pane.bind(route), fails(WorkspaceFailure.mismatch));
          server.row['profile'] = 'work';
          server.row['id'] = 'stored-child';
          await expectLater(pane.bind(route), fails(WorkspaceFailure.mismatch));
          server.row['id'] = 'stored';
          server.row['cwd'] = '/srv/../other';
          await expectLater(pane.bind(route), fails(WorkspaceFailure.invalid));
          server.row['cwd'] = '/srv/repo';
          final target = await pane.bind(route);
          server.row['git_metadata_generation'] = 2;
          await expectLater(
            target.read(WorkspaceRead.gitStatus),
            fails(WorkspaceFailure.mismatch),
          );
          final fresh = await pane.bind(route);
          server.backend = 'ssh';
          await expectLater(
            fresh.read(WorkspaceRead.gitStatus),
            fails(WorkspaceFailure.unbound),
          );
          expect(
            server.api.where((u) => u.path.endsWith('/git/status')),
            isEmpty,
          );
        },
      );

      test(
        'held reply after A→B→A, independent panes and later account edit',
        () async {
          final a = await pane.bind(host);
          server.hold = true;
          final flight = expectLater(
            a.read(WorkspaceRead.profiles),
            fails(WorkspaceFailure.stale),
          );
          await server.waiting.future.timeout(const Duration(seconds: 5));
          await pane.bind(route);
          final again = await pane.bind(host);
          server.release.complete();
          await flight;
          final otherPane = owner.pane();
          addTearDown(otherPane.close);
          final sibling = await otherPane.bind(host);
          pane.close();
          expect(
            await again.probe(WorkspaceRead.profiles),
            WorkspaceFailure.stale,
          );
          expect(await sibling.probe(WorkspaceRead.profiles), isNull);
          final edit = ConnectionMutationBarrier.begin(['fixture']);
          edit.release();
          final before = server.api.length;
          expect(
            await sibling.probe(WorkspaceRead.defaultDirectory),
            WorkspaceFailure.stale,
          );
          await expectLater(
            otherPane.bind(host),
            fails(WorkspaceFailure.stale),
          );
          expect(server.api.length, before);
        },
      );

      test(
        'ABA runtime rebind does not authorise a retained approval',
        () async {
          await attach();
          final first = await pane.bind(route);
          server.runtime = 'different';
          await attach();
          server.runtime = 'runtime';
          await attach();
          expect(
            await first.probe(WorkspaceRead.pendingApprovals),
            WorkspaceFailure.stale,
          );
          expect(
            server.rpc.where((r) => r['method'] == 'approval.pending'),
            isEmpty,
          );
          final fresh = await pane.bind(route);
          expect(await fresh.probe(WorkspaceRead.pendingApprovals), isNull);
          await server.sockets.single.close();
          // Observe the local close without depending on the remote close future's ordering.
          while (fresh.isCurrent) {
            await Future<void>.delayed(Duration.zero);
          }
          expect(
            await fresh.probe(WorkspaceRead.pendingApprovals),
            WorkspaceFailure.stale,
          );
        },
        timeout: const Timeout(Duration(seconds: 10)),
      );

      if (!classic) {
        test(
          'late resume receipt cannot restore an obsolete runtime',
          () async {
            server.holdResume = true;
            final old = attach();
            await server.waiting.future.timeout(const Duration(seconds: 5));
            server.runtime = 'new';
            await attach();
            final current = await pane.bind(route);
            expect(current.runtimeSessionId, 'new');
            server.release.complete();
            await old;
            expect(
              await current.probe(WorkspaceRead.pendingApprovals),
              WorkspaceFailure.stale,
            );
            final ambiguous = await pane.bind(route);
            expect(
              await ambiguous.probe(WorkspaceRead.pendingApprovals),
              WorkspaceFailure.unbound,
            );
            expect(
              server.rpc.where((r) => r['method'] == 'approval.pending'),
              isEmpty,
            );
            await attach();
            final fresh = await pane.bind(route);
            expect(await fresh.probe(WorkspaceRead.pendingApprovals), isNull);
          },
        );
      }

      test(
        'unsupported, auth denial, redirect and malformed success are distinct',
        () async {
          final target = await pane.bind(host);
          server.unknown = true;
          expect(
            await target.probe(WorkspaceRead.profiles),
            WorkspaceFailure.unsupported,
          );
          server.pluginCode = 403;
          expect(
            await target.probe(WorkspaceRead.dashboardPlugins),
            WorkspaceFailure.denied,
          );
          server.pluginCode = 307;
          expect(
            await target.probe(WorkspaceRead.dashboardPlugins),
            WorkspaceFailure.unavailable,
          );
          server.pluginCode = 200;
          server.plugins = {'token': 'secret-do-not-display'};
          expect(
            await target.probe(WorkspaceRead.dashboardPlugins),
            WorkspaceFailure.invalid,
          );
          expect(
            server.api.where((u) => u.path.endsWith('/untrusted')),
            isEmpty,
          );
          expect(
            server.rpc.where((r) => r['method'] == 'profiles.list'),
            hasLength(1),
          );
        },
      );
    });
  }
}

class _Fixture {
  _Fixture(this.server);
  final HttpServer server;
  final api = <Uri>[];
  final rpc = <Map<String, dynamic>>[];
  final sockets = <WebSocket>[];
  final waiting = Completer<void>();
  final release = Completer<void>();
  final row = <String, dynamic>{
    'id': 'stored',
    'profile': 'work',
    'cwd': '/srv/repo',
    'git_metadata_generation': 1,
  };
  String runtime = 'runtime', backend = 'local';
  bool hold = false, unknown = false;
  bool holdResume = false;
  int pluginCode = 200;
  Object plugins = [
    {'name': 'fixture-plugin'},
  ];
  final tickets = <String>{};
  int sequence = 0;

  SavedConnection get connection => SavedConnection(
    id: 'fixture',
    label: 'fixture',
    host: '127.0.0.1',
    port: server.port,
    apiKey: 'never-an-api-key',
    dashboardUsername: 'fixture',
    dashboardPassword: 'secret-fixture',
    gatewayProfile: 'work',
    dashboardPortOverride: server.port,
    dashboardPrefix: '/prefix',
    desktopGatewayUrl: 'http://127.0.0.1:${server.port}/prefix',
  );
  static Future<_Fixture> start() async {
    final fixture = _Fixture(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    fixture.server.listen(fixture.handle);
    return fixture;
  }

  Future<void> handle(HttpRequest req) async {
    api.add(req.uri);
    final path = req.uri.path;
    final res = req.response;
    Object? body;
    if (path == '/prefix/auth/password-login' &&
        req.method == 'POST' &&
        (jsonDecode(await utf8.decoder.bind(req).join()) as Map)['password'] ==
            'secret-fixture') {
      res.cookies.add(Cookie('hermes_session_at', 'secret-cookie'));
      body = {'ok': true};
    } else if (path == '/prefix/api/ws' &&
        !req.uri.hasQuery &&
        req.headers
                .value('sec-websocket-protocol')
                ?.split(',')
                .any((s) => tickets.remove(s.trim())) ==
            true) {
      final ws = await WebSocketTransformer.upgrade(
        req,
        protocolSelector: (p) => 'hermes-gateway-v1',
      );
      sockets.add(ws);
      ws.add(
        jsonEncode({
          'jsonrpc': '2.0',
          'method': 'event',
          'params': {
            'type': 'gateway.ready',
            'payload': {'replay_epoch': 'fixture', 'session_authority': true},
          },
        }),
      );
      ws.listen((raw) async {
        final frame = jsonDecode(raw as String) as Map<String, dynamic>;
        rpc.add(frame);
        final method = frame['method'];
        final refused = strictAuthorityFrame(frame);
        if (refused != null) {
          ws.add(refused);
          return;
        }
        if (hold && method == 'profiles.list') {
          if (!waiting.isCompleted) waiting.complete();
          await release.future;
        }
        final data = switch (method) {
          'profiles.list' => {
            'profiles': [
              {'name': 'work'},
            ],
            'install_id': 'machine-fixture',
          },
          'session.resume' => {
            'session_id': runtime,
            'stored_session_id': 'stored',
            'info': {
              'profile_name': 'work',
              'cwd': '/srv/repo',
              'terminal_backend': 'local',
            },
          },
          'approval.pending' => {'approvals': []},
          'process.list' => {'processes': []},
          _ => <String, dynamic>{},
        };
        if (holdResume && method == 'session.resume') {
          holdResume = false;
          waiting.complete();
          await release.future;
        }
        ws.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'id': frame['id'],
            if (unknown && method == 'profiles.list')
              'error': {'code': -32601, 'message': 'secret-error'}
            else
              'result': data,
          }),
        );
      });
      return;
    } else if (req.headers.value('cookie') !=
            'hermes_session_at=secret-cookie' ||
        req.headers.value('authorization') != null) {
      res.statusCode = 401;
    } else if (path == '/prefix/api/auth/ws-ticket' && req.method == 'POST') {
      final ticket = 'secret-ticket-${++sequence}';
      tickets.add('hermes-gateway-ticket.$ticket');
      body = {'ticket': ticket};
    } else if (path == '/prefix/api/webapp/socket-ticket' &&
        req.method == 'POST' &&
        req.uri.queryParameters['socket'] == 'host-terminal') {
      body = {'ticket': 'secret-terminal-ticket', 'ttl_seconds': 30};
    } else if (req.method != 'GET' ||
        req.uri.queryParameters['profile'] != 'work') {
      res.statusCode = 400;
    } else {
      switch (path) {
        case '/prefix/api/sessions/stored':
          body = row;
        case '/prefix/api/tools/terminal/backends':
          body = {'active': backend, 'backends': []};
        case '/prefix/api/git/status':
          body = {'changed': 0, 'files': []};
        case '/prefix/api/dashboard/plugins':
          res.statusCode = pluginCode;
          if (pluginCode == 307) res.headers.set('Location', '/untrusted');
          body = plugins;
        case '/prefix/api/fs/default-cwd':
          body = {'cwd': '/default', 'branch': null};
        default:
          res.statusCode = 404;
      }
    }
    res.headers.contentType = ContentType.json;
    res.write(jsonEncode(body));
    await res.close();
  }

  Future<void> close() async {
    if (!release.isCompleted) release.complete();
    for (final ws in sockets) {
      await ws.close();
    }
    await server.close(force: true);
  }
}
