import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';

import 'support/disposable_git_gateway.dart';

void main() {
  for (final classic in [true, false]) {
    test(
      '${classic ? 'Classic' : 'NextGen'} ships a disposable repository',
      () async {
        final root = Directory(
          '${Directory.current.path}/.dart_tool/lane-tmp/git-f07-$classic',
        );
        if (root.existsSync()) root.deleteSync(recursive: true);
        root.createSync(recursive: true);
        final repo = Directory('${root.path}/repo')..createSync();
        final bare = Directory('${root.path}/bare.git')..createSync();
        final config = File('${root.path}/empty-gitconfig')..createSync();
        await _git(repo, ['init', '-b', 'main'], config);
        await _git(repo, ['config', 'user.name', 'Ares Fixture'], config);
        await _git(repo, ['config', 'user.email', 'ares@localhost'], config);
        await _git(repo, ['config', 'commit.gpgsign', 'false'], config);
        File('${repo.path}/README.md').writeAsStringSync('hello\n');
        await _git(repo, ['add', 'README.md'], config);
        await _git(repo, ['commit', '-m', 'Initial'], config);
        await _git(repo, ['branch', 'other'], config);
        await _git(bare, ['init', '--bare'], config);
        await _git(repo, ['remote', 'add', 'origin', bare.path], config);
        await _git(repo, ['push', '-u', 'origin', 'main'], config);

        final gateway = await DisposableGitGateway.start(repo);
        late final RemoteWorkspaceOwner owner;
        late final WorkspacePane pane;
        late final void Function() dispose;
        if (classic) {
          final client = DesktopGatewayClient.fromConnection(
            gateway.connection,
          );
          client.setReconnectAllowed(false);
          owner = client.workspace;
          pane = owner.pane();
          dispose = client.close;
          await client.resumeSubmittedSession(
            localSessionId: 'local',
            storedSessionId: 'stored',
          );
        } else {
          final client = NextGenGateway(gateway.connection);
          owner = client.workspace;
          pane = owner.pane();
          dispose = client.dispose;
          await client.connected();
          await client.call('session.resume', {
            'session_id': 'stored',
            'omit_messages': true,
          });
        }
        final route = owner.route(storedSessionId: 'stored');
        try {
          final target = await pane.bind(route, expectedCwd: repo.path);
          await expectLater(
            target.gitStage(file: '../outside'),
            throwsA(
              isA<WorkspaceException>().having(
                (error) => error.reason,
                'reason',
                WorkspaceFailure.invalid,
              ),
            ),
          );
          expect(
            gateway.posts.where((post) => '${post['path']}'.endsWith('/stage')),
            isEmpty,
          );

          final baseline = await target.gitRevParseHead();
          expect(baseline, hasLength(40));
          File('${repo.path}/README.md').writeAsStringSync('hello\nchanged\n');
          File('${repo.path}/notes.txt').writeAsStringSync('note line\n');
          final turn = await target.gitReviewList(
            scope: GitReviewScope.lastTurn,
            base: baseline,
          );
          expect(
            turn.files.map((file) => file.path),
            containsAll(['README.md', 'notes.txt']),
          );
          final diff = await target.gitReviewDiff(
            file: 'notes.txt',
            scope: GitReviewScope.lastTurn,
            base: baseline,
          );
          expect(diff, contains('+note line'));

          await target.gitStage(file: 'notes.txt');
          await target.gitUnstage(file: 'notes.txt');
          expect(await _porcelain(repo), contains('?? notes.txt'));
          await target.gitStage(file: 'notes.txt');
          await target.gitRevert(file: 'README.md');
          expect(await _porcelain(repo), isNot(contains('README.md')));
          expect(File('${repo.path}/README.md').readAsStringSync(), 'hello\n');

          final context = await target.gitCommitContext();
          final message = draftGitCommitMessage(context.diff);
          expect(message, contains('notes.txt'));
          await target.gitCommit(message: message);
          expect(await _subject(repo), contains('notes.txt'));

          await target.gitSwitchBranch('other');
          await target.gitSwitchBranch('main');
          expect(await _branch(repo), 'main');

          final removed = await target.gitWorktreeAdd(
            name: 'hold',
            branch: 'feature/hold',
          );
          expect(Directory(removed.path).existsSync(), isTrue);
          await target.gitWorktreeRemove(worktreePath: removed.path);
          expect(Directory(removed.path).existsSync(), isFalse);

          final created = await target.gitWorktreeAdd(
            name: 'lane',
            branch: 'feature/lane',
          );
          final fences = await target.cwdFences();
          await target.changeCwd(created.path, fences);
          await pane.adoptMovedWorkspace(route);
          final followed = await pane.bind(route, expectedCwd: created.path);
          expect(followed.canonicalCwd, created.path);
          File('${created.path}/lane.txt').writeAsStringSync('lane line\n');
          await followed.gitCommit(message: 'Update lane.txt');
          final branch = await followed.gitReviewList(
            scope: GitReviewScope.branch,
          );
          expect(branch.files.map((file) => file.path), contains('lane.txt'));
          await followed.gitPush();
          final published = await Process.run('git', [
            '--git-dir',
            bare.path,
            'rev-parse',
            'feature/lane',
          ]);
          expect(published.exitCode, 0);
          expect((published.stdout as String).trim(), hasLength(40));

          gateway.ghReady = true;
          final url = await followed.gitCreatePullRequest();
          expect(url, startsWith('file:'));
          expect(
            File('${bare.path}/PULL_REQUEST').readAsStringSync(),
            contains('feature/lane'),
          );
          final request = gateway.posts.last;
          expect('${request['path']}', endsWith('/create-pr'));
          expect((request['body'] as Map).keys, {'path'});
          expect(gateway.executables.toSet(), {'git'});
          expect(
            gateway.posts.any((post) => post.toString().contains('github.com')),
            isFalse,
          );
        } finally {
          pane.close();
          dispose();
          await gateway.close();
          if (root.existsSync()) root.deleteSync(recursive: true);
        }
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
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
    fail('${args.join(' ')}\n${result.stderr}');
  }
}

Future<String> _porcelain(Directory repo) async {
  final result = await Process.run('git', [
    'status',
    '--porcelain',
  ], workingDirectory: repo.path);
  return result.stdout as String;
}

Future<String> _subject(Directory repo) async {
  final result = await Process.run('git', [
    'log',
    '-1',
    '--format=%s',
  ], workingDirectory: repo.path);
  return (result.stdout as String).trim();
}

Future<String> _branch(Directory repo) async {
  final result = await Process.run('git', [
    'rev-parse',
    '--abbrev-ref',
    'HEAD',
  ], workingDirectory: repo.path);
  return (result.stdout as String).trim();
}
