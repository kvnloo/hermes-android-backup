import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

import '../models/attachment_draft.dart';
import '../services/attachment_draft_service.dart';
import '../services/prepared_image_store.dart';

/// Read only this chat's journal folder on mount, target/store/revision changes,
/// and store notifications. Choosing a row fills the composer; neither opening
/// the chooser nor restoring a row submits anything.
class PreparedImageRecovery extends StatefulWidget {
  const PreparedImageRecovery({
    super.key,
    required this.target,
    required this.revision,
    required this.install,
    this.store,
  });
  final PreparedImageTarget target;
  final Object? Function() revision;
  final void Function(String, List<AttachmentDraft>) install;
  final PreparedImageStore? store;
  @override
  State<PreparedImageRecovery> createState() => _PreparedImageRecoveryState();
}

class _PreparedImageRecoveryState extends State<PreparedImageRecovery> {
  bool busy = false;
  bool _recoverable = false;
  String? _checkedTarget;
  Object? _checkedRevision;
  int _checkGeneration = 0;

  @override
  void initState() {
    super.initState();
    PreparedImageStore.changes.addListener(_check);
    _check();
  }

  @override
  void didUpdateWidget(PreparedImageRecovery oldWidget) {
    super.didUpdateWidget(oldWidget);
    final retarget =
        oldWidget.target.key != widget.target.key ||
        oldWidget.store != widget.store;
    // Only a different chat or store hides the button before the re-read; a
    // revision change keeps the current answer until the re-read lands, so a
    // shown button does not blink.
    if (retarget) _recoverable = false;
    if (retarget || _checkedRevision != widget.revision()) _check();
  }

  void _check() async {
    final generation = ++_checkGeneration;
    final target = widget.target;
    _checkedRevision = widget.revision();
    final found = await (widget.store ?? PreparedImageStore.shared)
        .hasRecoverable(target);
    if (!mounted ||
        generation != _checkGeneration ||
        widget.target.key != target.key) {
      return;
    }
    setState(() {
      _checkedTarget = target.key;
      _recoverable = found;
    });
  }

  @override
  void dispose() {
    PreparedImageStore.changes.removeListener(_check);
    super.dispose();
  }

  Future<void> open() async {
    final l10n = context.sharedL10n;
    if (busy) return;
    final revision = widget.revision();
    if (revision == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring,
          ),
        ),
      );
      return;
    }
    setState(() => busy = true);
    final target = widget.target;
    bool current() =>
        mounted &&
        widget.target.key == target.key &&
        widget.revision() == revision;
    final store = widget.store ?? PreparedImageStore.shared;
    try {
      final entries = await store.list(target);
      if (!mounted || !current()) return;
      if (entries.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat,
            ),
          ),
        );
        return;
      }
      final choice = await showModalBottomSheet<({PreparedImageEntry entry, bool discard})>(
        context: context,
        builder: (context) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(
                  l10n.release_core_prepared_image_recovery_unacknowledged_image_drafts,
                ),
                subtitle: Text(
                  l10n.release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore,
                ),
              ),
              for (final entry in entries)
                ListTile(
                  title: Text(
                    entry.text.isEmpty
                        ? l10n.release_core_prepared_image_recovery_image_draft
                        : entry.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    [
                      l10n.release_core_image_recovery_metadata(
                        entry.imageCount,
                        MaterialLocalizations.of(
                          context,
                        ).formatFullDate(entry.created.toLocal()),
                      ),
                      if (entry.copyOnly)
                        l10n.release_core_image_recovery_new_turn,
                    ].join(' · '),
                  ),
                  onTap: () =>
                      Navigator.pop(context, (entry: entry, discard: false)),
                  trailing: IconButton(
                    tooltip: l10n
                        .release_core_prepared_image_recovery_discard_local_copy,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        Navigator.pop(context, (entry: entry, discard: true)),
                  ),
                ),
            ],
          ),
        ),
      );
      if (!mounted || !current() || choice == null) return;
      if (choice.discard) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              l10n.release_core_prepared_image_recovery_discard_this_local_image_draft,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.release_core_git_review_pane_discard),
              ),
            ],
          ),
        );
        if (confirmed == true && current()) {
          await PreparedImageStore.retire(choice.entry);
        }
        return;
      }
      final drafts = await store.restore(choice.entry, current);
      if (drafts == null) return;
      if (!current()) {
        await AttachmentDraftService().removeAll(drafts);
        return;
      }
      widget.install(choice.entry.text, drafts);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.release_core_prepared_image_recovery_image_draft_recovery_is_unavailable,
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) =>
      !busy && (!_recoverable || _checkedTarget != widget.target.key)
      ? const SizedBox.shrink()
      : TextButton.icon(
          onPressed: busy ? null : open,
          icon: const Icon(Icons.restore, size: 18),
          label: Text(
            context
                .sharedL10n
                .release_core_prepared_image_recovery_recover_image_draft,
          ),
        );
}
