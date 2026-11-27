import 'dart:typed_data';
import 'dart:ui';

import '../models/attachment_draft.dart';
import '../services/attachment_draft_service.dart';

class PreviewPin {
  const PreviewPin(this.number, this.rect, this.selector, this.note, this.png);
  final int number;
  final Rect rect;
  final String selector, note;
  final Uint8List png;
}

typedef CommitPreviewDraft =
    void Function(String text, List<AttachmentDraft> crops);

/// Prepare all crops, verify the still-current composer and its current limits,
/// then append once. A failed/stale batch leaves neither chips nor text behind.
Future<void> stagePreviewEvidence({
  required String prompt,
  required List<PreviewPin> pins,
  required AttachmentDraftService service,
  required List<AttachmentDraft> existing,
  required void Function() check,
  required CommitPreviewDraft commit,
}) async {
  final prepared = <AttachmentDraft>[];
  try {
    for (final pin in pins) {
      check();
      prepared.add(
        await service.preparePreviewCrop(
          png: pin.png,
          pin: pin.number,
          existingDrafts: [...existing, ...prepared],
        ),
      );
    }
    check();
    service.validateRemoteDrafts([...existing, ...prepared]);
    commit(prompt, prepared);
  } catch (_) {
    await service.removeAll(prepared);
    rethrow;
  }
}

String annotationPrompt(
  String origin,
  List<PreviewPin> pins, {
  required String Function(String origin) introduction,
}) => [
  introduction(origin),
  for (final p in pins)
    '#${p.number} · ${p.selector} · ${p.rect.left.round()},${p.rect.top.round()} (${p.rect.width.round()} × ${p.rect.height.round()}): ${p.note}',
].join('\n');
