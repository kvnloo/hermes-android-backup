// Regressions from the independent re-check of v5/composer at a3437ec5,
// Classic layout. Each failed at a3437ec5:
//   RC3a two drops arriving before the first one finished both passed the
//        free-slot check: 9 drafts + 2 drops gave 11 tiles, and Send then
//        refused the whole draft
//   Switch to: the failure card's suggested model fell back to the picker;
//        Classic never switched and retried as NextGen and Desktop do
//   keyboard: the Classic composer under every keyboard, text size, draft
//        length and status combination (a guard alongside NextGen's)
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/composer_drag.dart';
import 'package:hermes_android/core/composer/os_intake.dart';
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
  id: 'recheck-parent',
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
  host: 'recheck.fixture',
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

/// A live session whose context breakdown has [categories] rows.
class _Rpc implements ComposerSessionRpc {
  int categories = 1;
  final calls = <String>[];

  @override
  bool hasLiveSession(String mobileSessionId) => true;

  Map<String, dynamic> _answer(String method) {
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
  Future<Map<String, dynamic>> requestSessionRpc(
    String method,
    Map<String, dynamic> params,
  ) async => _answer(method);

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params,
  ) async => _answer(method);
}

/// Lets real file I/O finish and render without moving the clock. Stops
/// once [done] holds, after a few quiet rounds more.
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

int _tileCount() => find.byType(AttachmentDraftTile).evaluate().length;

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': true});
    mockChatImageRecovery();
  });

  group('intake limits', () {
    late Directory root;
    late Directory cache;
    late PathProviderPlatform previousPaths;

    setUp(() {
      root = Directory.systemTemp.createTempSync('classic-recheck');
      cache = Directory('${root.path}/cache')..createSync();
      previousPaths = PathProviderPlatform.instance;
      PathProviderPlatform.instance = _Paths(root);
      String? clipboard;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData') {
              clipboard = (call.arguments as Map)['text'] as String;
            }
            if (call.method == 'Clipboard.getData') return {'text': clipboard};
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
      root.deleteSync(recursive: true);
    });

    ChatScreen intake(String connId, List<String> sent) => ChatScreen(
      connection: _conn(connId),
      session: _session,
      testApiClient: ApiClient(
        baseUrl: 'http://recheck.fixture',
        apiKey: 'fixture',
        httpClient: MockClient((_) async => http.Response('{"data":[]}', 200)),
      ),
      testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
      testAttachmentDraftService: AttachmentDraftService(
        cacheDirectoryProvider: () async => cache,
      ),
      testRemotePromptSubmit: completedStockTurn(({
        required sessionId,
        required text,
        required onEvent,
        required onSent,
      }) async {
        sent.add(text);
        onSent();
      }),
      testRemoteAttachmentUpload: ({required draft, required dataUrl}) async =>
          AttachmentUploadReceipt(refText: '@file:/attachments/${draft.name}'),
    );

    List<OsIntakeFile> make(int n, String prefix) => [
      for (var i = 0; i < n; i++)
        OsIntakeFile(
          (File('${root.path}/$prefix$i.txt')..writeAsStringSync('n$i')).path,
        ),
    ];

    OsFileDropTarget target(WidgetTester tester) =>
        tester.widget<OsFileDropTarget>(find.byType(OsFileDropTarget));

    testWidgets('RC3a two overlapping drops with one slot left give '
        'maxRemoteAttachmentDrafts, and Send sends them', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 4000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final sent = <String>[];
      await tester.pumpWidget(_app(intake('rc3a', sent)));
      await pumpChatUpdates(tester);
      target(tester).onFiles(make(maxRemoteAttachmentDrafts - 1, 'p'));
      await _drain(
        tester,
        done: () => _tileCount() >= maxRemoteAttachmentDrafts - 1,
      );
      expect(_tileCount(), maxRemoteAttachmentDrafts - 1);
      final more = make(2, 'q');
      // Back to back: the second arrives before the first is prepared.
      target(tester).onFiles([more[0]]);
      target(tester).onFiles([more[1]]);
      await _drain(tester);
      expect(_tileCount(), maxRemoteAttachmentDrafts);
      expect(sent, isEmpty);
      await tester.enterText(find.byKey(_composerKey), 'go');
      await tester.pump();
      await tester.tap(find.byTooltip('Send'));
      await _drain(tester, done: () => sent.isNotEmpty);
      expect(sent, hasLength(1));
      expect(
        RegExp('@file:').allMatches(sent.single).length,
        maxRemoteAttachmentDrafts,
      );
    });

    testWidgets('a drop, an in-app drag and a pasted path at once share the '
        'last slot: exactly one is staged', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 4000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final sent = <String>[];
      await tester.pumpWidget(_app(intake('rc3m', sent)));
      await pumpChatUpdates(tester);
      target(tester).onFiles(make(maxRemoteAttachmentDrafts - 1, 'm'));
      await _drain(
        tester,
        done: () => _tileCount() >= maxRemoteAttachmentDrafts - 1,
      );
      final dragged = File('${root.path}/dragged.txt')..writeAsStringSync('d');
      final pasted = File('${root.path}/pasted.txt')..writeAsStringSync('p');
      target(tester).onFiles(make(1, 'x'));
      tester
          .widget<ComposerDropSurface>(find.byType(ComposerDropSurface))
          .onDrop(
            ComposerDrag(
              path: dragged.path,
              directory: false,
              onGateway: false,
            ),
          );
      await tester.enterText(find.byKey(_composerKey), 'see ');
      await tester.pump();
      await Clipboard.setData(ClipboardData(text: pasted.path));
      await tester
          .state<EditableTextState>(
            find.descendant(
              of: find.byKey(_composerKey),
              matching: find.byType(EditableText),
            ),
          )
          .pasteText(SelectionChangedCause.toolbar);
      await _drain(tester);
      expect(_tileCount(), maxRemoteAttachmentDrafts);
      final text = _composer(tester);
      expect(text, anyOf('see ', 'see ${pasted.path}'));
      expect(sent, isEmpty);
    });
  });

  group('failure card Switch to', () {
    Map<String, dynamic> usageLimit({String? provider}) => {
      'message': 'Usage limit reached',
      'surface': {
        'layer': 'provider',
        'code': 'usage_window',
        'message': 'Usage limit reached',
        'usage_limit': {
          'suggestions': [
            {
              'model': 'gpt-5-mini',
              'label': 'GPT-5 mini',
              'provider': ?provider,
            },
          ],
        },
      },
    };

    ({ChatScreen screen, List<http.Request> writes}) chat(
      TestDesktopAsyncEventHook hook,
      String connId,
    ) {
      final writes = <http.Request>[];
      final screen = ChatScreen(
        connection: _conn(connId),
        session: _session,
        testApiClient: ApiClient(
          baseUrl: 'http://recheck.fixture',
          apiKey: 'fixture',
          httpClient: MockClient((request) async {
            if (request.method != 'GET') {
              writes.add(request);
              return http.Response(jsonEncode({'ok': true}), 200);
            }
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

    testWidgets('switches this chat to the suggested model, then runs the '
        'failed turn again; a newer draft stays', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final hook = TestDesktopAsyncEventHook();
      final c = chat(hook, 'switch-retry');
      await tester.pumpWidget(_app(c.screen));
      await pumpChatUpdates(tester);
      hook.handler!(
        StreamEvent(
          type: 'error',
          data: usageLimit(provider: 'openai'),
        ),
      );
      await pumpChatUpdates(tester);
      expect(find.byType(FailureRecoveryCard), findsOneWidget);
      await tester.enterText(find.byKey(_composerKey), 'my newer draft');
      await tester.pump();

      // This REST connection cannot re-run the turn: the card says so
      // before the switch (on the card and in its confirm), not after.
      const noRetry =
          "Switching changes the model only: this connection can't run the "
          'failed turn again. Send it again after switching.';
      expect(find.text(noRetry), findsOneWidget);
      await tester.tap(find.text('Switch to GPT-5 mini'));
      await pumpChatUpdates(tester);
      expect(
        find.text('Switch this chat to GPT-5 mini?\n\n$noRetry'),
        findsOneWidget,
      );
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(FilledButton, 'Switch model'),
        ),
      );
      await pumpChatUpdates(tester);

      final model = c.writes.singleWhere(
        (r) => r.url.path == '/api/sessions/recheck-parent/model',
      );
      expect(jsonDecode(model.body), {
        'provider': 'openai',
        'model': 'gpt-5-mini',
        'require_model_lock': true,
      });
      // Only the switch: no retry attempt, so no after-the-fact notice.
      expect(find.textContaining('Retry cannot replace a turn'), findsNothing);
      expect(c.writes, hasLength(1));
      expect(find.byType(FailureRecoveryCard), findsNothing);
      expect(_composer(tester), 'my newer draft');
    });

    testWidgets('a suggestion with no provider (and none known) opens the '
        'model picker and switches nothing', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final hook = TestDesktopAsyncEventHook();
      final c = chat(hook, 'switch-picker');
      await tester.pumpWidget(_app(c.screen));
      await pumpChatUpdates(tester);
      hook.handler!(StreamEvent(type: 'error', data: usageLimit()));
      await pumpChatUpdates(tester);
      await tester.tap(find.text('Switch to GPT-5 mini'));
      await pumpChatUpdates(tester);
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(FilledButton, 'Switch model'),
        ),
      );
      await pumpChatUpdates(tester);
      expect(c.writes, isEmpty);
      expect(find.textContaining('Retry cannot replace a turn'), findsNothing);
    });
  });

  // Every keyboard, text size, draft length and status combination: the
  // field and the send button sit above the keyboard and take taps.
  final longDraft = List.filled(14, 'a long draft line that wraps').join('\n');
  for (final keyboard in [260.0, 340.0]) {
    for (final scale in [1.0, 2.0]) {
      for (final long in [false, true]) {
        for (final status in [false, true]) {
          final name =
              'keyboard ${keyboard.toInt()} x$scale '
              '${long ? 'long' : 'short'} draft, status '
              '${status ? 'on' : 'off'}';
          testWidgets('Classic 320x640 $name: field and send above the '
              'keyboard and hit-testable', (tester) async {
            SharedPreferences.setMockInitialValues({
              'verbose_mode': true,
              if (status) 'composer_status_hidden_v1': <String>[],
            });
            tester.view.physicalSize = const Size(320, 640);
            tester.view.devicePixelRatio = 1.0;
            addTearDown(tester.view.reset);
            tester.platformDispatcher.textScaleFactorTestValue = scale;
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );
            final rpc = _Rpc()..categories = 20;
            final screen = ChatScreen(
              connection: _conn('kb-$name'),
              session: _session,
              testApiClient: ApiClient(
                baseUrl: 'http://recheck.fixture',
                apiKey: 'fixture',
                httpClient: MockClient(
                  (_) async => http.Response(jsonEncode({'data': []}), 200),
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
                onSent();
              }),
            );
            await tester.pumpWidget(_app(screen));
            await pumpChatUpdates(tester);
            tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
            await pumpChatUpdates(tester);
            await tester.enterText(
              find.byKey(_composerKey),
              long ? longDraft : 'steer this please',
            );
            await pumpChatUpdates(tester);
            final errors = <Object>[];
            Object? e;
            while ((e = tester.takeException()) != null) {
              errors.add(e!);
            }
            expect(errors, isEmpty);
            final top = 640 - keyboard;
            final field = tester.getRect(find.byKey(_composerKey));
            final send = tester.getRect(find.byTooltip('Send'));
            expect(field.top, greaterThanOrEqualTo(0));
            expect(field.bottom, lessThanOrEqualTo(top));
            expect(field.width, greaterThanOrEqualTo(80));
            expect(send.top, greaterThanOrEqualTo(0));
            expect(send.bottom, lessThanOrEqualTo(top));
            expect(find.byKey(_composerKey).hitTestable(), findsOneWidget);
            expect(find.byTooltip('Send').hitTestable(), findsOneWidget);
          });
        }
      }
    }
  }
}
