// Windows/Apple ports: the NextGen composer field sits under the real
// `SendOnEnter` (lib/core/widgets/desktop_shortcuts.dart), which sends on any
// Enter event without Shift. The slash suggestions box takes its keys on the
// field's own node first, so Enter or Tab that accept a row never reach
// `SendOnEnter` (nor do that key's repeats and key-up), and once the box is
// closed Enter sends through the real wrapper again.
// nextgen_slash_suggestions_test.dart covers the same with a stand-in.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/desktop_shortcuts.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _fieldKey = ValueKey('ng-composer-field');
const _boxKey = ValueKey('ng-slash-suggestions');

Key _row(String label) => ValueKey('ng-slash-suggestion-$label');

SavedConnection _connection() => SavedConnection(
  id: 'ng-suggest-send',
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

class _Call {
  const _Call(this.method, this.params);
  final String method;
  final Map<String, dynamic> params;
}

class _Gateway extends NextGenGateway {
  _Gateway() : super(_connection());

  final calls = <_Call>[];
  final WsClient _socket = WsClient('http://10.0.0.5:9119');

  @override
  WsClient? get socket => _socket;

  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => _socket;

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    calls.add(_Call(method, Map<String, dynamic>.of(params)));
    switch (method) {
      case 'commands.catalog':
        return {
          'pairs': [
            ['/help', 'Show help'],
            ['/title', 'Set the chat title (usage: /title <name>)'],
            ['/tools', 'Manage tools'],
          ],
        };
      case 'complete.slash':
        throw JsonRpcError(
          method,
          'Method not found: complete.slash',
          code: -32601,
        );
      case 'session.create':
        return {
          'session_id': 'rt-new',
          'stored_session_id': 'stored-new',
          'info': const <String, dynamic>{},
        };
      case 'prompt.submit':
        return {'status': 'started'};
      case 'slash.exec':
        return {'output': 'ok'};
    }
    return const {};
  }

  List<_Call> of(String method) =>
      calls.where((c) => c.method == method).toList();

  /// What reached the gateway as a send: commands run and prompts.
  List<String> get sent => [
    for (final c in calls)
      if (c.method == 'slash.exec')
        'exec ${c.params['command']}'
      else if (c.method == 'prompt.submit')
        'prompt ${c.params['text']}',
  ];
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 30));
  }
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(_fieldKey), text);
  await _settle(tester);
}

String _composer(WidgetTester tester) =>
    tester.widget<TextField>(find.byKey(_fieldKey)).controller!.text;

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    NextGenLook.instance
      ..themeMode = ThemeMode.dark
      ..accent = NgAccent.blue
      ..pureBlack = false
      ..glow = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, (_) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, null);
  });

  Future<_Gateway> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final prefs = await SharedPreferences.getInstance();
    final g = _Gateway();
    final chat = NgChatController(g)..runtimeId = 'rt-1';
    addTearDown(() {
      chat.dispose();
      g.dispose();
    });
    final m = ConnectionManager(prefs);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
        home: NgScope(
          connManager: m,
          gateway: g,
          connections: [g.connection],
          switchTo: (_) async {},
          addGateway: () async {},
          signOut: (_) async {},
          reload: () async {},
          signInAgain: () async {},
          child: Scaffold(
            body: NgChatView(
              chat: chat,
              onOpenSidebar: () {},
              onNewChat: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    // The port's wrapper is really there, around the composer field.
    expect(
      find.ancestor(
        of: find.byKey(_fieldKey),
        matching: find.byType(SendOnEnter),
      ),
      findsOneWidget,
    );
    return g;
  }

  testWidgets('Windows: Enter or Tab that accept a row, their repeats and '
      'key-up never reach SendOnEnter; Enter sends once the box is closed', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    try {
      final gateway = await pump(tester);

      await _type(tester, '/t');
      expect(find.byKey(_row('/title')), findsOneWidget);
      expect(find.byKey(_row('/tools')), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(_composer(tester), '/tools ');
      expect(find.byKey(_boxKey), findsNothing);
      expect(gateway.sent, isEmpty, reason: 'Enter accepted, not sent');

      // Enter held down: the accepting key-down, repeats, then key-up.
      await _type(tester, '/hel');
      expect(find.byKey(_row('/help')), findsOneWidget);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(_composer(tester), '/help ');
      expect(gateway.sent, isEmpty, reason: 'repeats and key-up swallowed');

      await _type(tester, '/ti');
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await _settle(tester);
      expect(_composer(tester), '/title ');
      expect(gateway.sent, isEmpty);

      // Box closed: the real SendOnEnter runs the command.
      await _type(tester, '/help ');
      expect(find.byKey(_boxKey), findsNothing);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(gateway.sent, ['exec help']);
      expect(_composer(tester), '');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('Windows: a command typed in full runs on Enter; with no '
      'matching row Enter sends the text as typed', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    try {
      final gateway = await pump(tester);

      await _type(tester, '/help');
      expect(find.byKey(_row('/help')), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(gateway.sent, [
        'exec help',
      ], reason: 'run as typed, not accepted as "/help "');
      expect(find.byKey(_boxKey), findsNothing);
      expect(_composer(tester), '');

      await _type(tester, '/zzz');
      expect(
        find.descendant(
          of: find.byKey(_boxKey),
          matching: find.text('No matching commands'),
        ),
        findsOneWidget,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(gateway.sent, ['exec help', 'prompt /zzz']);
      expect(_composer(tester), '');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
