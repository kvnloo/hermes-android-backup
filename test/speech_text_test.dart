import 'package:flutter_test/flutter_test.dart';

import 'package:hermes_android/core/utils/speech_text.dart';
import 'package:hermes_android/core/utils/voice_stop_word.dart';

void main() {
  test(
    'sanitizer strips markdown chrome, code, links and thinking prefixes',
    () {
      const input = '''
processing... kicking things off.
```dart
void main() {}
```
[Docs](https://example.com/docs) — see `parseCmd` and `lib/services/voice.dart`.
''';
      final out = sanitizeTextForSpeech(input);
      expect(out, isNot(contains('```')));
      expect(out, isNot(contains('https://')));
      expect(out, isNot(contains('processing...')));
      expect(out, contains('Docs'));
      // dense model IDs and paths are silence
      expect(out, isNot(contains('lib/services/voice.dart')));
    },
  );

  test('sanitizer flattens line breaks and punctuation-noise', () {
    final out = sanitizeTextForSpeech(
      'First line\n\nSecond line.\nThird line.',
    );
    expect(out, contains('First line'));
    expect(out, contains('Second line'));
    expect(out, contains('Third line'));
  });

  test('sanitizer speaks markdown tables as their header and drops cells', () {
    const input = '''
| Model | Price | Context |
| ----- | ----: | ------: |
| Alice | 1.2   | 4k      |
| Bob   | 2.4   | 8k      |
''';
    final out = sanitizeTextForSpeech(input);
    expect(out, contains('Model'));
    expect(out, contains('Price'));
    expect(out, isNot(contains('Alice')));
  });

  test('cutSentences emits complete sentences and holds the tail', () {
    /// First sentence is long enough (>= 24 chars), the tail is not.
    final cut = cutSentences(
      'This is a long enough sentence to be read aloud to the user. And this is a short tail.',
      false,
    );
    expect(cut.sentences.length, 1);
    expect(cut.sentences.first, contains('This is a long enough sentence'));
    expect(cut.rest, contains('And this is a short tail'));
  });

  test('cutSentences flushes the tail when flush is true', () {
    final cut = cutSentences('Short.', true);
    expect(cut.sentences.length, 1);
    expect(cut.rest, isEmpty);
  });

  test('stop-word matcher accepts whole-utterance stop commands', () {
    expect(isStopWordTurn('stop'), isTrue);
    expect(isStopWordTurn('stop please.'), isTrue);
    expect(isStopWordTurn('Please stop it.'), isTrue);
    expect(isStopWordTurn('just quiet down'), isTrue);
    expect(isStopWordTurn('be quiet please'), isTrue);
    expect(isStopWordTurn('shut up.'), isTrue);
    expect(isStopWordTurn('hold it.'), isTrue);
  });

  test('stop-word matcher rejects sentences that merely contain the word', () {
    expect(isStopWordTurn('please stop the file download'), isFalse);
    expect(isStopWordTurn('could you stop the download please'), isFalse);
    expect(isStopWordTurn('please stop the music'), isFalse);
    expect(isStopWordTurn('tell me what to do'), isFalse);
  });

  test('stop-word matcher is case-insensitive and punctuation-tolerant', () {
    expect(isStopWordTurn('STOP.'), isTrue);
    expect(isStopWordTurn('  Please   Stop!!  '), isTrue);
  });
}
