// GPT-Live wire parity with Hermes Desktop b7ee21c14e (lib/voice-live.ts and
// use-voice-live-conversation.ts): how a delegation becomes a Hermes turn and
// what the client sends on `oai-events` and to POST /voice-live/session.
// The real GptLiveConversation runs over a fake peer; nothing leaves the test.
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/gpt_live_conversation.dart';
import 'package:hermes_android/core/services/voice_live_engine.dart';

import 'support/fake_live_webrtc.dart';

Map<String, dynamic> _delegation(String id) => {
  'type': 'session.delegation.created',
  'event_id': 'event_$id',
  'delegation': {'id': id, 'type': 'delegation', 'target': 'client'},
};

void main() {
  group('delegation timing: vendor start_ms/end_ms are session-relative', () {
    test("Desktop's 0-3200 ms fixture delegates the user's last words "
        '(review probe G3)', () async {
      final live = await startFakeLive();
      addTearDown(live.conversation.dispose);
      String? delegationId;
      Map<String, String>? delegated;
      live.conversation.onDelegation = (id, prompt) {
        delegationId = id;
        delegated = prompt;
      };

      final channel = live.peer.channel;
      channel.receive(liveTranscriptDelta('assistant', 'Hi, how ', 0, 1000));
      channel.receive(
        liveTranscriptDelta('assistant', 'can I help?', 1000, 1500),
      );
      channel.receive(liveTranscriptDelta('user', 'What is ', 1500, 2500));
      channel.receive(
        liveTranscriptDelta('user', 'the weather in Paris?', 2500, 3200),
      );
      channel.receive(_delegation('dlg_1'));

      expect(delegationId, 'dlg_1');
      expect(delegated?['prompt'], 'What is the weather in Paris?');
      expect(
        delegated?['context'],
        'Voice assistant: Hi, how can I help?\n'
        'User: What is the weather in Paris?',
      );
    });

    test('the context window reaches five minutes back from the LAST '
        "fragment's end, not from the wall clock", () async {
      final live = await startFakeLive();
      addTearDown(live.conversation.dispose);
      Map<String, String>? delegated;
      live.conversation.onDelegation = (_, prompt) => delegated = prompt;

      final channel = live.peer.channel;
      // Ten minutes into the session: the first exchange is out of the window.
      channel.receive(liveTranscriptDelta('user', 'Book a table.', 0, 1200));
      channel.receive(liveTranscriptDelta('assistant', 'Done.', 1200, 2000));
      // Exactly at the floor (600000 - 300000): kept, as Desktop's `>=`.
      channel.receive(
        liveTranscriptDelta('assistant', 'Anything else?', 299000, 300000),
      );
      channel.receive(
        liveTranscriptDelta('user', 'Yes, check my mail.', 598000, 600000),
      );
      channel.receive(_delegation('dlg_2'));

      expect(delegated?['prompt'], 'Yes, check my mail.');
      expect(
        delegated?['context'],
        'Voice assistant: Anything else?\nUser: Yes, check my mail.',
      );
    });

    test('at most the last 80 fragments ride along (Desktop '
        'CONTEXT_MAX_FRAGMENTS)', () async {
      final live = await startFakeLive();
      addTearDown(live.conversation.dispose);
      Map<String, String>? delegated;
      live.conversation.onDelegation = (_, prompt) => delegated = prompt;

      final channel = live.peer.channel;
      for (var i = 0; i < 100; i++) {
        channel.receive(
          liveTranscriptDelta('user', 'w$i ', i * 100, i * 100 + 100),
        );
      }
      channel.receive(_delegation('dlg_3'));

      final words = delegated!['prompt']!.split(' ');
      expect(words, hasLength(80));
      expect(words.first, 'w20');
      expect(words.last, 'w99');
    });

    test('with no user words the prompt is the LAST 400 characters of the '
        'context (Desktop transcript.slice(-400))', () {
      final spoken = List.generate(60, (i) => 'Sentence number $i.').join(' ');
      final prompt = delegationPrompt([
        LiveFragment(
          speaker: 'assistant',
          text: spoken,
          startMs: 0,
          endMs: 9000,
        ),
      ]);
      final context = 'Voice assistant: $spoken';
      expect(prompt['context'], context);
      expect(prompt['prompt'], context.substring(context.length - 400));
      expect(prompt['prompt'], endsWith('Sentence number 59.'));
    });
  });

  group('interrupt / respond now', () {
    const nudge =
        'The user has finished speaking. Respond now to what they said.';

    test("instruct sends Desktop's session.instructions.append with "
        'content and a null delegation_id (review probe G4)', () async {
      final live = await startFakeLive();
      addTearDown(live.conversation.dispose);

      live.conversation.instruct(nudge);

      final sent = live.peer.channel.sent.last;
      expect(sent['type'], 'session.instructions.append');
      expect(sent['content'], nudge);
      expect(sent.containsKey('delegation_id'), isTrue);
      expect(sent['delegation_id'], isNull);
      expect(sent['event_id'], isA<String>());
      expect(sent['event_id'], isNotEmpty);
      expect(sent.keys.toSet(), {
        'type',
        'content',
        'delegation_id',
        'event_id',
      });
    });

    test('the composer control (VoiceLiveEngine.stopTurn) reaches the vendor '
        'in that shape, never as session.instruct', () async {
      final live = newFakeLive();
      final engine = VoiceLiveEngine(
        transport: live.transport,
        session: live.conversation,
      );
      addTearDown(engine.dispose);
      expect(await engine.start(), isTrue);

      engine.stopTurn();

      final channel = live.peer.channel;
      expect(channel.sentOfType('session.instruct'), isEmpty);
      final sent = channel.sentOfType('session.instructions.append').single;
      expect(sent['content'], nudge);
      expect(sent['delegation_id'], isNull);
    });

    test('an instruction is cut to the vendor append limit and every one '
        'carries its own event id', () async {
      final live = await startFakeLive();
      addTearDown(live.conversation.dispose);

      live.conversation.instruct('x' * 2000);
      live.conversation.instruct('  second  ');

      final sent = live.peer.channel.sentOfType('session.instructions.append');
      expect(sent, hasLength(2));
      expect(sent.first['content'], 'x' * 1400);
      expect(sent.last['content'], 'second');
      expect(sent.first['event_id'], isNot(sent.last['event_id']));
    });
  });

  group('seed history', () {
    test('items are {type: message, role, content} (review probe G2)', () {
      final history = toLiveHistory([
        (role: 'user', text: 'hello'),
        (role: 'assistant', text: 'hi'),
      ]);
      expect(history, [
        {
          'type': 'message',
          'role': 'user',
          'content': [
            {'type': 'input_text', 'text': 'hello'},
          ],
        },
        {
          'type': 'message',
          'role': 'assistant',
          'content': [
            {'type': 'output_text', 'text': 'hi'},
          ],
        },
      ]);
    });

    test("each turn is cut to Desktop's 1200 characters, and the budget "
        'counts the cut text', () {
      final long = 'a' * 3000;
      final one = toLiveHistory([
        (role: 'user', text: long),
        (role: 'assistant', text: 'short'),
      ]);
      expect(one, hasLength(2));
      expect((one.first['content'] as List).single['text'], 'a' * 1200);

      // 6000-character budget: five cut turns fit exactly, the sixth (the
      // oldest) does not.
      final six = toLiveHistory([
        for (var i = 0; i < 6; i++) (role: 'user', text: '$i$long'),
      ]);
      expect(six, hasLength(5));
      expect((six.first['content'] as List).single['text'], startsWith('1a'));
      expect((six.last['content'] as List).single['text'], startsWith('5a'));
    });

    test(
      'the seeded history reaches POST /voice-live/session as built',
      () async {
        final history = toLiveHistory([
          (role: 'user', text: 'What is on today?'),
          (role: 'assistant', text: 'Two meetings.'),
        ]);
        final live = await startFakeLive(history: history);
        addTearDown(live.conversation.dispose);

        expect(live.transport.history, history);
        expect(
          live.transport.history!.every((item) => item['type'] == 'message'),
          isTrue,
        );
      },
    );
  });
}
