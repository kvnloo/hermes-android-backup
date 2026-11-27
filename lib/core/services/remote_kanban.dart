part of 'remote_workspace.dart';

const List<String> kanbanWorkflowColumns = <String>[
  'triage',
  'todo',
  'scheduled',
  'ready',
  'running',
  'blocked',
  'review',
  'done',
];

const Set<String> kanbanLockedDragColumns = <String>{
  'scheduled',
  'running',
  'review',
};

const Map<String, String> kanbanColumnLabels = <String, String>{
  'triage': 'Triage',
  'todo': 'Todo',
  'scheduled': 'Scheduled',
  'ready': 'Ready',
  'running': 'Running',
  'blocked': 'Blocked',
  'review': 'Review',
  'done': 'Done',
};

/// Manual card transitions permitted by `hermes_cli/kanban_workflow.py`.
List<String> kanbanAllowedManualTargets(String status) => switch (status) {
  'triage' => const ['todo', 'ready'],
  'todo' => const ['triage', 'scheduled', 'ready'],
  'scheduled' => const ['triage', 'todo', 'ready'],
  'ready' => const ['triage', 'todo', 'scheduled', 'blocked', 'review', 'done'],
  'running' => const [
    'triage',
    'todo',
    'scheduled',
    'ready',
    'blocked',
    'review',
    'done',
  ],
  'blocked' => const ['triage', 'todo', 'scheduled', 'ready', 'done'],
  'review' => const ['triage', 'todo', 'ready', 'done'],
  'done' => const ['triage', 'todo', 'ready'],
  'archived' => const ['triage', 'todo', 'ready'],
  _ => const ['triage', 'todo', 'ready'],
};

class KanbanBoardMeta {
  const KanbanBoardMeta({
    required this.slug,
    required this.name,
    this.description = '',
    this.icon,
    this.color,
    this.defaultWorkdir,
    this.projectId,
    this.projectName,
    this.isCurrent = false,
    this.counts = const {},
    this.total = 0,
    this.defaultWorkspaceKind = 'scratch',
    this.archived = false,
  });

  final String slug;
  final String name;
  final String description;
  final String? icon;
  final String? color;
  final String? defaultWorkdir;
  final String? projectId;
  final String? projectName;
  final bool isCurrent;
  final Map<String, int> counts;
  final int total;
  final String defaultWorkspaceKind;
  final bool archived;

  int get activeWorkCount => (counts['running'] ?? 0) + (counts['ready'] ?? 0);

  factory KanbanBoardMeta.fromJson(Map raw) {
    final rawCounts = raw['counts'];
    final counts = <String, int>{
      if (rawCounts is Map)
        for (final entry in rawCounts.entries)
          if (entry.key is String && entry.value is num)
            entry.key as String: (entry.value as num).toInt(),
    };
    final slug = (raw['slug'] as String? ?? 'default').trim();
    final name = (raw['name'] as String? ?? slug).trim();
    return KanbanBoardMeta(
      slug: slug.isEmpty ? 'default' : slug,
      name: name.isEmpty ? (slug.isEmpty ? 'default' : slug) : name,
      description: raw['description'] as String? ?? '',
      icon: raw['icon'] as String?,
      color: raw['color'] as String?,
      defaultWorkdir: raw['default_workdir'] as String?,
      projectId: raw['project_id'] as String?,
      projectName: raw['project_name'] as String?,
      isCurrent: raw['is_current'] == true,
      counts: Map.unmodifiable(counts),
      total: (raw['total'] as num?)?.toInt() ?? 0,
      defaultWorkspaceKind:
          raw['default_workspace_kind'] as String? ?? 'scratch',
      archived: raw['archived'] == true,
    );
  }
}

class KanbanBoardsList {
  const KanbanBoardsList({required this.boards, required this.current});
  final List<KanbanBoardMeta> boards;
  final String current;
}

class KanbanTaskCard {
  const KanbanTaskCard({
    required this.id,
    required this.title,
    required this.status,
    this.body = '',
    this.assignee,
    this.tenant,
    this.priority = 0,
    this.workspaceKind,
    this.workspacePath,
    this.projectId,
    this.skills = const [],
    this.goalMode = false,
    this.goalMaxTurns,
    this.modelOverride,
    this.providerOverride,
    this.reasoningEffort,
    this.result,
    this.blockReason,
    this.completionContract,
    this.lastFailureError,
    this.currentRunId,
    this.currentRunStartedAt,
    this.createdAt,
    this.startedAt,
    this.completedAt,
    this.archived = false,
    this.parentCount = 0,
    this.openParentCount = 0,
    this.childCount = 0,
    this.sessionId,
  });

  final String id;
  final String title;
  final String status;
  final String body;
  final String? assignee;
  final String? tenant;
  final int priority;
  final String? workspaceKind;
  final String? workspacePath;
  final String? projectId;
  final List<String> skills;
  final bool goalMode;
  final int? goalMaxTurns;
  final String? modelOverride;
  final String? providerOverride;
  final String? reasoningEffort;
  final String? result;
  final String? blockReason;
  final String? completionContract;
  final String? lastFailureError;
  final int? currentRunId;
  final int? currentRunStartedAt;
  final int? createdAt;
  final int? startedAt;
  final int? completedAt;
  final bool archived;
  final int parentCount;
  final int openParentCount;
  final int childCount;

  /// The session whose agent loop created the task (Hermes provenance,
  /// `kanban_db.Task.session_id`); null for a card made from the CLI or the
  /// dashboard. The chat dock matches it to the chat's own session.
  final String? sessionId;

  factory KanbanTaskCard.fromJson(Map raw) {
    final rawSkills = raw['skills'];
    final skills = <String>[
      if (rawSkills is List)
        for (final s in rawSkills)
          if (s is String && s.trim().isNotEmpty) s.trim(),
    ];
    final assignee = (raw['assignee'] as String?)?.trim();
    final session = raw['session_id'];
    return KanbanTaskCard(
      id: raw['id']?.toString() ?? '',
      title: raw['title']?.toString() ?? '',
      status: raw['status']?.toString() ?? 'todo',
      body: raw['body']?.toString() ?? '',
      assignee: assignee == null || assignee.isEmpty ? null : assignee,
      tenant: raw['tenant'] as String?,
      priority: (raw['priority'] as num?)?.toInt() ?? 0,
      workspaceKind: raw['workspace_kind'] as String?,
      workspacePath: raw['workspace_path'] as String?,
      projectId: raw['project_id'] as String?,
      skills: List.unmodifiable(skills),
      goalMode: raw['goal_mode'] == true,
      goalMaxTurns: (raw['goal_max_turns'] as num?)?.toInt(),
      modelOverride: raw['model_override'] as String?,
      providerOverride: raw['provider_override'] as String?,
      reasoningEffort: raw['reasoning_effort'] as String?,
      result: raw['result'] as String?,
      blockReason: raw['block_reason'] as String?,
      completionContract: raw['completion_contract'] as String?,
      lastFailureError: raw['last_failure_error'] as String?,
      currentRunId: (raw['current_run_id'] as num?)?.toInt(),
      currentRunStartedAt: (raw['current_run_started_at'] as num?)?.toInt(),
      createdAt: (raw['created_at'] as num?)?.toInt(),
      startedAt: (raw['started_at'] as num?)?.toInt(),
      completedAt: (raw['completed_at'] as num?)?.toInt(),
      archived: raw['archived'] == true || raw['status'] == 'archived',
      parentCount: (raw['parent_count'] as num?)?.toInt() ?? 0,
      openParentCount: (raw['open_parent_count'] as num?)?.toInt() ?? 0,
      childCount: (raw['child_count'] as num?)?.toInt() ?? 0,
      sessionId: session is String && session.trim().isNotEmpty
          ? session.trim()
          : null,
    );
  }
}

class KanbanColumn {
  const KanbanColumn({required this.name, required this.tasks});
  final String name;
  final List<KanbanTaskCard> tasks;

  bool get isDragLocked => kanbanLockedDragColumns.contains(name);
  String get label => kanbanColumnLabels[name] ?? name;
}

class KanbanBoardSnapshot {
  const KanbanBoardSnapshot({
    required this.columns,
    required this.tenants,
    required this.assignees,
    required this.latestEventId,
    required this.now,
  });

  final List<KanbanColumn> columns;
  final List<String> tenants;
  final List<String> assignees;
  final int latestEventId;
  final int now;

  int get activeWorkCount {
    var total = 0;
    for (final column in columns) {
      if (column.name == 'running' || column.name == 'ready') {
        total += column.tasks.length;
      }
    }
    return total;
  }

  List<KanbanTaskCard> get allTasks => [
    for (final col in columns) ...col.tasks,
  ];

  factory KanbanBoardSnapshot.fromJson(Map raw) {
    final rawCols = raw['columns'];
    final byName = <String, List<KanbanTaskCard>>{};
    final extraOrder = <String>[];
    if (rawCols is List) {
      for (final entry in rawCols) {
        if (entry is! Map || entry['name'] is! String) continue;
        final name = entry['name'] as String;
        final rawTasks = entry['tasks'];
        final tasks = <KanbanTaskCard>[
          if (rawTasks is List)
            for (final item in rawTasks)
              if (item is Map) KanbanTaskCard.fromJson(item),
        ];
        byName[name] = List.unmodifiable(tasks);
        if (!kanbanWorkflowColumns.contains(name)) {
          extraOrder.add(name);
        }
      }
    }
    final columns = <KanbanColumn>[
      for (final name in kanbanWorkflowColumns)
        KanbanColumn(name: name, tasks: byName[name] ?? const []),
      for (final name in extraOrder)
        KanbanColumn(name: name, tasks: byName[name] ?? const []),
    ];
    return KanbanBoardSnapshot(
      columns: List.unmodifiable(columns),
      tenants: List.unmodifiable([
        if (raw['tenants'] is List)
          for (final t in raw['tenants'] as List)
            if (t is String) t,
      ]),
      assignees: List.unmodifiable([
        if (raw['assignees'] is List)
          for (final a in raw['assignees'] as List)
            if (a is String) a,
      ]),
      latestEventId: (raw['latest_event_id'] as num?)?.toInt() ?? 0,
      now: (raw['now'] as num?)?.toInt() ?? 0,
    );
  }
}

class KanbanCommentRecord {
  const KanbanCommentRecord({
    required this.author,
    required this.body,
    required this.createdAt,
  });
  final String author;
  final String body;
  final int createdAt;

  factory KanbanCommentRecord.fromJson(Map raw) => KanbanCommentRecord(
    author: raw['author']?.toString() ?? 'unknown',
    body: raw['body']?.toString() ?? '',
    createdAt: (raw['created_at'] as num?)?.toInt() ?? 0,
  );
}

class KanbanRunRecord {
  const KanbanRunRecord({
    required this.id,
    required this.profile,
    required this.status,
    this.outcome,
    this.summary,
    this.error,
    this.startedAt,
    this.endedAt,
  });
  final int id;
  final String profile;
  final String status;
  final String? outcome;
  final String? summary;
  final String? error;
  final int? startedAt;
  final int? endedAt;

  factory KanbanRunRecord.fromJson(Map raw) => KanbanRunRecord(
    id: (raw['id'] as num?)?.toInt() ?? 0,
    profile: raw['profile']?.toString() ?? '',
    status: raw['status']?.toString() ?? '',
    outcome: raw['outcome'] as String?,
    summary: raw['summary'] as String?,
    error: raw['error'] as String?,
    startedAt: (raw['started_at'] as num?)?.toInt(),
    endedAt: (raw['ended_at'] as num?)?.toInt(),
  );
}

class KanbanEventRecord {
  const KanbanEventRecord({
    this.id,
    this.taskId,
    required this.kind,
    this.payload,
    required this.createdAt,
  });
  final int? id;
  final String? taskId;
  final String kind;
  final Object? payload;
  final int createdAt;

  factory KanbanEventRecord.fromJson(Map raw) => KanbanEventRecord(
    id: (raw['id'] as num?)?.toInt(),
    taskId: raw['task_id']?.toString(),
    kind: raw['kind']?.toString() ?? 'event',
    payload: raw['payload'],
    createdAt: (raw['created_at'] as num?)?.toInt() ?? 0,
  );
}

class KanbanLinkedTask {
  const KanbanLinkedTask({
    required this.id,
    required this.title,
    required this.status,
  });
  final String id;
  final String title;
  final String status;

  factory KanbanLinkedTask.fromJson(Map raw) => KanbanLinkedTask(
    id: raw['id']?.toString() ?? '',
    title: raw['title']?.toString() ?? raw['id']?.toString() ?? '',
    status: raw['status']?.toString() ?? 'todo',
  );
}

class KanbanAttachmentRecord {
  const KanbanAttachmentRecord({
    required this.id,
    required this.filename,
    required this.size,
    this.contentType,
    this.uploadedBy,
    this.storedPath,
  });
  final String id;
  final String filename;
  final int size;
  final String? contentType;
  final String? uploadedBy;
  final String? storedPath;

  factory KanbanAttachmentRecord.fromJson(Map raw) => KanbanAttachmentRecord(
    id: raw['id']?.toString() ?? '',
    filename: raw['filename']?.toString() ?? '',
    size: (raw['size'] as num?)?.toInt() ?? 0,
    contentType: raw['content_type'] as String?,
    uploadedBy: raw['uploaded_by'] as String?,
    storedPath: raw['stored_path'] as String?,
  );
}

class KanbanDiagnosticRecord {
  const KanbanDiagnosticRecord({
    required this.kind,
    required this.severity,
    required this.title,
    required this.detail,
  });
  final String kind;
  final String severity;
  final String title;
  final String detail;

  factory KanbanDiagnosticRecord.fromJson(Map raw) => KanbanDiagnosticRecord(
    kind: raw['kind']?.toString() ?? 'diagnostic',
    severity: raw['severity']?.toString() ?? 'warning',
    title: raw['title']?.toString() ?? '',
    detail: raw['detail']?.toString() ?? '',
  );
}

class KanbanTaskDetail {
  const KanbanTaskDetail({
    required this.task,
    required this.comments,
    required this.runs,
    required this.events,
    required this.parents,
    required this.children,
    required this.linkedTasks,
    required this.attachments,
    required this.diagnostics,
    required this.warnings,
  });

  final KanbanTaskCard task;
  final List<KanbanCommentRecord> comments;
  final List<KanbanRunRecord> runs;
  final List<KanbanEventRecord> events;
  final List<String> parents;
  final List<String> children;
  final Map<String, KanbanLinkedTask> linkedTasks;
  final List<KanbanAttachmentRecord> attachments;
  final List<KanbanDiagnosticRecord> diagnostics;
  final List<String> warnings;

  factory KanbanTaskDetail.fromJson(Map raw) {
    final rawTask = raw['task'];
    if (rawTask is! Map) _fail(WorkspaceFailure.invalid);
    final rawLinks = raw['links'];
    final parents = <String>[
      if (rawLinks is Map && rawLinks['parents'] is List)
        for (final p in rawLinks['parents'] as List)
          if (p is String) p,
    ];
    final children = <String>[
      if (rawLinks is Map && rawLinks['children'] is List)
        for (final c in rawLinks['children'] as List)
          if (c is String) c,
    ];
    final linked = <String, KanbanLinkedTask>{};
    if (raw['link_tasks'] is List) {
      for (final item in raw['link_tasks'] as List) {
        if (item is Map) {
          final parsed = KanbanLinkedTask.fromJson(item);
          if (parsed.id.isNotEmpty) linked[parsed.id] = parsed;
        }
      }
    }
    return KanbanTaskDetail(
      task: KanbanTaskCard.fromJson(rawTask),
      comments: List.unmodifiable([
        if (raw['comments'] is List)
          for (final item in raw['comments'] as List)
            if (item is Map) KanbanCommentRecord.fromJson(item),
      ]),
      runs: List.unmodifiable([
        if (raw['runs'] is List)
          for (final item in raw['runs'] as List)
            if (item is Map) KanbanRunRecord.fromJson(item),
      ]),
      events: List.unmodifiable([
        if (raw['events'] is List)
          for (final item in raw['events'] as List)
            if (item is Map) KanbanEventRecord.fromJson(item),
      ]),
      parents: List.unmodifiable(parents),
      children: List.unmodifiable(children),
      linkedTasks: Map.unmodifiable(linked),
      attachments: List.unmodifiable([
        if (raw['attachments'] is List)
          for (final item in raw['attachments'] as List)
            if (item is Map) KanbanAttachmentRecord.fromJson(item),
      ]),
      diagnostics: List.unmodifiable([
        if (raw['diagnostics'] is List)
          for (final item in raw['diagnostics'] as List)
            if (item is Map) KanbanDiagnosticRecord.fromJson(item),
      ]),
      warnings: List.unmodifiable([
        if (raw['warnings'] is List)
          for (final item in raw['warnings'] as List)
            if (item is String && item.trim().isNotEmpty) item.trim(),
      ]),
    );
  }
}

class KanbanWorkerLog {
  const KanbanWorkerLog({
    required this.taskId,
    required this.exists,
    required this.sizeBytes,
    required this.content,
    required this.truncated,
  });
  final String taskId;
  final bool exists;
  final int sizeBytes;
  final String content;
  final bool truncated;

  factory KanbanWorkerLog.fromJson(Map raw) => KanbanWorkerLog(
    taskId: raw['task_id']?.toString() ?? '',
    exists: raw['exists'] == true,
    sizeBytes: (raw['size_bytes'] as num?)?.toInt() ?? 0,
    content: raw['content']?.toString() ?? '',
    truncated: raw['truncated'] == true,
  );
}

class KanbanProfileEntry {
  const KanbanProfileEntry({
    required this.name,
    this.isDefault = false,
    this.model,
    this.provider,
    this.description = '',
    this.descriptionAuto = false,
    this.skillCount = 0,
  });
  final String name;
  final bool isDefault;
  final String? model;
  final String? provider;
  final String description;
  final bool descriptionAuto;
  final int skillCount;

  factory KanbanProfileEntry.fromJson(Map raw) => KanbanProfileEntry(
    name: raw['name']?.toString() ?? 'default',
    isDefault: raw['is_default'] == true,
    model: raw['model'] as String?,
    provider: raw['provider'] as String?,
    description: raw['description']?.toString() ?? '',
    descriptionAuto: raw['description_auto'] == true,
    skillCount: (raw['skill_count'] as num?)?.toInt() ?? 0,
  );
}

class KanbanProjectEntry {
  const KanbanProjectEntry({
    required this.id,
    required this.slug,
    required this.name,
    this.primaryPath,
  });
  final String id;
  final String slug;
  final String name;
  final String? primaryPath;

  factory KanbanProjectEntry.fromJson(Map raw) => KanbanProjectEntry(
    id: raw['id']?.toString() ?? '',
    slug: raw['slug']?.toString() ?? '',
    name: raw['name']?.toString() ?? '',
    primaryPath: raw['primary_path'] as String?,
  );
}

class KanbanOrchestration {
  const KanbanOrchestration({
    this.orchestratorProfile,
    this.defaultAssignee,
    this.autoDecompose = false,
    this.autoPromoteChildren = false,
    this.resolvedOrchestratorProfile,
    this.resolvedDefaultAssignee,
    this.activeProfile,
  });

  final String? orchestratorProfile;
  final String? defaultAssignee;
  final bool autoDecompose;
  final bool autoPromoteChildren;
  final String? resolvedOrchestratorProfile;
  final String? resolvedDefaultAssignee;
  final String? activeProfile;

  factory KanbanOrchestration.fromJson(Map raw) {
    String? clean(Object? v) {
      final s = v is String ? v.trim() : null;
      return s == null || s.isEmpty ? null : s;
    }

    return KanbanOrchestration(
      orchestratorProfile: clean(raw['orchestrator_profile']),
      defaultAssignee: clean(raw['default_assignee']),
      autoDecompose: raw['auto_decompose'] == true,
      autoPromoteChildren: raw['auto_promote_children'] == true,
      resolvedOrchestratorProfile: clean(raw['resolved_orchestrator_profile']),
      resolvedDefaultAssignee: clean(raw['resolved_default_assignee']),
      activeProfile: clean(raw['active_profile']),
    );
  }
}

class KanbanTaskEstimate {
  const KanbanTaskEstimate({
    required this.ok,
    this.estTokens,
    this.complexity,
    this.rationale,
    this.model,
    this.reason,
  });
  final bool ok;
  final int? estTokens;
  final String? complexity;
  final String? rationale;
  final String? model;
  final String? reason;

  factory KanbanTaskEstimate.fromJson(Map raw) => KanbanTaskEstimate(
    ok: raw['ok'] == true,
    estTokens: (raw['est_tokens'] as num?)?.toInt(),
    complexity: raw['complexity'] as String?,
    rationale: raw['rationale'] as String?,
    model: raw['model'] as String?,
    reason: raw['reason'] as String?,
  );
}

class KanbanDispatchReceipt {
  const KanbanDispatchReceipt({
    required this.spawnedCount,
    required this.promoted,
    required this.reclaimed,
  });
  final int spawnedCount;
  final int promoted;
  final int reclaimed;

  factory KanbanDispatchReceipt.fromJson(Map raw) => KanbanDispatchReceipt(
    spawnedCount: raw['spawned'] is List ? (raw['spawned'] as List).length : 0,
    promoted: (raw['promoted'] as num?)?.toInt() ?? 0,
    reclaimed: (raw['reclaimed'] as num?)?.toInt() ?? 0,
  );
}

/// The reply of `POST /tasks/{id}/decompose` (plugins/kanban/dashboard/
/// plugin_api.py): a refusal is `ok: false` with a [reason], never an HTTP
/// error, and a task the decomposer keeps whole is `ok` without [fanout].
class KanbanDecomposeOutcome {
  const KanbanDecomposeOutcome({
    required this.ok,
    required this.fanout,
    required this.childIds,
    this.reason,
    this.newTitle,
  });

  final bool ok;
  final bool fanout;
  final List<String> childIds;
  final String? reason;
  final String? newTitle;

  factory KanbanDecomposeOutcome.fromJson(Map<String, dynamic> raw) {
    final ids = raw['child_ids'];
    String? text(Object? value) =>
        value is String && value.trim().isNotEmpty ? value.trim() : null;
    return KanbanDecomposeOutcome(
      ok: raw['ok'] == true,
      fanout: raw['fanout'] == true,
      childIds: List.unmodifiable([
        if (ids is List)
          for (final id in ids)
            if (id is String && id.isNotEmpty) id,
      ]),
      reason: text(raw['reason']),
      newTitle: text(raw['new_title']),
    );
  }
}

class KanbanBulkResult {
  const KanbanBulkResult({required this.id, required this.ok, this.error});
  final String id;
  final bool ok;
  final String? error;
}

class KanbanEventsFrame {
  const KanbanEventsFrame({required this.events, required this.cursor});
  final List<KanbanEventRecord> events;
  final int cursor;
}

/// Connection- and profile-scoped local board preferences, matching Desktop's
/// `$boardSlug`, `$pinnedBoards`, `$lanesByProfile` and `$collapsedLanes`
/// without mutating the gateway's CLI-shared `current` pointer.
class KanbanBoardPreferences {
  KanbanBoardPreferences(
    this._prefs, {
    required String connectionId,
    required String? profile,
  }) : _scope =
           'kanban.v1.$connectionId.${(profile == null || profile.trim().isEmpty) ? 'default' : profile.trim()}';

  final SharedPreferences _prefs;
  final String _scope;

  String get selectedBoard => _prefs.getString('$_scope.boardSlug') ?? '';

  Future<void> setSelectedBoard(String slug) =>
      _prefs.setString('$_scope.boardSlug', slug);

  List<String> get pinnedBoards => List.unmodifiable(
    _prefs.getStringList('$_scope.pinnedBoards') ?? const <String>[],
  );

  Future<void> setBoardPinned(String slug, bool pinned) {
    final current = List<String>.from(pinnedBoards);
    if (pinned && !current.contains(slug)) {
      current.add(slug);
    } else if (!pinned) {
      current.remove(slug);
    }
    return _prefs.setStringList('$_scope.pinnedBoards', current);
  }

  Future<void> movePinnedBoard(String slug, String target) {
    final next = List<String>.from(pinnedBoards);
    final from = next.indexOf(slug);
    final to = next.indexOf(target);
    if (from < 0 || to < 0 || from == to) return Future.value();
    next.removeAt(from);
    next.insert(to, slug);
    return _prefs.setStringList('$_scope.pinnedBoards', next);
  }

  bool get lanesByProfile => _prefs.getBool('$_scope.lanesByProfile') ?? false;

  Future<void> setLanesByProfile(bool value) =>
      _prefs.setBool('$_scope.lanesByProfile', value);

  Map<String, bool> get collapsedLanes {
    final raw = _prefs.getString('$_scope.collapsedLanes');
    if (raw == null || raw.isEmpty) return const {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return {
          for (final e in decoded.entries)
            if (e.key is String && e.value is bool)
              e.key as String: e.value as bool,
        };
      }
    } catch (_) {}
    return const {};
  }

  Future<void> setLaneCollapsed(String lane, bool? collapsed) {
    final next = Map<String, bool>.from(collapsedLanes);
    if (collapsed == null) {
      next.remove(lane);
    } else {
      next[lane] = collapsed;
    }
    return _prefs.setString('$_scope.collapsedLanes', jsonEncode(next));
  }
}

extension WorkspaceKanban on WorkspaceTarget {
  Future<Map<String, dynamic>> _kanbanMap(KanbanDashboardRequest request) =>
      _withOwner(() async {
        final raw = await _owner._dashboard.kanbanExchange(
          request,
          check: checkCurrent,
        );
        if (raw is! Map) _fail(WorkspaceFailure.invalid);
        return Map<String, dynamic>.from(raw);
      });

  /// Debounced 400 ms fire-and-forget dispatch nudge matching Desktop `api.ts`.
  static final Expando<Timer> _nudgeTimers = Expando<Timer>();

  static void _cancelNudge(RemoteWorkspaceOwner owner) {
    _nudgeTimers[owner]?.cancel();
    _nudgeTimers[owner] = null;
  }

  void _scheduleKanbanDispatchNudge(String? board) {
    _nudgeTimers[_owner]?.cancel();
    _nudgeTimers[_owner] = Timer(const Duration(milliseconds: 400), () async {
      if (!isCurrent) return;
      try {
        await _owner._dashboard.kanbanExchange(
          KanbanDispatchNudge(board: board),
          check: checkCurrent,
        );
      } catch (_) {
        // Best-effort nudge; the gateway dispatcher has its own periodic tick.
      }
    });
  }

  Future<KanbanBoardsList> kanbanBoards({bool includeArchived = false}) async {
    final raw = await _kanbanMap(
      KanbanBoardsRead(includeArchived: includeArchived),
    );
    final list = raw['boards'];
    if (list is! List) _fail(WorkspaceFailure.invalid);
    return KanbanBoardsList(
      boards: List.unmodifiable([
        for (final item in list)
          if (item is Map) KanbanBoardMeta.fromJson(item),
      ]),
      current: (raw['current'] as String? ?? 'default').trim(),
    );
  }

  Future<KanbanBoardMeta> kanbanCreateBoard({
    required String slug,
    required String name,
    String? projectId,
    String? defaultWorkdir,
  }) async {
    final raw = await _kanbanMap(
      KanbanBoardCreate(
        slug: slug,
        name: name,
        projectId: projectId,
        defaultWorkdir: defaultWorkdir,
      ),
    );
    final board = raw['board'] is Map ? raw['board'] as Map : raw;
    return KanbanBoardMeta.fromJson(board);
  }

  Future<KanbanBoardMeta> kanbanPatchBoard({
    required String slug,
    String? name,
    String? description,
    String? icon,
    String? color,
    String? defaultWorkdir,
    String? projectId,
  }) async {
    final raw = await _kanbanMap(
      KanbanBoardPatch(
        slug: slug,
        name: name,
        description: description,
        icon: icon,
        color: color,
        defaultWorkdir: defaultWorkdir,
        projectId: projectId,
      ),
    );
    final board = raw['board'] is Map ? raw['board'] as Map : raw;
    return KanbanBoardMeta.fromJson(board);
  }

  Future<String?> kanbanArchiveBoard(String slug) async {
    final raw = await _kanbanMap(KanbanBoardArchive(slug));
    final result = raw['result'];
    return result is Map ? result['new_path'] as String? : null;
  }

  Future<({String board, String archive, int size})> kanbanExportBoard({
    required String slug,
    String? output,
    bool attachments = true,
    bool logs = false,
  }) async {
    final raw = await _kanbanMap(
      KanbanBoardExport(
        slug: slug,
        output: output,
        attachments: attachments,
        logs: logs,
      ),
    );
    final archive = raw['archive'];
    if (archive is! String || archive.isEmpty) _fail(WorkspaceFailure.invalid);
    return (
      board: raw['board']?.toString() ?? slug,
      archive: archive,
      size: (raw['size'] as num?)?.toInt() ?? 0,
    );
  }

  Future<({String board, String name, bool renamed, List<String> warnings})>
  kanbanImportBoard({required String archive, String? slug}) async {
    final raw = await _kanbanMap(
      KanbanBoardImport(archive: archive, slug: slug),
    );
    final board = raw['board'];
    if (board is! String || board.isEmpty) _fail(WorkspaceFailure.invalid);
    return (
      board: board,
      name: raw['name']?.toString() ?? board,
      renamed: raw['renamed'] == true,
      warnings: List<String>.unmodifiable([
        if (raw['warnings'] is List)
          for (final w in raw['warnings'] as List)
            if (w is String && w.trim().isNotEmpty) w.trim(),
      ]),
    );
  }

  Future<KanbanBoardSnapshot> kanbanBoardSnapshot({
    String? board,
    bool includeArchived = false,
  }) async {
    final raw = await _kanbanMap(
      KanbanBoardSnapshotRead(board: board, includeArchived: includeArchived),
    );
    return KanbanBoardSnapshot.fromJson(raw);
  }

  Future<List<KanbanProfileEntry>> kanbanProfiles() async {
    final raw = await _kanbanMap(const KanbanProfilesRead());
    final list = raw['profiles'];
    if (list is! List) _fail(WorkspaceFailure.invalid);
    return List.unmodifiable([
      for (final item in list)
        if (item is Map) KanbanProfileEntry.fromJson(item),
    ]);
  }

  Future<String> kanbanSaveProfileDescription({
    required String name,
    required String description,
  }) async {
    final raw = await _kanbanMap(
      KanbanProfilePatch(name: name, description: description),
    );
    return raw['description']?.toString() ?? description;
  }

  Future<({bool ok, String description, String? reason})>
  kanbanDescribeProfileAuto(String name) async {
    final raw = await _kanbanMap(KanbanProfileDescribeAuto(name));
    return (
      ok: raw['ok'] == true,
      description: raw['description']?.toString() ?? '',
      reason: raw['reason'] as String?,
    );
  }

  Future<List<KanbanProjectEntry>> kanbanProjects() async {
    final raw = await _kanbanMap(const KanbanProjectsRead());
    final list = raw['projects'];
    if (list is! List) return const [];
    return List.unmodifiable([
      for (final item in list)
        if (item is Map) KanbanProjectEntry.fromJson(item),
    ]);
  }

  Future<KanbanOrchestration> kanbanOrchestration() async {
    final raw = await _kanbanMap(const KanbanOrchestrationRead());
    return KanbanOrchestration.fromJson(raw);
  }

  Future<KanbanOrchestration> kanbanSaveOrchestration({
    String? orchestratorProfile,
    String? defaultAssignee,
    bool? autoDecompose,
  }) async {
    final raw = await _kanbanMap(
      KanbanOrchestrationSave(
        orchestratorProfile: orchestratorProfile,
        defaultAssignee: defaultAssignee,
        autoDecompose: autoDecompose,
      ),
    );
    return KanbanOrchestration.fromJson(raw);
  }

  Future<KanbanDispatchReceipt> kanbanDispatchNow({String? board}) async {
    final raw = await _kanbanMap(KanbanDispatchNudge(board: board));
    return KanbanDispatchReceipt.fromJson(raw);
  }

  Future<KanbanTaskDetail> kanbanTaskDetail({
    required String taskId,
    String? board,
  }) async {
    final raw = await _kanbanMap(KanbanTaskRead(taskId: taskId, board: board));
    return KanbanTaskDetail.fromJson(raw);
  }

  Future<KanbanWorkerLog> kanbanTaskLog({
    required String taskId,
    String? board,
    int tail = 16384,
  }) async {
    final raw = await _kanbanMap(
      KanbanTaskLogRead(taskId: taskId, board: board, tail: tail),
    );
    return KanbanWorkerLog.fromJson(raw);
  }

  Future<({KanbanTaskCard task, String? warning})> kanbanCreateTask({
    String? board,
    required String title,
    String? body,
    String? assignee,
    String? tenant,
    int? priority,
    String? workspaceKind,
    String? workspacePath,
    List<String>? parents,
    bool triage = false,
    List<String>? skills,
    bool goalMode = false,
    int? goalMaxTurns,
    String? modelOverride,
    String? providerOverride,
    String? reasoningEffort,
    String? projectId,
  }) async {
    final raw = await _kanbanMap(
      KanbanTaskCreate(
        board: board,
        title: title,
        body: body,
        assignee: assignee,
        tenant: tenant,
        priority: priority,
        workspaceKind: workspaceKind,
        workspacePath: workspacePath,
        parents: parents,
        triage: triage,
        skills: skills,
        goalMode: goalMode,
        goalMaxTurns: goalMaxTurns,
        modelOverride: modelOverride,
        providerOverride: providerOverride,
        reasoningEffort: reasoningEffort,
        projectId: projectId,
      ),
    );
    final taskRaw = raw['task'] is Map ? raw['task'] as Map : raw;
    final created = KanbanTaskCard.fromJson(taskRaw);
    _scheduleKanbanDispatchNudge(board);
    return (task: created, warning: raw['warning'] as String?);
  }

  Future<KanbanTaskCard> kanbanPatchTask({
    required String taskId,
    String? board,
    String? status,
    String? assignee,
    int? priority,
    String? title,
    String? body,
    String? result,
    String? blockReason,
    String? summary,
    String? modelOverride,
    String? providerOverride,
    bool clearModelOverride = false,
    String? reasoningEffort,
    bool clearReasoningEffort = false,
  }) async {
    final raw = await _kanbanMap(
      KanbanTaskPatch(
        taskId: taskId,
        board: board,
        status: status,
        assignee: assignee,
        priority: priority,
        title: title,
        body: body,
        result: result,
        blockReason: blockReason,
        summary: summary,
        modelOverride: modelOverride,
        providerOverride: providerOverride,
        clearModelOverride: clearModelOverride,
        reasoningEffort: reasoningEffort,
        clearReasoningEffort: clearReasoningEffort,
      ),
    );
    final taskRaw = raw['task'] is Map ? raw['task'] as Map : raw;
    final updated = KanbanTaskCard.fromJson(taskRaw);
    _scheduleKanbanDispatchNudge(board);
    return updated;
  }

  Future<void> kanbanDeleteTask({required String taskId, String? board}) async {
    await _kanbanMap(KanbanTaskDelete(taskId: taskId, board: board));
    _scheduleKanbanDispatchNudge(board);
  }

  Future<List<KanbanBulkResult>> kanbanBulkUpdate({
    String? board,
    required List<String> ids,
    String? status,
    String? assignee,
    int? priority,
    bool? archive,
    bool? reclaimFirst,
  }) async {
    final raw = await _kanbanMap(
      KanbanTasksBulk(
        board: board,
        ids: ids,
        status: status,
        assignee: assignee,
        priority: priority,
        archive: archive,
        reclaimFirst: reclaimFirst,
      ),
    );
    _scheduleKanbanDispatchNudge(board);
    final results = raw['results'];
    if (results is! List) return const [];
    return List.unmodifiable([
      for (final item in results)
        if (item is Map && item['id'] is String)
          KanbanBulkResult(
            id: item['id'] as String,
            ok: item['ok'] == true,
            error: item['error'] as String?,
          ),
    ]);
  }

  Future<void> kanbanAddComment({
    required String taskId,
    String? board,
    required String body,
  }) async {
    await _kanbanMap(
      KanbanTaskComment(taskId: taskId, board: board, body: body),
    );
  }

  Future<void> kanbanReassignTask({
    required String taskId,
    String? board,
    required String profile,
    bool reclaimFirst = true,
    String? reason,
  }) async {
    await _kanbanMap(
      KanbanTaskReassign(
        taskId: taskId,
        board: board,
        profile: profile,
        reclaimFirst: reclaimFirst,
        reason: reason,
      ),
    );
    _scheduleKanbanDispatchNudge(board);
  }

  Future<void> kanbanReclaimTask({
    required String taskId,
    String? board,
  }) async {
    await _kanbanMap(KanbanTaskReclaim(taskId: taskId, board: board));
    _scheduleKanbanDispatchNudge(board);
  }

  Future<KanbanTaskEstimate> kanbanEstimateTask({
    required String taskId,
    String? board,
  }) async {
    final raw = await _kanbanMap(
      KanbanTaskEstimateRequest(taskId: taskId, board: board),
    );
    return KanbanTaskEstimate.fromJson(raw);
  }

  Future<KanbanTaskEstimate> kanbanEstimateDraft({
    required String title,
    String? body,
  }) async {
    final raw = await _kanbanMap(KanbanDraftEstimate(title: title, body: body));
    return KanbanTaskEstimate.fromJson(raw);
  }

  Future<KanbanDecomposeOutcome> kanbanDecomposeTask({
    required String taskId,
    String? board,
  }) async {
    final raw = await _kanbanMap(
      KanbanTaskDecompose(taskId: taskId, board: board),
    );
    final outcome = KanbanDecomposeOutcome.fromJson(raw);
    // Nothing changed on a refusal, so there is nothing to dispatch.
    if (outcome.ok) _scheduleKanbanDispatchNudge(board);
    return outcome;
  }

  Future<bool> kanbanAddLink({
    String? board,
    required String parentId,
    required String childId,
  }) async {
    final raw = await _kanbanMap(
      KanbanLinkAdd(board: board, parentId: parentId, childId: childId),
    );
    _scheduleKanbanDispatchNudge(board);
    return raw['gated'] == true;
  }

  Future<bool> kanbanRemoveLink({
    String? board,
    required String parentId,
    required String childId,
  }) async {
    final raw = await _kanbanMap(
      KanbanLinkRemove(board: board, parentId: parentId, childId: childId),
    );
    _scheduleKanbanDispatchNudge(board);
    return raw['ok'] == true;
  }

  Future<KanbanAttachmentRecord> kanbanUploadAttachment({
    required String taskId,
    String? board,
    required String filename,
    required Uint8List bytes,
  }) => _withOwner(() async {
    final raw = await _owner._dashboard.uploadKanbanAttachment(
      taskId: taskId,
      board: board,
      filename: filename,
      bytes: bytes,
      check: checkCurrent,
    );
    final att = raw['attachment'] is Map ? raw['attachment'] as Map : raw;
    return KanbanAttachmentRecord.fromJson(att);
  });

  /// Opens a fenced live `/api/plugins/kanban/events` stream for [board] from
  /// [since]. Returns null when the host refuses WebSocket upgrades or in
  /// widget tests without real sockets so callers keep their polling loop.
  ///
  /// This is the reusable public subscription the chat dock reuses in place of
  /// the board's private `_bindRealtime` path: callers keep their own cursor
  /// and cancel via the returned subscription's `cancel()`. The returned
  /// subscription is not bound to any widget lifetime.
  Future<StreamSubscription<KanbanEventsFrame>?> watchKanbanEvents({
    String? board,
    required int since,
    required void Function(KanbanEventsFrame frame) onFrame,
    void Function()? onClosed,
  }) async {
    if (!isCurrent) return null;
    try {
      final socket = await _owner._dashboard.openKanbanEventsSocket(
        board: board,
        since: since,
        check: checkCurrent,
      );
      late StreamSubscription<dynamic> inner;
      inner = socket.listen(
        (data) {
          if (!isCurrent) {
            unawaited(socket.close(WebSocketStatus.normalClosure));
            return;
          }
          if (data is! String) return;
          try {
            final decoded = jsonDecode(data);
            if (decoded is! Map) return;
            final cursor = (decoded['cursor'] as num?)?.toInt();
            final rawEvents = decoded['events'];
            if (cursor == null || rawEvents is! List) return;
            onFrame(
              KanbanEventsFrame(
                events: List.unmodifiable([
                  for (final item in rawEvents)
                    if (item is Map) KanbanEventRecord.fromJson(item),
                ]),
                cursor: cursor,
              ),
            );
          } catch (_) {}
        },
        onDone: () => onClosed?.call(),
        onError: (_) => onClosed?.call(),
        cancelOnError: true,
      );
      return _KanbanSocketSubscription(socket, inner);
    } catch (_) {
      return null;
    }
  }
}

class _KanbanSocketSubscription
    implements StreamSubscription<KanbanEventsFrame> {
  _KanbanSocketSubscription(this._socket, this._inner);
  final WebSocket _socket;
  final StreamSubscription<dynamic> _inner;

  @override
  Future<void> cancel() async {
    await _inner.cancel();
    try {
      await _socket.close(WebSocketStatus.normalClosure);
    } catch (_) {}
  }

  @override
  bool get isPaused => _inner.isPaused;
  @override
  void onData(void Function(KanbanEventsFrame data)? handleData) {}
  @override
  void onDone(void Function()? handleDone) => _inner.onDone(handleDone);
  @override
  void onError(Function? handleError) => _inner.onError(handleError);
  @override
  void pause([Future<void>? resumeSignal]) => _inner.pause(resumeSignal);
  @override
  void resume() => _inner.resume();
  @override
  Future<E> asFuture<E>([E? futureValue]) => _inner.asFuture<E>(futureValue);
}
