// Classic failure card over a real loopback Desktop gateway (WebSocket
// JSON-RPC): the card appears for real turn failures on every reachable
// Classic path, and "Switch to <model>" switches this chat's model, then
// sends exactly ONE retry through the regenerate plumbing NextGen and Desktop
// use (prompt.submit with confirm_truncate and the durable row). Cancelling
// sends nothing; leaving the chat mid-switch sends nothing. Where no retry is
// possible the card says so before the switch.
//   CS0 legacy stored chat (stock owner): a detached error frame raises the
//       card, over the socket and through the async hook alike.
//   CS1 recovery-v2 and legacy: Switch to = config.set once, then one
//       regenerate prompt.submit; a newer draft stays.
//   CS2 cancelling the confirm switches nothing, sends nothing.
//   CS3 leaving the chat while config.set is in flight: nothing goes out.
//   Live stock turn: a turn.error for the live turn raises the card once the
//       turn settles, and Switch to replaces that turn.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/os_intake.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/attachment_draft_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/gateway_turn_coordinator.dart';
import 'package:hermes_android/core/services/gateway_turn_recovery.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/widgets/attachment_draft_tile.dart';
import 'package:hermes_android/core/widgets/failure_recovery_card.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _composerKey = Key('chat-message-composer');

class _Server {
  _Server(this.server);
  final HttpServer server;
  final sockets = <WebSocket>[];
  final frames = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> history = [];
  List<Map<String, dynamic>> rows = [
    {'id': 1, 'role': 'user', 'content': 'hello there'},
    {'id': 2, 'role': 'assistant', 'content': ''},
  ];
  Completer<void>? configGate;

  /// Methods this gateway answers with a JSON-RPC error (an older gateway).
  final errors = <String, Map<String, dynamic>>{};
  bool _closed = false;

  SavedConnection get connection => SavedConnection(
    id: 'switch-retry-${server.port}',
    label: 'Fixture',
    host: '127.0.0.1',
    port: server.port,
    apiKey: 'fixture',
    dashboardPortOverride: server.port,
    dashboardProxied: true,
  );

  static Future<_Server> start() async {
    final s = _Server(await HttpServer.bind(InternetAddress.loopbackIPv4, 0));
    s.server.listen(s.handle);
    return s;
  }

  List<Map<String, dynamic>> of(String method) =>
      frames.where((f) => f['method'] == method).toList();

  Future<void> handle(HttpRequest request) async {
    if (request.uri.path == '/api/auth/ws-ticket') {
      request.response.headers.contentType = ContentType.json;
      request.response.write('{"ticket":"fixture"}');
      await request.response.close();
      return;
    }
    if (request.uri.path != '/api/ws') {
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode({
          'data': request.uri.path.endsWith('/messages') ? rows : const [],
        }),
      );
      await request.response.close();
      return;
    }
    final socket = await WebSocketTransformer.upgrade(request);
    sockets.add(socket);
    socket.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'method': 'event',
        'params': {'type': 'gateway.ready', 'payload': {}},
      }),
    );
    socket.listen((raw) async {
      if (_closed) return;
      final frame = Map<String, dynamic>.from(jsonDecode(raw as String) as Map);
      final method = frame['method'];
      if (method == null) return;
      frames.add(frame);
      final result = <String, dynamic>{'jsonrpc': '2.0', 'id': frame['id']};
      if (errors[method] case final error?) {
        result['error'] = error;
        if (!_closed && socket.readyState == WebSocket.open) {
          socket.add(jsonEncode(result));
        }
        return;
      }
      switch (method) {
        case 'session.resume':
          result['result'] = {
            'session_id': 'runtime-${frame['params']['session_id']}',
            'stored_session_id': frame['params']['session_id'],
            'running': false,
            'status': 'idle',
          };
        case 'config.get':
          result['result'] = {'config': <String, dynamic>{}};
        case 'config.set':
          final gate = configGate;
          if (gate != null) await gate.future;
          result['result'] = <String, dynamic>{};
        case 'session.history':
          result['result'] = {'messages': history};
        case 'file.attach':
          result['result'] = {
            'attached': true,
            'ref_text': '@file:/up/${frame['params']['name']}',
          };
        case 'commands.catalog':
          result['result'] = {
            'pairs': [
              ['/background', 'Run a prompt in the background'],
            ],
            'canon': {'/bg': '/background'},
          };
        case 'slash.exec':
          result['result'] = {'output': 'Background task started.'};
        default:
          result['result'] = {'ok': true};
      }
      if (!_closed && socket.readyState == WebSocket.open) {
        socket.add(jsonEncode(result));
      }
    });
  }

  void event(
    String type,
    Map<String, dynamic> payload,
    String sessionId, {
    String? turnId,
  }) {
    sockets.last.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'method': 'event',
        'params': {
          'type': type,
          'session_id': sessionId,
          'turn_id': ?turnId,
          'payload': payload,
        },
      }),
    );
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    for (final s in sockets) {
      await s.close();
    }
    await server.close(force: true);
  }
}

class _Paths extends PathProviderPlatform {
  _Paths(this.dir);
  final Directory dir;
  @override
  Future<String?> getTemporaryPath() async => dir.path;
}

class _Picker extends FilePicker {
  _Picker(this.files, {this.gate});
  final List<PlatformFile> files;
  final Completer<void>? gate;
  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    if (gate != null) await gate!.future;
    return FilePickerResult(files);
  }
}

int _tiles() => find.byType(AttachmentDraftTile).evaluate().length;

Session _session(String id) => Session(
  id: id,
  title: 'Chat $id',
  model: 'fixture',
  source: 'desktop',
  messageCount: 2,
  isActive: true,
  preview: '',
  startedAt: 1,
);

Future<void> _pump(WidgetTester tester, {int rounds = 20}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 20));
  }
}

Future<void> _until(WidgetTester tester, bool Function() condition) async {
  for (var i = 0; i < 300 && !condition(); i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 20));
  }
}

Map<String, dynamic> _usageLimit() => {
  'message': 'Usage limit reached',
  'surface': {
    'layer': 'provider',
    'code': 'usage_window',
    'message': 'Usage limit reached',
    'usage_limit': {
      'suggestions': [
        {'model': 'gpt-5-mini', 'label': 'GPT-5 mini', 'provider': 'openai'},
      ],
    },
  },
};

/// A recovery-v2 application session whose async error frames reach the
/// failure card through the test hook. Its own submit is never the retry.
class _V2Session implements GatewayTurnApplicationSession {
  int submitCount = 0;
  @override
  bool get hasActiveTurn => false;
  @override
  Object addTurnActivityListener(void Function() listener) => Object();
  @override
  void removeTurnActivityListener(Object token) {}
  @override
  Object setAsyncEventListener(
    String localSessionId,
    DesktopAsyncEventCallback listener,
  ) => Object();
  @override
  void removeAsyncEventListener(String localSessionId, Object registration) {}
  @override
  Object setTurnSettledListener(
    String localSessionId,
    GatewayTurnSettledCallback listener,
  ) => Object();
  @override
  void removeTurnSettledListener(String localSessionId, Object registration) {}
  @override
  bool ownsApprovalRequest({
    required String sessionId,
    required String requestId,
  }) => false;
  @override
  Future<bool> tryRespondToApproval({
    required String sessionId,
    required String choice,
    String? requestId,
  }) async => false;
  @override
  Future<bool> tryRespondToClarify({
    required String requestId,
    required String answer,
    String? questionId,
  }) async => false;
  @override
  Future<bool> tryRespondToSudo({
    required String requestId,
    required String password,
  }) async => false;
  @override
  Future<bool> tryRespondToSecret({
    required String requestId,
    required String value,
  }) async => false;
  @override
  Future<List<GatewayTurnRecoveryState>> recoverPending(
    String localSessionId, {
    GatewayTurnStateCallback? onState,
  }) async => const [];
  @override
  Future<GatewayTurnRecoveryState> submit({
    required String localSessionId,
    required String text,
    List<GatewayTurnAttachmentReceipt> attachments = const [],
    GatewayTurnStateCallback? onState,
  }) async {
    submitCount++;
    throw StateError('v2 submit');
  }

  @override
  Future<void> close() async {}
  @override
  Object setSessionBoundListener(
    String localSessionId,
    GatewayTurnSessionBoundCallback listener,
  ) => Object();
  @override
  void removeSessionBoundListener(String localSessionId, Object registration) {}
  @override
  Future<void> detachAttachments({
    required String localSessionId,
    required Iterable<GatewayTurnAttachmentReceipt> attachments,
  }) async {}
  @override
  Future<GatewayTurnRecoveryState> interrupt({
    required String localSessionId,
    required String clientTurnId,
  }) => throw UnimplementedError();
  @override
  Future<GatewayTurnAttachmentReceipt> stageAttachment({
    required String localSessionId,
    required String clientAttachmentId,
    required String name,
    required String dataUrl,
    required int byteLength,
    required String mediaType,
    required GatewayTurnAttachmentKind kind,
  }) => throw UnimplementedError();
}

final _hooks = <TestDesktopAsyncEventHook>[];
final _owners = <GatewayTurnApplicationController>[];

Future<void> _finish(WidgetTester tester, _Server server) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  await tester.runAsync(() async {
    for (final o in _owners) {
      await o.close();
    }
    _owners.clear();
    await server.close();
  });
  await tester.pump(const Duration(seconds: 20));
}

Finder get _card => find.byType(FailureRecoveryCard);

Future<void> _confirmSwitch(WidgetTester tester) async {
  await tester.tap(find.text('Switch to GPT-5 mini'));
  await _pump(tester, rounds: 5);
  await tester.tap(
    find.descendant(
      of: find.byType(AlertDialog),
      matching: find.widgetWithText(FilledButton, 'Switch model'),
    ),
  );
}

void main() {
  HttpOverrides? previous;
  late Directory root;
  late PathProviderPlatform previousPaths;
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
    mockChatImageRecovery();
    previous = HttpOverrides.current;
    HttpOverrides.global = null;
    root = Directory.systemTemp.createTempSync('switch-retry');
    previousPaths = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _Paths(root);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/image_picker'),
          (_) async => null,
        );
  });
  tearDown(() {
    HttpOverrides.global = previous;
    PathProviderPlatform.instance = previousPaths;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/image_picker'),
          null,
        );
    try {
      root.deleteSync(recursive: true);
    } catch (_) {}
  });

  Future<({_Server server, ValueNotifier<String> which})> mount(
    WidgetTester tester, {
    _V2Session? v2,
    List<Map<String, dynamic>>? rows,
  }) async {
    await tester.binding.setSurfaceSize(const Size(4000, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final server = (await tester.runAsync(_Server.start))!;
    if (rows != null) server.rows = rows;
    addTearDown(() async {
      await tester.runAsync(server.close);
    });
    final cache = Directory('${root.path}/cache')..createSync();
    final which = ValueNotifier('stored');
    final hook = TestDesktopAsyncEventHook();
    _hooks.add(hook);
    final owner = GatewayTurnApplicationController();
    _owners.add(owner);
    await tester.pumpWidget(
      MaterialApp(
        theme: hermesTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ValueListenableBuilder<String>(
          valueListenable: which,
          builder: (context, id, _) => KeyedSubtree(
            key: ValueKey(id),
            child: ChatScreen(
              connection: server.connection,
              session: _session(id),
              testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
              testDesktopAsyncEventHook: hook,
              turnApplicationController: owner,
              testTurnApplicationSession: v2,
              testAttachmentDraftService: AttachmentDraftService(
                cacheDirectoryProvider: () async => cache,
              ),
            ),
          ),
        ),
      ),
    );
    await _until(tester, () => server.of('session.resume').isNotEmpty);
    await _pump(tester);
    return (server: server, which: which);
  }

  /// The failed turn is in the transcript (REST history); its failure
  /// arrives as an error frame over the socket. A recovery-v2 owner's frames
  /// reach the screen through its async listener (the hook here).
  Future<void> failTurn(
    WidgetTester tester,
    _Server server, {
    required bool v2,
  }) async {
    if (v2) {
      _hooks.last.handler!(
        StreamEvent(
          type: 'error',
          data: _usageLimit(),
          sessionId: 'runtime-stored',
        ),
      );
    } else {
      server.event('error', _usageLimit(), 'runtime-stored');
    }
    await _until(tester, () => _card.evaluate().isNotEmpty);
    await _pump(tester, rounds: 5);
  }

  group('the card appears for real turn failures', () {
    testWidgets('CS0 legacy stored chat: a detached error frame over the '
        'socket raises the card with its Switch to suggestion', (tester) async {
      final h = await mount(tester);
      h.server.event('error', _usageLimit(), 'runtime-stored');
      await _until(tester, () => _card.evaluate().isNotEmpty);
      await _pump(tester, rounds: 5);
      expect(_card, findsOneWidget);
      expect(find.text('Usage limit reached'), findsWidgets);
      expect(find.text('Switch to GPT-5 mini'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('failure-card-switch-no-retry')),
        findsNothing,
      );
      await _finish(tester, h.server);
    });

    testWidgets('CS0 legacy stored chat: the same frame through the async '
        'hook raises the card too', (tester) async {
      final h = await mount(tester);
      _hooks.last.handler!(
        StreamEvent(
          type: 'error',
          data: _usageLimit(),
          sessionId: 'runtime-stored',
        ),
      );
      await _until(tester, () => _card.evaluate().isNotEmpty);
      await _pump(tester, rounds: 5);
      expect(_card, findsOneWidget);
      await _finish(tester, h.server);
    });

    testWidgets('a live stock turn: turn.error for that turn raises the card '
        'once it settles, and Switch to replaces exactly that turn', (
      tester,
    ) async {
      final h = await mount(tester);
      h.server.rows = const [];
      await tester.enterText(find.byKey(_composerKey), 'first try');
      await tester.pump();
      await tester.tap(find.byKey(const Key('chat-send-message')));
      await _until(tester, () => h.server.of('prompt.submit').isNotEmpty);
      await _pump(tester, rounds: 5);
      expect(_card, findsNothing);
      h.server.event('message.start', {}, 'runtime-stored', turnId: 'w1');
      await _pump(tester, rounds: 5);
      h.server.event(
        'turn.error',
        _usageLimit(),
        'runtime-stored',
        turnId: 'w1',
      );
      await _until(tester, () => _card.evaluate().isNotEmpty);
      await _pump(tester, rounds: 5);
      expect(_card, findsOneWidget, reason: 'no card for the live failure');
      expect(find.text('Switch to GPT-5 mini'), findsOneWidget);
      h.server.history = [
        {'role': 'user', 'text': 'first try', 'row_id': 9},
      ];
      await _confirmSwitch(tester);
      await _until(tester, () => h.server.of('prompt.submit').length > 1);
      await _pump(tester);
      final submits = h.server.of('prompt.submit');
      expect(submits, hasLength(2), reason: 'exactly one retry');
      final retry = submits.last['params'] as Map;
      expect(retry['text'], 'first try');
      expect(retry['confirm_truncate'], isTrue);
      expect(retry['truncate_before_row_id'], 9);
      expect(h.server.of('config.set'), hasLength(1));
      await _finish(tester, h.server);
    });
  });

  for (final v2 in [true, false]) {
    for (final first in [true, false]) {
      final path = v2 ? 'recovery-v2' : 'legacy stored chat';
      testWidgets('CS1 $path: Switch to sends config.set once, then one '
          'regenerate prompt.submit (${first ? 'first' : 'later'} turn)', (
        tester,
      ) async {
        final session = v2 ? _V2Session() : null;
        final h = await mount(tester, v2: session);
        h.server.history = [
          if (!first) ...[
            {'role': 'user', 'text': 'older', 'row_id': 3},
            {'role': 'assistant', 'text': 'reply', 'row_id': 4},
          ],
          {'role': 'user', 'text': 'hello there', 'row_id': 7},
        ];
        await failTurn(tester, h.server, v2: v2);
        expect(_card, findsOneWidget);
        await tester.enterText(find.byKey(_composerKey), 'my newer draft');
        await tester.pump();
        await _confirmSwitch(tester);
        await _until(tester, () => h.server.of('prompt.submit').isNotEmpty);
        await _pump(tester);
        final methods = h.server.frames.map((f) => f['method']).toList();
        final sets = h.server.of('config.set');
        final submits = h.server.of('prompt.submit');
        expect(sets, hasLength(1), reason: '$methods');
        expect(sets.single['params']['key'], 'model');
        expect(submits, hasLength(1), reason: '$methods');
        final retry = submits.single['params'] as Map;
        expect(retry['text'], 'hello there');
        expect(retry['confirm_truncate'], isTrue);
        expect(retry['truncate_before_row_id'], 7);
        // runRewindSubmit (rewind.ts:361-369): every resolved-row retry.
        expect(retry['confirm_empty_truncate'], isTrue);
        expect(retry.containsKey('truncate_before_user_ordinal'), isFalse);
        expect(
          methods.indexOf('config.set'),
          lessThan(methods.lastIndexOf('prompt.submit')),
        );
        expect(session?.submitCount ?? 0, 0);
        expect(
          tester.widget<TextField>(find.byKey(_composerKey)).controller!.text,
          'my newer draft',
        );
        // One switch is one retry: nothing more goes out later.
        await _pump(tester, rounds: 40);
        expect(h.server.of('prompt.submit'), hasLength(1));
        await _finish(tester, h.server);
      });
    }
  }

  testWidgets('CS2 cancelling the confirm switches nothing, sends nothing', (
    tester,
  ) async {
    final v2 = _V2Session();
    final h = await mount(tester, v2: v2);
    h.server.history = [
      {'role': 'user', 'text': 'hello there', 'row_id': 7},
    ];
    await failTurn(tester, h.server, v2: true);
    await tester.tap(find.text('Switch to GPT-5 mini'));
    await _pump(tester, rounds: 5);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextButton, 'Cancel'),
      ),
    );
    await _pump(tester);
    expect(h.server.of('config.set'), isEmpty);
    expect(h.server.of('prompt.submit'), isEmpty);
    expect(_card, findsOneWidget);
    await _finish(tester, h.server);
  });

  for (final v2 in [true, false]) {
    testWidgets('CS3 ${v2 ? 'recovery-v2' : 'legacy'}: leaving the chat while '
        'config.set is in flight sends no retry anywhere', (tester) async {
      final h = await mount(tester, v2: v2 ? _V2Session() : null);
      h.server.history = [
        {'role': 'user', 'text': 'hello there', 'row_id': 7},
      ];
      await failTurn(tester, h.server, v2: v2);
      h.server.configGate = Completer<void>();
      await _confirmSwitch(tester);
      await _until(tester, () => h.server.of('config.set').isNotEmpty);
      h.which.value = 'other';
      await _pump(tester);
      h.server.configGate!.complete();
      await _pump(tester, rounds: 40);
      expect(h.server.of('prompt.submit'), isEmpty);
      expect(h.server.of('session.history'), isEmpty);
      await _finish(tester, h.server);
    });
  }

  // The bubble's Regenerate on a Desktop chat is the truncating regenerate,
  // never the ask-again of a transport that cannot truncate
  // (classic_bubble_regenerate_test.dart).
  group('the bubble Regenerate on a Desktop chat', () {
    const answer = 'A saved answer';
    List<Map<String, dynamic>> saved() => [
      {'id': 1, 'role': 'user', 'content': 'hello there'},
      {
        'id': 2,
        'role': 'assistant',
        'content': answer,
        'finish_reason': 'stop',
      },
    ];

    Future<void> regenerate(WidgetTester tester) async {
      final reply = find.descendant(
        of: find.byWidgetPredicate(
          (widget) =>
              widget is MessageBubble &&
              !widget.isUser &&
              widget.content == answer,
        ),
        matching: find.byKey(const Key('message-bubble')),
      );
      await _until(tester, () => reply.evaluate().isNotEmpty);
      expect(reply.hitTestable(), findsOneWidget);
      await tester.enterText(find.byKey(_composerKey), 'my newer draft');
      await tester.pump();
      await tester.longPress(reply);
      await _pump(tester);
      expect(find.text('Regenerate response'), findsOneWidget);
      await tester.tap(find.text('Regenerate response'));
      await _pump(tester);
    }

    testWidgets('replaces the turn: one prompt.submit with confirm_truncate '
        'and the durable row; a newer draft stays', (tester) async {
      final h = await mount(tester, rows: saved());
      h.server.history = [
        {'role': 'user', 'text': 'hello there', 'row_id': 7},
      ];
      await regenerate(tester);
      await _until(tester, () => h.server.of('prompt.submit').isNotEmpty);
      await _pump(tester, rounds: 40);
      final submits = h.server.of('prompt.submit');
      expect(submits, hasLength(1));
      final retry = submits.single['params'] as Map;
      expect(retry['text'], 'hello there');
      expect(retry['confirm_truncate'], isTrue);
      expect(retry['truncate_before_row_id'], 7);
      expect(retry['confirm_empty_truncate'], isTrue);
      expect(
        tester.widget<TextField>(find.byKey(_composerKey)).controller!.text,
        'my newer draft',
      );
      await _finish(tester, h.server);
    });

    testWidgets('with no durable row it says so and sends nothing: never a '
        'plain resend', (tester) async {
      final h = await mount(tester, rows: saved());
      h.server.history = [];
      await regenerate(tester);
      await _until(tester, () => h.server.of('session.history').isNotEmpty);
      await _pump(tester, rounds: 40);
      expect(h.server.of('session.history'), hasLength(1));
      expect(h.server.of('prompt.submit'), isEmpty);
      expect(find.textContaining('Nothing was sent again'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byKey(_composerKey)).controller!.text,
        'my newer draft',
      );
      await _finish(tester, h.server);
    });
  });

  // /bg on an older gateway without prompt.background: as Desktop's slash.ts
  // (isMissingRpcMethod), it runs through slash.exec instead; a real failure
  // of prompt.background is reported, never re-run.
  for (final (label, error, fallsBack) in [
    ('-32601', {'code': -32601, 'message': 'unknown method'}, true),
    (
      '4004 unknown method',
      {'code': 4004, 'message': 'unknown method: prompt.background'},
      true,
    ),
    ('4004 bad input', {'code': 4004, 'message': 'text is required'}, false),
  ]) {
    testWidgets(
      '/background, prompt.background answers $label: '
      '${fallsBack ? 'runs through slash.exec' : 'reported, no slash.exec'}',
      (tester) async {
        final h = await mount(tester);
        h.server.errors['prompt.background'] = error;
        await tester.enterText(
          find.byKey(_composerKey),
          '/background summarise the repo',
        );
        await tester.pump();
        await tester.tap(find.byKey(const Key('chat-send-message')));
        await _until(
          tester,
          () =>
              h.server.of('prompt.background').isNotEmpty &&
              (!fallsBack || h.server.of('slash.exec').isNotEmpty),
        );
        await _pump(tester);
        expect(h.server.of('prompt.background'), hasLength(1));
        expect(
          h.server.of('prompt.background').single['params']['text'],
          'summarise the repo',
        );
        final exec = h.server.of('slash.exec');
        if (fallsBack) {
          expect(exec, hasLength(1), reason: 'no slash.exec fallback');
          expect(
            '${exec.single['params']['command']}',
            contains('background summarise the repo'),
          );
        } else {
          expect(exec, isEmpty);
        }
        expect(h.server.of('prompt.submit'), isEmpty);
        await _finish(tester, h.server);
      },
    );
  }

  // Intake over the gateway (the re-check's CR2): the Attach picker's files
  // and a drop arriving together at 9 drafts give exactly 10.
  for (final order in ['picker-first', 'drop-first']) {
    testWidgets('CR2 Attach (Choose files, 2 picked) + drop ($order) at 9 '
        'drafts give exactly 10', (tester) async {
      final h = await mount(tester);
      List<OsIntakeFile> make(int n, String p) => [
        for (var i = 0; i < n; i++)
          OsIntakeFile(
            (File('${root.path}/$p$i.txt')..writeAsStringSync('n$i')).path,
          ),
      ];
      OsFileDropTarget target() =>
          tester.widget<OsFileDropTarget>(find.byType(OsFileDropTarget));
      for (final f in make(maxRemoteAttachmentDrafts - 1, 'base')) {
        final before = _tiles();
        for (var k = 0; k < 5 && _tiles() == before; k++) {
          target().onFiles([f]);
          await _until(tester, () => _tiles() > before);
        }
      }
      expect(_tiles(), maxRemoteAttachmentDrafts - 1);
      final gate = Completer<void>();
      final picked = [
        for (final n in ['pa.txt', 'pb.txt'])
          (File('${root.path}/$n')..writeAsStringSync(n)),
      ];
      FilePicker.platform = _Picker([
        for (final f in picked)
          PlatformFile(name: f.uri.pathSegments.last, size: 2, path: f.path),
      ], gate: gate);
      addTearDown(() => FilePicker.platform = _Picker(const []));
      final drop = make(1, 'drop');
      if (order == 'drop-first') target().onFiles(drop);
      await tester.tap(find.byTooltip('Attach image or file'));
      await _pump(tester, rounds: 5);
      await tester.tap(find.text('Choose files'), warnIfMissed: false);
      await tester.pump();
      if (order == 'picker-first') target().onFiles(drop);
      gate.complete();
      await _pump(tester, rounds: 40);
      expect(tester.takeException(), isNull);
      expect(_tiles(), maxRemoteAttachmentDrafts);
      await _finish(tester, h.server);
    });
  }
}
