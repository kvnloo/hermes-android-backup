import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/desktop/desktop_integration.dart';
import 'package:hermes_android/core/desktop/desktop_os.dart';
import 'package:hermes_android/core/desktop/quick_entry.dart';
import 'package:hermes_android/core/desktop/quick_entry_window.dart';
import 'package:hermes_android/core/desktop/tray_controller.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/services/hermes_deeplink.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_child_process.dart';

const _chats = [
  QuickEntryChat(id: 's-alpha', title: 'Alpha Investigation'),
  QuickEntryChat(id: 's-beta', title: 'Beta notes'),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('launch frame', () {
    test('keeps valid, unique chats and fits the pipe bound', () {
      final launch = QuickEntryLaunch.bounded([
        const QuickEntryChat(id: 's-1', title: 'One'),
        const QuickEntryChat(id: '../etc/passwd', title: 'Bad'),
        const QuickEntryChat(id: 's-1', title: 'Duplicate'),
        const QuickEntryChat(id: '', title: 'Empty'),
        QuickEntryChat(id: 's-2', title: 'x' * 500),
        const QuickEntryChat(id: 's-3', title: 'Tab\tand\u0007bell\nline'),
        for (var i = 0; i < 40; i++)
          QuickEntryChat(id: 's-many-$i', title: '会話 $i ' * 20),
      ], locale: 'de');
      expect(launch.chats.first.id, 's-1');
      expect(launch.chats.map((c) => c.id), isNot(contains('../etc/passwd')));
      expect(launch.chats.where((c) => c.id == 's-1'), hasLength(1));
      expect(launch.chats[1].title.runes.length, 60);
      expect(launch.chats[1].title, endsWith('…'));
      // Tabs and new lines become spaces; other controls are dropped.
      expect(launch.chats[2].title, 'Tab andbell line');
      expect(launch.chats.length, lessThanOrEqualTo(12));
      expect(utf8.encode(launch.encode()).length, lessThanOrEqualTo(2000));
      final decoded = QuickEntryLaunch.decode(
        jsonDecode(launch.encode()) as Map<String, dynamic>,
      );
      expect(decoded.chats, launch.chats);
      expect(decoded.locale, 'de');
    });

    test('the child rejects frames it was not built for', () {
      Map<String, dynamic> frame(Object chats, [Object locale = 'en']) => {
        'chats': chats,
        'locale': locale,
      };
      expect(
        () => QuickEntryLaunch.decode({...frame([]), 'nonce': 'x'}),
        throwsFormatException,
      );
      expect(
        () => QuickEntryLaunch.decode(frame([], 'en; rm -rf')),
        throwsFormatException,
      );
      expect(
        () => QuickEntryLaunch.decode(
          frame([
            {'id': 'a b', 'title': 't'},
          ]),
        ),
        throwsFormatException,
      );
      expect(
        () => QuickEntryLaunch.decode(
          frame([
            {'id': 'a', 'title': 't', 'cwd': '/'},
          ]),
        ),
        throwsFormatException,
      );
      expect(QuickEntryLaunch.decode(frame([], 'pt_BR')).locale, 'pt_BR');
    });
  });

  group('hand-back', () {
    test('accepts only text and an offered chat', () {
      final newChat = QuickEntryPrefill.parse(
        jsonEncode({'prefill': '  Draft\u0000 this\n', 'session': null}),
        _chats,
      )!;
      expect(newChat.text, 'Draft this');
      expect(newChat.sessionId, isNull);

      final existing = QuickEntryPrefill.parse(
        jsonEncode({'prefill': 'Follow up', 'session': 's-beta'}),
        _chats,
      )!;
      expect(existing.sessionId, 's-beta');

      for (final line in [
        jsonEncode({'prefill': 'x', 'session': 's-unknown'}),
        jsonEncode({'prefill': 'x', 'session': 7}),
        jsonEncode({'prefill': '   ', 'session': null}),
        jsonEncode({'prefill': 'x' * 4001, 'session': null}),
        jsonEncode({'prefill': 'x', 'session': null, 'send': true}),
        jsonEncode({'text': 'x'}),
        'not json',
        quickEntryReady,
      ]) {
        expect(QuickEntryPrefill.parse(line, _chats), isNull, reason: line);
      }
    });

    test('becomes a prefill-only deep link the router accepts', () {
      final session = parseHermesDeepLink(
        const QuickEntryPrefill(
          text: 'Check line 2\nand & = signs',
          sessionId: 's-alpha',
        ).toDeepLink(),
      )!;
      expect(session.kind, HermesDeepLinkKind.session);
      expect(session.sessionId, 's-alpha');
      expect(session.prefill, 'Check line 2\nand & = signs');

      final fresh = parseHermesDeepLink(
        const QuickEntryPrefill(text: 'New idea').toDeepLink(),
      )!;
      expect(fresh.kind, HermesDeepLinkKind.open);
      expect(fresh.path, '/chat');
      expect(fresh.prefill, 'New idea');
    });
  });

  group('QuickEntryLauncher', () {
    late List<FakeChildProcess> spawned;
    late List<QuickEntryPrefill> handed;
    late QuickEntryLauncher launcher;

    setUp(() {
      spawned = [];
      handed = [];
    });

    QuickEntryLauncher withSpawn() => launcher = QuickEntryLauncher(
      chats: () => _chats,
      locale: () => 'fr',
      onPrefill: handed.add,
      spawn: () async {
        final process = FakeChildProcess();
        spawned.add(process);
        return process;
      },
      readyTimeout: const Duration(seconds: 2),
    );

    test('sends one frame, waits for ready and routes one hand-back', () async {
      withSpawn();
      final opening = launcher.show();
      final again = launcher.show();
      await pumpEventQueue();
      expect(spawned, hasLength(1));
      final child = spawned.single;
      expect(child.stdinLines, hasLength(1));
      final frame = jsonDecode(child.stdinLines.single) as Map;
      expect(frame['locale'], 'fr');
      expect((frame['chats'] as List).map((c) => (c as Map)['id']), [
        's-alpha',
        's-beta',
      ]);
      // Lines before ready are ignored.
      child.emit(jsonEncode({'prefill': 'early', 'session': null}));
      child.emit(quickEntryReady);
      expect(await opening, isTrue);
      expect(await again, isTrue);
      expect(launcher.active.value, isTrue);

      child.emit(jsonEncode({'prefill': 'nope', 'session': 'evil'}));
      child.emit(jsonEncode({'prefill': 'Use this', 'session': 's-alpha'}));
      child.emit(jsonEncode({'prefill': 'and this', 'session': null}));
      await pumpEventQueue();
      expect(handed, hasLength(1));
      expect(handed.single.text, 'Use this');
      expect(handed.single.sessionId, 's-alpha');

      child.exit(0);
      await pumpEventQueue();
      expect(launcher.active.value, isFalse);
    });

    test('toggling an open window closes it', () async {
      withSpawn();
      final opening = launcher.toggle();
      await pumpEventQueue();
      spawned.single.emit(quickEntryReady);
      expect(await opening, isTrue);
      expect(await launcher.toggle(), isFalse);
      expect(spawned.single.killed, isTrue);
      expect(launcher.active.value, isFalse);
      // A late line from the closed window is ignored.
      handed.clear();
      expect(spawned, hasLength(1));
    });

    test('a window that never becomes ready is closed', () async {
      withSpawn();
      final opening = launcher.show();
      await pumpEventQueue();
      spawned.single.emit(quickEntryFailed);
      expect(await opening, isFalse);
      expect(spawned.single.killed, isTrue);
      expect(launcher.active.value, isFalse);

      final second = launcher.show();
      await pumpEventQueue();
      spawned.last.exit(1);
      expect(await second, isFalse);
    });

    test('a failed spawn reports false', () async {
      launcher = QuickEntryLauncher(
        chats: () => _chats,
        locale: () => 'en',
        onPrefill: handed.add,
        spawn: () async => throw const ProcessException('ares', []),
      );
      expect(await launcher.show(), isFalse);
      expect(launcher.active.value, isFalse);
    });

    test('dispose closes the window and refuses new ones', () async {
      withSpawn();
      final opening = launcher.show();
      await pumpEventQueue();
      spawned.single.emit(quickEntryReady);
      await opening;
      launcher.dispose();
      expect(spawned.single.killed, isTrue);
      expect(await launcher.show(), isFalse);
      expect(spawned, hasLength(1));
    });
  });

  group('DesktopIntegration routing', () {
    const channel = MethodChannel('test/quick_entry_shell');
    late List<MethodCall> shellCalls;

    setUp(() {
      shellCalls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            shellCalls.add(call);
            return call.method == 'setTray' ? true : null;
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('a hand-back shows the window and prefills without sending', () async {
      SharedPreferences.setMockInitialValues({DesktopOsPrefs.trayKey: true});
      final links = HermesDeepLinkService(
        channel: const MethodChannel('test/quick_entry_links'),
      );
      final spawned = <FakeChildProcess>[];
      final integration = DesktopIntegration(
        preferences: await SharedPreferences.getInstance(),
        shell: const DesktopShell(channel),
        notifications: ValueNotifier(NotificationPrefs.defaults),
        deepLinks: links,
        quickEntryChats: () => _chats,
        quickEntrySpawn: () async {
          final process = FakeChildProcess();
          spawned.add(process);
          return process;
        },
        strings: () => lookupAppLocalizations(const Locale('en')),
      )..start();
      await integration.tray.sync();
      // The tray offers quick entry.
      final items = ((shellCalls.last.arguments as Map)['items'] as List)
          .cast<Map>();
      expect(items.map((i) => i['id']), contains('quick-entry'));

      integration.handleTrayAction(TrayAction.quickEntry);
      await pumpEventQueue();
      final child = spawned.single;
      expect((jsonDecode(child.stdinLines.single) as Map)['locale'], 'en');
      child.emit(quickEntryReady);
      child.emit(jsonEncode({'prefill': 'Summarise', 'session': 's-beta'}));
      await pumpEventQueue();
      expect(shellCalls.map((c) => c.method), contains('showWindow'));
      final link = links.pendingLink.value!;
      expect(link.kind, HermesDeepLinkKind.session);
      expect(link.sessionId, 's-beta');
      expect(link.prefill, 'Summarise');

      // The palette path opens a fresh window after this one exits.
      child.exit(0);
      await pumpEventQueue();
      final reopening = integration.openQuickEntry();
      await pumpEventQueue();
      spawned.last.emit(quickEntryReady);
      expect(await reopening, isTrue);
      spawned.last.emit(jsonEncode({'prefill': 'Fresh', 'session': null}));
      await pumpEventQueue();
      expect(links.pendingLink.value!.kind, HermesDeepLinkKind.open);
      expect(links.pendingLink.value!.prefill, 'Fresh');

      await integration.dispose();
      expect(spawned.last.killed, isTrue);
      expect(await integration.openQuickEntry(), isFalse);
    });
  });

  group('foreground right (Windows)', () {
    const channel = MethodChannel('test/quick_entry_foreground_shell');

    Future<List<MethodCall>> openOn(TargetPlatform platform) async {
      SharedPreferences.setMockInitialValues({});
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return call.method == 'allowForeground' ? true : null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      final spawned = <FakeChildProcess>[];
      final integration = DesktopIntegration(
        preferences: await SharedPreferences.getInstance(),
        shell: const DesktopShell(channel),
        hotkeyChannel: const MethodChannel('test/quick_entry_fg_hotkey'),
        notifications: ValueNotifier(NotificationPrefs.defaults),
        quickEntryChats: () => _chats,
        quickEntrySpawn: () async {
          final process = FakeChildProcess();
          spawned.add(process);
          return process;
        },
        platform: platform,
        strings: () => lookupAppLocalizations(const Locale('en')),
      )..start();
      addTearDown(integration.dispose);
      final opening = integration.openQuickEntry();
      await pumpEventQueue();
      spawned.single.emit(quickEntryReady);
      expect(await opening, isTrue);
      return calls;
    }

    test('only the quick-entry child pid may take the foreground, never any '
        'process', () async {
      final calls = await openOn(TargetPlatform.windows);
      final allow = calls.where((c) => c.method == 'allowForeground').toList();
      expect(allow, hasLength(1));
      expect(allow.single.arguments, {'pid': 4242});
    });

    test('macOS and Linux runners are not asked', () async {
      for (final platform in [TargetPlatform.macOS, TargetPlatform.linux]) {
        final calls = await openOn(platform);
        expect(
          calls.where((c) => c.method == 'allowForeground'),
          isEmpty,
          reason: '$platform',
        );
      }
    });
  });

  group('quick-entry owner (PROBE-4)', () {
    const channel = MethodChannel('test/quick_entry_owner_shell');

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async => null);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    SavedConnection connection(String id, {String? profile}) => SavedConnection(
      id: id,
      label: id,
      host: '$id.invalid',
      port: 8642,
      apiKey: 'k',
      gatewayProfile: profile,
    );

    /// Opens quick entry while connection A (profile "sol") is showing, then
    /// switches the main window to B (which has a chat with the same id)
    /// before the hand-back arrives.
    Future<
      ({
        HermesDeepLinkService links,
        List<SavedConnection> opened,
        DesktopIntegration integration,
      })
    >
    handBack(List<SavedConnection> saved) async {
      SharedPreferences.setMockInitialValues({});
      final links = HermesDeepLinkService(
        channel: const MethodChannel('test/quick_entry_owner_links'),
      );
      var offered = const [QuickEntryChat(id: 'shared-1', title: 'A: plan')];
      var owner = HermesLinkOwner(connectionId: 'conn-a', profile: 'sol');
      final opened = <SavedConnection>[];
      final spawned = <FakeChildProcess>[];
      final integration = DesktopIntegration(
        preferences: await SharedPreferences.getInstance(),
        shell: const DesktopShell(channel),
        notifications: ValueNotifier(NotificationPrefs.defaults),
        deepLinks: links,
        quickEntryChats: () => offered,
        quickEntryOwner: () => owner,
        connections: () => saved,
        openOwner: opened.add,
        quickEntrySpawn: () async {
          final process = FakeChildProcess();
          spawned.add(process);
          return process;
        },
        strings: () => lookupAppLocalizations(const Locale('en')),
      )..start();
      addTearDown(integration.dispose);
      final opening = integration.openQuickEntry();
      await pumpEventQueue();
      spawned.single.emit(quickEntryReady);
      expect(await opening, isTrue);
      // The user switches the main window to connection B meanwhile.
      offered = const [QuickEntryChat(id: 'shared-1', title: 'B: other')];
      owner = HermesLinkOwner(connectionId: 'conn-b');
      spawned.single.emit(
        jsonEncode({'prefill': 'Draft for A', 'session': 'shared-1'}),
      );
      await pumpEventQueue();
      return (links: links, opened: opened, integration: integration);
    }

    test('PROBE-4 the hand-back carries the connection and profile it was '
        'offered from, and is routed to that owner', () async {
      final a = connection('conn-a', profile: ' sol ');
      final b = connection('conn-b');
      final result = await handBack([a, b]);
      final link = result.links.pendingLink.value!;
      expect(link.kind, HermesDeepLinkKind.session);
      expect(link.sessionId, 'shared-1');
      expect(link.prefill, 'Draft for A');
      expect(
        link.owner,
        HermesLinkOwner(connectionId: 'conn-a', profile: 'sol'),
      );
      // Only A's shell may consume it; B (now showing) must not.
      expect(link.isFor('conn-a', 'sol'), isTrue);
      expect(link.isFor('conn-b', null), isFalse);
      expect(link.isFor('conn-a', null), isFalse);
      // The app root is asked to bring A's shell forward.
      expect(result.opened.map((c) => c.id), ['conn-a']);
    });

    test(
      'an owner that no longer exists keeps the text as a new draft',
      () async {
        final result = await handBack([connection('conn-b')]);
        final link = result.links.pendingLink.value!;
        expect(link.kind, HermesDeepLinkKind.open);
        expect(link.path, '/chat');
        expect(link.sessionId, isNull);
        expect(link.prefill, 'Draft for A');
        expect(link.owner, isNull);
        expect(result.opened, isEmpty);
      },
    );

    test('an owner now on another profile counts as gone: new draft, never '
        "the other profile's chat", () async {
      final result = await handBack([
        connection('conn-a', profile: 'other'),
        connection('conn-b'),
      ]);
      final link = result.links.pendingLink.value!;
      expect(link.kind, HermesDeepLinkKind.open);
      expect(link.sessionId, isNull);
      expect(link.prefill, 'Draft for A');
      expect(link.owner, isNull);
      expect(result.opened, isEmpty);
    });

    test('a hermes:// URL never carries an owner', () {
      final parsed = parseHermesDeepLink(
        'hermes://session/s-1?prefill=x&owner=conn-a&connection=conn-a',
      )!;
      expect(parsed.owner, isNull);
      expect(parsed.isFor('anything', null), isTrue);
    });
  });

  group('QuickEntryPanel', () {
    Future<(List<QuickEntryPrefill>, List<String>)> pump(
      WidgetTester tester,
    ) async {
      final submitted = <QuickEntryPrefill>[];
      final cancelled = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: 640,
              height: 220,
              child: QuickEntryPanel(
                chats: _chats,
                onSubmit: submitted.add,
                onCancel: () => cancelled.add('cancel'),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      return (submitted, cancelled);
    }

    testWidgets('Enter hands back the text for a new chat', (tester) async {
      final (submitted, _) = await pump(tester);
      expect(find.text('Put in composer'), findsOneWidget);
      expect(
        find.textContaining('Nothing is sent until you press Send'),
        findsOneWidget,
      );
      final submit = find.byKey(const Key('quick-entry-submit'));
      expect(tester.widget<FilledButton>(submit).onPressed, isNull);

      await tester.enterText(
        find.byKey(const Key('quick-entry-text')),
        'Draft a reply',
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(submitted, hasLength(1));
      expect(submitted.single.text, 'Draft a reply');
      expect(submitted.single.sessionId, isNull);
      // Only one hand-back per window.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.tap(submit);
      expect(submitted, hasLength(1));
    });

    testWidgets('targets a chosen chat; Shift+Enter is a new line', (
      tester,
    ) async {
      final (submitted, _) = await pump(tester);
      await tester.tap(find.byKey(const Key('quick-entry-target')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta notes').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('quick-entry-text')),
        'Line one',
      );
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump();
      expect(submitted, isEmpty);
      await tester.tap(find.byKey(const Key('quick-entry-submit')));
      await tester.pump();
      expect(submitted.single.sessionId, 's-beta');
      expect(submitted.single.text, startsWith('Line one'));
    });

    testWidgets('Escape and Cancel close without a hand-back', (tester) async {
      final (submitted, cancelled) = await pump(tester);
      await tester.enterText(find.byKey(const Key('quick-entry-text')), 'x');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.tap(find.byKey(const Key('quick-entry-cancel')));
      expect(cancelled, ['cancel', 'cancel']);
      expect(submitted, isEmpty);
    });
  });
}
