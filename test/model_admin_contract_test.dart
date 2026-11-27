import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/model_admin_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/model_admin.dart';
import 'package:hermes_android/core/services/remote_model_admin.dart';
import 'package:hermes_android/core/widgets/chat_context_header.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _profile = 'research';

DashboardClient _client(MockClient httpClient) => DashboardClient(
  host: '127.0.0.1',
  port: 9,
  proxied: true,
  gatewayProfile: _profile,
  httpClient: httpClient,
);

void main() {
  test('route clamp is shown only when the wire effort differs', () {
    expect(reasoningEffortClamp('ultra', ''), isNull);
    expect(reasoningEffortClamp('ultra', 'ultra'), isNull);
    expect(reasoningEffortClamp('ultra', 'max')?.wire, 'max');
    expect(reasoningEffortClamp('nope', 'max'), isNull);
    expect(creditsPurchasable({'ok': true, 'logged_in': true}), isFalse);
    expect(
      creditsPurchasable({
        'ok': true,
        'logged_in': true,
        'can_charge': true,
        'cli_billing_enabled': true,
        'card': {'last4': '4242'},
        'charge_presets': ['5'],
      }),
      isTrue,
    );
    expect(planChangeCanCommit('scheduled'), isTrue);
    expect(planChangeCanCommit('charge_now'), isFalse);
    expect(
      safeBillingMessage('https://pay.example'),
      'The gateway refused this billing request.',
    );
  });

  test('mixture edits keep the other preset fields and reject a blank slot', () {
    final saved = editActiveMixture(
      {
        'active_preset': 'default',
        'presets': {
          'default': {
            'enabled': false,
            'fanout': 'user_turn',
            'reference_temperature': 0.2,
            'aggregator': {'provider': 'old', 'model': 'old-model', 'extra': 1},
            'reference_models': [
              {'provider': 'a', 'model': 'one', 'reasoning_effort': 'low'},
            ],
          },
        },
      },
      enabled: true,
      policy: 'silent',
      aggregator: {'provider': 'nous', 'model': 'agg', 'extra': 1},
      references: [
        {'provider': 'a', 'model': 'one', 'reasoning_effort': 'low'},
        {'provider': 'b', 'model': 'two'},
      ],
    );
    final preset = (saved['presets'] as Map)['default'] as Map;
    expect(preset['fanout'], 'user_turn');
    expect(preset['reference_temperature'], 0.2);
    expect((preset['aggregator'] as Map)['extra'], 1);
    expect(preset['reference_models'], hasLength(2));
    expect(
      () => editActiveMixture(
        saved,
        enabled: true,
        policy: 'loud',
        aggregator: {'provider': '', 'model': 'agg'},
        references: [
          {'provider': 'a', 'model': 'one'},
        ],
      ),
      throwsA(
        isA<ModelAdminException>()
            .having(
              (e) => e.reason,
              'reason',
              ModelAdminFailure.mixtureSlotsRequired,
            )
            .having(
              (e) => e.message,
              'English rendering',
              'Name a provider and model for the aggregator and every reference.',
            ),
      ),
    );
  });

  test(
    'remote HTTP writes stay on the profile and do not send a plaintext remote URL',
    () async {
      final requests = <http.Request>[];
      final client = _client(
        MockClient((request) async {
          requests.add(request);
          final path = request.url.path;
          if (path.endsWith('/env') && request.method == 'GET') {
            return http.Response(
              jsonEncode({
                'OPENAI_API_KEY': {
                  'category': 'provider',
                  'provider_label': 'OpenAI',
                  'provider_primary': true,
                  'is_password': true,
                  'is_set': false,
                  'description': 'fixture',
                },
                'UNRELATED_TOKEN': {'category': 'tool', 'is_set': true},
              }),
              200,
            );
          }
          if (path.endsWith('/env')) return http.Response('{"ok":true}', 200);
          if (path.endsWith('/custom-endpoints/validate')) {
            return http.Response(
              jsonEncode({
                'ok': true,
                'reachable': true,
                'message': 'fixture answered',
                'transport_checked': 'anthropic_messages',
                'models': ['fixture-model'],
              }),
              200,
            );
          }
          if (path.endsWith('/delegation/routing')) {
            return http.Response(
              jsonEncode({
                'configured': 'model_map',
                'blocked_reason': null,
                'backends': [
                  {
                    'name': 'model_map',
                    'available': true,
                    'label': 'Model map',
                  },
                ],
                'model_map': {
                  'default': 'day',
                  'options': [
                    {
                      'name': 'day',
                      'model': 'kept',
                      'provider': 'openai',
                      'base_url': 'https://kept.example/v1',
                    },
                  ],
                },
                'profile_routes': {'profiles': [], 'default': null},
                'profiles': ['research'],
              }),
              200,
            );
          }
          if (path.endsWith('/model_map')) {
            return http.Response('{"ok":true}', 200);
          }
          if (path.endsWith('/config') && request.method == 'GET') {
            return http.Response(
              jsonEncode({
                'config': {
                  'delegation': {'max_iterations': 4},
                  'secret': 'do-not-keep',
                },
              }),
              200,
            );
          }
          if (path.endsWith('/config')) {
            return http.Response('{"ok":true}', 200);
          }
          if (path.endsWith('/providers/oauth/openai-codex')) {
            return http.Response('{"ok":true,"provider":"openai-codex"}', 200);
          }
          return http.Response('{}', 404);
        }),
      );
      final admin = RemoteModelAdmin(client);
      addTearDown(client.close);

      expect((await admin.keys()).single.envKey, 'OPENAI_API_KEY');
      await admin.saveKey('OPENAI_API_KEY', 'fixture-key-not-real');
      await admin.clearKey('OPENAI_API_KEY');
      expect(
        () => admin.testEndpoint(
          const EndpointDraft(
            name: 'Lab',
            baseUrl: 'http://models.example.test/v1',
            model: 'fixture-model',
            apiMode: 'chat_completions',
          ),
        ),
        throwsA(
          isA<ModelAdminException>()
              .having(
                (e) => e.reason,
                'reason',
                ModelAdminFailure.endpointHttps,
              )
              .having(
                (e) => e.message,
                'English rendering',
                'Use HTTPS for a remote endpoint, or HTTP on localhost.',
              ),
        ),
      );
      final tested = await admin.testEndpoint(
        const EndpointDraft(
          name: 'Lab',
          baseUrl: 'https://models.example.test/v1',
          model: 'fixture-model',
          apiMode: 'anthropic_messages',
        ),
      );
      expect(tested.transport, 'anthropic_messages');
      await admin.saveModelRoutes(
        routes: [
          {
            'name': 'day',
            'model': 'kept',
            'provider': 'openai',
            'base_url': 'https://kept.example/v1',
          },
        ],
        defaultRoute: 'day',
      );
      final limits = await admin.limits();
      expect(limits.maxIterations, 4);
      await admin.saveLimits(
        const DelegationLimits(
          maxIterations: 4,
          maxConcurrentChildren: 2,
          childTimeoutSeconds: 30,
        ),
      );
      await admin.disconnectAccount('openai-codex');

      Map<String, dynamic> bodyOf(String suffix, String method) =>
          jsonDecode(
                requests
                    .firstWhere(
                      (request) =>
                          request.url.path.endsWith(suffix) &&
                          request.method == method,
                    )
                    .body,
              )
              as Map<String, dynamic>;

      final save = bodyOf('/env', 'PUT');
      expect(save['key'], 'OPENAI_API_KEY');
      expect(save['provider_setup'], isTrue);
      expect(save.containsKey('value'), isTrue);
      expect(bodyOf('/env', 'DELETE')['key'], 'OPENAI_API_KEY');
      expect(bodyOf('/validate', 'POST')['api_mode'], 'anthropic_messages');
      expect(
        requests.where(
          (request) => request.url.path.contains('models.example.test'),
        ),
        isEmpty,
      );
      final route = bodyOf('/model_map', 'PUT');
      expect(
        (route['options'] as List).single['base_url'],
        'https://kept.example/v1',
      );
      final config = bodyOf('/config', 'PUT');
      expect(config['profile'], _profile);
      expect(config['config'].keys, ['delegation']);
      expect(
        requests
            .firstWhere((request) => request.url.path.endsWith('/openai-codex'))
            .method,
        'DELETE',
      );
      expect(
        requests.every(
          (request) =>
              request.url.queryParameters['profile'] == _profile ||
              request.url.path.endsWith('/config') && request.method == 'PUT' ||
              request.url.path.endsWith('/openai-codex'),
        ),
        isTrue,
      );
    },
  );

  testWidgets('testing an endpoint sends the selected API mode', (
    tester,
  ) async {
    final requests = <http.Request>[];
    final client = _client(
      MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/validate')) {
          return http.Response(
            jsonEncode({
              'ok': true,
              'reachable': true,
              'message': 'fixture answered',
              'transport_checked': 'anthropic_messages',
              'models': ['fixture-model'],
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'current': {
              'provider': 'custom',
              'model': 'fixture-model',
              'base_url': 'https://models.example.test/v1',
            },
            'endpoints': [],
          }),
          200,
        );
      }),
    );
    addTearDown(client.close);
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: ModelAdminScreen(
          connection: SavedConnection(
            id: 'fixture',
            label: 'Fixture',
            host: '127.0.0.1',
            port: 9,
            apiKey: 'synthetic',
          ),
          dashboard: client,
          presets: MemoryModelPresetStore(),
          initialSection: ModelAdminSection.endpoints,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('endpoint-name')), 'Lab');
    await tester.enterText(
      find.byKey(const Key('endpoint-url')),
      'https://models.example.test/v1',
    );
    await tester.enterText(
      find.byKey(const Key('endpoint-model')),
      'fixture-model',
    );
    await tester.tap(find.byKey(const Key('endpoint-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Anthropic Messages').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('endpoint-test')));
    await tester.pumpAndSettle();
    final validate = requests.singleWhere(
      (request) => request.url.path.endsWith('/validate'),
    );
    expect(jsonDecode(validate.body)['api_mode'], 'anthropic_messages');
    expect(find.byKey(const Key('endpoint-test-result')), findsOneWidget);
    expect(find.textContaining('anthropic_messages'), findsOneWidget);
  });

  testWidgets('credits are charged only after confirmation', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final calls = <String>[];
    Future<Map<String, dynamic>> rpc(
      String method,
      Map<String, dynamic> params,
    ) async {
      calls.add(method);
      if (method == 'billing.charge') {
        expect(params['amount_usd'], '5');
        expect(params['idempotency_key'], matches(RegExp(r'^[0-9a-f-]{36}$')));
        return {
          'jsonrpc': '2.0',
          'id': 1,
          'result': {'ok': true},
        };
      }
      if (method == 'subscription.state') {
        return {
          'jsonrpc': '2.0',
          'id': 1,
          'result': {
            'ok': true,
            'logged_in': true,
            'can_change_plan': true,
            'tiers': [
              {
                'tier_id': 'later',
                'name': 'Later',
                'is_current': false,
                'is_enabled': true,
              },
            ],
          },
        };
      }
      return {
        'jsonrpc': '2.0',
        'id': 1,
        'result': {
          'ok': true,
          'logged_in': true,
          'can_charge': true,
          'cli_billing_enabled': true,
          'balance_display': 'USD 0',
          'card': {'last4': '4242'},
          'charge_presets': ['5'],
          'auto_reload': {
            'enabled': false,
            'threshold_usd': '2',
            'reload_to_usd': '10',
          },
          'keep_going_on_credits': false,
        },
      };
    }

    Future<void> pump(
      Future<Map<String, dynamic>> Function(String, Map<String, dynamic>)?
      gateway,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ModelAdminScreen(
            key: ValueKey(gateway == null),
            connection: SavedConnection(
              id: 'fixture',
              label: 'Fixture',
              host: '127.0.0.1',
              port: 9,
              apiKey: 'synthetic',
            ),
            dashboard: _client(
              MockClient((request) async => http.Response('{}', 200)),
            ),
            presets: MemoryModelPresetStore(),
            initialSection: ModelAdminSection.billing,
            rpc: gateway,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pump(null);
    expect(find.byKey(const Key('billing-buy')), findsNothing);
    expect(find.byKey(const Key('admin-error')), findsOneWidget);

    calls.clear();
    await pump(rpc);
    expect(
      find.text('Credit purchases are not available for this account.'),
      findsNothing,
    );
    await tester.tap(find.byKey(const Key('billing-buy')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(calls, ['billing.state', 'subscription.state']);

    await tester.tap(find.byKey(const Key('billing-buy')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('admin-confirm-yes')));
    await tester.pumpAndSettle();
    expect(calls.where((method) => method == 'billing.charge'), [
      'billing.charge',
    ]);

    await tester.tap(find.byKey(const Key('plan-later')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('plan-confirm')), findsNothing);
  });

  testWidgets('a scheduled plan can be confirmed and an immediate one cannot', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    String effect = 'charge_now';
    final calls = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: ModelAdminScreen(
          connection: SavedConnection(
            id: 'fixture',
            label: 'Fixture',
            host: '127.0.0.1',
            port: 9,
            apiKey: 'synthetic',
          ),
          dashboard: _client(
            MockClient((request) async => http.Response('{}', 200)),
          ),
          presets: MemoryModelPresetStore(),
          initialSection: ModelAdminSection.billing,
          rpc: (method, params) async {
            calls.add(method);
            if (method == 'subscription.preview') {
              return {
                'jsonrpc': '2.0',
                'id': 1,
                'result': {'ok': true, 'effect': effect},
              };
            }
            if (method == 'subscription.change') {
              return {
                'jsonrpc': '2.0',
                'id': 1,
                'result': {'ok': true},
              };
            }
            if (method == 'subscription.state') {
              return {
                'jsonrpc': '2.0',
                'id': 1,
                'result': {
                  'ok': true,
                  'can_change_plan': true,
                  'tiers': [
                    {
                      'tier_id': 'later',
                      'name': 'Later',
                      'is_current': false,
                      'is_enabled': true,
                    },
                  ],
                },
              };
            }
            return {
              'jsonrpc': '2.0',
              'id': 1,
              'result': {
                'ok': true,
                'logged_in': false,
                'can_charge': false,
                'cli_billing_enabled': false,
              },
            };
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('billing-unavailable')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('plan-later')));
    await tester.tap(find.byKey(const Key('plan-later')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('plan-confirm')), findsNothing);
    expect(calls, isNot(contains('subscription.change')));

    effect = 'scheduled';
    await tester.tap(find.byKey(const Key('plan-later')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('plan-confirm')), findsOneWidget);
    await tester.tap(find.byKey(const Key('plan-confirm')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('admin-confirm-yes')));
    await tester.pumpAndSettle();
    expect(calls.where((method) => method == 'subscription.change'), [
      'subscription.change',
    ]);
  });

  testWidgets('Classic shows a stamped route clamp and hides an unknown wire', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ChatContextHeader(
            model: 'fixture',
            reasoningEffort: 'ultra',
            reasoningEffortWire: 'max',
            connectionLabel: 'Fixture',
            connectionStatus: ChatConnectionStatus.connected,
          ),
        ),
      ),
    );
    expect(find.textContaining('→'), findsOneWidget);
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ChatContextHeader(
            model: 'fixture',
            reasoningEffort: 'ultra',
            reasoningEffortWire: '',
            connectionLabel: 'Fixture',
            connectionStatus: ChatConnectionStatus.connected,
          ),
        ),
      ),
    );
    expect(find.textContaining('→'), findsNothing);
  });
}
