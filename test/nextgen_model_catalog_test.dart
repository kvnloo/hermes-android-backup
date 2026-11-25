import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/nextgen/data/model_catalog.dart';

import 'support/models_page_fixture.dart';

void main() {
  final fixture = ModelsFixture();
  NgModelCatalog catalog([List<Object?>? providers]) =>
      NgModelCatalog.fromOptions({'providers': providers ?? fixture.providers});

  test('reads each model with its price and abilities', () {
    final c = catalog();
    expect(c.providers.map((p) => p.slug), [
      'anthropic',
      'openrouter',
      'homelab',
    ]);
    expect(c.providerName('anthropic'), 'Anthropic');
    expect(c.providerName('never-listed'), 'never-listed');

    final opus = c.model('anthropic', 'claude-opus-4.5')!;
    expect(opus.price!.input, r'$5.00');
    expect(opus.price!.output, r'$25.00');
    expect(opus.price!.cache, r'$0.50');
    expect(opus.price!.free, isFalse);
    expect(opus.fast, isTrue);
    expect(opus.reasoning, isTrue);

    final haiku = c.model('anthropic', 'claude-haiku-4.5')!;
    expect(haiku.price!.cache, isNull);
    expect(haiku.fast, isFalse);

    final free = c.model('openrouter', 'meta/llama-free')!;
    expect(free.price!.free, isTrue);
    expect(free.reasoning, isFalse);

    // No pricing row at all is "unknown", not "free".
    expect(c.model('openrouter', 'openai/gpt-pro')!.price, isNull);
    expect(c.provider('openrouter')!.totalModels, 340);
  });

  test('an unreadable or empty price is unknown', () {
    final c = catalog([
      {
        'slug': 'p',
        'models': ['a', 'b', 'c'],
        'pricing': {
          'a': {'input': '?', 'output': '?', 'cache': '?', 'free': false},
          'b': {'input': '', 'output': '', 'free': false},
          'c': {'input': r'$1.00', 'output': '?', 'free': false},
        },
      },
    ]);
    expect(c.model('p', 'a')!.price, isNull);
    expect(c.model('p', 'b')!.price, isNull);
    expect(c.model('p', 'c')!.price!.input, r'$1.00');
    expect(c.model('p', 'c')!.price!.output, '');
  });

  test('models are assigned from every provider the gateway names', () {
    final c = catalog();
    expect(c.assignable.map((p) => p.slug), [
      'anthropic',
      'openrouter',
      'homelab',
    ]);
    expect(c.canAssign('anthropic', 'claude-haiku-4.5'), isTrue);
    expect(c.canAssign('anthropic', 'not-listed'), isFalse);
    // Not on the signed-in plan.
    expect(c.model('openrouter', 'openai/gpt-pro')!.locked, isTrue);
    expect(c.canAssign('openrouter', 'openai/gpt-pro'), isFalse);
    // A named endpoint is assigned by name like any other provider.
    expect(c.provider('homelab')!.gatewayOnly, isFalse);
    expect(c.canAssign('homelab', 'local-llm'), isTrue);
  });

  test('endpoints with no name and legacy custom: rows are not chosen', () {
    for (final slug in [
      'custom',
      'local',
      'Custom',
      'ollama',
      'llama.cpp',
      'custom:lab',
      'custom:ollama',
    ]) {
      final c = catalog([
        {
          'slug': slug,
          'models': ['m'],
        },
      ]);
      expect(c.providers.single.gatewayOnly, isTrue, reason: slug);
      expect(c.assignable, isEmpty, reason: slug);
      expect(c.canAssign(slug, 'm'), isFalse, reason: slug);
    }
    // `providers:` entries, however the gateway marks them, are chosen by
    // name.
    for (final row in [
      {'slug': 'lab', 'is_user_defined': true},
      {'slug': 'lab', 'api_url': 'https://private.example/v1'},
      {'slug': 'lab', 'base_url': 'https://private.example/v1'},
      {'slug': 'customer-cloud'},
    ]) {
      final c = catalog([
        {
          ...row,
          'models': ['m'],
        },
      ]);
      final slug = row['slug'] as String;
      expect(c.providers.single.gatewayOnly, isFalse, reason: '$row');
      expect(c.canAssign(slug, 'm'), isTrue, reason: '$row');
    }
  });

  test('skips rows it cannot name and repeats', () {
    final c = catalog([
      {
        'slug': 'a',
        'models': ['m', 'm', '', 7],
      },
      {
        'slug': 'a',
        'models': ['other'],
      },
      {
        'slug': 'auto',
        'models': ['m'],
      },
      {
        'models': ['m'],
      },
      'not a row',
      {
        'id': 'legacy-id',
        'models': [
          {'id': 'from-map'},
        ],
      },
    ]);
    expect(c.providers.map((p) => p.slug), ['a', 'legacy-id']);
    expect(c.provider('a')!.models.map((m) => m.id), ['m']);
    expect(c.provider('legacy-id')!.models.single.id, 'from-map');
    expect(
      () => NgModelCatalog.fromOptions({'providers': 'nope'}),
      throwsFormatException,
    );
  });

  test('reads rate limits for a whole sign-in and for single models', () {
    final account = catalog([
      {
        'slug': 'a',
        'models': ['m', 'n'],
        'limit': {'scope': 'account', 'resets_at': '2030-01-01T10:00:00+00:00'},
      },
    ]).providers.single;
    expect(account.limited, isTrue);
    expect(account.limitedUntil, DateTime.utc(2030, 1, 1, 10));
    expect(account.models.every((m) => m.limited), isTrue);

    final models = catalog([
      {
        'slug': 'a',
        'models': ['m', 'n'],
        'limit': {
          'scope': 'models',
          'models': {'n': '2030-02-01T00:00:00+00:00'},
        },
      },
    ]).providers.single;
    expect(models.limited, isFalse);
    expect(models.model('m')!.limited, isFalse);
    expect(models.model('n')!.limited, isTrue);
    expect(models.model('n')!.limitedUntil, DateTime.utc(2030, 2));
  });

  test('reads allowance windows for one account and for several', () {
    final single = catalog().provider('anthropic')!;
    expect(single.windows.single.label, '5-hour session');
    expect(single.windows.single.usedPercent, 42.4);
    expect(single.windows.single.resetsAt, DateTime.utc(2030, 1, 1, 10));
    expect(single.accounts, isEmpty);

    final pooled = catalog([
      {
        'slug': 'a',
        'models': ['m'],
        'usage': {
          'windows': [],
          'accounts': [
            {
              'id': 'one',
              'label': 'Work',
              'state': 'ready',
              'windows': [
                {'label': 'Weekly', 'used_percent': 130},
                {'label': 'No number yet', 'used_percent': null},
              ],
            },
            {
              'id': 'two',
              'state': 'limited',
              'resets_at': '2030-03-01T00:00:00+00:00',
            },
          ],
        },
      },
    ]).providers.single;
    expect(pooled.windows, isEmpty);
    expect(pooled.accounts.map((a) => a.label), ['Work', '']);
    expect(pooled.accounts.first.windows.single.usedPercent, 100);
    expect(pooled.accounts.last.state, 'limited');
    expect(pooled.accounts.last.resetsAt, DateTime.utc(2030, 3));
  });

  test('default model: context and abilities', () {
    final main = NgMainModel.fromInfo(fixture.info);
    expect(main.provider, 'anthropic');
    expect(main.model, 'claude-opus-4.5');
    expect(main.effectiveContext, 200000);
    expect(main.autoContext, 200000);
    expect(main.configContext, 0);
    expect(main.maxOutput, 64000);
    expect(main.tools, isTrue);
    expect(main.vision, isTrue);
    expect(main.reasoning, isTrue);
    expect(main.assigned, isTrue);

    final bare = NgMainModel.fromInfo({'model': 7, 'provider': null});
    expect(bare.assigned, isFalse);
    expect(bare.effectiveContext, 0);
    expect(bare.maxOutput, isNull);
    expect(bare.tools, isNull);
  });

  test('helper tasks: defaults, endpoints and thinking levels', () {
    final tasks = {
      for (final t in NgAuxTask.parseAll({'tasks': fixture.tasks})) t.task: t,
    };
    expect(tasks.keys, [
      'vision',
      'compression',
      'acme_summary',
      'custom_route',
      'web_extract',
    ]);
    expect(tasks['vision']!.usesDefault, isTrue);
    expect(tasks['vision']!.effortSupported, isTrue);
    expect(tasks['vision']!.effort, isNull);

    expect(tasks['compression']!.usesDefault, isFalse);
    expect(tasks['compression']!.effort, 'low');

    expect(tasks['acme_summary']!.label, 'Acme summary');
    expect(tasks['acme_summary']!.hint, 'Summarises Acme tickets');
    expect(tasks['acme_summary']!.effectiveModel, 'google/gemini-flash');

    expect(tasks['custom_route']!.endpoint, isTrue);
    expect(tasks['web_extract']!.effortSupported, isFalse);
    expect(tasks['web_extract']!.endpoint, isFalse);

    expect(() => NgAuxTask.parseAll({'tasks': null}), throwsFormatException);
  });

  test('token counts are short and exact enough to compare', () {
    expect(ngTokenCount(512), '512');
    expect(ngTokenCount(8192), '8.2K');
    expect(ngTokenCount(64000), '64K');
    expect(ngTokenCount(128000), '128K');
    expect(ngTokenCount(200000), '200K');
    expect(ngTokenCount(1000000), '1M');
    expect(ngTokenCount(1048576), '1.05M');
  });
}
