part of 'remote_workspace.dart';

/// The effective host configuration, not a request from this client. Keep
/// relative/tilde spellings as reported; never resolve them on this device.
typedef WorkspaceScanPolicy = ({
  bool enabled,
  List<String> roots,
  List<String> excludedSubtrees,
});
typedef WorkspaceDiscoveredRepo = ({String root, String label, int sessions});
typedef WorkspaceRepoDiscovery = ({
  WorkspaceScanPolicy? policy,
  List<WorkspaceDiscoveredRepo> repos,
});

extension WorkspaceRepositoryDiscovery on WorkspaceTarget {
  /// Scope for *local* presentation preferences. The gateway's implicit
  /// profile and an explicit profile named "default" are not interchangeable.
  String get discoveryPreferenceScope {
    checkCurrent();
    return Uri(
      queryParameters: {
        'connection': route.connectionId,
        'gateway': _owner.expectedBaseUrl,
        'profile': ?effectiveProfile,
      },
    ).query;
  }

  /// scan:true requests the pinned host's best-effort scan. Even then the
  /// reply is merged with its cache and session roots, not a scan receipt.
  Future<WorkspaceRepoDiscovery> discoverRepositories({required bool scan}) =>
      _withOwner(() async {
        final result = await _rpc('projects.discover_repos', {'scan': scan});
        final raw = result['repos'];
        if (raw is! List) _fail(WorkspaceFailure.invalid);
        final roots = <String>{};
        final repos = <WorkspaceDiscoveredRepo>[];
        for (final row in raw) {
          if (row is! Map) _fail(WorkspaceFailure.invalid);
          final root = row['root'];
          // DiscoveredRepo's wire schema makes these fields optional with
          // defaults. An explicit null or the wrong type is not a default.
          final label = row.containsKey('label') ? row['label'] : '';
          final sessions = row.containsKey('sessions') ? row['sessions'] : 0;
          if (root is! String ||
              !_canonicalPath(root) ||
              !roots.add(root) ||
              label is! String ||
              sessions is! int ||
              sessions < 0) {
            _fail(WorkspaceFailure.invalid);
          }
          repos.add((root: root, label: label, sessions: sessions));
        }
        final policy = result['discovery_policy'];
        return (
          policy: policy == null ? null : _decodeScanPolicy(policy),
          repos: List<WorkspaceDiscoveredRepo>.unmodifiable(repos),
        );
      });
}

WorkspaceScanPolicy _decodeScanPolicy(Object raw) {
  if (raw is! Map || raw['enabled'] is! bool) _fail(WorkspaceFailure.invalid);
  List<String> paths(String field) {
    final items = raw[field];
    if (items is! List ||
        !items.every(
          (p) =>
              p is String &&
              p.isNotEmpty &&
              !RegExp(r'[\x00-\x1f\x7f]').hasMatch(p),
        )) {
      _fail(WorkspaceFailure.invalid);
    }
    return List<String>.unmodifiable(items);
  }

  return (
    enabled: raw['enabled'] as bool,
    roots: paths('roots'),
    excludedSubtrees: paths('exclude_paths'),
  );
}

/// Presentation only. Neither these paths nor hidden roots go to the gateway.
/// The pinned config.set has no repo_scan_* setter. The fs/list endpoint
/// resolves its input path, and SSH lists directory links as directories;
/// neither a client walk nor record_repos is a safe policy override.
/// Component boundaries matter: excluding /src/lib must not exclude /src/lib2.
class WorkspaceRepoFilters {
  WorkspaceRepoFilters({
    Iterable<String> roots = const [],
    Iterable<String> exclusions = const [],
    Iterable<String> hidden = const [],
  }) : roots = _paths(roots),
       exclusions = _paths(exclusions),
       hidden = _paths(hidden);

  final Set<String> roots, exclusions, hidden;

  static Set<String> _paths(Iterable<String> paths) {
    final result = Set<String>.unmodifiable(paths);
    if (!result.every(_canonicalPath)) _fail(WorkspaceFailure.invalid);
    return result;
  }

  bool shows(String path) =>
      !hidden.contains(path) &&
      (roots.isEmpty || roots.any((root) => _under(path, root))) &&
      !exclusions.any((root) => _under(path, root));

  static bool _under(String path, String root) {
    // Compare gateway spellings, not client OS path semantics. A backslash
    // is a valid POSIX filename character. Never case-fold POSIX paths.
    if (!root.startsWith('/')) {
      if (path.startsWith('/')) return false;
      root = root.replaceAll('\\', '/');
      path = path.replaceAll('\\', '/');
    }
    return path == root ||
        path.startsWith(root.endsWith('/') ? root : '$root/');
  }
}
