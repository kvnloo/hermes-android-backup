import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/host_operations_screen.dart';
import 'package:hermes_android/core/screens/memory_graph_screen.dart';
import 'package:hermes_android/core/screens/schedule_desk_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/scoped_profile_owner.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late _Api api;

  setUp(() {
    api = _Api();
    debugProfileOwnerBinding = (connection, profile, action) async {
      final owner = _owner(api.client, profile);
      final pane = owner.pane();
      try {
        return await action(await pane.bind(owner.route()));
      } finally {
        pane.close();
        owner.close();
      }
    };
  });

  tearDown(() => debugProfileOwnerBinding = null);

  testWidgets('Host hides an ineligible remote update', (tester) async {
    final owner = _owner(api.client, 'work');
    addTearDown(owner.close);
    await tester.pumpWidget(
      MaterialApp(
        home: HostOperationsScreen(
          owner: owner,
          route: owner.route(),
          connection: _connection,
        ),
      ),
    );
    await _shown(tester, find.textContaining('gateway ready'));
    expect(find.text('Managed by Docker.'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('host-update')))
          .onPressed,
      isNull,
    );
    expect(api.methodsFor('/api/hermes/update'), isNot(contains('POST')));
    expect(find.textContaining('not this device'), findsWidgets);
  });

  testWidgets('Schedules stops the owning profile current run', (tester) async {
    final owner = _owner(api.client, 'work');
    addTearDown(owner.close);
    await tester.pumpWidget(
      MaterialApp(
        home: ScheduleDeskScreen(
          owner: owner,
          route: owner.route(),
          connection: _connection,
        ),
      ),
    );
    final stop = find.byKey(const Key('schedule-stop-alpha-nightly'));
    await _shown(tester, stop);
    expect(find.byKey(const Key('schedule-stop-work-daily')), findsNothing);
    await tester.tap(stop);
    await _shown(tester, find.textContaining('Stop requested'));
    expect(
      api.calls.any(
        (call) =>
            call.method == 'POST' &&
            call.path.endsWith('/cancel') &&
            call.query['profile'] == 'alpha',
      ),
      isTrue,
    );
    expect(api.calls.any((call) => call.path.endsWith('/pause')), isFalse);
  });

  testWidgets('memory graph filters and shares layout only', (tester) async {
    final owner = _owner(api.client, 'work');
    addTearDown(owner.close);
    await tester.pumpWidget(
      MaterialApp(
        home: MemoryGraphScreen(
          owner: owner,
          route: owner.route(),
          connection: _connection,
        ),
      ),
    );
    await _shown(tester, find.text('Packing'));
    final code = tester
        .widget<TextField>(find.byKey(const Key('memory-layout-code')))
        .controller!
        .text;
    expect(code, startsWith('HML1|'));
    expect(code.contains('Packing'), isFalse);
    await tester.enterText(find.byKey(const Key('memory-filter')), 'nope');
    await tester.pump();
    expect(find.text('Packing'), findsNothing);
    expect(find.textContaining('12 bytes'), findsOneWidget);
  });
}

final _connection = SavedConnection(
  id: 'ops-widget',
  label: 'Ops fixture',
  host: '127.0.0.1',
  port: 9,
  apiKey: 'not-a-live-key',
  dashboardUsername: 'fixture',
  dashboardPassword: 'secret-fixture',
  gatewayProfile: 'work',
);

RemoteWorkspaceOwner _owner(http.Client client, String profile) {
  final dashboard = DashboardClient(
    host: '127.0.0.1',
    port: 9,
    username: 'fixture',
    password: 'secret-fixture',
    gatewayProfile: profile,
    httpClient: client,
  );
  return RemoteWorkspaceOwner(
    connectionId: 'ops-widget',
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

class _Call {
  _Call(this.method, this.path, this.query);
  final String method, path;
  final Map<String, String> query;
}

class _Api {
  _Api() {
    client = MockClient((request) async {
      calls.add(
        _Call(request.method, request.url.path, request.url.queryParameters),
      );
      if (request.url.path == '/auth/password-login') {
        return http.Response(
          jsonEncode({'ok': true}),
          200,
          headers: {'set-cookie': 'hermes_session_at=secret-cookie'},
        );
      }
      return http.Response(jsonEncode(_body(request)), 200);
    });
  }

  late final MockClient client;
  final calls = <_Call>[];

  List<String> methodsFor(String suffix) => [
    for (final call in calls)
      if (call.path.endsWith(suffix)) call.method,
  ];

  Object? _body(http.Request request) {
    final path = request.url.path;
    if (path.endsWith('/api/logs')) {
      return {
        'file': request.url.queryParameters['file'],
        'lines': ['gateway ready'],
      };
    }
    if (path.endsWith('/api/status')) {
      return {
        'gateway_running': true,
        'version': '9.9.9',
        'active_sessions': 1,
        'gateway_state': 'running',
        'gateway_shared_with': ['work'],
      };
    }
    if (path.endsWith('/api/hermes/update/check')) {
      return {
        'install_method': 'docker',
        'current_version': '9.9.9',
        'behind': 0,
        'update_available': false,
        'can_apply': false,
        'message': 'Managed by Docker.',
      };
    }
    if (path.endsWith('/api/tools/computer-use/status')) {
      return {
        'platform': 'linux',
        'platform_supported': true,
        'installed': false,
        'ready': false,
        'can_grant': false,
        'checks': <Object>[],
        'accessibility': null,
        'screen_recording': null,
        'error': null,
      };
    }
    if (path.endsWith('/api/curator')) {
      return {'enabled': true, 'paused': false, 'last_run_at': null};
    }
    if (path.endsWith('/api/cron/jobs')) {
      return [
        {
          'id': 'nightly',
          'profile': 'alpha',
          'profile_name': 'alpha',
          'name': 'Nightly',
          'enabled': true,
          'deliver': 'local',
          'catch_up': null,
          'latest_execution': {'id': 'e1', 'status': 'running'},
        },
        {
          'id': 'daily',
          'profile': 'work',
          'profile_name': 'work',
          'name': 'Daily',
          'enabled': true,
          'deliver': 'local',
          'catch_up': null,
          'latest_execution': {'id': 'e2', 'status': 'completed'},
        },
      ];
    }
    if (path.endsWith('/cancel')) {
      return {'cancelled': true, 'job_id': 'nightly', 'execution_id': 'e1'};
    }
    if (path.endsWith('/api/cron/blueprints')) {
      return {'blueprints': <Object>[]};
    }
    if (path.endsWith('/api/cron/delivery-targets')) {
      return {
        'targets': [
          {'id': 'local', 'name': 'Local', 'home_target_set': true},
        ],
      };
    }
    if (path.endsWith('/api/learning/graph')) {
      return {
        'nodes': [
          {
            'id': 'packing',
            'label': 'Packing',
            'kind': 'skill',
            'category': 'home',
            'timestamp': 10,
            'useCount': 1,
            'state': 'active',
            'pinned': false,
          },
        ],
        'edges': <Object>[],
      };
    }
    if (path.endsWith('/api/memory')) {
      return {
        'active': '',
        'providers': <Object>[],
        'builtin_files': {'memory': 12, 'user': 4},
      };
    }
    return {'ok': true};
  }
}

Future<void> _shown(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 40 && finder.evaluate().isEmpty; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  expect(
    finder,
    findsWidgets,
    reason: tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data)
        .join(' | '),
  );
}
