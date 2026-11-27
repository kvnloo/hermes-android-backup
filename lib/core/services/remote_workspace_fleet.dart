part of 'remote_workspace.dart';

// Cloud metadata is not authority to sign in to a different origin. Neither
// the discovery response nor a Webapp registry entry is a credential source.
typedef FleetOrg = ({String id, String name});
typedef FleetAgent = ({String id, String name, String status, Uri? address});
typedef CloudInventory = ({
  List<FleetOrg> choices,
  FleetOrg? org,
  List<FleetAgent> agents,
});
typedef FleetSession = ({String id, String title, String profile});
typedef WebappGateway = ({String id, String kind, String label});
typedef WebappRegistry = ({
  String primary,
  String lastUsed,
  List<WebappGateway> entries,
});

enum WebappDirection { auto, rtl, ltr }

typedef FleetUpdateCheck = ({String install, String version, bool eligible});

/// The installation became busy after review. Nothing was sent, so the
/// operator may retry once its chats are idle.
final class FleetUpdateHeld extends WorkspaceException {
  const FleetUpdateHeld() : super(WorkspaceFailure.denied);
}

String _fleetText(Object? raw, {int max = 256}) {
  if (raw is! String ||
      raw.isEmpty ||
      raw.length > max ||
      RegExp(r'[\x00-\x1f\x7f\u202a-\u202e\u2066-\u2069]').hasMatch(raw)) {
    _fail(WorkspaceFailure.invalid);
  }
  return raw;
}

String _fleetId(Object? raw) {
  final id = _fleetText(raw);
  if (!RegExp(r'^[A-Za-z0-9_-][A-Za-z0-9._-]*$').hasMatch(id)) {
    _fail(WorkspaceFailure.invalid);
  }
  return id;
}

List<T> _fleetList<T>(
  Object? raw,
  T Function(Map) parse,
  String Function(T) id,
) {
  if (raw is! List) _fail(WorkspaceFailure.invalid);
  final seen = <String>{};
  return List.unmodifiable(
    raw.map<T>((e) {
      if (e is! Map) _fail(WorkspaceFailure.invalid);
      final row = parse(e);
      if (!seen.add(id(row))) _fail(WorkspaceFailure.invalid);
      return row;
    }),
  );
}

FleetOrg _org(Map raw) =>
    (id: _fleetId(raw['id']), name: _fleetText(raw['name']));
Uri? _cloudAddress(Object? raw) {
  if (raw == null) return null;
  final text = _fleetText(raw, max: 2048);
  // Never open a launch-ticket link, URL credentials, query, user-supplied
  // path traversal or fragments returned by a remote directory.
  final url = Uri.tryParse(text);
  if (url == null ||
      !text.startsWith('https://') ||
      url.host.isEmpty ||
      url.userInfo.isNotEmpty ||
      url.authority.contains('@') ||
      url.hasQuery ||
      url.hasFragment ||
      text.contains('\\') ||
      text.contains('%') ||
      text.split('/').any((s) => s == '.' || s == '..')) {
    _fail(WorkspaceFailure.insecure);
  }
  return url;
}

extension FleetWorkspace on WorkspaceTarget {
  /// Only health metadata and the enumerated state are shown. Upstream's
  /// access-status handler is native-grant-only at the pin; 403 is not a
  /// reason to mint a native grant, restart the gateway, or probe other hosts.
  Future<({String version, String access})> fleetDiagnostics() =>
      _withOwner(() async {
        final health = await _get(['health']);
        if (health is! Map || health['ok'] != true) {
          _fail(WorkspaceFailure.unavailable);
        }
        final version = _fleetText(health['version']);
        String access;
        try {
          final raw = await _get(['webapp-access', 'status']);
          if (raw is! Map ||
              raw['gateway'] is! Map ||
              !const {
                'off',
                'serving',
                'starting',
                'stopped',
                'unavailable',
              }.contains(raw['gateway']['state'])) {
            _fail(WorkspaceFailure.invalid);
          }
          access = raw['gateway']['state'] as String;
        } on DashboardHttpException catch (e) {
          if (e.statusCode == 403) {
            access = 'Host-only access status';
          } else if (e.statusCode == 404) {
            access = 'No Web Access administration on this listener';
          } else {
            rethrow;
          }
        }
        return (version: version, access: access);
      });
  Future<FleetUpdateCheck> checkFleetUpdate() => _withOwner(() async {
    final roster = await read(WorkspaceRead.profiles) as Map;
    final install = _fleetId(roster['install_id']);
    final raw = await _get(['hermes', 'update', 'check']);
    if (raw is! Map ||
        raw['can_apply'] is! bool ||
        raw['update_available'] is! bool) {
      _fail(WorkspaceFailure.invalid);
    }
    return (
      install: install,
      version: _fleetText(raw['current_version']),
      eligible:
          raw['install_method'] == 'git' &&
          raw['can_apply'] == true &&
          raw['update_available'] == true,
    );
  });
  Future<String?> startFleetUpdate(
    FleetUpdateCheck reviewed, {
    required bool Function() admit,
  }) => _withOwner(() async {
    if (!reviewed.eligible || await checkFleetUpdate() != reviewed) {
      _fail(WorkspaceFailure.mismatch);
    }
    void admitted() {
      if (!admit()) throw const FleetUpdateHeld();
    }

    admitted();
    final raw = await _owner._dashboard.workspaceJson(
      ['hermes', 'update'],
      query: const {},
      check: checkCurrent,
      startFleetUpdate: true,
      beforeSend: admitted,
    );
    if (raw is! Map || raw['ok'] != true || raw['name'] != 'hermes-update') {
      _fail(WorkspaceFailure.denied);
    }
    final id = raw['action_id'];
    return id is String && RegExp(r'^[0-9a-f]{32}$').hasMatch(id) ? id : null;
  });
  Future<String> fleetUpdateOutcome(String actionId, String install) =>
      _withOwner(() async {
        final roster = await read(WorkspaceRead.profiles) as Map;
        if (roster['install_id'] != install) _fail(WorkspaceFailure.mismatch);
        final raw = await _get(
          ['actions', 'hermes-update', 'status'],
          {'lines': '1'},
        );
        if (raw is! Map || raw['name'] != 'hermes-update') {
          _fail(WorkspaceFailure.invalid);
        }
        final receipt = raw['receipt'];
        if (receipt is! Map || receipt['action_id'] != actionId) {
          return 'Awaiting matching receipt';
        }
        return switch (receipt['outcome']) {
          'success' when (receipt['followups'] as List?)?.isNotEmpty == true =>
            'Updated; follow-up required',
          'success' => 'Updated',
          'partial' => 'Partially updated',
          'failed' => 'Update failed',
          _ => 'Not confirmed',
        };
      });

  /// One deliberate send on the exact socket holding the resume receipt.
  /// Never repeat the write after an ambiguous response or reconnect.
  Future<Map<String, dynamic>> submitFleetText(
    String text,
    String submissionId,
  ) => _withOwner(() async {
    if (text.trim().isEmpty || text.length > 65536) {
      _fail(WorkspaceFailure.invalid);
    }
    final result = await _rpc('prompt.submit', {
      'session_id': runtimeSessionId,
      'text': text,
      'submission_id': _fleetId(submissionId),
    });
    if (!const {
      'streaming',
      'accepted',
      'queued',
      'running',
      'started',
    }.contains(result['status'])) {
      _fail(WorkspaceFailure.unavailable);
    }
    return result;
  }, live: true);

  Future<CloudInventory> discoverCloud({String? orgId}) => _withOwner(() async {
    final Object? raw;
    try {
      raw = await _get(
        ['cloud', 'agents'],
        {if (orgId != null) 'org': _fleetId(orgId)},
      );
    } on DashboardHttpException catch (e) {
      if (e.statusCode == 409) {
        _fail(
          WorkspaceFailure.denied,
        ); // Portal sign-in required/expired, not an org list.
      }
      rethrow;
    }
    if (raw is! Map) _fail(WorkspaceFailure.invalid);
    if (raw['needsOrgSelection'] == true) {
      return (
        choices: _fleetList<FleetOrg>(raw['orgs'], _org, (v) => v.id),
        org: null,
        agents: const <FleetAgent>[],
      );
    }
    final org = raw['org'] == null ? null : _org(raw['org'] as Map);
    if (orgId != null && orgId != org?.id) _fail(WorkspaceFailure.mismatch);
    return (
      choices: const <FleetOrg>[],
      org: org,
      agents: _fleetList<FleetAgent>(
        raw['agents'],
        (r) => (
          id: _fleetId(r['id']),
          name: _fleetText(r['name']),
          status: _fleetText(r['status']),
          address: _cloudAddress(r['dashboardUrl']),
        ),
        (v) => v.id,
      ),
    );
  });

  Future<({List<FleetSession> rows, int total})> fleetSessions({
    int offset = 0,
  }) => _withOwner(() async {
    if (offset < 0) _fail(WorkspaceFailure.invalid);
    final raw = await _get(
      ['sessions'],
      {'order': 'recent', 'limit': '30', 'offset': '$offset'},
    );
    if (raw is! Map ||
        raw['offset'] != offset ||
        raw['total'] is! int ||
        (raw['storage'] is Map && (raw['storage'] as Map).isNotEmpty)) {
      _fail(WorkspaceFailure.unavailable);
    }
    final rows = _fleetList<FleetSession>(raw['sessions'], (r) {
      final p = _fleetText(r['profile']);
      if (effectiveProfile != null && effectiveProfile != p) {
        _fail(WorkspaceFailure.mismatch);
      }
      return (
        id: _fleetId(r['id']),
        profile: p,
        title: r['title'] == null || r['title'] == ''
            ? _fleetId(r['id'])
            : _fleetText(r['title'], max: 4096),
      );
    }, (r) => r.id);
    return (rows: rows, total: raw['total'] as int);
  });

  Future<Object?> _machineRead(String path) => _owner._dashboard.workspaceJson(
    [path],
    query: const {},
    check: checkCurrent,
  );
  Future<WebappRegistry> webappRegistry() => _withOwner(() async {
    final raw = await _machineRead('gateway-connections');
    if (raw is! Map) _fail(WorkspaceFailure.invalid);
    final entries = _fleetList<WebappGateway>(
      raw['connections'],
      (r) => (
        id: _fleetId(r['id']),
        label: _fleetText(r['label']),
        kind: _fleetText(r['kind']),
      ),
      (v) => v.id,
    );
    final primary = _fleetId(raw['primary']);
    final last = _fleetId(raw['lastUsed']);
    if (![primary, last].every((id) => entries.any((r) => r.id == id))) {
      _fail(WorkspaceFailure.invalid);
    }
    return (primary: primary, lastUsed: last, entries: entries);
  });
  Future<WebappRegistry> setWebappPrimary(WebappGateway row) => _withOwner(
    () async {
      if (!(await webappRegistry()).entries.contains(row)) {
        _fail(WorkspaceFailure.mismatch);
      }
      final reply = await _owner._dashboard.workspaceJson(
        ['gateway-connections', _fleetId(row.id), 'primary'],
        query: const {},
        check: checkCurrent,
        makeWebappPrimary: true,
      );
      if (reply is! Map || reply['ok'] != true) _fail(WorkspaceFailure.invalid);
      final actual = await webappRegistry();
      if (actual.primary != row.id || !actual.entries.contains(row)) {
        _fail(WorkspaceFailure.mismatch);
      }
      return actual;
    },
  );
  Future<WebappDirection> webappDirection() => _withOwner(() async {
    final raw = await _machineRead('ui-preferences');
    if (raw is! Map ||
        raw['exists'] is! bool ||
        raw['revision'] is! int ||
        raw['values'] is! Map) {
      _fail(WorkspaceFailure.invalid);
    }
    return switch (raw['values']['hermes.desktop.textDirection']) {
      null => WebappDirection.auto,
      'rtl' => WebappDirection.rtl,
      'ltr' => WebappDirection.ltr,
      _ => _fail(WorkspaceFailure.invalid),
    };
  });
  Future<WebappDirection> setWebappDirection(WebappDirection value) =>
      _withOwner(() async {
        await _owner._dashboard.workspaceJson(
          ['ui-preferences'],
          query: const {},
          check: checkCurrent,
          webappDirection: value.name,
        );
        if (await webappDirection() != value) _fail(WorkspaceFailure.mismatch);
        return value;
      });
}
