// A hermes:// prefill for an existing chat never replaces the user's unsent
// draft (review of 8d733edd, "also" gap): it is appended after it, whether the
// chat is already open or only has a saved draft. Nothing is sent.
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
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('appendComposerPrefill', () {
    test('an empty composer takes the prefill as is', () {
      expect(appendComposerPrefill('', 'From link'), 'From link');
      expect(appendComposerPrefill('  \n', 'From link'), 'From link');
    });
    test('a draft keeps its text and gets the prefill after it', () {
      expect(
        appendComposerPrefill('My draft', 'From link'),
        'My draft\n\nFrom link',
      );
      expect(
        appendComposerPrefill('My draft\n\n', 'From link'),
        'My draft\n\nFrom link',
      );
    });
    test('the same link opened twice does not repeat the prefill', () {
      expect(
        appendComposerPrefill('My draft\n\nFrom link', 'From link'),
        'My draft\n\nFrom link',
      );
    });
  });

  group('Classic', () {
    final posts = <String>[];

    setUp(() {
      posts.clear();
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

    Future<void> pumpShell(WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: WorkspaceScreen(
            connection: SavedConnection(
              id: 'classic-draft',
              label: 'Classic Phone',
              host: 'offline.test',
              port: 8642,
              apiKey: 'fixture',
            ),
            sessionsLoader: () async => [
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
            ],
            turnSignalsLoader: (_) async => HomeTurnSignals.empty,
            testChatApiClientFactory: () => ApiClient(
              baseUrl: 'http://offline.test:8642',
              apiKey: 'fixture',
              httpClient: MockClient((req) async {
                if (req.method == 'POST') posts.add(req.url.path);
                return http.Response(
                  jsonEncode(
                    req.url.path.contains('/sessions/')
                        ? {
                            'session': {
                              'id': 's-alpha',
                              'title': 'Alpha Investigation',
                            },
                            'messages': <Object>[],
                          }
                        : {'sessions': <Object>[], 'has_more': false},
                  ),
                  200,
                  headers: {'content-type': 'application/json'},
                );
              }),
            ),
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
    }

    String composerText(WidgetTester tester) => tester
        .widget<TextField>(find.byKey(const Key('chat-message-composer')))
        .controller!
        .text;

    testWidgets('a link for the open chat appends to its live draft in the '
        'same chat', (tester) async {
      HermesDeepLinkService.shared.handleRawLink('hermes://session/s-alpha');
      await pumpShell(tester);
      expect(find.byType(ChatScreen), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('chat-message-composer')),
        'My unsent draft',
      );
      await tester.pump();

      HermesDeepLinkService.shared.handleRawLink(
        'hermes://session/s-alpha?prefill=From+the+link',
      );
      await tester.pumpAndSettle();

      expect(find.byType(ChatScreen), findsOneWidget, reason: 'no 2nd copy');
      expect(composerText(tester), 'My unsent draft\n\nFrom the link');
      expect(posts, isEmpty, reason: 'a link never sends');
    });

    testWidgets('a link for a chat with a saved draft opens it with the '
        'prefill after the draft', (tester) async {
      HermesDeepLinkService.shared.handleRawLink('hermes://session/s-alpha');
      await pumpShell(tester);
      await tester.enterText(
        find.byKey(const Key('chat-message-composer')),
        'Saved draft',
      );
      await tester.pump();
      // Leave the chat; its draft is kept.
      Navigator.of(tester.element(find.byType(ChatScreen))).pop();
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsNothing);

      HermesDeepLinkService.shared.handleRawLink(
        'hermes://session/s-alpha?prefill=From+the+link',
      );
      await tester.pumpAndSettle();

      expect(find.byType(ChatScreen), findsOneWidget);
      expect(composerText(tester), 'Saved draft\n\nFrom the link');
      expect(posts, isEmpty, reason: 'a link never sends');
    });
  });
}
