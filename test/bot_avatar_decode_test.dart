// A bot picture is decoded at most a little larger than the 256 px avatar
// it becomes (review of deb6f558, item 6): the size comes from the
// picture's header, so a few kilobytes of PNG claiming huge dimensions are
// never decoded at full size on a phone.
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/bot_profile_forms.dart';

/// A [width] x [height] PNG: red on its left half, blue on its right.
Future<Uint8List> _halves(int width, int height) async {
  final recorder = ui.PictureRecorder();
  Canvas(recorder)
    ..drawRect(
      Rect.fromLTWH(0, 0, width / 2, height.toDouble()),
      Paint()..color = const Color(0xffff0000),
    )
    ..drawRect(
      Rect.fromLTWH(width / 2, 0, width / 2, height.toDouble()),
      Paint()..color = const Color(0xff0000ff),
    );
  final image = await recorder.endRecording().toImage(width, height);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}

/// The RGBA pixels of a PNG data URL, with its size.
Future<({int width, int height, ByteData rgba})> _pixels(String url) async {
  final bytes = base64Decode(url.substring(url.indexOf(',') + 1));
  final codec = await ui.instantiateImageCodec(bytes);
  final image = (await codec.getNextFrame()).image;
  try {
    final rgba = await image.toByteData();
    return (width: image.width, height: image.height, rgba: rgba!);
  } finally {
    image.dispose();
    codec.dispose();
  }
}

void main() {
  test('the decode size: the short side down to 256, never up, the long '
      'side in proportion up to 8 x 256', () {
    expect(botAvatarDecodeSize(40000, 40000), (width: 256, height: 256));
    expect(botAvatarDecodeSize(2400, 1200), (width: 512, height: 256));
    expect(botAvatarDecodeSize(1200, 2400), (width: 256, height: 512));
    expect(botAvatarDecodeSize(300, 1000000), (width: 256, height: 2048));
    expect(botAvatarDecodeSize(256, 4000), (width: 256, height: 2048));
    expect(botAvatarDecodeSize(100, 50), (width: 100, height: 50));
    expect(botAvatarDecodeSize(1, 1), (width: 1, height: 1));
    expect(botAvatarDecodeSize(4000, 2000, edge: 64), (width: 128, height: 64));
  });

  testWidgets('a large picture is decoded at the reduced size and cropped to '
      'its centred square', (tester) async {
    await tester.runAsync(() async {
      final decoded = <(int, int)>[];
      final url = await normalizeBotAvatar(
        await _halves(2400, 1200),
        onDecoded: (width, height) => decoded.add((width, height)),
      );
      expect(decoded, [(512, 256)]);
      expect(url, startsWith('data:image/png;base64,'));
      final out = await _pixels(url!);
      expect((out.width, out.height), (256, 256));
      // The centred square of a red | blue picture is red | blue too.
      int red(int x, int y) => out.rgba.getUint8((y * out.width + x) * 4);
      int blue(int x, int y) => out.rgba.getUint8((y * out.width + x) * 4 + 2);
      expect(red(40, 128), greaterThan(200));
      expect(blue(40, 128), lessThan(50));
      expect(blue(216, 128), greaterThan(200));
      expect(red(216, 128), lessThan(50));
    });
  });

  testWidgets('a small picture is decoded as it is, never enlarged', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final decoded = <(int, int)>[];
      final url = await normalizeBotAvatar(
        await _halves(120, 80),
        onDecoded: (width, height) => decoded.add((width, height)),
      );
      expect(decoded, [(120, 80)]);
      expect((await _pixels(url!)).width, 256);
    });
  });

  testWidgets('what is not a picture gives nothing', (tester) async {
    await tester.runAsync(() async {
      expect(
        await normalizeBotAvatar(Uint8List.fromList(utf8.encode('nope'))),
        isNull,
      );
    });
  });
}
