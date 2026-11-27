part of 'connection_manager.dart';

/// Closed `/api/plugins/kanban` transport. Callers supply domain requests,
/// never raw paths, origins, arbitrary query parameters or bearer URLs.
final _kanbanBoardSlug = RegExp(r'^[a-z0-9][a-z0-9_-]{0,63}$');
final _kanbanTaskId = RegExp(r'^[A-Za-z0-9][A-Za-z0-9_.:-]{0,127}$');
final _kanbanProfileName = RegExp(r'^[a-z0-9][a-z0-9_-]{0,63}$');

/// Structured 400/409 refusal from the Kanban router (for example, moving a
/// card to `ready` while parent dependencies are still open).
final class KanbanActionRefusedException implements Exception {
  const KanbanActionRefusedException(this.statusCode, this.detail);
  final int statusCode;
  final String detail;

  @override
  String toString() =>
      detail.isEmpty ? 'HTTP $statusCode' : 'HTTP $statusCode: $detail';
}

/// Distinguishes a missing/archived board (`404` when `?board=<slug>` was set)
/// from the Kanban plugin router itself being disabled/absent.
final class KanbanBoardNotFoundException implements Exception {
  const KanbanBoardNotFoundException(this.board);
  final String board;

  @override
  String toString() => 'Kanban board not found: $board';
}

sealed class KanbanDashboardRequest {
  const KanbanDashboardRequest();
}

final class KanbanBoardsRead extends KanbanDashboardRequest {
  const KanbanBoardsRead({this.includeArchived = false});
  final bool includeArchived;
}

final class KanbanBoardCreate extends KanbanDashboardRequest {
  const KanbanBoardCreate({
    required this.slug,
    required this.name,
    this.projectId,
    this.defaultWorkdir,
  });
  final String slug;
  final String name;
  final String? projectId;
  final String? defaultWorkdir;
}

final class KanbanBoardPatch extends KanbanDashboardRequest {
  const KanbanBoardPatch({
    required this.slug,
    this.name,
    this.description,
    this.icon,
    this.color,
    this.defaultWorkdir,
    this.projectId,
  });
  final String slug;
  final String? name;
  final String? description;
  final String? icon;
  final String? color;
  final String? defaultWorkdir;
  final String? projectId;
}

final class KanbanBoardArchive extends KanbanDashboardRequest {
  const KanbanBoardArchive(this.slug);
  final String slug;
}

final class KanbanBoardExport extends KanbanDashboardRequest {
  const KanbanBoardExport({
    required this.slug,
    this.output,
    this.attachments = true,
    this.logs = false,
  });
  final String slug;
  final String? output;
  final bool attachments;
  final bool logs;
}

final class KanbanBoardImport extends KanbanDashboardRequest {
  const KanbanBoardImport({required this.archive, this.slug});
  final String archive;
  final String? slug;
}

final class KanbanBoardSnapshotRead extends KanbanDashboardRequest {
  const KanbanBoardSnapshotRead({this.board, this.includeArchived = false});
  final String? board;
  final bool includeArchived;
}

final class KanbanProfilesRead extends KanbanDashboardRequest {
  const KanbanProfilesRead();
}

final class KanbanProfilePatch extends KanbanDashboardRequest {
  const KanbanProfilePatch({required this.name, required this.description});
  final String name;
  final String description;
}

final class KanbanProfileDescribeAuto extends KanbanDashboardRequest {
  const KanbanProfileDescribeAuto(this.name);
  final String name;
}

final class KanbanProjectsRead extends KanbanDashboardRequest {
  const KanbanProjectsRead();
}

final class KanbanOrchestrationRead extends KanbanDashboardRequest {
  const KanbanOrchestrationRead();
}

final class KanbanOrchestrationSave extends KanbanDashboardRequest {
  const KanbanOrchestrationSave({
    this.orchestratorProfile,
    this.defaultAssignee,
    this.autoDecompose,
  });
  final String? orchestratorProfile;
  final String? defaultAssignee;
  final bool? autoDecompose;
}

final class KanbanDispatchNudge extends KanbanDashboardRequest {
  const KanbanDispatchNudge({this.board});
  final String? board;
}

final class KanbanTaskRead extends KanbanDashboardRequest {
  const KanbanTaskRead({required this.taskId, this.board});
  final String taskId;
  final String? board;
}

final class KanbanTaskLogRead extends KanbanDashboardRequest {
  const KanbanTaskLogRead({
    required this.taskId,
    this.board,
    this.tail = 16384,
  });
  final String taskId;
  final String? board;
  final int tail;
}

final class KanbanTaskCreate extends KanbanDashboardRequest {
  const KanbanTaskCreate({
    this.board,
    required this.title,
    this.body,
    this.assignee,
    this.tenant,
    this.priority,
    this.workspaceKind,
    this.workspacePath,
    this.parents,
    this.triage = false,
    this.skills,
    this.goalMode = false,
    this.goalMaxTurns,
    this.modelOverride,
    this.providerOverride,
    this.reasoningEffort,
    this.projectId,
  });
  final String? board;
  final String title;
  final String? body;
  final String? assignee;
  final String? tenant;
  final int? priority;
  final String? workspaceKind;
  final String? workspacePath;
  final List<String>? parents;
  final bool triage;
  final List<String>? skills;
  final bool goalMode;
  final int? goalMaxTurns;
  final String? modelOverride;
  final String? providerOverride;
  final String? reasoningEffort;
  final String? projectId;
}

final class KanbanTaskPatch extends KanbanDashboardRequest {
  const KanbanTaskPatch({
    required this.taskId,
    this.board,
    this.status,
    this.assignee,
    this.priority,
    this.title,
    this.body,
    this.result,
    this.blockReason,
    this.summary,
    this.modelOverride,
    this.providerOverride,
    this.clearModelOverride = false,
    this.reasoningEffort,
    this.clearReasoningEffort = false,
  });
  final String taskId;
  final String? board;
  final String? status;
  final String? assignee;
  final int? priority;
  final String? title;
  final String? body;
  final String? result;
  final String? blockReason;
  final String? summary;
  final String? modelOverride;
  final String? providerOverride;
  final bool clearModelOverride;
  final String? reasoningEffort;
  final bool clearReasoningEffort;
}

final class KanbanTaskDelete extends KanbanDashboardRequest {
  const KanbanTaskDelete({required this.taskId, this.board});
  final String taskId;
  final String? board;
}

final class KanbanTasksBulk extends KanbanDashboardRequest {
  const KanbanTasksBulk({
    this.board,
    required this.ids,
    this.status,
    this.assignee,
    this.priority,
    this.archive,
    this.reclaimFirst,
    this.modelOverride,
    this.providerOverride,
    this.clearModelOverride = false,
    this.reasoningEffort,
    this.clearReasoningEffort = false,
  });
  final String? board;
  final List<String> ids;
  final String? status;
  final String? assignee;
  final int? priority;
  final bool? archive;
  final bool? reclaimFirst;
  final String? modelOverride;
  final String? providerOverride;
  final bool clearModelOverride;
  final String? reasoningEffort;
  final bool clearReasoningEffort;
}

final class KanbanTaskComment extends KanbanDashboardRequest {
  const KanbanTaskComment({
    required this.taskId,
    this.board,
    required this.body,
    this.author = 'ares',
  });
  final String taskId;
  final String? board;
  final String body;
  final String author;
}

final class KanbanTaskReassign extends KanbanDashboardRequest {
  const KanbanTaskReassign({
    required this.taskId,
    this.board,
    required this.profile,
    this.reclaimFirst = true,
    this.reason,
  });
  final String taskId;
  final String? board;
  final String profile;
  final bool reclaimFirst;
  final String? reason;
}

final class KanbanTaskReclaim extends KanbanDashboardRequest {
  const KanbanTaskReclaim({required this.taskId, this.board});
  final String taskId;
  final String? board;
}

final class KanbanTaskEstimateRequest extends KanbanDashboardRequest {
  const KanbanTaskEstimateRequest({required this.taskId, this.board});
  final String taskId;
  final String? board;
}

final class KanbanDraftEstimate extends KanbanDashboardRequest {
  const KanbanDraftEstimate({required this.title, this.body});
  final String title;
  final String? body;
}

final class KanbanTaskDecompose extends KanbanDashboardRequest {
  const KanbanTaskDecompose({
    required this.taskId,
    this.board,
    this.author = 'ares',
  });
  final String taskId;
  final String? board;
  final String author;
}

final class KanbanLinkAdd extends KanbanDashboardRequest {
  const KanbanLinkAdd({
    this.board,
    required this.parentId,
    required this.childId,
  });
  final String? board;
  final String parentId;
  final String childId;
}

final class KanbanLinkRemove extends KanbanDashboardRequest {
  const KanbanLinkRemove({
    this.board,
    required this.parentId,
    required this.childId,
  });
  final String? board;
  final String parentId;
  final String childId;
}

String? _validKanbanBoard(String? slug) {
  if (slug == null || slug.isEmpty) return null;
  if (!_kanbanBoardSlug.hasMatch(slug)) {
    throw const FormatException('Invalid board slug');
  }
  return slug;
}

String _validKanbanTask(String id) {
  if (!_kanbanTaskId.hasMatch(id)) {
    throw const FormatException('Invalid task id');
  }
  return id;
}

String _validKanbanProfile(String profile) {
  if (profile == 'current' || !_kanbanProfileName.hasMatch(profile)) {
    throw const FormatException('Invalid profile id');
  }
  return profile;
}

extension KanbanDashboardTransport on DashboardClient {
  String _effectiveKanbanProfile() {
    final named = gatewayProfile;
    final profile = named == null || named.isEmpty ? 'default' : named;
    return _validKanbanProfile(profile);
  }

  Future<Object?> kanbanExchange(
    KanbanDashboardRequest spec, {
    required void Function() check,
  }) async {
    final profile = _effectiveKanbanProfile();
    final plan = _kanbanPlan(profile, spec);
    if (plan.segments.isEmpty ||
        plan.segments.first != 'plugins' ||
        plan.segments.length < 3 ||
        plan.segments[1] != 'kanban' ||
        plan.segments.any(
          (s) =>
              s.isEmpty ||
              s == '.' ||
              s == '..' ||
              RegExp(r'[/\\%?#\x00-\x1f]').hasMatch(s),
        )) {
      throw const FormatException('Invalid kanban route');
    }
    check();
    final base = Uri.parse(_baseUrl);
    final uri = base.replace(
      pathSegments: [
        ...base.pathSegments.where((s) => s.isNotEmpty),
        'api',
        ...plan.segments,
      ],
      queryParameters: plan.query,
    );
    final request = http.Request(plan.method, uri)..followRedirects = false;
    if (plan.body != null) {
      request.bodyBytes = utf8.encode(jsonEncode(plan.body));
    }
    request.headers.addAll(await _authHeaders());
    if (plan.body != null) {
      request.headers['Content-Type'] = 'application/json';
    }
    check();
    final response = await _http
        .send(request)
        .timeout(ApiClient.requestTimeout);
    final bytes = BytesBuilder(copy: false);
    final maxBytes = response.statusCode == 200 ? 2 * 1024 * 1024 : 16 * 1024;
    await for (final chunk in response.stream.timeout(
      ApiClient.requestTimeout,
    )) {
      check();
      if (bytes.length + chunk.length <= maxBytes) {
        bytes.add(chunk);
      } else if (response.statusCode == 200) {
        throw const FormatException('Kanban response too large');
      }
    }
    check();
    final rawBytes = bytes.takeBytes();
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(rawBytes));
    }
    final detail = _extractKanbanErrorDetail(rawBytes);
    if (response.statusCode == 400 || response.statusCode == 409) {
      throw KanbanActionRefusedException(response.statusCode, detail);
    }
    if (response.statusCode == 404 &&
        plan.boardScoped != null &&
        plan.boardScoped != 'default' &&
        detail.toLowerCase().contains('board')) {
      throw KanbanBoardNotFoundException(plan.boardScoped!);
    }
    throw DashboardHttpException(response.statusCode);
  }

  Future<Map<String, dynamic>> uploadKanbanAttachment({
    required String taskId,
    String? board,
    required String filename,
    required Uint8List bytes,
    String uploadedBy = 'ares',
    required void Function() check,
  }) async {
    final profile = _effectiveKanbanProfile();
    final validTask = _validKanbanTask(taskId);
    final validBoard = _validKanbanBoard(board);
    final leaf = filename
        .split(RegExp(r'[/\\]'))
        .last
        .replaceAll(RegExp(r'[\x00-\x1f\x7f]'), '')
        .trim();
    if (leaf.isEmpty ||
        leaf == '.' ||
        leaf == '..' ||
        bytes.isEmpty ||
        bytes.length > 25 * 1024 * 1024) {
      throw const FormatException('Invalid attachment');
    }
    check();
    final base = Uri.parse(_baseUrl);
    final uri = base.replace(
      pathSegments: [
        ...base.pathSegments.where((s) => s.isNotEmpty),
        'api',
        'plugins',
        'kanban',
        'tasks',
        validTask,
        'attachments',
      ],
      queryParameters: {'profile': profile, 'board': ?validBoard},
    );
    final req = http.MultipartRequest('POST', uri)
      ..followRedirects = false
      ..fields['uploaded_by'] = uploadedBy
      ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: leaf));
    final auth = await _authHeaders();
    auth.remove('Content-Type');
    req.headers.addAll(auth);
    check();
    final res = await _http.send(req).timeout(ApiClient.requestTimeout);
    final out = BytesBuilder(copy: false);
    await for (final chunk in res.stream.timeout(ApiClient.requestTimeout)) {
      check();
      if (out.length + chunk.length > 64 * 1024) {
        throw const FormatException('Upload receipt too large');
      }
      out.add(chunk);
    }
    check();
    if (res.statusCode == 400 ||
        res.statusCode == 409 ||
        res.statusCode == 413) {
      throw KanbanActionRefusedException(
        res.statusCode,
        _extractKanbanErrorDetail(out.takeBytes()),
      );
    }
    if (res.statusCode != 200) {
      throw DashboardHttpException(res.statusCode);
    }
    final decoded = jsonDecode(utf8.decode(out.takeBytes()));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid attachment response');
    }
    return decoded;
  }

  /// Live `/api/plugins/kanban/events` stream authenticated with a single-use
  /// WebSocket ticket. Callers always keep a REST polling fallback.
  Future<WebSocket> openKanbanEventsSocket({
    String? board,
    int? since,
    required void Function() check,
  }) async {
    final profile = _effectiveKanbanProfile();
    final validBoard = _validKanbanBoard(board);
    final base = Uri.parse(_baseUrl);
    if (base.scheme != 'https' &&
        !(base.scheme == 'http' &&
            const {'127.0.0.1', '::1', 'localhost'}.contains(base.host))) {
      throw const FormatException('Unsafe kanban events origin');
    }
    check();
    final ticket = await mintWebSocketTicket();
    if (!RegExp(r'^[A-Za-z0-9_.-]{1,512}$').hasMatch(ticket)) {
      throw const FormatException('Invalid WebSocket ticket');
    }
    check();
    final uri = base.replace(
      scheme: base.scheme == 'https' ? 'wss' : 'ws',
      pathSegments: [
        ...base.pathSegments.where((s) => s.isNotEmpty),
        'api',
        'plugins',
        'kanban',
        'events',
      ],
      queryParameters: {
        'profile': profile,
        'board': ?validBoard,
        if (since != null && since >= 0) 'since': '$since',
        'ticket': ticket,
      },
    );
    final httpClient = _TerminalUpgrade(_upgradeClient(), check);
    var opened = false;
    try {
      final socket = await WebSocket.connect(
        uri.toString(),
        customClient: httpClient,
        headers: {
          ...HermesSignInVault.instance.accessHeadersFor(uri),
          'Origin': base.origin,
        },
      ).timeout(const Duration(seconds: 10));
      opened = true;
      unawaited(socket.done.whenComplete(() => httpClient.close(force: true)));
      try {
        check();
      } catch (_) {
        unawaited(socket.close(WebSocketStatus.normalClosure));
        rethrow;
      }
      return socket;
    } finally {
      if (!opened) httpClient.close(force: true);
    }
  }

  /// Single-use `/api/display/ws` RFB upgrade for Bot Desktop (`F11`).
  /// Only `display.observe` mints [displayTicket]; no bearer or cookie is sent.
  Future<WebSocket> openBotDisplaySocket({
    required String displayTicket,
    required void Function() check,
  }) async {
    final base = Uri.parse(_baseUrl);
    if (base.scheme != 'https' &&
        !(base.scheme == 'http' &&
            const {'127.0.0.1', '::1', 'localhost'}.contains(base.host))) {
      throw const FormatException('Unsafe display origin');
    }
    if (!RegExp(r'^[A-Za-z0-9_.-]{1,512}$').hasMatch(displayTicket)) {
      throw const FormatException('Invalid display ticket');
    }
    check();
    final uri = base.replace(
      scheme: base.scheme == 'https' ? 'wss' : 'ws',
      pathSegments: [
        ...base.pathSegments.where((s) => s.isNotEmpty),
        'api',
        'display',
        'ws',
      ],
      queryParameters: {'display_ticket': displayTicket},
    );
    final httpClient = _TerminalUpgrade(_upgradeClient(), check);
    var opened = false;
    try {
      final socket = await WebSocket.connect(
        uri.toString(),
        customClient: httpClient,
        headers: {
          ...HermesSignInVault.instance.accessHeadersFor(uri),
          'Origin': base.origin,
        },
      ).timeout(const Duration(seconds: 10));
      opened = true;
      unawaited(socket.done.whenComplete(() => httpClient.close(force: true)));
      try {
        check();
      } catch (_) {
        unawaited(socket.close(WebSocketStatus.normalClosure));
        rethrow;
      }
      return socket;
    } finally {
      if (!opened) httpClient.close(force: true);
    }
  }
}

String _extractKanbanErrorDetail(Uint8List rawBytes) {
  if (rawBytes.isEmpty) return '';
  try {
    final decoded = jsonDecode(utf8.decode(rawBytes, allowMalformed: true));
    if (decoded is Map) {
      final detail = decoded['detail'] ?? decoded['error'] ?? decoded['reason'];
      if (detail is String) {
        final clean = detail.replaceAll(RegExp(r'[\x00-\x1f\x7f]'), ' ').trim();
        return clean.length > 240 ? '${clean.substring(0, 240)}…' : clean;
      }
    }
  } catch (_) {}
  return '';
}

({
  String method,
  List<String> segments,
  Map<String, String> query,
  Map<String, Object?>? body,
  String? boardScoped,
})
_kanbanPlan(String profile, KanbanDashboardRequest spec) {
  List<String> path(List<String> suffix) => ['plugins', 'kanban', ...suffix];

  switch (spec) {
    case KanbanBoardsRead(:final includeArchived):
      return (
        method: 'GET',
        segments: path(['boards']),
        query: {
          'profile': profile,
          if (includeArchived) 'include_archived': 'true',
        },
        body: null,
        boardScoped: null,
      );
    case KanbanBoardCreate(
      :final slug,
      :final name,
      :final projectId,
      :final defaultWorkdir,
    ):
      final validSlug = _validKanbanBoard(slug);
      final trimmedName = name.trim();
      if (validSlug == null ||
          trimmedName.isEmpty ||
          trimmedName.length > 120) {
        throw const FormatException('Invalid board create');
      }
      return (
        method: 'POST',
        segments: path(['boards']),
        query: {'profile': profile},
        body: {
          'slug': validSlug,
          'name': trimmedName,
          if (projectId != null && projectId.isNotEmpty)
            'project_id': projectId,
          if (defaultWorkdir != null && defaultWorkdir.isNotEmpty)
            'default_workdir': defaultWorkdir,
        },
        boardScoped: null,
      );
    case KanbanBoardPatch(
      :final slug,
      :final name,
      :final description,
      :final icon,
      :final color,
      :final defaultWorkdir,
      :final projectId,
    ):
      final validSlug = _validKanbanBoard(slug);
      if (validSlug == null) throw const FormatException('Invalid board slug');
      return (
        method: 'PATCH',
        segments: path(['boards', validSlug]),
        query: {'profile': profile},
        body: {
          if (name != null) 'name': name.trim(),
          'description': ?description,
          'icon': ?icon,
          'color': ?color,
          'default_workdir': ?defaultWorkdir,
          'project_id': ?projectId,
        },
        boardScoped: validSlug,
      );
    case KanbanBoardArchive(:final slug):
      final validSlug = _validKanbanBoard(slug);
      if (validSlug == null || validSlug == 'default') {
        throw const FormatException('Cannot archive default board');
      }
      return (
        method: 'DELETE',
        segments: path(['boards', validSlug]),
        query: {'profile': profile},
        body: null,
        boardScoped: validSlug,
      );
    case KanbanBoardExport(
      :final slug,
      :final output,
      :final attachments,
      :final logs,
    ):
      final validSlug = _validKanbanBoard(slug);
      if (validSlug == null) throw const FormatException('Invalid board slug');
      return (
        method: 'POST',
        segments: path(['boards', validSlug, 'export']),
        query: {'profile': profile},
        body: {
          'output': output?.trim() ?? '',
          'attachments': attachments,
          'logs': logs,
        },
        boardScoped: validSlug,
      );
    case KanbanBoardImport(:final archive, :final slug):
      final trimmed = archive.trim();
      if (trimmed.isEmpty || RegExp(r'[\x00-\x1f\x7f]').hasMatch(trimmed)) {
        throw const FormatException('Invalid archive path');
      }
      final validSlug = _validKanbanBoard(slug);
      return (
        method: 'POST',
        segments: path(['boards', 'import']),
        query: {'profile': profile},
        body: {'archive': trimmed, 'slug': ?validSlug},
        boardScoped: null,
      );
    case KanbanBoardSnapshotRead(:final board, :final includeArchived):
      final validBoard = _validKanbanBoard(board);
      return (
        method: 'GET',
        segments: path(['board']),
        query: {
          'profile': profile,
          'board': ?validBoard,
          if (includeArchived) 'include_archived': 'true',
        },
        body: null,
        boardScoped: validBoard,
      );
    case KanbanProfilesRead():
      return (
        method: 'GET',
        segments: path(['profiles']),
        query: {'profile': profile},
        body: null,
        boardScoped: null,
      );
    case KanbanProfilePatch(:final name, :final description):
      final validName = _validKanbanProfile(name);
      return (
        method: 'PATCH',
        segments: path(['profiles', validName]),
        query: {'profile': profile},
        body: {'description': description},
        boardScoped: null,
      );
    case KanbanProfileDescribeAuto(:final name):
      final validName = _validKanbanProfile(name);
      return (
        method: 'POST',
        segments: path(['profiles', validName, 'describe-auto']),
        query: {'profile': profile},
        body: {'overwrite': true},
        boardScoped: null,
      );
    case KanbanProjectsRead():
      return (
        method: 'GET',
        segments: path(['projects']),
        query: {'profile': profile},
        body: null,
        boardScoped: null,
      );
    case KanbanOrchestrationRead():
      return (
        method: 'GET',
        segments: path(['orchestration']),
        query: {'profile': profile},
        body: null,
        boardScoped: null,
      );
    case KanbanOrchestrationSave(
      :final orchestratorProfile,
      :final defaultAssignee,
      :final autoDecompose,
    ):
      if (orchestratorProfile != null &&
          orchestratorProfile.isNotEmpty &&
          _validKanbanProfile(orchestratorProfile).isEmpty) {
        throw const FormatException('Invalid orchestrator');
      }
      if (defaultAssignee != null &&
          defaultAssignee.isNotEmpty &&
          _validKanbanProfile(defaultAssignee).isEmpty) {
        throw const FormatException('Invalid default assignee');
      }
      return (
        method: 'PUT',
        segments: path(['orchestration']),
        query: {'profile': profile},
        body: {
          'orchestrator_profile': ?orchestratorProfile,
          'default_assignee': ?defaultAssignee,
          'auto_decompose': ?autoDecompose,
        },
        boardScoped: null,
      );
    case KanbanDispatchNudge(:final board):
      final validBoard = _validKanbanBoard(board);
      return (
        method: 'POST',
        segments: path(['dispatch']),
        query: {'profile': profile, 'board': ?validBoard},
        body: const <String, Object?>{},
        boardScoped: validBoard,
      );
    case KanbanTaskRead(:final taskId, :final board):
      final validTask = _validKanbanTask(taskId);
      final validBoard = _validKanbanBoard(board);
      return (
        method: 'GET',
        segments: path(['tasks', validTask]),
        query: {'profile': profile, 'board': ?validBoard},
        body: null,
        boardScoped: validBoard,
      );
    case KanbanTaskLogRead(:final taskId, :final board, :final tail):
      final validTask = _validKanbanTask(taskId);
      final validBoard = _validKanbanBoard(board);
      final clampedTail = tail.clamp(512, 65536);
      return (
        method: 'GET',
        segments: path(['tasks', validTask, 'log']),
        query: {
          'profile': profile,
          'board': ?validBoard,
          'tail': '$clampedTail',
        },
        body: null,
        boardScoped: validBoard,
      );
    case KanbanTaskCreate(
      :final board,
      :final title,
      :final body,
      :final assignee,
      :final tenant,
      :final priority,
      :final workspaceKind,
      :final workspacePath,
      :final parents,
      :final triage,
      :final skills,
      :final goalMode,
      :final goalMaxTurns,
      :final modelOverride,
      :final providerOverride,
      :final reasoningEffort,
      :final projectId,
    ):
      final validBoard = _validKanbanBoard(board);
      final trimmedTitle = title.trim();
      if (trimmedTitle.isEmpty || trimmedTitle.length > 400) {
        throw const FormatException('Invalid task title');
      }
      if (assignee != null && assignee.isNotEmpty) {
        _validKanbanProfile(assignee);
      }
      if (workspaceKind != null &&
          !const {'scratch', 'worktree', 'dir'}.contains(workspaceKind)) {
        throw const FormatException('Invalid workspace kind');
      }
      final parentList = parents?.map(_validKanbanTask).toList();
      return (
        method: 'POST',
        segments: path(['tasks']),
        query: {'profile': profile, 'board': ?validBoard},
        body: {
          'title': trimmedTitle,
          if (body != null && body.trim().isNotEmpty) 'body': body,
          if (assignee != null && assignee.isNotEmpty) 'assignee': assignee,
          if (tenant != null && tenant.trim().isNotEmpty)
            'tenant': tenant.trim(),
          'priority': ?priority,
          'workspace_kind': ?workspaceKind,
          if (workspacePath != null && workspacePath.trim().isNotEmpty)
            'workspace_path': workspacePath.trim(),
          if (parentList != null && parentList.isNotEmpty)
            'parents': parentList,
          if (triage) 'triage': true,
          'skills': ?skills,
          if (goalMode) 'goal_mode': true,
          if (goalMaxTurns != null && goalMaxTurns > 0)
            'goal_max_turns': goalMaxTurns,
          if (modelOverride != null && modelOverride.trim().isNotEmpty)
            'model_override': modelOverride.trim(),
          if (providerOverride != null && providerOverride.trim().isNotEmpty)
            'provider_override': providerOverride.trim(),
          if (reasoningEffort != null && reasoningEffort.trim().isNotEmpty)
            'reasoning_effort': reasoningEffort.trim(),
          'project_id': ?projectId,
        },
        boardScoped: validBoard,
      );
    case KanbanTaskPatch(
      :final taskId,
      :final board,
      :final status,
      :final assignee,
      :final priority,
      :final title,
      :final body,
      :final result,
      :final blockReason,
      :final summary,
      :final modelOverride,
      :final providerOverride,
      :final clearModelOverride,
      :final reasoningEffort,
      :final clearReasoningEffort,
    ):
      final validTask = _validKanbanTask(taskId);
      final validBoard = _validKanbanBoard(board);
      if (assignee != null && assignee.isNotEmpty) {
        _validKanbanProfile(assignee);
      }
      return (
        method: 'PATCH',
        segments: path(['tasks', validTask]),
        query: {'profile': profile, 'board': ?validBoard},
        body: {
          'status': ?status,
          'assignee': ?assignee,
          'priority': ?priority,
          'title': ?title,
          'body': ?body,
          'result': ?result,
          'block_reason': ?blockReason,
          'summary': ?summary,
          'model_override': ?modelOverride,
          'provider_override': ?providerOverride,
          if (clearModelOverride) 'clear_model_override': true,
          'reasoning_effort': ?reasoningEffort,
          if (clearReasoningEffort) 'clear_reasoning_effort': true,
        },
        boardScoped: validBoard,
      );
    case KanbanTaskDelete(:final taskId, :final board):
      final validTask = _validKanbanTask(taskId);
      final validBoard = _validKanbanBoard(board);
      return (
        method: 'DELETE',
        segments: path(['tasks', validTask]),
        query: {'profile': profile, 'board': ?validBoard},
        body: null,
        boardScoped: validBoard,
      );
    case KanbanTasksBulk(
      :final board,
      :final ids,
      :final status,
      :final assignee,
      :final priority,
      :final archive,
      :final reclaimFirst,
      :final modelOverride,
      :final providerOverride,
      :final clearModelOverride,
      :final reasoningEffort,
      :final clearReasoningEffort,
    ):
      if (ids.isEmpty || ids.length > 200) {
        throw const FormatException('Invalid bulk task selection');
      }
      final validIds = ids.map(_validKanbanTask).toList();
      final validBoard = _validKanbanBoard(board);
      if (assignee != null && assignee.isNotEmpty) {
        _validKanbanProfile(assignee);
      }
      return (
        method: 'POST',
        segments: path(['tasks', 'bulk']),
        query: {'profile': profile, 'board': ?validBoard},
        body: {
          'ids': validIds,
          'status': ?status,
          'assignee': ?assignee,
          'priority': ?priority,
          'archive': ?archive,
          'reclaim_first': ?reclaimFirst,
          'model_override': ?modelOverride,
          'provider_override': ?providerOverride,
          if (clearModelOverride) 'clear_model_override': true,
          'reasoning_effort': ?reasoningEffort,
          if (clearReasoningEffort) 'clear_reasoning_effort': true,
        },
        boardScoped: validBoard,
      );
    case KanbanTaskComment(
      :final taskId,
      :final board,
      :final body,
      :final author,
    ):
      final validTask = _validKanbanTask(taskId);
      final validBoard = _validKanbanBoard(board);
      final trimmed = body.trim();
      if (trimmed.isEmpty) throw const FormatException('Empty comment');
      return (
        method: 'POST',
        segments: path(['tasks', validTask, 'comments']),
        query: {'profile': profile, 'board': ?validBoard},
        body: {'body': trimmed, 'author': author},
        boardScoped: validBoard,
      );
    case KanbanTaskReassign(
      :final taskId,
      :final board,
      profile: final targetProfile,
      :final reclaimFirst,
      :final reason,
    ):
      final validTask = _validKanbanTask(taskId);
      final validBoard = _validKanbanBoard(board);
      final validTarget = _validKanbanProfile(targetProfile);
      return (
        method: 'POST',
        segments: path(['tasks', validTask, 'reassign']),
        query: {'profile': profile, 'board': ?validBoard},
        body: {
          'profile': validTarget,
          'reclaim_first': reclaimFirst,
          if (reason != null && reason.trim().isNotEmpty)
            'reason': reason.trim(),
        },
        boardScoped: validBoard,
      );
    case KanbanTaskReclaim(:final taskId, :final board):
      final validTask = _validKanbanTask(taskId);
      final validBoard = _validKanbanBoard(board);
      return (
        method: 'POST',
        segments: path(['tasks', validTask, 'reclaim']),
        query: {'profile': profile, 'board': ?validBoard},
        body: const <String, Object?>{},
        boardScoped: validBoard,
      );
    case KanbanTaskEstimateRequest(:final taskId, :final board):
      final validTask = _validKanbanTask(taskId);
      final validBoard = _validKanbanBoard(board);
      return (
        method: 'POST',
        segments: path(['tasks', validTask, 'estimate']),
        query: {'profile': profile, 'board': ?validBoard},
        body: const <String, Object?>{},
        boardScoped: validBoard,
      );
    case KanbanDraftEstimate(:final title, :final body):
      final trimmed = title.trim();
      if (trimmed.isEmpty) throw const FormatException('Title required');
      return (
        method: 'POST',
        segments: path(['estimate']),
        query: {'profile': profile},
        body: {
          'title': trimmed,
          if (body != null && body.trim().isNotEmpty) 'body': body,
        },
        boardScoped: null,
      );
    case KanbanTaskDecompose(:final taskId, :final board, :final author):
      final validTask = _validKanbanTask(taskId);
      final validBoard = _validKanbanBoard(board);
      return (
        method: 'POST',
        segments: path(['tasks', validTask, 'decompose']),
        query: {'profile': profile, 'board': ?validBoard},
        body: {'author': author},
        boardScoped: validBoard,
      );
    case KanbanLinkAdd(:final board, :final parentId, :final childId):
      final validBoard = _validKanbanBoard(board);
      final validParent = _validKanbanTask(parentId);
      final validChild = _validKanbanTask(childId);
      if (validParent == validChild) {
        throw const FormatException('Self-link not allowed');
      }
      return (
        method: 'POST',
        segments: path(['links']),
        query: {'profile': profile, 'board': ?validBoard},
        body: {'parent_id': validParent, 'child_id': validChild},
        boardScoped: validBoard,
      );
    case KanbanLinkRemove(:final board, :final parentId, :final childId):
      final validBoard = _validKanbanBoard(board);
      final validParent = _validKanbanTask(parentId);
      final validChild = _validKanbanTask(childId);
      return (
        method: 'DELETE',
        segments: path(['links']),
        query: {
          'profile': profile,
          'board': ?validBoard,
          'parent_id': validParent,
          'child_id': validChild,
        },
        body: null,
        boardScoped: validBoard,
      );
  }
}
