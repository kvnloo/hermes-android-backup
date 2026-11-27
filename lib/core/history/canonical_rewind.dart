/// The canonical session authority's rewind, as Hermes Desktop sends it
/// (b7ee21c14e apps/desktop/src/api/canonical-protocol.ts:155-185 and
/// client.ts:509-520).
///
/// A Hermes 0.23+ gateway that advertises `session_authority` answers
/// `prompt.submit` through `CanonicalSubmitParams`, a closed key set with no
/// truncation keys: any of them is refused with `4001 invalid_params`. There
/// the cut is its own request, a revision-fenced `rewind` mutation on the
/// user row, followed by a plain submit. The legacy sidecar keeps the keys.
///
/// Pure helpers, no socket: the transport ([WsClient.send]) owns the wire.
library;

/// Desktop's `TRUNCATE_KEYS`: the legacy `prompt.submit` truncation keys
/// (edit, regenerate, restore). The deep-cut confirm guards the legacy
/// sidecar's implicit cut; the owner's rewind names its row and the user
/// already confirmed, so it is dropped as well.
const truncateKeys = <String>[
  'confirm_truncate',
  'confirm_empty_truncate',
  'confirm_deep_truncate',
  'truncate_before_row_id',
  'truncate_before_message_id',
  'truncate_before_user_ordinal',
  'rebind_survivor_row_ids',
];

/// The keys that name a cut. Only the durable row is an address the owner
/// accepts; a message id or an ordinal would be a guess.
const _targetKeys = <String>[
  'truncate_before_row_id',
  'truncate_before_message_id',
  'truncate_before_user_ordinal',
];

/// `JsonRpcError.reason` of a truncating submit that names no durable row.
const rewindTargetUnsavedReason = 'rewind_target_unsaved';

/// Desktop's refusal text for [rewindTargetUnsavedReason].
const rewindTargetUnsavedMessage =
    'This message is not saved yet; wait for it to settle, then edit it '
    'again';

/// `JsonRpcError.reason` of a rewind on a session whose revision or
/// execution generation this socket has not been told.
const rewindFencesUnknownReason = 'rewind_fences_unknown';

/// Desktop's refusal text for [rewindFencesUnknownReason].
const rewindFencesUnknownMessage =
    'Session revision unavailable; reopen the session before editing it';

/// A truncating submit names no durable row to cut at.
class RewindTargetUnsaved implements Exception {
  const RewindTargetUnsaved();

  @override
  String toString() => rewindTargetUnsavedMessage;
}

/// Desktop's `splitRewindSubmit`: the `session.rewind` request (null when
/// the submit names no cut) and the plain submit that follows it.
typedef RewindSubmitSplit = ({
  Map<String, dynamic>? rewind,
  Map<String, dynamic> submit,
});

/// Splits a truncating `prompt.submit` into the owner's rewind and a plain
/// submit, exactly as Desktop's `splitRewindSubmit`:
///
///  * no truncation key: null, the submit goes as it is;
///  * `truncate_before_row_id` a positive int: rewind to that row
///    (`{session_id, target_message_id, profile?}`), then the submit without
///    any truncation key;
///  * a message id or ordinal without a durable row: [RewindTargetUnsaved];
///  * only confirmation flags: the plain submit, no rewind.
RewindSubmitSplit? splitRewindSubmit(Map<String, dynamic> params) {
  if (!truncateKeys.any(params.containsKey)) return null;
  final row = params['truncate_before_row_id'];
  final submit = <String, dynamic>{
    for (final entry in params.entries)
      if (!truncateKeys.contains(entry.key)) entry.key: entry.value,
  };
  if (row is int && row > 0) {
    return (
      rewind: <String, dynamic>{
        'session_id': params['session_id'],
        'target_message_id': row,
        if (params['profile'] != null) 'profile': params['profile'],
      },
      submit: submit,
    );
  }
  if (_targetKeys.any(params.containsKey)) throw const RewindTargetUnsaved();
  return (rewind: null, submit: submit);
}

/// The CAS `revision` a socket has been told for each session, as Desktop's
/// `CanonicalDesktopProtocol` keeps it: every fenced mutation presents it,
/// with the session's `execution_generation` (which the socket tracks from
/// its frames).
class CanonicalSessionRevisions {
  final Map<String, int> _revisions = {};

  int? of(String sessionId) => _revisions[sessionId];

  void clear() => _revisions.clear();

  /// `session.info` states the revision; `session.updated` (another
  /// viewer's committed mutation) only ever moves it forwards.
  void noteEvent(String type, String? sessionId, Map<String, dynamic> payload) {
    if (sessionId == null || sessionId.isEmpty) return;
    final revision = payload['revision'];
    if (revision is! int) return;
    if (type == 'session.info') {
      _revisions[sessionId] = revision;
    } else if (type == 'session.updated' &&
        (payload['session_id'] ?? sessionId) == sessionId) {
      _raise(sessionId, revision);
    }
  }

  /// A reply that names its session and revision (a resume or create
  /// snapshot, a mutation receipt). An exact-retry mutation receipt replays
  /// its original revision, so a mutation never moves the value backwards.
  void noteResult(String method, Object? result) {
    if (result is! Map) return;
    final sessionId = result['session_id'];
    final revision = result['revision'];
    if (sessionId is! String || sessionId.isEmpty || revision is! int) return;
    if (method == 'session.mutate') {
      _raise(sessionId, revision);
    } else {
      _revisions[sessionId] = revision;
    }
  }

  /// A fence refusal names the owner's current revision: the next attempt
  /// presents it. Never backwards (an older refusal can arrive late).
  void noteRefusal(Object? sessionId, Object? data) {
    if (sessionId is! String || sessionId.isEmpty || data is! Map) return;
    if (!isFenceRefusal(data)) return;
    final revision = data['revision'];
    if (revision is int) _raise(sessionId, revision);
  }

  void _raise(String sessionId, int revision) {
    final known = _revisions[sessionId];
    if (known == null || revision > known) _revisions[sessionId] = revision;
  }
}

/// Whether an error's `data` is a fence refusal: nothing was written, and
/// it names the owner's current fences.
bool isFenceRefusal(Map<dynamic, dynamic> data) =>
    data['reason'] == 'revision_conflict' ||
    data['reason'] == 'stale_generation';

/// The wire form of Desktop's `session.rewind`: a `session.mutate` with
/// operation `rewind`, fenced by the session's revision and generation
/// (`gateway/session_mutations.py` `_FIELDS` plus `expected_generation`).
Map<String, dynamic> rewindMutation(
  Map<String, dynamic> rewind, {
  required String requestId,
  required int revision,
  required int generation,
}) => <String, dynamic>{
  'session_id': rewind['session_id'],
  'request_id': requestId,
  'expected_revision': revision,
  'expected_generation': generation,
  'operation': 'rewind',
  'payload': <String, dynamic>{
    'target_message_id': rewind['target_message_id'],
  },
  if (rewind['profile'] != null) 'profile': rewind['profile'],
};
