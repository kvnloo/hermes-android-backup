import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../l10n/workspace_strings.dart';

import '../services/connection_manager.dart';
import '../services/remote_workspace.dart';

/// Timeline of learned skills and memories, with edits on the bound profile.
class MemoryGraphScreen extends StatefulWidget {
  const MemoryGraphScreen({
    super.key,
    required this.owner,
    required this.route,
    required this.connection,
  });

  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final SavedConnection connection;

  @override
  State<MemoryGraphScreen> createState() => _MemoryGraphScreenState();
}

class _MemoryGraphScreenState extends State<MemoryGraphScreen> {
  WorkspacePane? _pane;
  WorkspaceTarget? _target;
  MemoryGraph? _graph;
  MemoryLayerStatus? _layers;
  MemoryProviderConfig? _provider;
  var _layout = const MemoryLayout(
    zoom: 1,
    playback: 1000,
    kind: 'all',
    pinnedOnly: false,
  );
  final _filter = TextEditingController();
  final _code = TextEditingController();
  final _providerValues = <String, TextEditingController>{};
  var _busy = false;
  Object? _error;
  Timer? _play;

  @override
  void initState() {
    super.initState();
    _code.text = _layout.encode();
    _open();
  }

  @override
  void dispose() {
    _play?.cancel();
    _filter.dispose();
    _code.dispose();
    for (final controller in _providerValues.values) {
      controller.dispose();
    }
    _pane?.close();
    super.dispose();
  }

  Future<WorkspaceTarget> _bound() async {
    final current = _target;
    if (current != null && current.isCurrent) return current;
    _pane?.close();
    final pane = _pane = widget.owner.pane();
    final target = await pane.bind(widget.route);
    _target = target;
    return target;
  }

  Future<void> _open() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final target = await _bound();
      final graph = await target.memoryGraph();
      final layers = await target.memoryLayers();
      if (!mounted) return;
      setState(() {
        _graph = graph;
        _layers = layers;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  List<MemoryGraphNode> get _visible {
    final graph = _graph;
    if (graph == null) return const [];
    final stamps = [
      for (final node in graph.nodes)
        if (node.timestamp != null) node.timestamp!,
    ];
    final min = stamps.isEmpty ? 0 : stamps.reduce((a, b) => a < b ? a : b);
    final max = stamps.isEmpty ? 0 : stamps.reduce((a, b) => a > b ? a : b);
    final cutoff = min + ((max - min) * _layout.playback / 1000).round();
    final query = _filter.text.trim().toLowerCase();
    return [
      for (final node in graph.nodes)
        if ((_layout.kind == 'all' || node.kind == _layout.kind) &&
            (!_layout.pinnedOnly || node.pinned) &&
            (node.timestamp == null || node.timestamp! <= cutoff) &&
            (query.isEmpty ||
                node.label.toLowerCase().contains(query) ||
                node.category.toLowerCase().contains(query)))
          node,
    ];
  }

  void _setLayout(MemoryLayout layout) {
    setState(() {
      _layout = layout;
      _code.text = layout.encode();
    });
  }

  void _playTimeline() {
    _play?.cancel();
    _play = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted || _layout.playback >= 1000) {
        timer.cancel();
        return;
      }
      _setLayout(
        MemoryLayout(
          zoom: _layout.zoom,
          playback: (_layout.playback + 50).clamp(0, 1000),
          kind: _layout.kind,
          pinnedOnly: _layout.pinnedOnly,
        ),
      );
    });
  }

  Future<void> _edit(MemoryGraphNode node) async {
    final target = _target;
    if (target == null) return;
    final MemoryNodeDetail detail;
    try {
      detail = await target.memoryNode(node.id);
    } on WorkspaceException catch (error) {
      if (mounted) setState(() => _error = error);
      return;
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error);
      return;
    }
    if (!mounted) return;
    final controller = TextEditingController(text: detail.content);
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.sharedL10n.release_core_memory_graph_screen_edit(
            (detail.label).toString(),
          ),
        ),
        content: TextField(
          controller: controller,
          maxLines: 8,
          decoration: InputDecoration(
            labelText:
                context.sharedL10n.release_core_memory_graph_screen_content,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.sharedL10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.sharedL10n.save),
          ),
        ],
      ),
    );
    final content = controller.text;
    controller.dispose();
    if (save != true || !mounted) return;
    await _guard(() async {
      await (await _bound()).saveMemoryNode(node.id, content);
      await _open();
    });
  }

  Future<void> _remove(MemoryGraphNode node) async {
    final verb = node.kind == 'skill'
        ? context.sharedL10n.release_core_memory_graph_screen_archive_skill
        : context.sharedL10n.release_core_memory_graph_screen_delete_memory;
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(verb),
        content: Text(
          node.kind == 'skill'
              ? context.sharedL10n
                    .release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
                      (node.label).toString(),
                      (widget.route.profile).toString(),
                    )
              : context.sharedL10n
                    .release_core_memory_graph_screen_delete_from_this_removes_that_memory(
                      (node.label).toString(),
                      (widget.route.profile).toString(),
                    ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.sharedL10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(verb),
          ),
        ],
      ),
    );
    if (agreed != true) return;
    await _guard(() async {
      await (await _bound()).removeMemoryNode(node.id);
      await _open();
    });
  }

  Future<void> _loadProvider(String name) async {
    await _guard(() async {
      final config = await (await _bound()).memoryProviderConfig(name);
      for (final controller in _providerValues.values) {
        controller.dispose();
      }
      _providerValues.clear();
      for (final field in config.fields) {
        _providerValues[field.key] = TextEditingController(
          text: field.kind == 'secret' ? '' : field.value,
        );
      }
      _provider = config;
    });
  }

  Future<void> _saveProvider() async {
    final config = _provider;
    if (config == null) return;
    final values = <String, String>{};
    for (final field in config.fields) {
      final text = _providerValues[field.key]?.text ?? '';
      if (field.kind == 'secret') {
        if (text.isNotEmpty) values[field.key] = text;
        continue;
      }
      // Unchanged fields stay stored. A blank must not clear, falsify or
      // default a value the user did not replace.
      if (text == field.value || text.isEmpty) continue;
      values[field.key] = text;
    }
    await _guard(() async {
      await (await _bound()).saveMemoryProvider(config.name, values);
    });
  }

  Future<void> _guard(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on WorkspaceException catch (error) {
      _error = error;
    } on FormatException catch (error) {
      _error = error;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    final layers = _layers;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.sharedL10n.release_core_more_pane_memory_graph),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.sharedL10n.release_core_memory_profile_summary(
              widget.route.profile ??
                  context.sharedL10n.release_core_memory_gateway_profile,
              widget.connection.label,
            ),
          ),
          if (_error != null)
            Text(
              workspaceErrorText(context.sharedL10n, _error!),
              key: const Key('memory-error'),
            ),
          if (layers != null)
            Text(
              context.sharedL10n.release_core_memory_layers_summary(
                layers.memoryBytes,
                layers.userBytes,
                layers.active.isEmpty
                    ? context.sharedL10n.release_core_schedule_builtin
                    : layers.active,
              ),
              key: const Key('memory-layers'),
            ),
          TextField(
            key: const Key('memory-filter'),
            controller: _filter,
            decoration: InputDecoration(
              labelText:
                  context.sharedL10n.release_core_memory_graph_screen_filter,
            ),
            onChanged: (_) => setState(() {}),
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final kind in ['all', 'skill', 'memory'])
                ChoiceChip(
                  label: Text(switch (kind) {
                    'all' => context.sharedL10n.release_core_memory_kind_all,
                    'skill' =>
                      context.sharedL10n.release_core_memory_kind_skill,
                    _ => context.sharedL10n.release_core_memory_kind_memory,
                  }),
                  selected: _layout.kind == kind,
                  onSelected: (_) => _setLayout(
                    MemoryLayout(
                      zoom: _layout.zoom,
                      playback: _layout.playback,
                      kind: kind,
                      pinnedOnly: _layout.pinnedOnly,
                    ),
                  ),
                ),
              FilterChip(
                label: Text(context.sharedL10n.pinned_chats),
                selected: _layout.pinnedOnly,
                onSelected: (value) => _setLayout(
                  MemoryLayout(
                    zoom: _layout.zoom,
                    playback: _layout.playback,
                    kind: _layout.kind,
                    pinnedOnly: value,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            key: const Key('memory-time'),
            value: _layout.playback.toDouble(),
            max: 1000,
            label: context.sharedL10n.release_core_memory_graph_screen_timeline,
            onChanged: (value) => _setLayout(
              MemoryLayout(
                zoom: _layout.zoom,
                playback: value.round(),
                kind: _layout.kind,
                pinnedOnly: _layout.pinnedOnly,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                key: const Key('memory-play'),
                onPressed: _playTimeline,
                child: Text(
                  context
                      .sharedL10n
                      .release_core_memory_graph_screen_play_timeline,
                ),
              ),
              for (final zoom in MemoryLayout.zooms)
                ChoiceChip(
                  label: Text('${zoom}x'),
                  selected: _layout.zoom == zoom,
                  onSelected: (_) => _setLayout(
                    MemoryLayout(
                      zoom: zoom,
                      playback: _layout.playback,
                      kind: _layout.kind,
                      pinnedOnly: _layout.pinnedOnly,
                    ),
                  ),
                ),
            ],
          ),
          TextField(
            key: const Key('memory-layout-code'),
            controller: _code,
            decoration: InputDecoration(
              labelText: context
                  .sharedL10n
                  .release_core_memory_graph_screen_layout_code,
            ),
            onSubmitted: (value) {
              try {
                _setLayout(MemoryLayout.decode(value.trim()));
              } on FormatException catch (error) {
                setState(() => _error = error);
              }
            },
          ),
          Transform.scale(
            scale: _layout.zoom,
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final node in visible)
                  ListTile(
                    key: Key('memory-node-${node.id}'),
                    title: Text(node.label),
                    subtitle: Text(
                      '${node.kind == 'skill'
                          ? context.sharedL10n.release_core_memory_kind_skill
                          : node.kind == 'memory'
                          ? context.sharedL10n.release_core_memory_kind_memory
                          : node.kind} · ${node.category}',
                    ),
                    onTap: _busy ? null : () => _edit(node),
                    trailing: IconButton(
                      key: Key('memory-remove-${node.id}'),
                      tooltip: node.kind == 'skill'
                          ? context
                                .sharedL10n
                                .release_core_memory_graph_screen_archive_skill
                          : context
                                .sharedL10n
                                .release_core_memory_graph_screen_delete_memory,
                      onPressed: _busy ? null : () => _remove(node),
                      icon: Icon(
                        node.kind == 'skill'
                            ? Icons.archive_outlined
                            : Icons.delete_outline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context
                .sharedL10n
                .release_core_memory_graph_screen_external_memory_providers,
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final provider
                  in layers?.providers ?? const <MemoryProviderSummary>[])
                ActionChip(
                  label: Text('${provider.name} (${provider.status})'),
                  onPressed: _busy ? null : () => _loadProvider(provider.name),
                ),
            ],
          ),
          if (_provider != null) ...[
            Text(_provider!.label),
            for (final field in _provider!.fields)
              TextField(
                key: Key('provider-field-${field.key}'),
                controller: _providerValues[field.key],
                obscureText: field.kind == 'secret',
                decoration: InputDecoration(
                  labelText: field.label,
                  helperText: field.kind == 'secret' && field.isSet
                      ? context
                            .sharedL10n
                            .release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep
                      : field.kind,
                ),
              ),
            FilledButton(
              key: const Key('provider-save'),
              onPressed: _busy ? null : _saveProvider,
              child: Text(
                context
                    .sharedL10n
                    .release_core_memory_graph_screen_save_provider,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
