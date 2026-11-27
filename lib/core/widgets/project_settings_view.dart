import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/remote_workspace.dart';

const _projectGlyphs = <String, IconData>{
  'folder-library': Icons.folder_copy_outlined,
  'repo': Icons.source_outlined,
  'rocket': Icons.rocket_launch_outlined,
  'star-full': Icons.star,
  'book': Icons.menu_book,
  'terminal': Icons.terminal,
};

// Use Desktop's swatch spelling so both pickers recognise the selected colour.
String _swatch(int hue) => 'hsl($hue 68% 58%)';
final _swatchColors = {
  for (final hue in [210, 120, 30, 270])
    _swatch(hue): HSLColor.fromAHSL(1, hue.toDouble(), .68, .58).toColor(),
};

/// The card and settings picker use the same glyph and colour vocabulary.
IconData projectGlyph(String? name) =>
    _projectGlyphs[name] ?? Icons.folder_rounded;
Color? projectSwatch(String? name) => _swatchColors[name];

/// Settings for a project on the owner that
/// supplied the row; never look up a replacement gateway by connection ID.
class ProjectSettingsView extends StatefulWidget {
  const ProjectSettingsView({
    super.key,
    required this.owner,
    required this.route,
    required this.projectId,
    this.onChanged,
  });

  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final String projectId;
  final ValueChanged<ProjectSettingsSnapshot>? onChanged;

  @override
  State<ProjectSettingsView> createState() => _ProjectSettingsViewState();
}

class _ProjectSettingsViewState extends State<ProjectSettingsView> {
  final _paths = TextEditingController();
  late WorkspacePane _pane;
  Object? _account;
  WorkspaceTarget? _target;
  ProjectSettingsSnapshot? _settings;
  WorkspaceFailure? _failure;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    ConnectionMutationBarrier.addListener(_accountChanged);
    _bind();
  }

  void _bind() {
    _pane = widget.owner.pane();
    _account = ConnectionMutationBarrier.capture(widget.route.connectionId);
    _busy = false;
    _refresh(_pane);
  }

  @override
  void didUpdateWidget(ProjectSettingsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.owner != widget.owner ||
        oldWidget.route != widget.route ||
        oldWidget.projectId != widget.projectId) {
      _pane.close();
      _paths.clear();
      _bind();
    }
  }

  void _accountChanged() {
    if (ConnectionMutationBarrier.isCurrent(
      widget.route.connectionId,
      _account,
    )) {
      return;
    }
    _pane.close();
    _paths.clear();
    setState(() {
      _target = null;
      _settings = null;
      _busy = false;
      _failure = WorkspaceFailure.stale;
    });
  }

  @override
  void dispose() {
    _pane.close();
    ConnectionMutationBarrier.removeListener(_accountChanged);
    _paths.dispose();
    super.dispose();
  }

  Future<void> _refresh(WorkspacePane pane) async {
    if (!mounted || pane != _pane || _busy) return;
    final id = widget.projectId;
    setState(() {
      _target = null;
      _settings = null;
      _failure = null;
      _busy = true;
    });
    try {
      final target = await pane.bind(widget.route);
      final settings = await target.readProjectSettings(id);
      if (!mounted || pane != _pane) return;
      target.checkCurrent();
      setState(() {
        _target = target;
        _settings = settings;
        _busy = false;
      });
    } on WorkspaceException catch (error) {
      if (!mounted || pane != _pane) return;
      setState(() {
        _failure = error.reason;
        _busy = false;
      });
    }
  }

  Future<void> _change(
    WorkspaceTarget target,
    ProjectSettingsSnapshot displayed,
    Future<ProjectSettingsSnapshot> Function() change, {
    bool clearPaths = false,
  }) async {
    // A menu can return after a project/owner transition, even an A→B→A.
    if (!mounted || _busy || target != _target || displayed != _settings) {
      return;
    }
    setState(() {
      _busy = true;
      _failure = null;
    });
    late ProjectSettingsSnapshot confirmed;
    try {
      confirmed = await change();
      target.checkCurrent();
    } on WorkspaceException catch (error) {
      if (!mounted || target != _target) return;
      ProjectSettingsSnapshot? observed;
      if (target.isCurrent) {
        // A lost reply or partial batch may already have changed the project.
        // Reconcile by reading, not by replaying any part of the gesture.
        try {
          observed = await target.readProjectSettings(displayed.id);
        } on WorkspaceException {
          // No verified snapshot; the Refresh action is still available.
        }
      }
      if (!mounted || target != _target) return;
      setState(() {
        _settings = target.isCurrent ? observed : null;
        _failure = target.isCurrent ? error.reason : WorkspaceFailure.stale;
        _busy = false;
      });
      return;
    }
    if (!mounted || target != _target) return;
    if (clearPaths) _paths.clear();
    setState(() {
      _settings = confirmed;
      _busy = false;
    });
    widget.onChanged?.call(confirmed);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final pane = _pane;
    final target = _target;
    final settings = target?.isCurrent == true ? _settings : null;
    final failure = target?.isCurrent == false
        ? WorkspaceFailure.stale
        : _failure;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context
              .sharedL10n
              .release_core_project_settings_view_project_settings,
        ),
        actions: [
          IconButton(
            tooltip: l.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: _busy ? null : () => _refresh(pane),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_busy) const LinearProgressIndicator(),
            if (failure != null)
              Semantics(
                liveRegion: true,
                child: Text(switch (failure) {
                  WorkspaceFailure.stale =>
                    l.ng_the_gateway_connection_dropped_try_again,
                  WorkspaceFailure.denied => l.ng_notify_permission_denied,
                  WorkspaceFailure.unsupported => l.ng_unsupported,
                  WorkspaceFailure.mismatch =>
                    context
                        .sharedL10n
                        .release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project,
                  WorkspaceFailure.invalid =>
                    context
                        .sharedL10n
                        .release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute,
                  _ => l.check_the_connection_and_try_again,
                }),
              ),
            if (target != null && settings != null) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(settings.name),
                subtitle: Text(settings.id),
                trailing: settings.isActive
                    ? Chip(label: Text(l.active))
                    : OutlinedButton(
                        onPressed: _busy
                            ? null
                            : () => _change(
                                target,
                                settings,
                                () => target.setProjectActive(settings.id),
                              ),
                        child: Text(
                          context
                              .sharedL10n
                              .release_core_project_settings_view_set_active,
                        ),
                      ),
              ),
              const Divider(),
              Text(
                l.appearance,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _picker(
                label:
                    context.sharedL10n.release_core_project_settings_view_icon,
                current: settings.icon,
                mark: (key) =>
                    Icon(_projectGlyphs[key] ?? Icons.folder_outlined),
                choices: {
                  '': l.ng_default,
                  'folder-library': context
                      .sharedL10n
                      .release_core_project_settings_view_folder,
                  'repo': context
                      .sharedL10n
                      .release_core_project_settings_view_repository,
                  'rocket': context
                      .sharedL10n
                      .release_core_project_settings_view_rocket,
                  'star-full': context
                      .sharedL10n
                      .release_core_project_settings_view_star,
                  'book': context
                      .sharedL10n
                      .release_core_project_settings_view_book,
                  'terminal': context
                      .sharedL10n
                      .release_core_project_settings_view_terminal,
                },
                onSelected: (icon) => _change(
                  target,
                  settings,
                  () => target.setProjectAppearance(settings.id, icon: icon),
                ),
              ),
              _picker(
                label: context
                    .sharedL10n
                    .release_core_project_settings_view_colour,
                current: settings.color,
                mark: (key) => Icon(Icons.circle, color: _swatchColors[key]),
                choices: {
                  '': l.ng_default,
                  _swatch(210): l.theme_palette_blue,
                  _swatch(120): l.theme_palette_green,
                  _swatch(30): l.theme_palette_orange,
                  _swatch(270): l.theme_palette_purple,
                },
                onSelected: (color) => _change(
                  target,
                  settings,
                  () => target.setProjectAppearance(settings.id, color: color),
                ),
              ),
              const Divider(),
              Text(l.folders, style: Theme.of(context).textTheme.titleMedium),
              for (final folder in settings.folders)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    folder.isPrimary
                        ? Icons.folder_special_outlined
                        : Icons.folder_outlined,
                    semanticLabel: folder.isPrimary
                        ? context
                              .sharedL10n
                              .release_core_project_settings_view_primary_folder
                        : null,
                  ),
                  title: Text(folder.path),
                  subtitle: folder.label == null ? null : Text(folder.label!),
                ),
              const SizedBox(height: 8),
              TextField(
                controller: _paths,
                enabled: !_busy,
                minLines: 2,
                maxLines: 5,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: context
                      .sharedL10n
                      .release_core_project_settings_view_server_folder_paths,
                  helperText: context
                      .sharedL10n
                      .release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are,
                  helperMaxLines: 2,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _paths,
                  builder: (context, value, _) => FilledButton.icon(
                    icon: const Icon(Icons.create_new_folder_outlined),
                    label: Text(
                      context
                          .sharedL10n
                          .release_core_project_settings_view_add_folders,
                    ),
                    onPressed: _busy || value.text.trim().isEmpty
                        ? null
                        : () {
                            final paths = _paths.text
                                .split(RegExp(r'\r?\n'))
                                .where((p) => p.isNotEmpty);
                            _change(
                              target,
                              settings,
                              () =>
                                  target.addProjectFolders(settings.id, paths),
                              clearPaths: true,
                            );
                          },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _picker({
    required String label,
    required String? current,
    required Widget Function(String key) mark,
    required Map<String, String> choices,
    required ValueChanged<String> onSelected,
  }) {
    final selected = current ?? '';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: mark(selected),
      title: Text(label),
      subtitle: Text(choices[selected] ?? selected),
      trailing: PopupMenuButton<String>(
        // PopupMenuButton resolves onSelected from its latest widget when the
        // menu closes. Don't let an open menu borrow a later target/row.
        key: ValueKey((_target, _settings, label)),
        enabled: !_busy,
        tooltip: context.sharedL10n.release_core_project_settings_view_choose(
          label,
        ),
        icon: const Icon(Icons.edit_outlined),
        initialValue: selected,
        onSelected: onSelected,
        itemBuilder: (_) => [
          for (final choice in choices.entries)
            PopupMenuItem(
              value: choice.key,
              child: Row(
                children: [
                  mark(choice.key),
                  const SizedBox(width: 12),
                  Flexible(child: Text(choice.value)),
                  if (selected == choice.key) const Icon(Icons.check, size: 18),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
