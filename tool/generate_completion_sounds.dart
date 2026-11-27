// Writes the bundled completion sounds from their source in code.
//
//   dart run tool/generate_completion_sounds.dart          # write the files
//   dart run tool/generate_completion_sounds.dart --check  # exit 1 on drift
//
// The tones are original: lib/core/services/completion_tones.dart synthesises
// them with plain arithmetic, so this reproduces the committed WAVs byte for
// byte on any platform. test/completion_tones_test.dart checks the same.
import 'dart:io';

import 'package:hermes_android/core/services/completion_tones.dart';

/// Every bundled copy, relative to the repository root.
const bundledCompletionSounds = <String, CompletionTone>{
  'android/app/src/main/res/raw/ares_mail.wav': CompletionTone.mail,
  'android/app/src/main/res/raw/ares_reminder.wav': CompletionTone.reminder,
  'ios/Runner/ares_mail.wav': CompletionTone.mail,
  'ios/Runner/ares_reminder.wav': CompletionTone.reminder,
  'macos/Runner/ares_mail.wav': CompletionTone.mail,
  'macos/Runner/ares_reminder.wav': CompletionTone.reminder,
};

void main(List<String> args) {
  final check = args.contains('--check');
  var drift = false;
  for (final MapEntry(key: path, value: tone)
      in bundledCompletionSounds.entries) {
    final bytes = completionToneWav(tone);
    final file = File(path);
    final same = file.existsSync() && _equal(file.readAsBytesSync(), bytes);
    if (check) {
      if (!same) {
        stderr.writeln('$path differs from its generated tone');
        drift = true;
      }
    } else if (!same) {
      file.writeAsBytesSync(bytes);
      stdout.writeln('wrote $path (${bytes.length} bytes)');
    }
  }
  if (drift) exitCode = 1;
}

bool _equal(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
