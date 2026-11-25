// NextGen composer: a typed slash command is highlighted from a scoped,
// cached `commands.catalog` read and tapping it shows its description. Uses
// only public NextGen APIs and keys, so the same file runs (red) against a
// build without the feature. Sending a highlighted command runs it on the
// gateway (see nextgen_slash_exec_test.dart), so the card no longer says it
// goes out as a message.
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
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _fieldKey = ValueKey('ng-composer-field');
const _infoKey = ValueKey('slash-command-info');

SavedConnection _connection() => SavedConnection(
  id: 'ng-slash',
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

Map<String, dynamic> _wireCatalog() => {
  'pairs': [
    ['/help', 'Show help'],
    ['/title', 'Set the chat title (usage: /title <name>)'],
    ['/background', 'Run a prompt in the background'],
  ],
  'canon': {
    '/help': '/help',
    '/title': '/title',
    '/background': '/background',
    '/bg': '/background',
  },
  'commands': {
    '/title': {'argument_mode': 'text'},
  },
  'plugin_commands': {'deploy': 'Deploy the current build'},
};

class _Call {
  const _Call(this.method, this.params);
  final String method;
  final Map<String, dynamic> params;
}

class _Gateway extends NextGenGateway {
  _Gateway({this.catalogFails = false}) : super(_connection());

  final bool catalogFails;
  final calls = <_Call>[];
  final WsClient _socket = WsClient('http://10.0.0.5:9119');

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
        if (catalogFails) {
          throw JsonRpcError('commands.catalog', 'unknown method');
        }
        return _wireCatalog();
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

  List<_Call> get catalogCalls =>
      calls.where((c) => c.method == 'commands.catalog').toList();
}

Widget _app(
  NgChatController chat,
  NextGenGateway gateway,
  ConnectionManager m,
) => MaterialApp(
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
    child: Scaffold(
      body: NgChatView(chat: chat, onOpenSidebar: () {}, onNewChat: () {}),
    ),
  ),
);

EditableTextState _editable(WidgetTester tester) => tester.state(
  find.descendant(
    of: find.byKey(_fieldKey),
    matching: find.byType(EditableText),
  ),
);

String _highlighted(WidgetTester tester) {
  final accent = NgColors.of(tester.element(find.byKey(_fieldKey))).accentText;
  final out = StringBuffer();
  void walk(InlineSpan node, TextStyle inherited) {
    final style = inherited.merge(node.style);
    if (node is TextSpan) {
      if ((node.text?.isNotEmpty ?? false) &&
          style.color == accent &&
          style.fontWeight == FontWeight.w500) {
        out.write(node.text);
      }
      for (final child in node.children ?? const <InlineSpan>[]) {
        walk(child, style);
      }
    }
  }

  walk(_editable(tester).renderEditable.text!, const TextStyle());
  return out.toString();
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(_fieldKey), text);
  await tester.pump();
  await tester.pump();
}

Future<void> _tapText(
  WidgetTester tester,
  int start,
  int end, {
  PointerDeviceKind kind = PointerDeviceKind.touch,
}) async {
  await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 50));
  final editable = _editable(tester).renderEditable;
  final box = editable
      .getBoxesForSelection(TextSelection(baseOffset: start, extentOffset: end))
      .first;
  await tester.tapAt(editable.localToGlobal(box.toRect().center), kind: kind);
  await tester.pump();
  await tester.pump();
}

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
    'stop': find.byTooltip('Stop'),
  };
  return {
    for (final entry in finders.entries)
      if (entry.value.evaluate().isNotEmpty)
        entry.key: tester.getRect(entry.value.first),
  };
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
    bool catalogFails = false,
    String? runtimeId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final gateway = _Gateway(catalogFails: catalogFails);
    final chat = NgChatController(gateway)..runtimeId = runtimeId;
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    return (gateway, chat);
  }

  testWidgets('typing a command highlights it from a scoped catalogue', (
    tester,
  ) async {
    final (gateway, _) = await pump(tester, runtimeId: 'rt-1');
    await _type(tester, 'hello');
    expect(gateway.catalogCalls, isEmpty, reason: 'plain text never asks');

    await _type(tester, '/help me');
    expect(gateway.catalogCalls, hasLength(1));
    expect(gateway.catalogCalls.single.params, {'session_id': 'rt-1'});
    expect(_highlighted(tester), '/help');

    await _type(tester, '/bg run the tests');
    expect(_highlighted(tester), '/bg', reason: 'alias via canon');
    await _type(tester, '/nope x');
    expect(_highlighted(tester), isEmpty);
    await _type(tester, '/usr/bin/env');
    expect(_highlighted(tester), isEmpty);
    await _type(tester, 'please /help');
    expect(_highlighted(tester), isEmpty);
    expect(gateway.catalogCalls, hasLength(1), reason: 'cached');
  });

  testWidgets('tapping the token shows the description and dismisses on a '
      'tap elsewhere, typing and send; send runs the command', (tester) async {
    final (gateway, _) = await pump(tester);
    await _type(tester, '/bg run tests');
    expect(gateway.catalogCalls.single.params, isEmpty, reason: 'draft chat');

    await _tapText(tester, 1, 3);
    expect(find.byKey(_infoKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(_infoKey),
        matching: find.text('/background'),
      ),
      findsOneWidget,
    );
    expect(find.text('/bg is an alias of /background'), findsOneWidget);
    expect(find.text('Run a prompt in the background'), findsOneWidget);
    expect(
      find.text(
        "NextGen sends this to Hermes as a normal message; the command "
        "itself doesn't run.",
      ),
      findsNothing,
      reason: 'NextGen runs commands now',
    );
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.tapAt(const Offset(200, 200));
    await tester.pump();
    expect(find.byKey(_infoKey), findsNothing);

    await _tapText(tester, 1, 3);
    expect(find.byKey(_infoKey), findsOneWidget);
    await _type(tester, '/bg run all tests');
    expect(find.byKey(_infoKey), findsNothing);

    await _tapText(tester, 1, 3);
    expect(find.byKey(_infoKey), findsOneWidget);
    await tester.tap(find.byTooltip('Send'));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(_infoKey), findsNothing);
    await tester.pump();
    await tester.pump();
    final exec = gateway.calls.singleWhere((c) => c.method == 'slash.exec');
    expect(exec.params, {
      'session_id': 'rt-new',
      'command': 'bg run all tests',
    });
    expect(gateway.calls.where((c) => c.method == 'prompt.submit'), isEmpty);
  });

  testWidgets('a chat switch dismisses the card', (tester) async {
    final (gateway, _) = await pump(tester);
    await _type(tester, '/title Trip');
    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsOneWidget);
    expect(find.text('Set the chat title (usage: /title <name>)'), findsOne);

    final prefs = await SharedPreferences.getInstance();
    final other = NgChatController(gateway);
    addTearDown(other.dispose);
    await tester.pumpWidget(_app(other, gateway, ConnectionManager(prefs)));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(_infoKey), findsNothing);
  });

  testWidgets("a failed catalogue falls back to Classic's command set for "
      'both the highlight and send', (tester) async {
    final (gateway, _) = await pump(tester, catalogFails: true);
    await _type(tester, '/help me');
    expect(gateway.catalogCalls, hasLength(1));
    expect(_highlighted(tester), '/help', reason: 'kSlashExecutableCommands');
    await _type(tester, '/bg run tests');
    expect(_highlighted(tester), isEmpty, reason: 'not in the fallback set');
    await _type(tester, '/help me now');
    expect(gateway.catalogCalls, hasLength(1), reason: 'no per-key retry');

    await tester.tap(find.byTooltip('Send'));
    for (var i = 0; i < 4; i++) {
      await tester.pump();
    }
    final exec = gateway.calls.singleWhere((c) => c.method == 'slash.exec');
    expect(exec.params, {'session_id': 'rt-new', 'command': 'help me now'});
    expect(gateway.calls.where((c) => c.method == 'prompt.submit'), isEmpty);
  });

  group('card placement', () {
    for (final (label, size, platform, kind) in [
      (
        'phone 412x760',
        const Size(412, 760),
        TargetPlatform.android,
        PointerDeviceKind.touch,
      ),
      (
        'windows 1280x800',
        const Size(1280, 800),
        TargetPlatform.windows,
        PointerDeviceKind.mouse,
      ),
      (
        'macOS 1280x800',
        const Size(1280, 800),
        TargetPlatform.macOS,
        PointerDeviceKind.mouse,
      ),
    ]) {
      for (final draft in [
        '/title Trip planning',
        '/title Trip planning\nsecond line\nthird line',
      ]) {
        final lines = '\n'.allMatches(draft).length + 1;
        testWidgets('$label, $lines-line draft: the small card clears the '
            'field and every composer control', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          debugDefaultTargetPlatformOverride = platform;
          try {
            await pump(tester);
            await _type(tester, draft);
            await _tapText(tester, 1, 5, kind: kind);
            expect(find.byKey(_infoKey), findsOneWidget);

            final card = tester.getRect(find.byKey(_infoKey));
            expect(card.width, lessThanOrEqualTo(280));
            expect(card.left, greaterThanOrEqualTo(0));
            expect(card.right, lessThanOrEqualTo(size.width));
            final field = _editableRect(tester);
            expect(card.overlaps(field), isFalse, reason: '$card vs $field');
            final controls = _controlRects(tester);
            for (final name in ['attach', 'model', 'dictate', 'send']) {
              expect(controls, contains(name));
            }
            for (final MapEntry(key: name, value: rect) in controls.entries) {
              expect(
                card.overlaps(rect),
                isFalse,
                reason: '$name $rect vs $card',
              );
            }
            final input = _inputContainerRect(tester);
            expect(card.bottom, lessThanOrEqualTo(input.top));
            expect(input.top - card.bottom, lessThanOrEqualTo(12));
          } finally {
            debugDefaultTargetPlatformOverride = null;
          }
        });
      }
    }
  });
}
