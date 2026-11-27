// Regression tests from the independent review of v5/composer at 7d750d1d
// (probes NG1-NG6), NextGen layout. Each failed at 7d750d1d:
//   NG1 /btw answer (btw.complete) never reached the chat
//   NG2 /background result (background.complete) never reached the chat
//   NG3 Retry after an accepted turn sent a second plain prompt.submit
//   NG4 picking a complete.slash argument replaced the whole command
//   NG6 the context breakdown pushed the composer under the keyboard
// NG5 (a pasted device directory stays text) passed and stays as a guard.
// Drop and paste intake (files from the OS, the clipboard or a keyboard)
// is covered at the end.
// Uses only public NextGen APIs and keys.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/os_intake.dart';
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
import 'package:image/image.dart' as image_lib;
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
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

class _Paths extends PathProviderPlatform {
  _Paths(this.dir);
  final Directory dir;
  @override
  Future<String?> getTemporaryPath() async => dir.path;
}

/// Lets real file I/O and image work (fake-async tests do not run it)
/// finish and render without moving the clock. Stops a few quiet rounds
/// after [done] holds.
Future<void> _drain(WidgetTester tester, {bool Function()? done}) async {
  var quiet = 0;
  for (var i = 0; i < 400 && quiet < 4; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
    if (done == null ? i >= 12 : done()) quiet++;
  }
}

List<String> _chips() => [
  for (final chip in find.byType(InputChip).evaluate())
    ((((chip.widget as InputChip).label as ConstrainedBox).child!) as Text)
        .data!,
];

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
    double textScale = 1.0,
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
    if (textScale != 1.0) {
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    }
    await tester.pumpWidget(_app(h, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    return h;
  }

  StreamEvent ev(String type, Map<String, dynamic> data) =>
      StreamEvent(type: type, data: data, sessionId: 'rt-1');

  testWidgets('PROBE NG1 /btw: prompt.btw is sent and its btw.complete answer '
      'reaches the chat', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['prompt.btw'] = (p) => {'task_id': 'btw_abc123'};
    await _send(tester, '/btw what changed?');
    expect(h.gateway.of('prompt.btw').single.params, {
      'session_id': 'rt-1',
      'text': 'what changed?',
    });
    expect(h.gateway.of('prompt.submit'), isEmpty);
    expect(find.textContaining('btw_abc123'), findsOneWidget);
    h.gateway.debugEmit(
      ev('btw.complete', {
        'task_id': 'btw_abc123',
        'question': 'what changed?',
        'text': 'SIDE-ANSWER-42',
      }),
    );
    await _settle(tester);
    expect(
      find.textContaining('SIDE-ANSWER-42'),
      findsOneWidget,
      reason: 'the side-question answer arrives only as btw.complete',
    );
  });

  testWidgets('/btw on a new chat creates its session first and a replayed '
      'answer shows once', (tester) async {
    final h = await pump(tester);
    h.gateway.handlers['prompt.btw'] = (p) => {'task_id': 'btw_new'};
    await _send(tester, '/btw anything new?');
    final methods = h.gateway.calls.map((c) => c.method).toList();
    expect(methods, contains('session.create'));
    expect(
      methods.indexOf('session.create'),
      lessThan(methods.indexOf('prompt.btw')),
    );
    expect(h.gateway.of('prompt.btw').single.params['session_id'], 'rt-new');
    final answer = StreamEvent(
      type: 'btw.complete',
      data: const {'task_id': 'btw_new', 'text': 'ONCE-ONLY'},
      sessionId: 'rt-new',
    );
    h.gateway.debugEmit(answer);
    h.gateway.debugEmit(answer);
    await _settle(tester);
    expect(find.textContaining('ONCE-ONLY'), findsOneWidget);
    expect(_composer(tester), isEmpty);
  });

  testWidgets('PROBE NG2 /background: background.complete result reaches the '
      'chat', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['prompt.background'] = (p) => {'task_id': 'bg_77'};
    await _send(tester, '/background summarise the repo');
    expect(h.gateway.of('prompt.background').single.params, {
      'session_id': 'rt-1',
      'text': 'summarise the repo',
    });
    h.gateway.debugEmit(
      ev('background.complete', {'task_id': 'bg_77', 'text': 'BG-RESULT-77'}),
    );
    await _settle(tester);
    expect(
      find.textContaining('BG-RESULT-77'),
      findsOneWidget,
      reason: 'the notice promises "The result will appear here"',
    );
  });

  // An older gateway without prompt.background: Desktop's slash.ts falls
  // back to slash.exec when the method is missing (isMissingRpcMethod).
  for (final (label, error) in [
    (
      '-32601',
      JsonRpcError('prompt.background', 'unknown method', code: -32601),
    ),
    (
      '4004 unknown method',
      JsonRpcError(
        'prompt.background',
        'unknown method: prompt.background',
        code: 4004,
      ),
    ),
  ]) {
    testWidgets('/background on a gateway without prompt.background ($label) '
        'runs through slash.exec', (tester) async {
      final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
      h.gateway.handlers['prompt.background'] = (p) => throw error;
      h.gateway.handlers['slash.exec'] = (p) => {'output': 'BG-EXEC-OK'};
      await _send(tester, '/background summarise the repo');
      await _settle(tester);
      expect(h.gateway.of('prompt.background'), hasLength(1));
      final exec = h.gateway.of('slash.exec');
      expect(exec, hasLength(1), reason: 'no slash.exec fallback');
      expect(exec.single.params['command'], 'background summarise the repo');
      expect(h.gateway.of('prompt.submit'), isEmpty);
    });
  }

  testWidgets('/background whose prompt.background really fails (4004 bad '
      'input) is reported, never re-run through slash.exec', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['prompt.background'] = (p) =>
        throw JsonRpcError('prompt.background', 'text is required', code: 4004);
    await _send(tester, '/background summarise the repo');
    await _settle(tester);
    expect(h.gateway.of('slash.exec'), isEmpty);
    expect(h.gateway.of('prompt.submit'), isEmpty);
    expect(find.textContaining('text is required'), findsWidgets);
  });

  testWidgets('PROBE NG3 Retry on the failure card after the gateway accepted '
      'the turn does not submit the prompt a second time', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    await _send(tester, 'hello there');
    expect(h.gateway.of('prompt.submit'), hasLength(1));
    h.gateway.debugEmit(ev('message.start', {}));
    h.gateway.debugEmit(ev('error', {'message': 'Provider timed out'}));
    await _settle(tester);
    expect(find.text('Retry'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await _settle(tester);
    final submits = h.gateway.of('prompt.submit');
    // ignore: avoid_print
    print('NG3 prompt.submit params: ${submits.map((s) => s.params).toList()}');
    expect(
      submits.length == 1 ||
          submits.last.params.keys.any((k) => k.startsWith('truncate_before')),
      isTrue,
      reason:
          'Desktop Retry regenerates the failed turn (prompt.submit with '
          'truncate_before_* + confirm_truncate); a plain second submit '
          'duplicates the accepted user turn',
    );
  });

  testWidgets('Retry of an accepted turn regenerates it in place with its '
      'durable row', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['session.history'] = (p) => {
      'messages': [
        {'role': 'user', 'text': 'older', 'row_id': 3},
        {'role': 'assistant', 'text': 'reply', 'row_id': 4},
        {'role': 'user', 'text': 'hello there', 'row_id': 7},
      ],
    };
    await _send(tester, 'hello there');
    h.gateway.debugEmit(ev('message.start', {}));
    h.gateway.debugEmit(ev('error', {'message': 'Provider timed out'}));
    await _settle(tester);
    await _type(tester, 'a newer draft');
    await tester.tap(find.text('Retry'));
    await _settle(tester);
    final submits = h.gateway.of('prompt.submit');
    expect(submits, hasLength(2));
    final regenerate = submits.last.params;
    expect(regenerate['text'], 'hello there');
    expect(regenerate['confirm_truncate'], isTrue);
    expect(regenerate['truncate_before_row_id'], 7);
    expect(
      regenerate['submission_id'],
      isNot(submits.first.params['submission_id']),
    );
    expect(_composer(tester), 'a newer draft');
    expect(find.text('hello there'), findsOneWidget);
  });

  testWidgets('Retry without a durable row sends nothing and never replaces '
      'a newer draft', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['session.history'] = (p) => {
      'messages': [
        {'role': 'user', 'text': 'something else', 'row_id': 2},
      ],
    };
    await _send(tester, 'hello there');
    h.gateway.debugEmit(ev('message.start', {}));
    h.gateway.debugEmit(ev('error', {'message': 'Provider timed out'}));
    await _settle(tester);
    await _type(tester, 'keep me');
    await tester.tap(find.text('Retry'));
    await _settle(tester);
    expect(h.gateway.of('prompt.submit'), hasLength(1));
    expect(_composer(tester), 'keep me');
  });

  testWidgets('PROBE NG4 accepting a complete.slash argument keeps the command '
      '(replace_from)', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['complete.slash'] = (p) => {
      'items': [
        {'text': 'friendly', 'display': 'friendly', 'meta': 'tone'},
      ],
      'replace_from': 13,
    };
    await _type(tester, '/personality fr');
    expect(
      h.gateway.of('complete.slash').last.params['text'],
      '/personality fr',
    );
    expect(find.text('friendly'), findsWidgets);
    await tester.tap(find.text('friendly').first);
    await _settle(tester);
    expect(_composer(tester), '/personality friendly');
    expect(tester.takeException(), isNull, reason: 'ListTile needs Material');
  });

  testWidgets('argument rows are cached per prefix: typing back over a '
      'prefix does not ask again', (tester) async {
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['complete.slash'] = (p) => {
      'items': [
        {'text': 'friendly'},
      ],
      'replace_from': 13,
    };
    await _type(tester, '/personality f');
    await _type(tester, '/personality fr');
    await _type(tester, '/personality f');
    expect(h.gateway.of('complete.slash').map((c) => c.params['text']), [
      '/personality f',
      '/personality fr',
    ]);
  });

  testWidgets('PROBE NG5 pasting a device directory path is not rewritten into '
      'a gateway @folder: reference', (tester) async {
    await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    final dir = Directory.systemTemp.path;
    expect(Directory(dir).existsSync(), isTrue);
    await _type(tester, 'see ');
    await _type(tester, 'see $dir');
    // ignore: avoid_print
    print('NG5 composer after paste: ${_composer(tester)}');
    expect(_composer(tester), isNot(contains('@folder:')));
  });

  for (final breakdownOn in [false, true]) {
    testWidgets('PROBE NG6 320x640 x2.0 with IME, busy turn, context breakdown '
        '${breakdownOn ? 'on' : 'off'}: editor >=80 px wide, above the '
        'keyboard, no overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final h = await pump(
        tester,
        storedId: 'stored-1',
        runtimeId: 'rt-1',
        textScale: 2.0,
      );
      h.gateway.handlers['session.context_breakdown'] = (p) => {
        'categories': [
          for (var i = 0; i < 8; i++)
            {
              'id': 'c$i',
              'label': 'Category $i',
              'tokens': 1000 * (i + 1),
              'color': '#888888',
            },
        ],
        'context_max': 200000,
        'context_used': 36000,
        'context_percent': 18,
        'estimated_total': 36000,
        'context_estimated': false,
        'context_source': 'provider_usage',
        'model': 'm',
      };
      // A narrow pane keeps no always-visible Status control: it lives in
      // the composer menu.
      expect(find.byKey(const ValueKey('composer-status-menu')), findsNothing);
      if (breakdownOn) {
        await tester.tap(find.byTooltip('Attach'));
        await _settle(tester);
        final status = find.byKey(const ValueKey('ng-composer-status'));
        await tester.ensureVisible(status);
        await _settle(tester);
        await tester.tap(status);
        await _settle(tester);
        final context = find.byKey(
          const ValueKey('composer-status-context-usage'),
        );
        await tester.ensureVisible(context);
        await _settle(tester);
        await tester.tap(context);
        await _settle(tester);
        await tester.tapAt(const Offset(5, 5));
        await _settle(tester);
        expect(h.gateway.of('session.context_breakdown'), isNotEmpty);
        // Folded by default here; opening it must still fit.
        await tester.tap(
          find.byKey(const ValueKey('composer-context-breakdown-toggle')),
        );
        await _settle(tester);
        expect(
          find.byKey(const ValueKey('composer-context-breakdown')),
          findsOneWidget,
        );
      }
      h.chat.running = true;
      h.chat.turnStartedAt = DateTime.now();
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await _type(tester, 'steer this please');
      final errors = <Object>[];
      Object? e;
      while ((e = tester.takeException()) != null) {
        errors.add(e!);
      }
      final field = tester.getRect(find.byKey(_fieldKey));
      // ignore: avoid_print
      print(
        'NG6 breakdown=$breakdownOn field=$field errors=${errors.length} '
        '${errors.isEmpty ? '' : errors.first.toString().split('\n').first}',
      );
      expect(errors, isEmpty);
      expect(field.width, greaterThanOrEqualTo(80));
      expect(field.bottom, lessThanOrEqualTo(640 - 260));
      expect(field.top, greaterThanOrEqualTo(0));
    });
  }

  testWidgets('the status layout choice is kept across chats and the '
      'breakdown refreshes after each turn', (tester) async {
    tester.view.physicalSize = const Size(1000, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
    h.gateway.handlers['session.context_breakdown'] = (p) => {
      'categories': [
        {'id': 'c', 'label': 'System', 'tokens': 10},
      ],
      'context_max': 1000,
      'context_used': 10,
    };
    // Status lives in the composer menu: no extra row by default. The
    // session timer, which the gateway does not report here, is not offered.
    expect(find.byKey(const ValueKey('composer-context-status')), findsNothing);
    await tester.tap(find.byTooltip('Attach'));
    await _settle(tester);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const ValueKey('ng-composer-status')));
    await _settle(tester);
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.byKey(const ValueKey('composer-status-session-timer')),
      findsNothing,
    );
    await tester.tap(
      find.byKey(const ValueKey('composer-status-context-usage')),
    );
    await _settle(tester);
    await tester.tapAt(const Offset(5, 5));
    await _settle(tester);
    // A wide pane shows the breakdown open.
    expect(
      find.byKey(const ValueKey('composer-context-breakdown')),
      findsOneWidget,
    );
    final reads = h.gateway.of('session.context_breakdown').length;
    expect(reads, greaterThan(0));
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getStringList('composer_status_hidden_v1'),
      isNot(contains('context-usage')),
    );
    h.gateway.debugEmit(ev('message.start', {}));
    await _settle(tester);
    h.gateway.debugEmit(ev('message.complete', {'text': 'done'}));
    await _settle(tester);
    expect(
      h.gateway.of('session.context_breakdown').length,
      greaterThan(reads),
    );
  });

  group('drop and paste intake', () {
    late Directory root;
    late File notes, shot;
    late Directory folder;
    late Uint8List png;
    late PathProviderPlatform previousPaths;

    setUp(() {
      root = Directory.systemTemp.createTempSync('ng-intake');
      notes = File('${root.path}/notes.txt')..writeAsStringSync('hello notes');
      png = image_lib.encodePng(image_lib.Image(width: 2, height: 2));
      shot = File('${root.path}/shot.png')..writeAsBytesSync(png);
      folder = Directory('${root.path}/folder')..createSync();
      previousPaths = PathProviderPlatform.instance;
      PathProviderPlatform.instance = _Paths(root);
      String? clipboard;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData') {
              clipboard = (call.arguments as Map)['text'] as String;
            }
            if (call.method == 'Clipboard.getData') {
              return {'text': clipboard};
            }
            if (call.method == 'Clipboard.hasStrings') {
              return {'value': clipboard?.isNotEmpty == true};
            }
            return null;
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
      PathProviderPlatform.instance = previousPaths;
      debugClipboardAttachmentReader = null;
      root.deleteSync(recursive: true);
    });

    List<FileSystemEntity> staged() {
      final dir = Directory('${root.path}/composer-paste');
      return dir.existsSync() ? dir.listSync() : const [];
    }

    testWidgets('files dropped from the OS become drafts and are never '
        'sent; a folder is refused', (tester) async {
      final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
      await _type(tester, 'my words');
      tester.widget<OsFileDropTarget>(find.byType(OsFileDropTarget)).onFiles([
        OsIntakeFile(notes.path),
        OsIntakeFile(shot.path),
        OsIntakeFile(folder.path, directory: true),
      ]);
      await _drain(
        tester,
        done: () => find
            .text("Folders can't be attached. Drop the files instead.")
            .evaluate()
            .isNotEmpty,
      );
      expect(_chips(), ['notes.txt', 'shot.png']);
      expect(
        find.text("Folders can't be attached. Drop the files instead."),
        findsOneWidget,
      );
      expect(h.gateway.of('prompt.submit'), isEmpty);
      expect(_composer(tester), 'my words');
    });

    testWidgets('Cmd/Ctrl+V with an image on the clipboard adds an image '
        'draft; plain text still pastes as text', (tester) async {
      debugClipboardAttachmentReader = () async =>
          ClipboardAttachment(image: png);
      final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
      await tester.tap(find.byKey(_fieldKey));
      await tester.pump();
      Future<void> paste() async {
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        await tester.pump();
      }

      await paste();
      await _drain(tester, done: () => _chips().isNotEmpty);
      expect(_chips(), hasLength(1));
      expect(_chips().single, endsWith('.png'));
      expect(_composer(tester), isEmpty);
      // The staged clipboard image is gone; the draft has its own copy.
      expect(staged(), isEmpty);

      debugClipboardAttachmentReader = () async => null;
      await Clipboard.setData(const ClipboardData(text: 'plain words'));
      await paste();
      await _drain(tester, done: () => _composer(tester) == 'plain words');
      expect(_composer(tester), 'plain words');
      expect(_chips(), hasLength(1));
      expect(h.gateway.of('prompt.submit'), isEmpty);
    });

    testWidgets('a keyboard-inserted image becomes a draft', (tester) async {
      final h = await pump(tester, storedId: 'stored-1', runtimeId: 'rt-1');
      final field = tester.widget<TextField>(find.byKey(_fieldKey));
      expect(
        field.contentInsertionConfiguration?.allowedMimeTypes,
        contains('image/png'),
      );
      field.contentInsertionConfiguration!.onContentInserted(
        KeyboardInsertedContent(
          mimeType: 'image/png',
          uri: 'content://keyboard/sticker.png',
          data: png,
        ),
      );
      await _drain(tester, done: () => _chips().isNotEmpty);
      expect(_chips(), hasLength(1));
      expect(staged(), isEmpty);
      expect(h.gateway.of('prompt.submit'), isEmpty);
    });
  });
}
