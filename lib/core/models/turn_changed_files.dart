/// Files a settled turn actually edited, derived from tool calls the way the
/// desktop changed-files card does. A running or failed call did not land.
library;

import 'dart:convert';

const turnFileEditTools = {'edit_file', 'patch', 'write_file'};

final class TurnChangedFile {
  const TurnChangedFile({
    required this.path,
    required this.name,
    required this.added,
    required this.removed,
  });

  final String path;
  final String name;
  final int added;
  final int removed;
}

List<TurnChangedFile> changedFilesFromToolParts(
  Iterable<
    ({String name, Object? args, Object? result, bool failed, bool running})
  >
  parts,
) {
  final byPath = <String, TurnChangedFile>{};
  for (final part in parts) {
    if (part.running || part.failed || !turnFileEditTools.contains(part.name)) {
      continue;
    }
    final result = _asMap(part.result);
    final diff = _inlineDiff(result);
    if (diff == null) continue;
    final path = _editPath(_asMap(part.args), result);
    if (path == null) continue;
    final stats = _diffStats(diff);
    final existing = byPath[path];
    if (existing == null) {
      byPath[path] = TurnChangedFile(
        path: path,
        name: _basename(path),
        added: stats.$1,
        removed: stats.$2,
      );
    } else {
      byPath[path] = TurnChangedFile(
        path: path,
        name: existing.name,
        added: existing.added + stats.$1,
        removed: existing.removed + stats.$2,
      );
    }
  }
  return List.unmodifiable(byPath.values);
}

/// The latest user turn in a stored transcript, using assistant `tool_calls`
/// and the following tool-result rows.
List<TurnChangedFile> changedFilesInLatestTurn(
  List<Map<String, dynamic>> messages,
) {
  var start = -1;
  for (var i = messages.length - 1; i >= 0; i--) {
    if (messages[i]['role'] == 'user') {
      start = i;
      break;
    }
  }
  if (start < 0) return const [];
  final results = <String, String>{};
  for (final message in messages.skip(start + 1)) {
    if (message['role'] != 'tool') continue;
    final id = message['tool_call_id'] ?? message['toolCallId'];
    final content = message['content'];
    if (id is String && content is String) results[id] = content;
  }
  final parts =
      <
        ({String name, Object? args, Object? result, bool failed, bool running})
      >[];
  for (final message in messages.skip(start + 1)) {
    if (message['role'] != 'assistant') continue;
    final calls = message['tool_calls'];
    if (calls is! List) {
      continue;
    }
    for (final call in calls) {
      if (call is! Map) continue;
      final function = call['function'];
      final name = function is Map
          ? function['name']?.toString()
          : call['name']?.toString();
      final args = function is Map ? function['arguments'] : call['arguments'];
      final id = call['id']?.toString();
      final output = id == null ? null : results[id];
      final parsed = output == null ? null : _decode(output);
      final failed =
          parsed is Map &&
          (parsed['success'] == false || parsed['error'] != null);
      if (name == null) continue;
      parts.add((
        name: name,
        args: args,
        result: parsed ?? output,
        failed: failed,
        running: false,
      ));
    }
  }
  return changedFilesFromToolParts(parts);
}

Object? _decode(String text) {
  final trimmed = text.trim();
  if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) return text;
  try {
    return jsonDecode(trimmed);
  } catch (_) {
    return text;
  }
}

Map<String, Object?> _asMap(Object? value) {
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  if (value is String) {
    final parsed = _decode(value);
    if (parsed is Map) {
      return parsed.map((key, item) => MapEntry(key.toString(), item));
    }
  }
  return const {};
}

String? _inlineDiff(Map<String, Object?> result) {
  for (final key in ['inline_diff', 'diff']) {
    final value = result[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
  }
  return null;
}

String? _editPath(Map<String, Object?> args, Map<String, Object?> result) {
  for (final source in [args, result]) {
    for (final key in ['path', 'file', 'filepath', 'resolved_path']) {
      final value = source[key];
      if (value is String &&
          value.trim().isNotEmpty &&
          !value.contains('\u0000')) {
        return value.trim();
      }
    }
  }
  return null;
}

(int, int) _diffStats(String diff) {
  var added = 0;
  var removed = 0;
  for (final line in diff.split('\n')) {
    if (line.startsWith('+') && !line.startsWith('+++')) {
      added += 1;
    } else if (line.startsWith('-') && !line.startsWith('---')) {
      removed += 1;
    }
  }
  return (added, removed);
}

String _basename(String path) {
  final normalized = path.replaceAll(r'\', '/').trim();
  final parts = normalized.split('/').where((part) => part.isNotEmpty);
  return parts.isEmpty ? normalized : parts.last;
}
