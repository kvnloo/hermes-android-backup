import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/nextgen/data/model_settings_controller.dart';
import 'package:http/http.dart' as http;

import 'support/models_page_fixture.dart';

const profile = 'research & development';

Future<(ModelsFixture, NgModelSettingsController)> loaded([
  void Function(ModelsFixture)? arrange,
]) async {
  final fixture = ModelsFixture();
  arrange?.call(fixture);
  final controller = NgModelSettingsController(fixture.client);
  addTearDown(controller.dispose);
  addTearDown(fixture.client.close);
  await controller.load();
  return (fixture, controller);
}

void main() {
  test('loads every section for the selected profile only', () async {
    final (f, c) = await loaded();
    expect(c.loading, isFalse);
    expect(c.main!.model, 'claude-opus-4.5');
    expect(c.routeVerified, isTrue);
    expect(c.endpointOnlyHere, isFalse);
    expect(c.canChangeMain, isTrue);
    expect(c.catalog!.providers, hasLength(3));
    expect(c.auxTasks, hasLength(5));
    expect(c.fallbackDraft.single.model, 'google/gemini-flash');
    expect(c.fallbackDirty, isFalse);

    for (final suffix in [
      '/model/info',
      '/model/options',
      '/model/auxiliary',
      '/providers/custom-endpoints',
      '/api/config',
    ]) {
      final request = f.at(suffix).single;
      expect(request.method, 'GET', reason: suffix);
      expect(request.url.queryParameters['profile'], profile, reason: suffix);
    }
    // The raw config read never asks for defaults, which would expand secrets.
    expect(
      f.at('/api/config').single.url.queryParameters['include_defaults'],
      'false',
    );
    expect(f.modelWrites, isEmpty);
    expect(f.configWrites, isEmpty);
  });

  group('default model', () {
    test('a change is sent once, then read back', () async {
      final (f, c) = await loaded();
      final result = await c.setMain('openrouter', 'google/gemini-flash');
      expect(result, isA<NgModelSaved>());
      expect(f.modelWrites.single, {
        'scope': 'main',
        'provider': 'openrouter',
        'model': 'google/gemini-flash',
        'profile': profile,
      });
      expect(c.main!.provider, 'openrouter');
      expect(c.main!.model, 'google/gemini-flash');
      expect(c.saving, isFalse);
      // Info and route are each read again after the write.
      expect(f.at('/model/info'), hasLength(2));
      expect(f.at('/providers/custom-endpoints'), hasLength(2));
    });

    test('an accepted write the gateway did not keep is not a save', () async {
      final (f, c) = await loaded((f) => f.persist = false);
      final result = await c.setMain('openrouter', 'google/gemini-flash');
      expect(result, isA<NgModelSaveFailed>());
      expect(f.modelWrites, hasLength(1));
      expect(c.main!.model, 'claude-opus-4.5');
      expect(c.saving, isFalse);
    });

    test('another model read back is shown, and is not a save', () async {
      final (f, c) = await loaded();
      final write = Completer<http.Response>();
      f.heldWrite = write;
      final pending = c.setMain('openrouter', 'google/gemini-flash');
      await pumpEventQueue();
      // The gateway accepts the write but ends up on a different model.
      f.heldWrite = null;
      f.info = {
        ...f.info,
        'provider': 'anthropic',
        'model': 'claude-haiku-4.5',
      };
      write.complete(http.Response(jsonEncode({'ok': true}), 200));
      expect(await pending, isA<NgModelSaveFailed>());
      expect(c.main!.provider, 'anthropic');
      expect(c.main!.model, 'claude-haiku-4.5');
      expect(c.saving, isFalse);
    });

    test('a write or a read-back that fails leaves nothing stuck', () async {
      final (f, c) = await loaded();
      // The gateway answers the write with an error.
      final write = Completer<http.Response>();
      f.heldWrite = write;
      final refused = c.setMain('openrouter', 'google/gemini-flash');
      await pumpEventQueue();
      expect(c.saving, isTrue);
      write.complete(
        http.Response(jsonEncode({'detail': 'secret-detail'}), 500),
      );
      expect(await refused, isA<NgModelSaveFailed>());
      expect(c.saving, isFalse);
      expect(c.canChangeMain, isTrue);

      // The write is accepted, then the read-back fails.
      f.heldWrite = null;
      f.failInfo = true;
      expect(
        await c.setMain('openrouter', 'google/gemini-flash'),
        isA<NgModelSaveFailed>(),
      );
      expect(c.saving, isFalse);

      // The connection drops while a write is on its way.
      f.failInfo = false;
      final dropped = Completer<http.Response>();
      f.heldWrite = dropped;
      final lost = c.setAux('vision', 'anthropic', 'claude-haiku-4.5');
      await pumpEventQueue();
      expect(c.saving, isTrue);
      dropped.completeError(http.ClientException('connection closed'));
      expect(await lost, isA<NgModelSaveFailed>());
      expect(c.saving, isFalse);
      expect(c.canEditAux, isTrue);
    });

    test('a refused write is not a save', () async {
      final (_, c) = await loaded((f) => f.accept = false);
      expect(
        await c.setMain('openrouter', 'google/gemini-flash'),
        isA<NgModelSaveFailed>(),
      );
      expect(c.main!.model, 'claude-opus-4.5');
    });

    test('an expensive model waits for the user to agree', () async {
      final (f, c) = await loaded(
        (f) => f.confirmMessage = 'This model costs a lot.',
      );
      final first = await c.setMain('anthropic', 'claude-haiku-4.5');
      expect(first, isA<NgModelNeedsConfirmation>());
      expect(
        (first as NgModelNeedsConfirmation).message,
        'This model costs a lot.',
      );
      expect(
        f.modelWrites.single.containsKey('confirm_expensive_model'),
        isFalse,
      );
      expect(c.main!.model, 'claude-opus-4.5');
      expect(c.saving, isFalse);

      final second = await c.setMain(
        'anthropic',
        'claude-haiku-4.5',
        confirmed: true,
      );
      expect(second, isA<NgModelSaved>());
      expect(f.modelWrites.last['confirm_expensive_model'], isTrue);
      expect(c.main!.model, 'claude-haiku-4.5');
    });

    test('a refusal after the user agreed is a failure', () async {
      final fixture = ModelsFixture();
      final controller = NgModelSettingsController(fixture.client);
      addTearDown(controller.dispose);
      await controller.load();
      // ok:false with no usable message is never a reason to ask again.
      fixture.accept = false;
      expect(
        await controller.setMain(
          'anthropic',
          'claude-haiku-4.5',
          confirmed: true,
        ),
        isA<NgModelSaveFailed>(),
      );
    });

    test('only models the gateway lists can be chosen', () async {
      final (f, c) = await loaded(
        (f) => f.providers.add({
          'slug': 'custom',
          'name': 'Custom',
          'models': ['private-model'],
        }),
      );
      for (final (provider, model) in [
        ('custom', 'private-model'), // an endpoint with no name
        ('openrouter', 'openai/gpt-pro'), // not on the plan
        ('anthropic', 'made-up'), // not offered
        ('', ''),
      ]) {
        expect(
          await c.setMain(provider, model),
          isA<NgModelSaveFailed>(),
          reason: '$provider/$model',
        );
      }
      expect(f.modelWrites, isEmpty);
    });

    // The three cases where assigning another model would lose an endpoint
    // the app could not choose again.
    for (final (name, arrange) in <(String, void Function(ModelsFixture))>[
      (
        'an address that replaces the provider\'s own',
        (f) => f.endpoint = 'https://private.example/v1',
      ),
      (
        'an endpoint with no name',
        (f) {
          f.info = {...f.info, 'provider': 'custom', 'model': 'private-model'};
          f.endpoint = 'https://private.example/v1';
        },
      ),
      (
        'a named endpoint used at another address',
        (f) {
          f.info = {...f.info, 'provider': 'homelab', 'model': 'local-llm'};
          f.endpoint = 'https://elsewhere.example/v1';
        },
      ),
      (
        'a local server name the gateway routes as an unnamed endpoint',
        (f) {
          f.info = {...f.info, 'provider': 'ollama', 'model': 'qwen3'};
          f.endpoint = 'http://nas.example:11434/v1';
        },
      ),
      (
        'an unnamed endpoint spelt in capitals',
        (f) {
          f.info = {...f.info, 'provider': 'Custom', 'model': 'qwen3'};
          f.endpoint = 'http://nas.example:11434/v1';
        },
      ),
      (
        'an address typed for a provider the app has no address for',
        (f) {
          f.info = {...f.info, 'provider': 'kilocode', 'model': 'm'};
          f.endpoint = 'https://proxy.example/v1';
        },
      ),
      (
        'a bare custom default at a providers: entry\'s address',
        (f) {
          f.info = {...f.info, 'provider': 'custom', 'model': 'local-llm'};
          f.endpoint = 'http://private.example:8000/v1/';
        },
      ),
      (
        'a legacy custom: default at another address',
        (f) {
          f.providers.add({
            'slug': 'custom:legacy',
            'name': 'Legacy',
            'models': ['legacy-model'],
            'is_user_defined': true,
            'api_url': 'http://legacy.example:9000/v1',
          });
          f.info = {...f.info, 'provider': 'custom:legacy', 'model': 'm'};
          f.endpoint = 'http://other.example:9000/v1';
        },
      ),
      (
        'a legacy custom: default with no entry',
        (f) {
          f.info = {...f.info, 'provider': 'custom:gone', 'model': 'm'};
          f.endpoint = 'http://other.example:9000/v1';
        },
      ),
    ]) {
      test('a default on $name is never changed', () async {
        final (f, c) = await loaded(arrange);
        expect(c.routeVerified, isTrue);
        expect(c.endpointOnlyHere, isTrue);
        expect(c.canChangeMain, isFalse);
        expect(
          await c.setMain('openrouter', 'google/gemini-flash'),
          isA<NgModelSaveFailed>(),
        );
        expect(f.modelWrites, isEmpty);
      });
    }

    test('a default on a named endpoint is changed and changed back', () async {
      final (f, c) = await loaded(
        (f) =>
            f.info = {...f.info, 'provider': 'homelab', 'model': 'local-llm'},
      );
      expect(c.routeVerified, isTrue);
      expect(c.endpointOnlyHere, isFalse);
      expect(c.canChangeMain, isTrue);

      expect(
        await c.setMain('openrouter', 'google/gemini-flash'),
        isA<NgModelSaved>(),
      );
      expect(c.main!.provider, 'openrouter');
      // The named endpoint is chosen by name; no address is sent.
      expect(await c.setMain('homelab', 'local-llm'), isA<NgModelSaved>());
      expect(f.modelWrites.last, {
        'scope': 'main',
        'provider': 'homelab',
        'model': 'local-llm',
        'profile': profile,
      });
      expect(c.main!.provider, 'homelab');
      expect(c.canChangeMain, isTrue);
    });

    test('a default on a provider plugin\'s own address is changed, '
        'whether or not its model is listed', () async {
      // An external-process provider plugin registers `process://<name>`,
      // and the gateway writes it back whenever that provider is chosen.
      final (f, c) = await loaded((f) {
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
        f.endpoint = 'process://Plugin-Subscription';
      });
      expect(c.routeVerified, isTrue);
      expect(c.endpointOnlyHere, isFalse);
      expect(c.canChangeMain, isTrue);
      expect(
        await c.setMain('anthropic', 'claude-haiku-4.5'),
        isA<NgModelSaved>(),
      );
      expect(c.main!.model, 'claude-haiku-4.5');
      expect(
        await c.setMain('plugin-subscription', 'big-model'),
        isA<NgModelSaved>(),
      );
    });

    for (final (name, arrange) in <(String, void Function(ModelsFixture))>[
      (
        'a bare custom default at a legacy entry\'s address',
        (f) {
          f.providers.add({
            'slug': 'custom:legacy',
            'name': 'Legacy',
            'models': ['legacy-model'],
            'is_user_defined': true,
            'api_url': 'http://legacy.example:9000/v1',
          });
          f.info = {...f.info, 'provider': 'custom', 'model': 'legacy-model'};
          f.endpoint = 'HTTP://legacy.example:9000/v1/ ';
        },
      ),
      (
        'a legacy custom: default at its entry\'s address',
        (f) {
          f.providers.add({
            'slug': 'custom:legacy',
            'name': 'Legacy',
            'models': ['legacy-model'],
            'is_user_defined': true,
            'api_url': 'http://legacy.example:9000/v1',
          });
          f.info = {...f.info, 'provider': 'custom:legacy', 'model': 'm'};
          f.endpoint = 'http://legacy.example:9000/v1';
        },
      ),
      (
        'a reviewed provider at its standard address in another spelling',
        (f) {
          f.info = {...f.info, 'provider': 'openrouter', 'model': 'm'};
          f.endpoint = ' https://OpenRouter.ai/api/v1/';
        },
      ),
    ]) {
      test('$name can be changed', () async {
        final (f, c) = await loaded(arrange);
        expect(c.endpointOnlyHere, isFalse);
        expect(c.canChangeMain, isTrue);
        expect(
          await c.setMain('anthropic', 'claude-haiku-4.5'),
          isA<NgModelSaved>(),
        );
        expect(f.modelWrites, hasLength(1));
      });
    }

    test(
      'route rows the app cannot read leave the default unchangeable',
      () async {
        for (final endpoints in [
          ['not a row'],
          [
            {'id': 'a', 'is_current': 'yes'},
          ],
        ]) {
          final (f, c) = await loaded(
            (f) => f.routeOverride = {
              'current': {
                'provider': 'anthropic',
                'model': 'claude-opus-4.5',
                'base_url': '',
              },
              'endpoints': endpoints,
            },
          );
          expect(c.routeVerified, isFalse, reason: '$endpoints');
          expect(c.canChangeMain, isFalse, reason: '$endpoints');
        }
      },
    );

    test('an unreadable route leaves the default unchangeable', () async {
      final (f, c) = await loaded((f) => f.routeStatus = 500);
      expect(c.main!.model, 'claude-opus-4.5');
      expect(c.routeVerified, isFalse);
      expect(c.canChangeMain, isFalse);
      expect(
        await c.setMain('openrouter', 'google/gemini-flash'),
        isA<NgModelSaveFailed>(),
      );
      expect(f.modelWrites, isEmpty);

      // Refresh recovers once the route can be read.
      f.routeStatus = 200;
      await c.load();
      expect(c.canChangeMain, isTrue);
    });

    test('a change after which the old address is still there is not '
        'confirmed', () async {
      final fixture = ModelsFixture();
      final controller = NgModelSettingsController(fixture.client);
      addTearDown(controller.dispose);
      await controller.load();
      final write = Completer<http.Response>();
      fixture.heldWrite = write;
      final pending = controller.setMain('openrouter', 'google/gemini-flash');
      await pumpEventQueue();
      fixture.info = {
        ...fixture.info,
        'provider': 'openrouter',
        'model': 'google/gemini-flash',
      };
      fixture.endpoint = 'https://private.example/v1';
      write.complete(http.Response('{"ok":true}', 200));
      expect(await pending, isA<NgModelSaveFailed>());
      expect(controller.endpointOnlyHere, isTrue);
      expect(controller.canChangeMain, isFalse);
    });
  });

  group('helper tasks', () {
    test('a model is assigned and read back', () async {
      final (f, c) = await loaded();
      final result = await c.setAux('vision', 'anthropic', 'claude-haiku-4.5');
      expect(result, isA<NgModelSaved>());
      expect(f.modelWrites.single, {
        'scope': 'auxiliary',
        'task': 'vision',
        'provider': 'anthropic',
        'model': 'claude-haiku-4.5',
        'confirm_expensive_model': false,
        'profile': profile,
      });
      final vision = c.auxTasks!.firstWhere((t) => t.task == 'vision');
      expect(vision.model, 'claude-haiku-4.5');
      expect(f.at('/model/auxiliary'), hasLength(2));
    });

    test('a task returns to the default model', () async {
      final (f, c) = await loaded();
      expect(await c.setAux('compression', 'auto', ''), isA<NgModelSaved>());
      expect(f.modelWrites.single['provider'], 'auto');
      expect(f.modelWrites.single['model'], '');
      // The thinking level was not part of this change.
      expect(f.modelWrites.single.containsKey('reasoning_effort'), isFalse);
      final task = c.auxTasks!.firstWhere((t) => t.task == 'compression');
      expect(task.usesDefault, isTrue);
      expect(task.effort, 'low');
    });

    test(
      'a thinking level is set, and cleared with an explicit null',
      () async {
        final (f, c) = await loaded();
        expect(
          await c.setAuxEffort('compression', 'high'),
          isA<NgModelSaved>(),
        );
        expect(f.modelWrites.single['provider'], 'openrouter');
        expect(f.modelWrites.single['model'], 'google/gemini-flash');
        expect(f.modelWrites.single['reasoning_effort'], 'high');
        expect(
          c.auxTasks!.firstWhere((t) => t.task == 'compression').effort,
          'high',
        );

        expect(await c.setAuxEffort('compression', null), isA<NgModelSaved>());
        expect(f.modelWrites.last.containsKey('reasoning_effort'), isTrue);
        expect(f.modelWrites.last['reasoning_effort'], isNull);
        expect(
          c.auxTasks!.firstWhere((t) => t.task == 'compression').effort,
          isNull,
        );
      },
    );

    test('a thinking level the gateway did not keep is not a save', () async {
      final (f, c) = await loaded((f) => f.persist = false);
      expect(
        await c.setAuxEffort('compression', 'high'),
        isA<NgModelSaveFailed>(),
      );
      expect(f.modelWrites.single['reasoning_effort'], 'high');
      expect(
        c.auxTasks!.firstWhere((t) => t.task == 'compression').effort,
        'low',
      );
      expect(c.saving, isFalse);
    });

    test('no thinking level is sent to a gateway that reports none', () async {
      final (f, c) = await loaded();
      expect(
        await c.setAuxEffort('web_extract', 'high'),
        isA<NgModelSaveFailed>(),
      );
      expect(f.modelWrites, isEmpty);
    });

    test('a task on a custom endpoint is never reassigned', () async {
      final (f, c) = await loaded();
      for (final attempt in [
        () => c.setAux('custom_route', 'anthropic', 'claude-haiku-4.5'),
        () => c.setAux('custom_route', 'auto', ''),
        () => c.setAuxEffort('custom_route', 'high'),
        () => c.setAux('never_listed', 'anthropic', 'claude-haiku-4.5'),
        () => c.setAux('vision', 'custom', 'private-model'),
        () => c.setAux('vision', 'openrouter', 'openai/gpt-pro'),
      ]) {
        expect(await attempt(), isA<NgModelSaveFailed>());
      }
      expect(f.modelWrites, isEmpty);

      // A named endpoint is assigned by name, like any other provider.
      expect(
        await c.setAux('vision', 'homelab', 'local-llm'),
        isA<NgModelSaved>(),
      );
      expect(f.modelWrites.single, {
        'scope': 'auxiliary',
        'task': 'vision',
        'provider': 'homelab',
        'model': 'local-llm',
        'confirm_expensive_model': false,
        'profile': profile,
      });
    });

    test('a save the gateway did not keep is not a save', () async {
      final (f, c) = await loaded((f) => f.persist = false);
      expect(
        await c.setAux('vision', 'anthropic', 'claude-haiku-4.5'),
        isA<NgModelSaveFailed>(),
      );
      expect(f.modelWrites, hasLength(1));
      expect(
        c.auxTasks!.firstWhere((t) => t.task == 'vision').usesDefault,
        isTrue,
      );
    });

    test('an expensive model waits for the user to agree', () async {
      final (f, c) = await loaded((f) => f.confirmMessage = 'Costly.');
      expect(
        await c.setAux('vision', 'anthropic', 'claude-opus-4.5'),
        isA<NgModelNeedsConfirmation>(),
      );
      expect(
        c.auxTasks!.firstWhere((t) => t.task == 'vision').usesDefault,
        isTrue,
      );
      expect(
        await c.setAux(
          'vision',
          'anthropic',
          'claude-opus-4.5',
          confirmed: true,
        ),
        isA<NgModelSaved>(),
      );
      expect(f.modelWrites.last['confirm_expensive_model'], isTrue);
    });
  });

  group('fallback list', () {
    test('edits stay in the draft until saved', () async {
      final (f, c) = await loaded();
      expect(c.addFallback('anthropic', 'claude-haiku-4.5'), isTrue);
      expect(c.fallbackDirty, isTrue);
      // The same route twice, a plan-locked model and one that is not
      // listed are refused.
      expect(c.addFallback('anthropic', 'claude-haiku-4.5'), isFalse);
      expect(c.addFallback('openrouter', 'openai/gpt-pro'), isFalse);
      expect(c.addFallback('anthropic', 'made-up'), isFalse);
      expect(c.fallbackDraft.map((e) => e.model), [
        'google/gemini-flash',
        'claude-haiku-4.5',
      ]);

      c.moveFallback(1, -1);
      expect(c.fallbackDraft.first.model, 'claude-haiku-4.5');
      c.moveFallback(0, -1); // already first
      c.moveFallback(1, 1); // already last
      expect(c.fallbackDraft.first.model, 'claude-haiku-4.5');

      c.removeFallback(1);
      expect(c.fallbackDraft.single.model, 'claude-haiku-4.5');
      c.revertFallbacks();
      expect(c.fallbackDraft.single.model, 'google/gemini-flash');
      expect(c.fallbackDirty, isFalse);
      expect(f.configWrites, isEmpty);
    });

    test(
      'a row is given another model in place, named endpoints included',
      () async {
        final (f, c) = await loaded(
          (f) => f.config = {
            'fallback_providers': [
              {'provider': 'openrouter', 'model': 'google/gemini-flash'},
              {'provider': 'homelab', 'model': 'local-llm'},
              {
                'provider': 'lab',
                'model': 'private-model',
                'base_url': r'${LAB_URL}',
                'key_env': 'LAB_KEY',
              },
              {'provider': 'retired', 'model': 'old-model'},
            ],
          },
        );
        // A named endpoint is an ordinary row; routing details and a provider
        // the gateway no longer lists keep the model they have.
        expect(c.fallbackLocked(c.fallbackDraft[1]), isFalse);
        expect(c.fallbackLocked(c.fallbackDraft[2]), isTrue);
        expect(c.fallbackLocked(c.fallbackDraft[3]), isTrue);

        expect(c.replaceFallback(0, 'anthropic', 'claude-haiku-4.5'), isTrue);
        expect(c.fallbackDirty, isTrue);
        // Refused: a row already in the list, the same model again, a model
        // that cannot be assigned, a row that must keep its model, no row.
        expect(c.replaceFallback(0, 'homelab', 'local-llm'), isFalse);
        expect(c.replaceFallback(0, 'anthropic', 'claude-haiku-4.5'), isFalse);
        expect(c.replaceFallback(0, 'openrouter', 'openai/gpt-pro'), isFalse);
        expect(c.replaceFallback(2, 'anthropic', 'claude-opus-4.5'), isFalse);
        expect(c.replaceFallback(3, 'anthropic', 'claude-opus-4.5'), isFalse);
        expect(c.replaceFallback(9, 'anthropic', 'claude-opus-4.5'), isFalse);
        expect(
          c.replaceFallback(1, 'openrouter', 'google/gemini-flash'),
          isTrue,
        );
        expect(f.configWrites, isEmpty);

        expect(await c.saveFallbacks(), isA<NgModelSaved>());
        final sent = f.configWrites.single['config'] as Map<String, dynamic>;
        expect(sent['fallback_providers'], [
          {'provider': 'anthropic', 'model': 'claude-haiku-4.5'},
          {'provider': 'openrouter', 'model': 'google/gemini-flash'},
          {
            'provider': 'lab',
            'model': 'private-model',
            'base_url': r'${LAB_URL}',
            'key_env': 'LAB_KEY',
          },
          {'provider': 'retired', 'model': 'old-model'},
        ]);
        expect(c.fallbackDirty, isFalse);

        // Not while a save is being read back, nor while the list cannot be
        // read.
        final held = Completer<http.Response>();
        f.heldWrite = held;
        final saving = c.saveFallbacks();
        await pumpEventQueue();
        expect(c.saving, isTrue);
        expect(c.replaceFallback(1, 'anthropic', 'claude-opus-4.5'), isFalse);
        f.heldWrite = null;
        held.complete(http.Response('{"ok":true}', 200));
        await saving;
        f.schemaStatus = 404;
        await c.load();
        expect(c.fallbackFailed, isTrue);
        expect(c.replaceFallback(1, 'anthropic', 'claude-opus-4.5'), isFalse);
        f.schemaStatus = 200;
        await c.load();

        // A named endpoint is added by name as well.
        expect(c.addFallback('homelab', 'local-llm'), isTrue);
        expect(c.fallbackDraft.last.toJson(), {
          'provider': 'homelab',
          'model': 'local-llm',
        });
      },
    );

    test('saving sends only the list, in order, and reads it back', () async {
      final (f, c) = await loaded();
      c.addFallback('anthropic', 'claude-haiku-4.5');
      c.moveFallback(1, -1);
      expect(await c.saveFallbacks(), isA<NgModelSaved>());
      expect(f.configWrites.single, {
        'config': {
          'fallback_providers': [
            {'provider': 'anthropic', 'model': 'claude-haiku-4.5'},
            {'provider': 'openrouter', 'model': 'google/gemini-flash'},
          ],
        },
        'profile': profile,
      });
      expect(c.fallbackDirty, isFalse);
      expect(c.fallbackDraft.map((e) => e.model), [
        'claude-haiku-4.5',
        'google/gemini-flash',
      ]);
    });

    test('routing details on a row survive reordering and saving', () async {
      final (f, c) = await loaded(
        (f) => f.config = {
          'fallback_providers': [
            {
              'provider': 'lab',
              'model': 'private-model',
              'base_url': r'${LAB_URL}',
              'key_env': 'LAB_KEY',
            },
            {'provider': 'openrouter', 'model': 'google/gemini-flash'},
          ],
          'fallback_model': {'provider': 'legacy', 'model': 'old'},
        },
      );
      expect(c.fallbackLocked(c.fallbackDraft[0]), isTrue);
      expect(c.fallbackLocked(c.fallbackDraft[1]), isFalse);
      expect(c.fallback!.legacyEntries.single.model, 'old');

      c.moveFallback(0, 1);
      expect(await c.saveFallbacks(), isA<NgModelSaved>());
      final sent = f.configWrites.single['config'] as Map<String, dynamic>;
      expect(sent.keys, ['fallback_providers']);
      expect(sent['fallback_providers'], [
        {'provider': 'openrouter', 'model': 'google/gemini-flash'},
        {
          'provider': 'lab',
          'model': 'private-model',
          'base_url': r'${LAB_URL}',
          'key_env': 'LAB_KEY',
        },
      ]);
      // The legacy entry was neither sent nor changed.
      expect(f.config['fallback_model'], {
        'provider': 'legacy',
        'model': 'old',
      });
    });

    test('removing every row saves an explicit empty list', () async {
      final (f, c) = await loaded();
      c.removeFallback(0);
      expect(await c.saveFallbacks(), isA<NgModelSaved>());
      expect(
        (f.configWrites.single['config'] as Map)['fallback_providers'],
        isEmpty,
      );
      expect(c.fallbackDraft, isEmpty);
    });

    test('a refused or ignored save keeps the draft', () async {
      for (final arrange in <void Function(ModelsFixture)>[
        (f) => f.accept = false,
        (f) => f.persist = false,
      ]) {
        final (f, c) = await loaded(arrange);
        c.addFallback('anthropic', 'claude-haiku-4.5');
        expect(await c.saveFallbacks(), isA<NgModelSaveFailed>());
        expect(f.configWrites, hasLength(1));
        expect(c.fallbackDraft, hasLength(2));
        expect(c.fallbackDirty, isTrue);
        expect(c.saving, isFalse);
      }
    });

    test('a gateway without raw config is never read or written', () async {
      final (f, c) = await loaded((f) => f.schemaStatus = 404);
      expect(c.fallbackFailed, isTrue);
      expect(c.fallback, isNull);
      expect(c.canEditFallbacks, isFalse);
      expect(c.addFallback('anthropic', 'claude-haiku-4.5'), isFalse);
      expect(await c.saveFallbacks(), isA<NgModelSaveFailed>());
      expect(f.at('/api/config'), isEmpty);
      // The other sections do not depend on it.
      expect(c.canChangeMain, isTrue);
      expect(c.canEditAux, isTrue);
    });

    test('unsaved edits survive a refresh', () async {
      final (f, c) = await loaded();
      c.addFallback('anthropic', 'claude-haiku-4.5');
      f.config = {
        'fallback_providers': [
          {'provider': 'openrouter', 'model': 'meta/llama-free'},
        ],
      };
      await c.load();
      expect(c.fallbackDraft.map((e) => e.model), [
        'google/gemini-flash',
        'claude-haiku-4.5',
      ]);
      expect(c.fallbackDirty, isTrue);
      // Discard now goes back to what the gateway holds.
      c.revertFallbacks();
      expect(c.fallbackDraft.single.model, 'meta/llama-free');
    });

    test('unsaved edits survive a refresh that fails', () async {
      final (f, c) = await loaded();
      c.addFallback('anthropic', 'claude-haiku-4.5');
      f.schemaStatus = 404;
      await c.load();
      expect(c.fallbackFailed, isTrue);
      // Kept, but not editable or saveable until the list can be read again.
      expect(c.fallbackDraft, hasLength(2));
      expect(c.canEditFallbacks, isFalse);
      c.removeFallback(0);
      expect(c.addFallback('openrouter', 'meta/llama-free'), isFalse);
      expect(c.fallbackDraft, hasLength(2));
      expect(await c.saveFallbacks(), isA<NgModelSaveFailed>());
      expect(f.configWrites, isEmpty);

      f.schemaStatus = 200;
      await c.load();
      expect(c.fallbackFailed, isFalse);
      expect(c.fallbackDraft.map((e) => e.model), [
        'google/gemini-flash',
        'claude-haiku-4.5',
      ]);
      expect(c.fallbackDirty, isTrue);
      expect(c.canEditFallbacks, isTrue);
    });
  });

  group('sections fail on their own', () {
    test(
      'no provider list: nothing can be chosen, the rest is shown',
      () async {
        final (f, c) = await loaded((f) => f.failOptions = true);
        expect(c.catalog, isNull);
        expect(c.catalogFailed, isTrue);
        expect(c.main!.model, 'claude-opus-4.5');
        expect(c.canChangeMain, isFalse);
        expect(c.auxTasks, hasLength(5));
        expect(c.fallbackDraft, hasLength(1));
        expect(
          await c.setAux('vision', 'anthropic', 'claude-haiku-4.5'),
          isA<NgModelSaveFailed>(),
        );
        expect(c.addFallback('anthropic', 'claude-haiku-4.5'), isFalse);
        expect(f.modelWrites, isEmpty);
        // Reordering and removing existing fallbacks need no provider list.
        c.removeFallback(0);
        expect(await c.saveFallbacks(), isA<NgModelSaved>());
      },
    );

    test('no default or no helper tasks', () async {
      final (_, c) = await loaded(
        (f) => f
          ..failInfo = true
          ..failAux = true,
      );
      expect(c.mainFailed, isTrue);
      expect(c.canChangeMain, isFalse);
      expect(c.auxFailed, isTrue);
      expect(c.canEditAux, isFalse);
      expect(c.catalog, isNotNull);
      expect(c.canEditFallbacks, isTrue);
    });
  });

  group('one change at a time', () {
    test('nothing else starts while a save is being read back', () async {
      final fixture = ModelsFixture();
      final c = NgModelSettingsController(fixture.client);
      addTearDown(c.dispose);
      await c.load();
      final write = Completer<http.Response>();
      fixture.heldWrite = write;
      final pending = c.setMain('openrouter', 'google/gemini-flash');
      await pumpEventQueue();
      expect(c.saving, isTrue);
      expect(c.canChangeMain, isFalse);
      expect(c.canEditAux, isFalse);
      expect(c.canEditFallbacks, isFalse);

      final reads = fixture.requests.length;
      await c.load();
      expect(
        await c.setAux('vision', 'anthropic', 'claude-haiku-4.5'),
        isA<NgModelSaveFailed>(),
      );
      expect(c.addFallback('anthropic', 'claude-haiku-4.5'), isFalse);
      expect(await c.saveFallbacks(), isA<NgModelSaveFailed>());
      expect(fixture.requests, hasLength(reads));
      expect(fixture.modelWrites, hasLength(1));

      fixture.heldWrite = null;
      fixture.info = {
        ...fixture.info,
        'provider': 'openrouter',
        'model': 'google/gemini-flash',
      };
      write.complete(http.Response(jsonEncode({'ok': true}), 200));
      expect(await pending, isA<NgModelSaved>());
      expect(c.saving, isFalse);
      expect(c.canEditAux, isTrue);
    });

    test('an answer after the page closed changes nothing', () async {
      final fixture = ModelsFixture();
      final c = NgModelSettingsController(fixture.client);
      await c.load();
      var notified = 0;
      c.addListener(() => notified++);
      final write = Completer<http.Response>();
      fixture.heldWrite = write;
      final pending = c.setMain('openrouter', 'google/gemini-flash');
      await pumpEventQueue();
      final before = notified;
      c.dispose();
      write.complete(http.Response(jsonEncode({'ok': true}), 200));
      expect(await pending, isA<NgModelSaveFailed>());
      expect(notified, before);
      expect(c.main!.model, 'claude-opus-4.5');
      // No read-back was attempted for a page that is gone.
      expect(fixture.at('/model/info'), hasLength(1));
    });

    test('a page that has closed sends nothing', () async {
      final fixture = ModelsFixture();
      addTearDown(fixture.client.close);
      final c = NgModelSettingsController(fixture.client);
      await c.load();
      c.addFallback('anthropic', 'claude-haiku-4.5');
      final requests = fixture.requests.length;
      c.dispose();
      expect(c.canChangeMain, isFalse);
      expect(c.canEditAux, isFalse);
      expect(c.canEditFallbacks, isFalse);
      for (final attempt in [
        () => c.setMain('openrouter', 'google/gemini-flash'),
        () => c.setAux('vision', 'anthropic', 'claude-haiku-4.5'),
        () => c.setAuxEffort('compression', 'high'),
        () => c.saveFallbacks(),
      ]) {
        expect(await attempt(), isA<NgModelSaveFailed>());
      }
      expect(fixture.requests, hasLength(requests));
    });

    test('a slow first read cannot overwrite a newer one', () async {
      final fixture = ModelsFixture();
      final c = NgModelSettingsController(fixture.client);
      addTearDown(c.dispose);
      final slow = Completer<http.Response>();
      fixture.heldInfo = slow;
      final first = c.load();
      await pumpEventQueue();
      fixture.heldInfo = null;
      fixture.info = {...fixture.info, 'model': 'claude-haiku-4.5'};
      await c.load();
      expect(c.main!.model, 'claude-haiku-4.5');
      slow.complete(
        http.Response(
          jsonEncode({'provider': 'anthropic', 'model': 'stale-model'}),
          200,
        ),
      );
      await first;
      expect(c.main!.model, 'claude-haiku-4.5');
      expect(c.mainLoading, isFalse);
    });
  });
}
