part of 'remote_workspace.dart';

/// Cloud identity comes from Portal discovery *and* an independently signed-in
/// saved connection. A URL returned by the source is never dialled directly.
typedef CloudAgent = ({String id, String name, String origin, String? org});
typedef CloudDirectory = ({Map<String, String> teams, List<CloudAgent> agents});
String? cloudAgentOrigin(String? url) {
  final u = Uri.tryParse(url ?? '');
  if (u == null ||
      u.scheme != 'https' ||
      u.port != 443 ||
      u.hasQuery ||
      u.hasFragment ||
      u.userInfo.isNotEmpty ||
      !{'', '/'}.contains(u.path) ||
      !RegExp(
        r'^[a-z0-9-]+\.agents\.(nousresearch|staging-nousresearch)\.com$',
      ).hasMatch(u.host)) {
    return null;
  }
  return u.origin;
}

extension ProfileCloudDiscovery on RemoteProfileAdmin {
  Future<CloudDirectory> cloudAgents({String? org}) async {
    final result = await _request(
      ProfileDashboardOp.cloudAgents,
      query: {'org': ?org},
    );
    if (result['needsOrgSelection'] == true) {
      return (
        teams: {
          for (final team in result['orgs'] as List)
            team['id'] as String: team['name'] as String,
        },
        agents: <CloudAgent>[],
      );
    }
    final agents = <CloudAgent>[];
    for (final row in result['agents'] as List) {
      final url = cloudAgentOrigin(row['dashboardUrl'] as String?);
      if (url == null || row['dashboardGatewayState'] == 'down') continue;
      agents.add((
        id: row['id'] as String,
        name: row['name'] as String,
        origin: url,
        org: org,
      ));
    }
    return (teams: <String, String>{}, agents: agents);
  }
}

enum AgentTransferPhase {
  prepared,
  backup,
  upload,
  restore,
  finished,
  failed,
  undo,
  undone,
}

class AgentTransfer {
  AgentTransfer._(this.source, this.target, this.agent);
  final RemoteProfileAdmin source, target;
  final CloudAgent agent;
  String? _undo;
  int? _restorePid;
  bool _working = false, _abort = false, _undoStarted = false;
  String? get undoArchive => _undo;
  String get receiptKey =>
      'agent_transfer_undo.v1.${sha256.convert(utf8.encode(jsonEncode([agent.id, agent.origin, target.roster.installId, target.roster.target.route.connectionId])))}';
  String _fingerprint(int pid, String path) => sha256
      .convert(utf8.encode(jsonEncode([pid, path, receiptKey])))
      .toString();
  String? get undoFingerprint => _undo != null && _restorePid != null
      ? _fingerprint(_restorePid!, _undo!)
      : null;

  /// Only reacquire an undo point previously witnessed on this installation.
  /// A locally stored path (or action name/PID alone) is never authority.
  Future<void> recoverUndo(String fingerprint) async {
    if (_working || phase != AgentTransferPhase.prepared) {
      _fail(WorkspaceFailure.mismatch);
    }
    final status = await target._request(
      ProfileDashboardOp.importStatus,
      peerCheck: _check,
    );
    final pid = status['pid'], path = status['undo_archive'];
    if (status['running'] != false ||
        status['name'] != 'import' ||
        pid is! int ||
        pid <= 0 ||
        path is! String ||
        !_validUndo(path) ||
        _fingerprint(pid, path) != fingerprint) {
      _fail(WorkspaceFailure.mismatch);
    }
    _restorePid = pid;
    _undo = path;
    phase = status['exit_code'] == 0
        ? AgentTransferPhase.finished
        : AgentTransferPhase.failed;
  }

  bool _validUndo(String path) =>
      _canonicalPath(path) &&
      RegExp(
        r'[/\\]backups[/\\]pre-transfer-\d{4}-\d\d-\d\d-\d{6}-[a-f0-9]{6}\.zip$',
      ).hasMatch(path);
  bool get canUndo => !_working && !_undoStarted && _undo != null;
  AgentTransferPhase phase = AgentTransferPhase.prepared;
  double? fraction;
  bool gatewayDown = false;
  List<String> messagingOff = [];
  static Future<AgentTransfer> prepare(
    RemoteProfileAdmin source,
    RemoteProfileAdmin target,
    CloudAgent agent,
  ) async {
    if (target.name != 'default' ||
        source.roster.installId == target.roster.installId ||
        source._target.route.connectionId ==
            target._target.route.connectionId ||
        cloudAgentOrigin(target._target._owner.expectedBaseUrl) !=
            agent.origin) {
      throw const WorkspaceException(WorkspaceFailure.mismatch);
    }
    final op = AgentTransfer._(source, target, agent);
    await op._verify();
    return op;
  }

  void _check() {
    source.check();
    target.check();
    if (_abort) _fail(WorkspaceFailure.stale);
  }

  void cancel() {
    if (phase == AgentTransferPhase.backup ||
        phase == AgentTransferPhase.upload) {
      _abort = true;
    }
  }

  Future<void> _verify() async {
    _check();
    final discovered = await source.cloudAgents(org: agent.org);
    if (discovered.agents.where((a) => a == agent).length != 1) {
      _fail(WorkspaceFailure.mismatch);
    }
    await source.roster.refresh();
    await target.roster.refresh();
    final r = await target._request(
      ProfileDashboardOp.transferCapability,
      peerCheck: _check,
    );
    if (r['import_keep_host'] != 1) _fail(WorkspaceFailure.unsupported);
    _check();
  }

  Future<void> replace(String confirmation, void Function() notify) async {
    if (_working ||
        phase != AgentTransferPhase.prepared ||
        confirmation != agent.id) {
      _fail(WorkspaceFailure.mismatch);
    }
    _working = true;
    try {
      await _verify();
      phase = AgentTransferPhase.backup;
      notify();
      _check();
      final archive = await source.startBackup(peerCheck: _check);
      while (!await source.backupDone(archive)) {
        _check();
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      phase = AgentTransferPhase.upload;
      fraction = 0;
      notify();
      const length = 512 * 1024;
      int offset = 0;
      int? size;
      String? upload;
      do {
        final part = await source._request(
          ProfileDashboardOp.backupChunk,
          query: {
            'archive': archive.archive,
            'offset': '$offset',
            'length': '$length',
          },
          peerCheck: _check,
        );
        if (part['size'] is! int ||
            part['size'] <= 0 ||
            part['size'] > 32 * 1024 * 1024 * 1024 ||
            part['offset'] != offset ||
            size != null && part['size'] != size) {
          _fail(WorkspaceFailure.mismatch);
        }
        size = part['size'] as int;
        final data = part['data'] as String;
        final n = base64Decode(data).length;
        if (n == 0 ||
            n > length ||
            offset + n > size ||
            part['done'] != (offset + n == size)) {
          _fail(WorkspaceFailure.invalid);
        }
        final receipt = await target._request(
          ProfileDashboardOp.uploadChunk,
          fields: {'offset': offset, 'upload_id': upload, 'data': data},
          peerCheck: _check,
        );
        final id = receipt['upload_id'];
        if (id is! String ||
            !RegExp(r'^[a-f0-9]{24}$').hasMatch(id) ||
            upload != null && id != upload ||
            receipt['received'] != offset + n) {
          _fail(WorkspaceFailure.mismatch);
        }
        upload = id;
        offset += n;
        fraction = offset / size;
        notify();
      } while (offset < size);
      await _verify();
      phase = AgentTransferPhase.restore;
      fraction = null;
      notify();
      final started = await target._request(
        ProfileDashboardOp.restoreUpload,
        fields: {'size': size, 'upload_id': upload},
        peerCheck: _check,
      );
      if (started['keep_host'] != true) _fail(WorkspaceFailure.invalid);
      _restorePid = _pid(started);
      await _watch(_restorePid!, true, notify);
      if (_undo == null) _fail(WorkspaceFailure.unavailable);
      phase = AgentTransferPhase.finished;
    } catch (_) {
      phase = AgentTransferPhase.failed;
      rethrow;
    } finally {
      _working = false;
      notify();
    }
  }

  int _pid(Map r) {
    if (r['ok'] != true ||
        r['name'] != 'import' ||
        r['pid'] is! int ||
        (r['pid'] as int) <= 0) {
      _fail(WorkspaceFailure.invalid);
    }
    return r['pid'] as int;
  }

  Future<void> _watch(int pid, bool restoring, void Function() notify) async {
    var failures = 0;
    while (true) {
      Map r;
      try {
        r = await target._request(
          ProfileDashboardOp.importStatus,
          peerCheck: _check,
        );
        failures = 0;
      } on WorkspaceException catch (e) {
        if (e.reason != WorkspaceFailure.unavailable || ++failures > 10) {
          rethrow;
        }
        await Future<void>.delayed(const Duration(seconds: 1));
        continue;
      }
      if (r['name'] != 'import' || r['pid'] != pid) {
        _fail(WorkspaceFailure.mismatch);
      }
      final undo = r['undo_archive'];
      if (restoring && undo != null) {
        if (undo is! String ||
            !_validUndo(undo) ||
            _undo != null && undo != _undo) {
          _fail(WorkspaceFailure.invalid);
        }
        _undo ??= undo;
        notify();
      }
      if (r['running'] == false) {
        if (r['exit_code'] != 0) _fail(WorkspaceFailure.unavailable);
        gatewayDown = r['gateway_down'] != null && r['gateway_down'] != '';
        messagingOff =
            (r['messaging_off'] as List?)?.whereType<String>().toList() ?? [];
        return;
      }
      if (r['running'] != true) _fail(WorkspaceFailure.invalid);
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> undo(String confirmation, void Function() notify) async {
    if (!canUndo || confirmation != agent.id) _fail(WorkspaceFailure.mismatch);
    _working = true;
    try {
      await _verify();
      final status = await target._request(
        ProfileDashboardOp.importStatus,
        peerCheck: _check,
      );
      if (status['pid'] != _restorePid ||
          status['running'] != false ||
          status['undo_archive'] != _undo) {
        _fail(WorkspaceFailure.mismatch);
      }
      _undoStarted = true;
      phase = AgentTransferPhase.undo;
      notify();
      final r = await target._request(
        ProfileDashboardOp.undoImport,
        fields: {'archive': _undo, 'force': true, 'keep_host': true},
        peerCheck: _check,
      );
      await _watch(_pid(r), false, notify);
      phase = AgentTransferPhase.undone;
    } catch (_) {
      phase = AgentTransferPhase.failed;
      rethrow;
    } finally {
      _working = false;
      notify();
    }
  }
}
