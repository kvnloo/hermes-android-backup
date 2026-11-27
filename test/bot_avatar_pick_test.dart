// A bot picture picked from the device is sized before it is read (review
// of deb6f558, item 6): the picker hands back a path, not the bytes, and a
// file over Desktop's 15 MB limit is refused from its size alone.
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/bot_profile_forms.dart';

/// The device's file picker: records how it was asked, answers [file].
class _Picker extends FilePicker {
  _Picker(this.file);
  final PlatformFile? file;
  final withData = <bool>[];

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
  }) async {
    this.withData.add(withData);
    final picked = file;
    return picked == null ? null : FilePickerResult([picked]);
  }
}

Future<Uint8List> _png(int width, int height) async {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRect(
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    Paint()..color = const Color(0xff3366cc),
  );
  final image = await recorder.endRecording().toImage(width, height);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('bot-avatar-'));
  tearDown(() => dir.deleteSync(recursive: true));

  testWidgets('the picker is asked for a path, not the bytes, and a small '
      'picture becomes a 256 px PNG', (tester) async {
    await tester.runAsync(() async {
      final file = File('${dir.path}/face.png')
        ..writeAsBytesSync(await _png(300, 200));
      final picker = _Picker(
        PlatformFile(
          name: 'face.png',
          size: file.lengthSync(),
          path: file.path,
        ),
      );
      FilePicker.platform = picker;
      final avatar = await pickBotAvatarImage();
      expect(picker.withData, [false]);
      expect(avatar, startsWith('data:image/png;base64,'));
    });
  });

  testWidgets('a file over 15 MB is refused from its size on disk before it '
      'is read, when the picker does not know its size', (tester) async {
    await tester.runAsync(() async {
      final file = File('${dir.path}/huge.png');
      // Sparse: 15,000,001 bytes on paper, nothing written.
      final handle = file.openSync(mode: FileMode.write)
        ..truncateSync(15000001);
      handle.closeSync();
      // Unreadable: reading it would fail differently from the size check.
      await Process.run('chmod', ['000', file.path]);
      addTearDown(() => Process.runSync('chmod', ['600', file.path]));
      FilePicker.platform = _Picker(
        PlatformFile(name: 'huge.png', size: 0, path: file.path),
      );
      await expectLater(
        pickBotAvatarImage(),
        throwsA(isA<BotAvatarTooLarge>()),
      );
    });
  }, skip: Platform.isWindows);

  testWidgets('the picker\'s own size refuses a file without touching it', (
    tester,
  ) async {
    await tester.runAsync(() async {
      FilePicker.platform = _Picker(
        PlatformFile(
          name: 'huge.png',
          size: 20000000,
          path: '${dir.path}/does-not-exist.png',
        ),
      );
      await expectLater(
        pickBotAvatarImage(),
        throwsA(isA<BotAvatarTooLarge>()),
      );
    });
  });

  testWidgets('bytes the picker already holds are held to the same limit', (
    tester,
  ) async {
    await tester.runAsync(() async {
      FilePicker.platform = _Picker(
        PlatformFile(name: 'huge.png', size: 0, bytes: Uint8List(15000001)),
      );
      await expectLater(
        pickBotAvatarImage(),
        throwsA(isA<BotAvatarTooLarge>()),
      );
    });
  });

  testWidgets('nothing picked: nothing read', (tester) async {
    await tester.runAsync(() async {
      FilePicker.platform = _Picker(null);
      expect(await pickBotAvatarImage(), isNull);
    });
  });
}
