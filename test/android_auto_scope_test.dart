import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Auto milestone does not introduce TV, boot, overlay or new-chat authority',
    () {
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();
      for (final unsupported in [
        'LEANBACK_LAUNCHER',
        'BootReceiver',
        'SYSTEM_ALERT_WINDOW',
        'SCHEDULE_EXACT_ALARM',
        'BIND_ACCESSIBILITY_SERVICE',
        'BIND_VOICE_INTERACTION',
        'HermesForegroundService',
        'HermesCarAppService',
      ]) {
        expect(manifest, isNot(contains(unsupported)), reason: unsupported);
      }
      final main = File('lib/main.dart').readAsStringSync();
      expect(main, isNot(contains('_sendVoiceReplyHeadless')));
      expect(main, isNot(contains("setLanguage('nl-NL')")));
      expect(main, isNot(contains('pendingNextGenVoiceReply')));
      expect(
        File('lib/nextgen/ui/main_page.dart').readAsStringSync(),
        isNot(contains('pendingNextGenVoiceReply')),
      );
    },
  );
}
