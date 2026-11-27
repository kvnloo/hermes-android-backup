// Canonical wire audit, the services both layouts share on the chat socket:
// capabilities (plugins, connectors, vault, shared metrics), model presets
// and billing, Projects, and the legacy prompt fallbacks. Each is driven
// through the socket of both layouts (DesktopGatewayClient.call for Classic,
// NextGenGateway.call for NextGen) against the strict gateway.
//
// On a session authority most of these are not authority verbs: it answers
// -32601 and the legacy sidecar serves them, refusing unknown keys with
// 4000. The recorded frames are written to
// build/canonical-wire/services.json for tool/canonical_wire_check.py.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/capabilities/capability_admin.dart';
import 'package:hermes_android/core/composer/regenerate.dart';
import 'package:hermes_android/core/services/canonical_wire.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/services/model_admin.dart';
import 'package:hermes_android/core/services/projects_gateway_client.dart';
import 'package:hermes_android/core/services/remote_model_admin.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/strict_authority_server.dart';
import 'support/wire_capture.dart';

typedef _Rpc =
    Future<Map<String, dynamic>> Function(
      String method,
      Map<String, dynamic> params,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final log = WireCaptureLog('services');
  late HttpOverrides? previous;
  late StrictAuthorityGateway gateway;
  late DesktopGatewayClient classic;
  late NextGenGateway nextgen;

  setUp(() async {
    previous = HttpOverrides.current;
    HttpOverrides.global = null;
    SharedPreferences.setMockInitialValues(<String, Object>{});
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
    gateway = await StrictAuthorityGateway.start();
    gateway.handler = (method, params) => switch (method) {
      'plugins.manage' => {'ok': true, 'plugins': const <Object>[]},
      'connectors.accounts' => {'accounts': const <Object>[]},
      'connectors.policy.get' => {'layers': const <Object>[]},
      'connectors.tools' => {'tools': const <Object>[]},
      'vault.list' => {'items': const <Object>[]},
      'vault.sources' => {'sources': const <Object>[]},
      'shared_metrics.status' ||
      'shared_metrics.set' => {'enabled': false, 'send': false},
      'projects.list' => {'projects': const <Object>[], 'active_id': null},
      'projects.tree' => {'projects': const <Object>[]},
      'projects.project_sessions' => {'project': null},
      'session.info' => {
        'info': {'reasoning_effort': 'high', 'reasoning_effort_wire': 'high'},
      },
      _ => null,
    };
    classic = DesktopGatewayClient.fromConnection(
      gateway.connection(id: 'classic', profile: 'work'),
    );
    nextgen = NextGenGateway(gateway.connection(id: 'nextgen', profile: 'work'))
      ..start();
    await nextgen.connected();
  });

  tearDown(() async {
    classic.close();
    nextgen.dispose();
    await gateway.close();
    HermesSignInVault.resetForTesting();
    HttpOverrides.global = previous;
  });

  tearDownAll(log.write);

  /// Runs [run] once per layout, on that layout's own socket.
  Future<void> both(
    String producer,
    Future<Object?> Function(_Rpc rpc) run,
  ) async {
    for (final (layout, rpc) in <(String, _Rpc)>[
      ('classic', classic.call),
      ('nextgen', nextgen.call),
    ]) {
      await log.record(
        gateway,
        layout: layout,
        producer: producer,
        run: () async {
          try {
            await run(rpc);
          } on CapabilityException {
            // The fixture's answer is minimal: only the request matters.
          } on ProjectsUnsupportedException {
            // As above.
          } on FormatException {
            // As above.
          } on TypeError {
            // As above.
          } on JsonRpcError {
            // As above: a frame the gateway refused fails [record] itself.
          }
        },
      );
    }
  }

  CapabilityAdmin admin(_Rpc rpc) => CapabilityAdmin(
    profile: 'work',
    rest: (method, path, {query, body, timeout}) =>
        throw const CapabilityException('REST is not part of this audit.'),
    rpc: rpc,
  );

  test('plugins', () async {
    await both('CapabilityAdmin.plugins', (rpc) => admin(rpc).plugins());
    await both(
      'CapabilityAdmin.installPlugin',
      (rpc) => admin(rpc).installPlugin('owner/repo', acceptCapabilities: true),
    );
    await both(
      'CapabilityAdmin.installCatalogPlugin',
      (rpc) => admin(rpc).installCatalogPlugin('spotify', ref: 'v1'),
    );
    await both(
      'CapabilityAdmin.updatePlugin',
      (rpc) => admin(rpc).updatePlugin('spotify', force: true),
    );
    await both(
      'CapabilityAdmin.togglePlugin',
      (rpc) => admin(rpc).togglePlugin('plugin:spotify', false),
    );
    await both(
      'CapabilityAdmin.removePlugin',
      (rpc) => admin(rpc).removePlugin('spotify'),
    );
    await both(
      'CapabilityAdmin.removePluginDesktopHalf',
      (rpc) => admin(rpc).removePluginDesktopHalf('spotify'),
    );
    await both(
      'CapabilityAdmin.updateAllPlugins',
      (rpc) => admin(rpc).updateAllPlugins(),
    );
  });

  test('account connectors', () async {
    await both(
      'CapabilityAdmin.connectorAccounts',
      (rpc) => admin(rpc).connectorAccounts(),
    );
    await both(
      'CapabilityAdmin.connectConnector',
      (rpc) => admin(rpc).connectConnector('gmail', alias: 'work-mail'),
    );
    await both(
      'CapabilityAdmin.removeConnectorAccount',
      (rpc) => admin(rpc).removeConnectorAccount('conn-1'),
    );
    await both(
      'CapabilityAdmin.connectorTools',
      (rpc) => admin(rpc).connectorTools('gmail'),
    );
    await both(
      'CapabilityAdmin.setDisabledTools',
      (rpc) => admin(rpc).setDisabledTools(
        connector: 'gmail',
        disabledTools: const ['send'],
        // A policy revision is the gateway's own ULID, read back first.
        expectedRevision: '01ARZ3NDEKTSV4RRFFQ69G5FAV',
      ),
    );
  });

  test('vault', () async {
    await both(
      'CapabilityAdmin.vaultInventory',
      (rpc) => admin(rpc).vaultInventory(),
    );
    await both(
      'CapabilityAdmin.addVaultItem',
      (rpc) => admin(rpc).addVaultItem(
        const VaultDraft.login(
          label: 'Example',
          origin: 'https://example.com',
          identifier: 'sam',
          password: 'fixture-secret',
        ),
      ),
    );
    await both(
      'CapabilityAdmin.removeVaultItem',
      (rpc) => admin(rpc).removeVaultItem('item-1'),
    );
    await both(
      'CapabilityAdmin.setVaultSourceEnabled',
      (rpc) => admin(rpc).setVaultSourceEnabled('builtin', true),
    );
    await both(
      'CapabilityAdmin.unlockVaultSource',
      (rpc) => admin(rpc).unlockVaultSource('builtin', 'fixture-master'),
    );
    await both(
      'CapabilityAdmin.lockVaultSource',
      (rpc) => admin(rpc).lockVaultSource('builtin'),
    );
  });

  test('shared metrics', () async {
    await both(
      'CapabilityAdmin.sharedMetrics',
      (rpc) => admin(rpc).sharedMetrics(),
    );
    await both(
      'CapabilityAdmin.setSharedMetrics',
      (rpc) => admin(rpc).setSharedMetrics(enabled: true, send: true),
    );
  });

  test('model presets, route clamp, billing and plans', () async {
    RemoteModelAdmin models(_Rpc rpc) =>
        RemoteModelAdmin(classic.dashboard, rpc: rpc);
    await both(
      'RemoteModelAdmin.applyPreset',
      (rpc) => models(rpc).applyPreset(
        sessionId: 'stored-1',
        preset: const ModelPreset(effort: 'high', fast: true),
      ),
    );
    await both(
      'RemoteModelAdmin.routeClamp',
      (rpc) => models(rpc).routeClamp('stored-1'),
    );
    await both(
      'RemoteModelAdmin.billingState',
      (rpc) => models(rpc).billingState(),
    );
    await both(
      'RemoteModelAdmin.subscriptionState',
      (rpc) => models(rpc).subscriptionState(),
    );
    await both(
      'RemoteModelAdmin.buyCredits',
      (rpc) => models(rpc).buyCredits('10', idempotencyKey: 'idem-1'),
    );
    await both(
      'RemoteModelAdmin.chargeStatus',
      (rpc) => models(rpc).chargeStatus('charge-1'),
    );
    await both(
      'RemoteModelAdmin.setAutoReload',
      (rpc) => models(
        rpc,
      ).setAutoReload(enabled: true, thresholdUsd: '5', reloadToUsd: '20'),
    );
    await both(
      'RemoteModelAdmin.setKeepGoing',
      (rpc) => models(rpc).setKeepGoing(true),
    );
    await both(
      'RemoteModelAdmin.previewPlan',
      (rpc) => models(rpc).previewPlan('tier-pro'),
    );
    await both(
      'RemoteModelAdmin.schedulePlan',
      (rpc) => models(rpc).schedulePlan('tier-pro', 'scheduled'),
    );
    // Neither socket has opened the chat, so its fences are unknown: the
    // level goes as the `config.set reasoning` the owner also serves.
    expect(gateway.calls('session.mutate'), isEmpty);
    expect(gateway.calls('config.set').map((p) => p['key']), [
      'reasoning',
      'fast',
      'reasoning',
      'fast',
    ]);
  });

  test(
    'a preset on an open chat sets its level as a fenced mutation',
    () async {
      await classic.ensureSession('stored-1');
      await log.record(
        gateway,
        layout: 'classic',
        producer: 'RemoteModelAdmin.applyPreset (open chat)',
        run: () =>
            RemoteModelAdmin(classic.dashboard, rpc: classic.call).applyPreset(
              sessionId: 'stored-1',
              preset: const ModelPreset(effort: 'low'),
            ),
      );
      final mutate = gateway.calls('session.mutate').single;
      expect(mutate['operation'], 'reasoning');
      expect(mutate['payload'], {'effort': 'low'});
      expect(mutate['expected_generation'], 1);
    },
  );

  test('projects', () async {
    ProjectsGatewayClient projects(_Rpc rpc) => ProjectsGatewayClient(
      (method, params) async => {'result': await rpc(method, params)},
    );
    await both('ProjectsGatewayClient.list', (rpc) => projects(rpc).list());
    await both(
      'ProjectsGatewayClient.tree',
      (rpc) => projects(rpc).tree(previewLimit: 3, sessionLimit: 20),
    );
    await both('ProjectsGatewayClient.get', (rpc) => projects(rpc).get('p1'));
    await both(
      'ProjectsGatewayClient.projectSessions',
      (rpc) => projects(rpc).projectSessions('p1', sessionLimit: 20),
    );
    await both(
      'ProjectsGatewayClient.create',
      (rpc) => projects(rpc).create(
        name: 'Ares',
        description: 'The app',
        primaryPath: '/work/ares',
        folders: const ['/work/ares'],
        use: true,
      ),
    );
    await both(
      'ProjectsGatewayClient.rename',
      (rpc) => projects(rpc).rename(id: 'p1', name: 'Ares 5'),
    );
    await both(
      'ProjectsGatewayClient.addFolder',
      (rpc) => projects(
        rpc,
      ).addFolder(id: 'p1', path: '/work/docs', label: 'Docs', isPrimary: true),
    );
    await both(
      'ProjectsGatewayClient.archive',
      (rpc) => projects(rpc).archive('p1', restore: true),
    );
    await both(
      'ProjectsGatewayClient.setActive',
      (rpc) => projects(rpc).setActive('p1'),
    );
    await both(
      'ProjectsGatewayClient.delete',
      (rpc) => projects(rpc).delete('p1'),
    );
  });

  test('moving a chat to another project is the workspace mutation', () async {
    ProjectsGatewayClient projects(_Rpc rpc) => ProjectsGatewayClient(
      (method, params) async => {'result': await rpc(method, params)},
    );
    await both(
      'ProjectsGatewayClient.moveSessionWorkspace',
      (rpc) => projects(
        rpc,
      ).moveSessionWorkspace(sessionKey: 'stored-1', cwd: '/work/other'),
    );
    expect(gateway.calls('session.workspace.move'), isEmpty);
    for (final mutate in gateway.calls('session.mutate')) {
      expect(mutate['operation'], 'workspace');
      expect(mutate['payload'], {'cwd': '/work/other'});
      expect(mutate['expected_generation'], 1);
    }
    // Neither socket had opened the chat: each read its fences first.
    expect(gateway.calls('session.resume'), hasLength(2));
  });

  test('regenerate reads the transcript rows of the session', () async {
    await both(
      'resolveRegenerateTarget (session.history)',
      (rpc) => resolveRegenerateTarget(
        rpc: rpc,
        sessionId: 'stored-1',
        text: 'hello',
      ),
    );
    expect(gateway.calls('session.history'), hasLength(2));
  });

  test('the legacy sudo and secret RPC fallbacks are not sent', () async {
    final socket = await gateway.connect(profile: 'work');
    addTearDown(socket.close);
    for (final (producer, method, run) in [
      (
        'WsClient.respondToSudo (legacy RPC fallback)',
        'sudo.respond',
        () => socket.respondToSudo(requestId: 'srq-1', password: 'fixture'),
      ),
      (
        'WsClient.respondToSecret (legacy RPC fallback)',
        'secret.respond',
        () => socket.respondToSecret(requestId: 'srq-2', value: 'fixture'),
      ),
    ]) {
      await log.recordRefused(
        gateway,
        layout: 'shared',
        producer: producer,
        method: method,
        kind: CanonicalRefusalKind.method,
        run: run,
      );
    }
  });
}
