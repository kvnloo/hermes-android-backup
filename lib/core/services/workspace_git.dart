part of 'remote_workspace.dart';

/// Review scopes mirrored from the gateway's `/api/git/review` routes.
/// Branch and last-turn are read-only; only uncommitted changes can be shipped.
enum GitReviewScope {
  uncommitted('uncommitted'),
  branch('branch'),
  lastTurn('lastTurn');

  const GitReviewScope(this.wire);
  final String wire;
}

final class GitReviewFile {
  const GitReviewFile({
    required this.path,
    required this.added,
    required this.removed,
    required this.status,
    required this.staged,
  });

  final String path;
  final int added;
  final int removed;
  final String status;
  final bool staged;
}

final class GitReviewList {
  const GitReviewList({
    required this.files,
    required this.base,
    this.omitted = 0,
  });
  final List<GitReviewFile> files;
  final String? base;

  /// Rows that were not safe to show. One bad row does not fail the read.
  final int omitted;
}

final class GitRows<T> {
  const GitRows(this.rows, {this.omitted = 0});
  final List<T> rows;
  final int omitted;
}

final class GitWorktreeInfo {
  const GitWorktreeInfo({
    required this.path,
    required this.branch,
    required this.isMain,
    required this.detached,
    required this.locked,
  });

  final String path;
  final String? branch;
  final bool isMain;
  final bool detached;
  final bool locked;
}

final class GitBranchInfo {
  const GitBranchInfo({
    required this.name,
    required this.checkedOut,
    required this.isDefault,
    required this.isRemote,
    required this.worktreePath,
  });

  final String name;
  final bool checkedOut;
  final bool isDefault;
  final bool isRemote;
  final String? worktreePath;
}

final class GitBaseBranch {
  const GitBaseBranch({
    required this.name,
    required this.isRemote,
    required this.isDefault,
  });

  final String name;
  final bool isRemote;
  final bool isDefault;
}

final class GitShipInfo {
  const GitShipInfo({required this.ghReady, required this.prUrl});
  final bool ghReady;
  final String? prUrl;
}

final class GitWorktreeCreated {
  const GitWorktreeCreated({
    required this.path,
    required this.branch,
    required this.repoRoot,
  });

  final String path;
  final String branch;
  final String repoRoot;
}

/// HEAD captured when a turn starts. The key is owner, session and
/// directory, so following into another directory does not keep the old base.
final class GitTurnMemory {
  static const _cap = 8;
  final Map<String, String> _sha = {};
  final List<String> _order = [];

  static String key({
    required String ownerId,
    required String? profile,
    required String sessionId,
    required String cwd,
  }) => '$ownerId\u0000${profile ?? ''}\u0000$sessionId\u0000${cwd.trim()}';

  void remember({
    required String ownerId,
    required String? profile,
    required String sessionId,
    required String cwd,
    required String sha,
  }) {
    final id = key(
      ownerId: ownerId,
      profile: profile,
      sessionId: sessionId,
      cwd: cwd,
    );
    if (_sha[id] == sha) return;
    _order.remove(id);
    while (_order.length >= _cap) {
      _sha.remove(_order.removeAt(0));
    }
    _order.add(id);
    _sha[id] = sha;
  }

  String? baselineFor({
    required String ownerId,
    required String? profile,
    required String sessionId,
    required String cwd,
  }) =>
      _sha[key(
        ownerId: ownerId,
        profile: profile,
        sessionId: sessionId,
        cwd: cwd,
      )];
}

final gitTurnMemory = GitTurnMemory();

final _gitSha = RegExp(r'^[0-9a-f]{7,64}$');
const _knownGitStatus = {'M', 'A', 'D', 'R', 'C', 'T', 'U', '?'};

/// A repository-relative path Git can return: a leading dot, spaces and a
/// trailing slash are ordinary. Absolute paths, `..` and controls are not.
bool _gitRelative(String file) {
  if (file.isEmpty || file.length > 1024) return false;
  if (file.startsWith('/') || file.startsWith('\\')) return false;
  if (RegExp(r'^[A-Za-z]:[/\\]').hasMatch(file)) return false;
  if (RegExp(r'[\x00-\x1f\x7f]').hasMatch(file)) return false;
  final parts = file.split(RegExp(r'[/\\]'));
  if (parts.last.isEmpty) parts.removeLast();
  if (parts.isEmpty) return false;
  return parts.every((part) => part.isNotEmpty && part != '.' && part != '..');
}

/// `git check-ref-format` rules, including `@` inside a name.
bool _gitBranch(String name) {
  if (name.isEmpty || name.length > 200 || name == '@') return false;
  if (name.startsWith('/') ||
      name.endsWith('/') ||
      name.endsWith('.') ||
      name.contains('..') ||
      name.contains('//') ||
      name.contains('@{') ||
      name.contains('\\')) {
    return false;
  }
  if (RegExp(r'[\x00-\x20\x7f~^:?*\[]').hasMatch(name)) return false;
  return name
      .split('/')
      .every(
        (part) =>
            part.isNotEmpty && !part.startsWith('.') && !part.endsWith('.lock'),
      );
}

String? _gitStatus(String status) {
  if (_knownGitStatus.contains(status)) return status;
  if (status.length == 1 && RegExp(r'^[A-Za-z]$').hasMatch(status)) {
    return 'changed';
  }
  return null;
}

bool _commitMessage(String message) {
  final trimmed = message.trim();
  if (trimmed.isEmpty || trimmed.length > 2000) return false;
  return !RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]').hasMatch(trimmed);
}

/// A commit subject drafted from the files the gateway would commit.
/// This does not call a model: the diff is only scanned for paths.
String draftGitCommitMessage(String diff, {String avoid = ''}) {
  final files = <String>[];
  for (final line in diff.split('\n')) {
    String? path;
    if (line.startsWith('diff --git ')) {
      final mark = line.lastIndexOf(' b/');
      if (mark >= 0) path = line.substring(mark + 3).trim();
    } else if (line.startsWith('#   ') && !line.startsWith('#   ...')) {
      path = line.substring(4).trim();
    }
    if (path != null && _gitRelative(path) && !files.contains(path)) {
      files.add(path);
    }
  }
  if (files.isEmpty) return '';
  final summary = files.length == 1
      ? 'Update ${files.single}'
      : 'Update ${files.length} files\n\n${files.take(12).join('\n')}';
  return summary == avoid.trim() ? '$summary\n' : summary;
}

String _boundGitCwd(WorkspaceTarget target) {
  final cwd = target.canonicalCwd;
  if (cwd == null || !isSafeWorkspacePath(cwd)) {
    _fail(WorkspaceFailure.unbound);
  }
  return cwd;
}

Future<void> _requireHostGit(WorkspaceTarget target) async {
  final backend = await target.read(WorkspaceRead.terminalBackends);
  if (backend is! Map ||
      backend['active'] != 'local' ||
      (target._binding?.backend != null &&
          target._binding!.backend != 'local')) {
    _fail(WorkspaceFailure.unbound);
  }
  await target.verifySession();
}

GitReviewFile? _reviewFile(Object? raw) {
  if (raw is! Map) return null;
  final path = raw['path'];
  final added = raw['added'];
  final removed = raw['removed'];
  final status = raw['status'];
  final staged = raw['staged'];
  if (path is! String ||
      !_gitRelative(path) ||
      added is! int ||
      added < 0 ||
      removed is! int ||
      removed < 0 ||
      status is! String ||
      staged is! bool) {
    return null;
  }
  final shown = _gitStatus(status);
  if (shown == null) return null;
  return GitReviewFile(
    path: path,
    added: added,
    removed: removed,
    status: shown,
    staged: staged,
  );
}

/// Records HEAD for this session directory when a turn becomes busy.
/// Failure is ignored: a directory that is not a local repository has no
/// last-turn baseline, and the turn itself is not delayed.
Future<void> captureGitTurnBaseline({
  required RemoteWorkspaceOwner owner,
  required String sessionId,
}) async {
  if (sessionId.isEmpty) return;
  final pane = owner.pane();
  try {
    final target = await pane.bind(owner.route(storedSessionId: sessionId));
    final cwd = target.canonicalCwd;
    if (cwd == null) return;
    final sha = await target.gitRevParseHead();
    if (sha == null) return;
    gitTurnMemory.remember(
      ownerId: owner.connectionId,
      profile: owner.profile,
      sessionId: sessionId,
      cwd: cwd,
      sha: sha,
    );
  } on WorkspaceException {
    return;
  } finally {
    pane.close();
  }
}

extension SessionGit on WorkspaceTarget {
  Future<String?> gitRevParseHead() => _withOwner(() async {
    final cwd = _boundGitCwd(this);
    await _requireHostGit(this);
    final raw = await _get(
      ['git', 'review', 'rev-parse'],
      {'path': cwd, 'ref': 'HEAD'},
    );
    if (raw is! Map || !raw.containsKey('sha')) _fail(WorkspaceFailure.invalid);
    final sha = raw['sha'];
    if (sha == null) return null;
    if (sha is! String || !_gitSha.hasMatch(sha)) {
      _fail(WorkspaceFailure.invalid);
    }
    return sha;
  }, session: true);

  Future<GitReviewList> gitReviewList({
    required GitReviewScope scope,
    String? base,
  }) => _withOwner(() async {
    final cwd = _boundGitCwd(this);
    if (scope == GitReviewScope.lastTurn) {
      if (base == null || !_gitSha.hasMatch(base)) {
        _fail(WorkspaceFailure.invalid);
      }
    } else if (base != null) {
      _fail(WorkspaceFailure.invalid);
    }
    await _requireHostGit(this);
    final raw = await _get(
      ['git', 'review', 'list'],
      {'path': cwd, 'scope': scope.wire, 'base': ?base},
    );
    if (raw is! Map || raw['files'] is! List) _fail(WorkspaceFailure.invalid);
    final reported = raw['base'];
    if (reported != null &&
        (reported is! String || !_gitSha.hasMatch(reported))) {
      _fail(WorkspaceFailure.invalid);
    }
    final files = <GitReviewFile>[];
    var omitted = 0;
    for (final row in raw['files'] as List) {
      final file = _reviewFile(row);
      if (file == null) {
        omitted++;
      } else {
        files.add(file);
      }
    }
    return GitReviewList(
      files: List.unmodifiable(files),
      base: reported,
      omitted: omitted,
    );
  }, session: true);

  Future<String> gitReviewDiff({
    required String file,
    required GitReviewScope scope,
    String? base,
    bool staged = false,
  }) => _withOwner(() async {
    if (!_gitRelative(file)) _fail(WorkspaceFailure.invalid);
    if (scope == GitReviewScope.lastTurn) {
      if (base == null || !_gitSha.hasMatch(base)) {
        _fail(WorkspaceFailure.invalid);
      }
    } else if (base != null) {
      _fail(WorkspaceFailure.invalid);
    }
    final cwd = _boundGitCwd(this);
    await _requireHostGit(this);
    final raw = await _get(
      ['git', 'review', 'diff'],
      {
        'path': cwd,
        'file': file,
        'scope': scope.wire,
        'staged': staged ? 'true' : 'false',
        'base': ?base,
      },
    );
    if (raw is! Map || raw['diff'] is! String) _fail(WorkspaceFailure.invalid);
    return raw['diff'] as String;
  }, session: true);

  Future<({String diff, String recent})> gitCommitContext() =>
      _withOwner(() async {
        final cwd = _boundGitCwd(this);
        await _requireHostGit(this);
        final raw = await _get(
          ['git', 'review', 'commit-context'],
          {'path': cwd},
        );
        if (raw is! Map || raw['diff'] is! String || raw['recent'] is! String) {
          _fail(WorkspaceFailure.invalid);
        }
        return (diff: raw['diff'] as String, recent: raw['recent'] as String);
      }, session: true);

  Future<GitShipInfo> gitShipInfo() => _withOwner(() async {
    final cwd = _boundGitCwd(this);
    await _requireHostGit(this);
    final raw = await _get(['git', 'review', 'ship-info'], {'path': cwd});
    if (raw is! Map || raw['ghReady'] is! bool) _fail(WorkspaceFailure.invalid);
    final pr = raw['pr'];
    if (pr == null) {
      return GitShipInfo(ghReady: raw['ghReady'] as bool, prUrl: null);
    }
    if (pr is! Map || pr['url'] is! String || (pr['url'] as String).isEmpty) {
      _fail(WorkspaceFailure.invalid);
    }
    return GitShipInfo(
      ghReady: raw['ghReady'] as bool,
      prUrl: pr['url'] as String,
    );
  }, session: true);

  Future<GitRows<GitWorktreeInfo>> gitWorktreeRows() => _withOwner(() async {
    final cwd = _boundGitCwd(this);
    await _requireHostGit(this);
    final raw = await _get(['git', 'worktrees'], {'path': cwd});
    if (raw is! Map || raw['worktrees'] is! List) {
      _fail(WorkspaceFailure.invalid);
    }
    return _keep((raw['worktrees'] as List).map(_worktree));
  }, session: true);

  Future<List<GitWorktreeInfo>> gitWorktrees() async =>
      (await gitWorktreeRows()).rows;

  Future<GitRows<GitBranchInfo>> gitBranchRows() => _withOwner(() async {
    final cwd = _boundGitCwd(this);
    await _requireHostGit(this);
    final raw = await _get(['git', 'branches'], {'path': cwd});
    if (raw is! Map || raw['branches'] is! List) {
      _fail(WorkspaceFailure.invalid);
    }
    return _keep((raw['branches'] as List).map(_branch));
  }, session: true);

  Future<List<GitBranchInfo>> gitBranches() async =>
      (await gitBranchRows()).rows;

  Future<GitRows<GitBaseBranch>> gitBaseBranchRows() => _withOwner(() async {
    final cwd = _boundGitCwd(this);
    await _requireHostGit(this);
    final raw = await _get(['git', 'base-branches'], {'path': cwd});
    if (raw is! Map || raw['branches'] is! List) {
      _fail(WorkspaceFailure.invalid);
    }
    return _keep((raw['branches'] as List).map(_baseBranch));
  }, session: true);

  Future<List<GitBaseBranch>> gitBaseBranches() async =>
      (await gitBaseBranchRows()).rows;

  Future<void> gitStage({String? file}) => _mutate('review/stage', file: file);

  Future<void> gitUnstage({String? file}) =>
      _mutate('review/unstage', file: file);

  Future<void> gitRevert({String? file}) =>
      _mutate('review/revert', file: file);

  Future<void> gitCommit({required String message, bool push = false}) =>
      _mutate('review/commit', message: message, push: push);

  Future<void> gitPush() => _mutate('review/push');

  Future<String> gitCreatePullRequest() => _withOwner(() async {
    final ship = await gitShipInfo();
    // Stock pushes before it tries gh, so this must not be called unready.
    if (!ship.ghReady) _fail(WorkspaceFailure.denied);
    if (ship.prUrl != null) return ship.prUrl!;
    final raw = await _post('review/create-pr', const {});
    if (raw is! Map ||
        raw['url'] is! String ||
        (raw['url'] as String).isEmpty) {
      _fail(WorkspaceFailure.invalid);
    }
    return raw['url'] as String;
  }, session: true);

  Future<GitWorktreeCreated> gitWorktreeAdd({
    String? name,
    String? branch,
    String? base,
    String? existingBranch,
  }) => _withOwner(() async {
    if (existingBranch != null) {
      if (name != null || branch != null || base != null) {
        _fail(WorkspaceFailure.invalid);
      }
      if (!_gitBranch(existingBranch)) _fail(WorkspaceFailure.invalid);
    } else {
      if (name != null && !_gitBranch(name)) {
        _fail(WorkspaceFailure.invalid);
      }
      if (branch != null && !_gitBranch(branch)) {
        _fail(WorkspaceFailure.invalid);
      }
      if (base != null && !_gitBranch(base)) {
        _fail(WorkspaceFailure.invalid);
      }
    }
    final raw = await _post('worktree/add', {
      'name': ?name,
      'branch': ?branch,
      'base': ?base,
      'existingBranch': ?existingBranch,
    });
    if (raw is! Map) _fail(WorkspaceFailure.invalid);
    final path = raw['path'];
    final created = raw['branch'];
    final root = raw['repoRoot'];
    if (path is! String ||
        !isSafeWorkspacePath(path) ||
        created is! String ||
        !_gitBranch(created) ||
        root is! String ||
        !isSafeWorkspacePath(root)) {
      _fail(WorkspaceFailure.invalid);
    }
    return GitWorktreeCreated(path: path, branch: created, repoRoot: root);
  }, session: true);

  Future<void> gitWorktreeRemove({
    required String worktreePath,
    bool force = false,
  }) => _withOwner(() async {
    if (!isSafeWorkspacePath(worktreePath) || worktreePath == canonicalCwd) {
      _fail(WorkspaceFailure.invalid);
    }
    final known = await gitWorktrees();
    if (!known.any((tree) => tree.path == worktreePath && !tree.isMain)) {
      _fail(WorkspaceFailure.mismatch);
    }
    await _post('worktree/remove', {
      'worktreePath': worktreePath,
      'force': force,
    });
  }, session: true);

  Future<void> gitSwitchBranch(String branch) => _withOwner(() async {
    if (!_gitBranch(branch)) _fail(WorkspaceFailure.invalid);
    final raw = await _post('branch/switch', {'branch': branch});
    if (raw is! Map || raw['branch'] != branch) _fail(WorkspaceFailure.invalid);
  }, session: true);

  Future<void> _mutate(
    String operation, {
    String? file,
    String? message,
    bool push = false,
  }) => _withOwner(() async {
    if (file != null && !_gitRelative(file)) _fail(WorkspaceFailure.invalid);
    if (message != null && !_commitMessage(message)) {
      _fail(WorkspaceFailure.invalid);
    }
    final fields = <String, Object?>{};
    if (operation == 'review/stage' ||
        operation == 'review/unstage' ||
        operation == 'review/revert') {
      if (file != null) fields['file'] = file;
    } else if (operation == 'review/commit') {
      fields['message'] = message!.trim();
      fields['push'] = push;
    } else if (operation != 'review/push') {
      _fail(WorkspaceFailure.invalid);
    }
    await _post(operation, fields);
  }, session: true);

  Future<Object?> _post(String operation, Map<String, Object?> fields) async {
    final cwd = _boundGitCwd(this);
    await _requireHostGit(this);
    final raw = await _owner._dashboard.workspaceGitPost(
      operation: operation,
      profile: effectiveProfile,
      check: checkCurrent,
      body: {'path': cwd, ...fields},
    );
    if (operation == 'review/create-pr' ||
        operation == 'worktree/add' ||
        operation == 'branch/switch') {
      return raw;
    }
    if (operation == 'worktree/remove') {
      final requested = fields['worktreePath'];
      if (raw is! Map || raw['removed'] != requested) {
        _fail(WorkspaceFailure.invalid);
      }
      return raw;
    }
    if (raw is! Map || raw['ok'] != true) _fail(WorkspaceFailure.invalid);
    return raw;
  }
}

GitRows<T> _keep<T>(Iterable<T?> rows) {
  final kept = <T>[];
  var omitted = 0;
  for (final row in rows) {
    if (row == null) {
      omitted++;
    } else {
      kept.add(row);
    }
  }
  return GitRows(List.unmodifiable(kept), omitted: omitted);
}

GitWorktreeInfo? _worktree(Object? raw) {
  if (raw is! Map) return null;
  final path = raw['path'];
  final branch = raw['branch'];
  if (path is! String ||
      !isSafeWorkspacePath(path) ||
      (branch != null && (branch is! String || !_gitBranch(branch))) ||
      raw['isMain'] is! bool ||
      raw['detached'] is! bool ||
      raw['locked'] is! bool) {
    return null;
  }
  return GitWorktreeInfo(
    path: path,
    branch: branch as String?,
    isMain: raw['isMain'] as bool,
    detached: raw['detached'] as bool,
    locked: raw['locked'] as bool,
  );
}

GitBranchInfo? _branch(Object? raw) {
  if (raw is! Map) return null;
  final name = raw['name'];
  final worktree = raw['worktreePath'];
  if (name is! String ||
      !_gitBranch(name) ||
      raw['checkedOut'] is! bool ||
      raw['isDefault'] is! bool ||
      raw['isRemote'] is! bool ||
      (worktree != null &&
          (worktree is! String || !isSafeWorkspacePath(worktree)))) {
    return null;
  }
  return GitBranchInfo(
    name: name,
    checkedOut: raw['checkedOut'] as bool,
    isDefault: raw['isDefault'] as bool,
    isRemote: raw['isRemote'] as bool,
    worktreePath: worktree as String?,
  );
}

GitBaseBranch? _baseBranch(Object? raw) {
  if (raw is! Map) return null;
  final name = raw['name'];
  if (name is! String ||
      !_gitBranch(name) ||
      raw['isRemote'] is! bool ||
      raw['isDefault'] is! bool) {
    return null;
  }
  return GitBaseBranch(
    name: name,
    isRemote: raw['isRemote'] as bool,
    isDefault: raw['isDefault'] as bool,
  );
}
