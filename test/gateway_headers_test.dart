import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/gateway_headers.dart';

void main() {
  group('normalizeRemoteHeaders', () {
    test('normalizes names and values', () {
      final headers = normalizeRemoteHeaders({
        'X-Custom': 'value',
        'x-another': '  spaced  ',
      });
      expect(headers, {'X-Custom': 'value', 'x-another': 'spaced'});
    });

    test('rejects invalid header names', () {
      final headers = normalizeRemoteHeaders({
        'not a header': 'value',
        'with?query=': 'value',
        'valid-name': 'value',
      });
      expect(headers, {'valid-name': 'value'});
    });

    test('rejects forbidden names (case-insensitive)', () {
      final headers = normalizeRemoteHeaders({
        'Authorization': 'Bearer something',
        'X-Hermes-Session-Token': 'token',
        'cookie': 'session=abc',
        'host': 'example.com',
        'X-Custom': 'kept',
      });
      expect(headers, {'X-Custom': 'kept'});
    });

    test('strips CR/LF from values (header injection)', () {
      final headers = normalizeRemoteHeaders({
        'X-Custom': 'value\r\nX-Inject: evil',
      });
      expect(headers['X-Custom'], 'valueX-Inject: evil');
    });

    test('drops empty values', () {
      final headers = normalizeRemoteHeaders({
        'X-Custom': '',
        'X-Other': 'value',
      });
      expect(headers, {'X-Other': 'value'});
    });
  });

  group('parseRemoteHeadersBlock', () {
    test('parses a block and reports problems per line', () {
      final parsed = parseRemoteHeadersBlock('''
        # a comment
        X-Custom: value1
        X-Other: value2
      ''');
      expect(parsed.headers, {'X-Custom': 'value1', 'X-Other': 'value2'});
      expect(parsed.problems, isEmpty);
    });

    test('reports malformed lines and drops them', () {
      final parsed = parseRemoteHeadersBlock('''
        no-colon-here
        X-Valid: kept
        : missing-name
        not-valid? : value
        Authorization: Bearer evil
        X-Empty:
      ''');
      expect(parsed.headers, {'X-Valid': 'kept'});
      expect(parsed.problems.length, greaterThanOrEqualTo(4));
    });

    test('never repairs a forbidden header', () {
      final parsed = parseRemoteHeadersBlock('Authorization: Bearer nope\n');
      expect(parsed.headers, isEmpty);
      expect(parsed.problems.length, 1);
    });
  });

  test('headersBlockFromMap round-trips', () {
    final headers = {'X-Custom': 'value', 'X-Other': 'spaced'};
    final block = headersBlockFromMap(headers);
    final parsed = parseRemoteHeadersBlock(block);
    expect(parsed.headers, headers);
    expect(parsed.problems, isEmpty);
  });
}
