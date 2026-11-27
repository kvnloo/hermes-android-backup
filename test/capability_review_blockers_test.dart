// Ports the independent review repros for the capabilities lane (C1-C5)
// and the should-fix gaps those repros sit next to.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:hermes_android/core/capabilities/capability_admin.dart';
import 'package:hermes_android/core/capabilities/capability_pages.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/models/gateway_approval.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/gateway_approval_dialog.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';

const _stockBlocked =
    '{"name":"x","identifier":"fixture/skill","source":"github",'
    '"trust_level":"community","verdict":"dangerous","summary":"x: dangerous",'
    '"policy":"block","policy_reason":"Blocked (community source + dangerous verdict, 1 findings).",'
    '"findings":[{"severity":"critical","category":"exfiltration","file":"SKILL.md","line":3,'
    '"description":"sends secrets"}],"severity_counts":{"critical":1},"tier1":null}';

const _stockAsk =
    '{"name":"x","identifier":"fixture/skill","source":"github",'
    '"trust_level":"community","verdict":"caution","summary":"x: caution",'
    '"policy":"ask","policy_reason":"Requires confirmation (community source + caution verdict, 1 findings).",'
    '"findings":[{"severity":"high","description":"reads the environment"}]}';

void main() {
  test('C1: a stock dangerous/policy=block scan is not installed', () async {
    final calls = <String>[];
    final admin = CapabilityAdmin(
      rest: (method, path, {query, body, timeout}) async {
        calls.add('$method $path');
        if (path == 'skills/hub/scan') {
          return const CapabilityResponse(200, _stockBlocked);
        }
        return const CapabilityResponse(200, '{"ok":true,"action":"x"}');
      },
    );

    final result = await admin.installHubSkill('fixture/skill');

    expect(result.scan.blocked, isTrue);
    expect(result.scan.verdict, 'dangerous');
    expect(result.installed, isFalse);
    expect(
      calls,
      ['GET skills/hub/scan'],
      reason:
          'install was requested for a scan the gateway marked policy=block',
    );
  });

  test(
    'a policy=block scan stays blocked even when force is requested',
    () async {
      final calls = <String>[];
      final admin = CapabilityAdmin(
        rest: (method, path, {query, body, timeout}) async {
          calls.add('$method $path');
          if (path == 'skills/hub/scan') {
            return const CapabilityResponse(200, _stockBlocked);
          }
          return const CapabilityResponse(200, '{"installed":true}');
        },
      );

      final result = await admin.installHubSkill('fixture/skill', force: true);

      expect(result.installed, isFalse);
      expect(calls.where((call) => call.contains('install')), isEmpty);
    },
  );

  test('an ask policy sends force only after named confirmation', () async {
    final bodies = <Object?>[];
    final admin = CapabilityAdmin(
      rest: (method, path, {query, body, timeout}) async {
        if (path == 'skills/hub/scan') {
          return const CapabilityResponse(200, _stockAsk);
        }
        bodies.add(body);
        return const CapabilityResponse(200, '{"ok":true,"installed":true}');
      },
    );

    final held = await admin.installHubSkill('fixture/skill');
    final forced = await admin.installHubSkill('fixture/skill', force: true);

    expect(held.installed, isFalse);
    expect(held.scan.caution, isTrue);
    expect(held.scan.verdict, 'caution');
    expect(forced.installed, isTrue);
    expect(bodies, hasLength(1));
    expect((bodies.single! as Map)['identifier'], 'fixture/skill');
    expect((bodies.single! as Map)['force'], isTrue);
  });

  test('a spawned install is not reported as installed', () async {
    final admin = CapabilityAdmin(
      rest: (method, path, {query, body, timeout}) async {
        if (path == 'skills/hub/scan') {
          return const CapabilityResponse(
            200,
            '{"verdict":"safe","policy":"allow"}',
          );
        }
        return const CapabilityResponse(
          200,
          '{"ok":true,"pid":4,"name":"skills-install-fixture"}',
        );
      },
    );

    final result = await admin.installHubSkill('fixture/skill');

    expect(result.installed, isFalse);
    expect(result.scan.verdict, 'safe');
  });

  testWidgets('a blocked scan shows the verdict and does not install', (
    tester,
  ) async {
    final calls = <String>[];
    final admin = CapabilityAdmin(
      rest: (method, path, {query, body, timeout}) async {
        calls.add('$method $path');
        if (path == 'skills/hub/scan') {
          return const CapabilityResponse(200, _stockBlocked);
        }
        if (path == 'skills') return const CapabilityResponse(200, '[]');
        return const CapabilityResponse(200, '{"ok":true,"installed":true}');
      },
    );
    await tester.pumpWidget(
      MaterialApp(home: CapabilityAdminScreen(admin: admin)),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('hub-identifier')),
      'fixture/skill',
    );
    await tester.tap(find.byKey(const Key('hub-install')));
    await tester.pumpAndSettle();

    expect(find.textContaining('dangerous'), findsWidgets);
    expect(calls.where((call) => call.contains('install')), isEmpty);
  });

  testWidgets('Install anyway stays bound to the scanned identifier', (
    tester,
  ) async {
    final installed = <Object?>[];
    final admin = CapabilityAdmin(
      rest: (method, path, {query, body, timeout}) async {
        if (path == 'skills/hub/scan') {
          return const CapabilityResponse(200, _stockAsk);
        }
        if (path == 'skills/hub/install') {
          installed.add(body);
          return const CapabilityResponse(200, '{"ok":true,"installed":true}');
        }
        return const CapabilityResponse(200, '[]');
      },
    );
    await tester.pumpWidget(
      MaterialApp(home: CapabilityAdminScreen(admin: admin)),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('hub-identifier')),
      'fixture/skill',
    );
    await tester.tap(find.byKey(const Key('hub-install')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('hub-force')), findsOneWidget);
    expect(find.textContaining('fixture/skill'), findsWidgets);

    await tester.enterText(
      find.byKey(const Key('hub-identifier')),
      'other/skill',
    );
    await tester.pump();

    expect(find.byKey(const Key('hub-force')), findsNothing);
    expect(installed, isEmpty);
  });

  testWidgets('C2: Accept capabilities does not force a scan-blocked plugin', (
    tester,
  ) async {
    final rpc = <Map<String, dynamic>>[];
    final admin = CapabilityAdmin(
      rest: (method, path, {query, body, timeout}) async =>
          const CapabilityResponse(200, '[]'),
      rpc: (method, params) async {
        rpc.add({'method': method, ...params});
        if (params['action'] == 'list') {
          return {
            'plugins': [
              {'name': 'fixture', 'key': 'fixture', 'status': 'enabled'},
            ],
          };
        }
        return {
          'ok': false,
          'name': 'fixture',
          'scan_blocked': true,
          'scan_verdict': 'caution',
          'scan_findings': [
            {'pattern_id': 'env_read', 'severity': 'high'},
          ],
        };
      },
    );
    await tester.pumpWidget(
      MaterialApp(home: CapabilityAdminScreen(admin: admin)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plugins'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('plugin-update-fixture')));
    await tester.pumpAndSettle();
    expect(find.text('The scan blocked this plugin.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('plugin-accept')));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(
      rpc.last['force'],
      isNot(true),
      reason: 'one tap on "Accept capabilities" overrode the scan block',
    );
  });

  testWidgets('a scan block needs its own confirmation that names the plugin', (
    tester,
  ) async {
    final rpc = <Map<String, dynamic>>[];
    final admin = CapabilityAdmin(
      rest: (method, path, {query, body, timeout}) async =>
          const CapabilityResponse(200, '[]'),
      rpc: (method, params) async {
        rpc.add({'method': method, ...params});
        if (params['action'] == 'list') {
          return {
            'plugins': [
              {'name': 'fixture', 'key': 'fixture', 'status': 'enabled'},
            ],
          };
        }
        if (params['force'] == true) return {'ok': true};
        return {'ok': false, 'scan_blocked': true, 'scan_verdict': 'caution'};
      },
    );
    await tester.pumpWidget(
      MaterialApp(home: CapabilityAdminScreen(admin: admin)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plugins'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('plugin-update-fixture')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('plugin-scan-review')));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('fixture'), findsWidgets);
    await tester.tap(find.byKey(const Key('plugin-scan-confirm')));
    await tester.pumpAndSettle();

    final forced = rpc.lastWhere((call) => call['action'] == 'update');
    expect(forced['force'], isTrue);
    expect(forced['name'], 'fixture');
    expect(forced.containsKey('accept_capabilities'), isFalse);
  });

  testWidgets('a plugin action error is shown', (tester) async {
    final admin = CapabilityAdmin(
      rest: (method, path, {query, body, timeout}) async =>
          const CapabilityResponse(200, '[]'),
      rpc: (method, params) async {
        if (params['action'] == 'list') {
          return {
            'plugins': [
              {'name': 'fixture', 'key': 'fixture', 'status': 'enabled'},
            ],
          };
        }
        throw const CapabilityException('plugin exploded');
      },
    );
    await tester.pumpWidget(
      MaterialApp(home: CapabilityAdminScreen(admin: admin)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plugins'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('plugin-update-fixture')));
    await tester.pumpAndSettle();

    expect(find.textContaining('plugin exploded'), findsOneWidget);
  });

  testWidgets('C3: tool grants stay on the connector they were loaded for', (
    tester,
  ) async {
    final rpc = <Map<String, dynamic>>[];
    final admin = CapabilityAdmin(
      rest: (method, path, {query, body, timeout}) async =>
          const CapabilityResponse(200, '{"servers":[]}'),
      rpc: (method, params) async {
        rpc.add({'method': method, ...params});
        if (method == 'connectors.policy.get') {
          return {
            'layers': [
              {
                'kind': 'member',
                'revision': 'r1',
                'body': {
                  'tools': {
                    'alpha': ['alpha_delete'],
                  },
                },
              },
            ],
          };
        }
        if (method == 'connectors.tools') {
          return {
            'tools': [
              {'name': 'alpha_read'},
              {'name': 'alpha_delete'},
            ],
          };
        }
        return <String, dynamic>{};
      },
    );
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(home: CapabilityAdminScreen(admin: admin)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Connectors'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('tool-connector')), 'alpha');
    await tester.tap(find.byKey(const Key('tool-load')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('tool-connector')), 'beta');
    await tester.tap(find.byKey(const Key('tool-save')));
    await tester.pumpAndSettle();

    final write = rpc.last;
    expect(
      (write['change'] as Map)['connector'],
      'alpha',
      reason: "alpha's grant list was written to a different connector",
    );
  });

  test(
    'adding an MCP server uses one POST and does not rewrite the map',
    () async {
      final calls = <String>[];
      Object? posted;
      final admin = CapabilityAdmin(
        rest: (method, path, {query, body, timeout}) async {
          calls.add('$method $path');
          if (method == 'POST' && path == 'mcp/servers') {
            posted = body;
            return const CapabilityResponse(200, '{"name":"added"}');
          }
          return const CapabilityResponse(
            200,
            '{"mcp_servers":{"kept":{"command":"echo"}}}',
          );
        },
      );

      await admin.addMcpServer(
        'added',
        const McpServerSpec.stdio(command: 'fixture-mcp'),
      );

      expect(calls, ['POST mcp/servers']);
      expect((posted! as Map)['name'], 'added');
      expect((posted! as Map)['command'], 'fixture-mcp');
      expect((posted! as Map).containsKey('servers'), isFalse);
    },
  );

  test('a boolean false approval mode is off', () async {
    final admin = CapabilityAdmin(
      rest: (method, path, {query, body, timeout}) async {
        return const CapabilityResponse(
          200,
          '{"approvals":{"mode":false,"timeout":30}}',
        );
      },
    );

    final policy = await admin.agentPolicy();

    expect(policy.approvalMode, 'off');
  });

  test('C4: NextGen renders a sandbox folder request as its own card', () {
    final parsed = NgInputRequest.parse(
      NgServerRequest(
        GatewayServerRequest.forTesting(
          id: 'r1',
          method: 'approval',
          params: {
            'request_id': 'r1',
            'kind': 'access',
            'path': '/fixture/private',
            'access': 'read_write',
            'description': 'Sandbox wants a folder',
            'choices': ['once', 'always', 'deny'],
          },
        ),
      ),
    )!;

    expect(parsed.title, isNot('Allow this command?'));
    expect(
      '${parsed.title} ${parsed.body} ${parsed.command}',
      contains('/fixture/private'),
    );
    expect(
      '${parsed.title} ${parsed.body} ${parsed.command}',
      contains('Read and write'),
    );
  });

  test('a NextGen website approval names the host', () {
    final parsed = NgInputRequest.parse(
      NgServerRequest(
        GatewayServerRequest.forTesting(
          id: 'r2',
          method: 'approval',
          params: {
            'kind': 'network',
            'host': 'fixture.example',
            'description': 'Sandbox wants a site',
            'choices': ['once', 'deny'],
          },
        ),
      ),
    )!;

    expect(parsed.title, isNot('Allow this command?'));
    expect(
      '${parsed.title} ${parsed.body} ${parsed.command}',
      contains('fixture.example'),
    );
    expect(
      '${parsed.title} ${parsed.body}',
      contains('sandbox is switched off'),
    );
  });

  testWidgets('C5: Classic folder card does not call once this request only', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GatewayApprovalDialog(
            request: GatewayApprovalRequest.fromEventData(const {
              'request_id': 'r1',
              'kind': 'access',
              'path': '/fixture/notes',
              'access': 'read',
              'description': 'Sandbox wants a folder',
              'choices': ['once', 'always', 'deny'],
            }),
            onRespond: (_) async {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Allow this folder for this request only.'), findsNothing);
    expect(
      find.text('Allow this folder until the sandbox is switched off.'),
      findsOneWidget,
    );
  });

  testWidgets('a website once grant lasts until the sandbox is switched off', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GatewayApprovalDialog(
            request: GatewayApprovalRequest.fromEventData(const {
              'kind': 'network',
              'host': 'fixture.example',
              'description': 'Sandbox wants a website',
              'choices': ['once', 'deny'],
            }),
            onRespond: (_) async {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Allow this website for this request only.'),
      findsNothing,
    );
    expect(
      find.text('Allow this website until the sandbox is switched off.'),
      findsOneWidget,
    );
  });

  testWidgets('the Classic REST fallback closes when its page is popped', (
    tester,
  ) async {
    final probe = _ClosingClient();
    final client = DashboardClient(host: 'fixture.invalid', httpClient: probe);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              pushAndRelease(
                context,
                const Text('capabilities-page'),
                client.close,
              );
            },
            child: const Text('open capabilities'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open capabilities'));
    await tester.pumpAndSettle();
    expect(find.text('capabilities-page'), findsOneWidget);
    expect(probe.closed, isFalse);

    Navigator.of(tester.element(find.text('capabilities-page'))).pop();
    await tester.pumpAndSettle();

    expect(probe.closed, isTrue);
  });

  testWidgets('a shared dashboard stays open when the capability page closes', (
    tester,
  ) async {
    final probe = _ClosingClient();
    final client = DashboardClient(host: 'fixture.invalid', httpClient: probe);
    addTearDown(client.close);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              pushAndRelease(context, const Text('shared-page'), null);
            },
            child: const Text('open shared'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open shared'));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.text('shared-page'))).pop();
    await tester.pumpAndSettle();

    expect(probe.closed, isFalse);
  });
}

class _ClosingClient extends http.BaseClient {
  bool closed = false;

  @override
  void close() {
    closed = true;
    super.close();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw StateError('unused');
  }
}
