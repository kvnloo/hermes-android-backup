/// Whole-utterance stop-word matcher. Mirrors Hermes Desktop's
/// `lib/voice-stop-word.ts`: only a clean, grammar-light instruction counts
/// as a stop request. "Please stop it." stops the reply; "please stop the
/// file download" does not.
library;

/// Canonical phrases that count as a stop instruction.
const _stopPhrases = <String>{
  'stop',
  'stop it',
  'stop that',
  'stop now',
  'stop me',
  'stop please',
  'shut up',
  'quiet down',
  'keep quiet',
  'be quiet',
  'be silent',
  'enough',
  'done',
  'cancel',
  'quit',
  'halt',
  'pause',
  'end',
  'finish',
  'over',
  'close it',
  'cut it',
  'hold it',
  'quietly stop',
  'stop quietly',
  'be quiet please',
};

/// Leading grammar words allowed before the canonical phrase. Empty string
/// means the phrase stands alone ("stop."). These are all grammar-light and
/// always prependable.
const _leadingGrammar = <String>[
  '',
  'please ',
  'just ',
  'please just ',
  'be ',
  'please be ',
  'just be ',
  'can you ',
  'could you ',
  'would you ',
  'can i ',
  'could i ',
  'would i ',
  'shut ',
  'please shut ',
  'just shut ',
];

/// Trailing fillers allowed after the canonical phrase — whole words only.
/// Deliberately short; anything else falls back to handing the utterance to
/// the model as a request.
const _trailingFillers = <String>[
  'please',
  'thanks',
  'thank you',
  'thank',
  'ok',
  'okay',
  'alright',
  'hey',
  'now',
  'then',
  'there',
  'so',
  'slowly',
  'quietly',
  'gentle',
  'just',
  'quiet',
  'silent',
  'silently',
  'hold on',
  'hold it',
];

/// Normalize an utterance for matching: lowercase, trim, strip trailing
/// punctuation and surrounding quotes, squash whitespace.
String normalizeUtterance(String text) {
  var s = text.toLowerCase().trim();
  s = s.replaceAll(RegExp(r'[.!?,;:]+$'), '').trim();
  s = s.replaceAll(RegExp(r'["“”]'), '');
  s = s.replaceAll(RegExp(r"'"), '');
  s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
  return s;
}

/// True iff [text] is a single stop instruction (optionally with grammar
/// around it), never a sentence that happens to contain the word.
bool isStopWordTurn(String text) {
  final utterance = normalizeUtterance(text);
  if (utterance.isEmpty) return false;

  for (final phrase in _stopPhrases) {
    for (final prefix in _leadingGrammar) {
      final candidate = '$prefix$phrase'.trim();
      if (utterance == candidate) return true;
      for (final filler in _trailingFillers) {
        if (utterance == '$candidate $filler') return true;
        for (final filler2 in _trailingFillers) {
          if (utterance == '$candidate $filler $filler2') return true;
        }
      }
    }
  }
  return false;
}

/// Alias matching Hermes Desktop's `isVoiceStopCommand`.
bool isVoiceStopCommand(String text) => isStopWordTurn(text);
