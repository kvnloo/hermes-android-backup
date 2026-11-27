/// Authenticated, per-pane access to a remote Hermes workspace. See
/// docs/remote-workspace-contract.md before adding an operation.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:uuid/uuid.dart';

import 'bot_display_rfb.dart';
import 'connection_manager.dart';
import 'connection_mutation_barrier.dart';
import 'portable_profile_bundle.dart';
import 'host_operations.dart';
import 'ws_client.dart';
import 'preview_peer.dart';
import '../history/foreign_session.dart';
import '../history/fork_lineage.dart';
import '../history/transcript_redaction.dart';

export 'host_operations.dart';

part 'remote_preview.dart';

part 'remote_workspace_fleet.dart';
part 'remote_managed_ssh.dart';
part 'workspace_discovery.dart';
part 'workspace_project_settings.dart';
part 'workspace_files.dart';
part 'workspace_git.dart';
part 'remote_profile_admin.dart';
part 'remote_agent_transfer.dart';
part 'remote_host_ops.dart';

part 'workspace_workers.dart';
part 'workspace_queue.dart';
part 'session_history.dart';

part 'remote_workspace_terminal.dart';
part 'remote_kanban.dart';
part 'remote_bots.dart';

/// Each entry is a particular operation, not permission for a whole family.
enum WorkspaceRead {
  profiles,
  defaultDirectory,
  gitStatus,
  pendingApprovals,
  processes,
  dashboardPlugins,
  terminalBackends,
  hostTerminalTicket,
}

enum WorkspaceFailure {
  stale,
  mismatch,
  unbound,
  unsupported,
  denied,
  ineligible,
  unavailable,
  invalid,
  insecure,
}

final class WorkspaceException implements Exception {
  const WorkspaceException(this.reason);
  final WorkspaceFailure reason;
  @override
  String toString() => 'Remote workspace: ${reason.name}';
}

Never _fail(WorkspaceFailure why) => throw WorkspaceException(why);

/// Mint on the originating owner when rendering a row, not after a click or
/// confirmation. The opaque issuer is intentionally not serialisable.
typedef WorkspaceRoute = ({
  Object issuer,
  String connectionId,
  String? profile,
  String? storedSessionId,
});

typedef _StoredWorkspace = ({String profile, String? cwd, int? generation});

/// One per *constructed* gateway, not per globally selected saved ID.
final class RemoteWorkspaceOwner {
  RemoteWorkspaceOwner({
    required this.connectionId,
    required this.expectedBaseUrl,
    required String? profile,
    required this._dashboard,
    required this._connect,
    required this._ownsSocket,
  }) : profile = profile?.trim().isEmpty == true ? null : profile?.trim(),
       _account = ConnectionMutationBarrier.capture(connectionId),
       _closed = ConnectionMutationBarrier.isPending(connectionId);

  final String connectionId;
  final String expectedBaseUrl;
  final String? profile;
  final DashboardClient _dashboard;
  final Future<WsClient> Function() _connect;
  final bool Function(WsClient) _ownsSocket;

  final Object? _account;
  bool _closed;

  WorkspacePane pane() => WorkspacePane._(this);
  final Object _issuer = Object();
  final _targetObservers = <void Function()>{};
  WorkspaceRoute route({String? storedSessionId}) => (
    issuer: _issuer,
    connectionId: connectionId,
    profile: profile,
    storedSessionId: storedSessionId,
  );
  void close() {
    _closed = true;
    for (final changed in List.of(_targetObservers)) {
      try {
        changed();
      } catch (_) {
        /* Observer failure must not prevent close. */
      }
    }
    WorkspaceKanban._cancelNudge(this);
  }

  void _check() {
    if (_closed ||
        !ConnectionMutationBarrier.isCurrent(connectionId, _account)) {
      _fail(WorkspaceFailure.stale);
    }
  }
}

/// The route owns this handle. Call [invalidate] synchronously when leaving
/// the route; [bind] also invalidates its previous result before the first await.
final class WorkspacePane {
  WorkspacePane._(this._owner);
  final RemoteWorkspaceOwner _owner;
  Object _selection = Object();
  bool _closed = false;
  void invalidate() => _selection = Object();
  void close() {
    _closed = true;
    invalidate();
  }

  /// The stored row can move before the live binding hears about it.
  /// Resume is the only receipt that replaces that binding; it is not a
  /// general command channel. A dropped socket becomes [WorkspaceFailure],
  /// not an exception that leaves the caller busy.
  Future<void> adoptMovedWorkspace(WorkspaceRoute route) {
    void check() {
      _owner._check();
      if (_closed) _fail(WorkspaceFailure.stale);
      if (!identical(route.issuer, _owner._issuer) ||
          route.connectionId != _owner.connectionId ||
          route.profile != _owner.profile ||
          route.storedSessionId == null) {
        _fail(WorkspaceFailure.mismatch);
      }
    }

    return _guard(check, () async {
      final socket = await _owner._connect();
      if (!_owner._ownsSocket(socket)) _fail(WorkspaceFailure.stale);
      final reply = await socket.send('session.resume', {
        'session_id': route.storedSessionId,
        'omit_messages': true,
        'defer_history': true,
        'source': 'desktop',
      });
      final result = reply['result'];
      final info = result is Map ? result['info'] : null;
      final cwd = info is Map ? info['cwd'] : null;
      if (reply['error'] != null ||
          cwd is! String ||
          !isSafeWorkspacePath(cwd)) {
        _fail(WorkspaceFailure.unavailable);
      }
    });
  }

  Future<WorkspaceTarget> bind(
    WorkspaceRoute route, {
    String? expectedCwd,
  }) async {
    final selected = _selection = Object();
    WsClient? pinned;
    int? epoch;
    void check() {
      _owner._check();
      if (_closed ||
          !identical(selected, _selection) ||
          (pinned != null &&
              (pinned!.socketEpoch != epoch || !_owner._ownsSocket(pinned!)))) {
        _fail(WorkspaceFailure.stale);
      }
    }

    return _guard(check, () async {
      if (!identical(route.issuer, _owner._issuer) ||
          route.connectionId != _owner.connectionId ||
          route.profile != _owner.profile ||
          route.profile != _owner._dashboard.gatewayProfile ||
          _owner.expectedBaseUrl != _owner._dashboard.baseUrl) {
        _fail(WorkspaceFailure.mismatch);
      }
      final base = Uri.parse(_owner._dashboard.baseUrl);
      final loopback = const {
        '127.0.0.1',
        '::1',
        'localhost',
      }.contains(base.host);
      if (base.userInfo.isNotEmpty ||
          base.hasQuery ||
          base.hasFragment ||
          !(base.scheme == 'https' || (base.scheme == 'http' && loopback))) {
        _fail(WorkspaceFailure.insecure);
      }
      final id = route.storedSessionId;
      if (id != null &&
          (id.isEmpty ||
              id == '.' ||
              id == '..' ||
              id.trim() != id ||
              RegExp(r'[/\\%?#\x00-\x1f\x7f]').hasMatch(id))) {
        _fail(WorkspaceFailure.invalid);
      }
      if (id == null && expectedCwd != null) _fail(WorkspaceFailure.unbound);
      final ws = pinned = await _owner._connect();
      epoch = ws.socketEpoch;
      check();
      if (ws.baseUrl != _owner._dashboard.baseUrl) {
        _fail(WorkspaceFailure.mismatch);
      }
      final ready = await ws.waitForGatewayReady();
      check();
      Future<_StoredWorkspace> readRow() async {
        final Object? raw;
        try {
          raw = await _owner._dashboard.workspaceJson(
            ['sessions', id!],
            query: {'profile': ?route.profile},
            check: check,
          );
        } on DashboardHttpException catch (e) {
          if (e.statusCode == 404) _fail(WorkspaceFailure.unbound);
          rethrow;
        }
        if (raw is! Map ||
            raw['id'] != id ||
            raw['profile'] is! String ||
            (raw['profile'] as String).isEmpty ||
            (route.profile != null && raw['profile'] != route.profile)) {
          _fail(WorkspaceFailure.mismatch);
        }
        final cwd = raw['cwd'];
        if (cwd != null && (cwd is! String || !_canonicalPath(cwd))) {
          _fail(WorkspaceFailure.invalid);
        }
        return (
          profile: raw['profile'] as String,
          cwd: cwd as String?,
          generation: raw['git_metadata_generation'] as int?,
        );
      }

      final row = id == null ? null : await readRow();
      if (expectedCwd != null && expectedCwd != row?.cwd) {
        _fail(WorkspaceFailure.mismatch);
      }
      final target = WorkspaceTarget._(
        _owner,
        route,
        ws,
        check,
        row,
        id == null ? null : ws.workspaceBinding(id),
        readRow,
        WsClient.readyFrameHasSessionAuthority(ready),
      );
      target.checkCurrent();
      return target;
    });
  }
}

/// No current-selection lookup, URL, arbitrary method, auth header or command
/// is accepted by the feature surface. Separate panes can hold separate targets.
final class WorkspaceTarget {
  WorkspaceTarget._(
    this._owner,
    this.route,
    this._socket,
    this._check,
    this._row,
    this._binding,
    this._readRow,
    this.sessionAuthority,
  );
  final RemoteWorkspaceOwner _owner;
  final WorkspaceRoute route;
  final WsClient _socket;
  final void Function() _check;
  final _StoredWorkspace? _row;
  final Future<_StoredWorkspace> Function() _readRow;
  final WorkspaceRuntime? _binding;
  bool? _guardedSavePresent;
  String? get runtimeSessionId => _binding?.runtimeId;
  final bool sessionAuthority;
  String? get canonicalCwd => _row?.cwd;
  String? get effectiveProfile => _row?.profile ?? route.profile;

  /// Synchronous admission/consumer fence, including socket and live binding.
  void checkCurrent() {
    _check();
    final id = route.storedSessionId;
    if (id != null && !identical(_socket.workspaceBinding(id), _binding)) {
      _fail(WorkspaceFailure.stale);
    }
    if (_binding != null &&
        ((_binding.profile != null && _binding.profile != effectiveProfile) ||
            (_binding.cwd != null && _binding.cwd != canonicalCwd))) {
      _fail(WorkspaceFailure.mismatch);
    }
  }

  /// Observe this exact target becoming stale, including same-owner runtime
  /// replacement. Cleanup detaches from the captured socket, never a successor.
  void Function() observeInvalidation(void Function() invalidated) {
    var active = true;
    void changed() {
      if (active && !isCurrent) {
        active = false;
        invalidated();
      }
    }

    final detach = _socket.observeWorkspaceBindings(changed);
    _owner._targetObservers.add(changed);
    changed();
    return () {
      active = false;
      detach();
      _owner._targetObservers.remove(changed);
    };
  }

  /// Refresh the authenticated session owner before an independently confirmed
  /// operation. Not a server-side CAS or authority to mutate anything.
  Future<void> verifySession() => _guard(checkCurrent, () async {
    if (_row == null) _fail(WorkspaceFailure.unbound);
    if (await _readRow() != _row) _fail(WorkspaceFailure.mismatch);
  });

  bool get isCurrent {
    try {
      checkCurrent();
      return true;
    } on WorkspaceException {
      return false;
    }
  }

  /// Negotiate only the requested read (or terminal-ticket availability, by
  /// explicit user action). Null = validated success; a denial is not absence.
  Future<WorkspaceFailure?> probe(WorkspaceRead operation) async {
    try {
      await read(operation);
      return null;
    } on WorkspaceException catch (e) {
      return e.reason;
    }
  }

  // Kept library-private: typed feature methods can share custody and fencing
  // without exposing a raw RPC name, credential or REST path to renderers.
  Future<Object?> _get(
    List<String> segments, [
    Map<String, String> params = const {},
  ]) {
    if (params.containsKey('profile')) _fail(WorkspaceFailure.mismatch);
    return _owner._dashboard.workspaceJson(
      segments,
      check: checkCurrent,
      query: {...params, 'profile': ?effectiveProfile},
    );
  }

  Future<Map<String, dynamic>> _rpc(
    String method,
    Map<String, dynamic> params, {
    bool bindProfile = true,
  }) async {
    checkCurrent();
    if (params.containsKey('profile')) _fail(WorkspaceFailure.mismatch);
    final response = await _socket.send(method, {
      ...params,
      if (bindProfile) 'profile': ?effectiveProfile,
    }, includeProfile: false);
    checkCurrent();
    final error = response['error'];
    if (error != null) {
      if (error is Map && _missingRpcMethod(error)) {
        _fail(WorkspaceFailure.unsupported);
      }
      if (error is Map && const {401, 403}.contains(error['code'])) {
        _fail(WorkspaceFailure.denied);
      }
      _fail(WorkspaceFailure.unavailable);
    }
    final result = response['result'];
    if (result is! Map<String, dynamic>) _fail(WorkspaceFailure.invalid);
    return result;
  }

  /// Desktop's `isMissingRpcMethod`: the code decides (`-32601`); a refusal
  /// without a code is judged by its message. A gateway that has no handler
  /// for a method is "not available here", never a failure to report raw.
  static bool _missingRpcMethod(Map<dynamic, dynamic> error) {
    final code = error['code'];
    if (code == -32601) return true;
    if (code != null) return false;
    final message = error['message']?.toString().toLowerCase() ?? '';
    return message.contains('method not found') ||
        message.contains('unknown method');
  }

  Future<T> _withOwner<T>(
    Future<T> Function() operation, {
    bool session = false,
    bool live = false,
  }) => _guard(checkCurrent, () async {
    if (live && runtimeSessionId == null) _fail(WorkspaceFailure.unbound);
    if (session || live) await verifySession();
    checkCurrent();
    final value = await operation();
    if (session || live) await verifySession();
    return value;
  });

  Future<Object?> read(WorkspaceRead operation) {
    return _withOwner(
      () async {
        Object? value;
        switch (operation) {
          case WorkspaceRead.profiles:
            final result = await _rpc('profiles.list', {
              'include_sessions': false,
            });
            if (result['profiles'] is! List ||
                !(result['profiles'] as List).every(
                  (r) => r is Map && r['name'] is String,
                )) {
              _fail(WorkspaceFailure.invalid);
            }
            value = result;
          case WorkspaceRead.pendingApprovals:
          case WorkspaceRead.processes:
            final approvals = operation == WorkspaceRead.pendingApprovals;
            final result = await _rpc(
              approvals ? 'approval.pending' : 'process.list',
              {'session_id': runtimeSessionId},
            );
            if (result[approvals ? 'approvals' : 'processes'] is! List) {
              _fail(WorkspaceFailure.invalid);
            }
            value = result;
          case WorkspaceRead.defaultDirectory:
            final result = await _get(['fs', 'default-cwd']);
            if (result is! Map ||
                result['cwd'] is! String ||
                !_canonicalPath(result['cwd'] as String)) {
              _fail(WorkspaceFailure.invalid);
            }
            value = result;
          case WorkspaceRead.dashboardPlugins:
            final result = await _get(['dashboard', 'plugins']);
            if (result is! List ||
                !result.every((r) => r is Map && r['name'] is String)) {
              _fail(WorkspaceFailure.invalid);
            }
            value = result;
          case WorkspaceRead.terminalBackends:
            final result = await _get(['tools', 'terminal', 'backends']);
            if (result is! Map ||
                result['active'] is! String ||
                result['backends'] is! List) {
              _fail(WorkspaceFailure.invalid);
            }
            value = result;
          case WorkspaceRead.gitStatus:
            final cwd = canonicalCwd;
            if (cwd == null) _fail(WorkspaceFailure.unbound);
            if (_binding?.backend != null && _binding!.backend != 'local') {
              _fail(WorkspaceFailure.unbound);
            }
            // /api/git is a host path, not the executor's SSH/container filesystem.
            final backend = await _get(['tools', 'terminal', 'backends']);
            if (backend is! Map || backend['active'] != 'local') {
              _fail(WorkspaceFailure.unbound);
            }
            await verifySession();
            final result = await _get(['git', 'status'], {'path': cwd});
            if (result != null &&
                (result is! Map ||
                    result['files'] is! List ||
                    result['changed'] is! int)) {
              _fail(WorkspaceFailure.invalid);
            }
            value = result;
          case WorkspaceRead.hostTerminalTicket:
            // Do not open a shell to discover support, nor give a ticket to UI.
            value = await _owner._dashboard.workspaceJson(
              ['webapp', 'socket-ticket'],
              query: {'socket': 'host-terminal'},
              check: checkCurrent,
              mintHostTerminalTicket: true,
            );
        }
        return value;
      },
      session: operation == WorkspaceRead.gitStatus,
      live:
          operation == WorkspaceRead.pendingApprovals ||
          operation == WorkspaceRead.processes,
    );
  }
}

/// File operations accept literal host-native absolute paths, never URLs,
/// network-device names, escaped separators, or Windows alternate streams.
bool isSafeWorkspacePath(String path) {
  if (!_canonicalPath(path) || path.startsWith(r'\\') || path.contains('%')) {
    return false;
  }
  final windows = !path.startsWith('/');
  final rest = windows ? path.substring(3) : path.substring(1);
  if (!windows && rest.contains(r'\')) return false;
  if (rest.contains(':')) return false;
  return rest
      .split(RegExp(r'[/\\]'))
      .every(
        (s) =>
            s.trim() == s &&
            (!windows ||
                (!s.endsWith('.') &&
                    !RegExp(
                      r'^(?:con|prn|aux|nul|com[1-9]|lpt[1-9])(?:\.|$)',
                      caseSensitive: false,
                    ).hasMatch(s))),
      );
}

/// One trailing separator is the same directory. Anything else stays untouched
/// so an ambiguous path is still rejected rather than repaired.
String normalizeWorkspaceCwd(String path) {
  if (path.length > 1 && (path.endsWith('/') || path.endsWith(r'\'))) {
    final stripped = path.substring(0, path.length - 1);
    if (!stripped.endsWith(':') && !stripped.endsWith(r'\')) return stripped;
  }
  return path;
}

/// An absolute server spelling, not a client-side realpath. Reject ambiguous
/// components (including the upstream second-decode fallback) instead of fixing them.
bool _canonicalPath(String path) {
  if (path.isEmpty ||
      path.trim() != path ||
      RegExp(r'[\x00-\x1f\x7f]|%[0-9a-fA-F]{2}').hasMatch(path)) {
    return false;
  }
  final drive = RegExp(r'^[A-Za-z]:[\\/]').hasMatch(path);
  final unc = path.startsWith(r'\\');
  if (!drive && !unc && !path.startsWith('/')) return false;
  if (path.startsWith('//') ||
      path.startsWith(r'\\?\') ||
      path.startsWith(r'\\.\')) {
    return false;
  }
  final components = drive || unc
      ? path.split(RegExp(r'[\\/]'))
      : path.split('/');
  if (unc &&
      (components.length < 4 ||
          components[2].isEmpty ||
          components[3].isEmpty)) {
    return false;
  }
  final rest = components.skip(unc ? 2 : 1).toList();
  if (rest.length == 1 && rest.single.isEmpty) return true;
  return rest.every((part) => part.isNotEmpty && part != '.' && part != '..');
}

Future<T> _guard<T>(void Function() check, Future<T> Function() run) async {
  check();
  try {
    final value = await run();
    check();
    return value;
  } catch (error) {
    check(); // Never surface an old owner's error on the replacement route.
    if (error is WorkspaceException ||
        error is KanbanActionRefusedException ||
        error is KanbanBoardNotFoundException) {
      rethrow;
    }
    if (error is DashboardHttpException) {
      if (const {401, 403}.contains(error.statusCode)) {
        _fail(WorkspaceFailure.denied);
      }
      if (const {404, 405, 501}.contains(error.statusCode)) {
        _fail(WorkspaceFailure.unsupported);
      }
    }
    if (error is FormatException || error is TypeError) {
      _fail(WorkspaceFailure.invalid);
    }
    _fail(WorkspaceFailure.unavailable);
  }
}
