/// Spoken-reply sanitizer. Mirrors Hermes Desktop's `lib/speech-text.ts`:
/// emoji, fenced/inline code, links, thinking prefixes, URLs, MEDIA: paths,
/// identifier-dense tokens, markdown tables, and line-break flattening are
/// all stripped or rewritten so a reply reads as clean prose instead of as
/// YAML-like noise. Keep this in lockstep with the server-side normalizer.
///
/// A table is spoken as its header row ("Model, Price, Context."), never as
/// cell-by-cell data. Identifier-dense tokens (filenames, hashes, UUIDs, dense
/// model IDs, paths) become silence — an English placeholder word is wrong
/// for every non-English voice.
library;

final RegExp _emojiRe = RegExp(
  '(?:[\\u{1F000}-\\u{1FAFF}\\u{2600}-\\u{27BF}]|[\\u{FE0F}\\u{200D}]|[\\u{E0020}-\\u{E007F}])+',
  unicode: true,
);

final RegExp _fencedCodeRe = RegExp('```[\\s\\S]*?(?:```|\$)');
final RegExp _inlineCodeRe = RegExp('`([^`]+)`');
final RegExp _markdownLinkRe = RegExp('\\[([^\\]]+)\\]\\(([^)]+)\\)');
final RegExp _paragraphBreakRe = RegExp(r'[ \t]*\n{2,}[ \t]*');
final RegExp _punctuatedParagraphBreakRe = RegExp(
  '([.!?])([*_~`>"\'’”)}\\]]*)[ \\t]*\\n{2,}[ \\t]*',
);
final RegExp _softBreakRe = RegExp(r'[ \t]*\n[ \t]*');
final RegExp _mediaPathRe = RegExp(
  r'[ \t]*MEDIA:\S+?(?=[.,;:!?)\]]*(?:\s|\$))',
);
final RegExp _lineFinalColonRe = RegExp(r':\s*$', multiLine: true);

final RegExp _thinkingPrefixRe = RegExp(
  '^\\s*(?:\\([^)\\n]{1,48}\\)\\s*)?(?:processing|thinking|reasoning|analyzing|pondering|contemplating|musing|cogitating|ruminating|deliberating|mulling|reflecting|computing|synthesizing|formulating|brainstorming)\\.\\.\\.\\s*',
  caseSensitive: false,
);

final RegExp _urlRe = RegExp(r'\bhttps?:\/\/\S+', caseSensitive: false);

final RegExp _filenameExtRe = RegExp(
  r'[\w.-]{0,60}\.(?:wav|ogg|mp3|flac|m4a|aac|py|pyc|ts|tsx|js|jsx|mjs|cjs|json|yaml|yml|toml|md|mdx|txt|csv|xlsx|xls|pdf|png|jpg|jpeg|gif|webp|svg|log|sql|sh|bash|zsh|rs|go|java|rb|php|html|css|lock|tar|gz|zip|db|sqlite|sqlite3|onnx|pt|bin|env|ini|conf|cfg|xml|dart|kt|swift|m|mm|h|hpp|c|cpp|cc|cxx|java|kt|kts|ipynb|lua|r|pl|pm|pas|asm|s|f|for|jl|zig|ex|exs|hs|scala|groovy|dart)\b',
  caseSensitive: false,
);
final RegExp _uuidRe = RegExp(
  r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
);
final RegExp _hashPrefixHexRe = RegExp(
  r'\b(?:sha(?:-?256|-?512|-?1|3)?|blake2[ab]?|md5|crc32?)[:\s]+[0-9a-fA-F]{7,64}',
  caseSensitive: false,
);
final RegExp _hexRunRe = RegExp(r'[0-9a-fA-F]{7,64}');
final RegExp _identifierTokenRe = RegExp(r'[A-Za-z0-9_./~@-]+');
final RegExp _dateTokenRe = RegExp(r'^\d{4}[-/]\d{1,2}(?:[-/]\d{1,2})?$');

bool _isDenseIdentifier(String token) {
  if (token.contains('@') || _dateTokenRe.hasMatch(token)) {
    return false; // email addresses, dates
  }
  if (RegExp(r'^(?:~/|\.\.?/|/)').hasMatch(token)) {
    return true; // filesystem paths
  }
  if (token.contains('/') &&
      (_filenameExtRe.hasMatch(token) || RegExp(r'\d').hasMatch(token))) {
    return true; // paths and dense model IDs
  }
  if (_filenameExtRe.hasMatch(token) || _uuidRe.hasMatch(token)) {
    return true;
  }
  if (_hexRunRe.hasMatch(token) && RegExp(r'\d').hasMatch(token)) {
    return true;
  }
  if (!RegExp(r'\d').hasMatch(token)) {
    return false;
  }
  final seps = ['_', '.', '/'].where((c) => token.contains(c)).length;
  final hyphens = '-'.allMatches(token).length;
  if (seps >= 2 || hyphens >= 2) {
    return true; // v2.1.0-beta.3, Llama-3.3-70B
  }
  return token.contains('/') || (hyphens >= 1 && seps >= 1);
}

String _pruneIdentifierTokens(String text) {
  return text
      .replaceAll(_hashPrefixHexRe, ' ')
      .replaceAllMapped(
        _identifierTokenRe,
        (m) => _isDenseIdentifier(m.group(0)!) ? ' ' : m.group(0)!,
      );
}

final RegExp _markdownTableDelimiterCellRe = RegExp(r'^:?-{3,}:?$');

bool _isUnescapedPipe(String row, int index) {
  var backslashes = 0;
  for (var cursor = index - 1; cursor >= 0 && row[cursor] == r'\'; cursor--) {
    backslashes++;
  }
  return backslashes % 2 == 0;
}

List<String> _splitMarkdownTableCells(String row) {
  final cells = <String>[];
  var cellStart = 0;
  for (var index = 0; index < row.length; index++) {
    if (row[index] == '|' && _isUnescapedPipe(row, index)) {
      cells.add(row.substring(cellStart, index).trim());
      cellStart = index + 1;
    }
  }
  cells.add(row.substring(cellStart).trim());
  return cells;
}

class _MarkdownTableRow {
  _MarkdownTableRow(this.blockquoteDepth, this.cells);
  final int blockquoteDepth;
  final List<String> cells;
}

_MarkdownTableRow? _parseMarkdownTableRow(String line) {
  var row = line;
  var blockquoteDepth = 0;

  while (true) {
    final indentation = RegExp(r'^[ \t]*').firstMatch(row)?.group(0) ?? '';
    if (indentation.contains('\t') || indentation.length > 3) {
      return null;
    }
    row = row.substring(indentation.length);
    if (!row.startsWith('>')) break;
    blockquoteDepth++;
    row = row.substring(1);
    if (row.startsWith(' ')) {
      row = row.substring(1);
    }
  }

  row = row.trimRight();

  final pipeIndexes = <int>[];
  final pipeMatches = RegExp(r'\|').allMatches(row);
  for (final match in pipeMatches) {
    if (_isUnescapedPipe(row, match.start)) {
      pipeIndexes.add(match.start);
    }
  }
  if (pipeIndexes.isEmpty) return null;
  final hasLeadingPipe = pipeIndexes.first == 0;
  final hasTrailingPipe = pipeIndexes.last == row.length - 1;

  if (hasLeadingPipe) row = row.substring(1);
  if (hasTrailingPipe) row = row.substring(0, row.length - 1);

  final cells = _splitMarkdownTableCells(row);
  if (cells.length < 2 &&
      !(hasLeadingPipe && hasTrailingPipe && cells.length == 1)) {
    return null;
  }
  return _MarkdownTableRow(blockquoteDepth, cells);
}

String _speakableTableHeader(List<String> cells) {
  final header = cells
      .map((cell) => cell.replaceAll(RegExp(r'\\\|'), ' ').trim())
      .where((cell) => cell.isNotEmpty)
      .join(', ');
  return header.isEmpty || RegExp(r'[.!?:]$').hasMatch(header)
      ? header
      : '$header.';
}

String _summarizeMarkdownTables(String text) {
  final lines = text.replaceAll(RegExp(r'\r\n?'), '\n').split('\n');
  final tableLines = <int>{};
  final headers = <int, String>{};

  var index = 1;
  while (index < lines.length) {
    final delimiterRow = _parseMarkdownTableRow(lines[index]);
    final headerRow = _parseMarkdownTableRow(lines[index - 1]);
    if (delimiterRow == null ||
        headerRow == null ||
        !delimiterRow.cells.every(
          (cell) => _markdownTableDelimiterCellRe.hasMatch(cell),
        ) ||
        headerRow.cells.length != delimiterRow.cells.length ||
        headerRow.blockquoteDepth != delimiterRow.blockquoteDepth) {
      index++;
      continue;
    }
    tableLines.add(index - 1);
    tableLines.add(index);
    headers[index - 1] = _speakableTableHeader(headerRow.cells);

    var rowIndex = index + 1;
    for (; rowIndex < lines.length; rowIndex++) {
      final bodyRow = _parseMarkdownTableRow(lines[rowIndex]);
      if (bodyRow == null ||
          bodyRow.blockquoteDepth != delimiterRow.blockquoteDepth) {
        break;
      }
      tableLines.add(rowIndex);
    }
    index = rowIndex;
  }

  return lines
      .asMap()
      .entries
      .expand((entry) {
        final line = entry.value;
        if (!tableLines.contains(entry.key)) return [line];
        final header = headers[entry.key];
        return header != null ? [header] : <String>[];
      })
      .join('\n');
}

String _normalizeLineBreaks(String text) {
  return text
      .replaceAll(RegExp(r'\r\n?'), '\n')
      .replaceAllMapped(
        RegExp(r'(\p{L})-\n(\p{L})', unicode: true),
        (m) => '${m[1]}${m[2]}',
      )
      .replaceAllMapped(_punctuatedParagraphBreakRe, (m) => '${m[1]}${m[2]} ')
      .replaceAll(_paragraphBreakRe, '. ')
      .replaceAll(_softBreakRe, ' ');
}

/// Sentence cutter: emit complete sentences as they form, hold the incomplete
/// tail, flush everything on [flush]. Mirrors the server-side SentenceChunker.
({List<String> sentences, String rest}) cutSentences(
  String buffer,
  bool flush, {
  int? minSentenceChars,
}) {
  final minChars = minSentenceChars ?? 24;
  final sentences = <String>[];
  var rest = buffer;
  var start = 0;

  final sentenceCutRe = RegExp('[.!?…。！？]+["”’)\\]]*\\s+');
  for (final match in sentenceCutRe.allMatches(buffer)) {
    final end = match.start + match[0]!.length;
    final candidate = buffer.substring(start, end).trim();
    if (candidate.length >= minChars) {
      sentences.add(candidate);
      start = end;
    }
  }

  rest = buffer.substring(start);
  if (flush) {
    final tail = rest.trim();
    if (tail.isNotEmpty) sentences.add(tail);
    rest = '';
  }

  return (sentences: sentences, rest: rest);
}

/// Incremental wrapper over [cutSentences] for the sync (non-streaming
/// provider) fallback.
class IncrementalSpeechSentenceBuffer {
  String _buffer = '';

  List<String> append(String delta) {
    final cut = cutSentences(_buffer + delta, false);
    _buffer = cut.rest;
    return cut.sentences;
  }

  List<String> flush() {
    final cut = cutSentences(_buffer, true);
    _buffer = '';
    return cut.sentences;
  }
}

/// Rewrite a reply for a spoken voice: no markdown, no code, no links, no
/// thinking preamble, no stale headings, no URL/PATH/identifier noise.
String sanitizeTextForSpeech(String text) {
  // Tables first: their right-align marker is a trailing colon (":-").
  final withoutTables = _summarizeMarkdownTables(text);

  // Close line-final colons BEFORE newlines are flattened.
  final pre = withoutTables.replaceAll(_lineFinalColonRe, '.');

  final withoutIdentifiers = _pruneIdentifierTokens(
    _normalizeLineBreaks(pre)
        .replaceAll(_fencedCodeRe, '')
        .replaceAll(_thinkingPrefixRe, ' ')
        .replaceAllMapped(_markdownLinkRe, (m) => m[1]!)
        .replaceAllMapped(_inlineCodeRe, (m) => m[1]!)
        .replaceAll(_urlRe, '')
        .replaceAll(_mediaPathRe, '')
        .replaceAll(_emojiRe, ' '),
  );

  return withoutIdentifiers
      .replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '')
      .replaceAll(RegExp(r'[*_~>#]'), '')
      .replaceAll(RegExp(r'^\s*[-+*]\s+', multiLine: true), '')
      .replaceAll(RegExp(r':\s*$'), '.')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
