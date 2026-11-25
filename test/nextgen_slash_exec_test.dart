// NextGen runs a typed slash command the way Kyllene and Classic do:
// `slash.exec` first, `command.dispatch` only after a definite refusal, the
// answer under the command in the chat. Unknown words and paths still go out
// as prompts. Uses only public NextGen APIs and keys, so the same file runs
// (red) against a build that sends every draft through `prompt.submit`.
import 'dart:async';
import 'dart:convert';

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
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _fieldKey = ValueKey('ng-composer-field');

SavedConnection _connection() => SavedConnection(
  id: 'ng-slash-exec',
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
    ['/undo', 'Take back the last turn'],
    ['/status', 'Show session status'],
    ['/browser', 'Connect a browser'],
    ['/model', 'Switch model'],
    ['/new', 'Start a new chat'],
    ['/stop', 'Stop the running turn'],
  ],
  'canon': {'/bg': '/background', '/reset': '/new'},
  'skills': {
    'review': {'description': 'Review a diff'},
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
  _Gateway(DashboardClient dashboard)
    : super(_connection(), dashboard: dashboard);

  final calls = <_Call>[];
  final handlers = <String, _Handler>{};

  /// The live socket; replacing it is a reconnect.
  WsClient current = WsClient('http://10.0.0.5:9119');

  /// Holds `commands.catalog` until completed (a slow catalogue).
  Completer<void>? catalogGate;

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
    calls.add(_Call(method, Map<String, dynamic>.of(params)));
    final handler = handlers[method];
    if (handler != null) return await handler(params);
    switch (method) {
      case 'commands.catalog':
        final gate = catalogGate;
        if (gate != null) await gate.future;
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

  List<_Call> of(String method) =>
      calls.where((c) => c.method == method).toList();
}

class _Harness {
  _Harness(this.gateway, this.chat, this.historyReads);
  final _Gateway gateway;
  final NgChatController chat;
  final List<Uri> historyReads;
  int newChats = 0;
}

Widget _app(_Harness h, ConnectionManager m) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
  home: NgScope(
    connManager: m,
    gateway: h.gateway,
    connections: [h.gateway.connection],
    switchTo: (_) async {},
    addGateway: () async {},
    signOut: (_) async {},
    reload: () async {},
    signInAgain: () async {},
    child: Scaffold(
      body: NgChatView(
        chat: h.chat,
        onOpenSidebar: () {},
        onNewChat: () => h.newChats++,
      ),
    ),
  ),
);

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byKey(_fieldKey), text);
  await _settle(tester);
}

Future<void> _send(WidgetTester tester, String text) async {
  await _type(tester, text);
  await tester.tap(find.byTooltip('Send'));
  await _settle(tester);
}

String _composer(WidgetTester tester) =>
    tester.widget<TextField>(find.byKey(_fieldKey)).controller!.text;

JsonRpcError _rpc(
  String method,
  String message, {
  int? code,
  String? reason,
  Map<String, dynamic>? data,
}) => JsonRpcError(
  method,
  message,
  code: code,
  reason: reason,
  data: {...?data, 'reason': ?reason},
);

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

  Future<_Harness> pump(
    WidgetTester tester, {
    String? storedId,
    String? runtimeId,
    bool running = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final historyReads = <Uri>[];
    final httpClient = MockClient((request) async {
      if (request.url.path.contains('/messages')) {
        historyReads.add(request.url);
      }
      return http.Response(
        jsonEncode({'messages': const <Object>[]}),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final gateway = _Gateway(
      DashboardClient(host: '10.0.0.5', proxied: true, httpClient: httpClient),
    );
    final chat = NgChatController(gateway, sessionId: storedId)
      ..runtimeId = runtimeId
      ..running = running;
    final h = _Harness(gateway, chat, historyReads);
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    await tester.pumpWidget(_app(h, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    return h;
  }

  testWidgets('/help runs through slash.exec with the exact params, its '
      'output shows under the command and nothing is prompted', (tester) async {
    final h = await pump(tester);
    h.gateway.handlers['slash.exec'] = (params) => {
      'output': 'Available commands:\n  /help  Show help',
    };

    await _send(tester, '/help');

    expect(h.gateway.of('session.create'), hasLength(1));
    final exec = h.gateway.of('slash.exec').single;
    expect(exec.params, {'session_id': 'rt-new', 'command': 'help'});
    expect(h.gateway.of('command.dispatch'), isEmpty);
    expect(h.gateway.of('prompt.submit'), isEmpty);
    expect(find.text('/help'), findsOneWidget);
    expect(find.textContaining('Available commands:'), findsOneWidget);
    expect(_composer(tester), isEmpty);

    await _send(tester, '/title Trip planning');
    expect(h.gateway.of('slash.exec').last.params, {
      'session_id': 'rt-new',
      'command': 'title Trip planning',
    });
    expect(h.gateway.of('session.create'), hasLength(1), reason: 'reused');
    expect(h.gateway.of('prompt.submit'), isEmpty);
  });

  testWidgets('a warning rides with the output', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['slash.exec'] = (params) => {
      'output': 'Title set.',
      'warning': 'The title is not synced to the desktop yet.',
    };
    await _send(tester, '/title Trip');
    expect(h.gateway.of('slash.exec').single.params, {
      'session_id': 'rt-1',
      'command': 'title Trip',
    });
    expect(h.gateway.of('session.create'), isEmpty);
    expect(find.textContaining('Title set.'), findsOneWidget);
    expect(find.textContaining('not synced to the desktop'), findsOneWidget);
  });

  testWidgets('a definite refusal falls back to command.dispatch once', (
    tester,
  ) async {
    final h = await pump(tester);
    h.gateway.handlers['slash.exec'] = (params) => throw _rpc(
      'slash.exec',
      'unsupported_command',
      code: 4001,
      reason: 'unsupported_command',
    );
    h.gateway.handlers['command.dispatch'] = (params) => {
      'type': 'plugin',
      'output': 'Deployed build 42.',
    };

    await _send(tester, '/deploy prod');

    expect(h.gateway.of('slash.exec').single.params, {
      'session_id': 'rt-new',
      'command': 'deploy prod',
    });
    expect(h.gateway.of('command.dispatch').single.params, {
      'session_id': 'rt-new',
      'name': 'deploy',
      'arg': 'prod',
    });
    expect(find.textContaining('Deployed build 42.'), findsOneWidget);
    expect(h.gateway.of('prompt.submit'), isEmpty);
    expect(_composer(tester), isEmpty);
  });

  testWidgets('a refusal from both stages keeps the draft and shows the '
      "gateway's reason; nothing is prompted", (tester) async {
    final h = await pump(tester);
    h.gateway.handlers['slash.exec'] = (params) => throw _rpc(
      'slash.exec',
      'unsupported_command',
      code: 4001,
      reason: 'unsupported_command',
      data: {'detail': '/browser needs the desktop app'},
    );
    h.gateway.handlers['command.dispatch'] = (params) => throw _rpc(
      'command.dispatch',
      'not a quick/plugin/bundle/skill command: browser',
      code: 4018,
    );

    await _send(tester, '/browser connect');

    expect(h.gateway.of('command.dispatch'), hasLength(1));
    expect(h.gateway.of('prompt.submit'), isEmpty);
    expect(find.text('/browser needs the desktop app'), findsOneWidget);
    expect(_composer(tester), '/browser connect');
  });

  testWidgets('a skill comes back as a prompt that shows its display line, '
      'never the model-facing message', (tester) async {
    final h = await pump(tester);
    const body = '[SKILL BODY] You are reviewing a diff. Follow these steps…';
    h.gateway.handlers['slash.exec'] = (params) => throw _rpc(
      'slash.exec',
      'skill command: use command.dispatch for /review',
      code: 4018,
    );
    h.gateway.handlers['command.dispatch'] = (params) => {
      'type': 'skill',
      'name': 'review',
      'message': body,
      'display': '/review the auth diff',
    };

    await _send(tester, '/review the auth diff');

    expect(h.gateway.of('command.dispatch').single.params, {
      'session_id': 'rt-new',
      'name': 'review',
      'arg': 'the auth diff',
    });
    final submit = h.gateway.of('prompt.submit').single;
    expect(submit.params['text'], body);
    expect(submit.params['session_id'], 'rt-new');
    expect(find.text('/review the auth diff'), findsOneWidget);
    expect(find.textContaining('[SKILL BODY]'), findsNothing);
    expect(_composer(tester), isEmpty);
  });

  testWidgets('a send directive from slash.exec shows its notice and is '
      'prompted once', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['slash.exec'] = (params) => {
      'type': 'send',
      'message': 'Plan the trip step by step.',
      'notice': 'Plan mode is on.',
    };
    await _send(tester, '/status plan');
    expect(h.gateway.of('prompt.submit'), hasLength(1));
    expect(
      h.gateway.of('prompt.submit').single.params['text'],
      'Plan the trip step by step.',
    );
    expect(find.text('Plan mode is on.'), findsOneWidget);
    expect(find.text('/status plan'), findsWidgets);
    expect(find.text('Plan the trip step by step.'), findsNothing);
    expect(h.gateway.of('command.dispatch'), isEmpty);
  });

  testWidgets('a prefill puts the text back in the composer and reads the '
      'transcript again', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['slash.exec'] = (params) => {
      'type': 'prefill',
      'message': 'my last prompt',
    };
    final readsBefore = h.historyReads.length;

    await _send(tester, '/undo');

    expect(_composer(tester), 'my last prompt');
    expect(h.historyReads.length, greaterThan(readsBefore));
    expect(h.gateway.of('prompt.submit'), isEmpty);
    expect(h.gateway.of('command.dispatch'), isEmpty);
  });

  testWidgets('an alias reply runs its target once, never in a loop', (
    tester,
  ) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['slash.exec'] = (params) =>
        params['command'] == 'bg run tests'
        ? {'type': 'alias', 'target': '/background'}
        : {'type': 'alias', 'target': '/bg'};

    await _send(tester, '/bg run tests');

    expect(h.gateway.of('slash.exec').map((c) => c.params['command']), [
      'bg run tests',
      'background run tests',
    ]);
    expect(h.gateway.of('prompt.submit'), isEmpty);
  });

  testWidgets('an alias to a command that answers shows that answer', (
    tester,
  ) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['slash.exec'] = (params) =>
        params['command'] == 'deploy now'
        ? {'type': 'alias', 'target': 'status --brief'}
        : {'output': 'Session rt-1 is idle.'};
    await _send(tester, '/deploy now');
    expect(h.gateway.of('slash.exec').map((c) => c.params['command']), [
      'deploy now',
      'status --brief now',
    ]);
    expect(find.text('Session rt-1 is idle.'), findsOneWidget);
  });

  testWidgets('/new, /reset, /stop and /model stay in the app', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');

    await _send(tester, '/new');
    expect(h.newChats, 1);
    await _send(tester, '/reset');
    expect(h.newChats, 2);
    expect(_composer(tester), isEmpty);

    h.chat.running = true;
    await _send(tester, '/stop');
    expect(h.gateway.of('session.interrupt').single.params, {
      'session_id': 'rt-1',
    });
    expect(find.text('Hermes is still working'), findsNothing);
    h.chat.running = false;

    await _send(tester, '/stop');
    expect(h.gateway.of('session.interrupt'), hasLength(1), reason: 'idle');
    expect(find.text('Nothing is running.'), findsOneWidget);
    // Clear the toast so it does not cover the composer.
    ScaffoldMessenger.of(
      tester.element(find.byKey(_fieldKey)),
    ).removeCurrentSnackBar();
    await _settle(tester);

    await _send(tester, '/model');
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      find.byKey(const ValueKey('ng-model-sheet-management')),
      findsOneWidget,
    );

    expect(h.gateway.of('slash.exec'), isEmpty);
    expect(h.gateway.of('command.dispatch'), isEmpty);
    expect(h.gateway.of('prompt.submit'), isEmpty);
  });

  testWidgets('unknown words and paths go out as prompts, unchanged', (
    tester,
  ) async {
    final h = await pump(tester);
    for (final text in [
      '/foo bar',
      '/Users/sam/notes.txt summarise this',
      'please run /help',
    ]) {
      await _send(tester, text);
      // The fake turn never ends; the next draft is a new prompt, not a steer.
      h.chat.running = false;
    }

    expect(h.gateway.of('slash.exec'), isEmpty);
    expect(h.gateway.of('command.dispatch'), isEmpty);
    expect(h.gateway.of('prompt.submit').map((c) => c.params['text']), [
      '/foo bar',
      '/Users/sam/notes.txt summarise this',
      'please run /help',
    ]);
  });

  for (final (label, error) in [
    ('a timeout', _rpc('slash.exec', 'Timeout')),
    (
      'a dropped socket',
      _rpc('slash.exec', 'Connection closed', reason: 'connection_closed'),
    ),
  ]) {
    testWidgets('$label is never dispatched or resent; the draft comes back', (
      tester,
    ) async {
      final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
      h.gateway.handlers['slash.exec'] = (params) => throw error;

      await _send(tester, '/help');

      expect(h.gateway.of('slash.exec'), hasLength(1));
      expect(h.gateway.of('command.dispatch'), isEmpty);
      expect(h.gateway.of('prompt.submit'), isEmpty);
      expect(find.textContaining('may still be running'), findsOneWidget);
      expect(_composer(tester), '/help');
    });
  }

  testWidgets('a gateway error that is not a refusal shows, without a '
      'fallback', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['slash.exec'] = (params) =>
        throw _rpc('slash.exec', 'slash worker start failed', code: 5030);
    await _send(tester, '/help');
    expect(h.gateway.of('command.dispatch'), isEmpty);
    expect(h.gateway.of('prompt.submit'), isEmpty);
    expect(
      find.text("Couldn't run the command: slash worker start failed"),
      findsOneWidget,
    );
    expect(_composer(tester), '/help');
  });

  testWidgets('a gateway without slash.exec gets the line as a prompt, and '
      'the connection remembers it until it reconnects', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['slash.exec'] = (params) =>
        throw _rpc('slash.exec', 'unknown method: slash.exec', code: -32601);

    await _send(tester, '/help');
    expect(h.gateway.of('slash.exec'), hasLength(1));
    expect(h.gateway.of('command.dispatch'), isEmpty);
    expect(h.gateway.of('prompt.submit').map((c) => c.params['text']), [
      '/help',
    ]);
    expect(_composer(tester), isEmpty);

    h.chat.running = false;
    await _send(tester, '/status');
    expect(h.gateway.of('slash.exec'), hasLength(1), reason: 'remembered');
    expect(h.gateway.of('prompt.submit').last.params['text'], '/status');

    // A new socket may be an upgraded gateway: ask again.
    h.chat.running = false;
    h.gateway.current = WsClient('http://10.0.0.5:9119');
    await _send(tester, '/help');
    expect(h.gateway.of('slash.exec'), hasLength(2));
  });

  testWidgets('a command during a running turn still goes to the gateway, '
      'which answers or refuses it', (tester) async {
    final h = await pump(
      tester,
      storedId: 'stored-1',
      runtimeId: 'rt-1',
      running: true,
    );
    h.gateway.handlers['slash.exec'] = (params) => params['command'] == 'status'
        ? {'output': 'Working: 3 tool calls so far.'}
        : throw _rpc(
            'slash.exec',
            'session is busy',
            code: 4009,
            reason: 'session_busy',
          );

    await _send(tester, '/status');
    expect(find.text('Hermes is still working'), findsNothing);
    expect(h.gateway.of('slash.exec').single.params, {
      'session_id': 'rt-1',
      'command': 'status',
    });
    expect(find.text('Working: 3 tool calls so far.'), findsOneWidget);

    await _send(tester, '/title Later');
    expect(h.gateway.of('slash.exec'), hasLength(2));
    expect(h.gateway.of('command.dispatch'), isEmpty);
    expect(h.gateway.of('session.steer'), isEmpty);
    expect(h.gateway.of('prompt.submit'), isEmpty);
    expect(
      find.text("Couldn't run the command: session is busy"),
      findsOneWidget,
    );
    expect(_composer(tester), '/title Later');
    expect(h.chat.running, isTrue);
  });

  testWidgets('a skill run mid-turn waits in the queue, showing its display '
      'line', (tester) async {
    final h = await pump(
      tester,
      storedId: 'stored-1',
      runtimeId: 'rt-1',
      running: true,
    );
    h.gateway.handlers['slash.exec'] = (params) => {
      'type': 'skill',
      'message': '[SKILL BODY] review',
      'display': '/review now',
    };
    await _send(tester, '/review now');
    expect(h.gateway.of('prompt.submit'), isEmpty);
    expect(h.chat.queued.single.text, '[SKILL BODY] review');
    expect(find.text('/review now'), findsOneWidget);
    expect(find.textContaining('[SKILL BODY]'), findsNothing);
  });

  testWidgets('plugin commands, skills and aliases from the scoped catalogue '
      'run on the gateway', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['slash.exec'] = (params) => {'output': 'ok'};
    await _send(tester, '/deploy');
    await _send(tester, '/bg tidy up');
    await _send(tester, '/review');
    expect(h.gateway.of('slash.exec').map((c) => c.params['command']), [
      'deploy',
      'bg tidy up',
      'review',
    ]);
    expect(h.gateway.of('commands.catalog').first.params, {
      'session_id': 'rt-1',
    });
    expect(h.gateway.of('prompt.submit'), isEmpty);
  });

  testWidgets('before the catalogue loads, a send waits briefly and then '
      "uses Classic's fallback set", (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.catalogGate = Completer<void>();
    h.gateway.handlers['slash.exec'] = (params) => {'output': 'Help text'};

    await _send(tester, '/help');
    await tester.pump(const Duration(milliseconds: 1500));
    expect(h.gateway.of('slash.exec'), isEmpty, reason: 'still waiting');
    await tester.pump(const Duration(milliseconds: 600));
    await _settle(tester);
    expect(h.gateway.of('slash.exec').single.params['command'], 'help');
    expect(h.gateway.of('prompt.submit'), isEmpty);

    await _send(tester, '/frobnicate now');
    await tester.pump(const Duration(seconds: 3));
    await _settle(tester);
    expect(
      h.gateway.of('prompt.submit').single.params['text'],
      '/frobnicate now',
    );
    h.gateway.catalogGate!.complete();
    await _settle(tester);
  });

  testWidgets('a second tap while a command is being decided runs it once', (
    tester,
  ) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.catalogGate = Completer<void>();
    h.gateway.handlers['slash.exec'] = (params) => {'output': 'Help text'};
    await _type(tester, '/help');
    await tester.tap(find.byTooltip('Send'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byTooltip('Send'));
    await tester.pump(const Duration(seconds: 3));
    await _settle(tester);
    expect(h.gateway.of('slash.exec'), hasLength(1));
    h.gateway.catalogGate!.complete();
    await _settle(tester);
  });
}
