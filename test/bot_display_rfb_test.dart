import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/bot_display_rfb.dart';

import 'support/fake_rfb_screen.dart';

void main() {
  test('reads a screen delivered a byte at a time and sends input', () async {
    final screen = FakeRfbScreen(
      width: 3,
      height: 2,
      colour: const [200, 100, 50],
      chunk: 1,
    );
    var frames = 0;
    final rfb = BotDisplayRfb(screen, onFrame: () => frames++);
    await rfb.ready;
    await pumpEventQueue();
    expect([rfb.width, rfb.height, rfb.desktopName], [3, 2, 'bot']);
    expect(frames, 1);
    expect(rfb.framebuffer, [
      for (var i = 0; i < 6; i++) ...[200, 100, 50, 255],
    ]);
    // 32 bpp, depth 24, little-endian true colour, R in the low byte.
    expect(screen.pixelFormat, [
      32, 24, 0, 1, 0, 255, 0, 255, 0, 255, 0, 8, 16, 0, 0, 0, //
    ]);
    expect(screen.encodings, [1, 0, -223]);
    // One full request, then an incremental one after the frame.
    expect(screen.updateRequests, 2);

    rfb.pointer(2, 1, 1);
    rfb.pointer(99, 99, 0);
    rfb.typeText('a\n€');
    await pumpEventQueue();
    expect(screen.pointers, [
      [2, 1, 1],
      [2, 1, 0],
    ]);
    expect(screen.keys, [
      [0x61, 1],
      [0x61, 0],
      [0xff0d, 1],
      [0xff0d, 0],
      [0x010020ac, 1],
      [0x010020ac, 0],
    ]);

    // A later frame repaints in place; CopyRect moves pixels on screen.
    screen.sendFrame(const [1, 2, 3]);
    await pumpEventQueue();
    expect(frames, 2);
    expect(rfb.framebuffer.sublist(0, 4), [1, 2, 3, 255]);

    await rfb.close();
    expect(screen.closeCode, 1000);
    expect(rfb.isLive, isFalse);
  });

  test('a refused handshake fails with the screen’s reason', () async {
    final screen = FakeRfbScreen(refuse: 'Too many viewers');
    final rfb = BotDisplayRfb(screen);
    await expectLater(
      rfb.ready,
      throwsA(
        isA<BotDisplayRfbException>().having(
          (e) => e.message,
          'message',
          'Too many viewers',
        ),
      ),
    );
    expect(rfb.isClosed, isTrue);
  });

  test('a rectangle outside the screen, an unknown encoding and an unknown '
      'message each close the viewer instead of being painted', () async {
    for (final bad in <List<int>>[
      // FramebufferUpdate, 1 rect at (3, 0) 2x1, Raw: past the right edge.
      [0, 0, 0, 1, 0, 3, 0, 0, 0, 2, 0, 1, 0, 0, 0, 0],
      // Rect with the Tight encoding (7), which was never requested.
      [0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 7],
      // Message type 9 does not exist.
      [9],
    ]) {
      final screen = FakeRfbScreen();
      String? closedWith = 'still open';
      final rfb = BotDisplayRfb(screen, onClosed: (e) => closedWith = e);
      await rfb.ready;
      await pumpEventQueue();
      screen.sendRaw(bad);
      await pumpEventQueue();
      expect(rfb.isClosed, isTrue, reason: '$bad');
      expect(closedWith, isNotNull);
      expect(screen.isClosed, isTrue);
    }
  });

  test('a screen that closes mid-handshake fails ready', () async {
    final screen = FakeRfbScreen();
    final rfb = BotDisplayRfb(screen);
    screen.drop(4001);
    await expectLater(rfb.ready, throwsA(isA<BotDisplayRfbException>()));
    expect(rfb.closeCode, 4001);
  });
}
