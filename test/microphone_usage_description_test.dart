// Apple's microphone prompt names every use: GPT-Live opens the microphone
// for live voice conversations too (voice review of 46683e29, card B item 10).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final plist in ['ios/Runner/Info.plist', 'macos/Runner/Info.plist']) {
    test('$plist names live voice in NSMicrophoneUsageDescription', () {
      final text = File(plist).readAsStringSync();
      final match = RegExp(
        r'<key>NSMicrophoneUsageDescription</key>\s*<string>([^<]*)</string>',
      ).firstMatch(text);
      expect(match, isNotNull);
      final description = match![1]!;
      expect(description, contains('voice dictation'));
      expect(description, contains('recorded voice messages'));
      expect(description, contains('live voice conversations with your agent'));
    });
  }
}
