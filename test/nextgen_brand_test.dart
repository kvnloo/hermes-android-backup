import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/android_launch_intent_service.dart';
import 'package:hermes_android/core/services/android_share_intent_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/notification_approval_authority.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/hermes_deeplink.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/brand.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/project_greeting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tool/brand_mockup_fixtures.dart';

Future<void> _frames(WidgetTester t) async {
  for (var i = 0; i < 12; i++) {
    await t.pump(const Duration(milliseconds: 50));
  }
}

Future<DemoGateway> _app(
  WidgetTester t, {
  Size size = const Size(393, 852),
  Brightness brightness = Brightness.dark,
  double scale = 1,
  Locale locale = const Locale('en'),
  AndroidShareIntentService? shares,
  AndroidLaunchIntentService? launches,
  bool pane = false,
}) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  final gateway = DemoGateway(DateTime.now(), withProjects: true);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('saved_connections', [
    jsonEncode(gateway.connection.toMap()),
  ]);
  final manager = ConnectionManager(prefs);
  final chat = pane ? NgChatController(gateway) : null;
  await t.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: nextGenTheme(brightness, NextGenLook.instance),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: NgLocalizationScope(
          child: NgScope(
            connManager: manager,
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
      ),
      home: pane
          ? Scaffold(body: NgChatView(chat: chat!))
          : NgMainPage(shareIntents: shares, launchIntents: launches),
    ),
  );
  await _frames(t);
  addTearDown(() async {
    await t.pumpWidget(const SizedBox.shrink());
    chat?.dispose();
    gateway.dispose();
    await t.pump(const Duration(seconds: 31));
  });
  return gateway;
}

Future<void> _newChat(WidgetTester t) async {
  final button = find.byKey(const Key('ng-brand-new-chat'));
  expect(button, findsOneWidget);
  await t.ensureVisible(button);
  await t.tap(button);
  await _frames(t);
  expect(find.byType(NgBrandLanding), findsNothing);
  expect(find.byType(NgChatView), findsOneWidget);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'nextgen_last_session.demo': 'release',
    });
    nextGenEnabled.value = true;
    nextGenOpenRequest.value = null;
    nextGenNotificationAnswer.value = null;
    pendingWindowsToastTarget = null;
    HermesDeepLinkService.shared.pendingLink.value = null;
  });
  tearDown(() {
    nextGenOpenRequest.value = null;
    HermesDeepLinkService.shared.pendingLink.value = null;
    nextGenEnabled.value = false;
  });

  testWidgets('cold launch shows landing instead of reopening last chat', (
    t,
  ) async {
    final gateway = await _app(t);
    expect(find.byType(NgBrandLanding), findsOneWidget);
    expect(find.byType(NgChatView), findsNothing);
    expect(gateway.calls.where((c) => c.method == 'session.resume'), isEmpty);
    await _newChat(t);
    expect(find.byType(NgBrandMark), findsOneWidget);
    // Back retains the current chat and opens the drawer, not the landing.
    await t.binding.handlePopRoute();
    await _frames(t);
    expect(find.byType(NgBrandLanding), findsNothing);
    expect(find.text('Search chats'), findsOneWidget);
  });

  testWidgets(
    'each fresh primary launch shows landing, not only first install',
    (t) async {
      await _app(t);
      await _newChat(t);
      await t.pumpWidget(const SizedBox.shrink());
      await _app(t);
      expect(find.byType(NgBrandLanding), findsOneWidget);
      expect(find.byType(NgChatView), findsNothing);
    },
  );

  testWidgets(
    'Open a chat opens discoverable drawer then selection leaves landing',
    (t) async {
      await _app(t);
      await t.tap(find.byKey(const Key('ng-brand-open-chat')));
      await _frames(t);
      expect(find.text('Search chats'), findsOneWidget);
      await t.tap(find.text('Draft release notes').hitTestable());
      await _frames(t);
      expect(find.byType(NgBrandLanding), findsNothing);
      expect(
        t.widget<NgChatView>(find.byType(NgChatView)).chat.storedId,
        'release',
      );
    },
  );

  testWidgets('Recent row opens its chat directly', (t) async {
    await _app(t);
    await t.tap(find.byKey(const Key('ng-brand-recent-release')));
    await _frames(t);
    expect(find.byType(NgBrandLanding), findsNothing);
    expect(
      t.widget<NgChatView>(find.byType(NgChatView)).chat.storedId,
      'release',
    );
  });

  testWidgets('wide sidebar selection leaves landing', (t) async {
    await _app(t, size: const Size(1440, 900));
    expect(find.byType(NgBrandLanding), findsOneWidget);
    await t.tap(find.text('Draft release notes').hitTestable());
    await _frames(t);
    expect(find.byType(NgBrandLanding), findsNothing);
    expect(
      t.widget<NgChatView>(find.byType(NgChatView)).chat.storedId,
      'release',
    );
  });

  testWidgets(
    'notification cold activation skips landing and restores requested chat',
    (t) async {
      expect(routeNotificationToNextGen('demo', 'release'), isTrue);
      await _app(t);
      expect(find.byType(NgBrandLanding), findsNothing);
      expect(
        t.widget<NgChatView>(find.byType(NgChatView)).chat.storedId,
        'release',
      );
      expect(nextGenOpenRequest.value, isNull);
    },
  );

  testWidgets(
    'Windows toast activation skips landing and consumes validated target',
    (t) async {
      final origin = NotificationApprovalAuthority.origin(demoConnection());
      final target = WindowsToastTarget(
        'demo',
        'release',
        origin['approvalAccount']!,
        origin['approvalMutation']!,
      );
      expect(
        routeNotificationToNextGen('demo', 'release', target: target),
        isTrue,
      );
      await _app(t);
      expect(find.byType(NgBrandLanding), findsNothing);
      expect(
        t.widget<NgChatView>(find.byType(NgChatView)).chat.storedId,
        'release',
      );
      expect(pendingWindowsToastTarget, isNull);
    },
  );

  testWidgets('cold notification answer bypasses landing for its session', (
    t,
  ) async {
    nextGenNotificationAnswer.value = (
      connectionId: 'demo',
      sessionId: 'release',
      requestId: 'approval-1',
      choice: 'once',
    );
    await _app(t);
    expect(find.byType(NgBrandLanding), findsNothing);
    expect(
      t.widget<NgChatView>(find.byType(NgChatView)).chat.storedId,
      'release',
    );
  });

  for (final link in [
    const HermesDeepLink.session('release'),
    const HermesDeepLink.open('/chat', prefill: 'Quick-entry draft'),
    const HermesDeepLink.launch(),
  ]) {
    testWidgets('${link.kind} cold activation skips landing without sending', (
      t,
    ) async {
      HermesDeepLinkService.shared.pendingLink.value = link;
      final gateway = await _app(t);
      expect(find.byType(NgBrandLanding), findsNothing);
      expect(find.byType(NgChatView), findsOneWidget);
      if (link.prefill != null) {
        expect(find.text(link.prefill!), findsOneWidget);
      }
      expect(gateway.calls.where((c) => c.method == 'prompt.submit'), isEmpty);
    });
  }

  testWidgets('warm deep link leaves landing and preserves prefill', (t) async {
    await _app(t);
    HermesDeepLinkService.shared.pendingLink.value = const HermesDeepLink.open(
      '/chat',
      prefill: 'Shared action',
    );
    await _frames(t);
    expect(find.byType(NgBrandLanding), findsNothing);
    expect(find.text('Shared action'), findsOneWidget);
  });

  testWidgets(
    'share cold activation skips landing and retains draft without sending',
    (t) async {
      final shares = AndroidShareIntentService();
      shares.pendingShare.value = const AndroidSharePayload(text: 'Shared URL');
      final gateway = await _app(t, shares: shares);
      expect(find.byType(NgBrandLanding), findsNothing);
      expect(find.text('Shared URL'), findsOneWidget);
      expect(shares.pendingShare.value, isNull);
      expect(gateway.calls.where((c) => c.method == 'prompt.submit'), isEmpty);
    },
  );

  testWidgets('launcher quick-chat cold activation skips landing', (t) async {
    final launches = AndroidLaunchIntentService();
    launches.pendingQuickChat.value = true;
    await _app(t, launches: launches);
    expect(find.byType(NgBrandLanding), findsNothing);
    expect(find.byType(NgChatView), findsOneWidget);
    expect(launches.pendingQuickChat.value, isFalse);
  });

  testWidgets('secondary chat views never install a landing', (t) async {
    await _app(t, pane: true);
    expect(find.byType(NgBrandLanding), findsNothing);
    expect(find.byType(NgProjectGreeting), findsOneWidget);
  });

  for (final size in [const Size(393, 852), const Size(1440, 900)]) {
    for (final brightness in Brightness.values) {
      testWidgets(
        'brand + project picker + sparkle ${size.width} $brightness, keyboard and cwd send',
        (t) async {
          final gateway = await _app(t, size: size, brightness: brightness);
          await _newChat(t);
          expect(find.byType(NgBrandMark), findsOneWidget);
          expect(find.byIcon(Icons.auto_awesome), findsWidgets);
          final picker = find.byKey(const Key('nextgen-project-picker'));
          expect(picker, findsOneWidget);
          await t.tap(picker);
          await _frames(t);
          await t.tap(
            find.widgetWithText(CheckedPopupMenuItem<String>, 'Home project'),
          );
          await _frames(t);
          final chat = t.widget<NgChatView>(find.byType(NgChatView)).chat;
          expect(chat.workingDirectory, '/srv/home');
          final mark = t.getRect(find.byType(NgBrandMark));
          final greeting = t.getRect(find.byType(NgProjectGreeting));
          expect(mark.bottom, lessThan(greeting.top));
          final initialHeight = mark.height;
          t.view.viewInsets = const FakeViewPadding(bottom: 336);
          final composer = find.byKey(const Key('ng-composer-field'));
          await t.showKeyboard(composer);
          await _frames(t);
          final rect = t.getRect(composer);
          expect(rect.bottom, lessThanOrEqualTo(size.height - 336));
          expect(rect.top, greaterThanOrEqualTo(0));
          expect(picker, findsOneWidget);
          final compact = find.byType(NgBrandMark);
          if (size.width < 600 && compact.evaluate().isNotEmpty) {
            expect(t.getSize(compact).height, lessThan(initialHeight));
          }
          await t.enterText(composer, 'Run pwd');
          expect(await chat.send('Run pwd'), isTrue);
          await _frames(t);
          final create = gateway.calls.singleWhere(
            (c) => c.method == 'session.create',
          );
          expect(create.params['cwd'], '/srv/home');
          expect(create.params['cwd_explicit'], isTrue);
          expect(t.takeException(), isNull);
        },
      );
    }
  }

  for (final locale in [const Locale('en'), const Locale('ar')]) {
    testWidgets('320x640 2x text landing and new chat fit $locale', (t) async {
      await _app(t, size: const Size(320, 640), scale: 2, locale: locale);
      expect(find.byType(NgBrandLanding), findsOneWidget);
      expect(t.takeException(), isNull);
      final semantics = t.ensureSemantics();
      expect(find.bySemanticsLabel('Ares'), findsOneWidget);
      semantics.dispose();
      await _newChat(t);
      final picker = find.byKey(const Key('nextgen-project-picker'));
      expect(picker, findsOneWidget);
      expect(find.byType(NgBrandMark), findsNothing);
      expect(t.takeException(), isNull);
    });
  }
}
