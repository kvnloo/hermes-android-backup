import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A dashboard Kanban plugin in memory, enough for the board screen (F12) to
/// load, list its cards and open one card's detail sheet. No sockets: the
/// board's event stream is refused, so it keeps its own poll.
class KanbanBoardFixture {
  KanbanBoardFixture({List<Map<String, dynamic>>? tasks})
    : tasks = tasks ?? [] {
    client = MockClient(_handle);
  }

  late final MockClient client;
  final List<Map<String, dynamic>> tasks;

  /// `METHOD path?query` of every Kanban request, in order.
  final List<String> requests = [];

  http.Response _json(Object data) => http.Response.bytes(
    utf8.encode(jsonEncode(data)),
    200,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );

  Future<http.Response> _handle(http.Request request) async {
    final path = request.url.path;
    if (path == '/auth/password-login') {
      return http.Response(
        jsonEncode({'ok': true}),
        200,
        headers: {'set-cookie': 'hermes_session_at=fixture-cookie'},
      );
    }
    const root = '/api/plugins/kanban';
    if (!path.startsWith(root)) return _json({'ok': true});
    requests.add('${request.method} ${request.url.path}?${request.url.query}');
    final rest = path.substring(root.length);
    final board = request.url.queryParameters['board'] ?? 'default';
    final onBoard = [
      for (final task in tasks)
        if ((task['board'] ?? 'default') == board) task,
    ];
    if (rest == '/boards') {
      return _json({
        'current': 'default',
        'boards': [
          {'slug': 'default', 'name': 'Default', 'is_current': true},
          {'slug': 'ops-board', 'name': 'Ops', 'is_current': false},
        ],
      });
    }
    if (rest == '/board') {
      final archived = request.url.queryParameters['include_archived'];
      return _json({
        'columns': [
          for (final column in [
            ...kanbanWorkflowColumns,
            if (archived == 'true') 'archived',
          ])
            {
              'name': column,
              'tasks': [
                for (final task in onBoard)
                  if (task['status'] == column) task,
              ],
            },
        ],
        'tenants': const <String>[],
        'assignees': const ['builder'],
        'latest_event_id': 12,
        'now': 1700000000,
      });
    }
    if (rest == '/profiles') {
      return _json({
        'profiles': [
          {'name': 'builder', 'is_default': true},
        ],
      });
    }
    if (rest == '/projects') return _json({'projects': const []});
    if (rest == '/orchestration') {
      return _json({
        'orchestrator_profile': 'builder',
        'default_assignee': 'builder',
        'auto_decompose': false,
      });
    }
    if (rest.startsWith('/tasks/') && request.method == 'GET') {
      final parts = rest.split('/');
      final task = onBoard.where((t) => t['id'] == parts[2]).firstOrNull;
      if (task == null) return http.Response('{"detail":"not found"}', 404);
      if (parts.length > 3 && parts[3] == 'log') {
        return _json({'task_id': task['id'], 'exists': false, 'content': ''});
      }
      return _json({
        'task': task,
        'comments': const [],
        'events': const [],
        'attachments': const [],
        'links': {'parents': const [], 'children': const []},
        'link_tasks': const [],
        'runs': const [],
      });
    }
    return _json({'ok': true});
  }
}

/// A gateway owner whose dashboard is [client], bound without a real socket.
RemoteWorkspaceOwner makeKanbanOwner(
  http.Client client, {
  required String connectionId,
  String? profile,
}) {
  final dashboard = DashboardClient(
    host: '127.0.0.1',
    port: 9,
    username: 'fixture',
    password: 'fixture-password',
    gatewayProfile: profile,
    httpClient: client,
  );
  return RemoteWorkspaceOwner(
    connectionId: connectionId,
    expectedBaseUrl: dashboard.baseUrl,
    profile: profile,
    dashboard: dashboard,
    connect: () async => _ReadySocket(dashboard.baseUrl),
    ownsSocket: (_) => true,
  );
}

class _ReadySocket extends Fake implements WsClient {
  _ReadySocket(this.baseUrl);
  @override
  final String baseUrl;
  @override
  int get socketEpoch => 1;
  @override
  bool get isConnected => true;
  @override
  Future<Map<String, dynamic>> waitForGatewayReady({
    Duration timeout = const Duration(seconds: 15),
  }) async => {};
}
