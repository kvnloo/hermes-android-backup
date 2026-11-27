import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/model_admin_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/model_admin.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

DashboardClient _client() => DashboardClient(
  host: '127.0.0.1',
  port: 9,
  proxied: true,
  gatewayProfile: 'research',
  httpClient: MockClient((request) async => http.Response('{}', 200)),
);

SavedConnection _conn() => SavedConnection(
  id: 'fixture',
  label: 'Fixture',
  host: '127.0.0.1',
  port: 9,
  apiKey: 'synthetic',
);

Map<String, dynamic> _env(Map<String, dynamic> result) => {
  'jsonrpc': '2.0',
  'id': 1,
  'result': result,
};

void _wide(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _pump(
  WidgetTester tester, {
  required Future<Map<String, dynamic>> Function(String, Map<String, dynamic>)
  rpc,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: ModelAdminScreen(
        connection: _conn(),
        dashboard: _client(),
        presets: MemoryModelPresetStore(),
        initialSection: ModelAdminSection.billing,
        rpc: rpc,
      ),
    ),
  );
}

void main() {
  testWidgets(
    'off auto-reload stays read-only when the account cannot charge',
    (tester) async {
      _wide(tester);
      final sent = <String, Map<String, dynamic>>{};
      await _pump(
        tester,
        rpc: (method, params) async {
          sent[method] = params;
          if (method == 'subscription.state') {
            return _env({'ok': true, 'logged_in': true});
          }
          if (method == 'billing.auto_reload') return _env({'ok': true});
          return _env({
            'ok': true,
            'logged_in': true,
            'can_charge': false,
            'cli_billing_enabled': false,
            'charge_presets': <String>[],
            'auto_reload': {
              'enabled': false,
              'threshold_usd': '2',
              'threshold_display': r'$2.00',
              'reload_to_usd': '100',
              'reload_to_display': r'$100.00',
            },
          });
        },
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('billing-unavailable')), findsOneWidget);
      final tile = tester.widget<SwitchListTile>(
        find.byKey(const Key('billing-auto-reload')),
      );
      expect(tile.onChanged, isNull);
      expect(find.byKey(const Key('billing-portal')), findsOneWidget);
      expect(
        find.textContaining('https://portal.nousresearch.com/billing'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('billing-auto-reload')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('admin-confirm')), findsNothing);
      expect(sent.containsKey('billing.auto_reload'), isFalse);
    },
  );

  testWidgets(
    'auto-reload confirmation names the threshold, reload amount and currency',
    (tester) async {
      _wide(tester);
      final sent = <String, Map<String, dynamic>>{};
      await _pump(
        tester,
        rpc: (method, params) async {
          sent[method] = params;
          if (method == 'subscription.state') {
            return _env({'ok': true, 'logged_in': true});
          }
          return _env({
            'ok': true,
            'logged_in': true,
            'can_charge': true,
            'cli_billing_enabled': true,
            'card': {'last4': '4242'},
            'charge_presets': ['25'],
            'auto_reload': {
              'enabled': false,
              'threshold_usd': '2',
              'threshold_display': r'$2.00',
              'reload_to_usd': '100',
              'reload_to_display': r'$100.00',
            },
          });
        },
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('billing-auto-reload')));
      await tester.tap(find.byKey(const Key('billing-auto-reload')));
      await tester.pumpAndSettle();
      final dialog = find.byKey(const Key('admin-confirm'));
      expect(dialog, findsOneWidget);
      expect(
        find.descendant(
          of: dialog,
          matching: find.text(
            'Turn on auto-reload and charge \$100.00 USD when the balance '
            'falls below \$2.00 USD?',
          ),
        ),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('admin-confirm-yes')));
      await tester.pumpAndSettle();
      expect(sent['billing.auto_reload'], {
        'enabled': true,
        'threshold': '2',
        'top_up_amount': '100',
      });
    },
  );

  testWidgets(
    'a failed plan preview clears the previous tier and disables confirm',
    (tester) async {
      _wide(tester);
      final changes = <Map<String, dynamic>>[];
      await _pump(
        tester,
        rpc: (method, params) async {
          if (method == 'subscription.state') {
            return _env({
              'ok': true,
              'logged_in': true,
              'can_change_plan': true,
              'tiers': [
                {
                  'tier_id': 'basic',
                  'name': 'Basic',
                  'is_current': false,
                  'is_enabled': true,
                },
                {
                  'tier_id': 'pro',
                  'name': 'Pro',
                  'is_current': false,
                  'is_enabled': true,
                },
              ],
            });
          }
          if (method == 'subscription.preview') {
            if (params['subscription_type_id'] == 'pro') {
              throw Exception('Timeout');
            }
            return _env({'ok': true, 'effect': 'scheduled'});
          }
          if (method == 'subscription.change') {
            changes.add(params);
            return _env({'ok': true});
          }
          return _env({'ok': true, 'logged_in': true});
        },
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('plan-basic')));
      await tester.tap(find.byKey(const Key('plan-basic')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('plan-confirm')), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key('plan-pro')));
      await tester.tap(find.byKey(const Key('plan-pro')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('admin-error')), findsOneWidget);
      expect(find.byKey(const Key('plan-confirm')), findsNothing);
      expect(changes, isEmpty);
    },
  );

  testWidgets(
    'plan confirm names the last successfully previewed plan, price and schedule',
    (tester) async {
      _wide(tester);
      final changes = <Map<String, dynamic>>[];
      await _pump(
        tester,
        rpc: (method, params) async {
          if (method == 'subscription.state') {
            return _env({
              'ok': true,
              'logged_in': true,
              'can_change_plan': true,
              'tiers': [
                {
                  'tier_id': 'basic',
                  'name': 'Basic',
                  'is_current': false,
                  'is_enabled': true,
                  'dollars_per_month_display': r'$20',
                },
              ],
            });
          }
          if (method == 'subscription.preview') {
            return _env({
              'ok': true,
              'effect': 'scheduled',
              'target_tier_name': 'Basic',
              'effective_at': '2026-08-15T00:00:00Z',
            });
          }
          if (method == 'subscription.change') {
            changes.add(params);
            return _env({'ok': true});
          }
          return _env({'ok': true, 'logged_in': true});
        },
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('plan-basic')));
      await tester.tap(find.byKey(const Key('plan-basic')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('plan-confirm')));
      await tester.pumpAndSettle();
      final dialog = find.byKey(const Key('admin-confirm'));
      expect(
        find.descendant(of: dialog, matching: find.textContaining('Basic')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialog, matching: find.textContaining(r'$20')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: dialog,
          matching: find.textContaining('2026-08-15T00:00:00Z'),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
    },
  );

  testWidgets('team subscriptions are not changed in the app', (tester) async {
    _wide(tester);
    await _pump(
      tester,
      rpc: (method, params) async {
        if (method == 'subscription.state') {
          return _env({
            'ok': true,
            'logged_in': true,
            'can_change_plan': true,
            'context': 'team',
            'tiers': [
              {
                'tier_id': 'basic',
                'name': 'Basic',
                'is_current': false,
                'is_enabled': true,
              },
            ],
          });
        }
        return _env({'ok': true, 'logged_in': true});
      },
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('plan-basic')), findsNothing);
    expect(find.byKey(const Key('plan-confirm')), findsNothing);
    expect(find.byKey(const Key('plan-portal')), findsOneWidget);
    expect(
      find.textContaining('https://portal.nousresearch.com/billing'),
      findsOneWidget,
    );
  });

  test('credential query parameters are rejected with userinfo', () {
    for (final param in ['api_key', 'token', 'key', 'secret', 'password']) {
      expect(
        () => validateEndpointDraft(
          EndpointDraft(
            name: 'Lab',
            baseUrl: 'https://models.example.test/v1?$param=not-a-real-secret',
            model: 'm',
            apiMode: '',
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
        reason: param,
      );
    }
    expect(
      () => validateEndpointDraft(
        const EndpointDraft(
          name: 'Lab',
          baseUrl: 'https://models.example.test/v1?API_KEY=not-a-real-secret',
          model: 'm',
          apiMode: '',
        ),
      ),
      throwsA(
        isA<ModelAdminException>()
            .having((e) => e.reason, 'reason', ModelAdminFailure.endpointHttps)
            .having(
              (e) => e.message,
              'English rendering',
              'Use HTTPS for a remote endpoint, or HTTP on localhost.',
            ),
      ),
    );
    expect(
      () => validateEndpointDraft(
        const EndpointDraft(
          name: 'Lab',
          baseUrl: 'https://user:pw@models.example.test/v1',
          model: 'm',
          apiMode: '',
        ),
      ),
      throwsA(
        isA<ModelAdminException>()
            .having((e) => e.reason, 'reason', ModelAdminFailure.endpointHttps)
            .having(
              (e) => e.message,
              'English rendering',
              'Use HTTPS for a remote endpoint, or HTTP on localhost.',
            ),
      ),
    );
    expect(
      () => validateEndpointDraft(
        const EndpointDraft(
          name: 'Lab',
          baseUrl: 'https://models.example.test/v1?model=fixture&keyboard=1',
          model: 'm',
          apiMode: '',
        ),
      ),
      returnsNormally,
    );
  });

  testWidgets(
    'a charge timeout stays unknown and a retry reuses the idempotency key',
    (tester) async {
      _wide(tester);
      final keys = <Object?>[];
      await _pump(
        tester,
        rpc: (method, params) async {
          if (method == 'billing.charge') {
            keys.add(params['idempotency_key']);
            if (keys.length == 1) throw Exception('Timeout');
            return _env({'ok': true});
          }
          if (method == 'subscription.state') {
            return _env({'ok': true, 'logged_in': true});
          }
          return _env({
            'ok': true,
            'logged_in': true,
            'can_charge': true,
            'cli_billing_enabled': true,
            'card': {'last4': '4242'},
            'charge_presets': ['25'],
          });
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('billing-buy')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('admin-confirm-yes')));
      await tester.pumpAndSettle();
      expect(find.text('Could not complete that request.'), findsNothing);
      expect(find.byKey(const Key('billing-charge-unknown')), findsOneWidget);
      expect(keys, hasLength(1));
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('billing-buy')))
            .onPressed,
        isNull,
      );
      await tester.tap(find.byKey(const Key('billing-buy')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('admin-confirm')), findsNothing);
      expect(keys, hasLength(1));
      await tester.tap(find.byKey(const Key('billing-charge-retry')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('admin-confirm-yes')));
      await tester.pumpAndSettle();
      expect(keys, hasLength(2));
      expect(keys[0], keys[1]);
      expect(find.byKey(const Key('billing-charge-unknown')), findsNothing);
    },
  );

  testWidgets('an accepted charge is polled until it settles', (tester) async {
    _wide(tester);
    final methods = <String>[];
    await _pump(
      tester,
      rpc: (method, params) async {
        if (method == 'billing.charge' || method == 'billing.charge_status') {
          methods.add(method);
        }
        if (method == 'billing.charge') {
          return _env({'ok': true, 'charge_id': 'ch_1'});
        }
        if (method == 'billing.charge_status') {
          expect(params['charge_id'], 'ch_1');
          return _env({'ok': true, 'status': 'settled', 'amount_usd': '25'});
        }
        if (method == 'subscription.state') {
          return _env({'ok': true, 'logged_in': true});
        }
        return _env({
          'ok': true,
          'logged_in': true,
          'can_charge': true,
          'cli_billing_enabled': true,
          'card': {'last4': '4242'},
          'charge_presets': ['25'],
        });
      },
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('billing-buy')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('admin-confirm-yes')));
    await tester.pumpAndSettle();
    expect(methods, ['billing.charge', 'billing.charge_status']);
    expect(find.text('Credit purchase settled.'), findsOneWidget);
    expect(find.byKey(const Key('billing-charge-unknown')), findsNothing);
  });
}
