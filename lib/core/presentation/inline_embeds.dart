// Inline embeds, matching Hermes Desktop's "Inline Embeds" setting
// (apps/desktop/src/store/embed-consent.ts and embeds/providers/). A rich
// preview reaches out to a third party, so by default it waits behind a
// placeholder until the reader loads it once or always allows the service.
//
// Ares has no WebView: nothing here runs a provider's scripts or frames.
// Markdown images are decoded from a capped https download, and provider
// previews are a public thumbnail and title from a documented endpoint
// (oEmbed, or YouTube's thumbnail URL). Tapping a preview opens the link in
// the browser.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import '../../nextgen/theme/nextgen_theme.dart';
import '../l10n/l10n.dart';
import '../theme/hermes_theme.dart';
import 'reading_controls.dart';

/// The services Desktop embeds. [id] is Desktop's provider id and the key a
/// standing "Always allow" is saved under.
enum EmbedProvider {
  youtube('youtube', 'YouTube'),
  vimeo('vimeo', 'Vimeo'),
  instagram('instagram', 'Instagram'),
  pinterest('pinterest', 'Pinterest'),
  tiktok('tiktok', 'TikTok'),
  twitter('twitter', 'X'),
  spotify('spotify', 'Spotify'),
  googleMaps('googlemaps', 'Google Maps'),
  openStreetMap('openstreetmap', 'OpenStreetMap');

  const EmbedProvider(this.id, this.label);

  final String id;
  final String label;

  /// Whether showing a preview contacts the provider. Instagram, Pinterest
  /// and the map services publish no keyless thumbnail or title endpoint,
  /// so their card is drawn from the link alone and needs no consent.
  bool get fetches => switch (this) {
    youtube || vimeo || twitter || tiktok || spotify => true,
    instagram || pinterest || googleMaps || openStreetMap => false,
  };

  static EmbedProvider? withId(String id) {
    for (final provider in values) {
      if (provider.id == id) return provider;
    }
    return null;
  }
}

/// The service key an https Markdown image is allowed under: its host.
String imageEmbedService(String host) => 'image:$host';

/// True when [host] is [domain] or one of its subdomains. Never a substring
/// match: `eviltiktok.com` is not `tiktok.com`, and
/// `maps.google.evil.example` is not Google.
bool hostIs(String host, String domain) =>
    host == domain || host.endsWith('.$domain');

/// A recognised provider link, resolved without any network access.
@immutable
final class EmbedDescriptor {
  const EmbedDescriptor._({
    required this.provider,
    required this.id,
    required this.source,
    this.detail,
  });

  final EmbedProvider provider;

  /// Stable per embed, e.g. `youtube:dQw4w9WgXcQ`.
  final String id;

  /// The link as the reply wrote it; opened in the browser on tap.
  final Uri source;

  /// The video id, track, place or coordinates the link names.
  final String? detail;

  /// The host named on the placeholder. X posts often arrive as
  /// twitter.com links; Desktop shows the current brand.
  String get host => provider == EmbedProvider.twitter
      ? 'x.com'
      : source.host.startsWith('www.')
      ? source.host.substring(4)
      : source.host;

  @override
  bool operator ==(Object other) =>
      other is EmbedDescriptor && other.id == id && other.source == source;

  @override
  int get hashCode => Object.hash(id, source);
}

const _maxUrlLength = 2048;

Uri? _webUri(String raw) {
  if (raw.isEmpty || raw.length > _maxUrlLength) return null;
  final uri = Uri.tryParse(raw.trim());
  if (uri == null ||
      (uri.scheme != 'https' && uri.scheme != 'http') ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty) {
    return null;
  }
  return uri;
}

final _youtubeId = RegExp(r'^[A-Za-z0-9_-]{11}$');
final _digits = RegExp(r'^\d{1,32}$');
final _slug = RegExp(r'^[A-Za-z0-9_-]{1,64}$');
final _spotifyId = RegExp(r'^[A-Za-z0-9]{1,64}$');
final _latLng = RegExp(
  r'@(-?\d{1,3}(?:\.\d{1,12})?),(-?\d{1,3}(?:\.\d{1,12})?)(?:,(\d{1,2}(?:\.\d{1,6})?)z)?',
);
final _osmMap = RegExp(
  r'map=(\d{1,2}(?:\.\d{1,6})?)/(-?\d{1,3}(?:\.\d{1,12})?)/(-?\d{1,3}(?:\.\d{1,12})?)',
);

const _spotifyTypes = {
  'album',
  'artist',
  'episode',
  'playlist',
  'show',
  'track',
};

// Pinterest's locale sites (Desktop matched any host containing
// "pinterest.", which also accepts evilpinterest.example).
const _pinterestDomains = [
  'pinterest.com',
  'pinterest.co.uk',
  'pinterest.com.au',
  'pinterest.ca',
  'pinterest.de',
  'pinterest.fr',
  'pinterest.es',
  'pinterest.it',
  'pinterest.pt',
  'pinterest.ie',
  'pinterest.nz',
  'pinterest.jp',
  'pinterest.co.kr',
  'pinterest.com.mx',
  'pinterest.at',
  'pinterest.ch',
  'pinterest.se',
  'pinterest.dk',
  'pinterest.ph',
  'pinterest.cl',
];

// Google Maps hosts (Desktop accepted any host starting "google.").
const _googleDomains = [
  'google.com',
  'google.co.uk',
  'google.com.au',
  'google.ca',
  'google.de',
  'google.fr',
  'google.es',
  'google.it',
  'google.nl',
  'google.be',
  'google.ch',
  'google.at',
  'google.ie',
  'google.co.nz',
  'google.co.jp',
  'google.co.kr',
  'google.co.in',
  'google.com.br',
  'google.com.mx',
  'google.com.sg',
  'google.com.hk',
  'google.com.tw',
  'google.co.za',
  'google.se',
  'google.no',
  'google.dk',
  'google.fi',
  'google.pl',
  'google.pt',
];

List<String> _segments(Uri uri) =>
    uri.pathSegments.where((segment) => segment.isNotEmpty).toList();

/// Resolves a link to a provider embed, or null. Pure and synchronous.
EmbedDescriptor? detectEmbed(String? raw) {
  if (raw == null) return null;
  final uri = _webUri(raw);
  if (uri == null) return null;
  var host = uri.host.toLowerCase();
  if (host.endsWith('.')) host = host.substring(0, host.length - 1);
  final segments = _segments(uri);
  EmbedDescriptor make(EmbedProvider provider, String detail) =>
      EmbedDescriptor._(
        provider: provider,
        id: '${provider.id}:$detail',
        source: uri,
        detail: detail,
      );

  // YouTube.
  if (hostIs(host, 'youtu.be') ||
      hostIs(host, 'youtube.com') ||
      hostIs(host, 'youtube-nocookie.com')) {
    var id = '';
    if (hostIs(host, 'youtu.be')) {
      id = segments.firstOrNull ?? '';
    } else if (segments.firstOrNull == 'watch') {
      id = uri.queryParameters['v'] ?? '';
    } else if (segments.length > 1 &&
        const {'embed', 'shorts', 'live', 'v'}.contains(segments.first)) {
      id = segments[1];
    }
    return _youtubeId.hasMatch(id) ? make(EmbedProvider.youtube, id) : null;
  }
  // Vimeo: the clip is the last all-digits segment.
  if (hostIs(host, 'vimeo.com')) {
    final id = segments.reversed.where(_digits.hasMatch).firstOrNull;
    return id == null ? null : make(EmbedProvider.vimeo, id);
  }
  if (hostIs(host, 'instagram.com')) {
    if (segments.length < 2) return null;
    final type = segments[0] == 'reels' ? 'reel' : segments[0];
    if (!const {'p', 'reel', 'tv'}.contains(type) ||
        !_slug.hasMatch(segments[1])) {
      return null;
    }
    return make(EmbedProvider.instagram, '$type/${segments[1]}');
  }
  if (_pinterestDomains.any((domain) => hostIs(host, domain))) {
    if (segments.length < 2 ||
        segments[0] != 'pin' ||
        !_digits.hasMatch(segments[1])) {
      return null;
    }
    return make(EmbedProvider.pinterest, segments[1]);
  }
  if (hostIs(host, 'tiktok.com')) {
    final at = segments.indexOf('video');
    final id = at >= 0 && at + 1 < segments.length ? segments[at + 1] : '';
    return _digits.hasMatch(id) ? make(EmbedProvider.tiktok, id) : null;
  }
  if (hostIs(host, 'twitter.com') || hostIs(host, 'x.com')) {
    final at = segments.indexOf('status');
    final id = at >= 0 && at + 1 < segments.length ? segments[at + 1] : '';
    return _digits.hasMatch(id) ? make(EmbedProvider.twitter, id) : null;
  }
  if (host == 'open.spotify.com') {
    final start = segments.firstOrNull?.startsWith('intl-') == true ? 1 : 0;
    if (segments.length < start + 2) return null;
    final type = segments[start];
    final id = segments[start + 1];
    if (!_spotifyTypes.contains(type) || !_spotifyId.hasMatch(id)) {
      return null;
    }
    return make(EmbedProvider.spotify, '$type/$id');
  }
  if (_googleDomains.any((domain) => hostIs(host, domain))) {
    if (!host.startsWith('maps.') && !uri.path.startsWith('/maps')) {
      return null;
    }
    final path = uri.path.length > 1024 ? '' : uri.path;
    final coords = _latLng.firstMatch(path);
    final query = uri.queryParameters['q'] ?? uri.queryParameters['query'];
    final at = segments.indexOf('place');
    final place = at >= 0 && at + 1 < segments.length
        ? segments[at + 1].split('@').first.replaceAll('+', ' ')
        : '';
    final detail = coords != null
        ? '${coords[1]},${coords[2]}'
        : (query != null && query.trim().isNotEmpty)
        ? query.trim()
        : place.trim();
    if (detail.isEmpty || detail.length > 200) return null;
    return make(EmbedProvider.googleMaps, detail);
  }
  if (hostIs(host, 'openstreetmap.org')) {
    final match = uri.fragment.length > 256
        ? null
        : _osmMap.firstMatch(uri.fragment);
    if (match == null) return null;
    return make(EmbedProvider.openStreetMap, '${match[2]},${match[3]}');
  }
  return null;
}

// ------------------------------------------------- bare links in Markdown --

/// Desktop turns only bare autolinks into embeds; a labelled link such as
/// `[watch](https://youtu.be/…)` stays a link. At most [max] per block.
List<EmbedDescriptor> bareProviderLinks(String markdown, {int max = 3}) {
  if (markdown.isEmpty || markdown.length > _maxScannedMarkdown) {
    return const [];
  }
  final cached = _bareLinks.remove(markdown);
  if (cached != null) {
    _bareLinks[markdown] = cached;
    return cached.take(max).toList();
  }
  final found = <EmbedDescriptor>[];
  final seen = <String>{};
  void visit(md.Node node) {
    if (found.length >= 8) return;
    if (node is! md.Element) return;
    if (node.tag == 'a') {
      final href = node.attributes['href'];
      final text = node.textContent.trim();
      if (href != null &&
          (text == href || 'http://$text' == href || 'https://$text' == href)) {
        final embed = detectEmbed(href);
        if (embed != null && seen.add(embed.id)) found.add(embed);
      }
      return;
    }
    if (node.tag == 'code' || node.tag == 'pre') return;
    for (final child in node.children ?? const <md.Node>[]) {
      visit(child);
    }
  }

  // Cheap pre-check: no provider host in the text, nothing to parse.
  final lower = markdown.toLowerCase();
  if (_providerHints.any(lower.contains)) {
    final nodes = md.Document(
      extensionSet: md.ExtensionSet.gitHubFlavored,
      encodeHtml: false,
    ).parse(markdown);
    for (final node in nodes) {
      visit(node);
    }
  }
  final result = List<EmbedDescriptor>.unmodifiable(found);
  _bareLinks[markdown] = result;
  if (_bareLinks.length > 128) _bareLinks.remove(_bareLinks.keys.first);
  return result.take(max).toList();
}

const _maxScannedMarkdown = 64 * 1024;
final _bareLinks = <String, List<EmbedDescriptor>>{};
const _providerHints = [
  'youtu',
  'vimeo',
  'instagram',
  'pinterest',
  'tiktok',
  'twitter',
  'x.com',
  'spotify',
  'google',
  'openstreetmap',
];

// --------------------------------------------------------------- network --

const _imageMaxBytes = 8 * 1024 * 1024;
const _thumbnailMaxBytes = 2 * 1024 * 1024;
const _oembedMaxBytes = 64 * 1024;
const _maxDecodedEdge = 2048;
const _maxSourcePixels = 40 * 1000 * 1000;
const _redirects = 3;

/// One https GET with no cookies, at most [maxBytes], following up to three
/// redirects only to https URLs [allowed] accepts (the first request is
/// checked too). A fourth redirect is refused. Every request goes through
/// dart:io's [HttpClient], so [HttpOverrides] sees it.
@visibleForTesting
Future<Uint8List> fetchCappedHttps(
  Uri uri, {
  required int maxBytes,
  required bool Function(Uri uri) allowed,
  String? accept,
}) async {
  final client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 10)
    ..idleTimeout = const Duration(seconds: 5)
    ..autoUncompress = true;
  try {
    var target = uri;
    for (var hop = 0; ; hop++) {
      if (target.scheme != 'https' ||
          target.host.isEmpty ||
          target.userInfo.isNotEmpty ||
          !allowed(target)) {
        throw StateError('Embed request not allowed.');
      }
      final request = await client.getUrl(target);
      request.followRedirects = false;
      request.persistentConnection = false;
      if (accept != null) request.headers.set(HttpHeaders.acceptHeader, accept);
      final response = await request.close().timeout(
        const Duration(seconds: 20),
      );
      final status = response.statusCode;
      if (status >= 300 && status < 400) {
        final location = response.headers.value(HttpHeaders.locationHeader);
        await response.drain<void>().catchError((_) {});
        if (location == null || hop >= _redirects) {
          throw StateError('Embed redirect refused.');
        }
        target = target.resolve(location);
        continue;
      }
      if (status != HttpStatus.ok) {
        await response.drain<void>().catchError((_) {});
        throw StateError('Embed request failed ($status).');
      }
      if (response.contentLength > maxBytes) {
        throw StateError('Embed response too large.');
      }
      return await _readCapped(
        response,
        maxBytes,
      ).timeout(const Duration(seconds: 20));
    }
  } finally {
    client.close(force: true);
  }
}

/// The body, refused as soon as it passes [maxBytes] whatever the declared
/// length said.
Future<Uint8List> _readCapped(Stream<List<int>> body, int maxBytes) async {
  final bytes = BytesBuilder(copy: false);
  await for (final chunk in body) {
    bytes.add(chunk);
    if (bytes.length > maxBytes) {
      throw StateError('Embed response too large.');
    }
  }
  return bytes.takeBytes();
}

/// A remote https image, downloaded with a byte cap and decoded no larger
/// than [maxEdge] pixels on its longer side. Redirects stay on [uri]'s host
/// unless [allowed] says otherwise.
@immutable
class CappedHttpsImage extends ImageProvider<CappedHttpsImage> {
  const CappedHttpsImage(
    this.uri, {
    this.maxBytes = _imageMaxBytes,
    this.maxEdge = _maxDecodedEdge,
    this.allowed,
  });

  final Uri uri;
  final int maxBytes;
  final int maxEdge;

  /// Where a request may go: a provider thumbnail's CDN, or the hosts the
  /// reader allows for a Markdown image. Only [uri]'s own host otherwise.
  final bool Function(Uri uri)? allowed;

  @override
  Future<CappedHttpsImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<CappedHttpsImage>(this);

  @override
  ImageStreamCompleter loadImage(
    CappedHttpsImage key,
    ImageDecoderCallback decode,
  ) => MultiFrameImageStreamCompleter(
    codec: key._load(),
    scale: 1,
    debugLabel: key.uri.toString(),
  );

  Future<ui.Codec> _load() async {
    final bytes = await fetchCappedHttps(
      uri,
      maxBytes: maxBytes,
      allowed: allowed ?? (target) => target.host == uri.host,
      accept: 'image/*',
    );
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    try {
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      final width = descriptor.width;
      final height = descriptor.height;
      if (width <= 0 || height <= 0 || width * height > _maxSourcePixels) {
        descriptor.dispose();
        throw StateError('Embed image too large.');
      }
      final scale = math.min(1.0, maxEdge / math.max(width, height));
      return descriptor.instantiateCodec(
        targetWidth: math.max(1, (width * scale).round()),
        targetHeight: math.max(1, (height * scale).round()),
      );
    } finally {
      buffer.dispose();
    }
  }

  @override
  bool operator ==(Object other) =>
      other is CappedHttpsImage &&
      other.uri == uri &&
      other.maxBytes == maxBytes &&
      other.maxEdge == maxEdge;

  @override
  int get hashCode => Object.hash(uri, maxBytes, maxEdge);
}

/// What a provider says about one of its links.
@immutable
final class EmbedPreview {
  const EmbedPreview({this.title, this.byline, this.thumbnail});

  final String? title;
  final String? byline;
  final Uri? thumbnail;
}

final class _Endpoint {
  const _Endpoint(this.host, this.path, this.query, this.thumbnailDomains);

  final String host;
  final String path;
  final Map<String, String> Function(String detail) query;

  Uri oembed(EmbedDescriptor embed) => Uri(
    scheme: 'https',
    host: host,
    path: path,
    queryParameters: query(embed.detail ?? ''),
  );

  /// Where an oEmbed `thumbnail_url` may point. Anything else is dropped.
  final List<String> thumbnailDomains;
}

// Documented oEmbed endpoints (YouTube, Vimeo, X, TikTok and Spotify each
// publish one). The canonical link is rebuilt from the parsed id, so the
// reply's own URL text never reaches the provider.
final _endpoints = <EmbedProvider, _Endpoint>{
  EmbedProvider.youtube: _Endpoint(
    'www.youtube.com',
    '/oembed',
    (id) => {'format': 'json', 'url': 'https://www.youtube.com/watch?v=$id'},
    const ['ytimg.com'],
  ),
  EmbedProvider.vimeo: _Endpoint(
    'vimeo.com',
    '/api/oembed.json',
    (id) => {'url': 'https://vimeo.com/$id'},
    const ['vimeocdn.com'],
  ),
  EmbedProvider.twitter: _Endpoint(
    'publish.twitter.com',
    '/oembed',
    (id) => {
      'url': 'https://twitter.com/i/status/$id',
      'omit_script': '1',
      'dnt': 'true',
    },
    const [],
  ),
  EmbedProvider.tiktok: _Endpoint(
    'www.tiktok.com',
    '/oembed',
    (id) => {'url': 'https://www.tiktok.com/video/$id'},
    const ['tiktokcdn.com', 'tiktokcdn-us.com', 'tiktokcdn-eu.com'],
  ),
  EmbedProvider.spotify: _Endpoint(
    'open.spotify.com',
    '/oembed',
    (id) => {'url': 'https://open.spotify.com/$id'},
    const ['scdn.co', 'spotifycdn.com'],
  ),
};

/// Every host a provider preview may contact: its oEmbed host and its
/// thumbnail CDN, over https.
bool embedRequestAllowed(EmbedProvider provider, Uri uri) {
  final endpoint = _endpoints[provider];
  if (endpoint == null || uri.scheme != 'https') return false;
  final host = uri.host.toLowerCase();
  return host == endpoint.host ||
      endpoint.thumbnailDomains.any((domain) => hostIs(host, domain));
}

/// Previews already fetched, most recent last, and fetches in flight. A
/// result is kept as a value, not a future, so a later visit (or a widget
/// in another zone) never waits on a completed fetch's callbacks.
final _previews = <String, EmbedPreview>{};
final _inFlight = <String, Future<EmbedPreview>>{};

/// The preview fetched earlier for [embed], if any.
EmbedPreview? cachedEmbedPreview(EmbedDescriptor embed) {
  final done = _previews.remove(embed.id);
  if (done != null) _previews[embed.id] = done;
  return done;
}

/// The provider's title and thumbnail for [embed], fetched once per link.
/// A failure is not remembered: it may be transient.
Future<EmbedPreview> loadEmbedPreview(EmbedDescriptor embed) {
  final done = cachedEmbedPreview(embed);
  if (done != null) return Future<EmbedPreview>.value(done);
  return _inFlight[embed.id] ??= _fetchPreview(embed)
      .then((preview) {
        _previews[embed.id] = preview;
        if (_previews.length > 64) _previews.remove(_previews.keys.first);
        return preview;
      })
      .whenComplete(() {
        _inFlight.remove(embed.id);
      });
}

@visibleForTesting
void debugResetEmbedPreviews() {
  _previews.clear();
  _inFlight.clear();
  _bareLinks.clear();
}

Future<EmbedPreview> _fetchPreview(EmbedDescriptor embed) async {
  final endpoint = _endpoints[embed.provider];
  if (endpoint == null) return EmbedPreview(title: embed.detail);
  final bytes = await fetchCappedHttps(
    endpoint.oembed(embed),
    maxBytes: _oembedMaxBytes,
    allowed: (uri) => embedRequestAllowed(embed.provider, uri),
    accept: 'application/json',
  );
  final json = jsonDecode(utf8.decode(bytes, allowMalformed: true));
  if (json is! Map) throw const FormatException('oEmbed is not an object.');
  String? text(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed.length > 200 ? '${trimmed.substring(0, 199)}…' : trimmed;
  }

  var title = text(json['title']);
  if (embed.provider == EmbedProvider.twitter) {
    title = text(_postText(json['html']));
  }
  Uri? thumbnail;
  if (embed.provider == EmbedProvider.youtube) {
    // YouTube's documented still for every public video.
    thumbnail = Uri.parse(
      'https://i.ytimg.com/vi/${embed.detail}/hqdefault.jpg',
    );
  } else if (json['thumbnail_url'] case final String raw) {
    final uri = _webUri(raw);
    if (uri != null && embedRequestAllowed(embed.provider, uri)) {
      thumbnail = uri;
    }
  }
  return EmbedPreview(
    title: title,
    byline: text(json['author_name']),
    thumbnail: thumbnail,
  );
}

/// The words of a post from X's oEmbed blockquote: the first paragraph with
/// its tags removed. A single bounded pass, no regular expressions.
String? _postText(Object? html) {
  if (html is! String || html.length > _oembedMaxBytes) return null;
  final start = html.indexOf('<p');
  if (start < 0) return null;
  final open = html.indexOf('>', start);
  final end = html.indexOf('</p>', open < 0 ? start : open);
  if (open < 0 || end < 0) return null;
  final out = StringBuffer();
  var inTag = false;
  for (var i = open + 1; i < end; i++) {
    final ch = html[i];
    if (ch == '<') {
      inTag = true;
    } else if (ch == '>') {
      inTag = false;
    } else if (!inTag) {
      out.write(ch);
    }
  }
  return out
      .toString()
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&nbsp;', ' ');
}

// --------------------------------------------------------------- widgets --

Future<void> _open(Uri uri) async {
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    // No browser or a refused intent: nothing else to do from a preview.
  }
}

/// The reading controls' embed choice. Without a reading scope (a bare
/// widget test or preview) nothing is fetched.
InlineEmbedMode _modeOf(ReadingControls? reading) =>
    reading?.embedMode ?? InlineEmbedMode.off;

/// The layout's link ink on its own surfaces: NextGen's `accentText` (its
/// `colorScheme.primary` is the accent fill, which is not a text colour)
/// and Classic's accent, as their Markdown links use.
Color embedLinkColor(BuildContext context) {
  final theme = Theme.of(context);
  return theme.extension<NgColors>()?.accentText ??
      theme.extension<HermesTokens>()?.accent ??
      theme.colorScheme.primary;
}

/// A Markdown image. Off: a link to the image. Ask: a placeholder naming
/// the host until Load or Always allow. Always (or allowed): the image.
/// Only https is ever downloaded; anything else stays [blocked].
///
/// [linkColor] is the surrounding prose's link colour (a user bubble's
/// differs from the page's); the links drawn in the reply use it.
Widget inlineImageEmbed(
  BuildContext context, {
  required String? uri,
  required String? alt,
  required Widget blocked,
  Color? linkColor,
}) {
  final parsed = uri == null ? null : _webUri(uri);
  if (parsed == null) return blocked;
  final label = (alt == null || alt.trim().isEmpty) ? null : alt.trim();
  return _ImageEmbed(uri: parsed, alt: label, linkColor: linkColor);
}

class _ImageEmbed extends StatelessWidget {
  const _ImageEmbed({required this.uri, required this.alt, this.linkColor});

  final Uri uri;
  final String? alt;
  final Color? linkColor;

  @override
  Widget build(BuildContext context) {
    final reading = ReadingControls.maybeOf(context);
    final host = uri.host;
    final link = _EmbedLink(
      uri: uri,
      label: alt ?? uri.toString(),
      color: linkColor,
    );
    // Plain http is never fetched; neither is anything in Off.
    if (uri.scheme != 'https' || _modeOf(reading) == InlineEmbedMode.off) {
      return link;
    }
    return EmbedGate(
      key: ValueKey('embed-image-$uri'),
      service: imageEmbedService(host),
      serviceLabel: host,
      host: host,
      caption: alt,
      openUri: uri,
      linkColor: linkColor,
      loaded: (context) =>
          _RemoteImage(uri: uri, alt: alt, linkColor: linkColor),
    );
  }
}

/// A tappable link for an embed that is not shown inline, in [color] or
/// else the layout's link colour.
class _EmbedLink extends StatelessWidget {
  const _EmbedLink({required this.uri, required this.label, this.color});

  final Uri uri;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ink = color ?? embedLinkColor(context);
    return Semantics(
      link: true,
      child: InkWell(
        key: ValueKey('embed-link-$uri'),
        onTap: () => _open(uri),
        child: Text(
          label,
          style: TextStyle(
            color: ink,
            decoration: TextDecoration.underline,
            decorationColor: ink,
          ),
        ),
      ),
    );
  }
}

class _RemoteImage extends StatelessWidget {
  const _RemoteImage({required this.uri, required this.alt, this.linkColor});

  final Uri uri;
  final String? alt;
  final Color? linkColor;

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    // The reader chose this host (Load, Always allow, or Always). A redirect
    // may stay on it or go to a host that is itself allowed, never to an
    // unknown one: Always allow for one image host is not consent to the
    // tracker it forwards to.
    final reading = ReadingControls.maybeOf(context);
    final always = _modeOf(reading) == InlineEmbedMode.always;
    final allowedHosts = {...?reading?.allowedEmbeds};
    bool follows(Uri target) =>
        target.host == uri.host ||
        always ||
        allowedHosts.contains(imageEmbedService(target.host));
    return Semantics(
      link: true,
      label: alt ?? uri.host,
      child: GestureDetector(
        onTap: () => _open(uri),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320),
          child: Image(
            key: ValueKey('embed-remote-image-$uri'),
            image: CappedHttpsImage(uri, allowed: follows),
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            gaplessPlayback: true,
            frameBuilder: (context, child, frame, sync) =>
                frame == null && !sync
                ? _EmbedNote(text: l.appearance_embed_loading)
                : child,
            errorBuilder: (context, _, _) => _EmbedLink(
              uri: uri,
              label: l.appearance_embed_image_failed(uri.host),
              color: linkColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmbedNote extends StatelessWidget {
  const _EmbedNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
    ),
  );
}

/// Previews for the reply's bare provider links, under its text. Off keeps
/// only the links (still tappable in the text above). Streaming text shows
/// none: a half-written link could name the wrong video.
Widget withProviderEmbeds(
  BuildContext context,
  String markdown,
  Widget body, {
  required bool complete,
}) {
  final reading = ReadingControls.maybeOf(context);
  if (!complete || _modeOf(reading) == InlineEmbedMode.off) return body;
  final embeds = bareProviderLinks(markdown);
  if (embeds.isEmpty) return body;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      body,
      for (final embed in embeds)
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: _ProviderEmbed(embed: embed),
        ),
    ],
  );
}

/// One provider preview behind the reader's consent.
class _ProviderEmbed extends StatelessWidget {
  _ProviderEmbed({required this.embed}) : super(key: ValueKey(embed.id));

  final EmbedDescriptor embed;

  @override
  Widget build(BuildContext context) {
    final card = _ProviderCard(embed: embed);
    if (!embed.provider.fetches) return card;
    return EmbedGate(
      service: embed.provider.id,
      serviceLabel: embed.provider.label,
      host: embed.host,
      openUri: embed.source,
      loaded: (_) => card,
    );
  }
}

/// The consent step: nothing inside [loaded] is built, so nothing is
/// fetched, until the mode, a saved allowance or "Load" permits it.
class EmbedGate extends StatefulWidget {
  const EmbedGate({
    super.key,
    required this.service,
    required this.serviceLabel,
    required this.host,
    required this.openUri,
    required this.loaded,
    this.caption,
    this.linkColor,
  });

  final String service;
  final String serviceLabel;
  final String host;
  final Uri openUri;
  final String? caption;
  final WidgetBuilder loaded;

  /// The surrounding prose's link colour, for Off's link. The placeholder
  /// draws on its own surface, in the layout's link colour.
  final Color? linkColor;

  @override
  State<EmbedGate> createState() => _EmbedGateState();
}

class _EmbedGateState extends State<EmbedGate> {
  var _once = false;

  @override
  Widget build(BuildContext context) {
    final reading = ReadingControls.maybeOf(context);
    final mode = _modeOf(reading);
    if (mode == InlineEmbedMode.off) {
      return _EmbedLink(
        uri: widget.openUri,
        label: widget.caption ?? widget.openUri.toString(),
        color: widget.linkColor,
      );
    }
    final allowed =
        mode == InlineEmbedMode.always ||
        _once ||
        (reading?.allowedEmbeds.contains(widget.service) ?? false);
    if (allowed) return widget.loaded(context);
    final l = context.sharedL10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      key: ValueKey('embed-placeholder-${widget.service}'),
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.public, size: 16, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: _EmbedLink(uri: widget.openUri, label: widget.host),
              ),
            ],
          ),
          if (widget.caption case final caption?)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilledButton.tonalIcon(
                key: ValueKey('embed-load-${widget.service}'),
                onPressed: () => setState(() => _once = true),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: Text(l.appearance_embed_load),
              ),
              if (reading != null &&
                  ReadingControls.isEmbedServiceKey(widget.service))
                OutlinedButton(
                  key: ValueKey('embed-allow-${widget.service}'),
                  onPressed: () =>
                      unawaited(reading.allowEmbedService(widget.service)),
                  child: Text(
                    l.appearance_embed_always_allow(widget.serviceLabel),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProviderCard extends StatefulWidget {
  const _ProviderCard({required this.embed});

  final EmbedDescriptor embed;

  @override
  State<_ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<_ProviderCard> {
  late Future<EmbedPreview> _preview = loadEmbedPreview(widget.embed);

  @override
  void didUpdateWidget(_ProviderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.embed != widget.embed) {
      _preview = loadEmbedPreview(widget.embed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final embed = widget.embed;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = context.sharedL10n;
    return FutureBuilder<EmbedPreview>(
      future: _preview,
      initialData: cachedEmbedPreview(embed),
      builder: (context, snapshot) {
        final preview = snapshot.data;
        final title = preview != null
            ? preview.title ?? embed.detail ?? embed.source.toString()
            : snapshot.hasError
            ? l.appearance_embed_preview_unavailable
            : l.appearance_embed_loading;
        final thumbnail = preview?.thumbnail;
        final provider = embed.provider;
        return Semantics(
          link: true,
          label: '${provider.label}: $title',
          child: Card(
            key: ValueKey('embed-card-${embed.id}'),
            margin: const EdgeInsets.symmetric(vertical: 6),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _open(embed.source),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (thumbnail != null)
                      AspectRatio(
                        aspectRatio: provider == EmbedProvider.spotify
                            ? 1
                            : provider == EmbedProvider.tiktok
                            ? 3 / 4
                            : 16 / 9,
                        child: Image(
                          image: CappedHttpsImage(
                            thumbnail,
                            maxBytes: _thumbnailMaxBytes,
                            maxEdge: 960,
                            allowed: (uri) =>
                                embedRequestAllowed(provider, uri),
                          ),
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, _) =>
                              ColoredBox(color: scheme.surfaceContainerHigh),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  [
                                    provider.label,
                                    ?preview?.byline,
                                    embed.host,
                                  ].join(' · '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              Icon(
                                Icons.open_in_new,
                                size: 16,
                                color: scheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
