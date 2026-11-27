/// Pure validation and sanitization for operator-supplied per-gateway headers.
///
/// The rules mirror the Electron Desktop client (see
/// `desktop/apps/desktop/electron/remote-ws-headers.ts`) so a connection that
/// works against a Desktop gateway works against Ares:
///
///  - names must be RFC 7230 token characters and must not be in the
///    forbidden list (auth, host, content-type, etc. — those are set by the
///    client itself and never passed through);
///  - values are stripped of CR/LF (header injection) and trimmed;
///  - malformed or forbidden entries are dropped, not repaired;
///  - headers are attached only to the REST/WS requests of the gateway they
///    were saved for — never to any other origin.
library;

import '../../l10n/app_localizations.dart';

/// RFC 7230 token characters for a header name.
final remoteHeaderNameRe = RegExp(r"^[!#$%&'*+\-.^_`|~0-9A-Za-z]+$");

/// Names the client sets itself (or that must never reach a gateway) and that
/// must never be passed through from user-supplied header text.
const List<String> forbiddenRemoteHeaderNames = [
  'authorization',
  'connection',
  'content-length',
  'content-type',
  'cookie',
  'host',
  'origin',
  'referer',
  'te',
  'trailer',
  'transfer-encoding',
  'upgrade',
  'x-hermes-session-token',
];

/// Trims a header value and strips any CR/LF (header injection guard). Returns
/// the empty string for a value that had no non-whitespace content.
String sanitizeHeaderValue(String value) {
  final stripped = value.replaceAll(RegExp(r'[\r\n]+'), '').trim();
  return stripped;
}

/// Normalizes a map of custom headers for a single gateway.
///
/// Names with characters outside the RFC 7230 token set are dropped; values
/// are CR/LF-stripped and trimmed; forbidden names are dropped; duplicates
/// collapse with the later entry winning (matching Map semantics — first wins
/// in Desktop; Ares keeps "later wins", which is the simpler rule and a
/// defensible one).
Map<String, String> normalizeRemoteHeaders(Map<String, dynamic> raw) {
  final out = <String, String>{};
  for (final entry in raw.entries) {
    final name = entry.key.trim();
    if (name.isEmpty) continue;
    if (!remoteHeaderNameRe.hasMatch(name)) continue;
    if (forbiddenRemoteHeaderNames.contains(name.toLowerCase())) continue;
    final value = sanitizeHeaderValue('${entry.value ?? ''}');
    if (value.isEmpty) continue;
    out[name] = value;
  }
  return Map<String, String>.unmodifiable(out);
}

/// Parses a user-entered "Name: Value" block (one per line, blank lines and
/// lines starting with `#` ignored) into normalized headers. Returns the
/// normalized map plus a list of per-line human-readable problems for any
/// line that could not be kept. Lines with problems are dropped, never
/// repaired.
class ParsedRemoteHeaders {
  const ParsedRemoteHeaders({
    required this.headers,
    required this.problems,
    this.issues = const [],
  });

  final Map<String, String> headers;

  /// English descriptions (logs, tests). Show [issues] through
  /// [describeHeaderIssue] in the UI instead.
  final List<String> problems;

  /// The same problems, typed, in line order, for localised display.
  final List<HeaderIssue> issues;
}

/// Why a line of the custom headers block was dropped.
enum HeaderIssueKind { format, missingName, invalidName, reserved, emptyValue }

/// One dropped line of the custom headers block.
class HeaderIssue {
  const HeaderIssue(this.kind, this.line, [this.name = '']);

  final HeaderIssueKind kind;

  /// 1-based line number.
  final int line;

  /// The header name, for [HeaderIssueKind.invalidName] and
  /// [HeaderIssueKind.reserved].
  final String name;
}

/// The localised message for [issue].
String describeHeaderIssue(AppLocalizations l10n, HeaderIssue issue) =>
    switch (issue.kind) {
      HeaderIssueKind.format => l10n.custom_headers_problem_format(issue.line),
      HeaderIssueKind.missingName => l10n.custom_headers_problem_missing_name(
        issue.line,
      ),
      HeaderIssueKind.invalidName => l10n.custom_headers_problem_invalid_name(
        issue.line,
        issue.name,
      ),
      HeaderIssueKind.reserved => l10n.custom_headers_problem_reserved(
        issue.line,
        issue.name,
      ),
      HeaderIssueKind.emptyValue => l10n.custom_headers_problem_empty_value(
        issue.line,
      ),
    };

ParsedRemoteHeaders parseRemoteHeadersBlock(String text) {
  final out = <String, String>{};
  final problems = <String>[];
  final issues = <HeaderIssue>[];
  final lines = text.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final raw = lines[i];
    final trimmed = raw.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final colon = raw.indexOf(':');
    if (colon < 0) {
      problems.add('Line ${i + 1}: expected "Name: Value"');
      issues.add(HeaderIssue(HeaderIssueKind.format, i + 1));
      continue;
    }
    final name = raw.substring(0, colon).trim();
    final value = raw.substring(colon + 1).trim();
    if (name.isEmpty) {
      problems.add('Line ${i + 1}: missing header name');
      issues.add(HeaderIssue(HeaderIssueKind.missingName, i + 1));
      continue;
    }
    if (!remoteHeaderNameRe.hasMatch(name)) {
      problems.add('Line ${i + 1}: invalid header name "$name"');
      issues.add(HeaderIssue(HeaderIssueKind.invalidName, i + 1, name));
      continue;
    }
    if (forbiddenRemoteHeaderNames.contains(name.toLowerCase())) {
      problems.add(
        'Line ${i + 1}: "$name" is reserved and cannot be passed through',
      );
      issues.add(HeaderIssue(HeaderIssueKind.reserved, i + 1, name));
      continue;
    }
    final sanitized = sanitizeHeaderValue(value);
    if (sanitized.isEmpty) {
      problems.add('Line ${i + 1}: empty header value');
      issues.add(HeaderIssue(HeaderIssueKind.emptyValue, i + 1));
      continue;
    }
    out[name] = sanitized;
  }
  return ParsedRemoteHeaders(
    headers: normalizeRemoteHeaders(out),
    problems: problems,
    issues: issues,
  );
}

/// Serializes normalized headers back to the "Name: Value" block used in the
/// settings UI. Order follows the map's insertion order.
String headersBlockFromMap(Map<String, String> headers) {
  return headers.entries.map((e) => '${e.key}: ${e.value}').join('\n');
}
