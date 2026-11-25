import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/models_page.dart';
import 'package:hermes_android/nextgen/ui/more_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/models_page_fixture.dart';

const profile = 'research & development';

Widget app(
  Widget home, {
  Locale locale = const Locale('en'),
  double textScale = 1,
}) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: NgLocalizationScope(child: child!),
  ),
  home: home,
);

/// Opens the page on a screen tall enough to show every section at once.
Future<ModelsFixture> open(
  WidgetTester tester, {
  void Function(ModelsFixture)? arrange,
  Size size = const Size(800, 3200),
  Locale locale = const Locale('en'),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final fixture = ModelsFixture();
  arrange?.call(fixture);
  addTearDown(fixture.client.close);
  await tester.pumpWidget(
    app(
      NgModelsPage(connection: modelsConnection, client: fixture.client),
      locale: locale,
      textScale: textScale,
    ),
  );
  await tester.pumpAndSettle();
  return fixture;
}

Finder inside(String key, String text) =>
    find.descendant(of: find.byKey(ValueKey(key)), matching: find.text(text));

Finder choice(String route) => find.byKey(ValueKey('ng-choice-$route'));

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(ValueKey(key)));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    NextGenLook.instance
      ..themeMode = ThemeMode.dark
      ..accent = NgAccent.blue
      ..pureBlack = false
      ..glow = true;
  });

  testWidgets('the default model shows what the gateway knows about it', (
    tester,
  ) async {
    await open(tester);
    const card = 'ng-models-default';
    expect(inside(card, 'claude-opus-4.5'), findsOneWidget);
    expect(inside(card, 'Anthropic'), findsOneWidget);
    for (final pill in ['Tools', 'Vision', 'Reasoning', 'Fast mode']) {
      expect(inside(card, pill), findsOneWidget, reason: pill);
    }
    for (final (label, value) in [
      ('Context window', '200K tokens'),
      ('Max output', '64K tokens'),
      ('Input price', r'$5.00 per 1M tokens'),
      ('Output price', r'$25.00 per 1M tokens'),
      ('Cached input price', r'$0.50 per 1M tokens'),
    ]) {
      expect(inside(card, label), findsOneWidget, reason: label);
      expect(inside(card, value), findsOneWidget, reason: label);
    }
    expect(
      find.text(
        'Changes the default for Research. Use the selector in a chat to '
        'override only that conversation.',
      ),
      findsOneWidget,
    );
    // The old screen's markdown-style line is gone.
    expect(find.textContaining('via `'), findsNothing);
    expect(find.byKey(const ValueKey('ng-models-change-default')), findsOne);
  });

  testWidgets('a context size set on the gateway shows both numbers', (
    tester,
  ) async {
    await open(
      tester,
      arrange: (f) => f.info = {
        ...f.info,
        'config_context_length': 100000,
        'effective_context_length': 100000,
      },
    );
    expect(inside('ng-models-default', '100K tokens'), findsOneWidget);
    expect(
      find.text('Set on the gateway. Auto-detected: 200K tokens.'),
      findsOneWidget,
    );
  });

  testWidgets('what is unknown is left out, not guessed', (tester) async {
    await open(
      tester,
      arrange: (f) {
        f.info = {'model': 'openai/gpt-pro', 'provider': 'openrouter'};
      },
    );
    const card = 'ng-models-default';
    expect(inside(card, 'openai/gpt-pro'), findsOneWidget);
    for (final absent in [
      'Context window',
      'Max output',
      'Input price',
      'Output price',
      'Tools',
      'Vision',
      // The model list calls every model it has no record for a reasoning
      // model, so only `model/info` counts.
      'Reasoning',
      'Free',
    ]) {
      expect(inside(card, absent), findsNothing, reason: absent);
    }
  });

  testWidgets('helper tasks are named and say which model they use', (
    tester,
  ) async {
    await open(tester);
    expect(inside('ng-aux-vision', 'Vision'), findsOneWidget);
    expect(
      inside('ng-aux-vision', 'Reads images and screenshots'),
      findsOneWidget,
    );
    expect(inside('ng-aux-vision', 'Uses the default model'), findsOneWidget);

    expect(inside('ng-aux-compression', 'Compression'), findsOneWidget);
    expect(inside('ng-aux-compression', 'google/gemini-flash'), findsOneWidget);
    expect(
      inside(
        'ng-aux-compression',
        r'OpenRouter · $0.30 in · $2.50 out per 1M tokens',
      ),
      findsOneWidget,
    );
    expect(inside('ng-aux-compression', 'Low'), findsOneWidget);

    // A plugin's task uses the plugin's own words and shows what it resolves to.
    expect(inside('ng-aux-acme_summary', 'Acme summary'), findsOneWidget);
    expect(
      inside('ng-aux-acme_summary', 'Summarises Acme tickets'),
      findsOneWidget,
    );
    expect(
      inside('ng-aux-acme_summary', 'google/gemini-flash'),
      findsOneWidget,
    );

    // A task this app has no name for is still readable.
    expect(inside('ng-aux-web_extract', 'Web extract'), findsOneWidget);

    expect(inside('ng-aux-custom_route', 'private-model'), findsOneWidget);
    expect(
      inside(
        'ng-aux-custom_route',
        'Runs on a custom endpoint. Change it on the gateway.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('providers show their allowance and open their model list', (
    tester,
  ) async {
    final fixture = await open(tester);
    const anthropic = 'ng-provider-anthropic';
    expect(inside(anthropic, 'Anthropic'), findsOneWidget);
    expect(inside(anthropic, '2 models'), findsOneWidget);
    expect(inside(anthropic, 'In use'), findsOneWidget);
    expect(inside(anthropic, '5-hour session'), findsOneWidget);
    expect(inside(anthropic, '42% used · 58% remaining'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey(anthropic)),
        matching: find.textContaining('Resets: '),
      ),
      findsOneWidget,
    );
    expect(inside('ng-provider-openrouter', '340 models'), findsOneWidget);
    expect(inside('ng-provider-openrouter', 'In use'), findsNothing);
    expect(inside('ng-provider-homelab', '1 model'), findsOneWidget);

    await tapKey(tester, 'ng-provider-openrouter');
    expect(choice('openrouter/google/gemini-flash'), findsOneWidget);
    expect(find.text(r'$0.30 in · $2.50 out per 1M tokens'), findsOneWidget);
    expect(
      find.descendant(
        of: choice('openrouter/meta/llama-free'),
        matching: find.text('Free'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: choice('openrouter/openai/gpt-pro'),
        matching: find.text('Not on your plan'),
      ),
      findsOneWidget,
    );
    // Another provider's models are not in this list.
    expect(choice('anthropic/claude-opus-4.5'), findsNothing);

    // Looking is not choosing.
    await tester.tap(choice('openrouter/google/gemini-flash'));
    await tester.pumpAndSettle();
    expect(choice('openrouter/google/gemini-flash'), findsOneWidget);
    expect(fixture.modelWrites, isEmpty);
    expect(fixture.configWrites, isEmpty);
  });

  testWidgets('a rate limit is shown on the provider and on its models', (
    tester,
  ) async {
    await open(
      tester,
      arrange: (f) => f.providers[1] = {
        ...f.providers[1],
        'limit': {'scope': 'account', 'resets_at': '2030-01-01T10:00:00+00:00'},
      },
    );
    expect(inside('ng-provider-openrouter', 'Rate-limited'), findsOneWidget);
    await tapKey(tester, 'ng-provider-openrouter');
    expect(
      find.descendant(
        of: choice('openrouter/google/gemini-flash'),
        matching: find.text('Rate-limited'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('endpoint addresses and key names never reach the screen', (
    tester,
  ) async {
    await open(
      tester,
      arrange: (f) => f.config = {
        'fallback_providers': [
          {
            'provider': 'lab',
            'model': 'private-model',
            'base_url': 'https://private.example/v1',
            'api_key': 'sk-never-show',
            'key_env': 'LAB_KEY',
          },
        ],
      },
    );
    for (final secret in [
      'private.example',
      'HOMELAB_SECRET_KEY',
      'sk-never-show',
      'LAB_KEY',
    ]) {
      expect(find.textContaining(secret), findsNothing, reason: secret);
    }
    expect(inside('ng-fallback-row-0', 'private-model'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('ng-fallback-row-0')),
        matching: find.textContaining('Routing details'),
      ),
      findsOneWidget,
    );
    // The provider with an endpoint is listed, and so is its model.
    await tapKey(tester, 'ng-provider-homelab');
    expect(choice('homelab/local-llm'), findsOneWidget);
    expect(find.textContaining('private.example'), findsNothing);
  });

  testWidgets('changing the default goes through the list and is read back', (
    tester,
  ) async {
    final fixture = await open(tester);
    await tapKey(tester, 'ng-models-change-default');
    // A named endpoint is offered like any provider, without its address;
    // a model that is not on the plan cannot be picked.
    expect(choice('homelab/local-llm'), findsOneWidget);
    expect(find.textContaining('private.example'), findsNothing);
    await tester.tap(choice('openrouter/openai/gpt-pro'));
    await tester.pumpAndSettle();
    expect(fixture.modelWrites, isEmpty);

    await tester.tap(choice('openrouter/google/gemini-flash'));
    await tester.pumpAndSettle();
    expect(fixture.modelWrites.single, {
      'scope': 'main',
      'provider': 'openrouter',
      'model': 'google/gemini-flash',
      'profile': profile,
    });
    expect(inside('ng-models-default', 'google/gemini-flash'), findsOneWidget);
    expect(inside('ng-models-default', 'OpenRouter'), findsOneWidget);
    expect(inside('ng-provider-openrouter', 'In use'), findsOneWidget);
    expect(inside('ng-provider-anthropic', 'In use'), findsNothing);
    expect(
      find.text(
        'Profile default set to google/gemini-flash. Chats with their own '
        'model keep that override.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('an expensive default asks first and can be declined', (
    tester,
  ) async {
    final fixture = await open(
      tester,
      arrange: (f) => f.confirmMessage = 'claude-haiku-4.5 is expensive.',
    );
    await tapKey(tester, 'ng-models-change-default');
    await tester.tap(choice('anthropic/claude-haiku-4.5'));
    await tester.pumpAndSettle();
    expect(find.text('claude-haiku-4.5 is expensive.'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(fixture.modelWrites, hasLength(1));
    expect(inside('ng-models-default', 'claude-opus-4.5'), findsOneWidget);
    expect(find.textContaining('Profile default set to'), findsNothing);

    await tapKey(tester, 'ng-models-change-default');
    await tester.tap(choice('anthropic/claude-haiku-4.5'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'ng-models-confirm');
    expect(fixture.modelWrites, hasLength(3));
    expect(
      fixture.modelWrites[1].containsKey('confirm_expensive_model'),
      isFalse,
    );
    expect(fixture.modelWrites[2]['confirm_expensive_model'], isTrue);
    expect(inside('ng-models-default', 'claude-haiku-4.5'), findsOneWidget);
  });

  testWidgets(
    'agreeing after the page moved to another gateway sends nothing',
    (tester) async {
      final first = await open(
        tester,
        arrange: (f) => f.confirmMessage = 'claude-haiku-4.5 is expensive.',
      );
      await tapKey(tester, 'ng-models-change-default');
      await tester.tap(choice('anthropic/claude-haiku-4.5'));
      await tester.pumpAndSettle();
      expect(find.text('claude-haiku-4.5 is expensive.'), findsOneWidget);

      // The page is given another gateway while the warning is still open.
      final second = ModelsFixture();
      addTearDown(second.client.close);
      await tester.pumpWidget(
        app(NgModelsPage(connection: modelsConnection, client: second.client)),
      );
      await tester.pumpAndSettle();
      expect(second.at('/model/info'), hasLength(1));

      await tapKey(tester, 'ng-models-confirm');
      expect(first.modelWrites, hasLength(1));
      expect(second.modelWrites, isEmpty);
      expect(find.textContaining('Profile default set to'), findsNothing);
    },
  );

  testWidgets('a save that cannot be confirmed says so', (tester) async {
    final fixture = await open(tester, arrange: (f) => f.persist = false);
    await tapKey(tester, 'ng-models-change-default');
    await tester.tap(choice('openrouter/google/gemini-flash'));
    await tester.pumpAndSettle();
    expect(fixture.modelWrites, hasLength(1));
    expect(inside('ng-models-default', 'claude-opus-4.5'), findsOneWidget);
    expect(
      find.text(
        'Model settings could not be loaded or saved. Refresh and try again.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Profile default set to'), findsNothing);
  });

  testWidgets('a default whose endpoint would be lost is shown but not '
      'changeable', (tester) async {
    final fixture = await open(
      tester,
      arrange: (f) => f.endpoint = 'https://private.example/v1',
    );
    expect(inside('ng-models-default', 'claude-opus-4.5'), findsOneWidget);
    expect(
      inside(
        'ng-models-default',
        'Runs on a custom endpoint. Change it on the gateway.',
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('ng-models-change-default')),
      findsNothing,
    );
    expect(find.textContaining('private.example'), findsNothing);
    expect(fixture.modelWrites, isEmpty);
  });

  testWidgets('a default on a provider plugin\'s own address is changed', (
    tester,
  ) async {
    // A subscription plugin: the gateway keeps its address with the default
    // model, and the model in use is a variant its list does not name.
    final fixture = await open(
      tester,
      arrange: (f) {
        f.providers.add({
          'slug': 'plugin-subscription',
          'name': 'Plugin subscription',
          'models': ['big-model'],
        });
        f.info = {
          ...f.info,
          'provider': 'plugin-subscription',
          'model': 'big-model[1m]',
        };
        f.endpoint = 'process://plugin-subscription';
      },
    );
    expect(inside('ng-models-default', 'big-model[1m]'), findsOneWidget);
    expect(
      find.text('Runs on a custom endpoint. Change it on the gateway.'),
      // Only the helper task that has its own endpoint says so.
      findsOneWidget,
    );
    expect(find.textContaining('process://'), findsNothing);

    await tapKey(tester, 'ng-models-change-default');
    await tester.tap(choice('homelab/local-llm'));
    await tester.pumpAndSettle();
    expect(fixture.modelWrites.single, {
      'scope': 'main',
      'provider': 'homelab',
      'model': 'local-llm',
      'profile': profile,
    });
    expect(inside('ng-models-default', 'local-llm'), findsOneWidget);
    // On a named endpoint now, and still changeable.
    expect(
      find.byKey(const ValueKey('ng-models-change-default')),
      findsOneWidget,
    );
    expect(find.textContaining('private.example'), findsNothing);
  });

  testWidgets('a fallback row is given another model by tapping it', (
    tester,
  ) async {
    final fixture = await open(
      tester,
      arrange: (f) => f.config = {
        'fallback_providers': [
          {'provider': 'openrouter', 'model': 'google/gemini-flash'},
          {'provider': 'homelab', 'model': 'local-llm'},
          {
            'provider': 'lab',
            'model': 'private-model',
            'base_url': 'https://private.example/v1',
            'key_env': 'LAB_KEY',
          },
        ],
      },
    );
    // A row with routing details keeps its model: it has no change control.
    expect(find.byKey(const ValueKey('ng-fallback-change-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('ng-fallback-change-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('ng-fallback-change-2')), findsNothing);

    await tapKey(tester, 'ng-fallback-change-0');
    // Another row's model cannot be picked: the sheet stays open.
    await tester.tap(choice('homelab/local-llm'));
    await tester.pumpAndSettle();
    expect(choice('homelab/local-llm'), findsOneWidget);
    await tester.tap(choice('anthropic/claude-haiku-4.5'));
    await tester.pumpAndSettle();

    expect(inside('ng-fallback-row-0', 'claude-haiku-4.5'), findsOneWidget);
    expect(inside('ng-fallback-row-1', 'local-llm'), findsOneWidget);
    expect(find.text('Unsaved changes'), findsOneWidget);
    expect(fixture.configWrites, isEmpty);

    await tapKey(tester, 'ng-fallback-save');
    expect(fixture.configWrites.single, {
      'config': {
        'fallback_providers': [
          {'provider': 'anthropic', 'model': 'claude-haiku-4.5'},
          {'provider': 'homelab', 'model': 'local-llm'},
          {
            'provider': 'lab',
            'model': 'private-model',
            'base_url': 'https://private.example/v1',
            'key_env': 'LAB_KEY',
          },
        ],
      },
      'profile': profile,
    });
    expect(find.text('Fallback list saved and verified.'), findsOneWidget);
    for (final secret in ['private.example', 'LAB_KEY']) {
      expect(find.textContaining(secret), findsNothing, reason: secret);
    }
  });

  testWidgets('fallbacks are added, reordered and saved as one list', (
    tester,
  ) async {
    final fixture = await open(tester);
    expect(inside('ng-fallback-row-0', 'google/gemini-flash'), findsOneWidget);
    expect(find.text('Unsaved changes'), findsNothing);

    await tapKey(tester, 'ng-fallback-add');
    // A route already in the list cannot be added twice.
    await tester.tap(choice('openrouter/google/gemini-flash'));
    await tester.pumpAndSettle();
    expect(choice('openrouter/google/gemini-flash'), findsOneWidget);
    await tester.tap(choice('anthropic/claude-haiku-4.5'));
    await tester.pumpAndSettle();

    expect(inside('ng-fallback-row-1', 'claude-haiku-4.5'), findsOneWidget);
    expect(
      inside(
        'ng-fallback-row-1',
        r'Anthropic · $1.00 in · $5.00 out per 1M tokens',
      ),
      findsOneWidget,
    );
    expect(find.text('Unsaved changes'), findsOneWidget);
    expect(fixture.configWrites, isEmpty);

    await tapKey(tester, 'ng-fallback-up-1');
    expect(inside('ng-fallback-row-0', 'claude-haiku-4.5'), findsOneWidget);
    await tapKey(tester, 'ng-fallback-save');
    expect(fixture.configWrites.single, {
      'config': {
        'fallback_providers': [
          {'provider': 'anthropic', 'model': 'claude-haiku-4.5'},
          {'provider': 'openrouter', 'model': 'google/gemini-flash'},
        ],
      },
      'profile': profile,
    });
    expect(find.text('Fallback list saved and verified.'), findsOneWidget);
    expect(find.text('Unsaved changes'), findsNothing);
  });

  testWidgets('fallback edits can be discarded, and a failed save keeps them', (
    tester,
  ) async {
    final fixture = await open(tester);
    await tapKey(tester, 'ng-fallback-remove-0');
    expect(find.text('No entries in this fallback list.'), findsOneWidget);
    await tapKey(tester, 'ng-fallback-discard');
    expect(inside('ng-fallback-row-0', 'google/gemini-flash'), findsOneWidget);
    expect(fixture.configWrites, isEmpty);

    fixture.persist = false;
    await tapKey(tester, 'ng-fallback-remove-0');
    await tapKey(tester, 'ng-fallback-save');
    expect(fixture.configWrites, hasLength(1));
    expect(
      find.textContaining('Could not verify the saved fallback list.'),
      findsOneWidget,
    );
    expect(find.text('Unsaved changes'), findsOneWidget);
    expect(find.byKey(const ValueKey('ng-fallback-row-0')), findsNothing);
  });

  testWidgets('legacy fallbacks are listed and left alone', (tester) async {
    await open(
      tester,
      arrange: (f) => f.config = {
        'fallback_providers': [],
        'fallback_model': {
          'provider': 'openrouter',
          'model': 'meta/llama-free',
        },
      },
    );
    expect(find.text('Legacy fallbacks (read-only)'), findsOneWidget);
    expect(find.text('meta/llama-free'), findsOneWidget);
    expect(find.text('OpenRouter · Free'), findsOneWidget);
  });

  testWidgets(
    'a helper task gets a model, a thinking level, then the default',
    (tester) async {
      final fixture = await open(tester);
      await tapKey(tester, 'ng-aux-vision');
      expect(find.text('Reads images and screenshots'), findsWidgets);
      expect(find.byKey(const ValueKey('ng-choice-default')), findsOneWidget);
      expect(find.text('THINKING LEVEL'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('ng-choice-effort-default')),
        findsOneWidget,
      );
      await tester.tap(choice('anthropic/claude-haiku-4.5'));
      await tester.pumpAndSettle();
      expect(fixture.modelWrites.single, {
        'scope': 'auxiliary',
        'task': 'vision',
        'provider': 'anthropic',
        'model': 'claude-haiku-4.5',
        'confirm_expensive_model': false,
        'profile': profile,
      });
      expect(inside('ng-aux-vision', 'claude-haiku-4.5'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);

      await tapKey(tester, 'ng-aux-compression');
      await tapKey(tester, 'ng-choice-effort-high');
      expect(fixture.modelWrites.last['task'], 'compression');
      expect(fixture.modelWrites.last['model'], 'google/gemini-flash');
      expect(fixture.modelWrites.last['reasoning_effort'], 'high');
      expect(inside('ng-aux-compression', 'High'), findsOneWidget);

      await tapKey(tester, 'ng-aux-compression');
      await tapKey(tester, 'ng-choice-default');
      expect(fixture.modelWrites.last['provider'], 'auto');
      expect(fixture.modelWrites.last['model'], '');
      expect(
        inside('ng-aux-compression', 'Uses the default model'),
        findsOneWidget,
      );
      expect(fixture.modelWrites, hasLength(3));
    },
  );

  testWidgets(
    'an older gateway offers no thinking level; endpoints stay shut',
    (tester) async {
      final fixture = await open(tester);
      await tapKey(tester, 'ng-aux-web_extract');
      expect(find.byKey(const ValueKey('ng-choice-default')), findsOneWidget);
      expect(find.text('THINKING LEVEL'), findsNothing);
      expect(
        find.byKey(const ValueKey('ng-choice-effort-default')),
        findsNothing,
      );
      Navigator.of(
        tester.element(find.byKey(const ValueKey('ng-choice-default'))),
      ).pop();
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('ng-aux-custom_route')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('ng-choice-default')), findsNothing);
      expect(fixture.modelWrites, isEmpty);
    },
  );

  testWidgets('each section says when it could not load, and retries', (
    tester,
  ) async {
    final fixture = await open(
      tester,
      arrange: (f) => f
        ..failOptions = true
        ..failAux = true
        ..schemaStatus = 404,
    );
    expect(inside('ng-models-default', 'claude-opus-4.5'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('ng-models-change-default')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('ng-providers-unavailable')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('ng-aux-unavailable')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('ng-fallback-unavailable')),
      findsOneWidget,
    );
    expect(find.text('Auxiliary settings are unavailable.'), findsOneWidget);
    expect(find.textContaining('secret-detail'), findsNothing);
    // Nothing was read from a gateway that cannot serve raw config.
    expect(fixture.at('/api/config'), isEmpty);

    fixture
      ..failOptions = false
      ..failAux = false
      ..schemaStatus = 200;
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('ng-aux-unavailable')),
        matching: find.text('Retry'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('ng-aux-vision')), findsOneWidget);
    expect(find.byKey(const ValueKey('ng-provider-anthropic')), findsOneWidget);
    expect(find.byKey(const ValueKey('ng-fallback-row-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('ng-models-change-default')), findsOne);
  });

  testWidgets('a default that cannot be read offers a retry', (tester) async {
    final fixture = await open(tester, arrange: (f) => f.failInfo = true);
    expect(
      find.byKey(const ValueKey('ng-models-default-unavailable')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('ng-models-default')), findsNothing);
    fixture.failInfo = false;
    await tapKey(tester, 'ng-models-refresh');
    expect(inside('ng-models-default', 'claude-opus-4.5'), findsOneWidget);
  });

  for (final (locale, title) in [
    (const Locale('en'), 'Default model'),
    (const Locale('ja'), 'デフォルトモデル'),
    (const Locale('de'), 'Standardmodell'),
    (const Locale('ru'), 'Модель по умолчанию'),
  ]) {
    testWidgets('fits a narrow phone at large text in $locale', (tester) async {
      await open(
        tester,
        size: const Size(320, 640),
        locale: locale,
        textScale: 2,
        arrange: (f) => f.providers[0] = {
          ...f.providers[0],
          'limit': {
            'scope': 'account',
            'resets_at': '2030-01-01T10:00:00+00:00',
          },
        },
      );
      expect(tester.takeException(), isNull);
      expect(find.text(title.toUpperCase()), findsOneWidget);
      final list = find.byType(Scrollable).first;
      for (final key in [
        'ng-fallback-row-0',
        'ng-aux-compression',
        'ng-aux-custom_route',
        'ng-provider-anthropic',
        'ng-provider-homelab',
      ]) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey(key)),
          200,
          scrollable: list,
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$locale $key');
      }
      // Leave the shared NextGen strings in English for the next test.
      await tester.pumpWidget(app(const SizedBox()));
      await tester.pumpAndSettle();
    });
  }

  testWidgets('More opens this page, not the classic model screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final fixture = ModelsFixture();
    final gateway = NextGenGateway(modelsConnection, dashboard: fixture.client);
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      app(
        NgScope(
          connManager: ConnectionManager(prefs),
          gateway: gateway,
          connections: [modelsConnection],
          switchTo: (_) async {},
          addGateway: () async {},
          signOut: (_) async {},
          reload: () async {},
          signInAgain: () async {},
          child: NgMorePage(onOpenSession: (_) {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Opening More reads nothing about models.
    expect(fixture.requests, isEmpty);
    await tester.tap(find.text('Model management'));
    await tester.pumpAndSettle();
    expect(find.byType(NgModelsPage), findsOneWidget);
    expect(inside('ng-models-default', 'claude-opus-4.5'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    gateway.dispose();
  });
}
