import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// file_picker 10.3.3 writes supplied bytes on mobile, Windows and macOS.
/// Its Linux XDG implementation only returns the user-selected destination.
Future<String?> saveProfileFile({
  required String title,
  required String filename,
  required Uint8List bytes,
  required void Function() check,
}) async {
  check();
  final path = await FilePicker.platform.saveFile(
    dialogTitle: title,
    fileName: filename,
    bytes: Platform.isLinux ? null : bytes,
  );
  check();
  if (path != null && Platform.isLinux) {
    await writeSelectedProfileFile(path, bytes, check);
  }
  return path;
}

/// Stage the sensitive file privately and replace only the path selected in
/// the native save panel. Never follow a destination symlink, leave a partial
/// backup, or fall back to another folder when the portal refuses the write.
Future<void> writeSelectedProfileFile(
  String path,
  Uint8List bytes,
  void Function() check,
) async {
  final destination = File(path);
  if (!destination.isAbsolute || bytes.isEmpty) {
    throw const FileSystemException('Invalid archive destination');
  }
  final type = await FileSystemEntity.type(path, followLinks: false);
  if (type != FileSystemEntityType.file &&
      type != FileSystemEntityType.notFound) {
    throw const FileSystemException('Choose a regular file');
  }
  check();
  final temp = await destination.parent.createTemp('.ares-save-');
  try {
    final stage = await File('${temp.path}/archive').create(exclusive: true);
    final mode = await Process.run('/bin/chmod', ['600', stage.path]);
    if (mode.exitCode != 0) {
      throw const FileSystemException(
        'Private archive permissions unavailable',
      );
    }
    check();
    await stage.writeAsBytes(bytes, flush: true);
    if (await stage.length() != bytes.length) {
      throw const FileSystemException('Incomplete archive');
    }
    check();
    await stage.rename(path);
  } finally {
    await temp.delete(recursive: true);
  }
}
