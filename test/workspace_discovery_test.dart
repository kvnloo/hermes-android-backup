import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/workspace_discovery_view.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

typedef _Json = Map<String, dynamic>;
const _base = 'https://gateway.invalid/work';

class _Dashboard extends Fake implements DashboardClient {
  _Dashboard(this.baseUrl, this.gatewayProfile);
  @override
  final String baseUrl;
  @override
  final String? gatewayProfile;
}

class _Socket extends Fake implements WsClient {
  _Socket([this.baseUrl = _base]);
  @override
  final String baseUrl;
  @override
  int socketEpoch = 1;
  @override
  Future<_Json> waitForGatewayReady({Duration? timeout}) async => {};
  final params = <_Json>[];
  _Json result = {
    'repos': [
      {'root': '/src/repo', 'label': 'Repo', 'sessions': 0, 'last_active': 0.0},
      {
        'root': '/elsewhere/desk',
        'label': 'Desk',
        'sessions': 3,
        'last_active': 2.5,
      },
    ],
    'discovery_policy': {
      'enabled': true,
      'roots': ['/src', '/extra'],
      'exclude_paths': ['/src/skip'],
    },
  };
  Future<_Json> Function()? intercept;

  @override
  Future<_Json> send(
    String method,
    _Json params, {
    Duration? timeout,
    void Function()? onSent,
    bool includeProfile = true,
  }) async {
    expect(method, 'projects.discover_repos');
    expect(includeProfile, isFalse);
    this.params.add(params);
    return intercept == null ? {'result': result} : intercept!();
  }
}

RemoteWorkspaceOwner _owner(
  _Socket socket, {
  String id = 'test-gateway',
  String? profile = 'work',
}) => RemoteWorkspaceOwner(
  connectionId: id,
  expectedBaseUrl: socket.baseUrl,
  profile: profile,
  dashboard: _Dashboard(socket.baseUrl, profile),
  connect: () async => socket,
  ownsSocket: (ws) => identical(socket, ws),
);

Matcher _fails(WorkspaceFailure reason) => throwsA(
  isA<WorkspaceException>().having((e) => e.reason, 'reason', reason),
);

final class _HeldStorage extends InMemorySharedPreferencesAsync {
  _HeldStorage() : super.empty();
  final entered = Completer<void>();
  final release = Completer<void>();
  int writes = 0;
  bool dropWrites = false;
  @override
  Future<String?> getString(
    String key,
    SharedPreferencesOptions options,
  ) async {
    if (!entered.isCompleted) {
      entered.complete();
      await release.future;
    }
    return super.getString(key, options);
  }

  @override
  Future<bool> setString(
    String key,
    String value,
    SharedPreferencesOptions options,
  ) async {
    writes++;
    return dropWrites ? true : super.setString(key, value, options);
  }
}

void main() {
  late _Socket socket;
  late RemoteWorkspaceOwner owner;
  late WorkspaceTarget target;
  late WorkspacePane pane;
  final originalStorage = SharedPreferencesAsyncPlatform.instance;
  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    socket = _Socket();
    owner = _owner(socket);
    pane = owner.pane();
    target = await pane.bind(owner.route());
  });
  tearDown(() {
    pane.close();
    owner.close();
    SharedPreferencesAsyncPlatform.instance = originalStorage;
  });

  test(
    'scan is an explicit profile-bound project RPC; policy is not an input',
    () async {
      socket.result['discovery_policy']['roots'] = ['~/code', 'repos', '/src'];
      final listing = await target.discoverRepositories(scan: false);
      expect(listing.policy!.roots, ['~/code', 'repos', '/src']);
      expect(listing.repos.map((r) => r.root), [
        '/src/repo',
        '/elsewhere/desk',
      ]);
      socket.result['discovery_policy']['enabled'] = false;
      final updated = await target.discoverRepositories(scan: true);
      expect(updated.policy!.enabled, isFalse);
      expect(updated.policy!.excludedSubtrees, ['/src/skip']);
      expect(
        updated.repos.last.sessions,
        3,
      ); // Session roots can outlive a scan.
      expect(socket.params, [
        {'scan': false, 'profile': 'work'},
        {'scan': true, 'profile': 'work'},
      ]);
    },
  );

  test(
    'legacy missing policy is unknown; malformed data and denials are not empty success',
    () async {
      final complete = socket.result;
      socket.result = {'repos': []};
      expect((await target.discoverRepositories(scan: false)).policy, isNull);
      for (final invalid in <_Json>[
        {
          'repos': [],
          'discovery_policy': {
            'enabled': true,
            'roots': [],
            'exclude_paths': 'no',
          },
        },
        {
          'repos': [],
          'discovery_policy': {
            'enabled': 'false',
            'roots': [],
            'exclude_paths': [],
          },
        },
        {
          'repos': [
            {'root': '/bad/../root', 'label': 'bad', 'sessions': 0},
          ],
        },
        {
          'repos': [...complete['repos'], ...complete['repos']],
        },
        {
          'repos': [
            {'root': '/ok', 'label': 'bad', 'sessions': -1},
          ],
        },
        {'repos': null},
      ]) {
        socket.result = invalid;
        await expectLater(
          target.discoverRepositories(scan: false),
          _fails(WorkspaceFailure.invalid),
        );
      }
      for (final pair in [
        (403, WorkspaceFailure.denied),
        (-32601, WorkspaceFailure.unsupported),
      ]) {
        socket.intercept = () async => {
          'error': {'code': pair.$1, 'message': 'do not display'},
        };
        await expectLater(
          target.discoverRepositories(scan: false),
          _fails(pair.$2),
        );
      }
    },
  );

  test(
    'local include/exclude match whole server components; hide is an exact root',
    () {
      final f = WorkspaceRepoFilters(
        roots: ['/src', r'C:\Code'],
        exclusions: ['/src/vendor', r'C:\Code\tmp'],
        hidden: ['/src/old'],
      );
      for (final path in [
        '/src',
        '/src/vendor2',
        '/src/old/sub',
        r'C:\Code\project',
        'C:/Code/ok',
      ]) {
        expect(f.shows(path), isTrue, reason: path);
      }
      for (final path in [
        '/src2',
        '/src/vendor',
        '/src/vendor/lib',
        '/src/old',
        r'C:\Code\tmp\repo',
        r'/src\x',
      ]) {
        expect(f.shows(path), isFalse, reason: path);
      }
      for (final path in [
        '~/src',
        '/src/../x',
        '/src/%2f',
        '/src//repo',
        ' /src',
      ]) {
        expect(
          () => WorkspaceRepoFilters(roots: [path]),
          _fails(WorkspaceFailure.invalid),
        );
      }
    },
  );

  test(
    'fresh stores keep hides only on the same endpoint, saved gateway and profile; undo is local',
    () async {
      final prefs = DiscoveryFilterPreferences(target);
      await prefs.setHidden('/src/repo', true);
      Future<Set<String>> hidden(_Socket s, String id, String? profile) async {
        final o = _owner(s, id: id, profile: profile);
        final p = o.pane();
        try {
          return (await DiscoveryFilterPreferences(
            await p.bind(o.route()),
          ).read()).hidden;
        } finally {
          p.close();
          o.close();
        }
      }

      expect(await hidden(socket, 'test-gateway', 'work'), {'/src/repo'});
      expect(await hidden(socket, 'test-gateway', 'personal'), isEmpty);
      expect(await hidden(socket, 'other-gateway', 'work'), isEmpty);
      expect(
        await hidden(_Socket('https://other.invalid'), 'test-gateway', 'work'),
        isEmpty,
      );
      final implicit = _owner(socket, profile: null);
      final implicitPane = implicit.pane();
      final implicitTarget = await implicitPane.bind(implicit.route());
      await DiscoveryFilterPreferences(implicitTarget).setHidden('/here', true);
      expect(await hidden(socket, 'test-gateway', 'default'), isEmpty);
      implicitPane.close();
      implicit.close();
      await prefs.setHidden('/src/repo', false);
      expect(await hidden(socket, 'test-gateway', 'work'), isEmpty);
      expect(socket.params, isEmpty);
    },
  );

  test(
    'same-scope edits merge hides; stale subtree drafts cannot replace a newer selection',
    () async {
      final second = DiscoveryFilterPreferences(
        await owner.pane().bind(owner.route()),
      );
      final first = DiscoveryFilterPreferences(target);
      final original = await first.read();
      await Future.wait([
        first.setHidden('/a', true),
        second.setHidden('/b', true),
      ]);
      final saved = await second.setSubtrees(
        original,
        ['/include', '/more'],
        ['/include/ex'],
      );
      expect(saved.hidden, {'/a', '/b'});
      await expectLater(
        first.setSubtrees(original, ['/stale'], []),
        _fails(WorkspaceFailure.mismatch),
      );
      await first.setHidden('/a', false);
      final persisted = await second.read();
      expect(persisted.hidden, {'/b'});
      expect(persisted.roots, {'/include', '/more'});
      expect(persisted.exclusions, {'/include/ex'});
      expect(socket.params, isEmpty);
    },
  );

  test(
    'recheck owner after preference I/O; an acknowledged but absent write does not hide a row',
    () async {
      final storage = _HeldStorage();
      SharedPreferencesAsyncPlatform.instance = storage;
      final pending = DiscoveryFilterPreferences(
        target,
      ).setHidden('/src/repo', true);
      await storage.entered.future;
      pane.invalidate();
      storage.release.complete();
      await expectLater(pending, _fails(WorkspaceFailure.stale));
      expect(storage.writes, 0);
      storage.dropWrites = true;
      final fresh = DiscoveryFilterPreferences(await pane.bind(owner.route()));
      await expectLater(
        fresh.setHidden('/src/repo', true),
        _fails(WorkspaceFailure.mismatch),
      );
      expect((await fresh.read()).hidden, isEmpty);
    },
  );

  Widget view(RemoteWorkspaceOwner o) => MaterialApp(
    theme: ThemeData(splashFactory: NoSplash.splashFactory),
    home: WorkspaceDiscoveryView(owner: o, route: o.route()),
  );

  testWidgets(
    'scan renders the returned rows and policy, not the policy shown at request time',
    (tester) async {
      await tester.pumpWidget(view(owner));
      await tester.pumpAndSettle();
      final button = find.widgetWithText(OutlinedButton, 'Scan gateway roots');
      final oldScan = tester.widget<OutlinedButton>(button).onPressed!;
      socket.result = {
        'repos': [
          {'root': '/now/visible'},
        ],
        'discovery_policy': {
          'enabled': false,
          'roots': ['/new'],
          'exclude_paths': ['/new/old'],
        },
      };
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text('Scanning: disabled'), findsOneWidget);
      expect(find.text('Scan roots: /new'), findsOneWidget);
      expect(find.text('Excluded subtrees: /new/old'), findsOneWidget);
      expect(find.text('/now/visible'), findsOneWidget);
      expect(find.text('Repo'), findsNothing);
      expect(tester.widget<OutlinedButton>(button).onPressed, isNull);
      oldScan();
      await tester.pumpAndSettle();
      expect(socket.params, [
        {'scan': false, 'profile': 'work'},
        {'scan': true, 'profile': 'work'},
      ]);
    },
  );

  testWidgets(
    'shows effective policy, scans on request, hides durably and offers undo',
    (tester) async {
      await tester.pumpWidget(view(owner));
      await tester.pumpAndSettle();
      expect(find.text('Scanning: enabled'), findsOneWidget);
      expect(find.text('Scan roots: /src\n/extra'), findsOneWidget);
      expect(find.text('Excluded subtrees: /src/skip'), findsOneWidget);
      expect(socket.params, [
        {'scan': false, 'profile': 'work'},
      ]);
      await tester.tap(find.text('Scan gateway roots'));
      await tester.pumpAndSettle();
      expect(socket.params.last, {'scan': true, 'profile': 'work'});
      final hide = find.byTooltip('Hide /src/repo');
      await tester.ensureVisible(hide);
      await tester.tap(hide);
      await tester.pumpAndSettle();
      expect(find.text('Repositories shown: 1 of 2'), findsOneWidget);
      expect(find.text('Repo'), findsNothing);
      expect(socket.params, hasLength(2));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(view(owner));
      await tester.pumpAndSettle();
      expect(find.text('Repo'), findsNothing);
      await tester.tap(find.text('Hidden repositories (1)'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Undo hide'));
      await tester.tap(find.text('Undo hide'));
      await tester.pumpAndSettle();
      expect(find.text('Repositories shown: 2 of 2'), findsOneWidget);
      expect(find.text('Hidden repositories (1)'), findsNothing);
      expect(socket.params, hasLength(3));
    },
  );

  testWidgets(
    'device subtree filters survive reopen, never change the server policy or scan parameters',
    (tester) async {
      await tester.pumpWidget(view(owner));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Filter results on this device'));
      await tester.pumpAndSettle();
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), '/src\n/elsewhere');
      await tester.enterText(fields.at(1), '/src/repo');
      final apply = find.text('Apply filters');
      await tester.ensureVisible(apply);
      await tester.tap(apply);
      await tester.pumpAndSettle();
      expect(find.text('Repositories shown: 1 of 2'), findsOneWidget);
      expect(socket.params, hasLength(1));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(view(owner));
      await tester.pumpAndSettle();
      expect(find.text('Repositories shown: 1 of 2'), findsOneWidget);
      expect(find.text('Scan roots: /src\n/extra'), findsOneWidget);
      expect(socket.params, everyElement({'scan': false, 'profile': 'work'}));
    },
  );

  testWidgets(
    'owner switch drops held scan, captured controls and same-ID account mutation',
    (tester) async {
      await tester.pumpWidget(view(owner));
      await tester.pumpAndSettle();
      final oldHide = tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (w) => w is IconButton && w.tooltip == 'Hide /src/repo',
            ),
          )
          .onPressed!;
      final held = Completer<_Json>();
      socket.intercept = () => held.future;
      await tester.tap(find.text('Scan gateway roots'));
      await tester.pump();
      final otherSocket = _Socket();
      otherSocket.result['repos'] = [
        {'root': '/other', 'label': 'Other', 'sessions': 1},
      ];
      otherSocket.result['discovery_policy']['enabled'] = false;
      final other = _owner(otherSocket, profile: 'other');
      await tester.pumpWidget(view(other));
      await tester.pumpAndSettle();
      oldHide();
      held.complete({'result': socket.result});
      await tester.pumpAndSettle();
      expect(find.text('Other'), findsOneWidget);
      expect(find.text('Repo'), findsNothing);
      expect(
        tester
            .widget<OutlinedButton>(
              find.widgetWithText(OutlinedButton, 'Scan gateway roots'),
            )
            .onPressed,
        isNull,
      );
      final lease = ConnectionMutationBarrier.begin([other.connectionId]);
      await tester.pumpAndSettle();
      lease.release();
      expect(find.text('Other'), findsNothing);
      expect(find.textContaining('connection changed'), findsOneWidget);
      other.close();
    },
  );
}
