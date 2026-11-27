import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/chat_presentation_state.dart';
import '../services/composer_draft_store.dart';
import '../services/connection_manager.dart';

/// An explicit copy into a fresh, untouched composer. Never deletes a source
/// or sends text. Fetches metadata for the chosen ID only, not the whole list.
class OrphanDraftRecovery extends StatefulWidget {
  const OrphanDraftRecovery({
    super.key,
    required this.writer,
    required this.editor,
    required this.lookup,
    required this.isCurrent,
  });
  final ComposerDraftWriter writer;
  final TextEditingController editor;
  final Future<Map<String, dynamic>> Function(String) lookup;
  final bool Function() isCurrent;

  @override
  State<OrphanDraftRecovery> createState() => _OrphanDraftRecoveryState();
}

class _OrphanDraftRecoveryState extends State<OrphanDraftRecovery> {
  List<String> _sources = const [];
  (int, int)? _opened, _undo;
  bool _checking = false;
  bool get _current =>
      mounted &&
      widget.writer.isCurrent &&
      widget.isCurrent() &&
      ModalRoute.of(context)?.isCurrent != false;

  @override
  void initState() {
    super.initState();
    // The departing route's close checkpoint is queued during finalization
    // of this frame, after the replacement composer has already mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  Future<void> _load() async {
    try {
      final sources = await ComposerDraftStore.recoveryCandidates(
        widget.writer.draftHandle,
      );
      if (mounted && widget.writer.isCurrent && widget.isCurrent()) {
        setState(() => _sources = sources);
      }
    } on Object {
      // Storage unavailable; do not infer absence or change any draft.
    }
  }

  Future<void> _recover(String source) async {
    final writer = widget.writer;
    final started = _opened;
    bool eligible() =>
        _current &&
        writer.hasConfirmedEmptyDraft &&
        writer.revision == started &&
        widget.editor.text.isEmpty;
    if (!eligible() || _checking || !_sources.contains(source)) return;
    final l10n = context.sharedL10n;
    setState(() => _checking = true);
    try {
      if (!ComposerDraftStore.isLocalKey(source)) {
        // A source ID is an identifier, never a relative URL/path.
        if (source.trim() != source ||
            source.isEmpty ||
            source == '.' ||
            source == '..' ||
            RegExp(r'[/\\%?#\x00-\x1f\x7f]').hasMatch(source)) {
          throw const FormatException();
        }
        try {
          final row = await widget.lookup(source);
          if (!eligible()) return;
          if (row['id'] != source) throw const FormatException();
          _notice(l10n.draft_session_exists);
          return;
        } on SessionNotFoundException catch (error) {
          if (error.sessionId != source) rethrow;
        }
      }
      if (!eligible()) return;
      final text = await ComposerDraftStore.recoveryText(
        writer.draftHandle,
        source,
      );
      if (!eligible()) return;
      if (text == null) throw const ComposerDraftReadException();
      widget.editor.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
      _undo = writer.revision;
      unawaited(writer.flush());
    } catch (_) {
      if (eligible()) _notice(l10n.draft_recovery_unavailable);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  void _notice(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _undoCopy((int, int) expected, String text) async {
    final writer = widget.writer;
    bool eligible() =>
        _current &&
        writer.revision == expected &&
        _undo == expected &&
        widget.editor.text == text;
    if (!eligible() || !await writer.draftHandle.ownsLease()) {
      return;
    }
    if (!eligible()) return;
    _undo = null;
    widget.editor.clear();
    unawaited(writer.flush());
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.editor,
        builder: (context, value, _) {
          final l = context.sharedL10n;
          if (_undo != null &&
              _undo == widget.writer.revision &&
              value.text.isNotEmpty) {
            final revision = _undo!;
            return TextButton.icon(
              onPressed: () => _undoCopy(revision, value.text),
              icon: const Icon(Icons.undo),
              label: Text(l.undo_draft_recovery),
            );
          }
          if (_sources.isEmpty ||
              value.text.isNotEmpty ||
              !widget.writer.isCurrent ||
              !widget.isCurrent()) {
            return const SizedBox.shrink();
          }
          return PopupMenuButton<String>(
            tooltip: l.recover_text_draft,
            enabled: !_checking,
            onOpened: () => _opened = widget.writer.revision,
            onSelected: _recover,
            itemBuilder: (_) => [
              for (final id in widget.isCurrent() ? _sources : const <String>[])
                PopupMenuItem(
                  value: id,
                  child: Text(
                    ComposerDraftStore.isLocalKey(id)
                        ? '${l.new_chat} · ${id.substring(id.length - 8)}'
                        : id,
                  ),
                ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(l.recover_text_draft),
            ),
          );
        },
      );
}
