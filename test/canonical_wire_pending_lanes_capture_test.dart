// Canonical wire audit, requests copied from the code that builds them
// instead of captured from it: the lanes this branch does not contain yet,
// v5/history (ec8af35e), v5/voice (30d239e1) and v5/bots (123050e4), and
// five producers of this base whose flow no capture suite drives.
//
// Their producers are not in this tree, so each request below is the frame
// that lane's code builds, copied from the named method at the named commit,
// and sent through the real socket (`WsClient.send`, so through the
// canonical guard) to the strict gateway. It shows what those producers put
// on the wire once the lanes are merged on top of the guard. When they are,
// the producers themselves are audited by running their suites with the tap
// (tool/canonical_wire_audit.sh) and this file can be deleted.
//
// Out of scope here, as in the task: the truncating `prompt.submit` and the
// `session.rewind` redirect (v5/history, canonical_rewind.dart).
//
// Captures: build/canonical-wire/pending_lanes.json.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/canonical_wire.dart';
import 'package:hermes_android/core/services/ws_client.dart';

import 'support/strict_authority_server.dart';
import 'support/wire_capture.dart';

const _session = 'local-1';
const _history = 'v5/history@ec8af35e';
const _voice = 'v5/voice@30d239e1';
const _bots = 'v5/bots@123050e4';

typedef _Frame = (String producer, String method, Map<String, dynamic> params);

// lib/core/services/session_history.dart. `_rpc` adds the bound profile
// unless `bindProfile: false` (the two mutations).
const _historyFrames = <_Frame>[
  (
    'SessionHistory.branchAtMessage',
    'session.mutate',
    {
      'session_id': _session,
      'request_id': 'req-branch',
      'operation': 'branch',
      'expected_revision': 3,
      'expected_generation': 2,
      'payload': {'through_message_id': 7},
    },
  ),
  (
    'SessionHistory.rewindAtMessage',
    'session.mutate',
    {
      'session_id': _session,
      'request_id': 'req-rewind',
      'operation': 'rewind',
      'expected_revision': 3,
      'expected_generation': 2,
      'payload': {'target_message_id': 7},
    },
  ),
  (
    'SessionHistory.checkpoints',
    'rollback.list',
    {'session_id': _session, 'profile': 'work'},
  ),
  (
    'SessionHistory.checkpointDiff',
    'rollback.diff',
    {'session_id': _session, 'hash': 'abc1234', 'profile': 'work'},
  ),
  (
    'SessionHistory.restoreCheckpoint',
    'rollback.restore',
    {'session_id': _session, 'hash': 'abc1234', 'profile': 'work'},
  ),
  (
    'SessionHistory.restoreCheckpoint (own edits too)',
    'rollback.restore',
    {'session_id': _session, 'hash': 'abc1234', 'all': true, 'profile': 'work'},
  ),
  (
    'SessionHistory.restoreCheckpoint (one file)',
    'rollback.restore',
    {
      'session_id': _session,
      'hash': 'abc1234',
      'file_path': 'lib/a.dart',
      'profile': 'work',
    },
  ),
  (
    'SessionHistory.exportTranscript',
    'session.export',
    {'session_id': _session, 'format': 'md', 'redact': true, 'profile': 'work'},
  ),
  (
    'SessionHistory.foreignSessions',
    'session.foreign.list',
    {'source': 'claude', 'offset': 0, 'limit': 25, 'profile': 'work'},
  ),
  (
    'SessionHistory.foreignPreview',
    'session.foreign.preview',
    {
      'id': '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
      'profile': 'work',
    },
  ),
  (
    'SessionHistory.importForeign',
    'session.foreign.import',
    {
      'id': '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
      'profile': 'work',
    },
  ),
  (
    'SessionHistory.transcript',
    'session.history',
    {'session_id': _session, 'profile': 'work'},
  ),
];

// lib/core/services/gateway_wake_word.dart (`_scopedParams` adds the
// transport's profile) and lib/core/services/voice_live_mode.dart.
const _voiceFrames = <_Frame>[
  (
    'GatewayWakeWord.refreshStatus',
    'wake.status',
    {'profile': 'work', 'surface': 'gui', 'client_capture': true},
  ),
  (
    'GatewayWakeWord.toggle (start)',
    'wake.start',
    {
      'profile': 'work',
      'surface': 'gui',
      'client_capture': true,
      'session_id': _session,
    },
  ),
  ('GatewayWakeWord.toggle (stop)', 'wake.stop', {'profile': 'work'}),
  ('GatewayWakeWord pause', 'wake.pause', {'profile': 'work'}),
  ('GatewayWakeWord resume', 'wake.resume', {'profile': 'work'}),
  (
    'GatewayWakeWord client capture feed',
    'wake.feed',
    {'profile': 'work', 'pcm': 'AAAA', 'sample_rate': 16000},
  ),
  (
    'VoiceLiveMode.setMode',
    'config.set',
    {'key': 'voice.voice_chat_mode', 'profile': 'work', 'value': 'gpt-live'},
  ),
];

// lib/core/services/remote_bots.dart. `_rpcBot` adds the bot's profile,
// `_rpcLaunch` none.
const _botFrames = <_Frame>[
  (
    'RemoteBots.findCanonicalChat',
    'session.list',
    {
      'title': 'Bot Chat',
      'limit': 200,
      'include_hidden': true,
      'profile': 'work',
    },
  ),
  (
    'RemoteBots.botRoutines',
    'cron.manage',
    {'action': 'list', 'include_disabled': true, 'profile': 'work'},
  ),
  (
    'RemoteBots.botRoutineAdd',
    'cron.manage',
    {
      'action': 'add',
      'name': '[bot:work] Daily',
      'schedule': '0 9 * * *',
      'prompt': 'Summarise the day',
      'repeat': 3,
      'continuity': true,
      'deliver': 'bot-chat',
      'profile': 'work',
    },
  ),
  (
    'RemoteBots.botRoutinePause',
    'cron.manage',
    {'action': 'pause', 'name': 'job-1', 'profile': 'work'},
  ),
  (
    'RemoteBots.botRoutineResume',
    'cron.manage',
    {'action': 'resume', 'name': 'job-1', 'profile': 'work'},
  ),
  (
    'RemoteBots.botRoutineRemove',
    'cron.manage',
    {'action': 'remove', 'name': 'job-1', 'profile': 'work'},
  ),
  ('RemoteBots.roomCapabilities', 'groups.capabilities', {}),
  (
    'RemoteBots.roomList',
    'groups.list',
    {'include_disbanded': false, 'limit': 50, 'offset': 0},
  ),
  ('RemoteBots.roomState', 'groups.state', {'room_id': 'room-1'}),
  (
    'RemoteBots.roomCreate',
    'groups.create',
    {
      'room_id': 'room-1',
      'name': 'Team',
      'members': [
        {
          'member_id': 'm1',
          'profile': 'work',
          'handle': 'work',
          'display_name': 'Work',
        },
      ],
    },
  ),
  (
    'RemoteBots.roomRename',
    'groups.rename',
    {'room_id': 'room-1', 'event_id': 'evt-1', 'name': 'Team 2'},
  ),
  (
    'RemoteBots.roomSend',
    'groups.send',
    {
      'room_id': 'room-1',
      'event_id': 'evt-2',
      'payload': {'text': 'hi'},
    },
  ),
  (
    'RemoteBots.roomContext',
    'groups.context',
    {
      'room_id': 'room-1',
      'event_id': 'evt-3',
      'purpose': 'Ship',
      'notes': 'Be brief',
      'routing': 'everyone',
    },
  ),
  (
    'RemoteBots.roomLog',
    'groups.log',
    {'room_id': 'room-1', 'since_seq': 4, 'limit': 100},
  ),
  ('RemoteBots.roomStop', 'groups.stop', {'room_id': 'room-1'}),
  ('RemoteBots.displayStatus', 'display.status', {'profile': 'work'}),
  ('RemoteBots.displayStart', 'display.start', {'profile': 'work'}),
  (
    'RemoteBots.displayStop',
    'display.stop',
    {'force': true, 'profile': 'work'},
  ),
  (
    'RemoteBots.displayObserve',
    'display.observe',
    {'viewer_id': 'viewer-1', 'profile': 'work'},
  ),
  ('RemoteBots.displayThumbnail', 'display.thumbnail', {'profile': 'work'}),
  ('RemoteBots.displayInstall', 'display.install', {'profile': 'work'}),
  (
    'RemoteBots.displayLeaseAcquire',
    'display.lease.acquire',
    {'viewer_id': 'viewer-1', 'reason': 'look', 'profile': 'work'},
  ),
  (
    'RemoteBots.displayLeaseRelease',
    'display.lease.release',
    {'viewer_id': 'viewer-1', 'force': true, 'profile': 'work'},
  ),
  (
    'RemoteBots.displaySwitchSandboxImage',
    'display.switchSandboxImage',
    {'approve': true, 'profile': 'work'},
  ),
];

// Producers of this base whose flow is not driven end to end by a capture
// suite: the request below is the frame the named code builds.
const _base = 'this base';
const _undrivenFrames = <_Frame>[
  (
    // lib/core/services/ws_client.dart respondToClarify(lockAnswer: true),
    // for the owner's batch `clarify` server request (not a projected
    // prompt, which the guard answers with clarify.respond by prompt id).
    'WsClient.respondToClarify (batch lock)',
    'clarify.lock',
    {'request_id': 'srq-batch-1', 'answer': 'main', 'question_id': 'q1'},
  ),
  (
    // lib/nextgen/data/chat_controller.dart runCommand, the dispatch stage
    // after slash.exec refused.
    'NgChatController.runCommand (dispatch stage)',
    'command.dispatch',
    {'session_id': _session, 'name': 'goal', 'arg': 'ship it'},
  ),
  (
    // lib/nextgen/data/chat_controller.dart _detach.
    'NgChatController._detach',
    'image.detach',
    {'session_id': _session, 'path': '/tmp/a.png'},
  ),
  (
    // lib/core/services/remote_profile_admin.dart ProfileRoster.create.
    'ProfileRoster.create',
    'profiles.create',
    {
      'name': 'ops',
      'clone_from': 'work',
      'clone_all': false,
      'clone_channels': false,
      'no_alias': true,
      'mirror_credentials': false,
      'share_auth': false,
      'profile': 'work',
    },
  ),
  (
    // lib/core/services/workspace_discovery.dart discoverRepositories.
    'WorkspaceTarget.discoverRepositories',
    'projects.discover_repos',
    {'scan': true, 'profile': 'work'},
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final log = WireCaptureLog('pending_lanes');
  late HttpOverrides? previous;
  late StrictAuthorityGateway gateway;
  late WsClient socket;

  setUp(() async {
    previous = HttpOverrides.current;
    HttpOverrides.global = null;
    gateway = await StrictAuthorityGateway.start();
    socket = await gateway.connect(profile: 'work');
  });

  tearDown(() async {
    socket.close();
    await gateway.close();
    HttpOverrides.global = previous;
  });

  tearDownAll(log.write);

  Future<void> sendAll(String lane, List<_Frame> frames) async {
    for (final (producer, method, params) in frames) {
      await log.record(
        gateway,
        layout: 'shared',
        producer: '$lane $producer (frame copied from the lane)',
        run: () => socket.send(method, params, includeProfile: false),
      );
    }
  }

  test('this base: five producers whose flow no capture suite drives', () {
    return sendAll(_base, _undrivenFrames);
  });

  test('v5/history: checkpoints, export, foreign sessions, fenced edits', () {
    return sendAll(_history, _historyFrames);
  });

  test('v5/voice: wake word and the live voice mode', () {
    return sendAll(_voice, _voiceFrames);
  });

  test('v5/bots: canonical chat, routines, rooms and Bot Desktop', () {
    return sendAll(_bots, _botFrames);
  });

  test(
    'v5/bots: a relay delivery loses its legacy sender fields in the guard',
    () async {
      await log.record(
        gateway,
        layout: 'shared',
        producer: '$_bots RemoteBots.botRelayDeliver (frame copied)',
        run: () => socket.send('bot_relay.deliver', const {
          'id': 'delivery-1',
          'profile': 'work',
          'message': 'Message from 🤖 Sam (@sam): hello',
          'from_profile': 'default',
          'from_handle': 'sam',
          'from_connection': 'conn-1',
        }, includeProfile: false),
      );
      final sent = gateway.calls('bot_relay.deliver').single;
      expect(sent.keys.where((key) => key.startsWith('from_')), isEmpty);
      expect(sent['author'], {
        'id': 'bot:conn-1/default',
        'name': 'sam',
        'is_bot': true,
      });
      expect(sent['message'], 'Message from 🤖 Sam (@sam@conn-1): hello');
    },
  );

  test('v5/voice: the wake capture preference has no canonical form', () async {
    // GatewayWakeWord.setCapturePreference writes `wake_word.capture`
    // with config.set. The owner serves no such key (Desktop has no such
    // control): the guard refuses it by name, so the voice lane must not
    // offer the control on a session-authority socket.
    await log.recordRefused(
      gateway,
      layout: 'shared',
      producer: '$_voice GatewayWakeWord.setCapturePreference (frame copied)',
      method: 'config.set',
      kind: CanonicalRefusalKind.setting,
      run: () async {
        final answer = await socket.send('config.set', const {
          'profile': 'work',
          'key': 'wake_word.capture',
          'value': 'client',
        }, includeProfile: false);
        // The lane's transports (DesktopGatewayClient.call and
        // NextGenGateway.call) raise an error answer as this.
        final error = answer['error'];
        if (error is Map) {
          throw JsonRpcError.fromGateway(
            'config.set',
            error,
            fallbackMessage: 'refused',
          );
        }
      },
    );
    expect(canonicalConfigAvailable('wake_word.capture'), isFalse);
    expect(canonicalConfigAvailable('voice.voice_chat_mode'), isTrue);
  });
}
