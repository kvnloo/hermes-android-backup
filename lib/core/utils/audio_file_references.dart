import 'attachment_types.dart';
import 'media_tags.dart';

/// Prompt `@file:` lines are gateway references, never client-local paths.
/// Keep their full paths rather than reconstructing one from a display name.
List<MediaTagRef> audioPromptFileRefs(String text) {
  final refs = <String, MediaTagRef>{};
  for (final line in text.split('\n')) {
    final match = RegExp(r'^\s*@file:(\S.*)$').firstMatch(line);
    if (match == null) continue;
    var path = match.group(1)!.trim();
    if (path.length > 1 && path.startsWith('`') && path.endsWith('`')) {
      path = path.substring(1, path.length - 1);
    }
    final scheme = Uri.tryParse(path)?.scheme ?? '';
    if (scheme.isNotEmpty && !RegExp(r'^[A-Za-z]:[/\\]').hasMatch(path)) {
      continue;
    }
    if (path.contains(RegExp(r'[\x00-\x1f\x7f]'))) continue;
    final ref = MediaTagRef(path: path);
    if (attachmentIsAudio(ref.extension)) refs[path] = ref;
  }
  return refs.values.toList(growable: false);
}
