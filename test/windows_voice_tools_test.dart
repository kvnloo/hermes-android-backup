import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/windows_voice_tools.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('ares-voice-tools-test-');
  });

  tearDown(() {
    if (root.existsSync()) root.deleteSync(recursive: true);
  });

  Directory draftsRoot() => Directory('${root.path}/voice_drafts');

  File writeDraft(String name, [int bytes = 8]) {
    final directory = draftsRoot();
    directory.createSync(recursive: true);
    final file = File('${directory.path}/$name');
    file.writeAsBytesSync(List<int>.filled(bytes, 1));
    return file;
  }

  test('owned .m4a under the voice_drafts root is required', () async {
    final drafts = draftsRoot()..createSync(recursive: true);
    final tools = WindowsVoiceTools(ffprobePath: '/nonexistent/ares-probe-xyz');

    await expectLater(
      tools.durationMs('${drafts.path}/voice.m4a', drafts),
      throwsStateError,
    );

    writeDraft('voice.m4a');
    // File exists but the probe is missing/broken -> throws StateError, and
    // no bytes are read.
    await expectLater(
      tools.durationMs('${drafts.path}/voice.m4a', drafts),
      throwsStateError,
    );
  });

  test(
    'join refuses files outside the drafts root and non-.m4a names',
    () async {
      final tools = WindowsVoiceTools();
      final outside = File('${root.path}/outside.m4a')
        ..writeAsBytesSync(List<int>.filled(8, 1));
      final drafts = draftsRoot()..createSync(recursive: true);
      writeDraft('base.m4a');
      writeDraft('next.m4a');

      expect(
        await tools.join(
          paths: [outside.path, '${drafts.path}/next.m4a'],
          output: '${drafts.path}/output.m4a',
          voiceDraftsRoot: drafts,
        ),
        isFalse,
      );

      final bad = File('${drafts.path}/notes.txt')
        ..writeAsBytesSync(List<int>.filled(8, 1));
      expect(
        await tools.join(
          paths: ['${drafts.path}/base.m4a', bad.path],
          output: '${drafts.path}/output.m4a',
          voiceDraftsRoot: drafts,
        ),
        isFalse,
      );
    },
  );

  test(
    'join refuses to re-target output anywhere but the drafts root',
    () async {
      final tools = WindowsVoiceTools();
      final drafts = draftsRoot()..createSync(recursive: true);
      writeDraft('base.m4a');
      writeDraft('next.m4a');

      expect(
        await tools.join(
          paths: ['${drafts.path}/base.m4a', '${drafts.path}/next.m4a'],
          output: '${root.path}/elsewhere.m4a',
          voiceDraftsRoot: drafts,
        ),
        isFalse,
      );
    },
  );
}
