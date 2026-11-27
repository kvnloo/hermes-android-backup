import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/scoped_profile_owner.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';

import 'support/strict_authority_gateway.dart';

void main() {
  test('layout codes carry zoom and filters, not memory text', () {
    const layout = MemoryLayout(
      zoom: 1.5,
      playback: 250,
      kind: 'skill',
      pinnedOnly: true,
    );
    final code = layout.encode();
    expect(code, 'HML1|1.5|250|skill|1');
    expect(code.contains('Packing'), isFalse);
    expect(MemoryLayout.decode(code).playback, 250);
    expect(
      () => MemoryLayout.decode('HML1|1.5|250|skill|1|Packing'),
      throwsFormatException,
    );
  });

  test('a zero exit without the same receipt is not an update success', () {
    expect(
      judgeHostUpdate(actionId: 'a' * 32, running: false, receipt: null),
      HostUpdateVerdict.unknown,
    );
    expect(
      judgeHostUpdate(
        actionId: 'a' * 32,
        running: false,
        receipt: HostUpdateReceipt(actionId: 'b' * 32, outcome: 'success'),
      ),
      HostUpdateVerdict.unknown,
    );
    expect(
      judgeHostUpdate(
        actionId: 'a' * 32,
        running: false,
        receipt: HostUpdateReceipt(actionId: 'a' * 32, outcome: 'success'),
      ),
      HostUpdateVerdict.success,
    );
    expect(
      judgeHostUpdate(
        actionId: 'a' * 32,
        running: true,
        receipt: HostUpdateReceipt(
          actionId: 'a' * 32,
          outcome: 'success',
          followups: ['restart'],
        ),
      ),
      HostUpdateVerdict.partial,
    );
  });

  test('delivery keeps the last selected target', () {
    expect(toggleDeliveryTarget('local', 'telegram'), 'local,telegram');
    expect(toggleDeliveryTarget('local,telegram', 'telegram'), 'local');
    expect(toggleDeliveryTarget('local', 'local'), 'local');
  });

  test(
    'docker eligibility cannot start an update, and liveness is not success',
    () async {
      final fixture = await OpsFixture.start();
      final gateway = DesktopGatewayClient.fromConnection(fixture.connection());
      gateway.setReconnectAllowed(false);
      final pane = gateway.workspace.pane();
      try {
        final target = await pane.bind(gateway.workspace.route());
        final logs = await target.hostLogs(file: 'gateway', search: 'ready');
        expect(logs.lines, ['gateway ready']);
        expect(
          fixture.calls
              .singleWhere((call) => call.path.endsWith('/api/logs'))
              .query,
          {
            'profile': 'work',
            'file': 'gateway',
            'lines': '200',
            'search': 'ready',
          },
        );
        expect(hostUpdateMayStart(await target.updateEligibility()), isFalse);
        await expectLater(
          target.startHostUpdate(),
          throwsA(
            isA<WorkspaceException>().having(
              (error) => error.reason,
              'reason',
              WorkspaceFailure.denied,
            ),
          ),
        );
        expect(fixture.posted('/api/hermes/update'), isFalse);
        fixture.canApply = true;
        fixture.installMethod = 'git';
        fixture.updateAvailable = true;
        final held = await target.startHostUpdate();
        expect(held.actionId, isNull);
        expect(held.refused, contains('running'));
        expect(fixture.posted('/api/hermes/update'), isFalse);
        fixture.activeSessions = 0;
        final launch = await target.startHostUpdate();
        expect(launch.actionId, 'a' * 32);
        expect(
          await target.hostUpdateVerdict(launch.actionId!),
          HostUpdateVerdict.unknown,
        );
        expect((await target.hostStatus()).running, isTrue);
        fixture.receiptMatches = true;
        expect(
          await target.hostUpdateVerdict(launch.actionId!),
          HostUpdateVerdict.success,
        );
      } finally {
        pane.close();
        gateway.close();
        await fixture.close();
      }
    },
  );

  test('schedule actions use the job owner and stop is not pause', () async {
    final fixture = await OpsFixture.start();
    final gateway = DesktopGatewayClient.fromConnection(fixture.connection());
    gateway.setReconnectAllowed(false);
    final pane = gateway.workspace.pane();
    try {
      final catalog = await pane.bind(gateway.workspace.route());
      final jobs = await catalog.allSchedules();
      final nightly = jobs.singleWhere((job) => job.id == 'nightly');
      final daily = jobs.singleWhere((job) => job.id == 'daily');
      expect(nightly.profile, 'alpha');
      expect(nightly.runInFlight, isTrue);
      expect(daily.runInFlight, isFalse);
      expect(
        fixture.calls
            .singleWhere((call) => call.path.endsWith('/api/cron/jobs'))
            .query,
        {'profile': 'all'},
      );
      await expectLater(
        catalog.stopCurrentRun(nightly),
        throwsA(
          isA<WorkspaceException>().having(
            (error) => error.reason,
            'reason',
            WorkspaceFailure.mismatch,
          ),
        ),
      );
      expect(fixture.posted('/cancel'), isFalse);
      final cancelled = await withProfileOwner(
        fixture.connection(profile: 'alpha'),
        'alpha',
        (target) => target.stopCurrentRun(nightly),
      );
      expect(cancelled, isTrue);
      expect(fixture.posted('/cancel', profile: 'alpha'), isTrue);
      expect(fixture.posted('/pause'), isFalse);
      await withProfileOwner(
        fixture.connection(),
        'work',
        (target) => target.setFutureRuns(daily, resume: false),
      );
      expect(fixture.posted('/pause', profile: 'work'), isTrue);
      expect(fixture.posted('/cancel', profile: 'work'), isFalse);
      final created = await withProfileOwner(
        fixture.connection(profile: 'alpha'),
        'alpha',
        (target) => target.instantiateBlueprint('brief', {'topic': 'news'}),
      );
      expect(created.profile, 'alpha');
      expect(
        fixture.calls
            .lastWhere((call) => call.path.endsWith('/instantiate'))
            .query['profile'],
        'alpha',
      );
    } finally {
      pane.close();
      gateway.close();
      await fixture.close();
    }
  });

  test('diagnostics need consent and a redacted receipt', () async {
    final fixture = await OpsFixture.start();
    final gateway = DesktopGatewayClient.fromConnection(fixture.connection());
    gateway.setReconnectAllowed(false);
    final pane = gateway.workspace.pane();
    try {
      final target = await pane.bind(gateway.workspace.route());
      expect(
        () => target.shareDiagnostics(consent: false),
        throwsFormatException,
      );
      expect(fixture.posted('/api/ops/debug-share'), isFalse);
      final hidden = await target.shareDiagnostics(consent: true);
      expect(hidden.redacted, isFalse);
      expect(hidden.urls, isEmpty);
      expect(
        jsonDecode(
          fixture.calls
              .singleWhere((call) => call.path.endsWith('/debug-share'))
              .body,
        ),
        {'consent': true},
      );
      final removed = await target.resetMemoryFiles('memory');
      expect(removed, ['MEMORY.md']);
      expect(
        jsonDecode(
          fixture.calls
              .singleWhere((call) => call.path.endsWith('/memory/reset'))
              .body,
        ),
        {'target': 'memory'},
      );
      final computer = await target.computerUse();
      expect(computer.platform, 'linux');
      expect(
        fixture.calls
            .where((call) => call.path.contains('computer-use'))
            .map((call) => call.method),
        ['GET'],
      );
    } finally {
      pane.close();
      gateway.close();
      await fixture.close();
    }
  });

  test('NextGen reads the same host log route', () async {
    final fixture = await OpsFixture.start();
    final gateway = NextGenGateway(fixture.connection());
    final pane = gateway.workspace.pane();
    try {
      final target = await pane.bind(gateway.workspace.route());
      expect((await target.hostLogs(file: 'errors')).file, 'errors');
      expect((await target.allSchedules()).map((job) => job.profile), [
        'alpha',
        'work',
      ]);
    } finally {
      pane.close();
      gateway.dispose();
      await fixture.close();
    }
  });
}

class OpsFixture {
  OpsFixture(this.server);
  final HttpServer server;
  final calls = <_Call>[];
  final sockets = <WebSocket>[];
  final tickets = <String>{};
  var sequence = 0;
  var canApply = false;
  var installMethod = 'docker';
  var updateAvailable = false;
  var receiptMatches = false;
  var activeSessions = 2;
  String? installId = 'ops-fixture';
  var removedPacking = false;
  final jobs = <String, Map<String, Object?>>{
    'nightly': {
      'id': 'nightly',
      'profile': 'alpha',
      'profile_name': 'alpha',
      'name': 'Nightly',
      'enabled': true,
      'deliver': 'local',
      'catch_up': null,
      'latest_execution': {'id': 'e1', 'status': 'running'},
    },
    'daily': {
      'id': 'daily',
      'profile': 'work',
      'profile_name': 'work',
      'name': 'Daily',
      'enabled': true,
      'deliver': 'local,telegram',
      'catch_up': false,
      'latest_execution': {'id': 'e2', 'status': 'completed'},
    },
  };

  SavedConnection connection({String profile = 'work'}) => SavedConnection(
    id: 'ops-fixture',
    label: 'Ops fixture',
    host: '127.0.0.1',
    port: server.port,
    apiKey: 'not-a-live-key',
    dashboardUsername: 'fixture',
    dashboardPassword: 'secret-fixture',
    gatewayProfile: profile,
    dashboardPortOverride: server.port,
    dashboardPrefix: '/prefix',
    desktopGatewayUrl: 'http://127.0.0.1:${server.port}/prefix',
  );

  bool posted(String suffix, {String? profile}) => calls.any(
    (call) =>
        call.method == 'POST' &&
        call.path.endsWith(suffix) &&
        (profile == null || call.query['profile'] == profile),
  );

  static Future<OpsFixture> start() async {
    final fixture = OpsFixture(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    fixture.server.listen(fixture.handle);
    return fixture;
  }

  Future<void> close() async {
    for (final socket in sockets) {
      await socket.close();
    }
    await server.close(force: true);
  }

  Future<void> handle(HttpRequest request) async {
    final path = request.uri.path;
    if (path == '/prefix/api/ws') {
      await _socket(request);
      return;
    }
    final body = request.method == 'GET'
        ? ''
        : await utf8.decoder.bind(request).join();
    calls.add(_Call(request.method, path, request.uri.queryParameters, body));
    final response = request.response;
    if (path == '/prefix/auth/password-login' &&
        request.method == 'POST' &&
        (jsonDecode(body) as Map)['password'] == 'secret-fixture') {
      response.cookies.add(Cookie('hermes_session_at', 'secret-cookie'));
      _json(response, {'ok': true});
      return;
    }
    if (request.headers.value('cookie') != 'hermes_session_at=secret-cookie' ||
        request.headers.value('authorization') != null) {
      response.statusCode = 401;
      await response.close();
      return;
    }
    if (path == '/prefix/api/auth/ws-ticket' && request.method == 'POST') {
      final ticket = 'secret-ticket-${++sequence}';
      tickets.add('hermes-gateway-ticket.$ticket');
      _json(response, {'ticket': ticket});
      return;
    }
    _json(
      response,
      _api(request.method, path, request.uri.queryParameters, body),
    );
  }

  Future<void> _socket(HttpRequest request) async {
    final offered =
        request.headers.value('sec-websocket-protocol')?.split(',') ?? [];
    if (!offered.any((item) => tickets.remove(item.trim()))) {
      request.response.statusCode = 401;
      await request.response.close();
      return;
    }
    final socket = await WebSocketTransformer.upgrade(
      request,
      protocolSelector: (protocols) => 'hermes-gateway-v1',
    );
    sockets.add(socket);
    socket.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'method': 'event',
        'params': {
          'type': 'gateway.ready',
          'payload': {'session_authority': true},
        },
      }),
    );
    socket.listen((raw) {
      final frame = jsonDecode(raw as String) as Map<String, dynamic>;
      final refused = strictAuthorityFrame(frame);
      if (refused != null) {
        socket.add(refused);
        return;
      }
      final result = frame['method'] == 'profiles.list'
          ? {
              'profiles': [
                {'name': 'work'},
                {'name': 'alpha'},
              ],
              'install_id': 'ops-fixture',
            }
          : <String, dynamic>{};
      socket.add(
        jsonEncode({'jsonrpc': '2.0', 'id': frame['id'], 'result': result}),
      );
    });
  }

  Object? _api(
    String method,
    String path,
    Map<String, String> query,
    String body,
  ) {
    final decoded = body.isEmpty ? null : jsonDecode(body);
    if (path.endsWith('/api/logs')) {
      return {
        'file': query['file'],
        'lines': [query['file'] == 'errors' ? 'error line' : 'gateway ready'],
      };
    }
    if (path.endsWith('/api/status')) {
      return {
        'gateway_running': true,
        'version': '9.9.9',
        'active_sessions': activeSessions,
        if (installId != null) 'install_id': installId,
        'gateway_state': 'running',
        'gateway_shared_with': ['work', 'alpha'],
      };
    }
    if (path.endsWith('/api/hermes/update/check')) {
      return {
        'install_method': installMethod,
        'current_version': '9.9.9',
        'behind': updateAvailable ? 2 : 0,
        'update_available': updateAvailable,
        'can_apply': canApply,
        'message': 'Managed by Docker.',
      };
    }
    if (path.endsWith('/api/hermes/update') && method == 'POST') {
      return {
        'ok': true,
        'name': 'hermes-update',
        'pid': 7,
        'action_id': 'a' * 32,
      };
    }
    if (path.endsWith('/api/actions/hermes-update/status')) {
      return {
        'name': 'hermes-update',
        'running': false,
        'exit_code': 0,
        'pid': 7,
        'lines': ['gateway still answering'],
        'action_id': receiptMatches ? 'a' * 32 : null,
        if (receiptMatches)
          'receipt': {
            'action_id': 'a' * 32,
            'outcome': 'success',
            'followups': <Object?>[],
          },
      };
    }
    if (path.endsWith('/api/hermes/update/receipt')) {
      return {
        'summary': {
          'action_id': 'b' * 32,
          'outcome': 'success',
          'followups': <Object?>[],
        },
      };
    }
    if (path.endsWith('/api/tools/computer-use/status')) {
      return {
        'platform': 'linux',
        'platform_supported': true,
        'installed': true,
        'ready': false,
        'can_grant': false,
        'checks': [
          {
            'label': 'driver',
            'status': 'needs_setup',
            'message': 'missing on the host',
          },
        ],
        'accessibility': null,
        'screen_recording': null,
        'error': null,
      };
    }
    if (path.endsWith('/api/curator') && method == 'GET') {
      return {'enabled': true, 'paused': false, 'last_run_at': null};
    }
    if (path.endsWith('/api/cron/jobs') && method == 'GET') {
      return jobs.values.toList();
    }
    if (path.endsWith('/api/cron/jobs/nightly') && method == 'GET') {
      return jobs['nightly'];
    }
    if (path.endsWith('/api/cron/jobs/daily') && method == 'GET') {
      return jobs['daily'];
    }
    if (path.endsWith('/pause') && method == 'POST') {
      jobs['daily']!['enabled'] = false;
      return jobs['daily'];
    }
    if (path.endsWith('/cancel') && method == 'POST') {
      return {'cancelled': true, 'job_id': 'nightly', 'execution_id': 'e1'};
    }
    if (path.endsWith('/api/cron/blueprints') && method == 'GET') {
      return {
        'blueprints': [
          {
            'key': 'brief',
            'title': 'Brief',
            'description': 'Morning note',
            'source': 'builtin',
            'fields': [
              {
                'name': 'topic',
                'type': 'text',
                'label': 'Topic',
                'default': 'news',
                'options': <String>[],
                'optional': false,
                'help': 'Subject',
              },
            ],
          },
        ],
      };
    }
    if (path.endsWith('/instantiate') && method == 'POST') {
      return {
        'id': 'briefed',
        'profile': query['profile'],
        'profile_name': query['profile'],
        'name': 'Brief',
        'enabled': true,
        'deliver': 'local',
        'catch_up': null,
      };
    }
    if (path.endsWith('/api/cron/delivery-targets')) {
      return {
        'targets': [
          {'id': 'local', 'name': 'Local', 'home_target_set': true},
          {'id': 'telegram', 'name': 'Telegram', 'home_target_set': true},
        ],
      };
    }
    if (path.endsWith('/api/ops/debug-share')) {
      return {
        'ok': true,
        'redacted': false,
        'urls': {'bundle': 'http://127.0.0.1/secret-paste'},
        'failures': <String, String>{},
      };
    }
    if (path.endsWith('/api/memory/reset')) {
      return {
        'ok': true,
        'deleted': ['MEMORY.md'],
      };
    }
    if (path.endsWith('/api/learning/graph')) {
      return {
        'nodes': removedPacking
            ? <Object?>[]
            : [
                {
                  'id': 'packing',
                  'label': 'Packing',
                  'kind': 'skill',
                  'category': 'home',
                  'timestamp': 10,
                  'useCount': 2,
                  'state': 'active',
                  'pinned': false,
                },
              ],
        'edges': <Object?>[],
      };
    }
    if (path.endsWith('/api/memory') && method == 'GET') {
      return {
        'active': '',
        'providers': [
          {
            'name': 'hindsight',
            'description': 'External',
            'available': true,
            'configured': false,
            'status': 'needs_config',
          },
        ],
        'builtin_files': {'memory': 12, 'user': 4},
      };
    }
    if (decoded is Map &&
        path.endsWith('/api/cron/jobs/daily') &&
        method == 'PUT') {
      final updates = decoded['updates'] as Map;
      jobs['daily']!.addAll(
        updates.map((key, value) => MapEntry('$key', value)),
      );
      return jobs['daily'];
    }
    return {'ok': true};
  }

  void _json(HttpResponse response, Object? body) {
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode(body));
    response.close();
  }
}

class _Call {
  _Call(this.method, this.path, this.query, this.body);
  final String method, path, body;
  final Map<String, String> query;
}
