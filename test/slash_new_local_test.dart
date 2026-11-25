import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/slash_command.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';
import 'support/completed_stock_turn.dart';

const _composerKey = Key('chat-message-composer');
const _sendKey = Key('chat-send-message');

/// Records every `slash.exec` the screen attempts so a test can prove a
/// command was handled locally instead of being sent to the gateway.
class _RecordingSlashGateway implements SlashCommandGateway {
  final List<String> executed = [];

  @override
  bool get slashCommandsSupported => true;

  @override
  Future<SlashCommandCatalog> fetchSlashCommands({String? sessionId}) async {
    return SlashCommandCatalog.fromResult({
      'pairs': [
        ['/new', 'Start a new session'],
        ['/reset', 'Start a new session'],
        ['/status', 'Show session status'],
      ],
      'canon': {'/reset': '/new'},
    });
  }

  @override
  Future<SlashCommandResult> runSlashCommand({
    required String sessionId,
    required String command,
    void Function()? onSent,
  }) async {
    onSent?.call();
    executed.add(command);
    return const SlashCommandResult.exec('command ran');
  }
}

/// A transport that never advertised slash commands (REST/SSE): the local
/// `/new` branch must run before this gate is ever consulted.
class _UnsupportedTransportGateway extends _RecordingSlashGateway {
  @override
  bool get slashCommandsSupported => false;
}

Future<void> _pumpChat(
  WidgetTester tester, {
  required _RecordingSlashGateway gateway,
  required List<String> submitted,
  String projectName = 'Fixture Project',
  String projectWorkingDirectory = '/srv/project',
  TestDesktopConnectionHook? connectionHook,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChatScreen(
        connection: SavedConnection(
          id: 'slash-new-local',
          label: 'Fixture',
          host: 'fixture.invalid',
          port: 8642,
          apiKey: 'fixture-key',
        ),
        session: Session(
          id: 'slash-new-session',
          title: 'Chat',
          model: 'fixture-model',
          source: 'test',
          messageCount: 0,
          isActive: true,
          preview: '',
          startedAt: 1,
        ),
        projectName: projectName,
        projectWorkingDirectory: projectWorkingDirectory,
        testApiClient: ApiClient(
          baseUrl: 'http://fixture.invalid',
          apiKey: 'fixture-key',
          httpClient: MockClient((_) async => http.Response('{"data":[]}', 200)),
        ),
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
        // Records every ordinary prompt send: a locally handled command must
        // never leak to the model as prose.
        testRemotePromptSubmit: completedStockTurn(
          ({
            required sessionId,
            required text,
            required onEvent,
            required onSent,
          }) async {
            onSent();
            submitted.add(text);
          },
        ),
        testSlashGateway: gateway,
        testDesktopConnectionHook: connectionHook,
      ),
    ),
  );
  await pumpChatUpdates(tester);
}

Future<void> _send(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(_composerKey), text);
  await pumpChatUpdates(tester);
  await tester.tap(find.byKey(_sendKey));
  await pumpChatUpdates(tester);
}

List<ChatScreen> _chatScreens(WidgetTester tester) => tester
    .widgetList<ChatScreen>(find.byType(ChatScreen, skipOffstage: false))
    .toList();

String _composerText(WidgetTester tester) => tester
    .widget<TextField>(find.byKey(_composerKey, skipOffstage: false).first)
    .controller!
    .text;

void main() {
  setUp(mockChatImageRecovery);
  setUp(() => SharedPreferences.setMockInitialValues({'verbose_mode': false}));

  testWidgets('/new opens a fresh draft chat locally, never slash.exec', (
    tester,
  ) async {
    final gateway = _RecordingSlashGateway();
    final submitted = <String>[];
    await _pumpChat(tester, gateway: gateway, submitted: submitted);

    await _send(tester, '/new');

    expect(gateway.executed, isEmpty);
    // Handled locally means handled completely: never resubmitted as prose.
    expect(submitted, isEmpty);
    final screens = _chatScreens(tester);
    expect(screens.length, 2, reason: '/new must open a second chat route');
    final fresh = screens.last.session;
    expect(fresh.isLocalDraft, isTrue);
    expect(fresh.id, isNot('slash-new-session'));
    expect(fresh.model, 'fixture-model');
    expect(fresh.title, 'New Chat');
    // The command line is consumed from the originating composer.
    expect(_composerText(tester), isEmpty);
  });

  testWidgets('/new with a title names the fresh draft', (tester) async {
    final gateway = _RecordingSlashGateway();
    final submitted = <String>[];
    await _pumpChat(tester, gateway: gateway, submitted: submitted);

    await _send(tester, '/new My next chat');

    expect(gateway.executed, isEmpty);
    expect(submitted, isEmpty);
    expect(_chatScreens(tester).last.session.title, 'My next chat');
  });

  testWidgets('/reset is the same local fresh-session command', (
    tester,
  ) async {
    final gateway = _RecordingSlashGateway();
    final submitted = <String>[];
    await _pumpChat(tester, gateway: gateway, submitted: submitted);

    await _send(tester, '/reset');

    expect(gateway.executed, isEmpty);
    expect(submitted, isEmpty);
    expect(_chatScreens(tester).length, 2);
  });

  testWidgets('//new canonicalizes onto the local handler', (tester) async {
    final gateway = _RecordingSlashGateway();
    final submitted = <String>[];
    await _pumpChat(tester, gateway: gateway, submitted: submitted);

    await _send(tester, '//new');

    expect(gateway.executed, isEmpty);
    expect(submitted, isEmpty);
    expect(_chatScreens(tester).length, 2);
  });

  testWidgets('/NEW canonicalizes onto the local handler', (tester) async {
    final gateway = _RecordingSlashGateway();
    final submitted = <String>[];
    await _pumpChat(tester, gateway: gateway, submitted: submitted);

    await _send(tester, '/NEW');

    expect(gateway.executed, isEmpty, reason: '/NEW must not hit slash.exec');
    expect(submitted, isEmpty, reason: '/NEW must not leak as prose');
    expect(
      _chatScreens(tester).length,
      2,
      reason: '/NEW must open a fresh draft route',
    );
  });

  testWidgets('/new with a trailing space canonicalizes onto the local handler', (
    tester,
  ) async {
    final gateway = _RecordingSlashGateway();
    final submitted = <String>[];
    await _pumpChat(tester, gateway: gateway, submitted: submitted);

    await _send(tester, '/new ');

    expect(gateway.executed, isEmpty);
    expect(submitted, isEmpty);
    expect(_chatScreens(tester).length, 2);
  });

  testWidgets('/new is handled locally even on a slash-unsupported transport', (
    tester,
  ) async {
    // The local branch runs BEFORE the gateway-support gate: a REST-only
    // transport must not fall through to submitting '/new' as prose.
    final gateway = _UnsupportedTransportGateway();
    final submitted = <String>[];
    await _pumpChat(tester, gateway: gateway, submitted: submitted);

    await _send(tester, '/new');

    expect(gateway.executed, isEmpty);
    expect(submitted, isEmpty);
    expect(_chatScreens(tester).length, 2);
  });

  testWidgets('the fresh draft inherits the project name and working directory', (
    tester,
  ) async {
    final gateway = _RecordingSlashGateway();
    final submitted = <String>[];
    await _pumpChat(
      tester,
      gateway: gateway,
      submitted: submitted,
      projectName: 'Imagery Ops',
      projectWorkingDirectory: '/srv/imagery',
    );

    await _send(tester, '/new');

    final draft = _chatScreens(tester).last;
    expect(draft.projectName, 'Imagery Ops');
    expect(draft.projectWorkingDirectory, '/srv/imagery');
  });

  testWidgets('the parent keeps its desktop connection hook across a /new pop', (
    tester,
  ) async {
    // The connection/async-event hooks are single-slot holders: forwarding
    // them to the pushed child would let the child's initState steal the
    // parent's handler and its dispose null it, killing any test that
    // drives the parent through the seam across a /new.
    final gateway = _RecordingSlashGateway();
    final submitted = <String>[];
    final hook = TestDesktopConnectionHook();
    await _pumpChat(
      tester,
      gateway: gateway,
      submitted: submitted,
      connectionHook: hook,
    );
    expect(hook.handler, isNotNull, reason: 'parent fills the seam in initState');

    await _send(tester, '/new');
    expect(_chatScreens(tester).length, 2);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await pumpChatUpdates(tester);

    expect(_chatScreens(tester).length, 1);
    expect(
      hook.handler,
      isNotNull,
      reason: 'the child pop must not null the parent\'s connection seam',
    );
    hook.handler!(DesktopConnectionState.reconnecting);
    expect(hook.currentState, DesktopConnectionState.reconnecting);
  });

  testWidgets('gateway-owned commands still run through slash.exec', (
    tester,
  ) async {
    final gateway = _RecordingSlashGateway();
    final submitted = <String>[];
    await _pumpChat(tester, gateway: gateway, submitted: submitted);

    await _send(tester, '/status');

    expect(gateway.executed, ['/status']);
    expect(submitted, isEmpty);
    expect(_chatScreens(tester).length, 1);
  });
}
