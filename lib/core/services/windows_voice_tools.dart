/// Windows voice-draft media tools.
///
/// Mirrors the Swift `voice_draft` channel (duration / join) for the Windows
/// build. Fragments are AAC-LC M4A at 16 kHz, one channel, written by the
/// `record` plugin. Joining re-encodes at the same settings with ffmpeg; the
/// Swift implementation uses AVAssetExportSession, and the Android and iOS
/// implementations read through a native channel — this is the Dart-side
/// equivalent used on Windows.
library;

import 'dart:io';

class WindowsVoiceTools {
  WindowsVoiceTools({this.ffprobePath, this.ffmpegPath});

  /// Explicit executables (tests). When null, the bundled ones are used.
  final String? ffprobePath;
  final String? ffmpegPath;

  /// Same bounds as the Swift implementation.
  static const int maxFileBytes = 6 * 1024 * 1024;
  static const int maxDurationMs = 600 * 1000;

  static String _nameFor(String base) =>
      Platform.isWindows ? '$base.exe' : base;

  /// Only the executables shipped beside the app are used: an `ffmpeg`
  /// folder next to the executable. Nothing is looked up on PATH, in the
  /// environment or in shared locations, so another program on the machine
  /// cannot substitute its own binary.
  static Future<String?> _resolve({
    String? explicit,
    required String base,
  }) async {
    if (explicit != null && explicit.isNotEmpty) return explicit;
    try {
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final candidate =
          '$exeDir${Platform.pathSeparator}ffmpeg${Platform.pathSeparator}${_nameFor(base)}';
      if (await File(candidate).exists()) return candidate;
    } catch (_) {}
    return null;
  }

  /// Returns the file's existence and non-directory state (shared by all ops).
  static Future<bool> _fileIsOwned(
    String path,
    Directory voiceDraftsRoot,
  ) async {
    final file = File(path);
    if (!await file.exists()) return false;
    if (file.parent.path != voiceDraftsRoot.path) return false;
    if (!path.toLowerCase().endsWith('.m4a')) return false;
    final length = await file.length();
    return length >= 1 && length <= maxFileBytes;
  }

  /// ffprobe duration in milliseconds. Throws [StateError] when the file is
  /// not owned or probing fails; callers keep the same contract as the
  /// native `duration` channel (absent/failure -> Duration.zero is the
  /// caller's decision).
  Future<int> durationMs(String path, Directory voiceDraftsRoot) async {
    if (!await _fileIsOwned(path, voiceDraftsRoot)) {
      throw StateError('Invalid voice draft media path.');
    }
    final probe = await _resolve(explicit: ffprobePath, base: 'ffprobe');
    if (probe == null) {
      throw StateError('ffprobe is not available.');
    }
    late ProcessResult result;
    try {
      result = await Process.run(probe, [
        '-v',
        'error',
        '-show_entries',
        'format=duration',
        '-of',
        'csv=p=0',
        path,
      ]);
    } catch (_) {
      throw StateError('ffprobe is not available.');
    }
    if (result.exitCode != 0) {
      throw StateError('ffprobe failed (exit ${result.exitCode}).');
    }
    final seconds = double.tryParse(result.stdout.toString().trim()) ?? 0.0;
    return (seconds * 1000).round();
  }

  /// Concat [paths] (all .m4a fragments owned by [voiceDraftsRoot]) into
  /// [output]. Returns true on success, false otherwise. [output] must live in
  /// the same directory — mirroring the native channel's ownership contract.
  Future<bool> join({
    required List<String> paths,
    required String output,
    required Directory voiceDraftsRoot,
  }) async {
    if (paths.length < 2) return false;
    final outputDirectory = File(output).parent.path;
    if (!paths.every((p) => File(p).parent.path == outputDirectory)) {
      return false;
    }
    for (final path in paths) {
      if (!await _fileIsOwned(path, voiceDraftsRoot)) return false;
    }
    final probe = await _resolve(explicit: ffprobePath, base: 'ffprobe');
    if (probe == null) return false;
    var totalMs = 0;
    for (final path in paths) {
      late ProcessResult result;
      try {
        result = await Process.run(probe, [
          '-v',
          'error',
          '-show_entries',
          'format=duration',
          '-of',
          'csv=p=0',
          path,
        ]);
      } catch (_) {
        return false;
      }
      if (result.exitCode != 0) return false;
      final seconds = double.tryParse(result.stdout.toString().trim()) ?? 0.0;
      totalMs += (seconds * 1000).round();
    }
    if (totalMs > maxDurationMs) return false;

    final ffmpeg = await _resolve(explicit: ffmpegPath, base: 'ffmpeg');
    if (ffmpeg == null) return false;

    final inputArgs = <String>[];
    for (final path in paths) {
      inputArgs.addAll(['-i', path]);
    }
    final inputLabels = List.generate(paths.length, (i) => '[$i:a]').join();
    late ProcessResult result;
    try {
      result = await Process.run(ffmpeg, [
        '-y',
        '-v',
        'error',
        ...inputArgs,
        '-filter_complex',
        "${inputLabels}concat=n=${paths.length}:v=0:a=1[out]",
        '-map',
        '[out]',
        '-c:a',
        'aac',
        '-b:a',
        '64000',
        '-ar',
        '16000',
        output,
      ]);
    } catch (_) {
      return false;
    }
    if (result.exitCode != 0) return false;
    final out = File(output);
    return await out.exists() && await out.length() > 0;
  }
}
