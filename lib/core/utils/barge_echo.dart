/// Heuristic echo guard for barge-in: a transcript that closely matches the
/// text being read aloud is the engine's own voice bleeding back into the mic,
/// not the user talking. This is intentionally lighter than Hermes Desktop's
/// difflib-based guard — it never blocks a genuine interjection (most words
/// differ), and only suppresses close matches.
///
/// Unlike Desktop, whose guard runs on one finished capture, the monitor here
/// sees every streaming partial, and the first ones are a few characters
/// long: "sure", then "sure here". A partial under [_minFragmentLength] is
/// therefore also compared with the opening of the utterance being spoken
/// (the monitor listens from the moment the read starts), so the reply's own
/// first words never cut it short. Anything else still interrupts.
library;

/// As Desktop's MIN_FRAGMENT_LENGTH_FOR_ECHO: shorter partials are too short
/// for the sliding window, which would match a one-word barge anywhere.
const _minFragmentLength = 10;

String _normalize(String text) =>
    text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

/// Lower-case words only: punctuation is not spoken, so "Sure." heard back
/// is "sure".
String _words(String text) => text
    .toLowerCase()
    .replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

/// Character bigram overlap ratio, in [0, 1].
double _bigramRatio(String a, String b) {
  if (a.isEmpty || b.isEmpty) return 0;
  final aSet = <String>{};
  final bSet = <String>{};
  for (var i = 0; i < a.length - 1; i++) {
    aSet.add(a.substring(i, i + 2));
  }
  for (var i = 0; i < b.length - 1; i++) {
    bSet.add(b.substring(i, i + 2));
  }
  if (aSet.isEmpty && bSet.isEmpty) {
    // Short strings: fall back to exact-character containment.
    return a == b ? 1.0 : 0.0;
  }
  final overlap = aSet.intersection(bSet).length;
  final union = aSet.union(bSet).length;
  return union == 0 ? 0.0 : overlap / union;
}

/// True when the short partial [transcript] is the opening of [spoken]: the
/// same leading words (the last one possibly still being recognised, as
/// "sure he"), or, for a recogniser's near miss, a close bigram match with
/// the opening of the same length. "no" is not the opening of "Now ...".
bool _isOpeningEcho(String transcript, String spoken) {
  final a = _words(transcript);
  final b = _words(spoken);
  if (a.isEmpty || b.isEmpty) return false;
  if (b == a || b.startsWith('$a ')) return true;
  final words = a.split(' ');
  if (words.length > 1) {
    // Whole leading words, then the start of the word being heard.
    final settled = words.sublist(0, words.length - 1).join(' ');
    if (b.startsWith('$settled ') &&
        b.substring(settled.length + 1).startsWith(words.last)) {
      return true;
    }
  }
  if (a.length < 4 || b.length < a.length) return false;
  return _bigramRatio(a, b.substring(0, a.length)) >= 0.5;
}

/// True when [transcript] looks like the engine speaking (echo) rather than a
/// user interjection. A genuine one-word barge ("no", "stop") never matches
/// long reply text; a short partial is only echo when it is the opening of
/// the reply being spoken.
bool isLikelyEcho(String transcript, String spoken) {
  final a = _normalize(transcript);
  final b = _normalize(spoken);
  if (a.isEmpty || b.isEmpty) return false;
  if (_bigramRatio(a, b) >= 0.5) return true;
  if (a.length < _minFragmentLength) return _isOpeningEcho(transcript, spoken);
  // Sliding window over the spoken text: a fragment of a long reply can look
  // like echo without matching the whole reply.
  if (a.length < b.length) {
    for (var start = 0; start <= b.length - a.length; start++) {
      if (_bigramRatio(a, b.substring(start, start + a.length)) >= 0.5) {
        return true;
      }
    }
  }
  return false;
}
