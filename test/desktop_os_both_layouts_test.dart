import 'support/settings_navigation.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/capabilities/capability_pages.dart';
import 'package:hermes_android/core/desktop/desktop_integration.dart';
import 'package:hermes_android/core/desktop/desktop_os.dart';
import 'package:hermes_android/core/desktop/quick_entry.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/screens/settings_screen.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hermes_deeplink.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/services/keep_awake.dart';
import 'package:hermes_android/core/services/shortcuts_store.dart';
import 'package:hermes_android/core/utils/home_turn_signals.dart';
import 'package:hermes_android/core/widgets/command_palette.dart';
import 'package:hermes_android/core/widgets/desktop_shortcuts.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/main.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/capabilities_page.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/settings_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_child_process.dart';

class _ShellGatewayFixture {
  _ShellGatewayFixture._(this.server);

  final HttpServer server;
  final List<String> mutationPaths = [];
  int promptSubmissions = 0;

  int get port => server.port;
  String get baseUrl => 'http://127.0.0.1:$port';

  static Future<_ShellGatewayFixture> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final fixture = _ShellGatewayFixture._(server);
    server.listen((req) async {
      final path = req.uri.path;
      if (req.method != 'GET' && path != '/api/auth/ws-ticket') {
        fixture.mutationPaths.add('${req.method} $path');
      }

      if (path == '/api/ws' && WebSocketTransformer.isUpgradeRequest(req)) {
        final ws = await WebSocketTransformer.upgrade(
          req,
          protocolSelector: (protocols) =>
              protocols.contains('hermes-gateway-v1')
              ? 'hermes-gateway-v1'
              : null,
        );
        ws.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'method': 'event',
            'params': {
              'type': 'gateway.ready',
              'payload': {
                'protocol': {'name': 'hermes-jsonrpc', 'major': 2},
              },
            },
          }),
        );
        ws.listen((raw) {
          final msg = jsonDecode(raw as String) as Map<String, dynamic>;
          final method = msg['method'] as String?;
          if (method != null && method.contains('prompt')) {
            fixture.promptSubmissions++;
          }
          if (msg.containsKey('id')) {
            ws.add(
              jsonEncode({
                'jsonrpc': '2.0',
                'id': msg['id'],
                'result': switch (method) {
                  'session.resume' || 'session.create' => {
                    'session_id': 'rt-alpha',
                    'stored_session_id': 's-alpha',
                  },
                  'projects.list' => {'projects': <Object>[]},
                  _ => <String, Object>{'accepted': true},
                },
              }),
            );
          }
        });
        return;
      }

      req.response.headers.contentType = ContentType.json;
      if (path == '/api/status') {
        req.response.statusCode = 200;
        req.response.write(
          jsonEncode({
            'version': '0.23.4-fixture',
            'gateway_running': true,
            'auth_required': false,
          }),
        );
      } else if (path == '/api/auth/ws-ticket') {
        req.response.statusCode = 200;
        req.response.write(jsonEncode({'ticket': 'fixture-ws-ticket'}));
      } else if (path == '/api/sessions') {
        req.response.statusCode = 200;
        req.response.write(
          jsonEncode({
            'sessions': [
              {
                'id': 's-alpha',
                'title': 'Alpha Investigation',
                'source': 'desktop',
                'model': 'gpt-test',
                'message_count': 2,
                'started_at': 1700000000,
                'last_active': 1700000100,
              },
              {
                'id': 's-beta',
                'title': 'Beta Notes',
                'source': 'desktop',
                'model': 'gpt-test',
                'message_count': 1,
                'started_at': 1700000050,
                'last_active': 1700000060,
              },
            ],
            'total': 2,
          }),
        );
      } else if (path.startsWith('/api/sessions/')) {
        req.response.statusCode = 200;
        req.response.write(
          jsonEncode({
            'id': 's-alpha',
            'title': 'Alpha Investigation',
            'source': 'desktop',
            'model': 'gpt-test',
            'messages': <Object>[],
          }),
        );
      } else {
        req.response.statusCode = 200;
        req.response.write(jsonEncode(<String, Object>{'items': <Object>[]}));
      }
      await req.response.close();
    });
    return fixture;
  }

  Future<void> close() => server.close(force: true);
}

ApiClient _offlineClassicApiClient() => ApiClient(
  baseUrl: 'http://offline.test:8642',
  apiKey: 'fixture',
  httpClient: MockClient((req) async {
    if (req.url.path.contains('/sessions/')) {
      return http.Response(
        jsonEncode({
          'session': {
            'id': 's-alpha',
            'title': 'Alpha Investigation',
            'model': 'gpt-test',
          },
          'messages': <Object>[],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    }
    return http.Response(
      jsonEncode({'sessions': <Object>[], 'has_more': false}),
      200,
      headers: {'content-type': 'application/json'},
    );
  }),
);

List<Session> _fixtureSessions() => [
  Session(
    id: 's-alpha',
    title: 'Alpha Investigation',
    source: 'desktop',
    model: 'gpt-test',
    messageCount: 2,
    isActive: false,
    preview: 'investigating',
    startedAt: 1700000000,
    lastActive: 1700000100,
    endedAt: null,
  ),
  Session(
    id: 's-beta',
    title: 'Beta Notes',
    source: 'desktop',
    model: 'gpt-test',
    messageCount: 1,
    isActive: false,
    preview: 'notes',
    startedAt: 1700000050,
    lastActive: 1700000060,
    endedAt: null,
  ),
];

/// A running desktop integration whose quick-entry window is a fake child.
Future<DesktopIntegration> _quickEntryIntegration(
  List<FakeChildProcess> spawned,
) async {
  const shell = MethodChannel('test/both_layouts_shell');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(shell, (_) async => null);
  final integration = DesktopIntegration(
    preferences: await SharedPreferences.getInstance(),
    shell: const DesktopShell(shell),
    notifications: ValueNotifier(NotificationPrefs.defaults),
    quickEntrySpawn: () async {
      final process = FakeChildProcess();
      spawned.add(process);
      return process;
    },
    strings: () => lookupAppLocalizations(const Locale('en')),
  )..start();
  return integration;
}

Future<void> _openQuickEntryFromPalette(WidgetTester tester) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await tester.pumpAndSettle();
  // Search by keyword so the query field itself does not match the label.
  await tester.enterText(
    find.byKey(const Key('app-command-palette-query')),
    'hud',
  );
  await tester.pumpAndSettle();
  await tester.tap(
    find.descendant(
      of: find.byType(CommandPalette),
      matching: find.text('Quick entry'),
    ),
  );
  // Not pumpAndSettle: the launcher's ready wait is a pending timer.
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(find.byType(CommandPalette), findsNothing);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    HermesDeepLinkService.shared.resetForTesting();
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
    PackageInfo.setMockInitialValues(
      appName: 'Ares',
      packageName: 'com.hermesagent.hermes_android',
      version: '5.0.0-test',
      buildNumber: '5000',
      buildSignature: '',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_tts'),
          (_) async => <Object>[],
        );
  });

  tearDown(() {
    HermesDeepLinkService.shared.resetForTesting();
    HermesSignInVault.resetForTesting();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), null);
  });

  group(
    'Classic layout: command palette, shortcuts, narrow More chat tools, and deep links',
    () {
      testWidgets(
        'Classic palette opens desktop quick entry; its hand-back opens the chosen chat with a prefill and never sends',
        (tester) async {
          tester.view.physicalSize = const Size(1200, 800);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);
          final spawned = <FakeChildProcess>[];
          // Created outside the test clock so its own futures can complete
          // inside runAsync at the end.
          final integration = (await tester.runAsync(
            () => _quickEntryIntegration(spawned),
          ))!;
          // Async teardown does not run microtasks under the fake clock;
          // dispose in the body, and only the synchronous part on failure.
          addTearDown(integration.quickEntry.dispose);
          final openedSessions = <String>[];

          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: DesktopShortcuts(
                forceEnabled: true,
                store: ShortcutsStore(await SharedPreferences.getInstance()),
                child: WorkspaceScreen(
                  connection: SavedConnection(
                    id: 'classic-hud',
                    label: 'Classic Host',
                    host: 'offline.test',
                    port: 8642,
                    apiKey: 'test-key',
                  ),
                  sessionsLoader: () async => _fixtureSessions(),
                  turnSignalsLoader: (_) async => HomeTurnSignals.empty,
                  onOpenSession: (s) => openedSessions.add(s.id),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          await _openQuickEntryFromPalette(tester);
          expect(spawned, hasLength(1));
          final frame = QuickEntryLaunch.decode(
            jsonDecode(spawned.single.stdinLines.single)
                as Map<String, dynamic>,
          );
          expect(frame.chats.map((c) => c.id), ['s-alpha', 's-beta']);
          expect(frame.chats.last.title, 'Beta Notes');

          spawned.single.emit(quickEntryReady);
          spawned.single.emit(
            jsonEncode({'prefill': 'From the HUD', 'session': 's-beta'}),
          );
          for (var i = 0; i < 5; i++) {
            await tester.pump(const Duration(milliseconds: 100));
          }
          expect(openedSessions, ['s-beta']);
          expect(HermesDeepLinkService.shared.pendingLink.value, isNull);

          // PROBE-4: a hand-back owned by another connection (the window
          // was offered that connection's chats) is never opened here, even
          // for a chat id this list also has.
          HermesDeepLinkService.shared.handleRawLink(
            'hermes://session/s-alpha?prefill=Not+for+this+connection',
            owner: HermesLinkOwner(connectionId: 'another-connection'),
          );
          for (var i = 0; i < 5; i++) {
            await tester.pump(const Duration(milliseconds: 100));
          }
          expect(openedSessions, ['s-beta']);
          expect(
            HermesDeepLinkService.shared.pendingLink.value?.owner?.connectionId,
            'another-connection',
          );
          HermesDeepLinkService.shared.takePendingLink();
          await tester.runAsync(integration.dispose);
          expect(DesktopIntegration.current, isNull);
        },
      );

      testWidgets(
        'wide Classic WorkspaceScreen opens palette via shortcut and button, switches sessions by ID, and honors rebound/conflicted chords',
        (tester) async {
          tester.view.physicalSize = const Size(1200, 800);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          final prefs = await SharedPreferences.getInstance();
          final store = ShortcutsStore(prefs);
          final openedSessions = <String>[];

          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: DesktopShortcuts(
                forceEnabled: true,
                store: store,
                child: WorkspaceScreen(
                  connection: SavedConnection(
                    id: 'classic-wide',
                    label: 'Classic Host',
                    host: 'offline.test',
                    port: 8642,
                    apiKey: 'fixture',
                  ),
                  sessionsLoader: () async => _fixtureSessions(),
                  turnSignalsLoader: (_) async => HomeTurnSignals.empty,
                  onOpenSession: (s) => openedSessions.add(s.id),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Default Ctrl+K mirror opens the dialog CommandPalette on desktop.
          await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
          await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
          await tester.pumpAndSettle();
          expect(find.byType(CommandPalette), findsOneWidget);
          expect(find.byType(Dialog), findsOneWidget);

          // Filter by session ID and select.
          await tester.enterText(
            find.byKey(const Key('app-command-palette-query')),
            's-beta',
          );
          await tester.pumpAndSettle();
          final betaInPalette = find.descendant(
            of: find.byType(CommandPalette),
            matching: find.text('Beta Notes'),
          );
          expect(betaInPalette, findsOneWidget);
          await tester.tap(betaInPalette);
          await tester.pumpAndSettle();
          expect(openedSessions, ['s-beta']);

          // Rebind commandPalette to Ctrl+Shift+P -> live DesktopShortcuts updates.
          await store.setChord(
            ShortcutAction.commandPalette,
            const KeyChord(
              key: LogicalKeyboardKey.keyP,
              ctrl: true,
              shift: true,
            ),
          );
          await tester.pump();

          // Old Ctrl+K no longer opens the palette.
          await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
          await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
          await tester.pumpAndSettle();
          expect(find.byType(CommandPalette), findsNothing);

          // New Ctrl+Shift+P opens the palette.
          await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
          await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
          await tester.sendKeyEvent(LogicalKeyboardKey.keyP);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
          await tester.pumpAndSettle();
          expect(find.byType(CommandPalette), findsOneWidget);
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          await tester.pumpAndSettle();

          // Conflict check: binding newChat to the SAME Ctrl+Shift+P chord causes
          // both conflicting custom bindings to fall back to safe defaults.
          await store.setChord(
            ShortcutAction.newChat,
            const KeyChord(
              key: LogicalKeyboardKey.keyP,
              ctrl: true,
              shift: true,
            ),
          );
          expect(store.conflicts(), isNotEmpty);
          await tester.pump();

          await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
          await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
          await tester.sendKeyEvent(LogicalKeyboardKey.keyP);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
          await tester.pumpAndSettle();
          expect(find.byType(CommandPalette), findsNothing);
        },
      );

      testWidgets(
        'narrow Classic (<480 px) exposes App command palette in More chat tools and handles cold-start/install deep links without executing',
        (tester) async {
          tester.view.physicalSize = const Size(390, 844);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          // Queue cold-start session deep link with prefill BEFORE mounting WorkspaceScreen.
          expect(
            HermesDeepLinkService.shared.handleRawLink(
              'hermes://session/s-alpha?prefill=Check+logs',
            ),
            isTrue,
          );

          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: WorkspaceScreen(
                connection: SavedConnection(
                  id: 'classic-narrow',
                  label: 'Classic Phone',
                  host: 'offline.test',
                  port: 8642,
                  apiKey: 'fixture',
                ),
                sessionsLoader: () async => _fixtureSessions(),
                turnSignalsLoader: (_) async => HomeTurnSignals.empty,
                testChatApiClientFactory: _offlineClassicApiClient,
                testDashboardHttpClient: MockClient(
                  (_) async => http.Response(
                    jsonEncode({'sessions': <Object>[], 'total': 0}),
                    200,
                    headers: {'content-type': 'application/json'},
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Cold-start deep link opened ChatScreen for s-alpha and prefilled composer, NEVER sent.
          expect(find.byType(ChatScreen), findsOneWidget);
          final composer = tester.widget<TextField>(
            find.byKey(const Key('chat-message-composer')),
          );
          expect(composer.controller?.text, 'Check logs');
          expect(tester.takeException(), isNull);

          // On <480 px, App command palette lives inside 'More chat tools'.
          await tester.tap(find.byTooltip('More chat tools'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 400));
          expect(find.text('App command palette'), findsOneWidget);
          await tester.tap(find.text('App command palette'));
          await tester.pumpAndSettle();

          // Narrow command palette is a full-screen takeover, not a Dialog.
          expect(find.byType(CommandPalette), findsOneWidget);
          expect(find.byType(Dialog), findsNothing);
          await tester.tap(find.byIcon(Icons.close));
          await tester.pumpAndSettle();

          // Pop back to WorkspaceScreen and verify hermes://launch & hermes://skill/install.
          Navigator.of(tester.element(find.byType(ChatScreen))).pop();
          await tester.pumpAndSettle();

          HermesDeepLinkService.shared.handleRawLink('hermes://launch');
          await tester.pumpAndSettle();
          expect(HermesDeepLinkService.shared.launchCount, 1);
          expect(find.byType(ChatScreen), findsNothing);

          // Unknown session id does not open or fabricate a chat; surfaces notice.
          HermesDeepLinkService.shared.handleRawLink(
            'hermes://session/missing-session-99?prefill=ignored',
          );
          await tester.pumpAndSettle();
          expect(find.byType(ChatScreen), findsNothing);
          expect(
            find.textContaining('Chat not found in the list'),
            findsOneWidget,
          );

          HermesDeepLinkService.shared.handleRawLink(
            'hermes://skill/install?identifier=demo-skill',
          );
          for (var i = 0; i < 10; i++) {
            await tester.pump(const Duration(milliseconds: 50));
          }
          expect(find.byType(CapabilityAdminScreen), findsOneWidget);
        },
      );
    },
  );

  group(
    'NextGen layout: command palette, shortcuts, narrow More chat tools, and deep links',
    () {
      Future<NextGenGateway> pumpNextGenShell(
        WidgetTester tester,
        _ShellGatewayFixture fixture,
        Size size, {
        ShortcutsStore? store,
      }) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final prefs = await SharedPreferences.getInstance();
        final conn = SavedConnection(
          id: 'ng-shell',
          label: 'NextGen Host',
          host: '127.0.0.1',
          port: fixture.port,
          dashboardPortOverride: fixture.port,
          dashboardProxied: true,
          apiKey: '',
          desktopGatewayUrl: fixture.baseUrl,
          singleLogin: true,
          signInMethod: 'none',
        );
        final gateway = NextGenGateway(conn);
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
            builder: (_, child) => DesktopShortcuts(
              forceEnabled: true,
              store: store ?? ShortcutsStore(prefs),
              child: NgScope(
                connManager: ConnectionManager(prefs),
                gateway: gateway,
                connections: [conn],
                switchTo: (_) async {},
                addGateway: () async {},
                signOut: (_) async {},
                reload: () async {},
                signInAgain: () async {},
                child: child!,
              ),
            ),
            home: const NgMainPage(),
          ),
        );
        for (var i = 0; i < 20; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 15)),
          );
          await tester.pump(const Duration(milliseconds: 40));
        }
        return gateway;
      }

      Future<void> unmountNextGen(
        WidgetTester tester,
        NextGenGateway gateway,
      ) async {
        await tester.pumpWidget(const SizedBox());
        gateway.dispose();
        await tester.pump(const Duration(seconds: 30));
      }

      testWidgets(
        'NextGen settings deep link opens exact category and backs to settings home',
        (tester) async {
          final previous = HttpOverrides.current;
          HttpOverrides.global = null;
          addTearDown(() => HttpOverrides.global = previous);
          final fixture = (await tester.runAsync(_ShellGatewayFixture.start))!;
          addTearDown(fixture.close);
          final prefs = await SharedPreferences.getInstance();
          final gateway = await pumpNextGenShell(
            tester,
            fixture,
            const Size(390, 844),
          );
          final before = nextGenEnabled.value;
          expect(
            HermesDeepLinkService.shared.handleRawLink(
              'hermes://settings/appearance',
            ),
            isTrue,
          );
          await tester.pumpAndSettle();
          expect(find.byType(NgSettingsPage), findsOneWidget);
          expect(
            find.byKey(const ValueKey('settings-control-ng.theme')),
            findsOneWidget,
          );
          expect(
            find.byKey(const ValueKey('settings-control-classic.theme')),
            findsNothing,
          );
          await tester.pageBack();
          await tester.pumpAndSettle();
          expect(
            find.byKey(const ValueKey('settings-category-appearance')),
            findsOneWidget,
          );
          expect(nextGenEnabled.value, before);
          expect(prefs.getBool(NextGenPreferences.enabledKey), isNull);
          expect(tester.takeException(), isNull);
          await unmountNextGen(tester, gateway);
        },
      );

      testWidgets(
        'NextGen palette opens desktop quick entry; its hand-back prefills the chosen chat and never sends',
        (tester) async {
          final previousOverrides = HttpOverrides.current;
          HttpOverrides.global = null;
          addTearDown(() => HttpOverrides.global = previousOverrides);

          final fixture = (await tester.runAsync(_ShellGatewayFixture.start))!;
          addTearDown(fixture.close);
          final spawned = <FakeChildProcess>[];
          final integration = (await tester.runAsync(
            () => _quickEntryIntegration(spawned),
          ))!;
          addTearDown(integration.quickEntry.dispose);

          final gateway = await pumpNextGenShell(
            tester,
            fixture,
            const Size(1200, 800),
          );

          await _openQuickEntryFromPalette(tester);
          expect(spawned, hasLength(1));
          final frame = QuickEntryLaunch.decode(
            jsonDecode(spawned.single.stdinLines.single)
                as Map<String, dynamic>,
          );
          expect(frame.chats.map((c) => c.id), contains('s-alpha'));

          spawned.single.emit(quickEntryReady);
          spawned.single.emit(
            jsonEncode({'prefill': 'From the HUD', 'session': 's-alpha'}),
          );
          for (var i = 0; i < 15; i++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 10)),
            );
            await tester.pump(const Duration(milliseconds: 30));
          }
          final composer = tester.widget<TextField>(
            find.byKey(const Key('ng-composer-field')),
          );
          expect(composer.controller?.text, 'From the HUD');
          expect(fixture.promptSubmissions, 0);

          // PROBE-4: a hand-back owned by another connection waits for that
          // connection; this one never applies it.
          HermesDeepLinkService.shared.handleRawLink(
            'hermes://session/s-alpha?prefill=Not+for+this+connection',
            owner: HermesLinkOwner(connectionId: 'another-connection'),
          );
          for (var i = 0; i < 10; i++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 10)),
            );
            await tester.pump(const Duration(milliseconds: 30));
          }
          expect(
            tester
                .widget<TextField>(find.byKey(const Key('ng-composer-field')))
                .controller
                ?.text,
            'From the HUD',
          );
          expect(
            HermesDeepLinkService.shared.pendingLink.value?.owner?.connectionId,
            'another-connection',
          );
          HermesDeepLinkService.shared.takePendingLink();
          await tester.runAsync(integration.dispose);

          await unmountNextGen(tester, gateway);
        },
      );

      testWidgets(
        'wide NextGen opens command palette via button and shortcut, switches sessions by ID, and rebinds in NgSettingsPage',
        (tester) async {
          final previousOverrides = HttpOverrides.current;
          HttpOverrides.global = null;
          addTearDown(() => HttpOverrides.global = previousOverrides);
          // A runner that keeps the device awake (the card is hidden
          // otherwise).
          final messenger =
              TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
          messenger.setMockMethodCallHandler(
            MethodChannelKeepAwakeAdapter.channel,
            (call) async => call.method == 'isSupported' ? true : null,
          );
          addTearDown(
            () => messenger.setMockMethodCallHandler(
              MethodChannelKeepAwakeAdapter.channel,
              null,
            ),
          );

          final fixture = (await tester.runAsync(_ShellGatewayFixture.start))!;
          addTearDown(fixture.close);

          final prefs = await SharedPreferences.getInstance();
          final store = ShortcutsStore(prefs);
          final gateway = await pumpNextGenShell(
            tester,
            fixture,
            const Size(1200, 800),
            store: store,
          );

          // The cold launch is the landing; start a chat before testing its
          // wide header's palette button. All routing/rebinding checks remain.
          expect(find.byKey(const Key('ng-brand-new-chat')), findsOneWidget);
          await tester.tap(find.byKey(const Key('ng-brand-new-chat')));
          await tester.pumpAndSettle();
          // Wide pane renders the App command palette IconButton directly.
          expect(
            find.byKey(const ValueKey('app-command-palette-button')),
            findsOneWidget,
          );
          await tester.tap(
            find.byKey(const ValueKey('app-command-palette-button')),
          );
          await tester.pumpAndSettle();
          expect(find.byType(CommandPalette), findsOneWidget);
          expect(find.byType(Dialog), findsOneWidget);

          // Filter by session ID s-alpha and open it.
          await tester.enterText(
            find.byKey(const Key('app-command-palette-query')),
            's-alpha',
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text('Alpha Investigation').last);
          for (var i = 0; i < 15; i++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 10)),
            );
            await tester.pump(const Duration(milliseconds: 30));
          }
          expect(find.text('Alpha Investigation'), findsWidgets);

          // Open palette via Ctrl+K and navigate to Settings, where both Desktop OS cards render.
          await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
          await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
          await tester.pumpAndSettle();
          await tester.enterText(
            find.byKey(const Key('app-command-palette-query')),
            'Settings',
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text('Settings').last);
          await tester.pumpAndSettle();

          expect(find.byType(NgSettingsPage), findsOneWidget);
          await openSettingsCategory(tester, 'device');
          expect(
            find.byKey(const Key('keep-awake-settings-card')),
            findsOneWidget,
          );
          // On desktop the Desktop integration card sits above it, so the
          // lazily built list may need a scroll.
          await tester.scrollUntilVisible(
            find.byKey(const Key('keyboard-shortcuts-settings-card')),
            200,
            scrollable: find
                .descendant(
                  of: find.byType(NgSettingsPage),
                  matching: find.byWidgetPredicate(
                    (w) =>
                        w is Scrollable &&
                        w.axisDirection == AxisDirection.down,
                  ),
                )
                .first,
          );
          expect(
            find.byKey(const Key('keyboard-shortcuts-settings-card')),
            findsOneWidget,
          );

          // Toggle keep-awake and rebind commandPalette directly inside NgSettingsPage.
          final ngAlways = find.byKey(
            const Key('keep-awake-mode-whileWorking'),
          );
          await tester.ensureVisible(ngAlways);
          await tester.tap(ngAlways);
          await tester.pumpAndSettle();
          expect(
            KeepAwakePolicyStore(prefs).read(),
            KeepAwakeMode.whileWorking,
          );

          final rebindBtn = find.byKey(
            const Key('shortcut-rebind-commandPalette'),
          );
          await tester.ensureVisible(rebindBtn);
          await tester.tap(rebindBtn);
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('chord-key-keyJ')));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('chord-save-button')));
          await tester.pumpAndSettle();
          expect(store.chordFor(ShortcutAction.commandPalette).keyName, 'keyJ');

          await unmountNextGen(tester, gateway);
        },
        // The shortcuts card only exists where the bindings fire.
        variant: TargetPlatformVariant.only(TargetPlatform.linux),
      );

      testWidgets(
        'narrow NextGen (<480 px) places App command palette in More chat tools and routes cold-start/install deep links safely without sending',
        (tester) async {
          final previousOverrides = HttpOverrides.current;
          HttpOverrides.global = null;
          addTearDown(() => HttpOverrides.global = previousOverrides);

          final fixture = (await tester.runAsync(_ShellGatewayFixture.start))!;
          addTearDown(fixture.close);

          // Queue cold-start session deep link BEFORE mounting NgMainPage.
          HermesDeepLinkService.shared.handleRawLink(
            'hermes://session/s-alpha?prefill=Prefill+NextGen',
          );

          final gateway = await pumpNextGenShell(
            tester,
            fixture,
            const Size(390, 844),
          );

          // Session opened, composer prefilled, ZERO prompt submissions sent.
          expect(find.text('Alpha Investigation'), findsOneWidget);
          final composer = tester.widget<TextField>(
            find.byKey(const Key('ng-composer-field')),
          );
          expect(composer.controller?.text, 'Prefill NextGen');
          expect(fixture.promptSubmissions, 0);
          expect(tester.takeException(), isNull);

          // A second link for the open chat appends after the unsent draft
          // the user typed; it never replaces it or sends.
          await tester.enterText(
            find.byKey(const Key('ng-composer-field')),
            'My unsent draft',
          );
          await tester.pump();
          HermesDeepLinkService.shared.handleRawLink(
            'hermes://session/s-alpha?prefill=From+the+link',
          );
          for (var i = 0; i < 10; i++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 10)),
            );
            await tester.pump(const Duration(milliseconds: 30));
          }
          expect(
            tester
                .widget<TextField>(find.byKey(const Key('ng-composer-field')))
                .controller
                ?.text,
            'My unsent draft\n\nFrom the link',
          );
          expect(fixture.promptSubmissions, 0);

          // On <480 px, App command palette is inside 'More chat tools', never overflowing.
          expect(
            find.byKey(const ValueKey('app-command-palette-button')),
            findsNothing,
          );
          await tester.tap(find.byTooltip('More chat tools'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 400));
          expect(find.text('App command palette'), findsOneWidget);
          await tester.tap(find.text('App command palette'));
          await tester.pumpAndSettle();

          expect(find.byType(CommandPalette), findsOneWidget);
          expect(find.byType(Dialog), findsNothing);
          await tester.tap(find.byIcon(Icons.close));
          await tester.pumpAndSettle();

          // Unknown session id in NextGen shows toast and does not create a blank chat.
          HermesDeepLinkService.shared.handleRawLink(
            'hermes://session/missing-ng-99?prefill=no',
          );
          for (var i = 0; i < 10; i++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 10)),
            );
            await tester.pump(const Duration(milliseconds: 30));
          }
          expect(
            find.textContaining('Chat not found in the list'),
            findsOneWidget,
          );
          expect(fixture.promptSubmissions, 0);

          // Install deep link opens NgCapabilitiesPage for review without any mutation request.
          fixture.mutationPaths.clear();
          HermesDeepLinkService.shared.handleRawLink(
            'hermes://plugin/install?catalog=kanban',
          );
          for (var i = 0; i < 15; i++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 10)),
            );
            await tester.pump(const Duration(milliseconds: 30));
          }
          expect(find.byType(NgCapabilitiesPage), findsOneWidget);
          expect(fixture.mutationPaths, isEmpty);

          await unmountNextGen(tester, gateway);
        },
      );
    },
  );

  group(
    'Keep-awake: opt-in policy + active-turn power channel in both Classic and NextGen',
    () {
      testWidgets(
        'HermesApp keeps power channel off by default, toggles on active turns in whileWorking, and releases on dispose',
        (tester) async {
          final powerCalls = <Map<String, Object?>>[];
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(MethodChannelKeepAwakeAdapter.channel, (
                call,
              ) async {
                if (call.method == 'isSupported') return true;
                if (call.method == 'setAwake') {
                  final args = Map<String, Object?>.from(call.arguments as Map);
                  powerCalls.add(args);
                }
                return null;
              });
          addTearDown(
            () => TestDefaultBinaryMessengerBinding
                .instance
                .defaultBinaryMessenger
                .setMockMethodCallHandler(
                  MethodChannelKeepAwakeAdapter.channel,
                  null,
                ),
          );

          final prefs = await SharedPreferences.getInstance();
          await NextGenPreferences.setEnabled(prefs, false);
          final manager = ConnectionManager(prefs);

          await tester.pumpWidget(HermesApp(connManager: manager));
          await tester.pumpAndSettle();

          // Default is off: turning nextGenTurnActive on/off emits zero setAwake calls.
          nextGenTurnActive.value = true;
          await tester.pump();
          nextGenTurnActive.value = false;
          await tester.pump();
          expect(powerCalls, isEmpty);

          // Open Classic SettingsScreen and select 'While working'.
          unawaited(
            Navigator.of(tester.element(find.byType(HomeScreen))).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => SettingsScreen(
                  connection: SavedConnection(
                    id: 'ka-classic',
                    label: 'Offline',
                    host: 'offline.test',
                    port: 8642,
                    apiKey: 'fixture',
                  ),
                  dashboardClient: DashboardClient(
                    host: 'offline.test',
                    port: 9119,
                    httpClient: MockClient(
                      (_) async => http.Response('offline', 503),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final scroll = find
              .descendant(
                of: find.byType(SettingsScreen),
                matching: find.byWidgetPredicate(
                  (w) =>
                      w is Scrollable && w.axisDirection == AxisDirection.down,
                ),
              )
              .first;
          final whileWorkingChip = find.byKey(
            const Key('keep-awake-mode-whileWorking'),
          );
          await openSettingsCategory(tester, 'device');
          await tester.scrollUntilVisible(
            whileWorkingChip,
            100,
            scrollable: scroll,
            maxScrolls: 150,
          );
          await tester.ensureVisible(whileWorkingChip);
          await tester.pumpAndSettle();
          // Supported runner hides the unsupported-runner capability note.
          expect(
            find.byKey(const Key('keep-awake-capability-note')),
            findsNothing,
          );
          await tester.tap(whileWorkingChip);
          await tester.pumpAndSettle();
          expect(powerCalls, isEmpty, reason: 'idle whileWorking stays off');

          // Active turn engages keep-awake; finishing releases it.
          nextGenTurnActive.value = true;
          await tester.pump();
          expect(powerCalls.last['enabled'], isTrue);

          nextGenTurnActive.value = false;
          await tester.pump();
          expect(powerCalls.last['enabled'], isFalse);

          // Switch to 'Always' -> immediately awake; disposing HermesApp releases OS flag
          // while keeping 'always' persisted in SharedPreferences.
          final alwaysChip = find.byKey(const Key('keep-awake-mode-always'));
          await tester.ensureVisible(alwaysChip);
          await tester.tap(alwaysChip);
          await tester.pumpAndSettle();
          expect(powerCalls.last['enabled'], isTrue);

          await tester.pumpWidget(const SizedBox());
          await tester.pump();
          expect(powerCalls.last['enabled'], isFalse);
          expect(KeepAwakePolicyStore(prefs).read(), KeepAwakeMode.always);
        },
      );
    },
  );
}
