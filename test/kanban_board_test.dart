import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/kanban_board_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/more_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _shown(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 40 && finder.evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 15)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  expect(finder, findsWidgets);
}

Future<void> _step(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 80));
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'Kanban board switches boards, enforces locked columns, handles 409 parent blocks, creates tasks, bulk updates, edits drawer links/logs, and saves orchestration',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final api = _KanbanFixtureApi();
      final owner = _makeOwner(
        api.client,
        connectionId: 'c-kanban',
        profile: 'work',
      );
      addTearDown(owner.close);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: KanbanBoardScreen(
            owner: owner,
            route: owner.route(),
            connection: _fixtureConnection,
            enableLivePolling: false,
          ),
        ),
      );
      await _shown(tester, find.byKey(const Key('kanban-active-count')));

      // Active count badge (2 ready + 1 running = 3 active).
      expect(find.text('3 active'), findsOneWidget);
      expect(find.text('Kanban · default'), findsOneWidget);

      // Dragging onto a locked column ('running') is rejected client-side.
      final runningTarget = tester.widget<DragTarget<KanbanTaskCard>>(
        find.byKey(const Key('kanban-column-running')),
      );
      expect(
        runningTarget.onWillAcceptWithDetails!(
          DragTargetDetails<KanbanTaskCard>(
            data: const KanbanTaskCard(
              id: 't_todo_1',
              title: 'Parent gated task',
              status: 'todo',
            ),
            offset: Offset.zero,
          ),
        ),
        isFalse,
      );

      // Attempting to move parent-blocked card 't_todo_1' to 'ready' surfaces the 409 detail.
      await tester.tap(find.byKey(const Key('kanban-move-t_todo_1')));
      await _step(tester);
      await tester.tap(find.text('Move to Ready'));
      await _shown(
        tester,
        find.textContaining(
          "Cannot move to 'ready': blocked by parent t_run_1",
        ),
      );

      // Create a new task with skills, model override, and complexity estimate.
      await tester.tap(find.byKey(const Key('kanban-new-task-button')));
      await _shown(tester, find.byKey(const Key('kanban-new-title')));
      await tester.enterText(
        find.byKey(const Key('kanban-new-title')),
        'Implement kanban regression',
      );
      await tester.tap(find.byKey(const Key('kanban-new-estimate')));
      await _shown(tester, find.textContaining('Complexity M'));
      final skillsField = find.byKey(const Key('kanban-new-skills'));
      await tester.ensureVisible(skillsField);
      await tester.enterText(skillsField, 'flutter, testing');
      final providerField = find.byKey(const Key('kanban-new-provider'));
      await tester.ensureVisible(providerField);
      await tester.enterText(providerField, 'openrouter');
      final modelField = find.byKey(const Key('kanban-new-model'));
      await tester.ensureVisible(modelField);
      await tester.enterText(modelField, 'gpt-5');
      await tester.tap(find.byKey(const Key('kanban-new-submit')));
      await _shown(tester, find.byKey(const Key('kanban-card-t_created_1')));

      final createCall = api.calls.singleWhere(
        (c) => c.method == 'POST' && c.path == '/api/plugins/kanban/tasks',
      );
      expect(createCall.query['profile'], 'work');
      expect(createCall.body?['skills'], contains('flutter'));
      expect(createCall.body?['model_override'], 'gpt-5');

      // Multi-select bulk assign with partial failure keeps the failed ID selected.
      await tester.tap(find.byKey(const Key('kanban-multiselect-toggle')));
      await _step(tester);
      await tester.tap(find.byKey(const Key('kanban-select-t_ready_1')));
      await tester.tap(find.byKey(const Key('kanban-select-t_fail_bulk')));
      await _step(tester);
      expect(find.byKey(const Key('kanban-selection-bar')), findsOneWidget);

      await tester.tap(find.byKey(const Key('kanban-bulk-assign')));
      await _step(tester);
      await tester.tap(find.text('@researcher').last);
      await _step(tester);
      await tester.tap(find.byKey(const Key('kanban-confirm-ok')));
      await _shown(tester, find.textContaining('1 of 2 failed'));
      expect(find.text('1 selected'), findsOneWidget);
      await tester.tap(find.text('Clear'));
      await _step(tester);

      // Open task detail drawer on running card 't_run_1': reassign, inspect runs & log, comment & requeue, links.
      await tester.tap(find.byKey(const Key('kanban-card-t_run_1')));
      await _shown(tester, find.textContaining('t_run_1 · Running'));

      // Reassigning a running card hits POST /tasks/{id}/reassign with reclaim_first: true.
      await tester.tap(find.byKey(const Key('kanban-detail-assignee')));
      await _step(tester);
      await tester.tap(find.text('@researcher').last);
      await _step(tester);
      await tester.tap(find.byKey(const Key('kanban-confirm-ok')));
      await _step(tester);
      expect(
        api.calls.any(
          (c) =>
              c.method == 'POST' &&
              c.path == '/api/plugins/kanban/tasks/t_run_1/reassign' &&
              c.body?['reclaim_first'] == true &&
              c.body?['profile'] == 'researcher',
        ),
        isTrue,
      );

      // Switch to Comments & Links tab: add parent link, post comment & requeue.
      await tester.tap(find.text('Comments & Links'));
      await _step(tester);
      await _shown(tester, find.byKey(const Key('kanban-add-parent-btn')));
      await tester.tap(find.byKey(const Key('kanban-add-parent-btn')));
      await _step(tester);
      await tester.tap(find.textContaining('t_ready_1:').last);
      await _step(tester);
      expect(
        api.calls.any(
          (c) =>
              c.method == 'POST' &&
              c.path == '/api/plugins/kanban/links' &&
              c.body?['parent_id'] == 't_ready_1' &&
              c.body?['child_id'] == 't_run_1',
        ),
        isTrue,
      );

      await tester.enterText(
        find.byKey(const Key('kanban-comment-input')),
        'Check edge cases before retry',
      );
      await tester.tap(find.byKey(const Key('kanban-comment-requeue')));
      await _step(tester);
      await tester.tap(find.byKey(const Key('kanban-confirm-ok')));
      await _step(tester);
      expect(
        api.calls.any(
          (c) =>
              c.method == 'POST' &&
              c.path == '/api/plugins/kanban/tasks/t_run_1/comments',
        ),
        isTrue,
      );
      expect(
        api.calls.any(
          (c) =>
              c.method == 'POST' &&
              c.path == '/api/plugins/kanban/tasks/t_run_1/reclaim',
        ),
        isTrue,
      );

      // Switch to Runs & Log tab: verify run summary and worker stdout tail.
      await tester.tap(find.text('Runs & Log'));
      await _step(tester);
      await _shown(tester, find.textContaining('Run #7 · @work'));
      expect(
        find.textContaining('worker log line: compiling suite'),
        findsOneWidget,
      );

      // Close drawer.
      await tester.tap(find.byIcon(Icons.close));
      await _step(tester);

      // Open Orchestration & Worker Profiles sheet: save orchestration + auto-describe.
      await tester.tap(find.byKey(const Key('kanban-orchestration-button')));
      await _step(tester);
      await _shown(
        tester,
        find.byKey(const Key('kanban-worker-auto-researcher')),
      );
      await tester.tap(find.byKey(const Key('kanban-worker-auto-researcher')));
      await _step(tester);
      await tester.tap(find.byKey(const Key('kanban-auto-decompose')));
      await _step(tester);
      await tester.tap(find.byKey(const Key('kanban-save-orchestration')));
      await _step(tester);
      expect(
        api.calls.any(
          (c) =>
              c.method == 'PUT' &&
              c.path == '/api/plugins/kanban/orchestration' &&
              c.body?['auto_decompose'] == true,
        ),
        isTrue,
      );

      // Board switcher: pin secondary board and switch locally via ?board=ops-board.
      await tester.tap(find.byKey(const Key('kanban-board-switcher')));
      await _step(tester);
      await _shown(tester, find.byKey(const Key('kanban-pin-ops-board')));
      await tester.tap(find.byKey(const Key('kanban-pin-ops-board')));
      await _step(tester);
      await tester.tap(find.byKey(const Key('kanban-board-row-ops-board')));
      await _shown(tester, find.text('Kanban · ops-board'));
      expect(
        find.byKey(const Key('kanban-pinned-tab-ops-board')),
        findsOneWidget,
      );
      expect(
        api.calls.any(
          (c) =>
              c.path == '/api/plugins/kanban/board' &&
              c.query['board'] == 'ops-board',
        ),
        isTrue,
      );

      // Account mutation revokes the bound Kanban view immediately.
      final barrier = ConnectionMutationBarrier.begin(const ['c-kanban']);
      addTearDown(barrier.release);
      await _shown(tester, find.textContaining('Gateway owner changed'));
      // Let any 400ms debounced nudge settle cleanly before widget teardown.
      await tester.pump(const Duration(milliseconds: 500));
    },
  );

  testWidgets(
    'Kanban board opens from outside with initialBoard and initialCardId',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final api = _KanbanFixtureApi();
      final owner = _makeOwner(
        api.client,
        connectionId: 'c-kanban-focus',
        profile: 'work',
      );
      addTearDown(owner.close);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: KanbanBoardScreen(
            owner: owner,
            route: owner.route(),
            connection: _fixtureConnection,
            enableLivePolling: false,
            initialBoard: 'default',
            initialCardId: 't_run_1',
          ),
        ),
      );

      // The pending card opens its detail sheet as soon as the snapshot lands.
      await _shown(tester, find.byKey(const Key('kanban-active-count')));
      await _shown(tester, find.textContaining('t_run_1 · Running'));

      // The focused sheet belongs to the board it was opened on.
      expect(find.text('Kanban · default'), findsOneWidget);

      // Closing the sheet leaves the board on screen.
      await tester.tap(find.byIcon(Icons.close));
      await _step(tester);
      expect(find.text('Kanban · default'), findsOneWidget);
    },
  );

  testWidgets(
    'Kanban board opens on a transient initial board without persisting the selection',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final api = _KanbanFixtureApi();
      final owner = _makeOwner(
        api.client,
        connectionId: 'c-kanban-transient',
        profile: 'work',
      );
      addTearDown(owner.close);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: KanbanBoardScreen(
            owner: owner,
            route: owner.route(),
            connection: _fixtureConnection,
            enableLivePolling: false,
            initialBoard: 'ops-board',
          ),
        ),
      );

      await _shown(tester, find.text('Kanban · ops-board'));

      // The transient board is not written to the saved selection.
      final store = KanbanBoardPreferences(
        await SharedPreferences.getInstance(),
        connectionId: 'c-kanban-transient',
        profile: 'work',
      );
      expect(store.selectedBoard, isEmpty);
    },
  );

  testWidgets(
    'NextGen More → Kanban entry is reachable and renders on narrow phones',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final gateway = NextGenGateway(_fixtureConnection);
      addTearDown(gateway.dispose);
      final connManager = ConnectionManager(
        await SharedPreferences.getInstance(),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NgScope(
            gateway: gateway,
            connManager: connManager,
            connections: [_fixtureConnection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: NgMorePage(onOpenSession: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Kanban'), findsOneWidget);
    },
  );

  testWidgets(
    'NextGen More → Bots entry is reachable and renders on narrow phones',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final gateway = NextGenGateway(_fixtureConnection);
      addTearDown(gateway.dispose);
      final connManager = ConnectionManager(
        await SharedPreferences.getInstance(),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NgScope(
            gateway: gateway,
            connManager: connManager,
            connections: [_fixtureConnection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: NgMorePage(onOpenSession: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Bots'), findsOneWidget);
    },
  );
}

final _fixtureConnection = SavedConnection(
  id: 'c-kanban',
  label: 'Disposable Kanban Host',
  host: '127.0.0.1',
  port: 9,
  apiKey: 'fixture-only',
  dashboardUsername: 'fixture',
  dashboardPassword: 'fixture-password',
  desktopGatewayUrl: 'http://127.0.0.1:9',
  gatewayProfile: 'work',
);

RemoteWorkspaceOwner _makeOwner(
  http.Client client, {
  required String connectionId,
  required String profile,
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

class _RecordedCall {
  _RecordedCall(this.method, this.path, this.query, this.body);
  final String method;
  final String path;
  final Map<String, String> query;
  final Map<String, dynamic>? body;
}

class _KanbanFixtureApi {
  _KanbanFixtureApi() {
    client = MockClient(_handle);
  }

  late final MockClient client;
  final calls = <_RecordedCall>[];
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': 't_todo_1',
      'title': 'Parent gated task',
      'status': 'todo',
      'assignee': 'work',
      'priority': 1,
      'open_parent_count': 1,
    },
    {
      'id': 't_ready_1',
      'title': 'Ready implementation card',
      'status': 'ready',
      'assignee': 'work',
      'priority': 2,
    },
    {
      'id': 't_fail_bulk',
      'title': 'Protected card',
      'status': 'ready',
      'assignee': 'work',
      'priority': 0,
    },
    {
      'id': 't_run_1',
      'title': 'Running worker card',
      'status': 'running',
      'assignee': 'work',
      'priority': 3,
      'current_run_id': 7,
    },
  ];
  final List<String> _run1Parents = [];
  final List<Map<String, dynamic>> _comments = [];
  bool _autoDecompose = false;

  Future<http.Response> _handle(http.Request request) async {
    Map<String, dynamic>? parsedBody;
    if (request.body.isNotEmpty) {
      try {
        final raw = jsonDecode(request.body);
        if (raw is Map<String, dynamic>) parsedBody = raw;
      } catch (_) {}
    }
    calls.add(
      _RecordedCall(
        request.method,
        request.url.path,
        request.url.queryParameters,
        parsedBody,
      ),
    );

    final path = request.url.path;
    if (path == '/auth/password-login') {
      return http.Response(
        jsonEncode({'ok': true}),
        200,
        headers: {'set-cookie': 'hermes_session_at=fixture-cookie'},
      );
    }
    if (path == '/api/plugins/kanban/boards' && request.method == 'GET') {
      return _json({
        'current': 'default',
        'boards': [
          {
            'slug': 'default',
            'name': 'Default Board',
            'is_current': true,
            'counts': {'ready': 2, 'running': 1, 'todo': 1},
            'total': _tasks.length,
            'default_workspace_kind': 'scratch',
          },
          {
            'slug': 'ops-board',
            'name': 'Ops Board',
            'is_current': false,
            'counts': {'ready': 0, 'running': 0},
            'total': 0,
            'default_workspace_kind': 'worktree',
          },
        ],
      });
    }
    if (path == '/api/plugins/kanban/board' && request.method == 'GET') {
      final board = request.url.queryParameters['board'] ?? 'default';
      final boardTasks = board == 'ops-board'
          ? <Map<String, dynamic>>[]
          : _tasks;
      return _json({
        'columns': [
          for (final col in kanbanWorkflowColumns)
            {
              'name': col,
              'tasks': [
                for (final t in boardTasks)
                  if (t['status'] == col) t,
              ],
            },
        ],
        'tenants': const <String>[],
        'assignees': const ['work', 'researcher'],
        'latest_event_id': 12,
        'now': 1700000000,
      });
    }
    if (path == '/api/plugins/kanban/profiles' && request.method == 'GET') {
      return _json({
        'profiles': [
          {
            'name': 'work',
            'is_default': true,
            'model': 'claude-sonnet',
            'provider': 'anthropic',
            'description': 'Primary builder',
            'skill_count': 4,
          },
          {
            'name': 'researcher',
            'is_default': false,
            'model': 'gpt-5',
            'provider': 'openrouter',
            'description': 'Deep audit specialist',
            'skill_count': 2,
          },
        ],
      });
    }
    if (path == '/api/plugins/kanban/profiles/researcher/describe-auto' &&
        request.method == 'POST') {
      return _json({
        'ok': true,
        'profile': 'researcher',
        'description': 'Auto-synthesized audit worker',
      });
    }
    if (path == '/api/plugins/kanban/projects' && request.method == 'GET') {
      return _json({
        'projects': [
          {
            'id': 'proj_1',
            'slug': 'ares',
            'name': 'Ares Client',
            'primary_path': '/srv/projects/ares',
          },
        ],
      });
    }
    if (path == '/api/plugins/kanban/orchestration') {
      if (request.method == 'PUT') {
        _autoDecompose = parsedBody?['auto_decompose'] == true;
      }
      return _json({
        'orchestrator_profile': 'work',
        'default_assignee': 'work',
        'auto_decompose': _autoDecompose,
        'auto_promote_children': true,
        'resolved_orchestrator_profile': 'work',
        'resolved_default_assignee': 'work',
        'active_profile': 'work',
      });
    }
    if (path == '/api/plugins/kanban/estimate' && request.method == 'POST') {
      return _json({
        'ok': true,
        'est_tokens': 8400,
        'complexity': 'M',
        'rationale': 'Two screens and REST wiring',
        'model': 'aux-estimator',
      });
    }
    if (path == '/api/plugins/kanban/tasks' && request.method == 'POST') {
      final created = <String, dynamic>{
        'id': 't_created_1',
        'title': parsedBody?['title'] ?? 'Untitled',
        'body': parsedBody?['body'] ?? '',
        'status': parsedBody?['triage'] == true ? 'triage' : 'ready',
        'assignee': parsedBody?['assignee'] ?? 'work',
        'priority': parsedBody?['priority'] ?? 0,
        'skills': parsedBody?['skills'] ?? const <String>[],
        'model_override': parsedBody?['model_override'],
        'provider_override': parsedBody?['provider_override'],
      };
      _tasks.add(created);
      return _json({'task': created});
    }
    if (path == '/api/plugins/kanban/tasks/t_todo_1' &&
        request.method == 'PATCH' &&
        parsedBody?['status'] == 'ready') {
      return http.Response(
        jsonEncode({
          'detail': "Cannot move to 'ready': blocked by parent t_run_1",
        }),
        409,
      );
    }
    if (path.startsWith('/api/plugins/kanban/tasks/') &&
        request.method == 'PATCH') {
      final id = path.split('/').last;
      final existing = _tasks.firstWhere((t) => t['id'] == id);
      if (parsedBody?['status'] != null) {
        existing['status'] = parsedBody!['status'];
      }
      if (parsedBody?['assignee'] != null) {
        existing['assignee'] = parsedBody!['assignee'];
      }
      return _json({'task': existing});
    }
    if (path == '/api/plugins/kanban/tasks/bulk' && request.method == 'POST') {
      final ids = (parsedBody?['ids'] as List? ?? const []).cast<String>();
      return _json({
        'results': [
          for (final id in ids)
            if (id == 't_fail_bulk')
              {'id': id, 'ok': false, 'error': 'claim lock held'}
            else
              {'id': id, 'ok': true},
        ],
      });
    }
    if (path == '/api/plugins/kanban/tasks/t_run_1' &&
        request.method == 'GET') {
      final row = _tasks.firstWhere((t) => t['id'] == 't_run_1');
      return _json({
        'task': row,
        'comments': _comments,
        'links': {'parents': _run1Parents, 'children': const <String>[]},
        'link_tasks': [
          for (final pid in _run1Parents)
            {
              'id': pid,
              'title': 'Ready implementation card',
              'status': 'ready',
            },
        ],
        'attachments': const [],
        'diagnostics': const [],
        'warnings': const [],
        'runs': [
          {
            'id': 7,
            'profile': 'work',
            'status': 'running',
            'outcome': 'in_progress',
            'summary': 'Executing regression verification',
          },
        ],
        'events': [
          {'id': 1, 'kind': 'claimed', 'created_at': 1700000000},
        ],
      });
    }
    if (path == '/api/plugins/kanban/tasks/t_run_1/log' &&
        request.method == 'GET') {
      return _json({
        'task_id': 't_run_1',
        'exists': true,
        'size_bytes': 64,
        'content': 'worker log line: compiling suite\nPASS',
        'truncated': false,
      });
    }
    if (path == '/api/plugins/kanban/tasks/t_run_1/reassign' &&
        request.method == 'POST') {
      final row = _tasks.firstWhere((t) => t['id'] == 't_run_1');
      row['assignee'] = parsedBody?['profile'];
      return _json({
        'ok': true,
        'task_id': 't_run_1',
        'assignee': row['assignee'],
      });
    }
    if (path == '/api/plugins/kanban/tasks/t_run_1/comments' &&
        request.method == 'POST') {
      _comments.add({
        'author': parsedBody?['author'] ?? 'ares',
        'body': parsedBody?['body'] ?? '',
        'created_at': 1700000050,
      });
      return _json({'ok': true});
    }
    if (path == '/api/plugins/kanban/tasks/t_run_1/reclaim' &&
        request.method == 'POST') {
      final row = _tasks.firstWhere((t) => t['id'] == 't_run_1');
      row['status'] = 'ready';
      return _json({'ok': true, 'task_id': 't_run_1'});
    }
    if (path == '/api/plugins/kanban/links' && request.method == 'POST') {
      final pid = parsedBody?['parent_id'] as String?;
      if (pid != null && !_run1Parents.contains(pid)) _run1Parents.add(pid);
      return _json({'ok': true, 'gated': true});
    }
    if (path == '/api/plugins/kanban/dispatch' && request.method == 'POST') {
      return _json({'spawned': const [], 'promoted': 1, 'reclaimed': 0});
    }
    return _json({'ok': true});
  }

  http.Response _json(Map<String, dynamic> data) =>
      http.Response(jsonEncode(data), 200);
}
