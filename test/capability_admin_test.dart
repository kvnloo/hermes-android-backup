import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/capabilities/capability_admin.dart';

void main() {
  test('a blocked skill scan is not installed', () async {
    final calls = <String>[];
    final admin = _admin(
      calls,
      rest: (method, path, {query, body, timeout}) async {
        calls.add('$method $path');
        if (path == 'skills/hub/scan') {
          return const CapabilityResponse(
            200,
            '{"verdict":"dangerous","policy":"block","findings":[{"description":"unsafe"}]}',
          );
        }
        return const CapabilityResponse(500, '{}');
      },
    );

    final result = await admin.installHubSkill('fixture/skill');

    expect(result.installed, isFalse);
    expect(result.scan.blocked, isTrue);
    expect(calls, ['GET skills/hub/scan']);
  });

  test('a caution scan waits for an explicit force', () async {
    final calls = <String>[];
    final admin = _admin(
      calls,
      rest: (method, path, {query, body, timeout}) async {
        calls.add('$method $path');
        if (path == 'skills/hub/scan') {
          return const CapabilityResponse(
            200,
            '{"verdict":"caution","policy":"ask"}',
          );
        }
        return const CapabilityResponse(200, '{"ok":true,"installed":true}');
      },
    );

    final held = await admin.installHubSkill('fixture/skill');
    final forced = await admin.installHubSkill('fixture/skill', force: true);

    expect(held.installed, isFalse);
    expect(held.scan.caution, isTrue);
    expect(forced.installed, isTrue);
    expect(calls, [
      'GET skills/hub/scan',
      'GET skills/hub/scan',
      'POST skills/hub/install',
    ]);
  });

  test('edit, lock and archive address the named skill', () async {
    final bodies = <Object?>[];
    final admin = _admin(
      [],
      rest: (method, path, {query, body, timeout}) async {
        bodies.add([method, path, query, body]);
        if (method == 'GET') {
          return const CapabilityResponse(
            200,
            '{"ok":true,"content":"# Fixture"}',
          );
        }
        return const CapabilityResponse(200, '{"ok":true}');
      },
    );

    expect(await admin.learningContent('notes'), '# Fixture');
    await admin.saveLearningContent('notes', '# Edited');
    await admin.setSkillLocked('notes', true);
    await admin.archiveSkill('notes');

    expect(bodies[1], [
      'PUT',
      'learning/node',
      {'profile': 'work'},
      {'id': 'notes', 'content': '# Edited'},
    ]);
    expect(bodies[2], [
      'PUT',
      'skills/lock',
      {'profile': 'work'},
      {'name': 'notes', 'locked': true},
    ]);
    expect(bodies[3], [
      'DELETE',
      'learning/node',
      {'profile': 'work'},
      {'id': 'notes'},
    ]);
    expect(skillIsEditable('agent'), isTrue);
    expect(skillIsEditable('hub'), isFalse);
  });

  test('adding an MCP server is one POST and a duplicate is refused', () async {
    final calls = <String>[];
    final admin = _admin(
      [],
      rest: (method, path, {query, body, timeout}) async {
        calls.add('$method $path');
        if (body is Map && body['name'] == 'kept') {
          return const CapabilityResponse(
            409,
            '{"detail":"Server already exists"}',
          );
        }
        return const CapabilityResponse(200, '{"name":"added"}');
      },
    );

    await admin.addMcpServer(
      'added',
      const McpServerSpec.stdio(command: 'fixture-mcp'),
    );
    expect(
      () => admin.addMcpServer(
        'kept',
        const McpServerSpec.http(url: 'https://fixture.example/mcp'),
      ),
      throwsA(isA<CapabilityException>()),
    );
    expect(calls, ['POST mcp/servers', 'POST mcp/servers']);
  });

  test('MCP logs are redacted before they can be shown', () async {
    final admin = _admin(
      [],
      rest: (method, path, {query, body, timeout}) async {
        expect(query?['file'], 'mcp');
        return const CapabilityResponse(
          200,
          '{"lines":["authorization: Bearer fixture-token-value"]}',
        );
      },
    );

    final text = await admin.mcpLogs();
    expect(text, isNot(contains('fixture-token-value')));
    expect(text, contains('[redacted]'));
  });

  test('tool grants use the member revision and do not invent one', () async {
    final rpcCalls = <List<Object?>>[];
    final admin = _admin(
      [],
      rpc: (method, params) async {
        rpcCalls.add([method, params]);
        if (method == 'connectors.policy.get') {
          return {
            'layers': [
              {
                'kind': 'member',
                'revision': 'rev-1',
                'body': {
                  'mode': 'deny',
                  'tools': {
                    'linear': ['archive'],
                  },
                },
              },
            ],
          };
        }
        return {
          'tools': [
            {'name': 'archive'},
            {'name': 'search'},
          ],
        };
      },
    );

    final grant = await admin.connectorTools('linear');
    await admin.setDisabledTools(
      connector: 'linear',
      disabledTools: const ['archive'],
      expectedRevision: grant.revision!,
    );

    expect(grant.disabled, ['archive']);
    expect(rpcCalls.last, [
      'connectors.policy.set',
      {
        'change': {
          'type': 'tools',
          'connector': 'linear',
          'disabled_tools': ['archive'],
        },
        'expected_revision': 'rev-1',
        'profile': 'work',
      },
    ]);
    expect(
      () => admin.setDisabledTools(
        connector: 'linear',
        disabledTools: const [],
        expectedRevision: '',
      ),
      throwsA(isA<CapabilityException>()),
    );
  });

  test('vault secrets stay out of validation and echoed errors', () async {
    final admin = _admin(
      [],
      rpc: (method, params) async {
        final secret = params['secret'] as Map;
        throw CapabilityException('rejected ${secret['password']}');
      },
    );

    expect(
      () => admin.addVaultItem(
        const VaultDraft.login(
          label: 'GitHub',
          origin: 'not-a-url',
          identifier: 'me@example.com',
          password: 's3cret-fixture',
        ),
      ),
      throwsA(
        predicate(
          (error) =>
              error is VaultFormException &&
              !error.message.contains('s3cret-fixture'),
        ),
      ),
    );
    expect(
      () => admin.addVaultItem(
        const VaultDraft.login(
          label: 'GitHub',
          origin: 'https://github.com',
          identifier: 'me@example.com',
          password: 's3cret-fixture',
        ),
      ),
      throwsA(
        predicate(
          (error) =>
              error is CapabilityException &&
              !error.message.contains('s3cret-fixture') &&
              error.message.contains('[redacted]'),
        ),
      ),
    );
  });

  test(
    'policy writes only its fields and metrics cannot send while off',
    () async {
      Object? written;
      final metrics = <Map<String, dynamic>>[];
      final admin = _admin(
        [],
        rest: (method, path, {query, body, timeout}) async {
          if (method == 'PUT') written = body;
          return const CapabilityResponse(
            200,
            '{"ok":true,"approvals":{"mode":"manual","timeout":30,"mcp_reload_confirm":true},"command_allowlist":["git status"],"checkpoints":{"enabled":true,"max_snapshots":4},"browser":{"allow_private_urls":false,"use_real_profile":false}}',
          );
        },
        rpc: (method, params) async {
          metrics.add(params);
          return {'enabled': params['enabled'], 'send': false, 'decided': true};
        },
      );

      final policy = await admin.agentPolicy();
      await admin.saveAgentPolicy(policy);
      final consent = await admin.setSharedMetrics(enabled: false, send: true);

      expect(policy.approvalMode, 'manual');
      expect(policy.allowlist, ['git status']);
      expect((written! as Map)['config'], policy.toWrite());
      expect(consent.send, isFalse);
      expect(metrics.single['send'], isFalse);
    },
  );

  test('a plugin capability widening is not accepted automatically', () async {
    final calls = <Map<String, dynamic>>[];
    final admin = _admin(
      [],
      rpc: (method, params) async {
        calls.add(params);
        return {
          'ok': false,
          'consent_required': true,
          'delta_lines': ['tools: added'],
        };
      },
    );

    final result = await admin.updatePlugin('fixture-plugin');

    expect(result.consentRequired, isTrue);
    expect(result.ok, isFalse);
    expect(calls.single.containsKey('accept_capabilities'), isFalse);
  });
}

CapabilityAdmin _admin(
  List<String> calls, {
  CapabilityRest? rest,
  CapabilityRpc? rpc,
}) {
  return CapabilityAdmin(
    profile: 'work',
    rpc: rpc,
    rest:
        rest ??
        (method, path, {query, body, timeout}) async {
          calls.add('$method $path');
          return const CapabilityResponse(200, '{}');
        },
  );
}
