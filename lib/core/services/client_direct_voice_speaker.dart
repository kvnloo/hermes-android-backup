import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:uuid/uuid.dart';

import 'client_direct_voice.dart';
import '../controllers/hands_free_conversation_controller.dart';
import 'hands_free_speech.dart';

/// Playback boundary for provider-synthesised MP3 bytes. Kept injectable so a
/// test can prove start/stop/cancel without a platform audio device.
abstract interface class DirectVoiceAudioSink {
  Future<HandsFreeSpeechOutcome> play(Uint8List bytes);
  Future<void> stop();
}

/// Plays through one audioplayers player, opened on the first playback and
/// never before: a chat that is only shown (or a test platform without the
/// plugin) has no player at all. Each sink's player has an id of its own, so
/// two chats never drive the same native player.
class FlutterDirectVoiceAudioSink implements DirectVoiceAudioSink {
  FlutterDirectVoiceAudioSink({AudioPlayer Function(String playerId)? create})
    : _create = create ?? ((id) => AudioPlayer(playerId: id));

  final AudioPlayer Function(String playerId) _create;
  AudioPlayer? _player;
  bool _disposed = false;
  Completer<HandsFreeSpeechOutcome>? _active;
  StreamSubscription<void>? _subscription;

  AudioPlayer _ensurePlayer() =>
      _player ??= _create('ares-direct-voice-${const Uuid().v4()}');

  @override
  Future<HandsFreeSpeechOutcome> play(Uint8List bytes) async {
    await stop();
    if (_disposed) return HandsFreeSpeechOutcome.canceled;
    final player = _ensurePlayer();
    final completer = Completer<HandsFreeSpeechOutcome>();
    _active = completer;
    _subscription = player.onPlayerComplete.listen((_) {
      if (!completer.isCompleted) {
        completer.complete(HandsFreeSpeechOutcome.completed);
      }
    });
    await player.play(BytesSource(bytes, mimeType: 'audio/mpeg'));
    return completer.future;
  }

  @override
  Future<void> stop() async {
    final active = _active;
    _active = null;
    await _subscription?.cancel();
    _subscription = null;
    // Nothing played yet: there is no player to stop, and none is opened.
    await _player?.stop();
    if (active != null && !active.isCompleted) {
      active.complete(HandsFreeSpeechOutcome.canceled);
    }
  }

  /// Ends playback and releases the native player, if one was opened.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    final player = _player;
    _player = null;
    final active = _active;
    _active = null;
    await _subscription?.cancel();
    _subscription = null;
    if (active != null && !active.isCompleted) {
      active.complete(HandsFreeSpeechOutcome.canceled);
    }
    if (player != null) await player.dispose();
  }
}

/// Uses the profile's client-direct TTS wire when the gateway reports one,
/// otherwise delegates to the existing flutter_tts relay speaker. Provider
/// rejections throw to the caller; they are never silently replayed through
/// the gateway with a different provider.
class ClientDirectVoiceReplySpeaker implements VoiceReplySpeaker {
  ClientDirectVoiceReplySpeaker({
    required this.store,
    required this.scopeKey,
    required this.fallback,
    DirectVoiceAudioSink? sink,
  }) : _ownedSink = sink == null ? FlutterDirectVoiceAudioSink() : null,
       _injectedSink = sink;

  final VoiceClientConfigStore store;
  final String scopeKey;
  final VoiceReplySpeaker fallback;

  /// The sink this speaker made, and so disposes. An injected sink belongs
  /// to whoever injected it.
  final FlutterDirectVoiceAudioSink? _ownedSink;
  final DirectVoiceAudioSink? _injectedSink;

  DirectVoiceAudioSink get _sink => _injectedSink ?? _ownedSink!;

  /// Resolves this scope's voice config ahead of the reply, so speaking it
  /// does not wait on a gateway round trip once it lands. Call when a spoken
  /// reply becomes expected; a failed read is retried when the reply comes.
  void warm() => unawaited(store.configFor(scopeKey));

  @override
  Future<bool> prepare() {
    warm();
    return fallback.prepare();
  }

  @override
  Future<HandsFreeSpeechOutcome> speak(
    String text, {
    required bool Function() isCurrent,
  }) async {
    final voice = (await store.configFor(scopeKey))?.tts;
    if (voice == null) {
      return fallback.speak(text, isCurrent: isCurrent);
    }
    final bytes = await store.synthesize(text);
    if (bytes == null || bytes.isEmpty) {
      return fallback.speak(text, isCurrent: isCurrent);
    }
    if (!isCurrent()) {
      return HandsFreeSpeechOutcome.canceled;
    }
    try {
      return await _sink.play(bytes);
    } catch (_) {
      return HandsFreeSpeechOutcome.failed;
    }
  }

  @override
  Future<void> stop() async {
    await _sink.stop();
    await fallback.stop();
  }

  /// Ends playback and releases the player this speaker opened. The relay
  /// fallback is the caller's: its flutter_tts engine outlives this speaker.
  Future<void> dispose() async {
    try {
      await _ownedSink?.dispose();
    } catch (_) {
      // Releasing a player that never finished opening is best effort.
    }
  }
}
