import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../utils/platform_capabilities.dart';
import 'completion_tones.dart';
import 'notification_prefs.dart';

/// Where a cue is played. Tests record instead.
abstract interface class CompletionCueOutput {
  Future<void> play(Uint8List wav);
}

/// Plays nothing: the default until an app entry point installs device
/// audio, so widget tests and hosts without the audio plugin stay quiet.
class _NoCueOutput implements CompletionCueOutput {
  const _NoCueOutput();
  @override
  Future<void> play(Uint8List wav) async {}
}

/// Plays through audioplayers without taking audio focus, as a short UI
/// sound: it mixes with music, dictation and spoken replies.
class _AudioplayersCueOutput implements CompletionCueOutput {
  AudioPlayer? _player;

  @override
  Future<void> play(Uint8List wav) async {
    var player = _player;
    if (player == null) {
      player = _player = AudioPlayer(playerId: 'ares-completion-cue');
      // Android applies this to this player only. On Apple platforms the
      // audio session is app-wide, so voice features keep theirs.
      if (defaultTargetPlatform == TargetPlatform.android) {
        await player.setAudioContext(
          AudioContext(
            android: const AudioContextAndroid(
              contentType: AndroidContentType.sonification,
              usageType: AndroidUsageType.notificationEvent,
              audioFocus: AndroidAudioFocus.none,
            ),
          ),
        );
      }
    }
    await player.stop();
    await player.play(BytesSource(wav, mimeType: 'audio/wav'));
  }
}

/// The in-app completion cue, in both layouts and every platform.
///
/// Desktop plays its completion sound on every `message.complete`
/// (`apps/desktop/src/lib/completion-sound.ts`, called from
/// `message-stream.ts`), keyed by session so one window plays it, and has a
/// mute. Ares plays it while it is in front, which is exactly when it posts no
/// completion notification, so the two never sound together. The sound is
/// the completion sound choice: Mail and Reminder play their tones, System
/// default plays a short chime (an app cannot play the platform's
/// notification sound itself), and Silent or the mute plays nothing.
class CompletionCuePlayer {
  CompletionCuePlayer._();

  static final instance = CompletionCuePlayer._();

  /// A second report of the same chat's turn end within this window (a
  /// `message.complete` then `turn.end`, or two owners) plays once.
  static const dedupeWindow = Duration(seconds: 5);

  CompletionCueOutput _output = const _NoCueOutput();
  final _clock = Stopwatch()..start();
  final _recent = <String, Duration>{};
  final _bytes = <CompletionTone, Uint8List>{};

  /// Whether this window plays the cue for the chat named by a key, when
  /// another window can show the same chat (a pop-out runs in its own
  /// process, so [dedupeWindow] cannot see the other copy). Desktop gives
  /// each cue to one window (`ownsAmbientCue`); the pop-out plumbing installs
  /// this. Null: this window plays every cue.
  bool Function(String key)? ownership;

  /// Plays cues on the device. Called once by the app's entry points
  /// (`main` and the pop-out child); until then cues are silent, since
  /// creating an audio player needs the platform plugin.
  void useDeviceAudio() {
    if (_output is _NoCueOutput) _output = _AudioplayersCueOutput();
  }

  @visibleForTesting
  set debugOutput(CompletionCueOutput? output) {
    _output = output ?? const _NoCueOutput();
    _recent.clear();
  }

  /// Ares is on screen: resumed, or only covered (a notification shade) on
  /// a phone. The same rule decides that no completion notification posts.
  static bool get appInFront {
    final state = WidgetsBinding.instance.lifecycleState;
    return state == null ||
        state == AppLifecycleState.resumed ||
        (state == AppLifecycleState.inactive && !isWindowsPlatform);
  }

  /// The tone the current choice plays in the app, or null for none.
  static CompletionTone? get tone {
    final prefs = notificationPrefs.value;
    if (prefs.muteAppSounds) return null;
    return switch (prefs.completionSound) {
      WindowsCompletionSound.silent => null,
      WindowsCompletionSound.system => CompletionTone.chime,
      WindowsCompletionSound.mail => CompletionTone.mail,
      WindowsCompletionSound.reminder => CompletionTone.reminder,
    };
  }

  /// A live reply finished successfully in the chat named by [key] (its
  /// connection and chat). Never call it for a failed or stopped turn.
  void turnFinished(String key) {
    final tone = CompletionCuePlayer.tone;
    if (tone == null || !appInFront) return;
    if (ownership?.call(key) == false) return;
    final now = _clock.elapsed;
    _recent.removeWhere((_, at) => now - at > dedupeWindow);
    if (_recent.containsKey(key)) return;
    _recent[key] = now;
    final wav = _bytes[tone] ??= completionToneWav(tone);
    unawaited(
      _output.play(wav).catchError((Object _) {
        // A missing audio device must not affect the chat.
      }),
    );
  }
}
