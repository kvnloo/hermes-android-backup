part of 'remote_workspace.dart';

typedef ProjectSettingsFolder = ({String path, String? label, bool isPrimary});

/// One stored project (not an inferred tree node) on the target's profile.
final class ProjectSettingsSnapshot {
  const ProjectSettingsSnapshot._({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.folders,
    required this.isActive,
  });

  final String id;
  final String name;
  final String? icon;
  final String? color;
  final List<ProjectSettingsFolder> folders;
  final bool isActive;

  static ProjectSettingsSnapshot _decode(
    Object? row,
    String id, {
    bool isActive = false,
  }) {
    if (row is! Map || row['id'] is! String) _fail(WorkspaceFailure.invalid);
    // projects.get and each gateway mutator also resolve *slugs*. A successful
    // lookup does not establish that it resolved to the requested stored ID.
    if (row['id'] != id) _fail(WorkspaceFailure.mismatch);
    final name = row['name'];
    final folders = row['folders'];
    if (name is! String || name.isEmpty || folders is! List) {
      _fail(WorkspaceFailure.invalid);
    }
    final paths = <String>{};
    final parsed = <ProjectSettingsFolder>[];
    for (final folder in folders) {
      if (folder is! Map) _fail(WorkspaceFailure.invalid);
      final path = folder['path'];
      if (path is! String || !_canonicalPath(path) || !paths.add(path)) {
        _fail(WorkspaceFailure.invalid);
      }
      parsed.add((
        path: path,
        label: folder['label'] as String?,
        isPrimary: (folder['is_primary'] as bool?) ?? false,
      ));
    }
    return ProjectSettingsSnapshot._(
      id: id,
      name: name,
      icon: row['icon'] as String?,
      color: row['color'] as String?,
      folders: List.unmodifiable(parsed),
      isActive: isActive,
    );
  }
}

void _validateSettingsProjectId(String id) {
  if (id.isEmpty ||
      id.trim() != id ||
      RegExp(r'[\x00-\x1f\x7f]').hasMatch(id)) {
    _fail(WorkspaceFailure.invalid);
  }
}

extension ProjectSettingsActions on WorkspaceTarget {
  Future<ProjectSettingsSnapshot> readProjectSettings(String projectId) =>
      _withOwner(() => _settingsFromList(projectId));

  Future<ProjectSettingsSnapshot> _settingsFromList(
    String id, {
    bool confirmIconClear = false,
    bool confirmColorClear = false,
  }) async {
    _validateSettingsProjectId(id);
    final result = await _rpc('projects.list', {});
    final rows = result['projects'];
    final active = result['active_id'];
    if (rows is! List ||
        !result.containsKey('active_id') ||
        (active != null && active is! String)) {
      _fail(WorkspaceFailure.invalid);
    }
    ProjectSettingsSnapshot? found;
    for (final row in rows) {
      if (row is! Map || row['id'] is! String) _fail(WorkspaceFailure.invalid);
      if (row['id'] != id) continue;
      if (found != null) _fail(WorkspaceFailure.invalid);
      // Optional display fields may be absent in a read. When explicitly
      // clearing one, require the pinned handler's stored NULL as evidence.
      if ((confirmIconClear && !row.containsKey('icon')) ||
          (confirmColorClear && !row.containsKey('color'))) {
        _fail(WorkspaceFailure.invalid);
      }
      found = ProjectSettingsSnapshot._decode(row, id, isActive: active == id);
    }
    return found ?? _fail(WorkspaceFailure.mismatch);
  }

  Future<ProjectSettingsSnapshot> _getSettingsProject(String id) async {
    _validateSettingsProjectId(id);
    final result = await _rpc('projects.get', {'id': id});
    return ProjectSettingsSnapshot._decode(result['project'], id);
  }

  /// Adds paths on the *server*, one RPC per new path. This is not atomic:
  /// stop on the first unconfirmed write; never retry or undo earlier writes.
  Future<ProjectSettingsSnapshot> addProjectFolders(
    String projectId,
    Iterable<String> paths,
  ) => _withOwner(() async {
    final requested = paths.toSet();
    if (requested.isEmpty || !requested.every(isSafeWorkspacePath)) {
      _fail(WorkspaceFailure.invalid);
    }
    var project = await _getSettingsProject(projectId);
    final present = project.folders.map((f) => f.path).toSet();
    final additions = requested.difference(present).toList();
    for (var i = 0; i < additions.length; i++) {
      final path = additions[i];
      final receipt = await _rpc('projects.add_folder', {
        'id': projectId,
        'path': path,
        'is_primary': false,
      });
      // Intermediate reads need one project only. The final listing also
      // carries the active pointer in the same authoritative snapshot.
      project = i == additions.length - 1
          ? await _settingsFromList(projectId)
          : await _getSettingsProject(projectId);
      ProjectSettingsSnapshot._decode(receipt['project'], projectId);
      if (!project.folders.any((f) => f.path == path)) {
        _fail(WorkspaceFailure.mismatch);
      }
    }
    if (additions.isEmpty) project = await _settingsFromList(projectId);
    if (!project.folders.map((f) => f.path).toSet().containsAll(requested)) {
      _fail(WorkspaceFailure.mismatch);
    }
    return project;
  });

  Future<ProjectSettingsSnapshot> setProjectActive(String projectId) =>
      _withOwner(() async {
        await _getSettingsProject(projectId);
        final receipt = await _rpc('projects.set_active', {'id': projectId});
        final project = await _settingsFromList(projectId);
        if (receipt['active_id'] != projectId || !project.isActive) {
          _fail(WorkspaceFailure.mismatch);
        }
        return project;
      });

  /// Null leaves a field untouched. The empty string explicitly clears it;
  /// the pinned gateway persists and returns that clear as null.
  Future<ProjectSettingsSnapshot> setProjectAppearance(
    String projectId, {
    String? icon,
    String? color,
  }) => _withOwner(() async {
    if (icon == null && color == null) _fail(WorkspaceFailure.invalid);
    for (final value in [icon, color].nonNulls) {
      if (value.trim() != value || RegExp(r'[\x00-\x1f\x7f]').hasMatch(value)) {
        _fail(WorkspaceFailure.invalid);
      }
    }
    await _getSettingsProject(projectId);
    final receipt = await _rpc('projects.update', {
      'id': projectId,
      'icon': ?icon,
      'color': ?color,
    });
    final project = await _settingsFromList(
      projectId,
      confirmIconClear: icon == '',
      confirmColorClear: color == '',
    );
    ProjectSettingsSnapshot._decode(receipt['project'], projectId);
    if ((icon != null && project.icon != (icon.isEmpty ? null : icon)) ||
        (color != null && project.color != (color.isEmpty ? null : color))) {
      _fail(WorkspaceFailure.mismatch);
    }
    return project;
  });
}
