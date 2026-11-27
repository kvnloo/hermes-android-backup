import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../services/remote_files_client.dart';
import '../services/remote_workspace.dart';
import '../theme/hermes_theme.dart';
import '../widgets/hermes_components.dart';
import '../widgets/markdown_file_preview.dart';
import '../widgets/attachment_audio_preview.dart';

import 'package:hermes_android/core/l10n/l10n.dart';

class FilesScreen extends StatefulWidget {
  final RemoteFilesDataSource files;
  final String? initialDirectory;
  final ValueChanged<String>? onAddToChat;
  final Future<void> Function(RemoteFileDownload download)? onSaveDownload;

  const FilesScreen({
    required this.files,
    this.initialDirectory,
    this.onAddToChat,
    this.onSaveDownload,
    super.key,
  });

  /// Each browser owns its connection, including project-folder drill-ins.
  static Future<void> open(
    BuildContext context,
    RemoteFilesClient files, {
    String? directory,
  }) async {
    try {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) =>
              FilesScreen(files: files, initialDirectory: directory),
        ),
      );
    } finally {
      files.close();
    }
  }

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  RemoteDirectory? _root;
  String? _path;
  final _parents = <String>[];
  int _generation = 0;
  List<RemoteFileEntry> _entries = const [];
  RemoteFileEntry? _selected;
  RemoteTextPreview? _preview;
  Object? _error;
  bool _loading = true;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadRoot());
  }

  @override
  void didUpdateWidget(FilesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.files, oldWidget.files) ||
        widget.initialDirectory != oldWidget.initialDirectory) {
      unawaited(_loadRoot());
    }
  }

  bool _owns(int generation) => mounted && generation == _generation;

  Future<void> _loadRoot() async {
    final generation = ++_generation;
    _root = null;
    _selected = null;
    _preview = null;
    _path = null;
    _downloading = false;
    _parents.clear();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final directory = widget.initialDirectory;
      final root = directory == null
          ? await widget.files.defaultDirectory()
          : RemoteDirectory(path: directory);
      if (!_owns(generation)) return;
      if (!isSafeWorkspacePath(root.path)) {
        throw const FormatException('Invalid gateway root');
      }
      _root = root;
      await _openDirectory(root.path);
    } catch (error) {
      if (!_owns(generation)) return;
      setState(() {
        _loading = false;
        _error = error;
      });
    }
  }

  Future<void> _openDirectory(String path) async {
    final generation = ++_generation;
    setState(() {
      _loading = true;
      _error = null;
      _selected = null;
      _preview = null;
    });
    try {
      final entries = await widget.files.listDirectory(path);
      if (!_owns(generation)) return;
      if (!entries.every((e) => isWorkspaceChild(path, e.name, e.path))) {
        throw const FormatException('Invalid gateway listing');
      }
      setState(() {
        _path = path;
        _entries = entries;
        _loading = false;
      });
    } catch (error) {
      if (!_owns(generation)) return;
      setState(() {
        _path = path;
        _loading = false;
        _error = error;
      });
    }
  }

  Future<void> _openFile(RemoteFileEntry entry) async {
    final generation = ++_generation;
    setState(() {
      _downloading = false;
      _selected = entry;
      _preview = null;
      _loading = true;
      _error = null;
    });
    if (attachmentAudioExtension(entry.name).isNotEmpty) {
      setState(() => _loading = false);
      return;
    }
    try {
      final preview = await widget.files.readText(entry.path);
      if (!_owns(generation)) return;
      if (preview.path != entry.path) {
        throw const FormatException('Gateway file changed');
      }
      setState(() {
        _preview = preview;
        _loading = false;
      });
    } catch (error) {
      if (!_owns(generation)) return;
      setState(() {
        _loading = false;
        _error = error;
      });
    }
  }

  void _enterDirectory(String path) {
    _parents.add(_path!);
    unawaited(_openDirectory(path));
  }

  void _back() {
    if (_selected != null) {
      _generation++;
      setState(() {
        _loading = false;
        _downloading = false;
        _selected = null;
        _preview = null;
        _error = null;
      });
      return;
    }
    if (_parents.isNotEmpty) {
      unawaited(_openDirectory(_parents.removeLast()));
      return;
    }
    Navigator.maybePop(context);
  }

  Future<void> _download() async {
    final generation = _generation;
    final route = ModalRoute.of(context);
    final selected = _selected;
    if (selected == null || _downloading) return;
    setState(() => _downloading = true);
    try {
      final download = await widget.files.download(selected.path);
      if (!mounted || generation != _generation || route?.isActive == false) {
        return;
      }
      final saver = widget.onSaveDownload;
      if (saver != null) {
        await saver(download);
      } else {
        final destination = await FilePicker.platform.saveFile(
          dialogTitle: context.l10n.save_2(download.filename),
          fileName: download.filename,
          bytes: download.bytes,
        );
        if (destination == null || destination.isEmpty) return;
      }
      if (!mounted || generation != _generation) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.downloaded(download.filename))),
      );
    } catch (error) {
      if (!mounted || generation != _generation) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.download_failed(error))),
      );
    } finally {
      if (_owns(generation)) setState(() => _downloading = false);
    }
  }

  Widget _directoryBody() {
    if (_entries.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Icons.folder_open_outlined,
          title: context.l10n.folder_is_empty,
          message:
              context.l10n.there_are_no_visible_files_in_this_server_folder,
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _openDirectory(_path!),
      child: ListView.separated(
        padding: const EdgeInsets.all(HermesSpacing.lg),
        itemCount: _entries.length,
        separatorBuilder: (_, _) => const SizedBox(height: HermesSpacing.sm),
        itemBuilder: (context, index) {
          final entry = _entries[index];
          return HermesCard(
            padding: const EdgeInsets.symmetric(
              horizontal: HermesSpacing.lg,
              vertical: HermesSpacing.md,
            ),
            onTap: () => entry.isDirectory
                ? _enterDirectory(entry.path)
                : unawaited(_openFile(entry)),
            child: Row(
              children: [
                Icon(
                  entry.isDirectory
                      ? Icons.folder_outlined
                      : Icons.description_outlined,
                  color: HermesTokens.of(context).accent,
                ),
                const SizedBox(width: HermesSpacing.md),
                Expanded(child: Text(entry.name)),
                const Icon(Icons.chevron_right),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _fileContents(RemoteFileEntry selected, RemoteTextPreview? preview) {
    final extension = attachmentAudioExtension(
      selected.name,
      preview?.mimeType,
    );
    if (extension.isNotEmpty) {
      final source = widget.files;
      return Center(
        child: SingleChildScrollView(
          child: AttachmentAudioPreview(
            sourceIdentity: (source, _generation, selected.path),
            extension: extension,
            loadBytes: () async {
              final result = source is RemoteFilesClient
                  ? await source.downloadPreview(selected.path)
                  : await source.download(selected.path);
              return result.bytes;
            },
          ),
        ),
      );
    }
    if (_error != null) {
      return SingleChildScrollView(
        child: ErrorState(
          title: context.l10n.could_not_preview_file,
          message: context.l10n.check_the_dashboard_connection_and_try_again,
          onRetry: () => unawaited(_openFile(selected)),
        ),
      );
    }
    if (preview != null &&
        !preview.binary &&
        isMarkdownFilename(selected.name)) {
      return MarkdownFilePreview(
        key: ValueKey(selected.path),
        text: preview.text,
      );
    }
    final tokens = HermesTokens.of(context);
    return SingleChildScrollView(
      child: SelectableText(
        preview?.binary == true
            ? context
                  .l10n
                  .binary_preview_is_unavailable_download_the_file_to_open_it
            : preview?.text ?? context.l10n.preview_unavailable,
        style: tokens.typography.body.copyWith(
          fontFamily: 'monospace',
          color: tokens.onSurface,
        ),
      ),
    );
  }

  Widget _previewBody() {
    final selected = _selected!;
    final preview = _preview;
    final tokens = HermesTokens.of(context);
    return Padding(
      padding: const EdgeInsets.all(HermesSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(selected.name, style: tokens.typography.section),
          const SizedBox(height: HermesSpacing.sm),
          Wrap(
            spacing: HermesSpacing.sm,
            runSpacing: HermesSpacing.sm,
            children: [
              if (preview != null)
                StatusChip(status: HermesStatus.idle, label: preview.language),
              if (preview?.truncated == true)
                StatusChip(
                  status: HermesStatus.blocked,
                  label: context.l10n.preview_truncated,
                ),
            ],
          ),
          const SizedBox(height: HermesSpacing.lg),
          Expanded(child: HermesCard(child: _fileContents(selected, preview))),
          const SizedBox(height: HermesSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _downloading ? null : _download,
                  icon: const Icon(Icons.download_outlined),
                  label: Text(context.l10n.download),
                ),
              ),
              if (widget.onAddToChat != null) ...[
                const SizedBox(width: HermesSpacing.md),
                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                        _preview == null &&
                            attachmentAudioExtension(selected.name).isEmpty
                        ? null
                        : () {
                            widget.onAddToChat!(selected.path);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.l10n.file_reference_added_to_chat,
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.add_comment_outlined),
                    label: Text(context.l10n.add_to_chat),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    if (_loading) return const LoadingSkeleton(rows: 6);
    if (_error != null && _selected == null) {
      return Center(
        child: ErrorState(
          title: context.l10n.could_not_load_files,
          message: context.l10n.check_the_dashboard_connection_and_try_again,
          onRetry: () =>
              unawaited(_path == null ? _loadRoot() : _openDirectory(_path!)),
        ),
      );
    }
    return _selected == null ? _directoryBody() : _previewBody();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(onPressed: _back, icon: const Icon(Icons.arrow_back)),
      title: Text(context.l10n.files),
      bottom: _selected == null && _path != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(42),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  HermesSpacing.lg,
                  0,
                  HermesSpacing.lg,
                  HermesSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _path!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_root?.branch != null)
                      StatusChip(
                        status: HermesStatus.idle,
                        label: _root!.branch,
                      ),
                  ],
                ),
              ),
            )
          : null,
    ),
    body: _body(),
  );
}
