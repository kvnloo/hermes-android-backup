// GPT-Live contract helpers and data-channel event mapping, no vendor calls.
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/gpt_live_conversation.dart';

class _FakeTransport implements GptLiveTransport {
  Object? statusBody;
  Object? sessionBody;
  @override
  Future<Object?> status() async => statusBody;
  @override
  Future<Object?> createSession({
    required String sdp,
    List<Map<String, dynamic>>? history,
  }) async {
    lastSdp = sdp;
    lastHistory = history;
    return sessionBody;
  }

  @override
  void dispose() {}

  String? lastSdp;
  List<Map<String, dynamic>>? lastHistory;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('status maps mode, availability and reason; no key is returned', () {
    expect(parseGptLiveStatus(null), isNull);
    final chained = parseGptLiveStatus({
      'ok': true,
      'mode': 'chained',
      'available': false,
      'reason': 'no key',
      'model': 'gpt-live-1',
      'voice': 'marin',
    })!;
    expect(chained.isLive, isFalse);
    expect(chained.reason, 'no key');
    expect(chained.toString(), isNot(contains('key')));
    final live = parseGptLiveStatus({
      'ok': true,
      'mode': 'gpt-live',
      'available': true,
    })!;
    expect(live.isLive, isTrue);
    expect(live.model, 'gpt-live-1');
    expect(live.voice, 'marin');
  });

  test('session creation accepts the SDP answer and session id', () {
    expect(parseGptLiveSession({'ok': true}), isNull);
    final session = parseGptLiveSession({
      'ok': true,
      'session': {'id': 's-1'},
      'transport': {'type': 'webrtc', 'sdp': 'v=0\r\n'},
    })!;
    expect(session.id, 's-1');
    expect(session.sdp, 'v=0\r\n');
  });

  test('delegation prompt uses the last user words plus spoken context', () {
    final prompt = delegationPrompt([
      const LiveFragment(speaker: 'user', text: 'What is '),
      const LiveFragment(speaker: 'user', text: 'the time?'),
      const LiveFragment(speaker: 'assistant', text: 'Checking.'),
      const LiveFragment(speaker: 'user', text: 'Actually, in UTC.'),
    ]);
    expect(prompt['prompt'], 'Actually, in UTC.');
    expect(prompt['context'], contains('User: What is the time?'));
    expect(prompt['context'], contains('Voice assistant: Checking.'));
  });

  test('commentary splits on sentences and honours the vendor cap', () {
    expect(chunkForCommentary('   '), isEmpty);
    expect(chunkForCommentary('Hello.'), ['Hello.']);
    final long = List.generate(10, (_) => 'A sentence.').join(' ');
    final chunks = chunkForCommentary(long, limit: 30);
    expect(chunks.length, greaterThan(1));
    for (final chunk in chunks) {
      expect(chunk.length, lessThanOrEqualTo(30));
    }
  });

  test('live history keeps the newest text turns within budget', () {
    final history = toLiveHistory([
      (role: 'user', text: 'old'),
      (role: 'assistant', text: 'new reply'),
    ]);
    expect(history.length, 2);
    expect(history.last['role'], 'assistant');
    expect(history.last['content'][0]['type'], 'output_text');
  });

  test(
    'data-channel events drive delegation, transcript and close callbacks',
    () async {
      final transport = _FakeTransport();
      LiveFragment? transcript;
      Map<String, String>? delegated;
      String? delegationId;
      String? closedReason;
      final conversation = GptLiveConversation(
        transport: transport,
        onTranscript: (fragment) => transcript = fragment,
        onDelegation: (id, prompt) {
          delegationId = id;
          delegated = prompt;
        },
        onClosed: (reason, usage) => closedReason = reason,
      );
      addTearDown(conversation.dispose);

      conversation.handleEvent(
        // Vendor timing is milliseconds from the start of the session.
        '{"type":"session.input_transcript.delta","delta":"hello","start_ms":1200,"end_ms":1900}',
      );
      expect(transcript?.speaker, 'user');
      expect(transcript?.startMs, 1200);
      expect(transcript?.endMs, 1900);
      expect(conversation.transcript.single.text, 'hello');

      conversation.handleEvent(
        '{"type":"session.delegation.created","delegation":{"id":"d-1"}}',
      );
      expect(delegationId, 'd-1');
      expect(delegated?['prompt'], 'hello');

      conversation.handleEvent(
        '{"type":"error","error":{"code":"context_injection_incomplete"}}',
      );
      conversation.handleEvent(
        '{"type":"session.closed","reason":"closed","usage":{"seconds":7}}',
      );
      await Future<void>.delayed(Duration.zero);
      expect(closedReason, 'closed');
      expect(conversation.active, isFalse);
      expect(transport.lastSdp, isNull); // no network call in event tests
    },
  );
}
