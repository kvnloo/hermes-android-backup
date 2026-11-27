// Apple-port adaptive layout, shortcut and platform-capability coverage.
//
// Layout is driven strictly by window size (never a device-name check); these
// tests pin the 600/840 breakpoints, the docked NextGen sidebar, the Classic
// list+detail pane, and the desktop keyboard shortcut bus.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/screens/workspace_sessions_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/utils/adaptive_layout.dart';
import 'package:hermes_android/core/utils/home_turn_signals.dart';
import 'package:hermes_android/core/utils/platform_capabilities.dart';
import 'package:hermes_android/core/widgets/desktop_shortcuts.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('adaptive size classes (window size only)', () {
    test('600 / 840 breakpoints and useful-height guard', () {
      expect(
        adaptiveSizeClassOf(const Size(599, 900)),
        AdaptiveSizeClass.compact,
      );
      expect(
        adaptiveSizeClassOf(const Size(600, 900)),
        AdaptiveSizeClass.medium,
      );
      expect(
        adaptiveSizeClassOf(const Size(839, 900)),
        AdaptiveSizeClass.medium,
      );
      expect(
        adaptiveSizeClassOf(const Size(840, 900)),
        AdaptiveSizeClass.expanded,
      );
      // Wide but short windows fall back to the medium rail.
      expect(
        adaptiveSizeClassOf(const Size(1000, 400)),
        AdaptiveSizeClass.medium,
      );
      expect(
        adaptiveSizeClassOf(
          Size(
            AdaptiveBreakpoints.expanded,
            AdaptiveBreakpoints.expandedMinHeight,
          ),
        ),
        AdaptiveSizeClass.expanded,
      );
    });
  });

  group('desktop shortcuts', () {
    test('bus broadcasts each action to the active shell', () async {
      final received = <DesktopShortcut>[];
      final sub = desktopShortcutBus.stream.listen(received.add);
      for (final action in DesktopShortcut.values) {
        fireDesktopShortcut(action);
      }
      await pumpEventQueue();
      expect(received, DesktopShortcut.values);
      await sub.cancel();
    });

    test('plain Enter sends, Shift+Enter inserts a newline', () {
      final plain = KeyDownEvent(
        logicalKey: LogicalKeyboardKey.enter,
        physicalKey: PhysicalKeyboardKey.enter,
        timeStamp: Duration.zero,
      );
      expect(shouldSendOnEnter(plain), isTrue);
      // Shift state lives on the hardware keyboard singleton in this Flutter.
      HardwareKeyboard.instance.handleKeyEvent(
        KeyDownEvent(
          logicalKey: LogicalKeyboardKey.shiftLeft,
          physicalKey: PhysicalKeyboardKey.shiftLeft,
          timeStamp: Duration.zero,
        ),
      );
      addTearDown(() {
        HardwareKeyboard.instance.handleKeyEvent(
          KeyUpEvent(
            logicalKey: LogicalKeyboardKey.shiftLeft,
            physicalKey: PhysicalKeyboardKey.shiftLeft,
            timeStamp: Duration.zero,
          ),
        );
      });
      expect(shouldSendOnEnter(plain), isFalse);
    });
  });

  group('platform capabilities', () {
    test('Android-only features are hidden on iOS and macOS', () {
      for (final platform in [TargetPlatform.iOS, TargetPlatform.macOS]) {
        debugDefaultTargetPlatformOverride = platform;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        expect(isApplePlatform, isTrue);
        expect(supportsAndroidBackgroundWork, isFalse);
        expect(supportsEmbeddedMobilePush, isFalse);
        expect(supportsHandsFreeWakeService, isFalse);
      }
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      expect(isApplePlatform, isFalse);
      expect(supportsAndroidBackgroundWork, isTrue);
    });
  });

  group('Classic adaptive shell', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    Future<void> pumpWorkspace(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: WorkspaceScreen(
            connection: SavedConnection(
              id: 'adaptive',
              label: 'Ares',
              host: 'example.invalid',
              port: 8642,
              apiKey: 'test',
            ),
            sessionsLoader: () async => [
              Session(
                id: 'chat-1',
                title: 'Wide chat',
                source: 'gateway',
                model: 'test',
                messageCount: 1,
                isActive: false,
                preview: '',
                startedAt: 1,
                lastActive: 1,
                endedAt: 1,
              ),
            ],
            turnSignalsLoader: (_) async => HomeTurnSignals.empty,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('phone width keeps the bottom NavigationBar', (tester) async {
      await pumpWorkspace(tester, const Size(400, 800));
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('wide window is list+detail and keeps the list mounted', (
      tester,
    ) async {
      await pumpWorkspace(tester, const Size(1000, 800));
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.text('Wide chat'), findsOneWidget);
      // No chat selected yet: the detail pane is an empty placeholder.
      expect(find.byType(ChatScreen), findsNothing);

      await tester.tap(find.text('Wide chat').last);
      await tester.pumpAndSettle();

      // Both panes are alive: the list keeps filters/scroll while the chat is
      // shown inline rather than pushed as a route.
      expect(find.byType(ChatScreen), findsOneWidget);
      expect(find.byType(WorkspaceSessionsScreen), findsOneWidget);
    });
  });

  group('NextGen wide docked sidebar', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    late NextGenGateway gateway;

    // NgMainPage starts project discovery, which waits on the gateway
    // connection with a timeout. Unmount, dispose and let those timers run
    // out before the test ends, as the other NgMainPage tests do.
    Future<void> unmount(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox());
      gateway.dispose();
      await tester.pump(const Duration(seconds: 30));
    }

    Future<void> pumpNextGen(
      WidgetTester tester,
      Size size, {
      FakeViewPadding padding = FakeViewPadding.zero,
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.view.padding = padding;
      tester.view.viewPadding = padding;
      addTearDown(tester.view.reset);
      final prefs = await SharedPreferences.getInstance();
      final conn = SavedConnection(
        id: 'ng-adaptive',
        label: 'Ares',
        host: '10.0.0.5',
        port: 9119,
        apiKey: '',
        desktopGatewayUrl: 'http://10.0.0.5:9119',
        singleLogin: true,
        signInMethod: 'none',
      );
      gateway = NextGenGateway(conn);
      await tester.pumpWidget(
        MaterialApp(
          theme: nextGenTheme(Brightness.light, NextGenLook.instance),
          // The app root takes the side insets of an expanded window.
          builder: (context, child) => ExpandedWindowSideInsets(child: child!),
          home: NgScope(
            connManager: ConnectionManager(prefs),
            gateway: gateway,
            connections: [conn],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: const NgMainPage(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
    }

    testWidgets('compact window uses a drawer', (tester) async {
      await pumpNextGen(tester, const Size(800, 600));
      final scaffold = tester.state<ScaffoldState>(find.byType(Scaffold).first);
      expect(scaffold.isDrawerOpen, isFalse);
      // The sidebar is not inline on a phone-width window.
      expect(find.byKey(const Key('ng-session-search')), findsNothing);
      await tester.tap(find.byKey(const ValueKey('ng-sidebar-button')));
      await tester.pumpAndSettle();
      expect(scaffold.isDrawerOpen, isTrue);
      expect(find.byKey(const Key('ng-session-search')), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('unfolded/wide window docks the sessions pane', (tester) async {
      await pumpNextGen(tester, const Size(1024, 800));
      // No modal drawer at the expanded breakpoint; the sidebar is inline.
      expect(find.byType(Drawer), findsNothing);
      expect(find.byKey(const Key('ng-session-search')), findsOneWidget);
      // Preserve the 5.0 cold-launch brand landing before opening the chat.
      expect(find.byKey(const Key('ng-brand-new-chat')), findsOneWidget);
      await tester.tap(find.byKey(const Key('ng-brand-new-chat')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(const Key('ng-session-search')), findsOneWidget);
      expect(find.byKey(const ValueKey('ng-sidebar-button')), findsOneWidget);
      await unmount(tester);
    });

    // An unfolded iPhone Duo is 951 x 669 pt and reports its status cluster
    // as an 84 pt right inset (and the home indicator as 34 pt at the bottom).
    const duo = Size(951, 669);
    const duoInsets = FakeViewPadding(right: 84, bottom: 34);

    testWidgets('unfolded Duo keeps the docked sidebar at full width', (
      tester,
    ) async {
      await pumpNextGen(tester, duo, padding: duoInsets);
      // The sidebar touches the left edge, so the right inset is not its to
      // give up: its search field spans the 330 pt pane, less 14 pt margins.
      final search = tester.getRect(find.byKey(const Key('ng-session-search')));
      expect(search.left, 14);
      expect(search.width, 330 - 28);
      await unmount(tester);
    });

    testWidgets('unfolded Duo keeps the chat clear of the status cluster', (
      tester,
    ) async {
      await pumpNextGen(tester, duo, padding: duoInsets);
      final page = tester.getRect(find.byType(NgMainPage));
      expect(page.left, 0);
      expect(page.right, duo.width - 84);
      // The bottom inset still reaches the panes, which pad their own footers.
      final media = MediaQuery.of(tester.element(find.byType(NgMainPage)));
      expect(media.padding.right, 0);
      expect(media.padding.bottom, 34);
      await unmount(tester);
    });
  });

  group('expanded-window side insets', () {
    Future<void> pump(
      WidgetTester tester,
      Size size,
      FakeViewPadding padding,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.view.padding = padding;
      tester.view.viewPadding = padding;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ExpandedWindowSideInsets(child: child!),
          home: const _Probe(),
        ),
      );
    }

    testWidgets('a phone in landscape still draws edge to edge', (
      tester,
    ) async {
      // Wide but short: the medium class, with a notch inset on both sides.
      await pump(
        tester,
        const Size(874, 402),
        const FakeViewPadding(left: 62, right: 62, bottom: 21),
      );
      expect(tester.getSize(find.byType(_Probe)), const Size(874, 402));
      final media = MediaQuery.of(tester.element(find.byType(_Probe)));
      expect(media.padding.left, 62);
      expect(media.padding.right, 62);
    });

    testWidgets('unfolding keeps the routes mounted', (tester) async {
      await pump(tester, const Size(466, 678), FakeViewPadding.zero);
      final before = tester.state(find.byType(_Probe));
      tester.view.physicalSize = const Size(951, 669);
      tester.view.padding = const FakeViewPadding(right: 84, bottom: 34);
      tester.view.viewPadding = const FakeViewPadding(right: 84, bottom: 34);
      await tester.pump();
      expect(tester.state(find.byType(_Probe)), same(before));
      expect(tester.getSize(find.byType(_Probe)), const Size(951 - 84, 669));
    });
  });
}

class _Probe extends StatefulWidget {
  const _Probe();

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
