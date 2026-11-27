import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/os_intake.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/attachment_draft_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_files_client.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/attachment_audio_preview.dart';
import 'package:hermes_android/core/widgets/attachment_preview_dialog.dart';
import 'package:hermes_android/core/widgets/media_artifact_card.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/audio_preview_fixture.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

SavedConnection _connection() => SavedConnection(
  id: 'audio-integration',
  label: 'Audio fixture',
  host: 'audio.fixture',
  port: 9119,
  apiKey: 'synthetic',
  desktopGatewayUrl: 'http://audio.fixture:9119',
  singleLogin: true,
  signInMethod: 'none',
  dashboardProxied: true,
  gatewayProfile: 'work',
);

class _Drafts extends AttachmentDraftService {
  int prepares = 0;
  int removes = 0;
  @override
  Future<AttachmentDraft> prepareGenericFile({
    required String sourcePath,
    required String displayName,
    String mediaType = 'application/octet-stream',
    required Iterable<AttachmentDraft> existingDrafts,
    int maxFileBytes = maxGenericAttachmentBytes,
    int maxTotalBytes = maxRemoteAttachmentDraftBytes,
  }) async {
    prepares++;
    return AttachmentDraft(
      id: 'picked-$prepares',
      cachedPath: '/private/cache/picked-$prepares.bin',
      name: displayName,
      byteLength: 3,
      mediaType: mediaType,
      kind: AttachmentDraftKind.genericFile,
    );
  }

  @override
  Future<void> removeCachedFile(AttachmentDraft draft) async {
    removes++;
  }
}

class _Gateway extends NextGenGateway {
  _Gateway(DashboardClient dashboard)
    : super(_connection(), dashboard: dashboard);
  @override
  RemoteFilesClient createFilesClient({
    String? sessionId,
    int? maxDownloadBytes,
  }) => RemoteFilesClient(
    dashboard: dashboard,
    profile: profile,
    sessionId: sessionId,
    maxDownloadBytes: maxDownloadBytes,
  );
  final calls = <String>[];
  final current = WsClient('http://audio.fixture:9119');
  @override
  WsClient? get socket => current;
  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    calls.add(method);
    return {};
  }
}

class _Files extends Fake implements RemoteFilesDataSource {
  final paths = <String>[];
  @override
  Future<RemoteFileDownload> download(String path) async {
    paths.add(path);
    return RemoteFileDownload(
      filename: 'clip.wav',
      bytes: Uint8List.fromList([1, 2, 3]),
    );
  }
}

Future<void> _pump(
  WidgetTester tester,
  AudioFixture audio,
  bool nextgen, {
  required _Drafts drafts,
  List<Map<String, dynamic>> rows = const [],
  _Files? files,
  void Function(NgChatController)? onChat,
}) async {
  await tester.binding.setSurfaceSize(const Size(1000, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final prefs = await SharedPreferences.getInstance();
  final client = MockClient((request) async {
    if (request.url.path.endsWith('/messages')) {
      return http.Response(jsonEncode({'data': rows}), 200);
    }
    if (request.url.path.contains('fs/download')) {
      expectSync(request.url.queryParameters['session_id'], 'audio-chat');
      expectSync(request.url.queryParameters['profile'], 'work');
      expectSync(request.url.queryParameters.containsKey('api_key'), isFalse);
      expectSync(
        request.headers['X-Hermes-Session-Token'],
        'fixture-deployment-only',
      );
      expectSync(
        request.url.toString(),
        isNot(contains('fixture-deployment-only')),
      );
      files?.paths.add(request.url.queryParameters['path']!);
      return http.Response.bytes(
        [1, 2, 3],
        200,
        headers: {
          'content-type': 'audio/wav',
          'content-disposition': 'attachment; filename="clip.wav"',
        },
      );
    }
    return http.Response('{}', 200);
  });
  Widget home;
  if (nextgen) {
    final gateway = _Gateway(
      DashboardClient(
        host: 'audio.fixture',
        proxied: true,
        httpClient: client,
        deploymentToken: 'fixture-deployment-only',
      ),
    );
    final chat =
        NgChatController(
            gateway,
            sessionId: 'audio-chat',
            attachmentService: drafts,
          )
          ..runtimeId = 'runtime-audio'
          ..debugApplyHistory(rows);
    onChat?.call(chat);
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    home = NgScope(
      connManager: ConnectionManager(prefs),
      gateway: gateway,
      connections: [gateway.connection],
      switchTo: (_) async {},
      addGateway: () async {},
      signOut: (_) async {},
      reload: () async {},
      signInAgain: () async {},
      child: Scaffold(
        body: NgChatView(chat: chat, onOpenSidebar: () {}, onNewChat: () {}),
      ),
    );
    addTearDown(() => expect(gateway.calls, isNot(contains('prompt.submit'))));
    addTearDown(() => expect(gateway.calls, isNot(contains('file.attach'))));
  } else {
    home = ChatScreen(
      connection: _connection(),
      session: const Session(
        id: 'audio-chat',
        title: 'Audio',
        model: 'fixture',
        source: 'desktop',
        messageCount: 2,
        isActive: false,
        preview: '',
        startedAt: 1,
      ),
      testApiClient: ApiClient(
        baseUrl: 'http://audio.fixture',
        apiKey: 'synthetic',
        httpClient: client,
      ),
      testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
      testAttachmentDraftService: drafts,
      testMediaFilesClient: files == null ? null : (_) => files,
    );
  }
  await tester.pumpWidget(
    audio.wrap(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: nextgen
            ? nextGenTheme(Brightness.dark, NextGenLook.instance)
            : null,
        home: home,
      ),
    ),
  );
  await pumpChatUpdates(tester);
}

void main() {
  setUp(mockChatImageRecovery);
  setUp(() => SharedPreferences.setMockInitialValues({'verbose_mode': false}));
  testWidgets(
    'NextGen inline audio popup belongs to the origin row, not the root navigator',
    (tester) async {
      final audio = AudioFixture();
      final files = _Files();
      late NgChatController chat;
      await _pump(
        tester,
        audio,
        true,
        drafts: _Drafts(),
        files: files,
        onChat: (value) => chat = value,
        rows: [
          {'id': 1, 'role': 'user', 'content': 'Make audio'},
          {
            'id': 2,
            'role': 'assistant',
            'content': '[clip](/gateway/clip.wav)',
            'finish_reason': 'stop',
          },
        ],
      );
      await tester.tap(find.text('clip', findRichText: true));
      await pumpChatUpdates(tester);
      expect(find.byType(AttachmentPreviewDialog), findsOneWidget);
      expect(
        audio.players,
        isEmpty,
        reason: 'Opening a preview never autoplays.',
      );
      await tester.tap(
        find.descendant(
          of: find.byType(AttachmentPreviewDialog),
          matching: find.byKey(const Key('attachment-audio-play-pause')),
        ),
      );
      await tester.pumpAndSettle();
      expect(audio.players.single.plays, 1);
      chat.debugApplyHistory([
        {'id': 1, 'role': 'user', 'content': 'Make audio'},
        {
          'id': 2,
          'role': 'assistant',
          'content': 'The file was removed.',
          'finish_reason': 'stop',
        },
      ]);
      // debugApplyHistory deliberately does not notify its consumer (unlike
      // reloadTranscript); rebuild the real retained view with that snapshot.
      tester.element(find.byType(NgChatView)).markNeedsBuild();
      await tester.pumpAndSettle();
      expect(find.byType(AttachmentPreviewDialog), findsNothing);
      expect(audio.players.single.disposals, 1);
      expect(audio.store.files.single.closes, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'NextGen owner removal under another popup fences held native audio initialization',
    (tester) async {
      final audio = AudioFixture();
      final player = AudioFixturePlayer()..sourceGate = Completer<void>();
      audio.makePlayer = () => player;
      late NgChatController chat;
      await _pump(
        tester,
        audio,
        true,
        drafts: _Drafts(),
        files: _Files(),
        onChat: (value) => chat = value,
        rows: [
          {'id': 1, 'role': 'user', 'content': 'Make audio'},
          {
            'id': 2,
            'role': 'assistant',
            'content': '[clip](/gateway/clip.wav)',
            'finish_reason': 'stop',
          },
        ],
      );
      await tester.tap(find.text('clip', findRichText: true));
      await pumpChatUpdates(tester);
      await tester.tap(
        find.descendant(
          of: find.byType(AttachmentPreviewDialog),
          matching: find.byKey(const Key('attachment-audio-play-pause')),
        ),
      );
      await tester.pump();
      final context = tester.element(find.byType(AttachmentPreviewDialog));
      unawaited(
        showDialog<void>(
          context: context,
          builder: (_) => const AlertDialog(content: Text('Unrelated popup')),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      chat.debugApplyHistory([
        {'id': 1, 'role': 'user', 'content': 'Make audio'},
        {
          'id': 2,
          'role': 'assistant',
          'content': 'Removed',
          'finish_reason': 'stop',
        },
      ]);
      tester.element(find.byType(NgChatView)).markNeedsBuild();
      await tester.pumpAndSettle();
      expect(find.byType(AttachmentPreviewDialog), findsNothing);
      expect(find.text('Unrelated popup'), findsOneWidget);
      expect(player.disposals, 0);
      expect(audio.store.files.single.closes, 0);
      player.sourceGate!.complete();
      await tester.pumpAndSettle();
      expect(player.plays, 0);
      expect(player.disposals, 1);
      expect(audio.store.files.single.closes, 1);
      expect(find.text('Unrelated popup'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  for (final nextgen in [false, true]) {
    final layout = nextgen ? 'NextGen' : 'Classic';
    testWidgets(
      '$layout actual composer: picked audio preview preserves draft and removal releases player',
      (tester) async {
        final audio = AudioFixture();
        final drafts = _Drafts();
        await _pump(tester, audio, nextgen, drafts: drafts);
        final field = find.byKey(
          nextgen
              ? const ValueKey('ng-composer-field')
              : const Key('chat-message-composer'),
        );
        await tester.enterText(field, 'Keep this unsent text');
        tester.widget<OsFileDropTarget>(find.byType(OsFileDropTarget)).onFiles([
          const OsIntakeFile('/picked/clip.wav'),
        ]);
        await pumpChatUpdates(tester);
        expect(drafts.prepares, 1);
        expect(find.byType(AttachmentAudioPreview), findsOneWidget);
        expect(audio.players, isEmpty);
        await tester.tap(find.byKey(const Key('attachment-audio-play-pause')));
        await tester.pumpAndSettle();
        expect(audio.players.single.plays, 1);
        expect(audio.store.reads, ['/private/cache/picked-1.bin']);
        expect(
          tester.widget<TextField>(field).controller!.text,
          'Keep this unsent text',
        );
        if (nextgen) {
          tester.widget<InputChip>(find.byType(InputChip)).onDeleted!();
        } else {
          await tester.tap(find.byTooltip('Remove attachment'));
        }
        await tester.pumpAndSettle();
        expect(find.byType(AttachmentAudioPreview), findsNothing);
        expect(drafts.removes, 1);
        expect(audio.players.single.disposals, 1);
        expect(audio.store.files.single.closes, 1);
        expect(
          tester.widget<TextField>(field).controller!.text,
          'Keep this unsent text',
        );
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      },
    );
    for (final user in [true, false]) {
      testWidgets(
        '$layout ${user ? "user attachment" : "assistant delivery"} actual history wires authenticated file playback',
        (tester) async {
          final audio = AudioFixture();
          final files = _Files();
          await _pump(
            tester,
            audio,
            nextgen,
            drafts: _Drafts(),
            files: files,
            rows: [
              {
                'id': 1,
                'role': 'user',
                'content': user
                    ? 'Listen\n@file:/gateway/clip.wav'
                    : 'Make audio',
              },
              {
                'id': 2,
                'role': 'assistant',
                'content': user ? 'Acknowledged' : 'MEDIA:/gateway/clip.wav',
                'finish_reason': 'stop',
              },
            ],
          );
          expect(find.byType(MediaArtifactCard), findsOneWidget);
          expect(find.byType(AttachmentAudioPreview), findsOneWidget);
          expect(files.paths, isEmpty);
          expect(audio.players, isEmpty);
          await tester.tap(
            find.byKey(const Key('attachment-audio-play-pause')),
          );
          // The bounded HTTP stream joins root-zone cancellation before the
          // player can initialize; global animation idle alone cannot join it.
          await pumpChatUpdates(tester);
          expect(files.paths, ['/gateway/clip.wav']);
          expect(audio.players.single.plays, 1);
          await tester.tap(
            find.byKey(const Key('attachment-audio-play-pause')),
          );
          await tester.pumpAndSettle();
          expect(audio.players.single.pauses, 1);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
          expect(audio.players.single.disposals, 1);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
