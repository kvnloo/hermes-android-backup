// Standalone native smoke entry; never loads Ares profiles or user content.
// Build: flutter build macos --debug -t tool/audio_attachment_probe.dart
// Run the built executable directly with ARES_AUDIO_PROBE_ROOT set to a private
// scratch directory. It generates silence, plays muted, then disposes/deletes.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hermes_android/core/services/attachment_audio_service.dart';

Uint8List _wav() {
  const samples = 16000 * 2;
  final bytes = Uint8List(44 + samples * 2);
  final data = ByteData.sublistView(bytes);
  void text(int offset, String value) =>
      bytes.setRange(offset, offset + value.length, value.codeUnits);
  text(0, 'RIFF');
  data.setUint32(4, bytes.length - 8, Endian.little);
  text(8, 'WAVE');
  text(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little);
  data.setUint32(24, 16000, Endian.little);
  data.setUint32(28, 32000, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  text(36, 'data');
  data.setUint32(40, samples * 2, Endian.little);
  return bytes;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Text('Private muted audio probe'))),
    ),
  );
  final path = Platform.environment['ARES_AUDIO_PROBE_ROOT'];
  if (path == null) exit(2);
  final root = Directory(path);
  final session = AttachmentAudioSession(
    fileStore: AttachmentAudioFileStore(
      temporaryDirectoryProvider: () async => root,
    ),
  );
  try {
    final ready = await session
        .open(() async => _wav(), 'wav')
        .timeout(const Duration(seconds: 20));
    if (!ready) throw StateError('not ready');
    final player = session.player!;
    await player.setVolume(0);
    final duration = await player.getDuration();
    if (duration == null ||
        duration.inMilliseconds < 1900 ||
        duration.inMilliseconds > 2100) {
      throw StateError('unexpected duration');
    }
    await session.seek(const Duration(milliseconds: 400));
    await session.play();
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final position = await player.getCurrentPosition();
    await session.pause();
    if (position == null || position.inMilliseconds <= 400) {
      throw StateError('no progress');
    }
    await session.close();
    final retained = await root.list().length;
    if (retained != 0) throw StateError('staging not released');
    // ignore: avoid_print
    print(
      'ARES_AUDIO_NATIVE ${jsonEncode({'platform': Platform.operatingSystem, 'duration_ms': duration.inMilliseconds, 'position_ms': position.inMilliseconds, 'muted': true, 'staged_entries_after_dispose': retained, 'result': 'PASS'})}',
    );
    exit(0);
  } catch (error) {
    // No paths, media or provider error payloads are printed.
    // ignore: avoid_print
    print(
      'ARES_AUDIO_NATIVE ${jsonEncode({'platform': Platform.operatingSystem, 'error_type': error.runtimeType.toString(), 'result': 'FAIL'})}',
    );
    try {
      await session.close().timeout(const Duration(seconds: 5));
    } catch (_) {}
    exit(1);
  }
}
