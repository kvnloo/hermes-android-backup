import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

import '../services/client_held_queue.dart';

class ClientHeldQueueRow {
  const ClientHeldQueueRow({
    required this.id,
    required this.text,
    this.canEdit = true,
  });

  final String id;
  final String text;
  final bool canEdit;
}

/// The composer strip Desktop shows for prompts that have not been admitted.
///
/// Resume is present only while the strip is parked. There is no control here
/// that holds a healthy gateway FIFO.
class ClientHeldQueueBar extends StatelessWidget {
  const ClientHeldQueueBar({
    super.key,
    required this.count,
    required this.parked,
    required this.rows,
    required this.onResume,
    required this.onSend,
    required this.onRemove,
    this.onEdit,
  });

  final int count;
  final bool parked;
  final List<ClientHeldQueueRow> rows;
  final VoidCallback onResume;
  final ValueChanged<String> onSend;
  final ValueChanged<String> onRemove;
  final ValueChanged<String>? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = clientHeldQueueLabel(
      count: count,
      parked: parked,
      strings: context.sharedL10n,
    );
    return Padding(
      key: const ValueKey('client-held-queue'),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  key: const ValueKey('client-held-queue-label'),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              if (parked)
                TextButton(
                  onPressed: onResume,
                  child: Text(
                    context
                        .sharedL10n
                        .release_core_client_held_queue_bar_resume,
                  ),
                ),
            ],
          ),
          for (final row in rows)
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.text,
                    key: ValueKey('client-held-queue-text-${row.id}'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: context
                      .sharedL10n
                      .release_core_client_held_queue_bar_send_queued_prompt,
                  icon: const Icon(Icons.send, size: 16),
                  onPressed: () => onSend(row.id),
                ),
                if (onEdit != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: context
                        .sharedL10n
                        .release_core_client_held_queue_bar_edit_unsent_prompt,
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    onPressed: row.canEdit ? () => onEdit!(row.id) : null,
                  ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: context
                      .sharedL10n
                      .release_core_client_held_queue_bar_remove_unsent_prompt,
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => onRemove(row.id),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
