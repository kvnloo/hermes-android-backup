part of 'remote_workspace.dart';

/// Public registry fields only. Never retain keyPath, tokens or raw errors.
typedef ManagedSshHost = ({String id, String label, String host, int port});
typedef ManagedSshStatus = ({
  String host,
  int localPort,
  int remotePort,
  bool reused,
  String version,
});

final class ManagedSshKeyChanged extends WorkspaceException {
  const ManagedSshKeyChanged() : super(WorkspaceFailure.denied);
}

extension ManagedSshWorkspace on WorkspaceTarget {
  Future<List<ManagedSshHost>> managedSshHosts() => _withOwner(() async {
    final raw = await _owner._dashboard.managedSshJson(
      method: 'GET',
      check: checkCurrent,
    );
    if (raw is! Map || raw['connections'] is! List) {
      _fail(WorkspaceFailure.invalid);
    }
    return _fleetList<ManagedSshHost>(
      (raw['connections'] as List)
          .where((r) => r is Map && r['kind'] == 'ssh')
          .toList(),
      (r) {
        final port = r['port'] ?? 22;
        if (port is! int || port < 1 || port > 65535) {
          _fail(WorkspaceFailure.invalid);
        }
        return (
          id: _fleetId(r['id']),
          label: _fleetText(r['label']),
          host: _fleetText(r['host']),
          port: port,
        );
      },
      (r) => r.id,
    );
  });

  Future<ManagedSshStatus?> managedSsh(
    ManagedSshHost row, {
    String method = 'GET',
  }) => _withOwner(() async {
    if (!const {'GET', 'POST', 'DELETE'}.contains(method)) {
      _fail(WorkspaceFailure.invalid);
    }
    // Re-read after confirmation. An edited host/port/id must not inherit consent.
    if (!(await managedSshHosts()).contains(row)) {
      _fail(WorkspaceFailure.mismatch);
    }
    final Object? raw;
    try {
      raw = await _owner._dashboard.managedSshJson(
        connectionId: row.id,
        method: method,
        check: checkCurrent,
      );
    } on DashboardHostKeyChanged {
      throw const ManagedSshKeyChanged();
    }
    if (raw is! Map || raw['ok'] != true) _fail(WorkspaceFailure.invalid);
    if (method == 'DELETE') {
      if (raw['disconnected'] is! bool) _fail(WorkspaceFailure.invalid);
      return null;
    }
    if (raw['connected'] == false) return null;
    if (raw['connected'] != true ||
        raw['host'] != row.host ||
        raw['reused'] is! bool) {
      _fail(WorkspaceFailure.mismatch);
    }
    final data = raw;
    int port(String key) {
      final p = data[key];
      if (p is! int || p < 1 || p > 65535) _fail(WorkspaceFailure.invalid);
      return p;
    }

    return (
      host: row.host,
      localPort: port('localPort'),
      remotePort: port('remotePort'),
      reused: data['reused'] as bool,
      // A failed non-essential --version probe is legitimately empty upstream.
      version: data['hermesVersion'] == ''
          ? ''
          : _fleetText(data['hermesVersion']),
    );
  });
}
