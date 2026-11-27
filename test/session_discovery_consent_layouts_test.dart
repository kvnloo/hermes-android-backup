import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/workspace_sessions_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/session_search_client.dart';
import 'package:hermes_android/core/services/session_search_preferences.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/sessions_sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'support/session_search_controls.dart';

SavedConnection _connection(String id, String profile) => SavedConnection(
  id: id,
  label: '$id/$profile',
  host: 'consent.invalid',
  port: 8642,
  useHttps: true,
  dashboardPortOverride: 9443,
  dashboardPrefix: '/hermes',
  apiKey: '',
  desktopGatewayUrl: 'https://consent.invalid:9443/hermes',
  gatewayProfile: profile,
  singleLogin: true,
  dashboardUsername: 'fixture-user',
  dashboardPassword: 'fixture-password',
);

http.Response _json(Object data) => http.Response(jsonEncode(data), 200);

class _HeldModeStore extends InMemorySharedPreferencesStore {
  _HeldModeStore() : super.empty();
  final gate = Completer<void>();
  bool held = false;

  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (!held && key.endsWith('.mode') && value == 'server') {
      held = true;
      await gate.future;
    }
    return super.setValue(type, key, value);
  }
}

class _Endpoint {
  _Endpoint(this.connection) {
    dashboard = DashboardClient.fromConnection(
      connection,
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/hermes/auth/password-login') {
          await loginGate?.future;
          return http.Response(
            '{}',
            200,
            headers: {
              'set-cookie': 'hermes_session_at=fixture-session; Path=/',
            },
          );
        }
        if (request.url.path == '/hermes/api/sessions/search') {
          return searchGate?.future ??
              _json({
                'profile': connection.gatewayProfile,
                'results': [
                  {
                    'id': 'buried-${connection.gatewayProfile}',
                    'title': 'Buried ${connection.gatewayProfile}',
                    'source': 'desktop',
                    'message_count': 2,
                    'snippet': 'private proof ${connection.gatewayProfile}',
                  },
                ],
              });
        }
        if (request.url.path == '/hermes/api/config') {
          return _json({
            'sessions': {'show_subagents': false},
          });
        }
        if (request.url.path == '/hermes/api/sessions') {
          return _json({'sessions': [], 'total': 0});
        }
        return http.Response('{}', 404);
      }),
    );
    gateway = NextGenGateway(connection, dashboard: dashboard);
  }

  final SavedConnection connection;
  late final DashboardClient dashboard;
  late final NextGenGateway gateway;
  final requests = <http.Request>[];
  Completer<void>? loginGate;
  Completer<http.Response>? searchGate;

  List<http.Request> get searches =>
      requests.where((r) => r.url.path.endsWith('/sessions/search')).toList();

  void dispose() {
    // Always release barriers before disposing the real transports.
    final login = loginGate;
    if (login != null && !login.isCompleted) login.complete();
    final search = searchGate;
    if (search != null && !search.isCompleted) {
      search.complete(_json({'results': []}));
    }
    gateway.dispose();
  }
}

class _Layout {
  _Layout(this.nextGen, this.prefs);
  final bool nextGen;
  final SharedPreferences prefs;
  final endpoints = <_Endpoint>[];
  NgSessionsModel? model;

  _Endpoint endpoint(String id, String profile) {
    final endpoint = _Endpoint(_connection(id, profile));
    endpoints.add(endpoint);
    return endpoint;
  }

  NgScope scope(_Endpoint endpoint, Widget child) => NgScope(
    connManager: ConnectionManager(prefs),
    gateway: endpoint.gateway,
    connections: endpoints.map((e) => e.connection).toList(),
    switchTo: (_) async {},
    addGateway: () async {},
    signOut: (_) async {},
    reload: () async {},
    signInAgain: () async {},
    child: child,
  );

  Finder get field => find.byKey(
    nextGen ? const Key('ng-session-search') : kWorkspaceSessionSearchKey,
  );

  Future<void> mount(
    WidgetTester tester,
    _Endpoint endpoint, {
    bool refresh = true,
  }) async {
    Widget child;
    if (nextGen) {
      final currentScope = scope(endpoint, const SizedBox());
      final current = model;
      if (current == null) {
        model = NgSessionsModel(currentScope);
      } else {
        current.scope = currentScope;
      }
      child = scope(
        endpoint,
        Scaffold(
          body: NgSessionsSidebar(
            model: model!,
            currentSessionId: null,
            onOpen: (_) {},
            onNewChat: () {},
            onDestination: (_) {},
          ),
        ),
      );
      if (refresh) unawaited(model!.refresh());
    } else {
      child = Scaffold(
        body: WorkspaceSessionsScreen(
          title: 'Chats',
          view: WorkspaceSessionView.all,
          embedded: true,
          load: () async => WorkspaceSessionsData(sessions: []),
          searchScope: endpoint.connection,
          searchMessages: (query, maySend) =>
              SessionSearchClient.searchDashboard(
                endpoint.dashboard,
                query,
                profile: endpoint.connection.gatewayProfile,
                maySend: maySend,
              ),
          onOpenSession: (_) {},
        ),
      );
    }
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: nextGenTheme(Brightness.light, NextGenLook.instance),
        home: child,
      ),
    );
    await tester.pump();
  }

  Future<void> type(WidgetTester tester, String query) async {
    await tester.enterText(field, query);
    await tester.pump(const Duration(milliseconds: 350));
    // Consent persistence and cookie authentication each cross asynchronous
    // boundaries before the 300 ms search timer/network continuation runs.
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
  }

  void dispose() {
    model?.dispose();
    for (final endpoint in endpoints) {
      endpoint.dispose();
    }
  }
}

void main() {
  for (final nextGen in [false, true]) {
    final name = nextGen ? 'NextGen' : 'Classic';
    group(name, () {
      late _Layout layout;
      setUp(() async {
        SharedPreferences.setMockInitialValues({});
        layout = _Layout(nextGen, await SharedPreferences.getInstance());
      });
      tearDown(() => layout.dispose());

      testWidgets(
        '$name grants and withdraws only the selected connection/profile',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(800, 1400));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final a = layout.endpoint('one', 'research');
          final b = layout.endpoint('one', 'personal');
          // Same address and profile, but a different saved connection.
          final c = layout.endpoint('two', 'research');
          await layout.mount(tester, a);
          await tester.pumpAndSettle();
          await layout.type(tester, 'private');
          expect(a.searches, isEmpty);
          await chooseGatewaySearch(tester, enable: true);
          await tester.pump(const Duration(milliseconds: 350));
          await tester.pump();
          expect(
            a.searches,
            hasLength(1),
            reason: 'Requests: ${a.requests.map((r) => r.url).toList()}',
          );
          expect(a.searches.single.url.queryParameters['profile'], 'research');
          expect(find.text('private proof research'), findsOneWidget);

          await layout.mount(tester, b);
          await tester.pumpAndSettle();
          expect(find.byTooltip('Search mode: On-device'), findsOneWidget);
          await layout.type(tester, 'private');
          expect(b.searches, isEmpty);
          expect(find.text('private proof research'), findsNothing);
          await chooseGatewaySearch(tester, enable: true);
          await tester.pump(const Duration(milliseconds: 350));
          await tester.pump();
          expect(b.searches, hasLength(1));
          expect(b.searches.single.url.queryParameters['profile'], 'personal');
          expect(find.text('private proof personal'), findsOneWidget);

          await layout.mount(tester, c);
          await tester.pumpAndSettle();
          expect(find.byTooltip('Search mode: On-device'), findsOneWidget);
          await layout.type(tester, 'private');
          expect(c.searches, isEmpty);

          await layout.mount(tester, a);
          await tester.pumpAndSettle();
          expect(
            find.byTooltip('Search mode: Full-text (gateway)'),
            findsOneWidget,
          );
          await chooseGatewaySearch(tester, enable: false);
          final store = SessionSearchPreferences(layout.prefs);
          expect(
            store.readMode(
              connectionIdentity: sessionSearchIdentity(a.connection),
            ),
            SessionSearchMode.local,
          );
          expect(
            store.readMode(
              connectionIdentity: sessionSearchIdentity(b.connection),
            ),
            SessionSearchMode.server,
          );
          await layout.mount(tester, b);
          await tester.pumpAndSettle();
          expect(
            find.byTooltip('Search mode: Full-text (gateway)'),
            findsOneWidget,
          );
          await tester.pumpWidget(const SizedBox());
        },
      );

      testWidgets(
        '$name asks again instead of borrowing the old gateway-wide grant',
        (tester) async {
          final a = layout.endpoint('legacy', 'research');
          final c = a.connection;
          final legacy =
              '${c.baseUrl}|${c.gatewayPrefix ?? ''}|${c.desktopGatewayUrl ?? ''}';
          await layout.prefs.setString(
            'session_search.${Uri.encodeComponent(legacy)}.mode',
            'server',
          );
          await layout.mount(tester, a);
          await tester.pumpAndSettle();
          expect(find.byTooltip('Search mode: On-device'), findsOneWidget);
          await layout.type(tester, 'private');
          expect(a.searches, isEmpty);
          await tester.pumpWidget(const SizedBox());
        },
      );

      testWidgets('$name fences a held preference grant on profile departure', (
        tester,
      ) async {
        final previous = SharedPreferencesStorePlatform.instance;
        final physical = _HeldModeStore();
        SharedPreferencesStorePlatform.instance = physical;
        addTearDown(() async {
          if (!physical.gate.isCompleted) physical.gate.complete();
          await tester.pump();
          SharedPreferencesStorePlatform.instance = previous;
        });
        final a = layout.endpoint('save-fence', 'research');
        final b = layout.endpoint('save-fence', 'personal');
        await layout.mount(tester, a);
        await tester.pumpAndSettle();
        await layout.type(tester, 'private');
        await chooseGatewaySearch(tester, enable: true);
        expect(physical.held, isTrue);
        expect(a.searches, isEmpty);
        expect(find.byTooltip('Search mode: On-device'), findsOneWidget);
        await layout.mount(tester, b);
        await layout.type(tester, 'private');
        physical.gate.complete();
        await tester.pumpAndSettle();
        expect(a.searches, isEmpty);
        expect(b.searches, isEmpty);
        expect(find.byTooltip('Search mode: On-device'), findsOneWidget);
        await layout.prefs.reload();
        final store = SessionSearchPreferences(layout.prefs);
        for (final endpoint in [a, b]) {
          expect(
            store.readMode(
              connectionIdentity: sessionSearchIdentity(endpoint.connection),
            ),
            SessionSearchMode.local,
          );
        }
        await layout.mount(tester, a);
        await tester.pumpAndSettle();
        expect(find.byTooltip('Search mode: On-device'), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('$name fences authentication across a profile switch', (
        tester,
      ) async {
        final a = layout.endpoint('auth-fence', 'research');
        final b = layout.endpoint('auth-fence', 'personal');
        await SessionSearchPreferences(layout.prefs).saveMode(
          connectionIdentity: sessionSearchIdentity(a.connection),
          mode: SessionSearchMode.server,
        );
        await layout.mount(tester, a);
        await tester.pumpAndSettle();
        // Browsing may already have acquired a cookie in NextGen; use a new
        // endpoint for this scope to force a fresh authenticated search.
        final held = layout.endpoint('auth-fence', 'research');
        held.loginGate = Completer<void>();
        await layout.mount(tester, held, refresh: false);
        await layout.type(tester, 'private');
        expect(
          held.requests.where((r) => r.url.path.endsWith('/password-login')),
          hasLength(1),
        );
        expect(held.searches, isEmpty);
        await layout.mount(tester, b);
        await layout.type(tester, 'private');
        held.loginGate!.complete();
        await tester.pumpAndSettle();
        expect(held.searches, isEmpty);
        expect(b.searches, isEmpty);
        expect(find.byTooltip('Search mode: On-device'), findsOneWidget);
        expect(find.text('private proof research'), findsNothing);
        await tester.pumpWidget(const SizedBox());
      });

      for (final fail in [false, true]) {
        testWidgets(
          '$name rejects departed-profile search ${fail ? 'failure' : 'hits'}',
          (tester) async {
            final a = layout.endpoint('response-fence', 'research');
            final b = layout.endpoint('response-fence', 'personal');
            await SessionSearchPreferences(layout.prefs).saveMode(
              connectionIdentity: sessionSearchIdentity(a.connection),
              mode: SessionSearchMode.server,
            );
            await layout.mount(tester, a);
            await tester.pumpAndSettle();
            a.searchGate = Completer<http.Response>();
            await layout.type(tester, 'private');
            expect(a.searches, hasLength(1));
            await layout.mount(tester, b);
            await layout.type(tester, 'private');
            a.searchGate!.complete(
              fail
                  ? http.Response('{}', 503)
                  : _json({
                      'profile': 'research',
                      'results': [
                        {
                          'id': 'old-private',
                          'title': 'Departed private title',
                          'snippet': 'private departed excerpt',
                        },
                      ],
                    }),
            );
            await tester.pumpAndSettle();
            expect(b.searches, isEmpty);
            expect(find.text('Departed private title'), findsNothing);
            expect(find.text('private departed excerpt'), findsNothing);
            expect(find.textContaining('HTTP 503'), findsNothing);
            expect(find.byTooltip('Search mode: On-device'), findsOneWidget);
            await tester.pumpWidget(const SizedBox());
          },
        );
      }
    });
  }
}
