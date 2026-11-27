part of 'remote_workspace.dart';

/// One saved transcript row the user can branch or rewind from.
class HistoryMessage {
  const HistoryMessage({
    required this.rowId,
    required this.role,
    required this.text,
  });

  final int rowId;
  final String role;
  final String text;
}

class HistoryBranchReceipt {
  const HistoryBranchReceipt({required this.sessionId, required this.title});

  final String sessionId;
  final String title;
}

class HistoryRewindReceipt {
  const HistoryRewindReceipt({required this.removed, required this.text});

  final int removed;
  final String text;
}

class HistoryCheckpoint {
  const HistoryCheckpoint({
    required this.hash,
    required this.label,
    required this.when,
  });

  final String hash;
  final String label;
  final String when;
}

class HistoryCheckpointDiff {
  const HistoryCheckpointDiff({required this.text});

  final String text;
}

class HistoryRestoreReceipt {
  const HistoryRestoreReceipt({
    required this.success,
    this.historyRemoved,
    this.files = const [],
  });

  final bool success;
  final int? historyRemoved;
  final List<String> files;
}

class HistoryExport {
  const HistoryExport({
    required this.format,
    required this.filename,
    required this.content,
  });

  final String format;
  final String filename;
  final String content;
}

class ForeignSessionSummary {
  const ForeignSessionSummary({
    required this.id,
    required this.source,
    required this.label,
    required this.title,
    required this.turns,
    this.cwd,
    this.excerpt = '',
    this.mtime = 0,
  });

  final String id;
  final String source;
  final String label;
  final String title;
  final int turns;
  final String? cwd;
  final String excerpt;
  final double mtime;
}

class ForeignSessionPage {
  const ForeignSessionPage({
    required this.sessions,
    required this.host,
    required this.unreadable,
    this.nextOffset,
  });

  final List<ForeignSessionSummary> sessions;
  final String host;
  final int unreadable;
  final int? nextOffset;
}

class ForeignPreviewView {
  const ForeignPreviewView({
    required this.messages,
    required this.total,
    required this.truncated,
    this.alreadyImported,
    this.cwd,
  });

  final List<ForeignTurn> messages;
  final int total;
  final bool truncated;
  final String? alreadyImported;
  final String? cwd;
}

class ForeignImportReceipt {
  const ForeignImportReceipt({
    required this.sessionId,
    required this.alreadyImported,
  });

  final String sessionId;
  final bool alreadyImported;
}

class ShownSessionLineage {
  const ShownSessionLineage({
    this.parent,
    this.siblings = const [],
    this.children = const [],
  });

  final ForkMark? parent;
  final List<ForkMark> siblings;
  final List<ForkMark> children;
}

final _checkpointHash = RegExp(r'^[0-9a-fA-F]{7,64}$');
final _foreignHandle = RegExp(r'^[0-9a-f]{64}$');
const _exportFormats = {'json', 'md', 'html'};

/// Branch, rewind, checkpoints, export and foreign import for one bound chat.
extension SessionHistory on WorkspaceTarget {
  Future<({int revision, int generation})> historyFences() =>
      _withOwner(_readFences, session: true);

  Future<List<HistoryMessage>> transcript() =>
      _withOwner(_readTranscript, session: true);

  /// Whether this gateway can branch or rewind a saved chat here: both are
  /// `session.mutate` operations of the 0.23+ session authority. A pre-0.23
  /// sidecar has no such method.
  bool get canMutateHistory => sessionAuthority;

  /// Whether this gateway renders transcript exports (`session.export`, a
  /// 0.23+ session authority method).
  bool get canExportTranscript => sessionAuthority;

  /// The id the session-keyed history RPCs take. The session authority
  /// addresses a chat by its stored id; a pre-0.23 sidecar only knows the
  /// runtime session it has live on this socket.
  String _historySessionKey() {
    if (sessionAuthority) return route.storedSessionId!;
    final runtime = runtimeSessionId;
    if (runtime == null) _fail(WorkspaceFailure.unbound);
    return runtime;
  }

  /// Parent, sibling and fork chats, read from the REST session rows as
  /// Hermes Desktop does (`GET /api/sessions`, session-branch-tree.ts): they
  /// carry `_branched_from`, `parent_session_id`, `_reset_from` and
  /// `_lineage_root_id`. The WebSocket `session.list` cannot answer this on
  /// a session authority: its scope is the live sessions, and its rows
  /// (`CanonicalSessionListRow`) have no lineage fields.
  Future<ShownSessionLineage> lineage() => _withOwner(() async {
    final body = await _get(
      ['sessions'],
      const {
        'limit': '200',
        'offset': '0',
        'min_messages': '0',
        'archived': 'include',
        'order': 'recent',
      },
    );
    final rows = body is Map ? body['sessions'] : body;
    if (rows is! List) _fail(WorkspaceFailure.invalid);
    final marks = <ForkMark>[];
    for (final row in rows) {
      final mark = _forkMark(row);
      if (mark != null) marks.add(mark);
    }
    final shown = lineageAround(route.storedSessionId!, marks);
    return ShownSessionLineage(
      parent: shown.parent,
      siblings: shown.siblings,
      children: shown.children,
    );
  }, session: true);

  /// Copies history through [throughMessageId] into a new stored session.
  ///
  /// [confirmed] is the dialog result. An unconfirmed call does not touch
  /// the gateway. The id must be a row this session's history just returned.
  Future<HistoryBranchReceipt> branchAtMessage({
    required int throughMessageId,
    required bool confirmed,
    required ({int revision, int generation}) fences,
  }) async {
    if (!confirmed) _fail(WorkspaceFailure.invalid);
    if (!canMutateHistory) _fail(WorkspaceFailure.unsupported);
    return _withOwner(() async {
      await _requireMessage(throughMessageId);
      final current = await _readFences();
      if (current != fences) _fail(WorkspaceFailure.mismatch);
      final id = route.storedSessionId!;
      final receipt = await _rpc('session.mutate', {
        'session_id': id,
        'request_id': const Uuid().v4(),
        'operation': 'branch',
        'expected_revision': current.revision,
        'expected_generation': current.generation,
        'payload': {'through_message_id': throughMessageId},
      }, bindProfile: false);
      final child = receipt['branched_session_id'];
      final revision = receipt['revision'];
      if (receipt['operation'] != 'branch' ||
          child is! String ||
          child.isEmpty ||
          child == id ||
          revision is! int ||
          revision <= fences.revision) {
        _fail(WorkspaceFailure.invalid);
      }
      final title = receipt['title'];
      return HistoryBranchReceipt(
        sessionId: child,
        title: title is String ? redactSecrets(title) : '',
      );
    }, session: true);
  }

  /// Drops the selected saved row and everything after it.
  ///
  /// The returned text is the redacted row, for the composer. Files are not
  /// changed; checkpoint restore is a separate confirmation.
  Future<HistoryRewindReceipt> rewindAtMessage({
    required int targetMessageId,
    required bool confirmed,
    required ({int revision, int generation}) fences,
  }) async {
    if (!confirmed) _fail(WorkspaceFailure.invalid);
    if (!canMutateHistory) _fail(WorkspaceFailure.unsupported);
    return _withOwner(() async {
      final message = await _requireMessage(targetMessageId);
      final current = await _readFences();
      if (current != fences) _fail(WorkspaceFailure.mismatch);
      final receipt = await _rpc('session.mutate', {
        'session_id': route.storedSessionId,
        'request_id': const Uuid().v4(),
        'operation': 'rewind',
        'expected_revision': current.revision,
        'expected_generation': current.generation,
        'payload': {'target_message_id': targetMessageId},
      }, bindProfile: false);
      final removed = receipt['removed'] ?? receipt['rewound_count'];
      final revision = receipt['revision'];
      if (receipt['operation'] != 'rewind' ||
          removed is! int ||
          removed < 1 ||
          revision is! int ||
          revision <= fences.revision) {
        _fail(WorkspaceFailure.invalid);
      }
      return HistoryRewindReceipt(removed: removed, text: message.text);
    }, session: true);
  }

  Future<List<HistoryCheckpoint>> checkpoints() => _withOwner(() async {
    final result = await _rpc('rollback.list', {
      'session_id': _historySessionKey(),
    });
    if (result['enabled'] != true) return const <HistoryCheckpoint>[];
    final rows = result['checkpoints'];
    if (rows is! List) _fail(WorkspaceFailure.invalid);
    final checkpoints = <HistoryCheckpoint>[];
    for (final row in rows) {
      if (row is! Map) continue;
      final hash = row['hash'];
      if (hash is! String || !_checkpointHash.hasMatch(hash)) continue;
      final label = row['message'];
      final when = row['timestamp'];
      checkpoints.add(
        HistoryCheckpoint(
          hash: hash,
          label: label is String ? redactSecrets(label) : '',
          when: when is String ? when : '',
        ),
      );
    }
    return checkpoints;
  }, session: true);

  Future<HistoryCheckpointDiff> checkpointDiff(String hash) =>
      _withOwner(() async {
        _requireHash(hash);
        final result = await _rpc('rollback.diff', {
          'session_id': _historySessionKey(),
          'hash': hash,
        });
        final body = result['diff'] ?? result['stat'] ?? '';
        if (body is! String) _fail(WorkspaceFailure.invalid);
        return HistoryCheckpointDiff(text: redactSecrets(body));
      }, session: true);

  /// Restores the working tree to [hash]. Does not send the request until
  /// [confirmed] is true. The default restore reverts the files the agent
  /// changed since the checkpoint and can also rewind the live transcript.
  /// `all` (also revert the user's own edits, Desktop's `/rollback --all`)
  /// goes out only when [revertOwnEdits] is the user's explicit choice. A
  /// file restore passes [filePath] and never sets `all`.
  Future<HistoryRestoreReceipt> restoreCheckpoint({
    required String hash,
    required bool confirmed,
    bool revertOwnEdits = false,
    String? filePath,
  }) async {
    if (!confirmed) _fail(WorkspaceFailure.invalid);
    return _withOwner(() async {
      _requireHash(hash);
      if (filePath != null) _requireRestoreFile(filePath);
      final result = await _rpc('rollback.restore', {
        'session_id': _historySessionKey(),
        'hash': hash,
        if (filePath == null && revertOwnEdits) 'all': true,
        'file_path': ?filePath,
      });
      if (result['success'] != true) _fail(WorkspaceFailure.unavailable);
      final removed = result['history_removed'];
      final files = result['restored_files'];
      return HistoryRestoreReceipt(
        success: true,
        historyRemoved: removed is int ? removed : null,
        files: files is List
            ? [
                for (final file in files)
                  if (file is String) redactSecrets(file),
              ]
            : const [],
      );
    }, session: true);
  }

  /// Owner-rendered JSON, Markdown or HTML. When [redact] is set, secrets
  /// are removed again on this device before the text is returned.
  Future<HistoryExport> exportTranscript({
    required String format,
    required bool redact,
  }) => _withOwner(() async {
    final normalized = format == 'markdown' ? 'md' : format;
    if (!_exportFormats.contains(normalized)) _fail(WorkspaceFailure.invalid);
    if (!canExportTranscript) _fail(WorkspaceFailure.unsupported);
    final result = await _rpc('session.export', {
      'session_id': route.storedSessionId,
      'format': normalized,
      'redact': redact,
    });
    final content = result['content'];
    final filename = result['filename'];
    if (result['format'] != normalized ||
        content is! String ||
        filename is! String ||
        content.length > 2 * 1024 * 1024) {
      _fail(WorkspaceFailure.invalid);
    }
    final safeName = _exportName(filename, normalized);
    final body = redact ? await redactTranscript(content) : content;
    return HistoryExport(format: normalized, filename: safeName, content: body);
  }, session: true);

  Future<ForeignSessionPage> foreignSessions({
    String? source,
    int offset = 0,
  }) => _withOwner(() async {
    if (source != null && source != 'claude' && source != 'codex') {
      _fail(WorkspaceFailure.invalid);
    }
    if (offset < 0) _fail(WorkspaceFailure.invalid);
    final result = await _rpc('session.foreign.list', {
      'source': ?source,
      'offset': offset,
      'limit': 25,
    });
    final rows = result['sessions'];
    final host = result['host'];
    if (rows is! List || host is! String) _fail(WorkspaceFailure.invalid);
    final sessions = <ForeignSessionSummary>[];
    for (final row in rows) {
      final summary = _foreignSummary(row);
      if (summary != null) sessions.add(summary);
    }
    final next = result['next_offset'];
    final unreadable = result['unreadable'];
    return ForeignSessionPage(
      sessions: sessions,
      host: redactSecrets(host),
      unreadable: unreadable is int ? unreadable : 0,
      nextOffset: next is int ? next : null,
    );
  }, session: route.storedSessionId != null);

  Future<ForeignPreviewView> previewForeign(String id) => _withOwner(() async {
    _requireHandle(id);
    final result = await _rpc('session.foreign.preview', {'id': id});
    final rows = result['messages'];
    final total = result['total'];
    if (rows is! List || total is! int) _fail(WorkspaceFailure.invalid);
    final messages = <ForeignTurn>[];
    for (final row in rows) {
      if (row is! Map) continue;
      final role = row['role'];
      final content = row['content'];
      if ((role != 'user' && role != 'assistant') || content is! String) {
        continue;
      }
      messages.add(ForeignTurn(role: role, text: redactSecrets(content)));
    }
    final existing = result['already_imported'];
    final cwd = result['cwd'];
    final safeCwd = cwd is String && cwd.trim().isNotEmpty
        ? redactSecrets(cwd.trim())
        : null;
    return ForeignPreviewView(
      messages: messages,
      total: total,
      truncated: result['truncated'] == true,
      alreadyImported: existing is String && _sessionId(existing)
          ? existing
          : null,
      cwd: safeCwd,
    );
  }, session: route.storedSessionId != null);

  Future<ForeignImportReceipt> importForeign(String id) => _withOwner(() async {
    _requireHandle(id);
    final result = await _rpc('session.foreign.import', {'id': id});
    return _importReceipt(result);
  }, session: route.storedSessionId != null);

  Future<({int revision, int generation})> _readFences() async {
    final id = route.storedSessionId!;
    final row = await _get(['sessions', id, 'mutation-snapshot']);
    if (row is! Map ||
        row['session_id'] != id ||
        row['exists'] != true ||
        row['runtime_revision'] is! int ||
        row['runtime_generation'] is! int) {
      _fail(WorkspaceFailure.unbound);
    }
    return (
      revision: row['runtime_revision'] as int,
      generation: row['runtime_generation'] as int,
    );
  }

  Future<List<HistoryMessage>> _readTranscript() async {
    final result = await _rpc('session.history', {
      'session_id': _historySessionKey(),
    });
    final rows = result['messages'];
    if (rows is! List) _fail(WorkspaceFailure.invalid);
    final messages = <HistoryMessage>[];
    for (final row in rows) {
      if (row is! Map) continue;
      final id = row['row_id'] ?? row['id'];
      final role = row['role'];
      if (id is! int || id <= 0) continue;
      if (role != 'user' && role != 'assistant') continue;
      final text = redactSecrets(_historyText(row['text'] ?? row['content']));
      if (text.isEmpty) continue;
      messages.add(HistoryMessage(rowId: id, role: role, text: text));
    }
    return messages;
  }

  Future<HistoryMessage> _requireMessage(int rowId) async {
    if (rowId <= 0) _fail(WorkspaceFailure.invalid);
    for (final message in await _readTranscript()) {
      if (message.rowId == rowId) return message;
    }
    _fail(WorkspaceFailure.invalid);
  }

  void _requireHash(String hash) {
    if (!_checkpointHash.hasMatch(hash)) _fail(WorkspaceFailure.invalid);
  }

  void _requireHandle(String id) {
    if (!_foreignHandle.hasMatch(id)) _fail(WorkspaceFailure.invalid);
  }

  void _requireRestoreFile(String path) {
    if (path.isEmpty ||
        path.trim() != path ||
        path.contains('..') ||
        path.contains('\x00') ||
        path.contains('%') ||
        !_canonicalPath(path)) {
      _fail(WorkspaceFailure.invalid);
    }
  }

  ForeignImportReceipt _importReceipt(Map<String, dynamic> result) {
    final id = result['session_id'];
    if (id is! String || !_sessionId(id)) _fail(WorkspaceFailure.invalid);
    return ForeignImportReceipt(
      sessionId: id,
      alreadyImported: result['already_imported'] == true,
    );
  }
}

ForkMark? _forkMark(Object? row) {
  if (row is! Map) return null;
  final id = row['id'];
  if (id is! String || id.isEmpty) return null;
  String? text(Object? value) =>
      value is String && value.trim().isNotEmpty ? value.trim() : null;
  double number(Object? value) => value is num ? value.toDouble() : 0;
  final title = text(row['title']) ?? '';
  return ForkMark(
    id: id,
    title: redactSecrets(title),
    parentSessionId: text(row['parent_session_id']),
    branchedFrom: text(row['_branched_from']),
    resetFrom: text(row['_reset_from']),
    lineageRootId: text(row['_lineage_root_id']),
    profile: text(row['profile']),
    lastActive: number(row['last_active']),
    startedAt: number(row['started_at']),
  );
}

ForeignSessionSummary? _foreignSummary(Object? row) {
  if (row is! Map) return null;
  final id = row['id'];
  final source = row['source'];
  final label = row['label'];
  final title = row['title'];
  if (id is! String ||
      !_foreignHandle.hasMatch(id) ||
      (source != 'claude' && source != 'codex') ||
      label is! String ||
      title is! String) {
    return null;
  }
  final turns = row['turn_count'];
  final safeTitle = redactSecrets(title);
  final rawCwd = row['cwd'];
  final safeCwd = rawCwd is String && rawCwd.trim().isNotEmpty
      ? redactSecrets(rawCwd.trim())
      : null;
  final rawExcerpt = row['excerpt'];
  final safeExcerpt = rawExcerpt is String ? redactSecrets(rawExcerpt) : '';
  final mtime = row['mtime'];
  return ForeignSessionSummary(
    id: id,
    source: source,
    label: redactSecrets(label),
    title: safeTitle,
    turns: turns is int ? turns : 0,
    cwd: safeCwd,
    excerpt: safeExcerpt,
    mtime: mtime is num ? mtime.toDouble() : 0,
  );
}

/// Exports above this size are redacted off the UI isolate: the rules are
/// several passes over up to 2 MiB of text.
const transcriptRedactionInlineLimit = 64 * 1024;

/// [redactSecrets] for a whole export. A large transcript is redacted on
/// another isolate so the page keeps drawing while it runs.
Future<String> redactTranscript(String content) =>
    content.length <= transcriptRedactionInlineLimit
    ? Future.value(redactSecrets(content))
    : Isolate.run(() => redactSecrets(content));

String _historyText(Object? value) {
  if (value is String) return value.trim();
  if (value is Map) return _historyText(value['text'] ?? value['content']);
  if (value is List) {
    return [
      for (final item in value) _historyText(item),
    ].where((part) => part.isNotEmpty).join('\n');
  }
  return '';
}

String _exportName(String filename, String format) {
  final base = filename.split(RegExp(r'[\\/]')).last.trim();
  final clean = base.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '');
  if (clean.isEmpty || clean.startsWith('.')) return 'transcript.$format';
  return clean;
}

bool _sessionId(String id) =>
    id.isNotEmpty &&
    id.length <= 128 &&
    id.trim() == id &&
    !id.contains('/') &&
    !id.contains('\\') &&
    !RegExp(r'\s').hasMatch(id);
