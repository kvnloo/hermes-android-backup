import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/services/client_held_queue.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/image_recovery_capability_notice.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/inert_turn_application_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/image_picker'),
          (_) async => null,
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/image_picker'),
          null,
        );
  });

  test('client-held park matches the Desktop drain gate', () {
    final queue = ClientHeldQueue();
    expect(queue.park(), isFalse);
    queue.enqueue('one');
    queue.enqueue('two');
    expect(queue.park(), isTrue);
    expect(queue.takeHead(manual: false), isNull);
    expect(clientHeldQueueLabel(count: 2, parked: true), '2 queued — paused');
    queue.enqueue('three');
    expect(queue.parked, isFalse);
    expect(queue.promote(queue.entries.last.id), isTrue);
    expect(queue.entries.first.text, 'three');
    expect(queue.takeHead(manual: true)?.text, 'three');
    expect(queue.parked, isFalse);
    queue.park();
    queue.remove(queue.entries.first.id);
    queue.remove(queue.entries.single.id);
    expect(queue.parked, isFalse);
    expect(queue.entries, isEmpty);
    queue.restoreParked(['kept', '  ', 'later']);
    expect(queue.parked, isTrue);
    expect(queue.peekAuto()?.text, isNull);
    expect(queue.entries.map((entry) => entry.text), ['kept', 'later']);
    queue.unpark();
    expect(queue.peekAuto(skipId: queue.entries.first.id)?.text, 'later');
  });

  testWidgets('NextGen Stop shows N queued — paused and Resume admits once', (
    tester,
  ) async {
    final calls = <Map<String, dynamic>>[];
    final gateway = _Gateway((method, params) async {
      calls.add({'method': method, ...params});
      return {'status': 'queued'};
    });
    final chat = NgChatController(gateway, sessionId: 'stored')
      ..runtimeId = 'rt';
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    await _pumpNextGen(tester, chat, gateway);
    gateway.debugEmit(
      StreamEvent(type: 'message.start', data: const {}, sessionId: 'rt'),
    );
    await tester.pump();
    chat.enqueue('later');
    await tester.pump();
    expect(find.text('1 queued'), findsOneWidget);
    expect(find.text('Resume'), findsNothing);
    expect(find.text('Pause device queue'), findsNothing);

    await tester.tap(find.byTooltip('Stop'));
    await tester.pump();
    expect(find.text('1 queued — paused'), findsOneWidget);
    expect(calls.where((call) => call['method'] == 'prompt.submit'), isEmpty);

    gateway.debugEmit(
      StreamEvent(type: 'message.complete', data: const {}, sessionId: 'rt'),
    );
    await tester.pump();
    expect(find.text('1 queued — paused'), findsOneWidget);
    expect(calls.where((call) => call['method'] == 'prompt.submit'), isEmpty);

    await tester.tap(find.text('Resume'));
    await tester.pump();
    await tester.pump();
    expect(
      calls.where((call) => call['method'] == 'prompt.submit').single['text'],
      'later',
    );
    expect(find.text('1 queued — paused'), findsNothing);
  });

  testWidgets('NextGen empty Enter and row send lift a park once', (
    tester,
  ) async {
    final calls = <Map<String, dynamic>>[];
    final gateway = _Gateway((method, params) async {
      calls.add({'method': method, ...params});
      return {'status': 'queued'};
    });
    final chat = NgChatController(gateway, sessionId: 'stored')
      ..runtimeId = 'rt';
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    await _pumpNextGen(tester, chat, gateway);
    gateway.debugEmit(
      StreamEvent(type: 'message.start', data: const {}, sessionId: 'rt'),
    );
    await tester.pump();
    chat.enqueue('first');
    chat.enqueue('send me');
    chat.setLocalQueuePaused(true);
    await tester.pump();
    expect(find.text('2 queued — paused'), findsOneWidget);

    await tester.tap(find.byTooltip('Send queued prompt').last);
    await tester.pump();
    gateway.debugEmit(
      StreamEvent(type: 'message.complete', data: const {}, sessionId: 'rt'),
    );
    await tester.pump();
    await tester.pump();
    expect(
      calls.where((call) => call['method'] == 'prompt.submit').single['text'],
      'send me',
    );
    expect(find.text('1 queued — paused'), findsNothing);
    expect(find.text('first'), findsWidgets);

    calls.clear();
    chat.setLocalQueuePaused(true);
    await tester.pump();
    expect(find.text('1 queued — paused'), findsOneWidget);
    gateway.debugEmit(
      StreamEvent(type: 'message.complete', data: const {}, sessionId: 'rt'),
    );
    await tester.pump();
    await tester.pump();
    expect(calls.where((call) => call['method'] == 'prompt.submit'), isEmpty);
    await tester.tap(find.byKey(const ValueKey('ng-composer-field')));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.pump();
    expect(
      calls.where((call) => call['method'] == 'prompt.submit').single['text'],
      'first',
    );
  });

  testWidgets('NextGen empty Enter while busy admits the head once', (
    tester,
  ) async {
    final calls = <Map<String, dynamic>>[];
    final gateway = _Gateway((method, params) async {
      calls.add({'method': method, ...params});
      return {'status': 'queued'};
    });
    final chat = NgChatController(gateway, sessionId: 'stored')
      ..runtimeId = 'rt';
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    await _pumpNextGen(tester, chat, gateway);
    gateway.debugEmit(
      StreamEvent(type: 'message.start', data: const {}, sessionId: 'rt'),
    );
    await tester.pump();
    chat.enqueue('head');
    chat.enqueue('tail');
    chat.setLocalQueuePaused(true);
    await tester.pump();
    expect(find.text('2 queued — paused'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('ng-composer-field')));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(calls.where((call) => call['method'] == 'prompt.submit'), isEmpty);
    expect(chat.localQueuePaused, isFalse);
    expect(chat.queued.first.text, 'head');

    gateway.debugEmit(
      StreamEvent(type: 'message.complete', data: const {}, sessionId: 'rt'),
    );
    await tester.pump();
    await tester.pump();
    expect(
      calls.where((call) => call['method'] == 'prompt.submit').single['text'],
      'head',
    );
    expect(chat.queued.single.text, 'tail');
  });

  testWidgets(
    'Classic REST queues, Stop parks, and Resume does not auto-resend',
    (tester) async {
      final client = _RestStreams();
      await _pumpClassic(tester, client);
      expect(
        find.byKey(const ValueKey('image-recovery-gap-restSse')),
        findsNothing,
      );
      expect(find.text('Recover image draft…'), findsNothing);
      expect(
        find.text(ImageRecoveryCapabilityNotice.restExplanation),
        findsNothing,
      );

      await tester.enterText(
        find.byKey(const Key('chat-message-composer')),
        'Original task',
      );
      await tester.tap(find.byKey(const Key('chat-send-message')));
      await _pump(tester);
      expect(client.prompts, hasLength(1));
      expect(find.byTooltip('Queue until this turn finishes'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('chat-message-composer')),
        'later',
      );
      await tester.tap(find.byKey(const Key('chat-queue-held')));
      await _pump(tester);
      expect(find.text('1 queued'), findsOneWidget);
      expect(client.prompts, hasLength(1));

      await tester.tap(find.byKey(const Key('chat-stop-response')));
      await _pump(tester);
      expect(find.text('1 queued — paused'), findsOneWidget);
      expect(client.prompts, hasLength(1));

      await tester.tap(find.text('Resume'));
      await _pump(tester);
      expect(client.prompts, hasLength(2));
      expect(jsonEncode(client.prompts.last), contains('later'));
      expect(find.text('1 queued — paused'), findsNothing);
      await _finishStreams(tester, client);
    },
  );

  testWidgets('Classic row send while busy unparks and does not duplicate', (
    tester,
  ) async {
    final client = _RestStreams();
    await _pumpClassic(tester, client);
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'Original task',
    );
    await tester.tap(find.byKey(const Key('chat-send-message')));
    await _pump(tester);
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'first',
    );
    await tester.tap(find.byKey(const Key('chat-queue-held')));
    await _pump(tester);
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'send me',
    );
    await tester.tap(find.byKey(const Key('chat-queue-held')));
    await _pump(tester);
    expect(find.text('2 queued'), findsOneWidget);

    await tester.tap(find.byTooltip('Send queued prompt').last);
    await _pump(tester);
    expect(client.prompts, hasLength(2));
    expect(jsonEncode(client.prompts.last), contains('send me'));
    expect(
      client.prompts.where((prompt) => jsonEncode(prompt).contains('send me')),
      hasLength(1),
    );
    expect(find.text('1 queued — paused'), findsNothing);
    expect(find.text('first'), findsWidgets);
    await _finishStreams(tester, client);
  });

  testWidgets('Classic empty Enter while busy admits the head once', (
    tester,
  ) async {
    final client = _RestStreams();
    await _pumpClassic(tester, client);
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'Original task',
    );
    await tester.tap(find.byKey(const Key('chat-send-message')));
    await _pump(tester);
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'later',
    );
    await tester.tap(find.byKey(const Key('chat-queue-held')));
    await _pump(tester);
    expect(find.text('1 queued'), findsOneWidget);

    await tester.tap(find.byKey(const Key('chat-message-composer')));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await _pump(tester);
    expect(client.prompts, hasLength(2));
    expect(
      client.prompts.where((prompt) => jsonEncode(prompt).contains('later')),
      hasLength(1),
    );
    expect(find.text('1 queued — paused'), findsNothing);
    await _finishStreams(tester, client);
  });

  testWidgets('companion recovery explains the missing image receipt', (
    tester,
  ) async {
    await _pumpClassic(
      tester,
      _RestStreams(),
      turnSession: InertTurnApplicationSession(),
    );
    expect(
      find.byKey(const ValueKey('image-recovery-gap-recoveryV2')),
      findsNothing,
    );
    expect(
      find.text(ImageRecoveryCapabilityNotice.recoveryExplanation),
      findsNothing,
    );
    expect(find.text('Recover image draft…'), findsNothing);
    expect(
      find.text(ImageRecoveryCapabilityNotice.restExplanation),
      findsNothing,
    );
  });

  for (final companion in [false, true]) {
    testWidgets('image attachment shows recovery gap (companion=$companion)', (
      tester,
    ) async {
      await _pumpClassic(
        tester,
        _RestStreams(),
        turnSession: companion ? InertTurnApplicationSession() : null,
        attachments: [
          AttachmentDraft(
            id: 'image',
            cachedPath: '/fixture/image.png',
            name: 'image.png',
            byteLength: 7,
            mediaType: 'image/png',
            kind: AttachmentDraftKind.image,
            sanitized: true,
          ),
        ],
      );
      expect(
        find.byKey(
          ValueKey(
            'image-recovery-gap-${companion ? 'recoveryV2' : 'restSse'}',
          ),
        ),
        findsOneWidget,
      );
      expect(find.text('Recover image draft…'), findsNothing);
      await tester.enterText(
        find.byKey(const Key('chat-message-composer')),
        'caption',
      );
      await _pump(tester);
      expect(find.byType(ImageRecoveryCapabilityNotice), findsOneWidget);
    });
  }

  testWidgets('a stock composer does not show the REST recovery gap', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatScreen(
          connection: _connection,
          session: _session,
          initialAttachmentDrafts: [
            AttachmentDraft(
              id: 'stock-image',
              cachedPath: '/fixture/image.png',
              name: 'image.png',
              byteLength: 7,
              mediaType: 'image/png',
              kind: AttachmentDraftKind.image,
              sanitized: true,
            ),
          ],
          testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
          testRemotePromptSubmit:
              ({
                required sessionId,
                required text,
                required onEvent,
                required onSent,
              }) async {},
          testApiClient: ApiClient(
            baseUrl: 'http://fixture.invalid',
            apiKey: 'fixture-key',
            httpClient: _RestStreams(),
          ),
        ),
      ),
    );
    await _pump(tester);
    expect(
      find.byKey(const ValueKey('image-recovery-gap-restSse')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('image-recovery-gap-recoveryV2')),
      findsNothing,
    );
  });
}

class _Gateway extends NextGenGateway {
  _Gateway(this.onCall) : super(_nextGenConnection);

  final Future<Map<String, dynamic>> Function(
    String method,
    Map<String, dynamic> params,
  )
  onCall;

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) => onCall(method, params);
}

final _nextGenConnection = SavedConnection(
  id: 'c1',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: '',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
);

Future<void> _pumpNextGen(
  WidgetTester tester,
  NgChatController chat,
  NextGenGateway gateway,
) async {
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: nextGenTheme(Brightness.light, NextGenLook.instance),
      home: NgScope(
        connManager: ConnectionManager(prefs),
        gateway: gateway,
        connections: [_nextGenConnection],
        switchTo: (_) async {},
        addGateway: () async {},
        signOut: (_) async {},
        reload: () async {},
        signInAgain: () async {},
        child: Scaffold(
          body: NgChatView(chat: chat, onOpenSidebar: () {}, onNewChat: () {}),
        ),
      ),
    ),
  );
  await tester.pump();
}

final _connection = SavedConnection(
  id: 'held-queue',
  label: 'Fixture',
  host: 'fixture.invalid',
  port: 8642,
  apiKey: 'fixture-key',
);

const _session = Session(
  id: 'stored-chat',
  title: 'Chat',
  model: 'fixture',
  source: 'test',
  messageCount: 0,
  isActive: true,
  preview: '',
  startedAt: 1,
);

Future<void> _pumpClassic(
  WidgetTester tester,
  http.Client client, {
  GatewayTurnApplicationSession? turnSession,
  List<AttachmentDraft> attachments = const [],
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChatScreen(
        connection: _connection,
        session: _session,
        initialAttachmentDrafts: attachments,
        testTurnApplicationSession: turnSession,
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
        testApiClient: ApiClient(
          baseUrl: 'http://fixture.invalid',
          apiKey: 'fixture-key',
          httpClient: client,
        ),
      ),
    ),
  );
  await _pump(tester);
}

Future<void> _pump(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  }
}

Future<void> _finishStreams(WidgetTester tester, _RestStreams client) async {
  for (final stream in client.streams) {
    // Stop cancels the subscription and leaves the controller open. Closing
    // that controller waits forever for a listener, so only finish a stream
    // that is still being read.
    if (stream.isClosed || !stream.hasListener) continue;
    stream.add(utf8.encode('data: [DONE]\n\n'));
    await stream.close();
  }
  await _pump(tester);
}

class _RestStreams extends http.BaseClient {
  final streams = <StreamController<List<int>>>[];
  final prompts = <Map<String, dynamic>>[];

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.method == 'POST' &&
        request.url.path.endsWith('/v1/chat/completions')) {
      final body = await request.finalize().bytesToString();
      prompts.add(jsonDecode(body) as Map<String, dynamic>);
      final stream = StreamController<List<int>>();
      streams.add(stream);
      return http.StreamedResponse(
        stream.stream,
        200,
        headers: {'content-type': 'text/event-stream'},
      );
    }
    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode({'data': []}))),
      200,
      headers: {'content-type': 'application/json'},
    );
  }
}
