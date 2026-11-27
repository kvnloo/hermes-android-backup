import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
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

  test('saving a NextGen edit after the row is gone says so', () {
    final gateway = _Gateway((method, params) async => {'status': 'queued'});
    final chat = NgChatController(gateway, sessionId: 'stored')
      ..runtimeId = 'rt';
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    chat.enqueue('gone');
    final row = chat.queued.single;
    chat.unqueue(row);
    chat.editLocalQueue(row, 'updated');
    expect(chat.error, 'That unsent prompt is no longer in the queue.');
  });

  testWidgets('NextGen does not drain the local row that is being edited', (
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
    chat.enqueue('old text');
    await tester.pump();
    await tester.tap(find.byTooltip('Edit unsent prompt'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byType(TextFormField), findsOneWidget);
    // The running turn finishes while the editor is open.
    gateway.debugEmit(
      StreamEvent(type: 'message.complete', data: const {}, sessionId: 'rt'),
    );
    await tester.pump();
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), 'new text');
    await tester.tap(find.text('Save'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    final submits = calls
        .where((c) => c['method'] == 'prompt.submit')
        .map((c) => c['text'])
        .toList();
    expect(submits, isNot(contains('old text')));
    expect(
      submits.contains('new text') ||
          chat.queued.map((row) => row.text).contains('new text'),
      isTrue,
    );
  });

  testWidgets('Classic does not drain the held row that is being edited', (
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
      'old text',
    );
    await tester.tap(find.byKey(const Key('chat-queue-held')));
    await _pump(tester);
    await tester.tap(find.byTooltip('Edit unsent prompt'));
    await _pump(tester);
    await _complete(tester, client.streams[0]);
    await tester.enterText(find.byType(TextFormField), 'new text');
    await tester.tap(find.text('Save'));
    await _pump(tester);
    final sent = client.prompts.map(jsonEncode).toList();
    expect(sent.skip(1).any((prompt) => prompt.contains('old text')), isFalse);
    expect(
      sent.skip(1).any((prompt) => prompt.contains('new text')) ||
          find.text('new text').evaluate().isNotEmpty,
      isTrue,
    );
    for (var i = 0; i < client.streams.length; i++) {
      final s = client.streams[i];
      if (!s.isClosed && s.hasListener) await _complete(tester, s);
    }
  });
}

Future<void> _complete(
  WidgetTester tester,
  StreamController<List<int>> stream,
) async {
  stream.add(
    utf8.encode(
      'data: ${jsonEncode({
        'choices': [
          {
            'delta': {'content': 'ok'},
            'finish_reason': null,
          },
        ],
      })}\n\n',
    ),
  );
  stream.add(
    utf8.encode(
      'data: ${jsonEncode({
        'choices': [
          {'delta': <String, dynamic>{}, 'finish_reason': 'stop'},
        ],
      })}\n\n',
    ),
  );
  stream.add(utf8.encode('data: [DONE]\n\n'));
  await stream.close();
  await _pump(tester);
  await _pump(tester);
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
  id: 'held-queue-edit-probe',
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

Future<void> _pumpClassic(WidgetTester tester, http.Client client) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChatScreen(
        connection: _connection,
        session: _session,
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
