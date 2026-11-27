part of 'remote_workspace.dart';

const guardedSaveUnavailable = "Guarded saving isn't available on this gateway";
const guardedSaveRefused = "This file can't be saved by the gateway";
const _guardedSaveOnlyHere =
    'Only a file directly in the working directory can be saved.';

/// Entries are issued by a directory read. A spelling, even an absolute one,
/// is not a capability to use this target or another session's file.
final class WorkspaceEntry {
  const WorkspaceEntry._(
    this.owner,
    this.name,
    this.path,
    this.relative,
    this.directory,
    this.ignored,
  );
  final WorkspaceTarget owner;
  final String name, path, relative;
  final bool directory;
  final bool? ignored;
}

final class WorkspaceDocument {
  const WorkspaceDocument._(
    this.entry,
    this.text,
    this.binary,
    this.truncated,
    this.bytes,
  );
  final WorkspaceEntry entry;
  final String text;
  final bool binary, truncated;
  final int bytes;
  bool get editable =>
      !binary &&
      !truncated &&
      !text.contains('\uFFFD') &&
      !text.contains('\u0000') &&
      utf8.encode(text).length == bytes &&
      bytes <= 512 * 1024;
}

String _remotePrefix(String dir) => dir.endsWith('/') || dir.endsWith(r'\')
    ? dir
    : '$dir${dir.startsWith('/') || !dir.contains(r'\') ? '/' : r'\'}';

bool isWorkspaceChild(String parent, String name, String path) =>
    isSafeWorkspacePath(parent) &&
    name.isNotEmpty &&
    !name.contains(RegExp(r'[/\\]')) &&
    isSafeWorkspacePath(path) &&
    path == '${_remotePrefix(parent)}$name';

extension SessionWorkspaceFiles on WorkspaceTarget {
  String get fileRoot {
    final cwd = canonicalCwd;
    if (cwd == null ||
        !isSafeWorkspacePath(cwd) ||
        route.storedSessionId == null) {
      _fail(WorkspaceFailure.unbound);
    }
    return cwd;
  }

  void _ownsEntry(WorkspaceEntry node, {required bool directory}) {
    if (!identical(node.owner, this) ||
        node.directory != directory ||
        !node.path.startsWith(_remotePrefix(fileRoot))) {
      _fail(WorkspaceFailure.mismatch);
    }
  }

  Future<void> _hostFiles() async {
    // /fs/list does not accept a sandbox session ID. Refuse non-host executors,
    // never list the gateway's /workspace as if it were a container mount.
    final backend = await read(WorkspaceRead.terminalBackends) as Map;
    if (backend['active'] != 'local' ||
        (_binding?.backend != null && _binding!.backend != 'local')) {
      _fail(WorkspaceFailure.unbound);
    }
    await verifySession();
  }

  Future<List<WorkspaceEntry>> listSessionFiles([WorkspaceEntry? folder]) =>
      _withOwner(() async {
        final root = fileRoot;
        if (folder != null) _ownsEntry(folder, directory: true);
        final parent = folder?.path ?? root;
        await _hostFiles();
        final raw = await _get(
          ['fs', 'list'],
          {'path': parent, 'git_flags': 'true'},
        );
        if (raw is! Map || raw['entries'] is! List) {
          _fail(WorkspaceFailure.invalid);
        }
        if (raw['error'] != null) _fail(WorkspaceFailure.unavailable);
        final entries = <WorkspaceEntry>[];
        final seen = <String>{};
        for (final row in raw['entries'] as List) {
          if (row is! Map || row['isDirectory'] is! bool) {
            _fail(WorkspaceFailure.invalid);
          }
          final name = row['name'];
          final path = row['path'];
          if (name is! String ||
              path is! String ||
              !isWorkspaceChild(parent, name, path) ||
              !seen.add(path)) {
            _fail(WorkspaceFailure.invalid);
          }
          entries.add(
            WorkspaceEntry._(
              this,
              name,
              path,
              path.substring(_remotePrefix(root).length),
              row['isDirectory'] as bool,
              row['gitIgnored'] as bool?,
            ),
          );
        }
        return List.unmodifiable(entries);
      }, session: true);

  Future<WorkspaceDocument> readDocument(WorkspaceEntry entry) =>
      _withOwner(() async {
        _ownsEntry(entry, directory: false);
        await _hostFiles();
        final raw = await _get(
          ['fs', 'read-text'],
          {'path': entry.path, 'session_id': route.storedSessionId!},
        );
        if (raw is! Map || raw['path'] != entry.path) {
          _fail(WorkspaceFailure.mismatch);
        }
        final bytes = raw['byteSize'];
        if (bytes is! int ||
            bytes < 0 ||
            raw['text'] is! String ||
            raw['truncated'] is! bool ||
            raw['binary'] is! bool) {
          _fail(WorkspaceFailure.invalid);
        }
        return WorkspaceDocument._(
          entry,
          raw['text'] as String,
          raw['binary'] as bool,
          raw['truncated'] as bool,
          bytes,
        );
      }, session: true);

  /// Review against the original snapshot, then require the host's own
  /// precondition. A read before an unconditional POST is not conflict-safe.
  Future<WorkspaceDocument> replaceDocument(
    WorkspaceDocument base,
    String draft,
  ) => _withOwner(() async {
    _ownsEntry(base.entry, directory: false);
    final bytes = utf8.encode(draft);
    if (!base.editable ||
        bytes.length > 512 * 1024 ||
        draft.contains('\u0000') ||
        utf8.decode(bytes) != draft) {
      _fail(WorkspaceFailure.invalid);
    }
    final latest = await readDocument(base.entry);
    if (!latest.editable || latest.text != base.text) {
      _fail(WorkspaceFailure.mismatch);
    }
    checkCurrent();
    final Object? receipt;
    try {
      receipt = await _owner._dashboard.workspaceReplaceText(
        profile: effectiveProfile!,
        sessionId: route.storedSessionId!,
        cwd: fileRoot,
        path: base.entry.path,
        expectedHash: sha256.convert(utf8.encode(base.text)).toString(),
        content: draft,
        check: checkCurrent,
      );
    } on DashboardHttpException catch (e) {
      if (e.statusCode == 409) _fail(WorkspaceFailure.mismatch);
      if (e.statusCode == 403) _fail(WorkspaceFailure.ineligible);
      rethrow;
    }
    if (receipt is! Map ||
        receipt['ok'] != true ||
        receipt['path'] != base.entry.path ||
        receipt['sha256'] != sha256.convert(bytes).toString()) {
      _fail(WorkspaceFailure.mismatch);
    }
    final confirmed = await readDocument(base.entry);
    if (confirmed.binary ||
        confirmed.truncated ||
        confirmed.text != draft ||
        confirmed.bytes != bytes.length) {
      _fail(WorkspaceFailure.mismatch);
    }
    return confirmed;
  }, session: true);

  Future<Set<String>> changedPaths() => _withOwner(() async {
    final cwd = fileRoot;
    await _hostFiles();
    final repo = await _get(['fs', 'git-root'], {'path': cwd});
    if (repo is! Map) _fail(WorkspaceFailure.invalid);
    final root = repo['root'];
    if (root == null) return <String>{};
    if (root is! String ||
        !isSafeWorkspacePath(root) ||
        (cwd != root && !cwd.startsWith(_remotePrefix(root)))) {
      _fail(WorkspaceFailure.mismatch);
    }
    final result = await read(WorkspaceRead.gitStatus) as Map?;
    final changed = <String>{};
    for (final row in result?['files'] as List? ?? const []) {
      final rel = row is Map ? row['path'] : null;
      if (rel is! String ||
          rel.isEmpty ||
          rel.startsWith('/') ||
          rel.contains(r'\')) {
        _fail(WorkspaceFailure.invalid);
      }
      final path =
          '${_remotePrefix(root)}${root.contains(r'\') ? rel.replaceAll('/', r'\') : rel}';
      if (!isSafeWorkspacePath(path)) _fail(WorkspaceFailure.invalid);
      if (path.startsWith(_remotePrefix(cwd))) changed.add(path);
    }
    return changed;
  }, session: true);

  Future<({int revision, int generation})> cwdFences() => _withOwner(() async {
    if (!sessionAuthority) _fail(WorkspaceFailure.unsupported);
    final id = route.storedSessionId!;
    final r = await _get(['sessions', id, 'mutation-snapshot']);
    if (r is! Map ||
        r['session_id'] != id ||
        r['exists'] != true ||
        r['runtime_revision'] is! int ||
        r['runtime_generation'] is! int) {
      _fail(WorkspaceFailure.unbound);
    }
    return (
      revision: r['runtime_revision'] as int,
      generation: r['runtime_generation'] as int,
    );
  }, session: true);

  /// Caller holds the original snapshot through confirmation. Never move an
  /// arbitrary legacy live ID or reuse another pane's latest revision.
  Future<void> changeCwd(
    String path,
    ({int revision, int generation}) fences,
  ) async {
    final normalized = normalizeWorkspaceCwd(path);
    var adopt = false;
    await _withOwner(() async {
      if (!isSafeWorkspacePath(normalized)) _fail(WorkspaceFailure.invalid);
      // The confirmed fences can go stale while the dialog is open. Re-read
      // them in this same owner turn, immediately before the closed field set
      // is dispatched. session.mutate forbids a profile parameter; the socket
      // already carries the bound profile.
      final current = await cwdFences();
      if (current != fences) _fail(WorkspaceFailure.mismatch);
      final id = route.storedSessionId!;
      final receipt = await _rpc('session.mutate', {
        'session_id': id,
        'request_id': const Uuid().v4(),
        'operation': 'workspace',
        'expected_revision': current.revision,
        'expected_generation': current.generation,
        'payload': {'cwd': normalized},
      }, bindProfile: false);
      if (receipt['session_id'] != id ||
          receipt['operation'] != 'workspace' ||
          receipt['revision'] is! int ||
          (receipt['revision'] as int) <= fences.revision) {
        _fail(WorkspaceFailure.mismatch);
      }
      final row = await _readRow();
      if (row.cwd != normalized || row.profile != effectiveProfile) {
        _fail(WorkspaceFailure.mismatch);
      }
      final snap = await _get(['sessions', id, 'mutation-snapshot']);
      adopt =
          snap is Map &&
          snap['session_id'] == id &&
          snap['exists'] == true &&
          snap['runtime_generation'] == current.generation &&
          snap['runtime_revision'] == receipt['revision'];
    });
    // The guard above still compares the pre-move binding. Adopt only after
    // it returns, and only for this session when its generation did not move.
    if (adopt && _binding != null) {
      _socket.adoptConfirmedWorkspaceCwd(route.storedSessionId!, normalized);
    }
  }

  /// Unknown and absent are the same to the person reading the file: do not
  /// offer a draft that the gateway cannot keep.
  Future<bool> guardedSavePresent() async {
    final cached = _guardedSavePresent;
    if (cached != null) return cached;
    try {
      final present = await _withOwner(() async {
        final status = await _owner._dashboard.workspaceReplaceTextProbe(
          profile: effectiveProfile!,
          check: checkCurrent,
        );
        return status == 400 || status == 413 || status == 415;
      }, session: true);
      _guardedSavePresent = present;
      return present;
    } on WorkspaceException catch (error) {
      if (error.reason == WorkspaceFailure.stale ||
          error.reason == WorkspaceFailure.mismatch) {
        rethrow;
      }
      _guardedSavePresent = false;
      return false;
    }
  }

  /// Mirrors the confirmed-edit patch: an immediate child of the session
  /// directory, not hidden, and not a refused database suffix.
  String? saveRefusal(WorkspaceEntry entry) {
    _ownsEntry(entry, directory: false);
    final root = fileRoot;
    final name = entry.name;
    final immediate =
        name == entry.relative && isWorkspaceChild(root, name, entry.path);
    if (!immediate) return _guardedSaveOnlyHere;
    if (name.startsWith('.')) {
      return "Hidden files can't be saved by the gateway.";
    }
    if (root == '/' ||
        (root.length == 3 &&
            root[1] == ':' &&
            (root[2] == '/' || root.codeUnitAt(2) == 92))) {
      return guardedSaveRefused;
    }
    final folded = name.toLowerCase();
    const refused = ['.db', '.sqlite', '.sqlite3', '-journal', '-wal', '-shm'];
    if (refused.any(folded.endsWith)) return guardedSaveRefused;
    return null;
  }
}
