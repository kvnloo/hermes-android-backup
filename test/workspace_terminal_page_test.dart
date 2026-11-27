import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/device_terminal.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/utils/home_turn_signals.dart';
import 'package:hermes_android/core/workspace/terminal_page.dart';
import 'package:hermes_android/core/workspace/workspace_registry.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_home.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xterm/xterm.dart';

import 'support/parallel_workspace_fixture.dart';

Future<Set<int>> _ptyPids() async {
  final result = await Process.run('pgrep', ['-x', 'ares-pty']);
  return {
    for (final line in (result.stdout as String).split('\n'))
      if (int.tryParse(line) != null) int.parse(line),
  };
}

/// Widget tests freeze real process and file futures until [WidgetTester.runAsync].
Future<Set<int>> _livePids(WidgetTester tester) async {
  final pids = await tester.runAsync(_ptyPids);
  expect(pids, isNotNull);
  return pids!;
}

Future<void> _frames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pump(const Duration(milliseconds: 350));
}

Future<void> _openWorkspace(
  WidgetTester tester, {
  required bool nextGen,
}) async {
  await tester.tap(find.text('More').last);
  await _frames(tester);
  await tester.tap(find.text('Parallel workspace'));
  await _frames(tester);
  await tester.tap(find.byTooltip('Add chat'));
  await _frames(tester);
  await tester.tap(find.text('Chat alpha').last);
  await _frames(tester);
  await tester.tap(find.byTooltip('Workspace tools'));
  await _frames(tester);
  await tester.tap(find.text('Terminals').last);
  await _frames(tester);
  expect(find.byType(TerminalPage), findsOneWidget);
  expect(
    find.text('Choose + to open a terminal. No shell starts automatically.'),
    findsOneWidget,
  );
  await tester.tap(find.byTooltip('New terminal'));
  await _frames(tester);
  expect(find.text('Gateway host terminal'), findsOneWidget);
  expect(find.text('Verified SSH terminal'), findsOneWidget);
  expect(
    find.text(
      LocalTerminal.supported
          ? 'This device (local shell)'
          : 'Local shell unavailable on mobile',
    ),
    findsOneWidget,
  );
  // Dismiss the menu before the next assertion. nextGen is unused beyond
  // documenting which shell opened the same page.
  expect(nextGen, isNotNull);
  await tester.tapAt(const Offset(10, 10));
  await _frames(tester);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    LocalTerminal.supportedOverride = null;
  });

  testWidgets('NextGen workspace opens the terminal page without a shell', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1600, 920);
    addTearDown(tester.view.reset);
    final fixture = ParallelFixture(profile: 'profile A', dashboard: true);
    final manager = _Accounts(
      await SharedPreferences.getInstance(),
      ParallelFixtureGateway(fixture),
    );
    final before = await _livePids(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: NextGenHome(
          connManager: manager,
          testGatewayFactory: (_) => manager.selected,
        ),
      ),
    );
    await _frames(tester);
    await _openWorkspace(tester, nextGen: true);
    expect(await _livePids(tester), before);
  });

  testWidgets(
    'Classic local shell is labelled, stays alive while hidden, and dies on close',
    (tester) async {
      final home = await tester.runAsync(() async {
        final root = Directory('build/pty-homes');
        await root.create(recursive: true);
        return root.createTemp('terminal-ui-');
      });
      expect(home, isNotNull);
      addTearDown(() => tester.runAsync(() => home!.delete(recursive: true)));
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1600, 920);
      addTearDown(tester.view.reset);
      LocalTerminal.helperOverride =
          Platform.environment['ARES_TERMINAL_FIXTURE_HELPER'] == null
          ? null
          : File(Platform.environment['ARES_TERMINAL_FIXTURE_HELPER']!);
      LocalTerminal.directoryOverride = home;
      addTearDown(() {
        LocalTerminal.helperOverride = null;
        LocalTerminal.directoryOverride = null;
      });
      final fixture = ParallelFixture();
      final before = await _livePids(tester);
      addTearDown(() async {
        for (final pid in (await _livePids(tester)).difference(before)) {
          Process.killPid(pid);
        }
      });
      await tester.pumpWidget(
        MaterialApp(
          theme: hermesTheme(Brightness.dark),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: WorkspaceScreen(
            connection: fixture.connection,
            sessionsLoader: () async => [],
            testChatApiClientFactory: fixture.api,
            testDashboardHttpClient: fixture.client(),
            turnSignalsLoader: (_) async => HomeTurnSignals.empty,
          ),
        ),
      );
      await _frames(tester);
      await _openWorkspace(tester, nextGen: false);
      await tester.tap(find.byTooltip('New terminal'));
      await _frames(tester);
      await tester.tap(find.text('Gateway host terminal'));
      await _frames(tester);
      expect(
        find.textContaining('no authenticated gateway terminal owner'),
        findsOneWidget,
      );
      expect(await _livePids(tester), before);

      await tester.tap(find.byTooltip('New terminal'));
      await _frames(tester);
      await tester.tap(find.text('This device (local shell)'));
      await _frames(tester);
      await tester.tap(find.text('Cancel'));
      await _frames(tester);
      expect(await _livePids(tester), before);
      expect(find.byType(TerminalView), findsNothing);

      await tester.tap(find.byTooltip('New terminal'));
      await _frames(tester);
      await tester.tap(find.text('This device (local shell)'));
      await _frames(tester);
      await tester.tap(find.text('Confirm'));
      Set<int> started = {};
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        started = (await _livePids(tester)).difference(before);
        if (started.isNotEmpty) break;
      }
      expect(started, isNotEmpty);
      expect(find.textContaining('This device'), findsWidgets);
      expect(find.byType(TerminalView), findsOneWidget);

      await tester.tap(find.widgetWithText(InputChip, 'Terminals'));
      await _frames(tester);
      await tester.tap(find.byTooltip('Workspace options'));
      await _frames(tester);
      await tester.tap(find.text('Hide pane (keep running)'));
      await _frames(tester);
      expect(find.byType(TerminalView, skipOffstage: false), findsOneWidget);
      expect(await _livePids(tester), containsAll(started));

      await tester.tap(find.byTooltip('Close Terminals'));
      await _frames(tester);
      expect(find.byType(TerminalView, skipOffstage: false), findsNothing);
      for (var i = 0; i < 20; i++) {
        if ((await _livePids(tester)).intersection(started).isEmpty) break;
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect((await _livePids(tester)).intersection(started), isEmpty);
    },
    skip:
        !(LocalTerminal.supported &&
            Platform.environment['ARES_TERMINAL_FIXTURE_HELPER'] != null),
  );

  testWidgets('a phone shows the local shell as unavailable', (tester) async {
    LocalTerminal.supportedOverride = false;
    addTearDown(() => LocalTerminal.supportedOverride = null);
    final fixture = ParallelFixture();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TerminalPage(
            target: WorkspaceTarget(
              fixture.connection,
              null,
              false,
              () => true,
            ),
          ),
        ),
      ),
    );
    await _frames(tester);
    await tester.tap(find.byTooltip('New terminal'));
    await _frames(tester);
    final item = tester.widget<PopupMenuItem<String>>(
      find.widgetWithText(
        PopupMenuItem<String>,
        'Local shell unavailable on mobile',
      ),
    );
    expect(item.enabled, isFalse);
    expect(find.byType(TerminalView), findsNothing);
  });
}

class _Accounts extends ConnectionManager {
  _Accounts(super.prefs, this.selected);
  final ParallelFixtureGateway selected;
  @override
  Future<List<SavedConnection>> loadConnectionsWithSecrets() async => [
    selected.connection,
  ];
}
