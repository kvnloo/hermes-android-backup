// Android-specific coverage for the docked NextGen sessions sidebar from the
// Apple port (see apple_adaptive_layout_test.dart for the shared contract):
// Android Automotive screens dock it, landscape phones keep the drawer, the
// sidebar button collapses/restores the dock, and sidebar search survives a
// window crossing the expanded breakpoint (foldable fold/unfold, resize).
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/utils/adaptive_layout.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

SavedConnection _connection() => SavedConnection(
  id: 'docked',
  label: 'Ares',
  host: 'gateway.example',
  port: 443,
  apiKey: '',
  useHttps: true,
  desktopGatewayUrl: 'https://gateway.example/hermes',
  dashboardPrefix: '/hermes',
  dashboardProxied: true,
  singleLogin: true,
  signInMethod: 'none',
);

class _Gateway extends NextGenGateway {
  _Gateway(super.connection)
    : super(
        dashboard: DashboardClient.fromConnection(
          connection,
          httpClient: MockClient((request) async {
            if (request.url.path.endsWith('/messages')) {
              return http.Response(jsonEncode({'messages': []}), 200);
            }
            if (request.url.path.endsWith('/sessions')) {
              return http.Response(
                jsonEncode({
                  'sessions': [
                    {
                      'id': 'docked-chat',
                      'title': 'Docked chat',
                      'source': 'cli',
                      'message_count': 2,
                      'started_at': 1750000000,
                      'last_active': 1750000000,
                    },
                  ],
                }),
                200,
              );
            }
            return http.Response(jsonEncode({'model': 'test-model'}), 200);
          }),
        ),
      );

  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

  final dummy = WsClient('https://gateway.example/hermes');

  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => dummy;

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async => {};
}

Future<void> _frames(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void _size(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
}

Future<void> _pump(WidgetTester tester, Size size) async {
  _size(tester, size);
  addTearDown(tester.view.reset);
  final prefs = await SharedPreferences.getInstance();
  final gateway = _Gateway(_connection());
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: nextGenTheme(Brightness.light, NextGenLook.instance),
      builder: (context, child) => NgLocalizationScope(
        child: NgScope(
          connManager: ConnectionManager(prefs),
          gateway: gateway,
          connections: [gateway.connection],
          switchTo: (_) async {},
          addGateway: () async {},
          signOut: (_) async {},
          reload: () async {},
          signInAgain: () async {},
          child: child!,
        ),
      ),
      // This suite verifies an opened chat, not the 5.0 cold-start landing.
      home: const NgMainPage(coldStart: false),
    ),
  );
  await _frames(tester);
}

final _search = find.byKey(const Key('ng-session-search'));
final _toggle = find.byKey(const ValueKey('ng-sidebar-button'));

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('car screens are expanded; short landscape phones are not', () {
    // Automotive 1024p landscape after system bars, and 800x1280 portrait.
    expect(
      adaptiveSizeClassOf(const Size(1024, 620)),
      AdaptiveSizeClass.expanded,
    );
    expect(
      adaptiveSizeClassOf(const Size(1067, 1600)),
      AdaptiveSizeClass.expanded,
    );
    // A landscape phone keeps the drawer (useful-height guard).
    expect(adaptiveSizeClassOf(const Size(915, 380)), AdaptiveSizeClass.medium);
  });

  testWidgets('compact window keeps the modal drawer', (tester) async {
    await _pump(tester, const Size(800, 600));
    expect(_search, findsNothing);
    await tester.tap(_toggle);
    await _frames(tester);
    final scaffold = tester.state<ScaffoldState>(find.byType(Scaffold).first);
    expect(scaffold.isDrawerOpen, isTrue);
    expect(_search, findsOneWidget);
  });

  testWidgets('car landscape docks the sidebar beside the chat', (
    tester,
  ) async {
    await _pump(tester, const Size(1024, 620));
    expect(find.byType(Drawer), findsNothing);
    expect(_search, findsOneWidget);
    expect(find.text('Docked chat'), findsOneWidget);
    expect(find.byType(NgChatView), findsOneWidget);
    // Sidebar and chat share the row instead of overlapping.
    expect(
      tester.getTopRight(_search).dx,
      lessThanOrEqualTo(tester.getTopLeft(find.byType(NgChatView)).dx),
    );
  });

  testWidgets('the sidebar button collapses and restores the docked pane', (
    tester,
  ) async {
    await _pump(tester, const Size(1280, 800));
    expect(_search, findsOneWidget);
    await tester.tap(_toggle);
    await _frames(tester);
    expect(_search, findsNothing);
    final scaffold = tester.state<ScaffoldState>(find.byType(Scaffold).first);
    expect(scaffold.isDrawerOpen, isFalse);
    await tester.tap(_toggle);
    await _frames(tester);
    expect(_search, findsOneWidget);
  });

  testWidgets('sidebar search survives crossing the breakpoint', (
    tester,
  ) async {
    await _pump(tester, const Size(1024, 620));
    await tester.enterText(_search, 'docked');
    await _frames(tester);
    _size(tester, const Size(800, 600));
    await _frames(tester);
    expect(_search, findsNothing);
    await tester.tap(_toggle);
    await _frames(tester);
    expect(tester.widget<TextField>(_search).controller?.text, 'docked');
  });
}
