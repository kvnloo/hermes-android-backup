import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/gateway_turn_contract.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_coordinator.dart';
import 'package:hermes_android/core/services/gateway_turn_recovery.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/inert_turn_application_session.dart';

const _ids = [
  '123e4567-e89b-42d3-a456-426614174001',
  '123e4567-e89b-42d3-a456-426614174002',
  '123e4567-e89b-42d3-a456-426614174003',
];

GatewayTurnRecoveryState _accepted(int n) =>
    GatewayTurnRecoveryState.initial(
      clientTurnId: _ids[n],
    ).markSubmissionStarted().applyAck(
      GatewayTurnAck(
        clientTurnId: _ids[n],
        turnId: 'turn-$n',
        status: GatewayRecoveryTurnStatus.accepted,
        lastSeq: 0,
        created: true,
      ),
    );

GatewayTurnRecoveryState _terminal(int n, String status) {
  final page = GatewayTurnReconcilePage.fromWire(
    {
      'automatic_resubmit': false,
      'mode': 'snapshot',
      'earliest_seq': 1,
      'last_seq': 4,
      'next_after_seq': 4,
      'has_more': false,
      'snapshot': {
        'turn_id': 'turn-$n',
        'client_turn_id': _ids[n],
        'status': status,
        'last_seq': 4,
        'assistant': {
          'message_id': 'msg-$n',
          'text': 'reply $n',
          // Every terminal snapshot this app accepts has a complete assistant.
          // The reviewer's interrupted page left it false, so parsing threw
          // before Stop could settle.
          'complete': true,
        },
        'attachment_manifest_digest':
            'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
        'final_message_ref': 7 + n,
      },
    },
    expectedAfterSeq: 0,
    expectedTurnId: 'turn-$n',
    expectedClientTurnId: _ids[n],
  )!;
  return _accepted(n).applyReconcilePage(page);
}

class _Turns extends InertTurnApplicationSession {
  final submitted = <String>[];
  final observers = <GatewayTurnStateCallback>[];
  Completer<void>? interruptGate;
  Object? rejectSubmit;
  int interrupts = 0;

  @override
  Future<GatewayTurnRecoveryState> submit({
    required String localSessionId,
    required String text,
    List<GatewayTurnAttachmentReceipt> attachments = const [],
    GatewayTurnStateCallback? onState,
  }) async {
    submitted.add(text);
    if (submitted.length > 1 && rejectSubmit != null) throw rejectSubmit!;
    final n = submitted.length - 1;
    if (onState != null) observers.add(onState);
    final state = _accepted(n);
    onState?.call(state);
    return state;
  }

  @override
  Future<GatewayTurnRecoveryState> interrupt({
    required String localSessionId,
    required String clientTurnId,
  }) async {
    interrupts++;
    await interruptGate?.future;
    final n = _ids.indexOf(clientTurnId);
    final state = _terminal(n, 'interrupted');
    for (final o in observers) {
      o(state);
    }
    return state;
  }
}

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

  Future<void> runAndQueue(WidgetTester tester, _Turns turns) async {
    await _pumpClassic(tester, turns);
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'Original task',
    );
    await tester.tap(find.byKey(const Key('chat-send-message')));
    await _pump(tester);
    expect(turns.submitted, ['Original task']);
    await tester.enterText(
      find.byKey(const Key('chat-message-composer')),
      'later',
    );
    await tester.tap(find.byKey(const Key('chat-queue-held')));
    await _pump(tester);
    expect(find.text('1 queued'), findsOneWidget);
  }

  testWidgets('a completed recovery-v2 turn drains the held prompt once', (
    tester,
  ) async {
    final turns = _Turns();
    await runAndQueue(tester, turns);
    for (final o in List.of(turns.observers)) {
      o(_terminal(0, 'completed'));
    }
    await _pump(tester);
    expect(turns.submitted, ['Original task', 'later']);
  });

  testWidgets('Resume during an in-flight Stop drains the held prompt', (
    tester,
  ) async {
    final turns = _Turns()..interruptGate = Completer<void>();
    await runAndQueue(tester, turns);
    await tester.tap(find.byKey(const Key('chat-stop-response')));
    await _pump(tester);
    expect(turns.interrupts, 1);
    expect(find.text('1 queued — paused'), findsOneWidget);
    await tester.tap(find.text('Resume'));
    await _pump(tester);
    expect(find.text('1 queued'), findsOneWidget);
    turns.interruptGate!.complete();
    await _pump(tester);
    await _pump(tester);
    expect(turns.submitted, ['Original task', 'later']);
  });

  testWidgets('a row send during an in-flight Stop unparks and drains', (
    tester,
  ) async {
    final turns = _Turns()..interruptGate = Completer<void>();
    await runAndQueue(tester, turns);
    await tester.tap(find.byKey(const Key('chat-stop-response')));
    await _pump(tester);
    expect(find.text('1 queued — paused'), findsOneWidget);
    await tester.tap(find.byTooltip('Send queued prompt'));
    await _pump(tester);
    turns.interruptGate!.complete();
    await _pump(tester);
    await _pump(tester);
    expect(turns.submitted, ['Original task', 'later']);
  });

  testWidgets('a refused recovery-v2 drain keeps the held prompt parked', (
    tester,
  ) async {
    final turns = _Turns()
      ..rejectSubmit = JsonRpcError('prompt.submit', 'refused', code: 4002);
    await runAndQueue(tester, turns);
    for (final o in List.of(turns.observers)) {
      o(_terminal(0, 'completed'));
    }
    await _pump(tester);
    expect(turns.submitted, ['Original task', 'later']);
    expect(find.byKey(const ValueKey('client-held-queue')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('client-held-queue')),
        matching: find.text('later'),
      ),
      findsOneWidget,
    );
    expect(find.text('1 queued \u2014 paused'), findsOneWidget);
    expect(find.textContaining('Send failed'), findsOneWidget);
  });
}

final _connection = SavedConnection(
  id: 'held-queue-recovery-probe',
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

Future<void> _pumpClassic(WidgetTester tester, _Turns turns) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChatScreen(
        connection: _connection,
        session: _session,
        testTurnApplicationSession: turns,
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
        testApiClient: ApiClient(
          baseUrl: 'http://fixture.invalid',
          apiKey: 'fixture-key',
          httpClient: _Json(),
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

class _Json extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      http.StreamedResponse(
        Stream.value(utf8.encode(jsonEncode({'data': []}))),
        200,
        headers: {'content-type': 'application/json'},
      );
}
