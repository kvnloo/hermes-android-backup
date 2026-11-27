import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/hermes_project.dart';
import 'package:hermes_android/core/models/project_sessions_tree.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/projects_repository.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/widgets/project_detail_screen.dart';
import 'package:hermes_android/core/widgets/project_settings_view.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

const _id = 'p_abcdef01';
const _other = 'p_abcd0000';
const _url = 'https://example.invalid';

class _Dashboard extends Fake implements DashboardClient {
  @override
  String get baseUrl => _url;
  @override
  String get gatewayProfile => 'work';
}

typedef _Json = Map<String, dynamic>;
typedef _Call = ({String method, _Json params});

_Json _row(String id, String name) => {
  'id': id,
  'slug': name.toLowerCase(),
  'name': name,
  'icon': null,
  'color': null,
  'created_at': 123,
  'archived': false,
  'folders': [
    {'path': '/server/base', 'is_primary': true, 'label': 'Base'},
  ],
};

class _Socket extends Fake implements WsClient {
  @override
  String get baseUrl => _url;
  @override
  int socketEpoch = 1;
  @override
  Future<_Json> waitForGatewayReady({Duration? timeout}) async => {};

  final projects = {_id: _row(_id, 'Alpha'), _other: _row(_other, 'Beta')};
  String? activeId;
  final calls = <_Call>[];
  Iterable<String> get methods => calls.map((c) => c.method);
  Future<_Json> Function(_Call, _Json)? intercept;
  bool persistChanges = true;

  @override
  Future<_Json> send(
    String method,
    _Json params, {
    Duration? timeout,
    void Function()? onSent,
    bool includeProfile = true,
  }) async {
    expect(includeProfile, isFalse);
    expect(params['profile'], 'work');
    final call = (method: method, params: params);
    calls.add(call);
    final row =
        projects[params['id']] ?? projects[_id]!; // Simulate slug fallback.
    _Json reply;
    switch (method) {
      case 'projects.list':
        reply = {'projects': projects.values.toList(), 'active_id': activeId};
      case 'projects.get':
        reply = {'project': row};
      case 'projects.add_folder':
        final added = {
          ...row,
          'folders': [
            ...row['folders'],
            {'path': params['path'], 'is_primary': false},
          ],
        };
        if (persistChanges) projects[row['id']] = added;
        reply = {'project': added};
      case 'projects.update':
        final updated = {
          ...row,
          for (final key in ['icon', 'color'])
            if (params.containsKey(key))
              key: params[key] == '' ? null : params[key],
        };
        if (persistChanges) projects[row['id']] = updated;
        reply = {'project': updated};
      case 'projects.set_active':
        if (persistChanges) activeId = params['id'] as String;
        reply = {'active_id': params['id']};
      default:
        throw StateError('Unexpected RPC $method');
    }
    final envelope = <String, dynamic>{'result': reply};
    return intercept == null ? envelope : await intercept!(call, envelope);
  }
}

RemoteWorkspaceOwner _owner(_Socket socket) => RemoteWorkspaceOwner(
  connectionId: 'settings-fixture',
  expectedBaseUrl: _url,
  profile: 'work',
  dashboard: _Dashboard(),
  connect: () async => socket,
  ownsSocket: (ws) => identical(ws, socket),
);

Matcher _fails(WorkspaceFailure reason) => throwsA(
  isA<WorkspaceException>().having((e) => e.reason, 'reason', reason),
);

void main() {
  late _Socket socket;
  late RemoteWorkspaceOwner owner;
  late WorkspacePane pane;
  late WorkspaceTarget target;
  setUp(() async {
    socket = _Socket();
    owner = _owner(socket);
    pane = owner.pane();
    target = await pane.bind(owner.route());
  });
  tearDown(() {
    pane.close();
    owner.close();
  });

  test(
    'adds distinct absolute server folders; reads each back before proceeding',
    () async {
      final settings = await target.addProjectFolders(_id, [
        '/server/base',
        '/server/docs',
        '/server/docs',
        '/server/art',
      ]);
      expect(settings.folders.map((f) => f.path), [
        '/server/base',
        '/server/docs',
        '/server/art',
      ]);
      expect(settings.folders.first.isPrimary, isTrue);
      expect(
        socket.calls
            .where((c) => c.method == 'projects.add_folder')
            .map((c) => c.params),
        [
          for (final path in ['/server/docs', '/server/art'])
            {'id': _id, 'path': path, 'is_primary': false, 'profile': 'work'},
        ],
      );
      final methods = socket.methods.toList();
      final first = methods.indexOf('projects.add_folder');
      final last = methods.lastIndexOf('projects.add_folder');
      expect(methods.sublist(first + 1, last), contains('projects.get'));
      expect(methods.last, 'projects.list');
    },
  );

  test(
    'validates whole batch and exact ID before a write; no slug or active fallback',
    () async {
      for (final path in ['~/repo', '/srv/../x', '/srv/%2E', ' /srv/y']) {
        await expectLater(
          target.addProjectFolders(_id, ['/srv/good', path]),
          _fails(WorkspaceFailure.invalid),
        );
      }
      await expectLater(
        target.setProjectActive(''),
        _fails(WorkspaceFailure.invalid),
      );
      await expectLater(
        target.setProjectActive(' $_id'),
        _fails(WorkspaceFailure.invalid),
      );
      expect(socket.calls, isEmpty);
      await expectLater(
        target.setProjectActive('alpha'),
        _fails(WorkspaceFailure.mismatch),
      );
      await expectLater(
        target.setProjectAppearance('alpha', icon: 'rocket'),
        _fails(WorkspaceFailure.mismatch),
      );
      await expectLater(
        target.addProjectFolders('alpha', ['/different']),
        _fails(WorkspaceFailure.mismatch),
      );
      expect(socket.methods.toSet(), {'projects.get'});
    },
  );

  test(
    'active and partial appearance patches use pinned wire keys and verify the returned snapshot',
    () async {
      expect((await target.setProjectActive(_id)).isActive, isTrue);
      expect(socket.methods, [
        'projects.get',
        'projects.set_active',
        'projects.list',
      ]);
      expect(socket.calls[1].params, {'id': _id, 'profile': 'work'});
      expect(
        (await target.setProjectAppearance(
          _id,
          icon: 'rocket',
          color: '#4682B4',
        )).color,
        '#4682B4',
      );
      final cleared = await target.setProjectAppearance(_id, icon: '');
      expect(cleared.icon, isNull);
      expect(cleared.color, '#4682B4');
      expect(
        socket.calls
            .where((c) => c.method == 'projects.update')
            .map((c) => c.params),
        [
          {'id': _id, 'profile': 'work', 'icon': 'rocket', 'color': '#4682B4'},
          {'id': _id, 'profile': 'work', 'icon': ''},
        ],
      );
    },
  );

  test(
    'ack alone cannot confirm a folder, appearance or active pointer',
    () async {
      socket.persistChanges = false;
      await expectLater(
        target.addProjectFolders(_id, ['/one', '/two']),
        _fails(WorkspaceFailure.mismatch),
      );
      expect(
        socket.calls.where((c) => c.method == 'projects.add_folder'),
        hasLength(1),
      );
      await expectLater(
        target.setProjectAppearance(_id, color: '#4682B4'),
        _fails(WorkspaceFailure.mismatch),
      );
      await expectLater(
        target.setProjectActive(_id),
        _fails(WorkspaceFailure.mismatch),
      );
    },
  );

  test(
    'malformed list and duplicate IDs cannot become fresh authority',
    () async {
      for (final invalid in <_Json>[
        {
          'projects': [socket.projects[_id]],
        },
        {
          'active_id': null,
          'projects': [socket.projects[_id], socket.projects[_id]],
        },
        {
          'active_id': null,
          'projects': [
            {
              ...socket.projects[_id]!,
              'folders': [
                {'path': 42},
              ],
            },
          ],
        },
      ]) {
        socket.intercept = (call, envelope) async => {'result': invalid};
        await expectLater(
          target.readProjectSettings(_id),
          _fails(WorkspaceFailure.invalid),
        );
      }
    },
  );

  test(
    'wrong project in a mutation receipt is not a confirmed update',
    () async {
      socket.intercept = (call, envelope) async =>
          call.method == 'projects.update'
          ? {
              'result': {'project': socket.projects[_other]},
            }
          : envelope;
      await expectLater(
        target.setProjectAppearance(_id, icon: 'book'),
        _fails(WorkspaceFailure.mismatch),
      );
      expect(socket.projects[_id]!['icon'], 'book');
      expect(socket.methods, [
        'projects.get',
        'projects.update',
        'projects.list',
      ]);
    },
  );

  test(
    'omitted optional appearance fields display but cannot prove an explicit clear',
    () async {
      socket.projects[_other]!.remove('icon');
      expect((await target.readProjectSettings(_other)).icon, isNull);
      socket.intercept = (call, envelope) async {
        if (call.method == 'projects.list') {
          socket.projects[_other]!.remove('icon');
        }
        return envelope;
      };
      await expectLater(
        target.setProjectAppearance(_other, icon: ''),
        _fails(WorkspaceFailure.invalid),
      );
      expect(
        socket.calls
            .singleWhere((call) => call.method == 'projects.update')
            .params,
        {'id': _other, 'profile': 'work', 'icon': ''},
      );
    },
  );

  Widget view(
    String id, {
    RemoteWorkspaceOwner? issuer,
    ValueChanged<ProjectSettingsSnapshot>? onChanged,
  }) {
    issuer ??= owner;
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: ProjectSettingsView(
        owner: issuer,
        route: issuer.route(),
        projectId: id,
        onChanged: onChanged,
      ),
    );
  }

  testWidgets(
    'renders confirmed folders, appearance and active project after explicit gestures',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(420, 1000);
      addTearDown(tester.view.reset);
      final confirmed = <ProjectSettingsSnapshot>[];
      await tester.pumpWidget(view(_id, onChanged: confirmed.add));
      await tester.pumpAndSettle();
      expect(socket.methods, ['projects.list']);
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('/server/base'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '/server/a\n/server/b');
      await tester.pump();
      await tester.tap(find.text('Add folders'));
      await tester.pumpAndSettle();
      expect(find.text('/server/a'), findsOneWidget);
      expect(find.text('/server/b'), findsOneWidget);
      final l10n = lookupAppLocalizations(const Locale('en'));
      await tester.tap(
        find.byTooltip(
          l10n.release_core_project_settings_view_choose(
            l10n.release_core_project_settings_view_icon,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rocket').last);
      await tester.pumpAndSettle();
      await tester.tap(
        find.byTooltip(
          l10n.release_core_project_settings_view_choose(
            l10n.release_core_project_settings_view_colour,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Blue').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Set active'));
      await tester.pumpAndSettle();
      expect(find.text('Active'), findsOneWidget);
      expect(confirmed, hasLength(4));
      expect(confirmed.last.id, _id);
      expect(confirmed.last.icon, 'rocket');
      expect(confirmed.last.color, 'hsl(210 68% 58%)');
      expect(confirmed.last.isActive, isTrue);
    },
  );

  testWidgets('replacing the owner during first add prevents a second write', (
    tester,
  ) async {
    final held = Completer<void>();
    socket.intercept = (call, envelope) async {
      if (call.method == 'projects.add_folder') await held.future;
      return envelope;
    };
    final replacement = _owner(_Socket());
    addTearDown(replacement.close);
    final results = <ProjectSettingsSnapshot>[];
    await tester.pumpWidget(view(_id, onChanged: results.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '/one\n/two');
    await tester.pump();
    await tester.ensureVisible(find.text('Add folders'));
    await tester.tap(find.text('Add folders'));
    await tester.pump();
    expect(socket.methods.last, 'projects.add_folder');
    final count = socket.calls.length;
    await tester.pumpWidget(view(_id, issuer: replacement));
    await tester.pumpAndSettle();
    held.complete();
    await tester.pumpAndSettle();
    expect(socket.calls, hasLength(count));
    expect(results, isEmpty);
    expect(find.text('/one'), findsNothing);
    expect(find.text('Alpha'), findsOneWidget);
  });

  testWidgets('unmount during preflight sends no mutation', (tester) async {
    final release = Completer<void>();
    socket.intercept = (call, envelope) async {
      if (call.method == 'projects.get') await release.future;
      return envelope;
    };
    await tester.pumpWidget(view(_id));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Set active'));
    await tester.pump();
    expect(socket.methods.last, 'projects.get');
    await tester.pumpWidget(const SizedBox());
    release.complete();
    await tester.pumpAndSettle();
    expect(socket.methods, ['projects.list', 'projects.get']);
  });

  testWidgets('a retained gesture cannot act after a project A→B→A change', (
    tester,
  ) async {
    await tester.pumpWidget(view(_id));
    await tester.pumpAndSettle();
    final stale = tester
        .widget<OutlinedButton>(
          find.widgetWithText(OutlinedButton, 'Set active'),
        )
        .onPressed!;
    await tester.pumpWidget(view(_other));
    await tester.pumpAndSettle();
    expect(find.text('Beta'), findsOneWidget);
    await tester.pumpWidget(view(_id));
    await tester.pumpAndSettle();
    stale();
    await tester.pumpAndSettle();
    expect(socket.methods, ['projects.list', 'projects.list', 'projects.list']);
  });

  testWidgets(
    'partial batch reconciles without replay and keeps the draft for explicit retry',
    (tester) async {
      final confirmed = <ProjectSettingsSnapshot>[];
      socket.intercept = (call, envelope) async =>
          call.method == 'projects.add_folder' && call.params['path'] == '/two'
          ? {
              'error': {'code': 5061, 'message': 'private gateway detail'},
            }
          : envelope;
      await tester.pumpWidget(view(_id, onChanged: confirmed.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '/one\n/two\n/three');
      await tester.pump();
      final add = find.text('Add folders');
      await tester.pumpAndSettle();
      await tester.ensureVisible(add);
      await tester.pumpAndSettle();
      await tester.tap(add);
      await tester.pumpAndSettle();
      expect(confirmed, isEmpty);
      expect(socket.methods.last, 'projects.list');
      expect(find.text('private gateway detail'), findsNothing);
      expect(find.text('/one'), findsOneWidget);
      expect(find.text('/two'), findsOneWidget);
      expect(find.text('/one\n/two\n/three'), findsOneWidget);
      Iterable<String> written() => socket.calls
          .where((c) => c.method == 'projects.add_folder')
          .map((c) => c.params['path'] as String);
      expect(written(), ['/one', '/two']);
      socket.intercept = null;
      await tester.scrollUntilVisible(
        add,
        160,
        scrollable: find
            .descendant(
              of: find.byType(ListView),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.pumpAndSettle();
      await tester.tap(add);
      await tester.pumpAndSettle();
      expect(written(), ['/one', '/two', '/three']);
      expect(confirmed.single.folders.map((f) => f.path), [
        '/server/base',
        '/one',
        '/two',
        '/three',
      ]);
    },
  );

  testWidgets('account revocation removes visible project data and drafts', (
    tester,
  ) async {
    await tester.pumpWidget(view(_id));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '/private/draft');
    ConnectionMutationBarrier.begin(['settings-fixture']).release();
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsNothing);
    expect(find.text('/private/draft'), findsNothing);
    expect(find.text('Add folders'), findsNothing);
    expect(socket.methods, ['projects.list']);
  });

  testWidgets('review: project files refresh when project settings change', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(420, 1200);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: hermesTheme(Brightness.dark),
        home: ProjectDetailScreen(
          projectId: _id,
          projectName: 'Alpha',
          workspace: owner,
          loadSessions: ({required bool refresh}) async =>
              const ProjectSessionsView(
                projectId: _id,
                tree: ProjectSessionsTree(
                  id: _id,
                  label: 'Alpha',
                  sessionCount: 0,
                  lastActive: 0,
                ),
              ),
          projects: const [
            HermesProject(
              id: _id,
              slug: 'alpha',
              name: 'Alpha',
              primaryPath: '/server/base',
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Tab, 'Files'));
    await tester.pumpAndSettle();
    expect(find.text('/server/base'), findsWidgets);
    expect(find.text('/server/added'), findsNothing);
    await tester.tap(find.byTooltip('Project settings'));
    await tester.pumpAndSettle();
    final settings = find.byType(ProjectSettingsView);
    final field = find.descendant(
      of: settings,
      matching: find.byType(TextField),
    );
    await tester.enterText(field, '/server/added');
    await tester.pump();
    await tester.tap(
      find.descendant(of: settings, matching: find.text('Add folders')),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: settings, matching: find.text('/server/added')),
      findsWidgets,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Project settings'), findsNothing);
    expect(find.text('/server/added'), findsOneWidget);
  });
}
