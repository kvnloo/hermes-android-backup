import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/projects_tree_overview.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/gateway_turn_coordinator.dart';
import 'package:hermes_android/core/services/normal_gateway_application_session.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/session_history_page.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_history_owner.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/inert_turn_application_session.dart';
import 'support/pump_chat_updates.dart';

class _OwnerController extends GatewayTurnApplicationController {
  _OwnerController(this.normal)
    : super(sessionFactory: (_) => InertTurnApplicationSession());
  final NormalGatewayApplicationSession normal;

  @override
  NormalGatewayApplicationSession normalSessionFor(
    SavedConnection connection, {
    NormalGatewayPromptSubmit? submit,
    NormalGatewaySteer? steer,
    NormalGatewayResume? resume,
    NormalGatewayHistory? history,
    TurnNotificationService? notifications,
  }) => normal;

  @override
  Future<void> close() async {
    await normal.close();
    await super.close();
  }
}

class _ClassicDesktopClient implements DesktopGatewayClient {
  _ClassicDesktopClient(this.workspace);

  @override
  final RemoteWorkspaceOwner workspace;

  @override
  bool get sessionAuthority => true;

  @override
  bool get slashCommandsSupported => false;

  @override
  void setSessionBoundListener(
    GatewayTurnSessionBoundCallback? listener, {
    GatewayTurnSessionBoundCallback? onCreated,
  }) {}

  @override
  void setSessionEventListener(DesktopAsyncEventCallback? listener) {}

  @override
  void setAsyncEventListener(
    DesktopAsyncEventCallback? listener, {
    DesktopAsyncEventSessionPredicate? acceptsSession,
  }) {}

  @override
  void setConnectionListener(DesktopConnectionCallback? listener) {}

  @override
  void setReconnectAllowed(bool allowed) {}

  @override
  void bindStoredSession(String localSessionId, String storedSessionId) {}

  @override
  String? storedSessionKeyFor(String mobileSessionId) =>
      mobileSessionId == 'local-draft' ? null : mobileSessionId;

  @override
  String? boundTerminalBackend(String storedSessionId) => null;

  @override
  Future<void> ensureSession(
    String sessionId, {
    String? workingDirectory,
  }) async {}

  @override
  bool ownsApprovalRequest(String sessionId, {String? requestId}) => false;

  @override
  void close() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnsupportedError(
    'Unexpected DesktopGatewayClient.${invocation.memberName}',
  );
}

class _NgHistoryGateway extends NextGenGateway {
  _NgHistoryGateway(FakeHistoryBackend backend)
    : _owner = backend.owner,
      super(backend.connection, dashboard: backend.dashboard);

  final RemoteWorkspaceOwner _owner;

  @override
  RemoteWorkspaceOwner get workspace => _owner;

  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async => <String, dynamic>{};
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  }
  await tester.pump();
}

Future<void> _reveal(WidgetTester tester, Finder target) async {
  final list = find.byKey(const ValueKey('history-scroll'));
  for (var i = 0; i < 12 && target.hitTestable().evaluate().isEmpty; i++) {
    await tester.drag(list, const Offset(0, -240));
    await _settle(tester);
  }
}

void main() {
  setUp(mockChatImageRecovery);
  for (final classic in [true, false]) {
    final label = classic ? 'Classic' : 'NextGen';

    testWidgets(
      '$label host-side Claude/Codex import lists, filters, paginates, previews redacted turns, confirms import and opens the session',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.devicePixelRatio = 1;
        // Narrow pane (<480 px) verifies entry via "More chat tools".
        tester.view.physicalSize = const Size(390, 900);
        addTearDown(tester.view.reset);

        final backend = FakeHistoryBackend(profile: 'field-work');
        addTearDown(backend.close);

        String? openedSessionId;
        String? openedTitle;
        late final Future<void> Function() disposeShell;
        late final Widget app;

        if (classic) {
          final client = _ClassicDesktopClient(backend.owner);
          final normal = NormalGatewayApplicationSession(
            connection: backend.connection,
            scope: 'foreign-import-classic',
            client: client,
            submit:
                ({
                  required sessionId,
                  required text,
                  required onEvent,
                  required onSent,
                }) async {},
            resume:
                ({required localSessionId, required storedSessionId}) async =>
                    const ResumedGatewaySession(runtimeSessionId: 'rt-1'),
            history: (_) async => const [],
          );
          final controller = _OwnerController(normal);
          await normal.ready;
          disposeShell = controller.close;
          app = MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ChatScreen(
              connection: backend.connection,
              session: Session(
                id: 'local-draft',
                title: 'New chat',
                model: 'fixture',
                source: 'mobile',
                messageCount: 0,
                isActive: true,
                preview: '',
                startedAt: 1,
                isLocalDraft: true,
              ),
              turnApplicationController: controller,
              testProjectOverviewLoader: () async => ProjectsTreeOverview.empty,
              testApiClient: backend.apiClient,
              testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
            ),
          );
        } else {
          final prefs = await SharedPreferences.getInstance();
          final gateway = _NgHistoryGateway(backend);
          final chat = NgChatController(gateway);
          disposeShell = () async {
            chat.dispose();
            gateway.dispose();
          };
          app = MaterialApp(
            theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
            home: NgScope(
              connManager: ConnectionManager(prefs),
              gateway: gateway,
              connections: [backend.connection],
              switchTo: (_) async {},
              addGateway: () async {},
              signOut: (_) async {},
              reload: () async {},
              signInAgain: () async {},
              child: NgChatView(
                chat: chat,
                onOpenSidebar: () {},
                onNewChat: () {},
                onOpenSessionId: (id, {title}) {
                  openedSessionId = id;
                  openedTitle = title;
                },
              ),
            ),
          );
        }

        try {
          await tester.pumpWidget(app);
          await tester.pump(const Duration(milliseconds: 200));

          // Narrow pane (<480 px) places import/history inside More chat tools.
          expect(find.byKey(const ValueKey('chat-tools-menu')), findsOneWidget);
          await tester.tap(find.byKey(const ValueKey('chat-tools-menu')));
          await _settle(tester);
          await tester.tap(find.text('Import Claude or Codex'));
          await _settle(tester);

          // No device file-picker stub control exists.
          expect(find.text('Preview a file'), findsNothing);
          expect(find.byKey(const ValueKey('history-pick-file')), findsNothing);

          // Bound owner and profile shown, initial page loaded.
          expect(
            find.textContaining('Destination profile: field-work'),
            findsOneWidget,
          );
          expect(backend.foreignLists.single['profile'], 'field-work');
          expect(find.text('Plan the release'), findsOneWidget);

          // Load second page via next_offset.
          await tester.tap(find.byKey(const ValueKey('history-foreign-more')));
          await _settle(tester);
          expect(find.text('Migrate database'), findsOneWidget);
          expect(
            find.textContaining(FakeHistoryBackend.fixtureToken),
            findsNothing,
          );

          // Filter by search query (matches title/cwd/excerpt).
          await tester.enterText(
            find.byKey(const ValueKey('history-foreign-search')),
            'claude-project',
          );
          await tester.pump();
          expect(find.text('Plan the release'), findsOneWidget);
          expect(find.text('Migrate database'), findsNothing);

          // Preview selected host session: secret redacted, import not sent yet.
          await tester.tap(
            find.byKey(
              const ValueKey(
                'history-foreign-${FakeHistoryBackend.claudeHandle}',
              ),
            ),
          );
          await _settle(tester);
          expect(
            backend.foreignPreviews.single['id'],
            FakeHistoryBackend.claudeHandle,
          );
          expect(backend.foreignPreviews.single['profile'], 'field-work');
          expect(find.text('Checklist looks ready.'), findsOneWidget);
          expect(
            find.textContaining(FakeHistoryBackend.fixtureToken),
            findsNothing,
          );
          expect(backend.foreignImports, isEmpty);

          // Confirm and import into the bound profile.
          final importBtn = find.byKey(const ValueKey('history-import-host'));
          await _reveal(tester, importBtn);
          await tester.tap(importBtn);
          await _settle(tester);
          expect(backend.foreignImports, isEmpty);

          await tester.tap(find.byKey(const ValueKey('history-confirm')));
          await _settle(tester);
          expect(backend.foreignImports, hasLength(1));
          expect(backend.foreignImports.single, {
            'id': FakeHistoryBackend.claudeHandle,
            'profile': 'field-work',
          });
          expect(find.text('Imported as imported-host-1'), findsOneWidget);

          // Open the newly imported chat.
          await tester.tap(find.byKey(const ValueKey('history-open-session')));
          await _settle(tester);
          if (!classic) {
            expect(openedSessionId, 'imported-host-1');
            expect(openedTitle, 'Plan the release');
          } else {
            expect(find.text('Plan the release'), findsWidgets);
          }
        } finally {
          await tester.pumpWidget(const SizedBox.shrink());
          await disposeShell();
          await tester.pump();
        }
      },
    );

    testWidgets(
      '$label shows clear unsupported state when gateway refuses session.foreign.list',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final backend = FakeHistoryBackend(
          profile: 'field-work',
          foreignSupported: false,
        );
        addTearDown(backend.close);

        await tester.pumpWidget(
          MaterialApp(
            theme: classic
                ? null
                : nextGenTheme(Brightness.dark, NextGenLook.instance),
            localizationsDelegates: classic
                ? AppLocalizations.localizationsDelegates
                : null,
            supportedLocales: classic
                ? AppLocalizations.supportedLocales
                : const [Locale('en')],
            home: SessionHistoryPage(
              owner: backend.owner,
              storedSessionId: FakeHistoryBackend.session,
            ),
          ),
        );
        await _settle(tester);

        final unsupported = find.byKey(
          const ValueKey('history-foreign-unsupported'),
        );
        await _reveal(tester, unsupported);
        expect(
          find.text(
            'Claude and Codex import is not supported by this gateway.',
          ),
          findsOneWidget,
        );
        expect(find.byKey(const ValueKey('history-import-host')), findsNothing);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets(
      '$label filters by Codex source, previews truncated already-imported session, and re-opens idempotent copy via host route',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(800, 1200);
        addTearDown(tester.view.reset);

        final backend = FakeHistoryBackend(profile: 'field-work');
        addTearDown(backend.close);

        String? openedSessionId;
        String? openedTitle;
        late final Future<void> Function() disposeShell;
        late final Widget app;

        if (classic) {
          final client = _ClassicDesktopClient(backend.owner);
          final normal = NormalGatewayApplicationSession(
            connection: backend.connection,
            scope: 'foreign-import-codex-classic',
            client: client,
            submit:
                ({
                  required sessionId,
                  required text,
                  required onEvent,
                  required onSent,
                }) async {},
            resume:
                ({required localSessionId, required storedSessionId}) async =>
                    const ResumedGatewaySession(runtimeSessionId: 'rt-2'),
            history: (_) async => const [],
          );
          final controller = _OwnerController(normal);
          await normal.ready;
          disposeShell = controller.close;
          app = MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ChatScreen(
              connection: backend.connection,
              session: Session(
                id: 'local-draft',
                title: 'New chat',
                model: 'fixture',
                source: 'mobile',
                messageCount: 0,
                isActive: true,
                preview: '',
                startedAt: 1,
                isLocalDraft: true,
              ),
              turnApplicationController: controller,
              testProjectOverviewLoader: () async => ProjectsTreeOverview.empty,
              testApiClient: backend.apiClient,
              testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
              onOpenSession: (session) async {
                openedSessionId = session.id;
                openedTitle = session.title;
              },
            ),
          );
        } else {
          final prefs = await SharedPreferences.getInstance();
          final gateway = _NgHistoryGateway(backend);
          final chat = NgChatController(gateway);
          disposeShell = () async {
            chat.dispose();
            gateway.dispose();
          };
          app = MaterialApp(
            theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
            home: NgScope(
              connManager: ConnectionManager(prefs),
              gateway: gateway,
              connections: [backend.connection],
              switchTo: (_) async {},
              addGateway: () async {},
              signOut: (_) async {},
              reload: () async {},
              signInAgain: () async {},
              child: NgChatView(
                chat: chat,
                onOpenSidebar: () {},
                onNewChat: () {},
                onOpenSessionId: (id, {title}) {
                  openedSessionId = id;
                  openedTitle = title;
                },
              ),
            ),
          );
        }

        try {
          await tester.pumpWidget(app);
          await tester.pump(const Duration(milliseconds: 200));

          if (classic) {
            await tester.tap(find.byTooltip('Chat actions'));
            await _settle(tester);
            await tester.tap(find.text('Import Claude or Codex'));
          } else {
            await tester.tap(find.byKey(const ValueKey('session-history')));
          }
          await _settle(tester);

          // Filter directly to Codex source (session.foreign.list with source='codex').
          await tester.tap(find.text('Codex'));
          await _settle(tester);
          expect(backend.foreignLists.last, {
            'source': 'codex',
            'offset': 0,
            'limit': 25,
            'profile': 'field-work',
          });
          expect(find.text('Plan the release'), findsNothing);

          final codexTile = find.byKey(
            const ValueKey('history-foreign-${FakeHistoryBackend.codexHandle}'),
          );
          await _reveal(tester, codexTile);
          await tester.tap(codexTile);
          await _settle(tester);

          // Preview contract (b7ee21c14e): truncated + already_imported + cwd + redaction.
          expect(backend.foreignPreviews.last, {
            'id': FakeHistoryBackend.codexHandle,
            'profile': 'field-work',
          });
          expect(find.text('Preview shows 2 of 52.'), findsOneWidget);
          expect(find.text('Directory: /srv/codex-project'), findsOneWidget);
          expect(find.text('Open imported session'), findsOneWidget);
          expect(
            find.textContaining(FakeHistoryBackend.fixtureToken),
            findsNothing,
          );

          final openImported = find.byKey(
            const ValueKey('history-import-host'),
          );
          await _reveal(tester, openImported);
          await tester.tap(openImported);
          await _settle(tester);
          await tester.tap(find.byKey(const ValueKey('history-confirm')));
          await _settle(tester);

          expect(backend.foreignImports.single, {
            'id': FakeHistoryBackend.codexHandle,
            'profile': 'field-work',
          });
          expect(
            find.text('Already imported as existing-codex-1'),
            findsOneWidget,
          );

          await tester.tap(find.byKey(const ValueKey('history-open-session')));
          await _settle(tester);
          expect(openedSessionId, 'existing-codex-1');
          expect(openedTitle, 'Migrate database');
        } finally {
          await tester.pumpWidget(const SizedBox.shrink());
          await disposeShell();
          await tester.pump();
        }
      },
    );
  }
}
