// Transcript video: the speed buttons and the slider drive the real player,
// and the position and speed are remembered per source for the chat (and
// connection) the video was opened from, in Classic and NextGen.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/render/render_scope.dart';
import 'package:hermes_android/core/render/video_playback_memory.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/attachment_video_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/services/remote_files_client.dart';
import 'package:hermes_android/core/widgets/attachment_video_preview.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart'
    as platform;

import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

class _File implements AttachmentVideoFile {
  _File(this.id);
  final int id;

  @override
  File get file => File('/private/memory-video-$id/attachment.mp4');

  @override
  Future<void> close() async {}
}

class _Store extends AttachmentVideoFileStore {
  var _files = 0;

  @override
  Future<AttachmentVideoFile> stage(Uint8List data, String extension) async =>
      _File(++_files);
}

/// A native player that records what the widget asked of it.
class _Native extends platform.VideoPlayerPlatform {
  final streams = <int, StreamController<platform.VideoEvent>>{};
  final positions = <int, Duration>{};
  final seeks = <Duration>[];
  final speeds = <double>[];
  final plays = <int>[];
  var created = 0;

  @override
  Future<void> init() async {}

  @override
  Future<int?> createWithOptions(platform.VideoCreationOptions options) async {
    final id = ++created;
    streams[id] = StreamController<platform.VideoEvent>()
      ..add(
        platform.VideoEvent(
          eventType: platform.VideoEventType.initialized,
          duration: const Duration(seconds: 100),
          size: const Size(640, 360),
        ),
      );
    return id;
  }

  @override
  Stream<platform.VideoEvent> videoEventsFor(int playerId) =>
      streams[playerId]!.stream;

  @override
  Future<void> dispose(int playerId) async {
    await streams.remove(playerId)?.close();
  }

  @override
  Future<void> play(int playerId) async => plays.add(playerId);

  @override
  Future<void> pause(int playerId) async {}

  @override
  Future<void> seekTo(int playerId, Duration position) async {
    seeks.add(position);
    positions[playerId] = position;
  }

  @override
  Future<Duration> getPosition(int playerId) async =>
      positions[playerId] ?? Duration.zero;

  @override
  Future<void> setVolume(int playerId, double volume) async {}

  @override
  Future<void> setLooping(int playerId, bool looping) async {}

  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) async =>
      speeds.add(speed);

  @override
  Future<void> setMixWithOthers(bool mixWithOthers) async {}

  @override
  Widget buildViewWithOptions(platform.VideoViewOptions options) =>
      SizedBox(key: ValueKey('native-video-${options.playerId}'));
}

Future<void> _flush(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    tester.binding.scheduleForcedFrame();
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  }
}

Widget _player(String? scope, String source, _Store store) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: SizedBox(
      width: 600,
      height: 500,
      child: AttachmentVideoPreview(
        key: ValueKey('$scope/$source'),
        bytes: Uint8List.fromList([1, 2, 3]),
        extension: 'mp4',
        fileStore: store,
        playbackScope: scope,
        playbackSource: source,
      ),
    ),
  ),
);

Future<void> _seekToHalf(WidgetTester tester) async {
  final slider = find.byKey(const Key('attachment-video-seek'));
  await tester.tap(slider); // the slider's centre: half of 100 s
  await _flush(tester);
}

const _video = '/home/me/clips/demo.mp4';

/// App-private temporary storage for the real staging path of the preview.
class _Paths extends PathProviderPlatform {
  _Paths(this.temporary);
  final Directory temporary;

  @override
  Future<String?> getTemporaryPath() async => temporary.path;
}

class _Files extends RemoteFilesClient {
  _Files() : super(dashboard: DashboardClient(host: '10.0.0.5', port: 9119));

  @override
  Future<RemoteFileDownload> download(String path) async =>
      RemoteFileDownload(filename: 'demo.mp4', bytes: const [0, 0, 0, 24]);
}

class _Gateway extends NextGenGateway {
  _Gateway(String id)
    : super(
        SavedConnection(
          id: id,
          label: 'Home $id',
          host: '10.0.0.5',
          port: 9119,
          apiKey: 'k',
          desktopGatewayUrl: 'http://10.0.0.5:9119',
          singleLogin: true,
          signInMethod: 'none',
        ),
      );

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async => {};

  @override
  RemoteFilesClient createFilesClient({
    String? sessionId,
    int? maxDownloadBytes,
  }) => _Files();
}

class _History extends http.BaseClient {
  _History(this.rows);
  final List<Map<String, dynamic>> rows;

  http.StreamedResponse _json(Object body) => http.StreamedResponse(
    Stream.value(utf8.encode(jsonEncode(body))),
    200,
    headers: {'content-type': 'application/json'},
  );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final path = request.url.path;
    if (request.method == 'GET' && path.endsWith('/messages')) {
      final offset = int.parse(request.url.queryParameters['offset'] ?? '0');
      return _json({'data': offset == 0 ? rows : const []});
    }
    if (request.method == 'GET' && path.startsWith('/api/sessions/')) {
      return _json({
        'session': {'id': path.split('/').last, 'archived': false},
      });
    }
    return http.StreamedResponse(Stream.value(utf8.encode('{}')), 404);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late platform.VideoPlayerPlatform previous;
  late _Native native;

  setUp(mockChatImageRecovery);
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': true});
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
    VideoPlaybackMemory.reset();
    previous = platform.VideoPlayerPlatform.instance;
    native = _Native();
    platform.VideoPlayerPlatform.instance = native;
  });
  tearDown(() {
    platform.VideoPlayerPlatform.instance = previous;
    VideoPlaybackMemory.reset();
  });

  test('memory is per chat and per connection, and bounded', () {
    final chatA = 'cx\u0000\u0000chat-a';
    final chatB = 'cx\u0000\u0000chat-b';
    final otherGateway = 'cy\u0000\u0000chat-a';
    VideoPlaybackMemory.remember(
      chatA,
      _video,
      position: const Duration(seconds: 42),
      speed: 1.5,
    );
    expect(VideoPlaybackMemory.recall(chatA, _video)?.position.inSeconds, 42);
    expect(VideoPlaybackMemory.recall(chatB, _video), isNull);
    expect(VideoPlaybackMemory.recall(otherGateway, _video), isNull);
    expect(VideoPlaybackMemory.startSpeed(chatB, _video), 1);
    VideoPlaybackMemory.rememberSpeed(chatB, 2);
    expect(VideoPlaybackMemory.startSpeed(chatB, '/other.mp4'), 2);
    expect(VideoPlaybackMemory.startSpeed(chatA, '/other.mp4'), 1);
    for (var i = 0; i < 30; i++) {
      VideoPlaybackMemory.remember(
        chatA,
        '/clip-$i.mp4',
        position: const Duration(seconds: 1),
        speed: 1,
      );
    }
    expect(VideoPlaybackMemory.recall(chatA, _video), isNull);
    expect(VideoPlaybackMemory.recall(chatA, '/clip-29.mp4'), isNotNull);
  });

  testWidgets('speed and slider drive the player; reopening restores both', (
    tester,
  ) async {
    final store = _Store();
    const chat = 'cx\u0000\u0000chat-a';
    await tester.pumpWidget(_player(chat, _video, store));
    await _flush(tester);
    await tester.tap(find.byKey(const Key('attachment-video-speed-1.5')));
    await _flush(tester);
    await _seekToHalf(tester);
    expect(native.seeks.last.inSeconds, inInclusiveRange(45, 55));
    await tester.tap(find.byKey(const Key('attachment-video-play-pause')));
    await _flush(tester);
    // video_player applies a rate to the native player once it plays.
    expect(native.speeds.last, 1.5);
    final seekedTo = native.seeks.last;
    await tester.pumpWidget(const SizedBox());
    await _flush(tester);

    native.seeks.clear();
    native.speeds.clear();
    await tester.pumpWidget(_player(chat, _video, store));
    await _flush(tester);
    expect(native.seeks, [seekedTo], reason: 'restored position');
    final chip = tester.widget<ChoiceChip>(
      find.byKey(const Key('attachment-video-speed-1.5')),
    );
    expect(chip.selected, isTrue);
    expect(native.plays, hasLength(1), reason: 'restoring never plays');
    await tester.tap(find.byKey(const Key('attachment-video-play-pause')));
    await _flush(tester);
    expect(native.speeds.last, 1.5);
    await tester.pumpWidget(const SizedBox());
    await _flush(tester);
  });

  testWidgets('another chat or connection starts the same file fresh', (
    tester,
  ) async {
    final store = _Store();
    VideoPlaybackMemory.remember(
      'cx\u0000\u0000chat-a',
      _video,
      position: const Duration(seconds: 30),
      speed: 2,
    );
    for (final scope in [
      'cx\u0000\u0000chat-b',
      'cy\u0000\u0000chat-a',
      null,
    ]) {
      native.seeks.clear();
      await tester.pumpWidget(_player(scope, _video, store));
      await _flush(tester);
      expect(native.seeks, isEmpty, reason: '$scope');
      expect(
        tester
            .widget<ChoiceChip>(
              find.byKey(const Key('attachment-video-speed-1.0')),
            )
            .selected,
        isTrue,
        reason: '$scope',
      );
      await tester.pumpWidget(const SizedBox());
      await _flush(tester);
    }
  });

  void useTemporaryStorage() {
    final previousPaths = PathProviderPlatform.instance;
    final temporary = Directory.systemTemp.createTempSync('video-memory-');
    PathProviderPlatform.instance = _Paths(temporary);
    addTearDown(() {
      PathProviderPlatform.instance = previousPaths;
      temporary.deleteSync(recursive: true);
    });
  }

  Future<void> openFromCard(WidgetTester tester) async {
    final card = find.byKey(const Key('media-card-$_video'));
    await tester.ensureVisible(card);
    await tester.tap(
      find.descendant(of: card, matching: find.byType(ListTile)).first,
    );
    for (
      var i = 0;
      i < 20 &&
          find
              .byKey(const Key('attachment-video-play-pause'))
              .evaluate()
              .isEmpty;
      i++
    ) {
      await _flush(tester);
    }
    expect(
      find.byKey(const Key('attachment-video-play-pause')),
      findsOneWidget,
    );
  }

  Future<void> closePreview(WidgetTester tester) async {
    final navigator = tester.state<NavigatorState>(find.byType(Navigator).last);
    navigator.pop();
    await _flush(tester);
  }

  const reply = 'Here is the clip:\n\nMEDIA:$_video\n';

  testWidgets('NextGen: a chat remembers its own video speed', (tester) async {
    useTemporaryStorage();
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final gateway = _Gateway('c1');
    addTearDown(gateway.dispose);
    NgChatController open(String id) {
      final chat = NgChatController(gateway, sessionId: id)
        ..runtimeId = 'rt-$id';
      chat.debugApplyHistory([
        {'role': 'user', 'content': 'clip'},
        {'role': 'assistant', 'content': reply},
      ]);
      addTearDown(chat.dispose);
      return chat;
    }

    final prefs = await SharedPreferences.getInstance();
    Future<void> show(NgChatController chat) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: nextGenTheme(Brightness.light, NextGenLook.instance),
          home: NgScope(
            connManager: ConnectionManager(prefs),
            gateway: gateway,
            connections: [gateway.connection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: Scaffold(
              body: NgChatView(
                key: ObjectKey(chat),
                chat: chat,
                onOpenSidebar: () {},
                onNewChat: () {},
              ),
            ),
          ),
        ),
      );
      await _flush(tester);
    }

    final a = open('chat-a');
    final b = open('chat-b');
    await show(a);
    await openFromCard(tester);
    await tester.tap(find.byKey(const Key('attachment-video-speed-2.0')));
    await _flush(tester);
    await closePreview(tester);
    final scopeA = '${renderConnectionKey(gateway.connection)}\u0000chat-a';
    expect(VideoPlaybackMemory.startSpeed(scopeA, _video), 2);

    await openFromCard(tester);
    expect(
      tester
          .widget<ChoiceChip>(
            find.byKey(const Key('attachment-video-speed-2.0')),
          )
          .selected,
      isTrue,
    );
    await closePreview(tester);

    await show(b);
    await openFromCard(tester);
    expect(
      tester
          .widget<ChoiceChip>(
            find.byKey(const Key('attachment-video-speed-1.0')),
          )
          .selected,
      isTrue,
      reason: 'chat B starts at its own speed',
    );
    await closePreview(tester);
    await tester.pumpWidget(const SizedBox());
    await _flush(tester);
  });

  testWidgets('Classic: a chat remembers its own video speed', (tester) async {
    useTemporaryStorage();
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    Widget chat(String connectionId, String id) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChatScreen(
        key: ValueKey('$connectionId/$id'),
        connection: SavedConnection(
          id: connectionId,
          label: 'Fixture',
          host: 'fixture.invalid',
          port: 8642,
          apiKey: 'fixture-key',
        ),
        session: Session(
          id: id,
          title: 'Chat $id',
          model: 'fixture',
          source: 'api_server',
          messageCount: 2,
          isActive: false,
          preview: '',
          startedAt: 1,
        ),
        testApiClient: ApiClient(
          baseUrl: 'http://fixture.invalid',
          apiKey: 'fixture-key',
          httpClient: _History([
            {'id': 1, 'role': 'user', 'content': 'clip'},
            {'id': 2, 'role': 'assistant', 'content': reply},
          ]),
        ),
        testMediaFilesClient: (_) => _Files(),
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
      ),
    );

    await tester.pumpWidget(chat('cx', 'chat-a'));
    await pumpChatUpdates(tester);
    await openFromCard(tester);
    await tester.tap(find.byKey(const Key('attachment-video-speed-1.5')));
    await _flush(tester);
    await closePreview(tester);
    await openFromCard(tester);
    expect(
      tester
          .widget<ChoiceChip>(
            find.byKey(const Key('attachment-video-speed-1.5')),
          )
          .selected,
      isTrue,
    );
    await closePreview(tester);

    for (final (connection, id) in [('cx', 'chat-b'), ('cy', 'chat-a')]) {
      await tester.pumpWidget(chat(connection, id));
      await pumpChatUpdates(tester);
      await openFromCard(tester);
      expect(
        tester
            .widget<ChoiceChip>(
              find.byKey(const Key('attachment-video-speed-1.0')),
            )
            .selected,
        isTrue,
        reason: '$connection/$id',
      );
      await closePreview(tester);
    }
    await tester.pumpWidget(const SizedBox());
    await _flush(tester);
  });
}
