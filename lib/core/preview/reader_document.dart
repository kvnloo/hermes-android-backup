import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

/// The reader has no WebView, cookie jar, script engine, form submission,
/// gateway client, app URL handler, asset loader or ambient TLS client key.
class PreviewPolicy {
  PreviewPolicy(Uri gateway) : _gateway = gateway;
  final Uri _gateway;
  static const _loopback = {'localhost', '127.0.0.1', '::1'};

  Uri accept(String address, {String? requiredOrigin}) {
    final u = Uri.tryParse(address);
    if (u == null ||
        address.length > 4096 ||
        RegExp(r'[\s\\\x00-\x1f\x7f]').hasMatch(address) ||
        !u.hasAuthority ||
        u.host.isEmpty ||
        RegExp(r'^[^:]+://[^/?#]*@').hasMatch(address) ||
        u.authority.contains('@') ||
        !(u.scheme == 'https' ||
            u.scheme == 'http' && _loopback.contains(u.host)) ||
        u.host.endsWith('.') ||
        u.port == 0 ||
        u.port > 65535 ||
        u.origin == _gateway.origin ||
        (_loopback.contains(u.host) &&
            _loopback.contains(_gateway.host) &&
            u.port == _gateway.port) ||
        (requiredOrigin != null && u.origin != requiredOrigin)) {
      throw const PreviewError(PreviewFailure.address);
    }
    return u;
  }
}

enum PreviewFailure {
  address,
  pageLimit,
  unreadable,
  complex,
  http,
  contentType,
  secureLoad,
  capture,
}

class PreviewError implements Exception {
  const PreviewError(this.reason, {this.statusCode});
  final PreviewFailure reason;
  final int? statusCode;

  /// Diagnostic compatibility for parser clients. Never render this English
  /// value: the preview maps [reason] through the current locale at build time.
  String get message => switch (reason) {
    PreviewFailure.address =>
      'This address is outside the approved preview origin.',
    PreviewFailure.pageLimit => 'Page exceeds the reader limit.',
    PreviewFailure.unreadable => 'The page could not be read.',
    PreviewFailure.complex => 'This page is too complex for reader mode.',
    PreviewFailure.http =>
      'HTTP $statusCode. No redirect or sign-in was followed.',
    PreviewFailure.contentType =>
      'Only HTML and plain text can open in reader mode.',
    PreviewFailure.secureLoad => 'The site could not be loaded securely.',
    PreviewFailure.capture => 'Could not capture these pixels.',
  };
}

class PreviewBlock {
  const PreviewBlock(this.tag, this.selector, this.text, this.link);
  final String tag, selector, text;
  final Uri? link;
}

class ReaderDocument {
  const ReaderDocument(this.url, this.title, this.blocks);
  final Uri url;
  final String title;
  final List<PreviewBlock> blocks;

  static const _excluded = {
    'head',
    'style',
    'script',
    'noscript',
    'template',
    'iframe',
    'object',
    'embed',
    'svg',
    'canvas',
    'form',
    'input',
    'textarea',
    'select',
    'button',
    'dialog',
    'audio',
    'video',
    'img',
    'link',
    'meta',
  };
  static const _groups = {
    'section',
    'article',
    'aside',
    'nav',
    'p',
    'blockquote',
    'li',
    'pre',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'a',
    'div',
    'main',
    'footer',
    'header',
    'code',
    'td',
    'th',
  };

  /// [ReaderDocument.parse] in a separate isolate that is killed after
  /// [timeout], so neither the UI nor a background core is held by a page.
  static Future<ReaderDocument> parseInBackground(
    Uri location,
    String source, {
    int limit = 256 * 1024,
    Duration timeout = const Duration(seconds: 6),
  }) async {
    if (source.length > limit) {
      throw const PreviewError(PreviewFailure.pageLimit);
    }
    final replies = ReceivePort();
    Isolate? worker;
    try {
      worker = await Isolate.spawn<(SendPort, String, String, int)>(
        _parseInIsolate,
        (replies.sendPort, location.toString(), source, limit),
        onError: replies.sendPort,
        onExit: replies.sendPort,
      );
      final reply = await replies.first.timeout(timeout);
      if (reply is ReaderDocument) return reply;
      if (reply is PreviewError) throw reply;
      throw const PreviewError(PreviewFailure.unreadable);
    } on TimeoutException {
      throw const PreviewError(PreviewFailure.complex);
    } finally {
      worker?.kill(priority: Isolate.immediate);
      replies.close();
    }
  }

  static void _parseInIsolate((SendPort, String, String, int) message) {
    final (port, location, source, limit) = message;
    try {
      port.send(
        ReaderDocument.parse(Uri.parse(location), source, limit: limit),
      );
    } on PreviewError catch (error) {
      port.send(error);
    } catch (_) {
      port.send(const PreviewError(PreviewFailure.unreadable));
    }
  }

  /// Project only visible reader text and structural selectors. Never retain
  /// attribute values, input values, original markup or a page-defined style.
  factory ReaderDocument.parse(
    Uri location,
    String source, {
    int limit = 256 * 1024,
  }) {
    if (source.length > limit) {
      throw const PreviewError(PreviewFailure.pageLimit);
    }
    final doc = html.parse(source);
    final blocks = <PreviewBlock>[];
    var visited = 0;
    void visit(Element node, String path, int depth, String tag, Uri? link) {
      if (++visited > 6000 || depth > 48 || blocks.length >= 480) return;
      final name = node.localName ?? '';
      if (!RegExp(r'^[a-z][a-z0-9-]{0,40}$').hasMatch(name) ||
          _excluded.contains(name) ||
          node.attributes.containsKey('hidden') ||
          node.attributes['aria-hidden'] == 'true' ||
          node.attributes.containsKey('contenteditable')) {
        return;
      }
      if (_groups.contains(name)) tag = name;
      if (name == 'a') {
        link = location.tryResolvePreviewLink(node.attributes['href']);
      }
      final buf = StringBuffer();
      void flush() {
        final text = buf.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
        buf.clear();
        if (text.isNotEmpty && blocks.length < 480) {
          blocks.add(
            PreviewBlock(
              tag,
              path,
              text.substring(0, text.length.clamp(0, 4096)),
              link,
            ),
          );
        }
      }

      final counts = <String?, int>{};
      for (final child in node.nodes) {
        if (child is Text) buf.write(child.data);
        if (child is Element) {
          flush();
          final tagName = child.localName;
          final index = counts.update(tagName, (v) => v + 1, ifAbsent: () => 1);
          visit(
            child,
            '$path > $tagName:nth-of-type($index)',
            depth + 1,
            tag,
            link,
          );
        }
        if (blocks.length >= 480 || visited > 6000) break;
      }
      flush();
    }

    final body = doc.body;
    if (body != null) visit(body, 'body', 0, 'p', null);
    final title = doc.querySelector('title')?.text.trim() ?? '';
    return ReaderDocument(
      location,
      title.substring(0, title.length.clamp(0, 160)),
      List.unmodifiable(blocks),
    );
  }
}

extension on Uri {
  Uri? tryResolvePreviewLink(String? href) {
    if (href == null || href.isEmpty || href.length > 4096) return null;
    try {
      return resolve(href);
    } on FormatException {
      return null;
    }
  }
}

/// One credential-free GET on an explicitly chosen origin. Redirects (even
/// same-origin), subresources, challenges and cookies are never followed.
class ReaderLoad {
  ReaderLoad(this.policy);
  final PreviewPolicy policy;
  HttpClient? _active;
  void cancel() {
    _active?.close(force: true);
    _active = null;
  }

  Future<ReaderDocument> load(
    String address, {
    required String approvedOrigin,
    required void Function() check,
  }) async {
    final url = policy.accept(address, requiredOrigin: approvedOrigin);
    cancel();
    check();
    final client = _active =
        HttpClient(context: SecurityContext(withTrustedRoots: true))
          ..connectionTimeout = const Duration(seconds: 8)
          ..findProxy = (_) => 'DIRECT';
    final deadline = Timer(
      const Duration(seconds: 12),
      () => client.close(force: true),
    );
    try {
      final request = await client.getUrl(url);
      check();
      request.followRedirects = false;
      request.headers.set(HttpHeaders.acceptHeader, 'text/html, text/plain');
      final response = await request.close();
      check();
      if (response.statusCode != 200) {
        throw PreviewError(
          PreviewFailure.http,
          statusCode: response.statusCode,
        );
      }
      final mime = response.headers.contentType?.mimeType;
      if (mime != 'text/html' && mime != 'text/plain') {
        throw const PreviewError(PreviewFailure.contentType);
      }
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in response) {
        check();
        if (bytes.length + chunk.length > 256 * 1024) {
          throw const PreviewError(PreviewFailure.pageLimit);
        }
        bytes.add(chunk);
      }
      check();
      final text = utf8.decode(bytes.takeBytes(), allowMalformed: true);
      // Parse off the UI isolate: HTML parsing cost grows with nesting, and
      // a hostile page within the byte limit must never freeze the app.
      final document = mime == 'text/plain'
          // Escaping can grow text up to 6x; the byte limit already applied.
          ? await ReaderDocument.parseInBackground(
              url,
              '<pre>${const HtmlEscape().convert(text)}</pre>',
              limit: 6 * 256 * 1024 + 11,
            )
          : await ReaderDocument.parseInBackground(url, text);
      check();
      return document;
    } on PreviewError {
      rethrow;
    } catch (_) {
      check();
      throw const PreviewError(PreviewFailure.secureLoad);
    } finally {
      deadline.cancel();
      client.close(force: true);
      if (identical(_active, client)) _active = null;
    }
  }
}
