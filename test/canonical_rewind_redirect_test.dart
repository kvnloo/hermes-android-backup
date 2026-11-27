// The canonical rewind redirect at the transport layer (WsClient.send), as
// Hermes Desktop's `canonicalRedirect` (b7ee21c14e
// apps/desktop/src/api/client.ts:509-520 and canonical-protocol.ts:155-185).
//
// A 0.23+ session authority answers `prompt.submit` through
// `CanonicalSubmitParams`, a closed key set: any truncation key is refused
// with `4001 invalid_params` (review probes classic_edit_prompt_submit.json
// and nextgen_edit_prompt_submit.json, checked by
// py_canonical_submit_check.py). Every truncating producer therefore goes
// out as the owner's rewind (a fenced `session.mutate`, Desktop's
// `session.rewind`) followed by ONE plain `prompt.submit`. The legacy
// sidecar keeps its keys.
//
// The real WsClient runs on FakeAuthorityGateway, which enforces the
// gateway's contracts.
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/regenerate.dart';
import 'package:hermes_android/core/history/canonical_rewind.dart';
import 'package:hermes_android/core/history/rewind_submit.dart'
    hide truncateSubmitParams;
import 'package:hermes_android/core/services/ws_client.dart';

import 'support/fake_authority_gateway.dart';

/// What the review probes captured Ares sending for a confirmed Edit.
const _probeEditParams = <String, Object>{
  'confirm_truncate': true,
  'truncate_before_row_id': 7,
  'confirm_deep_truncate': true,
  'confirm_empty_truncate': true,
};

Future<void> _submit(
  WsClient client,
  FakeAuthorityGateway gateway,
  Map<String, Object?> extra, {
  String text = 'Edited probe',
}) => client.submitPrompt(
  text,
  sessionId: gateway.sessionId,
  onEvent: (_) {},
  extraParams: extra,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('splitRewindSubmit (Desktop canonical-protocol.ts:165-180)', () {
    test('a submit without truncation keys is not split', () {
      expect(splitRewindSubmit({'session_id': 's', 'text': 'hi'}), isNull);
    });

    test('a durable row becomes a rewind and a plain submit', () {
      final split = splitRewindSubmit({
        'session_id': 's',
        'text': 'hi',
        'submission_id': 'sub',
        'profile': 'work',
        ..._probeEditParams,
        'rebind_survivor_row_ids': [3],
      })!;
      expect(split.rewind, {
        'session_id': 's',
        'target_message_id': 7,
        'profile': 'work',
      });
      expect(split.submit, {
        'session_id': 's',
        'text': 'hi',
        'submission_id': 'sub',
        'profile': 'work',
      });
    });

    test('a message id or an ordinal without a durable row is refused', () {
      for (final params in [
        {'confirm_truncate': true, 'truncate_before_user_ordinal': 0},
        {'confirm_truncate': true, 'truncate_before_message_id': 'm-1'},
        {'confirm_truncate': true, 'truncate_before_row_id': 0},
        {'confirm_truncate': true, 'truncate_before_row_id': '7'},
      ]) {
        expect(
          () => splitRewindSubmit({'session_id': 's', 'text': 'x', ...params}),
          throwsA(isA<RewindTargetUnsaved>()),
          reason: '$params',
        );
      }
      expect(
        const RewindTargetUnsaved().toString(),
        'This message is not saved yet; wait for it to settle, then edit it '
        'again',
      );
    });

    test('bare confirmation flags are dropped: a plain submit, no rewind', () {
      final split = splitRewindSubmit({
        'session_id': 's',
        'text': 'x',
        'confirm_empty_truncate': true,
      })!;
      expect(split.rewind, isNull);
      expect(split.submit, {'session_id': 's', 'text': 'x'});
    });
  });

  group('session authority socket', () {
    test('the gateway refuses the legacy truncation keys with 4001 (the '
        'review finding, on the fake)', () async {
      final gateway = FakeAuthorityGateway();
      final answer = gateway.dial(Uri.parse('ws://x'));
      addTearDown(answer.sink.close);
      final frames = <Object?>[];
      answer.stream.listen(frames.add);
      answer.sink.add(
        '{"jsonrpc":"2.0","id":1,"method":"prompt.submit","params":'
        '{"session_id":"authority-session","text":"Edited probe",'
        '"submission_id":"probe-submission","confirm_truncate":true,'
        '"truncate_before_row_id":7,"confirm_deep_truncate":true,'
        '"confirm_empty_truncate":true}}',
      );
      await pumpEventQueue();
      final refusal = gateway.refusals.single;
      expect(refusal.method, 'prompt.submit');
      expect(refusal.error['code'], 4001);
      expect(refusal.error['message'], 'invalid_params');
      expect(
        (refusal.error['data'] as Map)['fields'],
        unorderedEquals([
          'confirm_truncate',
          'truncate_before_row_id',
          'confirm_deep_truncate',
          'confirm_empty_truncate',
        ]),
      );
      expect(gateway.rows, hasLength(4), reason: 'nothing was cut or sent');
    });

    test('a truncating submit is the fenced rewind, then ONE plain '
        'prompt.submit', () async {
      final gateway = FakeAuthorityGateway();
      final client = await gateway.connect();
      await _submit(client, gateway, _probeEditParams);

      expect(gateway.refusals, isEmpty);
      expect(gateway.writes, ['session.mutate', 'prompt.submit']);
      expect(gateway.calls('session.rewind'), isEmpty);
      final cut = gateway.calls('session.mutate').single.params;
      expect(cut.keys.toSet(), {
        'session_id',
        'request_id',
        'expected_revision',
        'expected_generation',
        'operation',
        'payload',
        'profile',
      });
      expect(cut['session_id'], gateway.sessionId);
      expect(cut['operation'], 'rewind');
      expect(cut['payload'], {'target_message_id': 7});
      expect(cut['expected_revision'], 4);
      expect(cut['expected_generation'], 2);
      expect(cut['profile'], 'field-work');
      final submit = gateway.calls('prompt.submit').single.params;
      expect(submit.keys.toSet().difference(canonicalSubmitKeys), isEmpty);
      for (final key in truncateKeys) {
        expect(submit.containsKey(key), isFalse, reason: key);
      }
      expect(submit['text'], 'Edited probe');
      expect(submit['submission_id'], isA<String>());
      // The owner cut at row 7 and admitted the edited turn.
      expect(
        [for (final row in gateway.rows) row['text']],
        ['Edited probe', 'Fresh reply'],
      );
    });

    test('every producer builder goes out as rewind + plain submit', () async {
      final producers = <String, Map<String, Object?>>{
        'composer Regenerate / Retry (regenerateSubmitParams)':
            regenerateSubmitParams(9),
        'truncateSubmitParams (row)': truncateSubmitParams(rowId: 9),
        'history Edit / Restore (buildRewindParams, deep cut)':
            buildRewindParams(
              await RewindPlan.resolve(
                requestGateway: (_, _) async => null,
                sessionId: 's',
                truncateOrdinal: 1,
                truncateMessageId: null,
                truncateRowId: 9,
                sourceText: 'Another question',
              ),
              confirmDeepTruncate: true,
              rebindSurvivorRowIds: const [7],
            ),
      };
      for (final entry in producers.entries) {
        final gateway = FakeAuthorityGateway();
        final client = await gateway.connect();
        await _submit(client, gateway, entry.value);
        expect(gateway.refusals, isEmpty, reason: entry.key);
        expect(gateway.writes, [
          'session.mutate',
          'prompt.submit',
        ], reason: entry.key);
        expect(
          gateway.calls('session.mutate').single.params['payload'],
          {'target_message_id': 9},
          reason: entry.key,
        );
        expect(
          [for (final row in gateway.rows) row['text']],
          ['Keep this', 'Noted', 'Edited probe', 'Fresh reply'],
          reason: entry.key,
        );
        client.close();
      }
    });

    test('a plain submit is one prompt.submit, no rewind', () async {
      final gateway = FakeAuthorityGateway();
      final client = await gateway.connect();
      await _submit(client, gateway, const {});
      expect(gateway.writes, ['prompt.submit']);
      expect(gateway.refusals, isEmpty);
      expect(gateway.rows, hasLength(6));
    });

    test('bare confirm_empty_truncate (an unresolved first turn) is dropped: '
        'a plain submit', () async {
      final gateway = FakeAuthorityGateway();
      final client = await gateway.connect();
      await _submit(client, gateway, const {'confirm_empty_truncate': true});
      expect(gateway.writes, ['prompt.submit']);
      expect(gateway.refusals, isEmpty);
      expect(gateway.rows, hasLength(6), reason: 'nothing was cut');
    });

    test('an ordinal or message id without a durable row is refused here, '
        'with Desktop\'s message: nothing reaches the wire', () async {
      for (final extra in <Map<String, Object?>>[
        truncateSubmitParams(ordinal: 0),
        {'confirm_truncate': true, 'truncate_before_message_id': 'm-1'},
      ]) {
        final gateway = FakeAuthorityGateway();
        final client = await gateway.connect();
        await expectLater(
          _submit(client, gateway, extra),
          throwsA(
            isA<JsonRpcError>()
                .having((e) => e.reason, 'reason', rewindTargetUnsavedReason)
                .having(
                  (e) => e.message,
                  'message',
                  'This message is not saved yet; wait for it to settle, '
                      'then edit it again',
                ),
          ),
        );
        expect(gateway.writes, isEmpty, reason: '$extra');
        expect(gateway.rows, hasLength(4));
        client.close();
      }
    });

    test('a refused rewind sends no prompt, and its fences are adopted for '
        'the next attempt (no automatic retry)', () async {
      final gateway = FakeAuthorityGateway();
      final client = await gateway.connect();
      // Another viewer committed a mutation this socket has not heard of.
      gateway.revision = 9;
      await expectLater(
        _submit(client, gateway, regenerateSubmitParams(9)),
        throwsA(
          isA<JsonRpcError>().having(
            (e) => e.reason,
            'reason',
            'revision_conflict',
          ),
        ),
      );
      expect(gateway.writes, ['session.mutate']);
      expect(gateway.rows, hasLength(4), reason: 'nothing was cut');
      expect(client.sessionRevisionFor(gateway.sessionId), 9);

      await _submit(client, gateway, regenerateSubmitParams(9));
      expect(gateway.writes, [
        'session.mutate',
        'session.mutate',
        'prompt.submit',
      ]);
      expect(
        gateway.calls('session.mutate').last.params['expected_revision'],
        9,
      );
    });

    test('the revision follows the session: a turn (session.info), then a '
        'second rewind presents the new fences', () async {
      final gateway = FakeAuthorityGateway();
      final client = await gateway.connect();
      await _submit(client, gateway, regenerateSubmitParams(9));
      // rewind (5), the turn's session.info (6); generation 3 from the
      // admission receipt.
      expect(client.sessionRevisionFor(gateway.sessionId), gateway.revision);
      final newest = gateway.rows.lastWhere((row) => row['role'] == 'user');
      await _submit(
        client,
        gateway,
        regenerateSubmitParams(newest['row_id'] as int),
      );
      expect(gateway.refusals, isEmpty);
      final second = gateway.calls('session.mutate').last.params;
      expect(second['expected_revision'], 6);
      expect(second['expected_generation'], 3);
    });

    test('a session this socket never attached has no fences: refused '
        'locally, never guessed', () async {
      final gateway = FakeAuthorityGateway();
      final client = await gateway.connect(attach: false);
      await expectLater(
        _submit(client, gateway, regenerateSubmitParams(9)),
        throwsA(
          isA<JsonRpcError>().having(
            (e) => e.reason,
            'reason',
            rewindFencesUnknownReason,
          ),
        ),
      );
      expect(gateway.writes, isEmpty);
    });

    test('a raw send (NextGen gateway.call) is redirected the same way, with '
        'fences learned from its own raw session.resume', () async {
      final gateway = FakeAuthorityGateway();
      final client = await gateway.connect(attach: false);
      final resumed = await client.send('session.resume', {
        'session_id': gateway.sessionId,
      });
      expect(resumed['error'], isNull);
      final reply = await client.send('prompt.submit', {
        'session_id': gateway.sessionId,
        'text': 'Edited probe',
        'submission_id': 'sub-1',
        ..._probeEditParams,
      });
      expect(reply['error'], isNull);
      expect((reply['result'] as Map)['status'], 'started');
      expect(gateway.writes, ['session.mutate', 'prompt.submit']);
      expect(gateway.refusals, isEmpty);
    });
  });

  group('legacy sidecar socket', () {
    test('the legacy keys go out unchanged in one prompt.submit', () async {
      final gateway = FakeAuthorityGateway(authority: false);
      final client = await gateway.connect();
      expect(client.sessionAuthority, isFalse);
      await _submit(client, gateway, _probeEditParams);
      // The pre-0.23 sidecar refuses `submission_id`; the retry without it
      // is the existing compatibility path.
      final accepted = gateway.calls('prompt.submit').last.params;
      expect(accepted, {
        'session_id': gateway.sessionId,
        'text': 'Edited probe',
        'profile': 'field-work',
        ..._probeEditParams,
      });
      expect(gateway.calls('session.mutate'), isEmpty);
      expect(
        [for (final row in gateway.rows) row['text']],
        ['Edited probe', 'Fresh reply'],
        reason: 'the sidecar cut the transcript itself',
      );
    });

    test('an ordinal-only cut is still the sidecar\'s to judge', () async {
      final gateway = FakeAuthorityGateway(authority: false);
      final client = await gateway.connect();
      await _submit(client, gateway, truncateSubmitParams(ordinal: 0));
      expect(gateway.calls('prompt.submit').last.params, {
        'session_id': gateway.sessionId,
        'text': 'Edited probe',
        'profile': 'field-work',
        'confirm_truncate': true,
        'truncate_before_user_ordinal': 0,
        'confirm_empty_truncate': true,
      });
    });
  });
}
