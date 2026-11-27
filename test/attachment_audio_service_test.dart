import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/attachment_audio_service.dart';
import 'package:hermes_android/core/services/remote_files_client.dart';

import 'support/audio_preview_fixture.dart';

void main() {
  test(
    'real staging snapshots bounded audio bytes and removes only its owned directory',
    () async {
      final root = Directory(
        Platform.environment['TMPDIR']!,
      ).createTempSync('ares-audio-store-');
      addTearDown(() => root.deleteSync(recursive: true));
      final sentinel = File('${root.path}/unrelated')
        ..writeAsStringSync('keep');
      final store = AttachmentAudioFileStore(
        temporaryDirectoryProvider: () async => root,
      );
      final bytes = Uint8List.fromList([1, 2, 3]);
      final pending = store.stage(bytes, 'WAV');
      bytes[0] = 99;
      final staged = await pending;
      expect(await staged.file.readAsBytes(), [1, 2, 3]);
      expect(staged.file.path, endsWith('/attachment.wav'));
      await staged.close();
      await staged.close();
      expect(await staged.file.exists(), false);
      expect(sentinel.readAsStringSync(), 'keep');
      await expectLater(
        store.stage(Uint8List(0), 'wav'),
        throwsFormatException,
      );
      await expectLater(
        store.stage(Uint8List(1), '../wav'),
        throwsFormatException,
      );
      await expectLater(
        store.stage(Uint8List(1), 'm3u8'),
        throwsFormatException,
      );
      expect(root.listSync().length, 1);
    },
  );

  test(
    'local composer snapshot refuses over-budget files without unbounded buffering',
    () async {
      final root = Directory(
        Platform.environment['TMPDIR']!,
      ).createTempSync('ares-audio-read-');
      addTearDown(() => root.deleteSync(recursive: true));
      final file = File('${root.path}/synthetic.bin');
      final handle = file.openSync(mode: FileMode.write);
      handle.truncateSync(maxAttachmentDownloadBytes + 1);
      handle.closeSync();
      const store = AttachmentAudioFileStore();
      await expectLater(store.readLocal(file.path), throwsFormatException);
      expect(file.lengthSync(), maxAttachmentDownloadBytes + 1);
    },
  );

  test(
    'concurrent play claims serialize; old queued claims cannot revive after close',
    () async {
      final fixture = AudioFixture();
      final a = fixture.create();
      final b = fixture.create();
      await a.open(() async => Uint8List.fromList([1]), 'wav');
      await b.open(() async => Uint8List.fromList([2]), 'wav');
      final first = a.play();
      final second = b.play();
      await Future.wait([first, second]);
      expect(
        fixture.players[0].plays,
        0,
        reason: 'A newer queued gesture supersedes an unstarted claim.',
      );
      expect(fixture.players[0].pauses, 0);
      expect(fixture.players[1].plays, 1);
      final stale = a.play();
      final closed = a.close();
      await Future.wait([stale, closed]);
      expect(fixture.players[0].plays, 0);
      await b.close();
      expect(fixture.players.map((player) => player.disposals), [1, 1]);
    },
  );

  test(
    'owner closing after peer pause queues still joins exact native teardown',
    () async {
      final fixture = AudioFixture();
      final player = AudioFixturePlayer();
      var creates = 0;
      fixture.makePlayer = () => creates++ == 0 ? player : AudioFixturePlayer();
      final a = fixture.create();
      final b = fixture.create();
      await a.open(() async => Uint8List.fromList([1]), 'wav');
      await b.open(() async => Uint8List.fromList([2]), 'wav');
      await a.play();
      player.seekGate = Completer<void>();
      player.pauseGate = Completer<void>();
      final seek = a.seek(const Duration(seconds: 2));
      await pumpEventQueue();
      final play = b.play();
      await pumpEventQueue();
      final close = a.close();
      player.seekGate!.complete();
      try {
        await pumpEventQueue();
        expect(fixture.players[1].plays, 0);
      } finally {
        player.pauseGate!.complete();
        await Future.wait([seek, play, close]);
        await b.close();
      }
    },
  );

  test(
    'a new claimant joins a closing native owner before it can play',
    () async {
      final fixture = AudioFixture();
      final player = AudioFixturePlayer()
        ..pauseGate = Completer<void>()
        ..disposeGate = Completer<void>();
      var creates = 0;
      fixture.makePlayer = () => creates++ == 0 ? player : AudioFixturePlayer();
      final a = fixture.create();
      final b = fixture.create();
      await a.open(() async => Uint8List.fromList([1]), 'wav');
      await b.open(() async => Uint8List.fromList([2]), 'wav');
      await a.play();
      final close = a.close();
      final play = b.play();
      await pumpEventQueue();
      expect(fixture.players[1].plays, 0);
      player.pauseGate!.complete();
      await pumpEventQueue();
      expect(fixture.players[1].plays, 0);
      player.disposeGate!.complete();
      await Future.wait([close, play]);
      expect(fixture.players[1].plays, 1);
      await b.close();
    },
  );

  test(
    'failed peer pause retains arbitration authority until it can stop',
    () async {
      final fixture = AudioFixture();
      final a = fixture.create();
      final b = fixture.create();
      final c = fixture.create();
      await a.open(() async => Uint8List.fromList([1]), 'wav');
      await b.open(() async => Uint8List.fromList([2]), 'wav');
      await c.open(() async => Uint8List.fromList([3]), 'wav');
      await a.play();
      fixture.players[0].pauseError = StateError('native pause refused');
      await expectLater(b.play(), throwsStateError);
      await b.close();
      await expectLater(c.play(), throwsStateError);
      expect(fixture.players[2].plays, 0);
      fixture.players[0].pauseError = null;
      await a.close();
      await c.close();
    },
  );

  test(
    'late native play is paused after permission loss, never auto-resumed',
    () async {
      final fixture = AudioFixture();
      final player = AudioFixturePlayer()..playGate = Completer<void>();
      fixture.makePlayer = () => player;
      final session = fixture.create();
      await session.open(() async => Uint8List.fromList([1]), 'wav');
      final play = session.play();
      await pumpEventQueue();
      expect(player.plays, 1);
      final paused = session.setAllowed(false);
      player.playGate!.complete();
      await Future.wait([play, paused]);
      expect(player.pauses, greaterThanOrEqualTo(1));
      await session.setAllowed(true);
      expect(player.plays, 1);
      await session.close();
    },
  );
}
