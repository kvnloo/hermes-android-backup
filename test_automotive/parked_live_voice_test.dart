import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/parked_automotive.dart';
import 'package:hermes_android/core/services/gpt_live_conversation.dart';
import 'package:hermes_android/core/services/voice_live_engine.dart';

class _NoVoiceTransport implements GptLiveTransport {
  int calls = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls++;
    throw StateError('Parked builds must never start live voice');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'parked live voice cannot read status or acquire a microphone',
    () async {
      expect(isParkedAutomotive, isTrue);
      final transport = _NoVoiceTransport();
      final engine = VoiceLiveEngine(transport: transport);
      addTearDown(engine.dispose);
      expect(await engine.start(), isFalse);
      expect(transport.calls, 0);
      expect(engine.engaged, isFalse);
      expect(engine.holdsMicrophone, isFalse);
    },
  );
}
