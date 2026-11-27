// The Classic composer stays above the on-screen keyboard where the chat is
// nested in another Scaffold: the Parallel workspace (reached from More on a
// phone), and any outer Scaffold that has already resized for the keyboard.
// Field, Attach and Send must sit above the keyboard top and be
// hit-testable, nothing may overflow, and a long draft scrolls inside the
// editor. When space is tight the non-essential chrome (the workspace tab
// strip, the chat's context header, the model/status row) folds away and
// comes back when the keyboard closes.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/screens/classic_parallel_workspace.dart';
import 'package:hermes_android/core/services/composer_session_rpc.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/widgets/chat_context_header.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/completed_stock_turn.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/parallel_workspace_fixture.dart';
import 'support/pump_chat_updates.dart';

const _field = Key('chat-message-composer');

final _long = List.generate(
  40,
  (i) => 'line $i of a long draft that wraps on a phone',
).join('\n');

class _Case {
  const _Case(this.size, this.kb, this.scale, this.long, [this.status = false]);
  final Size size;
  final double kb;
  final double scale;
  final bool long;
  final bool status;
  @override
  String toString() =>
      '${size.width.toInt()}x${size.height.toInt()} kb${kb.toInt()} '
      'x$scale ${long ? 'long40' : 'short'} status-${status ? 'on' : 'off'}';
}

List<_Case> _cases({bool status = false}) => [
  for (final size in const [Size(320, 640), Size(390, 844)])
    for (final kb in const [260.0, 340.0])
      for (final scale in const [1.0, 2.0])
        for (final long in const [false, true])
          for (final s in status ? const [false, true] : const [false])
            _Case(size, kb, scale, long, s),
  for (final scale in const [1.0, 2.0])
    for (final long in const [false, true])
      for (final s in status ? const [false, true] : const [false])
        _Case(const Size(844, 390), 200, scale, long, s),
];

Map<String, dynamic> _breakdown() => {
  'categories': [
    for (var i = 0; i < 20; i++)
      {
        'id': 'c$i',
        'label': 'Category number $i',
        'tokens': 900 * (i + 1),
        'color': '#888888',
      },
  ],
  'context_max': 200000,
  'context_used': 189000,
  'context_percent': 94,
};

class _Rpc implements ComposerSessionRpc {
  @override
  bool hasLiveSession(String mobileSessionId) => true;
  Map<String, dynamic> _answer(String method) =>
      method == 'session.context_breakdown' ? _breakdown() : const {};
  @override
  Future<Map<String, dynamic>> requestSessionRpc(
    String method,
    Map<String, dynamic> params,
  ) async => _answer(method);
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params,
  ) async => _answer(method);
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void _expectAboveKeyboard(WidgetTester tester, String label, _Case c) {
  final errors = <String>[];
  Object? e;
  while ((e = tester.takeException()) != null) {
    errors.add(e.toString().split('\n').first);
  }
  final top = c.size.height - c.kb;
  final field = find.byKey(_field);
  final buttons = {
    'attach': find.byTooltip('Attach image or file'),
    'send': find.byKey(const Key('chat-send-message')),
  };
  final fieldRect = tester.getRect(field);
  final scrollable = find.descendant(
    of: field,
    matching: find.byType(Scrollable),
  );
  final position = scrollable.evaluate().isEmpty
      ? null
      : tester.state<ScrollableState>(scrollable.first).position;
  final where =
      '$label $c field=${fieldRect.top.toInt()}..${fieldRect.bottom.toInt()} '
      'kbTop=${top.toInt()} errors=$errors';
  expect(errors, isEmpty, reason: where);
  expect(fieldRect.top, greaterThanOrEqualTo(0), reason: where);
  expect(fieldRect.bottom, lessThanOrEqualTo(top + 0.5), reason: where);
  expect(fieldRect.width, greaterThanOrEqualTo(80), reason: where);
  expect(fieldRect.height, greaterThanOrEqualTo(20), reason: where);
  expect(field.hitTestable(), findsOneWidget, reason: '$where field hit');
  for (final MapEntry(:key, :value) in buttons.entries) {
    expect(value, findsWidgets, reason: '$where $key missing');
    final r = tester.getRect(value.first);
    expect(r.top, greaterThanOrEqualTo(0), reason: '$where $key $r');
    expect(r.bottom, lessThanOrEqualTo(top + 0.5), reason: '$where $key $r');
    expect(value.hitTestable(), findsWidgets, reason: '$where $key hit');
  }
  if (c.long) {
    expect(position, isNotNull, reason: '$where no editor scrollable');
    expect(
      position!.maxScrollExtent,
      greaterThan(0),
      reason: '$where editor does not scroll internally',
    );
  }
}

Future<void> _pumpWorkspace(WidgetTester tester, _Case c) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = c.size;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.textScaleFactorTestValue = c.scale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final f = ParallelFixture();
  await tester.pumpWidget(
    MaterialApp(
      theme: hermesTheme(Brightness.light),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ClassicParallelWorkspace(
        connection: f.connection,
        clientFactory: f.api,
      ),
    ),
  );
  await _settle(tester);
  await tester.tap(find.byTooltip('Add chat'));
  await _settle(tester);
  await tester.tap(find.text('Chat alpha').last);
  await _settle(tester);
  expect(find.byType(ChatScreen), findsOneWidget);
}

Future<void> _type(WidgetTester tester, _Case c) async {
  tester.view.viewInsets = FakeViewPadding(bottom: c.kb);
  await pumpChatUpdates(tester);
  await tester.showKeyboard(find.byKey(_field));
  await tester.enterText(
    find.byKey(_field),
    c.long ? _long : 'steer this please',
  );
  await pumpChatUpdates(tester);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockChatImageRecovery();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, (_) async => null);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, null);
  });

  group('Classic Parallel workspace pane', () {
    for (final c in _cases()) {
      testWidgets('$c: composer above the keyboard', (tester) async {
        await _pumpWorkspace(tester, c);
        await _type(tester, c);
        _expectAboveKeyboard(tester, 'Classic parallel', c);
      });
    }

    testWidgets('tight space folds the tab strip and context header while '
        'the keyboard is up; both come back when it closes', (tester) async {
      const c = _Case(Size(320, 640), 340, 1.0, false);
      await _pumpWorkspace(tester, c);
      expect(find.byType(InputChip), findsOneWidget);
      expect(find.byType(ChatContextHeader), findsOneWidget);
      await _type(tester, c);
      expect(find.byType(InputChip), findsNothing);
      expect(find.byType(ChatContextHeader), findsNothing);
      _expectAboveKeyboard(tester, 'Classic parallel', c);
      tester.view.resetViewInsets();
      await pumpChatUpdates(tester);
      expect(find.byType(InputChip), findsOneWidget);
      expect(find.byType(ChatContextHeader), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('typing in the second of a stacked pair: the keyboard '
        'squeezes the pair to one pane, and that pane stays the one shown', (
      tester,
    ) async {
      const c = _Case(Size(390, 844), 340, 1.0, false);
      await _pumpWorkspace(tester, c);
      await tester.tap(find.byTooltip('Workspace options'));
      await _settle(tester);
      await tester.tap(find.text('Dock another pane'));
      await _settle(tester);
      await tester.tap(find.text('Chat beta').last);
      await _settle(tester);
      await tester.tap(find.byTooltip('Workspace options'));
      await _settle(tester);
      await tester.tap(find.text('Arrange top to bottom'));
      await _settle(tester);
      Finder betaField() => find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is ChatScreen && w.session.id == 'beta',
        ),
        matching: find.byKey(_field),
      );
      expect(find.byKey(_field), findsNWidgets(2), reason: 'both panes show');
      await tester.tap(betaField());
      await tester.showKeyboard(betaField());
      await tester.enterText(betaField(), 'steer this please');
      tester.view.viewInsets = FakeViewPadding(bottom: c.kb);
      await pumpChatUpdates(tester);
      expect(betaField(), findsOneWidget, reason: 'the typed pane went away');
      final field = tester.getRect(betaField());
      expect(field.bottom, lessThanOrEqualTo(c.size.height - c.kb + 0.5));
      expect(betaField().hitTestable(), findsOneWidget);
      expect(
        tester.widget<TextField>(betaField()).focusNode!.hasFocus,
        isTrue,
        reason: 'the typed pane lost focus (the keyboard would close)',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('a roomy pane keeps its chrome with the keyboard up', (
      tester,
    ) async {
      const c = _Case(Size(390, 844), 260, 1.0, false);
      await _pumpWorkspace(tester, c);
      await _type(tester, c);
      expect(find.byType(InputChip), findsOneWidget);
      expect(find.byType(ChatContextHeader), findsOneWidget);
      _expectAboveKeyboard(tester, 'Classic parallel', c);
    });
  });

  group('Classic chat inside an outer Scaffold', () {
    for (final c in _cases(status: true)) {
      testWidgets('$c: composer above the keyboard', (tester) async {
        SharedPreferences.setMockInitialValues({
          'verbose_mode': true,
          if (c.status) 'composer_status_hidden_v1': <String>[],
        });
        tester.view.physicalSize = c.size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        tester.platformDispatcher.textScaleFactorTestValue = c.scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final screen = ChatScreen(
          connection: SavedConnection(
            id: 'kb-nested-${c.hashCode}',
            label: 'kb',
            host: 'kb.fixture',
            port: 8642,
            apiKey: 'fixture',
          ),
          session: const Session(
            id: 'kb-parent',
            title: 'Parent',
            model: 'fixture',
            source: 'api_server',
            messageCount: 2,
            isActive: true,
            preview: '',
            startedAt: 1,
          ),
          testApiClient: ApiClient(
            baseUrl: 'http://kb.fixture',
            apiKey: 'fixture',
            httpClient: MockClient(
              (_) async => http.Response(jsonEncode({'data': []}), 200),
            ),
          ),
          testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
          testComposerRpc: _Rpc(),
          testRemotePromptSubmit: completedStockTurn(({
            required sessionId,
            required text,
            required onEvent,
            required onSent,
          }) async {
            onSent();
          }),
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: hermesTheme(Brightness.light),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: screen),
          ),
        );
        await pumpChatUpdates(tester);
        await _type(tester, c);
        final toggle = find.byKey(
          const ValueKey('composer-context-breakdown-toggle'),
        );
        if (c.status && toggle.hitTestable().evaluate().isNotEmpty) {
          await tester.tap(toggle.hitTestable().first);
          await pumpChatUpdates(tester);
        }
        _expectAboveKeyboard(tester, 'Classic nested', c);
      });
    }
  });
}
