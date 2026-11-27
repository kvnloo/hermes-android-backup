// The goal/subagents/tasks dock above the NextGen composer, with the
// on-screen keyboard up. Sam: "if you have the bottom goal/tasks bar
// expanded, the keyboard overlays the app so you can't use it."
//
// The dock was capped at 45% of the *window* height, which does not shrink
// when the keyboard opens, so an expanded dock pushed the composer under the
// keyboard. It is now measured against the space left above the keyboard.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/data/session_control.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/session_dock.dart';
import 'package:shared_preferences/shared_preferences.dart';

SavedConnection _connection() => SavedConnection(
  id: 'dock-keyboard',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: 'fixture-key',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
  dashboardProxied: true,
);

void _fillDock(NgChatController chat) {
  chat
    ..control = NgSessionControl.parse({
      'revision': 'r1',
      'goal': {
        'title': 'Ship the release with every platform verified ' * 2,
        'status': 'active',
        'turns_used': 4,
        'max_turns': 20,
      },
      'heartbeat': {'prompt': 'ping', 'interval_seconds': 900, 'fire_count': 3},
    })
    ..todos = NgTodoList.parse({
      'revision': 1,
      'todos': [
        for (var i = 0; i < 12; i++)
          {
            'id': '${i + 1}',
            'content': 'Step $i of the release checklist',
            'status': i < 5
                ? 'completed'
                : i == 5
                ? 'in_progress'
                : 'pending',
          },
      ],
    })
    ..todosLive = true;
  // The dock lists the current batch of subagents while one is live.
  chat.subagentBatchStart = DateTime.now().subtract(const Duration(minutes: 1));
  for (var i = 0; i < 4; i++) {
    chat.subagents.add(
      NgSubagent('s$i', goal: 'Check platform $i')..toolCount = 3,
    );
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('the cap is a share of the space above the keyboard', (
    tester,
  ) async {
    final seen = <double>[];
    Widget probe(EdgeInsets insets) => MediaQuery(
      data: MediaQueryData(
        size: const Size(390, 844),
        padding: const EdgeInsets.only(top: 44),
        viewInsets: insets,
      ),
      child: Builder(
        builder: (context) {
          seen.add(
            ngAboveComposerMaxHeight(
              context,
              fraction: 0.45,
              withKeyboard: 0.25,
            ),
          );
          return const SizedBox();
        },
      ),
    );
    await tester.pumpWidget(probe(EdgeInsets.zero));
    await tester.pumpWidget(probe(const EdgeInsets.only(bottom: 340)));
    expect(seen.first, closeTo((844 - 44) * 0.45, 0.01));
    expect(seen.last, closeTo((844 - 44 - 340) * 0.25, 0.01));
  });

  for (final brightness in [Brightness.light, Brightness.dark]) {
    testWidgets('an expanded dock never pushes the composer under the keyboard '
        '(${brightness.name})', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final prefs = await SharedPreferences.getInstance();
      final gateway = NextGenGateway(_connection());
      final chat = NgChatController(gateway, sessionId: 'dock-kb')
        ..model = 'model-a';
      _fillDock(chat);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: nextGenTheme(brightness, NextGenLook.instance),
          home: NgScope(
            connManager: ConnectionManager(prefs),
            gateway: gateway,
            connections: [gateway.connection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: Scaffold(
              body: NgChatView(
                chat: chat,
                onOpenSidebar: () {},
                onNewChat: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(const ValueKey('ng-dock')), findsOneWidget);
      // Open every section, as a user reading the plan would.
      for (final key in [
        'ng-dock-goal',
        'ng-dock-subagents',
        'ng-dock-tasks',
      ]) {
        await tester.ensureVisible(find.byKey(ValueKey(key)));
        await tester.tap(find.byKey(ValueKey(key)));
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(tester.takeException(), isNull);

      // Keyboard up, composer focused.
      final field = find.byKey(const ValueKey('ng-composer-field'));
      await tester.tap(field);
      tester.view.viewInsets = const FakeViewPadding(bottom: 340);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      final keyboardTop = 844.0 - 340;
      final fieldRect = tester.getRect(field);
      expect(
        fieldRect.bottom,
        lessThanOrEqualTo(keyboardTop),
        reason: 'composer field hidden by the keyboard: $fieldRect',
      );
      expect(field.hitTestable(), findsOneWidget);
      final dockRect = tester.getRect(find.byKey(const ValueKey('ng-dock')));
      expect(
        dockRect.height,
        lessThanOrEqualTo(keyboardTop * 0.25 + 1),
        reason: 'dock should shrink with the keyboard up: $dockRect',
      );
      await tester.enterText(field, 'typed while the plan is open');
      await tester.pump();
      expect(find.text('typed while the plan is open'), findsOneWidget);

      // Keyboard down: the dock gets its normal share back.
      tester.view.resetViewInsets();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(
        tester.getRect(find.byKey(const ValueKey('ng-dock'))).height,
        greaterThan(dockRect.height),
      );

      await tester.pumpWidget(const SizedBox());
      gateway.dispose();
      await tester.pump(const Duration(seconds: 30));
    });
  }
}
