// Exercises WindowsVoiceTools against real ffprobe/ffmpeg executables.
//
// Skipped unless ARES_TEST_FFMPEG and ARES_TEST_FFPROBE point at the
// executables to use, for example the build bundled with the Windows package:
//
//   set ARES_TEST_FFMPEG=C:\path\to\ffmpeg.exe
//   set ARES_TEST_FFPROBE=C:\path\to\ffprobe.exe
//   flutter test test/windows_voice_tools_ffmpeg_test.dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/windows_voice_tools.dart';

void main() {
  final ffmpeg = Platform.environment['ARES_TEST_FFMPEG'];
  final ffprobe = Platform.environment['ARES_TEST_FFPROBE'];
  final Object skip = (ffmpeg == null || ffprobe == null)
      ? 'Set ARES_TEST_FFMPEG and ARES_TEST_FFPROBE to run'
      : false;

  late Directory root;
  late Directory drafts;

  // Same shape as the recorder's fragments: AAC-LC, 16 kHz, mono, 64 kbit/s.
  Future<String> fragment(String name, int seconds) async {
    // Built the way LocalVoiceRecorder builds draft paths ('/' joins), so the
    // ownership checks see the separators they see in production.
    final path = '${drafts.path}/$name';
    final result = await Process.run(ffmpeg!, [
      '-y',
      '-v',
      'error',
      '-f',
      'lavfi',
      '-i',
      'sine=frequency=440:sample_rate=16000:duration=$seconds',
      '-ac',
      '1',
      '-c:a',
      'aac',
      '-b:a',
      '64000',
      '-ar',
      '16000',
      path,
    ]);
    expect(result.exitCode, 0, reason: '${result.stderr}');
    return path;
  }

  setUp(() async {
    root = await Directory.systemTemp.createTemp('ares-voice-ffmpeg-');
    drafts = Directory('${root.path}/voice_drafts');
    await drafts.create();
  });

  tearDown(() => root.delete(recursive: true));

  test('measures and joins real AAC fragments', () async {
    final tools = WindowsVoiceTools(ffprobePath: ffprobe, ffmpegPath: ffmpeg);
    final first = await fragment('draft.m4a', 1);
    final second = await fragment('draft.m4a.continue.m4a', 2);

    expect(await tools.durationMs(first, drafts), inInclusiveRange(900, 1250));
    expect(
      await tools.durationMs(second, drafts),
      inInclusiveRange(1900, 2250),
    );

    final output = '${drafts.path}/draft.m4a.test.joined.m4a';
    expect(
      await tools.join(
        paths: [first, second],
        output: output,
        voiceDraftsRoot: drafts,
      ),
      isTrue,
    );
    expect(
      await tools.durationMs(output, drafts),
      inInclusiveRange(2800, 3400),
    );
  }, skip: skip);

  test('refuses fragments outside the drafts directory', () async {
    final tools = WindowsVoiceTools(ffprobePath: ffprobe, ffmpegPath: ffmpeg);
    final inside = await fragment('draft.m4a', 1);
    final outside = File('${root.path}/elsewhere.m4a');
    await File(inside).copy(outside.path);

    expect(
      () => tools.durationMs(outside.path, drafts),
      throwsA(isA<StateError>()),
    );
    expect(
      await tools.join(
        paths: [inside, outside.path],
        output: '${drafts.path}/draft.m4a.test.joined.m4a',
        voiceDraftsRoot: drafts,
      ),
      isFalse,
    );
  }, skip: skip);
}
