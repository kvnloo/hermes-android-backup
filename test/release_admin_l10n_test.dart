import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/core/screens/model_admin_screen.dart';
import 'package:hermes_android/core/screens/profile_admin_panel.dart';
import 'package:hermes_android/core/screens/profile_bundle_screen.dart';
import 'package:hermes_android/core/screens/profile_transfer_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/model_admin.dart';
import 'package:hermes_android/core/services/remote_model_admin.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

final _en = lookupAppLocalizations(const Locale('en'));
final _de = lookupAppLocalizations(const Locale('de'));

TypeMatcher<ModelAdminException> _failure(
  ModelAdminFailure reason,
  String english,
) => isA<ModelAdminException>()
    .having((e) => e.reason, 'reason', reason)
    .having((e) => e.message, 'English compatibility rendering', english)
    .having((e) => e.localized(_en), 'English UI rendering', english)
    .having((e) => e.localized(_de), 'German UI rendering', isNot(english));

SavedConnection _connection() => SavedConnection(
  id: 'admin-l10n-fixture',
  label: 'Fixture',
  host: '127.0.0.1',
  port: 9,
  apiKey: 'synthetic',
);

DashboardClient _client([int status = 200, String body = '{}']) =>
    DashboardClient(
      host: '127.0.0.1',
      port: 9,
      proxied: true,
      gatewayProfile: 'research',
      httpClient: MockClient((_) async => http.Response(body, status)),
    );

Widget _app(Widget child, Locale locale, {bool delegate = false}) =>
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        if (delegate) AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      home: Scaffold(body: child),
    );

class _Profile extends Fake implements RemoteProfileAdmin {
  @override
  String get name => 'fixture';
  @override
  void check() {
    if (denyCheck) throw const WorkspaceException(WorkspaceFailure.denied);
  }

  bool denyCheck = false;
  List<String> states = [];
  @override
  Future<List<ProfileChannel>> channels() async => [
    for (final state in states) _Channel(state),
  ];
  @override
  Future<Map> bundledPresentation() async =>
      throw const WorkspaceException(WorkspaceFailure.unsupported);
}

class _Channel extends Fake implements ProfileChannel {
  _Channel(this.state);
  @override
  final String state;
  @override
  String get name => 'Telegram';
  @override
  String get id => state;
}

void main() {
  test('endpoint validation retains typed reasons and exact English', () {
    EndpointDraft draft({
      String name = 'Lab',
      String model = 'm',
      String mode = '',
      String url = 'https://example.invalid',
      String? id,
      String? key,
    }) => EndpointDraft(
      name: name,
      model: model,
      apiMode: mode,
      baseUrl: url,
      id: id,
      apiKey: key,
    );
    final cases = [
      (
        draft(name: ''),
        ModelAdminFailure.endpointNameRequired,
        'Enter a name for this endpoint.',
      ),
      (
        draft(model: ''),
        ModelAdminFailure.endpointModelRequired,
        'Enter the model this endpoint serves.',
      ),
      (
        draft(mode: 'unsupported'),
        ModelAdminFailure.knownApiMode,
        'Choose Auto or a known API mode.',
      ),
      (
        draft(id: 'invalid/id'),
        ModelAdminFailure.endpointIdInvalid,
        'This endpoint identifier is not usable.',
      ),
      (
        draft(url: 'http://example.invalid'),
        ModelAdminFailure.endpointHttps,
        'Use HTTPS for a remote endpoint, or HTTP on localhost.',
      ),
      (
        draft(key: 'one\ntwo'),
        ModelAdminFailure.keyInvalid,
        'That API key cannot be saved.',
      ),
    ];
    for (final (input, reason, english) in cases) {
      expect(
        () => validateEndpointDraft(input),
        throwsA(_failure(reason, english)),
      );
    }
  });

  test(
    'preset, delegation, route and response errors retain reasons and English',
    () async {
      await expectLater(
        MemoryModelPresetStore().save('', 'm', const ModelPreset()),
        throwsA(
          _failure(
            ModelAdminFailure.chooseProvider,
            'Choose a provider and a model.',
          ),
        ),
      );
      await expectLater(
        MemoryModelPresetStore().save(
          'p',
          'm',
          const ModelPreset(effort: 'bad'),
        ),
        throwsA(
          _failure(
            ModelAdminFailure.knownEffort,
            'Choose a known effort level.',
          ),
        ),
      );
      expect(
        () => checkedSessionId('bad id'),
        throwsA(
          _failure(
            ModelAdminFailure.chatIdRequired,
            'Enter the chat id this change applies to.',
          ),
        ),
      );
      expect(
        () => delegationLimitsPatch(const DelegationLimits()),
        throwsA(
          _failure(
            ModelAdminFailure.limitsRequired,
            'Enter iteration, concurrency and timeout limits before saving.',
          ),
        ),
      );
      expect(
        () => namedEndpoints({}),
        throwsA(
          _failure(
            ModelAdminFailure.responseShape,
            'The gateway response did not match the expected shape.',
          ),
        ),
      );
      expect(
        () => modelRouteBody(
          routes: [
            {'name': 'r', 'model': 'm'},
            {'name': 'r', 'model': 'n'},
          ],
          defaultRoute: null,
        ),
        throwsA(
          _failure(
            ModelAdminFailure.routeUnique,
            'Route names must be unique.',
          ),
        ),
      );
    },
  );

  test(
    'HTTP and RPC errors distinguish local reasons from server detail',
    () async {
      final badHttp = _client(503);
      final unreadable = _client(200, 'not json');
      final client = _client();
      addTearDown(badHttp.close);
      addTearDown(unreadable.close);
      addTearDown(client.close);
      await expectLater(
        RemoteModelAdmin(badHttp).endpoints(),
        throwsA(
          _failure(
            ModelAdminFailure.httpError,
            'The gateway returned HTTP 503.',
          ).having((e) => e.statusCode, 'HTTP status', 503),
        ),
      );
      await expectLater(
        RemoteModelAdmin(unreadable).endpoints(),
        throwsA(
          _failure(
            ModelAdminFailure.responseUnreadable,
            'The gateway response could not be read.',
          ),
        ),
      );
      await expectLater(
        RemoteModelAdmin(client).billingState(),
        throwsA(
          _failure(
            ModelAdminFailure.connectBeforeChange,
            'Connect the live gateway session before changing billing or a chat.',
          ),
        ),
      );
      final unsupported = RemoteModelAdmin(
        client,
        rpc: (_, _) async => {
          'error': {'code': -32601, 'message': 'server detail'},
        },
      );
      await expectLater(
        unsupported.billingState(),
        throwsA(
          _failure(
            ModelAdminFailure.operationUnavailable,
            'This gateway does not provide that operation.',
          ),
        ),
      );
      final detail = RemoteModelAdmin(
        client,
        rpc: (_, _) async => {
          'error': {'code': -1, 'message': 'Synthetic server detail'},
        },
      );
      await expectLater(
        detail.billingState(),
        throwsA(
          isA<ModelAdminException>()
              .having((e) => e.reason, 'reason', ModelAdminFailure.server)
              .having((e) => e.message, 'English', 'Synthetic server detail')
              .having(
                (e) => e.localized(_de),
                'server detail',
                'Synthetic server detail',
              ),
        ),
      );
    },
  );

  for (final locale in AppLocalizations.supportedLocales) {
    final l = lookupAppLocalizations(locale);
    test('service fallbacks and profile failure rendering in $locale', () {
      expect(
        safeBillingMessage('https://sensitive.invalid', l: l),
        l.rel_admin_billing_refused,
      );
      expect(safeBillingMessage(null, l: l), l.rel_admin_billing_refused);
      expect(
        safeBillingMessage('Synthetic server detail', l: l),
        'Synthetic server detail',
      );
      final answered = endpointTestResult({'reachable': true, 'ok': false});
      expect(answered.reachable, false);
      expect(answered.answered, true);
      expect(answered.localizedMessage(l), l.rel_admin_endpoint_answered);
      expect(answered.message, 'The endpoint answered.');
      expect(
        endpointTestResult({}).localizedMessage(l),
        l.rel_admin_endpoint_no_answer,
      );
      expect(endpointTestResult({}).message, 'The endpoint did not answer.');
      expect(
        endpointTestResult({'message': 'Server says so'}).localizedMessage(l),
        'Server says so',
      );
      expect(
        profileError(const WorkspaceException(WorkspaceFailure.stale), l),
        l.rel_admin_connection_changed_reopen_profiles,
      );
      expect(
        profileError(const WorkspaceException(WorkspaceFailure.denied), l),
        l.rel_admin_access_denied_by_the_gateway,
      );
      expect(
        profileError(StateError('Internal diagnostic'), l),
        l.rel_admin_could_not_verify_the_result_refresh_the_target_before,
      );
    });

    testWidgets(
      'model administration uses ambient $locale without app delegate',
      (tester) async {
        final client = _client();
        addTearDown(client.close);
        await tester.pumpWidget(
          _app(
            ModelAdminScreen(
              connection: _connection(),
              dashboard: client,
              presets: MemoryModelPresetStore(),
              initialSection: ModelAdminSection.billing,
            ),
            locale,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(l.rel_admin_providers_and_billing), findsOneWidget);
        expect(find.text(l.rel_admin_connect_before_billing), findsOneWidget);
        expect(find.byTooltip(l.rel_admin_refresh), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final delegate in [false, true]) {
    testWidgets(
      'profile screens use German with generated delegate=$delegate',
      (tester) async {
        final profile = _Profile();
        await tester.pumpWidget(
          _app(
            ProfileAdminPanel(
              admin: profile,
              label: 'Gateway',
              connection: _connection(),
              nextGen: !delegate,
              onRosterChanged: () {},
            ),
            const Locale('de'),
            delegate: delegate,
          ),
        );
        expect(find.text(_de.rel_admin_edit_persona), findsOneWidget);
        expect(find.text(_de.rel_admin_clone_profile), findsOneWidget);
        expect(find.text('Clone profile'), findsNothing);
        await tester.pumpWidget(
          _app(
            ProfileBundleScreen(
              admin: profile,
              gateway: 'Gateway',
              connection: _connection(),
              nextGen: !delegate,
            ),
            const Locale('de'),
            delegate: delegate,
          ),
        );
        expect(
          find.text(_de.rel_admin_portable_profile_bundle),
          findsOneWidget,
        );
        await tester.tap(
          find.text(_de.rel_admin_review_appearance_saved_with_this_profile),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(
            _de.rel_admin_this_operation_is_unavailable_on_this_gateway,
          ),
          findsOneWidget,
        );
        await tester.pumpWidget(
          _app(
            ProfileTransferScreen(source: profile, label: 'Gateway'),
            const Locale('de'),
            delegate: delegate,
          ),
        );
        expect(
          find.text(_de.rel_admin_transfer_source('Gateway', 'fixture')),
          findsOneWidget,
        );
        profile.denyCheck = true;
        await tester.tap(find.text(_de.rel_admin_find_my_cloud_agents));
        await tester.pumpAndSettle();
        expect(
          find.text(_de.rel_admin_access_denied_by_the_gateway),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('channel states localize known codes and preserve future codes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final states = {
      'pending_restart': _de.rel_admin_state_pending_restart,
      'startup_failed': _de.rel_admin_state_startup_failed,
      'gateway_stopped': _de.rel_admin_state_gateway_stopped,
      'connecting': _de.rel_admin_state_connecting,
      'retrying': _de.rel_admin_state_retrying,
      'fatal': _de.rel_admin_state_fatal,
      'future_wire_state': 'future_wire_state',
    };
    final profile = _Profile()..states = states.keys.toList();
    await tester.pumpWidget(
      _app(
        ProfileAdminPanel(
          admin: profile,
          label: 'Gateway',
          connection: _connection(),
          nextGen: true,
          onRosterChanged: () {},
        ),
        const Locale('de'),
      ),
    );
    await tester.tap(find.text(_de.rel_admin_messaging_channels));
    await tester.pumpAndSettle();
    for (final entry in states.entries) {
      expect(find.text('${entry.key} · ${entry.value}'), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('German credit confirmation preserves amount and consent gate', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final client = _client();
    addTearDown(client.close);
    final charges = <Map<String, dynamic>>[];
    await tester.pumpWidget(
      _app(
        ModelAdminScreen(
          connection: _connection(),
          dashboard: client,
          presets: MemoryModelPresetStore(),
          initialSection: ModelAdminSection.billing,
          rpc: (method, params) async {
            if (method == 'billing.state') {
              return {
                'ok': true,
                'logged_in': true,
                'can_charge': true,
                'cli_billing_enabled': true,
                'card': {'last4': '4242'},
                'charge_presets': ['5'],
              };
            }
            if (method == 'billing.charge') charges.add(params);
            return {'ok': true};
          },
        ),
        const Locale('de'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('billing-buy')));
    await tester.pumpAndSettle();
    expect(find.text(_de.rel_admin_buy_confirm('5')), findsOneWidget);
    expect(charges, isEmpty);
    await tester.tap(find.text(_de.rel_admin_cancel));
    await tester.pumpAndSettle();
    expect(charges, isEmpty);
    await tester.tap(find.byKey(const Key('billing-buy')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('admin-confirm-yes')));
    await tester.pumpAndSettle();
    expect(charges, hasLength(1));
    expect(charges.single['amount_usd'], '5');
    expect(
      charges.single['idempotency_key'],
      matches(RegExp(r'^[0-9a-f-]{36}$')),
    );
    expect(find.text(_de.rel_admin_credit_purchase_submitted), findsOneWidget);
  });

  test(
    'all release admin keys have descriptions and matching ICU variables',
    () {
      final english =
          jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync()) as Map;
      final keys = english.keys
          .cast<String>()
          .where((k) => k.startsWith('rel_admin_'))
          .toList();
      expect(keys.length, greaterThan(350));
      final placeholder = RegExp(r'\{(\w+)\}');
      for (final file in Directory(
        'lib/l10n',
      ).listSync().whereType<File>().where((f) => f.path.endsWith('.arb'))) {
        final catalog = jsonDecode(file.readAsStringSync()) as Map;
        for (final key in keys) {
          final value = catalog[key] as String;
          expect(value, isNotEmpty, reason: '${file.path}:$key');
          expect(catalog['@$key']['description'], isNotEmpty, reason: key);
          expect(
            placeholder.allMatches(value).map((m) => m[1]).toSet(),
            placeholder
                .allMatches(english[key] as String)
                .map((m) => m[1])
                .toSet(),
            reason: '${file.path}:$key',
          );
        }
      }
    },
  );
}
