import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

import '../utils/attachment_types.dart';
import 'attachment_video_service.dart';
import 'remote_files_client.dart' show maxAttachmentDownloadBytes;

/// Uses the existing locked, app-private staging protocol. Neither gateway
/// paths nor original filenames ever reach a native audio source.
class AttachmentAudioFileStore extends AttachmentVideoFileStore {
  const AttachmentAudioFileStore({super.temporaryDirectoryProvider});

  @override
  bool acceptsExtension(String extension) => attachmentIsAudio(extension);

  /// Only composer-owned cache paths may call this boundary, never remote refs.
  /// Read a bounded snapshot so deleting a draft cannot delete a native source.
  Future<Uint8List> readLocal(String path) async {
    final builder = BytesBuilder(copy: false);
    await for (final chunk in File(path).openRead()) {
      if (builder.length + chunk.length > maxAttachmentDownloadBytes) {
        throw const FormatException('Audio exceeds preview bounds');
      }
      builder.add(chunk);
    }
    return builder.takeBytes();
  }
}

AudioPlayer _newAudioPlayer() => AudioPlayer();

/// One immutable audio source lifetime. Closing revokes commands immediately,
/// then joins native initialization and commands before disposal and deletion.
/// An initialization timeout in the UI does NOT grant permission to delete a
/// file still being read by native code.
class AttachmentAudioSession {
  AttachmentAudioSession({
    this.fileStore = const AttachmentAudioFileStore(),
    this.createPlayer = _newAudioPlayer,
  });

  final AttachmentAudioFileStore fileStore;
  final AudioPlayer Function() createPlayer;
  AudioPlayer? _player;
  AttachmentVideoFile? _file;
  Future<bool>? _opening;
  Future<void>? _closing;
  Future<void> _commands = Future<void>.value();
  bool _closed = false;
  bool _allowed = true;
  int _epoch = 0;
  static AttachmentAudioSession? _playing;
  static Future<void>? _playTail;
  static int _latestPlayIntent = 0;

  /// Reserve at the user gesture, before a possibly slow file download.
  static int claimPlayIntent() => ++_latestPlayIntent;

  AudioPlayer? get player => _closed ? null : _player;

  Future<bool> open(Future<Uint8List?> Function() bytes, String extension) =>
      _opening ??= _prepare(bytes, extension);

  Future<bool> _prepare(
    Future<Uint8List?> Function() bytes,
    String extension,
  ) async {
    if (_closed) return false;
    if (!attachmentIsAudio(extension)) {
      throw const FormatException('Unsupported audio container');
    }
    final data = await bytes();
    if (_closed) return false;
    if (data == null) throw const FormatException('Audio unavailable');
    _file = await fileStore.stage(data, extension);
    if (_closed) return false;
    final player = _player = createPlayer();
    await player.setReleaseMode(ReleaseMode.stop);
    if (_closed) return false;
    await player.setSource(DeviceFileSource(_file!.file.path));
    return !_closed;
  }

  Future<void> setAllowed(bool allowed) {
    if (_closed || allowed == _allowed) return Future<void>.value();
    _allowed = allowed;
    if (allowed) return Future<void>.value();
    _epoch++;
    return pause();
  }

  Future<void> play({bool replay = false, int? playIntent}) {
    if (_closed || !_allowed) return Future<void>.value();
    final intent = playIntent ?? claimPlayIntent();
    final epoch = _epoch;
    final command = (_playTail ?? Future<void>.value()).then(
      (_) => _enqueue(() async {
        if (!_canPlay(epoch, intent)) return;
        final previous = _playing;
        if (previous != null && !identical(previous, this)) {
          // Do not relinquish the old owner if native pause fails: another
          // claimant must retry that stop rather than overlap an unknown reader.
          if (previous._closed) {
            await previous.close();
          } else {
            await previous.pause();
            // Closing may have revoked that queued pause before it reached
            // native code. Join the old owner, not merely its skipped command.
            if (previous._closed) await previous.close();
          }
        }
        if (!_canPlay(epoch, intent)) return;
        _playing = this;
        if (replay) {
          await _player!.seek(Duration.zero);
          if (!_canPlay(epoch, intent) || !identical(_playing, this)) return;
        }
        await _player!.resume();
        if (!_canPlay(epoch, intent) || !identical(_playing, this)) {
          await _player!.pause();
        }
      }),
    );
    final settled = command.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    _playTail = settled;
    unawaited(
      settled.then((_) {
        if (identical(_playTail, settled)) _playTail = null;
      }),
    );
    return command;
  }

  bool _canPlay(int epoch, int intent) =>
      !_closed && _allowed && epoch == _epoch && intent == _latestPlayIntent;

  Future<void> pause() {
    _epoch++;
    return _enqueue(() => _player!.pause());
  }

  Future<void> seek(Duration position) =>
      _enqueue(() => _player!.seek(position));

  Future<void> _enqueue(Future<void> Function() action) {
    if (_closed || _player == null) return Future<void>.value();
    final command = _commands.then((_) async {
      if (!_closed) await action();
    });
    _commands = command.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return command;
  }

  Future<void> close() {
    _closed = true;
    _epoch++;
    return _closing ??= _release();
  }

  Future<void> _release() async {
    try {
      await _opening;
    } catch (_) {
      // The initiating UI owns the sanitized loading/codec error.
    }
    await _commands;
    final player = _player;
    if (player != null) {
      try {
        await player.pause();
      } catch (_) {
        // Native disposal must still be attempted when pause fails.
      }
      await player.dispose(); // Retain the locked file if disposal fails.
      _player = null;
    }
    if (identical(_playing, this)) _playing = null;
    await _file?.close();
    _file = null;
  }
}
