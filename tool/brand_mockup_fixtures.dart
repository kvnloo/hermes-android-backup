// Invented chats and an in-memory gateway for the brand render harness.
// Adapted from ares-apple's store screenshot fixtures. No network access.
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/dashboard_api_client.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const demoConnectionId = 'demo';
const demoModel = 'gpt-5';

SavedConnection demoConnection() => SavedConnection(
  id: demoConnectionId,
  label: 'My gateway',
  host: 'gateway.example.com',
  port: 443,
  apiKey: '',
  useHttps: true,
  desktopGatewayUrl: 'https://gateway.example.com',
  dashboardProxied: true,
  singleLogin: true,
  signInMethod: 'none',
);

double _epoch(DateTime time) => time.millisecondsSinceEpoch / 1000.0;

class DemoChat {
  const DemoChat(this.id, this.title, this.ago, {this.pinned = false});
  final String id;
  final String title;
  final Duration ago;
  final bool pinned;

  Session row(DateTime now) => Session(
    id: id,
    title: title,
    model: demoModel,
    source: 'desktop',
    messageCount: 6,
    isActive: false,
    preview: '',
    startedAt: _epoch(now.subtract(ago + const Duration(hours: 1))),
    lastActive: _epoch(now.subtract(ago)),
    pinned: pinned,
  );
}

/// Neutral sample chats, newest first.
const demoChats = <DemoChat>[
  DemoChat('garden', 'Plan the garden irrigation', Duration(minutes: 12)),
  DemoChat('release', 'Draft release notes', Duration(hours: 2)),
  DemoChat('meeting', 'Summarise meeting notes', Duration(hours: 5)),
  DemoChat('packing', 'Trip packing list', Duration(days: 1, hours: 3)),
  DemoChat('apps', 'Compare two note-taking apps', Duration(days: 2)),
  DemoChat('standup', 'Weekly standup summary', Duration(days: 3)),
  DemoChat('party', 'Birthday party checklist', Duration(days: 5)),
  DemoChat('login', 'Fix the flaky login test', Duration(days: 8)),
  DemoChat('reading', 'Reading list: distributed systems', Duration(days: 12)),
  DemoChat('meals', 'Meal plan for the week', Duration(days: 16)),
];

Map<String, Object> demoPreferences(DateTime now) => {
  'nextgen_enabled': true,
  // Every chat already looked at: no unread dots.
  'nextgen.seen_chats.$demoConnectionId': jsonEncode({
    'since': _epoch(now.subtract(const Duration(days: 60))),
    'chats': {for (final chat in demoChats) chat.id: _epoch(now) + 60},
  }),
};

http.Response _json(Object data, [int status = 200]) => http.Response(
  jsonEncode(data),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

http.Client _demoHttp() => MockClient((request) async {
  final path = request.url.path;
  if (path.endsWith('/model/info')) {
    return _json({
      'model': demoModel,
      'provider': 'openai',
      'effective_context_length': 200000,
      'capabilities': {'supports_tools': true, 'context_window': 200000},
    });
  }
  return _json(const <String, Object>{});
});

class DemoApi extends DashboardApiClient {
  DemoApi(super.dashboard, this.now) : super.withDashboard();
  final DateTime now;

  @override
  Future<bool?> showSubagentSessions({String? profile}) async => false;

  @override
  Future<SessionListPage> getSessionsPage({
    int limit = 50,
    int offset = 0,
    String? title,
    String? excludeSources,
    bool Function()? maySendSearch,
    Duration timeout = ApiClient.requestTimeout,
  }) async => SessionListPage(
    sessions: offset == 0 ? [for (final c in demoChats) c.row(now)] : const [],
    hasMore: false,
  );

  @override
  Future<Uint8List> getMessagesBytes(
    String sessionId, {
    int? limit,
    int offset = 0,
    bool latest = false,
  }) async => utf8.encode(jsonEncode({'messages': const <Object>[]}));

  @override
  Future<void> setSessionUnread(String sessionId, {required bool unread}) =>
      Future.value();
}

/// A connected gateway answering from memory.
class DemoGateway extends NextGenGateway {
  DemoGateway(DateTime now, {this.withProjects = false})
    : super(
        demoConnection(),
        dashboard: DashboardClient.fromConnection(
          demoConnection(),
          httpClient: _demoHttp(),
        ),
      ) {
    api = DemoApi(dashboard, now);
  }

  final bool withProjects;
  final calls = <({String method, Map<String, dynamic> params})>[];
  final WsClient _socket = WsClient('https://gateway.example.com');
  final _liveEvents = StreamController<StreamEvent>.broadcast();
  final _requests = StreamController<NgServerRequest>.broadcast();

  @override
  WsClient? get socket => _socket;

  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

  @override
  Stream<StreamEvent> get events => _liveEvents.stream;

  @override
  Stream<NgServerRequest> get serverRequests => _requests.stream;

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
    calls.add((method: method, params: Map.of(params)));
    switch (method) {
      case 'session.create':
        return {'session_id': 'runtime-new', 'stored_session_id': 'stored-new'};
      case 'session.resume':
        return {'session_id': 'runtime-existing', 'running': false};
      case 'prompt.submit':
        return {'status': 'started'};
      case 'commands.catalog':
        return {'pairs': const <Object>[], 'canon': const <String, Object>{}};
      case 'complete.slash':
        throw JsonRpcError(method, 'Method not found', code: -32601);
      case 'projects.list':
        return {
          'projects': [
            if (withProjects)
              {
                'id': 'home',
                'name': 'Home project',
                'primary_path': '/srv/home',
                'folders': [],
              },
          ],
        };
      case 'projects.tree':
        return {'projects': const <Object>[]};
    }
    return const {};
  }

  @override
  void dispose() {
    _liveEvents.close();
    _requests.close();
    _socket.close();
    super.dispose();
  }
}
