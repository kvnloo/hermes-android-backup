import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/ws_client.dart';

import 'support/strict_authority_gateway.dart';

const _url = 'https://cwd.example.invalid';

class _Dashboard extends Fake implements DashboardClient {
  _Dashboard(this.socket);
  final _Socket socket;

  @override
  String get baseUrl => _url;
  @override
  String get gatewayProfile => 'work';

  @override
  Future<Object?> workspaceJson(
    List<String> segments, {
    required Map<String, String> query,
    required void Function() check,
    bool mintHostTerminalTicket = false,
    String? webappDirection,
    bool makeWebappPrimary = false,
    bool startFleetUpdate = false,
    void Function()? beforeSend,
  }) async {
    check();
    expect(query['profile'], 'work');
    expect(mintHostTerminalTicket, isFalse);
    expect(webappDirection, isNull);
    expect(makeWebappPrimary || startFleetUpdate, isFalse);
    final route = segments.join('/');
    socket.reads.add(route);
    if (route == 'sessions/stored') {
      return {
        'id': 'stored',
        'profile': 'work',
        'cwd': socket.cwd,
        'git_metadata_generation': 1,
      };
    }
    if (route == 'sessions/stored/mutation-snapshot') {
      return {
        'session_id': 'stored',
        'exists': true,
        'runtime_revision': socket.revision,
        'runtime_generation': socket.generation,
      };
    }
    throw StateError(route);
  }
}

class _Socket extends Fake implements WsClient {
  String cwd = '/srv/work';
  int revision = 4;
  int generation = 9;
  final reads = <String>[];
  final calls = <Map<String, dynamic>>[];

  @override
  String get baseUrl => _url;
  @override
  int socketEpoch = 1;
  @override
  WorkspaceRuntime? workspaceBinding(String storedId) => null;
  @override
  Future<Map<String, dynamic>> waitForGatewayReady({Duration? timeout}) async =>
      {
        'method': 'event',
        'params': {
          'type': 'gateway.ready',
          'payload': {'session_authority': true},
        },
      };

  @override
  Future<Map<String, dynamic>> send(
    String method,
    Map<String, dynamic> params, {
    Duration? timeout,
    void Function()? onSent,
    bool includeProfile = true,
  }) async {
    expect(includeProfile, isFalse);
    calls.add({'method': method, ...params});
    // This fake stands for the socket of a session authority: a frame the
    // pinned gateway refuses is refused here too.
    final refused = strictAuthorityReply(null, method, params);
    if (refused != null) return refused;
    if (method != 'session.mutate') throw StateError(method);
    cwd = (params['payload'] as Map)['cwd'] as String;
    revision = (params['expected_revision'] as int) + 1;
    return {
      'result': {
        'session_id': 'stored',
        'operation': 'workspace',
        'revision': revision,
        'cwd': cwd,
      },
    };
  }
}

void main() {
  test(
    'workspace move uses the closed mutate field set and the fresh fences',
    () async {
      final socket = _Socket();
      final owner = RemoteWorkspaceOwner(
        connectionId: 'cwd-fixture',
        expectedBaseUrl: _url,
        profile: 'work',
        dashboard: _Dashboard(socket),
        connect: () async => socket,
        ownsSocket: (ws) => identical(ws, socket),
      );
      final pane = owner.pane();
      final target = await pane.bind(owner.route(storedSessionId: 'stored'));
      await target.changeCwd('/srv/other', (revision: 4, generation: 9));
      final sent = socket.calls.single;
      expect(sent.keys.toSet(), {
        'method',
        'session_id',
        'request_id',
        'operation',
        'expected_revision',
        'expected_generation',
        'payload',
      });
      expect(sent['request_id'], isA<String>());
      expect((sent['request_id'] as String).isNotEmpty, isTrue);
      expect(sent['payload'], {'cwd': '/srv/other'});
      expect(sent['expected_revision'], 4);
      expect(socket.cwd, '/srv/other');
      pane.close();
      owner.close();
    },
  );

  test(
    'a newer revision fence is refused before any workspace mutation',
    () async {
      final socket = _Socket()..revision = 8;
      final owner = RemoteWorkspaceOwner(
        connectionId: 'cwd-fixture',
        expectedBaseUrl: _url,
        profile: 'work',
        dashboard: _Dashboard(socket),
        connect: () async => socket,
        ownsSocket: (ws) => identical(ws, socket),
      );
      final pane = owner.pane();
      final target = await pane.bind(owner.route(storedSessionId: 'stored'));
      await expectLater(
        target.changeCwd('/srv/later', (revision: 4, generation: 9)),
        throwsA(
          isA<WorkspaceException>().having(
            (e) => e.reason,
            'reason',
            WorkspaceFailure.mismatch,
          ),
        ),
      );
      expect(socket.calls, isEmpty);
      expect(socket.cwd, '/srv/work');
      pane.close();
      owner.close();
    },
  );

  test(
    'review: a trailing slash is normalised before the workspace mutate',
    () async {
      final socket = _Socket();
      final owner = RemoteWorkspaceOwner(
        connectionId: 'cwd-fixture',
        expectedBaseUrl: _url,
        profile: 'work',
        dashboard: _Dashboard(socket),
        connect: () async => socket,
        ownsSocket: (ws) => identical(ws, socket),
      );
      final pane = owner.pane();
      final target = await pane.bind(owner.route(storedSessionId: 'stored'));
      await target.changeCwd('/srv/other/', (revision: 4, generation: 9));
      expect(socket.calls.single['payload'], {'cwd': '/srv/other'});
      expect(socket.cwd, '/srv/other');
      pane.close();
      owner.close();
    },
  );
}
