import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';

import '../../nextgen/data/chat_controller.dart';
import '../../nextgen/data/nextgen_gateway.dart';
import 'connection_manager.dart';
import 'connection_mutation_barrier.dart';
import 'remote_workspace.dart';

part 'fleet_updates.dart';

/// A user's explicit attachment to a saved account. The gateway, all of its
/// chats and their listeners outlive the currently visible route, but never
/// an edit to the saved account. Neither labels nor profile names are keys.
final class FleetHost extends ChangeNotifier {
  FleetHost._(SavedConnection c, this._epoch) : gateway = NextGenGateway(c) {
    _pane = gateway.workspace.pane();
    var sawConnection = false;
    _reconnect = gateway.reconnected.listen((_) {
      // The initial refresh already waits for the first socket. A later
      // connection must also recover a failed first read, when there is no
      // previous target to invalidate. Never retry by resending a chat turn.
      final needsRoster =
          current && target == null && (sawConnection || !loading);
      sawConnection = true;
      if (needsRoster) unawaited(refresh());
    });
    gateway.addListener(_stateChanged);
  }
  final NextGenGateway gateway;
  final Object? _epoch;
  late final WorkspacePane _pane;
  late final StreamSubscription<void> _reconnect;
  final _chats = <String, NgChatController>{};
  bool get busyChat => _chats.values.any((c) => c.running);
  final _profiles = <String, FleetHost>{};
  Iterable<FleetHost> get attachedProfiles => _profiles.values;
  bool get busyInstallation =>
      busyChat || attachedProfiles.any((p) => p.busyChat);
  void attachProfile(String name, WorkspaceTarget displayed) {
    displayed.checkCurrent();
    if (!identical(displayed, target) ||
        !profiles.contains(name) ||
        name == gateway.profile ||
        !RegExp(r'^[a-zA-Z0-9_][a-zA-Z0-9._-]{0,127}$').hasMatch(name)) {
      throw const WorkspaceException(WorkspaceFailure.mismatch);
    }
    _profiles.putIfAbsent(name, () {
      final h = FleetHost._(
        gateway.connection.copyWith(gatewayProfile: name),
        _epoch,
      );
      unawaited(h.refresh());
      return h;
    });
    notifyListeners();
  }

  WorkspaceTarget? _target;
  WorkspaceTarget? get target =>
      current && _target?.isCurrent == true ? _target : null;
  bool _closed = false;
  bool get current =>
      !_closed &&
      ConnectionMutationBarrier.isCurrent(gateway.connection.id, _epoch);
  List<String> profiles = const [];

  /// The installation behind this saved entry, from the last good roster.
  /// Null while unknown; a busy host with an unknown installation blocks
  /// every fleet update, because it may be the same installation.
  String? installId;
  List<FleetSession> sessions = const [];
  int total = 0;
  int _nextOffset = 0;
  bool hasMore = false;
  WorkspaceFailure? failure;
  Object _flight = Object();
  bool loading = false;
  void _stateChanged() {
    if (current) notifyListeners();
  }

  void _check() {
    if (!current) throw const WorkspaceException(WorkspaceFailure.stale);
  }

  Future<void> refresh({bool more = false}) async {
    _check();
    final flight = _flight = Object();
    final previous = more ? sessions : const <FleetSession>[];
    loading = true;
    failure = null;
    // A new bind supersedes the old page. Keep it out of the view while
    // disconnected, but retain the target identity for reconnect detection.
    notifyListeners();
    try {
      final host = await _pane.bind(gateway.workspace.route());
      final roster = await host.read(WorkspaceRead.profiles) as Map;
      final offset = more ? _nextOffset : 0;
      final page = await host.fleetSessions(offset: offset);
      host.checkCurrent();
      if (!identical(flight, _flight) || !current) return;
      _target = host;
      final install = roster['install_id'];
      installId = install is String && install.isNotEmpty ? install : null;
      profiles = List.unmodifiable([
        for (final r in roster['profiles'] as List) r['name'] as String,
      ]);
      sessions = List.unmodifiable(
        {
          ...{for (final r in previous) r.id: r},
          ...{for (final r in page.rows) r.id: r},
        }.values,
      );
      total = page.total;
      _nextOffset = offset + page.rows.length;
      hasMore = page.rows.isNotEmpty && _nextOffset < total;
    } catch (e) {
      if (!identical(flight, _flight) || !current) return;
      failure = e is WorkspaceException
          ? e.reason
          : WorkspaceFailure.unavailable;
      profiles = const [];
      installId = null;
      sessions = const [];
      total = 0;
      hasMore = false;
    } finally {
      if (identical(flight, _flight) && current) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<NgChatController> openSession(
    FleetSession row,
    WorkspaceTarget source,
  ) async {
    _check();
    source.checkCurrent();
    if (gateway.profile == null ||
        !identical(source, _target) ||
        !sessions.contains(row)) {
      throw const WorkspaceException(WorkspaceFailure.stale);
    }
    final pane = gateway.workspace.pane();
    try {
      final route = gateway.workspace.route(storedSessionId: row.id);
      final selected = await pane.bind(route);
      source.checkCurrent();
      selected.checkCurrent();
      if (selected.effectiveProfile != row.profile) {
        throw const WorkspaceException(WorkspaceFailure.mismatch);
      }
      final chat = _chats.putIfAbsent(row.id, () {
        final chat = NgChatController(
          gateway,
          sessionId: row.id,
          title: row.title,
        );
        unawaited(chat.open());
        return chat;
      });
      return chat;
    } finally {
      pane.close();
    }
  }

  /// A chat controller's cached runtime id alone is not evidence after a
  /// reconnect. Only submit to a revalidated stored row and the current
  /// socket's explicit stored→runtime receipt; never create on a missing id.
  Future<bool> send(
    FleetSession row,
    NgChatController chat,
    String text,
    WorkspaceTarget displayed,
  ) async {
    _check();
    displayed.checkCurrent();
    if (!identical(displayed, target)) {
      throw const WorkspaceException(WorkspaceFailure.stale);
    }
    final pane = gateway.workspace.pane();
    try {
      final selected = await pane.bind(
        gateway.workspace.route(storedSessionId: row.id),
      );
      displayed.checkCurrent();
      if (!identical(_chats[row.id], chat) ||
          selected.effectiveProfile != row.profile ||
          selected.runtimeSessionId == null ||
          selected.runtimeSessionId != chat.runtimeId ||
          chat.running) {
        throw const WorkspaceException(WorkspaceFailure.unbound);
      }
      return await chat.send(text, fleetTarget: selected);
    } finally {
      pane.close();
    }
  }

  @override
  void dispose() {
    _closed = true;
    _pane.close();
    for (final h in _profiles.values) {
      h.dispose();
    }
    _profiles.clear();
    _reconnect.cancel();
    gateway.removeListener(_stateChanged);
    for (final c in _chats.values) {
      c.dispose();
    }
    _chats.clear();
    gateway.dispose();
    super.dispose();
  }
}

final class GatewayFleet extends ChangeNotifier {
  GatewayFleet(this.manager) {
    ConnectionMutationBarrier.addListener(_prune);
  }
  final ConnectionManager manager;
  static const _primaryKey = 'ares.fleet.primary.v1';
  static String _principal(SavedConnection c) => sha256
      .convert(utf8.encode(jsonEncode(c.toMap()..remove('fleet_reconnect'))))
      .toString();
  static String? primaryId(
    ConnectionManager manager,
    Iterable<SavedConnection> saved,
  ) {
    final primary = manager.prefs.getString(_primaryKey);
    if (primary == null) return null;
    return saved.where((c) => _principal(c) == primary).singleOrNull?.id;
  }

  Future<void> togglePrimary(FleetHost h) async {
    if (!identical(host(h.gateway.connection.id), h) || !h.current) {
      throw const WorkspaceException(WorkspaceFailure.stale);
    }
    final value = _principal(h.gateway.connection);
    final clear = manager.prefs.getString(_primaryKey) == value;
    final ok = clear
        ? await manager.prefs.remove(_primaryKey)
        : await manager.prefs.setString(_primaryKey, value);
    if (!ok || manager.prefs.getString(_primaryKey) != (clear ? null : value)) {
      throw const WorkspaceException(WorkspaceFailure.unavailable);
    }
    if (!_closed) notifyListeners();
  }

  final _hosts = <String, FleetHost>{};
  FleetHost? host(String id) => _hosts[id];
  final _updates = <FleetHost, FleetUpdateRow>{};

  /// Busy across every saved entry that is, or may be, [install]: several
  /// addresses (LAN, Tailscale, localhost) can reach one installation.
  bool _installationBusy(String install) => _hosts.values.any(
    (h) =>
        h.current &&
        h.busyInstallation &&
        [
          h,
          ...h.attachedProfiles,
        ].any((p) => p.installId == null || p.installId == install),
  );
  bool _closed = false;
  void _prune() {
    for (final id in _hosts.keys.toList()) {
      if (!_hosts[id]!.current) detach(id);
    }
  }

  Future<void> restore() async {
    // Snapshot only explicit opt-ins. Recheck the physical entry under the
    // saved-account transaction before any network I/O; never restore chats,
    // send a prompt, or dial SSH merely because the app started.
    final ids = [
      for (final c in manager.getConnections())
        if (c.fleetReconnect) c.id,
    ];
    await Future.wait(
      ids.map((id) async {
        try {
          await attach(id, restoring: true);
        } catch (_) {
          /* Remains manually reconnectable. */
        }
      }),
    );
  }

  Future<void> remember(FleetHost h, bool enabled) async {
    if (!h.current || !identical(_hosts[h.gateway.connection.id], h)) {
      throw const WorkspaceException(WorkspaceFailure.stale);
    }
    await manager.setFleetReconnect(h.gateway.connection.id, h._epoch, enabled);
    if (!_closed) notifyListeners();
  }

  bool remembered(String id) =>
      manager
          .getConnections()
          .where((c) => c.id == id)
          .singleOrNull
          ?.fleetReconnect ==
      true;

  Future<FleetHost> attach(String id, {bool restoring = false}) async {
    final epoch = ConnectionMutationBarrier.capture(id);
    final c = await manager.readFleetConnection(id);
    if (_closed || !ConnectionMutationBarrier.isCurrent(id, epoch)) {
      throw const WorkspaceException(WorkspaceFailure.stale);
    }
    if (c == null || !c.hasDashboardAuth || (restoring && !c.fleetReconnect)) {
      throw const WorkspaceException(WorkspaceFailure.unbound);
    }
    final existing = _hosts[id];
    if (existing != null) return existing;
    final host = _hosts[id] = FleetHost._(c, epoch);
    notifyListeners();
    unawaited(host.refresh());
    return host;
  }

  void detach(String id) {
    final removed = _hosts.remove(id);
    if (removed == null) return;
    _updates.remove(removed);
    removed.dispose();
    notifyListeners();
  }

  @override
  void dispose() {
    _closed = true;
    ConnectionMutationBarrier.removeListener(_prune);
    for (final h in _hosts.values) {
      h.dispose();
    }
    _hosts.clear();
    super.dispose();
  }
}
