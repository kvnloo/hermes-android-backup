import 'package:flutter/foundation.dart';

import '../utils/media_tags.dart';

/// Agent text is inspected only up to this many characters. Titles,
/// document markers and tags sit near the start; a longer body is never
/// rescanned whole on the UI thread.
const artifactInspectChars = 16 * 1024;

/// A small most-recently-used memo keyed by a content hash. The stored text
/// is compared on a hash hit, so a collision recomputes instead of returning
/// another fence's result. A rebuild with unchanged text (every earlier
/// fence while a reply streams) skips the parser.
class ContentMemo<V> {
  ContentMemo(this.capacity);

  final int capacity;
  // Map literals keep insertion order, which makes this least-recently-used.
  final _entries = <String, (String, String, V)>{};

  /// How many times [lookup] had to compute. Tests use it to prove a cache hit.
  @visibleForTesting
  int misses = 0;

  V lookup(String content, V Function() compute, {String scope = ''}) {
    final key = '$scope:${artifactContentHash(content)}:${content.length}';
    final hit = _entries.remove(key);
    if (hit != null && hit.$1 == scope && hit.$2 == content) {
      _entries[key] = hit;
      return hit.$3;
    }
    misses++;
    final value = compute();
    _entries[key] = (scope, content, value);
    while (_entries.length > capacity) {
      _entries.remove(_entries.keys.first);
    }
    return value;
  }

  /// The stored value for [content] without computing one, or null.
  ({V value})? peek(String content, {String scope = ''}) {
    final key = '$scope:${artifactContentHash(content)}:${content.length}';
    final hit = _entries.remove(key);
    if (hit == null || hit.$1 != scope || hit.$2 != content) {
      if (hit != null) _entries[key] = hit;
      return null;
    }
    _entries[key] = hit;
    return (value: hit.$3);
  }

  /// Stores a value computed elsewhere (a background parse).
  void put(String content, V value, {String scope = ''}) {
    final key = '$scope:${artifactContentHash(content)}:${content.length}';
    _entries.remove(key);
    _entries[key] = (scope, content, value);
    while (_entries.length > capacity) {
      _entries.remove(_entries.keys.first);
    }
  }

  void clear() {
    _entries.clear();
    misses = 0;
  }
}

String _head(String text) => text.length > artifactInspectChars
    ? text.substring(0, artifactInspectChars)
    : text;

bool _asciiLetter(int c) =>
    (c >= 0x61 && c <= 0x7a) || (c >= 0x41 && c <= 0x5a);

bool _tagNameChar(int c) =>
    _asciiLetter(c) || (c >= 0x30 && c <= 0x39) || c == 0x2d;

/// The whitespace `\s` matched for these short markers.
bool isMarkupSpace(int c) =>
    c == 0x20 ||
    (c >= 0x09 && c <= 0x0d) ||
    c == 0xa0 ||
    c == 0x1680 ||
    (c >= 0x2000 && c <= 0x200a) ||
    c == 0x2028 ||
    c == 0x2029 ||
    c == 0x202f ||
    c == 0x205f ||
    c == 0x3000 ||
    c == 0xfeff;

enum GeneratedArtifactKind { code, html, svg }

class GeneratedArtifact {
  const GeneratedArtifact({
    required this.kind,
    required this.language,
    required this.title,
  });

  final GeneratedArtifactKind kind;
  final String language;
  final String title;
}

const _htmlLanguages = {'html', 'htm', 'xhtml'};
const _nonArtifactLanguages = {
  '',
  'console',
  'diff',
  'listing',
  'log',
  'logs',
  'markdown',
  'md',
  'mermaid',
  'output',
  'patch',
  'plain',
  'plaintext',
  'shell-session',
  'stdout',
  'text',
  'txt',
};
const _commonCodeLanguages = {
  'bash',
  'c',
  'cpp',
  'cs',
  'css',
  'dart',
  'go',
  'html',
  'java',
  'javascript',
  'js',
  'json',
  'jsx',
  'kt',
  'php',
  'py',
  'python',
  'rb',
  'rs',
  'sh',
  'sql',
  'swift',
  'ts',
  'tsx',
  'typescript',
  'yaml',
  'yml',
};

final _languageTag = RegExp(r'^[a-z0-9][a-z0-9+#-]*$', caseSensitive: false);
// Indentation only: a `\s*` here also ate blank lines from every newline and
// went quadratic on a run of empty lines.
final _codeDeclaration = RegExp(
  r'(?:^|\n)[ \t]*(?:export\s+)?(?:default\s+)?(?:async\s+)?(?:function|class|struct|interface|enum|trait|impl|def|fn)\s+([A-Za-z_$][\w$]*)',
);
final _codeSignal = RegExp(
  r'[;{}]|\b(def|class|function|import|const|let|var|fn|struct)\b',
);
final _wordGap = RegExp(r'\s+');
final _filenameComment = RegExp(
  r'^\s*(?://|#|--|<!--|/\*)\s*([\w./-]+\.[a-z0-9]{1,8})\b',
  caseSensitive: false,
);

const _htmlFragmentMinChars = 1200;
const _svgMinChars = 2000;
const _codeMinLines = 48;
const _codeMinChars = 3000;

String sanitizeLanguageTag(String? tag) {
  final first = (tag ?? '').trim().split(RegExp(r'\s')).first;
  if (first.isEmpty || first.length > 16 || !_languageTag.hasMatch(first)) {
    return '';
  }
  return first.toLowerCase();
}

bool isLikelyProseCodeBlock(String language, String code) {
  if (_commonCodeLanguages.contains(language)) return false;
  var prose = 0;
  var signals = 0;
  for (final line in _head(code).split('\n')) {
    if (_codeSignal.hasMatch(line)) {
      signals++;
    } else if (line.trim().split(_wordGap).length > 8) {
      prose++;
    }
  }
  return prose >= 2 && signals <= 1;
}

/// [lowerAscii] is a lower-case ASCII pattern; [text] is compared without
/// regard to ASCII case, in place, so offsets stay those of [text].
bool _matchesAt(String text, int at, String lowerAscii) {
  if (at < 0 || at + lowerAscii.length > text.length) return false;
  for (var i = 0; i < lowerAscii.length; i++) {
    var c = text.codeUnitAt(at + i);
    if (c >= 0x41 && c <= 0x5a) c |= 0x20;
    if (c != lowerAscii.codeUnitAt(i)) return false;
  }
  return true;
}

int _indexOfIgnoreCase(String text, String lowerAscii, [int from = 0]) {
  final last = text.length - lowerAscii.length;
  for (var i = from < 0 ? 0 : from; i <= last; i++) {
    if (_matchesAt(text, i, lowerAscii)) return i;
  }
  return -1;
}

/// `<!doctype html`, `<html`, `<head` or `<body` followed by a space or `>`.
/// One forward pass; replaces a regex that the reply text could stall.
bool _looksLikeHtmlDocument(String text) {
  var at = text.indexOf('<');
  while (at >= 0) {
    if (_matchesAt(text, at, '<!doctype')) {
      var i = at + 9;
      final start = i;
      while (i < text.length && isMarkupSpace(text.codeUnitAt(i))) {
        i++;
      }
      if (i > start && _matchesAt(text, i, 'html')) return true;
    } else if (_matchesAt(text, at, '<html') ||
        _matchesAt(text, at, '<head') ||
        _matchesAt(text, at, '<body')) {
      final next = at + 5;
      if (next < text.length) {
        final c = text.codeUnitAt(next);
        if (c == 0x3e || isMarkupSpace(c)) return true;
      }
    }
    at = text.indexOf('<', at + 1);
  }
  return false;
}

/// `<name` followed by a space or `>`, anywhere in [text].
bool _hasOpenTag(String text, String name) {
  final open = '<$name';
  var at = _indexOfIgnoreCase(text, open);
  while (at >= 0) {
    final next = at + open.length;
    if (next < text.length) {
      final c = text.codeUnitAt(next);
      if (c == 0x3e || isMarkupSpace(c)) return true;
    }
    at = _indexOfIgnoreCase(text, open, at + 1);
  }
  return false;
}

/// True when [text] holds `<name>` or `<name attrs…>`. Each `<` is read
/// once: the tag name stops before the next `<`, and whether any `>`
/// follows is one precomputed index, so unterminated tags cannot make the
/// scan restart from every `<`.
bool _hasHtmlTag(String text) {
  final lastClose = text.lastIndexOf('>');
  if (lastClose < 0) return false;
  var at = text.indexOf('<');
  while (at >= 0 && at < lastClose) {
    var i = at + 1;
    if (i < text.length && _asciiLetter(text.codeUnitAt(i))) {
      i++;
      while (i < text.length && _tagNameChar(text.codeUnitAt(i))) {
        i++;
      }
      if (i < text.length) {
        final c = text.codeUnitAt(i);
        if (c == 0x3e) return true;
        if (isMarkupSpace(c) && lastClose > i) return true;
      }
    }
    at = text.indexOf('<', at + 1);
  }
  return false;
}

/// Replaces each `<…>` with a space, then collapses whitespace. Unclosed
/// `<` keeps the rest as text, as the old pattern did, in one pass.
String _stripTags(String value) {
  final out = StringBuffer();
  var i = 0;
  while (i < value.length) {
    final open = value.indexOf('<', i);
    final close = open < 0 ? -1 : value.indexOf('>', open + 1);
    if (close < 0) {
      out.write(value.substring(i));
      break;
    }
    out
      ..write(value.substring(i, open))
      ..write(' ');
    i = close + 1;
  }
  return out.toString().replaceAll(_wordGap, ' ').trim();
}

/// The text of the first `<tag …>…</tag>` in the inspected head. Only the
/// first opener can match: a later one has the same or a later `>` and
/// closer, so failing there fails everywhere.
String _titleFromTag(String content, String tag) {
  final head = _head(content);
  final open = _indexOfIgnoreCase(head, '<$tag');
  if (open < 0) return '';
  final gt = head.indexOf('>', open + tag.length + 1);
  if (gt < 0) return '';
  final close = _indexOfIgnoreCase(head, '</$tag>', gt + 1);
  if (close < 0) return '';
  final text = _stripTags(head.substring(gt + 1, close));
  return text.length > 80 ? text.substring(0, 80) : text;
}

String _codeTitle(String language, String content) {
  final head = content.length > 2000 ? content.substring(0, 2000) : content;
  final fileName = _filenameComment.firstMatch(head)?.group(1);
  if (fileName != null && fileName.isNotEmpty) return fileName;
  final declaration = _codeDeclaration.firstMatch(head)?.group(1);
  if (declaration != null && declaration.isNotEmpty) return declaration;
  return language;
}

int _lineCount(String text) {
  var lines = 1;
  var index = text.indexOf('\n');
  while (index != -1) {
    lines++;
    index = text.indexOf('\n', index + 1);
  }
  return lines;
}

final _detections = ContentMemo<GeneratedArtifact?>(64);
final _histories = ContentMemo<List<VersionedArtifact>>(16);

/// Drops memoised detections, for a renderer reset or a cold timing test.
void resetArtifactCaches() {
  _detections.clear();
  _histories.clear();
}

/// Scans actually run (cache misses), for tests.
@visibleForTesting
int get debugArtifactScans => _detections.misses + _histories.misses;

/// Promotes a substantial HTML, SVG or code fence. Small snippets stay inline.
/// Results are memoised by content, so a rebuild or streamed token that
/// leaves this fence unchanged does not scan it again.
GeneratedArtifact? detectArtifact(String? language, String? code) {
  final trimmed = (code ?? '').trim();
  if (trimmed.isEmpty) return null;
  final clean = sanitizeLanguageTag(language);
  return _detections.lookup(
    trimmed,
    () => _detect(clean, trimmed),
    scope: clean,
  );
}

GeneratedArtifact? _detect(String clean, String trimmed) {
  if (_htmlLanguages.contains(clean)) {
    final head = _head(trimmed);
    final document = _looksLikeHtmlDocument(head);
    // A fenced HTML document is one artefact even when the draft is short.
    // Fragments still have to be large so a tag example stays a code fence.
    final substantial =
        document ||
        (trimmed.length >= _htmlFragmentMinChars && _hasHtmlTag(head));
    if (!substantial) return null;
    final title = _titleFromTag(head, 'title');
    final heading = title.isEmpty ? _titleFromTag(head, 'h1') : '';
    return GeneratedArtifact(
      kind: GeneratedArtifactKind.html,
      language: clean,
      title: title.isNotEmpty ? title : (heading.isNotEmpty ? heading : 'HTML'),
    );
  }
  if (clean == 'svg') {
    if (trimmed.length >= _svgMinChars && _hasOpenTag(_head(trimmed), 'svg')) {
      final title = _titleFromTag(trimmed, 'title');
      return GeneratedArtifact(
        kind: GeneratedArtifactKind.svg,
        language: clean,
        title: title.isEmpty ? 'SVG' : title,
      );
    }
    return null;
  }
  if (_nonArtifactLanguages.contains(clean)) return null;
  if (trimmed.length < _codeMinChars && _lineCount(trimmed) < _codeMinLines) {
    return null;
  }
  if (isLikelyProseCodeBlock(clean, trimmed)) return null;
  return GeneratedArtifact(
    kind: GeneratedArtifactKind.code,
    language: clean,
    title: _codeTitle(clean, trimmed),
  );
}

/// [value] without leading and trailing [chars]. A hand trim: `^-+|-+$`
/// restarted inside a long dash run that did not end the value.
String _trimRuns(String value, String chars) {
  var start = 0;
  var end = value.length;
  while (start < end && chars.contains(value[start])) {
    start++;
  }
  while (end > start && chars.contains(value[end - 1])) {
    end--;
  }
  return value.substring(start, end);
}

String artifactSlug(GeneratedArtifact detection) {
  final title = _trimRuns(
    detection.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-'),
    '-',
  );
  final trimmed = title.length > 48 ? title.substring(0, 48) : title;
  return '${detection.kind.name}:${detection.language}:${trimmed.isEmpty ? 'untitled' : trimmed}';
}

String artifactContentHash(String content) {
  var hash = 0x811c9dc5;
  for (final unit in content.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash.toRadixString(36);
}

const _downloadExtensions = {
  'bash': '.sh',
  'c': '.c',
  'cpp': '.cpp',
  'css': '.css',
  'dart': '.dart',
  'go': '.go',
  'htm': '.html',
  'html': '.html',
  'java': '.java',
  'javascript': '.js',
  'js': '.js',
  'json': '.json',
  'jsx': '.jsx',
  'php': '.php',
  'py': '.py',
  'python': '.py',
  'rb': '.rb',
  'rs': '.rs',
  'sh': '.sh',
  'sql': '.sql',
  'svg': '.svg',
  'swift': '.swift',
  'ts': '.ts',
  'tsx': '.tsx',
  'typescript': '.ts',
  'xhtml': '.html',
  'yaml': '.yaml',
  'yml': '.yaml',
};

String artifactDownloadName(GeneratedArtifact detection) {
  final base = _trimRuns(
    detection.title
        .replaceAll(RegExp(r'[^A-Za-z0-9._ -]+'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '-'),
    '-',
  );
  var clipped = base.isEmpty
      ? 'artifact'
      : (base.length > 60 ? base.substring(0, 60) : base);
  var end = clipped.length;
  while (end > 0 && ' .'.contains(clipped[end - 1])) {
    end--;
  }
  clipped = clipped.substring(0, end);
  if (RegExp(r'\.[a-z0-9]{1,8}$', caseSensitive: false).hasMatch(clipped)) {
    return clipped;
  }
  final extension = switch (detection.kind) {
    GeneratedArtifactKind.html => '.html',
    GeneratedArtifactKind.svg => '.svg',
    GeneratedArtifactKind.code =>
      _downloadExtensions[detection.language] ?? '.txt',
  };
  return '$clipped$extension';
}

class ArtifactRevision {
  const ArtifactRevision({
    required this.index,
    required this.hash,
    required this.content,
    required this.detection,
  });

  final int index;
  final String hash;
  final String content;
  final GeneratedArtifact detection;

  String get downloadName => artifactDownloadName(detection);
}

class VersionedArtifact {
  const VersionedArtifact({required this.slug, required this.revisions});

  final String slug;
  final List<ArtifactRevision> revisions;
}

final _fence = RegExp(r'```([^\n`]*)\n([\s\S]*?)```');

/// Rebuilds versioned artifacts from assistant text. The same title in one
/// corpus is one artifact; a changed body is the next revision. No file is
/// required. Memoised by corpus, so every card in one reply shares one scan.
List<VersionedArtifact> artifactHistoryFromText(String corpus) =>
    _histories.lookup(corpus, () => _historyFromText(corpus));

/// A fence opened at the start of a line after [from] that never closes:
/// a reply still streaming, or one cut off at its token limit. Its body is
/// everything after the opening line.
({String language, String body})? openFenceTail(String corpus, int from) {
  final open = corpus.lastIndexOf('```');
  if (open < from) return null;
  var lineStart = open;
  while (lineStart > 0 && corpus.codeUnitAt(lineStart - 1) == 0x20) {
    lineStart--;
  }
  if (open - lineStart > 3) return null;
  if (lineStart > 0 && corpus.codeUnitAt(lineStart - 1) != 0x0a) return null;
  final infoEnd = corpus.indexOf('\n', open + 3);
  if (infoEnd < 0) return null;
  final info = corpus.substring(open + 3, infoEnd);
  if (info.contains('`')) return null;
  return (language: info, body: corpus.substring(infoEnd + 1));
}

List<VersionedArtifact> _historyFromText(String corpus) {
  final grouped = <String, List<ArtifactRevision>>{};
  final order = <String>[];
  var closedEnd = 0;
  final fences = <(String?, String)>[];
  for (final match in _fence.allMatches(corpus)) {
    fences.add((match.group(1), match.group(2) ?? ''));
    closedEnd = match.end;
  }
  // The open fence at the end of the reply is its latest revision, so every
  // card in the reply counts it while it streams or after a cut-off.
  final tail = openFenceTail(corpus, closedEnd);
  if (tail != null) fences.add((tail.language, tail.body));
  for (final (language, body) in fences) {
    final detection = detectArtifact(language, body);
    if (detection == null) continue;
    final slug = artifactSlug(detection);
    final hash = artifactContentHash(body.trim());
    final revisions = grouped.putIfAbsent(slug, () {
      order.add(slug);
      return <ArtifactRevision>[];
    });
    if (revisions.isNotEmpty && revisions.last.hash == hash) continue;
    revisions.add(
      ArtifactRevision(
        index: revisions.length + 1,
        hash: hash,
        content: body.trim(),
        detection: detection,
      ),
    );
  }
  return List.unmodifiable([
    for (final slug in order)
      VersionedArtifact(
        slug: slug,
        revisions: List.unmodifiable(grouped[slug]!),
      ),
  ]);
}

enum IndexedArtifactKind { image, file, link }

class IndexedArtifact {
  const IndexedArtifact({
    required this.id,
    required this.kind,
    required this.value,
    required this.label,
    required this.sessionId,
    required this.sessionTitle,
    required this.timestamp,
  });

  final String id;
  final IndexedArtifactKind kind;
  final String value;
  final String label;
  final String sessionId;
  final String sessionTitle;
  final double timestamp;
}

/// Markdown link text longer than this is not read as a link label.
const markdownLinkLabelMaxChars = 200;

/// A path or URL longer than this is not indexed: no real artefact address
/// is that long, and the extension checks below then stay bounded.
const indexedValueMaxChars = 2048;

/// One `[label](target)` or `![alt](target)` found by [_bracketLinks].
typedef _BracketLink = ({int start, int end, String target});

/// The `[label](target)` (or, with [image], `![alt](target)`) links in
/// [text], leftmost first and not overlapping, as `allMatches` of
/// `\[([^\]]+)\]\(([^)\s]+)\)` found them, but read in one pass. The
/// patterns restarted at every `[` and rescanned to the end, so terminal
/// output full of ANSI `ESC[` codes took seconds to index. A label over
/// [markdownLinkLabelMaxChars] is not a link.
List<_BracketLink> _bracketLinks(String text, {required bool image}) {
  final found = <_BracketLink>[];
  // The first `]` at or after a position, and the first `)` or whitespace,
  // are reused while later starts fall before them, so each character is
  // passed over a bounded number of times.
  var closeFrom = -1, close = -1;
  var stopFrom = -1, stop = -1;
  int nextClose(int from) {
    if (from < closeFrom || from > close || close < 0) {
      closeFrom = from;
      close = text.indexOf(']', from);
      if (close < 0) close = text.length;
    }
    return close;
  }

  int nextStop(int from) {
    if (from < stopFrom || from > stop) {
      stopFrom = from;
      var i = from;
      while (i < text.length) {
        final c = text.codeUnitAt(i);
        if (c == 0x29 /* ) */ || isMarkupSpace(c)) break;
        i++;
      }
      stop = i;
    }
    return stop;
  }

  var at = text.indexOf(image ? '![' : '[');
  while (at >= 0) {
    final open = image ? at + 1 : at;
    final labelStart = open + 1;
    final labelEnd = nextClose(labelStart);
    final labelLength = labelEnd - labelStart;
    var next = at + 1;
    if (labelEnd < text.length &&
        (image || labelLength > 0) &&
        labelLength <= markdownLinkLabelMaxChars &&
        labelEnd + 1 < text.length &&
        text.codeUnitAt(labelEnd + 1) == 0x28 /* ( */ ) {
      final targetStart = labelEnd + 2;
      final targetEnd = nextStop(targetStart);
      if (targetEnd > targetStart &&
          targetEnd < text.length &&
          text.codeUnitAt(targetEnd) == 0x29) {
        found.add((
          start: at,
          end: targetEnd + 1,
          target: text.substring(targetStart, targetEnd),
        ));
        next = targetEnd + 1;
      }
    }
    at = text.indexOf(image ? '![' : '[', next);
  }
  return found;
}

final _bareUrl = RegExp(r'''https?://[^\s<>"'`)]+''');
final _unixPath = RegExp(r'''(^|[\s("'`)])((?:/|~/|\.\.?/)[^\s"'`<>]+)''');
final _imageExt = RegExp(
  r'\.(?:png|jpe?g|gif|webp|svg|bmp)(?:\?.*)?$',
  caseSensitive: false,
);
final _fileExt = RegExp(
  r'\.(?:png|jpe?g|gif|webp|svg|bmp|pdf|txt|json|md|csv|xlsx?|docx?|pptx?|html?|zip|tar|gz|avi|flac|m4a|mkv|mp3|ogg|opus|wav|webm|mp4|mov)(?:\?.*)?$',
  caseSensitive: false,
);
final _producerTool = RegExp(
  r'(?:^|_)(?:creat(?:e|ion)|download|export|generat(?:e|ion)|render|save|speech|tts|write)(?:_|$)',
  caseSensitive: false,
);
final _wheel = RegExp(r'\.whl(?:\.metadata)?$', caseSensitive: false);
final _pipCache = RegExp(
  r'/(?:\.cache/pip|library/caches/pip|appdata/local/pip/cache)/',
  caseSensitive: false,
);

bool _packageDownload(String value) {
  final path = value.replaceAll('\\', '/').toLowerCase();
  return _pipCache.hasMatch(path) || _wheel.hasMatch(path);
}

String _cleanArtifactValue(String value) {
  var trimmed = value.trim();
  for (var i = 0; i < 3; i++) {
    if (trimmed.length >= 2 &&
        '"\'`'.contains(trimmed[0]) &&
        trimmed[0] == trimmed[trimmed.length - 1]) {
      trimmed = trimmed.substring(1, trimmed.length - 1).trim();
      continue;
    }
    break;
  }
  // Trailing emphasis and punctuation, trimmed by hand: `[`*]+$` and
  // `[),.;]+$` restarted inside a long run that did not end the value.
  var end = trimmed.length;
  while (end > 0 && '`*'.contains(trimmed[end - 1])) {
    end--;
  }
  while (end > 0 && '),.;'.contains(trimmed[end - 1])) {
    end--;
  }
  return trimmed.substring(0, end);
}

IndexedArtifactKind? _kindFor(String value, {required bool explicit}) {
  if (!explicit && _packageDownload(value)) return null;
  if (value.startsWith('https://') || value.startsWith('http://')) {
    return _fileExt.hasMatch(value)
        ? (_imageExt.hasMatch(value)
              ? IndexedArtifactKind.image
              : IndexedArtifactKind.file)
        : IndexedArtifactKind.link;
  }
  if (explicit || _fileExt.hasMatch(value)) {
    return _imageExt.hasMatch(value)
        ? IndexedArtifactKind.image
        : IndexedArtifactKind.file;
  }
  return null;
}

void _pushIndexed(
  Map<String, IndexedArtifact> into,
  String raw, {
  required String sessionId,
  required String sessionTitle,
  required double timestamp,
  bool explicit = false,
}) {
  if (raw.length > indexedValueMaxChars) return;
  final value = _cleanArtifactValue(raw);
  if (value.isEmpty) return;
  final kind = _kindFor(value, explicit: explicit);
  if (kind == null) return;
  final id = '$sessionId|$value';
  final label = value.split('/').last.split('?').first;
  into[id] = IndexedArtifact(
    id: id,
    kind: kind,
    value: value,
    label: label.isEmpty ? value : label,
    sessionId: sessionId,
    sessionTitle: sessionTitle,
    timestamp: timestamp,
  );
}

void _fromProse(
  Map<String, IndexedArtifact> into,
  String text, {
  required String sessionId,
  required String sessionTitle,
  required double timestamp,
}) {
  for (final ref in extractMediaTagRefs(text)) {
    _pushIndexed(
      into,
      ref.path,
      sessionId: sessionId,
      sessionTitle: sessionTitle,
      timestamp: timestamp,
      explicit: true,
    );
  }
  for (final link in _bracketLinks(text, image: true)) {
    _pushIndexed(
      into,
      link.target,
      sessionId: sessionId,
      sessionTitle: sessionTitle,
      timestamp: timestamp,
    );
  }
  for (final link in _bracketLinks(text, image: false)) {
    final start = link.start;
    if (start > 0 && text.codeUnitAt(start - 1) == 0x21 /* ! */ ) continue;
    _pushIndexed(
      into,
      link.target,
      sessionId: sessionId,
      sessionTitle: sessionTitle,
      timestamp: timestamp,
    );
  }
  for (final match in _bareUrl.allMatches(text)) {
    _pushIndexed(
      into,
      match.group(0) ?? '',
      sessionId: sessionId,
      sessionTitle: sessionTitle,
      timestamp: timestamp,
    );
  }
  for (final match in _unixPath.allMatches(text)) {
    _pushIndexed(
      into,
      match.group(2) ?? '',
      sessionId: sessionId,
      sessionTitle: sessionTitle,
      timestamp: timestamp,
    );
  }
}

double _timestampOf(Map<String, dynamic> message) {
  final raw = message['timestamp'];
  final parsed = raw is num
      ? raw.toDouble()
      : raw is String
      ? double.tryParse(raw)
      : null;
  return parsed != null && parsed.isFinite ? parsed : 0;
}

/// Indexes ordinary links, recognised paths and selected tool output.
/// Explicit deliveries stay eligible even when a heuristic would skip them.
List<IndexedArtifact> indexArtifactsFromMessages({
  required String sessionId,
  required String sessionTitle,
  required List<Map<String, dynamic>> messages,
}) {
  final found = <String, IndexedArtifact>{};
  for (final message in messages) {
    final role = message['role']?.toString() ?? '';
    final text = message['content']?.toString() ?? '';
    final timestamp = _timestampOf(message);
    if (role == 'assistant' || role == 'agent') {
      if (text.isNotEmpty) {
        _fromProse(
          found,
          text,
          sessionId: sessionId,
          sessionTitle: sessionTitle,
          timestamp: timestamp,
        );
      }
      continue;
    }
    if (role != 'tool') continue;
    final name = (message['tool_name'] ?? message['name'] ?? '')
        .toString()
        .trim()
        .toLowerCase();
    final producer =
        _producerTool.hasMatch(name) || name.startsWith('bfl_flux3_');
    final terminal = name == 'terminal';
    if (text.isNotEmpty && (producer || terminal)) {
      _fromProse(
        found,
        text,
        sessionId: sessionId,
        sessionTitle: sessionTitle,
        timestamp: timestamp,
      );
    }
    if (name == 'browser_vision' || name == 'vision_analyze') {
      for (final match in RegExp(
        r'Screenshot path:\s*([^\r\n<>]+)',
        caseSensitive: false,
      ).allMatches(text)) {
        _pushIndexed(
          found,
          match.group(1) ?? '',
          sessionId: sessionId,
          sessionTitle: sessionTitle,
          timestamp: timestamp,
          explicit: true,
        );
      }
    }
  }
  final values = found.values.toList()
    ..sort((a, b) {
      final byTime = b.timestamp.compareTo(a.timestamp);
      return byTime == 0 ? a.id.compareTo(b.id) : byTime;
    });
  return values;
}
