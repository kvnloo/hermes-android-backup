import 'dart:async';

import '../utils/barge_echo.dart';
import 'android_voice_composer_adapter.dart';
import 'voice_composer_adapter.dart';

/// A speech monitor that fires [onInterrupt] the moment the user starts
/// speaking during read-aloud playback.
///
/// It is strictly read-aloud interruption — it never submits a turn, never
/// sends audio anywhere and never touches the hands-free controller. The
/// mic is only opened while a reply is being read and only when barge-in is
/// explicitly enabled in settings; the concrete platform path is identical to
/// the composer's dictation path (native on Android, speech_to_text elsewhere).
abstract interface class BargeInMonitor {
  /// Starts the monitor. Returns `false` without side effects when the
  /// platform cannot start it. [echoText] is the text being read aloud; a
  /// transcript that closely matches it is the engine's own voice bleeding
  /// back into the mic, not the user talking, and is ignored.
  Future<bool> start({
    required void Function() onInterrupt,
    String? echoText,
    bool Function()? isCurrent,
  });

  /// Stops listening. Safe to call repeatedly.
  Future<void> stop();
}

class SpeechToTextBargeInMonitor implements BargeInMonitor {
  SpeechToTextBargeInMonitor({VoiceComposerAdapter? adapter})
    : _adapter = adapter ?? createVoiceComposerAdapter();

  final VoiceComposerAdapter _adapter;
  bool _active = false;
  bool _stopping = false;
  bool _consumed = false;
  bool Function()? _isCurrent;
  String? _echoText;
  void Function()? _onInterrupt;

  @override
  Future<bool> start({
    required void Function() onInterrupt,
    String? echoText,
    bool Function()? isCurrent,
  }) async {
    _stopping = false;
    _consumed = false;
    _onInterrupt = onInterrupt;
    _echoText = echoText;
    _isCurrent = isCurrent;
    final ok = await _adapter.initialize(
      onStatus: (_) {},
      onError: (_) {
        unawaited(stop());
      },
    );
    if (!ok || _stopping) return false;
    _active = true;
    // Fire-and-forget: the monitor's job is to surface speech from the
    // adapter's event path; the listen future completes when recognition
    // ends, which it does not need to hold here.
    unawaited(_listenSafely());
    // A delivered final result with an empty transcript (or no result at
    // all) is not an interrupt; keep the monitor armed until stopped.
    return _active && !_stopping;
  }

  Future<void> _listenSafely() async {
    try {
      await _adapter.listen(
        // The interrupt path cancels the listen itself; no final result is
        // delivered after the mic is stopped.
        onResult: ({required transcript, required isFinal}) {
          if (!_active || _stopping || _consumed) return;
          final text = transcript.trim();
          if (text.isEmpty) return;
          if (_isCurrent != null && !_isCurrent!()) {
            unawaited(stop());
            return;
          }
          final echo = _echoText;
          if (echo != null && isLikelyEcho(text, echo)) return;
          _consumed = true;
          unawaited(stop());
          _onInterrupt?.call();
        },
      );
    } catch (_) {
      unawaited(stop());
    }
  }

  @override
  Future<void> stop() async {
    if (_stopping) return;
    _stopping = true;
    _active = false;
    try {
      await _adapter.stop();
    } catch (_) {
      // A failed stop must not break the read path.
    }
    try {
      await _adapter.cancel();
    } catch (_) {
      // Best effort.
    }
    _onInterrupt = null;
    _isCurrent = null;
    _echoText = null;
  }
}
