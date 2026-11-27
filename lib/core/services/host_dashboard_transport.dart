part of 'connection_manager.dart';

/// Closed dashboard catalogue for host maintenance, schedules and the memory
/// graph. Callers cannot choose an HTTP method, origin or profile override.
final _hostProfileId = RegExp(r'^[a-z0-9][a-z0-9_-]{0,63}$');
final _hostToken = RegExp(r'^[A-Za-z0-9][A-Za-z0-9_-]{0,80}$');
final _hostNodeId = RegExp(r'^[A-Za-z0-9][A-Za-z0-9_.:-]{0,179}$');
final _hostBlueprint = RegExp(r'^[A-Za-z0-9][A-Za-z0-9_:-]{0,80}$');
final _hostSecretKey = RegExp(
  r'key|token|secret|password',
  caseSensitive: false,
);

const _hostLogFiles = {'agent', 'errors', 'gateway', 'desktop'};
const _hostLogLevels = {'INFO', 'WARNING', 'ERROR'};
const _hostActionNames = {
  'doctor',
  'security-audit',
  'curator-run',
  'gateway-restart',
  'hermes-update',
};
const _memoryResetTargets = {'all', 'memory', 'user'};

sealed class HostDashboardRequest {
  const HostDashboardRequest();
}

final class HostStatusRead extends HostDashboardRequest {
  const HostStatusRead();
}

final class HostLogRead extends HostDashboardRequest {
  const HostLogRead({required this.file, this.level, this.search});
  final String file;
  final String? level;
  final String? search;
}

final class HostComputerUseRead extends HostDashboardRequest {
  const HostComputerUseRead();
}

final class HostUpdateCheck extends HostDashboardRequest {
  const HostUpdateCheck({this.force = false});
  final bool force;
}

final class HostUpdateReceiptRead extends HostDashboardRequest {
  const HostUpdateReceiptRead();
}

final class HostActionStatusRead extends HostDashboardRequest {
  const HostActionStatusRead(this.name);
  final String name;
}

final class HostDoctorStart extends HostDashboardRequest {
  const HostDoctorStart();
}

final class HostSecurityAuditStart extends HostDashboardRequest {
  const HostSecurityAuditStart();
}

final class HostCuratorRead extends HostDashboardRequest {
  const HostCuratorRead();
}

final class HostCuratorPause extends HostDashboardRequest {
  const HostCuratorPause(this.paused);
  final bool paused;
}

final class HostCuratorRun extends HostDashboardRequest {
  const HostCuratorRun();
}

final class HostMemoryReset extends HostDashboardRequest {
  const HostMemoryReset(this.target);
  final String target;
}

final class HostDebugShare extends HostDashboardRequest {
  const HostDebugShare();
}

final class HostRestartStart extends HostDashboardRequest {
  const HostRestartStart();
}

final class HostUpdateStartRequest extends HostDashboardRequest {
  const HostUpdateStartRequest();
}

final class HostMemoryRead extends HostDashboardRequest {
  const HostMemoryRead();
}

final class HostMemoryConfigRead extends HostDashboardRequest {
  const HostMemoryConfigRead(this.provider);
  final String provider;
}

final class HostMemoryConfigSave extends HostDashboardRequest {
  const HostMemoryConfigSave(this.provider, this.values);
  final String provider;
  final Map<String, String> values;
}

final class HostLearningGraphRead extends HostDashboardRequest {
  const HostLearningGraphRead();
}

final class HostLearningNodeRead extends HostDashboardRequest {
  const HostLearningNodeRead(this.id);
  final String id;
}

final class HostLearningNodeSave extends HostDashboardRequest {
  const HostLearningNodeSave(this.id, this.content);
  final String id;
  final String content;
}

final class HostLearningNodeDelete extends HostDashboardRequest {
  const HostLearningNodeDelete(this.id);
  final String id;
}

final class HostAllSchedulesRead extends HostDashboardRequest {
  const HostAllSchedulesRead();
}

final class HostScheduleRead extends HostDashboardRequest {
  const HostScheduleRead(this.jobId);
  final String jobId;
}

final class HostBlueprintRead extends HostDashboardRequest {
  const HostBlueprintRead();
}

final class HostBlueprintInstantiate extends HostDashboardRequest {
  const HostBlueprintInstantiate(this.blueprint, this.values);
  final String blueprint;
  final Map<String, String> values;
}

final class HostDeliveryTargetsRead extends HostDashboardRequest {
  const HostDeliveryTargetsRead();
}

final class HostScheduleCatchUp extends HostDashboardRequest {
  const HostScheduleCatchUp(this.jobId, this.catchUp);
  final String jobId;
  final bool? catchUp;
}

final class HostScheduleDeliver extends HostDashboardRequest {
  const HostScheduleDeliver(this.jobId, this.deliver);
  final String jobId;
  final String deliver;
}

final class HostSchedulePause extends HostDashboardRequest {
  const HostSchedulePause(this.jobId, {required this.resume});
  final String jobId;
  final bool resume;
}

final class HostScheduleCancel extends HostDashboardRequest {
  const HostScheduleCancel(this.jobId);
  final String jobId;
}

extension HostDashboardTransport on DashboardClient {
  Future<Object?> hostExchange(
    HostDashboardRequest request, {
    required void Function() check,
    Future<void> Function()? beforeSend,
  }) {
    // A saved connection with no profile is the gateway's own default home.
    final named = gatewayProfile;
    final profile = named == null || named.isEmpty ? 'default' : named;
    if (profile == 'current' || !_hostProfileId.hasMatch(profile)) {
      throw const FormatException('Invalid profile scope');
    }
    final plan = _hostPlan(profile, request);
    if (plan.body?.containsKey('profile') == true) {
      throw const FormatException('Invalid profile scope');
    }
    return _workspaceExchange(
      plan.segments,
      query: plan.query,
      check: check,
      method: plan.method,
      body: plan.body,
      beforeSend: beforeSend,
    );
  }
}

({
  String method,
  List<String> segments,
  Map<String, String> query,
  Map<String, Object?>? body,
})
_hostPlan(String profile, HostDashboardRequest request) {
  final query = {'profile': profile};
  switch (request) {
    case HostStatusRead():
      return (method: 'GET', segments: ['status'], query: query, body: null);
    case HostLogRead(:final file, :final level, :final search):
      if (!_hostLogFiles.contains(file)) {
        throw const FormatException('Invalid log file');
      }
      if (level != null && !_hostLogLevels.contains(level)) {
        throw const FormatException('Invalid log level');
      }
      if (search != null &&
          (search.length > 200 ||
              search.trim() != search ||
              RegExp(r'[\x00-\x1f\x7f]').hasMatch(search))) {
        throw const FormatException('Invalid log search');
      }
      return (
        method: 'GET',
        segments: ['logs'],
        query: {
          'profile': profile,
          'file': file,
          'lines': '200',
          'level': ?level,
          if (search != null && search.isNotEmpty) 'search': search,
        },
        body: null,
      );
    case HostComputerUseRead():
      return (
        method: 'GET',
        segments: ['tools', 'computer-use', 'status'],
        query: query,
        body: null,
      );
    case HostUpdateCheck(:final force):
      return (
        method: 'GET',
        segments: ['hermes', 'update', 'check'],
        query: {...query, if (force) 'force': 'true'},
        body: null,
      );
    case HostUpdateReceiptRead():
      return (
        method: 'GET',
        segments: ['hermes', 'update', 'receipt'],
        query: query,
        body: null,
      );
    case HostActionStatusRead(:final name):
      if (!_hostActionNames.contains(name)) {
        throw const FormatException('Invalid action');
      }
      return (
        method: 'GET',
        segments: ['actions', name, 'status'],
        query: {...query, 'lines': '200'},
        body: null,
      );
    case HostDoctorStart():
      return (
        method: 'POST',
        segments: ['ops', 'doctor'],
        query: query,
        body: {},
      );
    case HostSecurityAuditStart():
      return (
        method: 'POST',
        segments: ['ops', 'security-audit'],
        query: query,
        body: {},
      );
    case HostCuratorRead():
      return (method: 'GET', segments: ['curator'], query: query, body: null);
    case HostCuratorPause(:final paused):
      return (
        method: 'PUT',
        segments: ['curator', 'paused'],
        query: query,
        body: {'paused': paused},
      );
    case HostCuratorRun():
      return (
        method: 'POST',
        segments: ['curator', 'run'],
        query: query,
        body: {},
      );
    case HostMemoryReset(:final target):
      if (!_memoryResetTargets.contains(target)) {
        throw const FormatException('Invalid memory reset');
      }
      return (
        method: 'POST',
        segments: ['memory', 'reset'],
        query: query,
        body: {'target': target},
      );
    case HostDebugShare():
      return (
        method: 'POST',
        segments: ['ops', 'debug-share'],
        query: query,
        body: {'consent': true},
      );
    case HostRestartStart():
      return (
        method: 'POST',
        segments: ['gateway', 'restart'],
        query: query,
        body: null,
      );
    case HostUpdateStartRequest():
      return (
        method: 'POST',
        segments: ['hermes', 'update'],
        query: query,
        body: null,
      );
    case HostMemoryRead():
      return (method: 'GET', segments: ['memory'], query: query, body: null);
    case HostMemoryConfigRead(:final provider):
      if (!_hostProfileId.hasMatch(provider)) {
        throw const FormatException('Invalid memory provider');
      }
      return (
        method: 'GET',
        segments: ['memory', 'providers', provider, 'config'],
        query: {...query, 'surface': 'declared'},
        body: null,
      );
    case HostMemoryConfigSave(:final provider, :final values):
      if (!_hostProfileId.hasMatch(provider)) {
        throw const FormatException('Invalid memory provider');
      }
      return (
        method: 'PUT',
        segments: ['memory', 'providers', provider, 'config'],
        query: {...query, 'surface': 'declared'},
        body: {'values': _hostValues(provider, values, emptySecrets: true)},
      );
    case HostLearningGraphRead():
      return (
        method: 'GET',
        segments: ['learning', 'graph'],
        query: query,
        body: null,
      );
    case HostLearningNodeRead(:final id):
      _hostNode(id);
      return (
        method: 'GET',
        segments: ['learning', 'node'],
        query: {...query, 'id': id},
        body: null,
      );
    case HostLearningNodeSave(:final id, :final content):
      _hostNode(id);
      if (content.length > 65536 || content.contains('\u0000')) {
        throw const FormatException('Invalid learning node');
      }
      return (
        method: 'PUT',
        segments: ['learning', 'node'],
        query: query,
        body: {'id': id, 'content': content},
      );
    case HostLearningNodeDelete(:final id):
      _hostNode(id);
      return (
        method: 'DELETE',
        segments: ['learning', 'node'],
        query: query,
        body: {'id': id},
      );
    case HostAllSchedulesRead():
      return (
        method: 'GET',
        segments: ['cron', 'jobs'],
        query: {'profile': 'all'},
        body: null,
      );
    case HostScheduleRead(:final jobId):
      _hostJob(jobId);
      return (
        method: 'GET',
        segments: ['cron', 'jobs', jobId],
        query: query,
        body: null,
      );
    case HostBlueprintRead():
      return (
        method: 'GET',
        segments: ['cron', 'blueprints'],
        query: query,
        body: null,
      );
    case HostBlueprintInstantiate(:final blueprint, :final values):
      if (!_hostBlueprint.hasMatch(blueprint)) {
        throw const FormatException('Invalid blueprint');
      }
      return (
        method: 'POST',
        segments: ['cron', 'blueprints', 'instantiate'],
        query: query,
        body: {
          'blueprint': blueprint,
          'values': _hostValues(blueprint, values, emptySecrets: false),
        },
      );
    case HostDeliveryTargetsRead():
      return (
        method: 'GET',
        segments: ['cron', 'delivery-targets'],
        query: query,
        body: null,
      );
    case HostScheduleCatchUp(:final jobId, :final catchUp):
      _hostJob(jobId);
      return (
        method: 'PUT',
        segments: ['cron', 'jobs', jobId],
        query: query,
        body: {
          'updates': <String, Object?>{'catch_up': catchUp},
        },
      );
    case HostScheduleDeliver(:final jobId, :final deliver):
      _hostJob(jobId);
      final parts = deliver.split(',');
      if (parts.isEmpty ||
          parts.toSet().length != parts.length ||
          parts.any((part) => !_hostToken.hasMatch(part))) {
        throw const FormatException('Invalid delivery target');
      }
      return (
        method: 'PUT',
        segments: ['cron', 'jobs', jobId],
        query: query,
        body: {
          'updates': {'deliver': deliver},
        },
      );
    case HostSchedulePause(:final jobId, :final resume):
      _hostJob(jobId);
      return (
        method: 'POST',
        segments: ['cron', 'jobs', jobId, resume ? 'resume' : 'pause'],
        query: query,
        body: null,
      );
    case HostScheduleCancel(:final jobId):
      _hostJob(jobId);
      return (
        method: 'POST',
        segments: ['cron', 'jobs', jobId, 'cancel'],
        query: query,
        body: null,
      );
  }
}

void _hostJob(String jobId) {
  if (!_hostToken.hasMatch(jobId)) {
    throw const FormatException('Invalid schedule');
  }
}

void _hostNode(String id) {
  if (!_hostNodeId.hasMatch(id)) {
    throw const FormatException('Invalid learning node');
  }
}

Map<String, String> _hostValues(
  String owner,
  Map<String, String> values, {
  required bool emptySecrets,
}) {
  if (!_hostProfileId.hasMatch(owner) && !_hostBlueprint.hasMatch(owner)) {
    throw const FormatException('Invalid value owner');
  }
  if (values.length > 40) throw const FormatException('Invalid values');
  final clean = <String, String>{};
  for (final entry in values.entries) {
    if (!_hostToken.hasMatch(entry.key) ||
        entry.value.length > 4000 ||
        entry.value.contains('\u0000')) {
      throw const FormatException('Invalid value');
    }
    if (emptySecrets &&
        entry.value.isEmpty &&
        _hostSecretKey.hasMatch(entry.key)) {
      continue;
    }
    clean[entry.key] = entry.value;
  }
  return clean;
}
