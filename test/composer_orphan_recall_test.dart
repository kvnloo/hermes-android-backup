import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/chat_presentation_state.dart';
import 'package:hermes_android/core/services/composer_draft_store.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
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
import 'support/pump_chat_updates.dart';

class _Reads {
  final checks = <String>[];
  final rows = [
    {'id': 1, 'role': 'user', 'content': 'first'},
    {'id': 2, 'role': 'assistant', 'content': 'not a prompt'},
    {'id': 3, 'role': 'user', 'content': 'second'},
  ];
  Completer<http.Response>? pending;
  http.Response missing() => http.Response(
    '{"error":{"code":"session_not_found","message":"Gone"}}',
    404,
  );
  Future<http.Response> answer(String path) async {
    if (path.endsWith('/messages')) {
      return http.Response(
        jsonEncode({'data': path.contains('gone') ? rows : []}),
        200,
      );
    }
    if (path.endsWith('/gone')) {
      checks.add(path);
      return pending?.future ?? missing();
    }
    return http.Response('{}', 200);
  }
}

class _Dashboard extends DashboardClient {
  _Dashboard(this.reads)
    : super(
        host: 'fixture.invalid',
        httpClient: MockClient((_) async => http.Response('{}', 200)),
      );
  final _Reads reads;
  @override
  Future<http.Response> apiRequest(
    String method,
    String endpoint, {
    Object? body,
    Map<String, String>? queryParameters,
    Duration timeout = ApiClient.requestTimeout,
    bool retried = false,
    bool Function()? maySend,
  }) {
    expectSync(method, 'GET');
    return reads.answer(endpoint);
  }
}

class _Gateway extends NextGenGateway {
  _Gateway(super.connection, _Reads reads)
    : super(dashboard: _Dashboard(reads));
  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    expectSync(method, isNot('prompt.submit'));
    return {};
  }
}

class _Routes {
  _Routes(this.ng, this.tester);
  final bool ng;
  final WidgetTester tester;
  final conn = SavedConnection(
    id: 'drafts',
    label: 'fixture',
    host: 'fixture.invalid',
    port: 8642,
    apiKey: '',
  );
  final reads = _Reads();
  late final gateway = _Gateway(conn, reads);
  final owner = GatewayTurnApplicationController();
  final chats = <NgChatController>[];
  Finder get field =>
      find.byKey(Key(ng ? 'ng-composer-field' : 'chat-message-composer'));
  String get text => tester.widget<TextField>(field).controller!.text;
  String currentKey = '';
  Future<void> frames() async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
  }

  Future<void> open(String id, {bool fresh = false}) async {
    currentKey = id;
    late final Widget home;
    if (ng) {
      final chat = NgChatController(gateway, sessionId: fresh ? null : id);
      if (!fresh) {
        chat.items.addAll([
          NgUserItem('1', 'first'),
          NgAssistantItem('2')..text = 'not a prompt',
          NgUserItem('3', 'second'),
        ]);
      }
      currentKey = chat.draftKey;
      chats.add(chat);
      home = NgScope(
        connManager: ConnectionManager(await SharedPreferences.getInstance()),
        gateway: gateway,
        connections: [conn],
        switchTo: (_) async {},
        addGateway: () async {},
        signOut: (_) async {},
        reload: () async {},
        signInAgain: () async {},
        child: NgChatView(
          key: ObjectKey(chat),
          chat: chat,
          onOpenSidebar: () {},
          onNewChat: () {},
        ),
      );
    } else {
      home = ChatScreen(
        key: ValueKey(id),
        connection: conn,
        turnApplicationController: owner,
        testApiClient: ApiClient(
          baseUrl: conn.baseUrl,
          apiKey: '',
          httpClient: MockClient((req) async {
            expectSync(req.method, 'GET');
            return reads.answer(req.url.path);
          }),
        ),
        session: Session(
          id: id,
          title: id,
          model: 'fixture',
          source: 'test',
          messageCount: 0,
          isActive: true,
          preview: '',
          startedAt: 1,
          isLocalDraft: fresh,
        ),
      );
    }
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ng ? nextGenTheme(Brightness.light, NextGenLook.instance) : null,
        home: home,
      ),
    );
    await frames();
  }

  Future<void> pick() async {
    await tester.tap(find.text('Recover a text draft'));
    await frames();
    await tester.tap(find.text('gone').last);
    await frames();
  }

  Future<void> seed() async {
    await open('gone');
    await tester.enterText(field, '  keep me\n');
    await open('fresh', fresh: true);
    expect(text, isEmpty);
  }

  Future<void> close() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await frames();
    for (final chat in chats) {
      chat.dispose();
    }
    if (ng) gateway.dispose();
    await owner.close();
  }
}

void main() {
  setUp(mockChatImageRecovery);
  setUp(() => SharedPreferences.setMockInitialValues({'verbose_mode': false}));
  for (final ng in [false, true]) {
    final shell = ng ? 'NextGen' : 'Classic';
    testWidgets(
      '$shell: Up/Down recalls only sent prompts and leaves editing alone',
      (tester) async {
        final r = _Routes(ng, tester);
        await r.open('gone');
        await tester.tap(r.field);
        for (final entry in [
          (LogicalKeyboardKey.arrowUp, 'second'),
          (LogicalKeyboardKey.arrowUp, 'first'),
          (LogicalKeyboardKey.arrowDown, 'second'),
          (LogicalKeyboardKey.arrowDown, ''),
        ]) {
          await tester.sendKeyEvent(entry.$1);
          await tester.pump();
          expect(r.text, entry.$2);
        }
        await tester.enterText(r.field, 'new\ntext');
        await tester.pump();
        expect(r.text, 'new\ntext');
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        expect(r.text, 'new\ntext');
        await r.close();
      },
    );
    testWidgets(
      '$shell: only exact terminal absence permits copying; Undo keeps source',
      (tester) async {
        final r = _Routes(ng, tester);
        await r.seed();
        for (final reply in [
          http.Response('Not Found', 404),
          http.Response(
            '{"error":{"code":"proxy_failure","message":"session not found"}}',
            404,
          ),
          http.Response('unavailable', 503),
          http.Response('{"session":{"id":"gone"}}', 200),
        ]) {
          r.reads.pending = Completer()..complete(reply);
          await r.pick();
          expect(r.text, isEmpty);
          expect(find.text('Undo'), findsNothing);
        }
        r.reads.pending = null;
        await r.pick();
        expect(r.text, '  keep me\n');
        expect(
          await ComposerDraftStore.read(
            connectionId: 'drafts',
            sessionId: r.currentKey,
          ),
          '  keep me\n',
        );
        await tester.tap(find.text('Undo'));
        await r.frames();
        expect(r.text, isEmpty);
        expect(
          await ComposerDraftStore.read(
            connectionId: 'drafts',
            sessionId: 'gone',
          ),
          '  keep me\n',
        );
        expect(
          await ComposerDraftStore.read(
            connectionId: 'drafts',
            sessionId: r.currentKey,
          ),
          isNull,
        );
        await r.pick();
        final staleUndo = tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Undo'))
            .onPressed!;
        await tester.enterText(r.field, 'new edit');
        await tester.enterText(r.field, '  keep me\n');
        staleUndo();
        await r.frames();
        expect(
          r.text,
          '  keep me\n',
          reason: 'equal bytes are not the recovered revision',
        );
        expect(find.text('Undo'), findsNothing);
        await r.close();
      },
    );
    testWidgets(
      '$shell: typed-then-cleared, replacement and account ABA fence held proof',
      (tester) async {
        final r = _Routes(ng, tester);
        await r.seed();
        for (final race in ['clear', 'replace', 'account']) {
          final gate = r.reads.pending = Completer();
          final before = r.reads.checks.length;
          await r.pick();
          expect(r.reads.checks.length, before + 1);
          if (race == 'clear') {
            await tester.enterText(r.field, 'intervening');
            await tester.enterText(r.field, '');
          } else if (race == 'replace') {
            await r.open('replacement', fresh: true);
          } else {
            ConnectionMutationBarrier.begin([r.conn.id]).release();
          }
          gate.complete(r.reads.missing());
          await r.frames();
          expect(r.text, isEmpty);
          expect(find.text('Undo'), findsNothing);
        }
        await r.close();
      },
    );
  }
  testWidgets(
    'NextGen cold restart: each never-sent draft keeps its own local key',
    (tester) async {
      final first = _Routes(true, tester);
      await first.open('a', fresh: true);
      final a = first.currentKey;
      await tester.enterText(first.field, 'unsent A');
      await first.open('b', fresh: true);
      final b = first.currentKey;
      expect(b, isNot(a));
      expect(first.text, isEmpty);
      await tester.enterText(first.field, 'unsent B');
      await first.close();
      final prefs = await SharedPreferences.getInstance();
      SharedPreferences.setMockInitialValues({
        for (final key in prefs.getKeys()) key: prefs.get(key)!,
      });
      final second = _Routes(true, tester);
      await second.open('new', fresh: true);
      await tester.tap(find.text('Recover a text draft'));
      await second.frames();
      expect(find.textContaining(b.substring(b.length - 8)), findsOneWidget);
      await tester.tap(find.textContaining(a.substring(a.length - 8)));
      await second.frames();
      expect(second.text, 'unsent A');
      expect(second.reads.checks, isEmpty);
      await second.close();
    },
  );
  test(
    'candidate provenance excludes another account, alias source and unscoped legacy draft',
    () async {
      SavedConnection account(String host, String profile) => SavedConnection(
        id: 'same',
        label: 'test',
        host: host,
        port: 443,
        apiKey: '',
        gatewayProfile: profile,
      );
      final a = ChatPresentationRegistry.forConnection(
        account('host-a', 'work'),
      );
      final source = a.chatFor('local').openWriter()..edit('alpha');
      await source.close();
      a.bind('local', 'stored');
      final target = a.chatFor('dest').openWriter().draftHandle;
      await ComposerDraftStore.save(
        connectionId: a.connectionId,
        sessionId: 'legacy',
        text: 'unstamped',
      );
      expect(await ComposerDraftStore.recoveryCandidates(target), ['stored']);
      final lookalike = ComposerDraftStore.newLocalKey();
      final remote = a.chatFor(lookalike).openWriter()..edit('stored row');
      await remote.close();
      expect(await ComposerDraftStore.recoveryText(target, lookalike), isNull);
      for (final other in [
        account('host-b', 'work'),
        account('host-a', 'home'),
      ]) {
        final b = ChatPresentationRegistry.forConnection(other);
        final t = b.chatFor('dest').openWriter().draftHandle;
        expect(await ComposerDraftStore.recoveryCandidates(t), isEmpty);
        expect(await ComposerDraftStore.recoveryText(t, 'stored'), isNull);
        b.close();
      }
      a.close();
    },
  );
}
