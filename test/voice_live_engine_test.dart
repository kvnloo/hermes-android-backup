import 'package:flutter_test/flutter_test.dart';

import 'package:hermes_android/core/services/gpt_live_conversation.dart';
import 'package:hermes_android/core/services/voice_live_engine.dart';

class _FakeConversation implements LiveConversation {
  bool _active = false;
  String? _delegationId;
  String? _sessionId;
  String? lastSpeakText;
  String? lastThinkText;
  String? lastInstructText;
  bool lastMuted = false;
  bool closed = false;
  bool forcedClose = false;
  int startCalls = 0;
  List<String> sentInstructions = [];

  @override
  bool get active => _active;
  @override
  String? get sessionId => _sessionId;
  @override
  String? get delegationId => _delegationId;

  @override
  Future<bool> start({List<Map<String, dynamic>>? history}) async {
    startCalls++;
    _active = true;
    return true;
  }

  @override
  void speak(String text, {String? delegationId}) {
    lastSpeakText = text;
  }

  @override
  void think(String text, {String? delegationId}) {
    lastThinkText = text;
  }

  @override
  void instruct(String text) {
    sentInstructions.add(text);
  }

  @override
  void setMuted(bool muted) {
    lastMuted = muted;
  }

  @override
  Future<void> close() async {
    closed = true;
    _active = false;
  }

  @override
  Future<void> forceClose(String reason, [int? usageSeconds]) async {
    forcedClose = true;
    _active = false;
  }

  @override
  void dispose() {
    _active = false;
  }

  @override
  void Function(String id, Map<String, String> prompt)? onDelegation;
  @override
  void Function(LiveFragment fragment)? onTranscript;
  @override
  void Function(String message, bool fatal)? onError;
  @override
  void Function(String reason, int? usageSeconds)? onClosed;

  /// Test helper: simulate a vendor delegation.
  void fireDelegation(String id, String prompt) {
    _delegationId = id;
    onDelegation?.call(id, {'prompt': prompt, 'context': 'User: $prompt'});
  }

  /// Test helper: simulate a vendor close.
  void fireClosed(String reason) {
    onClosed?.call(reason, null);
  }
}

class _FakeTransport implements GptLiveTransport {
  _FakeTransport({this.seededStatus});

  final GptLiveStatus? seededStatus;

  @override
  Future<Object?> status() async => {
    'ok': true,
    'mode': seededStatus?.isLive == true ? 'gpt-live' : 'chained',
    'available': seededStatus?.available ?? false,
    'reason': seededStatus?.reason,
  };

  @override
  Future<Object?> createSession({
    required String sdp,
    List<Map<String, dynamic>>? history,
  }) async => {
    'ok': true,
    'session': {'id': 'test-session', 'sdp': 'answer'},
    'transport': {'sdp': 'answer'},
  };

  @override
  void dispose() {}
}

void main() {
  test(
    'status comes from the gateway and reasons through the engine',
    () async {
      final transport = _FakeTransport(
        seededStatus: const GptLiveStatus(
          mode: 'gpt-live',
          available: true,
          reason: null,
          model: 'gpt-live-1',
          voice: 'marin',
        ),
      );
      final engine = VoiceLiveEngine(
        transport: transport,
        session: _FakeConversation(),
      );
      addTearDown(engine.dispose);

      final status = await engine.refresh();
      expect(status, isNotNull);
      expect(engine.startable, isTrue);
      expect(engine.isLive, isTrue);
    },
  );

  test(
    'start refuses when the host is chained or unavailable and never starts the conversation',
    () async {
      final transport = _FakeTransport(
        seededStatus: const GptLiveStatus(
          mode: 'chained',
          available: false,
          reason: 'Live is not configured for this profile.',
          model: 'chained',
          voice: 'default',
        ),
      );
      final conversation = _FakeConversation();
      final engine = VoiceLiveEngine(
        transport: transport,
        session: conversation,
      );
      addTearDown(engine.dispose);

      String? errorMessage;
      engine.onError = (message) => errorMessage = message;

      expect(await engine.start(), isFalse);
      expect(conversation.startCalls, 0);
      expect(engine.state, VoiceLiveState.idle);
      expect(errorMessage, isNotNull);
      expect(engine.reason, contains('not configured'));
    },
  );

  test('start runs the live conversation and reports listening', () async {
    final transport = _FakeTransport(
      seededStatus: const GptLiveStatus(
        mode: 'gpt-live',
        available: true,
        reason: null,
        model: 'gpt-live-1',
        voice: 'marin',
      ),
    );
    final conversation = _FakeConversation();
    final engine = VoiceLiveEngine(transport: transport, session: conversation);
    addTearDown(engine.dispose);

    expect(await engine.start(), isTrue);
    expect(conversation.startCalls, 1);
    expect(engine.state, VoiceLiveState.listening);
    expect(engine.active, isTrue);
  });

  test(
    'delegation routes prompt to the composer exactly once and drops late events',
    () async {
      final transport = _FakeTransport(
        seededStatus: const GptLiveStatus(
          mode: 'gpt-live',
          available: true,
          reason: null,
          model: 'gpt-live-1',
          voice: 'marin',
        ),
      );
      final conversation = _FakeConversation();
      final engine = VoiceLiveEngine(
        transport: transport,
        session: conversation,
      );
      addTearDown(engine.dispose);

      expect(await engine.start(), isTrue);

      final delivered = <Map<String, String>>[];
      engine.onDelegation = (id, prompt) =>
          delivered.add({'prompt': prompt['prompt']!});

      conversation.fireDelegation('d-1', 'What is on the agenda?');
      expect(delivered.single['prompt'], 'What is on the agenda?');
      expect(engine.state, VoiceLiveState.thinking);

      await engine.stop();
      expect(conversation.closed, isTrue);
      expect(engine.state, VoiceLiveState.idle);
      expect(engine.active, isFalse);

      // A late vendor event after teardown must not land in the composer.
      conversation.fireDelegation('d-2', 'late');
      expect(delivered.length, 1);
    },
  );

  test('speaking runs the reply feed and the engine tracks state', () async {
    final transport = _FakeTransport(
      seededStatus: const GptLiveStatus(
        mode: 'gpt-live',
        available: true,
        reason: null,
        model: 'gpt-live-1',
        voice: 'marin',
      ),
    );
    final conversation = _FakeConversation();
    final engine = VoiceLiveEngine(transport: transport, session: conversation);
    addTearDown(engine.dispose);

    expect(await engine.start(), isTrue);
    engine.onDelegation = (id, prompt) {};

    conversation.fireDelegation('d-1', 'what do you think');
    engine.speak(
      'Here are the three things to do this week. Start with the groceries tomorrow.',
    );
    expect(conversation.lastSpeakText, isNotNull);
    expect(engine.state, VoiceLiveState.speaking);
    // A second call with the same text sends nothing new.
    final first = conversation.lastSpeakText;
    engine.speak(
      'Here are the three things to do this week. Start with the groceries tomorrow.',
    );
    expect(conversation.lastSpeakText, first);

    // Settling flushes the remainder.
    engine.settle();
    expect(conversation.lastSpeakText, isNotNull);

    // identical tool label is suppressed by the engine's own dedupe
    engine.think('Reading files');
    engine.think('Reading files');
    expect(conversation.lastThinkText, 'Reading files');

    // a fresh label reaches the model
    engine.think('Writing file');
    expect(conversation.lastThinkText, 'Writing file');

    engine.settle();
    expect(engine.state, VoiceLiveState.listening);
    expect(engine.delegationId, isNull);
  });

  test('mute round-trips through the engine', () async {
    final transport = _FakeTransport(
      seededStatus: const GptLiveStatus(
        mode: 'gpt-live',
        available: true,
        reason: null,
        model: 'gpt-live-1',
        voice: 'marin',
      ),
    );
    final conversation = _FakeConversation();
    final engine = VoiceLiveEngine(transport: transport, session: conversation);
    addTearDown(engine.dispose);

    expect(await engine.start(), isTrue);

    engine.setMuted(true);
    expect(conversation.lastMuted, isTrue);
    expect(engine.muted, isTrue);

    engine.setMuted(false);
    expect(conversation.lastMuted, isFalse);
  });

  test('instruct forwards the text', () async {
    final transport = _FakeTransport(
      seededStatus: const GptLiveStatus(
        mode: 'gpt-live',
        available: true,
        reason: null,
        model: 'gpt-live-1',
        voice: 'marin',
      ),
    );
    final conversation = _FakeConversation();
    final engine = VoiceLiveEngine(transport: transport, session: conversation);
    addTearDown(engine.dispose);

    expect(await engine.start(), isTrue);
    engine.instruct('Finish and respond now.');
    expect(conversation.sentInstructions, ['Finish and respond now.']);
    engine.instruct(
      'Finish and respond now.',
    ); // no-op after active session ends
    expect(conversation.sentInstructions.length, 2);
  });

  test('error callback refuses to fire after teardown', () async {
    final transport = _FakeTransport(
      seededStatus: const GptLiveStatus(
        mode: 'gpt-live',
        available: true,
        reason: null,
        model: 'gpt-live-1',
        voice: 'marin',
      ),
    );
    final conversation = _FakeConversation();
    final engine = VoiceLiveEngine(transport: transport, session: conversation);
    addTearDown(engine.dispose);

    expect(await engine.start(), isTrue);
    final messages = <String>[];
    engine.onError = (message) => messages.add(message);

    await engine.stop();
    conversation.onError?.call('late vendor error', false);
    expect(messages, isEmpty);
  });
}
