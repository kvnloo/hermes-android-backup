import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/device_terminal.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/utils/home_turn_signals.dart';
import 'package:hermes_android/core/workspace/terminal_page.dart';
import 'package:hermes_android/core/workspace/workspace_registry.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
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

Future<Set<int>> _livePids(WidgetTester tester) async =>
    (await tester.runAsync(_ptyPids))!;

Future<void> _frames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pump(const Duration(milliseconds: 350));
}

Future<Directory> _home(WidgetTester tester, String prefix) async {
  final home = await tester.runAsync(() async {
    final root = Directory('build/pty-homes');
    await root.create(recursive: true);
    return root.createTemp(prefix);
  });
  addTearDown(() => tester.runAsync(() => home!.delete(recursive: true)));
  return home!;
}

Future<bool> _exists(WidgetTester tester, File file) async =>
    (await tester.runAsync(file.exists))!;

Future<Set<int>> _startLocal(WidgetTester tester, Set<int> before) async {
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
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
  return started;
}

Future<void> _closeLocal(WidgetTester tester, Set<int> started) async {
  await tester.tap(find.byTooltip('Close shell'));
  await _frames(tester);
  await tester.tap(find.text('Confirm'));
  await _frames(tester);
  for (var i = 0; i < 20; i++) {
    if ((await _livePids(tester)).intersection(started).isEmpty) break;
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect((await _livePids(tester)).intersection(started), isEmpty);
}

void _useHelper(Directory home) {
  LocalTerminal.helperOverride = File(
    Platform.environment['ARES_TERMINAL_FIXTURE_HELPER']!,
  );
  LocalTerminal.directoryOverride = home;
  addTearDown(() {
    LocalTerminal.helperOverride = null;
    LocalTerminal.directoryOverride = null;
  });
}

Future<List<int>> _matchingPids(String pattern) async {
  final result = await Process.run('pgrep', ['-f', pattern]);
  return [
    for (final line in (result.stdout as String).split('\n'))
      if (int.tryParse(line) != null) int.parse(line),
  ];
}

void main() {
  final helper = Platform.environment['ARES_TERMINAL_FIXTURE_HELPER'];
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
    'keyboard paste is reviewed before it reaches the local shell',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1400, 900);
      addTearDown(tester.view.reset);
      final home = await _home(tester, 'paste-');
      _useHelper(home);
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async => call.method == 'Clipboard.getData'
            ? <String, Object?>{'text': 'touch pasted_unreviewed\r'}
            : null,
      );
      final before = await _livePids(tester);
      addTearDown(() async {
        for (final pid in (await _livePids(tester)).difference(before)) {
          Process.killPid(pid);
        }
      });
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
      final started = await _startLocal(tester, before);
      expect(find.byType(TerminalView), findsOneWidget);
      await tester.tap(find.byType(TerminalView));
      await _frames(tester);
      final mod = defaultTargetPlatform == TargetPlatform.macOS
          ? LogicalKeyboardKey.metaLeft
          : LogicalKeyboardKey.controlLeft;
      await tester.sendKeyDownEvent(mod);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
      await tester.sendKeyUpEvent(mod);
      await _frames(tester);
      final marker = File('${home.path}/pasted_unreviewed');
      var exists = false;
      for (var i = 0; i < 30 && !exists; i++) {
        exists = await _exists(tester, marker);
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(
        exists,
        isFalse,
        reason: 'clipboard text executed in the shell with no review dialog',
      );
      expect(find.textContaining('Paste into'), findsOneWidget);
      final shortcuts = tester
          .widget<TerminalView>(find.byType(TerminalView))
          .shortcuts;
      expect(shortcuts, isNotNull);
      expect(
        shortcuts!.values.whereType<PasteTextIntent>(),
        isEmpty,
        reason: 'xterm paste shortcut bypasses review',
      );
      await tester.tap(find.text('Cancel'));
      await _frames(tester);
      expect(await _exists(tester, marker), isFalse);

      final target = tester.widget<DragTarget<String>>(
        find.byType(DragTarget<String>),
      );
      target.onAcceptWithDetails!.call(
        DragTargetDetails<String>(
          data: 'touch dropped_unreviewed\r',
          offset: Offset.zero,
        ),
      );
      await _frames(tester);
      final dropped = File('${home.path}/dropped_unreviewed');
      expect(await _exists(tester, dropped), isFalse);
      expect(find.textContaining('Paste into'), findsOneWidget);
      expect(find.textContaining('touch dropped_unreviewed'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await _frames(tester);
      await _closeLocal(tester, started);
    },
    skip: helper == null || !LocalTerminal.supported,
    variant: const TargetPlatformVariant({
      TargetPlatform.macOS,
      TargetPlatform.linux,
    }),
  );

  testWidgets(
    'context-menu paste uses the same review dialog',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1400, 900);
      addTearDown(tester.view.reset);
      final home = await _home(tester, 'menu-');
      _useHelper(home);
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async => call.method == 'Clipboard.getData'
            ? <String, Object?>{'text': 'touch menu_unreviewed\r'}
            : null,
      );
      final before = await _livePids(tester);
      addTearDown(() async {
        for (final pid in (await _livePids(tester)).difference(before)) {
          Process.killPid(pid);
        }
      });
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
      final started = await _startLocal(tester, before);
      await tester.tap(
        find.byType(TerminalView),
        buttons: kSecondaryMouseButton,
      );
      await _frames(tester);
      expect(find.text('Paste'), findsOneWidget);
      await tester.tap(find.text('Paste'));
      await _frames(tester);
      final marker = File('${home.path}/menu_unreviewed');
      expect(await _exists(tester, marker), isFalse);
      expect(find.textContaining('Paste into'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await _frames(tester);
      expect(await _exists(tester, marker), isFalse);
      await _closeLocal(tester, started);
    },
    skip: helper == null || !LocalTerminal.supported,
  );

  testWidgets(
    'Close shell ends a local PTY after the originating chat closes',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1600, 920);
      addTearDown(tester.view.reset);
      final home = await _home(tester, 'close-');
      _useHelper(home);
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
      final started = await _startLocal(tester, before);

      await tester.tap(find.byTooltip('Close Chat alpha'));
      await _frames(tester);
      expect(find.byType(TerminalPage), findsOneWidget);
      tester
          .widget<TerminalView>(find.byType(TerminalView))
          .terminal
          .textInput('touch stale_input\r');
      await _frames(tester);
      expect(find.textContaining('Input refused'), findsOneWidget);
      expect(await _exists(tester, File('${home.path}/stale_input')), isFalse);

      await tester.tap(find.byTooltip('Close shell'));
      await _frames(tester);
      await tester.tap(find.text('Confirm'));
      await _frames(tester);
      for (var i = 0; i < 20; i++) {
        if ((await _livePids(tester)).intersection(started).isEmpty) break;
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(
        (await _livePids(tester)).intersection(started),
        isEmpty,
        reason: 'Close shell did not end the local PTY',
      );
    },
    skip: helper == null || !LocalTerminal.supported,
  );

  test(
    'background jobs die when the local shell helper closes',
    () async {
      final home = await Directory.systemTemp.createTemp('pty-bg-');
      addTearDown(() => home.delete(recursive: true));
      final tag = (DateTime.now().millisecondsSinceEpoch % 20000) + 40;
      final background = '^/bin/sleep $tag\$';
      final foreground = '^/bin/sleep ${tag + 1}\$';
      addTearDown(() async {
        for (final pattern in [background, foreground]) {
          for (final pid in await _matchingPids(pattern)) {
            Process.killPid(pid, ProcessSignal.sigkill);
          }
        }
      });
      final term = await LocalTerminal.startHelper(
        File(helper!),
        home,
        check: () {},
      );
      await Future<void>.delayed(const Duration(milliseconds: 500));
      term.write('/bin/sleep $tag &\r');
      await Future<void>.delayed(const Duration(milliseconds: 500));
      term.write('/bin/sleep ${tag + 1}\r');
      await Future<void>.delayed(const Duration(milliseconds: 500));
      expect(
        await _matchingPids(background),
        isNotEmpty,
        reason: 'background sleep did not start',
      );
      await term.close();
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(await _matchingPids(background), isEmpty);
      expect(await _matchingPids(foreground), isEmpty);
    },
    skip: helper == null || !LocalTerminal.supported,
  );

  test('Windows cmd.exe receives a minimal system PATH', () {
    final env = LocalTerminal.shellEnvironment(
      home: r'C:\Users\app',
      windows: true,
      systemRoot: r'C:\Windows\',
    );
    expect(env['HOME'], r'C:\Users\app');
    expect(env['SystemRoot'], r'C:\Windows');
    expect(env['PATH'], r'C:\Windows\System32;C:\Windows');
    final posix = LocalTerminal.shellEnvironment(
      home: '/tmp/home',
      windows: false,
    );
    expect(posix['PATH'], '/usr/bin:/bin:/usr/sbin:/sbin');
    expect(posix.containsKey('SystemRoot'), isFalse);
  });
}
