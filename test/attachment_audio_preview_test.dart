import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/services/remote_files_client.dart';
import 'package:hermes_android/core/utils/audio_file_references.dart';
import 'package:hermes_android/core/utils/media_tags.dart';
import 'package:hermes_android/core/widgets/attachment_audio_preview.dart';
import 'package:hermes_android/core/widgets/attachment_draft_tile.dart';
import 'package:hermes_android/core/widgets/media_artifact_card.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

import 'support/audio_preview_fixture.dart';

final _bytes = Uint8List.fromList([1, 2, 3]);
const _play = Key('attachment-audio-play-pause');
Widget _app(AudioFixture fixture, Widget child, {double scale = 1}) =>
    fixture.wrap(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: Scaffold(body: child),
      ),
    );

class _Files extends Fake implements RemoteFilesDataSource {
  final paths = <String>[];
  Completer<RemoteFileDownload>? gate;
  Object? error;
  @override
  Future<RemoteFileDownload> download(String path) async {
    paths.add(path);
    if (error case final error?) throw error;
    return gate?.future ??
        RemoteFileDownload(filename: 'clip.wav', bytes: _bytes);
  }
}

void main() {
  test(
    'MIME and extension candidates are explicit; remote paths stay remote',
    () {
      expect(attachmentAudioExtension('CLIP.WAV'), 'wav');
      expect(attachmentAudioExtension('clip', 'audio/ogg; codecs=opus'), 'ogg');
      expect(attachmentAudioExtension('clip', 'audio/unknown'), '');
      expect(attachmentAudioExtension('x.m3u'), '');
      expect(
        audioPromptFileRefs(
          '@file:`/gateway/clip.wav`\n@file:https://host/a.wav\n@file:file:///private/a.wav',
        ).map((ref) => ref.path),
        ['/gateway/clip.wav'],
      );
    },
  );

  testWidgets(
    'picked audio tile: lazy play/pause, seek, no send, narrow large text',
    (tester) async {
      final fixture = AudioFixture();
      var removed = 0;
      await tester.binding.setSurfaceSize(const Size(320, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final draft = AttachmentDraft(
        id: 'audio',
        cachedPath: '/private/cache/clip.wav',
        name: 'clip.wav',
        byteLength: 3,
        mediaType: 'audio/wav',
        kind: AttachmentDraftKind.genericFile,
      );
      await tester.pumpWidget(
        _app(
          fixture,
          AttachmentDraftTile(
            draft: draft,
            index: 0,
            total: 1,
            busy: false,
            onMovePrevious: () {},
            onMoveNext: () {},
            onRetry: () {},
            onRemove: () => removed++,
          ),
          scale: 2,
        ),
      );
      expect(find.byKey(_play), findsOneWidget);
      expect(fixture.players, isEmpty);
      expect(fixture.store.reads, isEmpty);
      await tester.tap(find.byKey(_play));
      await tester.pumpAndSettle();
      expect(fixture.store.reads, [draft.cachedPath]);
      final player = fixture.players.single;
      expect(player.sources.single, isA<DeviceFileSource>());
      expect(
        (player.sources.single as DeviceFileSource).path,
        isNot(draft.cachedPath),
      );
      expect(player.plays, 1);
      expect(find.byTooltip('Pause'), findsOneWidget);
      await tester.tap(find.byKey(_play));
      await tester.pumpAndSettle();
      expect(player.pauses, 1);
      final slider = tester.widget<Slider>(
        find.byKey(const Key('attachment-audio-seek')),
      );
      slider.onChanged!(0.5);
      await tester.pumpAndSettle();
      expect(player.seeks, [const Duration(seconds: 5)]);
      expect(find.text('0:05 / 0:10'), findsOneWidget);
      player.states.add(PlayerState.completed);
      await tester.pump();
      await tester.tap(find.byKey(_play));
      await tester.pumpAndSettle();
      expect(player.seeks.last, Duration.zero);
      expect(player.plays, 2);
      expect(removed, 0);
      expect(draft.status, AttachmentDraftStatus.ready);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      expect(player.disposals, 1);
      expect(fixture.store.files.single.closes, 1);
    },
    variant: TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
    }),
  );

  testWidgets(
    'delivered card lazily loads; failure is sanitized and retry succeeds',
    (tester) async {
      final fixture = AudioFixture();
      final files = _Files()..error = StateError('secret-token-path');
      await tester.pumpWidget(
        _app(
          fixture,
          MediaArtifactCard(
            ref: const MediaTagRef(path: '/gateway/clip.wav'),
            filesClient: () => files,
            sourceIdentity: 'owner-a',
          ),
        ),
      );
      expect(files.paths, isEmpty);
      expect(fixture.players, isEmpty);
      await tester.tap(find.byKey(_play));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('attachment-audio-error')), findsOneWidget);
      expect(find.textContaining('secret-token-path'), findsNothing);
      expect(fixture.players, isEmpty);
      files.error = null;
      await tester.tap(find.byKey(_play));
      await tester.pumpAndSettle();
      expect(files.paths, ['/gateway/clip.wav', '/gateway/clip.wav']);
      expect(fixture.players.single.plays, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      expect(fixture.players.single.disposals, 1);
    },
  );

  testWidgets('late remote fetch cannot play across A/B/A owner replacement', (
    tester,
  ) async {
    final fixture = AudioFixture();
    final files = _Files()..gate = Completer<RemoteFileDownload>();
    Future<void> build(String owner) => tester.pumpWidget(
      _app(
        fixture,
        MediaArtifactCard(
          ref: const MediaTagRef(path: '/gateway/clip.wav'),
          filesClient: () => files,
          sourceIdentity: owner,
        ),
      ),
    );
    await build('a');
    await tester.tap(find.byKey(_play));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    await build('b');
    await build('a');
    files.gate!.complete(
      RemoteFileDownload(filename: 'clip.wav', bytes: _bytes),
    );
    await tester.pumpAndSettle();
    expect(fixture.players, isEmpty);
    expect(files.paths, ['/gateway/clip.wav']);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('removal during local read or staging never starts playback', (
    tester,
  ) async {
    for (final staging in [false, true]) {
      final fixture = AudioFixture();
      final read = Completer<Uint8List>();
      final stage = Completer<AudioFixtureFile>();
      if (staging) {
        fixture.store.stageGate = stage;
      } else {
        fixture.store.readGate = read;
      }
      await tester.pumpWidget(
        _app(
          fixture,
          const AttachmentAudioPreview(
            sourceIdentity: 'draft',
            extension: 'wav',
            localPath: '/private/cache/clip.wav',
          ),
        ),
      );
      await tester.tap(find.byKey(_play));
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      final file = AudioFixtureFile();
      if (staging) {
        stage.complete(file);
      } else {
        read.complete(_bytes);
      }
      await tester.pumpAndSettle();
      expect(fixture.players, isEmpty);
      expect(file.closes, staging ? 1 : 0);
    }
  });

  testWidgets(
    'native initialization timeout fences late success and joins disposal before deletion',
    (tester) async {
      final fixture = AudioFixture();
      final player = AudioFixturePlayer()
        ..sourceGate = Completer<void>()
        ..disposeGate = Completer<void>();
      fixture.makePlayer = () => player;
      await tester.pumpWidget(
        _app(
          fixture,
          AttachmentAudioPreview(
            sourceIdentity: 'draft',
            extension: 'wav',
            loadBytes: () async => _bytes,
          ),
        ),
      );
      await tester.tap(find.byKey(_play));
      await tester.pump();
      await tester.pump(const Duration(seconds: 21));
      expect(find.byKey(const Key('attachment-audio-error')), findsOneWidget);
      expect(fixture.store.files.single.closes, 0);
      expect(player.disposals, 0);
      player.sourceGate!.complete();
      await tester.pump();
      expect(player.plays, 0);
      expect(player.disposals, 1);
      expect(fixture.store.files.single.closes, 0);
      player.disposeGate!.complete();
      await tester.pumpAndSettle();
      expect(fixture.store.files.single.closes, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets('codec failure keeps save/share fallback and offers retry', (
    tester,
  ) async {
    final fixture = AudioFixture()
      ..makePlayer = () =>
          AudioFixturePlayer()
            ..sourceError = UnsupportedError('sensitive native detail');
    await tester.pumpWidget(
      _app(
        fixture,
        MediaArtifactCard(
          ref: const MediaTagRef(path: '/gateway/unsupported.opus'),
          filesClient: () => _Files(),
          sourceIdentity: 'a',
        ),
      ),
    );
    await tester.tap(find.byKey(_play));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('attachment-audio-error')), findsOneWidget);
    expect(find.byTooltip('Retry'), findsOneWidget);
    expect(find.textContaining('sensitive native detail'), findsNothing);
    expect(find.byTooltip('Download'), findsOneWidget);
    expect(find.byTooltip('Share'), findsOneWidget);
    expect(fixture.players.single.disposals, 1);
    expect(fixture.store.files.single.closes, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('a slow older Play tap cannot steal a newer attachment player', (
    tester,
  ) async {
    final fixture = AudioFixture();
    final pending = Completer<Uint8List>();
    await tester.pumpWidget(
      _app(
        fixture,
        Column(
          children: [
            AttachmentAudioPreview(
              sourceIdentity: 'a',
              extension: 'wav',
              loadBytes: () => pending.future,
            ),
            AttachmentAudioPreview(
              sourceIdentity: 'b',
              extension: 'wav',
              loadBytes: () async => _bytes,
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.byKey(_play).first);
    await tester.pump();
    await tester.tap(find.byKey(_play).last);
    await tester.pump();
    expect(fixture.players.single.plays, 1);
    pending.complete(_bytes);
    await tester.pumpAndSettle();
    expect(fixture.players.length, 2);
    expect(fixture.players[0].plays, 1);
    expect(fixture.players[0].pauses, 0);
    expect(fixture.players[1].plays, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  for (final cover in [false, true]) {
    testWidgets(
      'suspension revokes the initial held play intent (cover=$cover)',
      (tester) async {
        final fixture = AudioFixture();
        final player = AudioFixturePlayer()..sourceGate = Completer<void>();
        fixture.makePlayer = () => player;
        await tester.pumpWidget(
          _app(
            fixture,
            AttachmentAudioPreview(
              sourceIdentity: 'a',
              extension: 'wav',
              loadBytes: () async => _bytes,
            ),
          ),
        );
        await tester.tap(find.byKey(_play));
        await tester.pump();
        if (cover) {
          final context = tester.element(find.byType(AttachmentAudioPreview));
          unawaited(
            showDialog<void>(
              context: context,
              builder: (_) => const AlertDialog(content: Text('Covered')),
            ),
          );
          await tester.pump();
          Navigator.of(context).pop();
          // Finish the popup exit before releasing native initialization.
          await tester.pump(const Duration(seconds: 1));
        } else {
          tester.binding.handleAppLifecycleStateChanged(
            AppLifecycleState.inactive,
          );
          await tester.pump();
          tester.binding.handleAppLifecycleStateChanged(
            AppLifecycleState.resumed,
          );
          await tester.pump();
        }
        player.sourceGate!.complete();
        await tester.pumpAndSettle();
        try {
          expect(player.plays, 0);
          await tester.tap(find.byKey(_play));
          await tester.pumpAndSettle();
          expect(player.plays, 1);
        } finally {
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
        }
      },
    );
  }

  testWidgets(
    'late duration cannot overwrite a replacement source projection',
    (tester) async {
      final fixture = AudioFixture();
      final old = AudioFixturePlayer()..durationGate = Completer<Duration?>();
      var creates = 0;
      fixture.makePlayer = () => creates++ == 0 ? old : AudioFixturePlayer();
      Future<void> build(String owner) => tester.pumpWidget(
        _app(
          fixture,
          AttachmentAudioPreview(
            sourceIdentity: owner,
            extension: 'wav',
            loadBytes: () async => _bytes,
          ),
        ),
      );
      await build('a');
      await tester.tap(find.byKey(_play));
      await tester.pump();
      await build('b');
      await tester.tap(find.byKey(_play));
      await tester.pumpAndSettle();
      old.durationGate!.complete(const Duration(seconds: 99));
      await tester.pump();
      fixture.players.last.positions.add(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text('0:02 / 0:10'), findsOneWidget);
      expect(find.text('0:02 / 1:39'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'native duration stream errors are sanitized and handled, not zone errors',
    (tester) async {
      final fixture = AudioFixture();
      await tester.pumpWidget(
        _app(
          fixture,
          AttachmentAudioPreview(
            sourceIdentity: 'a',
            extension: 'wav',
            loadBytes: () async => _bytes,
          ),
        ),
      );
      await tester.tap(find.byKey(_play));
      await tester.pumpAndSettle();
      fixture.players.single.durations.addError(
        StateError('sensitive codec detail'),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('attachment-audio-error')), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(fixture.players.single.disposals, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'retained card owner replacement joins a held play then disposes its source',
    (tester) async {
      final fixture = AudioFixture();
      final player = AudioFixturePlayer()..playGate = Completer<void>();
      fixture.makePlayer = () => player;
      final files = _Files();
      Future<void> build(String owner) => tester.pumpWidget(
        _app(
          fixture,
          MediaArtifactCard(
            ref: const MediaTagRef(path: '/gateway/clip.wav'),
            filesClient: () => files,
            sourceIdentity: owner,
          ),
        ),
      );
      await build('a');
      await tester.tap(find.byKey(_play));
      await tester.pump();
      expect(player.plays, 1);
      await build('b');
      expect(player.disposals, 0);
      expect(fixture.store.files.single.closes, 0);
      player.playGate!.complete();
      await tester.pumpAndSettle();
      expect(player.pauses, greaterThanOrEqualTo(1));
      expect(player.disposals, 1);
      expect(fixture.store.files.single.closes, 1);
      expect(find.byTooltip('Play'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets('covering popup pauses; closing it does not resume audio', (
    tester,
  ) async {
    final fixture = AudioFixture();
    await tester.pumpWidget(
      _app(
        fixture,
        AttachmentAudioPreview(
          sourceIdentity: 'a',
          extension: 'wav',
          loadBytes: () async => _bytes,
        ),
      ),
    );
    await tester.tap(find.byKey(_play));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(AttachmentAudioPreview));
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => const AlertDialog(content: Text('Covered')),
      ),
    );
    await tester.pumpAndSettle();
    expect(fixture.players.single.pauses, 1);
    Navigator.of(context).pop();
    await tester.pumpAndSettle();
    expect(fixture.players.single.plays, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets(
    'background pause does not autoplay on resume; peer play pauses previous',
    (tester) async {
      final fixture = AudioFixture();
      await tester.pumpWidget(
        _app(
          fixture,
          Column(
            children: [
              for (final id in ['a', 'b'])
                AttachmentAudioPreview(
                  sourceIdentity: id,
                  extension: 'wav',
                  loadBytes: () async => _bytes,
                ),
            ],
          ),
        ),
      );
      await tester.tap(find.byKey(_play).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_play).last);
      await tester.pumpAndSettle();
      expect(fixture.players[0].pauses, 1);
      expect(fixture.players[1].plays, 1);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pumpAndSettle();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(fixture.players[1].pauses, 1);
      expect(fixture.players.map((p) => p.plays), [1, 1]);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );
}
