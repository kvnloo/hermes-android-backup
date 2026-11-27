// Inline Embeds re-check of 29f578c5 (probes E1-E9 made permanent), plus
// the embed link colour. Every HttpClient call, header and client setting
// is recorded: Ask fetches nothing until the reader chooses, Always only
// contacts allowed https hosts, Off fetches nothing, links stay tappable,
// and a link the embed draws reads like the prose links around it.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:hermes_android/core/theme/hermes_theme.dart';
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

final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);
// IHDR says 30000 x 30000 (900 MP); a few bytes long.
final _hugePng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAdTAAAHUwCAIAAADpRW/tAAAAC0lEQVR4nGNgQAUAABAAATm9j2UAAAAASUVORK5CYII=',
);

class _Net extends HttpOverrides {
  final requests = <Uri>[];
  final log = <String>[];
  final headerWrites = <String>[];
  final clientSettings = <String>{};
  final redirects = <String, String>{};
  final bodies = <String, List<int>>{};
  final streamed = <String>{};

  ({int status, List<int> body, String? location, int? length}) serve(Uri uri) {
    final key = '$uri';
    if (redirects[key] case final to?) {
      return (status: 302, body: const [], location: to, length: 0);
    }
    if (bodies[key] case final body?) {
      return (
        status: 200,
        body: body,
        location: null,
        length: streamed.contains(key) ? -1 : body.length,
      );
    }
    if (uri.path.endsWith('/oembed') || uri.path.endsWith('oembed.json')) {
      final body = utf8.encode(
        jsonEncode({
          'title': 'Fixture title ${uri.host}',
          'author_name': 'Fixture author',
          'html':
              '<blockquote><p>Fixture post words</p></blockquote><script src="x"></script>',
          'thumbnail_url': uri.host == 'www.tiktok.com'
              ? 'https://p16.tiktokcdn.com/t.jpg'
              : uri.host == 'open.spotify.com'
              ? 'https://i.scdn.co/image/s.jpg'
              : 'https://tracker.example/thumb.jpg',
        }),
      );
      return (status: 200, body: body, location: null, length: body.length);
    }
    if (uri.path.endsWith('.png') || uri.path.endsWith('.jpg')) {
      return (status: 200, body: _png, location: null, length: _png.length);
    }
    return (status: 404, body: const [], location: null, length: 0);
  }

  Set<String> get hosts => {for (final u in requests) u.host};

  @override
  HttpClient createHttpClient(SecurityContext? context) => _Client(this);
}

class _Client implements HttpClient {
  _Client(this.net);
  final _Net net;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    net.requests.add(url);
    return _Req(net, net.serve(url));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isSetter) {
      net.clientSettings.add('${invocation.memberName}');
      return null;
    }
    if (invocation.isGetter) return null;
    if (invocation.memberName == #close) return null;
    net.log.add(
      'UNEXPECTED ${invocation.memberName} '
      '${invocation.positionalArguments}',
    );
    net.requests.add(Uri.parse('unexpected://${invocation.memberName}'));
    throw const SocketException('probe: unexpected request kind');
  }
}

class _Headers implements HttpHeaders {
  _Headers(this.net, [this.location]);
  final _Net? net;
  final String? location;
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) =>
      net?.headerWrites.add('set $name=$value');
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) =>
      net?.headerWrites.add('add $name=$value');
  @override
  String? value(String name) =>
      name == HttpHeaders.locationHeader ? location : null;
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isSetter) {
      net?.headerWrites.add('setter ${invocation.memberName}');
    }
    return null;
  }
}

class _Req implements HttpClientRequest {
  _Req(this.net, this.answer);
  final _Net net;
  final ({int status, List<int> body, String? location, int? length}) answer;
  late final _headers = _Headers(net);
  @override
  HttpHeaders get headers => _headers;
  @override
  List<Cookie> get cookies {
    net.headerWrites.add('cookies accessed');
    return [];
  }

  @override
  Future<HttpClientResponse> close() async => _Resp(answer);
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isSetter) {
      net.headerWrites.add('req.${invocation.memberName}');
    }
    return null;
  }
}

class _Resp extends Stream<List<int>> implements HttpClientResponse {
  _Resp(this.answer);
  final ({int status, List<int> body, String? location, int? length}) answer;
  @override
  int get statusCode => answer.status;
  @override
  int get contentLength => answer.length ?? answer.body.length;
  @override
  HttpHeaders get headers => _Headers(null, answer.location);
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    // Chunk the body so a byte cap is enforced while streaming.
    const size = 64 * 1024;
    final chunks = <List<int>>[
      for (var i = 0; i < answer.body.length; i += size)
        answer.body.sublist(
          i,
          i + size > answer.body.length ? answer.body.length : i + size,
        ),
    ];
    return Stream<List<int>>.fromIterable(chunks).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

_Net _record() {
  final net = _Net();
  final previous = HttpOverrides.current;
  HttpOverrides.global = net;
  addTearDown(() => HttpOverrides.global = previous);
  return net;
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

Map<String, Object> _reading(
  InlineEmbedMode? mode, {
  Set<String> allowed = const {},
  bool? legacy,
}) => {
  ReadingControls.preferenceKey: jsonEncode({
    'chatFont': 'platform',
    'terminalFont': 'geistMono',
    'direction': 'automatic',
    'bubbleOpacity': 1,
    'embedMode': ?mode?.name,
    'allowedEmbeds': ?(mode == null ? null : allowed.toList()),
    'externalEmbeds': ?legacy,
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

const _imgA = 'https://img-a.example.org/a.png';
const _imgB = 'https://img-b.example.org/b.png';
const _imgHttp = 'http://img-c.example.org/c.png';
const _yt1 = 'https://youtu.be/dQw4w9WgXcQ';
const _yt2 = 'https://www.youtube.com/watch?v=aaaaaaaaaaa';
const _x = 'https://x.com/someone/status/1790000000000000000';

const _replyMain =
    'Images:\n\n'
    '![first]($_imgA)\n\n'
    '![second]($_imgB)\n\n'
    '![plain]($_imgHttp)\n\n'
    '$_yt1\n\n'
    '$_yt2\n\n'
    '$_x\n';

const _hostile = [
  'https://eviltiktok.com/@a/video/123',
  'https://maps.google.evil.example/maps?q=Sydney',
  'https://tiktok.com.evil.example/@a/video/123',
];
const _replyHostile =
    'Hostile:\n\n'
    '${'https://eviltiktok.com/@a/video/123'}\n\n'
    '${'https://maps.google.evil.example/maps?q=Sydney'}\n\n'
    '${'https://tiktok.com.evil.example/@a/video/123'}\n';
const _replyGood =
    'Good:\n\n'
    'https://www.tiktok.com/@a/video/7234567890\n\n'
    'https://open.spotify.com/track/4uLU6hMCjMI75M1A2tKUQC\n';

Future<void> _pumpChat(
  WidgetTester tester,
  String layout,
  SharedPreferences prefs,
  String reply, {
  Brightness brightness = Brightness.dark,
  String user = 'Show me',
}) async {
  tester.view.physicalSize = const Size(1000, 4000);
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
        {'role': 'user', 'content': user},
        {'role': 'assistant', 'content': reply},
      ]);
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: nextGenTheme(brightness, NextGenLook.instance),
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
    {'id': '1', 'role': 'user', 'content': user},
    {'id': '2', 'role': 'assistant', 'content': reply, 'completed': true},
  ];
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: preferredSupportedLocales(),
      localeListResolutionCallback: resolvePreferredLocale,
      theme: hermesTheme(brightness),
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
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Fires the TapGestureRecognizer of the prose span containing [needle].
bool _tapProse(String needle) {
  for (final element in find.byType(RichText).evaluate()) {
    final p = element.renderObject;
    if (p is! RenderParagraph) continue;
    TapGestureRecognizer? r;
    p.text.visitChildren((span) {
      if (span is TextSpan &&
          (span.text ?? '').contains(needle) &&
          span.recognizer is TapGestureRecognizer) {
        r = span.recognizer! as TapGestureRecognizer;
        return false;
      }
      return true;
    });
    if (r?.onTap case final onTap?) {
      onTap();
      return true;
    }
  }
  return false;
}

Finder _k(String key) => find.byKey(ValueKey(key));

/// The colour of every painted run whose text contains [needle], inside
/// [within] when given.
List<Color> _inkOf(String needle, {Finder? within}) {
  final paragraphs = within == null
      ? find.byType(RichText)
      : find.descendant(of: within, matching: find.byType(RichText));
  final colors = <Color>[];
  for (final element in paragraphs.evaluate()) {
    final paragraph = element.renderObject;
    if (paragraph is! RenderParagraph) continue;
    void walk(InlineSpan span, TextStyle? inherited) {
      final style = inherited == null
          ? span.style
          : inherited.merge(span.style);
      if (span is! TextSpan) return;
      if ((span.text ?? '').contains(needle)) {
        colors.add(style?.color ?? const Color(0xFF000000));
      }
      for (final child in span.children ?? const <InlineSpan>[]) {
        walk(child, style);
      }
    }

    walk(paragraph.text, null);
  }
  return colors;
}

double _ratio(Color a, Color b) {
  final x = a.computeLuminance() + 0.05;
  final y = b.computeLuminance() + 0.05;
  return x > y ? x / y : y / x;
}

String _hex(Color c) => '#${c.toARGB32().toRadixString(16).padLeft(8, '0')}';

ReadingControls _controls(WidgetTester tester) =>
    ReadingControls.maybeOf(tester.element(find.byType(Scaffold).first))!;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
    debugResetEmbedPreviews();
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
  });

  test('E1 provider matching: exact host or subdomain only', () {
    final want = {
      'https://www.youtube.com/watch?v=dQw4w9WgXcQ': 'youtube:dQw4w9WgXcQ',
      'https://youtu.be/dQw4w9WgXcQ': 'youtube:dQw4w9WgXcQ',
      'https://WWW.YOUTUBE.COM./watch?v=dQw4w9WgXcQ': 'youtube:dQw4w9WgXcQ',
      'https://www.tiktok.com/@a/video/7234567890': 'tiktok:7234567890',
      'https://maps.google.com/maps?q=Sydney': 'googlemaps:Sydney',
    };
    final got = {for (final u in want.keys) u: detectEmbed(u)?.id};
    final hostile = [
      ..._hostile,
      'https://www.youtube.com.evil.example/watch?v=dQw4w9WgXcQ',
      'https://youtu.be.evil.example/dQw4w9WgXcQ',
      'https://evil.example/https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'https://www.youtube.com@evil.example/watch?v=dQw4w9WgXcQ',
      'https://xyoutube.com/watch?v=dQw4w9WgXcQ',
      'https://www.google.com.evil.example/maps?q=Sydney',
      'https://open.spotify.com.evil.example/track/4uLU6hMCjMI75M1A2tKUQC',
      'https://evilx.com/a/status/1',
      'https://notvimeo.com/76979871',
    ];
    final leaked = {for (final u in hostile) u: detectEmbed(u)?.id}
      ..removeWhere((_, v) => v == null);
    expect(got, want);
    expect(leaked, isEmpty);
    expect(hostIs('eviltiktok.com', 'tiktok.com'), isFalse);
    expect(hostIs('maps.google.evil.example', 'google.com'), isFalse);
    expect(hostIs('tiktok.com.evil.example', 'tiktok.com'), isFalse);
    expect(hostIs('www.youtube.com', 'youtube.com'), isTrue);
    expect(hostIs('youtu.be', 'youtu.be'), isTrue);
  });

  test(
    'E2 migration: old switch on -> Always, off -> Ask; default Ask',
    () async {
      final out = <String, String>{};
      for (final legacy in [true, false]) {
        SharedPreferences.setMockInitialValues(_reading(null, legacy: legacy));
        final prefs = await SharedPreferences.getInstance();
        final c = ReadingControls(prefs);
        out['legacy=$legacy'] = c.embedMode.name;
        // A write re-encodes in the new shape.
        await c.setEmojiReactions(true);
        final stored =
            jsonDecode(prefs.getString(ReadingControls.preferenceKey)!) as Map;
        out['stored legacy=$legacy'] =
            'embedMode=${stored['embedMode']} externalEmbeds=${stored['externalEmbeds']}';
        expect(ReadingControls(prefs).embedMode.name, out['legacy=$legacy']);
        c.dispose();
      }
      SharedPreferences.setMockInitialValues({});
      final fresh = ReadingControls(await SharedPreferences.getInstance());
      out['fresh'] = fresh.embedMode.name;
      fresh.dispose();
      expect(out['legacy=true'], 'always', reason: jsonEncode(out));
      expect(out['legacy=false'], 'ask');
      expect(out['fresh'], 'ask');
    },
  );

  for (final layout in ['nextgen', 'classic']) {
    testWidgets('E3 $layout Ask: nothing until Load/Always, per service', (
      tester,
    ) async {
      final opened = _launches();
      SharedPreferences.setMockInitialValues(_reading(InlineEmbedMode.ask));
      final prefs = await SharedPreferences.getInstance();
      final net = _record();
      await _pumpChat(tester, layout, prefs, _replyMain);
      await _settle(tester);
      final steps = <String, Object?>{};
      steps['initial'] = net.requests.map((u) => '$u').toList();
      steps['placeholders'] = {
        for (final k in [
          'embed-placeholder-image:img-a.example.org',
          'embed-placeholder-image:img-b.example.org',
          'embed-placeholder-image:img-c.example.org',
          'embed-placeholder-youtube',
          'embed-placeholder-twitter',
        ])
          k: _k(k).evaluate().length,
      };
      steps['httpImageLink'] = _k('embed-link-$_imgHttp').evaluate().length;
      expect(net.requests, isEmpty, reason: 'Ask fetched before a choice');

      // Load image A only.
      await tester.tap(_k('embed-load-image:img-a.example.org'));
      await _settle(tester);
      steps['afterLoadA'] = net.requests.map((u) => '$u').toList();
      expect(net.requests.map((u) => '$u'), [_imgA]);

      // Always allow img-b.
      await tester.tap(_k('embed-allow-image:img-b.example.org'));
      await _settle(tester);
      steps['afterAllowB'] = net.requests.map((u) => '$u').toList();
      steps['allowedAfterB'] = _controls(tester).allowedEmbeds.toList();
      expect(net.hosts, {'img-a.example.org', 'img-b.example.org'});

      // Load the first YouTube only.
      final ytLoads = _k('embed-load-youtube');
      steps['ytLoadButtons'] = ytLoads.evaluate().length;
      await tester.tap(ytLoads.first);
      await _settle(tester);
      steps['afterLoadYt1'] = net.requests.map((u) => '$u').toList();
      steps['ytPlaceholdersLeft'] = _k(
        'embed-placeholder-youtube',
      ).evaluate().length;
      expect(net.hosts.contains('publish.twitter.com'), isFalse);

      // Always allow YouTube: the second loads, X still waits.
      await tester.tap(_k('embed-allow-youtube').first);
      await _settle(tester);
      steps['afterAllowYt'] = net.requests.map((u) => '$u').toList();
      steps['allowed'] = _controls(tester).allowedEmbeds.toList();
      steps['twitterPlaceholder'] = _k(
        'embed-placeholder-twitter',
      ).evaluate().length;
      expect(net.hosts.contains('publish.twitter.com'), isFalse);
      expect(
        net.hosts.difference({
          'img-a.example.org',
          'img-b.example.org',
          'www.youtube.com',
          'i.ytimg.com',
        }),
        isEmpty,
      );
      expect(net.requests.every((u) => u.scheme == 'https'), isTrue);

      // Links stay tappable: the X placeholder's host link and prose links.
      final xLink = find.descendant(
        of: _k('embed-placeholder-twitter'),
        matching: find.text('x.com'),
      );
      steps['xHostLink'] = xLink.evaluate().length;
      if (xLink.evaluate().isNotEmpty) {
        await tester.tap(xLink);
        await tester.pump();
      }
      steps['proseX'] = _tapProse('x.com/someone');
      steps['proseYt'] = _tapProse('youtu.be/dQw4w9WgXcQ');
      await tester.pump();
      steps['launched'] = List.of(opened);
      steps['headerWrites'] = net.headerWrites.toSet().toList();
      steps['clientSettings'] = net.clientSettings.toList();
      steps['unexpected'] = net.log;
      expect(opened, containsAll([_x, _yt1]), reason: jsonEncode(steps));
      expect(net.log, isEmpty);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('E4 $layout Always: only allowed https hosts', (tester) async {
      final opened = _launches();
      SharedPreferences.setMockInitialValues(_reading(InlineEmbedMode.always));
      final prefs = await SharedPreferences.getInstance();
      final net = _record();
      await _pumpChat(tester, layout, prefs, _replyMain);
      await _settle(tester);
      final hosts = net.hosts;
      final out = <String, Object?>{
        'requests': net.requests.map((u) => '$u').toList(),
        'nonHttps': net.requests
            .where((u) => u.scheme != 'https')
            .map((u) => '$u')
            .toList(),
        'headerWrites': net.headerWrites.toSet().toList(),
        'clientSettings': net.clientSettings.toList(),
        'proseYt': _tapProse('youtu.be/dQw4w9WgXcQ'),
      };
      await tester.pump();
      out['launched'] = opened;
      expect(
        hosts.difference({
          'img-a.example.org',
          'img-b.example.org',
          'www.youtube.com',
          'i.ytimg.com',
          'publish.twitter.com',
        }),
        isEmpty,
        reason: jsonEncode(out),
      );
      expect(hosts.contains('img-c.example.org'), isFalse);
      expect(hosts.contains('tracker.example'), isFalse);
      expect(opened, [_yt1]);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('E5 $layout Off: nothing fetched, links tappable', (
      tester,
    ) async {
      final opened = _launches();
      SharedPreferences.setMockInitialValues(
        _reading(
          InlineEmbedMode.off,
          allowed: {'youtube', 'image:img-a.example.org'},
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      final net = _record();
      await _pumpChat(tester, layout, prefs, _replyMain);
      await _settle(tester);
      final out = <String, Object?>{
        'requests': net.requests.map((u) => '$u').toList(),
        'placeholders': find
            .byWidgetPredicate(
              (w) =>
                  w.key is ValueKey<String> &&
                  ((w.key! as ValueKey<String>).value.startsWith(
                        'embed-placeholder',
                      ) ||
                      (w.key! as ValueKey<String>).value.startsWith(
                        'embed-card',
                      )),
            )
            .evaluate()
            .length,
      };
      for (final img in [_imgA, _imgB, _imgHttp]) {
        final link = _k('embed-link-$img');
        out['link $img'] = link.evaluate().length;
        if (link.evaluate().isNotEmpty) {
          await tester.ensureVisible(link);
          await tester.tap(link);
          await tester.pump();
        }
      }
      out['proseYt'] = _tapProse('youtu.be/dQw4w9WgXcQ');
      out['proseX'] = _tapProse('x.com/someone');
      await tester.pump();
      out['launched'] = opened;
      expect(net.requests, isEmpty, reason: jsonEncode(out));
      expect(out['placeholders'], 0);
      expect(opened, containsAll([_imgA, _imgB, _imgHttp, _yt1, _x]));
      await tester.pumpWidget(const SizedBox());
    });

    for (final mode in InlineEmbedMode.values) {
      testWidgets('E6 $layout ${mode.name}: hostile hosts never fetched', (
        tester,
      ) async {
        final opened = _launches();
        SharedPreferences.setMockInitialValues(_reading(mode));
        final prefs = await SharedPreferences.getInstance();
        final net = _record();
        await _pumpChat(tester, layout, prefs, '$_replyHostile\n$_replyGood');
        await _settle(tester);
        final cards = find
            .byWidgetPredicate(
              (w) =>
                  w.key is ValueKey<String> &&
                  (w.key! as ValueKey<String>).value.startsWith('embed-'),
            )
            .evaluate()
            .map((e) => (e.widget.key! as ValueKey<String>).value)
            .toSet()
            .toList();
        final tapped = <String, bool>{
          for (final u in _hostile) u: _tapProse(Uri.parse(u).host),
        };
        await tester.pump();
        final seen = jsonEncode({
          'hosts': net.hosts.toList(),
          'embedKeys': cards,
          'hostileTapped': tapped,
          'launched': opened,
        });
        for (final u in _hostile) {
          expect(net.hosts.contains(Uri.parse(u).host), isFalse, reason: seen);
          expect(cards.any((k) => k.contains(Uri.parse(u).host)), isFalse);
        }
        expect(tapped.values.every((v) => v), isTrue);
        if (mode != InlineEmbedMode.always) {
          expect(net.requests, isEmpty);
        } else {
          expect(
            net.hosts.difference({
              'www.tiktok.com',
              'p16.tiktokcdn.com',
              'open.spotify.com',
              'i.scdn.co',
            }),
            isEmpty,
          );
        }
        await tester.pumpWidget(const SizedBox());
      });
    }
  }

  // E7: an allowed image host that redirects. Redirects are followed only
  // over https, to the same host or to a host that is itself allowed (in
  // Always, every https image host is), and never past three hops. Load
  // once allows only the host the reader chose.
  group('E7 image redirects', () {
    const tracker = 'https://tracker.example/pixel.png';
    const moved = 'https://img-a.example.org/moved.png';
    for (final layout in ['nextgen', 'classic']) {
      testWidgets('$layout: Always allow for a host does not reach another', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues(
          _reading(InlineEmbedMode.ask, allowed: {'image:img-a.example.org'}),
        );
        final prefs = await SharedPreferences.getInstance();
        final net = _record();
        net.redirects[_imgA] = tracker;
        await _pumpChat(tester, layout, prefs, '![first]($_imgA)\n');
        await _settle(tester);
        expect(net.requests.map((u) => '$u'), [_imgA]);
        expect(net.hosts.contains('tracker.example'), isFalse);
        expect(
          find.descendant(
            of: _k('embed-link-$_imgA'),
            matching: find.textContaining("Couldn't load the image"),
          ),
          findsOneWidget,
        );
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('$layout: Load once does not follow to another host', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues(_reading(InlineEmbedMode.ask));
        final prefs = await SharedPreferences.getInstance();
        final net = _record();
        net.redirects[_imgA] = tracker;
        await _pumpChat(tester, layout, prefs, '![first]($_imgA)\n');
        await _settle(tester);
        expect(net.requests, isEmpty);
        await tester.tap(_k('embed-load-image:img-a.example.org'));
        await _settle(tester);
        expect(net.requests.map((u) => '$u'), [_imgA]);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('$layout: the same host, or another allowed host, is '
          'followed', (tester) async {
        SharedPreferences.setMockInitialValues(
          _reading(
            InlineEmbedMode.ask,
            allowed: {'image:img-a.example.org', 'image:img-b.example.org'},
          ),
        );
        final prefs = await SharedPreferences.getInstance();
        final net = _record();
        net.redirects[_imgA] = moved;
        net.redirects[moved] = _imgB;
        await _pumpChat(tester, layout, prefs, '![first]($_imgA)\n');
        await _settle(tester);
        expect(net.requests.map((u) => '$u'), [_imgA, moved, _imgB]);
        expect(_k('embed-remote-image-$_imgA'), findsOneWidget);
        expect(_k('embed-link-$_imgA'), findsNothing);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('$layout: Always follows https only', (tester) async {
        SharedPreferences.setMockInitialValues(
          _reading(InlineEmbedMode.always),
        );
        final prefs = await SharedPreferences.getInstance();
        final net = _record();
        net.redirects[_imgA] = tracker;
        net.redirects[_imgB] = 'http://img-b.example.org/b.png';
        await _pumpChat(
          tester,
          layout,
          prefs,
          '![first]($_imgA)\n\n![second]($_imgB)\n',
        );
        await _settle(tester);
        // Always allows every https image host, the redirect's included.
        expect(net.requests.map((u) => '$u'), containsAll([_imgA, tracker]));
        // Plain http is never requested, even as a redirect.
        expect(net.requests.where((u) => u.scheme != 'https'), isEmpty);
        expect(net.requests.map((u) => '$u'), contains(_imgB));
        await tester.pumpWidget(const SizedBox());
      });
    }

    test('gives up after three hops', () async {
      final net = _record();
      final hops = [
        for (var i = 0; i <= 4; i++) 'https://img-a.example.org/hop$i.png',
      ];
      for (var i = 0; i < 4; i++) {
        net.redirects[hops[i]] = hops[i + 1];
      }
      bool sameHost(Uri uri) => uri.host == 'img-a.example.org';
      await expectLater(
        fetchCappedHttps(Uri.parse(hops[0]), maxBytes: 1024, allowed: sameHost),
        throwsStateError,
      );
      // The first request and three hops; the fourth redirect is refused.
      expect(net.requests.map((u) => '$u'), hops.take(4));

      net.requests.clear();
      final bytes = await fetchCappedHttps(
        Uri.parse(hops[1]),
        maxBytes: 1024,
        allowed: sameHost,
      );
      expect(bytes, isNotEmpty);
      expect(net.requests.map((u) => '$u'), hops.skip(1));
    });

    testWidgets('an image provider follows only its own host by default', (
      tester,
    ) async {
      final net = _record();
      net.redirects[_imgA] = tracker;
      final outcome = await tester.runAsync(() async {
        final done = Completer<String>();
        final stream = CappedHttpsImage(
          Uri.parse(_imgA),
        ).resolve(ImageConfiguration.empty);
        final listener = ImageStreamListener(
          (info, _) {
            if (!done.isCompleted) done.complete('loaded');
            info.dispose();
          },
          onError: (Object error, _) {
            if (!done.isCompleted) done.complete('refused');
          },
        );
        stream.addListener(listener);
        try {
          return await done.future.timeout(const Duration(seconds: 20));
        } finally {
          stream.removeListener(listener);
        }
      });
      expect(outcome, 'refused');
      expect(net.hosts, {'img-a.example.org'});
    });
  });

  testWidgets('E8 caps: decoded size and bytes, default limits', (
    tester,
  ) async {
    final net = _record();
    net.bodies['https://img.example.org/huge.png'] = _hugePng;
    final nine = List<int>.filled(9 * 1024 * 1024, 1);
    net.bodies['https://img.example.org/big-declared.png'] = nine;
    net.bodies['https://img.example.org/big-streamed.png'] = nine;
    net.streamed.add('https://img.example.org/big-streamed.png');
    final results = <String, String>{};
    for (final name in ['huge', 'big-declared', 'big-streamed']) {
      final uri = Uri.parse('https://img.example.org/$name.png');
      final outcome = await tester.runAsync(() async {
        final done = Completer<String>();
        final stream = CappedHttpsImage(uri).resolve(ImageConfiguration.empty);
        final listener = ImageStreamListener((info, _) {
          done.complete('decoded ${info.image.width}x${info.image.height}');
          info.dispose();
        }, onError: (Object error, _) => done.complete('error $error'));
        stream.addListener(listener);
        try {
          return await done.future.timeout(const Duration(seconds: 20));
        } on TimeoutException {
          return 'timeout';
        } finally {
          stream.removeListener(listener);
        }
      });
      results[name] = outcome ?? 'null';
    }
    for (final r in results.values) {
      expect(r, startsWith('error'), reason: jsonEncode(results));
    }
  });

  // An embed's link is prose: Off's image link and the "Couldn't load"
  // link sit in the reply and use its link colour; the Ask placeholder's
  // host link sits on the placeholder and uses the layout's link colour.
  // NextGen draws links in NgColors.accentText (colorScheme.primary is the
  // accent fill, 3.9:1 on the dark page); Classic in its tokens' accent,
  // or the bubble's onAccent in a user bubble.
  group('embed links read like prose links', () {
    const doc = 'https://example.org/doc';
    // Not an image path, so the recording network answers 404 and Always
    // shows the "Couldn't load" link.
    const missing = 'https://img-a.example.org/missing';
    const reply = 'See [the docs]($doc).\n\n![chart]($missing)\n';
    for (final layout in ['nextgen', 'classic']) {
      for (final app in Brightness.values) {
        for (final mode in InlineEmbedMode.values) {
          testWidgets('$layout ${app.name} ${mode.name}', (tester) async {
            SharedPreferences.setMockInitialValues(_reading(mode));
            final prefs = await SharedPreferences.getInstance();
            final net = _record();
            await _pumpChat(tester, layout, prefs, reply, brightness: app);
            await _settle(tester);
            final prose = _inkOf('the docs');
            expect(prose, hasLength(1));
            final context = tester.element(find.byType(Scaffold).first);
            final theme = Theme.of(context);
            final layoutLink = layout == 'nextgen'
                ? NgColors.of(context).accentText
                : HermesTokens.of(context).accent;
            // Assistant prose links are the layout's link colour.
            expect(_hex(prose.single), _hex(layoutLink));
            final link = _k('embed-link-$missing');
            expect(link, findsOneWidget, reason: '${net.requests}');
            final String label;
            switch (mode) {
              case InlineEmbedMode.off:
                label = 'chart';
              case InlineEmbedMode.ask:
                label = 'img-a.example.org';
                expect(
                  find.ancestor(
                    of: link,
                    matching: _k('embed-placeholder-image:img-a.example.org'),
                  ),
                  findsOneWidget,
                );
              case InlineEmbedMode.always:
                label = "Couldn't load the image";
                expect(net.hosts, {'img-a.example.org'});
            }
            final ink = _inkOf(label, within: link);
            expect(ink, hasLength(1), reason: label);
            expect(_hex(ink.single), _hex(prose.single), reason: label);
            if (mode == InlineEmbedMode.ask) {
              final fill = Color.alphaBlend(
                theme.colorScheme.surfaceContainerLow,
                theme.scaffoldBackgroundColor,
              );
              expect(
                _ratio(ink.single, fill),
                greaterThanOrEqualTo(4.5),
                reason: '${_hex(ink.single)} on ${_hex(fill)}',
              );
            }
            await tester.pumpWidget(const SizedBox());
          });
        }
      }
    }

    // Classic renders the reader's own messages as Markdown too: an image
    // link in a user bubble is drawn in the bubble's link colour, not the
    // accent the bubble is filled with.
    for (final app in Brightness.values) {
      for (final mode in [InlineEmbedMode.off, InlineEmbedMode.always]) {
        testWidgets('classic user bubble ${app.name} ${mode.name}', (
          tester,
        ) async {
          SharedPreferences.setMockInitialValues(_reading(mode));
          final prefs = await SharedPreferences.getInstance();
          _record();
          await _pumpChat(
            tester,
            'classic',
            prefs,
            'Noted.',
            brightness: app,
            user: 'Mine: [my ref]($doc)\n\n![pic]($missing)\n',
          );
          await _settle(tester);
          final prose = _inkOf('my ref');
          expect(prose, hasLength(1));
          final context = tester.element(find.byType(Scaffold).first);
          expect(_hex(prose.single), _hex(HermesTokens.of(context).onAccent));
          final link = _k('embed-link-$missing');
          expect(link, findsOneWidget);
          final label = mode == InlineEmbedMode.off
              ? 'pic'
              : "Couldn't load the image";
          final ink = _inkOf(label, within: link);
          expect(ink, hasLength(1), reason: label);
          expect(_hex(ink.single), _hex(prose.single), reason: label);
          await tester.pumpWidget(const SizedBox());
        });
      }
    }
  });

  for (final layout in ['classic', 'nextgen']) {
    testWidgets('E9 $layout settings: Ask/Always/Off and Reset N', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues(
        _reading(
          InlineEmbedMode.ask,
          allowed: {'youtube', 'twitter', 'image:img-a.example.org'},
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      tester.view.physicalSize = const Size(900, 6000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: layout == 'classic'
              ? hermesTheme(Brightness.light)
              : nextGenTheme(Brightness.light, NextGenLook.instance),
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
      final out = <String, Object?>{
        'title': find.text('Inline embeds').evaluate().length,
        'segments': [
          for (final t in ['Ask', 'Always', 'Off'])
            find
                .descendant(
                  of: _k('presentation-embeds'),
                  matching: find.text(t),
                )
                .evaluate()
                .length,
        ],
        'reset3': find.text('Reset 3 allowed services').evaluate().length,
      };
      await tester.tap(_k('presentation-embeds-reset'));
      await tester.pumpAndSettle();
      out['resetAfter'] = _k('presentation-embeds-reset').evaluate().length;
      out['stored'] = ReadingControls(prefs).allowedEmbeds.toList();
      await ReadingControls(prefs).allowEmbedService('youtube');
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
      out['reset1'] = find.text('Reset 1 allowed service').evaluate().length;
      expect(out['title'], 1, reason: jsonEncode(out));
      expect(out['segments'], [1, 1, 1]);
      expect(out['reset3'], 1);
      expect(out['resetAfter'], 0);
      expect(out['stored'], isEmpty);
      expect(out['reset1'], 1);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
