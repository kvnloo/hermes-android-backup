import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/widgets/git_review_pane.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';

import 'support/disposable_git_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides? previous;
  setUp(() {
    previous = HttpOverrides.current;
    HttpOverrides.global = null;
  });
  tearDown(() => HttpOverrides.global = previous);

  test('B1 ordinary Git rows stay visible', () async {
    final harness = await _GitHarness.open();
    try {
      final repo = harness.repo;
      final config = harness.config;
      await _git(repo, ['init', '-b', 'main'], config);
      File('${repo.path}/.gitignore').writeAsStringSync('x\n');
      File('${repo.path}/keep').writeAsStringSync('k\n');
      await _git(repo, ['add', '.gitignore', 'keep'], config);
      await _git(repo, ['commit', '-m', 'init'], config);
      File('${repo.path}/kind').writeAsStringSync('file\n');
      await _git(repo, ['add', 'kind'], config);
      await _git(repo, ['commit', '-m', 'kind'], config);
      File('${repo.path}/.gitignore').writeAsStringSync('x\ny\n');
      File('${repo.path}/kind').deleteSync();
      await Link('${repo.path}/kind').create('keep');
      File('${repo.path}/My Notes.md').writeAsStringSync('hello notes\n');
      await _git(repo, [
        'worktree',
        'add',
        '${repo.path}/.worktrees/hold',
        '-b',
        'feature/hold',
      ], config);
      await _git(repo, [
        'branch',
        'dependabot/npm_and_yarn/@babel/core-7.26.0',
      ], config);
      harness.gateway.extraReviewRows.addAll([
        {
          'path': '/etc/passwd',
          'added': 1,
          'removed': 0,
          'status': 'M',
          'staged': false,
        },
        {
          'path': 'typed.txt',
          'added': 1,
          'removed': 0,
          'status': 'X',
          'staged': false,
        },
      ]);

      final target = await harness.pane.bind(
        harness.route,
        expectedCwd: repo.path,
      );
      final list = await target.gitReviewList(
        scope: GitReviewScope.uncommitted,
      );
      final byPath = {for (final file in list.files) file.path: file};
      expect(byPath.keys, isNot(contains('/etc/passwd')));
      expect(byPath['.gitignore']?.status, 'M');
      expect(byPath['My Notes.md']?.status, '?');
      expect(byPath['.worktrees/']?.status, '?');
      expect(byPath['kind']?.status, 'T');
      expect(byPath['typed.txt']?.status, 'changed');
      final diff = await target.gitReviewDiff(
        file: 'My Notes.md',
        scope: GitReviewScope.uncommitted,
      );
      expect(diff, contains('hello notes'));
      final branches = await target.gitBranches();
      expect(
        branches.map((branch) => branch.name),
        contains('dependabot/npm_and_yarn/@babel/core-7.26.0'),
      );
    } finally {
      await harness.close();
    }
  });

  test('B4 records HEAD for this owner, session and directory', () async {
    final harness = await _GitHarness.open();
    try {
      final repo = harness.repo;
      await _git(repo, ['init', '-b', 'main'], harness.config);
      File('${repo.path}/README.md').writeAsStringSync('hello\n');
      await _git(repo, ['add', 'README.md'], harness.config);
      await _git(repo, ['commit', '-m', 'Initial'], harness.config);
      final head = await Process.run('git', [
        'rev-parse',
        'HEAD',
      ], workingDirectory: repo.path);
      final sha = (head.stdout as String).trim();
      await captureGitTurnBaseline(owner: harness.owner, sessionId: 'stored');
      expect(
        gitTurnMemory.baselineFor(
          ownerId: harness.owner.connectionId,
          profile: harness.owner.profile,
          sessionId: 'stored',
          cwd: repo.path,
        ),
        sha,
      );
      expect(
        gitTurnMemory.baselineFor(
          ownerId: harness.owner.connectionId,
          profile: harness.owner.profile,
          sessionId: 'stored',
          cwd: '${repo.path}/.worktrees/lane',
        ),
        isNull,
      );
    } finally {
      await harness.close();
    }
  });

  test('B2 stock worktree removal is success', () async {
    final harness = await _GitHarness.open();
    try {
      final repo = harness.repo;
      await _git(repo, ['init', '-b', 'main'], harness.config);
      File('${repo.path}/README.md').writeAsStringSync('hello\n');
      await _git(repo, ['add', 'README.md'], harness.config);
      await _git(repo, ['commit', '-m', 'Initial'], harness.config);
      final target = await harness.pane.bind(
        harness.route,
        expectedCwd: repo.path,
      );
      final created = await target.gitWorktreeAdd(
        name: 'hold',
        branch: 'feature/hold',
      );
      expect(Directory(created.path).existsSync(), isTrue);
      await target.gitWorktreeRemove(worktreePath: created.path);
      expect(Directory(created.path).existsSync(), isFalse);
      final trees = await target.gitWorktrees();
      expect(trees.map((tree) => tree.path), isNot(contains(created.path)));
    } finally {
      await harness.close();
    }
  });

  for (final classic in [true, false]) {
    final layout = classic ? 'Classic' : 'NextGen';

    testWidgets(
      '$layout B3 disables create pull request until gh is ready',
      (tester) async {
        await _surface(tester);
        final harness = await _showPane(tester, classic: classic, dirty: true);
        expect(
          find.text('Install the GitHub CLI (gh) and sign in to open PRs'),
          findsOneWidget,
        );
        final button = tester.widget<OutlinedButton>(
          find.byKey(const Key('git-pr')),
        );
        expect(button.onPressed, isNull);
        expect(_prPosts(harness.gateway), 0);
        await _release(tester, harness);
      },
      timeout: const Timeout(Duration(seconds: 40)),
    );

    testWidgets(
      '$layout B3 opens an existing pull request',
      (tester) async {
        await _surface(tester);
        final harness = await _showPane(
          tester,
          classic: classic,
          dirty: true,
          ghReady: true,
          pullRequestUrl: 'https://example.com/pull/7',
        );
        expect(find.text('Pull request ready'), findsOneWidget);
        final opened = <String>[];
        debugOpenGitPullRequest = (url) async {
          opened.add(url);
        };
        addTearDown(() => debugOpenGitPullRequest = null);
        final before = _prPosts(harness.gateway);
        await tester.tap(find.byKey(const Key('git-pr')));
        await tester.pump();
        expect(_prPosts(harness.gateway), before);
        expect(opened, ['https://example.com/pull/7']);
        await _release(tester, harness);
      },
      timeout: const Timeout(Duration(seconds: 40)),
    );

    testWidgets(
      '$layout B4 marks HEAD after a failed last-turn load',
      (tester) async {
        await _surface(tester);
        final harness = await _showPane(tester, classic: classic, dirty: true);
        await tester.tap(find.text('Last turn'));
        await _settle(tester);
        expect(find.byKey(const Key('git-mark-head')), findsOneWidget);
        await tester.ensureVisible(find.byKey(const Key('git-mark-head')));
        await tester.tap(find.byKey(const Key('git-mark-head')));
        await _settle(tester);
        expect(
          find.text('This review is no longer the selected session.'),
          findsNothing,
        );
        expect(find.byKey(const Key('git-mark-head')), findsNothing);
        expect(find.byKey(const Key('git-file-README.md')), findsOneWidget);
        await _release(tester, harness);
      },
      timeout: const Timeout(Duration(seconds: 40)),
    );

    testWidgets(
      '$layout B5 follow does not pin the directory',
      (tester) async {
        await _surface(tester);
        final harness = await _showPane(
          tester,
          classic: classic,
          worktree: true,
        );
        await tester.tap(find.byKey(const Key('git-follow-lane')));
        await _until(tester, find.byKey(const Key('git-confirm')));
        await tester.tap(find.byKey(const Key('git-confirm')));
        await _untilCwd(tester, (cwd) => cwd.endsWith('/.worktrees/lane'));
        harness.gateway.cwd = harness.repo.path;
        await tester.runAsync(() async {
          final extra = harness.owner.pane();
          await extra.adoptMovedWorkspace(harness.route);
          extra.close();
        });
        await tester.tap(find.byKey(const Key('git-refresh')));
        await _untilCwd(tester, (cwd) => cwd == harness.repo.path);
        expect(find.textContaining('session changed'), findsNothing);
        await _release(tester, harness);
      },
      timeout: const Timeout(Duration(seconds: 40)),
    );

    testWidgets(
      '$layout B5 a dropped follow socket clears busy',
      (tester) async {
        await _surface(tester);
        final harness = await _showPane(
          tester,
          classic: classic,
          worktree: true,
        );
        harness.gateway.dropResume = true;
        await tester.tap(find.byKey(const Key('git-follow-lane')));
        await _until(tester, find.byKey(const Key('git-confirm')));
        await tester.tap(find.byKey(const Key('git-confirm')));
        await _until(tester, find.byKey(const Key('git-error')));
        expect(
          tester
              .widget<IconButton>(find.byKey(const Key('git-refresh')))
              .onPressed,
          isNotNull,
        );
        await _release(tester, harness);
      },
      timeout: const Timeout(Duration(seconds: 40)),
    );
  }
}

int _prPosts(DisposableGitGateway gateway) => gateway.posts
    .where((post) => '${post['path']}'.endsWith('/create-pr'))
    .length;

Future<void> _surface(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1200, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<_GitHarness> _showPane(
  WidgetTester tester, {
  required bool classic,
  bool dirty = false,
  bool worktree = false,
  bool ghReady = false,
  String? pullRequestUrl,
}) async {
  final harness = await tester.runAsync(
    () => _GitHarness.open(classic: classic),
  );
  addTearDown(() async {
    await harness?.close();
  });
  final repo = harness!.repo;
  await tester.runAsync(() async {
    await _git(repo, ['init', '-b', 'main'], harness.config);
    File('${repo.path}/README.md').writeAsStringSync('hello\n');
    await _git(repo, ['add', 'README.md'], harness.config);
    await _git(repo, ['commit', '-m', 'Initial'], harness.config);
    if (worktree) {
      File('${repo.path}/.gitignore').writeAsStringSync('.worktrees/\n');
      await _git(repo, ['add', '.gitignore'], harness.config);
      await _git(repo, ['commit', '-m', 'ignore worktrees'], harness.config);
      await _git(repo, [
        'worktree',
        'add',
        '${repo.path}/.worktrees/lane',
        '-b',
        'lane',
      ], harness.config);
    }
    if (dirty) {
      File('${repo.path}/README.md').writeAsStringSync('hello\nchanged\n');
    }
    harness.gateway
      ..ghReady = ghReady
      ..pullRequestUrl = pullRequestUrl;
  });
  await tester.pumpWidget(
    MaterialApp(
      home: GitReviewPane(
        owner: harness.owner,
        route: harness.route,
        onClose: () {},
      ),
    ),
  );
  await _until(tester, find.byKey(const Key('git-cwd')));
  return harness;
}

Future<void> _release(WidgetTester tester, _GitHarness harness) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.runAsync(harness.close);
  // dart:io keeps a zero-duration idle timer after each response. pump()
  // does not elapse, so the timer is still pending when the test ends.
  // pump(Duration.zero) elapses and fires it, including timers created
  // while the previous one is firing.
  for (var i = 0; i < 4; i++) {
    await tester.pump(Duration.zero);
  }
}

Future<void> _settle(WidgetTester tester) => _until(
  tester,
  find.byWidgetPredicate(
    (widget) => widget is LinearProgressIndicator,
    skipOffstage: false,
  ),
  present: false,
);

Future<void> _until(
  WidgetTester tester,
  Finder finder, {
  bool present = true,
}) async {
  for (var i = 0; i < 80; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();
    final found = finder.evaluate().isNotEmpty;
    if (found == present) return;
  }
  fail(
    'Timed out waiting for ${present ? '' : 'absence of '}$finder. '
    '${_visible(tester)}',
  );
}

Future<void> _untilCwd(
  WidgetTester tester,
  bool Function(String cwd) match,
) async {
  for (var i = 0; i < 80; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();
    final cwd = find.byKey(const Key('git-cwd'));
    if (cwd.evaluate().isNotEmpty) {
      final shown = tester.widget<Text>(cwd).data ?? '';
      if (match(shown)) return;
    }
  }
  fail('Timed out waiting for the working directory. ${_visible(tester)}');
}

String _visible(WidgetTester tester) {
  final texts = tester
      .widgetList<Text>(find.byType(Text))
      .map((text) => text.data)
      .whereType<String>()
      .where((text) => text.trim().isNotEmpty)
      .take(12)
      .join(' | ');
  return 'visible: $texts';
}

class _GitHarness {
  _GitHarness({
    required this.root,
    required this.repo,
    required this.config,
    required this.gateway,
    required this.owner,
    required this.pane,
    required this.route,
    required this.dispose,
  });

  final Directory root;
  final Directory repo;
  final File config;
  final DisposableGitGateway gateway;
  final RemoteWorkspaceOwner owner;
  final WorkspacePane pane;
  final WorkspaceRoute route;
  final void Function() dispose;
  var closed = false;

  static Future<_GitHarness> open({bool classic = true}) async {
    final root = Directory(
      '${Directory.current.path}/.dart_tool/lane-tmp/git-blockers-${DateTime.now().microsecondsSinceEpoch}',
    )..createSync(recursive: true);
    final repo = Directory('${root.path}/repo')..createSync();
    final config = File('${root.path}/empty-gitconfig')..createSync();
    final gateway = await DisposableGitGateway.start(repo);
    late final RemoteWorkspaceOwner owner;
    late final void Function() dispose;
    if (classic) {
      final client = DesktopGatewayClient.fromConnection(gateway.connection);
      client.setReconnectAllowed(false);
      owner = client.workspace;
      dispose = client.close;
      await client.resumeSubmittedSession(
        localSessionId: 'local',
        storedSessionId: 'stored',
      );
    } else {
      final client = NextGenGateway(gateway.connection);
      owner = client.workspace;
      dispose = client.dispose;
      await client.connected();
      await client.call('session.resume', {
        'session_id': 'stored',
        'omit_messages': true,
      });
    }
    final pane = owner.pane();
    return _GitHarness(
      root: root,
      repo: repo,
      config: config,
      gateway: gateway,
      owner: owner,
      pane: pane,
      route: owner.route(storedSessionId: 'stored'),
      dispose: dispose,
    );
  }

  Future<void> close() async {
    if (closed) return;
    closed = true;
    pane.close();
    dispose();
    await gateway.close();
    if (root.existsSync()) root.deleteSync(recursive: true);
  }
}

Future<void> _git(Directory dir, List<String> args, File config) async {
  final result = await Process.run(
    'git',
    args,
    workingDirectory: dir.path,
    environment: {
      'PATH': Platform.environment['PATH'] ?? '/usr/bin:/bin',
      'GIT_CONFIG_GLOBAL': config.path,
      'GIT_CONFIG_NOSYSTEM': '1',
      'GIT_AUTHOR_NAME': 'Ares Fixture',
      'GIT_AUTHOR_EMAIL': 'ares@localhost',
      'GIT_COMMITTER_NAME': 'Ares Fixture',
      'GIT_COMMITTER_EMAIL': 'ares@localhost',
    },
  );
  if (result.exitCode != 0) {
    fail('${args.join(' ')}\n${result.stdout}\n${result.stderr}');
  }
}
