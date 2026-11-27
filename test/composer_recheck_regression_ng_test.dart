// Regressions from the independent re-check of v5/composer at a3437ec5,
// NextGen layout. Each failed at a3437ec5:
//   RNG6b two drops arriving before the first one finished both passed the
//         free-slot check: 9 drafts + 2 drops gave 11 (and a send carried
//         11 @file refs)
//   RNG6d pasting a local file path with no slot left removed the path and
//         staged nothing (the composer ended as 'see ')
//   paste caret: a staged path was removed at its first occurrence, not
//         where it was pasted
//   regenerate: every retry sent confirm_empty_truncate, not only a cut at
//         the first turn (Desktop's truncateSubmitParams)
//   keyboard: a long multi-line draft at 320x640, 2.0x text and a 260 px
//         keyboard put the field 128 px under the keyboard (185 px with
//         the status row on)
// Uses only public NextGen APIs and keys.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/composer_drag.dart';
import 'package:hermes_android/core/composer/composer_intake.dart';
import 'package:hermes_android/core/composer/os_intake.dart';
import 'package:hermes_android/core/services/attachment_draft_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/composer_drop_surface.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _fieldKey = ValueKey('ng-composer-field');

SavedConnection _connection() => SavedConnection(
  id: 'ng-recheck',
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
  WsClient current = WsClient('http://10.0.0.5:9119');

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
        return {'pairs': const <Object>[]};
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

Widget _app(_Gateway gateway, NgChatController chat, ConnectionManager m) =>
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
      home: NgScope(
        connManager: m,
        gateway: gateway,
        connections: [gateway.connection],
        switchTo: (_) async {},
        addGateway: () async {},
        signOut: (_) async {},
        reload: () async {},
        signInAgain: () async {},
        child: Scaffold(
          body: NgChatView(chat: chat, onOpenSidebar: () {}, onNewChat: () {}),
        ),
      ),
    );

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

String _composer(WidgetTester tester) =>
    tester.widget<TextField>(find.byKey(_fieldKey)).controller!.text;

class _Paths extends PathProviderPlatform {
  _Paths(this.dir);
  final Directory dir;
  @override
  Future<String?> getTemporaryPath() async => dir.path;
}

/// Lets real file I/O finish and render without moving the clock. Stops a
/// few quiet rounds after [done] holds.
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

  Future<({_Gateway gateway, NgChatController chat})> pump(
    WidgetTester tester, {
    double textScale = 1.0,
    bool running = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final httpClient = MockClient(
      (request) async => http.Response(
        jsonEncode({'messages': const <Object>[]}),
        200,
        headers: {'content-type': 'application/json'},
      ),
    );
    final gateway = _Gateway(
      DashboardClient(host: '10.0.0.5', proxied: true, httpClient: httpClient),
    );
    final chat = NgChatController(gateway, sessionId: 'stored-1')
      ..runtimeId = 'rt-1'
      ..running = running;
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    if (textScale != 1.0) {
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    }
    await tester.pumpWidget(_app(gateway, chat, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    return (gateway: gateway, chat: chat);
  }

  test('a paste is found at its caret, else at the copy nearest to it', () {
    const chunk = PastedChunk('/p/x.txt', 'see  and ', 4);
    expect(chunk.offsetIn('see /p/x.txt and '), 4);
    // An earlier copy typed by hand is not the paste.
    const moved = PastedChunk('/p/x.txt', '/p/x.txt and ', 13);
    expect(moved.offsetIn('/p/x.txt and /p/x.txt'), 13);
    // Typing before the paste moved it: the nearest copy, not the first.
    expect(moved.offsetIn('/p/x.txt and so /p/x.txt'), 16);
    expect(moved.offsetIn('nothing pasted'), -1);
    expect(moved.removeFrom('/p/x.txt and /p/x.txt')!.text, '/p/x.txt and ');
  });

  // A regenerate is Desktop's runReload -> runRewindSubmit: the resolved row
  // is the cut and every such submit carries confirm_empty_truncate
  // (rewind.ts:361-369), first turn or later.
  for (final first in [true, false]) {
    testWidgets('a regenerate sends runRewindSubmit\'s params: the row and '
        'confirm_empty_truncate (${first ? 'first' : 'a later'} turn)', (
      tester,
    ) async {
      final h = await pump(tester);
      StreamEvent ev(String type, Map<String, dynamic> data) =>
          StreamEvent(type: type, data: data, sessionId: 'rt-1');
      h.gateway.handlers['session.history'] = (p) => {
        'messages': [
          if (!first) ...[
            {'role': 'user', 'text': 'older', 'row_id': 3},
            {'role': 'assistant', 'text': 'reply', 'row_id': 4},
          ],
          {'role': 'user', 'text': 'hello there', 'row_id': 7},
        ],
      };
      h.gateway.handlers['session.interrupt'] = (p) {
        h.gateway.debugEmit(ev('message.complete', {'status': 'interrupted'}));
        return {'status': 'ok'};
      };
      await tester.enterText(find.byKey(_fieldKey), 'hello there');
      await _settle(tester);
      await tester.tap(find.byTooltip('Send'));
      await _settle(tester);
      h.gateway.debugEmit(ev('message.start', {}));
      await _settle(tester);
      final retry = h.chat.retryLast();
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(await retry, NgRetryResult.regenerated);
      final submit = h.gateway.of('prompt.submit').last.params;
      expect(submit['confirm_truncate'], isTrue);
      expect(submit['truncate_before_row_id'], 7);
      expect(submit.containsKey('truncate_before_user_ordinal'), isFalse);
      expect(submit['confirm_empty_truncate'], isTrue);
    });
  }

  group('intake limits', () {
    late Directory root;
    late PathProviderPlatform previousPaths;
    setUp(() {
      root = Directory.systemTemp.createTempSync('ng-recheck');
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

    List<OsIntakeFile> make(int count, String prefix) => [
      for (var i = 0; i < count; i++)
        OsIntakeFile(
          (File('${root.path}/$prefix$i.txt')..writeAsStringSync('n$i')).path,
        ),
    ];

    OsFileDropTarget target(WidgetTester tester) =>
        tester.widget<OsFileDropTarget>(find.byType(OsFileDropTarget));

    Future<void> pasteAtCaret(
      WidgetTester tester,
      String before,
      String pasted,
    ) async {
      await tester.enterText(find.byKey(_fieldKey), before);
      await _settle(tester);
      await Clipboard.setData(ClipboardData(text: pasted));
      final editable = find.descendant(
        of: find.byKey(_fieldKey),
        matching: find.byType(EditableText),
      );
      await tester
          .state<EditableTextState>(editable)
          .pasteText(SelectionChangedCause.toolbar);
      await _settle(tester);
    }

    testWidgets('RNG6b two overlapping drops with one slot left give '
        'maxRemoteAttachmentDrafts, and the send carries no more', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(4000, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final h = await pump(tester);
      target(tester).onFiles(make(maxRemoteAttachmentDrafts - 1, 'b'));
      await _drain(
        tester,
        done: () => _chips().length >= maxRemoteAttachmentDrafts - 1,
      );
      expect(_chips(), hasLength(maxRemoteAttachmentDrafts - 1));
      final more = make(2, 'c');
      // Back to back: the second arrives before the first is prepared.
      target(tester).onFiles([more[0]]);
      target(tester).onFiles([more[1]]);
      await _drain(tester);
      expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
      expect(h.gateway.of('prompt.submit'), isEmpty);
      h.gateway.handlers['file.attach'] = (p) => {
        'attached': true,
        'ref_text': '@file:/up/${p['name']}',
      };
      await tester.enterText(find.byKey(_fieldKey), 'go');
      await _settle(tester);
      await tester.tap(find.byTooltip('Send'));
      await _drain(
        tester,
        done: () => h.gateway.of('prompt.submit').isNotEmpty,
      );
      final submit = h.gateway.of('prompt.submit').single;
      expect(h.gateway.of('file.attach'), hasLength(maxRemoteAttachmentDrafts));
      expect(
        RegExp('@file:').allMatches(submit.params['text'].toString()).length,
        maxRemoteAttachmentDrafts,
      );
    });

    testWidgets('a drop, an in-app drag and a pasted path at once share the '
        'last slot: exactly one is staged', (tester) async {
      tester.view.physicalSize = const Size(4000, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await pump(tester);
      target(tester).onFiles(make(maxRemoteAttachmentDrafts - 1, 'm'));
      await _drain(
        tester,
        done: () => _chips().length >= maxRemoteAttachmentDrafts - 1,
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
      await pasteAtCaret(tester, 'see ', pasted.path);
      await _drain(tester);
      expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
      // Only a staged path leaves the text: whichever lost keeps its text.
      final staged = _chips().contains('pasted.txt');
      expect(_composer(tester), staged ? 'see ' : 'see ${pasted.path}');
    });

    testWidgets('RNG6d pasting a local file path when no slot is left keeps '
        'the pasted text', (tester) async {
      tester.view.physicalSize = const Size(4000, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await pump(tester);
      target(tester).onFiles(make(maxRemoteAttachmentDrafts, 'd'));
      await _drain(
        tester,
        done: () => _chips().length >= maxRemoteAttachmentDrafts,
      );
      final extra = File('${root.path}/extra.txt')..writeAsStringSync('x');
      await pasteAtCaret(tester, 'see ', extra.path);
      await _drain(tester);
      expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
      expect(_composer(tester), 'see ${extra.path}');
    });

    testWidgets('a staged pasted path leaves at the caret, not at an earlier '
        'copy of the same text', (tester) async {
      await pump(tester);
      final file = File('${root.path}/same.txt')..writeAsStringSync('s');
      await pasteAtCaret(tester, 'was ${file.path} now ', file.path);
      await _drain(tester, done: () => _chips().isNotEmpty);
      expect(_chips(), ['same.txt']);
      expect(_composer(tester), 'was ${file.path} now ');
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
          testWidgets('NextGen 320x640 $name: field and send above the '
              'keyboard and hit-testable', (tester) async {
            SharedPreferences.setMockInitialValues({
              if (status) 'composer_status_hidden_v1': <String>[],
            });
            tester.view.physicalSize = const Size(320, 640);
            tester.view.devicePixelRatio = 1.0;
            addTearDown(tester.view.reset);
            final h = await pump(tester, textScale: scale);
            h.gateway.handlers['session.context_breakdown'] = (p) => {
              'categories': [
                for (var i = 0; i < 20; i++)
                  {
                    'id': 'c$i',
                    'label': 'Category number $i',
                    'tokens': 900 * (i + 1),
                    'color': '#888888',
                  },
              ],
              'context_max': 200000,
              'context_used': 189000,
              'context_percent': 94,
            };
            tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
            await tester.enterText(
              find.byKey(_fieldKey),
              long ? longDraft : 'steer this please',
            );
            await _settle(tester);
            final errors = <Object>[];
            Object? e;
            while ((e = tester.takeException()) != null) {
              errors.add(e!);
            }
            expect(errors, isEmpty);
            final top = 640 - keyboard;
            final field = tester.getRect(find.byKey(_fieldKey));
            final send = tester.getRect(find.byTooltip('Send'));
            expect(field.top, greaterThanOrEqualTo(0));
            expect(field.bottom, lessThanOrEqualTo(top));
            expect(field.width, greaterThanOrEqualTo(80));
            expect(send.top, greaterThanOrEqualTo(0));
            expect(send.bottom, lessThanOrEqualTo(top));
            expect(find.byKey(_fieldKey).hitTestable(), findsOneWidget);
            expect(find.byTooltip('Send').hitTestable(), findsOneWidget);
            expect(find.byTooltip('Attach').hitTestable(), findsOneWidget);
          });
        }
      }
    }
  }

  // The re-check's own shape: a running turn, status on via the Attach
  // menu, the breakdown open.
  for (final v in [
    'V1-no-status-long',
    'V2-status-long',
    'V3-status-short-expanded',
    'V4-status-long-expanded',
  ]) {
    testWidgets('RNG5 $v 320x640 x2.0 keyboard 260, running: composer above '
        'the keyboard, no overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final h = await pump(tester, textScale: 2.0);
      h.gateway.handlers['session.context_breakdown'] = (p) => {
        'categories': [
          for (var i = 0; i < 20; i++)
            {
              'id': 'c$i',
              'label': 'Category number $i',
              'tokens': 900 * (i + 1),
              'color': '#888888',
            },
        ],
        'context_max': 200000,
        'context_used': 189000,
        'context_percent': 94,
      };
      final status = !v.startsWith('V1');
      final long = v.contains('long');
      if (status) {
        await tester.tap(find.byTooltip('Attach'));
        await _settle(tester);
        final st = find.byKey(const ValueKey('ng-composer-status'));
        await tester.ensureVisible(st);
        await _settle(tester);
        await tester.tap(st);
        await _settle(tester);
        final ctx = find.byKey(const ValueKey('composer-status-context-usage'));
        await tester.ensureVisible(ctx);
        await _settle(tester);
        await tester.tap(ctx);
        await _settle(tester);
        await tester.tapAt(const Offset(5, 5));
        await _settle(tester);
        if (v.contains('expanded')) {
          await tester.tap(
            find.byKey(const ValueKey('composer-context-breakdown-toggle')),
          );
          await _settle(tester);
          expect(
            find.byKey(const ValueKey('composer-context-breakdown')),
            findsOneWidget,
          );
        }
      }
      h.chat.running = true;
      h.chat.turnStartedAt = DateTime.now();
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await tester.enterText(
        find.byKey(_fieldKey),
        long
            ? 'a long steer line that wraps over several lines at this size'
            : 'steer this please',
      );
      await _settle(tester);
      final errors = <Object>[];
      Object? e;
      while ((e = tester.takeException()) != null) {
        errors.add(e!);
      }
      expect(errors, isEmpty);
      final field = tester.getRect(find.byKey(_fieldKey));
      expect(field.width, greaterThanOrEqualTo(80));
      expect(field.bottom, lessThanOrEqualTo(640 - 260));
      expect(field.top, greaterThanOrEqualTo(0));
      expect(find.byKey(_fieldKey).hitTestable(), findsOneWidget);
      final send = tester.getRect(find.byTooltip('Send'));
      expect(send.bottom, lessThanOrEqualTo(640 - 260));
    });
  }
}
