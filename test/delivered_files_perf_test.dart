// Delivered-file indexing runs on the UI thread when a reply is final. On
// 242fa67c, 20 KB of one character took 9.4 s (JIT), 20 KB of spaces 3.4 s,
// and 20 KB of '>' overflowed the stack (render re-check, 6c6508ea gaps).
// Wall-clock budgets: the full suite runs this file alone (-j1) via the
// 'perf' tag (dart_test.yaml), so parallel load can't fail it.
@Tags(['perf'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/utils/delivered_files.dart';

int _ms(void Function() body) {
  final watch = Stopwatch()..start();
  body();
  return watch.elapsedMilliseconds;
}

void main() {
  const n = 20000;
  final hostile = {
    'letters': 'a' * n,
    'dots': '.' * n,
    'png dots': '.png' * (n ~/ 4),
    'spaces': ' ' * n,
    'quote markers': '>' * n,
    'brackets': '[' * n,
  };

  for (final entry in hostile.entries) {
    test('${entry.key} alone stays fast and finds nothing', () {
      late List<Object> refs;
      final ms = _ms(() => refs = extractMarkdownFileRefs(entry.value));
      expect(refs, isEmpty);
      expect(ms, lessThan(200), reason: '${entry.key}: $ms ms');
    });

    test('${entry.key} beside a real file link still finds the link', () {
      final text =
          'Saved [the report](/srv/project/report.md).\n\n${entry.value}\n';
      late List<String> paths;
      final ms = _ms(
        () => paths = extractMarkdownFileRefs(text).map((r) => r.path).toList(),
      );
      // '>' x 20 KB nests quotations far beyond any real reply; indexing may
      // give up on it, but it must neither crash nor freeze.
      if (entry.key != 'quote markers') {
        expect(paths, ['/srv/project/report.md'], reason: entry.key);
      }
      expect(ms, lessThan(1500), reason: '${entry.key}: $ms ms');
    });
  }

  test('a long plain line keeps its block kind', () {
    final long = 'z' * 5000;
    // The long line after the quote stays a lazy continuation of the quote,
    // so the link inside the quotation is still not indexed.
    final quoted = '> Note\n$long [q](/tmp/quoted.md)\n';
    expect(extractMarkdownFileRefs(quoted), isEmpty);
    // A long thematic break still ends the quotation.
    final broken = '> Note\n${'-' * 5000}\n\n[after](/tmp/after.md)\n';
    expect(extractMarkdownFileRefs(broken).map((r) => r.path), [
      '/tmp/after.md',
    ]);
    // An indented long line is still code.
    final code = '    ${'y' * 5000}\n    [c](/tmp/code.md)\n';
    expect(extractMarkdownFileRefs(code), isEmpty);
  });

  test('a final reply is parsed once and then served from memory', () {
    final text = 'See [x](/tmp/x.md) ${'w ' * 8000}';
    final first = _ms(() => extractMarkdownFileRefs(text));
    final again = _ms(() {
      for (var i = 0; i < 50; i++) {
        extractMarkdownFileRefs(text);
      }
    });
    expect(extractMarkdownFileRefs(text).single.path, '/tmp/x.md');
    expect(again, lessThanOrEqualTo(first + 20));
  });

  test('streaming text is never indexed', () {
    expect(extractMarkdownFileRefs('[x](/tmp/x.md)', isFinal: false), isEmpty);
  });
}
