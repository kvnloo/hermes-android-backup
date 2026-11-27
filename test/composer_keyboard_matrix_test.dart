// The composer above the keyboard in both layouts (from the c830319a
// re-check's keyboard probe; the Parallel workspace hosts are in
// classic_parallel_keyboard_test and nextgen_parallel_keyboard_test).
// NextGen and Classic, each bare (pop-out / pushed route) and nested in an
// outer Scaffold (main page / workspace pane), at 320x640 and 390x844 with
// 260 and 340 px keyboards, 1.0x and 2.0x text, short and 40-line drafts,
// status off and on (breakdown open); plus landscape 844x390 with a 200 px
// keyboard. Field, Attach, mic and Send must be above the keyboard and
// hit-testable, no exception (RenderFlex overflow), and a long draft must
// scroll inside the editor.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/composer_session_rpc.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
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

import 'support/completed_stock_turn.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _ngField = ValueKey('ng-composer-field');
const _clField = Key('chat-message-composer');

final _long = List.generate(
  40,
  (i) => 'line $i of a long draft that wraps on a phone',
).join('\n');

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

SavedConnection _ngConnection() => SavedConnection(
  id: 'ng-kb',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: '',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
  dashboardProxied: true,
  gatewayProfile: 'work',
);

class _NgGateway extends NextGenGateway {
  _NgGateway(DashboardClient d) : super(_ngConnection(), dashboard: d);
  WsClient current = WsClient('http://10.0.0.5:9119');
  @override
  WsClient? get socket => current;
  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);
  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => current;
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (method == 'session.context_breakdown') return _breakdown();
    if (method == 'commands.catalog') return {'pairs': const <Object>[]};
    return const {};
  }
}

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

class _Case {
  const _Case(this.size, this.kb, this.scale, this.long, this.status);
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

List<_Case> _cases() => [
  for (final size in const [Size(320, 640), Size(390, 844)])
    for (final kb in const [260.0, 340.0])
      for (final scale in const [1.0, 2.0])
        for (final long in const [false, true])
          for (final status in const [false, true])
            _Case(size, kb, scale, long, status),
  for (final scale in const [1.0, 2.0])
    for (final long in const [false, true])
      for (final status in const [false, true])
        _Case(const Size(844, 390), 200, scale, long, status),
];

void _log(String s) {
  // ignore: avoid_print
  print(s);
}

Future<void> _check(
  WidgetTester tester,
  String label,
  _Case c,
  Finder field,
  Map<String, Finder> buttons,
) async {
  final errors = <String>[];
  Object? e;
  while ((e = tester.takeException()) != null) {
    errors.add(e.toString().split('\n').first);
  }
  final top = c.size.height - c.kb;
  final fieldRect = tester.getRect(field);
  final scrollable = find.descendant(
    of: field,
    matching: find.byType(Scrollable),
  );
  final position = scrollable.evaluate().isEmpty
      ? null
      : tester.state<ScrollableState>(scrollable.first).position;
  final rects = <String, Rect?>{
    for (final entry in buttons.entries)
      entry.key: entry.value.evaluate().isEmpty
          ? null
          : tester.getRect(entry.value.first),
  };
  final hits = <String, bool>{
    'field': field.hitTestable().evaluate().isNotEmpty,
    for (final entry in buttons.entries)
      entry.key: entry.value.hitTestable().evaluate().isNotEmpty,
  };
  final status = find
      .byKey(const ValueKey('composer-context-breakdown-toggle'))
      .evaluate()
      .isNotEmpty;
  _log(
    'KB $label $c field=${fieldRect.top.toStringAsFixed(0)}..'
    '${fieldRect.bottom.toStringAsFixed(0)} w=${fieldRect.width.toInt()} '
    'kbTop=${top.toInt()} scrollMax=${position?.maxScrollExtent.toStringAsFixed(0)} '
    'status=$status '
    'buttons=${rects.map((k, v) => MapEntry(k, v == null ? 'none' : '${v.top.toInt()}..${v.bottom.toInt()}'))} '
    'hits=$hits errors=$errors',
  );
  expect(errors, isEmpty, reason: '$label $c');
  expect(fieldRect.top, greaterThanOrEqualTo(0), reason: '$label $c field top');
  expect(
    fieldRect.bottom,
    lessThanOrEqualTo(top + 0.5),
    reason: '$label $c field bottom',
  );
  expect(fieldRect.width, greaterThanOrEqualTo(80), reason: '$label $c width');
  expect(
    fieldRect.height,
    greaterThanOrEqualTo(20),
    reason: '$label $c height',
  );
  for (final entry in rects.entries) {
    final r = entry.value;
    expect(r, isNotNull, reason: '$label $c ${entry.key} missing');
    expect(r!.top, greaterThanOrEqualTo(0), reason: '$label $c ${entry.key}');
    expect(
      r.bottom,
      lessThanOrEqualTo(top + 0.5),
      reason: '$label $c ${entry.key}',
    );
  }
  for (final entry in hits.entries) {
    expect(entry.value, isTrue, reason: '$label $c ${entry.key} hit-test');
  }
  if (c.long) {
    expect(position, isNotNull, reason: '$label $c no editor scrollable');
    expect(
      position!.maxScrollExtent,
      greaterThan(0),
      reason: '$label $c editor does not scroll internally',
    );
  }
}

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, (_) async => null);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, null);
  });

  for (final nested in [true, false]) {
    for (final c in _cases()) {
      final label = 'NextGen ${nested ? 'nested' : 'bare'}';
      testWidgets('$label $c', (tester) async {
        SharedPreferences.setMockInitialValues({
          if (c.status) 'composer_status_hidden_v1': <String>[],
        });
        NextGenLook.instance
          ..themeMode = ThemeMode.dark
          ..accent = NgAccent.blue
          ..pureBlack = false
          ..glow = true;
        tester.view.physicalSize = c.size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        tester.platformDispatcher.textScaleFactorTestValue = c.scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final prefs = await SharedPreferences.getInstance();
        final gateway = _NgGateway(
          DashboardClient(
            host: '10.0.0.5',
            proxied: true,
            httpClient: MockClient(
              (_) async => http.Response(
                jsonEncode({'messages': const <Object>[]}),
                200,
                headers: {'content-type': 'application/json'},
              ),
            ),
          ),
        );
        final chat = NgChatController(gateway, sessionId: 'stored-1')
          ..runtimeId = 'rt-1';
        addTearDown(() {
          chat.dispose();
          gateway.dispose();
        });
        final view = NgChatView(chat: chat, onOpenSidebar: () {});
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
            home: NgScope(
              connManager: ConnectionManager(prefs),
              gateway: gateway,
              connections: [gateway.connection],
              switchTo: (_) async {},
              addGateway: () async {},
              signOut: (_) async {},
              reload: () async {},
              signInAgain: () async {},
              child: nested ? Scaffold(body: view) : view,
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        if (c.status) {
          chat.running = true;
          chat.turnStartedAt = DateTime.now();
        }
        tester.view.viewInsets = FakeViewPadding(bottom: c.kb);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.showKeyboard(find.byKey(_ngField));
        await tester.enterText(
          find.byKey(_ngField),
          c.long ? _long : 'steer this please',
        );
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }
        final toggle = find.byKey(
          const ValueKey('composer-context-breakdown-toggle'),
        );
        if (c.status && toggle.hitTestable().evaluate().isNotEmpty) {
          await tester.tap(toggle.hitTestable().first);
          for (var i = 0; i < 6; i++) {
            await tester.pump(const Duration(milliseconds: 50));
          }
        }
        await _check(tester, label, c, find.byKey(_ngField), {
          'attach': find.byTooltip('Attach'),
          'mic': find.byTooltip('Dictate'),
          'send': find.byTooltip('Send'),
        });
      });
    }
  }

  for (final nested in [true, false]) {
    for (final c in _cases()) {
      final label = 'Classic ${nested ? 'nested' : 'bare'}';
      testWidgets('$label $c', (tester) async {
        SharedPreferences.setMockInitialValues({
          'verbose_mode': true,
          if (c.status) 'composer_status_hidden_v1': <String>[],
        });
        mockChatImageRecovery();
        tester.view.physicalSize = c.size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        tester.platformDispatcher.textScaleFactorTestValue = c.scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final screen = ChatScreen(
          connection: SavedConnection(
            id: 'kb-${c.hashCode}',
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
            home: nested ? Scaffold(body: screen) : screen,
          ),
        );
        await pumpChatUpdates(tester);
        tester.view.viewInsets = FakeViewPadding(bottom: c.kb);
        await pumpChatUpdates(tester);
        await tester.showKeyboard(find.byKey(_clField));
        await tester.enterText(
          find.byKey(_clField),
          c.long ? _long : 'steer this please',
        );
        await pumpChatUpdates(tester);
        final toggle = find.byKey(
          const ValueKey('composer-context-breakdown-toggle'),
        );
        if (c.status && toggle.hitTestable().evaluate().isNotEmpty) {
          await tester.tap(toggle.hitTestable().first);
          await pumpChatUpdates(tester);
        }
        await _check(tester, label, c, find.byKey(_clField), {
          'attach': find.byTooltip('Attach image or file'),
          'send': find.byKey(const Key('chat-send-message')),
        });
      });
    }
  }
}
