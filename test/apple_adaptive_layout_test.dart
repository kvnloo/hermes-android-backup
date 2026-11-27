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

    Future<NextGenGateway> pumpNextGen(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
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
      final gateway = NextGenGateway(conn);
      await tester.pumpWidget(
        MaterialApp(
          theme: nextGenTheme(Brightness.light, NextGenLook.instance),
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
      return gateway;
    }

    // The new-chat greeting loads Projects through gateway.connected(), which
    // starts the reconnect loop and waits up to 20 s. Unmount, dispose and let
    // those timers run out inside the test, as the other NgMainPage tests do.
    Future<void> unmount(WidgetTester tester, NextGenGateway gateway) async {
      await tester.pumpWidget(const SizedBox());
      gateway.dispose();
      await tester.pump(const Duration(seconds: 30));
    }

    testWidgets('compact window uses a drawer', (tester) async {
      final gateway = await pumpNextGen(tester, const Size(800, 600));
      final scaffold = tester.state<ScaffoldState>(find.byType(Scaffold).first);
      expect(scaffold.isDrawerOpen, isFalse);
      // The sidebar is not inline on a phone-width window.
      expect(find.byKey(const Key('ng-session-search')), findsNothing);
      await tester.tap(find.byKey(const ValueKey('ng-sidebar-button')));
      await tester.pumpAndSettle();
      expect(scaffold.isDrawerOpen, isTrue);
      expect(find.byKey(const Key('ng-session-search')), findsOneWidget);
      await unmount(tester, gateway);
    });

    testWidgets('unfolded/wide window docks the sessions pane', (tester) async {
      final gateway = await pumpNextGen(tester, const Size(1024, 800));
      // No modal drawer at the expanded breakpoint; the sidebar is inline.
      expect(find.byType(Drawer), findsNothing);
      expect(find.byKey(const Key('ng-session-search')), findsOneWidget);
      // Cold launch is the brand landing; opening a new chat exposes the
      // chat header's sidebar toggle without changing the docked layout.
      expect(find.byKey(const Key('ng-brand-new-chat')), findsOneWidget);
      await tester.tap(find.byKey(const Key('ng-brand-new-chat')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(const Key('ng-session-search')), findsOneWidget);
      expect(find.byKey(const ValueKey('ng-sidebar-button')), findsOneWidget);
      await unmount(tester, gateway);
    });
  });
}
