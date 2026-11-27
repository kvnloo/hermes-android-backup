import 'dart:async';

import 'package:flutter/services.dart';

import '../utils/large_paste.dart';
import 'composer_drag.dart';

const kLocalImageExtensions = {'png', 'jpg', 'jpeg', 'webp'};

/// One composer's attachment intake, one job at a time.
///
/// Every way a draft arrives (an OS drop, a paste, a keyboard image, the
/// Attach picker, a drag from the files panel) checks the free slots and the
/// size budget against the drafts already staged, then awaits file work. Two
/// jobs that both checked before either finished would both pass, so the
/// composer runs the check and its prepare inside [run]: each job starts
/// only after the one before it has staged its draft (or failed).
///
/// A job must not await another [run] of the same queue: it would wait on
/// itself.
class ComposerIntakeQueue {
  Future<void> _tail = Future<void>.value();
  int _pending = 0;

  /// Whether a job is waiting or running.
  bool get busy => _pending > 0;

  Future<T> run<T>(Future<T> Function() job) {
    final previous = _tail;
    final done = Completer<void>();
    _tail = done.future;
    _pending++;
    return () async {
      try {
        await previous;
        return await job();
      } finally {
        _pending--;
        done.complete();
      }
    }();
  }
}

enum LocalIntake { leaveText, pastedText, imageFile, genericFile, reference }

class IntakePlan {
  const IntakePlan(this.kind, {this.path, this.text, this.directory = false});

  final LocalIntake kind;
  final String? path;
  final String? text;
  final bool directory;
}

/// A single pasted chunk that is a filesystem path or file URL, or null.
String? clipboardPath(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty || trimmed.contains('\n') || trimmed.contains('\r')) {
    return null;
  }
  if (trimmed.startsWith('file://')) {
    final uri = Uri.tryParse(trimmed);
    if (uri == null || uri.scheme != 'file') return null;
    final path = uri.toFilePath();
    return path.isEmpty ? null : path;
  }
  final absolute =
      trimmed.startsWith('/') || RegExp(r'^[A-Za-z]:[\\/]').hasMatch(trimmed);
  return absolute ? trimmed : null;
}

bool looksLikeImagePath(String path) {
  final dot = path.lastIndexOf('.');
  if (dot < 0 || dot == path.length - 1) return false;
  return kLocalImageExtensions.contains(path.substring(dot + 1).toLowerCase());
}

/// Classify a drag. Existence of a local file is the caller's check: a missing
/// local path must not become an attachment.
IntakePlan classifyDrag(ComposerDrag drag) {
  if (drag.onGateway || drag.directory) {
    return IntakePlan(
      LocalIntake.reference,
      path: drag.path,
      directory: drag.directory || drag.onGateway && drag.directory,
    );
  }
  if (looksLikeImagePath(drag.path)) {
    return IntakePlan(LocalIntake.imageFile, path: drag.path);
  }
  return IntakePlan(LocalIntake.genericFile, path: drag.path);
}

/// A committed paste. Oversized text becomes a paste file. A single path is
/// only an attachment after [pathExists] is true.
IntakePlan classifyPaste(
  String inserted, {
  required bool pathExists,
  required bool directory,
}) {
  if (inserted.length > largePasteAttachmentThreshold) {
    return IntakePlan(LocalIntake.pastedText, text: inserted);
  }
  final path = clipboardPath(inserted);
  if (path == null) return const IntakePlan(LocalIntake.leaveText);
  if (!pathExists) return const IntakePlan(LocalIntake.leaveText);
  if (directory) {
    return IntakePlan(LocalIntake.reference, path: path, directory: true);
  }
  if (looksLikeImagePath(path)) {
    return IntakePlan(LocalIntake.imageFile, path: path);
  }
  return IntakePlan(LocalIntake.genericFile, path: path);
}

class PastedChunk {
  const PastedChunk(this.text, this.withoutPaste, this.caret);

  final String text;

  /// Editor value with the chunk removed, so a confirmed file paste does not
  /// also leave the path in the draft.
  final String withoutPaste;
  final int caret;

  /// Where this paste sits in [text] now: at its caret when it is still
  /// there, else the copy nearest the caret (edits before it moved it). An
  /// earlier copy the person typed or pasted is never the first choice.
  /// -1 when the pasted text is gone.
  int offsetIn(String text) {
    final end = caret + this.text.length;
    if (caret >= 0 &&
        end <= text.length &&
        text.substring(caret, end) == this.text) {
      return caret;
    }
    var best = -1;
    for (
      var at = text.indexOf(this.text);
      at >= 0;
      at = text.indexOf(this.text, at + 1)
    ) {
      if (best < 0 || (at - caret).abs() < (best - caret).abs()) best = at;
    }
    return best;
  }

  /// [text] without this paste (see [offsetIn]), the caret where it was;
  /// null when the pasted text is gone.
  TextEditingValue? removeFrom(String text) {
    final at = offsetIn(text);
    if (at < 0) return null;
    return TextEditingValue(
      text: text.replaceRange(at, at + this.text.length, ''),
      selection: TextSelection.collapsed(offset: at),
    );
  }

  /// A single insertion at the caret. One-character typing is ignored.
  static PastedChunk? detect(String before, int start, int end, String after) {
    if (start < 0 || end < start || end > before.length) return null;
    final prefix = before.substring(0, start);
    final suffix = before.substring(end);
    if (!after.startsWith(prefix) || !after.endsWith(suffix)) return null;
    final length = after.length - prefix.length - suffix.length;
    if (length < 2) return null;
    final inserted = after.substring(prefix.length, prefix.length + length);
    return PastedChunk(inserted, '$prefix$suffix', prefix.length);
  }
}
