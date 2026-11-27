import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/classic_parallel_chat_pane.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/widgets/hermes_shell.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/parallel_chat_pane.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/parallel_workspace_fixture.dart';
import 'support/presence_socket.dart';

/// The workspace gateway with a socket whose gateway accepts presence.
class _PresenceGateway extends ParallelFixtureGateway {
  _PresenceGateway(super.f);
  final presence = PresenceSocket(capable: true);
  @override
  WsClient? get socket => presence;
}

/// A loopback gateway that accepts presence and records every report with
/// the real time it arrived.
class _PresenceServer {
  _PresenceServer(this.server);
  final HttpServer server;
  final sockets = <WebSocket>[];
  final resumes = <String>[];
  final reports = <Map<String, dynamic>>[];
  final at = <Duration>[];
  final clock = Stopwatch()..start();

  SavedConnection get connection => SavedConnection(
    id: 'presence-wire',
    label: 'Fixture',
    host: '127.0.0.1',
    port: server.port,
    apiKey: 'fixture',
    dashboardPortOverride: server.port,
    dashboardProxied: true,
  );

  static Future<_PresenceServer> start() async {
    final owner = _PresenceServer(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    owner.server.listen(owner._handle);
    return owner;
  }

  /// Reports as a [PresenceSocket] log, for the shared oracle.
  PresenceSocket get log {
    final socket = PresenceSocket();
    socket.reports.addAll(reports);
    socket.at.addAll(at);
    return socket;
  }

  Future<void> _handle(HttpRequest request) async {
    final path = request.uri.path;
    if (path == '/api/auth/ws-ticket') {
      request.response.headers.contentType = ContentType.json;
      request.response.write('{"ticket":"fixture"}');
    } else if (path.endsWith('/messages') || path.endsWith('/sessions')) {
      request.response.headers.contentType = ContentType.json;
      request.response.write('{"data":[]}');
    } else if (path == '/api/ws') {
      final socket = await WebSocketTransformer.upgrade(request);
      sockets.add(socket);
      socket.add(
        jsonEncode({
          'jsonrpc': '2.0',
          'method': 'event',
          'params': {'type': 'gateway.ready', 'payload': {}},
        }),
      );
      socket.listen((raw) => _frame(socket, jsonDecode(raw as String) as Map));
      return;
    } else {
      request.response.statusCode = 404;
    }
    await request.response.close();
  }

  void _frame(WebSocket socket, Map frame) {
    final method = frame['method'];
    if (method == null) return;
    final params = Map<String, dynamic>.from(frame['params'] as Map? ?? {});
    final result = switch (method) {
      'client.capabilities' => {'client_activity': true},
      'config.get' => {'config': <String, dynamic>{}},
      'session.resume' => () {
        final id = params['session_id'] as String;
        resumes.add(id);
        return {
          'session_id': 'runtime-$id',
          'stored_session_id': id,
          'running': false,
          'status': 'idle',
        };
      }(),
      'client.activity' => () {
        reports.add(params);
        at.add(clock.elapsed);
        return <String, dynamic>{};
      }(),
      _ => {'ok': true},
    };
    if (socket.readyState == WebSocket.open) {
      socket.add(
        jsonEncode({'jsonrpc': '2.0', 'id': frame['id'], 'result': result}),
      );
    }
  }

  Future<void> close() async {
    for (final socket in sockets) {
      await socket.close();
    }
    await server.close(force: true);
  }
}

Future<void> _until(WidgetTester tester, bool Function() condition) async {
  for (var i = 0; i < 500; i++) {
    await tester.pump(const Duration(milliseconds: 10));
    if (condition()) return;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
  }
  fail('wire fixture condition did not arrive');
}

void main() {
  HttpOverrides? previous;
  setUp(() {
    notificationPrefs.value = NotificationPrefs.defaults;
    previous = HttpOverrides.current;
    HttpOverrides.global = null;
  });
  tearDown(() {
    notificationPrefs.value = NotificationPrefs.defaults;
    HttpOverrides.global = previous;
  });

  testWidgets(
    'Classic parallel panes on one application socket claim only the newest input pane',
    (tester) async {
      SharedPreferences.setMockInitialValues({'verbose_mode': true});
      await NotificationPrefsStore.setShareWindowActivity(true);
      const picker = MethodChannel('plugins.flutter.io/image_picker');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        picker,
        (_) async => null,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          picker,
          null,
        ),
      );
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1600, 940);
      addTearDown(tester.view.reset);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      final server = (await tester.runAsync(_PresenceServer.start))!;
      final controller = GatewayTurnApplicationController();
      Session session(String id) => Session(
        id: id,
        title: 'Pane $id',
        model: 'fixture',
        source: 'test',
        messageCount: 0,
        isActive: false,
        preview: '',
        startedAt: 1,
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Row(
            children: [
              for (final id in ['alpha', 'beta'])
                Expanded(
                  child: ClassicParallelChatPane(
                    connection: server.connection,
                    session: session(id),
                    controller: controller,
                    close: () {},
                  ),
                ),
            ],
          ),
        ),
      );
      await _until(tester, () => server.resumes.length >= 2);
      Finder pane(String id) => find.byWidgetPredicate(
        (w) => w is ClassicParallelChatPane && w.session.id == id,
      );
      await tester.tap(pane('beta'));
      await tester.pump();
      await waitRealSeconds(tester, 3);
      await tester.tap(pane('alpha'));
      await tester.pump();
      await waitRealSeconds(tester, 61);
      expectNewestPaneOnly(
        server.log,
        older: 'runtime-beta',
        newer: 'runtime-alpha',
      );
      await tester.pumpWidget(const SizedBox());
      await _until(
        tester,
        () => (server.reports.last['sessions'] as List).isEmpty,
      );
      await controller.close();
      await tester.runAsync(server.close);
      await tester.pump(const Duration(seconds: 16));
    },
  );

  testWidgets(
    'NextGen parallel panes on one gateway socket claim only the newest input pane',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await NotificationPrefsStore.setShareWindowActivity(true);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1500, 920);
      addTearDown(tester.view.reset);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      final manager = ConnectionManager(await SharedPreferences.getInstance());
      final fixture = ParallelFixture(dashboard: true, profile: 'pane-test');
      final g = _PresenceGateway(fixture);
      addTearDown(g.dispose);
      final rows = (await g.api.getSessionsPage()).sessions;
      await tester.pumpWidget(
        MaterialApp(
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NgScope(
            connManager: manager,
            gateway: g,
            connections: [fixture.connection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: Row(
              children: [
                for (final row in rows)
                  Expanded(
                    child: NgParallelChatPane(
                      gateway: g,
                      session: row,
                      close: () {},
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(g.resumes, unorderedEquals(['alpha', 'beta']));
      Finder pane(String id) => find.byWidgetPredicate(
        (w) => w is NgParallelChatPane && w.session.id == id,
      );
      await tester.tap(pane('beta'));
      await tester.pump();
      await waitRealSeconds(tester, 3);
      await tester.tap(pane('alpha'));
      await tester.pump();
      await waitRealSeconds(tester, 61);
      expectNewestPaneOnly(
        g.presence,
        older: 'runtime-beta',
        newer: 'runtime-alpha',
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(g.presence.reports.last['sessions'], isEmpty);
    },
  );

  testWidgets('NextGen composer typing claims the pane without a pointer', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await NotificationPrefsStore.setShareWindowActivity(true);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final manager = ConnectionManager(await SharedPreferences.getInstance());
    final fixture = ParallelFixture(dashboard: true, profile: 'pane-test');
    final g = _PresenceGateway(fixture);
    addTearDown(g.dispose);
    final rows = (await g.api.getSessionsPage()).sessions;
    await tester.pumpWidget(
      MaterialApp(
        theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: NgScope(
          connManager: manager,
          gateway: g,
          connections: [fixture.connection],
          switchTo: (_) async {},
          addGateway: () async {},
          signOut: (_) async {},
          reload: () async {},
          signInAgain: () async {},
          child: NgParallelChatPane(
            gateway: g,
            session: rows.first,
            close: () {},
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(g.presence.reports, isEmpty);
    await tester.showKeyboard(find.byKey(const ValueKey('ng-composer-field')));
    await tester.pump();
    final claims = g.presence.reports.length;
    expect(claims, 1, reason: 'focusing the composer is input');
    tester.testTextInput.enterText('typed on a phone');
    await tester.pump();
    expect(g.presence.reports.single['sessions'], ['runtime-${rows.first.id}']);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Classic composer typing claims the pane without a pointer', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'verbose_mode': true});
    await NotificationPrefsStore.setShareWindowActivity(true);
    const picker = MethodChannel('plugins.flutter.io/image_picker');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      picker,
      (_) async => null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        picker,
        null,
      ),
    );
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final server = (await tester.runAsync(_PresenceServer.start))!;
    final controller = GatewayTurnApplicationController();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ClassicParallelChatPane(
          connection: server.connection,
          session: Session(
            id: 'alpha',
            title: 'Pane alpha',
            model: 'fixture',
            source: 'test',
            messageCount: 0,
            isActive: false,
            preview: '',
            startedAt: 1,
          ),
          controller: controller,
          close: () {},
        ),
      ),
    );
    await _until(tester, () => server.resumes.isNotEmpty);
    expect(server.reports, isEmpty);
    final composer = find.byKey(const Key('chat-message-composer'));
    await tester.showKeyboard(composer);
    await _until(tester, () => server.reports.isNotEmpty);
    tester.testTextInput.enterText('typed on a phone');
    await tester.pump();
    expect(server.reports.single['sessions'], ['runtime-alpha']);
    await tester.pumpWidget(const SizedBox());
    await _until(
      tester,
      () => (server.reports.last['sessions'] as List).isEmpty,
    );
    await controller.close();
    await tester.runAsync(server.close);
    await tester.pump(const Duration(seconds: 16));
  });

  // Review re-check of 5eedcb09: input at t=0, nothing for 63 s, input
  // again. The claim at t=45 still named the same session, so the fresh
  // input waited for the next 45 s refresh (t=90) while the gateway had aged
  // the t=0 input out at t=60. a8108fc9 and Desktop claim it at once.
  testWidgets(
    'NextGen: input after an idle spell is claimed at once, not at the next refresh',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await NotificationPrefsStore.setShareWindowActivity(true);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      final manager = ConnectionManager(await SharedPreferences.getInstance());
      final fixture = ParallelFixture(dashboard: true, profile: 'pane-test');
      final g = _PresenceGateway(fixture);
      addTearDown(g.dispose);
      final rows = (await g.api.getSessionsPage()).sessions;
      await tester.pumpWidget(
        MaterialApp(
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NgScope(
            connManager: manager,
            gateway: g,
            connections: [fixture.connection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: NgParallelChatPane(
              gateway: g,
              session: rows.first,
              close: () {},
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final session = 'runtime-${rows.first.id}';
      final pane = find.byType(NgParallelChatPane);
      await tester.tap(pane);
      await tester.pump();
      expect(g.presence.reports.single['sessions'], [session]);
      await waitRealSeconds(tester, 63);
      final since = g.presence.clock.elapsed;
      await tester.tap(pane);
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)),
      );
      await tester.pump();
      expectClaimedAtOnce(g.presence, since: since, session: session);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(g.presence.reports.last['sessions'], isEmpty);
    },
  );

  testWidgets(
    'Classic: input after an idle spell is claimed at once, not at the next refresh',
    (tester) async {
      SharedPreferences.setMockInitialValues({'verbose_mode': true});
      await NotificationPrefsStore.setShareWindowActivity(true);
      const picker = MethodChannel('plugins.flutter.io/image_picker');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        picker,
        (_) async => null,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          picker,
          null,
        ),
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      final server = (await tester.runAsync(_PresenceServer.start))!;
      final controller = GatewayTurnApplicationController();
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ClassicParallelChatPane(
            connection: server.connection,
            session: Session(
              id: 'alpha',
              title: 'Pane alpha',
              model: 'fixture',
              source: 'test',
              messageCount: 0,
              isActive: false,
              preview: '',
              startedAt: 1,
            ),
            controller: controller,
            close: () {},
          ),
        ),
      );
      await _until(tester, () => server.resumes.isNotEmpty);
      final pane = find.byType(ClassicParallelChatPane);
      await tester.tap(pane);
      await _until(tester, () => server.reports.isNotEmpty);
      expect(server.reports.single['sessions'], ['runtime-alpha']);
      await waitRealSeconds(tester, 63);
      final since = server.clock.elapsed;
      final before = server.reports.length;
      await tester.tap(pane);
      await tester.pump();
      // Wire round trip, bounded: the oracle checks the arrival time.
      for (var i = 0; i < 15 && server.reports.length == before; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 100)),
        );
        await tester.pump();
      }
      expectClaimedAtOnce(server.log, since: since, session: 'runtime-alpha');
      await tester.pumpWidget(const SizedBox());
      await _until(
        tester,
        () => (server.reports.last['sessions'] as List).isEmpty,
      );
      await controller.close();
      await tester.runAsync(server.close);
      await tester.pump(const Duration(seconds: 16));
    },
  );

  // Review re-check of 5eedcb09: the Classic shell keeps a visited
  // destination mounted in an IndexedStack with its tickers running, so the
  // chat embedded in the wide Chats pane kept its claim after the user chose
  // Activity. (NextGen opens its destinations as pushed routes, which the
  // pushed-route test covers.)
  testWidgets(
    'Classic: a chat in a hidden Chats pane withdraws at once and is claimed again on input',
    (tester) async {
      SharedPreferences.setMockInitialValues({'verbose_mode': true});
      await NotificationPrefsStore.setShareWindowActivity(true);
      const picker = MethodChannel('plugins.flutter.io/image_picker');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        picker,
        (_) async => null,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          picker,
          null,
        ),
      );
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1400, 900);
      addTearDown(tester.view.reset);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      final server = (await tester.runAsync(_PresenceServer.start))!;
      final controller = GatewayTurnApplicationController();
      final shell = GlobalKey<HermesShellState>();
      // One connection object, as in the app: the pane is keyed by it, and a
      // new one per build would remount the chat instead of hiding it.
      final connection = server.connection;
      final session = Session(
        id: 'alpha',
        title: 'Pane alpha',
        model: 'fixture',
        source: 'test',
        messageCount: 0,
        isActive: false,
        preview: '',
        startedAt: 1,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: hermesTheme(Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HermesShell(
            key: shell,
            builder: (context, destination) =>
                destination == HermesDestination.chats
                ? ClassicParallelChatPane(
                    connection: connection,
                    session: session,
                    controller: controller,
                    close: () {},
                  )
                : Center(child: Text(destination.name)),
          ),
        ),
      );
      await _until(tester, () => server.resumes.isNotEmpty);
      final pane = find.byType(ClassicParallelChatPane);
      final chat = tester.state(pane);
      await tester.tap(pane);
      await _until(tester, () => server.reports.isNotEmpty);
      expect(server.reports.single['sessions'], ['runtime-alpha']);
      shell.currentState!.select(HermesDestination.activity);
      await tester.pump();
      await _until(tester, () => server.reports.length > 1);
      expect(
        tester.state(find.byType(ClassicParallelChatPane, skipOffstage: false)),
        same(chat),
        reason: 'the hidden pane stays mounted',
      );
      expect(server.reports, hasLength(2), reason: server.log.log());
      expect(server.reports.last['sessions'], isEmpty);
      expect(server.reports.last.containsKey('away'), isFalse);
      // The ticker does not claim the hidden pane's fresh input again.
      await tester.pump(const Duration(seconds: 11));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await tester.pump();
      expect(server.reports, hasLength(2), reason: server.log.log());
      // Shown again, input there claims it.
      shell.currentState!.select(HermesDestination.chats);
      await tester.pump();
      await tester.tap(pane);
      await _until(
        tester,
        () => (server.reports.last['sessions'] as List).isNotEmpty,
      );
      expect(server.reports.last['sessions'], ['runtime-alpha']);
      await tester.pumpWidget(const SizedBox());
      await _until(
        tester,
        () => (server.reports.last['sessions'] as List).isEmpty,
      );
      await controller.close();
      await tester.runAsync(server.close);
      await tester.pump(const Duration(seconds: 16));
    },
  );
}
