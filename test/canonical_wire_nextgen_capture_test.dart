// Canonical wire audit, NextGen layout: every request a NextGen chat
// (NgChatController over the real NextGenGateway socket) sends on a
// session-authority (Hermes 0.23+) gateway, driven end to end against the
// strict gateway.
//
// The recorded frames are written to build/canonical-wire/nextgen.json and
// validated against the gateway's own pydantic models by
// tool/canonical_wire_check.py.
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/composer_commands.dart';
import 'package:hermes_android/core/composer/reference_completion.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/render/catalog_install.dart';
import 'package:hermes_android/core/services/canonical_wire.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/data/session_control.dart';
import 'package:hermes_android/nextgen/data/slash_exec.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/strict_authority_server.dart';
import 'support/wire_capture.dart';

const _layout = 'nextgen';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final log = WireCaptureLog('nextgen');
  late HttpOverrides? previous;
  late StrictAuthorityGateway gateway;
  late NextGenGateway ng;
  final chats = <NgChatController>[];

  setUp(() async {
    previous = HttpOverrides.current;
    HttpOverrides.global = null;
    SharedPreferences.setMockInitialValues(<String, Object>{});
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
    gateway = await StrictAuthorityGateway.start(
      http: (request) {
        final path = request.uri.path;
        if (path == '/api/model/info') {
          return (200, {'model': 'gpt-test', 'provider': 'openai'});
        }
        if (path.endsWith('/messages')) {
          return (200, {'messages': const <Object>[]});
        }
        return null;
      },
    );
    gateway.handler = (method, params) {
      if (method == 'prompt.submit') {
        final sessionId = params['session_id'] as String;
        scheduleMicrotask(
          () => gateway.emit(
            'message.complete',
            sessionId: sessionId,
            payload: {'text': 'done'},
            envelope: {'execution_generation': gateway.generationOf(sessionId)},
          ),
        );
      }
      if (method == 'handoff.request') return {'queued': true};
      if (method == 'handoff.state') return {'state': 'pending'};
      if (method == 'handoff.fail') return {'state': 'failed'};
      if (method == 'session.control' || method == 'session.control.read') {
        return {
          'control': {'revision': 1},
        };
      }
      return null;
    };
    ng = NextGenGateway(gateway.connection(profile: 'work'));
    ng.start();
    await ng.connected();
  });

  tearDown(() async {
    for (final chat in chats) {
      chat.dispose();
    }
    chats.clear();
    ng.dispose();
    await gateway.close();
    HermesSignInVault.resetForTesting();
    HttpOverrides.global = previous;
  });

  tearDownAll(log.write);

  Future<T> record<T>(String producer, Future<T> Function() run) =>
      log.record(gateway, layout: _layout, producer: producer, run: run);

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 60));

  Future<NgChatController> opened([String id = 'stored-1']) async {
    final chat = NgChatController(ng, sessionId: id);
    chats.add(chat);
    await chat.open();
    return chat;
  }

  test('a stored chat is attached with the canonical resume', () async {
    final chat = NgChatController(ng, sessionId: 'stored-1');
    chats.add(chat);
    await record('NgChatController.open', chat.open);
    final resume = gateway.calls('session.resume').single;
    expect(resume.containsKey('inline_images'), isFalse);
    expect(chat.runtimeId, 'stored-1');
  });

  test('a new chat is created in its folder, then admitted', () async {
    final chat = NgChatController(ng);
    chats.add(chat);
    chat.startIn('/work/app');
    await record(
      'NgChatController.send (new chat)',
      () => chat.send('Hello', submissionId: 'sub-new'),
    );
    final create = gateway.calls('session.create').single;
    expect(create['source'], 'gui');
    expect(create['cwd'], '/work/app');
    expect(create['cwd_explicit'], isTrue);
    expect(gateway.calls('prompt.submit').single['submission_id'], 'sub-new');
  });

  test('a prompt, a steer and a stop on an open chat', () async {
    final chat = await opened();
    await record(
      'NgChatController.send',
      () => chat.send('Next step', submissionId: 'sub-2'),
    );
    await record('NgChatController.steer', () => chat.steer('Be brief'));
    await record('NgChatController.stop', chat.stop);
    expect(gateway.calls('session.steer').single['execution_generation'], 1);
    expect(
      gateway.calls('session.interrupt').single['execution_generation'],
      1,
    );
  });

  test(
    'an image is staged and named on the prompt; a file is attached',
    () async {
      final chat = await opened();
      final directory = await Directory.systemTemp.createTemp('wire-capture');
      addTearDown(() => directory.delete(recursive: true));
      final png = File('${directory.path}/shot.png')
        ..writeAsBytesSync(const [137, 80, 78, 71, 13, 10, 26, 10]);
      final text = File('${directory.path}/notes.txt')..writeAsStringSync('hi');
      await record(
        'NgChatController.send (image + file)',
        () => chat.send(
          'Look',
          submissionId: 'sub-3',
          attachments: [
            AttachmentDraft(
              id: 'a1',
              cachedPath: png.path,
              name: 'shot.png',
              byteLength: 8,
              mediaType: 'image/png',
              kind: AttachmentDraftKind.image,
            ),
            AttachmentDraft(
              id: 'a2',
              cachedPath: text.path,
              name: 'notes.txt',
              byteLength: 2,
              mediaType: 'text/plain',
              kind: AttachmentDraftKind.genericFile,
            ),
          ],
        ),
      );
      expect(gateway.calls('image.attach_bytes'), hasLength(1));
      expect(gateway.calls('file.attach'), hasLength(1));
      expect(gateway.calls('prompt.submit').single['attachments'], isNotEmpty);
    },
  );

  test('a model pick and a reasoning level are fenced mutations', () async {
    final chat = await opened();
    await record(
      'NgChatController.setModel',
      () => chat.setModel(provider: 'anthropic', model: 'claude-sonnet-4'),
    );
    await record(
      'NgChatController.setReasoning',
      () => chat.setReasoning('high'),
    );
    expect(gateway.calls('config.set'), isEmpty);
    final mutations = gateway.calls('session.mutate');
    expect(mutations.map((m) => m['operation']), ['model', 'reasoning']);
    expect(mutations[1]['payload'], {'effort': 'high'});
    expect(mutations[1]['expected_revision'], 2);
  });

  test('slash commands run on the session', () async {
    final chat = await opened();
    await record(
      'NgChatController.runCommand',
      () => chat.runCommand(const NgSlashLine('status', '')),
    );
    await record(
      'NextGen slash catalogue (commands.catalog)',
      () => ng.call('commands.catalog', {'session_id': 'stored-1'}),
    );
    await record(
      'NgChatView complete.slash',
      () =>
          ng.call('complete.slash', {'text': '/mo', 'session_id': 'stored-1'}),
    );
    await record(
      'NgChatView complete.path',
      () => ng.call(
        'complete.path',
        pathCompletionParams(query: '@src/', sessionId: 'stored-1'),
      ),
    );
  });

  test('side question, background task and handoff', () async {
    final chat = await opened();
    for (final line in const [
      NgSlashLine('btw', 'what changed?'),
      NgSlashLine('background', 'run the tests'),
      NgSlashLine('handoff', 'telegram'),
    ]) {
      await record(
        'NgChatController.runDedicated (/${line.name})',
        () => chat.runDedicated(line),
      );
    }
    await record(
      'watchHandoff (handoff.state, handoff.fail)',
      () => watchHandoff(
        rpc: ng.call,
        sessionId: 'stored-1',
        timeoutMessage: ngL.composer_handoff_timeout,
        alive: () => true,
        interval: const Duration(milliseconds: 10),
        limit: const Duration(milliseconds: 40),
      ),
    );
    expect(gateway.calls('prompt.btw').single['text'], 'what changed?');
    expect(gateway.calls('handoff.request').single['platform'], 'telegram');
    expect(gateway.calls('handoff.fail'), hasLength(1));
  });

  test('context breakdown and compress', () async {
    await opened();
    await record(
      'NgChatView session.context_breakdown',
      () => ng.call('session.context_breakdown', {'session_id': 'stored-1'}),
    );
    await record(
      'NgChatView session.compress',
      () => ng.call('session.compress', {'session_id': 'stored-1'}),
    );
    expect(gateway.calls('session.compress'), isEmpty);
    final mutate = gateway.calls('session.mutate').single;
    expect(mutate['operation'], 'compress');
    expect(mutate['expected_generation'], 1);
  });

  test('goal, loop and sub-goal controls', () async {
    final chat = await opened();
    await record('NgChatController.refreshControl', chat.refreshControl);
    for (final action in NgControlAction.values) {
      await record(
        'NgChatController.runControl (${action.wire})',
        () => chat.runControl(
          action,
          text: action == NgControlAction.subgoalAdd ? 'ship it' : null,
          index: action == NgControlAction.subgoalRemove ? 1 : null,
        ),
      );
    }
    expect(
      gateway.calls('session.control'),
      hasLength(NgControlAction.values.length),
    );
  });

  test('subagents are listed and stopped', () async {
    final chat = await opened();
    await record('NgChatController.refreshSubagents', chat.refreshSubagents);
    await record(
      'NgChatController.stopSubagent',
      () => ng.call('subagent.interrupt', {
        'session_id': 'stored-1',
        'subagent_id': 'sub-agent-1',
      }),
    );
  });

  test('an approval the owner publishes is shown and answered', () async {
    final chat = await opened();
    gateway.requestApproval('stored-1', 'approval-1');
    await settle();
    expect(chat.request?.kind, NgRequestKind.approval);
    expect(chat.request?.command, 'rm -rf build');
    expect(ng.needsYou, contains('stored-1'));
    await log.record(
      gateway,
      layout: _layout,
      producer: 'NgChatController.answerApproval',
      settle: const Duration(milliseconds: 60),
      run: () async => expect(chat.answerApproval('once'), isTrue),
    );
    expect(gateway.calls('approval.respond').single, {
      'session_id': 'stored-1',
      'execution_generation': 1,
      'prompt_id': 'approval-1',
      'choice': 'once',
      'profile': 'work',
    });
  });

  test('a question the owner publishes is shown and answered', () async {
    final chat = await opened();
    gateway.requestClarify('stored-1', 'clarify-1');
    await settle();
    expect(chat.request?.kind, NgRequestKind.clarify);
    expect(chat.request?.questions.single.question, 'Which branch?');
    await log.record(
      gateway,
      layout: _layout,
      producer: 'NgChatController.answerClarify',
      settle: const Duration(milliseconds: 60),
      run: () async => expect(
        chat.answerClarify([
          ['dev'],
        ]),
        isTrue,
      ),
    );
    final respond = gateway.calls('clarify.respond').single;
    expect(respond['prompt_id'], 'clarify-1');
    expect(respond['answer'], 'dev');
  });

  test('a prompt open at attach is shown from the snapshot', () async {
    gateway.handler = (method, params) => method == 'session.resume'
        ? gateway.snapshot(
            'stored-1',
            running: true,
            prompts: [
              {
                'kind': 'approval',
                'prompt_id': 'approval-9',
                'execution_generation': 1,
                'command': 'git push',
                'description': 'Push the branch',
                'choices': ['once', 'deny'],
              },
            ],
          )
        : null;
    final chat = await opened();
    await settle();
    expect(chat.request?.command, 'git push');
    await log.record(
      gateway,
      layout: _layout,
      producer: 'NgChatController.answerApproval (replayed)',
      settle: const Duration(milliseconds: 60),
      run: () async => expect(chat.answerApproval('deny'), isTrue),
    );
    expect(gateway.calls('approval.respond').single['prompt_id'], 'approval-9');
  });

  test('a prompt settled elsewhere takes its card down', () async {
    final chat = await opened();
    gateway.requestApproval('stored-1', 'approval-2');
    await settle();
    expect(chat.request, isNotNull);
    gateway.emit(
      'approval.settled',
      sessionId: 'stored-1',
      payload: {'prompt_id': 'approval-2', 'execution_generation': 1},
    );
    await settle();
    expect(chat.request, isNull);
    expect(ng.needsYou, isEmpty);
    expect(gateway.calls('approval.respond'), isEmpty);
  });

  test('a catalog card is answered for the session owner', () async {
    final chat = await opened();
    gateway.emit(
      'connection.request',
      sessionId: 'stored-1',
      payload: {
        'op_id': 'op-1',
        'seq': 1,
        'targets': [
          {'kind': 'plugin', 'name': 'spotify', 'state': 'pending'},
        ],
      },
    );
    await settle();
    final operation = chat.catalog!;
    await record(
      'NgChatController.respondCatalog',
      () => chat.respondCatalog(
        operation,
        CatalogOperation.answer(operation.rows.single, approve: true),
      ),
    );
  });

  test('replay after a reconnect names the canonical cursor', () async {
    await opened();
    await record(
      'NgChatController resync (session.events.since)',
      () => ng.call('session.events.since', {
        'session_id': 'stored-1',
        'replay_epoch': 'strict-epoch',
        'last_sequence': 4,
      }),
    );
  });

  test('a session-owned connector verb the owner does not serve', () async {
    await opened();
    await log.recordRefused(
      gateway,
      layout: _layout,
      producer: 'NextGenGateway.call (connectors.accounts, session owner)',
      method: 'connectors.accounts',
      kind: CanonicalRefusalKind.method,
      run: () => ng.call('connectors.accounts', {
        'owner': {'type': 'session', 'session_id': 'stored-1'},
      }),
    );
  });
}
