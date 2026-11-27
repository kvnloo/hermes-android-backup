// Regression tests from the independent review of v5/composer at 7d750d1d
// (probes C1-C4), Classic layout. Each failed at 7d750d1d:
//   C1 an async error frame armed a Retry that resent the accepted prompt
//      and overwrote the newer draft
//   C2 a btw.complete answer never reached the chat
//   C3 /resume from an embedded chat replaced the whole shell
//   C4 no @-reference completion or status bar in Classic, and no drop or
//      paste intake (files from the OS, the clipboard, a keyboard or the
//      files panel)
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/composer_drag.dart';
import 'package:hermes_android/core/composer/os_intake.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/attachment_draft_service.dart';
import 'package:hermes_android/core/services/composer_session_rpc.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/widgets/attachment_draft_tile.dart';
import 'package:hermes_android/core/widgets/composer_drop_surface.dart';
import 'package:hermes_android/core/widgets/failure_recovery_card.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:image/image.dart' as image_lib;
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/completed_stock_turn.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _composerKey = Key('chat-message-composer');

Widget _app(Widget home) => MaterialApp(
  theme: hermesTheme(Brightness.light),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

const _session = Session(
  id: 'probe-parent',
  title: 'Parent',
  model: 'fixture',
  source: 'api_server',
  messageCount: 2,
  isActive: true,
  preview: '',
  startedAt: 1,
);

SavedConnection _conn(String id) => SavedConnection(
  id: id,
  label: id,
  host: 'probe.fixture',
  port: 8642,
  apiKey: 'fixture',
);

String _composer(WidgetTester tester) =>
    tester.widget<TextField>(find.byKey(_composerKey)).controller!.text;

class _Paths extends PathProviderPlatform {
  _Paths(this.dir);
  final Directory dir;
  @override
  Future<String?> getTemporaryPath() async => dir.path;
}

/// The composer's gateway calls without a socket: a live session whose
/// context breakdown has [categories] rows.
class _ComposerRpc implements ComposerSessionRpc {
  _ComposerRpc({this.categories = 1});
  final int categories;
  final calls = <String>[];

  @override
  bool hasLiveSession(String mobileSessionId) => true;

  @override
  Future<Map<String, dynamic>> requestSessionRpc(
    String method,
    Map<String, dynamic> params,
  ) async {
    calls.add(method);
    if (method != 'session.context_breakdown') return const {};
    return {
      'categories': [
        for (var i = 0; i < categories; i++)
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
    };
  }

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params,
  ) async {
    calls.add(method);
    return const {};
  }
}

/// Real files on this device for the intake tests, and a cache for drafts.
class _Files {
  _Files() {
    root = Directory.systemTemp.createTempSync('classic-intake');
    cache = Directory('${root.path}/cache')..createSync();
    notes = File('${root.path}/notes.txt')..writeAsStringSync('hello notes');
    png = image_lib.encodePng(image_lib.Image(width: 2, height: 2));
    shot = File('${root.path}/shot.png')..writeAsBytesSync(png);
    folder = Directory('${root.path}/folder')..createSync();
  }

  late final Directory root, cache, folder;
  late final File notes, shot;
  late final Uint8List png;

  List<FileSystemEntity> get staged {
    final dir = Directory('${root.path}/composer-paste');
    return dir.existsSync() ? dir.listSync() : const [];
  }
}

/// Lets real file I/O and image work (fake-async tests do not run it)
/// finish and render, without moving the clock: notices stay up. Stops once
/// [done] holds, after a few quiet rounds more.
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

bool Function() _tiles(int count) =>
    () => find.byType(AttachmentDraftTile).evaluate().length >= count;

/// A text clipboard (the test binding has none).
void _mockTextClipboard() {
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
}

Future<void> _pasteShortcut(WidgetTester tester) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await tester.pump();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': true});
    mockChatImageRecovery();
  });

  ({ChatScreen screen, List<http.BaseRequest> writes}) classic(
    TestDesktopAsyncEventHook hook,
    String connId,
  ) {
    final writes = <http.BaseRequest>[];
    final screen = ChatScreen(
      connection: _conn(connId),
      session: _session,
      testApiClient: ApiClient(
        baseUrl: 'http://probe.fixture',
        apiKey: 'fixture',
        httpClient: MockClient((request) async {
          if (request.method != 'GET') writes.add(request);
          return http.Response(
            jsonEncode({
              'data': [
                {'id': 1, 'role': 'user', 'content': 'Earlier question'},
                {'id': 2, 'role': 'assistant', 'content': 'Earlier answer'},
              ],
            }),
            200,
          );
        }),
      ),
      testDesktopAsyncEventHook: hook,
      testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
    );
    return (screen: screen, writes: writes);
  }

  testWidgets('PROBE C1 an async error frame arms a Retry that resends the '
      'already-answered prompt and overwrites the newer draft', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final hook = TestDesktopAsyncEventHook();
    final c = classic(hook, 'probe-c1');
    await tester.pumpWidget(_app(c.screen));
    await pumpChatUpdates(tester);
    expect(find.textContaining('Earlier answer'), findsWidgets);

    // The Desktop client delivers every terminal frame (incl. `error`) on
    // the async channel too (desktop_gateway_client.dart:94-101).
    hook.handler!(
      StreamEvent(type: 'error', data: {'message': 'Upstream provider error'}),
    );
    await pumpChatUpdates(tester);
    expect(find.byType(FailureRecoveryCard), findsOneWidget);

    await tester.enterText(find.byKey(_composerKey), 'my newer unsent draft');
    await tester.pump();
    final before = c.writes.length;
    await tester.tap(find.text('Retry'));
    await pumpChatUpdates(tester);
    // ignore: avoid_print
    print(
      'C1 writes after Retry: ${c.writes.skip(before).map((r) => '${r.method} ${r.url.path}').toList()} '
      'composer="${_composer(tester)}"',
    );
    expect(
      c.writes.length,
      before,
      reason: 'Retry must not resubmit a turn the gateway already accepted',
    );
    expect(_composer(tester), 'my newer unsent draft');
  });

  testWidgets('PROBE C2 a btw.complete answer is shown in Classic', (
    tester,
  ) async {
    final hook = TestDesktopAsyncEventHook();
    final c = classic(hook, 'probe-c2');
    await tester.pumpWidget(_app(c.screen));
    await pumpChatUpdates(tester);
    hook.handler!(
      StreamEvent(
        type: 'btw.complete',
        data: {
          'task_id': 'btw_1',
          'question': 'q',
          'text': 'CLASSIC-SIDE-ANSWER',
          'session_id': 'probe-parent',
        },
      ),
    );
    await pumpChatUpdates(tester);
    expect(find.textContaining('CLASSIC-SIDE-ANSWER'), findsOneWidget);
  });

  testWidgets('PROBE C4 Classic composer offers @-reference completion and the '
      'status bar (F19/F25 in both layouts)', (tester) async {
    final hook = TestDesktopAsyncEventHook();
    final c = classic(hook, 'probe-c4');
    await tester.pumpWidget(_app(c.screen));
    await pumpChatUpdates(tester);
    await tester.enterText(find.byKey(_composerKey), 'look at @fi');
    await pumpChatUpdates(tester);
    final starters = find.text('@file:').evaluate().length;
    final status = find.text('Status').evaluate().length;
    final drop = find.byType(ComposerDropSurface).evaluate().length;
    // ignore: avoid_print
    print(
      'C4 @file: rows=$starters Status controls=$status dropSurfaces=$drop',
    );
    expect(starters, greaterThan(0), reason: '@ completion missing');
    expect(status, greaterThan(0), reason: 'status bar missing');
  });

  testWidgets('PROBE C3 /resume from a chat embedded in a shell route never '
      'replaces the shell', (tester) async {
    final previous = HttpOverrides.current;
    HttpOverrides.global = null;
    addTearDown(() => HttpOverrides.global = previous);
    late HttpServer server;
    await tester.runAsync(() async {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((req) async {
        final path = req.uri.path;
        req.response.headers.contentType = ContentType.json;
        if (path == '/api/sessions') {
          req.response.write(
            jsonEncode({
              'object': 'list',
              'data': [
                {
                  'id': 'other-chat',
                  'title': 'Other chat',
                  'model': 'm',
                  'message_count': 1,
                  'started_at': 1.7e9,
                  'ended_at': null,
                  'preview': 'hi',
                  'source': 'cli',
                },
              ],
              'has_more': false,
            }),
          );
        } else if (path.endsWith('/messages')) {
          req.response.write(jsonEncode({'data': []}));
        } else {
          req.response.statusCode = 404;
          req.response.write('{}');
        }
        await req.response.close();
      });
    });
    addTearDown(() async {
      await tester.runAsync(() => server.close(force: true));
    });
    final connection = SavedConnection(
      id: 'probe-c3',
      label: 'probe',
      host: '127.0.0.1',
      port: server.port,
      dashboardPortOverride: server.port,
      apiKey: 'fixture',
    );
    // The workspace detail pane: the host swaps the chat it shows through
    // its own open path (what the review probe's bare embedding lacked).
    final shown = ValueNotifier<Session>(
      const Session(
        id: 'embedded-chat',
        title: 'Embedded',
        model: 'm',
        source: 'api_server',
        messageCount: 0,
        isActive: true,
        preview: '',
        startedAt: 1,
      ),
    );
    addTearDown(shown.dispose);
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: Row(
            children: [
              const SizedBox(width: 120, child: Text('WORKSPACE-SHELL')),
              Expanded(
                child: ValueListenableBuilder<Session>(
                  valueListenable: shown,
                  builder: (context, session, _) => KeyedSubtree(
                    key: ValueKey(session.id),
                    child: ChatScreen(
                      connection: connection,
                      session: session,
                      testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
                      onOpenSession: (picked) async => shown.value = picked,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    Future<void> settle() async {
      for (var i = 0; i < 10; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 60)),
        );
        await tester.pump(const Duration(milliseconds: 60));
      }
    }

    await settle();
    await tester.enterText(find.byKey(_composerKey), '/resume');
    await tester.pump();
    await tester.tap(find.byTooltip('Send'));
    await settle();
    // ignore: avoid_print
    print(
      'C3 picker rows: Other chat=${find.text('Other chat').evaluate().length} '
      'unavailable=${find.text('This pane has no chat list to search.').evaluate().length}',
    );
    expect(find.text('Other chat'), findsOneWidget);
    await tester.tap(find.text('Other chat'));
    await settle();
    // ignore: avoid_print
    print(
      'C3 shell after pick: ${find.text('WORKSPACE-SHELL').evaluate().length}',
    );
    expect(find.text('WORKSPACE-SHELL'), findsOneWidget);
    expect(shown.value.id, 'other-chat');
    expect(
      tester.widget<ChatScreen>(find.byType(ChatScreen)).session.id,
      'other-chat',
    );
  });

  testWidgets('/resume in a pane with no open path keeps the pane and the '
      'line', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final hook = TestDesktopAsyncEventHook();
    final c = classic(hook, 'probe-c3-bare');
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: Row(
            children: [
              const SizedBox(width: 120, child: Text('WORKSPACE-SHELL')),
              Expanded(child: c.screen),
            ],
          ),
        ),
      ),
    );
    await pumpChatUpdates(tester);
    await tester.enterText(find.byKey(_composerKey), '/resume');
    await tester.pump();
    await tester.tap(find.byTooltip('Send'));
    await pumpChatUpdates(tester);
    expect(find.text('Resume a chat'), findsNothing);
    expect(find.text('WORKSPACE-SHELL'), findsOneWidget);
    expect(_composer(tester), '/resume');
    expect(find.textContaining('session list'), findsOneWidget);
  });

  group('C4 Classic drop and paste intake', () {
    late _Files files;
    late PathProviderPlatform previousPaths;

    setUp(() {
      files = _Files();
      previousPaths = PathProviderPlatform.instance;
      PathProviderPlatform.instance = _Paths(files.root);
      _mockTextClipboard();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
      PathProviderPlatform.instance = previousPaths;
      debugClipboardAttachmentReader = null;
      files.root.deleteSync(recursive: true);
    });

    ({ChatScreen screen, List<String> sent}) intakeChat(
      String connId, {
      List<AttachmentDraft> initial = const [],
      Future<void>? hold,
    }) {
      final sent = <String>[];
      final screen = ChatScreen(
        connection: _conn(connId),
        session: _session,
        testApiClient: ApiClient(
          baseUrl: 'http://probe.fixture',
          apiKey: 'fixture',
          httpClient: MockClient(
            (_) async => http.Response('{"data":[]}', 200),
          ),
        ),
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
        testAttachmentDraftService: AttachmentDraftService(
          cacheDirectoryProvider: () async => files.cache,
        ),
        testInitialAttachmentDrafts: initial,
        testRemotePromptSubmit: completedStockTurn(({
          required sessionId,
          required text,
          required onEvent,
          required onSent,
        }) async {
          sent.add(text);
          onSent();
          await hold;
        }),
        testRemoteAttachmentUpload:
            ({required draft, required dataUrl}) async =>
                AttachmentUploadReceipt(
                  refText: '@file:/attachments/${draft.name}',
                ),
      );
      return (screen: screen, sent: sent);
    }

    Future<({ChatScreen screen, List<String> sent})> pumpIntake(
      WidgetTester tester,
      String connId, {
      List<AttachmentDraft> initial = const [],
      double height = 1400,
      Future<void>? hold,
    }) async {
      await tester.binding.setSurfaceSize(Size(800, height));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final c = intakeChat(connId, initial: initial, hold: hold);
      await tester.pumpWidget(_app(c.screen));
      await pumpChatUpdates(tester);
      return c;
    }

    testWidgets('files dropped from the OS become drafts and are never '
        'sent; a folder is refused', (tester) async {
      final c = await pumpIntake(tester, 'intake-drop');
      await tester.enterText(find.byKey(_composerKey), 'my words');
      await tester.pump();
      tester.widget<OsFileDropTarget>(find.byType(OsFileDropTarget)).onFiles([
        OsIntakeFile(files.notes.path),
        OsIntakeFile(files.shot.path),
        OsIntakeFile(files.folder.path, directory: true),
      ]);
      await _drain(
        tester,
        done: () => find
            .text("Folders can't be attached. Drop the files instead.")
            .evaluate()
            .isNotEmpty,
      );
      expect(find.byType(AttachmentDraftTile), findsNWidgets(2));
      expect(find.textContaining('notes.txt'), findsWidgets);
      expect(find.textContaining('shot.png'), findsWidgets);
      expect(
        find.text("Folders can't be attached. Drop the files instead."),
        findsOneWidget,
      );
      expect(c.sent, isEmpty);
      expect(_composer(tester), 'my words');
    });

    testWidgets('a drop stops at maxRemoteAttachmentDrafts', (tester) async {
      final initial = [
        for (var i = 0; i < maxRemoteAttachmentDrafts - 1; i++)
          AttachmentDraft(
            id: 'held-$i',
            cachedPath: '${files.cache.path}/held-$i.bin',
            name: 'held-$i.txt',
            byteLength: 4,
            mediaType: 'text/plain',
            kind: AttachmentDraftKind.genericFile,
          ),
      ];
      final c = await pumpIntake(
        tester,
        'intake-limit',
        initial: initial,
        height: 4000,
      );
      expect(
        find.byType(AttachmentDraftTile),
        findsNWidgets(maxRemoteAttachmentDrafts - 1),
      );
      tester.widget<OsFileDropTarget>(find.byType(OsFileDropTarget)).onFiles([
        OsIntakeFile(files.notes.path),
        OsIntakeFile(files.shot.path),
      ]);
      await _drain(
        tester,
        done: () => find
            .text('You can attach up to $maxRemoteAttachmentDrafts items.')
            .evaluate()
            .isNotEmpty,
      );
      expect(
        find.byType(AttachmentDraftTile),
        findsNWidgets(maxRemoteAttachmentDrafts),
      );
      expect(
        find.text('You can attach up to $maxRemoteAttachmentDrafts items.'),
        findsOneWidget,
      );
      expect(c.sent, isEmpty);
    });

    testWidgets('Ctrl+V with an image on the clipboard adds an image draft; '
        'plain text still pastes as text', (tester) async {
      debugClipboardAttachmentReader = () async =>
          ClipboardAttachment(image: files.png);
      final c = await pumpIntake(tester, 'intake-paste');
      await tester.tap(find.byKey(_composerKey));
      await tester.pump();
      await _pasteShortcut(tester);
      await _drain(tester, done: _tiles(1));
      expect(find.byType(AttachmentDraftTile), findsOneWidget);
      expect(_composer(tester), isEmpty);
      // The staged clipboard image is gone; the draft has its own copy.
      expect(files.staged, isEmpty);

      debugClipboardAttachmentReader = () async => null;
      await Clipboard.setData(const ClipboardData(text: 'plain words'));
      await _pasteShortcut(tester);
      await _drain(tester, done: () => _composer(tester) == 'plain words');
      expect(_composer(tester), 'plain words');
      expect(find.byType(AttachmentDraftTile), findsOneWidget);
      expect(c.sent, isEmpty);
    });

    testWidgets('a pasted path to a file on this device becomes a draft and '
        'leaves the text; a folder path stays text', (tester) async {
      final c = await pumpIntake(tester, 'intake-path');
      final field = find.descendant(
        of: find.byKey(_composerKey),
        matching: find.byType(EditableText),
      );
      await tester.enterText(find.byKey(_composerKey), 'see ');
      await tester.pump();
      await Clipboard.setData(ClipboardData(text: files.notes.path));
      await tester
          .state<EditableTextState>(field)
          .pasteText(SelectionChangedCause.toolbar);
      await _drain(
        tester,
        done: () => _tiles(1)() && _composer(tester) == 'see ',
      );
      expect(find.byType(AttachmentDraftTile), findsOneWidget);
      expect(_composer(tester), 'see ');

      await Clipboard.setData(ClipboardData(text: files.folder.path));
      await tester
          .state<EditableTextState>(field)
          .pasteText(SelectionChangedCause.toolbar);
      await _drain(tester);
      expect(_composer(tester), 'see ${files.folder.path}');
      expect(_composer(tester), isNot(contains('@folder:')));
      expect(find.byType(AttachmentDraftTile), findsOneWidget);
      expect(c.sent, isEmpty);
    });

    testWidgets('while a reply runs, Ctrl+V pastes text and the editor keeps '
        'its state', (tester) async {
      debugClipboardAttachmentReader = () async =>
          ClipboardAttachment(image: files.png);
      final hold = Completer<void>();
      final c = await pumpIntake(tester, 'intake-busy', hold: hold.future);
      final field = find.descendant(
        of: find.byKey(_composerKey),
        matching: find.byType(EditableText),
      );
      final before = tester.state<EditableTextState>(field);
      await tester.enterText(find.byKey(_composerKey), 'first');
      await tester.pump();
      await tester.tap(find.byTooltip('Send'));
      await tester.pump();
      await tester.pump();
      expect(c.sent, ['first']);
      expect(find.byKey(const Key('chat-stop-response')), findsOneWidget);
      // Attach is closed now; the editor is the same one, not rebuilt.
      expect(identical(tester.state<EditableTextState>(field), before), isTrue);
      await tester.tap(find.byKey(_composerKey));
      await tester.pump();
      await Clipboard.setData(const ClipboardData(text: 'typed while busy'));
      await _pasteShortcut(tester);
      await _drain(
        tester,
        done: () => _composer(tester).contains('typed while busy'),
      );
      expect(_composer(tester), 'typed while busy');
      expect(find.byType(AttachmentDraftTile), findsNothing);
      hold.complete();
      await pumpChatUpdates(tester);
    });

    testWidgets('a keyboard-inserted image becomes a draft', (tester) async {
      final c = await pumpIntake(tester, 'intake-keyboard');
      final field = tester.widget<TextField>(find.byKey(_composerKey));
      expect(
        field.contentInsertionConfiguration?.allowedMimeTypes,
        contains('image/png'),
      );
      field.contentInsertionConfiguration!.onContentInserted(
        KeyboardInsertedContent(
          mimeType: 'image/png',
          uri: 'content://keyboard/sticker.png',
          data: files.png,
        ),
      );
      await _drain(tester, done: _tiles(1));
      expect(find.byType(AttachmentDraftTile), findsOneWidget);
      expect(files.staged, isEmpty);
      expect(c.sent, isEmpty);
    });

    testWidgets('a gateway file dragged from the files panel becomes a '
        'reference', (tester) async {
      final c = await pumpIntake(tester, 'intake-drag');
      tester
          .widget<ComposerDropSurface>(find.byType(ComposerDropSurface))
          .onDrop(
            const ComposerDrag(
              path: '/srv/app/main.py',
              directory: false,
              onGateway: true,
            ),
          );
      await _drain(tester);
      expect(_composer(tester), contains('@file:'));
      expect(_composer(tester), contains('/srv/app/main.py'));
      expect(find.byType(AttachmentDraftTile), findsNothing);
      expect(c.sent, isEmpty);
    });
  });

  ChatScreen statusChat(String connId, _ComposerRpc rpc, List<String> sent) =>
      ChatScreen(
        connection: _conn(connId),
        session: _session,
        testApiClient: ApiClient(
          baseUrl: 'http://probe.fixture',
          apiKey: 'fixture',
          httpClient: MockClient(
            (_) async => http.Response('{"data":[]}', 200),
          ),
        ),
        testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
        testComposerRpc: rpc,
        testRemotePromptSubmit: completedStockTurn(({
          required sessionId,
          required text,
          required onEvent,
          required onSent,
        }) async {
          sent.add(text);
          onSent();
        }),
      );

  testWidgets('C4 Classic reads the context breakdown again after each '
      'turn', (tester) async {
    // Every status item on, the context breakdown included.
    SharedPreferences.setMockInitialValues({
      'verbose_mode': true,
      'composer_status_hidden_v1': <String>[],
    });
    await tester.binding.setSurfaceSize(const Size(1000, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final rpc = _ComposerRpc();
    final sent = <String>[];
    await tester.pumpWidget(_app(statusChat('status-refresh', rpc, sent)));
    await pumpChatUpdates(tester);
    final reads = rpc.calls.where((m) => m == 'session.context_breakdown');
    expect(reads, isNotEmpty);
    final before = reads.length;
    await tester.enterText(find.byKey(_composerKey), 'one more turn');
    await tester.pump();
    await tester.tap(find.byTooltip('Send'));
    await pumpChatUpdates(tester);
    expect(sent, ['one more turn']);
    expect(reads.length, greaterThan(before));
  });

  for (final breakdownOpen in [false, true]) {
    testWidgets('C4 Classic composer at 320x640, 2.0x text, 260 px keyboard '
        'and the Status control in the model row'
        '${breakdownOpen ? ', breakdown open' : ''}: editor >=80 px wide, '
        'above the keyboard, no overflow', (tester) async {
      SharedPreferences.setMockInitialValues({
        'verbose_mode': true,
        'composer_status_hidden_v1': <String>[],
      });
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final rpc = _ComposerRpc(categories: 8);
      await tester.pumpWidget(_app(statusChat('status-narrow', rpc, [])));
      await pumpChatUpdates(tester);
      expect(find.byKey(const ValueKey('composer-status-menu')), findsWidgets);
      if (breakdownOpen) {
        // Folded by default on a narrow pane; opening it must still fit.
        expect(
          find.byKey(const ValueKey('composer-context-breakdown')),
          findsNothing,
        );
        final toggle = find.byKey(
          const ValueKey('composer-context-breakdown-toggle'),
        );
        await tester.ensureVisible(toggle);
        await tester.tap(toggle);
        await pumpChatUpdates(tester);
        expect(
          find.byKey(const ValueKey('composer-context-breakdown')),
          findsOneWidget,
        );
      }
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await tester.enterText(find.byKey(_composerKey), 'steer this please');
      await pumpChatUpdates(tester);
      final errors = <Object>[];
      Object? e;
      while ((e = tester.takeException()) != null) {
        errors.add(e!);
      }
      final field = tester.getRect(find.byKey(_composerKey));
      // ignore: avoid_print
      print(
        'C4 narrow breakdownOpen=$breakdownOpen field=$field '
        'errors=${errors.length} '
        '${errors.isEmpty ? '' : errors.first.toString().split('\n').first}',
      );
      expect(errors, isEmpty);
      expect(field.width, greaterThanOrEqualTo(80));
      expect(field.bottom, lessThanOrEqualTo(640 - 260));
      expect(field.top, greaterThanOrEqualTo(0));
    });
  }
}
