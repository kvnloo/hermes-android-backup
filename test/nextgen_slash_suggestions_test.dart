// NextGen composer: typing `/` shows a box of suggested commands above the
// composer, like Hermes Desktop, Kyllene and Ares Classic. Matches come from
// the gateway's `complete.slash` (debounced, newest typing wins), else from
// the scoped `commands.catalog`, plus NextGen's own `/new` `/reset` `/stop`
// `/model`. Picking a row fills the composer; it never sends. Uses only
// public NextGen widgets and keys, so the same file runs (red) against a
// build without the box.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _fieldKey = ValueKey('ng-composer-field');
const _boxKey = ValueKey('ng-slash-suggestions');
const _infoKey = ValueKey('slash-command-info');

Key _row(String label) => ValueKey('ng-slash-suggestion-$label');

SavedConnection _connection() => SavedConnection(
  id: 'ng-suggest',
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

/// The gateway's real `commands.catalog` shape. NextGen's own `/new`,
/// `/reset`, `/stop` and `/model` are deliberately missing.
Map<String, dynamic> _wireCatalog() => {
  'pairs': [
    ['/help', 'Show help'],
    ['/title', 'Set the chat title (usage: /title <name>)'],
    ['/background', 'Run a prompt in the background'],
    ['/personality', 'Set a personality'],
    ['/tools', 'Manage tools'],
    ['/review', 'Review a diff'],
  ],
  'canon': {'/bg': '/background'},
  'categories': [
    {
      'name': 'Session',
      'pairs': [
        ['/help', 'Show help'],
        ['/title', 'Set the chat title (usage: /title <name>)'],
      ],
    },
  ],
  'skills': {
    '/review': {'usage': 0, 'origin': 'local'},
  },
  'plugin_commands': {'deploy': 'Deploy the current build'},
};

class _Call {
  const _Call(this.method, this.params);
  final String method;
  final Map<String, dynamic> params;
}

typedef _Handler =
    FutureOr<Map<String, dynamic>> Function(Map<String, dynamic> params);

class _Gateway extends NextGenGateway {
  _Gateway() : super(_connection());

  final calls = <_Call>[];
  final handlers = <String, _Handler>{};
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
    final handler = handlers[method];
    if (handler != null) return await handler(params);
    switch (method) {
      case 'commands.catalog':
        return _wireCatalog();
      case 'complete.slash':
        // An older gateway: no completion RPC.
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
    }
    return const {};
  }

  List<_Call> of(String method) =>
      calls.where((c) => c.method == method).toList();

  List<String> get completions =>
      of('complete.slash').map((c) => c.params['text'] as String).toList();
}

Map<String, dynamic> _item(
  String text,
  String meta, {
  String? display,
  String kind = 'command',
}) => {'text': text, 'display': ?display, 'meta': meta, 'kind': kind};

Widget _app(
  NgChatController chat,
  NextGenGateway gateway,
  ConnectionManager m, {
  FocusOnKeyEventCallback? outerKeys,
}) {
  Widget view = NgChatView(chat: chat, onOpenSidebar: () {}, onNewChat: () {});
  if (outerKeys != null) {
    // Stands in for the Windows/Apple ports' `SendOnEnter`: a Focus above
    // the field that sends on Enter.
    view = Focus(onKeyEvent: outerKeys, child: view);
  }
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
    home: NgScope(
      connManager: m,
      gateway: gateway,
      connections: [gateway.connection],
      switchTo: (_) async {},
      addGateway: () async {},
      signOut: (_) async {},
      reload: () async {},
      signInAgain: () async {},
      child: Scaffold(body: view),
    ),
  );
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

TextEditingValue _value(WidgetTester tester) =>
    tester.widget<TextField>(find.byKey(_fieldKey)).controller!.value;

String _composer(WidgetTester tester) => _value(tester).text;

EditableTextState _editable(WidgetTester tester) => tester.state(
  find.descendant(
    of: find.byKey(_fieldKey),
    matching: find.byType(EditableText),
  ),
);

bool _fieldFocused(WidgetTester tester) =>
    _editable(tester).widget.focusNode.hasFocus;

Finder _inBox(String text) =>
    find.descendant(of: find.byKey(_boxKey), matching: find.text(text));

Rect _editableRect(WidgetTester tester) {
  final editable = _editable(tester).renderEditable;
  return editable.localToGlobal(Offset.zero) & editable.size;
}

/// The composer's rounded input container (the field's nearest decorated
/// Container ancestor).
Rect _inputContainerRect(WidgetTester tester) {
  final container = find
      .ancestor(of: find.byKey(_fieldKey), matching: find.byType(Container))
      .evaluate()
      .map((element) => element.widget as Container)
      .firstWhere((widget) => widget.decoration is BoxDecoration);
  return tester.getRect(find.byWidget(container));
}

Map<String, Rect> _controlRects(WidgetTester tester) {
  final finders = <String, Finder>{
    'attach': find.byTooltip('Attach'),
    'model': find.byKey(const ValueKey('ng-model-picker')),
    'dictate': find.byTooltip('Dictate'),
    'send': find.byTooltip('Send'),
  };
  return {
    for (final entry in finders.entries)
      if (entry.value.evaluate().isNotEmpty)
        entry.key: tester.getRect(entry.value.first),
  };
}

Future<void> _tapText(WidgetTester tester, int start, int end) async {
  await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 50));
  final editable = _editable(tester).renderEditable;
  final box = editable
      .getBoxesForSelection(TextSelection(baseOffset: start, extentOffset: end))
      .first;
  await tester.tapAt(editable.localToGlobal(box.toRect().center));
  await _settle(tester);
}

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

  Future<(_Gateway, NgChatController)> pump(
    WidgetTester tester, {
    String? runtimeId,
    _Gateway? gateway,
    FocusOnKeyEventCallback? outerKeys,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final g = gateway ?? _Gateway();
    final chat = NgChatController(g)..runtimeId = runtimeId;
    addTearDown(() {
      chat.dispose();
      g.dispose();
    });
    await tester.pumpWidget(
      _app(chat, g, ConnectionManager(prefs), outerKeys: outerKeys),
    );
    await tester.pump(const Duration(milliseconds: 300));
    return (g, chat);
  }

  testWidgets('typing / shows the box with the catalogue, skills marked and '
      "NextGen's own commands included", (tester) async {
    final (gateway, _) = await pump(tester, runtimeId: 'rt-1');
    expect(find.byKey(_boxKey), findsNothing);

    await _type(tester, 'hello');
    expect(find.byKey(_boxKey), findsNothing, reason: 'prose never opens it');

    await _type(tester, '/');
    expect(find.byKey(_boxKey), findsOneWidget);
    expect(gateway.of('commands.catalog').single.params, {
      'session_id': 'rt-1',
    });
    for (final name in ['/help', '/title', '/background', '/review']) {
      expect(find.byKey(_row(name)), findsOneWidget, reason: name);
    }
    expect(_inBox('Show help'), findsOneWidget);
    expect(_inBox('Set the chat title (usage: /title <name>)'), findsOneWidget);
    // Only the skill row carries the Skill mark.
    expect(
      find.descendant(
        of: find.byKey(_row('/review')),
        matching: find.text('Skill'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(_row('/help')),
        matching: find.text('Skill'),
      ),
      findsNothing,
    );

    await _type(tester, '/st');
    expect(
      find.byKey(_row('/stop')),
      findsOneWidget,
      reason: 'local commands appear even when the catalogue lacks them',
    );
    await _type(tester, '/mod');
    expect(find.byKey(_row('/model')), findsOneWidget);
    await _type(tester, '/b');
    expect(find.byKey(_row('/background')), findsOneWidget);
    expect(find.byKey(_row('/bg')), findsOneWidget, reason: 'alias');

    // The composer field is never replaced or unfocused by the box.
    expect(_fieldFocused(tester), isTrue);
    expect(_composer(tester), '/b');
  });

  testWidgets('/ti filters to /title (prefix, then substring) and an unknown '
      'name says so', (tester) async {
    final (_, _) = await pump(tester);
    await _type(tester, '/ti');
    expect(find.byKey(_row('/title')), findsOneWidget);
    expect(find.byKey(_row('/help')), findsNothing);
    expect(find.byKey(_row('/background')), findsNothing);

    await _type(tester, '/elp');
    expect(find.byKey(_row('/help')), findsOneWidget, reason: 'substring');

    await _type(tester, '/zzz');
    expect(find.byKey(_boxKey), findsOneWidget);
    expect(_inBox('No matching commands'), findsOneWidget);
  });

  testWidgets('complete.slash: debounced, scoped to the live session, its '
      'ranking wins, rows that would not run are dropped and a slow '
      'reply for older typing is ignored', (tester) async {
    final gateway = _Gateway();
    final held = Completer<Map<String, dynamic>>();
    gateway.handlers['complete.slash'] = (params) {
      switch (params['text']) {
        case '/t':
          return held.future;
        case '/ti':
          return {
            'items': [
              _item('title', 'Server: set the title', display: '/title'),
              // A TUI-only command the catalogue does not list never shows.
              _item('tips', 'TUI tips', display: '/tips'),
            ],
            'replace_from': 1,
          };
        case '/re':
          return {
            'items': [
              _item(
                'review',
                '⚡ Review a diff',
                display: '/review',
                kind: 'skill',
              ),
            ],
            'replace_from': 1,
          };
      }
      return {'items': const <Object>[], 'replace_from': 1};
    };
    await pump(tester, runtimeId: 'rt-1', gateway: gateway);

    // A bare `/` browses the catalogue without asking.
    await _type(tester, '/');
    expect(find.byKey(_row('/help')), findsOneWidget);
    expect(gateway.completions, isEmpty);

    // Fast typing asks once, for the latest text.
    await tester.enterText(find.byKey(_fieldKey), '/x');
    await tester.pump(const Duration(milliseconds: 40));
    await tester.enterText(find.byKey(_fieldKey), '/xy');
    await _settle(tester);
    expect(gateway.completions, ['/xy']);
    expect(gateway.of('complete.slash').single.params, {
      'text': '/xy',
      'session_id': 'rt-1',
    });

    await _type(tester, '/t');
    expect(gateway.completions.last, '/t', reason: 'held');
    await _type(tester, '/ti');
    expect(gateway.completions.last, '/ti');
    expect(_inBox('Server: set the title'), findsOneWidget);
    expect(find.byKey(_row('/tips')), findsNothing);

    // The reply for `/t` lands after the newer typing: ignored.
    held.complete({
      'items': [_item('tools', 'STALE tools', display: '/tools')],
      'replace_from': 1,
    });
    await _settle(tester);
    expect(find.text('STALE tools'), findsNothing);
    expect(_inBox('Server: set the title'), findsOneWidget);
    expect(_composer(tester), '/ti');

    await _type(tester, '/re');
    expect(
      find.descendant(
        of: find.byKey(_row('/review')),
        matching: find.text('Skill'),
      ),
      findsOneWidget,
    );
    expect(_inBox('Review a diff'), findsOneWidget, reason: 'glyph trimmed');
  });

  testWidgets('a draft chat asks without a session id (the socket adds the '
      'profile, as for every NextGen call)', (tester) async {
    final gateway = _Gateway();
    gateway.handlers['complete.slash'] = (params) => {
      'items': [_item('help', 'Show help', display: '/help')],
      'replace_from': 1,
    };
    await pump(tester, gateway: gateway);
    await _type(tester, '/he');
    expect(gateway.of('complete.slash').single.params, {'text': '/he'});
    expect(find.byKey(_row('/help')), findsOneWidget);
  });

  testWidgets('method-not-found falls back to the catalogue and is not asked '
      'again on that socket', (tester) async {
    final (gateway, _) = await pump(tester, runtimeId: 'rt-1');
    await _type(tester, '/ti');
    expect(gateway.completions, ['/ti']);
    expect(find.byKey(_row('/title')), findsOneWidget);
    expect(_inBox('Set the chat title (usage: /title <name>)'), findsOneWidget);
    await _type(tester, '/he');
    expect(find.byKey(_row('/help')), findsOneWidget);
    expect(gateway.completions, ['/ti'], reason: 'remembered per socket');
  });

  testWidgets('a failing complete.slash also falls back, for that query', (
    tester,
  ) async {
    final gateway = _Gateway();
    gateway.handlers['complete.slash'] = (_) =>
        throw JsonRpcError('complete.slash', 'boom', code: 5020);
    await pump(tester, gateway: gateway);
    await _type(tester, '/ti');
    expect(find.byKey(_row('/title')), findsOneWidget);
    await _type(tester, '/he');
    expect(gateway.completions, ['/ti', '/he'], reason: 'not remembered');
    expect(find.byKey(_row('/help')), findsOneWidget);
  });

  testWidgets('desktop: arrows + Enter or Tab accept without sending, even '
      'under a send-on-Enter wrapper; Enter sends once the box is closed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    try {
      var sends = 0;
      // The ports' `shouldSendOnEnter`: any Enter event without Shift.
      KeyEventResult sendOnEnter(FocusNode node, KeyEvent event) {
        if ((event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.numpadEnter) &&
            !HardwareKeyboard.instance.isShiftPressed) {
          sends++;
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      }

      final (gateway, _) = await pump(
        tester,
        runtimeId: 'rt-1',
        outerKeys: sendOnEnter,
      );
      await _type(tester, '/t');
      expect(find.byKey(_row('/title')), findsOneWidget);
      expect(find.byKey(_row('/tools')), findsOneWidget);

      // First row is marked; Down moves to the second, Up back, Down again.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(_composer(tester), '/tools ');
      expect(
        _value(tester).selection,
        const TextSelection.collapsed(offset: 7),
      );
      expect(sends, 0, reason: 'Enter (down and up) accepted, not sent');
      expect(_fieldFocused(tester), isTrue);
      expect(find.byKey(_boxKey), findsNothing);
      expect(gateway.of('prompt.submit'), isEmpty);
      expect(gateway.of('slash.exec'), isEmpty);

      await _type(tester, '/hel');
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await _settle(tester);
      expect(_composer(tester), '/help ');
      expect(_fieldFocused(tester), isTrue, reason: 'Tab did not move focus');
      expect(sends, 0);

      // Box closed: Enter belongs to sending again. 5.0.0 builds the
      // ports' send-on-Enter into the composer (SendOnEnter), inside any
      // outer wrapper, so the command runs once and the wrapper stays idle.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(gateway.of('slash.exec').single.params['command'], 'help');
      expect(_composer(tester), isEmpty);
      expect(sends, 0, reason: 'sent once, by the composer');
      expect(gateway.of('prompt.submit'), isEmpty);

      // A command typed in full: Enter is not taken by the box (the
      // composer sends `/help` as typed) and the box closes; Tab still
      // accepts.
      await _type(tester, '/help');
      expect(find.byKey(_row('/help')), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(gateway.of('slash.exec'), hasLength(2));
      expect(_composer(tester), isEmpty);
      expect(sends, 0);
      expect(find.byKey(_boxKey), findsNothing);
      await _type(tester, '/hel');
      await _type(tester, '/help');
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await _settle(tester);
      expect(_composer(tester), '/help ');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('desktop: with no matching row Enter is not taken', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    try {
      var sends = 0;
      final (gateway, _) = await pump(
        tester,
        outerKeys: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            sends++;
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
      );
      await _type(tester, '/zzz');
      expect(_inBox('No matching commands'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      // The box let Enter through: the composer's SendOnEnter sent `/zzz`
      // as an ordinary prompt (not a gateway command), once.
      expect(_composer(tester), isEmpty);
      expect(gateway.of('slash.exec'), isEmpty);
      expect(gateway.of('prompt.submit'), hasLength(1));
      expect(sends, 0, reason: 'sent once, by the composer');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('tapping a row fills the composer, keeps focus and the '
      'keyboard, and sends nothing', (tester) async {
    final (gateway, _) = await pump(tester, runtimeId: 'rt-1');
    await _type(tester, '/ti');
    await tester.tap(find.byKey(_row('/title')));
    await _settle(tester);
    expect(_composer(tester), '/title ');
    expect(_value(tester).selection, const TextSelection.collapsed(offset: 7));
    expect(_fieldFocused(tester), isTrue);
    expect(tester.testTextInput.isVisible, isTrue);
    expect(find.byKey(_boxKey), findsNothing);
    expect(gateway.of('prompt.submit'), isEmpty);
    expect(gateway.of('slash.exec'), isEmpty);
    expect(gateway.of('session.create'), isEmpty);

    // A token with text after it: only the token is replaced.
    await _type(tester, '/ba now please');
    await tester.pump();
    final controller = tester
        .widget<TextField>(find.byKey(_fieldKey))
        .controller!;
    controller.selection = const TextSelection.collapsed(offset: 3);
    // Moving the caret alone never opens the box; an edit does.
    await _settle(tester);
    expect(find.byKey(_boxKey), findsNothing);
    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '/bac now please',
        selection: TextSelection.collapsed(offset: 4),
      ),
    );
    await _settle(tester);
    await tester.tap(find.byKey(_row('/background')));
    await _settle(tester);
    expect(_composer(tester), '/background now please');
    expect(_value(tester).selection, const TextSelection.collapsed(offset: 12));
  });

  testWidgets('Esc closes it without touching the draft until the next '
      'edit; a space after a full name, deleting the slash or tapping '
      'elsewhere closes it', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    try {
      await pump(tester);
      await _type(tester, '/ti');
      expect(find.byKey(_boxKey), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await _settle(tester);
      expect(find.byKey(_boxKey), findsNothing);
      expect(_composer(tester), '/ti');
      expect(_fieldFocused(tester), isTrue);

      await _type(tester, '/tit');
      expect(find.byKey(_boxKey), findsOneWidget, reason: 'an edit reopens');

      await _type(tester, '/title ');
      expect(find.byKey(_boxKey), findsNothing);

      await _type(tester, '/ti');
      expect(find.byKey(_boxKey), findsOneWidget);
      await _type(tester, 'ti');
      expect(find.byKey(_boxKey), findsNothing);

      await _type(tester, '/');
      expect(find.byKey(_boxKey), findsOneWidget);
      await tester.tapAt(const Offset(400, 120));
      await _settle(tester);
      expect(find.byKey(_boxKey), findsNothing);
      expect(_composer(tester), '/');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('the info card stays away while the box is open', (tester) async {
    await pump(tester);
    await _type(tester, '/title');
    expect(find.byKey(_boxKey), findsOneWidget);
    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsNothing);

    // Closed (Esc), a tap on the token shows the card again.
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _settle(tester);
    expect(find.byKey(_boxKey), findsNothing);
    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsOneWidget);
  });

  testWidgets('a tap on the token of a draft with arguments shows the card, '
      'not the box', (tester) async {
    final gateway = _Gateway();
    gateway.handlers['complete.slash'] = (params) => {
      'items': const <Object>[],
      'replace_from': (params['text'] as String).lastIndexOf(' ') + 1,
    };
    await pump(tester, runtimeId: 'rt-1', gateway: gateway);
    await _type(tester, '/title Trip planning');
    expect(gateway.completions, ['/title Trip planning']);
    expect(find.byKey(_boxKey), findsNothing);
    await _tapText(tester, 1, 5);
    expect(find.byKey(_boxKey), findsNothing);
    expect(find.byKey(_infoKey), findsOneWidget);
  });

  testWidgets('argument completion: replace_from > 1 fills just the '
      'argument', (tester) async {
    final gateway = _Gateway();
    gateway.handlers['complete.slash'] = (params) {
      final text = params['text'] as String;
      if (text == '/personality al') {
        return {
          'items': [
            _item('alice', 'Friendly helper'),
            _item('alfred', 'Butler'),
          ],
          'replace_from': 13,
        };
      }
      return {
        'items': const <Object>[],
        'replace_from': text.lastIndexOf(' ') + 1,
      };
    };
    await pump(tester, runtimeId: 'rt-1', gateway: gateway);
    await _type(tester, '/personality al');
    expect(gateway.of('complete.slash').last.params, {
      'text': '/personality al',
      'session_id': 'rt-1',
    });
    expect(find.byKey(_row('alice')), findsOneWidget);
    expect(_inBox('Friendly helper'), findsOneWidget);
    expect(gateway.completions, ['/personality al']);

    await tester.tap(find.byKey(_row('alice')));
    await _settle(tester);
    expect(_composer(tester), '/personality alice');
    expect(_value(tester).selection, const TextSelection.collapsed(offset: 18));
    expect(find.byKey(_boxKey), findsNothing);
    expect(gateway.of('slash.exec'), isEmpty);
  });

  for (final acceptKey in [LogicalKeyboardKey.enter, LogicalKeyboardKey.tab]) {
    testWidgets(
      'argument choices accept ${acceptKey.keyLabel} without sending',
      (tester) async {
        final gateway = _Gateway();
        gateway.handlers['complete.slash'] = (_) => {
          'items': [
            _item('alice', 'Friendly helper'),
            _item('alfred', 'Butler'),
          ],
          'replace_from': 13,
        };
        await pump(tester, runtimeId: 'rt-1', gateway: gateway);
        await _type(tester, '/personality al');
        expect(gateway.completions, ['/personality al']);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyEvent(acceptKey);
        await _settle(tester);
        expect(_composer(tester), '/personality alfred');
        expect(
          _value(tester).selection,
          const TextSelection.collapsed(offset: 19),
        );
        expect(find.byKey(_boxKey), findsNothing);
        expect(gateway.of('slash.exec'), isEmpty);
        expect(gateway.of('prompt.submit'), isEmpty);
      },
    );
  }

  testWidgets('Escape dismisses argument choices without sending', (
    tester,
  ) async {
    final gateway = _Gateway();
    gateway.handlers['complete.slash'] = (_) => {
      'items': [_item('alice', 'Friendly helper')],
      'replace_from': 13,
    };
    await pump(tester, runtimeId: 'rt-1', gateway: gateway);
    await _type(tester, '/personality al');
    expect(find.byKey(_boxKey), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _settle(tester);
    expect(find.byKey(_boxKey), findsNothing);
    expect(_composer(tester), '/personality al');
    expect(gateway.of('slash.exec'), isEmpty);
    expect(gateway.of('prompt.submit'), isEmpty);
  });

  group('placement', () {
    for (final (label, size, platform) in [
      ('phone 412x760', const Size(412, 760), TargetPlatform.android),
      ('windows 1280x800', const Size(1280, 800), TargetPlatform.windows),
    ]) {
      for (final draft in ['/', '/t']) {
        testWidgets('$label, "$draft": the box sits above the composer and '
            'clears the field and every control', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          debugDefaultTargetPlatformOverride = platform;
          try {
            await pump(tester);
            await _type(tester, draft);
            expect(find.byKey(_boxKey), findsOneWidget);
            final box = tester.getRect(find.byKey(_boxKey));
            final field = _editableRect(tester);
            final input = _inputContainerRect(tester);
            expect(box.overlaps(field), isFalse, reason: '$box vs $field');
            final controls = _controlRects(tester);
            for (final name in ['attach', 'model', 'dictate', 'send']) {
              expect(controls, contains(name));
            }
            for (final MapEntry(key: name, value: rect) in controls.entries) {
              expect(
                box.overlaps(rect),
                isFalse,
                reason: '$name $rect vs $box',
              );
            }
            expect(box.bottom, lessThanOrEqualTo(input.top));
            expect(input.top - box.bottom, lessThanOrEqualTo(12));
            expect(box.left, greaterThanOrEqualTo(input.left - 0.5));
            expect(box.right, lessThanOrEqualTo(input.right + 0.5));
            expect(box.width, lessThanOrEqualTo(420));
            expect(box.top, greaterThanOrEqualTo(0));
            // About six rows at most, then it scrolls.
            expect(box.height, lessThanOrEqualTo(300));
          } finally {
            debugDefaultTargetPlatformOverride = null;
          }
        });
      }
    }
  });

  testWidgets('Android back closes the box first, without opening the '
      'sidebar or leaving the app', (tester) async {
    final platformCalls = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        platformCalls.add(call.method);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final conn = _connection();
    final gateway = NextGenGateway(conn);
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
        home: NgScope(
          connManager: ConnectionManager(prefs),
          gateway: gateway,
          connections: [conn],
          switchTo: (_) async {},
          addGateway: () async {},
          signOut: (_) async {},
          reload: () async {},
          signInAgain: () async {},
          child: NavigatorPopHandler(
            onPopWithResult: (_) => navigator.currentState?.maybePop(),
            child: Navigator(
              key: navigator,
              onGenerateInitialRoutes: (_, _) => [
                MaterialPageRoute<void>(
                  builder: (_) => const NgMainPage(coldStart: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    ScaffoldState scaffold() =>
        tester.state<ScaffoldState>(find.byType(Scaffold).first);

    await _type(tester, '/');
    expect(find.byKey(_boxKey), findsOneWidget);
    expect(find.byKey(_row('/new')), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byKey(_boxKey), findsNothing);
    expect(scaffold().isDrawerOpen, isFalse);
    expect(_composer(tester), '/');
    expect(platformCalls, isNot(contains('SystemNavigator.pop')));

    // With the box closed, Back is the sidebar's again.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(scaffold().isDrawerOpen, isTrue);

    await tester.pumpWidget(const SizedBox());
    gateway.dispose();
  });
}
