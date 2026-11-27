/// A short built-in `:shortcode` list. A picked row inserts the character.
/// The OS emoji keyboard still inserts anything else; this is not a claim
/// that the full emojibase index is bundled.
const Map<String, String> kComposerEmoji = {
  'smile': '☺',
  'joy': '😂',
  'thumbsup': '👍',
  'thumbsdown': '👎',
  'heart': '❤',
  'fire': '🔥',
  'rocket': '🚀',
  'bug': '🐛',
  'white_check_mark': '✅',
  'x': '❌',
  'warning': '⚠',
  'eyes': '👀',
  'tada': '🎉',
  'wave': '👋',
  'thinking': '🤔',
  'memo': '📝',
  'bulb': '💡',
  'star': '⭐',
  'lock': '🔒',
  'wrench': '🔧',
};

class EmojiHit {
  const EmojiHit(this.code, this.character);

  final String code;
  final String character;
}

class ActiveToken {
  const ActiveToken(this.start, this.end, this.query);

  final int start;
  final int end;
  final String query;
}

/// The `:query` touching [caret], or null when the token does not start with
/// the trigger (so `12:30` is not an emoji).
ActiveToken? activeTrigger(String text, int caret, String trigger) {
  if (trigger.isEmpty || caret < 0 || caret > text.length) return null;
  var start = caret;
  while (start > 0) {
    final previous = text[start - 1];
    if (previous == ' ' || previous == '\n' || previous == '\t') break;
    start--;
  }
  if (start >= text.length || !text.startsWith(trigger, start)) return null;
  if (caret < start + trigger.length) return null;
  return ActiveToken(
    start,
    caret,
    text.substring(start + trigger.length, caret),
  );
}

List<EmojiHit> emojiMatches(String query) {
  final needle = query.toLowerCase();
  final hits = <EmojiHit>[];
  for (final entry in kComposerEmoji.entries) {
    if (needle.isEmpty || entry.key.startsWith(needle)) {
      hits.add(EmojiHit(entry.key, entry.value));
    }
  }
  return hits;
}

String applyInsert(String text, int start, int end, String insert) {
  final needsSpace = end < text.length && text[end] != ' ' && text[end] != '\n';
  return text.replaceRange(start, end, needsSpace ? '$insert ' : insert);
}
