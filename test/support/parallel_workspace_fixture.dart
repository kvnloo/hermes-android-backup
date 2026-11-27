import 'dart:async';
import 'dart:convert';

import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Physical HTTP boundary with the real profile-aware REST adapters; no socket,
/// saved account or production endpoint is involved.
class ParallelFixture {
  ParallelFixture({this.profile, this.dashboard = false});
  final String? profile;
  final bool dashboard;
  final requests = <Uri>[];
  Completer<void>? rosterGate;
  late final connection = SavedConnection(
    id: 'parallel-fixture',
    label: 'Fixture',
    host: 'parallel.invalid',
    port: 9119,
    apiKey: '',
    gatewayProfile: profile,
    singleLogin: dashboard,
    desktopGatewayUrl: dashboard ? 'http://parallel.invalid:9119' : null,
    dashboardProxied: dashboard,
  );

  MockClient client() => MockClient((req) async {
    final uri = req.url;
    requests.add(uri);
    final path = uri.path;
    Object body = {};
    if (path == '/api/sessions') {
      await rosterGate?.future;
      final rows = [
        if ((uri.queryParameters['offset'] ?? '0') == '0')
          for (final id in ['alpha', 'beta'])
            {
              'id': id,
              'title': 'Chat $id',
              'source': 'desktop',
              'started_at': 1700000000,
              'message_count': 1,
            },
      ];
      body = dashboard
          ? {'sessions': rows, 'total': 2}
          : {'data': rows, 'has_more': false};
    } else if (path.endsWith('/messages')) {
      final id = uri.pathSegments[2];
      body = {
        dashboard ? 'messages' : 'data': [
          {
            'id': 1,
            'role': 'user',
            'content': 'History ${profile ?? "legacy"} $id',
            'timestamp': 1700000000,
          },
        ],
      };
    } else if (path.startsWith('/api/sessions/')) {
      body = {'id': uri.pathSegments.last, 'archived': false};
    }
    return http.Response(
      jsonEncode(body),
      200,
      headers: {'content-type': 'application/json'},
    );
  });
  ApiClient api() => ApiClient.forConnection(connection, httpClient: client());
}

class ParallelFixtureGateway extends NextGenGateway {
  ParallelFixtureGateway(ParallelFixture f)
    : super(
        f.connection,
        dashboard: DashboardClient.fromConnection(
          f.connection,
          httpClient: f.client(),
        ),
      );
  final _socket = WsClient('http://parallel.invalid:9119'); // Never connected.
  final resumes = <String>[];
  @override
  void start() {} // In-process event bus and RPCs, no start/network loop.
  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);
  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => _socket;
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (method == 'session.resume') {
      final id = params['session_id'] as String;
      resumes.add(id);
      return {'session_id': 'runtime-$id', 'stored_session_id': id};
    }
    return {};
  }
}
