// Canonical wire audit, Classic layout: every request the Classic chat
// transport (DesktopGatewayClient over WsClient) sends on a session-authority
// (Hermes 0.23+) socket, driven end to end against the strict gateway.
//
// The strict gateway refuses what the pinned gateway refuses, so each test
// fails on a legacy shape. The recorded frames are written to
// build/canonical-wire/classic.json and validated against the gateway's own
// pydantic models by tool/canonical_wire_check.py.
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/render/catalog_install.dart';
import 'package:hermes_android/core/services/canonical_wire.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/strict_authority_server.dart';
import 'support/wire_capture.dart';

const _layout = 'classic';

void main() {
  final log = WireCaptureLog('classic');
  late HttpOverrides? previous;
  late StrictAuthorityGateway gateway;
  late DesktopGatewayClient client;
  final events = <(String, StreamEvent)>[];

  setUp(() async {
    previous = HttpOverrides.current;
    HttpOverrides.global = null;
    SharedPreferences.setMockInitialValues(<String, Object>{});
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
    events.clear();
    gateway = await StrictAuthorityGateway.start();
    gateway.handler = (method, params) {
      if (method == 'prompt.submit') {
        final sessionId = params['session_id'] as String;
        // The turn the admission started ends at once.
        scheduleMicrotask(
          () => gateway.emit(
            'message.complete',
            sessionId: sessionId,
            payload: {'text': 'done'},
            envelope: {'execution_generation': gateway.generationOf(sessionId)},
          ),
        );
      }
      return null;
    };
    client = DesktopGatewayClient.fromConnection(
      gateway.connection(profile: 'work'),
    );
    client.setAsyncEventListener((session, event) {
      events.add((session, event));
    });
  });

  tearDown(() async {
    client.close();
    await gateway.close();
    HermesSignInVault.resetForTesting();
    HttpOverrides.global = previous;
  });

  tearDownAll(log.write);

  Future<T> record<T>(String producer, Future<T> Function() run) =>
      log.record(gateway, layout: _layout, producer: producer, run: run);

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 60));

  test('a stored chat is opened with the canonical resume', () async {
    await record(
      'DesktopGatewayClient.ensureSession (resume)',
      () => client.ensureSession('stored-1'),
    );
    final resume = gateway.calls('session.resume').single;
    expect(resume['session_id'], 'stored-1');
    expect(resume.containsKey('inline_images'), isFalse);
    expect(resume['profile'], 'work');
  });

  test('a new chat is created when the owner does not know its id', () async {
    gateway.unknownSessions.add('draft-1');
    await record(
      'DesktopGatewayClient.ensureSession (create)',
      () => client.ensureSession('draft-1', workingDirectory: '/work/app'),
    );
    final create = gateway.calls('session.create').single;
    expect(create['source'], 'gui');
    expect(create['cwd'], '/work/app');
  });

  test('a prompt is admitted with its submission id', () async {
    await client.ensureSession('stored-1');
    await record(
      'DesktopGatewayClient.submitPrompt',
      () => client.submitPrompt(
        sessionId: 'stored-1',
        text: 'Hello',
        submissionId: 'sub-1',
        onEvent: (_) {},
        onSent: () {},
      ),
    );
    expect(gateway.calls('prompt.submit').single['submission_id'], 'sub-1');
  });

  test('steer and stop name the running generation', () async {
    await client.ensureSession('stored-1');
    await record(
      'DesktopGatewayClient.steerPrompt',
      () => client.steerPrompt(sessionId: 'stored-1', text: 'Shorter'),
    );
    await record(
      'DesktopGatewayClient.interruptPrompt',
      () => client.interruptPrompt(sessionId: 'stored-1'),
    );
    expect(gateway.calls('session.steer').single['execution_generation'], 1);
    expect(
      gateway.calls('session.interrupt').single['execution_generation'],
      1,
    );
  });

  test('rename is the owner\'s rename mutation', () async {
    await client.ensureSession('stored-1');
    await record(
      'DesktopGatewayClient.renameSession',
      () => client.renameSession(sessionId: 'stored-1', title: 'Release plan'),
    );
    expect(gateway.calls('session.title'), isEmpty);
    final mutate = gateway.calls('session.mutate').single;
    expect(mutate['operation'], 'rename');
    expect(mutate['payload'], {'title': 'Release plan'});
    expect(mutate['expected_revision'], 1);
    expect(mutate.containsKey('expected_generation'), isFalse);
  });

  test('branch is the owner\'s branch mutation and names the child', () async {
    await client.ensureSession('stored-1');
    final branch = await record(
      'DesktopGatewayClient.branchSession',
      () => client.branchSession(sessionId: 'stored-1', name: 'Try B'),
    );
    expect(gateway.calls('session.branch'), isEmpty);
    final mutate = gateway.calls('session.mutate').single;
    expect(mutate['operation'], 'branch');
    expect(mutate['payload'], {'title': 'Try B'});
    expect(mutate['expected_generation'], 1);
    // The legacy answer shape the caller reads.
    expect(branch['session_id'], branch['branched_session_id']);
    expect(branch['parent_session_id'], 'stored-1');
  });

  test('a model pick is the model mutation, never a config write', () async {
    await client.ensureSession('stored-1');
    await record(
      'DesktopGatewayClient.setSessionModel',
      () => client.setSessionModel(
        sessionId: 'stored-1',
        provider: 'anthropic',
        model: 'claude-sonnet-4',
      ),
    );
    await record(
      'DesktopGatewayClient.setSessionModel (custom endpoint)',
      () => client.setSessionModel(
        sessionId: 'stored-1',
        provider: 'custom',
        model: 'local-model',
      ),
    );
    expect(gateway.calls('config.set'), isEmpty);
    final picks = gateway.calls('session.mutate');
    expect(picks[0]['payload'], {
      'model': 'claude-sonnet-4',
      'provider': 'anthropic',
    });
    expect(picks[1]['payload'], {'model': 'local-model'});
    expect(picks[1]['expected_revision'], 2);
  });

  test('reasoning is read and set for the session', () async {
    await client.ensureSession('stored-1');
    await record(
      'DesktopGatewayClient.getSessionReasoning',
      () => client.getSessionReasoning('stored-1'),
    );
    await record(
      'DesktopGatewayClient.setSessionReasoning',
      () => client.setSessionReasoning(sessionId: 'stored-1', effort: 'high'),
    );
    final mutate = gateway.calls('session.mutate').single;
    expect(mutate['operation'], 'reasoning');
    expect(mutate['payload'], {'effort': 'high'});
  });

  test('a file is attached to the session', () async {
    await client.ensureSession('stored-1');
    await record(
      'DesktopGatewayClient.attachFile',
      () => client.attachFile(
        sessionId: 'stored-1',
        name: 'notes.txt',
        dataUrl: 'data:text/plain;base64,aGk=',
      ),
    );
  });

  test('slash catalogue, completion and exec', () async {
    await client.ensureSession('stored-1');
    await record(
      'DesktopGatewayClient.fetchSlashCommands',
      () => client.fetchSlashCommands(sessionId: 'stored-1'),
    );
    await record(
      'DesktopGatewayClient.fetchSlashCommands (no session)',
      () => client.fetchSlashCommands(),
    );
    await record(
      'DesktopGatewayClient.runSlashCommand',
      () => client.runSlashCommand(sessionId: 'stored-1', command: '/status'),
    );
    await record(
      'ChatScreen complete.slash (requestSessionRpc)',
      () => client.requestSessionRpc('complete.slash', {
        'session_id': 'stored-1',
        'text': '/mo',
      }),
    );
    await record(
      'ChatScreen complete.path (requestSessionRpc)',
      () => client.requestSessionRpc('complete.path', {
        'session_id': 'stored-1',
        'word': '@src/',
      }),
    );
  });

  test('context breakdown and compress', () async {
    await client.ensureSession('stored-1');
    await record(
      'ChatScreen session.context_breakdown (requestSessionRpc)',
      () => client.requestSessionRpc('session.context_breakdown', {
        'session_id': 'stored-1',
      }),
    );
    await record(
      'ChatScreen session.compress (requestSessionRpc)',
      () => client.requestSessionRpc('session.compress', {
        'session_id': 'stored-1',
      }),
    );
    expect(gateway.calls('session.compress'), isEmpty);
    final mutate = gateway.calls('session.mutate').single;
    expect(mutate['operation'], 'compress');
    expect(mutate['payload'], isEmpty);
    expect(mutate['expected_generation'], 1);
  });

  test('an approval the owner publishes is answered by prompt id', () async {
    await client.ensureSession('stored-1');
    gateway.requestApproval('stored-1', 'approval-1');
    await settle();
    final shown = events.where((e) => e.$2.type == 'approval.request').single;
    expect(shown.$1, 'stored-1');
    expect(shown.$2.data['command'], 'rm -rf build');
    final requestId = shown.$2.data['server_request_id'] as String;
    await log.record(
      gateway,
      layout: _layout,
      producer: 'DesktopGatewayClient.respondToApproval',
      settle: const Duration(milliseconds: 60),
      run: () => client.respondToApproval(
        sessionId: 'stored-1',
        choice: 'session',
        serverRequestId: requestId,
      ),
    );
    expect(gateway.calls('approval.respond').single, {
      'session_id': 'stored-1',
      'execution_generation': 1,
      'prompt_id': 'approval-1',
      'choice': 'session',
      'profile': 'work',
    });
  });

  test('a question the owner publishes is answered by prompt id', () async {
    await client.ensureSession('stored-1');
    gateway.requestClarify('stored-1', 'clarify-1');
    await settle();
    final shown = events.where((e) => e.$2.type == 'clarify.request').single;
    final requestId = shown.$2.data['request_id'] as String;
    final questions = shown.$2.data['questions'] as List;
    expect(questions.single['question'], 'Which branch?');
    await record(
      'DesktopGatewayClient.respondToClarify',
      () => client.respondToClarify(
        requestId: requestId,
        answer: 'main',
        questionId: questions.single['qid'] as String,
      ),
    );
    expect(gateway.calls('clarify.lock'), isEmpty);
    final respond = gateway.calls('clarify.respond').single;
    expect(respond['prompt_id'], 'clarify-1');
    expect(respond['answer'], 'main');
    expect(respond['execution_generation'], 1);
  });

  test('a settled prompt takes its card down', () async {
    await client.ensureSession('stored-1');
    gateway.requestApproval('stored-1', 'approval-2');
    await settle();
    gateway.emit(
      'approval.settled',
      sessionId: 'stored-1',
      payload: {'prompt_id': 'approval-2', 'execution_generation': 1},
    );
    await settle();
    expect(events.where((e) => e.$2.type == 'request.cancel'), hasLength(1));
    // Answering it now is refused here: nothing is sent.
    final refusal = await client.rpc('approval.respond', {
      'session_id': 'stored-1',
      'prompt_id': 'approval-2',
      'choice': 'once',
    });
    expect(
      CanonicalWireRefusal.fromData((refusal['error'] as Map)['data'])?.kind,
      CanonicalRefusalKind.promptStale,
    );
    expect(gateway.calls('approval.respond'), isEmpty);
  });

  test('a connection card is answered for the session owner', () async {
    await client.ensureSession('stored-1');
    final row = CatalogRow.parse(const {'kind': 'plugin', 'name': 'spotify'})!;
    for (final (label, answer) in [
      (
        'install',
        CatalogOperation.answer(row, approve: true, env: {'TOKEN': 'x'}),
      ),
      ('skip', CatalogOperation.answer(row, approve: false)),
      ('continue', CatalogOperation.continueAnswer),
    ]) {
      await record(
        'DesktopGatewayClient.respondToConnection ($label)',
        () => client.respondToConnection(
          sessionId: 'stored-1',
          opId: 'op-1',
          result: answer,
        ),
      );
    }
  });

  test('control-plane calls on the same socket', () async {
    await record(
      'DesktopGatewayClient.call (profiles.list)',
      () => client.call('profiles.list', {'include_sessions': false}),
    );
  });

  test('a config key the owner does not serve is refused by name', () async {
    await client.ensureSession('stored-1');
    await log.recordRefused(
      gateway,
      layout: _layout,
      producer: 'DesktopGatewayClient.requestSessionRpc (config.set skin)',
      method: 'config.set',
      kind: CanonicalRefusalKind.setting,
      run: () => client.requestSessionRpc('config.set', {
        'session_id': 'stored-1',
        'key': 'skin',
        'value': 'mono',
      }),
    );
    await log.recordRefused(
      gateway,
      layout: _layout,
      producer:
          'DesktopGatewayClient.requestSessionRpc (config.set fast scope)',
      method: 'config.set',
      kind: CanonicalRefusalKind.setting,
      run: () => client.requestSessionRpc('config.set', {
        'session_id': 'stored-1',
        'key': 'fast',
        'value': 'fast',
        'scope': 'global',
      }),
    );
  });
}
