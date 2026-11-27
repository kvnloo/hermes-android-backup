part of 'remote_workspace.dart';

class RemoteHostStatus {
  const RemoteHostStatus({
    required this.running,
    required this.version,
    required this.activeSessions,
    required this.state,
    required this.heartbeatStaleSeconds,
    required this.sharedWith,
  });

  final bool running;
  final String version;
  final int activeSessions;
  final String? state;
  final num? heartbeatStaleSeconds;
  final List<String> sharedWith;
}

class RemoteHostLogs {
  const RemoteHostLogs({required this.file, required this.lines});
  final String file;
  final List<String> lines;
}

class RemoteComputerUseCheck {
  const RemoteComputerUseCheck(this.label, this.status, this.message);
  final String label, status, message;
}

class RemoteComputerUse {
  const RemoteComputerUse({
    required this.platform,
    required this.platformSupported,
    required this.installed,
    required this.ready,
    required this.canGrant,
    required this.checks,
    required this.accessibility,
    required this.screenRecording,
    required this.error,
  });

  final String platform;
  final bool platformSupported, installed, canGrant;
  final bool? ready, accessibility, screenRecording;
  final List<RemoteComputerUseCheck> checks;
  final String? error;
}

class RemoteCuratorStatus {
  const RemoteCuratorStatus({
    required this.enabled,
    required this.paused,
    required this.lastRunAt,
  });

  final bool enabled, paused;
  final String? lastRunAt;
}

class RemoteActionStatus {
  const RemoteActionStatus({
    required this.name,
    required this.running,
    required this.exitCode,
    required this.lines,
    required this.actionId,
    required this.receipt,
  });

  final String name;
  final bool running;
  final int? exitCode;
  final List<String> lines;
  final String? actionId;
  final HostUpdateReceipt? receipt;
}

class RemoteUpdateLaunch {
  const RemoteUpdateLaunch.started(this.actionId, {this.alreadyRunning = false})
    : refused = null;
  const RemoteUpdateLaunch.refused(this.refused)
    : actionId = null,
      alreadyRunning = false;

  final String? actionId;
  final bool alreadyRunning;
  final String? refused;
}

class DiagnosticShare {
  const DiagnosticShare({
    required this.redacted,
    required this.urls,
    required this.failures,
  });

  final bool redacted;
  final Map<String, String> urls;
  final List<String> failures;
}

class RemoteCronJob {
  const RemoteCronJob({
    required this.id,
    required this.profile,
    required this.name,
    required this.enabled,
    required this.catchUp,
    required this.deliver,
    required this.runInFlight,
  });

  final String id, profile, name, deliver;
  final bool enabled, runInFlight;
  final bool? catchUp;
}

class RemoteBlueprintField {
  const RemoteBlueprintField({
    required this.name,
    required this.type,
    required this.label,
    required this.help,
    required this.defaultValue,
    required this.options,
    required this.optional,
  });

  final String name, type, label, help;
  final String? defaultValue;
  final List<String> options;
  final bool optional;
}

class RemoteBlueprint {
  const RemoteBlueprint({
    required this.key,
    required this.title,
    required this.description,
    required this.source,
    required this.fields,
  });

  final String key, title, description;
  final String? source;
  final List<RemoteBlueprintField> fields;
}

class RemoteDeliveryTarget {
  const RemoteDeliveryTarget({
    required this.id,
    required this.name,
    required this.homeTargetSet,
  });

  final String id, name;
  final bool homeTargetSet;
}

class MemoryGraphNode {
  const MemoryGraphNode({
    required this.id,
    required this.label,
    required this.kind,
    required this.category,
    required this.timestamp,
    required this.useCount,
    required this.state,
    required this.pinned,
  });

  final String id, label, kind, category, state;
  final int? timestamp;
  final int useCount;
  final bool pinned;
}

class MemoryGraph {
  const MemoryGraph({required this.nodes, required this.edges});
  final List<MemoryGraphNode> nodes;
  final List<({String source, String target})> edges;
}

class MemoryNodeDetail {
  const MemoryNodeDetail({
    required this.id,
    required this.kind,
    required this.label,
    required this.content,
  });

  final String id, kind, label, content;
}

class MemoryProviderSummary {
  const MemoryProviderSummary({
    required this.name,
    required this.description,
    required this.status,
    required this.available,
    required this.configured,
  });

  final String name, description, status;
  final bool available, configured;
}

class MemoryLayerStatus {
  const MemoryLayerStatus({
    required this.active,
    required this.memoryBytes,
    required this.userBytes,
    required this.providers,
  });

  final String active;
  final int memoryBytes, userBytes;
  final List<MemoryProviderSummary> providers;
}

class MemoryProviderField {
  const MemoryProviderField({
    required this.key,
    required this.label,
    required this.kind,
    required this.isSet,
    required this.options,
    this.value = '',
  });

  final String key, label, kind, value;
  final bool isSet;
  final List<String> options;
}

class MemoryProviderConfig {
  const MemoryProviderConfig({
    required this.name,
    required this.label,
    required this.fields,
  });

  final String name, label;
  final List<MemoryProviderField> fields;
}

Map<String, dynamic> _hostObject(Object? data) {
  if (data is! Map) _fail(WorkspaceFailure.invalid);
  return data.map((key, value) => MapEntry('$key', value));
}

Future<Map<String, dynamic>> _hostCall(
  WorkspaceTarget target,
  HostDashboardRequest request, {
  Future<void> Function()? beforeSend,
}) async {
  final data = await target._owner._dashboard.hostExchange(
    request,
    check: target.checkCurrent,
    beforeSend: beforeSend,
  );
  return _hostObject(data);
}

/// Nothing was sent. The caller may retry once the installation is idle.
final class _HostUpdateHeld implements Exception {
  const _HostUpdateHeld(this.launch);
  final RemoteUpdateLaunch launch;
}

/// Busy or unidentified installations are not updated. active_sessions is
/// the installation-wide count, and a missing install id blocks.
Future<RemoteUpdateLaunch?> _hostUpdateAdmission(WorkspaceTarget target) async {
  final map = await _hostCall(target, const HostStatusRead());
  target.checkCurrent();
  final install = map['install_id'];
  final sessions = map['active_sessions'];
  if (install is! String || install.isEmpty || sessions is! int) {
    return const RemoteUpdateLaunch.refused(
      'This installation is unknown, so the update was not sent',
    );
  }
  final agents = map['active_agents'];
  if (sessions > 0 ||
      map['gateway_busy'] == true ||
      (agents is int && agents > 0)) {
    return const RemoteUpdateLaunch.refused(
      'A chat on this installation is running',
    );
  }
  return null;
}

bool _hostBool(Object? value) {
  if (value is! bool) _fail(WorkspaceFailure.invalid);
  return value;
}

bool? _hostBoolOrNull(Object? value) {
  if (value == null) return null;
  return _hostBool(value);
}

List<String> _hostLines(Object? value) {
  if (value is! List || value.any((line) => line is! String)) {
    _fail(WorkspaceFailure.invalid);
  }
  return [for (final line in value.take(200)) line as String];
}

HostUpdateReceipt? _hostReceipt(Object? value) {
  if (value == null) return null;
  final map = _hostObject(value);
  final followups = map['followups'];
  final steps = <String>[];
  if (followups != null) {
    if (followups is! List) _fail(WorkspaceFailure.invalid);
    for (final row in followups) {
      if (row is! Map || row['step'] is! String) {
        _fail(WorkspaceFailure.invalid);
      }
      steps.add(row['step'] as String);
    }
  }
  final actionId = map['action_id'];
  if (actionId != null && actionId is! String) _fail(WorkspaceFailure.invalid);
  final outcome = map['outcome'];
  if (outcome is! String) _fail(WorkspaceFailure.invalid);
  return HostUpdateReceipt(
    actionId: actionId as String?,
    outcome: outcome,
    followups: steps,
  );
}

void _ownJob(WorkspaceTarget target, RemoteCronJob job) {
  if (!isProfileId(job.profile) ||
      target.effectiveProfile != job.profile ||
      target.route.profile != job.profile) {
    _fail(WorkspaceFailure.mismatch);
  }
}

RemoteCronJob _cronJob(Object? row) {
  final map = _hostObject(row);
  final id = map['id'];
  final named = map['profile'] ?? map['profile_name'];
  if (id is! String ||
      !RegExp(r'^[A-Za-z0-9][A-Za-z0-9_-]{0,80}$').hasMatch(id) ||
      named is! String ||
      !isProfileId(named)) {
    _fail(WorkspaceFailure.invalid);
  }
  if (map['profile'] is String &&
      map['profile_name'] is String &&
      map['profile'] != map['profile_name']) {
    _fail(WorkspaceFailure.mismatch);
  }
  bool inFlight(Object? execution) {
    if (execution == null) return false;
    final status = _hostObject(execution)['status'];
    return status == 'claimed' || status == 'running';
  }

  final catchUp = map['catch_up'];
  if (catchUp != null && catchUp is! bool) _fail(WorkspaceFailure.invalid);
  final deliver = map['deliver'];
  if (deliver != null && deliver is! String) _fail(WorkspaceFailure.invalid);
  final name = map['name'];
  return RemoteCronJob(
    id: id,
    profile: named,
    name: name is String && name.trim().isNotEmpty ? name.trim() : id,
    enabled: _hostBool(map['enabled']),
    catchUp: catchUp as bool?,
    deliver: deliver is String && deliver.isNotEmpty ? deliver : 'local',
    runInFlight:
        inFlight(map['latest_execution']) || inFlight(map['live_execution']),
  );
}

extension RemoteHostOps on WorkspaceTarget {
  Future<RemoteHostStatus> hostStatus() => _withOwner(() async {
    final map = await _hostCall(this, const HostStatusRead());
    final sessions = map['active_sessions'];
    final stale = map['heartbeat_stale_s'] ?? map['gateway_heartbeat_stale_s'];
    final shared = map['gateway_shared_with'];
    if (sessions is! int || (stale != null && stale is! num)) {
      _fail(WorkspaceFailure.invalid);
    }
    final names = <String>[];
    if (shared != null) {
      if (shared is! List) _fail(WorkspaceFailure.invalid);
      for (final name in shared) {
        if (name is! String || !isProfileId(name)) {
          _fail(WorkspaceFailure.invalid);
        }
        names.add(name);
      }
    }
    final state = map['gateway_state'];
    if (state != null && state is! String) _fail(WorkspaceFailure.invalid);
    return RemoteHostStatus(
      running: _hostBool(map['gateway_running']),
      version: map['version'] is String ? map['version'] as String : '',
      activeSessions: sessions,
      state: state as String?,
      heartbeatStaleSeconds: stale as num?,
      sharedWith: names,
    );
  });

  Future<RemoteHostLogs> hostLogs({
    required String file,
    String? level,
    String? search,
  }) => _withOwner(() async {
    final map = await _hostCall(
      this,
      HostLogRead(file: file, level: level, search: search),
    );
    if (map['file'] != file) _fail(WorkspaceFailure.mismatch);
    return RemoteHostLogs(file: file, lines: _hostLines(map['lines']));
  });

  Future<RemoteComputerUse> computerUse() => _withOwner(() async {
    final map = await _hostCall(this, const HostComputerUseRead());
    final checks = map['checks'];
    if (checks is! List) _fail(WorkspaceFailure.invalid);
    return RemoteComputerUse(
      platform: map['platform'] is String ? map['platform'] as String : '',
      platformSupported: _hostBool(map['platform_supported']),
      installed: _hostBool(map['installed']),
      ready: _hostBoolOrNull(map['ready']),
      canGrant: map['can_grant'] == true,
      accessibility: _hostBoolOrNull(map['accessibility']),
      screenRecording: _hostBoolOrNull(map['screen_recording']),
      error: map['error'] is String ? map['error'] as String : null,
      checks: [
        for (final row in checks)
          RemoteComputerUseCheck(
            _hostObject(row)['label'] is String
                ? _hostObject(row)['label'] as String
                : '',
            _hostObject(row)['status'] is String
                ? _hostObject(row)['status'] as String
                : '',
            _hostObject(row)['message'] is String
                ? _hostObject(row)['message'] as String
                : '',
          ),
      ],
    );
  });

  Future<HostUpdateEligibility> updateEligibility({bool force = false}) =>
      _withOwner(() async {
        final map = await _hostCall(this, HostUpdateCheck(force: force));
        final behind = map['behind'];
        if (behind != null && behind is! int) _fail(WorkspaceFailure.invalid);
        final held = map['held'];
        if (held != null && held is! String) _fail(WorkspaceFailure.invalid);
        return HostUpdateEligibility(
          installMethod: map['install_method'] is String
              ? map['install_method'] as String
              : 'unknown',
          currentVersion: map['current_version'] is String
              ? map['current_version'] as String
              : '',
          behind: behind as int?,
          updateAvailable: map['update_available'] == true,
          canApply: map['can_apply'] == true,
          held: held as String?,
          message: map['message'] is String ? map['message'] as String : null,
        );
      });

  Future<RemoteUpdateLaunch> startHostUpdate() => _withOwner(() async {
    final eligibility = await updateEligibility();
    checkCurrent();
    if (!hostUpdateMayStart(eligibility)) _fail(WorkspaceFailure.denied);
    // Per installation, same rule as fleet 192dbc2e: a busy chat holds the
    // update, and an unknown install blocks. Rechecked after auth, immediately
    // before the POST leaves.
    final held = await _hostUpdateAdmission(this);
    if (held != null) return held;
    final Map<String, dynamic> map;
    try {
      map = await _hostCall(
        this,
        const HostUpdateStartRequest(),
        beforeSend: () async {
          final again = await _hostUpdateAdmission(this);
          if (again != null) throw _HostUpdateHeld(again);
        },
      );
    } on _HostUpdateHeld catch (held) {
      return held.launch;
    }
    if (map['name'] != 'hermes-update') _fail(WorkspaceFailure.invalid);
    if (map['ok'] != true) {
      final message = map['message'];
      return RemoteUpdateLaunch.refused(
        message is String ? message : 'Remote update refused',
      );
    }
    final actionId = map['action_id'];
    if (actionId is! String || !RegExp(r'^[0-9a-f]{32}$').hasMatch(actionId)) {
      _fail(WorkspaceFailure.invalid);
    }
    return RemoteUpdateLaunch.started(
      actionId,
      alreadyRunning: map['already_running'] == true,
    );
  });

  Future<RemoteActionStatus> actionStatus(String name) => _withOwner(() async {
    final map = await _hostCall(this, HostActionStatusRead(name));
    if (map['name'] != name) _fail(WorkspaceFailure.mismatch);
    final exitCode = map['exit_code'];
    if (exitCode != null && exitCode is! int) _fail(WorkspaceFailure.invalid);
    final running = _hostBool(map['running']);
    final actionId = map['action_id'];
    if (actionId != null && actionId is! String) {
      _fail(WorkspaceFailure.invalid);
    }
    final receipt = _hostReceipt(map['receipt']);
    // A live update omits action_id and still returns the previous run's
    // receipt. That is waiting, not a substituted receipt. A status that
    // names an action_id the receipt does not match still is.
    if (receipt != null && actionId is String && receipt.actionId != actionId) {
      _fail(WorkspaceFailure.mismatch);
    }
    return RemoteActionStatus(
      name: name,
      running: running,
      exitCode: exitCode as int?,
      lines: _hostLines(map['lines']),
      actionId: actionId as String?,
      receipt: receipt,
    );
  });

  Future<HostUpdateVerdict> hostUpdateVerdict(String actionId) =>
      _withOwner(() async {
        final status = await actionStatus('hermes-update');
        checkCurrent();
        return judgeHostUpdate(
          actionId: actionId,
          running: status.running,
          receipt: status.receipt,
        );
      });

  Future<RemoteUpdateLaunch> restartHost() => _withOwner(() async {
    final map = await _hostCall(this, const HostRestartStart());
    if (map['ok'] != true || map['name'] != 'gateway-restart') {
      _fail(WorkspaceFailure.invalid);
    }
    return const RemoteUpdateLaunch.started('gateway-restart');
  });

  Future<RemoteActionStatus> startMaintenance(String name) =>
      _withOwner(() async {
        final request = switch (name) {
          'doctor' => const HostDoctorStart(),
          'security-audit' => const HostSecurityAuditStart(),
          'curator-run' => const HostCuratorRun(),
          _ => null,
        };
        if (request == null) _fail(WorkspaceFailure.invalid);
        final map = await _hostCall(this, request);
        if (map['ok'] != true || map['name'] != name) {
          _fail(WorkspaceFailure.invalid);
        }
        return actionStatus(name);
      });

  Future<RemoteCuratorStatus> curatorStatus() => _withOwner(() async {
    final map = await _hostCall(this, const HostCuratorRead());
    final last = map['last_run_at'];
    if (last != null && last is! String) _fail(WorkspaceFailure.invalid);
    return RemoteCuratorStatus(
      enabled: _hostBool(map['enabled']),
      paused: _hostBool(map['paused']),
      lastRunAt: last as String?,
    );
  });

  Future<RemoteCuratorStatus> setCuratorPaused(bool paused) =>
      _withOwner(() async {
        final map = await _hostCall(this, HostCuratorPause(paused));
        if (map['ok'] != true || map['paused'] != paused) {
          _fail(WorkspaceFailure.mismatch);
        }
        return curatorStatus();
      });

  Future<List<String>> resetMemoryFiles(String target) => _withOwner(() async {
    final map = await _hostCall(this, HostMemoryReset(target));
    if (map['ok'] != true || map['deleted'] is! List) {
      _fail(WorkspaceFailure.invalid);
    }
    return [
      for (final item in map['deleted'] as List)
        if (item is String) item,
    ];
  });

  Future<DiagnosticShare> shareDiagnostics({required bool consent}) {
    if (!consent) {
      throw const FormatException('Diagnostic share needs consent');
    }
    return _withOwner(() async {
      final map = await _hostCall(this, const HostDebugShare());
      final failures = map['failures'];
      final failureText = <String>[];
      if (failures is Map) {
        for (final entry in failures.entries) {
          if (entry.value is String) failureText.add('${entry.key}');
        }
      }
      if (map['redacted'] != true) {
        return DiagnosticShare(
          redacted: false,
          urls: const {},
          failures: failureText,
        );
      }
      final urls = map['urls'];
      if (urls is! Map) _fail(WorkspaceFailure.invalid);
      return DiagnosticShare(
        redacted: true,
        urls: {
          for (final entry in urls.entries)
            if (entry.key is String && entry.value is String)
              entry.key as String: entry.value as String,
        },
        failures: failureText,
      );
    });
  }
}

extension RemoteScheduleDesk on WorkspaceTarget {
  Future<List<RemoteCronJob>> allSchedules() => _withOwner(() async {
    final data = await _owner._dashboard.hostExchange(
      const HostAllSchedulesRead(),
      check: checkCurrent,
    );
    if (data is! List) _fail(WorkspaceFailure.invalid);
    return [for (final row in data) _cronJob(row)];
  });

  Future<RemoteCronJob> _readJob(RemoteCronJob job) async {
    final after = _cronJob(await _hostCall(this, HostScheduleRead(job.id)));
    if (after.id != job.id || after.profile != job.profile) {
      _fail(WorkspaceFailure.mismatch);
    }
    return after;
  }

  Future<bool> stopCurrentRun(RemoteCronJob job) => _withOwner(() async {
    _ownJob(this, job);
    if (!job.runInFlight) _fail(WorkspaceFailure.invalid);
    final map = await _hostCall(this, HostScheduleCancel(job.id));
    if (map['job_id'] != job.id || map['cancelled'] is! bool) {
      _fail(WorkspaceFailure.invalid);
    }
    return map['cancelled'] as bool;
  });

  Future<RemoteCronJob> setFutureRuns(
    RemoteCronJob job, {
    required bool resume,
  }) => _withOwner(() async {
    _ownJob(this, job);
    await _hostCall(this, HostSchedulePause(job.id, resume: resume));
    final after = await _readJob(job);
    if (after.enabled != resume) _fail(WorkspaceFailure.mismatch);
    return after;
  });

  Future<RemoteCronJob> setCatchUp(RemoteCronJob job, bool? catchUp) =>
      _withOwner(() async {
        _ownJob(this, job);
        await _hostCall(this, HostScheduleCatchUp(job.id, catchUp));
        final after = await _readJob(job);
        if (after.catchUp != catchUp) _fail(WorkspaceFailure.mismatch);
        return after;
      });

  Future<RemoteCronJob> setDelivery(RemoteCronJob job, String deliver) =>
      _withOwner(() async {
        _ownJob(this, job);
        await _hostCall(this, HostScheduleDeliver(job.id, deliver));
        final after = await _readJob(job);
        if (after.deliver != deliver) _fail(WorkspaceFailure.mismatch);
        return after;
      });

  Future<List<RemoteDeliveryTarget>> deliveryTargets() => _withOwner(() async {
    final map = await _hostCall(this, const HostDeliveryTargetsRead());
    final rows = map['targets'];
    if (rows is! List) _fail(WorkspaceFailure.invalid);
    return [
      for (final row in rows)
        RemoteDeliveryTarget(
          id: () {
            final id = _hostObject(row)['id'];
            if (id is! String ||
                !RegExp(r'^[A-Za-z0-9][A-Za-z0-9_-]{0,40}$').hasMatch(id)) {
              _fail(WorkspaceFailure.invalid);
            }
            return id;
          }(),
          name: _hostObject(row)['name'] is String
              ? _hostObject(row)['name'] as String
              : '',
          homeTargetSet: _hostObject(row)['home_target_set'] == true,
        ),
    ];
  });

  Future<List<RemoteBlueprint>> blueprints() => _withOwner(() async {
    final map = await _hostCall(this, const HostBlueprintRead());
    final rows = map['blueprints'];
    if (rows is! List) _fail(WorkspaceFailure.invalid);
    return [for (final row in rows) _blueprint(row)];
  });

  Future<RemoteCronJob> instantiateBlueprint(
    String key,
    Map<String, String> values,
  ) => _withOwner(() async {
    final profile = effectiveProfile;
    if (profile == null || !isProfileId(profile)) {
      _fail(WorkspaceFailure.unbound);
    }
    final map = await _hostCall(this, HostBlueprintInstantiate(key, values));
    final job = _cronJob(map);
    if (job.profile != profile) _fail(WorkspaceFailure.mismatch);
    return job;
  });
}

RemoteBlueprint _blueprint(Object? row) {
  final map = _hostObject(row);
  final key = map['key'];
  if (key is! String ||
      !RegExp(r'^[A-Za-z0-9][A-Za-z0-9_:-]{0,80}$').hasMatch(key)) {
    _fail(WorkspaceFailure.invalid);
  }
  final fields = map['fields'];
  if (fields is! List) _fail(WorkspaceFailure.invalid);
  return RemoteBlueprint(
    key: key,
    title: map['title'] is String ? map['title'] as String : key,
    description: map['description'] is String
        ? map['description'] as String
        : '',
    source: map['source'] is String ? map['source'] as String : null,
    fields: [
      for (final field in fields)
        RemoteBlueprintField(
          name: () {
            final name = _hostObject(field)['name'];
            if (name is! String ||
                !RegExp(r'^[A-Za-z0-9][A-Za-z0-9_-]{0,80}$').hasMatch(name)) {
              _fail(WorkspaceFailure.invalid);
            }
            return name;
          }(),
          type: _hostObject(field)['type'] is String
              ? _hostObject(field)['type'] as String
              : 'text',
          label: _hostObject(field)['label'] is String
              ? _hostObject(field)['label'] as String
              : '',
          help: _hostObject(field)['help'] is String
              ? _hostObject(field)['help'] as String
              : '',
          defaultValue: _hostObject(field)['default'] is String
              ? _hostObject(field)['default'] as String
              : null,
          options: [
            for (final option in (_hostObject(field)['options'] as List? ?? []))
              if (option is String) option,
          ],
          optional: _hostObject(field)['optional'] == true,
        ),
    ],
  );
}

extension RemoteMemoryGraphOps on WorkspaceTarget {
  Future<MemoryGraph> memoryGraph() => _withOwner(() async {
    final map = await _hostCall(this, const HostLearningGraphRead());
    final nodes = map['nodes'];
    final edges = map['edges'];
    if (nodes is! List || edges is! List) _fail(WorkspaceFailure.invalid);
    return MemoryGraph(
      nodes: [for (final row in nodes) _graphNode(row)],
      edges: [
        for (final row in edges)
          (
            source: () {
              final source = _hostObject(row)['source'];
              if (source is! String) _fail(WorkspaceFailure.invalid);
              return source;
            }(),
            target: () {
              final target = _hostObject(row)['target'];
              if (target is! String) _fail(WorkspaceFailure.invalid);
              return target;
            }(),
          ),
      ],
    );
  });

  Future<MemoryNodeDetail> memoryNode(String id) => _withOwner(() async {
    final map = await _hostCall(this, HostLearningNodeRead(id));
    if (map['ok'] != true) _fail(WorkspaceFailure.invalid);
    final kind = map['kind'];
    if (kind != 'memory' && kind != 'skill') _fail(WorkspaceFailure.invalid);
    return MemoryNodeDetail(
      id: id,
      kind: kind as String,
      label: map['label'] is String ? map['label'] as String : id,
      content: map['content'] is String ? map['content'] as String : '',
    );
  });

  Future<MemoryNodeDetail> saveMemoryNode(String id, String content) =>
      _withOwner(() async {
        final map = await _hostCall(this, HostLearningNodeSave(id, content));
        if (map['ok'] != true) _fail(WorkspaceFailure.invalid);
        final detail = await memoryNode(id);
        if (detail.content != content) _fail(WorkspaceFailure.mismatch);
        return detail;
      });

  Future<void> removeMemoryNode(String id) => _withOwner(() async {
    final map = await _hostCall(this, HostLearningNodeDelete(id));
    if (map['ok'] != true) _fail(WorkspaceFailure.invalid);
    final graph = await memoryGraph();
    if (graph.nodes.any((node) => node.id == id)) {
      _fail(WorkspaceFailure.mismatch);
    }
  });

  Future<MemoryLayerStatus> memoryLayers() => _withOwner(() async {
    final map = await _hostCall(this, const HostMemoryRead());
    final providers = map['providers'];
    final files = _hostObject(map['builtin_files']);
    if (providers is! List ||
        files['memory'] is! int ||
        files['user'] is! int) {
      _fail(WorkspaceFailure.invalid);
    }
    return MemoryLayerStatus(
      active: map['active'] is String ? map['active'] as String : '',
      memoryBytes: files['memory'] as int,
      userBytes: files['user'] as int,
      providers: [
        for (final row in providers)
          MemoryProviderSummary(
            name: () {
              final name = _hostObject(row)['name'];
              if (name is! String || !isProfileId(name)) {
                _fail(WorkspaceFailure.invalid);
              }
              return name;
            }(),
            description: _hostObject(row)['description'] is String
                ? _hostObject(row)['description'] as String
                : '',
            status: _hostObject(row)['status'] is String
                ? _hostObject(row)['status'] as String
                : '',
            available: _hostObject(row)['available'] == true,
            configured: _hostObject(row)['configured'] == true,
          ),
      ],
    );
  });

  Future<MemoryProviderConfig> memoryProviderConfig(String provider) =>
      _withOwner(() async {
        final map = await _hostCall(this, HostMemoryConfigRead(provider));
        final fields = map['fields'];
        if (map['name'] != provider || fields is! List) {
          _fail(WorkspaceFailure.invalid);
        }
        return MemoryProviderConfig(
          name: provider,
          label: map['label'] is String ? map['label'] as String : provider,
          fields: [
            for (final row in fields)
              MemoryProviderField(
                key: () {
                  final key = _hostObject(row)['key'];
                  if (key is! String) _fail(WorkspaceFailure.invalid);
                  return key;
                }(),
                label: _hostObject(row)['label'] is String
                    ? _hostObject(row)['label'] as String
                    : '',
                kind: _hostObject(row)['kind'] is String
                    ? _hostObject(row)['kind'] as String
                    : 'text',
                isSet: _hostObject(row)['is_set'] == true,
                value: () {
                  final value = _hostObject(row)['value'];
                  if (value != null && value is! String) {
                    _fail(WorkspaceFailure.invalid);
                  }
                  return value is String ? value : '';
                }(),
                options: [
                  for (final option
                      in (_hostObject(row)['options'] as List? ?? []))
                    if (option is Map && option['value'] is String)
                      option['value'] as String,
                ],
              ),
          ],
        );
      });

  Future<void> saveMemoryProvider(
    String provider,
    Map<String, String> values,
  ) => _withOwner(() async {
    final map = await _hostCall(this, HostMemoryConfigSave(provider, values));
    if (map['ok'] != true) _fail(WorkspaceFailure.invalid);
  });
}

MemoryGraphNode _graphNode(Object? row) {
  final map = _hostObject(row);
  final id = map['id'];
  final kind = map['kind'];
  if (id is! String ||
      !RegExp(r'^[A-Za-z0-9][A-Za-z0-9_.:-]{0,179}$').hasMatch(id) ||
      (kind != 'memory' && kind != 'skill')) {
    _fail(WorkspaceFailure.invalid);
  }
  final timestamp = map['timestamp'];
  if (timestamp != null && timestamp is! int) _fail(WorkspaceFailure.invalid);
  final useCount = map['useCount'] ?? map['use_count'] ?? 0;
  if (useCount is! int) _fail(WorkspaceFailure.invalid);
  return MemoryGraphNode(
    id: id,
    label: map['label'] is String ? map['label'] as String : id,
    kind: kind as String,
    category: map['category'] is String ? map['category'] as String : '',
    timestamp: timestamp as int?,
    useCount: useCount,
    state: map['state'] is String ? map['state'] as String : '',
    pinned: map['pinned'] == true,
  );
}
