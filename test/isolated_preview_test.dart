import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/preview/chat_preview.dart';
import 'package:hermes_android/core/preview/reader_document.dart';
import 'package:hermes_android/core/services/preview_peer.dart';

void main() {
  final policy = PreviewPolicy(Uri.parse('https://gateway.example:9443/api'));
  test(
    'approval means exact scheme, host and port; no gateway or userinfo',
    () {
      expect(
        policy
            .accept(
              'https://site.example:443/docs',
              requiredOrigin: 'https://site.example',
            )
            .path,
        '/docs',
      );
      for (final url in [
        'https://site.example.other/',
        'https://sub.site.example/',
        'https://site.example:444/',
        'http://site.example/',
        'file:///x',
        'javascript:void(0)',
        'https://name:pass@site.example/',
        'https://@site.example/',
        'https://site.example./',
      ]) {
        expect(
          () => policy.accept(url, requiredOrigin: 'https://site.example'),
          throwsA(isA<PreviewError>()),
          reason: url,
        );
      }
      expect(
        () => policy.accept('https://gateway.example:9443/private'),
        throwsA(isA<PreviewError>()),
      );
    },
  );

  test(
    'guest fetch is stateless and never follows redirects or subresources',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      final base = 'http://127.0.0.1:${server.port}';
      final paths = <String>[];
      final headers = <HttpHeaders>[];
      server.listen((r) async {
        paths.add(r.uri.path);
        headers.add(r.headers);
        r.response.headers.contentType = ContentType.html;
        if (r.uri.path == '/redirect') {
          r.response.statusCode = 302;
          r.response.headers.set('Location', '$base/forbidden');
        } else {
          r.response.cookies.add(Cookie('guest', 'ignore'));
          r.response.write(
            '<title>Read me</title><h1>Heading</h1><p>Text</p><a href="/two">Next</a><form>never<input value="hidden"></form><script src="/forbidden">never</script><img src="/forbidden">',
          );
        }
        await r.response.close();
      });
      final loader = ReaderLoad(policy);
      addTearDown(loader.cancel);
      final d = await loader.load(
        '$base/one',
        approvedOrigin: base,
        check: () {},
      );
      expect(d.title, 'Read me');
      expect(d.blocks.map((b) => b.text), ['Heading', 'Text', 'Next']);
      expect(d.blocks.last.link.toString(), '$base/two');
      await loader.load('$base/two', approvedOrigin: base, check: () {});
      await expectLater(
        loader.load('$base/redirect', approvedOrigin: base, check: () {}),
        throwsA(isA<PreviewError>()),
      );
      expect(paths, ['/one', '/two', '/redirect']);
      for (final h in headers) {
        expect(h['cookie'], isNull);
        expect(h['authorization'], isNull);
        expect(h['referer'], isNull);
      }
    },
  );
  test('late load cannot publish after owner revocation', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    final base = 'http://127.0.0.1:${server.port}';
    final request = server.first;
    var allowed = true;
    final result = ReaderLoad(policy).load(
      base,
      approvedOrigin: base,
      check: () {
        if (!allowed) throw StateError('revoked');
      },
    );
    final r = await request;
    allowed = false;
    r.response.headers.contentType = ContentType.html;
    r.response.write('stale');
    await r.response.close();
    await expectLater(result, throwsStateError);
  });
  test(
    'replayed requests, wrong owner, vault and scripts cannot borrow page',
    () {
      final peers = PreviewPeers();
      var count = 0;
      final release = peers.attach(
        'rt',
        'blue',
        (
          action, {
          required start,
          required count,
          required amount,
          required direction,
        }) => {'action': action.name},
      );
      Map? ask(String method, Map<String, dynamic> p, {bool replay = false}) =>
          peers.answer(method, p, replayed: replay);
      expect(ask('preview.read', {'session_id': 'rt'}), {
        'value': '{"action":"read"}',
      });
      for (final p in [
        {'session_id': 'other'},
        {'session_id': 'rt', 'profile': 'red'},
        {'profile': 'blue'},
      ]) {
        expect(ask('preview.read', p), isNull);
      }
      expect(ask('preview.read', {'session_id': 'rt'}, replay: true), isNull);
      for (final a in ['vault', 'eval', 'type', 'click', 'press', 'open']) {
        expect(ask('preview.act', {'session_id': 'rt', 'action': a}), isNull);
      }
      release();
      expect(ask('preview.read', {'session_id': 'rt'}), isNull);
      peers.attach(
        'rt',
        'blue',
        (
          action, {
          required start,
          required count,
          required amount,
          required direction,
        }) => {'safe': true},
      );
      release();
      if (ask('preview.read', {'session_id': 'rt'}) != null) count++;
      expect(count, 1);
    },
  );

  test('console copy uses the selection, otherwise every retained line', () {
    final log = PreviewConsoleLog();
    expect(log.export(), isEmpty);
    log.add('one');
    log.add('two');
    expect(log.export(), ['one', 'two']);
    log.toggle(log.lines.last.id);
    expect(log.export(), ['two']);
    log.toggle(log.lines.last.id);
    expect(log.export(), ['one', 'two']);
    final doomed = log.lines.first.id;
    log.toggle(doomed);
    for (var i = 0; i < 60; i++) {
      log.add('n$i');
    }
    expect(log.length, 50);
    expect(log.selected, isEmpty);
    expect(log.export().first, 'n10');
    log.toggle(log.lines.first.id);
    log.clear();
    expect(log.isEmpty, isTrue);
    expect(log.export(), isEmpty);
  });
}
