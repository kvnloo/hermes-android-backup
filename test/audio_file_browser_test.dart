import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/files_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_files_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'support/audio_preview_fixture.dart';

class _Files extends Fake implements RemoteFilesDataSource {
  int reads = 0;
  final downloads = <String>[];
  Completer<RemoteFileDownload>? pending;
  @override
  Future<RemoteDirectory> defaultDirectory() async =>
      const RemoteDirectory(path: '/gateway');
  @override
  Future<List<RemoteFileEntry>> listDirectory(String path) async => const [
    RemoteFileEntry(
      name: 'clip.wav',
      path: '/gateway/clip.wav',
      isDirectory: false,
    ),
  ];
  @override
  Future<RemoteTextPreview> readText(String path) async {
    reads++;
    throw StateError('Audio must not be sent to the text decoder');
  }

  @override
  Future<RemoteFileDownload> download(String path) async {
    downloads.add(path);
    return pending?.future ??
        RemoteFileDownload(filename: 'clip.wav', bytes: [1, 2, 3]);
  }
}

Widget _app(AudioFixture audio, _Files files) => audio.wrap(
  MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: FilesScreen(files: files),
  ),
);

void main() {
  testWidgets(
    'file browser selects audio without fetching, then plays and releases on Back',
    (tester) async {
      final audio = AudioFixture();
      final files = _Files();
      await tester.pumpWidget(_app(audio, files));
      await tester.pumpAndSettle();
      await tester.tap(find.text('clip.wav'));
      await tester.pumpAndSettle();
      expect(files.reads, 0);
      expect(files.downloads, isEmpty);
      expect(audio.players, isEmpty);
      await tester.tap(find.byKey(const Key('attachment-audio-play-pause')));
      await tester.pumpAndSettle();
      expect(files.downloads, ['/gateway/clip.wav']);
      expect(audio.players.single.plays, 1);
      expect(find.text('Download'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(audio.players.single.disposals, 1);
      expect(audio.store.files.single.closes, 1);
      expect(
        find.byKey(const Key('attachment-audio-play-pause')),
        findsNothing,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'file-browser owner replacement rejects a late old audio download',
    (tester) async {
      final audio = AudioFixture();
      final old = _Files()..pending = Completer<RemoteFileDownload>();
      final fresh = _Files();
      await tester.pumpWidget(_app(audio, old));
      await tester.pumpAndSettle();
      await tester.tap(find.text('clip.wav'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('attachment-audio-play-pause')));
      await tester.pump();
      await tester.pumpWidget(_app(audio, fresh));
      old.pending!.complete(
        RemoteFileDownload(filename: 'clip.wav', bytes: [1, 2, 3]),
      );
      await tester.pumpAndSettle();
      expect(audio.players, isEmpty);
      expect(fresh.downloads, isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  test(
    'browser preview imposes a streaming budget even when Save client is unbounded',
    () async {
      var consumed = false;
      final source = RemoteFilesClient(
        profile: 'work',
        sessionId: 'stored',
        dashboard: DashboardClient(
          host: 'audio.fixture',
          deploymentToken: 'synthetic-only',
          httpClient: MockClient.streaming((request, _) async {
            expect(request.url.queryParameters['profile'], 'work');
            expect(request.url.queryParameters['session_id'], 'stored');
            expect(request.headers['X-Hermes-Session-Token'], 'synthetic-only');
            expect(request.url.toString(), isNot(contains('synthetic-only')));
            return http.StreamedResponse(
              Stream<List<int>>.multi((sink) {
                consumed = true;
                sink.add([1]);
                sink.close();
              }),
              200,
              contentLength: maxAttachmentDownloadBytes + 1,
            );
          }),
        ),
      );
      addTearDown(source.close);
      await expectLater(
        source.downloadPreview('/gateway/clip.wav'),
        throwsA(isA<DownloadSizeLimitException>()),
      );
      expect(
        consumed,
        isTrue,
        reason: 'Oversized response is canceled without buffering its payload.',
      );
    },
  );
}
