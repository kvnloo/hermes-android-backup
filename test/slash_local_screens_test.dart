// Gap 16 of the review of v5/bots @ d74ba224: `/kanban` and `/bots` open an
// Ares screen, so both layouts offer them in their slash UI whether or not
// the gateway's command list has them.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/controllers/slash_command_controller.dart';
import 'package:hermes_android/core/models/slash_command.dart';
import 'package:hermes_android/core/screens/bots_screen.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/kanban_dock.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/data/slash_catalog.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/bots_review_fixture.dart';
import 'support/completed_stock_turn.dart';
import 'support/fake_kanban_source.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

/// A gateway catalogue with neither `/kanban` nor `/bots`.
SlashCommandCatalog _catalog() => SlashCommandCatalog.fromResult({
  'pairs': [
    ['/help', 'Show help'],
    ['/status', 'Show the session status'],
  ],
  'canon': {'/help': '/help', '/status': '/status'},
});

const _local = [
  SlashCommand(name: 'kanban', description: 'Open the Kanban board'),
  SlashCommand(name: 'bots', description: 'Open your bots'),
];

class _SlashGateway implements SlashCommandGateway {
  _SlashGateway(this.catalog);
  final Future<SlashCommandCatalog> catalog;
  final commands = <String>[];

  @override
  bool get slashCommandsSupported => true;

  @override
  Future<SlashCommandCatalog> fetchSlashCommands({String? sessionId}) =>
      catalog;

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

class _NgGateway extends NextGenGateway {
  _NgGateway()
    : super(
        SavedConnection(
          id: 'ng-local-screens',
          label: 'Home',
          host: '10.0.0.5',
          port: 9119,
          apiKey: '',
          desktopGatewayUrl: 'http://10.0.0.5:9119',
          singleLogin: true,
          signInMethod: 'none',
        ),
      );

  @override
  WsClient? get socket => null;

  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async => {
    'pairs': [
      ['/help', 'Show help'],
    ],
  };
}

List<String> _names(SlashCommandController c) => [
  for (final m in c.matches) m.name,
];

void main() {
  setUp(mockChatImageRecovery);

  group('Classic SlashCommandController', () {
    test('lists the local screen commands the catalogue lacks', () async {
      final controller = SlashCommandController(
        loadCatalog: () async => _catalog(),
        localCommands: () => _local,
      );
      addTearDown(controller.dispose);
      controller.updateText('/');
      await controller.ensureCatalog();
      expect(_names(controller), ['help', 'status', 'kanban', 'bots']);
      controller.updateText('/ka');
      expect(_names(controller), ['kanban']);
      controller.updateText('/bo');
      expect(_names(controller), ['bots']);
      expect(controller.isExecutable('/kanban'), isTrue);
      expect(controller.knowsCommand('bots'), isTrue);
      expect(controller.isExecutable('frobnicate'), isFalse);
    });

    test('a gateway entry of the same name wins; no duplicate', () async {
      final controller = SlashCommandController(
        loadCatalog: () async => SlashCommandCatalog.fromResult({
          'pairs': [
            ['/kanban', 'Kanban board commands (gateway)'],
          ],
        }),
        localCommands: () => _local,
      );
      addTearDown(controller.dispose);
      controller.updateText('/ka');
      await controller.ensureCatalog();
      expect(controller.matches.single.description, contains('gateway'));
    });

    test('a catalogue that fails still offers the local commands', () async {
      final controller = SlashCommandController(
        loadCatalog: () async => throw StateError('offline'),
        localCommands: () => _local,
      );
      addTearDown(controller.dispose);
      controller.updateText('/bot');
      await controller.ensureCatalog();
      expect(controller.isOpen, isTrue);
      expect(_names(controller), ['bots']);
    });

    test('without local commands nothing changes', () async {
      final controller = SlashCommandController(
        loadCatalog: () async => throw StateError('offline'),
      );
      addTearDown(controller.dispose);
      controller.updateText('/b');
      await controller.ensureCatalog();
      expect(controller.isOpen, isFalse);
      expect(controller.matches, isEmpty);
    });
  });

  testWidgets('Classic chat: typing /bo offers /bots, and sending it opens '
      'the bots screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(900, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final bots = BotsReviewGateway();
    final owner = botsReviewOwner(bots);
    addTearDown(owner.close);
    final slash = _SlashGateway(Future.value(_catalog()));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatScreen(
          connection: botsReviewConnection,
          session: Session(
            id: 'slash-local-screens',
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
          testSlashGateway: slash,
          testRemotePromptSubmit: completedStockTurn(null),
          testKanban: TestChatKanban(
            owner: owner,
            source: () => FakeKanbanSource(),
          ),
        ),
      ),
    );
    await pumpChatUpdates(tester);
    final composer = find.byKey(const Key('chat-message-composer'));
    await tester.enterText(composer, '/bo');
    await pumpChatUpdates(tester);
    final dropdown = find.byKey(const Key('slash-command-dropdown'));
    expect(dropdown, findsOneWidget);
    expect(
      find.descendant(of: dropdown, matching: find.text('/bots')),
      findsOneWidget,
    );
    await tester.enterText(composer, '/kanban');
    await pumpChatUpdates(tester);
    expect(
      find.descendant(of: dropdown, matching: find.text('/kanban')),
      findsOneWidget,
    );

    await tester.enterText(composer, '/bots');
    await pumpChatUpdates(tester);
    await tester.tap(find.byKey(const Key('chat-send-message')));
    await botsShown(tester, find.byType(BotsScreen));
    expect(slash.commands, isEmpty, reason: 'never sent to the gateway');
    await botsShown(tester, find.text('WorkBot'));
  });

  test('NextGen highlights /kanban and /bots with a description, catalogue '
      'or not', () async {
    final gateway = _NgGateway();
    addTearDown(gateway.dispose);
    final reader = NgSlashCatalog()..scopeTo(gateway);
    addTearDown(reader.dispose);
    for (final name in ['kanban', 'bots', 'Bots']) {
      final info = reader.resolve(name);
      expect(info, isNotNull, reason: name);
      expect(info!.description, isNotEmpty);
    }
    await reader.ensureLoaded();
    expect(reader.resolve('kanban')?.description, 'Open the Kanban board');
    expect(await reader.runsOnGateway('bots'), isTrue);
    expect(reader.resolve('frobnicate'), isNull);
  });
}
