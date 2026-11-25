// Classic composer: a typed slash command is highlighted and tapping it shows
// its catalogue description. Uses only the screen's public test seams and
// keys, so the same file runs (red) against a build without the feature.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/slash_command.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/completed_stock_turn.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _composerKey = Key('chat-message-composer');
const _infoKey = ValueKey('slash-command-info');
const _dropdownKey = Key('slash-command-dropdown');

Map<String, Object?> _wireCatalog() => {
  'pairs': [
    ['/help', 'Show help'],
    ['/title', 'Set the chat title (usage: /title <name>)'],
    ['/status', 'Show the session status'],
    ['/new', 'Start a new session'],
  ],
  'canon': {'/help': '/help', '/title': '/title', '/reset': '/new'},
  'commands': {
    '/title': {'argument_mode': 'text'},
  },
  'plugin_commands': {'deploy': 'Deploy the current build'},
};

class _Gateway implements SlashCommandGateway {
  _Gateway({this.supported = true, Future<SlashCommandCatalog>? catalog})
    : _catalog =
          catalog ??
          Future.value(SlashCommandCatalog.fromResult(_wireCatalog()));

  final bool supported;
  final Future<SlashCommandCatalog> _catalog;
  final commands = <String>[];
  var catalogLoads = 0;

  @override
  bool get slashCommandsSupported => supported;

  @override
  Future<SlashCommandCatalog> fetchSlashCommands({String? sessionId}) {
    catalogLoads += 1;
    return _catalog;
  }

  @override
  Future<SlashCommandResult> runSlashCommand({
    required String sessionId,
    required String command,
    void Function()? onSent,
  }) async {
    commands.add(command);
    onSent?.call();
    return const SlashCommandResult.exec('ok');
  }
}

var _sessions = 0;

Future<void> _pump(WidgetTester tester, _Gateway gateway) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChatScreen(
        connection: SavedConnection(
          id: 'slash-hl',
          label: 'Slash highlight',
          host: 'slash.invalid',
          port: 8642,
          apiKey: 'fixture-key',
        ),
        session: Session(
          id: 'slash-hl-${_sessions++}',
          title: 'Slash chat',
          model: 'fixture-model',
          source: 'test',
          messageCount: 0,
          isActive: true,
          preview: '',
          startedAt: 1,
        ),
        testApiClient: ApiClient(
          baseUrl: 'http://slash.invalid',
          apiKey: 'fixture-key',
          httpClient: MockClient(
            (_) async => http.Response('{"data":[]}', 200),
          ),
        ),
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
        testSlashGateway: gateway,
        testRemotePromptSubmit: completedStockTurn(null),
      ),
    ),
  );
  await pumpChatUpdates(tester);
}

EditableTextState _editable(WidgetTester tester) => tester.state(
  find.descendant(
    of: find.byKey(_composerKey),
    matching: find.byType(EditableText),
  ),
);

Color _accent(WidgetTester tester) =>
    HermesTokens.of(tester.element(find.byKey(_composerKey))).accent;

/// The painted span's leaves as (text, merged style).
List<(String, TextStyle)> _leaves(WidgetTester tester) {
  final out = <(String, TextStyle)>[];
  void walk(InlineSpan node, TextStyle inherited) {
    final style = inherited.merge(node.style);
    if (node is TextSpan) {
      if (node.text?.isNotEmpty ?? false) out.add((node.text!, style));
      for (final child in node.children ?? const <InlineSpan>[]) {
        walk(child, style);
      }
    }
  }

  walk(_editable(tester).renderEditable.text!, const TextStyle());
  return out;
}

String _highlighted(WidgetTester tester) {
  final accent = _accent(tester);
  return _leaves(tester)
      .where(
        (leaf) =>
            leaf.$2.color == accent && leaf.$2.fontWeight == FontWeight.w500,
      )
      .map((leaf) => leaf.$1)
      .join();
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(_composerKey), text);
  await tester.pump();
  await tester.pump();
}

/// Taps the middle of the characters [start, end) of the draft, as a fresh
/// single tap (past the double-tap window of any previous tap).
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

/// Every composer control the card must leave uncovered, by name.
Map<String, Rect> _controlRects(WidgetTester tester) {
  final finders = <String, Finder>{
    'attach': find.byTooltip('Attach image or file'),
    'model': find.ancestor(
      of: find.byIcon(Icons.tune),
      matching: find.byType(TextButton),
    ),
    'voice input': find.byTooltip('Speak to Hermes'),
    'hands-free start': find.byKey(const Key('hands-free-start')),
    'hands-free stop': find.byKey(const Key('hands-free-quick-stop')),
    'spoken replies': find.byWidgetPredicate(
      (widget) =>
          widget is Tooltip &&
          (widget.message == 'Spoken replies off' ||
              widget.message == 'Spoken replies on'),
    ),
    'send': find.byTooltip('Send'),
    'stop': find.byKey(const Key('chat-stop-response')),
  };
  return {
    for (final entry in finders.entries)
      if (entry.value.evaluate().isNotEmpty)
        entry.key: tester.getRect(entry.value.first),
  };
}

String _draft(WidgetTester tester) =>
    tester.widget<TextField>(find.byKey(_composerKey)).controller!.text;

void main() {
  setUp(mockChatImageRecovery);
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
  });

  testWidgets('a typed command is highlighted as soon as it is typed', (
    tester,
  ) async {
    await _pump(tester, _Gateway());
    await _type(tester, '/title My chat');
    expect(_highlighted(tester), '/title');
    expect(_draft(tester), '/title My chat', reason: 'the value is unchanged');

    await _type(tester, '/deploy now');
    expect(_highlighted(tester), '/deploy', reason: 'plugin command');
  });

  testWidgets('unknown names, paths and mid-sentence slashes stay plain', (
    tester,
  ) async {
    await _pump(tester, _Gateway());
    for (final text in ['/nope x', '/usr/bin/env', 'please /help me']) {
      await _type(tester, text);
      expect(_highlighted(tester), isEmpty, reason: text);
      expect(_draft(tester), text);
    }
  });

  testWidgets('tapping the token shows its description without stealing '
      'focus or the keyboard', (tester) async {
    await _pump(tester, _Gateway());
    await _type(tester, '/title My chat');
    expect(find.byKey(_dropdownKey), findsNothing);
    final focus = FocusManager.instance.primaryFocus;

    await _tapText(tester, 1, 5);

    expect(find.byKey(_infoKey), findsOneWidget);
    expect(
      find.descendant(of: find.byKey(_infoKey), matching: find.text('/title')),
      findsOneWidget,
    );
    expect(
      find.text('Set the chat title (usage: /title <name>)'),
      findsOneWidget,
    );
    expect(FocusManager.instance.primaryFocus, focus);
    expect(tester.testTextInput.isVisible, isTrue);
    expect(_draft(tester), '/title My chat');
  });

  testWidgets('tapping outside the token shows nothing', (tester) async {
    await _pump(tester, _Gateway());
    await _type(tester, '/title My chat');
    await _tapText(tester, 8, 12);
    expect(find.byKey(_infoKey), findsNothing);
  });

  testWidgets('a tap elsewhere, typing, Esc and send each dismiss it', (
    tester,
  ) async {
    final gateway = _Gateway();
    await _pump(tester, gateway);
    await _type(tester, '/title My chat');

    // Tap elsewhere (the transcript).
    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsOneWidget);
    await tester.tapAt(const Offset(200, 150));
    await tester.pump();
    expect(find.byKey(_infoKey), findsNothing);

    // Typing.
    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsOneWidget);
    await _type(tester, '/title My chats');
    expect(find.byKey(_infoKey), findsNothing);

    // Esc keeps the draft.
    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.byKey(_infoKey), findsNothing);
    expect(_draft(tester), '/title My chats');

    // Tapping the token again toggles it closed.
    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsOneWidget);
    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsNothing);

    // Send: the command text goes out unchanged.
    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsOneWidget);
    await tester.tap(find.byTooltip('Send'));
    await tester.pump();
    await pumpChatUpdates(tester);
    expect(find.byKey(_infoKey), findsNothing);
    expect(gateway.commands, ['/title My chats']);
  });

  testWidgets('focus loss and the timeout dismiss it', (tester) async {
    await _pump(tester, _Gateway());
    await _type(tester, '/title My chat');
    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsOneWidget);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    expect(find.byKey(_infoKey), findsNothing);

    await _tapText(tester, 1, 5);
    expect(find.byKey(_infoKey), findsOneWidget);
    await tester.pump(const Duration(seconds: 9));
    expect(find.byKey(_infoKey), findsNothing);
  });

  testWidgets('moving the caret into the token from the keyboard shows it', (
    tester,
  ) async {
    await _pump(tester, _Gateway());
    await _type(tester, '/title My chat');
    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '/title My chat',
        selection: TextSelection.collapsed(offset: 3),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.byKey(_infoKey), findsOneWidget);
    expect(
      find.text('Set the chat title (usage: /title <name>)'),
      findsOneWidget,
    );

    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '/title My chat',
        selection: TextSelection.collapsed(offset: 10),
      ),
    );
    await tester.pump();
    expect(find.byKey(_infoKey), findsNothing, reason: 'caret left the token');
  });

  testWidgets('no card while the command dropdown is open', (tester) async {
    await _pump(tester, _Gateway());
    await _type(tester, '/help');
    expect(find.byKey(_dropdownKey), findsOneWidget);
    expect(_highlighted(tester), '/help');
    await _tapText(tester, 1, 4);
    expect(find.byKey(_infoKey), findsNothing);
  });

  testWidgets('before the catalogue loads, the send fallback set decides', (
    tester,
  ) async {
    final catalog = Completer<SlashCommandCatalog>();
    await _pump(tester, _Gateway(catalog: catalog.future));
    // `/help` is in the reviewed fallback set the send path uses; the plugin
    // `/deploy` is only known once the catalogue answers.
    await _type(tester, '/help me');
    expect(_highlighted(tester), '/help');
    await _tapText(tester, 1, 4);
    expect(find.byKey(_infoKey), findsOneWidget);
    expect(find.text('Loading commands…'), findsOneWidget);

    await _type(tester, '/deploy now');
    expect(_highlighted(tester), isEmpty);

    catalog.complete(SlashCommandCatalog.fromResult(_wireCatalog()));
    await tester.pump();
    await tester.pump();
    expect(_highlighted(tester), '/deploy');
    await _tapText(tester, 1, 6);
    expect(find.text('Deploy the current build'), findsOneWidget);
  });

  testWidgets('without the slash gateway only the app-owned /new is styled', (
    tester,
  ) async {
    await _pump(tester, _Gateway(supported: false));
    await _type(tester, '/help me');
    expect(_highlighted(tester), isEmpty);
    await _type(tester, '/new Trip plans');
    expect(_highlighted(tester), '/new');
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
            await _pump(tester, _Gateway());
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
            for (final name in ['attach', 'voice input', 'spoken replies']) {
              expect(controls, contains(name));
            }
            expect(
              controls.containsKey('send') || controls.containsKey('stop'),
              isTrue,
            );
            for (final MapEntry(key: name, value: rect) in controls.entries) {
              expect(
                card.overlaps(rect),
                isFalse,
                reason: '$name $rect vs $card',
              );
            }
            // Above the whole input container, a small gap away.
            final bar = tester.getRect(find.byKey(const Key('chat-input-bar')));
            expect(card.bottom, lessThanOrEqualTo(bar.top));
            expect(bar.top - card.bottom, lessThanOrEqualTo(12));
          } finally {
            debugDefaultTargetPlatformOverride = null;
          }
        });
      }
    }
  });
}
