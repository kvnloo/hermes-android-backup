import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'remote_workspace.dart' show HistoryExport;

/// Where an exported transcript went.
enum TranscriptExportOutcome {
  /// Written to the file the person chose in the save dialog.
  saved,

  /// Handed to the system share sheet as a file.
  shared,

  /// The dialog or sheet was dismissed; nothing was kept.
  cancelled,
}

typedef TranscriptExportSaver =
    Future<TranscriptExportOutcome> Function(HistoryExport export);

const _mimeTypes = {
  'json': 'application/json',
  'md': 'text/markdown',
  'html': 'text/html',
};

/// Saves an exported transcript as a FILE, never as text in a share sheet.
///
/// On desktop it is a save-as dialog, as Hermes Desktop's `saveTextFileAs`.
/// Android and iOS have no such dialog to rely on, so the transcript is
/// written to the app cache, shared as that file, and deleted afterwards.
Future<TranscriptExportOutcome> saveTranscriptExport(
  HistoryExport export,
) async {
  final bytes = Uint8List.fromList(utf8.encode(export.content));
  final mobile =
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
  if (!mobile) {
    // file_picker writes the bytes itself on Windows and macOS; its Linux
    // dialog only returns the chosen path.
    final linux = defaultTargetPlatform == TargetPlatform.linux;
    final path = await FilePicker.platform.saveFile(
      fileName: export.filename,
      bytes: linux ? null : bytes,
    );
    if (path == null) return TranscriptExportOutcome.cancelled;
    if (linux) await File(path).writeAsBytes(bytes, flush: true);
    return TranscriptExportOutcome.saved;
  }
  final cache = await getTemporaryDirectory();
  final folder = await Directory(
    '${cache.path}/transcript-export',
  ).create(recursive: true);
  final file = File('${folder.path}/${export.filename}');
  await file.writeAsBytes(bytes, flush: true);
  try {
    final result = await SharePlus.instance.share(
      ShareParams(
        subject: export.filename,
        files: [XFile(file.path, mimeType: _mimeTypes[export.format])],
      ),
    );
    return result.status == ShareResultStatus.dismissed
        ? TranscriptExportOutcome.cancelled
        : TranscriptExportOutcome.shared;
  } finally {
    try {
      await file.delete();
    } catch (_) {
      // Already gone, or still held by the receiving app: the cache is the
      // system's to clear.
    }
  }
}
