import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hermes_android/core/services/connection_manager.dart';

/// Disposable wire peer with distinguishable passwords, cookies and tickets,
/// but deliberately colliding profile, stored and runtime IDs across peers.
class FleetFixture {
  FleetFixture._(this.server, this.name);
  final HttpServer server;
  final String name;
  final sockets = <WebSocket>[];
  final requests = <({String method, Uri uri})>[];
  final prompts = <String>[];
  final tickets = <String>{};
  int issued = 0;
  bool refuseRoster = false;
  int rosterRequests = 0;
  String primary = 'local';
  String receipt = '0' * 32;
  bool mayUpdate = true;
  bool includeSsh = false;
  String sshHost = 'fixture.invalid';
  String sshVersion = '1.2.3';
  String? sshErrorKind;
  bool sshConnected = false;
  Completer<void>? holdSsh;
  final enteredSsh = Completer<void>();
  final sshWrites = <({String method, String body, String? origin})>[];

  /// Holds `GET /api/hermes/update/check` until completed, so a test can
  /// change chat state between eligibility review and the update POST.
  Completer<void>? holdCheck;
  final enteredCheck = Completer<void>();
  String? direction;
  int revision = 0;
  final writes =
      <({String method, String path, String? origin, Object? body})>[];
  String orgEcho = 'team';
  String agentUrl = 'https://agent.invalid';
  static Future<FleetFixture> start(String name) async {
    final f = FleetFixture._(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
      name,
    );
    f.server.listen(f._handle);
    return f;
  }

  SavedConnection get connection => SavedConnection(
    id: name,
    label: 'Gateway $name',
    host: '127.0.0.1',
    port: server.port,
    apiKey: '',
    dashboardPortOverride: server.port,
    desktopGatewayUrl: 'http://127.0.0.1:${server.port}',
    gatewayProfile: 'work',
    dashboardUsername: 'test',
    dashboardPassword: 'fixture-$name',
  );
  Future<void> close() async {
    for (final ws in sockets) {
      await ws.close();
    }
    await server.close(force: true);
  }

  void event(String type, Map<String, Object?> payload) => sockets.last.add(
    jsonEncode({
      'jsonrpc': '2.0',
      'method': 'event',
      'params': {'type': type, 'session_id': 'runtime', 'payload': payload},
    }),
  );
  Map get reg => {
    'primary': primary,
    'lastUsed': 'local',
    'connections': [
      if (includeSsh)
        {
          'id': 'ssh-fixture',
          'kind': 'ssh',
          'label': 'Fixture SSH',
          'host': sshHost,
          'port': 2222,
          'keyPath': 'never-render-this',
        },
      {'id': 'local', 'kind': 'local', 'label': 'Webapp host'},
      {
        'id': 'other',
        'kind': 'remote',
        'label': 'Workstation',
        'tokenPreview': 'never-render-this',
      },
    ],
  };
  Map get prefs => {
    'exists': true,
    'revision': revision,
    'values': {
      if (direction != null) 'hermes.desktop.textDirection': direction,
      'hermes.desktop.notForAres': 'never-render-this',
    },
  };
  Map get row => {
    'id': 'same',
    'profile': 'work',
    'cwd': '/fixture',
    'title': 'Session on $name',
  };
  Future<void> _handle(HttpRequest req) async {
    final path = req.uri.path, res = req.response;
    requests.add((method: req.method, uri: req.uri));
    Object? body;
    if (path == '/auth/password-login' &&
        jsonDecode(await utf8.decoder.bind(req).join())['password'] ==
            'fixture-$name') {
      res.cookies.add(Cookie('hermes_session_at', 'fixture-$name'));
      body = {'ok': true};
    } else if (path == '/api/ws' &&
        req.headers
            .value('sec-websocket-protocol')!
            .split(',')
            .any((s) => tickets.remove(s.trim()))) {
      final ws = await WebSocketTransformer.upgrade(
        req,
        protocolSelector: (_) => 'hermes-gateway-v1',
      );
      sockets.add(ws);
      event('gateway.ready', {
        'replay_epoch': name,
        'session_authority': false,
      });
      ws.listen((raw) {
        if (ws.readyState != WebSocket.open) return;
        final msg = jsonDecode(raw as String) as Map;
        final params = msg['params'] as Map;
        if (msg['method'] == 'profiles.list') {
          rosterRequests++;
          if (refuseRoster) {
            ws.add(
              jsonEncode({
                'jsonrpc': '2.0',
                'id': msg['id'],
                'error': {
                  'code': -32000,
                  'message': 'Fixture temporarily unavailable',
                },
              }),
            );
            return;
          }
        }
        final data = switch (msg['method']) {
          'profiles.list' => {
            'profiles': [
              {'name': 'work'},
              {'name': 'studio'},
            ],
            'install_id': 'fixture-$name',
          },
          'session.resume' => {
            'session_id': 'runtime',
            'stored_session_id': 'same',
            'running': false,
            'info': {'profile_name': params['profile'], 'cwd': '/fixture'},
          },
          'prompt.submit' => {'status': 'streaming'},
          _ => <String, Object?>{},
        };
        if (msg['method'] == 'prompt.submit') {
          prompts.add(params['text'] as String);
        }
        ws.add(jsonEncode({'jsonrpc': '2.0', 'id': msg['id'], 'result': data}));
      });
      return;
    } else if (req.headers.value('cookie') !=
            'hermes_session_at=fixture-$name' ||
        req.headers.value('authorization') != null) {
      res.statusCode = 401;
    } else if (path == '/api/gateway-connections/ssh-fixture/ssh' &&
        !req.uri.hasQuery) {
      if (req.method != 'GET') {
        sshWrites.add((
          method: req.method,
          body: await utf8.decoder.bind(req).join(),
          origin: req.headers.value('origin'),
        ));
      }
      if (req.method == 'POST') {
        if (!enteredSsh.isCompleted) enteredSsh.complete();
        await holdSsh?.future;
      }
      if (req.method == 'POST' && sshErrorKind != null) {
        res.statusCode = 502;
        body = {
          'detail': {'kind': sshErrorKind, 'message': 'never-render-this'},
        };
      } else if (req.method == 'DELETE') {
        sshConnected = false;
        body = {'ok': true, 'disconnected': true};
      } else {
        if (req.method == 'POST') sshConnected = true;
        body = {
          'ok': true,
          'connected': sshConnected,
          if (sshConnected) ...{
            'host': sshHost,
            'localPort': 40001,
            'remotePort': 9119,
            'pid': 42,
            'hermesVersion': sshVersion,
            'reused': true,
          },
        };
      }
    } else if (path == '/api/auth/ws-ticket') {
      final ticket = '$name-${++issued}';
      tickets.add('hermes-gateway-ticket.$ticket');
      body = {'ticket': ticket};
    } else if (path == '/api/health') {
      body = {'ok': true, 'version': '1.2.3'};
    } else if (path == '/api/webapp-access/status') {
      res.statusCode = 403;
      body = {'detail': 'never-render-this'};
    } else if (path == '/api/cloud/agents' &&
        req.uri.queryParameters['profile'] == 'work') {
      body = req.uri.queryParameters['org'] == null
          ? {
              'needsOrgSelection': true,
              'orgs': [
                {'id': 'team', 'name': 'Fixture team'},
              ],
            }
          : {
              'org': {'id': orgEcho, 'name': 'Fixture team'},
              'agents': [
                {
                  'id': 'bot',
                  'name': 'Hosted $name',
                  'status': 'running',
                  'dashboardUrl': agentUrl,
                },
              ],
            };
    } else if (path == '/api/hermes/update/check') {
      final held = holdCheck;
      if (held != null) {
        if (!enteredCheck.isCompleted) enteredCheck.complete();
        await held.future;
      }
      body = {
        'install_method': 'git',
        'current_version': '1.2.3',
        'can_apply': mayUpdate,
        'update_available': true,
      };
    } else if (path == '/api/hermes/update' &&
        req.method == 'POST' &&
        !req.uri.hasQuery) {
      body = {
        'ok': true,
        'name': 'hermes-update',
        'pid': 42,
        'action_id': '1' * 32,
      };
    } else if (path == '/api/actions/hermes-update/status') {
      body = {
        'name': 'hermes-update',
        'receipt': {
          'action_id': receipt,
          'outcome': 'success',
          'followups': [],
        },
      };
    } else if (path == '/api/sessions' &&
        const {'work', 'studio'}.contains(req.uri.queryParameters['profile'])) {
      body = {
        'offset': 0,
        'total': 1,
        'sessions': [
          {...row, 'profile': req.uri.queryParameters['profile']},
        ],
      };
    } else if (path == '/api/sessions/same') {
      body = {...row, 'profile': req.uri.queryParameters['profile']};
    } else if (path == '/api/sessions/same/messages') {
      body = {'messages': [], 'total': 0};
    } else if (path == '/api/gateway-connections' && req.method == 'GET') {
      body = reg;
    } else if (path == '/api/gateway-connections/other/primary' &&
        req.method == 'POST' &&
        req.headers.value('origin') == 'http://127.0.0.1:${server.port}') {
      writes.add((
        method: req.method,
        path: path,
        origin: req.headers.value('origin'),
        body: jsonDecode(await utf8.decoder.bind(req).join()),
      ));
      primary = 'other';
      body = {'ok': true, 'registry': reg};
    } else if (path == '/api/ui-preferences' && !req.uri.hasQuery) {
      if (req.method == 'PATCH' &&
          req.headers.value('origin') == 'http://127.0.0.1:${server.port}') {
        final data = jsonDecode(await utf8.decoder.bind(req).join());
        writes.add((
          method: req.method,
          path: path,
          origin: req.headers.value('origin'),
          body: data,
        ));
        direction = data['values']['hermes.desktop.textDirection'] as String?;
        revision++;
      }
      body = prefs;
    } else {
      res.statusCode = 404;
    }
    res.headers.contentType = ContentType.json;
    res.write(jsonEncode(body));
    await res.close();
  }
}
