part of 'gateway_fleet.dart';

extension FleetUpdates on GatewayFleet {
  Future<List<FleetUpdateRow>> checkUpdates() async {
    final rows = await Future.wait(
      _hosts.values.toList().map((h) async {
        final old = _updates[h];
        if (old != null) {
          await old.refreshReceipt();
          return old;
        }
        final r = FleetUpdateRow._(h, _updates, _installationBusy);
        await r._check();
        return r;
      }),
    );
    final seen = <String>{
      for (final r in _updates.values)
        if (r._offer != null) r._offer!.install,
    };
    for (final r in rows) {
      if (r.canStart && !seen.add(r._offer!.install)) {
        r.state = 'Skipped: same installation';
        r._offer = null;
      }
    }
    return rows;
  }
}

final class FleetUpdateRow {
  FleetUpdateRow._(this.host, this._operations, this._busy);
  final FleetHost host;
  final Map<FleetHost, FleetUpdateRow> _operations;
  final bool Function(String install) _busy;
  WorkspaceTarget? _target;
  FleetUpdateCheck? _offer;
  String state = 'Not checked';
  String? _action;
  bool _handedOff = false;
  bool get hasReceipt => _action != null;
  bool get canStart =>
      _offer?.eligible == true &&
      !_handedOff &&
      _target?.isCurrent == true &&
      !host.busyInstallation &&
      !_busy(_offer!.install);
  String get description =>
      '${host.gateway.connection.label} · ${host.gateway.url.display}';
  Future<void> _check() async {
    if (host.gateway.connection.fleetKind != 'direct') {
      state = host.gateway.connection.fleetKind == 'cloud'
          ? 'Skipped: Cloud-managed'
          : 'Skipped: not enrolled as a direct gateway';
      return;
    }
    try {
      final t = host.target;
      if (t == null || host.busyInstallation) {
        state = 'Skipped: disconnected or busy';
        return;
      }
      _target = t;
      _offer = await t.checkFleetUpdate();
      state = _offer!.eligible
          ? 'Eligible · ${_offer!.version}'
          : 'No applicable update';
    } catch (_) {
      state = 'Could not verify eligibility';
    }
  }

  Future<void> start() async {
    if (!canStart ||
        !host.current ||
        _operations.values.any((r) => r._offer?.install == _offer!.install)) {
      if (!_handedOff) state = 'Skipped: stale, busy or already requested';
      return;
    }
    // Reserve the installation synchronously across all open confirmation
    // views. Never re-issue a POST because a backend restarted mid-reply.
    _operations[host] = this;
    _handedOff = true;
    state = 'Requesting';
    final install = _offer!.install;
    try {
      // Rechecked after the eligibility re-read and again immediately before
      // the POST leaves: a chat may start on any entry for this installation.
      _action = await _target!.startFleetUpdate(
        _offer!,
        admit: () => host.current && !_busy(install),
      );
      state = _action == null
          ? 'Accepted; receipt unavailable'
          : 'Accepted; awaiting receipt';
      if (hasReceipt) await refreshReceipt();
    } on FleetUpdateHeld {
      // Nothing was sent. Release the reservation so a later check can retry.
      if (identical(_operations[host], this)) _operations.remove(host);
      _handedOff = false;
      state = 'Skipped: a chat on this installation is running';
    } catch (_) {
      state = 'Not confirmed; do not resend automatically';
    }
  }

  Future<void> refreshReceipt() async {
    if (_action == null) return;
    try {
      final t = host.target;
      if (t == null) {
        state = 'Reconnect to check receipt';
        return;
      }
      state = await t.fleetUpdateOutcome(_action!, _offer!.install);
    } catch (_) {
      state = 'Receipt unavailable';
    }
  }
}
