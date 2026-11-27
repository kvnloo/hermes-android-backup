import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/attachment_audio_service.dart';
import 'package:hermes_android/core/services/attachment_video_service.dart';
import 'package:hermes_android/core/widgets/attachment_audio_preview.dart';

class AudioFixtureFile implements AttachmentVideoFile {
  int closes = 0;
  @override
  File get file => File('/private/ares-synthetic-audio/attachment.wav');
  @override
  Future<void> close() async => closes++;
}

class AudioFixtureStore extends AttachmentAudioFileStore {
  final reads = <String>[];
  final files = <AudioFixtureFile>[];
  Completer<Uint8List>? readGate;
  Completer<AttachmentVideoFile>? stageGate;
  Object? error;
  @override
  Future<Uint8List> readLocal(String path) async {
    reads.add(path);
    return readGate?.future ?? Uint8List.fromList([1, 2, 3]);
  }

  @override
  Future<AttachmentVideoFile> stage(Uint8List bytes, String extension) async {
    if (error case final error?) throw error;
    if (stageGate case final gate?) return gate.future;
    final file = AudioFixtureFile();
    files.add(file);
    return file;
  }
}

class AudioFixturePlayer extends Fake implements AudioPlayer {
  final states = StreamController<PlayerState>.broadcast(sync: true);
  final positions = StreamController<Duration>.broadcast(sync: true);
  final durations = StreamController<Duration>.broadcast(sync: true);
  final events = StreamController<AudioEvent>.broadcast(sync: true);
  final sources = <Source>[];
  final seeks = <Duration>[];
  int plays = 0;
  int pauses = 0;
  int disposals = 0;
  Completer<void>? sourceGate;
  Completer<void>? playGate;
  Completer<void>? pauseGate;
  Completer<void>? seekGate;
  Completer<void>? disposeGate;
  Object? sourceError;
  Object? disposeError;
  Object? pauseError;
  Completer<Duration?>? durationGate;
  @override
  Stream<PlayerState> get onPlayerStateChanged => states.stream;
  @override
  Stream<Duration> get onPositionChanged => positions.stream;
  @override
  Stream<Duration> get onDurationChanged => durations.stream;
  @override
  Stream<AudioEvent> get eventStream => events.stream;
  @override
  Future<void> setReleaseMode(ReleaseMode mode) async {}
  @override
  Future<void> setSource(Source source) async {
    sources.add(source);
    await sourceGate?.future;
    if (sourceError case final error?) throw error;
  }

  @override
  Future<Duration?> getDuration() async =>
      durationGate?.future ?? const Duration(seconds: 10);
  @override
  Future<void> resume() async {
    plays++;
    await playGate?.future;
    states.add(PlayerState.playing);
  }

  @override
  Future<void> pause() async {
    pauses++;
    await pauseGate?.future;
    if (pauseError case final error?) throw error;
    states.add(PlayerState.paused);
  }

  @override
  Future<void> seek(Duration position) async {
    seeks.add(position);
    await seekGate?.future;
    positions.add(position);
  }

  @override
  Future<void> dispose() async {
    disposals++;
    await disposeGate?.future;
    if (disposeError case final error?) throw error;
    await states.close();
    await positions.close();
    await durations.close();
    await events.close();
  }
}

class AudioFixture {
  final store = AudioFixtureStore();
  final players = <AudioFixturePlayer>[];
  final sessions = <AttachmentAudioSession>[];
  AudioFixturePlayer Function()? makePlayer;
  AttachmentAudioSession create() {
    final session = AttachmentAudioSession(
      fileStore: store,
      createPlayer: () {
        final player = makePlayer?.call() ?? AudioFixturePlayer();
        players.add(player);
        return player;
      },
    );
    sessions.add(session);
    return session;
  }

  Widget wrap(Widget child) =>
      AttachmentAudioEnvironment(createSession: create, child: child);
}
