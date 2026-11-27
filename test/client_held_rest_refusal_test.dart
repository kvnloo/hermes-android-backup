import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
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

  Future<void> startAndQueue(
    WidgetTester tester,
    _RestStreams client,
    List<String> held,
  ) async {
    await _pumpClassic(tester, client);
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'Original task',
    );
    await tester.tap(find.byKey(const Key('chat-send-message')));
    await _pump(tester);
    expect(client.prompts, hasLength(1));
    for (final text in held) {
      await tester.enterText(
        find.byKey(const Key('chat-message-composer')),
        text,
      );
      await tester.tap(find.byKey(const Key('chat-queue-held')));
      await _pump(tester);
    }
    expect(find.text('${held.length} queued'), findsOneWidget);
  }

  testWidgets('a completed Classic turn auto-drains the held head once', (
    tester,
  ) async {
    final client = _RestStreams();
    await startAndQueue(tester, client, ['later']);
    await _complete(tester, client.streams[0]);
    expect(client.prompts, hasLength(2));
    expect(jsonEncode(client.prompts[1]), contains('later'));
    await _complete(tester, client.streams[1]);
    expect(client.prompts, hasLength(2));
    await _finishAll(tester, client);
  });

  testWidgets('two Classic held prompts drain one after another', (
    tester,
  ) async {
    final client = _RestStreams();
    await startAndQueue(tester, client, ['first', 'second']);
    await _complete(tester, client.streams[0]);
    expect(client.prompts, hasLength(2), reason: 'first drained');
    expect(jsonEncode(client.prompts[1]), contains('first'));
    await _complete(tester, client.streams[1]);
    expect(client.prompts, hasLength(3), reason: 'second drained');
    expect(jsonEncode(client.prompts[2]), contains('second'));
    await _finishAll(tester, client);
  });

  testWidgets('a refused Classic REST drain keeps the held prompt parked', (
    tester,
  ) async {
    final client = _RestStreams()..failPost = {2};
    await startAndQueue(tester, client, ['keep me']);
    await _complete(tester, client.streams[0]);
    expect(client.prompts, hasLength(2));
    expect(jsonEncode(client.prompts[1]), contains('keep me'));
    await _pump(tester);
    expect(find.byKey(const ValueKey('client-held-queue')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('client-held-queue')),
        matching: find.text('keep me'),
      ),
      findsOneWidget,
    );
    expect(find.text('1 queued \u2014 paused'), findsOneWidget);
    expect(find.textContaining('Send failed'), findsOneWidget);
    await _finishAll(tester, client);
  });

  testWidgets('typing during a Classic turn survives the auto-drain', (
    tester,
  ) async {
    final client = _RestStreams();
    await startAndQueue(tester, client, ['later']);
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'newer typing',
    );
    await _pump(tester);
    await _complete(tester, client.streams[0]);
    expect(client.prompts, hasLength(2));
    final composer = tester.widget<TextField>(
      find.byKey(const Key('chat-message-composer')),
    );
    expect(composer.controller?.text, 'newer typing');
    await _finishAll(tester, client);
  });

  testWidgets(
    'a Classic held prompt is restored parked and is not sent on reopen',
    (tester) async {
      final client = _RestStreams();
      await startAndQueue(tester, client, ['remember me']);
      await tester.pumpWidget(const SizedBox());
      await _pump(tester);
      await _finishAll(tester, client);
      await _pumpClassic(tester, client);
      await _pump(tester);
      expect(find.byKey(const ValueKey('client-held-queue')), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('client-held-queue')),
          matching: find.text('remember me'),
        ),
        findsOneWidget,
      );
      expect(find.text('1 queued \u2014 paused'), findsOneWidget);
      expect(
        client.prompts.any(
          (prompt) => jsonEncode(prompt).contains('remember me'),
        ),
        isFalse,
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(hours: 1));
    },
  );
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

Future<void> _finishAll(WidgetTester tester, _RestStreams client) async {
  for (var i = 0; i < client.streams.length; i++) {
    final stream = client.streams[i];
    if (stream.isClosed || !stream.hasListener) continue;
    await _complete(tester, stream);
  }
  await _pump(tester);
}

final _connection = SavedConnection(
  id: 'held-queue-probe',
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
  Set<int> failPost = {};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.method == 'POST' &&
        request.url.path.endsWith('/v1/chat/completions')) {
      final body = await request.finalize().bytesToString();
      prompts.add(jsonDecode(body) as Map<String, dynamic>);
      if (failPost.contains(prompts.length)) {
        return http.StreamedResponse(
          Stream.value(utf8.encode(jsonEncode({'error': 'unavailable'}))),
          503,
          headers: {'content-type': 'application/json'},
        );
      }
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
