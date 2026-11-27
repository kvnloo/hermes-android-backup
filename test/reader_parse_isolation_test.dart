import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/preview/reader_document.dart';

/// Serves [body] once over loopback HTTP with [mime].
Future<HttpServer> _serve(String body, String mime) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen((request) {
    request.response
      ..headers.contentType = ContentType.parse(mime)
      ..write(body);
    unawaited(request.response.close());
  });
  return server;
}

void main() {
  test(
    'a hostile deeply nested page never blocks the UI isolate and is stopped',
    () async {
      // 256 KiB of nested <div>: ~85 s of synchronous parsing on a loaded
      // host when parsed on the calling isolate.
      final hostile = '<div>' * 52428;
      var ticks = 0;
      final ticker = Timer.periodic(
        const Duration(milliseconds: 50),
        (_) => ticks++,
      );
      final watch = Stopwatch()..start();
      try {
        await expectLater(
          ReaderDocument.parseInBackground(
            Uri.parse('https://site.example/'),
            hostile,
            timeout: const Duration(seconds: 2),
          ),
          throwsA(
            isA<PreviewError>().having(
              (e) => e.message,
              'message',
              'This page is too complex for reader mode.',
            ),
          ),
        );
      } finally {
        ticker.cancel();
      }
      expect(watch.elapsed, lessThan(const Duration(seconds: 5)));
      expect(ticks, greaterThan(10), reason: 'the event loop kept running');
    },
  );

  test('an ordinary page parses in the background', () async {
    final doc = await ReaderDocument.parseInBackground(
      Uri.parse('https://site.example/'),
      '<html><head><title>T</title></head><body><h1>Hello</h1>'
      '<p>World <a href="/x">link</a></p></body></html>',
    );
    expect(doc.blocks.map((b) => b.text).join(' '), contains('Hello'));
  });

  test(
    'loading a nested page end to end keeps the event loop running',
    () async {
      final server = await _serve('<div>' * 13107, 'text/html'); // 64 KiB
      addTearDown(() => server.close(force: true));
      final origin = 'http://127.0.0.1:${server.port}';
      var ticks = 0;
      final ticker = Timer.periodic(
        const Duration(milliseconds: 50),
        (_) => ticks++,
      );
      final watch = Stopwatch()..start();
      try {
        await ReaderLoad(
          PreviewPolicy(Uri.parse('https://gateway.invalid')),
        ).load('$origin/x', approvedOrigin: origin, check: () {});
      } on PreviewError {
        // Too complex is an acceptable outcome; freezing is not.
      } finally {
        ticker.cancel();
      }
      expect(ticks, greaterThanOrEqualTo(watch.elapsedMilliseconds ~/ 100));
    },
  );

  test(
    'plain text near the byte limit opens even though escaping grows it',
    () async {
      final server = await _serve('/' * (60 * 1024), 'text/plain');
      addTearDown(() => server.close(force: true));
      final origin = 'http://127.0.0.1:${server.port}';
      final loader = ReaderLoad(
        PreviewPolicy(Uri.parse('https://gateway.invalid')),
      );
      final doc = await loader.load(
        '$origin/notes.txt',
        approvedOrigin: origin,
        check: () {},
      );
      expect(doc.blocks, isNotEmpty);
    },
  );
}
