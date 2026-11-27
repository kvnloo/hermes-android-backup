// Inline Embeds, matching Hermes Desktop (re-check probe R4 made
// permanent). Every request the app makes goes through a recording
// HttpOverrides: Ask fetches nothing until the reader chooses, Always
// fetches only https from the image or provider hosts, Off fetches nothing,
// and links stay tappable in every mode, in both layouts.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/l10n/l10n.dart';
import 'package:hermes_android/core/presentation/inline_embeds.dart';
import 'package:hermes_android/core/presentation/presentation_scope.dart';
import 'package:hermes_android/core/presentation/presentation_settings.dart';
import 'package:hermes_android/core/presentation/reading_controls.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

// ------------------------------------------------------ recording network --

final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

typedef _Answer = ({int status, List<int> body, String? location});

/// Answers like the real services would, and records every request.
class _Recorder extends HttpOverrides {
  final requests = <Uri>[];

  /// Per-URL answers that replace the defaults below.
  final answers = <String, _Answer>{};

  _Answer serve(Uri uri) {
    if (answers['$uri'] case final answer?) return answer;
    final (:status, :body) = _serve(uri);
    return (status: status, body: body, location: null);
  }

  ({int status, List<int> body}) _serve(Uri uri) {
    if (uri.path.endsWith('/oembed')) {
      return (
        status: 200,
        body: utf8.encode(
          jsonEncode({
            'title': 'Fixture video title',
            'author_name': 'Fixture channel',
            'thumbnail_url': 'https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
          }),
        ),
      );
    }
    if (uri.path.endsWith('.png') || uri.path.endsWith('.jpg')) {
      return (status: 200, body: _png);
    }
    return (status: 404, body: const []);
  }

  Set<String> get hosts => {for (final uri in requests) uri.host};

  @override
  HttpClient createHttpClient(SecurityContext? context) => _Client(this);
}

class _Client implements HttpClient {
  _Client(this.owner);
  final _Recorder owner;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    owner.requests.add(url);
    return _Request(owner.serve(url));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isSetter || invocation.isGetter) return null;
    if (invocation.memberName == #close) return null;
    // Any other way of opening a request is recorded as a failure.
    owner.requests.add(Uri.parse('unexpected://${invocation.memberName}'));
    throw const SocketException('Unexpected request in this test.');
  }
}

class _Headers implements HttpHeaders {
  _Headers([this.location]);
  final String? location;

  @override
  String? value(String name) =>
      name == HttpHeaders.locationHeader ? location : null;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Request implements HttpClientRequest {
  _Request(this.answer);
  final _Answer answer;

  @override
  HttpHeaders get headers => _Headers();

  // A 200 whose body is listed under status 2000 streams without a length.
  @override
  Future<HttpClientResponse> close() async => answer.status == 2000
      ? _Response((
          status: 200,
          body: answer.body,
          location: null,
        ), declaredLength: -1)
      : _Response(answer);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Response extends Stream<List<int>> implements HttpClientResponse {
  _Response(this.answer, {this.declaredLength});
  final _Answer answer;
  final int? declaredLength;

  @override
  int get statusCode => answer.status;

  /// -1 (unknown) for a body streamed without a length.
  @override
  int get contentLength => declaredLength ?? answer.body.length;

  @override
  HttpHeaders get headers => _Headers(answer.location);

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => Stream<List<int>>.value(answer.body).listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

_Recorder _record() {
  final recorder = _Recorder();
  final previous = HttpOverrides.current;
  HttpOverrides.global = recorder;
  addTearDown(() => HttpOverrides.global = previous);
  return recorder;
}

List<String> _launches() {
  const channel = MethodChannel('plugins.flutter.io/url_launcher');
  final opened = <String>[];
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(channel, (call) async {
    if (call.method == 'launch') {
      opened.add((call.arguments as Map)['url'] as String);
    }
    return true;
  });
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
  return opened;
}

// -------------------------------------------------------------- fixtures --

const _image = 'https://images.example.org/p.png';
const _youtube = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
const _reply =
    'Picture:\n\n'
    '![pixel]($_image)\n\n'
    '![insecure](http://plain.example.org/p.png)\n\n'
    'Watch $_youtube\n\n'
    'Labelled [clip](https://vimeo.com/76979871)\n\n'
    'Meet at https://maps.google.com/maps?q=Sydney+Opera+House\n\n'
    'Hostile https://eviltiktok.com/@a/video/123 and '
    'https://maps.google.evil.example/maps?q=Sydney\n';

Map<String, Object> _reading(InlineEmbedMode mode, {Set<String>? allowed}) => {
  ReadingControls.preferenceKey: jsonEncode({
    'chatFont': 'platform',
    'terminalFont': 'geistMono',
    'direction': 'automatic',
    'bubbleOpacity': 1,
    'embedMode': mode.name,
    'allowedEmbeds': [...?allowed],
    'emojiReactions': false,
    'celebrationHearts': false,
  }),
};

class _History extends http.BaseClient {
  _History(this.rows);
  final List<Map<String, dynamic>> rows;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.method == 'GET' && request.url.path.endsWith('/messages')) {
      return http.StreamedResponse(
        Stream.value(utf8.encode(jsonEncode({'data': rows}))),
        200,
        headers: {'content-type': 'application/json'},
      );
    }
    return http.StreamedResponse(Stream.value(utf8.encode('{}')), 404);
  }
}

/// Mounts the reply in the real chat view of [layout], tall enough that the
/// whole reply is laid out at once.
Future<void> _pumpChat(
  WidgetTester tester,
  String layout,
  SharedPreferences prefs,
) async {
  tester.view.physicalSize = const Size(1000, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  if (layout == 'nextgen') {
    final gateway = NextGenGateway(
      SavedConnection(
        id: 'c1',
        label: 'Home',
        host: '10.0.0.5',
        port: 9119,
        apiKey: 'k',
        desktopGatewayUrl: 'http://10.0.0.5:9119',
        singleLogin: true,
        signInMethod: 'none',
      ),
    );
    final chat = NgChatController(gateway, sessionId: 's')
      ..runtimeId = 'runtime-s'
      ..debugApplyHistory([
        {'role': 'user', 'content': 'Show me'},
        {'role': 'assistant', 'content': _reply},
      ]);
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: nextGenTheme(Brightness.light, NextGenLook.instance),
        builder: (context, child) =>
            PresentationRoot(preferences: prefs, child: child!),
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
    await tester.pump(const Duration(milliseconds: 300));
    return;
  }
  mockChatImageRecovery();
  final rows = [
    {'id': '1', 'role': 'user', 'content': 'Show me'},
    {'id': '2', 'role': 'assistant', 'content': _reply, 'completed': true},
  ];
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: preferredSupportedLocales(),
      localeListResolutionCallback: resolvePreferredLocale,
      builder: (context, child) =>
          PresentationRoot(preferences: prefs, child: child!),
      home: ChatScreen(
        connection: SavedConnection(
          id: 'home',
          label: 'Fixture',
          host: 'embeds.fixture',
          port: 8642,
          apiKey: 'k',
        ),
        session: Session(
          id: 'embeds',
          title: 'Fixture',
          model: 'fixture-model',
          source: 'api_server',
          messageCount: rows.length,
          isActive: false,
          preview: '',
          startedAt: 1,
        ),
        testApiClient: ApiClient(
          baseUrl: 'http://embeds.fixture',
          apiKey: 'k',
          httpClient: _History(rows),
        ),
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
      ),
    ),
  );
  await pumpChatUpdates(tester);
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Invokes the tap handler of the prose link whose text contains [needle].
bool _tapProseLink(WidgetTester tester, String needle) {
  for (final element in find.byType(RichText).evaluate()) {
    final paragraph = element.renderObject;
    if (paragraph is! RenderParagraph) continue;
    TapGestureRecognizer? recognizer;
    paragraph.text.visitChildren((span) {
      if (span is TextSpan &&
          (span.text ?? '').contains(needle) &&
          span.recognizer is TapGestureRecognizer) {
        recognizer = span.recognizer! as TapGestureRecognizer;
        return false;
      }
      return true;
    });
    if (recognizer?.onTap case final onTap?) {
      onTap();
      return true;
    }
  }
  return false;
}

Finder _key(String key) => find.byKey(ValueKey(key));

ReadingControls _controls(WidgetTester tester, String layout) =>
    ReadingControls.maybeOf(
      tester.element(
        find.byType(layout == 'nextgen' ? NgChatView : ChatScreen),
      ),
    )!;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
    debugResetEmbedPreviews();
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
  });

  group('provider matching', () {
    test('recognises every provider Desktop embeds', () {
      final cases = {
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ': 'youtube:dQw4w9WgXcQ',
        'https://youtu.be/dQw4w9WgXcQ?t=42': 'youtube:dQw4w9WgXcQ',
        'https://m.youtube.com/shorts/dQw4w9WgXcQ': 'youtube:dQw4w9WgXcQ',
        'https://music.youtube.com/watch?v=dQw4w9WgXcQ': 'youtube:dQw4w9WgXcQ',
        'https://vimeo.com/channels/staff/76979871': 'vimeo:76979871',
        'https://player.vimeo.com/video/76979871': 'vimeo:76979871',
        'https://www.instagram.com/reels/Cabc_12/': 'instagram:reel/Cabc_12',
        'https://www.pinterest.co.uk/pin/123456/': 'pinterest:123456',
        'https://www.tiktok.com/@someone/video/7234567890': 'tiktok:7234567890',
        'https://x.com/someone/status/1790000000000000000':
            'twitter:1790000000000000000',
        'https://mobile.twitter.com/a/status/42': 'twitter:42',
        'https://open.spotify.com/intl-de/track/4uLU6hMCjMI75M1A2tKUQC':
            'spotify:track/4uLU6hMCjMI75M1A2tKUQC',
        'https://maps.google.com/maps?q=Sydney+Opera+House':
            'googlemaps:Sydney Opera House',
        'https://www.google.com.au/maps/place/Bondi+Beach/@-33.89,151.27,15z':
            'googlemaps:-33.89,151.27',
        'https://www.openstreetmap.org/#map=15/-33.8568/151.2153':
            'openstreetmap:-33.8568,151.2153',
      };
      for (final entry in cases.entries) {
        expect(detectEmbed(entry.key)?.id, entry.value, reason: entry.key);
      }
      expect(
        detectEmbed('https://twitter.com/a/status/1')?.host,
        'x.com',
        reason: 'X posts name the current brand',
      );
    });

    test('hostile and near-miss hosts never match', () {
      for (final url in [
        'https://eviltiktok.com/@a/video/123',
        'https://tiktok.com.evil.example/@a/video/123',
        'https://maps.google.evil.example/maps?q=Sydney',
        'https://google.evil.example/maps?q=Sydney',
        'https://notgoogle.com/maps?q=Sydney',
        'https://evilpinterest.com/pin/123',
        'https://pinterest.evil.example/pin/123',
        'https://youtube.com.evil.example/watch?v=dQw4w9WgXcQ',
        'https://notyoutube.com/watch?v=dQw4w9WgXcQ',
        'https://evilx.com/a/status/1',
        'https://x.com.evil.example/a/status/1',
        'https://open.spotify.com.evil.example/track/abc',
        'https://evil.open.spotify.com.example/track/abc',
        'https://user:pw@www.youtube.com/watch?v=dQw4w9WgXcQ',
        'ftp://www.youtube.com/watch?v=dQw4w9WgXcQ',
        'javascript:alert(1)',
        'https://www.google.com/search?q=maps',
        'https://www.youtube.com/watch?v=short',
      ]) {
        expect(detectEmbed(url), isNull, reason: url);
      }
      expect(hostIs('eviltiktok.com', 'tiktok.com'), isFalse);
      expect(hostIs('www.tiktok.com', 'tiktok.com'), isTrue);
      expect(hostIs('tiktok.com', 'tiktok.com'), isTrue);
    });

    test('only bare links become embeds; code and labels stay text', () {
      final found = bareProviderLinks(
        'A https://youtu.be/dQw4w9WgXcQ and www.youtube.com/watch?v=aaaaaaaaaaa '
        'but [labelled](https://vimeo.com/1) and `https://x.com/a/status/2`\n\n'
        '```\nhttps://open.spotify.com/track/abc\n```\n',
      );
      expect(found.map((e) => e.id), [
        'youtube:dQw4w9WgXcQ',
        'youtube:aaaaaaaaaaa',
      ]);
    });

    test('previews contact only the provider and its thumbnail CDN', () {
      final yt = EmbedProvider.youtube;
      expect(
        embedRequestAllowed(yt, Uri.parse('https://www.youtube.com/oembed')),
        isTrue,
      );
      expect(
        embedRequestAllowed(yt, Uri.parse('https://i.ytimg.com/vi/x/0.jpg')),
        isTrue,
      );
      for (final uri in [
        'http://www.youtube.com/oembed',
        'https://ytimg.com.evil.example/a.jpg',
        'https://www.youtube.com.evil.example/oembed',
        'https://tracker.example/pixel.png',
      ]) {
        expect(embedRequestAllowed(yt, Uri.parse(uri)), isFalse, reason: uri);
      }
      // No public endpoint: nothing to contact, nothing to consent to.
      expect(EmbedProvider.googleMaps.fetches, isFalse);
      expect(EmbedProvider.youtube.fetches, isTrue);
    });
  });

  group('capped https', () {
    bool any(Uri _) => true;

    test('refuses plain http, oversize bodies and http redirects', () async {
      final network = _record();
      Future<Object?> outcome(String url, {int max = 1024}) =>
          fetchCappedHttps(Uri.parse(url), maxBytes: max, allowed: any).then(
            (bytes) => bytes.length,
            onError: (Object error) => error.runtimeType.toString(),
          );

      expect(await outcome('http://images.example.org/p.png'), 'StateError');
      expect(network.requests, isEmpty, reason: 'http is never requested');

      final big = List<int>.filled(4096, 7);
      network.answers['https://big.example.org/declared'] = (
        status: 200,
        body: big,
        location: null,
      );
      network.answers['https://big.example.org/streamed'] = (
        status: 2000,
        body: big,
        location: null,
      );
      expect(await outcome('https://big.example.org/declared'), 'StateError');
      expect(await outcome('https://big.example.org/streamed'), 'StateError');
      expect(
        await outcome('https://big.example.org/streamed', max: 8192),
        4096,
      );

      network.answers['https://hop.example.org/a'] = (
        status: 302,
        body: const [],
        location: 'http://hop.example.org/b.png',
      );
      network.requests.clear();
      expect(await outcome('https://hop.example.org/a'), 'StateError');
      expect(network.requests.map((u) => '$u'), ['https://hop.example.org/a']);

      network.answers['https://hop.example.org/c'] = (
        status: 301,
        body: const [],
        location: '/d.png',
      );
      network.requests.clear();
      expect(await outcome('https://hop.example.org/c'), _png.length);
      expect(network.requests.map((u) => '$u'), [
        'https://hop.example.org/c',
        'https://hop.example.org/d.png',
      ]);
    });

    test('a provider thumbnail redirect off its CDN is refused', () async {
      final network = _record();
      network.answers['https://i.ytimg.com/vi/x/hqdefault.jpg'] = (
        status: 302,
        body: const [],
        location: 'https://tracker.example/pixel.png',
      );
      await expectLater(
        fetchCappedHttps(
          Uri.parse('https://i.ytimg.com/vi/x/hqdefault.jpg'),
          maxBytes: 1024,
          allowed: (uri) => embedRequestAllowed(EmbedProvider.youtube, uri),
        ),
        throwsStateError,
      );
      expect(network.hosts, {'i.ytimg.com'});
    });

    testWidgets('images decode no larger than the cap', (tester) async {
      final network = _record();
      late List<int> wide;
      await tester.runAsync(() async {
        final recorder = ui.PictureRecorder();
        Canvas(recorder).drawRect(
          const Rect.fromLTWH(0, 0, 400, 100),
          Paint()..color = const Color(0xFF336699),
        );
        final image = await recorder.endRecording().toImage(400, 100);
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();
        wide = png!.buffer.asUint8List();
      });
      network.answers['https://images.example.org/wide.png'] = (
        status: 200,
        body: wide,
        location: null,
      );
      final info = await tester.runAsync(() async {
        final done = Completer<ImageInfo>();
        final stream = CappedHttpsImage(
          Uri.parse('https://images.example.org/wide.png'),
          maxEdge: 40,
        ).resolve(ImageConfiguration.empty);
        final listener = ImageStreamListener(
          (info, _) => done.complete(info),
          onError: (Object error, _) => done.completeError(error),
        );
        stream.addListener(listener);
        try {
          return await done.future.timeout(const Duration(seconds: 10));
        } finally {
          stream.removeListener(listener);
        }
      });
      expect(info!.image.width, 40);
      expect(info.image.height, 10);
      info.dispose();
    });
  });

  group('settings', () {
    test('the old switch migrates: on is Always, off is Ask', () async {
      for (final (old, mode) in [
        (true, InlineEmbedMode.always),
        (false, InlineEmbedMode.ask),
      ]) {
        SharedPreferences.setMockInitialValues({
          ReadingControls.preferenceKey: jsonEncode({
            'chatFont': 'platform',
            'terminalFont': 'geistMono',
            'direction': 'automatic',
            'bubbleOpacity': 1,
            'externalEmbeds': old,
            'emojiReactions': false,
            'celebrationHearts': false,
          }),
        });
        final controls = ReadingControls(await SharedPreferences.getInstance());
        expect(controls.embedMode, mode);
        expect(controls.allowedEmbeds, isEmpty);
        controls.dispose();
      }
      SharedPreferences.setMockInitialValues({});
      final fresh = ReadingControls(await SharedPreferences.getInstance());
      expect(fresh.embedMode, InlineEmbedMode.ask, reason: 'Desktop default');
      fresh.dispose();
    });

    test('allowed services persist, validate, cap and reset', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final controls = ReadingControls(prefs);
      addTearDown(controls.dispose);
      await controls.allowEmbedService('youtube');
      await controls.allowEmbedService('youtube');
      await controls.allowEmbedService('image:images.example.org');
      await controls.allowEmbedService('image:Not A Host');
      await controls.allowEmbedService('');
      expect(controls.allowedEmbeds, {'youtube', 'image:images.example.org'});
      final again = ReadingControls(prefs);
      expect(again.allowedEmbeds, controls.allowedEmbeds);
      again.dispose();
      for (var i = 0; i < 80; i++) {
        await controls.allowEmbedService('image:h$i.example.org');
      }
      expect(
        controls.allowedEmbeds,
        hasLength(ReadingControls.maxAllowedEmbeds),
      );
      expect(controls.allowedEmbeds, contains('image:h79.example.org'));
      expect(controls.allowedEmbeds, isNot(contains('youtube')));
      await controls.resetAllowedEmbeds();
      expect(controls.allowedEmbeds, isEmpty);
    });

    testWidgets('Ask, Always, Off and "Reset N allowed services"', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues(
        _reading(InlineEmbedMode.ask, allowed: {'youtube', 'twitter'}),
      );
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              PresentationRoot(preferences: prefs, child: child!),
          home: Scaffold(
            body: ListView(
              children: [PresentationSettingsPanel(preferences: prefs)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final segmented = _key('presentation-embeds');
      await tester.ensureVisible(segmented);
      await tester.pumpAndSettle();
      expect(find.text('Inline embeds'), findsOneWidget);
      expect(
        find.textContaining('Ask shows a placeholder until you allow each one'),
        findsOneWidget,
      );
      final reading = ReadingControls.maybeOf(
        tester.element(find.byType(PresentationSettingsPanel)),
      )!;
      await tester.tap(
        find.descendant(of: segmented, matching: find.text('Always')),
      );
      await tester.pumpAndSettle();
      expect(reading.embedMode, InlineEmbedMode.always);
      await tester.tap(
        find.descendant(of: segmented, matching: find.text('Off')),
      );
      await tester.pumpAndSettle();
      expect(reading.embedMode, InlineEmbedMode.off);
      expect(find.text('Reset 2 allowed services'), findsOneWidget);
      await tester.tap(_key('presentation-embeds-reset'));
      await tester.pumpAndSettle();
      expect(reading.allowedEmbeds, isEmpty);
      expect(_key('presentation-embeds-reset'), findsNothing);
      expect(ReadingControls(prefs).allowedEmbeds, isEmpty);
      await tester.pumpWidget(const SizedBox());
    });
  });

  for (final layout in ['nextgen', 'classic']) {
    group('$layout transcript', () {
      testWidgets('Ask fetches nothing until Load or Always allow', (
        tester,
      ) async {
        final opened = _launches();
        SharedPreferences.setMockInitialValues(_reading(InlineEmbedMode.ask));
        final prefs = await SharedPreferences.getInstance();
        final network = _record();
        await _pumpChat(tester, layout, prefs);
        await _settle(tester);

        expect(network.requests, isEmpty, reason: 'nothing before a choice');
        // Each placeholder names its host.
        final image = _key('embed-placeholder-image:images.example.org');
        final video = _key('embed-placeholder-youtube');
        expect(image, findsOneWidget);
        expect(video, findsOneWidget);
        expect(
          find.descendant(of: image, matching: find.text('images.example.org')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: video, matching: find.text('youtube.com')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: video,
            matching: find.text('Always allow YouTube'),
          ),
          findsOneWidget,
        );
        // Plain http is a link, never a placeholder; labelled and hostile
        // links are not embeds.
        expect(
          _key('embed-link-http://plain.example.org/p.png'),
          findsOneWidget,
        );
        expect(_key('embed-placeholder-vimeo'), findsNothing);
        expect(_key('embed-placeholder-tiktok'), findsNothing);
        expect(_key('embed-placeholder-googlemaps'), findsNothing);
        // Maps has no keyless preview endpoint: a local card, no consent,
        // no request.
        expect(
          _key('embed-card-googlemaps:Sydney Opera House'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Google Maps · maps.google.com'),
          findsOneWidget,
        );

        // Load: this image only.

        await tester.tap(_key('embed-load-image:images.example.org'));
        await _settle(tester);
        expect(network.requests.map((u) => '$u'), [_image]);
        expect(video, findsOneWidget, reason: 'YouTube still waits');
        expect(
          _controls(tester, layout).allowedEmbeds,
          isEmpty,
          reason: 'Load is not Always allow',
        );

        // Always allow YouTube: its oEmbed title and thumbnail, nothing else.

        await tester.tap(_key('embed-allow-youtube'));
        await _settle(tester);
        expect(_controls(tester, layout).allowedEmbeds, {'youtube'});
        expect(video, findsNothing);
        expect(find.text('Fixture video title'), findsOneWidget);
        expect(network.hosts, {
          'images.example.org',
          'www.youtube.com',
          'i.ytimg.com',
        });
        expect(network.requests.every((u) => u.scheme == 'https'), isTrue);
        final oembed = network.requests.singleWhere((u) => u.path == '/oembed');
        expect(oembed.queryParameters['url'], _youtube);

        // The preview opens the link in the browser.
        await tester.tap(find.text('Fixture video title'));
        await tester.pump();
        expect(opened, contains(_youtube));

        // The prose link itself stays tappable.
        opened.clear();
        expect(_tapProseLink(tester, 'youtube.com/watch'), isTrue);
        await tester.pump();
        expect(opened, [_youtube]);

        // Reset puts YouTube back behind its placeholder.
        await _controls(tester, layout).resetAllowedEmbeds();
        await _settle(tester);
        expect(video, findsOneWidget);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('Always fetches only allowed https hosts', (tester) async {
        final opened = _launches();
        SharedPreferences.setMockInitialValues(
          _reading(InlineEmbedMode.always),
        );
        final prefs = await SharedPreferences.getInstance();
        final network = _record();
        await _pumpChat(tester, layout, prefs);
        await _settle(tester);

        expect(network.hosts, {
          'images.example.org',
          'www.youtube.com',
          'i.ytimg.com',
        });
        expect(network.requests.every((u) => u.scheme == 'https'), isTrue);
        for (final never in [
          'plain.example.org',
          'vimeo.com',
          'eviltiktok.com',
          'maps.google.evil.example',
        ]) {
          expect(network.hosts, isNot(contains(never)), reason: never);
        }
        expect(find.byType(Image), findsWidgets);
        expect(find.text('Fixture video title'), findsOneWidget);
        expect(_key('embed-placeholder-youtube'), findsNothing);
        // The prose link is still a link.
        expect(_tapProseLink(tester, 'youtube.com/watch'), isTrue);
        await tester.pump();
        expect(opened, [_youtube]);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('Off fetches nothing and keeps tappable links', (
        tester,
      ) async {
        final opened = _launches();
        SharedPreferences.setMockInitialValues(
          _reading(InlineEmbedMode.off, allowed: {'youtube'}),
        );
        final prefs = await SharedPreferences.getInstance();
        final network = _record();
        await _pumpChat(tester, layout, prefs);
        await _settle(tester);

        expect(network.requests, isEmpty);
        expect(_key('embed-placeholder-youtube'), findsNothing);
        expect(
          _key('embed-card-googlemaps:Sydney Opera House'),
          findsNothing,
          reason: 'Off keeps plain links',
        );
        expect(find.text('Fixture video title'), findsNothing);
        // The image is a link to itself.
        final link = _key('embed-link-$_image');
        expect(link, findsOneWidget);
        expect(
          find.descendant(of: link, matching: find.text('pixel')),
          findsOneWidget,
        );
        await tester.ensureVisible(link);
        await tester.tap(link);
        await tester.pump();
        expect(opened, [_image]);
        expect(_tapProseLink(tester, 'youtube.com/watch'), isTrue);
        await tester.pump();
        expect(opened, [_image, _youtube]);
        expect(network.requests, isEmpty);
        await tester.pumpWidget(const SizedBox());
      });
    });
  }
}
