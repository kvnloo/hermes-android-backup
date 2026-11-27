import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/os_intake.dart';
import 'package:hermes_android/core/composer/windows_clipboard_image.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/services/attachment_draft_service.dart';
import 'package:image/image.dart' as image_lib;

Uint8List _native() =>
    File('test/fixtures/windows_clipboard/native-reader.bmp').readAsBytesSync();

void _pixels(Uint8List png) {
  expect(png.take(8), [137, 80, 78, 71, 13, 10, 26, 10]);
  final image = image_lib.decodePng(png)!;
  expect([image.width, image.height], [3, 2]);
  final colors = [
    [255, 0, 0],
    [0, 255, 0],
    [0, 0, 255],
    [255, 255, 255],
    [0, 0, 0],
    [255, 255, 0],
  ];
  for (var y = 0; y < 2; y++) {
    for (var x = 0; x < 3; x++) {
      final p = image.getPixel(x, y);
      expect([p.r, p.g, p.b, p.a], [...colors[y * 3 + x], 255]);
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'actual Windows plugin BMP output converts to opaque correct PNG pixels',
    () {
      _pixels(normalizeWindowsClipboardImage(_native()));
    },
  );

  test('top-down BMP transport preserves row order', () {
    final bytes = _native();
    final bottom = bytes.sublist(54, 66);
    bytes.setRange(54, 66, bytes.sublist(66, 78));
    bytes.setRange(66, 78, bottom);
    ByteData.sublistView(bytes).setInt32(22, -2, Endian.little);
    _pixels(normalizeWindowsClipboardImage(bytes));
  });

  test('24-bit BMP transport accepts DWORD-padded rows', () {
    final native = _native();
    final bytes = Uint8List.fromList(native);
    final data = ByteData.sublistView(bytes);
    data.setUint16(28, 24, Endian.little);
    for (var y = 0; y < 2; y++) {
      for (var x = 0; x < 3; x++) {
        bytes.setRange(
          54 + y * 12 + x * 3,
          57 + y * 12 + x * 3,
          native.sublist(54 + y * 12 + x * 4, 57 + y * 12 + x * 4),
        );
      }
      bytes.fillRange(63 + y * 12, 66 + y * 12, 0);
    }
    _pixels(normalizeWindowsClipboardImage(bytes));
  });

  final malformed = <String, void Function(ByteData)>{
    'huge width': (b) => b.setInt32(18, 0x7fffffff, Endian.little),
    'huge height': (b) => b.setInt32(22, 0x7fffffff, Endian.little),
    'INT_MIN height': (b) => b.setInt32(22, -0x80000000, Endian.little),
    'negative width': (b) => b.setInt32(18, -3, Endian.little),
    'zero height': (b) => b.setInt32(22, 0, Endian.little),
    'oversized pixel budget': (b) {
      b.setInt32(18, 4097, Endian.little);
      b.setInt32(22, 4096, Endian.little);
    },
    'offset wraps': (b) => b.setUint32(10, 0xffffffff, Endian.little),
    'offset inside header': (b) => b.setUint32(10, 40, Endian.little),
    'file length mismatch': (b) => b.setUint32(2, 54, Endian.little),
    'pixel length mismatch': (b) => b.setUint32(34, 1, Endian.little),
    'unsupported header': (b) => b.setUint32(14, 124, Endian.little),
    'palette allocation': (b) => b.setUint32(46, 0xffffffff, Endian.little),
    'compression': (b) => b.setUint32(30, 0xffffffff, Endian.little),
    'unsupported depth': (b) => b.setUint16(28, 8, Endian.little),
    'multiple planes': (b) => b.setUint16(26, 2, Endian.little),
  };
  for (final entry in malformed.entries) {
    test('reject BMP before decode: ${entry.key}', () {
      final bytes = _native();
      entry.value(ByteData.sublistView(bytes));
      expect(
        () => normalizeWindowsClipboardImage(bytes),
        throwsFormatException,
      );
    });
  }

  test('truncated BMP headers and pixels are rejected', () {
    for (final size in [2, 13, 53, 54, 77]) {
      expect(
        () => normalizeWindowsClipboardImage(_native().sublist(0, size)),
        throwsFormatException,
      );
    }
  });

  test('PNG alpha and other formats remain unchanged, not relabeled PNG', () {
    final rgba = image_lib.Image(width: 1, height: 1, numChannels: 4)
      ..setPixelRgba(0, 0, 12, 34, 56, 78);
    final png = image_lib.encodePng(rgba);
    expect(identical(normalizeWindowsClipboardImage(png), png), isTrue);
    expect(image_lib.decodePng(png)!.getPixel(0, 0).a, 78);
    for (final bytes in [
      Uint8List.fromList([1, 2, 3]),
      _native().sublist(14),
    ]) {
      expect(identical(normalizeWindowsClipboardImage(bytes), bytes), isTrue);
      expect(image_lib.decodePng(bytes), isNull);
    }
  });

  test(
    'service rejects raw native BMP; converted repeated pastes are sanitized drafts',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'windows-paste-service-',
      );
      addTearDown(() => root.delete(recursive: true));
      final service = AttachmentDraftService(
        cacheDirectoryProvider: () async => root,
      );
      final source = await File(
        '${root.path}/paste.png',
      ).writeAsBytes(_native());
      Future<AttachmentDraft> prepare(List<AttachmentDraft> drafts) =>
          service.prepareImage(
            sourcePath: source.path,
            displayName: 'paste.png',
            existingDrafts: drafts,
            mode: AttachmentDraftMode.remoteGateway,
          );
      await expectLater(prepare([]), throwsA(isA<AttachmentDraftException>()));
      await source.writeAsBytes(normalizeWindowsClipboardImage(_native()));
      final first = await prepare([]);
      final second = await prepare([first]);
      expect(first.cachedPath, isNot(second.cachedPath));
      for (final draft in [first, second]) {
        expect(draft.sanitized, isTrue);
        expect(draft.mediaType, 'image/png');
        _pixels(await File(draft.cachedPath).readAsBytes());
      }
      // Raw headerless CF_DIB is not silently accepted by the service either.
      await source.writeAsBytes(_native().sublist(14));
      await expectLater(prepare([]), throwsA(isA<AttachmentDraftException>()));
    },
  );

  test(
    'real shared intake normalizes plugin channel bytes only on Windows',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'windows-paste-channel-',
      );
      addTearDown(() => root.delete(recursive: true));
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      const channel = MethodChannel('pasteboard');
      messenger.setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'files') return <String>[];
        if (call.method == 'image') {
          // Pasteboard's Dart adapter branches on the actual host OS, not Flutter's
          // target override. Windows reads AND deletes this native temporary file.
          if (Platform.isWindows) {
            return (await File(
              '${root.path}/native.tmp',
            ).writeAsBytes(_native())).path;
          }
          return _native();
        }
        return null;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
      _pixels((await readClipboardAttachment())!.image!);
      _pixels((await readClipboardAttachment())!.image!);
      if (Platform.isWindows) {
        expect(File('${root.path}/native.tmp').existsSync(), isFalse);
      }
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect((await readClipboardAttachment())!.image!.take(2), [0x42, 0x4d]);
    },
  );
}
