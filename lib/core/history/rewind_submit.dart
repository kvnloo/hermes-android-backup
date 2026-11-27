/// Desktop-parity rewind semantics for Classic and NextGen (see
/// apps/desktop/src/app/session/hooks/use-prompt-actions/rewind.ts).
///
/// Pure helpers and injectable RPC runner — no widget dependencies. This file
/// owns the exact wire shape of a truncating `prompt.submit`.
library;

/// Mirror of rewind.ts `isSyntheticRendererId`. Renderer-synthetic message ids
/// (`timestamp-index-role` from chat-messages/hydration.ts, `user-…` /
/// `assistant-…` shapes, Classic `_timeline_id`s and NextGen item keys) never
/// reach the gateway — only durable `row_id` or platform `message_id` values
/// may ride along as truncation targets.
bool isSyntheticRendererId(String? messageId) {
  if (messageId == null || messageId.isEmpty) return true;
  return messageId.startsWith('user-') ||
      messageId.startsWith('assistant-') ||
      messageId.startsWith('local-') ||
      messageId.startsWith('run:') ||
      messageId.startsWith('reasoning:') ||
      messageId.contains('-synthetic-') ||
      RegExp(r'^[uast]\d+$').hasMatch(messageId) ||
      RegExp(r'^\d+-\d+-(user|assistant|tools)\b').hasMatch(messageId);
}

/// Mirror of rewind.ts `truncateSubmitParams`.
///
/// `confirm_truncate` states that the submit really is a rewind/edit/regenerate:
/// the gateway drops history only for a submit that says so, so a leftover
/// ordinal riding along on an ordinary send cannot delete the transcript.
/// Emits `confirm_truncate` plus ONE target (`truncate_before_row_id`
/// preferred, else non-synthetic `truncate_before_message_id`, else
/// `truncate_before_user_ordinal`; [RewindPlan] never passes an ordinal).
/// Ordinal 0 additionally sets
/// `confirm_empty_truncate`. A cut that archives later user turns sets
/// `confirm_deep_truncate` only when [confirmDeepTruncate] is true.
Map<String, dynamic> truncateSubmitParams(
  int? truncateOrdinal,
  String? truncateMessageId,
  int? truncateRowId, {
  bool confirmDeepTruncate = false,
}) {
  final hasRowId = truncateRowId != null && truncateRowId > 0;
  final hasMessageId =
      truncateMessageId != null &&
      truncateMessageId.isNotEmpty &&
      !isSyntheticRendererId(truncateMessageId);
  final hasOrdinal = truncateOrdinal != null && truncateOrdinal >= 0;

  if (!hasRowId && !hasMessageId && !hasOrdinal) {
    return const {};
  }

  return <String, dynamic>{
    'confirm_truncate': true,
    if (hasRowId)
      'truncate_before_row_id': truncateRowId
    else if (hasMessageId)
      'truncate_before_message_id': truncateMessageId
    else if (hasOrdinal)
      'truncate_before_user_ordinal': truncateOrdinal,
    if (truncateOrdinal == 0) 'confirm_empty_truncate': true,
    if (confirmDeepTruncate) 'confirm_deep_truncate': true,
  };
}

typedef GatewayRpcCall =
    Future<Map<String, dynamic>?> Function(
      String method,
      Map<String, dynamic> params,
    );

/// Outcome of inspecting `session.history` for a durable `row_id`.
class DurableRowLookup {
  const DurableRowLookup({
    required this.rowId,
    required this.persistedHasRowIds,
  });

  final int? rowId;

  /// True when `session.history` returned persisted user rows carrying integer
  /// `row_id`s. When true and [rowId] is null, client/server ordinal spaces may
  /// diverge so the caller degrades to a plain resubmit rather than guessing.
  /// When false (legacy gateway without `row_id` or `session.history` absent),
  /// `truncate_before_user_ordinal` remains usable as the fallback target.
  final bool persistedHasRowIds;
}

int? _parsePositiveInt(Object? raw) {
  if (raw is int && raw > 0) return raw;
  if (raw is String) {
    final parsed = int.tryParse(raw);
    if (parsed != null && parsed > 0) return parsed;
  }
  return null;
}

/// Mirror of rewind.ts `resolveDurableRowId`. Resolves the durable `row_id` of
/// a user turn by exact trimmed content against `session.history`.
Future<int?> resolveDurableRowId(
  GatewayRpcCall requestGateway,
  String sessionId,
  String sourceText,
  int? expectedOrdinal,
) async {
  final lookup = await lookupDurableRowId(
    requestGateway,
    sessionId,
    sourceText,
    expectedOrdinal,
  );
  return lookup.rowId;
}

/// The session's full saved transcript (`session.history`), read once for a
/// rewind: it addresses the turn by its durable row and says what a cut
/// there archives. The rows on screen cannot answer either question: they
/// are a paged tail, and rows of this visit have no durable identity yet.
class RewindHistory {
  RewindHistory._(this._users, this.maxRowId);

  /// Visible user turns that carry a durable `row_id`, in transcript order.
  final List<({int rowId, String text})> _users;

  /// The newest durable row of any role, or null when none is stamped.
  final int? maxRowId;

  /// Whether the gateway stamps durable rows on this transcript.
  bool get hasRowIds => _users.isNotEmpty;

  /// Null when `session.history` cannot be read (an old gateway, a dropped
  /// socket): the caller then knows nothing about the saved transcript.
  static Future<RewindHistory?> read(
    GatewayRpcCall requestGateway,
    String sessionId,
  ) async {
    final Object? raw;
    try {
      final result = await requestGateway('session.history', {
        'session_id': sessionId,
      });
      raw = result?['messages'];
    } catch (_) {
      return null;
    }
    if (raw is! List) return null;
    final users = <({int rowId, String text})>[];
    int? maxRowId;
    for (final entry in raw) {
      if (entry is! Map) continue;
      final rid = _parsePositiveInt(entry['row_id']);
      if (rid == null) continue;
      if (maxRowId == null || rid > maxRowId) maxRowId = rid;
      if (entry['role'] != 'user') continue;
      final kind = entry['display_kind'];
      if (kind != null && kind != '') continue;
      final rawText = entry['text'] ?? entry['content'];
      if (rawText != null && rawText is! String) continue;
      users.add((rowId: rid, text: (rawText as String? ?? '').trim()));
    }
    return RewindHistory._(users, maxRowId);
  }

  /// The durable row of one user turn. The bubble's own row id wins when
  /// the transcript has it (Desktop's first choice, `source.rowId`); else
  /// the turn is matched by exact trimmed text, as rewind.ts
  /// `resolveDurableRowId`: a unique match, or the newest of several only
  /// when [expectedOrdinal] says the target is the latest turn.
  int? rowFor({
    int? bubbleRowId,
    required String sourceText,
    int? expectedOrdinal,
  }) {
    if (bubbleRowId != null &&
        bubbleRowId > 0 &&
        _users.any((user) => user.rowId == bubbleRowId)) {
      return bubbleRowId;
    }
    final wanted = sourceText.trim();
    if (wanted.isEmpty) return null;
    final matches = _users.where((user) => user.text == wanted).toList();
    if (matches.length == 1) return matches.single.rowId;
    if (matches.length > 1 &&
        expectedOrdinal != null &&
        expectedOrdinal >= _users.length - 1) {
      final last = matches.last;
      return identical(_users.last, last) ? last.rowId : null;
    }
    return null;
  }

  /// Whether a cut at [rowId] archives later user turns (Desktop's
  /// `laterVisibleUserTurns`): what the deep-cut confirm asks about.
  bool laterUserTurns(int rowId) {
    final index = _users.indexWhere((user) => user.rowId == rowId);
    return index >= 0 && index < _users.length - 1;
  }
}

/// Full lookup used by [RewindPlan.resolve] so callers distinguish an
/// unresolvable turn in a `row_id`-stamped transcript from a legacy gateway
/// that does not stamp `row_id`.
Future<DurableRowLookup> lookupDurableRowId(
  GatewayRpcCall requestGateway,
  String sessionId,
  String sourceText,
  int? expectedOrdinal,
) async {
  if (sourceText.trim().isEmpty) {
    return const DurableRowLookup(rowId: null, persistedHasRowIds: false);
  }
  final history = await RewindHistory.read(requestGateway, sessionId);
  if (history == null || !history.hasRowIds) {
    return const DurableRowLookup(rowId: null, persistedHasRowIds: false);
  }
  return DurableRowLookup(
    rowId: history.rowFor(
      sourceText: sourceText,
      expectedOrdinal: expectedOrdinal,
    ),
    persistedHasRowIds: true,
  );
}

/// Resolved target for ONE truncating `prompt.submit`.
class RewindPlan {
  const RewindPlan._({
    required this.truncateOrdinal,
    required this.truncateMessageId,
    required this.truncateRowId,
    required this.sourceText,
    required this.originalOrdinal,
  });

  final int? truncateOrdinal;
  final String? truncateMessageId;
  final int? truncateRowId;
  final String sourceText;
  final int? originalOrdinal;

  bool get truncates =>
      truncateRowId != null ||
      truncateMessageId != null ||
      truncateOrdinal != null;

  /// A plan for a target the caller already resolved ([RewindHistory]):
  /// the durable row, or none (a plain resubmit). [originalOrdinal] is the
  /// turn's place among the user turns, kept only for the first-turn
  /// `confirm_empty_truncate` rule.
  const RewindPlan.resolved({
    required int? rowId,
    required this.sourceText,
    required this.originalOrdinal,
  }) : truncateOrdinal = null,
       truncateMessageId = null,
       truncateRowId = rowId;

  /// Target priority: `truncate_before_row_id` (direct or resolved from
  /// `session.history`), else a non-synthetic `truncate_before_message_id`.
  /// Never `truncate_before_user_ordinal`: a client-side ordinal can
  /// disagree with the gateway's (#87059), and the gateway fails it closed
  /// on a durable session. An unresolved target is a plain resubmit, as
  /// rewind.ts `runRewindSubmit` (`resolvedOrdinal = undefined` on both
  /// branches).
  static Future<RewindPlan> resolve({
    required GatewayRpcCall requestGateway,
    required String sessionId,
    required int? truncateOrdinal,
    required String? truncateMessageId,
    required int? truncateRowId,
    required String sourceText,
  }) async {
    final hasRowId = truncateRowId != null && truncateRowId > 0;
    final hasMessageId =
        truncateMessageId != null &&
        truncateMessageId.isNotEmpty &&
        !isSyntheticRendererId(truncateMessageId);
    final hasOrdinal = truncateOrdinal != null && truncateOrdinal >= 0;

    if (!hasRowId && !hasMessageId && !hasOrdinal) {
      return RewindPlan._(
        truncateOrdinal: null,
        truncateMessageId: null,
        truncateRowId: null,
        sourceText: sourceText,
        originalOrdinal: truncateOrdinal,
      );
    }

    if (hasRowId) {
      return RewindPlan._(
        truncateOrdinal: null,
        truncateMessageId: null,
        truncateRowId: truncateRowId,
        sourceText: sourceText,
        originalOrdinal: truncateOrdinal,
      );
    }

    final lookup = sourceText.trim().isEmpty
        ? const DurableRowLookup(rowId: null, persistedHasRowIds: false)
        : await lookupDurableRowId(
            requestGateway,
            sessionId,
            sourceText,
            truncateOrdinal,
          );
    if (lookup.rowId != null) {
      return RewindPlan._(
        truncateOrdinal: null,
        truncateMessageId: null,
        truncateRowId: lookup.rowId,
        sourceText: sourceText,
        originalOrdinal: truncateOrdinal,
      );
    }

    if (hasMessageId) {
      return RewindPlan._(
        truncateOrdinal: null,
        truncateMessageId: truncateMessageId,
        truncateRowId: null,
        sourceText: sourceText,
        originalOrdinal: truncateOrdinal,
      );
    }

    return RewindPlan._(
      truncateOrdinal: null,
      truncateMessageId: null,
      truncateRowId: null,
      sourceText: sourceText,
      originalOrdinal: truncateOrdinal,
    );
  }

  @override
  String toString() =>
      'RewindPlan(rowId: $truncateRowId, messageId: $truncateMessageId, ordinal: $truncateOrdinal)';
}

/// Builds the truncation params for ONE `prompt.submit`.
Map<String, dynamic> buildRewindParams(
  RewindPlan plan, {
  required bool confirmDeepTruncate,
  Iterable<int>? rebindSurvivorRowIds,
}) {
  final params = <String, dynamic>{
    ...truncateSubmitParams(
      plan.truncateOrdinal,
      plan.truncateMessageId,
      plan.truncateRowId,
      confirmDeepTruncate: confirmDeepTruncate,
    ),
  };
  // rewind.ts:361-369. With the ordinal dropped, the durable row is
  // authoritative and a cut at the first active turn is allowed. An
  // unresolved first turn sends the flag bare, as Desktop does: the legacy
  // sidecar ignores it on a non-empty prefix, and the canonical transport
  // strips it (it is one of Desktop's TRUNCATE_KEYS).
  if (plan.truncateOrdinal == null &&
      (plan.truncateRowId != null || plan.originalOrdinal == 0)) {
    params['confirm_empty_truncate'] = true;
  }
  if (params.isEmpty) return const {};
  if (rebindSurvivorRowIds != null) {
    final ids = {
      for (final id in rebindSurvivorRowIds)
        if (id > 0) id,
    }.toList(growable: false);
    if (ids.isNotEmpty) {
      params['rebind_survivor_row_ids'] = ids;
    }
  }
  return params;
}

/// Exact match of rewind.ts lines 382-386: backends predating `#133716` reject
/// `confirm_deep_truncate` at contract admission (`4000`, handler never runs).
/// Only that field may be stripped on the single compatibility retry.
bool isRejectedDeepTruncatePayload({
  required int? code,
  required String message,
  required Map<String, dynamic> sentParams,
}) =>
    code == 4000 &&
    sentParams.containsKey('confirm_deep_truncate') &&
    message.contains(
      'invalid params for prompt.submit: confirm_deep_truncate:',
    );

/// Returns a copy of [params] with ONLY `confirm_deep_truncate` removed.
Map<String, dynamic> stripRejectedDeepTruncate(Map<String, dynamic> params) =>
    Map<String, dynamic>.of(params)..remove('confirm_deep_truncate');

bool isSessionBusyPayload({required int? code, required String message}) {
  if (code == 4002) return true;
  final lower = message.toLowerCase();
  return lower.contains('session is busy') || lower.contains('session_busy');
}

/// Post-rewrite durable row identity returned by a truncating `prompt.submit`.
class SurvivorRowIds {
  const SurvivorRowIds._({this.byOldRowId, this.byUserOrdinal});

  final Map<int, int?>? byOldRowId;
  final List<int?>? byUserOrdinal;

  static SurvivorRowIds? fromSubmitResult(Object? rawResult) {
    if (rawResult is! Map) return null;
    final rawMap = rawResult['survivor_row_id_map'];
    if (rawMap is Map) {
      final parsed = <int, int?>{};
      for (final entry in rawMap.entries) {
        final previous = int.tryParse('${entry.key}');
        if (previous == null) continue;
        final val = entry.value;
        if (val == null) {
          parsed[previous] = null;
        } else if (val is int) {
          parsed[previous] = val;
        }
      }
      return SurvivorRowIds._(byOldRowId: parsed);
    }
    final rawList = rawResult['survivor_user_row_ids'];
    if (rawList is List) {
      return SurvivorRowIds._(
        byUserOrdinal: [
          for (final entry in rawList) entry is int ? entry : null,
        ],
      );
    }
    return null;
  }
}

/// Exception interface accepted by [runRewindSubmit] for RPC error inspection.
class RewindRpcException implements Exception {
  const RewindRpcException({required this.code, required this.message});
  final int? code;
  final String message;
  @override
  String toString() => 'RewindRpcException($code): $message';
}

/// Mirror of rewind.ts `runRewindSubmit`: resolves the durable address, sends
/// `session.interrupt` first when [interruptFirst] is true (and on a raced
/// session-busy error), submits ONE truncating `prompt.submit`, and retries
/// once without `confirm_deep_truncate` when an older backend rejects that
/// parameter with 4000.
Future<SurvivorRowIds?> runRewindSubmit({
  required GatewayRpcCall requestGateway,
  required String sessionId,
  required String text,
  int? truncateOrdinal,
  String? truncateMessageId,
  int? truncateRowId,
  String? sourceText,
  Iterable<int>? rebindRowIds,
  bool interruptFirst = false,
  bool confirmDeepTruncate = false,
  int? Function(Object error)? errorCodeOf,
  String Function(Object error)? errorMessageOf,
}) async {
  int? codeOf(Object err) {
    if (errorCodeOf != null) return errorCodeOf(err);
    if (err is RewindRpcException) return err.code;
    return null;
  }

  String messageOf(Object err) {
    if (errorMessageOf != null) return errorMessageOf(err);
    if (err is RewindRpcException) return err.message;
    return err.toString();
  }

  final plan = await RewindPlan.resolve(
    requestGateway: requestGateway,
    sessionId: sessionId,
    truncateOrdinal: truncateOrdinal,
    truncateMessageId: truncateMessageId,
    truncateRowId: truncateRowId,
    sourceText: sourceText ?? '',
  );

  Future<void> interrupt() async {
    try {
      await requestGateway('session.interrupt', {'session_id': sessionId});
    } catch (_) {
      // Best-effort; submit still gates on gateway state.
    }
  }

  var deepConfirmUnsupported = false;

  Future<Map<String, dynamic>?> submitOnce() async {
    final params = <String, dynamic>{
      'session_id': sessionId,
      'text': text,
      ...buildRewindParams(
        plan,
        confirmDeepTruncate: confirmDeepTruncate && !deepConfirmUnsupported,
        rebindSurvivorRowIds: rebindRowIds,
      ),
    };
    try {
      return await requestGateway('prompt.submit', params);
    } catch (error) {
      if (!isRejectedDeepTruncatePayload(
        code: codeOf(error),
        message: messageOf(error),
        sentParams: params,
      )) {
        rethrow;
      }
      deepConfirmUnsupported = true;
      return requestGateway('prompt.submit', stripRejectedDeepTruncate(params));
    }
  }

  if (interruptFirst) {
    await interrupt();
  }

  Map<String, dynamic>? result;
  try {
    result = await submitOnce();
  } catch (error) {
    if (!isSessionBusyPayload(code: codeOf(error), message: messageOf(error))) {
      rethrow;
    }
    await interrupt();
    result = await submitOnce();
  }
  return SurvivorRowIds.fromSubmitResult(result);
}
