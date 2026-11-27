import 'package:flutter/widgets.dart' show Locale;

import '../../l10n/app_localizations.dart';
import '../services/ws_client.dart';

/// Commands the composer runs itself, the way Desktop does, instead of
/// sending them as an ordinary prompt.
enum DedicatedSlash { sideQuestion, background, handoff, resume }

AppLocalizations _english() => lookupAppLocalizations(const Locale('en'));

/// A finished side question (`btw.complete`) or background task
/// (`background.complete`), shown in the chat the way Desktop's gateway
/// event dispatcher shows it: a header naming the task, then the answer.
class SideAnswer {
  const SideAnswer({
    required this.kind,
    required this.text,
    this.taskId = '',
    this.question = '',
  });

  final DedicatedSlash kind;
  final String text;
  final String taskId;
  final String question;

  /// Desktop's `[btw "q" (id)]` / `[bg id]` line, without the brackets.
  String get header => switch (kind) {
    DedicatedSlash.sideQuestion =>
      'btw${question.isEmpty ? '' : ' "$question"'}'
          '${taskId.isEmpty ? '' : ' ($taskId)'}',
    _ => taskId.isEmpty ? 'bg' : 'bg $taskId',
  };

  /// Same task, same answer: a replayed event, not a second answer.
  String get identity => '${kind.name}|$taskId|$text';

  /// Parses the gateway event; null for other events and empty answers.
  static SideAnswer? fromEvent(String type, Map<String, dynamic> data) {
    final kind = switch (type) {
      'btw.complete' => DedicatedSlash.sideQuestion,
      'background.complete' => DedicatedSlash.background,
      _ => null,
    };
    if (kind == null) return null;
    final text = _line(data['text']);
    if (text.isEmpty) return null;
    return SideAnswer(
      kind: kind,
      text: text,
      taskId: _line(data['task_id']),
      question: kind == DedicatedSlash.sideQuestion
          ? _line(data['question'])
          : '',
    );
  }

  static String _line(Object? value) =>
      (value is String ? value : value?.toString() ?? '')
          .replaceAll('\u0000', '')
          .trim();
}

DedicatedSlash? dedicatedSlash(String name) {
  return switch (name.toLowerCase()) {
    'btw' => DedicatedSlash.sideQuestion,
    'bg' || 'background' => DedicatedSlash.background,
    'handoff' => DedicatedSlash.handoff,
    'resume' || 'sessions' || 'switch' => DedicatedSlash.resume,
    _ => null,
  };
}

class CommandRequest {
  const CommandRequest(this.method, this.params);

  final String method;
  final Map<String, dynamic> params;
}

class CommandPlan {
  const CommandPlan({
    this.consumed = false,
    this.openResume = false,
    this.resumeQuery = '',
    this.notice,
    this.request,
  });

  /// The line was handled. Do not also send it as a prompt.
  final bool consumed;
  final bool openResume;
  final String resumeQuery;
  final String? notice;
  final CommandRequest? request;
}

/// What to do before any RPC. [notice] is the usage or missing-session line.
CommandPlan planDedicated({
  required String name,
  required String arg,
  required String? sessionId,
  AppLocalizations? l10n,
}) {
  final kind = dedicatedSlash(name);
  if (kind == null) return const CommandPlan();
  final strings = l10n ?? _english();
  final trimmed = arg.trim();
  if (kind == DedicatedSlash.resume) {
    return CommandPlan(consumed: true, openResume: true, resumeQuery: trimmed);
  }
  if (trimmed.isEmpty) {
    return CommandPlan(
      consumed: true,
      notice: switch (kind) {
        DedicatedSlash.sideQuestion => strings.composer_btw_usage,
        DedicatedSlash.background => strings.composer_background_usage,
        DedicatedSlash.handoff => strings.composer_handoff_usage,
        DedicatedSlash.resume => '',
      },
    );
  }
  final session = sessionId?.trim() ?? '';
  if (session.isEmpty) {
    return CommandPlan(
      consumed: true,
      notice: strings.composer_command_needs_session,
    );
  }
  final method = switch (kind) {
    DedicatedSlash.sideQuestion => 'prompt.btw',
    DedicatedSlash.background => 'prompt.background',
    DedicatedSlash.handoff => 'handoff.request',
    DedicatedSlash.resume => '',
  };
  final params = switch (kind) {
    DedicatedSlash.handoff => {'session_id': session, 'platform': trimmed},
    _ => {'session_id': session, 'text': trimmed},
  };
  return CommandPlan(consumed: true, request: CommandRequest(method, params));
}

class CommandAnswer {
  const CommandAnswer({
    required this.fallbackToExec,
    this.notice = '',
    this.watchHandoff = false,
    this.failed = false,
    this.taskId = '',
  });

  /// The gateway has no dedicated method. The existing slash.exec path runs.
  final bool fallbackToExec;
  final String notice;
  final bool watchHandoff;

  /// The gateway refused or the call failed; [notice] says why.
  final bool failed;

  /// The side question or background task the gateway started, if named.
  final String taskId;
}

/// Whether [error] says the gateway has no such method, so the command takes
/// its older slash.exec route. Desktop's isMissingRpcMethod (b7ee21c14e
/// apps/desktop/src/lib/gateway-rpc.ts:7-17, used by slash.ts's /background
/// fallback): a JSON-RPC code decides when there is one (-32601), and a
/// codeless error decides by its message ("method not found", "-32601",
/// "unknown method", "no such method"). An older gateway's 4004 refusal
/// whose message names an unknown method is that same verdict. Any other
/// coded error (a 4004 for bad input, a -32000 that merely mentions the
/// words) is a real failure and is reported, never re-run.
bool missingRpcMethod(Object error) {
  final code = error is JsonRpcError ? error.code : null;
  final message = error is JsonRpcError ? error.message : error.toString();
  if (code == -32601) return true;
  if (code == 4004) return _unknownMethod.hasMatch(message);
  if (code != null) return false;
  return _missingMethod.hasMatch(message);
}

final _missingMethod = RegExp(
  r'method not found|-32601|unknown method|no such method',
  caseSensitive: false,
);
final _unknownMethod = RegExp(
  r'unknown method|method not found|no such method',
  caseSensitive: false,
);

CommandAnswer interpretCommandResult({
  required DedicatedSlash kind,
  required String arg,
  required Map<String, dynamic> result,
  AppLocalizations? l10n,
}) {
  final strings = l10n ?? _english();
  final id = result['task_id']?.toString().trim() ?? '';
  return switch (kind) {
    DedicatedSlash.sideQuestion => CommandAnswer(
      fallbackToExec: false,
      taskId: id,
      notice: id.isEmpty
          ? strings.composer_side_question
          : strings.composer_side_question_id(id),
    ),
    DedicatedSlash.background => CommandAnswer(
      fallbackToExec: false,
      taskId: id,
      notice: id.isEmpty
          ? strings.composer_background_started
          : strings.composer_background_started_id(id),
    ),
    DedicatedSlash.handoff => CommandAnswer(
      fallbackToExec: false,
      watchHandoff: true,
      notice: strings.composer_handoff_requested(arg.trim()),
    ),
    DedicatedSlash.resume => const CommandAnswer(fallbackToExec: false),
  };
}

CommandAnswer interpretCommandError(Object error) {
  if (missingRpcMethod(error)) {
    return const CommandAnswer(fallbackToExec: true);
  }
  final message = error is JsonRpcError ? error.message : error.toString();
  return CommandAnswer(fallbackToExec: false, failed: true, notice: message);
}

class DedicatedRun {
  const DedicatedRun(this.plan, this.answer);

  final CommandPlan plan;
  final CommandAnswer? answer;
}

/// Plans the command and, when it has an RPC, runs that RPC. Resume and
/// usage lines do not call the gateway. A missing method asks the caller to
/// use its existing slash.exec path.
Future<DedicatedRun?> runDedicatedCommand({
  required String name,
  required String arg,
  required String? sessionId,
  Future<Map<String, dynamic>> Function(
    String method,
    Map<String, dynamic> params,
  )?
  rpc,
  AppLocalizations? l10n,
}) async {
  if (dedicatedSlash(name) == null) return null;
  final plan = planDedicated(
    name: name,
    arg: arg,
    sessionId: sessionId,
    l10n: l10n,
  );
  final request = plan.request;
  if (request == null) return DedicatedRun(plan, null);
  if (rpc == null) {
    return DedicatedRun(plan, const CommandAnswer(fallbackToExec: true));
  }
  try {
    final result = await rpc(request.method, request.params);
    return DedicatedRun(
      plan,
      interpretCommandResult(
        kind: dedicatedSlash(name)!,
        arg: arg,
        result: result,
        l10n: l10n,
      ),
    );
  } catch (error) {
    return DedicatedRun(plan, interpretCommandError(error));
  }
}

enum HandoffPhase { pending, completed, failed, timedOut }

/// One `handoff.state` reading. A clock past [deadlineMs] is a timeout even
/// when the gateway is still pending. Completed wins over the clock.
HandoffPhase readHandoffPhase({
  required Object? state,
  required int nowMs,
  required int deadlineMs,
}) {
  if (state == 'completed') return HandoffPhase.completed;
  if (state == 'failed') return HandoffPhase.failed;
  if (nowMs >= deadlineMs) return HandoffPhase.timedOut;
  return HandoffPhase.pending;
}

Map<String, dynamic> handoffStateParams(String sessionId) => {
  'session_id': sessionId,
};

Map<String, dynamic> handoffFailParams(String sessionId, String error) => {
  'session_id': sessionId,
  'error': error,
};

class HandoffOutcome {
  const HandoffOutcome(this.phase, [this.error = '']);

  final HandoffPhase phase;

  /// The gateway's reason for a failed handoff, when it gave one.
  final String error;
}

/// Watches a requested handoff to a terminal state, as Desktop does: poll
/// `handoff.state`; at the deadline `handoff.fail`, and if that answers that
/// the handoff completed meanwhile, it completed. [alive] false stops the
/// watch quietly (the chat closed); the result is then [HandoffPhase.pending].
Future<HandoffOutcome> watchHandoff({
  required Future<Map<String, dynamic>> Function(
    String method,
    Map<String, dynamic> params,
  )
  rpc,
  required String sessionId,
  required String timeoutMessage,
  required bool Function() alive,
  Duration interval = const Duration(milliseconds: 800),
  Duration limit = const Duration(seconds: 60),
  int Function()? clock,
}) async {
  final now = clock ?? () => DateTime.now().millisecondsSinceEpoch;
  final deadline = now() + limit.inMilliseconds;
  while (now() < deadline) {
    await Future<void>.delayed(interval);
    if (!alive()) return const HandoffOutcome(HandoffPhase.pending);
    Map<String, dynamic> record;
    try {
      record = await rpc('handoff.state', handoffStateParams(sessionId));
    } catch (_) {
      continue;
    }
    if (!alive()) return const HandoffOutcome(HandoffPhase.pending);
    final phase = readHandoffPhase(
      state: record['state'],
      nowMs: now(),
      deadlineMs: deadline,
    );
    if (phase == HandoffPhase.completed) return HandoffOutcome(phase);
    if (phase == HandoffPhase.failed) {
      return HandoffOutcome(phase, record['error']?.toString().trim() ?? '');
    }
    if (phase == HandoffPhase.timedOut) break;
  }
  if (!alive()) return const HandoffOutcome(HandoffPhase.pending);
  Map<String, dynamic>? cleanup;
  try {
    cleanup = await rpc(
      'handoff.fail',
      handoffFailParams(sessionId, timeoutMessage),
    );
  } catch (_) {}
  if (cleanup?['state'] == 'completed') {
    return const HandoffOutcome(HandoffPhase.completed);
  }
  return const HandoffOutcome(HandoffPhase.timedOut);
}

class ResumeCandidate {
  const ResumeCandidate({
    required this.id,
    required this.title,
    this.preview = '',
  });

  final String id;
  final String title;
  final String preview;
}

List<ResumeCandidate> filterResume(
  Iterable<ResumeCandidate> rows,
  String query,
) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty) return rows.toList();
  return [
    for (final row in rows)
      if (row.id.toLowerCase().contains(needle) ||
          row.title.toLowerCase().contains(needle) ||
          row.preview.toLowerCase().contains(needle))
        row,
  ];
}

class ArgumentHint {
  const ArgumentHint(this.text, this.label);

  final String text;
  final String label;
}

/// A `complete.slash` answer: its rows and where they replace the typed
/// line (`replace_from`, command_discovery.py): an argument row like
/// `friendly` for `/personality fr` replaces from the argument's start, so
/// the command stays.
class ArgumentCompletion {
  const ArgumentCompletion(this.hints, {this.replaceFrom});

  static const empty = ArgumentCompletion([]);

  final List<ArgumentHint> hints;
  final int? replaceFrom;

  /// [line] (the text sent as `text`) with [hint] in place of the part
  /// from `replace_from` on. Without a usable offset, the last word.
  String apply(String line, ArgumentHint hint) {
    var from = replaceFrom;
    if (from == null || from < 0 || from > line.length) {
      final space = line.lastIndexOf(' ');
      from = space < 0 ? line.length : space + 1;
    }
    return line.replaceRange(from, line.length, hint.text);
  }
}

ArgumentCompletion parseArgumentCompletion(Object? result) {
  final hints = parseArgumentHints(result);
  final raw = result is Map ? result['replace_from'] : null;
  return ArgumentCompletion(hints, replaceFrom: raw is int ? raw : null);
}

/// Rows from `complete.slash`. An empty or unrecognised payload is no hints,
/// not a locally invented argument list.
List<ArgumentHint> parseArgumentHints(Object? result) {
  if (result is! Map) return const [];
  final items = result['items'] ?? result['completions'];
  if (items is! List) return const [];
  final hints = <ArgumentHint>[];
  for (final item in items) {
    if (item is String && item.trim().isNotEmpty) {
      hints.add(ArgumentHint(item.trim(), item.trim()));
      continue;
    }
    if (item is! Map) continue;
    final text = item['text'] ?? item['insert'] ?? item['value'];
    if (text is! String || text.trim().isEmpty) continue;
    final display = item['display'];
    hints.add(
      ArgumentHint(
        text.trim(),
        display is String && display.isNotEmpty ? display : text.trim(),
      ),
    );
  }
  return hints;
}
