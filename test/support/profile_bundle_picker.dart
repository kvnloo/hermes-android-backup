import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Substitutes only the native choose/save dialog. The reviewed bytes are the
/// real archive the screen encoded; the dialog itself is not under test.
class ProfileBundlePicker extends FilePicker {
  ProfileBundlePicker(this.file);
  final File file;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async => FilePickerResult([
    PlatformFile(
      name: 'fixture.tar.gz',
      size: file.lengthSync(),
      path: file.path,
      // A real file stream never completes inside a widget test's fake clock.
      readStream: Stream<List<int>>.value(file.readAsBytesSync()),
    ),
  ]);

  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) async {
    if (bytes != null) file.writeAsBytesSync(bytes, flush: true);
    return file.path;
  }
}
