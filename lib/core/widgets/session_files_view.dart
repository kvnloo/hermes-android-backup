import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'package:flutter/services.dart';

import '../composer/composer_drag.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/remote_workspace.dart';
import 'git_review_pane.dart';
import 'markdown_file_preview.dart';
import 'media_artifact_card.dart';
import '../services/remote_files_client.dart';
import '../utils/attachment_types.dart';
import '../utils/media_tags.dart';

/// Same tree beside either chat; on a phone it takes the body while the live
/// transcript stays mounted. No second session or local filesystem is opened.
class SessionFilesLayout extends StatelessWidget {
  const SessionFilesLayout({super.key, required this.child, this.files});
  final Widget child;
  final SessionFilesView? files;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final wide = box.maxWidth >= 850;
      return Stack(
        children: [
          Positioned.fill(
            right: files != null && wide ? 360 : 0,
            child: TickerMode(
              enabled: files == null || wide,
              child: Offstage(offstage: files != null && !wide, child: child),
            ),
          ),
          if (files != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: wide ? 360 : box.maxWidth,
              child: files!,
            ),
        ],
      );
    },
  );
}

void appendWorkspaceReference(TextEditingController input, String reference) {
  final text = input.text.isEmpty
      ? '$reference '
      : '${input.text}\n$reference ';
  input.value = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );
}

bool _referenceNeedsQuoting(String value) {
  const marks = '()[]{}<>`"\'';
  for (final unit in value.codeUnits) {
    if (unit == 9 ||
        unit == 10 ||
        unit == 11 ||
        unit == 12 ||
        unit == 13 ||
        unit == 32) {
      return true;
    }
  }
  return value.split('').any(marks.contains);
}

/// Quote like the gateway's format_reference_value so REFERENCE_PATTERN reads
/// the whole path. A line range stays outside the quotes.
String formatGatewayReferenceValue(String value) {
  if (!_referenceNeedsQuoting(value)) return value;
  for (final quote in ['`', '"', "'"]) {
    if (!value.contains(quote)) return '$quote$value$quote';
  }
  return value;
}

String gatewayContextReference({
  required bool folder,
  required String path,
  int? lineStart,
  int? lineEnd,
}) {
  final value = formatGatewayReferenceValue(path);
  final range = lineStart == null
      ? ''
      : (lineEnd == null || lineEnd == lineStart)
      ? ':$lineStart'
      : ':$lineStart-$lineEnd';
  return '@${folder ? 'folder' : 'file'}:$value$range';
}

class SessionFilesView extends StatefulWidget {
  const SessionFilesView({
    super.key,
    required this.owner,
    required this.route,
    required this.onReference,
    required this.onClose,
    this.onHandOff,
    this.onGitClosed,
    this.startOnGit = false,
    this.focusGitFile,
    this.turnBaseline,
    this.audioFilesClient,
  });
  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final ValueChanged<String> onReference;
  final VoidCallback onClose;
  final ValueChanged<String>? onHandOff;
  final VoidCallback? onGitClosed;
  final bool startOnGit;
  final String? focusGitFile;
  final String? turnBaseline;
  final RemoteFilesDataSource Function()? audioFilesClient;
  @override
  State<SessionFilesView> createState() => _FilesState();
}

class _FilesState extends State<SessionFilesView> {
  late WorkspacePane _pane;
  Object? _account;
  WorkspaceTarget? _target;
  ValueNotifier<bool> _audioValidity = ValueNotifier(true);
  void Function()? _detachAudioTarget;
  final _rows = <String, List<WorkspaceEntry>>{};
  final _expanded = <String>{};
  Set<String> _changed = {};
  WorkspaceDocument? _file;
  final _source = TextEditingController();
  int _epoch = 0;
  bool _busy = false;
  bool _showIgnored = false;
  bool _editing = false;
  bool _showSource = false;
  bool _review = false;
  bool _git = false;
  String Function(AppLocalizations)? _message;
  String? _saveNote;
  bool get _dirty => _editing && _file != null && _source.text != _file!.text;
  bool _owns(int e) => mounted && e == _epoch;

  @override
  void initState() {
    super.initState();
    ConnectionMutationBarrier.addListener(_revoked);
    _git = widget.startOnGit;
    _bind();
  }

  @override
  void didUpdateWidget(SessionFilesView old) {
    super.didUpdateWidget(old);
    if (old.route != widget.route || old.owner != widget.owner) {
      _pane.close();
      _bind();
    }
    if (widget.startOnGit && !old.startOnGit) _git = true;
  }

  void _bind() {
    _pane = widget.owner.pane();
    _account = ConnectionMutationBarrier.capture(widget.route.connectionId);
    _clear();
    _reload();
  }

  void _clear() {
    _audioValidity.value = false;
    _detachAudioTarget?.call();
    _detachAudioTarget = null;
    _epoch++;
    _rows.clear();
    _expanded.clear();
    _changed = {};
    _file = null;
    _source.clear();
    _editing = false;
    _review = false;
    _saveNote = null;
    _target = null;
    _busy = false;
  }

  void _revoked() {
    if (!ConnectionMutationBarrier.isCurrent(
      widget.route.connectionId,
      _account,
    )) {
      _pane.invalidate();
      setState(() {
        _clear();
        _message = (l10n) => l10n
            .release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection;
      });
    }
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(_revoked);
    _pane.close();
    _audioValidity.value = false;
    _detachAudioTarget?.call();
    _audioValidity.dispose();
    _epoch++;
    _source.dispose();
    super.dispose();
  }

  String Function(AppLocalizations) _failure(Object e) =>
      (l10n) => e is WorkspaceException
      ? switch (e.reason) {
          WorkspaceFailure.stale =>
            l10n.release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane,
          WorkspaceFailure.unbound =>
            l10n.release_core_session_files_view_no_verified_host_working_directory_for_this_session,
          WorkspaceFailure.denied =>
            l10n.release_core_session_files_view_the_gateway_denied_this_operation,
          WorkspaceFailure.ineligible => l10n.release_core_guarded_save_refused,
          WorkspaceFailure.unsupported =>
            l10n.release_core_session_files_view_this_gateway_does_not_support_this_operation,
          WorkspaceFailure.mismatch =>
            l10n.release_core_session_files_view_the_file_owner_or_working_directory_changed_reload,
          WorkspaceFailure.invalid =>
            l10n.release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid,
          WorkspaceFailure.insecure =>
            l10n.release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection,
          WorkspaceFailure.unavailable =>
            l10n.release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state,
        }
      : l10n.release_core_session_files_view_gateway_operation_could_not_be_confirmed;

  Future<void> _reload() async {
    _audioValidity.value = false;
    _detachAudioTarget?.call();
    _detachAudioTarget = null;
    final previous = {..._expanded};
    final e = ++_epoch;
    setState(() {
      _target = null;
      _rows.clear();
      _expanded.clear();
      _changed = {};
      _message = null;
      _busy = true;
    });
    try {
      final t = await _pane.bind(widget.route);
      final root = t.fileRoot;
      final listing = await t.listSessionFiles();
      final fresh = {root: listing};
      final expanded = <String>{};
      // Re-expand only folders freshly re-issued beneath the new root.
      final queue = [...listing];
      for (var i = 0; i < queue.length; i++) {
        if (!_owns(e)) return;
        final n = queue[i];
        if (n.directory && previous.contains(n.path)) {
          final kids = await t.listSessionFiles(n);
          fresh[n.path] = kids;
          expanded.add(n.path);
          queue.addAll(kids);
        }
      }
      Set<String> changed = {};
      String Function(AppLocalizations)? statusMessage;
      try {
        changed = await t.changedPaths();
      } on WorkspaceException catch (err) {
        if (err.reason == WorkspaceFailure.stale ||
            err.reason == WorkspaceFailure.mismatch) {
          rethrow;
        }
        statusMessage = (l10n) =>
            l10n.release_core_session_files_view_git_status_unavailable;
      }
      if (!_owns(e)) return;
      t.checkCurrent();
      _audioValidity.dispose();
      final validity = _audioValidity = ValueNotifier(true);
      _detachAudioTarget = t.observeInvalidation(() {
        validity.value = false;
        if (mounted) {
          setState(
            () => _message = _failure(
              const WorkspaceException(WorkspaceFailure.stale),
            ),
          );
        }
      });
      setState(() {
        _target = t;
        _rows.addAll(fresh);
        _expanded.addAll(expanded);
        _changed = changed;
        _message = statusMessage;
      });
    } catch (err) {
      if (_owns(e)) setState(() => _message = _failure(err));
    } finally {
      if (_owns(e)) setState(() => _busy = false);
    }
  }

  Future<void> _act(Future<void> Function(WorkspaceTarget t, int e) f) async {
    final t = _target;
    if (t == null || _busy) return;
    final e = ++_epoch;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      t.checkCurrent();
      await f(t, e);
    } catch (err) {
      if (_owns(e)) setState(() => _message = _failure(err));
    } finally {
      if (_owns(e)) setState(() => _busy = false);
    }
  }

  Future<void> _open(WorkspaceEntry node) => _act((t, e) async {
    if (node.directory) {
      if (_expanded.contains(node.path)) {
        setState(() => _expanded.remove(node.path));
        return;
      }
      final list = await t.listSessionFiles(node);
      if (!_owns(e)) return;
      t.checkCurrent();
      setState(() {
        _rows[node.path] = list;
        _expanded.add(node.path);
      });
      return;
    }
    final file = await t.readDocument(node);
    if (!_owns(e)) return;
    final present = await t.guardedSavePresent();
    if (!_owns(e)) return;
    final note = present ? t.saveRefusal(file.entry) : guardedSaveUnavailable;
    t.checkCurrent();
    setState(() {
      _display(file);
      _saveNote = note;
    });
  });
  void _display(WorkspaceDocument file) {
    _file = file;
    _source.text = file.text;
    _editing = false;
    _review = false;
    _showSource = !isMarkdownFilename(file.entry.name);
  }

  Future<void> _reference(
    WorkspaceEntry n, {
    bool lines = false,
    bool relative = false,
    bool copy = false,
  }) => _act((t, e) async {
    final selection = _source.selection;
    await t.verifySession();
    if (!_owns(e)) return;
    t.checkCurrent();
    int? lineStart;
    int? lineEnd;
    if (lines) {
      if (!selection.isValid ||
          selection.isCollapsed ||
          _editing ||
          _file?.entry != n) {
        return;
      }
      int lineAt(int offset) =>
          '\n'.allMatches(_source.text.substring(0, offset)).length + 1;
      lineStart = lineAt(selection.start);
      final last = lineAt(selection.end - 1);
      lineEnd = lineStart == last ? null : last;
    }
    if (copy) {
      await Clipboard.setData(
        ClipboardData(text: relative ? n.relative : n.path),
      );
    } else {
      widget.onReference(
        gatewayContextReference(
          folder: n.directory,
          path: n.path,
          lineStart: lineStart,
          lineEnd: lineEnd,
        ),
      );
    }
  });

  Future<void> _move() => _act((t, e) async {
    final fences = await t.cwdFences();
    if (!mounted || !_owns(e)) return;
    var draft = t.fileRoot;
    final path = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          ctx
              .sharedL10n
              .release_core_session_files_view_change_this_chat_s_working_directory,
        ),
        content: TextFormField(
          initialValue: draft,
          onChanged: (v) => draft = v,
          decoration: InputDecoration(
            labelText: ctx
                .sharedL10n
                .release_core_session_files_view_absolute_gateway_directory,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(ctx.sharedL10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, draft),
            child: Text(
              ctx.sharedL10n.release_core_session_files_view_change_directory,
            ),
          ),
        ],
      ),
    );
    if (path == null || !_owns(e)) return;
    await t.changeCwd(path, fences);
    if (!_owns(e)) return;
    _expanded.clear();
    await _reload();
  });

  Future<void> _save() => _act((t, e) async {
    final file = _file!, draft = _source.text;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          context
              .sharedL10n
              .release_core_session_files_view_replace_gateway_file,
        ),
        content: Text(
          context.sharedL10n
              .release_core_session_files_view_only_if_the_file_still_matches_the_version(
                (file.entry.path).toString(),
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.sharedL10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              context.sharedL10n.release_core_session_files_view_save_changes,
            ),
          ),
        ],
      ),
    );
    if (ok != true || !_owns(e)) return;
    try {
      final saved = await t.replaceDocument(file, draft);
      if (!_owns(e)) return;
      t.checkCurrent();
      setState(() {
        _display(saved);
        _message = (l10n) => l10n
            .release_core_session_files_view_saved_and_verified_on_the_gateway;
      });
    } on WorkspaceException catch (err) {
      if (!_owns(e)) return;
      setState(() {
        _review = true;
        _message = (l10n) => switch (err.reason) {
          WorkspaceFailure.unsupported =>
            l10n.release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your,
          WorkspaceFailure.ineligible => l10n.release_core_guarded_save_refused,
          _ =>
            l10n.release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
              _failure(err)(l10n),
            ),
        };
      });
    }
  });

  Future<void> _reviewLatest() => _act((t, e) async {
    final original = _file!;
    final current = await t.readDocument(original.entry);
    if (!mounted || !_owns(e)) return;
    final choice = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          ctx
              .sharedL10n
              .release_core_session_files_view_review_current_gateway_version,
        ),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(child: SelectableText(current.text)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(ctx.sharedL10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              ctx
                  .sharedL10n
                  .release_core_session_files_view_discard_draft_and_reload,
            ),
          ),
          if (current.editable)
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                ctx
                    .sharedL10n
                    .release_core_session_files_view_keep_draft_against_this_version,
              ),
            ),
        ],
      ),
    );
    if (choice == null || !_owns(e)) return;
    t.checkCurrent();
    setState(() {
      if (choice) {
        _file = current;
        _review = false;
      } else {
        _display(current);
      }
    });
  });

  Future<void> _back() async {
    if (_busy) return;
    final e = _epoch;
    if (_dirty &&
        await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(
                  context
                      .sharedL10n
                      .release_core_session_files_view_discard_unsaved_edits,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      context
                          .sharedL10n
                          .release_core_session_files_view_keep_editing,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(
                      context
                          .sharedL10n
                          .release_core_session_files_view_discard_edits,
                    ),
                  ),
                ],
              ),
            ) !=
            true) {
      return;
    }
    if (!_owns(e)) return;
    if (_file == null) {
      widget.onClose();
      return;
    }
    setState(() {
      _file = null;
      _source.clear();
      _editing = false;
      _review = false;
      _saveNote = null;
      _message = null;
    });
  }

  Iterable<({WorkspaceEntry node, int depth})> _visible(
    String path, [
    int depth = 0,
  ]) sync* {
    for (final n in _rows[path] ?? const <WorkspaceEntry>[]) {
      if (!_showIgnored && n.ignored == true) continue;
      yield (node: n, depth: depth);
      if (n.directory && _expanded.contains(n.path)) {
        yield* _visible(n.path, depth + 1);
      }
    }
  }

  Widget _tree(WorkspaceTarget t) {
    final visible = _visible(t.fileRoot).toList();
    final flags = (_rows.values.expand((v) => v)).any((n) => n.ignored != null);
    return Column(
      children: [
        ListTile(
          title: Text(
            context
                .sharedL10n
                .release_core_session_files_view_remote_working_directory,
          ),
          subtitle: SelectableText(t.fileRoot),
          trailing: IconButton(
            tooltip: context
                .sharedL10n
                .release_core_session_files_view_change_working_directory,
            icon: const Icon(Icons.drive_file_move_outline),
            onPressed: _busy ? null : _move,
          ),
        ),
        if (flags)
          CheckboxListTile(
            dense: true,
            title: Text(
              context
                  .sharedL10n
                  .release_core_session_files_view_show_ignored_files,
            ),
            value: _showIgnored,
            onChanged: (v) => setState(() => _showIgnored = v ?? false),
          ),
        if (!flags && visible.isNotEmpty)
          Text(
            context
                .sharedL10n
                .release_core_session_files_view_gateway_does_not_report_ignored_status,
          ),
        Expanded(
          child: visible.isEmpty
              ? Center(
                  child: Text(
                    context
                        .sharedL10n
                        .release_core_session_files_view_no_visible_entries,
                  ),
                )
              : ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (ctx, i) {
                    final n = visible[i].node;
                    return Padding(
                      padding: EdgeInsets.only(
                        left: (visible[i].depth.clamp(0, 6) * 10).toDouble(),
                      ),
                      child: ListTile(
                        dense: true,
                        enabled: !_busy,
                        leading: LongPressDraggable<ComposerDrag>(
                          data: ComposerDrag(
                            path: n.path,
                            directory: n.directory,
                            onGateway: true,
                          ),
                          feedback: Material(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(n.name),
                            ),
                          ),
                          child: Icon(
                            n.directory
                                ? (_expanded.contains(n.path)
                                      ? Icons.folder_open
                                      : Icons.folder_outlined)
                                : Icons.description_outlined,
                          ),
                        ),
                        title: Text(n.name),
                        subtitle: _changed.contains(n.path)
                            ? Text(
                                context
                                    .sharedL10n
                                    .release_core_session_files_view_changed,
                              )
                            : n.ignored == true
                            ? Text(
                                context
                                    .sharedL10n
                                    .release_core_session_files_view_ignored,
                              )
                            : null,
                        onTap: () => _open(n),
                        trailing: PopupMenuButton<String>(
                          tooltip: context.sharedL10n
                              .release_core_session_files_view_actions_for(
                                (n.name).toString(),
                              ),
                          enabled: !_busy,
                          onSelected: (v) {
                            if (n.owner == _target) {
                              _reference(
                                n,
                                relative: v == 'relative',
                                copy: v != 'attach',
                              );
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'relative',
                              child: Text(
                                context
                                    .sharedL10n
                                    .release_core_session_files_view_copy_relative_path,
                              ),
                            ),
                            PopupMenuItem(
                              value: 'absolute',
                              child: Text(
                                context
                                    .sharedL10n
                                    .release_core_session_files_view_copy_gateway_path,
                              ),
                            ),
                            PopupMenuItem(
                              value: 'attach',
                              child: Text(
                                n.directory
                                    ? context
                                          .sharedL10n
                                          .release_core_session_files_view_attach_folder_reference
                                    : context
                                          .sharedL10n
                                          .release_core_session_files_view_attach_file_reference,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _audioDocument(WorkspaceDocument file) {
    final target = file.entry.owner;
    final files = widget.audioFilesClient!;
    return SingleChildScrollView(
      child: MediaArtifactCard(
        ref: MediaTagRef(
          path: file.entry.path,
          suggestedFilename: file.entry.name,
        ),
        sourceIdentity: (target, file),
        ownerValidity: _audioValidity,
        isOwnerCurrent: () => target.isCurrent,
        filesClient: () {
          target.checkCurrent();
          return files();
        },
      ),
    );
  }

  Widget _document(WorkspaceDocument file) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SelectableText(file.entry.relative),
      if (file.truncated)
        Text(
          context
              .sharedL10n
              .release_core_session_files_view_preview_truncated_editing_disabled,
        ),
      if (_saveNote != null)
        Text(switch (_saveNote!) {
          guardedSaveUnavailable =>
            context.sharedL10n.release_core_guarded_save_unavailable,
          'Only a file directly in the working directory can be saved.' =>
            context.sharedL10n.release_core_file_save_direct_only,
          "Hidden files can't be saved by the gateway." =>
            context.sharedL10n.release_core_file_save_hidden,
          _ => context.sharedL10n.release_core_guarded_save_refused,
        }),
      Wrap(
        children: [
          if (!_editing && !file.binary)
            TextButton(
              onPressed: () => setState(() => _showSource = true),
              child: Text(
                context.sharedL10n.release_core_session_files_view_select_lines,
              ),
            ),
          if (!_editing && file.editable && _saveNote == null)
            TextButton(
              onPressed: _busy
                  ? null
                  : () => setState(() {
                      _editing = true;
                      _showSource = true;
                    }),
              child: Text(context.sharedL10n.edit),
            ),
          if (_editing)
            TextButton(
              onPressed: _busy || _review || !_dirty ? null : _save,
              child: Text(context.sharedL10n.save),
            ),
          if (_review)
            TextButton(
              onPressed: _busy ? null : _reviewLatest,
              child: Text(
                context
                    .sharedL10n
                    .release_core_session_files_view_review_gateway_version,
              ),
            ),
          if (!_editing && _showSource && !file.binary)
            ValueListenableBuilder(
              valueListenable: _source,
              builder: (ctx, v, _) => TextButton(
                onPressed:
                    _busy || !v.selection.isValid || v.selection.isCollapsed
                    ? null
                    : () => _reference(file.entry, lines: true),
                child: Text(
                  context
                      .sharedL10n
                      .release_core_session_files_view_attach_selected_lines,
                ),
              ),
            ),
        ],
      ),
      Expanded(
        child:
            widget.audioFilesClient != null &&
                attachmentIsAudio(file.entry.name.split('.').last)
            ? _audioDocument(file)
            : file.binary
            ? Center(
                child: Text(
                  context
                      .sharedL10n
                      .release_core_session_files_view_binary_file_no_text_preview,
                ),
              )
            : !_showSource
            ? MarkdownFilePreview(
                key: ValueKey(file.entry.path),
                text: file.text,
              )
            : TextField(
                controller: _source,
                readOnly: !_editing || _busy,
                expands: true,
                minLines: null,
                maxLines: null,
                style: const TextStyle(fontFamily: 'monospace'),
                onChanged: (_) => setState(() {}),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  labelText: context
                      .sharedL10n
                      .release_core_session_files_view_file_source,
                  alignLabelWithHint: true,
                ),
              ),
      ),
    ],
  );

  String? _recordedTurnBaseline() {
    final session = widget.route.storedSessionId;
    final cwd = _target?.canonicalCwd;
    if (session == null || cwd == null) return null;
    return gitTurnMemory.baselineFor(
      ownerId: widget.owner.connectionId,
      profile: widget.owner.profile,
      sessionId: session,
      cwd: cwd,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_git) {
      return GitReviewPane(
        owner: widget.owner,
        route: widget.route,
        turnBaseline: _recordedTurnBaseline() ?? widget.turnBaseline,
        initialFile: widget.focusGitFile,
        onHandOff: widget.onHandOff,
        onClose: () {
          setState(() => _git = false);
          widget.onGitClosed?.call();
        },
      );
    }
    final t = _target;
    final file = _file;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Material(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: file == null
                          ? context
                                .sharedL10n
                                .release_core_session_files_view_close_session_files
                          : context
                                .sharedL10n
                                .release_core_session_files_view_back_to_tree,
                      icon: Icon(file == null ? Icons.close : Icons.arrow_back),
                      onPressed: _busy ? null : _back,
                    ),
                    Expanded(
                      child: Text(
                        context
                            .sharedL10n
                            .release_core_session_files_view_session_files,
                      ),
                    ),
                    if (file == null)
                      IconButton(
                        key: const Key('open-git-review'),
                        tooltip: context
                            .sharedL10n
                            .release_core_session_files_view_git_review,
                        icon: const Icon(Icons.difference_outlined),
                        onPressed: _busy
                            ? null
                            : () => setState(() => _git = true),
                      ),
                    if (file == null)
                      IconButton(
                        tooltip: context
                            .sharedL10n
                            .release_core_session_files_view_refresh_tree,
                        icon: const Icon(Icons.refresh),
                        onPressed: _busy ? null : _reload,
                      ),
                  ],
                ),
                if (_busy) const LinearProgressIndicator(),
                if (_message != null) Text(_message!(context.sharedL10n)),
                if (t != null)
                  Expanded(child: file == null ? _tree(t) : _document(file)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
