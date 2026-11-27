// Barge-in: speaking over an ongoing reply-aloud cuts it short. The echo
// guard suppresses the engine's own voice bleeding back into the mic; the
// monitor is opt-in and never starts a turn.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/controllers/hands_free_conversation_controller.dart'
    show HandsFreeSpeechOutcome;
import 'package:hermes_android/core/services/barge_in_monitor.dart';
import 'package:hermes_android/core/services/barge_in_preference.dart';
import 'package:hermes_android/core/services/hands_free_speech.dart';
import 'package:hermes_android/core/utils/barge_echo.dart';
import 'package:hermes_android/nextgen/data/read_aloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';

class _FakeSpeaker implements VoiceReplySpeaker {
  final spoken = <String>[];
  bool gated = false;
  Completer<HandsFreeSpeechOutcome>? gate;
  int stops = 0;

  @override
  Future<bool> prepare() async => true;

  @override
  Future<HandsFreeSpeechOutcome> speak(
    String text, {
    required bool Function() isCurrent,
  }) {
    spoken.add(text);
    if (!isCurrent()) return Future.value(HandsFreeSpeechOutcome.canceled);
    if (gated) {
      final c = gate = Completer<HandsFreeSpeechOutcome>();
      return c.future;
    }
    return Future.value(HandsFreeSpeechOutcome.completed);
  }

  @override
  Future<void> stop() async {
    stops++;
    final c = gate;
    gate = null;
    if (c != null && !c.isCompleted) {
      c.complete(HandsFreeSpeechOutcome.canceled);
    }
  }
}

/// Faithful to the real monitor's speech handling: a stale isCurrent stops it
/// without interrupting, an echo is ignored, an interjection fires once.
class _FakeBargeIn implements BargeInMonitor {
  String? get echoText => _echoText;
  VoidCallback? _onInterrupt;
  bool Function()? _isCurrent;
  String? _echoText;
  bool started = false;
  int stops = 0;

  @override
  Future<bool> start({
    required VoidCallback onInterrupt,
    String? echoText,
    bool Function()? isCurrent,
  }) async {
    started = true;
    _onInterrupt = onInterrupt;
    _echoText = echoText;
    _isCurrent = isCurrent;
    return true;
  }

  void speak(String transcript) {
    if (!started) return;
    if (_isCurrent != null && !_isCurrent!()) {
      stop();
      return;
    }
    final echo = _echoText;
    if (echo != null && isLikelyEcho(transcript, echo)) return;
    _consumed = true;
    final callback = _onInterrupt;
    _onInterrupt = null;
    _isCurrent = null;
    _echoText = null;
    callback?.call();
  }

  var _consumed = false;

  @override
  Future<void> stop() async {
    stops++;
    started = false;
    _onInterrupt = null;
    _isCurrent = null;
    _echoText = null;
  }

  bool get consumed => _consumed;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<_FakeBargeIn> monitors;

  BargeInMonitor Function() factory() => () {
    final m = _FakeBargeIn();
    monitors.add(m);
    return m;
  };

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    monitors = [];
    bargeInEnabled.value = false;
  });

  tearDown(() {
    bargeInEnabled.value = false;
  });

  group('echo guard: short partials of the reply being spoken (probe B1)', () {
    const spoken =
        'Sure. Here is the weather for Paris today: sunny with a high of '
        'twenty two degrees and light winds from the west.';

    test("the app's own first words are echo, from the first partial", () {
      for (final partial in [
        'sure',
        'Sure.',
        'sure here',
        'sure here is',
        'sure here is the weather',
        'here is the weather for paris today',
      ]) {
        expect(isLikelyEcho(partial, spoken), isTrue, reason: partial);
      }
    });

    test('a short interjection that is not the opening still interrupts', () {
      for (final partial in ['stop', 'wait', 'no', 'hold on', 'cancel']) {
        expect(isLikelyEcho(partial, spoken), isFalse, reason: partial);
      }
      // A word the reply only starts with is not its opening word.
      expect(isLikelyEcho('no', 'Now I will check the calendar.'), isFalse);
      // Words from later in the reply are not its opening.
      expect(isLikelyEcho('paris', spoken), isFalse);
    });

    test('the read keeps going over its own opening words, and stops for '
        'the user', () async {
      final adapter = FakeVoiceComposerAdapter();
      final monitor = SpeechToTextBargeInMonitor(adapter: adapter);
      var interrupts = 0;
      expect(
        await monitor.start(
          onInterrupt: () => interrupts++,
          echoText: spoken,
          isCurrent: () => true,
        ),
        isTrue,
      );
      await pumpEventQueue();
      adapter.emitPartial('sure');
      adapter.emitPartial('sure here');
      adapter.emitPartial('sure here is the weather');
      expect(interrupts, 0);
      adapter.emitPartial('stop');
      expect(interrupts, 1);
      await monitor.stop();
    });
  });

  group('echo guard', () {
    test('close transcript match is echo', () {
      expect(
        isLikelyEcho(
          'The quick brown fox jumps over the lazy dog',
          'The quick brown fox jumps over the lazy dog',
        ),
        isTrue,
      );
    });

    test('a fragment of a long reply is echo', () {
      expect(
        isLikelyEcho(
          'quick brown fox jumps',
          'In a story about the quick brown fox jumps over the lazy dog we find the quick brown fox jumps again',
        ),
        isTrue,
      );
    });

    test('a genuine interjection is not echo', () {
      expect(
        isLikelyEcho('stop', 'The quick brown fox jumps over the lazy dog'),
        isFalse,
      );
      expect(
        isLikelyEcho(
          'wait, one moment',
          'The quick brown fox jumps over the lazy dog',
        ),
        isFalse,
      );
    });

    test('empty transcript or spoken text is not echo', () {
      expect(isLikelyEcho('', 'hello'), isFalse);
      expect(isLikelyEcho('hello', ''), isFalse);
    });
  });

  group('barge-in during read aloud', () {
    test('the monitor is not started when barge-in is off', () async {
      final fake = _FakeSpeaker()..gated = true;
      final controller = NgReadAloud(speaker: fake, bargeInMonitor: factory());
      addTearDown(controller.dispose);

      final reading = controller.read('a', 'hello world');
      await pumpEventQueue();
      expect(controller.readingKey, 'a');
      expect(monitors, isEmpty);
      await controller.stop();
      await reading;
    });

    test('a spoken utterance cuts the reply without a failure toast', () async {
      bargeInEnabled.value = true;
      final fake = _FakeSpeaker()..gated = true;
      final controller = NgReadAloud(speaker: fake, bargeInMonitor: factory());
      addTearDown(controller.dispose);
      var unavailable = 0;
      controller.onUnavailable = () => unavailable++;

      final reading = controller.read('a', 'hello world');
      await pumpEventQueue();
      expect(monitors, hasLength(1));
      expect(monitors.first.started, isTrue);
      expect(monitors.first.echoText, 'hello world');

      monitors.first.speak('stop');
      await reading;
      expect(controller.readingKey, isNull);
      expect(unavailable, 0);
      expect(fake.stops, greaterThanOrEqualTo(1));
      expect(monitors.first.consumed, isTrue);
    });

    test('a transcript matching the spoken text is not an interrupt', () async {
      bargeInEnabled.value = true;
      final fake = _FakeSpeaker()..gated = true;
      final controller = NgReadAloud(speaker: fake, bargeInMonitor: factory());
      addTearDown(controller.dispose);

      final reading = controller.read(
        'a',
        'The quick brown fox jumps over the lazy dog',
      );
      await pumpEventQueue();
      monitors.first.speak('the quick brown fox jumps over the lazy dog');
      expect(controller.readingKey, 'a');
      // Exactly the claim's stop; the echo path must not stop playback.
      expect(fake.stops, 1);
      // The genuine interjection then cuts the reply.
      monitors.first.speak('stop');
      await reading;
      expect(controller.readingKey, isNull);
    });

    test('the monitor is stopped when the read finishes', () async {
      bargeInEnabled.value = true;
      final fake = _FakeSpeaker();
      final controller = NgReadAloud(speaker: fake, bargeInMonitor: factory());
      addTearDown(controller.dispose);

      final reading = controller.read('a', 'finished text');
      await reading;
      expect(controller.readingKey, isNull);
      expect(monitors, hasLength(1));
      expect(monitors.first.stops, greaterThanOrEqualTo(1));
      expect(monitors.first.consumed, isFalse);
    });

    test('a stale isCurrent stops the monitor itself', () async {
      bargeInEnabled.value = true;
      final fake = _FakeSpeaker();
      final controller = NgReadAloud(speaker: fake, bargeInMonitor: factory());
      addTearDown(controller.dispose);

      final reading = controller.read('a', 'done');
      await reading;
      // Reading ended: the monitor is already stopped and cannot interrupt.
      expect(monitors.first.stops, greaterThanOrEqualTo(1));
      monitors.first.speak('stop');
      // A stale monitor must not fire anything.
      expect(fake.stops, 1);
      expect(controller.readingKey, isNull);
    });
  });

  group('BargeInPreferenceStore', () {
    test('defaults off and persists across loads', () async {
      bargeInEnabled.value = false;
      await BargeInPreferenceStore.load();
      expect(bargeInEnabled.value, isFalse);

      await BargeInPreferenceStore.setEnabled(true);
      expect(bargeInEnabled.value, isTrue);
      bargeInEnabled.value = false;
      await BargeInPreferenceStore.load();
      expect(bargeInEnabled.value, isTrue);

      await BargeInPreferenceStore.setEnabled(false);
      expect(bargeInEnabled.value, isFalse);
    });
  });
}
