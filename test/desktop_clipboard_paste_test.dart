import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/os_intake.dart';

final _desktop = TargetPlatformVariant({
  TargetPlatform.macOS,
  TargetPlatform.windows,
  TargetPlatform.linux,
});

Future<void> _paste(WidgetTester tester) async {
  await tester.showKeyboard(find.byType(TextField));
  final modifier = defaultTargetPlatform == TargetPlatform.macOS
      ? LogicalKeyboardKey.metaLeft
      : LogicalKeyboardKey.controlLeft;
  await tester.sendKeyDownEvent(modifier);
  await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
  await tester.sendKeyUpEvent(modifier);
  await tester.pump();
}

void main() {
  tearDown(() {
    debugClipboardAttachmentReader = null;
  });

  testWidgets('desktop image-only context menu offers attachment Paste', (
    tester,
  ) async {
    debugClipboardAttachmentReader = () async =>
        ClipboardAttachment(image: Uint8List.fromList([1]));
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.hasStrings') return {'value': false};
        return null;
      },
    );
    var pasted = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClipboardAttachmentPaste(
            onAttachment: (_) async {
              pasted++;
            },
            child: const TextField(
              contextMenuBuilder: ClipboardAttachmentPaste.contextMenuBuilder,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.tapAt(
      tester.getTopLeft(find.byType(EditableText)) + const Offset(10, 10),
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    );
    await tester.pumpAndSettle();
    expect(find.text('Paste'), findsOneWidget);
    await tester.tap(find.text('Paste'));
    await tester.pumpAndSettle();
    expect(pasted, 1);
  }, variant: _desktop);

  for (final remount in [false, true]) {
    for (final textOnly in [false, true]) {
      testWidgets(
        'delayed ${textOnly ? 'text' : 'image'} read is fenced across owner A/B/A (remount=$remount)',
        (tester) async {
          final pending = Completer<ClipboardAttachment?>();
          debugClipboardAttachmentReader = () => pending.future;
          var pasted = 0;
          final controller = TextEditingController();
          addTearDown(controller.dispose);
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            (call) async {
              if (call.method == 'Clipboard.getData') {
                return {'text': 'must not paste into B'};
              }
              return null;
            },
          );
          Future<void> build(String id) => tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ClipboardAttachmentPaste(
                  key: remount ? ValueKey(id) : null,
                  owner: id,
                  onAttachment: (_) async {
                    pasted++;
                  },
                  child: TextField(
                    controller: controller,
                    contextMenuBuilder:
                        ClipboardAttachmentPaste.contextMenuBuilder,
                  ),
                ),
              ),
            ),
          );
          await build('a');
          await _paste(tester);
          await build('b');
          await build('a');
          pending.complete(
            textOnly
                ? null
                : ClipboardAttachment(image: Uint8List.fromList([1])),
          );
          await tester.pump();
          expect(pasted, 0);
          expect(controller.text, isEmpty);
          await tester.pumpWidget(const SizedBox.shrink());
        },
        variant: _desktop,
      );
    }
  }

  for (final failure in [false, true]) {
    for (final toolbar in [false, true]) {
      testWidgets(
        'text-only fallback preserves selection, toolbar=$toolbar read failure=$failure',
        (tester) async {
          debugClipboardAttachmentReader = () async {
            if (failure) throw PlatformException(code: 'denied');
            return null;
          };
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            (call) async {
              if (call.method == 'Clipboard.getData') {
                return {'text': ' pasted'};
              }
              if (call.method == 'Clipboard.hasStrings') return {'value': true};
              return null;
            },
          );
          final controller = TextEditingController(text: 'keep');
          addTearDown(controller.dispose);
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ClipboardAttachmentPaste(
                  onAttachment: (_) async {
                    fail('plain text must not become an attachment');
                  },
                  child: TextField(
                    controller: controller,
                    contextMenuBuilder:
                        ClipboardAttachmentPaste.contextMenuBuilder,
                  ),
                ),
              ),
            ),
          );
          await tester.showKeyboard(find.byType(TextField));
          controller.selection = const TextSelection.collapsed(offset: 4);
          if (toolbar) {
            await tester.tapAt(
              tester.getTopLeft(find.byType(EditableText)) +
                  const Offset(200, 10),
              kind: PointerDeviceKind.mouse,
              buttons: kSecondaryMouseButton,
            );
            await tester.pumpAndSettle();
            await tester.tap(find.text('Paste'));
            await tester.pumpAndSettle();
          } else {
            await _paste(tester);
          }
          expect(controller.text, 'keep pasted');
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        },
        variant: _desktop,
      );
    }
  }

  testWidgets(
    'existing pasteboard channel reads multiple paths before bitmap; unavailable files falls back to image',
    (tester) async {
      final methods = <String>[];
      var paths = true;
      final bytes = Uint8List.fromList([1, 2, 3]);
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('pasteboard'),
        (call) async {
          methods.add(call.method);
          if (call.method == 'files') {
            if (!paths) throw PlatformException(code: 'unsupported');
            return ['/fixture/a.png', '', '/fixture/b.jpg'];
          }
          if (call.method == 'image') {
            // The plugin returns encoded bytes on macOS/Linux and a temporary
            // BMP path on Windows (format normalization is tested separately).
            if (Platform.isWindows) {
              final dir = await Directory.systemTemp.createTemp(
                'clipboard-channel-',
              );
              addTearDown(() => dir.delete(recursive: true));
              return (await File(
                '${dir.path}/image.png',
              ).writeAsBytes(bytes)).path;
            }
            return bytes;
          }
          return null;
        },
      );
      final files = await readClipboardAttachment();
      expect(files!.files, ['/fixture/a.png', '/fixture/b.jpg']);
      expect(methods, ['files']);
      paths = false;
      final image = await readClipboardAttachment();
      expect(image!.image, bytes);
      expect(methods, ['files', 'files', 'image']);
    },
    variant: _desktop,
  );
}
