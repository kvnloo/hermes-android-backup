// NextGen parity for /resume: a NextGen parallel pane and a NextGen pop-out
// window (both NgParallelChatPane) list the connection's chats in the
// picker (not "This pane has no chat list to search.") and open the pick:
// a workspace pane as another pane of the workspace, a pop-out window over
// its own chat (a picked chat closes back to it), a pane anywhere else in
// place of its chat.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/workspace/popout_bootstrap.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/brand.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/parallel_chat_pane.dart';
import 'package:hermes_android/nextgen/ui/parallel_workspace_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/parallel_workspace_fixture.dart';

const _field = ValueKey('ng-composer-field');

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump(const Duration(milliseconds: 60));
  }
}

Future<void> _resume(WidgetTester tester) async {
  await tester.enterText(find.byKey(_field).last, '/resume');
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
  await tester.tap(find.byTooltip('Send').last);
  await _settle(tester);
}

Widget _scoped(
  ConnectionManager manager,
  ParallelFixture fixture,
  ParallelFixtureGateway g,
  Widget child,
) => MaterialApp(
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
    child: child,
  ),
);

Iterable<String?> _shownChats(WidgetTester tester) => tester
    .widgetList<NgChatView>(find.byType(NgChatView))
    .map((view) => view.chat.storedId);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, (_) async => null);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, null);
  });

  testWidgets('a NextGen pane lists the connection\'s chats and, outside a '
      'workspace, opens the pick in place of its chat', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 1400);
    addTearDown(tester.view.reset);
    final manager = ConnectionManager(await SharedPreferences.getInstance());
    final fixture = ParallelFixture(dashboard: true, profile: 'pane-test');
    final g = ParallelFixtureGateway(fixture);
    addTearDown(g.dispose);
    final rows = (await g.api.getSessionsPage()).sessions;
    await tester.pumpWidget(
      _scoped(
        manager,
        fixture,
        g,
        NgParallelChatPane(gateway: g, session: rows.first, close: () {}),
      ),
    );
    await _settle(tester);
    expect(find.byType(NgBrandLanding), findsNothing);
    await _resume(tester);
    expect(find.text('Resume a chat'), findsOneWidget);
    expect(find.text('This pane has no chat list to search.'), findsNothing);
    expect(find.text('Chat beta'), findsWidgets, reason: 'rows not listed');
    await tester.tap(find.text('Chat beta').last);
    await _settle(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(_shownChats(tester), ['beta']);
    expect(g.resumes, contains('beta'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a NextGen workspace pane opens the pick as another pane of '
      'the workspace; its own pane stays', (tester) async {
    NextGenLook.instance.themeMode = ThemeMode.dark;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1400, 1000);
    addTearDown(tester.view.reset);
    final manager = ConnectionManager(await SharedPreferences.getInstance());
    final fixture = ParallelFixture(dashboard: true, profile: 'pane-test');
    final g = ParallelFixtureGateway(fixture);
    addTearDown(g.dispose);
    await tester.pumpWidget(
      _scoped(manager, fixture, g, NgParallelWorkspacePage(gateway: g)),
    );
    await _settle(tester);
    await tester.tap(find.byTooltip('Add chat'));
    await _settle(tester);
    await tester.tap(find.text('Chat alpha').last);
    await _settle(tester);
    expect(find.byType(NgBrandLanding), findsNothing);
    await _resume(tester);
    expect(find.text('Resume a chat'), findsOneWidget);
    expect(find.text('This pane has no chat list to search.'), findsNothing);
    await tester.tap(find.text('Chat beta').last);
    await _settle(tester);
    await tester.pump(const Duration(seconds: 1));
    final tabs = tester
        .widgetList<InputChip>(find.byType(InputChip))
        .map((chip) => ((chip.label as ConstrainedBox).child as Text).data)
        .toList();
    expect(tabs, ['Chat alpha', 'Chat beta']);
    expect(_shownChats(tester), contains('beta'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a NextGen pop-out window opens the pick over its own chat; '
      'closing the pick goes back to it', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 1400);
    addTearDown(tester.view.reset);
    final manager = ConnectionManager(await SharedPreferences.getInstance());
    final fixture = ParallelFixture(dashboard: true, profile: 'pane-test');
    final g = ParallelFixtureGateway(fixture);
    final rows = (await g.api.getSessionsPage()).sessions;
    final Session first = rows.first;
    await tester.pumpWidget(
      PopoutChatApp(
        manager: manager,
        connection: fixture.connection,
        session: first,
        gateway: g,
      ),
    );
    await _settle(tester);
    expect(find.byType(NgBrandLanding), findsNothing);
    await _resume(tester);
    expect(find.text('Resume a chat'), findsOneWidget);
    expect(find.text('This pane has no chat list to search.'), findsNothing);
    await tester.tap(find.text('Chat beta').last);
    await _settle(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(_shownChats(tester), ['beta']);
    final windowChat = find.byWidgetPredicate(
      (w) => w is NgChatView && w.chat.storedId == 'alpha',
      skipOffstage: false,
    );
    expect(windowChat, findsOneWidget, reason: 'the window chat stays');
    await tester.tap(find.byType(CloseButton));
    await _settle(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(_shownChats(tester), ['alpha']);
    expect(tester.takeException(), isNull);
  });
}
