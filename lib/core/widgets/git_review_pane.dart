import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

import '../models/turn_changed_files.dart';
import '../services/remote_workspace.dart';
import 'markdown_link_handler.dart';

/// Test hook for the pull-request button. Production uses the shared web-link
/// handler, which allows only http and https.
@visibleForTesting
Future<void> Function(String url)? debugOpenGitPullRequest;

class TurnChangedFilesCard extends StatelessWidget {
  const TurnChangedFilesCard({
    super.key,
    required this.files,
    required this.onOpen,
  });

  final List<TurnChangedFile> files;
  final ValueChanged<TurnChangedFile> onOpen;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Card(
      key: const Key('turn-changed-files'),
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.sharedL10n.release_core_git_files_changed(files.length),
              style: theme.textTheme.titleSmall,
            ),
            for (final file in files)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(file.name),
                subtitle: Text('+${file.added} -${file.removed}'),
                onTap: () => onOpen(file),
              ),
          ],
        ),
      ),
    );
  }
}

/// Owner-scoped Git review for the session directory. Mutations are the named
/// gateway operations; this pane never assembles a shell command.
class GitReviewPane extends StatefulWidget {
  const GitReviewPane({
    super.key,
    required this.owner,
    required this.route,
    this.expectedCwd,
    this.turnBaseline,
    this.initialFile,
    this.onHandOff,
    this.onClose,
    this.onFollowed,
  });

  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final String? expectedCwd;
  final String? turnBaseline;
  final String? initialFile;
  final ValueChanged<String>? onHandOff;
  final VoidCallback? onClose;
  final ValueChanged<String>? onFollowed;

  @override
  State<GitReviewPane> createState() => _GitReviewPaneState();
}

class _GitReviewPaneState extends State<GitReviewPane> {
  late WorkspacePane _pane;
  WorkspaceTarget? _target;
  var _epoch = 0;
  var _busy = false;
  var _pinned = false;
  String? _expected;
  var _scope = GitReviewScope.uncommitted;
  String? _baseline;
  String? _baselineCwd;
  var _omitted = 0;
  String Function(AppLocalizations)? _message;
  String? _diff;
  String? _selected;
  String? _prUrl;
  var _ghReady = false;
  List<GitReviewFile> _files = const [];
  List<GitWorktreeInfo> _trees = const [];
  List<GitBranchInfo> _branches = const [];
  List<GitBaseBranch> _bases = const [];
  final _commit = TextEditingController();
  final _workName = TextEditingController();
  final _workBranch = TextEditingController();
  String? _base;
  String? _convert;
  String? _switchTo;

  bool _owns(int epoch) => mounted && epoch == _epoch;

  @override
  void initState() {
    super.initState();
    _baseline = widget.turnBaseline;
    _expected = widget.expectedCwd;
    _pane = widget.owner.pane();
    _load();
  }

  @override
  void didUpdateWidget(GitReviewPane old) {
    super.didUpdateWidget(old);
    final switched =
        !identical(old.owner, widget.owner) || old.route != widget.route;
    if (switched) {
      _pane.close();
      _pane = widget.owner.pane();
      _target = null;
      _expected = widget.expectedCwd;
      _baseline = widget.turnBaseline;
      _baselineCwd = null;
      _files = const [];
      _diff = null;
      _message = null;
      _load();
      return;
    }
    if (old.turnBaseline != widget.turnBaseline) {
      _baseline = widget.turnBaseline;
      _baselineCwd = null;
      if (_scope == GitReviewScope.lastTurn) _load();
    }
  }

  @override
  void dispose() {
    _epoch++;
    _pane.close();
    _commit.dispose();
    _workName.dispose();
    _workBranch.dispose();
    super.dispose();
  }

  Future<void> _load({String? expected}) async {
    final epoch = ++_epoch;
    // A Follow confirms one directory. Keeping that path would make every
    // later move look like the session changed.
    final pinned = expected ?? _expected;
    if (expected != null) _expected = null;
    setState(() {
      _busy = true;
      _message = null;
    });
    WorkspaceTarget? bound;
    try {
      final target = await _pane.bind(widget.route, expectedCwd: pinned);
      if (!_owns(epoch)) return;
      bound = target;
      final cwd = target.canonicalCwd;
      final baseline = _baselineFor(cwd);
      final results = await Future.wait<Object?>([
        target.gitReviewList(
          scope: _scope,
          base: _scope == GitReviewScope.lastTurn ? baseline : null,
        ),
        target.gitWorktreeRows(),
        target.gitBranchRows(),
        target.gitBaseBranchRows(),
        target.gitShipInfo(),
      ]);
      if (!_owns(epoch)) return;
      final list = results[0] as GitReviewList;
      final trees = results[1] as GitRows<GitWorktreeInfo>;
      final branches = results[2] as GitRows<GitBranchInfo>;
      final bases = results[3] as GitRows<GitBaseBranch>;
      final ship = results[4] as GitShipInfo;
      setState(() {
        _target = target;
        _baseline = baseline;
        _baselineCwd = cwd;
        _files = list.files;
        _trees = trees.rows;
        _branches = branches.rows;
        _bases = bases.rows;
        _omitted =
            list.omitted + trees.omitted + branches.omitted + bases.omitted;
        _ghReady = ship.ghReady;
        _prUrl = ship.prUrl ?? _prUrl;
        _base ??= _bases
            .where((row) => row.isDefault)
            .map((row) => row.name)
            .firstOrNull;
        _selected = _match(widget.initialFile) ?? _selected;
        _busy = false;
      });
      if (_selected != null) await _showDiff(epoch);
    } on WorkspaceException catch (error) {
      if (!_owns(epoch)) return;
      setState(() {
        _busy = false;
        _message = _why(error);
        if (bound != null) _target = bound;
      });
    } catch (_) {
      if (!_owns(epoch)) return;
      setState(() {
        _busy = false;
        _message = (l10n) => l10n
            .release_core_git_review_pane_the_git_operation_did_not_complete;
        if (bound != null) _target = bound;
      });
    }
  }

  String? _baselineFor(String? cwd) {
    final session = widget.route.storedSessionId;
    if (cwd != null && session != null) {
      final recorded = gitTurnMemory.baselineFor(
        ownerId: widget.owner.connectionId,
        profile: widget.owner.profile,
        sessionId: session,
        cwd: cwd,
      );
      if (recorded != null) return recorded;
    }
    if (cwd != null && cwd == _baselineCwd) return _baseline;
    if (widget.turnBaseline != null &&
        (widget.expectedCwd == null || widget.expectedCwd == cwd)) {
      return widget.turnBaseline;
    }
    return null;
  }

  String? get _scopeBase =>
      _scope == GitReviewScope.lastTurn ? _baseline : null;

  String? _match(String? requested) {
    if (requested == null) return null;
    for (final file in _files) {
      if (file.path == requested ||
          requested.endsWith('/${file.path}') ||
          requested.endsWith('\\${file.path}')) {
        return file.path;
      }
    }
    return null;
  }

  Future<void> _showDiff(int epoch) async {
    final target = _target;
    final path = _selected;
    if (target == null || path == null) return;
    final file = _files.where((row) => row.path == path).firstOrNull;
    try {
      final diff = await target.gitReviewDiff(
        file: path,
        scope: _scope,
        base: _scopeBase,
        staged: _scope == GitReviewScope.uncommitted && (file?.staged ?? false),
      );
      if (!_owns(epoch)) return;
      setState(() => _diff = diff);
    } on WorkspaceException catch (error) {
      if (_owns(epoch)) setState(() => _message = _why(error));
    }
  }

  Future<void> _act(Future<void> Function(WorkspaceTarget target) run) async {
    final target = _target;
    if (target == null || _busy) return;
    final epoch = _epoch;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await run(target);
      if (!_owns(epoch)) return;
      await _load();
    } on WorkspaceException catch (error) {
      if (!_owns(epoch)) return;
      setState(() {
        _busy = false;
        _message = _why(error);
      });
    } catch (_) {
      if (!_owns(epoch)) return;
      setState(() {
        _busy = false;
        _message = (l10n) => l10n
            .release_core_git_review_pane_the_git_operation_did_not_complete;
      });
    }
  }

  Future<bool> _confirm(String title, String body, String action) async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.sharedL10n.cancel),
          ),
          FilledButton(
            key: const Key('git-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
      ),
    );
    return answer == true;
  }

  @override
  Widget build(BuildContext context) {
    final shipping = _scope == GitReviewScope.uncommitted && _files.isNotEmpty;
    return Material(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: context
                      .sharedL10n
                      .release_core_git_review_pane_close_git_review,
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    context
                        .sharedL10n
                        .release_core_session_files_view_git_review,
                  ),
                ),
                Text(context.sharedL10n.release_core_git_review_pane_pin_lane),
                Switch(
                  key: const Key('git-follow-pin'),
                  value: _pinned,
                  onChanged: (value) => setState(() => _pinned = value),
                ),
                IconButton(
                  key: const Key('git-refresh'),
                  tooltip: context
                      .sharedL10n
                      .release_core_git_review_pane_refresh_git_review,
                  onPressed: _busy ? null : () => _load(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            if (_busy) const LinearProgressIndicator(),
            if (_message != null)
              Text(_message!(context.sharedL10n), key: const Key('git-error')),
            if (_omitted > 0)
              Text(
                context.sharedL10n.release_core_git_entries_omitted(_omitted),
                key: const Key('git-omitted'),
              ),
            if (_target?.canonicalCwd case final cwd?)
              Text(cwd, key: const Key('git-cwd')),
            const SizedBox(height: 8),
            SegmentedButton<GitReviewScope>(
              segments: [
                ButtonSegment(
                  value: GitReviewScope.uncommitted,
                  label: Text(
                    context.sharedL10n.release_core_git_review_pane_uncommitted,
                  ),
                ),
                ButtonSegment(
                  value: GitReviewScope.branch,
                  label: Text(context.sharedL10n.branch),
                ),
                ButtonSegment(
                  value: GitReviewScope.lastTurn,
                  label: Text(
                    context.sharedL10n.release_core_git_review_pane_last_turn,
                  ),
                ),
              ],
              selected: {_scope},
              onSelectionChanged: _busy
                  ? null
                  : (next) async {
                      setState(() {
                        _scope = next.single;
                        _diff = null;
                      });
                      await _load();
                    },
            ),
            if (_scope != GitReviewScope.uncommitted)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  context
                      .sharedL10n
                      .release_core_git_review_pane_branch_and_last_turn_views_are_read_only,
                  key: Key('git-readonly'),
                ),
              ),
            if (_scope == GitReviewScope.lastTurn && _baseline == null)
              OutlinedButton(
                key: const Key('git-mark-head'),
                onPressed: _busy
                    ? null
                    : () => _act((target) async {
                        final sha = await target.gitRevParseHead();
                        final cwd = target.canonicalCwd;
                        final session = widget.route.storedSessionId;
                        if (sha == null || cwd == null || session == null) {
                          throw WorkspaceException(WorkspaceFailure.invalid);
                        }
                        gitTurnMemory.remember(
                          ownerId: widget.owner.connectionId,
                          profile: widget.owner.profile,
                          sessionId: session,
                          cwd: cwd,
                          sha: sha,
                        );
                        _baseline = sha;
                        _baselineCwd = cwd;
                      }),
                child: Text(
                  context
                      .sharedL10n
                      .release_core_git_review_pane_mark_head_as_the_turn_baseline,
                ),
              ),
            if (shipping) ...[
              Wrap(
                spacing: 8,
                children: [
                  TextButton(
                    key: const Key('git-stage-all'),
                    onPressed: _busy
                        ? null
                        : () => _act((target) => target.gitStage()),
                    child: Text(
                      context.sharedL10n.release_core_git_review_pane_stage_all,
                    ),
                  ),
                  TextButton(
                    key: const Key('git-revert-all'),
                    onPressed: _busy
                        ? null
                        : () async {
                            final yes = await _confirm(
                              context
                                  .sharedL10n
                                  .release_core_git_review_pane_discard_every_uncommitted_change,
                              context
                                  .sharedL10n
                                  .release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files,
                              context
                                  .sharedL10n
                                  .release_core_git_review_pane_discard,
                            );
                            if (yes) await _act((target) => target.gitRevert());
                          },
                    child: Text(
                      context
                          .sharedL10n
                          .release_core_git_review_pane_discard_all,
                    ),
                  ),
                ],
              ),
            ],
            for (final file in _files)
              ListTile(
                key: Key('git-file-${file.path}'),
                selected: file.path == _selected,
                title: Text(file.path),
                subtitle: Text(
                  '${file.status} +${file.added} -${file.removed}${file.staged ? ' · ${context.sharedL10n.release_core_git_staged}' : ''}',
                ),
                onTap: () async {
                  setState(() => _selected = file.path);
                  await _showDiff(_epoch);
                },
                trailing: shipping
                    ? Wrap(
                        children: [
                          IconButton(
                            key: Key(
                              file.staged
                                  ? 'git-unstage-${file.path}'
                                  : 'git-stage-${file.path}',
                            ),
                            tooltip: file.staged
                                ? context
                                      .sharedL10n
                                      .release_core_git_review_pane_unstage
                                : context
                                      .sharedL10n
                                      .release_core_git_review_pane_stage,
                            onPressed: _busy
                                ? null
                                : () => _act(
                                    (target) => file.staged
                                        ? target.gitUnstage(file: file.path)
                                        : target.gitStage(file: file.path),
                                  ),
                            icon: Icon(file.staged ? Icons.remove : Icons.add),
                          ),
                          IconButton(
                            key: Key('git-revert-${file.path}'),
                            tooltip: context
                                .sharedL10n
                                .release_core_git_review_pane_discard_file,
                            onPressed: _busy
                                ? null
                                : () async {
                                    final yes = await _confirm(
                                      context.sharedL10n
                                          .release_core_git_review_pane_discard_2(
                                            (file.path).toString(),
                                          ),
                                      context
                                          .sharedL10n
                                          .release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the,
                                      context
                                          .sharedL10n
                                          .release_core_git_review_pane_discard,
                                    );
                                    if (yes) {
                                      await _act(
                                        (target) =>
                                            target.gitRevert(file: file.path),
                                      );
                                    }
                                  },
                            icon: const Icon(Icons.undo),
                          ),
                        ],
                      )
                    : null,
              ),
            if (_diff != null)
              SelectableText(
                _diff!.length > 20000
                    ? context.sharedL10n.release_core_git_diff_truncated(
                        _diff!.substring(0, 20000),
                      )
                    : _diff!,
                key: const Key('git-diff'),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            if (shipping) ...[
              TextField(
                key: const Key('git-message'),
                controller: _commit,
                minLines: 2,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: context
                      .sharedL10n
                      .release_core_git_review_pane_commit_message,
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton(
                    key: const Key('git-generate'),
                    onPressed: _busy
                        ? null
                        : () => _act((target) async {
                            final context = await target.gitCommitContext();
                            final draft = draftGitCommitMessage(
                              context.diff,
                              avoid: _commit.text,
                            );
                            if (draft.isEmpty) {
                              _message = (l10n) => l10n
                                  .release_core_git_review_pane_nothing_in_the_diff_to_summarise;
                              return;
                            }
                            _commit.text = draft;
                          }),
                    child: Text(
                      context
                          .sharedL10n
                          .release_core_git_review_pane_generate_message,
                    ),
                  ),
                  FilledButton(
                    key: const Key('git-commit'),
                    onPressed: _busy
                        ? null
                        : () => _act(
                            (target) => target.gitCommit(message: _commit.text),
                          ),
                    child: Text(
                      context.sharedL10n.release_core_git_review_pane_commit,
                    ),
                  ),
                  FilledButton(
                    key: const Key('git-commit-push'),
                    onPressed: _busy
                        ? null
                        : () => _act(
                            (target) => target.gitCommit(
                              message: _commit.text,
                              push: true,
                            ),
                          ),
                    child: Text(
                      context
                          .sharedL10n
                          .release_core_git_review_pane_commit_and_push,
                    ),
                  ),
                  OutlinedButton(
                    key: const Key('git-push'),
                    onPressed: _busy
                        ? null
                        : () => _act((target) => target.gitPush()),
                    child: Text(
                      context.sharedL10n.release_core_git_review_pane_push,
                    ),
                  ),
                  OutlinedButton(
                    key: const Key('git-pr'),
                    onPressed: _busy
                        ? null
                        : _prUrl != null
                        ? () => unawaited(_openPullRequest(_prUrl!))
                        : _ghReady
                        ? () => _act((target) async {
                            final url = await target.gitCreatePullRequest();
                            _prUrl = url;
                          })
                        : null,
                    child: Text(
                      _prUrl == null
                          ? context
                                .sharedL10n
                                .release_core_git_review_pane_create_pull_request
                          : context
                                .sharedL10n
                                .release_core_git_review_pane_pull_request_ready,
                    ),
                  ),
                  if (widget.onHandOff != null)
                    TextButton(
                      key: const Key('git-hand-off'),
                      onPressed: () {
                        widget.onHandOff!(
                          'Ship this session workspace: review the uncommitted diff, commit, push to its private remote, and open a pull request if gh is available. Stay in this repository.',
                        );
                      },
                      child: Text(
                        context
                            .sharedL10n
                            .release_core_git_review_pane_ask_hermes_to_ship,
                      ),
                    ),
                ],
              ),
              Text(
                _ghReady
                    ? context
                          .sharedL10n
                          .release_core_git_review_pane_gh_is_authenticated_on_this_gateway
                    : context
                          .sharedL10n
                          .release_core_git_review_pane_install_the_github_cli_gh_and_sign_in,
                key: const Key('git-gh'),
              ),
              if (_prUrl case final url?)
                Row(
                  children: [
                    Expanded(
                      child: SelectableText(url, key: const Key('git-pr-url')),
                    ),
                    TextButton(
                      onPressed: () => unawaited(_openPullRequest(url)),
                      child: Text(context.sharedL10n.notification_open_action),
                    ),
                  ],
                ),
            ],
            const Divider(),
            Text(
              context.sharedL10n.release_core_git_review_pane_worktrees,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            for (final tree in _trees)
              ListTile(
                title: Text(tree.branch ?? tree.path),
                subtitle: Text(tree.path),
                trailing: tree.isMain
                    ? Text(context.sharedL10n.release_core_git_review_pane_main)
                    : Wrap(
                        children: [
                          TextButton(
                            key: Key('git-follow-${tree.branch}'),
                            onPressed: _busy || _pinned
                                ? null
                                : () async {
                                    final yes = await _confirm(
                                      context.sharedL10n
                                          .release_core_git_review_pane_follow(
                                            (tree.branch).toString(),
                                          ),
                                      context
                                          .sharedL10n
                                          .release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless,
                                      context
                                          .sharedL10n
                                          .release_core_git_review_pane_follow_2,
                                    );
                                    if (!yes || _pinned) return;
                                    await _act((target) async {
                                      final fences = await target.cwdFences();
                                      await target.changeCwd(tree.path, fences);
                                      await _pane.adoptMovedWorkspace(
                                        widget.route,
                                      );
                                      widget.onFollowed?.call(tree.path);
                                      await _load(expected: tree.path);
                                    });
                                  },
                            child: Text(
                              context
                                  .sharedL10n
                                  .release_core_git_review_pane_follow_2,
                            ),
                          ),
                          TextButton(
                            key: Key('git-remove-${tree.branch}'),
                            onPressed: _busy
                                ? null
                                : () async {
                                    final yes = await _confirm(
                                      context.sharedL10n
                                          .release_core_git_review_pane_remove(
                                            (tree.branch).toString(),
                                          ),
                                      context
                                          .sharedL10n
                                          .release_core_git_review_pane_the_worktree_directory_is_removed,
                                      context
                                          .sharedL10n
                                          .release_core_git_review_pane_remove_2,
                                    );
                                    if (!yes) return;
                                    await _act(
                                      (target) => target.gitWorktreeRemove(
                                        worktreePath: tree.path,
                                      ),
                                    );
                                  },
                            child: Text(
                              context
                                  .sharedL10n
                                  .release_core_git_review_pane_remove_2,
                            ),
                          ),
                        ],
                      ),
              ),
            TextField(
              key: const Key('git-worktree-name'),
              controller: _workName,
              decoration: InputDecoration(
                labelText: context
                    .sharedL10n
                    .release_core_git_review_pane_new_worktree_name,
              ),
            ),
            TextField(
              key: const Key('git-worktree-branch'),
              controller: _workBranch,
              decoration: InputDecoration(
                labelText:
                    context.sharedL10n.release_core_git_review_pane_new_branch,
              ),
            ),
            if (_bases.isNotEmpty)
              DropdownButton<String>(
                key: const Key('git-worktree-base'),
                value: _bases.any((row) => row.name == _base) ? _base : null,
                hint: Text(
                  context.sharedL10n.release_core_git_review_pane_base_branch,
                ),
                items: [
                  for (final row in _bases)
                    DropdownMenuItem(value: row.name, child: Text(row.name)),
                ],
                onChanged: (value) => setState(() => _base = value),
              ),
            FilledButton(
              key: const Key('git-worktree-create'),
              onPressed: _busy
                  ? null
                  : () => _act((target) async {
                      await target.gitWorktreeAdd(
                        name: _workName.text.trim().isEmpty
                            ? null
                            : _workName.text.trim(),
                        branch: _workBranch.text.trim().isEmpty
                            ? null
                            : _workBranch.text.trim(),
                        base: _base,
                      );
                    }),
              child: Text(
                context.sharedL10n.release_core_git_review_pane_create_worktree,
              ),
            ),
            if (_branches.isNotEmpty) ...[
              DropdownButton<String>(
                key: const Key('git-convert-branch'),
                value: _branches.any((row) => row.name == _convert)
                    ? _convert
                    : null,
                hint: Text(
                  context
                      .sharedL10n
                      .release_core_git_review_pane_existing_branch,
                ),
                items: [
                  for (final row in _branches.where((row) => !row.isRemote))
                    DropdownMenuItem(value: row.name, child: Text(row.name)),
                ],
                onChanged: (value) => setState(() => _convert = value),
              ),
              OutlinedButton(
                key: const Key('git-worktree-convert'),
                onPressed: _busy || _convert == null
                    ? null
                    : () => _act(
                        (target) =>
                            target.gitWorktreeAdd(existingBranch: _convert),
                      ),
                child: Text(
                  context
                      .sharedL10n
                      .release_core_git_review_pane_convert_branch_to_worktree,
                ),
              ),
              DropdownButton<String>(
                key: const Key('git-switch-branch'),
                value: _branches.any((row) => row.name == _switchTo)
                    ? _switchTo
                    : null,
                hint: Text(
                  context.sharedL10n.release_core_git_review_pane_switch_branch,
                ),
                items: [
                  for (final row in _branches.where((row) => !row.isRemote))
                    DropdownMenuItem(value: row.name, child: Text(row.name)),
                ],
                onChanged: (value) => setState(() => _switchTo = value),
              ),
              OutlinedButton(
                key: const Key('git-switch'),
                onPressed: _busy || _switchTo == null
                    ? null
                    : () =>
                          _act((target) => target.gitSwitchBranch(_switchTo!)),
                child: Text(
                  context.sharedL10n.release_core_git_review_pane_switch_branch,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openPullRequest(String url) {
    final hook = debugOpenGitPullRequest;
    if (hook != null) return hook(url);
    return openMarkdownWebLink(context, url);
  }
}

String Function(AppLocalizations) _why(WorkspaceException error) =>
    (l10n) => switch (error.reason) {
      WorkspaceFailure.unsupported =>
        l10n.release_core_git_review_pane_this_gateway_does_not_support_that_git_operation,
      WorkspaceFailure.unbound =>
        l10n.release_core_git_review_pane_git_needs_the_session_directory_on_the_local,
      WorkspaceFailure.denied || WorkspaceFailure.ineligible =>
        l10n.release_core_git_review_pane_the_gateway_refused_the_git_operation,
      WorkspaceFailure.mismatch =>
        l10n.release_core_git_review_pane_the_session_changed_refresh_and_try_again,
      WorkspaceFailure.stale =>
        l10n.release_core_git_review_pane_this_review_is_no_longer_the_selected_session,
      WorkspaceFailure.invalid =>
        l10n.release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result,
      WorkspaceFailure.insecure =>
        l10n.release_core_git_review_pane_git_review_requires_the_gateway_transport,
      WorkspaceFailure.unavailable =>
        l10n.release_core_git_review_pane_the_git_operation_did_not_complete,
    };
