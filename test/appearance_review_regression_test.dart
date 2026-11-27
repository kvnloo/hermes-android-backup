// Regressions for the appearance review probes A2 (reactions leaked between
// chats) and A3 (NextGen fetched Markdown images with external embeds off).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/l10n/l10n.dart';
import 'package:hermes_android/core/presentation/presentation_scope.dart';
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

Map<String, Object> _reading({bool embeds = false, bool reactions = false}) => {
  ReadingControls.preferenceKey: jsonEncode({
    'chatFont': 'platform',
    'terminalFont': 'geistMono',
    'direction': 'automatic',
    'bubbleOpacity': 1,
    'externalEmbeds': embeds,
    'emojiReactions': reactions,
    'celebrationHearts': false,
  }),
};

Finder get _thumbs => find.widgetWithText(ChoiceChip, '👍');

List<bool> _thumbsSelected(WidgetTester tester) => [
  for (final element in _thumbs.evaluate())
    (element.widget as ChoiceChip).selected,
];

/// Records every request made through dart:io while installed, and fails
/// it. Creating a client is allowed (a gateway object owns one); opening a
/// connection with it is not.
class _NoNetwork extends HttpOverrides {
  final attempts = <String>[];

  /// Flutter checks that the image client hook is unset before tear-down,
  /// so each test releases the guard at the end of its body.
  void Function() release = () {};

  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      _RefusingClient(attempts);
}

class _RefusingClient implements HttpClient {
  _RefusingClient(this.attempts);

  final List<String> attempts;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final name = invocation.memberName.toString();
    if (name.contains('open') ||
        name.contains('get') ||
        name.contains('post') ||
        name.contains('put') ||
        name.contains('delete') ||
        name.contains('head') ||
        name.contains('patch')) {
      final url = invocation.positionalArguments.whereType<Uri>().firstOrNull;
      attempts.add('$name ${url ?? invocation.positionalArguments}');
      throw const SocketException('Network access is not allowed here.');
    }
    return null;
  }
}

Future<_NoNetwork> _forbidNetwork() async {
  final guard = _NoNetwork();
  final previous = HttpOverrides.current;
  HttpOverrides.global = guard;
  debugNetworkImageHttpClientProvider = () => _RefusingClient(guard.attempts);
  guard.release = () {
    HttpOverrides.global = previous;
    debugNetworkImageHttpClientProvider = null;
  };
  addTearDown(guard.release);
  return guard;
}

Finder get _networkImages => find.byWidgetPredicate(
  (widget) => widget is Image && widget.image is NetworkImage,
);

// ---- NextGen ---------------------------------------------------------------

NextGenGateway _gateway([String id = 'c1']) => NextGenGateway(
  SavedConnection(
    id: id,
    label: 'Home',
    host: '10.0.0.5',
    port: 9119,
    apiKey: 'k',
    desktopGatewayUrl: 'http://10.0.0.5:9119',
    singleLogin: true,
    signInMethod: 'none',
  ),
);

Future<void> _pumpNg(
  WidgetTester tester,
  SharedPreferences prefs,
  NextGenGateway gateway,
  NgChatController chat,
) async {
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
}

NgChatController _ngChat(
  NextGenGateway gateway,
  String id,
  List<Map<String, dynamic>> rows,
) => NgChatController(gateway, sessionId: id)
  ..runtimeId = 'runtime-$id'
  ..debugApplyHistory(rows);

// ---- Classic ---------------------------------------------------------------

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

Widget _classic(
  SharedPreferences prefs, {
  required String connection,
  required String session,
  required List<Map<String, dynamic>> rows,
}) => MaterialApp(
  key: ValueKey('$connection/$session'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: preferredSupportedLocales(),
  localeListResolutionCallback: resolvePreferredLocale,
  builder: (context, child) =>
      PresentationRoot(preferences: prefs, child: child!),
  home: ChatScreen(
    connection: SavedConnection(
      id: connection,
      label: 'Fixture',
      host: 'reactions.fixture',
      port: 8642,
      apiKey: 'k',
    ),
    session: Session(
      id: session,
      title: 'Fixture',
      model: 'fixture-model',
      source: 'api_server',
      messageCount: rows.length,
      isActive: false,
      preview: '',
      startedAt: 1,
    ),
    testApiClient: ApiClient(
      baseUrl: 'http://reactions.fixture',
      apiKey: 'k',
      httpClient: _History(rows),
    ),
    testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
  ),
);

/// Two chats whose rows carry the same message ids, as two gateways (or two
/// chats on one) can.
List<Map<String, dynamic>> _rows(String question) => [
  {'id': '1', 'role': 'user', 'content': question},
  {
    'id': '2',
    'role': 'assistant',
    'content': 'Answer to $question',
    'completed': true,
  },
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => HermesSignInVault.resetForTesting(MemorySignInSecretStore()));

  group('A2 reactions stay with their own chat', () {
    testWidgets('NextGen: a reaction on chat A is not shown on chat B', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues(_reading(reactions: true));
      final prefs = await SharedPreferences.getInstance();
      final gateway = _gateway();
      final chatA = _ngChat(gateway, 'a', [
        {'role': 'user', 'content': 'Question in chat A'},
        {'role': 'assistant', 'content': 'Answer A'},
      ]);
      final chatB = _ngChat(gateway, 'b', [
        {'role': 'user', 'content': 'Different question in chat B'},
        {'role': 'assistant', 'content': 'Answer B'},
      ]);
      addTearDown(() {
        chatA.dispose();
        chatB.dispose();
        gateway.dispose();
      });
      // Both chats number their rows from the same sequence.
      expect(
        chatA.items.map((item) => item.key),
        chatB.items.map((item) => item.key),
      );

      await _pumpNg(tester, prefs, gateway, chatA);
      await tester.tap(_thumbs.first);
      await tester.pump();
      expect(_thumbsSelected(tester), [true, false]);

      await _pumpNg(tester, prefs, gateway, chatB);
      expect(find.text('Different question in chat B'), findsOneWidget);
      expect(
        _thumbsSelected(tester),
        [false, false],
        reason: 'chat A reaction appeared on a chat B message',
      );

      await _pumpNg(tester, prefs, gateway, chatA);
      expect(find.text('Question in chat A'), findsOneWidget);
      expect(_thumbsSelected(tester), [true, false]);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets(
      'Classic: the same message id in another chat or on another gateway '
      'has its own reaction',
      (tester) async {
        mockChatImageRecovery();
        SharedPreferences.setMockInitialValues(_reading(reactions: true));
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          _classic(
            prefs,
            connection: 'home',
            session: 'chat-a',
            rows: _rows('Question in chat A'),
          ),
        );
        await pumpChatUpdates(tester);
        expect(find.text('Question in chat A'), findsOneWidget);
        expect(_thumbs, findsNWidgets(2));
        await tester.tap(_thumbs.first);
        await tester.pump();
        expect(_thumbsSelected(tester), [true, false]);

        await tester.pumpWidget(
          _classic(
            prefs,
            connection: 'home',
            session: 'chat-b',
            rows: _rows('Question in chat B'),
          ),
        );
        await pumpChatUpdates(tester);
        expect(find.text('Question in chat B'), findsOneWidget);
        expect(_thumbsSelected(tester), [
          false,
          false,
        ], reason: 'chat A reaction appeared on chat B');

        await tester.pumpWidget(
          _classic(
            prefs,
            connection: 'office',
            session: 'chat-a',
            rows: _rows('Same chat id on another gateway'),
          ),
        );
        await pumpChatUpdates(tester);
        expect(find.text('Same chat id on another gateway'), findsOneWidget);
        expect(_thumbsSelected(tester), [
          false,
          false,
        ], reason: 'a reaction crossed gateways');

        await tester.pumpWidget(
          _classic(
            prefs,
            connection: 'home',
            session: 'chat-a',
            rows: _rows('Question in chat A'),
          ),
        );
        await pumpChatUpdates(tester);
        expect(_thumbsSelected(tester), [
          true,
          false,
        ], reason: 'chat A keeps its own reaction');
        await tester.pumpWidget(const SizedBox());
      },
    );
  });

  // The old External embeds switch is migrated to Inline Embeds: off becomes
  // Ask (nothing is fetched until the reader chooses), on becomes Always
  // (the https image, and nothing else, is requested).
  group('A3 Markdown images follow the migrated embed choice', () {
    const reply = 'Here:\n\n![pixel](https://tracker.invalid/p.png?u=me)\n';

    // Each case must make (or refuse) its own request, not reuse an image
    // an earlier case left in the process-wide cache.
    setUp(
      () => PaintingBinding.instance.imageCache
        ..clear()
        ..clearLiveImages(),
    );

    void expectMigrated(_NoNetwork network, bool embeds) {
      if (embeds) {
        expect(network.attempts, isNotEmpty);
        expect(
          network.attempts.where(
            (a) => !a.contains('https://tracker.invalid/'),
          ),
          isEmpty,
        );
      } else {
        expect(network.attempts, isEmpty);
        expect(find.text('tracker.invalid'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('embed-load-image:tracker.invalid')),
          findsOneWidget,
        );
      }
    }

    for (final embeds in [false, true]) {
      testWidgets('NextGen with external embeds ${embeds ? 'on' : 'off'}', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues(_reading(embeds: embeds));
        final prefs = await SharedPreferences.getInstance();
        expect(
          ReadingControls(prefs).embedMode,
          embeds ? InlineEmbedMode.always : InlineEmbedMode.ask,
        );
        final network = await _forbidNetwork();
        final gateway = _gateway();
        final chat = _ngChat(gateway, 's', [
          {'role': 'user', 'content': 'Show it'},
          {'role': 'assistant', 'content': reply},
        ]);
        addTearDown(() {
          chat.dispose();
          gateway.dispose();
        });
        await _pumpNg(tester, prefs, gateway, chat);
        await tester.pump(const Duration(milliseconds: 300));

        // Never Flutter's NetworkImage: its shared client has no byte cap.
        expect(_networkImages, findsNothing);
        expectMigrated(network, embeds);
        await tester.pumpWidget(const SizedBox());
        network.release();
      });

      testWidgets('Classic with external embeds ${embeds ? 'on' : 'off'}', (
        tester,
      ) async {
        mockChatImageRecovery();
        SharedPreferences.setMockInitialValues(_reading(embeds: embeds));
        final prefs = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          _classic(
            prefs,
            connection: 'home',
            session: 'images',
            rows: [
              {'id': '1', 'role': 'user', 'content': 'Show it'},
              {
                'id': '2',
                'role': 'assistant',
                'content': reply,
                'completed': true,
              },
            ],
          ),
        );
        final network = await _forbidNetwork();
        await pumpChatUpdates(tester);

        expect(find.text('Show it'), findsOneWidget);
        expect(_networkImages, findsNothing);
        expectMigrated(network, embeds);
        await tester.pumpWidget(const SizedBox());
        network.release();
      });
    }
  });
}
