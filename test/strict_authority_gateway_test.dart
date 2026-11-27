// The strict authority fake must refuse what the pinned gateway refuses and
// accept what it accepts: every authority-mode suite trusts it.
//
// Each row below is checked here against the fake, and written to
// build/canonical-wire/strict_fake_corpus.json with the fake's verdict.
// tool/canonical_wire_check.py then checks every row against the gateway's
// own dispatcher and pydantic models and reports any disagreement.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/strict_authority_gateway.dart';

typedef _Row = (String label, String method, Map<String, dynamic> params);

const _session = 'local-1';

/// Frames the gateway accepts on an authority socket.
const _accepted = <_Row>[
  ('create', 'session.create', {'source': 'gui', 'cwd': '/w', 'profile': 'p'}),
  (
    'resume',
    'session.resume',
    {'session_id': _session, 'omit_messages': true, 'source': 'desktop'},
  ),
  ('info', 'session.info', {'session_id': _session, 'profile': 'work'}),
  (
    'rename',
    'session.mutate',
    {
      'session_id': _session,
      'request_id': 'r1',
      'expected_revision': 3,
      'operation': 'rename',
      'payload': {'title': 'Plan'},
    },
  ),
  (
    'model pick',
    'session.mutate',
    {
      'session_id': _session,
      'request_id': 'r2',
      'expected_revision': 3,
      'expected_generation': 2,
      'operation': 'model',
      'payload': {'model': 'm', 'provider': 'p'},
    },
  ),
  (
    'submit',
    'prompt.submit',
    {'session_id': _session, 'text': 'hi', 'submission_id': 's1'},
  ),
  (
    'approval',
    'approval.respond',
    {
      'session_id': _session,
      'execution_generation': 2,
      'prompt_id': 'p1',
      'choice': 'once',
    },
  ),
  (
    'clarify',
    'clarify.respond',
    {
      'session_id': _session,
      'execution_generation': 2,
      'prompt_id': 'p1',
      'answer': 'yes',
    },
  ),
  (
    'steer',
    'session.steer',
    {'session_id': _session, 'execution_generation': 2, 'text': 'shorter'},
  ),
  (
    'reasoning',
    'config.set',
    {'session_id': _session, 'key': 'reasoning', 'value': 'high'},
  ),
  (
    'global yolo',
    'config.set',
    {'session_id': _session, 'key': 'yolo', 'value': '1', 'scope': 'global'},
  ),
  (
    'voice mode',
    'config.set',
    {'key': 'voice.voice_chat_mode', 'value': 'hands_free'},
  ),
  (
    'attach',
    'file.attach',
    {'session_id': _session, 'name': 'a.txt', 'path': '', 'data_url': 'd'},
  ),
  ('btw', 'prompt.btw', {'session_id': _session, 'text': 'why?'}),
  ('handoff', 'handoff.request', {'session_id': _session, 'platform': 'tg'}),
  (
    'control',
    'session.control',
    {
      'session_id': _session,
      'action': 'subgoal.add',
      'args': {'text': 'ship'},
    },
  ),
  (
    'account connector',
    'connectors.connect',
    {
      'connectors': ['gmail'],
      'owner': {'type': 'account'},
      'reconnect': false,
    },
  ),
  (
    'activity',
    'client.activity',
    {
      'sessions': [_session],
      'idle_seconds': 0,
      'basis': 'system',
    },
  ),
  ('rollback list', 'rollback.list', {'session_id': _session}),
  (
    'export',
    'session.export',
    {'session_id': _session, 'format': 'md', 'redact': true},
  ),
];

/// Frames the gateway refuses on an authority socket.
const _refused = <_Row>[
  ('legacy create source', 'session.create', {'source': 'desktop'}),
  (
    'legacy resume key',
    'session.resume',
    {'session_id': _session, 'inline_images': false},
  ),
  (
    'legacy rename verb',
    'session.title',
    {'session_id': _session, 'title': 't'},
  ),
  ('legacy branch verb', 'session.branch', {'session_id': _session}),
  ('legacy compress verb', 'session.compress', {'session_id': _session}),
  ('legacy usage verb', 'session.usage', {'session_id': _session}),
  (
    'legacy approval',
    'approval.respond',
    {'session_id': _session, 'choice': 'once'},
  ),
  ('legacy clarify', 'clarify.respond', {'request_id': 'r', 'answer': 'a'}),
  (
    'model as a config write',
    'config.set',
    {'session_id': _session, 'key': 'model', 'value': 'm --provider p'},
  ),
  (
    'scope on a key without one',
    'config.set',
    {'session_id': _session, 'key': 'fast', 'value': 'fast', 'scope': 'global'},
  ),
  ('unserved config key', 'config.set', {'key': 'repo_scan', 'value': 'on'}),
  (
    'steer without a generation',
    'session.steer',
    {'session_id': _session, 'text': 'shorter'},
  ),
  (
    'submit without an identity',
    'prompt.submit',
    {'session_id': _session, 'text': 'hi'},
  ),
  (
    'submit with truncation keys',
    'prompt.submit',
    {
      'session_id': _session,
      'text': 'hi',
      'submission_id': 's',
      'confirm_truncate': true,
      'truncate_before_row_id': 4,
    },
  ),
  (
    'model pick without a generation',
    'session.mutate',
    {
      'session_id': _session,
      'request_id': 'r',
      'expected_revision': 3,
      'operation': 'model',
      'payload': {'model': 'm'},
    },
  ),
  (
    'rename with a stray key',
    'session.mutate',
    {
      'session_id': _session,
      'request_id': 'r',
      'expected_revision': 3,
      'operation': 'rename',
      'payload': {'title': 't', 'name': 't'},
    },
  ),
  (
    'attach with fixture-only keys',
    'file.attach',
    {'session_id': _session, 'name': 'a', 'source_channel': 'x'},
  ),
  (
    'unknown control action',
    'session.control',
    {'session_id': _session, 'action': 'goal.start'},
  ),
  (
    'legacy fallback with an unknown key',
    'client.activity',
    {
      'sessions': [_session],
      'idle_seconds': 0,
      'basis': 'system',
      'profile': 'work',
    },
  ),
  ('a verb nobody serves', 'sudo.respond', {'request_id': 'r'}),
];

void main() {
  for (final (label, method, params) in _accepted) {
    test('accepts: $label ($method)', () {
      expect(strictAuthorityRefusal(method, params), isNull);
    });
  }

  for (final (label, method, params) in _refused) {
    test('refuses: $label ($method)', () {
      expect(strictAuthorityRefusal(method, params), isNotNull);
    });
  }

  test('a verb the authority does not serve answers -32601', () {
    expect(
      strictAuthorityRefusal('session.title', const {
        'session_id': _session,
        'title': 't',
      })?['code'],
      -32601,
    );
  });

  test('a canonical contract names the refused fields with 4001', () {
    final refusal = strictAuthorityRefusal('session.resume', const {
      'session_id': _session,
      'inline_images': false,
    })!;
    expect(refusal['code'], 4001);
    expect((refusal['data'] as Map)['fields'], ['inline_images']);
  });

  test('the legacy sidecar refuses an unknown key with 4000', () {
    expect(
      strictAuthorityRefusal('client.activity', const {
        'sessions': <String>[],
        'idle_seconds': 0,
        'basis': 'page',
        'profile': 'work',
      })?['code'],
      4000,
    );
  });

  test('the corpus is written for the gateway-side parity check', () {
    final directory = Directory(
      Platform.environment['ARES_WIRE_CAPTURE_DIR'] ?? 'build/canonical-wire',
    )..createSync(recursive: true);
    Map<String, dynamic> row(_Row source, {required bool refused}) => {
      'id': source.$1,
      'layout': 'corpus',
      'producer': 'strict fake corpus: ${source.$1}',
      'socket': 'authority',
      'method': source.$2,
      'params': source.$3,
      if (refused) 'expect': 'refused',
      'strict_fake': strictAuthorityRefusal(source.$2, source.$3) == null
          ? 'accepted'
          : 'refused',
    };

    File('${directory.path}/strict_fake_corpus.json').writeAsStringSync(
      '${const JsonEncoder.withIndent(' ').convert({
        'pin': canonicalWirePin,
        'captures': [for (final source in _accepted) row(source, refused: false), for (final source in _refused) row(source, refused: true)],
      })}\n',
    );
  });
}
