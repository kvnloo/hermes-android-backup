import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/portable_profile_bundle.dart';

Uint8List tar(Map<String, String> entries) {
  final a = Archive();
  for (final e in entries.entries) {
    a.addFile(ArchiveFile.string(e.key, e.value));
  }
  return Uint8List.fromList(gzip.encode(TarEncoder().encodeBytes(a)));
}

void main() {
  test(
    'only opted-in regular profile files survive a fresh CLI-format bundle',
    () async {
      final bundle = await PortableProfileBundle.inspect(
        tar({
          'qa/.env': 'fixture',
          'qa/auth.json': 'fixture',
          'qa/SOUL.md': 'fixture persona',
          'qa/cron/jobs.json': '{"jobs":[]}',
          'qa/skills/demo/SKILL.md': '# demo',
          'qa/scripts/automation.sh': 'fixture',
          'qa/desktop.json': '{}',
        }),
      );
      expect(
        bundle.files.keys,
        unorderedEquals([
          'SOUL.md',
          'cron/jobs.json',
          'skills/demo/SKILL.md',
          'desktop.json',
        ]),
      );
      expect(bundle.omitted, 3);
      expect(() => bundle.encode({}), throwsFormatException);
      final next = await PortableProfileBundle.inspect(
        bundle.encode({'SOUL.md', 'skills/demo/SKILL.md'}),
      );
      expect(next.profile, 'qa');
      expect(next.files, {
        'SOUL.md': 'fixture persona',
        'skills/demo/SKILL.md': '# demo',
      });
      expect(next.omitted, 0);
    },
  );
  test(
    'mixed roots, bad headers, and a stream that grows beyond its declared cap fail',
    () async {
      await expectLater(
        PortableProfileBundle.inspect(
          tar({'qa/SOUL.md': 'a', 'other/config.yaml': 'b'}),
        ),
        throwsFormatException,
      );
      await expectLater(
        PortableProfileBundle.inspect(
          Uint8List.fromList(gzip.encode(List.filled(512, 1))),
        ),
        throwsFormatException,
      );
      await expectLater(
        PortableProfileBundle.bounded(
          Stream.fromIterable([
            [1],
            [2, 3],
          ]),
          2,
        ),
        throwsFormatException,
      );
    },
  );
}
