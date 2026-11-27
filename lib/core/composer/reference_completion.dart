import '../../l10n/app_localizations.dart';
import '../l10n/service_strings.dart';

const kReferenceKinds = ['file', 'folder', 'url', 'image', 'tool', 'git'];
const kSimpleReferences = ['diff', 'staged'];

Map<String, String> _referenceMeta(AppLocalizations l) => {
  'file': l.rel_svc_misc_attach_file_reference,
  'folder': l.rel_svc_misc_attach_folder_reference,
  'url': l.rel_svc_misc_attach_url_reference,
  'image': l.rel_svc_misc_attach_image_reference,
  'tool': l.rel_svc_misc_attach_tool_reference,
  'git': l.rel_svc_misc_attach_git_context,
  'diff': l.rel_svc_misc_attach_unstaged_diff,
  'staged': l.rel_svc_misc_attach_staged_diff,
};

/// Localized descriptions for callers that previously read the starter map.
Map<String, String> get kReferenceMeta => _referenceMeta(serviceStrings);

class ReferenceSuggestion {
  const ReferenceSuggestion({
    required this.insert,
    required this.label,
    this.meta = '',
    required this.kind,
  });

  final String insert;
  final String label;
  final String meta;
  final String kind;
}

class ReferenceChip {
  const ReferenceChip({
    required this.start,
    required this.end,
    required this.raw,
    required this.kind,
    required this.value,
  });

  final int start;
  final int end;
  final String raw;
  final String kind;
  final String value;
}

/// Local starter rows. A gateway listing replaces these once it arrives;
/// an empty or failed listing does not invent paths.
List<ReferenceSuggestion> starterSuggestions(
  String query, {
  AppLocalizations? strings,
}) {
  final referenceMeta = _referenceMeta(strings ?? serviceStrings);
  final needle = query.toLowerCase();
  if (needle.contains(':')) return const [];
  final rows = <ReferenceSuggestion>[];
  for (final kind in kReferenceKinds) {
    if (needle.isEmpty || kind.startsWith(needle)) {
      rows.add(
        ReferenceSuggestion(
          insert: '@$kind:',
          label: '@$kind:',
          meta: referenceMeta[kind] ?? '',
          kind: kind,
        ),
      );
    }
  }
  for (final kind in kSimpleReferences) {
    if (needle.isEmpty || kind.startsWith(needle)) {
      rows.add(
        ReferenceSuggestion(
          insert: '@$kind',
          label: '@$kind',
          meta: referenceMeta[kind] ?? '',
          kind: kind,
        ),
      );
    }
  }
  return rows;
}

/// `complete.path` word. A bare kind asks for that kind's listing.
String pathCompletionWord(String query) {
  if (kReferenceKinds.contains(query)) return '@$query:';
  return '@$query';
}

Map<String, dynamic> pathCompletionParams({
  required String query,
  String? sessionId,
  String? cwd,
}) {
  return {
    'word': pathCompletionWord(query),
    if (sessionId != null && sessionId.isNotEmpty) 'session_id': sessionId,
    if (cwd != null && cwd.isNotEmpty) 'cwd': cwd,
  };
}

List<ReferenceSuggestion> parseReferenceCompletions(Object? result) {
  if (result is! Map) return const [];
  final items = result['items'];
  if (items is! List) return const [];
  final rows = <ReferenceSuggestion>[];
  for (final item in items) {
    if (item is! Map) continue;
    final text = item['text'];
    if (text is! String || text.trim().isEmpty) continue;
    final display = item['display'];
    final meta = item['meta'];
    final classified = _classify(text.trim());
    rows.add(
      ReferenceSuggestion(
        insert: text.trim(),
        label: display is String && display.isNotEmpty
            ? display
            : classified.label,
        meta: meta is String ? meta : '',
        kind: classified.kind,
      ),
    );
  }
  return rows;
}

ReferenceSuggestion _classify(String text) {
  final match = RegExp(
    r'^@(file|folder|url|image|tool|git):(.*)$',
  ).firstMatch(text);
  if (match != null) {
    final kind = match.group(1)!;
    final rest = match.group(2)!;
    return ReferenceSuggestion(
      insert: text,
      label: rest.isEmpty ? '@$kind:' : _leaf(rest),
      kind: kind,
    );
  }
  return ReferenceSuggestion(insert: text, label: text, kind: 'simple');
}

String _leaf(String value) {
  final trimmed = _unquote(value);
  final parts = trimmed
      .split(RegExp(r'[\\/]'))
      .where((part) => part.isNotEmpty);
  if (parts.isEmpty) return trimmed;
  return parts.last;
}

List<ReferenceChip> referenceChips(String text) {
  final chips = <ReferenceChip>[];
  var index = 0;
  while (index < text.length) {
    final at = text.indexOf('@', index);
    if (at < 0) break;
    final chip = _chipAt(text, at);
    if (chip == null) {
      index = at + 1;
      continue;
    }
    chips.add(chip);
    index = chip.end;
  }
  return chips;
}

ReferenceChip? _chipAt(String text, int at) {
  final rest = text.substring(at + 1);
  for (final simple in kSimpleReferences) {
    if (!rest.startsWith(simple)) continue;
    final end = at + 1 + simple.length;
    if (end < text.length && _isTokenChar(text[end])) continue;
    return ReferenceChip(
      start: at,
      end: end,
      raw: text.substring(at, end),
      kind: simple,
      value: simple,
    );
  }
  for (final kind in kReferenceKinds) {
    final prefix = '$kind:';
    if (!rest.startsWith(prefix)) continue;
    final valueStart = at + 1 + prefix.length;
    final valueEnd = _valueEnd(text, valueStart);
    return ReferenceChip(
      start: at,
      end: valueEnd,
      raw: text.substring(at, valueEnd),
      kind: kind,
      value: _unquote(text.substring(valueStart, valueEnd)),
    );
  }
  return null;
}

bool _isTokenChar(String character) {
  final code = character.codeUnitAt(0);
  return (code >= 48 && code <= 57) ||
      (code >= 65 && code <= 90) ||
      (code >= 97 && code <= 122) ||
      character == '_';
}

int _valueEnd(String text, int start) {
  if (start >= text.length) return start;
  final quote = text[start];
  if (quote == '"' || quote == "'" || quote == '`') {
    final close = text.indexOf(quote, start + 1);
    return close < 0 ? text.length : close + 1;
  }
  var index = start;
  while (index < text.length) {
    final character = text[index];
    if (character == ' ' || character == '\n' || character == '\t') break;
    index++;
  }
  return index;
}

String _unquote(String value) {
  if (value.length >= 2) {
    final quote = value[0];
    if ((quote == '"' || quote == "'" || quote == '`') &&
        value.endsWith(quote)) {
      return value.substring(1, value.length - 1);
    }
  }
  return value;
}

String removeChip(String text, ReferenceChip chip) {
  final next = text.replaceRange(chip.start, chip.end, '');
  return next
      .replaceAll(RegExp(r'[ \t]{2,}'), ' ')
      .replaceAll('\n\n\n', '\n\n');
}
