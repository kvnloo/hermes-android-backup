import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hermes_android/core/services/session_search_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/dashboard_api_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/sessions_sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/mtls_fixture.dart';
import 'support/session_search_controls.dart';
import 'package:hermes_android/core/services/session_search_preferences.dart';

const _excluded = 'oneshot,subagent,kanban,tool';
const _internal = ['oneshot', 'subagent', 'kanban', 'tool'];

Map<String, dynamic> _row(String id, {String source = 'desktop'}) => {
  'id': id,
  'title': 'Row $id',
  'source': source,
  'message_count': 2,
  'started_at': 1000,
  'last_active': 2000,
  'unread': true,
};

http.Response _json(Object value) => http.Response(jsonEncode(value), 200);

class _Fixture {
  _Fixture(this.prefs, {this.showSubagents = false, this.configStatus = 200}) {
    connection = SavedConnection(
      id: 'selected',
      label: 'Selected gateway',
      host: 'api.not-selected.test',
      port: 8642,
      apiKey: '',
      desktopGatewayUrl: 'https://selected.test:9443/hermes',
      gatewayProfile: 'research',
      singleLogin: true,
      dashboardUsername: 'fixture-user',
      dashboardPassword: 'fixture-password',
    );
    dashboard = DashboardClient.fromConnection(
      connection,
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/hermes/auth/password-login') {
          await heldLogin?.future;
          return http.Response(
            '{}',
            200,
            headers: {
              'set-cookie': 'hermes_session_at=fixture-session; Path=/',
            },
          );
        }
        if (request.url.path == '/hermes/api/sessions/buried') {
          if (request.method == 'PATCH') {
            archived = true;
            return _json({});
          }
          return _json({
            'session': {'id': 'buried', 'archived': archived},
          });
        }
        if (request.url.path == '/hermes/api/config') {
          if (heldConfig != null) return heldConfig!.future;
          return configStatus == 200
              ? _json({
                  'sessions': {'show_subagents': showSubagents},
                })
              : http.Response('{}', configStatus);
        }
        if (request.url.path == '/hermes/api/sessions/search') {
          return heldSearch?.future ??
              Future.value(searchReply ?? _json({'results': searchRows}));
        }
        if (request.url.path == '/hermes/api/sessions') {
          final offset = int.parse(
            request.url.queryParameters['offset'] ?? '0',
          );
          if (serverRows != null) {
            final excluded =
                (request.url.queryParameters['exclude_sources'] ?? '')
                    .split(',')
                    .toSet();
            if (showSubagents == true) excluded.remove('subagent');
            final rows = serverRows!
                .where((row) => !excluded.contains(row['source']))
                .toList();
            final limit = int.parse(request.url.queryParameters['limit']!);
            return _json({
              'sessions': rows.skip(offset).take(limit).toList(),
              'total': rows.length,
            });
          }
          return _json({'sessions': pages[offset] ?? [], 'total': total});
        }
        return http.Response('{}', 404);
      }),
    );
    gateway = NextGenGateway(connection, dashboard: dashboard);
    model = NgSessionsModel(scope(const SizedBox()));
  }

  final SharedPreferences prefs;
  final Object showSubagents;
  final int configStatus;
  final requests = <http.Request>[];
  final pages = <int, List<Map<String, dynamic>>>{};
  List<Map<String, dynamic>>? serverRows;
  Completer<void>? heldLogin;
  Completer<http.Response>? heldSearch;
  http.Response? searchReply;
  Completer<http.Response>? heldConfig;
  List<Map<String, dynamic>> searchRows = [];
  int total = 0;
  bool archived = false;
  late final SavedConnection connection;
  late final DashboardClient dashboard;
  late final NextGenGateway gateway;
  late NgSessionsModel model;

  List<http.Request> get listing =>
      requests.where((r) => r.url.path == '/hermes/api/sessions').toList();

  NgScope scope(Widget child) => NgScope(
    connManager: ConnectionManager(prefs),
    gateway: gateway,
    connections: [connection],
    switchTo: (_) async {},
    addGateway: () async {},
    signOut: (_) async {},
    reload: () async {},
    signInAgain: () async {},
    child: child,
  );

  Widget get widget => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: nextGenTheme(Brightness.light, NextGenLook.instance),
    home: scope(
      Scaffold(
        body: NgSessionsSidebar(
          model: model,
          currentSessionId: null,
          onOpen: (_) {},
          onNewChat: () {},
          onDestination: (_) {},
        ),
      ),
    ),
  );

  void dispose() {
    model.dispose();
    gateway.dispose();
  }
}

Future<_Fixture> _fixture({
  Object showSubagents = false,
  int configStatus = 200,
}) async {
  SharedPreferences.setMockInitialValues({});
  final fixture = _Fixture(
    await SharedPreferences.getInstance(),
    showSubagents: showSubagents,
    configStatus: configStatus,
  );
  addTearDown(fixture.dispose);
  return fixture;
}

void main() {
  for (final savedLocal in [false, true]) {
    testWidgets(
      'NextGen sends no local queries and revokes held search (saved: $savedLocal)',
      (t) async {
        final f = await _fixture();
        final prefs = SessionSearchPreferences(f.prefs);
        final identity = sessionSearchIdentity(f.connection);
        if (savedLocal) {
          await prefs.saveMode(
            connectionIdentity: identity,
            mode: SessionSearchMode.local,
          );
          f.model.dispose();
          f.model = NgSessionsModel(f.scope(const SizedBox()));
        }
        f.pages[0] = [_row('local')];
        await f.model.refresh();
        await t.pumpWidget(f.widget);
        final field = find.byKey(const Key('ng-session-search'));
        List<String?> queries() => [
          for (final r in f.requests)
            if (r.url.path.endsWith('/sessions/search'))
              r.url.queryParameters['q'],
        ];
        await t.enterText(field, 'local');
        await t.pump(const Duration(milliseconds: 350));
        await f.model.refresh();
        expect(queries(), isEmpty);
        expect(find.text('Row local'), findsOneWidget);
        final held = f.heldSearch = Completer();
        await chooseGatewaySearch(t, enable: true);
        await t.pump(const Duration(milliseconds: 350));
        expect(queries(), ['local']);
        expect(f.model.loading, isTrue);
        await chooseGatewaySearch(t, enable: false);
        expect(find.text('Row local'), findsOneWidget);
        expect(f.model.loading, isFalse);
        held.complete(
          _json({
            'results': [
              {'id': 'buried', 'snippet': 'secret excerpt'},
            ],
          }),
        );
        await t.pumpAndSettle();
        expect(find.text('secret excerpt'), findsNothing);
        await t.enterText(field, 'private again');
        await t.pump(const Duration(milliseconds: 350));
        expect(queries(), ['local']);
        expect(
          prefs.readMode(connectionIdentity: identity),
          SessionSearchMode.local,
        );
        await t.pumpWidget(const SizedBox());
      },
    );
  }
  for (final after401 in [false, true]) {
    test(
      'revocation during dashboard login blocks query dispatch (retry: $after401)',
      () async {
        final f = await _fixture();
        await f.model.searchAccess.setServer(true);
        f.model.query = 'private';
        if (after401) {
          f.heldSearch = Completer();
        } else {
          f.heldLogin = Completer();
        }
        final refresh = f.model.refresh();
        await pumpEventQueue();
        final expected = after401 ? 1 : 0;
        int searches() => f.requests
            .where((r) => r.url.path.endsWith('/sessions/search'))
            .length;
        expect(searches(), expected);
        if (after401) {
          f.heldLogin = Completer();
          f.heldSearch!.complete(http.Response('{}', 401));
          await pumpEventQueue();
        }
        expect(
          f.requests
              .where((r) => r.url.path.endsWith('/password-login'))
              .length,
          after401 ? 2 : 1,
        );
        await f.model.searchAccess.setServer(false);
        f.heldLogin!.complete();
        await refresh;
        expect(searches(), expected);
        expect(f.model.error, isNull);
        expect(f.model.loading, isFalse);
      },
    );
  }
  testWidgets('same-query refresh must drop FTS-only rows on fallback', (
    t,
  ) async {
    final f = await _fixture();
    await f.model.searchAccess.setServer(true);
    f.pages[0] = [_row('local')];
    await f.model.refresh();
    await t.pumpWidget(f.widget);
    f.searchRows = [
      {
        'session_id': 'buried',
        'title': 'Remote only',
        'snippet': 'private excerpt',
      },
    ];
    await t.enterText(find.byKey(const Key('ng-session-search')), 'local');
    await t.pump(const Duration(milliseconds: 350));
    await t.pumpAndSettle();
    expect(find.text('private excerpt'), findsOneWidget);
    final unavailable = f.heldSearch = Completer();
    final refresh = f.model.refresh();
    await t.pump();
    unavailable.completeError(http.ClientException('fixture offline'));
    await refresh;
    await t.pump();
    expect(f.model.error, contains('Showing local matches'));
    expect(find.text('Row local'), findsOneWidget);
    expect(find.text('private excerpt'), findsNothing);
  });
  testWidgets('archive read-back wins over older held search', (t) async {
    final f = await _fixture();
    await f.model.searchAccess.setServer(true);
    await f.model.refresh();
    await t.pumpWidget(f.widget);
    f.searchRows = [
      {
        'session_id': 'buried',
        'title': 'Remote only',
        'snippet': 'content excerpt',
      },
    ];
    await t.enterText(find.byKey(const Key('ng-session-search')), 'content');
    await t.pump(const Duration(milliseconds: 350));
    await t.pumpAndSettle();
    await t.testTextInput.receiveAction(TextInputAction.done);
    await t.pumpAndSettle();
    expect(find.text('content excerpt'), findsOneWidget);
    final held = f.heldSearch = Completer();
    final old = f.model.refresh();
    await t.pump();
    expect(f.requests.where((r) => r.url.path.endsWith('/search')).length, 2);
    await t.longPress(find.text('Remote only'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 350));
    await t.tap(find.widgetWithText(ListTile, 'Archive'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 350));
    await t.pump();
    expect(f.archived, true);
    expect(f.model.sessions, isEmpty);
    expect(f.model.loading, true);
    expect(f.model.error, isNull);
    held.complete(_json({'results': f.searchRows}));
    await old;
    await t.pumpAndSettle();
    expect(find.text('Remote only'), findsNothing);
  });

  testWidgets(
    'NextGen organises known usage below pins and can show row metadata',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(700, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final f = await _fixture();
      f.pages[0] = [
        {..._row('pin'), 'pinned': true, 'total_tokens': 1},
        {..._row('small'), 'total_tokens': 2},
        {..._row('large'), 'total_tokens': 900},
      ];
      f.total = 3;
      await f.model.refresh();
      await tester.pumpWidget(f.widget);
      await tester.pumpAndSettle();
      Future<void> choose(String label) async {
        await tester.tap(find.byTooltip('Organise chats'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(CheckedPopupMenuItem<Object>, label),
        );
        await tester.pumpAndSettle();
      }

      await choose('Most tokens');
      await choose('Show model and usage');
      double y(String s) => tester.getTopLeft(find.text(s)).dy;
      expect(y('Row pin'), lessThan(y('Row large')));
      expect(y('Row large'), lessThan(y('Row small')));
      expect(find.textContaining('900 tokens'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'active NextGen search resolves stored IDs, shows excerpts, and distinguishes wrong scope and unsupported from empty',
    (tester) async {
      final f = await _fixture();
      await f.model.searchAccess.setServer(true);
      f.pages[0] = [_row('local')];
      f.total = 1;
      await f.model.refresh();
      await tester.pumpWidget(f.widget);
      final field = find.byKey(const Key('ng-session-search'));
      Future<void> query(String text) async {
        await tester.enterText(field, text);
        await tester.pump(const Duration(milliseconds: 350));
        await tester.pumpAndSettle();
      }

      f.searchRows = [
        {
          'session_id': 'buried',
          'title': 'Hidden conversation',
          'snippet': 'Found in a message',
        },
      ];
      await query('message');
      expect(find.text('Found in a message'), findsOneWidget);
      expect(f.model.sessions.single.id, 'buried');
      final old = f.heldSearch = Completer();
      await tester.enterText(field, 'old');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.enterText(field, 'local');
      old.complete(_json({'results': f.searchRows}));
      f.heldSearch = null;
      await tester.pump();
      expect(find.text('Hidden conversation'), findsNothing);
      expect(find.text('Row local'), findsOneWidget);
      f.searchReply = http.Response('{}', 404);
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('does not expose session search'),
        findsOneWidget,
      );
      expect(find.text('Row local'), findsOneWidget);
      f.searchReply = _json({'profile': 'different', 'results': f.searchRows});
      await query('scoped');
      expect(
        find.textContaining('Unexpected message search response'),
        findsOneWidget,
      );
      expect(find.text('Hidden conversation'), findsNothing);
      f.searchReply = _json({'results': []});
      await query('absent');
      expect(f.model.error, isNull);
      expect(f.model.sessions, isEmpty);
      await tester.pumpWidget(const SizedBox());
    },
  );
  test(
    'chat browse requests server exclusions on the selected authenticated origin',
    () async {
      final f = await _fixture();
      f.pages[0] = [for (var i = 0; i < 25; i++) _row('human-$i')];
      f.total = 25;
      await f.model.refresh();

      expect(f.listing, hasLength(1));
      expect(f.listing.single.url.queryParameters, {
        'profile': 'research',
        'limit': '60',
        'offset': '0',
        'order': 'recent',
        'archived': 'exclude',
        'exclude_sources': _excluded,
      });
      final configs = f.requests.where(
        (r) => r.url.path.endsWith('/api/config'),
      );
      expect(configs, hasLength(1));
      expect(configs.single.url.queryParameters['profile'], 'research');
      expect(
        f.requests.where((r) => r.url.path.endsWith('/auth/password-login')),
        hasLength(1),
      );
      expect(
        f.requests.every(
          (r) =>
              r.url.host == 'selected.test' &&
              r.url.port == 9443 &&
              r.url.scheme == 'https',
        ),
        isTrue,
      );
      expect(f.listing.single.headers.containsKey('cookie'), isTrue);
    },
  );

  test(
    'a supporting server excludes workers before applying its page window',
    () async {
      final f = await _fixture();
      f.serverRows = [
        for (var i = 0; i < 240; i++)
          _row('worker-$i', source: _internal[i % 4]),
        for (var i = 0; i < 25; i++) _row('human-$i'),
      ];
      await f.model.refresh();
      expect(f.listing, hasLength(1));
      expect(f.model.sessions, hasLength(25));
      expect(f.model.unreadCount, 25);
      expect(f.model.hasMore, isFalse);
    },
  );

  test(
    'a replacement connection rejects an old held preference and list read',
    () async {
      final old = await _fixture(showSubagents: false);
      final replacement = await _fixture(showSubagents: true);
      old.heldConfig = Completer<http.Response>();
      final refreshing = old.model.refresh();
      await pumpEventQueue();
      old.model.scope = replacement.scope(const SizedBox());
      old.heldConfig!.complete(
        _json({
          'sessions': {'show_subagents': false},
        }),
      );
      await refreshing;
      expect(old.listing, isEmpty);
      replacement.pages[0] = [_row('subagent', source: 'subagent')];
      replacement.total = 1;
      await old.model.refresh();
      expect(old.model.unreadCount, 1);
      expect(
        replacement.listing.single.url.queryParameters['exclude_sources'],
        _excluded,
      );
    },
  );

  test('a disposed owner stops after a held preference read', () async {
    SharedPreferences.setMockInitialValues({});
    final f = _Fixture(await SharedPreferences.getInstance());
    f.heldConfig = Completer<http.Response>();
    final refreshing = f.model.refresh();
    await pumpEventQueue();
    f.model.dispose();
    f.heldConfig!.complete(
      _json({
        'sessions': {'show_subagents': false},
      }),
    );
    await refreshing;
    expect(f.listing, isEmpty);
    f.gateway.dispose();
  });

  test(
    'older servers fill refresh and load-more past excluded raw windows',
    () async {
      final f = await _fixture();
      List<Map<String, dynamic>> internal(int start) => [
        for (var i = start; i < start + 60; i++)
          _row('worker-$i', source: _internal[i % _internal.length]),
      ];
      f.pages[0] = internal(0);
      f.pages[60] = [
        for (var i = 0; i < 20; i++) _row('human-$i'),
        for (var i = 0; i < 40; i++) _row('cron-$i', source: 'cron'),
      ];
      f.pages[120] = internal(120);
      f.pages[180] = [_row('deep'), _row('human-0')];
      f.total = 182;
      await f.model.refresh();
      expect(f.listing.map((r) => r.url.queryParameters['offset']), [
        '0',
        '60',
      ]);
      expect(f.model.unreadCount, 20);
      expect(f.model.hasMore, isTrue);

      await f.model.loadMore();
      expect(f.listing.map((r) => r.url.queryParameters['offset']), [
        '0',
        '60',
        '120',
        '180',
      ]);
      expect(
        f.listing.every(
          (r) => r.url.queryParameters['exclude_sources'] == _excluded,
        ),
        isTrue,
      );
      expect(f.model.sessions.where((s) => s.id == 'deep'), hasLength(1));
      expect(f.model.sessions.where((s) => s.id == 'human-0'), hasLength(1));
      expect(f.model.unreadCount, 21);
      expect(f.model.hasMore, isFalse);
    },
  );

  test(
    'older machine-only refresh stays bounded and keeps a resumable cursor',
    () async {
      final f = await _fixture();
      for (var page = 0; page < 10; page++) {
        f.pages[page * 60] = [
          for (var i = 0; i < 60; i++)
            _row('worker-${page * 60 + i}', source: 'oneshot'),
        ];
      }
      f.pages[600] = [_row('deep')];
      f.total = 601;
      await f.model.refresh();
      expect(f.listing, hasLength(10));
      expect(f.model.unreadCount, 0);
      expect(f.model.topAttention, NgChatAttention.none);
      expect(f.model.hasMore, isTrue);
      await f.model.loadMore();
      expect(f.listing, hasLength(11));
      expect(f.listing.last.url.queryParameters['offset'], '600');
      expect(f.model.unreadCount, 1);
    },
  );

  for (final show in [false, true, 'yes']) {
    testWidgets(
      'mounted sidebar respects profile Show subagents=$show without showing other workers',
      (tester) async {
        final f = await _fixture(showSubagents: show);
        f.pages[0] = [
          _row('human'),
          for (final source in _internal) _row(source, source: source),
          _row('cron', source: 'cron'),
        ];
        f.total = f.pages[0]!.length;
        await f.model.refresh();
        await tester.pumpWidget(f.widget);
        await tester.pumpAndSettle();
        expect(find.text('Row human'), findsOneWidget);
        expect(
          find.text('Row subagent'),
          show == false ? findsNothing : findsOneWidget,
        );
        for (final source in ['oneshot', 'kanban', 'tool', 'cron']) {
          expect(find.text('Row $source'), findsNothing);
        }
        expect(f.model.unreadCount, show == false ? 1 : 2);
        expect(
          f.listing.single.url.queryParameters['exclude_sources'],
          _excluded,
        );
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets(
    'an unreadable preference preserves server-returned subagents, not other workers',
    (tester) async {
      final f = await _fixture(configStatus: 403);
      f.pages[0] = [
        _row('subagent', source: 'subagent'),
        _row('tool', source: 'tool'),
      ];
      f.total = 2;
      await f.model.refresh();
      await tester.pumpWidget(f.widget);
      await tester.pumpAndSettle();
      expect(find.text('Row subagent'), findsOneWidget);
      expect(find.text('Row tool'), findsNothing);
      expect(f.model.error, isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'Crons and search keep their unfiltered request and presentation scope',
    (tester) async {
      final f = await _fixture();
      await f.model.searchAccess.setServer(true);
      f.pages[0] = [_row('human'), _row('cron', source: 'cron')];
      f.total = 2;
      await f.model.refresh();
      await tester.pumpWidget(f.widget);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Crons'));
      await tester.tap(find.widgetWithText(ChoiceChip, 'Crons'));
      await tester.pumpAndSettle();
      expect(find.text('Row cron'), findsOneWidget);
      expect(find.text('Row human'), findsNothing);
      expect(f.listing, hasLength(2));
      expect(
        f.listing.last.url.queryParameters.containsKey('exclude_sources'),
        isFalse,
      );
      expect(f.listing.last.url.queryParameters['profile'], 'research');
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(f.widget);
      await tester.pumpAndSettle();
      expect(find.text('Row cron'), findsOneWidget);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Crons'))
            .selected,
        isTrue,
      );
      expect(f.listing, hasLength(2));

      await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'All'));
      await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
      await tester.pumpAndSettle();
      f.searchRows = [
        for (final source in _internal) _row('search-$source', source: source),
      ];
      final browseCount = f.listing.length;
      await tester.enterText(
        find.byKey(const Key('ng-session-search')),
        'needle',
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      final searches = f.requests.where(
        (r) => r.url.path.endsWith('/sessions/search'),
      );
      expect(searches, hasLength(1));
      expect(searches.single.url.queryParameters, {
        'profile': 'research',
        'q': 'needle',
        'limit': '60',
      });
      expect(f.listing, hasLength(browseCount));
      for (final source in _internal) {
        expect(find.text('Row search-$source'), findsOneWidget);
      }
      expect(f.model.hasMore, isFalse);
      await tester.pumpWidget(const SizedBox());
    },
  );

  test(
    'chat listing preserves real mutual TLS, dashboard prefix and profile',
    () async {
      final fixture = MutualTlsFixture();
      await fixture.start((request) async {
        if (request.uri.path.endsWith('/config')) {
          fixture.json(request, {
            'sessions': {'show_subagents': false},
          });
        } else {
          fixture.json(request, {
            'sessions': [_row('human')],
            'total': 1,
          });
        }
        await request.response.close();
      });
      addTearDown(fixture.close);
      await withLoopbackTrust(() async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final conn = SavedConnection(
          id: 'mtls',
          label: 'mTLS',
          host: 'unused.test',
          port: 8642,
          apiKey: '',
          desktopGatewayUrl: '${fixture.origin}/dashboard',
          dashboardProxied: true,
          gatewayProfile: 'research',
          clientCertificate: loopbackIdentity,
        );
        final gateway = NextGenGateway(conn);
        final model = NgSessionsModel(
          NgScope(
            connManager: ConnectionManager(prefs),
            gateway: gateway,
            connections: [conn],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: const SizedBox(),
          ),
        );
        addTearDown(() {
          model.dispose();
          gateway.dispose();
        });
        await model.refresh();
        expect(model.error, isNull);
        expect(model.sessions.single.id, 'human');
        expect(fixture.anonymousRequests, 0);
        expect(fixture.requests, hasLength(2));
        expect(fixture.requests.every((r) => r.certificate != null), isTrue);
        expect(
          fixture.requests.every(
            (r) => r.uri.queryParameters['profile'] == 'research',
          ),
          isTrue,
        );
        final listing = fixture.requests.singleWhere(
          (r) => r.uri.path == '/dashboard/api/sessions',
        );
        expect(listing.uri.queryParameters['exclude_sources'], _excluded);
      });
    },
  );

  test('rejects an oversized search page before mapping its rows', () async {
    final f = await _fixture();
    f.searchRows = [for (var i = 0; i < 61; i++) _row('item$i')];
    await expectLater(
      f.gateway.api.getSessionsPage(title: 'x', limit: 60),
      throwsA(
        isA<SessionSearchException>().having(
          (e) => e.message,
          'reason',
          contains('more search results'),
        ),
      ),
    );
    expect(f.requests.last.url.queryParameters['limit'], '60');
    f.searchRows.removeLast();
    expect(
      (await f.gateway.api.getSessionsPage(title: 'x', limit: 60)).sessions,
      hasLength(60),
    );
  });

  test('generic dashboard paging and search remain unfiltered', () async {
    final f = await _fixture();
    await f.gateway.api.getSessionsPage(limit: 12, offset: 7);
    await f.gateway.api.getSessionsPage(title: ' needle ');
    expect(f.listing.single.url.queryParameters, {
      'profile': 'research',
      'limit': '12',
      'offset': '7',
      'order': 'recent',
      'archived': 'exclude',
    });
    final search = f.requests.singleWhere(
      (r) => r.url.path.endsWith('/sessions/search'),
    );
    expect(search.url.queryParameters.containsKey('exclude_sources'), isFalse);
    expect(
      f.requests.where((r) => r.url.path.endsWith('/api/config')),
      isEmpty,
    );
  });

  test(
    'profile auto-selection counts the same human sources as chat browse',
    () async {
      final requests = <http.Request>[];
      final api = DashboardApiClient.fromConnection(
        SavedConnection(
          id: 'fixture',
          label: 'fixture',
          host: 'fixture.test',
          port: 443,
          apiKey: '',
          dashboardProxied: true,
        ),
        httpClient: MockClient((request) async {
          requests.add(request);
          if (request.url.path.endsWith('/config')) {
            return _json({
              'sessions': {'show_subagents': false},
            });
          }
          return _json({
            'sessions': request.url.queryParameters['profile'] == 'default'
                ? [for (final source in _internal) _row(source, source: source)]
                : [_row('human')],
          });
        }),
      );
      final counts = await api.visibleChatCounts(['default', 'research']);
      expect(counts, {'default': 0, 'research': 1});
      expect(profileHoldingVisibleChats(counts), 'research');
      expect(
        requests
            .where((r) => r.url.path.endsWith('/sessions'))
            .every(
              (r) => r.url.queryParameters['exclude_sources'] == _excluded,
            ),
        isTrue,
      );
    },
  );
}
