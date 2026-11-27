import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/controllers/slash_command_controller.dart';
import 'package:hermes_android/core/models/slash_command.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/slash_command_dropdown.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/completed_stock_turn.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _composerKey = Key('chat-message-composer');

/// The real `commands.catalog` shape (`CommandsCatalogResult`): ordered
/// `pairs`, a DICT of per-command metadata, display `categories`, skills and
/// plugin commands. A realistic slice of a stock gateway profile.
Map<String, Object?> _wireCatalog({Set<String>? executable}) => {
  'pairs': [
    ['/help', 'Show help'],
    ['/status', 'Show the session status'],
    ['/plan', 'Draft a plan before acting'],
    ['/model', 'Choose a model'],
    ['/title', 'Set the chat title'],
    ['/yolo', 'Toggle YOLO mode'],
    ['/cron', 'Manage cron jobs'],
    ['/review', 'Review the working tree'],
    ['/nostalgia', 'Recall an old session'],
    ['/skill:review', 'Review the working tree'],
    ['/logs', 'Show recent gateway log lines'],
  ],
  'sub': {
    'cron': ['list', 'run', 'add'],
  },
  'canon': {'/h': '/help', '/yolo': '/yolo'},
  'commands': {
    '/help': {'argument_mode': 'text', 'desktop': null},
    '/title': {'argument_mode': 'text'},
    '/model': {'argument_mode': 'options', 'desktop': 'model-picker'},
    '/cron': {
      'argument_mode': 'mixed',
      'desktop': null,
      'desktop_subcommands': ['list', 'run'],
    },
  },
  'categories': [
    {
      'name': 'Session',
      'pairs': [
        ['/status', 'Show the session status'],
        ['/title', 'Set the chat title'],
      ],
    },
    {
      'name': 'Config',
      'pairs': [
        ['/yolo', 'Toggle YOLO mode'],
        ['/model', 'Choose a model'],
      ],
    },
    {
      'name': 'TUI',
      'pairs': [
        ['/logs', 'Show recent gateway log lines'],
      ],
    },
  ],
  'skills': {
    '/skill:review': {'usage': 3, 'origin': 'local'},
    // Collides with nothing in `pairs`: no `/<name>` row, no description.
    '/skill:orphan': {'usage': 0, 'origin': 'bundled'},
  },
  'skill_count': 2,
  'warning': '',
  'plugin_commands': {'deploy': 'Deploy the current build'},
  'executable': ?executable?.toList(),
};

/// The real `SlashExecResult` worker/plugin form: `output` (+ `warning`), no
/// `type`. `type` is only set when slash.exec rerouted to command.dispatch.
Map<String, Object?> _workerOutput(String output, {String? warning}) => {
  'output': output,
  'warning': ?warning,
};

SlashCommandCatalog _catalog({Set<String>? executable}) =>
    SlashCommandCatalog.fromResult(_wireCatalog(executable: executable));

/// Slash RPC double: no socket, no gateway process.
class _FakeSlashGateway implements SlashCommandGateway {
  _FakeSlashGateway({
    SlashCommandCatalog? catalog,
    this.result = const SlashCommandResult.exec('ok'),
    this.error,
    this.catalogError,
    this.pendingResult,
  }) : catalog = catalog ?? _catalog();

  final SlashCommandCatalog? catalog;
  final SlashCommandResult result;
  final Object? error;
  final Object? catalogError;
  final Completer<SlashCommandResult>? pendingResult;
  final List<String> commands = [];
  var catalogLoads = 0;

  @override
  bool get slashCommandsSupported => true;

  @override
  Future<SlashCommandCatalog> fetchSlashCommands({String? sessionId}) async {
    catalogLoads += 1;
    if (catalogError != null) throw catalogError!;
    final cached = catalog;
    if (cached == null) throw StateError('gateway offline');
    return cached;
  }

  @override
  Future<SlashCommandResult> runSlashCommand({
    required String sessionId,
    required String command,
    void Function()? onSent,
  }) async {
    commands.add(command);
    onSent?.call();
    final failure = error;
    if (failure != null) throw failure;
    return pendingResult == null ? result : await pendingResult!.future;
  }
}

class _HeldCatalogGateway extends _FakeSlashGateway {
  Object? failure;
  final pending = Completer<SlashCommandCatalog>();
  @override
  Future<SlashCommandCatalog> fetchSlashCommands({String? sessionId}) =>
      pending.future;
  @override
  Future<SlashCommandResult> runSlashCommand({
    required String sessionId,
    required String command,
    void Function()? onSent,
  }) async {
    commands.add(command);
    onSent?.call();
    if (failure case final error?) throw error;
    return result;
  }
}

String _composerText(WidgetTester tester) =>
    tester.widget<TextField>(find.byKey(_composerKey)).controller!.text;

/// Notices are stored per connection+session for the process, so every screen
/// test needs its own session identity.
var _pumpedSessions = 0;

ChatScreen _chatScreen({
  required SlashCommandGateway slashGateway,
  TestRemotePromptSubmit? remoteSubmit,
  required String sessionId,
  http.Client? apiClient,
  TestDesktopConnectionHook? connectionHook,
  Future<void> Function(Session session)? onOpenSession,
}) {
  return ChatScreen(
    onOpenSession: onOpenSession,
    connection: SavedConnection(
      id: 'slash-fixture',
      label: 'Slash fixture',
      host: 'slash.invalid',
      port: 8642,
      apiKey: 'fixture-key',
    ),
    session: Session(
      id: sessionId,
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
      httpClient:
          apiClient ??
          MockClient((_) async => http.Response('{"data":[]}', 200)),
    ),
    testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
    testSlashGateway: slashGateway,
    testDesktopConnectionHook: connectionHook,
    testRemotePromptSubmit: completedStockTurn(remoteSubmit),
  );
}

Future<void> _pumpChat(
  WidgetTester tester, {
  required SlashCommandGateway slashGateway,
  TestRemotePromptSubmit? remoteSubmit,
  String? sessionId,
  http.Client? apiClient,
  TestDesktopConnectionHook? connectionHook,
}) async {
  final id = sessionId ?? 'slash-session-${_pumpedSessions++}';
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: _chatScreen(
        slashGateway: slashGateway,
        remoteSubmit: remoteSubmit,
        sessionId: id,
        apiClient: apiClient,
        connectionHook: connectionHook,
      ),
    ),
  );
  await pumpChatUpdates(tester);
}

/// Pumps the chat as a PUSHED route over a stand-in session list that, like
/// the real one, hands the chat its own open-chat path ([opened] records
/// what `/resume` asked it to open).
Future<void> _pushChat(
  WidgetTester tester, {
  required SlashCommandGateway slashGateway,
  List<String>? opened,
  http.Client? apiClient,
}) async {
  final id = 'slash-session-${_pumpedSessions++}';
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: SizedBox(key: Key('session-list-page'))),
    ),
  );
  final context = tester.element(find.byKey(const Key('session-list-page')));
  Navigator.of(context).push(
    MaterialPageRoute(
      settings: const RouteSettings(name: '/classic-session-chat'),
      builder: (_) => _chatScreen(
        slashGateway: slashGateway,
        sessionId: id,
        apiClient: apiClient,
        onOpenSession: (session) async => opened?.add(session.id),
      ),
    ),
  );
  await pumpChatUpdates(tester);
}

Future<void> _send(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Send'));
  await tester.pump();
  await pumpChatUpdates(tester);
}

void main() {
  setUp(mockChatImageRecovery);
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
  });

  group('trigger detection', () {
    test('lone slash opens an empty query', () {
      expect(slashCommandQuery('/'), '');
    });

    test('leading token is the query', () {
      expect(slashCommandQuery('/mod'), 'mod');
      expect(slashCommandQuery('/status'), 'status');
    });

    test('slash inside prose does not trigger', () {
      expect(slashCommandQuery('please run /status for me'), isNull);
    });

    test('a URL does not trigger', () {
      expect(slashCommandQuery('https://x'), isNull);
      expect(slashCommandQuery('see https://x/y'), isNull);
    });

    test('an argument ends the dropdown token', () {
      expect(slashCommandQuery('/model gpt'), isNull);
      expect(slashCommandQuery('/status '), isNull);
    });

    test('a newline ends the dropdown token', () {
      expect(slashCommandQuery('/status\nmore'), isNull);
    });

    test('text without a leading slash does not trigger', () {
      expect(slashCommandQuery(''), isNull);
      expect(slashCommandQuery('status'), isNull);
    });

    test('the send gate keeps the full invocation', () {
      expect(slashCommandName('/status'), 'status');
      expect(slashCommandName('/yolo on'), 'yolo');
      expect(slashCommandName('/title A B'), 'title');
      expect(slashCommandName('/cron list'), 'cron');
      expect(slashCommandName('/status\nmore'), 'status');
    });

    test('a lone slash is not a command', () {
      expect(slashCommandName('/'), isNull);
      expect(slashCommandName('/ '), isNull);
    });

    test('prose and URLs are not commands', () {
      expect(slashCommandName(''), isNull);
      expect(slashCommandName('status'), isNull);
      expect(slashCommandName('please /status'), isNull);
      expect(slashCommandName('https://x/y'), isNull);
    });
  });

  group('local filtering', () {
    late SlashCommandController controller;

    setUp(() {
      controller = SlashCommandController(
        loadCatalog: () async => _catalog(),
        limit: 20,
      );
    });

    tearDown(() => controller.dispose());

    test('the whole catalogue is offered in gateway order', () async {
      controller.updateText('/');
      await controller.ensureCatalog();
      expect(controller.isOpen, isTrue);
      expect(controller.matches.map((command) => command.name), [
        'help',
        'status',
        'plan',
        'model',
        'title',
        'yolo',
        'cron',
        'review',
        'nostalgia',
        'skill:review',
        'logs',
        'deploy',
        'skill:orphan',
      ]);
    });

    test('prefix matches rank before substring matches', () async {
      controller.updateText('/st');
      await controller.ensureCatalog();
      expect(controller.matches.map((command) => command.name), [
        'status',
        'nostalgia',
      ]);
    });

    test('filtering narrows on every keystroke', () async {
      controller.updateText('/m');
      await controller.ensureCatalog();
      expect(controller.matches.map((command) => command.name), ['model']);

      controller.updateText('/mo');
      expect(controller.matches.map((command) => command.name), ['model']);

      controller.updateText('/moz');
      expect(controller.matches, isEmpty);
      expect(controller.isOpen, isTrue);
    });

    test('closing keeps the draft untouched', () async {
      controller.updateText('/sta');
      await controller.ensureCatalog();
      controller.close();
      expect(controller.isOpen, isFalse);
      expect(controller.query, isEmpty);
    });

    test('leaving the trigger closes the dropdown', () async {
      controller.updateText('/sta');
      await controller.ensureCatalog();
      expect(controller.updateText('/status now'), isFalse);
      expect(controller.isOpen, isFalse);
    });

    test('the visible list is capped', () async {
      final capped = SlashCommandController(
        loadCatalog: () async => SlashCommandCatalog.fromResult({
          'pairs': [
            for (var i = 0; i < 12; i++) ['/command$i', 'Command $i'],
          ],
        }),
        limit: 5,
      );
      addTearDown(capped.dispose);
      capped.updateText('/');
      await capped.ensureCatalog();
      expect(capped.matches, hasLength(5));
    });
  });

  group('catalogue cache', () {
    test('fetches once and reuses the cached catalogue', () async {
      var loads = 0;
      final controller = SlashCommandController(
        loadCatalog: () async {
          loads += 1;
          return _catalog();
        },
      );
      addTearDown(controller.dispose);

      controller.updateText('/');
      await controller.ensureCatalog();
      controller.updateText('/s');
      await controller.ensureCatalog();
      controller.updateText('/st');
      expect(await controller.ensureCatalog(), isTrue);
      expect(loads, 1);
    });

    test('concurrent ensureCatalog calls share one request', () async {
      var loads = 0;
      final controller = SlashCommandController(
        loadCatalog: () async {
          loads += 1;
          return _catalog();
        },
      );
      addTearDown(controller.dispose);

      await Future.wait([
        controller.ensureCatalog(),
        controller.ensureCatalog(),
        controller.ensureCatalog(),
      ]);
      expect(loads, 1);
    });

    test('invalidate refetches on the next request', () async {
      var loads = 0;
      final controller = SlashCommandController(
        loadCatalog: () async {
          loads += 1;
          return _catalog();
        },
      );
      addTearDown(controller.dispose);

      await controller.ensureCatalog();
      expect(loads, 1);
      controller.invalidate();
      expect(controller.catalogLoaded, isFalse);
      await controller.ensureCatalog();
      expect(loads, 2);
    });

    test('a scope change invalidates the cache', () async {
      var loads = 0;
      final controller = SlashCommandController(
        cacheScope: 'connection-a',
        loadCatalog: () async {
          loads += 1;
          return _catalog();
        },
      );
      addTearDown(controller.dispose);

      await controller.ensureCatalog();
      controller.updateScope('connection-a');
      await controller.ensureCatalog();
      expect(loads, 1);

      controller.updateScope('connection-b');
      await controller.ensureCatalog();
      expect(loads, 2);
    });
  });

  group('gateway failure', () {
    test('a failed catalogue disables the dropdown without throwing', () async {
      var loads = 0;
      final controller = SlashCommandController(
        loadCatalog: () async {
          loads += 1;
          throw StateError('gateway offline');
        },
      );
      addTearDown(controller.dispose);

      controller.updateText('/status');
      expect(await controller.ensureCatalog(), isFalse);
      expect(controller.isOpen, isFalse);
      expect(controller.catalogUnavailable, isTrue);
      expect(controller.matches, isEmpty);

      // No retry per keystroke: the composer keeps working, the feature stays
      // off until an explicit invalidation.
      controller.updateText('/sta');
      await controller.ensureCatalog();
      expect(loads, 1);

      controller.invalidate();
      expect(controller.catalogUnavailable, isFalse);
      expect(await controller.ensureCatalog(), isFalse);
      expect(loads, 2);
    });

    test('without a catalogue only the reviewed set is a hint', () {
      final controller = SlashCommandController(
        loadCatalog: () async => _catalog(),
      );
      addTearDown(controller.dispose);
      expect(controller.catalogLoaded, isFalse);
      // Last resort while the catalogue has not answered...
      expect(controller.isExecutable('status'), isTrue);
      // ...and never a claim about a name the reviewed set does not know.
      expect(controller.isExecutable('model'), isFalse);
    });
  });

  group('catalogue execution set', () {
    test('a loaded catalogue is the authority', () async {
      final controller = SlashCommandController(
        loadCatalog: () async => _catalog(),
      );
      addTearDown(controller.dispose);
      await controller.ensureCatalog();

      expect(controller.isExecutable('status'), isTrue);
      expect(controller.isExecutable('cron'), isTrue);
      expect(controller.isExecutable('model'), isTrue);
      expect(controller.isExecutable('deploy'), isTrue);
      expect(controller.isExecutable('/title'), isTrue);
      // In the reviewed fallback but absent from this profile: not executable.
      expect(controller.isExecutable('skills'), isFalse);
      expect(controller.isExecutable('steer'), isFalse);
    });

    test('a legacy explicit set still wins when advertised', () async {
      final controller = SlashCommandController(
        loadCatalog: () async => _catalog(executable: {'model'}),
      );
      addTearDown(controller.dispose);
      await controller.ensureCatalog();

      expect(controller.isExecutable('model'), isTrue);
      expect(controller.isExecutable('status'), isFalse);
    });
  });

  group('learned refusals', () {
    test('a refused command disappears from the dropdown matches', () async {
      final controller = SlashCommandController(
        loadCatalog: () async => _catalog(),
        limit: 20,
      );
      addTearDown(controller.dispose);
      controller.updateText('/');
      await controller.ensureCatalog();
      expect(controller.matches.map((c) => c.name), contains('status'));

      controller.markRefused('/status');
      expect(controller.matches.map((c) => c.name), isNot(contains('status')));
      controller.updateText('/st');
      expect(controller.matches.map((c) => c.name), isNot(contains('status')));
    });

    test(
      'reconnect drops the learned refusals even with a reused catalog',
      () async {
        final memory = SlashCommandRefusals();
        final catalog = _catalog();
        final controller = SlashCommandController(
          loadCatalog: () async => catalog,
          refusals: memory,
          limit: 20,
        );
        addTearDown(controller.dispose);
        await controller.ensureCatalog();
        controller.markRefused('status');
        memory.reset();
        controller.invalidate();
        await controller.ensureCatalog();
        expect(controller.matches.map((c) => c.name), contains('status'));
      },
    );
  });

  group('dropdown', () {
    testWidgets('lists the filtered commands and reports a choice', (
      tester,
    ) async {
      final controller = SlashCommandController(
        loadCatalog: () async => _catalog(),
      );
      addTearDown(controller.dispose);
      controller.updateText('/st');
      await controller.ensureCatalog();

      SlashCommand? selected;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SlashCommandDropdown(
              controller: controller,
              onSelected: (command) => selected = command,
            ),
          ),
        ),
      );

      expect(find.text('/status'), findsOneWidget);
      expect(find.text('/nostalgia'), findsOneWidget);
      expect(find.text('/model'), findsNothing);

      await tester.tap(find.text('/status'));
      expect(selected?.name, 'status');
    });

    testWidgets('explains an empty result instead of collapsing', (
      tester,
    ) async {
      final controller = SlashCommandController(
        loadCatalog: () async => _catalog(),
      );
      addTearDown(controller.dispose);
      controller.updateText('/zzz');
      await controller.ensureCatalog();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SlashCommandDropdown(
              controller: controller,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('No matching commands'), findsOneWidget);
      expect(find.text('/status'), findsNothing);
    });
  });

  group('catalogue wire shape', () {
    test('pairs, categories, plugin commands and skills build the list', () {
      final catalog = _catalog();

      expect(catalog.commands.map((command) => command.name), [
        'help',
        'status',
        'plan',
        'model',
        'title',
        'yolo',
        'cron',
        'review',
        'nostalgia',
        'skill:review',
        'logs',
        'deploy',
        'skill:orphan',
      ]);
      expect(catalog.canExecute('title'), isTrue);
      expect(catalog.canExecute('/TITLE'), isTrue);
      expect(catalog.canExecute('not-a-command'), isFalse);
    });

    test('categories label the rows they group', () {
      final byName = {
        for (final command in _catalog().commands) command.name: command,
      };
      expect(byName['status']!.category, 'Session');
      expect(byName['title']!.category, 'Session');
      expect(byName['model']!.category, 'Config');
      expect(byName['logs']!.category, 'TUI');
      expect(byName['help']!.category, isEmpty);
      expect(byName['deploy']!.category, 'Plugin commands');
      expect(byName['skill:orphan']!.category, 'Skills');
    });

    test('plugin commands carry a slash and their description', () {
      final deploy = _catalog().commands.firstWhere(
        (command) => command.name == 'deploy',
      );
      expect(deploy.invocation, '/deploy');
      expect(deploy.description, 'Deploy the current build');
    });

    test('a skill without a pairs row keeps an empty description', () {
      final orphan = _catalog().commands.firstWhere(
        (command) => command.name == 'skill:orphan',
      );
      expect(orphan.description, isEmpty);
      expect(orphan.invocation, '/skill:orphan');
    });

    test('duplicate names dedupe on their canonical key', () {
      final catalog = SlashCommandCatalog.fromResult({
        'pairs': [
          ['/logs', 'Show recent gateway log lines'],
        ],
        'categories': [
          {
            'name': 'TUI',
            'pairs': [
              ['/logs', 'Show recent gateway log lines'],
            ],
          },
        ],
        // A display row hides this one, but it is still a plugin command.
        'plugin_commands': {'logs': 'Plugin copy'},
      });
      expect(catalog.commands.map((command) => command.name), ['logs']);
      expect(
        catalog.commands.single.description,
        'Show recent gateway log lines',
      );
      expect(catalog.commands.single.category, 'TUI');
    });

    test('aliases resolve to their canonical command', () {
      final catalog = SlashCommandCatalog.fromResult({
        'pairs': [
          ['/help', 'Show help'],
          ['/h', 'alias row'],
        ],
        'canon': {'/h': '/help'},
      });
      expect(catalog.commands.map((command) => command.name), ['help']);
      expect(catalog.canExecute('/h'), isTrue);
      expect(catalog.canExecute('h'), isTrue);
    });

    test('argument_mode attaches from the commands dict', () {
      final byName = {
        for (final command in _catalog().commands) command.name: command,
      };
      expect(byName['help']!.argumentMode, 'text');
      expect(byName['title']!.argumentMode, 'text');
      expect(byName['model']!.argumentMode, 'options');
      expect(byName['cron']!.argumentMode, 'mixed');
      expect(byName['status']!.argumentMode, isNull);
      expect(byName['deploy']!.argumentMode, isNull);
    });

    test('an unknown argument_mode is ignored', () {
      final catalog = SlashCommandCatalog.fromResult({
        'pairs': [
          ['/odd', 'Odd mode'],
        ],
        'commands': {
          '/odd': {'argument_mode': 'freetext'},
        },
      });
      expect(catalog.commands.single.argumentMode, isNull);
    });

    test('a bare list of names still parses', () {
      final catalog = SlashCommandCatalog.fromResult(['/status', 'help']);
      expect(catalog.commands.map((command) => command.name), [
        'status',
        'help',
      ]);
    });

    test('legacy command maps in an entries envelope still parse', () {
      final catalog = SlashCommandCatalog.fromResult({
        'entries': [
          {'name': '/status', 'summary': 'Show status', 'group': 'reads'},
        ],
      });
      final command = catalog.commands.single;
      expect(command.name, 'status');
      expect(command.invocation, '/status');
      expect(command.description, 'Show status');
      expect(command.category, 'reads');
    });

    test('invalid entries are dropped', () {
      final catalog = SlashCommandCatalog.fromResult({
        'pairs': [
          ['', 'empty'],
          ['with space', 'not a command'],
          [42, 'number'],
          [null, 'null'],
        ],
        'plugin_commands': {'': 'empty', ' ok ': 'trimmed'},
      });
      expect(catalog.commands.map((command) => command.name), ['ok']);
    });
  });

  group('slash.exec result shape', () {
    test('typeless output is an exec notice', () {
      final result = SlashCommandResult.fromResult(
        _workerOutput('/status\nok'),
      );
      expect(result.kind, SlashCommandResultKind.exec);
      expect(result.isExecuted, isTrue);
      expect(result.text, '/status\nok');
    });

    test('a warning is appended to the output', () {
      final result = SlashCommandResult.fromResult(
        _workerOutput('/status\nok', warning: 'Session mirror failed'),
      );
      expect(result.kind, SlashCommandResultKind.exec);
      expect(result.text, '/status\nok\n\nSession mirror failed');
      expect(result.text, contains('Session mirror failed'));
    });

    test('a warning alone is still shown', () {
      final result = SlashCommandResult.fromResult({
        'output': '',
        'warning': 'Side effects not mirrored',
      });
      expect(result.kind, SlashCommandResultKind.exec);
      expect(result.text, 'Side effects not mirrored');
    });

    test('output wins over a missing or unknown type', () {
      for (final type in [null, 'exec', 'plugin', 'mystery']) {
        final result = SlashCommandResult.fromResult({
          'type': ?type,
          'output': 'done',
        });
        expect(result.kind, SlashCommandResultKind.exec, reason: '$type');
        expect(result.text, 'done');
      }
    });

    test('skill and send directives become prompts', () {
      for (final type in ['skill', 'send']) {
        final result = SlashCommandResult.fromResult({
          'type': type,
          'message': 'Summarize the repo',
        });
        expect(result.kind, SlashCommandResultKind.prompt);
        expect(result.isPrompt, isTrue);
        expect(result.text, 'Summarize the repo');
      }
    });

    test('a prefill directive fills the composer instead of sending', () {
      final result = SlashCommandResult.fromResult({
        'type': 'prefill',
        'message': 'Explain the diff',
        'display': 'Prefilled',
      });
      expect(result.kind, SlashCommandResultKind.prefill);
      expect(result.isPrefill, isTrue);
      expect(result.text, 'Explain the diff');
    });

    test('an alias directive never re-sends and shows what it named', () {
      expect(
        SlashCommandResult.fromResult({
          'type': 'alias',
          'target': '/status',
          'display': 'Alias for /status',
        }).text,
        'Alias for /status',
      );
      expect(
        SlashCommandResult.fromResult({
          'type': 'alias',
          'target': 'status',
        }).text,
        '/status',
      );
    });

    test('a directive without its payload is a no-output notice', () {
      for (final result in [
        SlashCommandResult.fromResult({'type': 'skill', 'message': '  '}),
        SlashCommandResult.fromResult({'type': 'prefill'}),
        SlashCommandResult.fromResult({'type': 'exec'}),
        SlashCommandResult.fromResult(null),
        SlashCommandResult.fromResult(const <String, Object?>{}),
      ]) {
        expect(result.kind, SlashCommandResultKind.exec);
        expect(result.text, isEmpty);
      }
    });
  });

  group('screen dispatch', () {
    testWidgets("a command with arguments dispatches the full line", (
      tester,
    ) async {
      final gateway = _FakeSlashGateway(
        result: SlashCommandResult.fromResult(
          _workerOutput('YOLO mode enabled'),
        ),
      );
      await _pumpChat(tester, slashGateway: gateway);

      await tester.enterText(find.byKey(_composerKey), '/yolo on');
      await tester.pump();
      await _send(tester);

      expect(gateway.commands, ['/yolo on']);
      // Exec output is a local notice, never a prompt.
      expect(find.byKey(const Key('slash-command-notice')), findsOneWidget);
      expect(find.text('YOLO mode enabled'), findsOneWidget);
      expect(_composerText(tester), isEmpty);
    });

    testWidgets('/title A B keeps its arguments in the RPC', (tester) async {
      final gateway = _FakeSlashGateway(
        result: SlashCommandResult.fromResult(_workerOutput('title set')),
      );
      await _pumpChat(tester, slashGateway: gateway);

      await tester.enterText(find.byKey(_composerKey), '/title A B');
      await tester.pump();
      await _send(tester);

      expect(gateway.commands, ['/title A B']);
    });

    testWidgets('a picked command is persisted as the draft', (tester) async {
      final gateway = _FakeSlashGateway();
      await _pumpChat(
        tester,
        slashGateway: gateway,
        sessionId: 'slash-draft-session',
      );

      await tester.enterText(find.byKey(_composerKey), '/st');
      await tester.pump();
      await tester.tap(find.text('/status'));
      await tester.pump();
      expect(_composerText(tester), '/status ');

      // Leaving the chat persists exactly what typing would have; reopening
      // restores it without any send.
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      await _pumpChat(
        tester,
        slashGateway: gateway,
        sessionId: 'slash-draft-session',
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('/status '), findsOneWidget);
      expect(gateway.commands, isEmpty);
    });

    testWidgets('a prefill directive fills the composer without sending', (
      tester,
    ) async {
      final gateway = _FakeSlashGateway(
        result: SlashCommandResult.fromResult({
          'type': 'prefill',
          'message': 'Explain the diff',
        }),
      );
      await _pumpChat(tester, slashGateway: gateway);

      await tester.enterText(find.byKey(_composerKey), '/plan');
      await tester.pump();
      await _send(tester);

      expect(gateway.commands, ['/plan']);
      expect(_composerText(tester), 'Explain the diff');
      expect(find.byKey(const Key('slash-command-notice')), findsNothing);
    });

    testWidgets('a send timeout keeps the draft and never submits prose', (
      tester,
    ) async {
      final submitted = <String>[];
      final gateway = _FakeSlashGateway(
        error: JsonRpcError('slash.exec', 'Timeout'),
      );
      await _pumpChat(
        tester,
        slashGateway: gateway,
        remoteSubmit:
            ({
              required sessionId,
              required text,
              required onEvent,
              required onSent,
            }) async {
              onSent();
              submitted.add(text);
            },
      );

      await tester.enterText(find.byKey(_composerKey), '/review');
      await tester.pump();
      await _send(tester);

      expect(gateway.commands, ['/review']);
      expect(submitted, isEmpty);
      expect(_composerText(tester), '/review');
      expect(find.byKey(const Key('slash-command-notice')), findsNothing);
      expect(
        find.textContaining('may still be running on the gateway'),
        findsOneWidget,
      );
    });

    testWidgets('a post-write disconnect is handled as delivery unknown', (
      tester,
    ) async {
      final submitted = <String>[];
      final gateway = _FakeSlashGateway(
        error: JsonRpcError(
          'slash.exec',
          'Desktop gateway connection closed',
          reason: 'connection_closed',
        ),
      );
      await _pumpChat(
        tester,
        slashGateway: gateway,
        remoteSubmit:
            ({
              required sessionId,
              required text,
              required onEvent,
              required onSent,
            }) async {
              onSent();
              submitted.add(text);
            },
      );

      await tester.enterText(find.byKey(_composerKey), '/cron run');
      await tester.pump();
      await _send(tester);

      expect(submitted, isEmpty);
      expect(_composerText(tester), '/cron run');
      expect(
        find.textContaining('may still be running on the gateway'),
        findsOneWidget,
      );
    });

    testWidgets(
      'a catalogued unsupported command shows a refusal notice, not prose',
      (tester) async {
        final submitted = <String>[];
        final gateway = _FakeSlashGateway(
          error: JsonRpcError(
            'slash.exec',
            'not a quick/plugin/bundle/skill command: /status',
            code: 4018,
          ),
        );
        await _pumpChat(
          tester,
          slashGateway: gateway,
          remoteSubmit:
              ({
                required sessionId,
                required text,
                required onEvent,
                required onSent,
              }) async {
                onSent();
                submitted.add(text);
              },
        );

        await tester.enterText(find.byKey(_composerKey), '/status');
        await tester.pump();
        await _send(tester);

        expect(gateway.commands, ['/status']);
        expect(submitted, isEmpty);
        expect(_composerText(tester), '/status');
        expect(find.byKey(Key('slash-command-notice')), findsOneWidget);
        expect(
          find.textContaining('not available on this server'),
          findsOneWidget,
        );
      },
    );

    testWidgets('the gateway refusal hint rides the notice card', (
      tester,
    ) async {
      final submitted = <String>[];
      final gateway = _FakeSlashGateway(
        error: JsonRpcError(
          'slash.exec',
          'unsupported_command',
          code: 4018,
          data: {'detail': 'Run `hermes backup --quick` in a terminal.'},
        ),
      );
      await _pumpChat(
        tester,
        slashGateway: gateway,
        remoteSubmit:
            ({
              required sessionId,
              required text,
              required onEvent,
              required onSent,
            }) async {
              onSent();
              submitted.add(text);
            },
      );

      await tester.enterText(find.byKey(_composerKey), '/status');
      await tester.pump();
      await _send(tester);

      expect(submitted, isEmpty);
      expect(
        find.textContaining('Run `hermes backup --quick` in a terminal.'),
        findsOneWidget,
      );
      expect(find.textContaining('not available on this server'), findsNothing);
    });

    testWidgets(
      'a transport-level 4001 keeps the draft and the dropdown intact',
      (tester) async {
        final submitted = <String>[];
        final gateway = _FakeSlashGateway(
          error: JsonRpcError('slash.exec', 'session not found', code: 4001),
        );
        await _pumpChat(
          tester,
          slashGateway: gateway,
          remoteSubmit:
              ({
                required sessionId,
                required text,
                required onEvent,
                required onSent,
              }) async {
                onSent();
                submitted.add(text);
              },
        );

        await tester.enterText(find.byKey(_composerKey), '/status');
        await tester.pump();
        await _send(tester);

        // A failure is not permission to send the command a second time.
        expect(submitted, isEmpty);
        expect(_composerText(tester), '/status');
        expect(find.byKey(Key('slash-command-notice')), findsNothing);

        await tester.enterText(find.byKey(_composerKey), '/stat');
        await pumpChatUpdates(tester);
        expect(find.byKey(ValueKey('slash-command-status')), findsOneWidget);
      },
    );

    testWidgets(
      'the control-socket refusal shape (4001 + data.reason) gets the card',
      (tester) async {
        final submitted = <String>[];
        final gateway = _FakeSlashGateway(
          error: JsonRpcError(
            'slash.exec',
            'unsupported_command',
            code: 4001,
            // What `JsonRpcError.fromGateway` produces from the wire: the
            // verdict rides data.reason and is surfaced on `.reason`.
            reason: 'unsupported_command',
            data: {
              'reason': 'unsupported_command',
              'detail':
                  'Run `hermes profile export [name] -o <file>` in a terminal.',
            },
          ),
        );
        await _pumpChat(
          tester,
          slashGateway: gateway,
          remoteSubmit:
              ({
                required sessionId,
                required text,
                required onEvent,
                required onSent,
              }) async {
                onSent();
                submitted.add(text);
              },
        );

        await tester.enterText(find.byKey(_composerKey), '/status');
        await tester.pump();
        await _send(tester);

        // Live stock gateways refuse with code 4001 and ride the verdict in
        // data.reason — this is the shape shipped servers actually send.
        expect(submitted, isEmpty);
        expect(
          find.textContaining('Run `hermes profile export'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'an unsupported_session_field verdict is not a command refusal',
      (tester) async {
        final submitted = <String>[];
        final gateway = _FakeSlashGateway(
          error: JsonRpcError(
            'slash.exec',
            'refused',
            code: 4001,
            reason: 'unsupported_session_field',
            data: {'reason': 'unsupported_session_field'},
          ),
        );
        await _pumpChat(
          tester,
          slashGateway: gateway,
          remoteSubmit:
              ({
                required sessionId,
                required text,
                required onEvent,
                required onSent,
              }) async {
                onSent();
                submitted.add(text);
              },
        );

        await tester.enterText(find.byKey(_composerKey), '/status');
        await tester.pump();
        await _send(tester);

        expect(submitted, isEmpty);
        expect(_composerText(tester), '/status');
        expect(find.byKey(Key('slash-command-notice')), findsNothing);
      },
    );

    testWidgets('a refused command is no longer offered by the dropdown', (
      tester,
    ) async {
      final gateway = _FakeSlashGateway(
        error: JsonRpcError('slash.exec', 'unsupported_command', code: 4018),
      );
      await _pumpChat(tester, slashGateway: gateway);

      await tester.enterText(find.byKey(_composerKey), '/status');
      await tester.pump();
      await _send(tester);

      await tester.enterText(find.byKey(_composerKey), '/stat');
      await pumpChatUpdates(tester);
      expect(find.byType(SlashCommandDropdown), findsOneWidget);
      expect(find.byKey(ValueKey('slash-command-status')), findsNothing);
      expect(find.text('No matching commands'), findsOneWidget);
    });

    testWidgets(
      'an unsupported command outside the catalogue still falls back to the plain send',
      (tester) async {
        final submitted = <String>[];
        final gateway = _FakeSlashGateway(
          error: JsonRpcError(
            'slash.exec',
            'not a quick/plugin/bundle/skill command: /notacommand',
            code: 4018,
          ),
        );
        await _pumpChat(
          tester,
          slashGateway: gateway,
          remoteSubmit:
              ({
                required sessionId,
                required text,
                required onEvent,
                required onSent,
              }) async {
                onSent();
                submitted.add(text);
              },
        );

        await tester.enterText(find.byKey(_composerKey), '/notacommand');
        await tester.pump();
        await _send(tester);

        expect(submitted, ['/notacommand']);
        expect(_composerText(tester), isEmpty);
      },
    );
  });

  group('screen local intercepts', () {
    // A model inventory (plus session metadata the picker's getSession call
    // insists on) so `/model` can actually open the picker sheet.
    http.Client inventoryClient() => MockClient((req) async {
      if (req.url.path.contains('api/model/options')) {
        return http.Response(
          '{"model":"fixmodel","providers":[{"slug":"fixprov","models":["fixmodel"]}]}',
          200,
        );
      }
      if (req.url.path.startsWith('/api/sessions/')) {
        return http.Response(
          '{"object":"hermes.session","session":{"id":"x","model":"fixmodel"}}',
          200,
        );
      }
      return http.Response('{"data":[]}', 200);
    });

    Future<void> expectModelPicker(WidgetTester tester, String line) async {
      final gateway = _FakeSlashGateway();
      final submitted = <String>[];
      await _pumpChat(
        tester,
        slashGateway: gateway,
        apiClient: inventoryClient(),
        remoteSubmit:
            ({
              required sessionId,
              required text,
              required onEvent,
              required onSent,
            }) async {
              onSent();
              submitted.add(text);
            },
      );

      await tester.enterText(find.byKey(_composerKey), line);
      await tester.pump();
      // Not _send(): its pumpAndSettle never settles once the picker's
      // spinner opens, so drive the tap with timed pumps instead.
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(gateway.commands, isEmpty);
      expect(submitted, isEmpty);
      expect(_composerText(tester), isEmpty);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(BottomSheet), findsOneWidget);
    }

    testWidgets('/model opens the model picker instead of asking the gateway', (
      tester,
    ) async {
      await expectModelPicker(tester, '/model');
    });

    testWidgets('//model canonicalizes to the same local path', (tester) async {
      await expectModelPicker(tester, '//model');
    });

    testWidgets('/MODEL casefolds to the same local path', (tester) async {
      await expectModelPicker(tester, '/MODEL');
    });

    testWidgets('/sessions opens the resume picker over the listed chats', (
      tester,
    ) async {
      final gateway = _FakeSlashGateway();
      final opened = <String>[];
      Map<String, Object?> row(String id, String source) => {
        'id': id,
        'title': 'Chat $id',
        'model': 'm',
        'message_count': 1,
        'started_at': 1,
        'source': source,
      };
      await _pushChat(
        tester,
        slashGateway: gateway,
        opened: opened,
        apiClient: MockClient(
          (request) async => http.Response(
            jsonEncode({
              'data': [
                row('human', 'cli'),
                row('nightly', 'cron'),
                row('batch', 'kanban'),
              ],
            }),
            200,
          ),
        ),
      );

      await tester.enterText(find.byKey(_composerKey), '/sessions');
      await tester.pump();
      await _send(tester);

      expect(gateway.commands, isEmpty);
      expect(find.text('Resume a chat'), findsOneWidget);
      expect(find.text('Chat human'), findsOneWidget);
      expect(find.text('Chat nightly'), findsNothing, reason: 'cron');
      expect(find.text('Chat batch'), findsNothing, reason: 'kanban');
      await tester.tap(find.text('Chat human'));
      await pumpChatUpdates(tester);
      expect(opened, ['human'], reason: "through the host's open path");
    });

    testWidgets('/resume opens the resume picker too, and cancelling gives '
        'the line back', (tester) async {
      final gateway = _FakeSlashGateway();
      await _pushChat(tester, slashGateway: gateway, opened: []);

      await tester.enterText(find.byKey(_composerKey), '/resume old');
      await tester.pump();
      await _send(tester);

      expect(gateway.commands, isEmpty);
      expect(find.text('Resume a chat'), findsOneWidget);
      await tester.tapAt(const Offset(5, 5));
      await pumpChatUpdates(tester);
      expect(find.text('Resume a chat'), findsNothing);
      expect(_composerText(tester), '/resume old');
    });

    testWidgets('/sessions in an embedded chat answers with a notice', (
      tester,
    ) async {
      final gateway = _FakeSlashGateway();
      await _pumpChat(tester, slashGateway: gateway);

      await tester.enterText(find.byKey(_composerKey), '/sessions');
      await tester.pump();
      await _send(tester);

      expect(gateway.commands, isEmpty);
      expect(_composerText(tester), '/sessions');
      expect(find.byKey(Key('slash-command-notice')), findsOneWidget);
      expect(find.textContaining('session list'), findsOneWidget);
    });
  });
  group('review regressions', () {
    Future<List<String>> prepare(
      WidgetTester tester,
      _FakeSlashGateway gateway, {
      http.Client? apiClient,
    }) async {
      final submitted = <String>[];
      await _pumpChat(
        tester,
        slashGateway: gateway,
        apiClient: apiClient,
        remoteSubmit:
            ({
              required sessionId,
              required text,
              required onEvent,
              required onSent,
            }) async {
              onSent();
              submitted.add(text);
            },
      );
      return submitted;
    }

    testWidgets(
      'a fresh send directive submits its expanded prompt exactly once',
      (tester) async {
        final gateway = _FakeSlashGateway(
          result: SlashCommandResult.fromResult({
            'type': 'send',
            'message': 'expanded body',
          }),
        );
        final submitted = await prepare(tester, gateway);
        await tester.enterText(find.byKey(_composerKey), '/plan');
        await _send(tester);
        expect(gateway.commands, ['/plan']);
        expect(submitted, ['expanded body']);
        expect(_composerText(tester), isEmpty);
      },
    );

    testWidgets('refusal after a catalog timeout never becomes prose', (
      tester,
    ) async {
      final gateway = _HeldCatalogGateway()
        ..failure = JsonRpcError(
          'slash.exec',
          'unsupported_command',
          code: 4001,
          reason: 'unsupported_command',
        );
      final submitted = await prepare(tester, gateway);
      await tester.enterText(find.byKey(_composerKey), '/logs');
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 4));
      await pumpChatUpdates(tester);
      expect(gateway.commands, ['/logs']);
      expect(submitted, isEmpty);
      expect(_composerText(tester), '/logs');
      expect(find.byKey(const Key('slash-command-notice')), findsOneWidget);
      gateway.pending.complete(_catalog());
      await pumpChatUpdates(tester);
      await tester.enterText(find.byKey(_composerKey), '/log');
      await pumpChatUpdates(tester);
      expect(find.byKey(const ValueKey('slash-command-logs')), findsNothing);
    });

    testWidgets('refusal without a loaded catalog never becomes prose', (
      tester,
    ) async {
      final gateway = _FakeSlashGateway(
        catalogError: StateError('offline'),
        error: JsonRpcError.fromGateway('slash.exec', {
          'code': 4001,
          'message': 'unsupported_command',
          'data': {
            'reason': 'unsupported_command',
            'detail': 'Use a terminal.',
          },
        }, fallbackMessage: 'Slash failed'),
      );
      final submitted = await prepare(tester, gateway);
      await tester.enterText(find.byKey(_composerKey), '/logs');
      await _send(tester);
      expect(gateway.commands, ['/logs']);
      expect(submitted, isEmpty);
      expect(_composerText(tester), '/logs');
      expect(find.textContaining('Use a terminal.'), findsOneWidget);
    });

    testWidgets('an argument refusal does not hide the bare command', (
      tester,
    ) async {
      final gateway = _FakeSlashGateway(
        error: JsonRpcError(
          'slash.exec',
          'unsupported_command',
          code: 4001,
          reason: 'unsupported_command',
        ),
      );
      final submitted = await prepare(tester, gateway);
      await tester.enterText(find.byKey(_composerKey), '/cron add');
      await _send(tester);
      expect(submitted, isEmpty);
      expect(_composerText(tester), '/cron add');
      await tester.enterText(find.byKey(_composerKey), '/cron');
      await pumpChatUpdates(tester);
      expect(find.byKey(const ValueKey('slash-command-cron')), findsOneWidget);
    });

    testWidgets('4018 execution failures do not poison the command dropdown', (
      tester,
    ) async {
      final gateway = _FakeSlashGateway(
        error: JsonRpcError(
          'slash.exec',
          'quick command failed with exit code 1',
          code: 4018,
        ),
      );
      final submitted = await prepare(tester, gateway);
      await tester.enterText(find.byKey(_composerKey), '/status');
      await _send(tester);
      expect(submitted, isEmpty);
      expect(_composerText(tester), '/status');
      expect(
        find.byKey(const ValueKey('slash-command-status')),
        findsOneWidget,
      );
    });

    testWidgets('model discovery failure preserves the shortcut draft', (
      tester,
    ) async {
      final gateway = _FakeSlashGateway();
      final submitted = await prepare(
        tester,
        gateway,
        apiClient: MockClient((_) async => http.Response('{"data":[]}', 200)),
      );
      await tester.enterText(find.byKey(_composerKey), '/model');
      await _send(tester);
      expect(submitted, isEmpty);
      expect(gateway.commands, isEmpty);
      expect(_composerText(tester), '/model');
      expect(find.byType(BottomSheet), findsNothing);
    });

    for (final line in ['/model gpt-5', '/resume old-chat', '/sessions all']) {
      testWidgets('$line does not silently discard arguments', (tester) async {
        final gateway = _FakeSlashGateway();
        final submitted = await prepare(tester, gateway);
        await tester.enterText(find.byKey(_composerKey), line);
        await _send(tester);
        expect(submitted, isEmpty);
        expect(gateway.commands, isEmpty);
        expect(_composerText(tester), line);
        expect(find.byKey(const Key('slash-command-notice')), findsOneWidget);
      });
    }

    testWidgets('new typing wins over a delayed prefill response', (
      tester,
    ) async {
      final pending = Completer<SlashCommandResult>();
      final gateway = _FakeSlashGateway(pendingResult: pending);
      final submitted = await prepare(tester, gateway);
      await tester.enterText(find.byKey(_composerKey), '/plan');
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      expect(gateway.commands, ['/plan']);
      await tester.enterText(find.byKey(_composerKey), 'newer draft');
      pending.complete(const SlashCommandResult.prefill('obsolete prefill'));
      await pumpChatUpdates(tester);
      expect(_composerText(tester), 'newer draft');
      expect(submitted, isEmpty);
    });

    testWidgets('two taps during slash execution run exactly once', (
      tester,
    ) async {
      final pending = Completer<SlashCommandResult>();
      final gateway = _FakeSlashGateway(pendingResult: pending);
      final submitted = await prepare(tester, gateway);
      await tester.enterText(find.byKey(_composerKey), '/status');
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      expect(gateway.commands, ['/status']);
      expect(submitted, isEmpty);
      pending.complete(const SlashCommandResult.exec('done'));
      await pumpChatUpdates(tester);
      expect(gateway.commands, ['/status']);
      expect(submitted, isEmpty);
    });

    testWidgets('old refusal cannot poison a reconnected catalog', (
      tester,
    ) async {
      final pending = Completer<SlashCommandResult>();
      final gateway = _FakeSlashGateway(pendingResult: pending);
      final submitted = await prepare(tester, gateway);
      await tester.enterText(find.byKey(_composerKey), '/status');
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      gateway.slashRefusals.reset();
      pending.completeError(
        JsonRpcError('slash.exec', 'unsupported_command', code: 4018),
      );
      await pumpChatUpdates(tester);
      expect(_composerText(tester), '/status');
      expect(submitted, isEmpty);
      expect(find.byKey(const Key('slash-command-notice')), findsNothing);
      await tester.enterText(find.byKey(_composerKey), '/stat');
      await pumpChatUpdates(tester);
      expect(
        find.byKey(const ValueKey('slash-command-status')),
        findsOneWidget,
      );
    });

    testWidgets(
      'delayed send directive preserves a newer draft without sending',
      (tester) async {
        final pending = Completer<SlashCommandResult>();
        final gateway = _FakeSlashGateway(pendingResult: pending);
        final submitted = await prepare(tester, gateway);
        await tester.enterText(find.byKey(_composerKey), '/plan');
        await tester.tap(find.byTooltip('Send'));
        await tester.pump();
        await tester.enterText(find.byKey(_composerKey), 'new draft');
        pending.complete(const SlashCommandResult.prompt('expanded prompt'));
        await pumpChatUpdates(tester);
        expect(_composerText(tester), 'new draft');
        expect(submitted, isEmpty);
        expect(find.text('expanded prompt'), findsOneWidget);
      },
    );

    testWidgets(
      'model discovery completing after route disposal does not consume draft',
      (tester) async {
        final inventory = Completer<http.Response>();
        final gateway = _FakeSlashGateway();
        await prepare(
          tester,
          gateway,
          apiClient: MockClient((req) {
            if (req.url.path.contains('/api/model/options')) {
              return inventory.future;
            }
            return Future.value(http.Response('{"data":[]}', 200));
          }),
        );
        await tester.enterText(find.byKey(_composerKey), '/model');
        await tester.tap(find.byTooltip('Send'));
        await tester.pump();
        await tester.enterText(find.byKey(_composerKey), 'newer model draft');
        await tester.pumpWidget(const SizedBox());
        inventory.complete(
          http.Response(
            '{"model":"m","providers":[{"slug":"p","models":["m"]}]}',
            200,
          ),
        );
        await pumpChatUpdates(tester);
        expect(tester.takeException(), isNull);
        expect(gateway.commands, isEmpty);
      },
    );

    testWidgets(
      'a refused draft survives disposing and reopening the real route',
      (tester) async {
        final gateway = _FakeSlashGateway(
          error: JsonRpcError(
            'slash.exec',
            'unsupported_command',
            code: 4001,
            reason: 'unsupported_command',
          ),
        );
        final submitted = <String>[];
        const sessionId = 'refused-draft-reopen';
        await _pumpChat(
          tester,
          slashGateway: gateway,
          sessionId: sessionId,
          remoteSubmit:
              ({
                required sessionId,
                required text,
                required onEvent,
                required onSent,
              }) async {
                submitted.add(text);
                onSent();
              },
        );
        await tester.enterText(find.byKey(_composerKey), '/status');
        await _send(tester);
        await tester.pumpWidget(const SizedBox());
        await pumpChatUpdates(tester);
        await _pumpChat(tester, slashGateway: gateway, sessionId: sessionId);
        expect(_composerText(tester), '/status');
        expect(submitted, isEmpty);
        expect(gateway.commands, ['/status']);
        expect(
          find.byKey(const ValueKey('slash-command-status')),
          findsNothing,
        );
      },
    );

    testWidgets('new typing survives successful model discovery', (
      tester,
    ) async {
      final inventory = Completer<http.Response>();
      final gateway = _FakeSlashGateway();
      await prepare(
        tester,
        gateway,
        apiClient: MockClient((req) {
          if (req.url.path.contains('/api/model/options')) {
            return inventory.future;
          }
          if (req.url.path.startsWith('/api/sessions/') &&
              !req.url.path.endsWith('/messages')) {
            return Future.value(
              http.Response(
                '{"object":"hermes.session","session":{"id":"x","model":"m"}}',
                200,
              ),
            );
          }
          return Future.value(http.Response('{"data":[]}', 200));
        }),
      );
      await tester.enterText(find.byKey(_composerKey), '/model');
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      await tester.enterText(find.byKey(_composerKey), 'new model draft');
      inventory.complete(
        http.Response(
          '{"model":"m","providers":[{"slug":"p","models":["m"]}]}',
          200,
        ),
      );
      for (
        var i = 0;
        i < 20 && find.byType(BottomSheet).evaluate().isEmpty;
        i++
      ) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(_composerText(tester), 'new model draft');
    });

    testWidgets(
      'a sessions shortcut never blindly pops an unrelated pushed route',
      (tester) async {
        final gateway = _FakeSlashGateway();
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: SizedBox(key: Key('not-a-browser'))),
          ),
        );
        Navigator.of(
          tester.element(find.byKey(const Key('not-a-browser'))),
        ).push(
          MaterialPageRoute(
            builder: (_) => _chatScreen(
              slashGateway: gateway,
              sessionId: 'not-a-browser-chat',
            ),
          ),
        );
        await pumpChatUpdates(tester);
        await tester.enterText(find.byKey(_composerKey), '/sessions');
        await _send(tester);
        expect(find.byKey(_composerKey), findsOneWidget);
        expect(_composerText(tester), '/sessions');
        expect(find.byKey(const Key('slash-command-notice')), findsOneWidget);
        expect(gateway.commands, isEmpty);
      },
    );

    testWidgets('disposing a route during catalog load never sends prose', (
      tester,
    ) async {
      final gateway = _HeldCatalogGateway();
      final submitted = await prepare(tester, gateway);
      await tester.enterText(find.byKey(_composerKey), '/status');
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
      gateway.pending.complete(_catalog());
      await tester.pump();
      expect(submitted, isEmpty);
      expect(gateway.commands, isEmpty);
      expect(tester.takeException(), isNull);
    });
  });
  group('connection refusal authority', () {
    test(
      'aliases absent from pairs still execute and share refusals',
      () async {
        final catalog = SlashCommandCatalog.fromResult({
          'pairs': [
            ['/help', 'Help'],
          ],
          'canon': {'/h': '/help'},
        });
        final memory = SlashCommandRefusals();
        final first = SlashCommandController(
          loadCatalog: () async => catalog,
          refusals: memory,
        );
        final second = SlashCommandController(
          loadCatalog: () async => catalog,
          refusals: memory,
        );
        addTearDown(second.dispose);
        await first.ensureCatalog();
        await second.ensureCatalog();
        expect(first.isExecutable('h'), isTrue);
        var changes = 0;
        second.addListener(() => changes++);
        first.markRefused('/H');
        expect(second.matches, isEmpty);
        expect(changes, greaterThan(0));
        first.dispose();
        // Disposed retained routes have detached from shared memory.
        memory.reset();
        await second.ensureCatalog();
        expect(second.matches.single.name, 'help');
      },
    );

    test('explicit empty execution set is authoritative in dropdown', () async {
      final controller = SlashCommandController(
        loadCatalog: () async => _catalog(executable: {}),
      );
      addTearDown(controller.dispose);
      await controller.ensureCatalog();
      expect(controller.matches, isEmpty);
      expect(controller.isExecutable('status'), isFalse);
    });

    test('a held old catalog cannot return after a memory reset', () async {
      final memory = SlashCommandRefusals();
      final old = Completer<SlashCommandCatalog>();
      var loads = 0;
      final controller = SlashCommandController(
        refusals: memory,
        loadCatalog: () {
          loads++;
          return loads == 1
              ? old.future
              : Future.value(_catalog(executable: {'help'}));
        },
      );
      addTearDown(controller.dispose);
      final held = controller.ensureCatalog();
      memory.reset();
      expect(await controller.ensureCatalog(), isTrue);
      old.complete(_catalog());
      expect(await held, isFalse);
      expect(controller.matches.single.name, 'help');
    });
  });
}
