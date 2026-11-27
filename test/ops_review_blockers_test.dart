// Ports the ops review repros. Each test fails on 73e8f67a and passes once
// the receipt, busy hold, provider save and delivery editor are fixed.
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
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/testing.dart';

typedef _Handler = Object? Function(http.Request request);

class _Call {
  _Call(this.method, this.path, this.query, this.body);
  final String method, path, body;
  final Map<String, String> query;
}

class _Api {
  _Api(this.handler) {
    client = MockClient((request) async {
      calls.add(
        _Call(
          request.method,
          request.url.path,
          request.url.queryParameters,
          request.body,
        ),
      );
      if (request.url.path == '/auth/password-login') {
        return http.Response(
          jsonEncode({'ok': true}),
          200,
          headers: {'set-cookie': 'hermes_session_at=secret-cookie'},
        );
      }
      return http.Response(jsonEncode(handler(request) ?? {'ok': true}), 200);
    });
  }

  final _Handler handler;
  late final MockClient client;
  final calls = <_Call>[];

  Iterable<_Call> posts(String suffix) => calls.where(
    (call) => call.method == 'POST' && call.path.endsWith(suffix),
  );
}

final _connection = SavedConnection(
  id: 'ops-review',
  label: 'Ops review',
  host: '127.0.0.1',
  port: 9,
  apiKey: 'not-a-live-key',
  dashboardUsername: 'fixture',
  dashboardPassword: 'secret-fixture',
  gatewayProfile: 'work',
);

RemoteWorkspaceOwner _owner(http.Client client, String? profile) {
  final dashboard = DashboardClient(
    host: '127.0.0.1',
    port: 9,
    username: 'fixture',
    password: 'secret-fixture',
    gatewayProfile: profile,
    httpClient: client,
  );
  return RemoteWorkspaceOwner(
    connectionId: 'ops-review',
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

Future<void> _settle(WidgetTester tester, [int rounds = 30]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
}

void _wide(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Map<String, Object?> _hostDefaults(
  http.Request request, {
  int sessions = 0,
  String? installId = 'ops-review',
}) {
  final path = request.url.path;
  if (path.endsWith('/api/logs')) {
    return {'file': request.url.queryParameters['file'], 'lines': <String>[]};
  }
  if (path.endsWith('/api/status')) {
    return {
      'gateway_running': true,
      'version': '9.9.9',
      'active_sessions': sessions,
      'install_id': ?installId,
      'gateway_state': 'running',
      'gateway_shared_with': ['work'],
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
    };
  }
  if (path.endsWith('/api/curator')) {
    return {'enabled': true, 'paused': false, 'last_run_at': null};
  }
  if (path.endsWith('/api/learning/graph')) {
    return {'nodes': <Object>[], 'edges': <Object>[]};
  }
  return {'ok': true};
}

Map<String, Object?> _eligibleUpdate() => {
  'install_method': 'git',
  'current_version': '9.9.9',
  'behind': 3,
  'update_available': true,
  'can_apply': true,
  'message': null,
};

void main() {
  tearDown(() => debugProfileOwnerBinding = null);

  testWidgets(
    'a running update with the previous receipt stays awaiting, and recheck does not post again',
    (tester) async {
      _wide(tester);
      final api = _Api((request) {
        final path = request.url.path;
        if (path.endsWith('/api/hermes/update/check')) return _eligibleUpdate();
        if (path.endsWith('/api/hermes/update') && request.method == 'POST') {
          return {
            'ok': true,
            'pid': 7,
            'name': 'hermes-update',
            'action_id': 'a' * 32,
          };
        }
        if (path.endsWith('/api/actions/hermes-update/status')) {
          // Pinned gateway: a live run omits action_id and the receipt is
          // the previous run.
          return {
            'name': 'hermes-update',
            'running': true,
            'exit_code': null,
            'pid': 7,
            'lines': <String>[],
            'receipt': {
              'action_id': 'b' * 32,
              'outcome': 'success',
              'followups': <Object>[],
            },
          };
        }
        return _hostDefaults(request);
      });
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
      await _settle(tester);
      await tester.tap(find.byKey(const Key('host-update')));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await _settle(tester);
      expect(api.posts('/api/hermes/update'), hasLength(1));
      expect(find.textContaining('Awaiting matching receipt'), findsOneWidget);
      expect(find.text('Remote workspace: mismatch'), findsNothing);
      await tester.tap(find.byKey(const Key('host-update-recheck')));
      await _settle(tester);
      expect(api.posts('/api/hermes/update'), hasLength(1));
      expect(find.textContaining('Awaiting matching receipt'), findsOneWidget);
    },
  );

  testWidgets(
    'an update is not posted while this installation has active sessions',
    (tester) async {
      _wide(tester);
      final api = _Api((request) {
        final path = request.url.path;
        if (path.endsWith('/api/hermes/update/check')) return _eligibleUpdate();
        if (path.endsWith('/api/hermes/update') && request.method == 'POST') {
          return {
            'ok': true,
            'name': 'hermes-update',
            'pid': 7,
            'action_id': 'a' * 32,
          };
        }
        return _hostDefaults(request, sessions: 2);
      });
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
      await _settle(tester);
      await tester.tap(find.byKey(const Key('host-update')));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await _settle(tester);
      expect(api.posts('/api/hermes/update'), isEmpty);
      expect(
        find.textContaining('A chat on this installation is running'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'a chat that starts after the first admission check still holds the update POST',
    (tester) async {
      _wide(tester);
      var armed = false;
      var armedStatusReads = 0;
      final api = _Api((request) {
        final path = request.url.path;
        if (path.endsWith('/api/hermes/update/check')) return _eligibleUpdate();
        if (path.endsWith('/api/status')) {
          var sessions = 0;
          if (armed) {
            armedStatusReads++;
            if (armedStatusReads >= 2) sessions = 2;
          }
          return _hostDefaults(request, sessions: sessions);
        }
        if (path.endsWith('/api/hermes/update') && request.method == 'POST') {
          return {
            'ok': true,
            'name': 'hermes-update',
            'pid': 7,
            'action_id': 'a' * 32,
          };
        }
        return _hostDefaults(request);
      });
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
      await _settle(tester);
      armed = true;
      await tester.tap(find.byKey(const Key('host-update')));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await _settle(tester);
      expect(armedStatusReads, greaterThanOrEqualTo(2));
      expect(api.posts('/api/hermes/update'), isEmpty);
      expect(
        find.textContaining('A chat on this installation is running'),
        findsOneWidget,
      );
    },
  );

  testWidgets('an unknown installation blocks the update POST', (tester) async {
    _wide(tester);
    final api = _Api((request) {
      final path = request.url.path;
      if (path.endsWith('/api/hermes/update/check')) return _eligibleUpdate();
      if (path.endsWith('/api/hermes/update') && request.method == 'POST') {
        return {
          'ok': true,
          'name': 'hermes-update',
          'pid': 7,
          'action_id': 'a' * 32,
        };
      }
      return _hostDefaults(request, installId: null);
    });
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
    await _settle(tester);
    await tester.tap(find.byKey(const Key('host-update')));
    await tester.pump();
    await tester.tap(find.text('Confirm'));
    await _settle(tester);
    expect(api.posts('/api/hermes/update'), isEmpty);
    expect(find.textContaining('installation is unknown'), findsOneWidget);
  });

  testWidgets(
    'saving one memory-provider field keeps the other stored values',
    (tester) async {
      _wide(tester);
      tester.view.physicalSize = const Size(800, 3000);
      final api = _Api((request) {
        final path = request.url.path;
        if (path.endsWith('/api/memory') && request.method == 'GET') {
          return {
            'active': 'hindsight',
            'providers': [
              {
                'name': 'hindsight',
                'description': 'External',
                'available': true,
                'configured': true,
                'status': 'ready',
              },
            ],
            'builtin_files': {'memory': 1, 'user': 1},
          };
        }
        if (path.endsWith('/config') && request.method == 'GET') {
          return {
            'name': 'hindsight',
            'label': 'Hindsight',
            'fields': [
              {
                'key': 'base_url',
                'label': 'Base URL',
                'kind': 'text',
                'is_set': true,
                'value': 'https://mem.example.test',
              },
              {
                'key': 'bank',
                'label': 'Bank',
                'kind': 'text',
                'is_set': true,
                'value': 'main',
              },
              {
                'key': 'auto_recall',
                'label': 'Auto recall',
                'kind': 'bool',
                'is_set': true,
                'value': 'true',
              },
              {
                'key': 'api_key',
                'label': 'API key',
                'kind': 'secret',
                'is_set': true,
                'value': '',
              },
            ],
          };
        }
        return _hostDefaults(request);
      });
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
      await _settle(tester);
      await tester.tap(find.textContaining('hindsight ('));
      await _settle(tester);
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('provider-field-base_url')))
            .controller!
            .text,
        'https://mem.example.test',
      );
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('provider-field-bank')))
            .controller!
            .text,
        'main',
      );
      await tester.enterText(
        find.byKey(const Key('provider-field-bank')),
        'research',
      );
      await tester.tap(find.byKey(const Key('provider-save')));
      await _settle(tester);
      final put = api.calls.singleWhere(
        (call) => call.method == 'PUT' && call.path.endsWith('/config'),
      );
      expect(jsonDecode(put.body), {
        'values': {'bank': 'research'},
      });
      await tester.enterText(
        find.byKey(const Key('provider-field-base_url')),
        '',
      );
      await tester.tap(find.byKey(const Key('provider-save')));
      await _settle(tester);
      final puts = api.calls.where(
        (call) => call.method == 'PUT' && call.path.endsWith('/config'),
      );
      expect(jsonDecode(puts.last.body), {
        'values': {'bank': 'research'},
      });
    },
  );

  testWidgets('a memory entry that cannot be opened shows the error', (
    tester,
  ) async {
    _wide(tester);
    final api = _Api((request) {
      final path = request.url.path;
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
      if (path.endsWith('/api/learning/node')) return {'ok': false};
      if (path.endsWith('/api/memory') && request.method == 'GET') {
        return {
          'active': '',
          'providers': <Object>[],
          'builtin_files': {'memory': 12, 'user': 4},
        };
      }
      return _hostDefaults(request);
    });
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
    await _settle(tester);
    await tester.tap(find.byKey(const Key('memory-node-packing')));
    await _settle(tester);
    expect(find.byKey(const Key('memory-error')), findsOneWidget);
    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(
      find.text(
        l10n.release_core_workspace_operation_failed(
          l10n.release_core_workspace_failure_invalid,
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'after a list refresh a delivery editor keeps its own profile targets',
    (tester) async {
      _wide(tester);
      tester.view.physicalSize = const Size(800, 3000);
      var listed = 0;
      Map<String, Object?> job(String id, String profile) => {
        'id': id,
        'profile': profile,
        'profile_name': profile,
        'name': id,
        'enabled': true,
        'deliver': 'local',
        'catch_up': null,
        'latest_execution': null,
      };
      final api = _Api((request) {
        final path = request.url.path;
        final profile = request.url.queryParameters['profile'];
        if (path.endsWith('/api/cron/jobs') && request.method == 'GET') {
          listed++;
          return listed == 1
              ? [job('nightly', 'alpha'), job('daily', 'work')]
              : [
                  job('fresh', 'work'),
                  job('nightly', 'alpha'),
                  job('daily', 'work'),
                ];
        }
        if (path.endsWith('/api/cron/delivery-targets')) {
          return {
            'targets': [
              {'id': 'local', 'name': 'Local', 'home_target_set': true},
              if (profile == 'work')
                {'id': 'telegram', 'name': 'Telegram', 'home_target_set': true},
            ],
          };
        }
        if (path.endsWith('/api/cron/blueprints')) {
          return {'blueprints': <Object>[]};
        }
        return _hostDefaults(request);
      });
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
      await _settle(tester);
      expect(find.widgetWithText(FilterChip, 'Telegram'), findsOneWidget);
      await tester.tap(find.byTooltip('Refresh'));
      await _settle(tester);
      final alphaCard = find.ancestor(
        of: find.byKey(const Key('schedule-job-alpha-nightly')),
        matching: find.byType(Card),
      );
      expect(
        find.descendant(
          of: alphaCard,
          matching: find.widgetWithText(FilterChip, 'Telegram'),
        ),
        findsNothing,
      );
      final workCard = find.ancestor(
        of: find.byKey(const Key('schedule-job-work-daily')),
        matching: find.byType(Card),
      );
      expect(
        find.descendant(
          of: workCard,
          matching: find.widgetWithText(FilterChip, 'Telegram'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('a malformed delivery target is rejected without throwing', (
    tester,
  ) async {
    _wide(tester);
    final api = _Api((request) {
      final path = request.url.path;
      if (path.endsWith('/api/cron/jobs') && request.method == 'GET') {
        return [
          {
            'id': 'daily',
            'profile': 'work',
            'profile_name': 'work',
            'name': 'daily',
            'enabled': true,
            'deliver': 'bad id',
            'catch_up': null,
            'latest_execution': null,
          },
        ];
      }
      if (path.endsWith('/api/cron/delivery-targets')) {
        return {
          'targets': [
            {'id': 'local', 'name': 'Local', 'home_target_set': true},
            {'id': 'telegram', 'name': 'Telegram', 'home_target_set': true},
          ],
        };
      }
      if (path.endsWith('/api/cron/blueprints')) {
        return {'blueprints': <Object>[]};
      }
      return _hostDefaults(request);
    });
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
    await _settle(tester);
    await tester.tap(find.widgetWithText(FilterChip, 'Local'));
    await _settle(tester);
    expect(
      find.text(
        lookupAppLocalizations(
          const Locale('en'),
        ).release_core_schedule_invalid_delivery_target,
      ),
      findsOneWidget,
    );
    expect(api.calls.where((call) => call.method == 'PUT'), isEmpty);
  });

  testWidgets('restart confirmation warns that live turns are interrupted', (
    tester,
  ) async {
    _wide(tester);
    final api = _Api((request) => _hostDefaults(request));
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
    await _settle(tester);
    await tester.tap(find.byKey(const Key('host-restart')));
    await tester.pump();
    expect(find.textContaining('interrupted'), findsOneWidget);
    expect(api.posts('/api/gateway/restart'), isEmpty);
  });

  testWidgets('a profile-less connection uses the gateway default', (
    tester,
  ) async {
    _wide(tester);
    final api = _Api((request) => _hostDefaults(request));
    final owner = _owner(api.client, null);
    addTearDown(owner.close);
    final connection = SavedConnection(
      id: 'ops-review',
      label: 'Ops review',
      host: '127.0.0.1',
      port: 9,
      apiKey: 'not-a-live-key',
      dashboardUsername: 'fixture',
      dashboardPassword: 'secret-fixture',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HostOperationsScreen(
          owner: owner,
          route: owner.route(),
          connection: connection,
        ),
      ),
    );
    await _settle(tester);
    expect(find.byKey(const Key('host-error')), findsNothing);
    expect(find.textContaining('gateway default'), findsOneWidget);
    expect(
      api.calls
          .singleWhere((call) => call.path.endsWith('/api/status'))
          .query['profile'],
      'default',
    );
  });
}
