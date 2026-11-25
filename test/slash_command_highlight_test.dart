import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/controllers/slash_command_controller.dart';
import 'package:hermes_android/core/models/slash_command.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/widgets/slash_command_highlight.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/data/slash_catalog.dart';
import 'package:hermes_android/nextgen/ui/slash_command_info.dart';

/// The real `commands.catalog` shape, as in the dropdown tests.
Map<String, Object?> _wireCatalog() => {
  'pairs': [
    ['/help', 'Show help'],
    ['/title', 'Set the chat title (usage: /title <name>)'],
    ['/model', 'Choose a model'],
    ['/background', 'Run a prompt in the background'],
    ['/new', 'Start a new session'],
    ['/skill:review', 'Review the working tree'],
  ],
  'canon': {
    '/help': '/help',
    '/title': '/title',
    '/background': '/background',
    '/bg': '/background',
    '/reset': '/new',
  },
  'commands': {
    '/title': {'argument_mode': 'text'},
    '/model': {'argument_mode': 'options'},
  },
  'skills': {
    '/skill:review': {'usage': 3, 'origin': 'local'},
  },
  'plugin_commands': {'deploy': 'Deploy the current build'},
};

const _accent = Color(0xFF00AA55);

SlashCommandHighlightController _controller(
  String text, {
  SlashCommandTokenResolver? resolver,
  TextRange composing = TextRange.empty,
}) {
  final lookup = SlashCommandLookup.fromCatalogResult(_wireCatalog());
  return SlashCommandHighlightController.fromValue(
      TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
        composing: composing,
      ),
    )
    ..resolver = resolver ?? lookup.resolve
    ..highlightStyleOf = (_) =>
        const TextStyle(color: _accent, fontWeight: FontWeight.w500);
}

/// Every leaf as (text, merged style) in paint order.
List<(String, TextStyle)> _leaves(InlineSpan span) {
  final out = <(String, TextStyle)>[];
  void walk(InlineSpan node, TextStyle inherited) {
    final style = inherited.merge(node.style);
    if (node is TextSpan) {
      if (node.text != null && node.text!.isNotEmpty) {
        out.add((node.text!, style));
      }
      for (final child in node.children ?? const <InlineSpan>[]) {
        walk(child, style);
      }
    }
  }

  walk(span, const TextStyle());
  return out;
}

String _accented(InlineSpan span) => _leaves(
  span,
).where((leaf) => leaf.$2.color == _accent).map((leaf) => leaf.$1).join();

String _underlined(InlineSpan span) => _leaves(span)
    .where((leaf) => leaf.$2.decoration == TextDecoration.underline)
    .map((leaf) => leaf.$1)
    .join();

Future<TextSpan> _span(
  WidgetTester tester,
  TextEditingController controller, {
  bool withComposing = true,
}) async {
  late TextSpan span;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          span = controller.buildTextSpan(
            context: context,
            style: const TextStyle(fontSize: 15),
            withComposing: withComposing,
          );
          return const SizedBox();
        },
      ),
    ),
  );
  return span;
}

class _CatalogGateway extends NextGenGateway {
  _CatalogGateway({String? profile, this.online = true})
    : super(
        SavedConnection(
          id: 'c-${profile ?? 'default'}',
          label: 'Home',
          host: '10.0.0.5',
          port: 9119,
          apiKey: '',
          desktopGatewayUrl: 'http://10.0.0.5:9119',
          singleLogin: true,
          signInMethod: 'none',
          gatewayProfile: profile,
        ),
      );

  bool online;
  final calls = <Map<String, dynamic>>[];
  final reconnects = StreamController<void>.broadcast();

  @override
  Stream<void> get reconnected => reconnects.stream;
  Object? failure;
  Completer<Map<String, dynamic>>? hold;

  @override
  NgConnectionState get state => NgConnectionState(
    online ? NgConnectionPhase.connected : NgConnectionPhase.idle,
  );

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    expect(method, 'commands.catalog');
    calls.add(Map<String, dynamic>.of(params));
    final held = hold;
    if (held != null) return held.future;
    final error = failure;
    if (error != null) throw error;
    return Map<String, dynamic>.from(_wireCatalog());
  }
}

void main() {
  group('SlashCommandToken.parse follows the send path', () {
    test('a leading command, with or without arguments', () {
      final token = SlashCommandToken.parse('/title My chat')!;
      expect((token.start, token.end, token.name), (0, 6, 'title'));
      expect(SlashCommandToken.parse('/help')!.end, 5);
      expect(SlashCommandToken.parse('/skill:review x')!.name, 'skill:review');
    });

    test('leading whitespace is trimmed by send, so it is skipped', () {
      final token = SlashCommandToken.parse('  \n/help me')!;
      expect((token.start, token.end, token.name), (3, 8, 'help'));
    });

    test('mid-sentence slashes, paths and a lone slash are not tokens', () {
      for (final text in [
        'please run /help',
        '/',
        '/ help',
        '/usr/bin/env',
        '//help',
        '/help/',
        'see https://example.com',
        '',
        '   ',
      ]) {
        expect(SlashCommandToken.parse(text), isNull, reason: text);
      }
    });
  });

  group('SlashCommandLookup', () {
    final lookup = SlashCommandLookup.fromCatalogResult(_wireCatalog());

    test('registry, plugin and skill commands resolve with details', () {
      final title = lookup.resolve('title')!;
      expect(title.canonical, 'title');
      expect(title.description, 'Set the chat title (usage: /title <name>)');
      expect(title.argumentMode, 'text');
      expect(title.isAlias, isFalse);
      expect(lookup.resolve('TITLE')!.canonical, 'title');
      expect(lookup.resolve('deploy')!.description, 'Deploy the current build');
      expect(lookup.resolve('skill:review'), isNotNull);
    });

    test('aliases resolve through canon to the canonical command', () {
      final bg = lookup.resolve('bg')!;
      expect(bg.typed, 'bg');
      expect(bg.canonical, 'background');
      expect(bg.isAlias, isTrue);
      expect(bg.description, 'Run a prompt in the background');
      expect(lookup.resolve('reset')!.canonical, 'new');
    });

    test('unknown names do not resolve', () {
      expect(lookup.resolve('nope'), isNull);
      expect(lookup.resolve(''), isNull);
    });

    test('one lookup is cached per parsed catalogue', () {
      final catalog = SlashCommandCatalog.fromResult(_wireCatalog());
      expect(
        identical(
          SlashCommandLookup.of(catalog),
          SlashCommandLookup.of(catalog),
        ),
        isTrue,
      );
    });
  });

  group('SlashCommandHighlightController.buildTextSpan', () {
    testWidgets('a known command token is styled, the rest is not', (
      tester,
    ) async {
      final controller = _controller('/title My chat');
      final span = await _span(tester, controller);
      expect(span.toPlainText(), '/title My chat');
      expect(_accented(span), '/title');
      final token = _leaves(span).first;
      expect(token.$2.fontWeight, FontWeight.w500);
      expect(token.$2.fontSize, 15, reason: 'inherits the field style');
      expect(controller.text, '/title My chat');
    });

    testWidgets('an alias is styled', (tester) async {
      final span = await _span(tester, _controller('/bg run tests'));
      expect(_accented(span), '/bg');
    });

    testWidgets('leading whitespace before the token stays plain', (
      tester,
    ) async {
      final span = await _span(tester, _controller('  /help me'));
      expect(span.toPlainText(), '  /help me');
      expect(_accented(span), '/help');
    });

    testWidgets('unknown names, paths and mid-sentence slashes are plain', (
      tester,
    ) async {
      for (final text in [
        '/nope x',
        '/usr/bin/env',
        'please /help',
        'see /help',
        '/',
      ]) {
        final span = await _span(tester, _controller(text));
        expect(span.toPlainText(), text, reason: text);
        expect(_accented(span), isEmpty, reason: text);
      }
    });

    testWidgets('no resolver means no highlight', (tester) async {
      final controller = SlashCommandHighlightController(text: '/help');
      final span = await _span(tester, controller);
      expect(_accented(span), isEmpty);
      expect(span.toPlainText(), '/help');
    });

    testWidgets('the IME composing underline survives inside the token', (
      tester,
    ) async {
      final controller = _controller(
        '/help',
        composing: const TextRange(start: 1, end: 5),
      );
      final span = await _span(tester, controller);
      expect(span.toPlainText(), '/help');
      expect(_accented(span), '/help');
      expect(_underlined(span), 'help');
      final help = _leaves(span).last;
      expect(help.$2.color, _accent);
      expect(help.$2.decoration, TextDecoration.underline);
    });

    testWidgets('composing after the token and across its edge', (
      tester,
    ) async {
      var span = await _span(
        tester,
        _controller('/help wor', composing: const TextRange(start: 6, end: 9)),
      );
      expect(_accented(span), '/help');
      expect(_underlined(span), 'wor');

      span = await _span(
        tester,
        _controller(
          '/help world',
          composing: const TextRange(start: 3, end: 8),
        ),
      );
      expect(span.toPlainText(), '/help world');
      expect(_accented(span), '/help');
      expect(_underlined(span), 'lp wo');
    });

    testWidgets('withComposing false paints no underline', (tester) async {
      final span = await _span(
        tester,
        _controller('/help', composing: const TextRange(start: 1, end: 5)),
        withComposing: false,
      );
      expect(_underlined(span), isEmpty);
      expect(_accented(span), '/help');
    });

    testWidgets('composing on a plain draft matches the base controller', (
      tester,
    ) async {
      const value = TextEditingValue(
        text: 'hello wor',
        composing: TextRange(start: 6, end: 9),
      );
      final ours = await _span(
        tester,
        _controller(value.text, composing: value.composing),
      );
      final base = await _span(tester, TextEditingController.fromValue(value));
      expect(ours, base);
    });

    test('the controller is a plain TextEditingController for wrappers', () {
      final controller = _controller('/help');
      expect(controller, isA<TextEditingController>());
      controller.value = const TextEditingValue(
        text: '/help me',
        selection: TextSelection.collapsed(offset: 8),
      );
      expect(controller.slashToken!.name, 'help');
      expect(controller.highlight!.info.canonical, 'help');
      controller.text = 'plain';
      expect(controller.slashToken, isNull);
      expect(controller.highlight, isNull);
    });
  });

  group('resolveChatSlashToken mirrors the Classic send gate', () {
    SlashCommandController commands(Future<SlashCommandCatalog> Function() l) =>
        SlashCommandController(loadCatalog: l);

    test('without the slash gateway only app-owned /new and /reset run', () {
      final c = commands(() async => SlashCommandCatalog.fromResult({}));
      SlashCommandTokenInfo? r(String name) => resolveChatSlashToken(
        name,
        commands: c,
        available: false,
        localCommands: const {'new', 'reset'},
      );
      expect(r('help'), isNull);
      expect(r('new'), isNotNull);
      expect(r('Reset'), isNotNull);
    });

    test('before the catalogue loads the reviewed fallback set decides', () {
      final pending = Completer<SlashCommandCatalog>();
      final c = commands(() => pending.future);
      SlashCommandTokenInfo? r(String name) => resolveChatSlashToken(
        name,
        commands: c,
        available: true,
        localCommands: const {'new', 'reset'},
      );
      expect(kSlashExecutableCommands, contains('help'));
      final help = r('help')!;
      expect(help.canonical, 'help');
      expect(help.detailsPending, isTrue);
      expect(r('deploy'), isNull, reason: 'not in the fallback set');
      expect(r('nope'), isNull);
    });

    test('a loaded catalogue is authoritative and supplies details', () async {
      final c = commands(
        () async => SlashCommandCatalog.fromResult(_wireCatalog()),
      );
      await c.ensureCatalog();
      SlashCommandTokenInfo? r(String name) => resolveChatSlashToken(
        name,
        commands: c,
        available: true,
        localCommands: const {'new', 'reset'},
      );
      expect(r('deploy')!.description, 'Deploy the current build');
      expect(r('title')!.argumentMode, 'text');
      expect(r('title')!.detailsPending, isFalse);
      expect(r('version'), isNull, reason: 'fallback-only name');
      expect(r('nope'), isNull);
    });

    test(
      'a failed catalogue keeps the fallback without a loading state',
      () async {
        final c = commands(() async => throw StateError('offline'));
        await c.ensureCatalog();
        expect(c.catalogUnavailable, isTrue);
        final help = resolveChatSlashToken(
          'help',
          commands: c,
          available: true,
          localCommands: const {'new', 'reset'},
        )!;
        expect(help.detailsPending, isFalse);
      },
    );
  });

  group('NgSlashCatalog', () {
    test('loads once per profile and session scope and caches', () async {
      final gateway = _CatalogGateway(profile: 'work');
      final reader = NgSlashCatalog();
      reader.scopeTo(gateway);
      // Before the catalogue: only Classic's fallback set (what a send would
      // run), with its details pending.
      expect(reader.resolve('background'), isNull);
      expect(reader.resolve('help')!.detailsPending, isTrue);
      await reader.ensureLoaded();
      expect(gateway.calls, [<String, dynamic>{}]);
      expect(reader.resolve('help')!.description, 'Show help');
      expect(reader.resolve('bg')!.canonical, 'background');

      // Cached: a second reader on the same scope does not ask again.
      final again = NgSlashCatalog()..scopeTo(gateway);
      await again.ensureLoaded();
      expect(again.resolve('help'), isNotNull);
      expect(gateway.calls, hasLength(1));

      // A live session is its own scope (its workspace's skills).
      reader.scopeTo(gateway, sessionId: 'rt-1');
      expect(reader.resolve('background'), isNull);
      await reader.ensureLoaded();
      expect(gateway.calls.last, {'session_id': 'rt-1'});
      expect(gateway.calls, hasLength(2));

      // Another connection/profile never reuses this one's answer.
      final other = _CatalogGateway(profile: 'home');
      reader.scopeTo(other);
      expect(reader.resolve('background'), isNull);
      await reader.ensureLoaded();
      expect(other.calls, hasLength(1));
      reader.dispose();
      again.dispose();
    });

    test('concurrent requests share one flight and notify', () async {
      final gateway = _CatalogGateway()..hold = Completer();
      final reader = NgSlashCatalog()..scopeTo(gateway);
      var notified = 0;
      reader.addListener(() => notified++);
      final first = reader.ensureLoaded();
      final second = reader.ensureLoaded();
      expect(gateway.calls, hasLength(1));
      gateway.hold!.complete(Map<String, dynamic>.from(_wireCatalog()));
      await Future.wait([first, second]);
      expect(reader.resolve('title'), isNotNull);
      expect(notified, 1);
      reader.dispose();
    });

    test(
      "a failure falls back to Classic's set and retries only later",
      () async {
        final gateway = _CatalogGateway()..failure = StateError('refused');
        final reader = NgSlashCatalog(retryAfter: const Duration(hours: 1))
          ..scopeTo(gateway);
        await reader.ensureLoaded();
        expect(reader.resolve('background'), isNull);
        expect(reader.resolve('help')!.detailsPending, isTrue);
        await reader.ensureLoaded();
        expect(gateway.calls, hasLength(1), reason: 'no retry per keystroke');

        final eager = NgSlashCatalog(retryAfter: Duration.zero)
          ..scopeTo(gateway);
        gateway.failure = null;
        await eager.ensureLoaded();
        expect(gateway.calls, hasLength(2));
        expect(eager.resolve('help')!.detailsPending, isFalse);
        expect(eager.resolve('background'), isNotNull);
        reader.dispose();
        eager.dispose();
      },
    );

    test('offline is not a failure and sends nothing', () async {
      final gateway = _CatalogGateway(online: false);
      final reader = NgSlashCatalog()..scopeTo(gateway);
      await reader.ensureLoaded();
      expect(gateway.calls, isEmpty);
      gateway.online = true;
      await reader.ensureLoaded();
      expect(gateway.calls, hasLength(1));
      reader.dispose();
    });
  });

  group('NgSlashCatalog reconnects', () {
    test(
      'a reconnect marks answers stale; they show until refetched',
      () async {
        final gateway = _CatalogGateway();
        final reader = NgSlashCatalog()..scopeTo(gateway);
        await reader.ensureLoaded();
        await reader.ensureLoaded();
        expect(gateway.calls, hasLength(1));
        final before = reader.lookup;

        gateway.reconnects.add(null);
        await Future<void>.delayed(Duration.zero);
        expect(identical(reader.lookup, before), isTrue, reason: 'no flicker');
        gateway.hold = Completer();
        final refetch = reader.ensureLoaded();
        expect(gateway.calls, hasLength(2));
        expect(reader.resolve('help'), isNotNull, reason: 'still highlighted');
        gateway.hold!.complete({
          'pairs': [
            ['/help', 'Show help'],
            ['/fresh', 'Added after the restart'],
          ],
        });
        await refetch;
        expect(reader.resolve('fresh')!.description, 'Added after the restart');
        await reader.ensureLoaded();
        expect(gateway.calls, hasLength(2), reason: 'fresh again');
        reader.dispose();
      },
    );
  });

  group('SlashCommandInfoCard', () {
    test('detects the localized usage clause the gateway appends', () {
      for (final description in [
        'Set the chat title (usage: /title <name>)',
        'Titel setzen (Verwendung: /title <name>)',
        'タイトルを設定（使い方: /title <name>）',
        'Set the title. Try /TITLE',
      ]) {
        expect(
          SlashCommandInfoCard.describesUsage(description, 'title'),
          isTrue,
          reason: description,
        );
      }
      for (final description in [
        'Set the chat title',
        'See /titles for more',
        '',
      ]) {
        expect(
          SlashCommandInfoCard.describesUsage(description, 'title'),
          isFalse,
          reason: description,
        );
      }
    });

    Future<void> card(WidgetTester tester, SlashCommandTokenInfo info) =>
        tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: SlashCommandInfoCard(
                info: info,
                strings: SlashCommandInfoStrings(
                  noDescription: 'none',
                  loading: 'loading',
                  aliasOf: (alias, command) => '$alias → $command',
                  argumentsOptions: 'options hint',
                  argumentsText: 'text hint',
                  argumentsMixed: 'mixed hint',
                ),
                style: const SlashCommandInfoStyle(
                  background: Colors.black,
                  foreground: Colors.white,
                  muted: Colors.grey,
                  accent: _accent,
                  border: Colors.grey,
                ),
              ),
            ),
          ),
        );

    testWidgets('drops the argument hint when the description has usage', (
      tester,
    ) async {
      await card(
        tester,
        const SlashCommandTokenInfo(
          typed: 't',
          canonical: 'title',
          description: 'Set the chat title (usage: /title <name>)',
          argumentMode: 'text',
        ),
      );
      expect(find.text('text hint'), findsNothing);
      expect(find.text('/t → /title'), findsOneWidget, reason: 'alias kept');
      expect(tester.getSize(find.byType(SlashCommandInfoCard)).width, 280);

      await card(
        tester,
        const SlashCommandTokenInfo(
          typed: 'model',
          canonical: 'model',
          description: 'Choose a model',
          argumentMode: 'options',
        ),
      );
      expect(find.text('options hint'), findsOneWidget);
      expect(
        tester.getSize(find.byType(SlashCommandInfoCard)).width,
        lessThanOrEqualTo(280),
      );
    });
  });

  group('NgSlashCommandInfo note flag', () {
    for (final shows in [true, false]) {
      testWidgets('showsSentAsMessageNote: $shows', (tester) async {
        final gateway = _CatalogGateway();
        final chat = NgChatController(gateway);
        final input = SlashCommandHighlightController();
        final focus = FocusNode();
        addTearDown(() {
          chat.dispose();
          gateway.dispose();
          input.dispose();
          focus.dispose();
        });
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: NgSlashCommandInfo(
                  chat: chat,
                  controller: input,
                  focusNode: focus,
                  showsSentAsMessageNote: shows,
                  child: TextField(controller: input, focusNode: focus),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(find.byType(TextField), '/help me');
        await tester.pump();
        await tester.pump();
        final editable = tester
            .state<EditableTextState>(find.byType(EditableText))
            .renderEditable;
        final box = editable
            .getBoxesForSelection(
              const TextSelection(baseOffset: 1, extentOffset: 4),
            )
            .first;
        await tester.pump(const Duration(milliseconds: 400));
        await tester.tapAt(editable.localToGlobal(box.toRect().center));
        await tester.pump();
        await tester.pump();
        expect(find.text('Show help'), findsOneWidget);
        expect(
          find.textContaining('NextGen sends this to Hermes'),
          shows ? findsOneWidget : findsNothing,
        );
      });
    }
  });
}
