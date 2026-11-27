import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/legal_links.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

SavedConnection _connection() => SavedConnection(
  id: 'c1',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: '',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
  dashboardProxied: true,
);

double _contrast(Color foreground, Color background) {
  final a = foreground.computeLuminance();
  final b = background.computeLuminance();
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;
  return (lighter + 0.05) / (darker + 0.05);
}

Widget _app(
  NgChatController chat,
  NextGenGateway gateway,
  ConnectionManager connections,
) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
  home: NgScope(
    connManager: connections,
    gateway: gateway,
    connections: [gateway.connection],
    switchTo: (_) async {},
    addGateway: () async {},
    signOut: (_) async {},
    reload: () async {},
    signInAgain: () async {},
    child: Scaffold(
      body: NgChatView(chat: chat, onOpenSidebar: () {}, onNewChat: () {}),
    ),
  ),
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    NextGenLook.instance
      ..themeMode = ThemeMode.dark
      ..accent = NgAccent.blue
      ..pureBlack = false
      ..glow = true;
  });

  test('selected NextGen chips keep readable labels in every accent', () {
    for (final brightness in Brightness.values) {
      for (final accent in NgAccent.values) {
        NextGenLook.instance
          ..themeMode = brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light
          ..accent = accent;
        final theme = nextGenTheme(brightness, NextGenLook.instance);
        final colours = theme.extension<NgColors>()!;
        final background = Color.alphaBlend(
          theme.chipTheme.selectedColor!,
          colours.surface2,
        );
        final label = theme.chipTheme.secondaryLabelStyle?.color;
        expect(label, isNotNull);
        expect(
          _contrast(label!, background),
          greaterThanOrEqualTo(4.5),
          reason: '$brightness $accent selected chip label',
        );
      }
    }
  });

  testWidgets('every composer tap explicitly reopens the Android keyboard', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, (call) async {
          calls.add(call);
          return null;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.textInput, null);
    });
    final prefs = await SharedPreferences.getInstance();
    final gateway = NextGenGateway(_connection());
    final chat = NgChatController(gateway, sessionId: 'stored');
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));

    final finder = find.byKey(const ValueKey('ng-composer-field'));
    final field = tester.widget<TextField>(finder);
    expect(field.onTap, isNotNull);
    field.focusNode!.requestFocus();
    await tester.pump();
    calls.clear();

    // Back can hide the IME while the field keeps focus. A fresh tap must still
    // ask Android to show it.
    await tester.tap(finder);
    await tester.pump();
    expect(calls.where((call) => call.method == 'TextInput.show'), isNotEmpty);

    // Repeated taps while focus is retained must make the same request; a
    // single onTap callback is not enough to cover the reported device path.
    calls.clear();
    await tester.tap(finder);
    await tester.pump();
    expect(calls.where((call) => call.method == 'TextInput.show'), isNotEmpty);

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
  });

  testWidgets('provider chips filter and clear the composer model list', (
    tester,
  ) async {
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/model/options')) {
        return http.Response(
          jsonEncode({
            'providers': [
              {
                'slug': 'openai',
                'name': 'OpenAI',
                'models': ['gpt-5.2', 'gpt-5-mini'],
              },
              {
                'slug': 'anthropic',
                'name': 'Anthropic',
                'models': ['claude-sonnet-4'],
              },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      return http.Response('{}', 200);
    });
    final dashboard = DashboardClient(
      host: '10.0.0.5',
      proxied: true,
      httpClient: client,
    );
    final gateway = NextGenGateway(_connection(), dashboard: dashboard);
    final prefs = await SharedPreferences.getInstance();
    final chat = NgChatController(gateway, sessionId: 'stored');
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const ValueKey('ng-model-picker')));
    await tester.pumpAndSettle();

    expect(find.text('gpt-5.2', skipOffstage: false), findsOneWidget);
    expect(find.text('claude-sonnet-4', skipOffstage: false), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('ng-model-provider-openai')));
    await tester.pumpAndSettle();
    expect(find.text('gpt-5.2', skipOffstage: false), findsOneWidget);
    expect(find.text('gpt-5-mini', skipOffstage: false), findsOneWidget);
    expect(find.text('claude-sonnet-4', skipOffstage: false), findsNothing);

    // A second tap clears that provider. The All chip does the same explicitly.
    await tester.tap(find.byKey(const ValueKey('ng-model-provider-openai')));
    await tester.pumpAndSettle();
    expect(find.text('claude-sonnet-4', skipOffstage: false), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('ng-model-provider-anthropic')));
    await tester.pumpAndSettle();
    expect(find.text('gpt-5.2', skipOffstage: false), findsNothing);
    expect(find.text('claude-sonnet-4', skipOffstage: false), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('ng-model-provider-all')));
    await tester.pumpAndSettle();
    expect(find.text('gpt-5.2', skipOffstage: false), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('ng-model-search')),
      'not-a-model',
    );
    await tester.pumpAndSettle();
    expect(
      find.text('No models match these filters.', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('gpt-5.2', skipOffstage: false), findsNothing);
    expect(find.text('claude-sonnet-4', skipOffstage: false), findsNothing);

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
    client.close();
  });

  Future<void> openNgPicker(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('ng-model-picker')));
    await tester.pumpAndSettle();
  }

  // The composer chip also shows the session's model; sheet assertions must
  // be scoped to the sheet itself.
  Finder inSheet(Finder f) =>
      find.descendant(of: find.byType(DraggableScrollableSheet), matching: f);

  // Like inSheet but also counts built-but-offscreen rows; use with
  // scrollSheetToEnd before a findsNothing check.
  Finder inSheetAll(Finder f) => find.descendant(
    of: find.byType(DraggableScrollableSheet),
    matching: f,
    skipOffstage: false,
  );

  // The sheet's main ListView builds lazily; scroll it until built.
  Future<void> scrollToInSheet(WidgetTester tester, Finder f) async {
    final list = find
        .descendant(
          of: find.byType(DraggableScrollableSheet),
          matching: find.byType(ListView),
        )
        .first;
    for (var i = 0; i < 4 && f.evaluate().isEmpty; i++) {
      await tester.drag(list, const Offset(0, -250));
      await tester.pumpAndSettle();
    }
  }

  // Force the sheet's list to build everything before a findsNothing check;
  // a lazily-unbuilt row would make such an assertion vacuously true.
  Future<void> scrollSheetToEnd(WidgetTester tester) async {
    final list = find
        .descendant(
          of: find.byType(DraggableScrollableSheet),
          matching: find.byType(ListView),
        )
        .first;
    for (var i = 0; i < 4; i++) {
      await tester.drag(list, const Offset(0, -250));
      await tester.pumpAndSettle();
    }
  }

  MockClient pickerClient(Map<String, dynamic> Function() options) =>
      MockClient((request) async {
        if (request.url.path.endsWith('/model/options')) {
          return http.Response(
            jsonEncode(options()),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('{}', 200);
      });

  testWidgets('NextGen picker lists only configured providers', (tester) async {
    final client = pickerClient(
      () => {
        'providers': [
          {
            'slug': 'custom:halogen',
            'name': 'Halogen',
            'models': ['chat-a', 'chat-b'],
            'is_user_defined': true,
            'is_current': true,
          },
          {
            'slug': 'custom:gufo',
            'name': 'Gufo',
            'models': ['gufo-model'],
            'is_user_defined': true,
            'is_current': false,
          },
          {
            'slug': 'huggingface',
            'name': 'HuggingFace',
            'models': ['hidden-model', 'hidden-other'],
            'is_user_defined': false,
            'is_current': false,
          },
        ],
      },
    );
    final dashboard = DashboardClient(
      host: '10.0.0.5',
      proxied: true,
      httpClient: client,
    );
    final gateway = NextGenGateway(_connection(), dashboard: dashboard);
    final prefs = await SharedPreferences.getInstance();
    final chat = NgChatController(gateway, sessionId: 'stored');
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    await openNgPicker(tester);

    expect(inSheet(find.text('chat-a')), findsOneWidget);
    await scrollToInSheet(tester, inSheet(find.text('gufo-model')));
    expect(inSheet(find.text('gufo-model')), findsOneWidget);
    await scrollSheetToEnd(tester);
    expect(inSheetAll(find.text('hidden-model')), findsNothing);
    expect(inSheetAll(find.text('hidden-other')), findsNothing);
    expect(
      find.byKey(const ValueKey('ng-model-provider-huggingface')),
      findsNothing,
    );

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
    client.close();
  });

  testWidgets('NextGen picker keeps local-runtime and MoA rows without flags', (
    tester,
  ) async {
    final client = pickerClient(
      () => {
        'providers': [
          {
            'slug': 'custom:halogen',
            'name': 'Halogen',
            'models': ['chat-a'],
            'is_user_defined': true,
            'is_current': true,
          },
          {
            'slug': 'local',
            'name': 'Local',
            'models': ['local-model'],
            'is_user_defined': false,
            'is_current': false,
            'source': 'local-runtime',
          },
          {
            'slug': 'moa',
            'name': 'MoA',
            'models': ['moa-model'],
            'is_user_defined': false,
            'is_current': false,
            'source': 'virtual',
          },
          {
            'slug': 'huggingface',
            'name': 'HuggingFace',
            'models': ['hidden-model'],
            'is_user_defined': false,
            'is_current': false,
          },
        ],
      },
    );
    final dashboard = DashboardClient(
      host: '10.0.0.5',
      proxied: true,
      httpClient: client,
    );
    final gateway = NextGenGateway(_connection(), dashboard: dashboard);
    final prefs = await SharedPreferences.getInstance();
    final chat = NgChatController(gateway, sessionId: 'stored');
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    await openNgPicker(tester);

    // The gateway's explicit-only semantics keep managed local models and
    // the opt-in MoA row even though neither carries a configured flag.
    expect(inSheet(find.text('chat-a')), findsOneWidget);
    await scrollToInSheet(tester, inSheet(find.text('local-model')));
    expect(inSheet(find.text('local-model')), findsOneWidget);
    await scrollToInSheet(tester, inSheet(find.text('moa-model')));
    expect(inSheet(find.text('moa-model')), findsOneWidget);
    await scrollSheetToEnd(tester);
    expect(inSheetAll(find.text('hidden-model')), findsNothing);

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
    client.close();
  });

  testWidgets('NextGen pinned model from a hidden provider stays listed', (
    tester,
  ) async {
    final client = pickerClient(
      () => {
        'providers': [
          {
            'slug': 'custom:halogen',
            'name': 'Halogen',
            'models': ['chat-a'],
            'is_user_defined': true,
            'is_current': true,
          },
          {
            'slug': 'huggingface',
            'name': 'HuggingFace',
            'models': ['hidden-model', 'hidden-other'],
            'is_user_defined': false,
            'is_current': false,
          },
        ],
      },
    );
    final dashboard = DashboardClient(
      host: '10.0.0.5',
      proxied: true,
      httpClient: client,
    );
    final gateway = NextGenGateway(_connection(), dashboard: dashboard);
    final prefs = await SharedPreferences.getInstance();
    final chat = NgChatController(gateway, sessionId: 'stored');
    chat.model = 'hidden-model';
    chat.provider = 'huggingface';
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    await openNgPicker(tester);

    // The pinned row stays visible; the provider's other models stay hidden.
    expect(inSheet(find.text('chat-a')), findsOneWidget);
    await scrollToInSheet(tester, inSheet(find.text('hidden-model')));
    expect(inSheet(find.text('hidden-model')), findsOneWidget);
    // Scroll to the end so "hidden" means really absent, not unbuilt.
    await scrollSheetToEnd(tester);
    expect(inSheetAll(find.text('hidden-other')), findsNothing);

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
    client.close();
  });

  testWidgets('NextGen picker keeps the full list for flagless payloads', (
    tester,
  ) async {
    final client = pickerClient(
      () => {
        'providers': [
          {
            'slug': 'openai',
            'name': 'OpenAI',
            'models': ['gpt-5.2'],
          },
          {
            'slug': 'anthropic',
            'name': 'Anthropic',
            'models': ['claude-x'],
          },
        ],
      },
    );
    final dashboard = DashboardClient(
      host: '10.0.0.5',
      proxied: true,
      httpClient: client,
    );
    final gateway = NextGenGateway(_connection(), dashboard: dashboard);
    final prefs = await SharedPreferences.getInstance();
    final chat = NgChatController(gateway, sessionId: 'stored');
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    await openNgPicker(tester);

    expect(inSheet(find.text('gpt-5.2')), findsOneWidget);
    expect(inSheet(find.text('claude-x')), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
    client.close();
  });

  testWidgets('NextGen pinned model missing from inventory adds no row', (
    tester,
  ) async {
    final client = pickerClient(
      () => {
        'providers': [
          {
            'slug': 'custom:halogen',
            'name': 'Halogen',
            'models': ['chat-a'],
            'is_user_defined': true,
            'is_current': true,
          },
          {
            'slug': 'huggingface',
            'name': 'HuggingFace',
            'models': ['hidden-model'],
            'is_user_defined': false,
            'is_current': false,
          },
        ],
      },
    );
    final dashboard = DashboardClient(
      host: '10.0.0.5',
      proxied: true,
      httpClient: client,
    );
    final gateway = NextGenGateway(_connection(), dashboard: dashboard);
    final prefs = await SharedPreferences.getInstance();
    final chat = NgChatController(gateway, sessionId: 'stored');
    chat.model = 'gone-model';
    chat.provider = 'huggingface';
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    await openNgPicker(tester);

    expect(inSheet(find.text('chat-a')), findsOneWidget);
    await scrollSheetToEnd(tester);
    expect(inSheetAll(find.text('gone-model')), findsNothing);
    expect(inSheetAll(find.text('hidden-model')), findsNothing);

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
    client.close();
  });

  testWidgets(
    'NextGen configured provider with no models keeps filter active',
    (tester) async {
      final client = pickerClient(
        () => {
          'providers': [
            {
              'slug': 'custom:empty',
              'name': 'Empty',
              'models': <String>[],
              'is_user_defined': true,
              'is_current': false,
            },
            {
              'slug': 'nous',
              'name': 'Nous',
              'models': ['ghost-a', 'ghost-b'],
              'is_user_defined': false,
              'is_current': false,
            },
          ],
        },
      );
      final dashboard = DashboardClient(
        host: '10.0.0.5',
        proxied: true,
        httpClient: client,
      );
      final gateway = NextGenGateway(_connection(), dashboard: dashboard);
      final prefs = await SharedPreferences.getInstance();
      final chat = NgChatController(gateway, sessionId: 'stored');
      chat.model = 'ghost-a';
      chat.provider = 'nous';
      await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
      await tester.pump(const Duration(milliseconds: 300));
      await openNgPicker(tester);

      // The only configured provider has no models; the pinned row keeps the
      // filter active, so the hidden provider's other model stays hidden.
      expect(inSheet(find.text('ghost-a')), findsOneWidget);
      await scrollSheetToEnd(tester);
      expect(inSheetAll(find.text('ghost-b')), findsNothing);

      await tester.pumpWidget(const SizedBox());
      chat.dispose();
      gateway.dispose();
      client.close();
    },
  );

  testWidgets('NextGen empty configured set with no pinned model falls back', (
    tester,
  ) async {
    final client = pickerClient(
      () => {
        'providers': [
          {
            'slug': 'custom:empty',
            'name': 'Empty',
            'models': <String>[],
            'is_user_defined': true,
            'is_current': false,
          },
          {
            'slug': 'nous',
            'name': 'Nous',
            'models': ['ghost-b'],
            'is_user_defined': false,
            'is_current': false,
          },
        ],
      },
    );
    final dashboard = DashboardClient(
      host: '10.0.0.5',
      proxied: true,
      httpClient: client,
    );
    final gateway = NextGenGateway(_connection(), dashboard: dashboard);
    final prefs = await SharedPreferences.getInstance();
    final chat = NgChatController(gateway, sessionId: 'stored');
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    await openNgPicker(tester);

    // Nothing configured has models and nothing is pinned; an empty picker
    // is worse than the unfiltered list.
    expect(inSheet(find.text('ghost-b')), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
    client.close();
  });

  testWidgets('NextGen pinned row survives search and its provider chip', (
    tester,
  ) async {
    final client = pickerClient(
      () => {
        'providers': [
          {
            'slug': 'custom:halogen',
            'name': 'Halogen',
            'models': ['chat-a'],
            'is_user_defined': true,
            'is_current': true,
          },
          {
            'slug': 'huggingface',
            'name': 'HuggingFace',
            'models': ['hidden-model'],
            'is_user_defined': false,
            'is_current': false,
          },
        ],
      },
    );
    final dashboard = DashboardClient(
      host: '10.0.0.5',
      proxied: true,
      httpClient: client,
    );
    final gateway = NextGenGateway(_connection(), dashboard: dashboard);
    final prefs = await SharedPreferences.getInstance();
    final chat = NgChatController(gateway, sessionId: 'stored');
    chat.model = 'hidden-model';
    chat.provider = 'huggingface';
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    await openNgPicker(tester);

    // Searching for the pinned model keeps its synthesized row visible.
    await tester.enterText(
      find.byKey(const ValueKey('ng-model-search')),
      'hidden',
    );
    await tester.pumpAndSettle();
    expect(inSheet(find.text('hidden-model')), findsOneWidget);
    expect(inSheet(find.text('chat-a')), findsNothing);
    await tester.enterText(find.byKey(const ValueKey('ng-model-search')), '');
    await tester.pumpAndSettle();

    // The synthesized provider's chip filters to exactly the pinned pair.
    await tester.tap(
      find.byKey(const ValueKey('ng-model-provider-huggingface')),
    );
    await tester.pumpAndSettle();
    expect(inSheet(find.text('hidden-model')), findsOneWidget);
    expect(inSheet(find.text('chat-a')), findsNothing);

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
    client.close();
  });

  testWidgets('NextGen pinned pair moved out of its provider shows no row', (
    tester,
  ) async {
    final client = pickerClient(
      () => {
        'providers': [
          {
            'slug': 'custom:halogen',
            'name': 'Halogen',
            'models': ['chat-a'],
            'is_user_defined': true,
            'is_current': true,
          },
          {
            'slug': 'nous',
            'name': 'Nous',
            'models': ['moved-model'],
            'is_user_defined': false,
            'is_current': false,
          },
        ],
      },
    );
    final dashboard = DashboardClient(
      host: '10.0.0.5',
      proxied: true,
      httpClient: client,
    );
    final gateway = NextGenGateway(_connection(), dashboard: dashboard);
    final prefs = await SharedPreferences.getInstance();
    final chat = NgChatController(gateway, sessionId: 'stored');
    // Pinned to (custom:halogen, moved-model), but halogen no longer offers
    // it — the exact pair is absent, so no row is synthesized and the other
    // provider's copy is NOT shown under the pinned provider's name.
    chat.model = 'moved-model';
    chat.provider = 'custom:halogen';
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    await openNgPicker(tester);

    expect(inSheet(find.text('chat-a')), findsOneWidget);
    await scrollSheetToEnd(tester);
    expect(inSheetAll(find.text('moved-model')), findsNothing);

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
    client.close();
  });

  testWidgets('NextGen assistant reply exposes the AI output report action', (
    tester,
  ) async {
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    final launches = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          launches.add(call);
          return true;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
    final prefs = await SharedPreferences.getInstance();
    final gateway = NextGenGateway(_connection());
    final chat = NgChatController(gateway, sessionId: 'stored');
    chat.debugApplyHistory([
      {'role': 'assistant', 'content': 'A completed answer'},
    ]);
    await tester.pumpWidget(_app(chat, gateway, ConnectionManager(prefs)));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byTooltip('Report AI output'));
    await tester.pumpAndSettle();
    expect(launches, hasLength(1));
    final args = Map<Object?, Object?>.from(launches.single.arguments as Map);
    expect(args['url'], aresAiOutputReportUri.toString());

    await tester.pumpWidget(const SizedBox());
    chat.dispose();
    gateway.dispose();
  });
}
