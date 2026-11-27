import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/remote_workspace.dart';
import '../services/transcript_export_io.dart';

/// Branch, rewind, checkpoints, export and Claude/Codex import for one chat
/// (or host-side Claude/Codex import for a bound owner/profile before a chat
/// is saved when [storedSessionId] is null).
///
/// Classic and NextGen both open this page. It uses the owner that supplied
/// the session, not whichever gateway was opened last.
class SessionHistoryPage extends StatefulWidget {
  const SessionHistoryPage({
    super.key,
    required this.owner,
    this.storedSessionId,
    this.onRewound,
    this.onRestored,
    this.onOpenSession,
    this.saveExport = saveTranscriptExport,
  });

  final RemoteWorkspaceOwner owner;
  final String? storedSessionId;
  final ValueChanged<String>? onRewound;

  /// A checkpoint restore removed chat messages: the chat behind this page
  /// must read its transcript again.
  final VoidCallback? onRestored;

  /// Saves an exported transcript as a file (a save dialog on desktop, a
  /// shared file on Android and iOS).
  final TranscriptExportSaver saveExport;
  final void Function(String sessionId, {String? title})? onOpenSession;

  @override
  State<SessionHistoryPage> createState() => _SessionHistoryPageState();
}

class _SessionHistoryPageState extends State<SessionHistoryPage> {
  late final WorkspacePane _pane = widget.owner.pane();
  final TextEditingController _foreignSearchController =
      TextEditingController();
  WorkspaceTarget? _target;
  var _loading = true;
  var _busy = false;
  var _loadingMoreForeign = false;
  String? _error;
  List<HistoryMessage> _messages = const [];
  ShownSessionLineage? _lineage;
  List<HistoryCheckpoint> _checkpoints = const [];
  int? _selectedRow;
  String? _selectedHash;
  String? _diff;
  var _diffFailed = false;
  var _revertOwnEdits = false;
  var _messagesUnavailable = false;
  var _lineageUnavailable = false;
  var _checkpointsUnavailable = false;
  String _format = 'md';
  var _redact = true;
  String? _foreignSource;
  String _foreignSearch = '';
  ForeignSessionPage? _foreign;
  String? _foreignError;
  String? _selectedForeign;
  ForeignPreviewView? _foreignPreview;
  var _foreignPreviewLoading = false;
  String? _foreignPreviewError;
  var _foreignUnsupported = false;
  String? _notice;
  ({String sessionId, String? title})? _openableSession;

  bool get _hasStoredSession => widget.storedSessionId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _foreignSearchController.dispose();
    _pane.close();
    super.dispose();
  }

  /// A failure as a sentence in the user's language, never a raw enum.
  String _reason(WorkspaceFailure failure) {
    final l10n = context.sharedL10n;
    return switch (failure) {
      WorkspaceFailure.unsupported => l10n.history_error_unsupported,
      WorkspaceFailure.denied ||
      WorkspaceFailure.insecure ||
      WorkspaceFailure.ineligible => l10n.history_error_denied,
      WorkspaceFailure.stale ||
      WorkspaceFailure.mismatch => l10n.history_error_changed,
      WorkspaceFailure.unbound => l10n.history_error_unbound,
      WorkspaceFailure.invalid => l10n.history_error_invalid,
      WorkspaceFailure.unavailable => l10n.history_error_unavailable,
    };
  }

  /// Each section loads on its own: a gateway that lacks one (a pre-0.23
  /// sidecar without lineage or export, an authority without Claude/Codex
  /// import) still shows the others, each absence with its own reason.
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _foreignError = null;
    });
    WorkspaceTarget? target;
    try {
      target = await _pane.bind(
        widget.owner.route(storedSessionId: widget.storedSessionId),
      );
      final bound = target;
      Future<T?> section<T>(Future<T> Function() read) async {
        try {
          return await read();
        } on WorkspaceException catch (error) {
          // The owner itself is gone: nothing else can load either.
          if (!bound.isCurrent) rethrow;
          if (error.reason == WorkspaceFailure.denied) rethrow;
          return null;
        } catch (_) {
          return null;
        }
      }

      List<HistoryMessage>? messages = const [];
      ShownSessionLineage? lineage;
      List<HistoryCheckpoint>? checkpoints = const [];
      if (_hasStoredSession) {
        messages = await section(bound.transcript);
        lineage = await section(bound.lineage);
        checkpoints = await section(bound.checkpoints);
      }
      ForeignSessionPage? foreign;
      var unsupported = false;
      String? foreignErr;
      try {
        foreign = await bound.foreignSessions(source: _foreignSource);
      } on WorkspaceException catch (error) {
        if (!bound.isCurrent) rethrow;
        if (error.reason == WorkspaceFailure.unsupported) {
          unsupported = true;
        } else if (mounted) {
          foreignErr = _reason(error.reason);
        }
      }
      if (!mounted) return;
      if (!bound.isCurrent) {
        // The owner changed or closed during the load: never leave the
        // spinner up for a result that will not be shown.
        setState(() {
          _loading = false;
          _error = _reason(WorkspaceFailure.stale);
        });
        return;
      }
      setState(() {
        _target = bound;
        _messages = messages ?? const [];
        _messagesUnavailable = messages == null;
        _lineage = lineage;
        _lineageUnavailable = _hasStoredSession && lineage == null;
        _checkpoints = checkpoints ?? const [];
        _checkpointsUnavailable = checkpoints == null;
        _foreign = foreign;
        _foreignUnsupported = unsupported;
        _foreignError = foreignErr;
        _loading = false;
      });
    } on WorkspaceException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _reason(error.reason);
        _loading = false;
      });
    } catch (_) {
      // A closed owner or a dropped socket: the spinner must not outlive it.
      if (!mounted) return;
      setState(() {
        _error = _reason(WorkspaceFailure.unavailable);
        _loading = false;
      });
    }
  }

  Future<bool> _confirm(String title, String body) async {
    final l10n = context.sharedL10n;
    final answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(body)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const ValueKey('history-confirm'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.continue_label),
          ),
        ],
      ),
    );
    return answer == true && mounted;
  }

  Future<void> _branch() async {
    final target = _target;
    final row = _selectedRow;
    if (target == null || row == null || _busy) return;
    final l10n = context.sharedL10n;
    final confirmed = await _confirm(
      l10n.history_branch_title,
      l10n.history_branch_body,
    );
    if (!confirmed || !target.isCurrent) return;
    setState(() => _busy = true);
    try {
      final fences = await target.historyFences();
      if (!target.isCurrent) return;
      final receipt = await target.branchAtMessage(
        throughMessageId: row,
        confirmed: true,
        fences: fences,
      );
      if (!mounted) return;
      setState(() {
        _notice = l10n.history_branched(receipt.sessionId);
        _openableSession = (
          sessionId: receipt.sessionId,
          title: receipt.title.isEmpty ? null : receipt.title,
        );
        _busy = false;
      });
    } on WorkspaceException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _reason(error.reason);
        _busy = false;
      });
    }
  }

  Future<void> _rewind() async {
    final target = _target;
    final row = _selectedRow;
    if (target == null || row == null || _busy) return;
    final l10n = context.sharedL10n;
    final confirmed = await _confirm(
      l10n.history_rewind_title,
      l10n.history_rewind_body,
    );
    if (!confirmed || !target.isCurrent) return;
    setState(() => _busy = true);
    try {
      final fences = await target.historyFences();
      if (!target.isCurrent) return;
      final receipt = await target.rewindAtMessage(
        targetMessageId: row,
        confirmed: true,
        fences: fences,
      );
      if (!mounted) return;
      widget.onRewound?.call(receipt.text);
      if (!mounted) return;
      Navigator.pop(context);
    } on WorkspaceException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _reason(error.reason);
        _busy = false;
      });
    }
  }

  Future<void> _showDiff(String hash) async {
    final target = _target;
    if (target == null) return;
    final l10n = context.sharedL10n;
    setState(() {
      _selectedHash = hash;
      _diff = null;
      _diffFailed = false;
    });
    try {
      final diff = await target.checkpointDiff(hash);
      if (!mounted || !target.isCurrent || _selectedHash != hash) return;
      setState(
        () => _diff = diff.text.isEmpty ? l10n.history_diff_none : diff.text,
      );
    } on WorkspaceException {
      if (!mounted || _selectedHash != hash) return;
      setState(() => _diffFailed = true);
    }
  }

  /// Restore is offered only for a checkpoint whose changes are on screen:
  /// not while the diff loads, and not after it failed.
  bool get _canRestore =>
      _selectedHash != null && _diff != null && !_diffFailed && !_busy;

  Future<void> _restore() async {
    final target = _target;
    final hash = _selectedHash;
    if (target == null || hash == null || !_canRestore) return;
    final l10n = context.sharedL10n;
    final all = _revertOwnEdits;
    final confirmed = await _confirm(
      l10n.history_restore_title,
      all ? l10n.history_restore_body_all : l10n.history_restore_body,
    );
    if (!confirmed || !target.isCurrent) return;
    setState(() => _busy = true);
    try {
      final receipt = await target.restoreCheckpoint(
        hash: hash,
        confirmed: true,
        revertOwnEdits: all,
      );
      if (!mounted) return;
      final removed = receipt.historyRemoved;
      setState(() {
        _notice = removed == null || removed <= 0
            ? l10n.history_restored
            : l10n.history_restored_removed(removed);
        _openableSession = null;
        _busy = false;
      });
      if (removed != null && removed > 0) {
        // The transcript lost messages: the chat behind this page and the
        // list here must both read it again.
        widget.onRestored?.call();
        if (mounted) unawaited(_load());
      }
    } on WorkspaceException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _reason(error.reason);
        _busy = false;
      });
    }
  }

  Future<void> _export() async {
    final target = _target;
    if (target == null || _busy) return;
    final l10n = context.sharedL10n;
    setState(() => _busy = true);
    try {
      final exported = await target.exportTranscript(
        format: _format,
        redact: _redact,
      );
      if (!mounted || !target.isCurrent) return;
      final outcome = await widget.saveExport(exported);
      if (!mounted) return;
      setState(() {
        if (outcome == TranscriptExportOutcome.saved) {
          _notice = l10n.history_export_saved;
          _openableSession = null;
        }
        _busy = false;
      });
    } on WorkspaceException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _reason(error.reason);
        _busy = false;
      });
    } catch (_) {
      // The file could not be written or handed over.
      if (!mounted) return;
      setState(() {
        _error = _reason(WorkspaceFailure.unavailable);
        _busy = false;
      });
    }
  }

  Future<void> _reloadForeign(String? source) async {
    final target = _target;
    if (target == null) return;
    setState(() {
      _foreignSource = source;
      _foreignError = null;
      _selectedForeign = null;
      _foreignPreview = null;
      _foreignPreviewError = null;
    });
    try {
      final page = await target.foreignSessions(source: source);
      if (!mounted || !target.isCurrent || _foreignSource != source) return;
      setState(() {
        _foreignUnsupported = false;
        _foreign = page;
      });
    } on WorkspaceException catch (error) {
      if (!mounted) return;
      if (error.reason == WorkspaceFailure.unsupported) {
        setState(() {
          _foreignUnsupported = true;
          _foreign = null;
        });
        return;
      }
      setState(() => _foreignError = _reason(error.reason));
    }
  }

  Future<void> _loadMoreForeign() async {
    final target = _target;
    final current = _foreign;
    final nextOffset = current?.nextOffset;
    if (target == null ||
        current == null ||
        nextOffset == null ||
        _loadingMoreForeign) {
      return;
    }
    final source = _foreignSource;
    setState(() {
      _loadingMoreForeign = true;
      _foreignError = null;
    });
    try {
      final page = await target.foreignSessions(
        source: source,
        offset: nextOffset,
      );
      if (!mounted || !target.isCurrent || _foreignSource != source) return;
      final merged = <String, ForeignSessionSummary>{
        for (final row in current.sessions) row.id: row,
        for (final row in page.sessions) row.id: row,
      };
      setState(() {
        _foreign = ForeignSessionPage(
          sessions: merged.values.toList(growable: false),
          host: page.host,
          unreadable: current.unreadable + page.unreadable,
          nextOffset: page.nextOffset,
        );
        _loadingMoreForeign = false;
      });
    } on WorkspaceException catch (error) {
      if (!mounted) return;
      setState(() {
        _loadingMoreForeign = false;
        if (error.reason == WorkspaceFailure.unsupported) {
          _foreignUnsupported = true;
          _foreign = null;
        } else {
          _foreignError = _reason(error.reason);
        }
      });
    }
  }

  Future<void> _previewForeign(String id) async {
    final target = _target;
    if (target == null) return;
    setState(() {
      _selectedForeign = id;
      _foreignPreview = null;
      _foreignPreviewError = null;
      _foreignPreviewLoading = true;
    });
    try {
      final preview = await target.previewForeign(id);
      if (!mounted || !target.isCurrent || _selectedForeign != id) return;
      setState(() {
        _foreignPreview = preview;
        _foreignPreviewLoading = false;
      });
    } on WorkspaceException catch (error) {
      if (!mounted || _selectedForeign != id) return;
      if (error.reason == WorkspaceFailure.unsupported) {
        setState(() {
          _foreignUnsupported = true;
          _foreignPreview = null;
          _foreignPreviewLoading = false;
        });
        return;
      }
      setState(() {
        _foreignPreviewError = _reason(error.reason);
        _foreignPreviewLoading = false;
      });
    }
  }

  Future<void> _importForeign() async {
    final target = _target;
    final id = _selectedForeign;
    final preview = _foreignPreview;
    if (target == null || id == null || preview == null || _busy) return;
    final selectedRow = _foreign?.sessions
        .where((row) => row.id == id)
        .firstOrNull;
    final destination = target.effectiveProfile ?? 'default';
    final l10n = context.sharedL10n;
    final confirmed = await _confirm(
      l10n.history_import_title,
      preview.alreadyImported == null
          ? l10n.history_import_body(destination)
          : l10n.history_import_body_existing(destination),
    );
    if (!confirmed || !target.isCurrent) return;
    setState(() => _busy = true);
    try {
      final receipt = await target.importForeign(id);
      if (!mounted) return;
      setState(() {
        _notice = receipt.alreadyImported
            ? l10n.history_imported_already(receipt.sessionId)
            : l10n.history_imported(receipt.sessionId);
        _openableSession = (
          sessionId: receipt.sessionId,
          title: selectedRow?.title,
        );
        _busy = false;
      });
    } on WorkspaceException catch (error) {
      if (!mounted) return;
      if (error.reason == WorkspaceFailure.unsupported) {
        setState(() {
          _foreignUnsupported = true;
          _foreignPreview = null;
          _busy = false;
        });
        return;
      }
      setState(() {
        _error = _reason(error.reason);
        _busy = false;
      });
    }
  }

  void _openSession(String sessionId, {String? title}) {
    final callback = widget.onOpenSession;
    if (callback == null || !mounted) return;
    Navigator.of(context).pop();
    callback(sessionId, title: title);
  }

  List<ForeignSessionSummary> _visibleForeignSessions() {
    final rows = _foreign?.sessions ?? const <ForeignSessionSummary>[];
    final query = _foreignSearch.trim().toLowerCase();
    if (query.isEmpty) return rows;
    return [
      for (final row in rows)
        if ('${row.title} ${row.cwd ?? ''} ${row.excerpt}'
            .toLowerCase()
            .contains(query))
          row,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    final visibleForeign = _visibleForeignSessions();
    final destinationProfile =
        _target?.effectiveProfile ?? widget.owner.profile ?? 'default';
    final canMutate = _target?.canMutateHistory ?? true;
    final canExport = _target?.canExportTranscript ?? true;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _hasStoredSession
              ? l10n.session_history
              : l10n.import_claude_or_codex,
        ),
        actions: [
          IconButton(
            key: const ValueKey('history-refresh'),
            tooltip: l10n.refresh,
            onPressed: _loading || _busy ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              key: const ValueKey('history-scroll'),
              padding: const EdgeInsets.all(16),
              children: [
                if (_error != null)
                  Text(
                    l10n.history_failed(_error!),
                    key: const ValueKey('history-error'),
                  ),
                if (_notice != null)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(_notice!, key: const ValueKey('history-notice')),
                      if (widget.onOpenSession != null &&
                          _openableSession != null)
                        FilledButton.tonal(
                          key: const ValueKey('history-open-session'),
                          onPressed: _busy
                              ? null
                              : () => _openSession(
                                  _openableSession!.sessionId,
                                  title: _openableSession!.title,
                                ),
                          child: Text(l10n.history_open_chat),
                        ),
                    ],
                  ),
                if (_hasStoredSession) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.history_lineage,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (_lineageUnavailable)
                    Text(
                      l10n.history_lineage_unavailable,
                      key: const ValueKey('history-lineage-unavailable'),
                    )
                  else
                    _lineageTiles(l10n),
                  const SizedBox(height: 16),
                  Text(
                    l10n.history_messages,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (_messagesUnavailable)
                    Text(
                      l10n.history_messages_unavailable,
                      key: const ValueKey('history-messages-unavailable'),
                    )
                  else if (_messages.isEmpty)
                    Text(l10n.history_messages_none)
                  else if (canMutate)
                    Text(l10n.history_messages_hint),
                  for (final message in _messages)
                    ListTile(
                      key: ValueKey('history-message-${message.rowId}'),
                      selected: _selectedRow == message.rowId,
                      title: Text(
                        message.role == 'user'
                            ? l10n.history_role_user
                            : l10n.history_role_assistant,
                      ),
                      subtitle: Text(
                        message.text,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: canMutate
                          ? () => setState(() => _selectedRow = message.rowId)
                          : null,
                    ),
                  if (!canMutate)
                    Text(
                      l10n.history_mutate_unsupported,
                      key: const ValueKey('history-mutate-unsupported'),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton(
                          key: const ValueKey('history-branch'),
                          onPressed: _selectedRow == null || _busy
                              ? null
                              : _branch,
                          child: Text(l10n.history_branch_here),
                        ),
                        OutlinedButton(
                          key: const ValueKey('history-rewind'),
                          onPressed: _selectedRow == null || _busy
                              ? null
                              : _rewind,
                          child: Text(l10n.history_rewind_here),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.history_checkpoints,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (_checkpointsUnavailable)
                    Text(
                      l10n.history_checkpoints_unavailable,
                      key: const ValueKey('history-checkpoints-unavailable'),
                    )
                  else if (_checkpoints.isEmpty)
                    Text(l10n.history_checkpoints_none),
                  for (final checkpoint in _checkpoints)
                    ListTile(
                      key: ValueKey('history-checkpoint-${checkpoint.hash}'),
                      selected: _selectedHash == checkpoint.hash,
                      title: Text(
                        checkpoint.label.isEmpty
                            ? checkpoint.hash
                            : checkpoint.label,
                      ),
                      subtitle: Text(checkpoint.when),
                      onTap: () => _showDiff(checkpoint.hash),
                    ),
                  if (_selectedHash != null && _diffFailed)
                    Text(
                      l10n.history_diff_failed,
                      key: const ValueKey('history-diff-failed'),
                    )
                  else if (_selectedHash != null && _diff == null)
                    Text(
                      l10n.history_diff_loading,
                      key: const ValueKey('history-diff-loading'),
                    ),
                  if (_diff != null)
                    SelectableText(_diff!, key: const ValueKey('history-diff')),
                  if (_checkpoints.isNotEmpty) ...[
                    CheckboxListTile(
                      key: const ValueKey('history-restore-own-edits'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _revertOwnEdits,
                      title: Text(l10n.history_restore_own_edits),
                      onChanged: _busy
                          ? null
                          : (value) =>
                                setState(() => _revertOwnEdits = value == true),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: OutlinedButton(
                        key: const ValueKey('history-restore'),
                        onPressed: _canRestore ? _restore : null,
                        child: Text(l10n.history_restore_checkpoint),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    l10n.history_export,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (!canExport)
                    Text(
                      l10n.history_export_unsupported,
                      key: const ValueKey('history-export-unsupported'),
                    )
                  else ...[
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'json', label: Text('JSON')),
                        ButtonSegment(value: 'md', label: Text('Markdown')),
                        ButtonSegment(value: 'html', label: Text('HTML')),
                      ],
                      selected: {_format},
                      onSelectionChanged: (value) =>
                          setState(() => _format = value.single),
                    ),
                    SwitchListTile(
                      key: const ValueKey('history-redact'),
                      value: _redact,
                      title: Text(l10n.history_export_redact),
                      onChanged: (value) => setState(() => _redact = value),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FilledButton(
                        key: const ValueKey('history-export'),
                        onPressed: _busy ? null : _export,
                        child: Text(l10n.history_export_action),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
                Text(
                  l10n.import_claude_or_codex,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_foreignUnsupported)
                  Text(
                    l10n.history_import_unsupported,
                    key: const ValueKey('history-foreign-unsupported'),
                  )
                else ...[
                  Text(
                    _foreign == null
                        ? l10n.history_import_destination(destinationProfile)
                        : l10n.history_import_reading(
                            _foreign!.host,
                            destinationProfile,
                            _foreign!.unreadable,
                          ),
                    key: const ValueKey('history-foreign-meta'),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String?>(
                    segments: [
                      ButtonSegment(
                        value: null,
                        label: Text(l10n.history_import_all),
                      ),
                      const ButtonSegment(
                        value: 'claude',
                        label: Text('Claude Code'),
                      ),
                      const ButtonSegment(value: 'codex', label: Text('Codex')),
                    ],
                    selected: {_foreignSource},
                    onSelectionChanged: (value) => _reloadForeign(value.single),
                  ),
                  if ((_foreign?.sessions.isNotEmpty ?? false) ||
                      _foreignSearch.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    TextField(
                      key: const ValueKey('history-foreign-search'),
                      controller: _foreignSearchController,
                      decoration: InputDecoration(
                        labelText: l10n.search,
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) =>
                          setState(() => _foreignSearch = value),
                    ),
                  ],
                  if (_foreignError != null) ...[
                    const SizedBox(height: 8),
                    Text(l10n.history_import_scan_failed(_foreignError!)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton(
                        key: const ValueKey('history-foreign-retry'),
                        onPressed: () => _reloadForeign(_foreignSource),
                        child: Text(l10n.retry),
                      ),
                    ),
                  ] else if (_foreign != null && visibleForeign.isEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _foreignSearch.trim().isEmpty
                          ? l10n.history_import_none
                          : l10n.history_import_no_match,
                      key: const ValueKey('history-foreign-empty'),
                    ),
                  ],
                  for (final row in visibleForeign)
                    ListTile(
                      key: ValueKey('history-foreign-${row.id}'),
                      selected: _selectedForeign == row.id,
                      title: Text(row.title),
                      subtitle: Text(
                        [
                          '${row.label} · ${row.turns}',
                          if (row.cwd != null && row.cwd!.isNotEmpty)
                            row.cwd!
                          else if (row.excerpt.isNotEmpty)
                            row.excerpt,
                        ].join(' · '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _previewForeign(row.id),
                    ),
                  if (_foreign?.nextOffset != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        key: const ValueKey('history-foreign-more'),
                        onPressed: _loadingMoreForeign
                            ? null
                            : _loadMoreForeign,
                        child: Text(
                          _loadingMoreForeign ? l10n.loading : l10n.load_more,
                        ),
                      ),
                    ),
                  if (_foreignPreviewLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (_foreignPreviewError != null) ...[
                    Text(
                      l10n.history_import_preview_failed(_foreignPreviewError!),
                    ),
                    if (_selectedForeign != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton(
                          onPressed: () => _previewForeign(_selectedForeign!),
                          child: Text(l10n.retry),
                        ),
                      ),
                  ],
                  if (_foreignPreview != null)
                    _previewList(l10n, _foreignPreview!),
                  const SizedBox(height: 8),
                  FilledButton(
                    key: const ValueKey('history-import-host'),
                    onPressed: _foreignPreview == null || _busy
                        ? null
                        : _importForeign,
                    child: Text(
                      _foreignPreview?.alreadyImported != null
                          ? l10n.history_import_open
                          : l10n.history_import_action,
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _lineageTiles(AppLocalizations l10n) {
    final lineage = _lineage;
    if (lineage == null) return const SizedBox.shrink();
    final canOpen = widget.onOpenSession != null;
    final rows = <Widget>[
      if (lineage.parent != null)
        ListTile(
          key: ValueKey('history-lineage-parent-${lineage.parent!.id}'),
          title: Text(
            lineage.parent!.title.isEmpty
                ? lineage.parent!.id
                : lineage.parent!.title,
          ),
          subtitle: Text(l10n.history_lineage_parent),
          onTap: canOpen
              ? () => _openSession(
                  lineage.parent!.id,
                  title: lineage.parent!.title,
                )
              : null,
        ),
      for (final sibling in lineage.siblings)
        ListTile(
          key: ValueKey('history-lineage-sibling-${sibling.id}'),
          title: Text(sibling.title.isEmpty ? sibling.id : sibling.title),
          subtitle: Text(l10n.history_lineage_sibling),
          onTap: canOpen
              ? () => _openSession(sibling.id, title: sibling.title)
              : null,
        ),
      for (final child in lineage.children)
        ListTile(
          key: ValueKey('history-lineage-fork-${child.id}'),
          title: Text(child.title.isEmpty ? child.id : child.title),
          subtitle: Text(l10n.history_lineage_fork),
          onTap: canOpen
              ? () => _openSession(child.id, title: child.title)
              : null,
        ),
    ];
    if (rows.isEmpty) {
      return Text(l10n.history_lineage_none);
    }
    return Column(children: rows);
  }

  Widget _previewList(AppLocalizations l10n, ForeignPreviewView preview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (preview.cwd != null)
          Text(
            l10n.history_import_directory(preview.cwd!),
            key: const ValueKey('history-foreign-preview-cwd'),
          ),
        if (preview.truncated)
          Text(
            l10n.history_import_preview_partial(
              preview.messages.length,
              preview.total,
            ),
          ),
        for (final message in preview.messages)
          ListTile(
            title: Text(
              message.role == 'user'
                  ? l10n.history_role_user
                  : l10n.history_role_assistant,
            ),
            subtitle: Text(
              message.text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
