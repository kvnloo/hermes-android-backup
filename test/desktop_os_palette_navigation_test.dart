// Regression (review of 8d733edd, PROBE-8): on narrow Classic (390x844) the
// chat is a route pushed over the shell. Palette navigation commands (Chats,
// Scheduled / Crons, Projects, Activity) and the tab shortcuts must pop back
// to the shell and then switch, not only switch the hidden tab underneath.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hermes_deeplink.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/utils/home_turn_signals.dart';
import 'package:hermes_android/core/widgets/command_palette.dart';
import 'package:hermes_android/core/widgets/desktop_shortcuts.dart';
import 'package:hermes_android/core/widgets/hermes_shell.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiClient _offlineClassicApiClient() => ApiClient(
  baseUrl: 'http://offline.test:8642',
  apiKey: 'fixture',
  httpClient: MockClient((req) async {
    if (req.url.path.contains('/sessions/')) {
      return http.Response(
        jsonEncode({
          'session': {
            'id': 's-alpha',
            'title': 'Alpha Investigation',
            'model': 'gpt-test',
          },
          'messages': <Object>[],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    }
    return http.Response(
      jsonEncode({'sessions': <Object>[], 'has_more': false}),
      200,
      headers: {'content-type': 'application/json'},
    );
  }),
);

List<Session> _sessions() => [
  Session(
    id: 's-alpha',
    title: 'Alpha Investigation',
    source: 'desktop',
    model: 'gpt-test',
    messageCount: 2,
    isActive: false,
    preview: 'investigating',
    startedAt: 1700000000,
    lastActive: 1700000100,
    endedAt: null,
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    HermesDeepLinkService.shared.resetForTesting();
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
    PackageInfo.setMockInitialValues(
      appName: 'Ares',
      packageName: 'com.hermesagent.hermes_android',
      version: '5.0.0-test',
      buildNumber: '5000',
      buildSignature: '',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_tts'),
          (_) async => <Object>[],
        );
  });

  tearDown(() {
    HermesDeepLinkService.shared.resetForTesting();
    HermesSignInVault.resetForTesting();
  });

  Future<void> pumpWorkspaceWithOpenChat(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    // Open the chat route the same way a cold deep link does.
    HermesDeepLinkService.shared.handleRawLink('hermes://session/s-alpha');
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: WorkspaceScreen(
          connection: SavedConnection(
            id: 'classic-narrow',
            label: 'Classic Phone',
            host: 'offline.test',
            port: 8642,
            apiKey: 'fixture',
          ),
          sessionsLoader: () async => _sessions(),
          turnSignalsLoader: (_) async => HomeTurnSignals.empty,
          testChatApiClientFactory: _offlineClassicApiClient,
          testDashboardHttpClient: MockClient(
            (_) async => http.Response(
              jsonEncode({'sessions': <Object>[], 'total': 0}),
              200,
              headers: {'content-type': 'application/json'},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ChatScreen), findsOneWidget);
  }

  HermesDestination shown(WidgetTester tester) =>
      tester.state<HermesShellState>(find.byType(HermesShell)).current;

  const destinations = {
    'Projects': HermesDestination.projects,
    'Scheduled / Crons': HermesDestination.crons,
    'Activity': HermesDestination.activity,
    'Chats': HermesDestination.chats,
  };

  for (final entry in destinations.entries) {
    final label = entry.key;
    testWidgets('narrow Classic: palette "$label" from an open chat pops back '
        'to the shell and shows it (PROBE-8)', (tester) async {
      await pumpWorkspaceWithOpenChat(tester);
      await tester.tap(find.byTooltip('More chat tools'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text('App command palette'));
      await tester.pumpAndSettle();
      expect(find.byType(CommandPalette), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(CommandPalette),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CommandPalette), findsNothing);
      expect(
        find.byType(ChatScreen),
        findsNothing,
        reason: 'the chat route must not keep covering the shell',
      );
      expect(shown(tester), entry.value);
    });
  }

  testWidgets('narrow Classic: the Go to tab 3 shortcut from an open chat '
      'pops back to the shell and shows Projects', (tester) async {
    await pumpWorkspaceWithOpenChat(tester);
    fireDesktopShortcut(DesktopShortcut.tab3);
    await tester.pumpAndSettle();
    expect(find.byType(ChatScreen), findsNothing);
    expect(shown(tester), HermesDestination.projects);
  });
}
