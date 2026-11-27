import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/os_intake.dart';

/// Method-channel fixture only, NOT native clipboard E2E. Uses the bytes
/// exported by the real pinned Windows plugin/GDI harness for screenshot data.
void useNativeWindowsClipboardFixture({
  required Directory root,
  required ClipboardAttachment? Function() current,
  required Uint8List screenshotToken,
}) {
  if (defaultTargetPlatform != TargetPlatform.windows) return;
  debugClipboardAttachmentReader = null;
  const channel = MethodChannel('pasteboard');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final bmp = File(
    'test/fixtures/windows_clipboard/native-reader.bmp',
  ).readAsBytesSync();
  var sequence = 0;
  messenger.setMockMethodCallHandler(channel, (call) async {
    final clip = current();
    if (call.method == 'files') return clip?.files ?? <String>[];
    if (call.method == 'image') {
      final bytes = identical(clip?.image, screenshotToken) ? bmp : clip?.image;
      if (bytes == null) return null;
      if (Platform.isWindows) {
        return (File(
          '${root.path}/native-${sequence++}.tmp',
        )..writeAsBytesSync(bytes)).path;
      }
      return bytes;
    }
    return null;
  });
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
}
