// One open NextGen chat: the transcript from the dashboard's REST history,
// then the live session over `/api/ws` (tui_gateway/contracts/events.py).
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random, max;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../core/models/attachment_draft.dart';
import '../../core/models/background_report.dart';
import '../../core/models/legacy_lcm_summary.dart';
import '../../core/models/slash_command.dart';
import '../../core/render/catalog_install.dart';
import '../../core/render/setup_beat.dart';
import '../../core/services/attachment_draft_service.dart';
import '../../core/services/chat_kanban_dock.dart';
import '../../core/services/completion_cue_player.dart';
import '../../core/services/remote_workspace.dart';
import '../../core/services/system_sleep_gate.dart';
import '../../core/services/composer_draft_store.dart';
import '../../core/services/connection_mutation_barrier.dart';
import '../../core/services/prepared_image_store.dart';
import '../../core/services/slash_command_errors.dart';
import '../../core/services/ws_client.dart';
import '../../core/composer/composer_commands.dart';
import '../../core/composer/failure_recovery.dart';
import '../../core/history/canonical_rewind.dart'
    show rewindFencesUnknownReason, rewindTargetUnsavedReason;
import '../../core/history/rewind_submit.dart'
    show
        RewindHistory,
        RewindPlan,
        buildRewindParams,
        isRejectedDeepTruncatePayload,
        stripRejectedDeepTruncate;
import '../../core/composer/regenerate.dart';
import 'history_rows.dart';
import 'nextgen_gateway.dart';
import 'session_control.dart';
import 'slash_exec.dart';
import '../nextgen_l10n.dart';

/// The gateway outcome for a per-chat model pick.
sealed class NgModelSwitchResult {
  const NgModelSwitchResult();
}

class NgModelSwitchDone extends NgModelSwitchResult {
  final String? resolvedModel;
  final Map<String, dynamic>? info;
  const NgModelSwitchDone({this.resolvedModel, this.info});
}

class NgModelSwitchDeferred extends NgModelSwitchResult {
  final String? resolvedModel;
  final Map<String, dynamic>? info;
  const NgModelSwitchDeferred({this.resolvedModel, this.info});
}

class NgModelSwitchNeedsConfirmation extends NgModelSwitchResult {
  final String message;
  const NgModelSwitchNeedsConfirmation(this.message);
}

class NgModelSwitchFailed extends NgModelSwitchResult {
  final String message;
  final bool clearConfirmation;
  const NgModelSwitchFailed(this.message, {this.clearConfirmation = true});
}

/// One tool call inside a reply.
class NgTool {
  final String id;
  String name;
  String? detail;
  bool running;
  String? summary;
  double? durationSeconds;
  String? input;
  String? output;
  bool failed;

  /// When the call started and finished, for the row's timestamp.
  DateTime? startedAt;
  DateTime? finishedAt;

  NgTool({
    required this.id,
    required this.name,
    this.detail,
    this.running = false,
    this.summary,
    this.durationSeconds,
    this.input,
    this.output,
    this.failed = false,
    this.startedAt,
    this.finishedAt,
  });
}

/// Kyllene's inline limit: anything larger than this goes over HTTP to the
/// gateway's upload instead of inside one WebSocket message.
const ngMaxInlineAttachmentBytes = 12 * 1000 * 1000;

/// The folder under the managed files' home that uploads wait in.
const ngUploadsFolder = '.ares-uploads';

/// [name] as one path segment the gateway finds again: no folders, no `..`,
/// no characters `file.attach` expands or its path checks turn down.
String ngSafeUploadName(String name) {
  final base = name.split('/').last.split(r'\').last;
  var cleaned = base
      .split('')
      .where((c) {
        final unit = c.codeUnitAt(0);
        return unit >= 0x20 && unit != 0x7f && !'<>:"|?*\$%'.contains(c);
      })
      .join()
      .replaceAll(RegExp(r'^[ .]+|[ .]+$'), '');
  if (cleaned.isEmpty) cleaned = 'attachment';
  if (cleaned.length > 200) {
    cleaned = cleaned.substring(0, 200).replaceAll(RegExp(r'[ .]+$'), '');
  }
  const devices = {'CON', 'PRN', 'AUX', 'NUL'};
  final stem = cleaned.split('.').first.toUpperCase();
  final device =
      devices.contains(stem) || RegExp(r'^(COM|LPT)[1-9]$').hasMatch(stem);
  return device ? '_$cleaned' : cleaned;
}

/// Separates a prompt's `@file:` attachment lines from its text.
(String, List<String>) splitFileRefs(String text) {
  final files = <String>[];
  final kept = <String>[];
  for (final line in text.split('\n')) {
    final match = RegExp(r'^\s*@file:(\S.*)$').firstMatch(line);
    if (match == null) {
      kept.add(line);
      continue;
    }
    var ref = match.group(1)!.trim();
    if (ref.length > 1 && ref.startsWith('`') && ref.endsWith('`')) {
      ref = ref.substring(1, ref.length - 1);
    }
    files.add(ref.split('/').last);
  }
  return (kept.join('\n').trim(), files);
}

/// Rows per history page, as Kyllene's `HISTORY_PAGE`.
const ngHistoryPage = 60;

/// Tool input/output kept per call; the view shows 4000 characters, so
/// multi-megabyte outputs need not sit in memory.
const ngStoredToolChars = 16000;

String? ngCapStored(String? text) =>
    text == null || text.length <= ngStoredToolChars
    ? text
    : '${text.substring(0, ngStoredToolChars)}…';

/// Bounds JSON serialization: compact-encode first, and only pretty-print
/// when the result fits the cap. Avoids formatting multi-MB maps on the UI
/// thread just to immediately truncate them.
String? ngBoundedToolJson(String? text, Object? value) {
  if (text != null) return text;
  if (value == null) return null;
  final compact = jsonEncode(value);
  if (compact.length > ngStoredToolChars) return compact;
  return const JsonEncoder.withIndent('  ').convert(value);
}

/// A full page starts mid-turn more often than not: drop the rows before its
/// first prompt so the turn shows whole once the next page brings them.
/// A page that is all one turn stays as it is.
List<Map<String, dynamic>> ngFromFirstTurn(List<Map<String, dynamic>> page) {
  final first = page.indexWhere((r) => r['role']?.toString() == 'user');
  return first <= 0 ? page : page.sublist(first);
}

sealed class NgItem {
  final String key;
  NgItem(this.key);
}

class NgUserItem extends NgItem {
  String text;
  final DateTime? time;

  /// Sent while the agent worked: steered into the running turn.
  final bool steered;

  /// Sent but the gateway hasn't confirmed it yet / refused it.
  bool pending;
  String? failure;

  /// Files sent with the prompt (kept until it is accepted, for Retry).
  final List<AttachmentDraft> attachments;

  /// Names of files a stored prompt referenced (`@file:` lines).
  final List<String> files;

  /// Original prompt refs before filename-only display projection.
  final String? fileReferenceText;

  /// Client-generated UUID for `prompt.submit` idempotency on modern gateways.
  String? submissionId;
  bool recoverInComposer = false;
  final String? composerImageText;

  /// The model-facing prompt when the bubble shows something else: a
  /// command's send/skill directive shows its `display` line in [text] and
  /// submits this. Null when [text] is what was sent.
  final String? sentText;

  /// Extra `prompt.submit` params (a regenerate's truncation target, a
  /// voice-live delegation's surface and context), sent again unchanged
  /// with the same submission id when the send is retried.
  final Map<String, Object> promptParams;

  /// The saved row behind a stored prompt (the gateway's `row_id`): the
  /// durable address an edit or restore cuts at. Null for a prompt of this
  /// visit, until history covers it.
  final int? rowId;

  NgUserItem(
    super.key,
    this.text, {
    this.rowId,
    this.time,
    this.steered = false,
    this.pending = false,
    this.attachments = const [],
    this.files = const [],
    this.fileReferenceText,
    this.submissionId,
    this.composerImageText,
    this.sentText,
    this.promptParams = const {},
  });
}

/// Where an edit or restore of a stored turn cuts
/// ([NgChatController.rewindTargetFor]): the durable row (null is Desktop's
/// plain resubmit), whether later user turns are archived, the turn's place
/// among the user turns, and the transcript's newest row.
typedef NgRewindTarget = ({
  int? rowId,
  bool laterTurns,
  int ordinal,
  int? maxRowId,
});

/// What [NgChatController.retryLast] did.
enum NgRetryResult {
  /// Nothing to retry (or the chat closed).
  nothing,

  /// An unaccepted submission went again under its submission id.
  resent,

  /// An accepted turn was regenerated in place.
  regenerated,

  /// An accepted turn with no durable row to replace: nothing was sent.
  notFound,

  /// The send failed; the transcript is as it was.
  failed,
}

/// A `/command` run on the gateway and what it answered: shown under the
/// command, local to this view, never part of the stored transcript.
class NgCommandItem extends NgItem {
  /// The command as typed (`/title Trip`).
  final String command;
  final DateTime time;

  /// The gateway's output (with any warning or notice), or why it failed.
  String output = '';
  bool running = true;
  bool failed = false;
  bool expanded = true;

  NgCommandItem(super.key, this.command, {required this.time});
}

class NgAssistantItem extends NgItem {
  String text = '';
  String reasoning = '';
  final List<NgTool> tools = [];
  bool open;
  DateTime? time;
  int? inputTokens;
  int? outputTokens;

  NgAssistantItem(super.key, {this.open = true, this.time});

  bool get isEmpty => text.isEmpty && reasoning.isEmpty && tools.isEmpty;
}

class NgNoticeItem extends NgItem {
  final String text;
  final bool error;
  DateTime? time;
  NgNoticeItem(super.key, this.text, {this.error = false, this.time});
}

/// What a collapsed system card is about.
enum NgSystemKind { task, process, note, summary }

/// Background results and runtime notices the agent receives as messages:
/// a finished background process, a delegated-task batch, a model fallback.
/// They are long and meant for the model, so they show collapsed.
class NgSystemItem extends NgItem {
  final NgSystemKind kind;
  final String body;
  final String? summary;
  final bool hasIssues;
  bool expanded = false;
  DateTime? time;
  NgSystemItem(
    super.key, {
    required this.kind,
    required this.body,
    this.summary,
    this.hasIssues = false,
  });

  /// One line for the collapsed card: the server's summary, else the first
  /// line of the body without its bracketed label.
  String get preview {
    final given = summary?.trim() ?? '';
    if (given.isNotEmpty) return given;
    for (final raw in body.split('\n')) {
      var line = raw.trim();
      if (line.isEmpty) continue;
      line = line
          .replaceFirst(RegExp(r'^\[+'), '')
          .replaceFirst(RegExp(r'\]+$'), '')
          .replaceFirst(RegExp(r'^(IMPORTANT|System|SYSTEM|NOTE)\s*:\s*'), '')
          .trim();
      if (line.isEmpty) continue;
      return line.length > 160 ? '${line.substring(0, 160)}…' : line;
    }
    return '';
  }
}

/// Classifies a history row (or a live notice) that the agent, not the
/// person, wrote: a collapsed card, or null when it is ordinary text.
NgSystemItem? ngSystemItemFor(String key, Map<String, dynamic> row) {
  final report = BackgroundReport.fromMessage(row);
  if (report != null) {
    // LCM context summaries get their own collapsed "Summary" card.
    final isLcm =
        report.kind == BackgroundReportKind.task &&
        LegacyLcmSummary.matches(report.body);
    return NgSystemItem(
      key,
      kind: isLcm
          ? NgSystemKind.summary
          : report.kind == BackgroundReportKind.process
          ? NgSystemKind.process
          : NgSystemKind.task,
      body: report.body,
      summary: report.summary,
      hasIssues: report.hasIssues,
    );
  }
  return null;
}

/// Short notices stay a centred line; long or multi-line ones collapse.
bool ngNoticeIsLong(String text) =>
    text.length > 160 || text.trim().contains('\n');

/// What [NgChatController.runDedicated] did: the card it answered under,
/// and the live session to watch when it requested a handoff.
class NgDedicatedResult {
  const NgDedicatedResult(this.card, {this.handoffSession});

  final NgCommandItem card;
  final String? handoffSession;
}

/// A queued prompt, sent when the running turn ends.
class NgQueued {
  final String key;
  final String text;

  /// What to show instead of [text] (a command's send/skill directive).
  final String? display;
  NgQueued(this.key, this.text, {this.display});
}

/// What running a typed command came to (see [NgChatController.runCommand]).
enum NgCommandResult {
  /// The gateway ran it; its answer is on the card.
  done,

  /// It became a prompt (a send/skill directive), sent or queued.
  sentAsPrompt,

  /// The gateway handed text back for the composer ([NgCommandOutcome.text]).
  prefill,

  /// The gateway refused it before running anything.
  refused,

  /// It could not run (not sent, or the gateway answered with an error).
  failed,

  /// Sent, but no reply came back: it may still be running.
  deliveryUnknown,

  /// This connection has no `slash.exec`: nothing ran, send it as a prompt.
  unsupported,
}

class NgCommandOutcome {
  const NgCommandOutcome(this.result, {this.text = '', this.item});
  final NgCommandResult result;

  /// The prefill text.
  final String text;

  /// The command's card, when it has one.
  final NgCommandItem? item;

  /// The draft should come back: nothing ran, or it may not have.
  bool get keepsDraft =>
      result == NgCommandResult.refused ||
      result == NgCommandResult.failed ||
      result == NgCommandResult.deliveryUnknown ||
      result == NgCommandResult.unsupported;
}

enum NgRequestKind { approval, clarify, secret, saveLogin, setupBeat }

class NgClarifyQuestion {
  final String? qid;
  final String question;
  final List<String> choices;
  final bool multiSelect;
  const NgClarifyQuestion(
    this.qid,
    this.question,
    this.choices,
    this.multiSelect,
  );
}

/// Something the agent is blocked on until the user answers.
class NgInputRequest {
  final NgServerRequest request;
  final NgRequestKind kind;
  final String title;
  final String body;
  final String? command;
  final List<String> choices;
  final List<NgClarifyQuestion> questions;
  final bool masked;

  /// The onboarding card, for [NgRequestKind.setupBeat].
  final SetupBeatRequest? setupBeat;

  NgInputRequest._(
    this.request, {
    required this.kind,
    required this.title,
    this.body = '',
    this.command,
    this.choices = const [],
    this.questions = const [],
    this.masked = true,
    this.setupBeat,
  });

  static List<String> _strings(Object? value) => value is List
      ? value
            .map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList()
      : const [];

  static NgInputRequest? parse(NgServerRequest request) {
    final p = request.params;
    String s(String key) => p[key]?.toString() ?? '';
    switch (request.method) {
      case 'approval':
        final offered = _strings(p['choices']);
        final choices = <String>{'once'};
        if (offered.isNotEmpty) {
          choices.addAll(offered);
        } else if (p['smart_denied'] != true && p['allow_session'] != false) {
          choices.add('session');
          if (p['allow_permanent'] != false) choices.add('always');
        }
        choices.add('deny');
        const order = ['once', 'session', 'always', 'deny'];
        final ordered = order.where(choices.contains).toList();
        final kind = s('kind');
        if (kind == 'access' || kind == 'network') {
          final description = s('description');
          final level = switch (s('access')) {
            'read' => ngL.ng_folder_read_only,
            'read_write' => ngL.ng_folder_read_write,
            _ => kind == 'access' ? ngL.ng_folder_access_unspecified : '',
          };
          final target = kind == 'access' ? s('path') : s('host');
          return NgInputRequest._(
            request,
            kind: NgRequestKind.approval,
            title: kind == 'access'
                ? ngL.ng_folder_access
                : ngL.ng_website_access,
            body: [
              if (description.isNotEmpty) description,
              if (level.isNotEmpty) level,
              ngL.ng_allow_until_sandbox_off,
            ].join('\n'),
            command: target,
            choices: ordered,
          );
        }
        return NgInputRequest._(
          request,
          kind: NgRequestKind.approval,
          title: ngL.ng_allow_this_command,
          body: s('description').isNotEmpty
              ? s('description')
              : s('tool_name').isNotEmpty
              ? ngL.ng_hermes_wants_to_run_this_with(s('tool_name'))
              : ngL.ng_hermes_wants_to_run_this,
          command: s('command'),
          choices: ordered,
        );
      case 'setup_beat':
        final card = SetupBeatRequest.parse(request.id, p);
        if (card == null) return null;
        return NgInputRequest._(
          request,
          kind: NgRequestKind.setupBeat,
          title: card.question,
          setupBeat: card,
        );
      case 'clarify':
        final batch = <NgClarifyQuestion>[];
        final raw = p['questions'];
        if (raw is List) {
          for (final q in raw) {
            if (q is! Map || q['qid'] == null) continue;
            batch.add(
              NgClarifyQuestion(
                q['qid'].toString(),
                q['question']?.toString() ?? '',
                _strings(q['choices']),
                q['multi_select'] == true,
              ),
            );
          }
        }
        if (batch.isEmpty && s('question').isNotEmpty) {
          batch.add(
            NgClarifyQuestion(
              null,
              s('question'),
              _strings(p['choices']),
              p['multi_select'] == true,
            ),
          );
        }
        if (batch.isEmpty) return null;
        return NgInputRequest._(
          request,
          kind: NgRequestKind.clarify,
          title: batch.length == 1
              ? ngL.ng_hermes_has_a_question
              : ngL.ng_hermes_has_questions,
          questions: batch,
        );
      case 'sudo':
        return NgInputRequest._(
          request,
          kind: NgRequestKind.secret,
          title: ngL.ng_password_for_sudo,
          body: ngL.ng_hermes_needs_your_sudo_password_to,
          command: s('command'),
        );
      case 'secret':
        return NgInputRequest._(
          request,
          kind: NgRequestKind.secret,
          title: s('env_var').isNotEmpty ? s('env_var') : ngL.ng_a_secret_value,
          body: s('prompt').isNotEmpty
              ? s('prompt')
              : ngL.ng_value_for(s('env_var')),
        );
      case 'vault.unlock_prompt':
        final name = s('display_name').isNotEmpty
            ? s('display_name')
            : s('backend').isNotEmpty
            ? s('backend')
            : ngL.ng_your_password_manager;
        return NgInputRequest._(
          request,
          kind: NgRequestKind.secret,
          title: ngL.ng_unlock(name),
          body: ngL.ng_hermes_needs_unlocked_to_sign_in(name),
        );
      case 'vault.code':
        final site = s('site');
        return NgInputRequest._(
          request,
          kind: NgRequestKind.secret,
          title: ngL.ng_sign_in_code,
          body: [
            site.isEmpty
                ? ngL.ng_enter_the_sign_in_code
                : ngL.ng_enter_the_sign_in_code_for(site),
            if (s('hint').isNotEmpty) s('hint'),
          ].join(' '),
          masked: false,
        );
      case 'vault.save_login':
        final site = s('site').isNotEmpty ? s('site') : s('origin');
        return NgInputRequest._(
          request,
          kind: NgRequestKind.saveLogin,
          title: site.isEmpty
              ? ngL.ng_save_a_login
              : ngL.ng_save_your_login(site),
          body: s('origin'),
        );
    }
    return null;
  }
}

/// Usage and cost for the chat (`session.usage`).
class NgUsage {
  final int input;
  final int output;
  final int reasoning;
  final int cacheRead;
  final double? cost;
  final int? contextUsed;
  final int? contextMax;
  final int calls;
  final double? cacheHitPct;
  final double? avgTps;
  final int? compressions;
  final bool contextEstimated;
  const NgUsage({
    this.input = 0,
    this.output = 0,
    this.reasoning = 0,
    this.cacheRead = 0,
    this.cost,
    this.contextUsed,
    this.contextMax,
    this.calls = 0,
    this.cacheHitPct,
    this.avgTps,
    this.compressions,
    this.contextEstimated = false,
  });

  static int _i(Object? v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;

  static NgUsage? parse(Object? raw) {
    if (raw is! Map) return null;
    final cost = raw['estimated_cost_usd'] ?? raw['cost_usd'] ?? raw['cost'];
    return NgUsage(
      input: _i(raw['input_tokens'] ?? raw['input']),
      output: _i(raw['output_tokens'] ?? raw['output']),
      reasoning: _i(raw['reasoning_tokens'] ?? raw['reasoning']),
      cacheRead: _i(raw['cache_read_tokens'] ?? raw['cache_read']),
      cost: cost is num ? cost.toDouble() : double.tryParse('$cost'),
      contextUsed: raw['context_used'] is num
          ? (raw['context_used'] as num).toInt()
          : raw['context_tokens'] is num
          ? (raw['context_tokens'] as num).toInt()
          : null,
      contextMax: raw['context_max'] is num
          ? (raw['context_max'] as num).toInt()
          : raw['context_length'] is num
          ? (raw['context_length'] as num).toInt()
          : null,
      calls: _i(raw['api_calls'] ?? raw['calls']),
      cacheHitPct:
          raw.containsKey('cache_hit_pct') && raw['cache_hit_pct'] is num
          ? (raw['cache_hit_pct'] as num).toDouble()
          : null,
      avgTps: raw.containsKey('avg_tps') && raw['avg_tps'] is num
          ? (raw['avg_tps'] as num).toDouble()
          : null,
      compressions:
          raw.containsKey('compressions') && raw['compressions'] is num
          ? (raw['compressions'] as num).toInt()
          : null,
      contextEstimated: raw['context_estimated'] == true,
    );
  }
}

class NgChatController extends ChangeNotifier {
  NgChatController(
    this.gateway, {
    String? sessionId,
    this.title = '',
    String? workingDirectory,
    this.onCreated,
    this.onTurnFinished,
    AttachmentDraftService? attachmentService,
    String? initialText,
    // Keep the public named argument while the mutable field stays private.
    // ignore: prefer_initializing_formals
  }) : _workingDirectory = workingDirectory,
       _imageEpoch = ConnectionMutationBarrier.capture(gateway.connection.id),
       storedId = sessionId,
       draftKey = sessionId ?? ComposerDraftStore.newLocalKey(),
       attachmentService = attachmentService ?? AttachmentDraftService() {
    _initialText = initialText;
    _subs.add(gateway.events.listen(_onEvent));
    _subs.add(gateway.serverRequests.listen(_onServerRequest));
    _subs.add(gateway.reconnected.listen((_) => unawaited(_reattach())));
    // The socket is up (again): the dock may read the board now.
    _subs.add(gateway.reconnected.listen((_) => unawaited(kanban.refresh())));
    // Answered on another device, withdrawn, or no longer open per the server.
    _subs.add(gateway.withdrawnRequests.listen(forgetRequest));
    SystemSleepGate.instance.addListener(_onSleepGate);
  }

  /// The computer slept or the session locked with this turn running: the
  /// paused socket cannot see it end, so keep-awake waits until this chat
  /// has re-attached and caught up after the pause ([_reattach]).
  void _onSleepGate() {
    if (_disposed) return;
    if (SystemSleepGate.instance.value && running) {
      SystemSleepGate.instance.holdReconcile(this);
    }
  }

  final NextGenGateway gateway;
  final String draftKey;

  /// One-shot composer prefill (used by validated `hermes://` deep links).
  /// Consumed exactly once by the chat view on mount; never re-applied.
  String? _initialText;
  String? consumeInitialText() {
    final value = _initialText;
    _initialText = null;
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  /// Offers a deep-link prefill to this chat's view (a mounted view picks it
  /// up on its next change notification, a new one when it mounts). The view
  /// appends it after any unsent draft; nothing is sent.
  void offerInitialText(String text) {
    if (_disposed || text.trim().isEmpty) return;
    _initialText = text;
    notifyListeners();
  }

  bool get draftOwnerCurrent => !_disposed && gateway.draftAccountCurrent;
  final Object? _imageEpoch;
  PreparedImageTarget? get imageTarget {
    final stored = storedId;
    if (_disposed ||
        stored == null ||
        !ConnectionMutationBarrier.isCurrent(
          gateway.connection.id,
          _imageEpoch,
        )) {
      return null;
    }
    return PreparedImageTarget(
      gateway.connection,
      stored,
      gateway.sessionAuthority
          ? PreparedImageTransport.nextgenCanonical
          : PreparedImageTransport.nextgenPending,
    );
  }

  String? _workingDirectory;
  String? get workingDirectory => _workingDirectory;
  bool _creatingSession = false;
  bool _createUncertain = false;

  /// A deliberate folder pick is local until the first session is created.
  /// Acquire creation authority before its first await; never change a cwd
  /// while create is in flight or after an ambiguous acknowledgement.
  bool get canPickProject =>
      !_disposed &&
      !_creatingSession &&
      !_createUncertain &&
      runtimeId == null &&
      storedId == null &&
      items.isEmpty &&
      !running;

  bool startIn(String? folder) {
    if (!canPickProject) return false;
    _workingDirectory = folder?.trim().isNotEmpty == true ? folder : null;
    _changed();
    return true;
  }

  /// Prepares and caches composer attachments (shared with classic chat).
  final AttachmentDraftService attachmentService;

  /// The stored session id (`/api/sessions`), null until the first send.
  String? storedId;

  /// The live session id on the current socket.
  String? runtimeId;

  String title;
  final List<NgItem> items = [];
  final List<NgQueued> queued = [];
  bool localQueuePaused = false;

  /// The local row whose editor is open. Drain skips it and may send later
  /// rows in their original order.
  String? editingLocalKey;
  bool _drainScheduled = false;
  bool running = false;
  bool loadingHistory = false;

  /// Earlier rows remain on the gateway; [loadOlder] fetches the next page.
  bool hasOlder = false;
  bool loadingOlder = false;

  /// Ids of the stored rows behind the transcript, oldest first; their
  /// count is the baseline offset (from the newest) of the next older page,
  /// raised by [_olderShift] for rows a page re-served. Only ids are kept:
  /// the rows themselves can be megabytes of tool output.
  final List<String?> _rowIds = [];

  /// A live turn's rows are stored by now, but the transcript shows that
  /// turn as the aggregate it streamed into. [_adoptPersistedIds] walks the
  /// newest pages after the turn ends and adopts the ids at the tail, so
  /// paging treats those rows as shown instead of re-inserting them as
  /// older items.
  bool _adopting = false;

  /// Rows a page re-served because a live turn appended rows after the
  /// window was built. A live turn persists rows while the reader is
  /// scrolled back, moving the newest end under [_rowIds.length]; carrying
  /// the overlap forward keeps every next offset behind the oldest row of
  /// the last page, so paging advances a full page per fetch and an
  /// all-known page cannot occur from growth alone. Reset with the window.
  int _olderShift = 0;

  Future<List<Map<String, dynamic>>> _fetchRows(
    String id, {
    required int limit,
    int offset = 0,
  }) async => ngDecodeHistory(
    await gateway.api.getMessagesBytes(
      id,
      limit: limit,
      offset: offset,
      latest: true,
    ),
  );
  String? historyError;
  String? status;
  String? thinkingFrame;
  String? error;
  FailureSurface? turnFailure;
  NgInputRequest? request;

  /// The open `manage_catalog` install card of this chat, if any.
  CatalogOperation? catalog;

  /// Answers this chat's catalog card through `connection.respond`, owned
  /// by this chat's runtime session. False when the card is not this chat's
  /// open operation any more or the gateway refused the answer.
  Future<bool> respondCatalog(
    CatalogOperation operation,
    Map<String, dynamic> answer,
  ) async {
    final current = catalog;
    final runtime = runtimeId;
    if (_disposed ||
        runtime == null ||
        current == null ||
        current.opId != operation.opId ||
        current.settled) {
      return false;
    }
    final result = await gateway.call('connection.respond', {
      'owner': {'type': 'session', 'session_id': runtime},
      'op_id': operation.opId,
      'result': answer,
    });
    return result['status'] == 'ok';
  }

  /// Hides a settled catalog card.
  void dismissCatalog(String opId) {
    if (catalog?.opId != opId || !(catalog?.settled ?? false)) return;
    catalog = null;
    _changed();
  }

  String? model;
  String? provider;
  String? reasoningEffort;

  /// What the route actually sends. Empty until session.info stamps it.
  String? reasoningEffortWire;
  NgUsage? usage;
  DateTime? turnStartedAt;

  /// The agent's plan, shown above the composer (Kyllene's task list).
  NgTodoList? todos;

  /// [todos] was written by the turn running now, not kept from an earlier
  /// one; a past plan shows folded as "Last plan".
  bool todosLive = false;

  /// The session's goal, loop and heartbeat (Kyllene's control strip).
  NgSessionControl? control;

  /// The control action in flight, and the last one's failure.
  NgControlAction? controlBusy;
  String? controlError;

  /// Delegated child agents this chat has seen (Kyllene's subagent dock).
  final List<NgSubagent> subagents = [];

  /// When the current batch of subagents started: the dock lists those
  /// since, so one delegation's finished siblings stay beside its live ones.
  DateTime? subagentBatchStart;

  /// The Kanban cards this chat sent to the board, for the dock: its own
  /// `kanban_create` / `kanban_link` calls plus the cards the board says this
  /// session created. Reads through this chat's own gateway owner only.
  late final ChatKanbanDockController kanban = ChatKanbanDockController(
    connectionId: gateway.connection.id,
    profile: gateway.profile,
    openSource: () => _disposed
        ? null
        : debugKanbanSource?.call() ?? WorkspaceChatKanbanSource(kanbanOwner),
    // The dock reads over the socket this chat opened; it never opens one.
    // The socket itself is asked, as [NextGenGateway.connected] asks it: a
    // connected state alone does not mean a socket is there to reuse.
    online: () =>
        debugKanbanSource != null || (gateway.socket?.isConnected ?? false),
  )..setChat(primaryId: storedId);

  /// The gateway owner the dock reads the board and opens it through.
  RemoteWorkspaceOwner get kanbanOwner => debugKanbanOwner ?? gateway.workspace;

  @visibleForTesting
  RemoteWorkspaceOwner? debugKanbanOwner;

  @visibleForTesting
  ChatKanbanSource Function()? debugKanbanSource;

  /// The subagents the dock shows while any of them is still live.
  List<NgSubagent> get dockSubagents {
    final start = subagentBatchStart;
    if (start == null || !subagents.any((a) => a.status.live)) return const [];
    return [
      for (final a in subagents)
        if (a.status.live || !a.startedAt.isBefore(start)) a,
    ];
  }

  bool _controlUnsupported = false;

  final void Function(String storedId)? onCreated;
  final void Function()? onTurnFinished;

  final List<StreamSubscription<dynamic>> _subs = [];
  int _seq = 0;
  bool _disposed = false;
  bool _attaching = false;
  Completer<void>? _attachCompleter;
  int? _revision;
  int? _executionGeneration;

  String _key(String prefix) => '$prefix-${_seq++}';

  /// Coalesces high-frequency streaming deltas to one notification per frame.
  /// Terminal events (turn end, errors, requests) use [_changedNow] instead.
  bool _framePending = false;
  void _changed() {
    if (_disposed || _framePending) return;
    _framePending = true;
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      _framePending = false;
      if (!_disposed) notifyListeners();
    });
  }

  /// Immediate notification for terminal/lifecycle events.
  void _changedNow() {
    if (_disposed) return;
    _framePending = false;
    notifyListeners();
  }

  bool get isNew => storedId == null;

  /// Loads the transcript, then attaches to the live session.
  Future<void> open() async {
    final id = storedId;
    if (id == null) {
      unawaited(_ensureInfo());
      return;
    }
    loadingHistory = true;
    historyError = null;
    _changed();
    try {
      final messages = await _fetchRows(id, limit: ngHistoryPage);
      if (_disposed) return;
      _setRows(messages, ngHistoryPage);
      // A page of hidden or tool-only rows shows nothing: reach back a few
      // pages for something to show rather than an empty chat.
      for (var i = 0; i < 4 && items.isEmpty && hasOlder && !_disposed; i++) {
        loadingHistory = false;
        await loadOlder();
        loadingHistory = true;
      }
    } catch (e) {
      historyError = ngL.ng_couldn_t_load_this_chat(e);
    } finally {
      loadingHistory = false;
      _changed();
    }
    await _attach();
  }

  Future<void> _ensureInfo() async {
    try {
      final info = await gateway.dashboard.getModelInfo();
      model ??= info['model']?.toString();
      provider ??= info['provider']?.toString();
      _changed();
    } catch (_) {
      // The model chip shows "Default" until a session reports one.
    }
  }

  Future<void> _attach() async {
    final id = storedId;
    if (id == null || _disposed) return;
    if (_attaching) {
      await _attachCompleter?.future;
      return;
    }
    _attaching = true;
    final attaching = Completer<void>();
    _attachCompleter = attaching;
    try {
      await gateway.connected();
      final known = gateway.openRequestIdsFor([id, runtimeId]);
      final result = await gateway.call('session.resume', {
        'session_id': id,
        'source': 'desktop',
        'omit_messages': true,
        'defer_history': true,
        // The canonical resume model forbids inline_images (#291).
        if (!gateway.sessionAuthority) 'inline_images': false,
      });
      if (_disposed || storedId != id) return;
      _withAuthority(result);
      // The first canonical attach starts the cursor at the snapshot's
      // watermark. A later one (a poll, a re-attach after a replay) keeps the
      // cursor of what was actually applied, so the bridged frames count.
      if (gateway.sessionAuthority && _cursor == null) {
        _acceptSnapshot(result);
      }
      runtimeId = result['session_id']?.toString() ?? runtimeId;
      if (runtimeId != null) gateway.bindRuntime(runtimeId!, id);
      // A compressed chat resumes as its continuation: cards it creates
      // from here on carry that session id.
      kanban.setChat(
        primaryId: id,
        aliases: [
          for (final key in const ['stored_session_id', 'resumed'])
            if (result[key] case final String alias) alias,
        ],
      );
      final wasRunning = running;
      running = result['running'] == true;
      if (running && !wasRunning) {
        turnStartedAt ??= DateTime.now();
        _captureGitTurnBaseline();
      }
      _withInfo(result['info']);
      _withTodos(NgTodoList.parse(result['todo_state']));
      _attachedOnce = true;
      unawaited(refreshControl());
      unawaited(refreshSubagents());
      // The server's list is authoritative: one answered elsewhere is gone.
      gateway.reconcileOpenRequests(result['open_requests'], known: known);
      // Requests that arrived before this chat bound its runtime id.
      for (final pending in gateway.openRequests.values) {
        _onServerRequest(pending);
      }
      _changed();
    } catch (e) {
      if (!_disposed) {
        error = ngL.ng_live_updates_are_unavailable(_clean(e));
        _changed();
      }
    } finally {
      _attaching = false;
      if (!attaching.isCompleted) attaching.complete();
      _attachCompleter = null;
    }
  }

  static int? _authorityInt(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  void _withAuthority(Map<String, dynamic> raw) {
    _adoptRevision(raw['revision']);
    _adoptExecutionGeneration(raw['execution_generation']);
  }

  void _adoptRevision(Object? value, {bool authoritative = false}) {
    final next = _authorityInt(value);
    if (next == null) return;
    if (authoritative || _revision == null || next > _revision!) {
      _revision = next;
    }
    final retained = _retainedModelMutation;
    final expected = _authorityInt(retained?['expected_revision']);
    if (retained != null && expected != null && expected < next) {
      final payload = retained['payload'];
      final sentToken = payload is Map ? payload['confirm']?.toString() : null;
      _clearRetainedModelMutation();
      if (sentToken != null && sentToken == _modelConfirmationToken) {
        _clearModelConfirmation();
      }
    }
  }

  void _adoptExecutionGeneration(Object? value) {
    final next = _authorityInt(value);
    if (next == null) return;
    if (_executionGeneration == null || next > _executionGeneration!) {
      _executionGeneration = next;
    }
  }

  static String _clean(Object e) => switch (e) {
    // The transport's own refusals, in the user's language.
    JsonRpcError(reason: rewindTargetUnsavedReason) =>
      ngL.rewind_target_unsaved,
    JsonRpcError(reason: rewindFencesUnknownReason) =>
      ngL.rewind_session_changed,
    _ => _cleanText(e),
  };

  static String _cleanText(Object e) => e
      .toString()
      .replaceFirst('Bad state: ', '')
      .replaceFirst('Exception: ', '')
      .replaceFirst(RegExp(r'^JsonRpcError\([^)]*\): '), '');

  void _captureGitTurnBaseline() {
    final session = storedId;
    if (session == null || session.isEmpty) return;
    unawaited(
      captureGitTurnBaseline(owner: gateway.workspace, sessionId: session),
    );
  }

  void _withInfo(Object? raw) {
    if (raw is! Map) return;
    final m = raw['model']?.toString();
    if (m != null && m.isNotEmpty) model = m;
    final p = raw['provider']?.toString();
    if (p != null && p.isNotEmpty) provider = p;
    if (raw.containsKey('reasoning_effort')) {
      final r = raw['reasoning_effort']?.toString() ?? '';
      reasoningEffort = r.isEmpty ? null : r;
      if (!raw.containsKey('reasoning_effort_wire')) {
        reasoningEffortWire = '';
      }
    }
    if (raw.containsKey('reasoning_effort_wire')) {
      reasoningEffortWire = raw['reasoning_effort_wire']?.toString() ?? '';
    }
    final t = raw['title']?.toString();
    if (t != null && t.trim().isNotEmpty) title = t;
    usage = NgUsage.parse(raw['usage']) ?? usage;
    // Context compression moves the chat to a continuation session and the
    // gateway says so here (`stored_session_id`). Cards made from then on
    // carry the new id, cards made before keep the old one: the dock counts
    // both as this chat's.
    final stored = raw['stored_session_id'];
    if (stored is String && stored.trim().isNotEmpty) {
      kanban.setChat(primaryId: storedId, aliases: [stored]);
    }
  }

  // ── History ─────────────────────────────────────────────────────────

  static String _plain(Object? content) {
    if (content == null) return '';
    if (content is String) return content;
    if (content is List) {
      return content
          .map((part) {
            if (part is String) return part;
            if (part is Map) {
              final type = part['type']?.toString() ?? '';
              if (type.contains('image')) return ngL.task_image_placeholder;
              // Only plain text: a structured `text` value (Kyllene #419)
              // is skipped rather than shown as a Dart map.
              final text = part['text'];
              return text is String ? text : '';
            }
            return '';
          })
          .where((t) => t.isNotEmpty)
          .join('\n');
    }
    if (content is Map) {
      final text = content['text'];
      return text is String ? text : '';
    }
    return '';
  }

  static DateTime? _time(Object? ts) {
    if (ts is num && ts > 0) {
      return DateTime.fromMillisecondsSinceEpoch((ts * 1000).round());
    }
    return null;
  }

  /// A runtime notice: a centred line when short, else a collapsed card.
  void _addNotice(String text, {DateTime? time, List<NgItem>? into}) {
    final items = into ?? this.items;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final at = time ?? DateTime.now();
    final report = ngSystemItemFor(_key('s'), {
      'role': 'user',
      'content': trimmed,
    });
    if (report != null) {
      items.add(report..time = at);
    } else if (ngNoticeIsLong(trimmed)) {
      items.add(
        NgSystemItem(_key('s'), kind: NgSystemKind.note, body: trimmed)
          ..time = at,
      );
    } else {
      items.add(NgNoticeItem(_key('n'), trimmed, time: at));
    }
  }

  /// A local command result (side question, background, handoff, compress).
  void showCommandNotice(String text) {
    _addNotice(text);
    _changedNow();
  }

  /// Re-read the transcript after a compression. Does not open a new session.
  Future<void> reloadTranscript() async {
    final id = storedId;
    if (id == null || _disposed) return;
    final messages = await _fetchRows(id, limit: ngHistoryPage);
    if (_disposed) return;
    _setRows(messages, ngHistoryPage);
    _changedNow();
  }

  @visibleForTesting
  void debugApplyHistory(
    List<Map<String, dynamic>> messages, {
    int? pageLimit,
  }) => _setRows(messages, pageLimit ?? messages.length + 1);

  /// Shows [page] (the newest rows, asked for with [limit]) as the whole
  /// transcript.
  void _setRows(List<Map<String, dynamic>> page, int limit) {
    kanban.observeHistoryRows(page);
    final full = page.length >= limit;
    final rows = full ? ngFromFirstTurn(page) : page;
    hasOlder = full;
    _olderShift = 0;
    _rowIds
      ..clear()
      ..addAll(rows.map((r) => r['id']?.toString()));
    items
      ..clear()
      ..addAll(_itemsFrom(rows));
  }

  /// Loads the page of rows before the oldest one shown, as Kyllene does
  /// when the transcript is scrolled near its top.
  Future<void> loadOlder() async {
    final id = storedId;
    if (id == null || !hasOlder || loadingOlder || loadingHistory) return;
    loadingOlder = true;
    _changed();
    try {
      final offset = _rowIds.length + _olderShift;
      final guardLength = _rowIds.length;
      final guardShift = _olderShift;
      final page = await _fetchRows(id, limit: ngHistoryPage, offset: offset);
      if (_disposed) return;
      kanban.observeHistoryRows(page);
      // Adoption or a window rebuild during the fetch moved the accounting
      // this page's offset was computed from. Applying it would double-count
      // the adopted rows in the shift; drop it and let the next scroll retry
      // against the current window.
      if (_rowIds.length != guardLength || _olderShift != guardShift) return;
      final full = page.length >= ngHistoryPage;
      final known = _rowIds.whereType<String>().toSet();
      // Rows already shown come again when the chat grew since.
      // Drop rows already shown before trimming: a partially-known page's
      // unseen rows can be the tail of a long turn with no prompt in them,
      // and trimming first would cut exactly those and let the shift
      // advance a whole page past them.
      final unknown = page
          .where((r) => r['id'] == null || !known.contains('${r['id']}'))
          .toList();
      final fresh = full ? ngFromFirstTurn(unknown) : unknown;
      hasOlder = full;
      // Carry the overlap forward: the re-served rows are ones a live turn
      // appended after the window was built, so the next offset must skip
      // them on top of the shown rows instead of pointing back into them.
      // Rows trimmed away below count as neither known nor shown, so the
      // next page re-reads exactly them.
      _olderShift += page.length - unknown.length;
      if (fresh.isNotEmpty) {
        _rowIds.insertAll(0, fresh.map((r) => r['id']?.toString()));
        items.insertAll(0, _itemsFrom(fresh));
      }
    } catch (_) {
      // Scrolling to the top again retries.
    } finally {
      loadingOlder = false;
      _changed();
    }
  }

  /// Adopts the stored ids a finished live turn appended at the newest end.
  /// The transcript already shows the turn as the aggregate it streamed
  /// into, but [_rowIds] never learned those rows, so without this a page
  /// reaching them would re-insert them as older duplicates. Walks newest
  /// pages while the tail is unknown, adopting only the unknown run after
  /// the last known row — unknown rows below it are older history, not yet
  /// shown. The walk has no page cap: it stops at the first known row or a
  /// short page, so a turn of any length is fully adopted. Adopted rows were
  /// being carried by [_olderShift] as unlearned growth, so the shift shrinks
  /// by the adopted count to keep the next offset on real coverage. Best
  /// effort: a window rebuild mid-fetch aborts, and rows that persist between
  /// a fetch and its adopt stay covered by [_olderShift].
  Future<void> _adoptPersistedIds() async {
    final id = storedId;
    if (id == null || _disposed || _adopting) return;
    // An empty trimmed window shows nothing to reconcile against; adopting
    // would mark unseen history as shown. A resync rebuilds the window.
    if (_rowIds.isEmpty) return;
    _adopting = true;
    try {
      var baseline = _rowIds.length;
      for (var page = 0; ; page++) {
        final rows = await _fetchRows(
          id,
          limit: ngHistoryPage,
          offset: page * ngHistoryPage,
        );
        if (_disposed || storedId != id || _rowIds.length != baseline) return;
        // The finished turn's stored rows: its Kanban calls are here even
        // when the gateway sent no live tool events for them.
        kanban.observeHistoryRows(rows);
        final known = _rowIds.whereType<String>().toSet();
        var cut = rows.length;
        while (cut > 0) {
          final rid = rows[cut - 1]['id']?.toString();
          if (rid != null && known.contains(rid)) break;
          cut--;
        }
        if (cut == rows.length) return;
        final adopted = rows.length - cut;
        _rowIds.addAll([
          for (final r in rows.sublist(cut)) r['id']?.toString(),
        ]);
        // The shift was carrying these same rows as unlearned growth; now
        // that they are shown ids, drop them from the shift so the next
        // offset does not overshoot real coverage.
        _olderShift -= adopted;
        if (_olderShift < 0) _olderShift = 0;
        baseline = _rowIds.length;
        if (cut > 0 || rows.length < ngHistoryPage) return;
      }
    } catch (_) {
      // The next turn end or resync tries again; the shift covers the gap.
    } finally {
      _adopting = false;
    }
  }

  List<NgItem> _itemsFrom(List<Map<String, dynamic>> messages) {
    final items = <NgItem>[];
    NgAssistantItem? reply;
    final toolsById = <String, NgTool>{};
    for (final m in messages) {
      final role = m['role']?.toString();
      final displayKind = m['display_kind']?.toString();
      final text = _plain(m['display_content'] ?? m['content']);
      final metadata = m['display_metadata'];
      if (displayKind == 'hidden' ||
          (metadata is Map && metadata['model_only'] == true)) {
        continue;
      }
      // Background results, delegated-task batches, model switches and
      // other runtime notices arrive as rows; show them collapsed.
      final system = ngSystemItemFor(_key('s'), m);
      if (system != null) {
        // A user-role row ends the reply before it, so the card sits where
        // it happened and the next answer starts a new block.
        reply?.open = false;
        reply = null;
        items.add(system..time = _time(m['timestamp']));
        continue;
      }
      // Merged rows: a summary envelope absorbed into an assistant turn.
      // Collapse the envelope; keep the tail as a visible assistant reply.
      if (role == 'assistant' || role == 'agent' || role == 'user') {
        final split = LegacyLcmSummary.splitEnvelope(text);
        if (split != null) {
          reply?.open = false;
          reply = null;
          items.add(
            NgSystemItem(_key('s'), kind: NgSystemKind.summary, body: split.$1)
              ..time = _time(m['timestamp']),
          );
          // The tail is the assistant's real answer; render it normally.
          if (role == 'user') {
            final (body, files) = splitFileRefs(split.$2);
            items.add(
              NgUserItem(
                _key('u'),
                body,
                time: _time(m['timestamp']),
                files: files,
                fileReferenceText: split.$2,
              ),
            );
          } else {
            reply = NgAssistantItem(_key('a'), open: false);
            reply.text = split.$2;
            items.add(reply);
          }
          continue;
        }
      }
      if (role == 'user') {
        if (displayKind != null &&
            displayKind.isNotEmpty &&
            displayKind != 'steer') {
          reply?.open = false;
          reply = null;
          _addNotice(text, time: _time(m['timestamp']), into: items);
          continue;
        }
        if (text.startsWith('[System:')) continue;
        reply?.open = false;
        reply = null;
        final (body, files) = splitFileRefs(text);
        final rawId = m['id'];
        items.add(
          NgUserItem(
            _key('u'),
            body,
            rowId: rawId is int && rawId > 0 ? rawId : null,
            time: _time(m['timestamp']),
            steered: displayKind == 'steer',
            files: files,
            fileReferenceText: text,
          ),
        );
      } else if (role == 'assistant') {
        reply ??= () {
          final r = NgAssistantItem(_key('a'), open: false);
          items.add(r);
          return r;
        }();
        final reasoning =
            (m['display_reasoning'] ?? m['reasoning'])?.toString() ?? '';
        if (reasoning.trim().isNotEmpty) {
          reply.reasoning = reply.reasoning.isEmpty
              ? reasoning
              : '${reply.reasoning}\n\n$reasoning';
        }
        if (text.trim().isNotEmpty) {
          reply.text = reply.text.isEmpty ? text : '${reply.text}\n\n$text';
        }
        reply.time = _time(m['timestamp']) ?? reply.time;
        final calls = m['tool_calls'];
        if (calls is List) {
          for (final call in calls) {
            if (call is! Map) continue;
            final fn = call['function'];
            final id = call['id']?.toString() ?? _key('t');
            final name =
                (fn is Map ? fn['name'] : call['name'])?.toString() ?? 'tool';
            final args = fn is Map ? fn['arguments'] : call['arguments'];
            final tool = NgTool(
              id: id,
              name: name,
              detail:
                  call['label']?.toString() ??
                  (call.containsKey('ng_args_preview')
                      ? call['ng_args_preview']?.toString()
                      : ngArgsPreview(args)),
              input: ngCapStored(
                args is String
                    ? args
                    : (args == null ? null : jsonEncode(args)),
              ),
              startedAt: _time(m['timestamp']),
            );
            toolsById[id] = tool;
            reply.tools.add(tool);
          }
        }
      } else if (role == 'tool') {
        final id = m['tool_call_id']?.toString();
        final tool = id == null ? null : toolsById[id];
        if (tool != null) {
          tool.output = ngCapStored(text);
          tool.summary = _firstLine(text);
          tool.finishedAt = _time(m['timestamp']);
        }
      }
    }
    return items;
  }

  static String? _firstLine(String? text) => ngFirstLine(text);

  // ── Live events ─────────────────────────────────────────────────────

  /// The last item that is not a command card: a command run mid-turn adds
  /// its card under the streaming reply without ending it.
  NgItem? get _lastTurnItem {
    for (var i = items.length - 1; i >= 0; i--) {
      if (items[i] is! NgCommandItem) return items[i];
    }
    return null;
  }

  NgAssistantItem _openReply() {
    final last = _lastTurnItem;
    if (last is NgAssistantItem && last.open) return last;
    final reply = NgAssistantItem(_key('a'));
    items.add(reply);
    return reply;
  }

  bool _isMine(StreamEvent event) {
    final id = event.sessionId;
    if (id == null) return false;
    return id == runtimeId || id == storedId;
  }

  // ── Catch-up (Kyllene's ChatSession.catchUp) ──────────────────────────

  /// Legacy (non-authority) gateways number events per gateway process: the
  /// last live event applied (`seq`) and the `gateway.ready` epoch it was
  /// counted in.
  int? _lastSeq;
  String? _seqEpoch;

  /// After a legacy reload found no turn running, turn frames held during
  /// it belong to a turn the transcript already shows: dropped until the
  /// next turn starts. Legacy frames carry no snapshot watermark to fence on.
  bool _legacyDropSettledTurn = false;

  /// The canonical session authority numbers each session's events per
  /// SessionEvents lifetime (`replay_epoch` on its snapshots and frames),
  /// unrelated to the process epoch in `gateway.ready`: the position of the
  /// last event applied, or of the snapshot accepted in its place.
  NgReplayCursor? _cursor;

  /// This session's earlier event streams (a restart, a released stream):
  /// their late frames are dropped, never read as a new stream.
  final Set<String> _retiredEpochs = {};

  /// The open reply is missing part of what its turn streamed (attached
  /// mid-turn, reloaded, or a hole replay could not fill), so the turn's
  /// final text replaces it instead of being spliced after the hole.
  bool _replyGap = false;

  /// Live events held while a catch-up fills a gap, applied after it.
  List<StreamEvent>? _held;

  /// Whether the last turn ended in an error or was stopped, for its
  /// notification.
  bool lastTurnFailed = false;
  bool lastTurnInterrupted = false;

  String? _readyEpoch() {
    final frame = gateway.readyFrame;
    if (frame == null) return null;
    Object? find(Object? m) {
      if (m is! Map) return null;
      return m['replay_epoch'] ?? find(m['payload']) ?? find(m['params']);
    }

    return find(frame)?.toString();
  }

  static String? _frameEpoch(StreamEvent event) {
    final epoch = event.envelope['replay_epoch'];
    return epoch is String && epoch.isNotEmpty ? epoch : null;
  }

  /// Takes a canonical snapshot's watermark as the cursor: frames it covers
  /// are not applied again, and an earlier stream's frames are dropped.
  void _acceptSnapshot(Map<String, dynamic> snapshot) {
    final epoch = snapshot['replay_epoch'];
    final sequence = snapshot['last_sequence'];
    if (epoch is! String || epoch.isEmpty || sequence is! int) return;
    if (sequence < 0) return;
    final next = NgReplayCursor(epoch, sequence);
    final previous = _cursor;
    if (previous != null && previous.epoch != epoch) {
      _retiredEpochs.add(previous.epoch);
    }
    _retiredEpochs.remove(epoch);
    final missed = previous == null
        ? sequence > 0
        : previous.epoch != epoch || previous.sequence < sequence;
    if (snapshot['running'] == true && missed) _replyGap = true;
    _cursor = next;
  }

  void _onEvent(StreamEvent event) {
    if (_disposed || !_isMine(event)) return;
    _deliver(event);
  }

  /// Applies a live event in order: one already applied is skipped, and one
  /// past a gap waits, with those after it, while [_catchUp] fills the gap.
  /// [draining] marks the held events a finished catch-up lets through.
  void _deliver(StreamEvent event, {bool draining = false}) {
    final held = _held;
    if (held != null) {
      held.add(event);
      return;
    }
    if (gateway.sessionAuthority) {
      _deliverCanonical(event, draining: draining);
      return;
    }
    if (draining && _legacyDropSettledTurn) {
      if (event.type == 'message.start') {
        _legacyDropSettledTurn = false;
      } else if (_settledTurnFrames.contains(event.type)) {
        return;
      }
    }
    final seq = event.seq;
    final last = _lastSeq;
    if (seq != null && last != null) {
      if (_seqEpoch != null && _readyEpoch() != _seqEpoch) {
        // The gateway restarted and counts anew: reload rather than trust.
        _held = [event];
        unawaited(_catchUp());
        return;
      }
      if (seq <= last) return;
      if (seq > last + 1) {
        _held = [event];
        unawaited(_catchUp());
        return;
      }
    }
    _applyEvent(event);
  }

  static const _settledTurnFrames = {
    'message.delta',
    'message.interim',
    'message.complete',
    'reasoning.delta',
    'reasoning.available',
    'thinking.delta',
    'tool.start',
    'tool.generating',
    'tool.complete',
    'status.update',
    'turn.end',
    'turn.error',
    'error',
  };

  void _deliverCanonical(StreamEvent event, {required bool draining}) {
    if (event.type == 'session.replay_gap') {
      // The owner retired this socket's subscription (its backlog overflowed)
      // while the socket stayed up: nothing more arrives live until the chat
      // replays what it missed and attaches again.
      _held = [];
      unawaited(_catchUp(resubscribe: true));
      return;
    }
    final seq = event.seq;
    final epoch = _frameEpoch(event);
    final cursor = _cursor;
    if (seq == null || epoch == null || cursor == null) {
      _applyEvent(event);
      return;
    }
    if (epoch != cursor.epoch) {
      // A retired stream's straggler; or, right after a catch-up settled
      // the current stream, a frame from before what it accepted.
      if (draining || _retiredEpochs.contains(epoch)) return;
      _held = [event];
      unawaited(_catchUp());
      return;
    }
    if (seq <= cursor.sequence) return;
    if (seq > cursor.sequence + 1) {
      if (draining) {
        // Past what the catch-up just settled. Never chase it with another
        // catch-up straight away (an owner answering with an older
        // watermark would loop): apply it, and the running reply's final
        // text fills the hole.
        if (running) _replyGap = true;
        _applyEvent(event);
        return;
      }
      _held = [event];
      unawaited(_catchUp());
      return;
    }
    _applyEvent(event);
  }

  /// Catches the open chat up after the app was away: a backgrounded phone
  /// misses live events, and a socket that never reported a drop stays
  /// "connected", so nothing else would fetch what was missed.
  void resync() {
    if (_disposed || runtimeId == null || storedId == null) return;
    if (_held != null || _attaching) return;
    if (!(gateway.socket?.isConnected ?? false)) return;
    _held = [];
    unawaited(_catchUp(foreground: true));
  }

  /// Re-attaches after the socket came back, then fills what was missed.
  Future<void> _reattach() async {
    try {
      if (_disposed) return;
      // The first connect is the chat opening, which reads everything anyway.
      if (!_attachedOnce) {
        await _attach();
        return;
      }
      _held ??= [];
      if (gateway.sessionAuthority && _cursor != null) {
        // Replay first, then attach: the owner bridges whatever it publishes
        // between the two onto this socket.
        await _catchUp(resubscribe: true);
        return;
      }
      await _attach();
      await _catchUp();
    } finally {
      // Caught up after a pause: [running] is current again.
      if (!SystemSleepGate.instance.value) {
        SystemSleepGate.instance.releaseReconcile(this);
      }
    }
  }

  bool _attachedOnce = false;

  /// Replays the events after the cursor from the gateway's ring
  /// (`session.events.since`), then lets held live events through. When the
  /// ring can't (an older gateway, too long away, a restart, a new stream)
  /// the gateway's state is read again ([_reconcile]); a turn that ended
  /// meanwhile still finishes here, so its reply notifies. [resubscribe]
  /// re-attaches after a successful replay, for a retired subscription.
  Future<void> _catchUp({
    bool foreground = false,
    bool resubscribe = false,
  }) async {
    final rt = runtimeId;
    List<StreamEvent>? missed;
    if (rt != null && gateway.sessionAuthority) {
      final cursor = _cursor;
      if (cursor != null) {
        try {
          final known = gateway.openRequestIdsFor([rt, storedId]);
          final reply = await gateway.call('session.events.since', {
            'session_id': rt,
            'replay_epoch': cursor.epoch,
            'last_sequence': cursor.sequence,
          });
          missed = ngParseCanonicalReplay(
            reply,
            rt,
            cursor.epoch,
            cursor.sequence,
          );
          gateway.reconcileOpenRequests(reply['open_requests'], known: known);
        } catch (_) {
          missed = null; // replay unavailable, or the link went again
        }
      }
    } else if (rt != null) {
      final from = _lastSeq;
      if (from != null && _seqEpoch == _readyEpoch()) {
        try {
          final known = gateway.openRequestIdsFor([rt, storedId]);
          final reply = await gateway.call('session.events.since', {
            'session_id': rt,
            'last_seen': from,
          });
          missed = ngParseReplay(reply, rt, from, _seqEpoch);
          gateway.reconcileOpenRequests(reply['open_requests'], known: known);
        } catch (_) {
          missed = null; // older gateway, or the link went again
        }
      }
    }
    if (_disposed) return;
    if (missed != null) {
      for (final e in missed) {
        _applyEvent(e);
      }
      if (resubscribe) await _attach();
    } else {
      await _reconcile(foreground: foreground);
    }
    if (_disposed) return;
    final held = _held ?? const <StreamEvent>[];
    _held = null;
    for (final e in held) {
      _deliver(e, draining: true);
    }
    _legacyDropSettledTurn = false;
    _changed();
  }

  /// Reads the gateway's own state when the missed events can't be
  /// replayed: whether the turn still runs and what waits on the user
  /// (`session.resume`), then the transcript — unless, back in sight
  /// mid-turn, the live reply is kept because the transcript has none of
  /// what it streamed. Nothing on screen changes until the reads are in; if
  /// either fails the live view stays and the next resync tries again.
  /// Nothing is ever sent again from here.
  Future<void> _reconcile({required bool foreground}) async {
    final id = storedId;
    final rt = runtimeId;
    final canonical = gateway.sessionAuthority;
    final wasRunning = running;
    final shownGeneration = _executionGeneration;
    if (id == null) {
      _dropCursor(canonical);
      return;
    }
    // The same window as shown, so a long scroll back isn't lost.
    final limit = max(ngHistoryPage, _rowIds.length).clamp(1, 500);
    Map<String, dynamic>? snapshot;
    List<Map<String, dynamic>>? rows;
    // Requests cached when the read started: the reply settles only these.
    var known = const <String>{};
    try {
      if (rt != null) {
        known = gateway.openRequestIdsFor([rt, id]);
        snapshot = await gateway.call('session.resume', {
          'session_id': id,
          'source': 'desktop',
          'omit_messages': true,
          'defer_history': true,
          // The canonical resume model forbids inline_images (#291).
          if (!canonical) 'inline_images': false,
        });
      }
      if (_disposed) return;
      final nowRunning = snapshot == null
          ? running
          : snapshot['running'] == true;
      // A canonical owner names its claim: a newer turn running now is not
      // the reply on screen, so that one is reloaded, never continued.
      final sameTurn =
          !canonical ||
          snapshot == null ||
          snapshot['execution_generation'] == shownGeneration;
      if (!(foreground && wasRunning && nowRunning && sameTurn)) {
        rows = await _fetchRows(id, limit: limit);
      }
      if (_disposed) return;
    } catch (_) {
      // Nothing was admitted. Live events still come, and whatever this
      // left out of the running reply is a hole its final text fills.
      if (_disposed) return;
      if (running) _replyGap = true;
      _dropCursor(canonical);
      return;
    }
    if (snapshot != null) {
      _withAuthority(snapshot);
      runtimeId = snapshot['session_id']?.toString() ?? runtimeId;
      running = snapshot['running'] == true;
      _withInfo(snapshot['info']);
      if (canonical) {
        _acceptSnapshot(snapshot);
      } else {
        _lastSeq = null;
      }
      // A question asked while the app was away comes back only here, and
      // one answered on another device is dropped only here.
      final open = snapshot['open_requests'];
      gateway.reconcileOpenRequests(open, known: known);
      if (open is List && open.isNotEmpty) {
        for (final pending in gateway.openRequests.values.toList()) {
          _onServerRequest(pending);
        }
      }
    } else {
      _dropCursor(canonical);
    }
    if (rows == null) {
      // Back mid-turn and it still runs: the live reply stays as it shows.
      // What streamed while away is a hole its final text fills (a canonical
      // snapshot said whether there was one).
      if (running && (!canonical || snapshot == null)) _replyGap = true;
      return;
    }
    final keepQueued = List.of(queued);
    _setRows(rows, limit);
    queued
      ..clear()
      ..addAll(keepQueued);
    if (running) {
      _openReply();
      _replyGap = true;
    } else {
      if (!canonical) _legacyDropSettledTurn = true;
      if (wasRunning) {
        // It ended while the app was away.
        lastTurnFailed = false;
        lastTurnInterrupted = false;
        _finishTurn();
      }
    }
  }

  void _dropCursor(bool canonical) {
    if (canonical) {
      _cursor = null;
    } else {
      _lastSeq = null;
    }
  }

  void _applyEvent(StreamEvent event) {
    final seq = event.seq;
    if (seq != null) {
      if (gateway.sessionAuthority) {
        final epoch = _frameEpoch(event);
        if (epoch != null) _cursor = NgReplayCursor(epoch, seq);
      } else {
        _lastSeq = seq;
        _seqEpoch = _readyEpoch();
      }
    }
    final p = event.data;
    _adoptExecutionGeneration(
      event.envelope['execution_generation'] ?? p['execution_generation'],
    );
    String? s(String key) {
      final v = p[key];
      return v?.toString();
    }

    switch (event.type) {
      case 'message.start':
        // A new turn hasn't planned yet; the last plan is from before.
        final starting = !running;
        todosLive = todosLive && running;
        running = true;
        _replyGap = false;
        error = null;
        if (starting) {
          turnStartedAt ??= DateTime.now();
          _captureGitTurnBaseline();
        }
        for (final item in items.whereType<NgUserItem>()) {
          item.pending = false;
        }
        _openReply();
      case 'message.delta':
        final chunk = s('text');
        if (chunk != null && chunk.isNotEmpty) {
          _openReply().text += chunk;
          running = true;
          thinkingFrame = null;
        }
      case 'message.interim':
        if (p['already_streamed'] != true) {
          final chunk = s('text');
          if (chunk != null && chunk.isNotEmpty) {
            _openReply().text += '$chunk\n\n';
          }
        }
      case 'reasoning.delta' || 'reasoning.available':
        final chunk = s('text');
        if (chunk != null) _openReply().reasoning += chunk;
      case 'thinking.delta':
        final frame = s('text')?.trim();
        if (frame != null && frame.isNotEmpty) thinkingFrame = frame;
      case 'tool.start':
        final id = s('tool_id');
        if (id == null) return;
        final reply = _openReply();
        reply.tools.removeWhere((t) => t.id == id);
        reply.tools.add(
          NgTool(
            id: id,
            name: s('name') ?? 'tool',
            detail: s('context') ?? s('preview') ?? ngArgsPreview(p['args']),
            running: true,
            input: ngCapStored(ngBoundedToolJson(s('args_text'), p['args'])),
            startedAt: DateTime.now(),
          ),
        );
        running = true;
        thinkingFrame = null;
      case 'tool.generating':
        final name = s('name');
        if (name != null) thinkingFrame = ngL.ng_preparing(name);
      case 'tool.complete':
        final id = s('tool_id');
        if (id == null) return;
        NgTool? tool;
        for (final item in items.reversed) {
          if (item is NgAssistantItem) {
            for (final t in item.tools) {
              if (t.id == id) tool = t;
            }
            if (tool != null) break;
          }
        }
        tool ??= () {
          final t = NgTool(id: id, name: s('name') ?? 'tool');
          _openReply().tools.add(t);
          return t;
        }();
        tool.running = false;
        tool.finishedAt = DateTime.now();
        tool.summary = s('summary') ?? tool.summary;
        final d = p['duration_s'];
        tool.durationSeconds = d is num ? d.toDouble() : tool.durationSeconds;
        final result = p['result'];
        tool.output = ngCapStored(
          ngBoundedToolJson(
                s('result_text'),
                result is String ? null : result,
              ) ??
              (result is String ? result : tool.output),
        );
        tool.failed =
            result is Map &&
            (result['success'] == false || result['error'] != null);
        kanban.observeToolCall(
          name: s('name') ?? tool.name,
          args: p['args'] ?? tool.input,
          result: result ?? s('result_text'),
        );
      case 'status.update':
        final text = s('text');
        status = text == null || text.trim().isEmpty ? null : text;
      case 'session.usage':
        usage = NgUsage.parse(p['usage']) ?? usage;
      case 'todo.updated':
        _withTodos(NgTodoList.parse(p));
      case 'subagent.spawn_requested' ||
          'subagent.start' ||
          'subagent.progress' ||
          'subagent.thinking' ||
          'subagent.tool' ||
          'subagent.complete':
        final wasLive = subagents.any((a) => a.status.live);
        final agent = ngApplySubagentEvent(subagents, event.type, p);
        if (!wasLive && agent != null && agent.status.live) {
          subagentBatchStart = agent.startedAt;
        }
        _trimSubagents();
      case 'session.control.update':
        if (p.containsKey('control')) {
          _withControl(NgSessionControl.parse(p['control']));
        }
      case 'session.updated':
        _adoptRevision(p['revision']);
        if (p['operation'] == 'model' &&
            p['status'] == 'confirmation_required') {
          final committedModel = _nonEmptyString(p['committed_model']);
          if (committedModel != null) model = committedModel;
          final committedProvider = _nonEmptyString(p['committed_provider']);
          if (committedProvider != null) provider = committedProvider;
          final confirmMsg =
              _nonEmptyString(p['confirm_message']) ??
              _nonEmptyString(p['warning']);
          if (confirmMsg != null) error = confirmMsg;
          final token = p['confirm']?.toString();
          final payload = p['payload'];
          final targetModel = payload is Map
              ? payload['model']?.toString()
              : null;
          final targetProvider = payload is Map
              ? payload['provider']?.toString() ?? ''
              : '';
          if (token != null &&
              token.isNotEmpty &&
              targetModel != null &&
              targetModel.isNotEmpty) {
            _modelConfirmationKey = '$targetProvider/$targetModel';
            _modelConfirmationToken = token;
            _modelConfirmationSent = false;
          }
        } else if (p['operation'] == 'model' && p['status'] == 'refused') {
          final committedModel = _nonEmptyString(p['model']);
          if (committedModel != null) model = committedModel;
          final committedProvider = _nonEmptyString(p['provider']);
          if (committedProvider != null) provider = committedProvider;
          final reason =
              _nonEmptyString(p['message']) ?? _nonEmptyString(p['reason']);
          if (reason != null) error = reason;
        } else {
          _withInfo(p['info']);
          final updatedModel = _nonEmptyString(p['model']);
          if (updatedModel != null) model = updatedModel;
          final updatedProvider = _nonEmptyString(p['provider']);
          if (updatedProvider != null) provider = updatedProvider;
        }
      case 'session.info':
        _adoptRevision(p['revision'], authoritative: true);
        _withInfo(p);
      case 'session.title':
        final t = s('title');
        if (t != null && t.trim().isNotEmpty) title = t;
      case 'notice':
        final message = s('message')?.trim();
        if (message != null && message.isNotEmpty) _addNotice(message);
      case 'error':
        error = s('message') ?? ngL.ng_the_turn_failed;
        turnFailure = FailureSurface.parse(
          p['surface'] ?? p['error_surface'] ?? p,
        );
        _finishTurn(failed: true);
      case 'message.complete' || 'turn.end':
        final live = running;
        final reply = _openReply();
        final text = s('text');
        if (text != null &&
            (reply.text.isEmpty || _replyGap && text.trim().isNotEmpty)) {
          reply.text = text;
        }
        final u = NgUsage.parse(p['usage']);
        if (u != null) {
          reply.inputTokens = u.input;
          reply.outputTokens = u.output;
        }
        reply.time = DateTime.now();
        final outcome = s('status');
        lastTurnFailed = outcome == 'error';
        lastTurnInterrupted = outcome == 'interrupted';
        _finishTurn(failed: lastTurnFailed);
        // The in-app cue for a live reply that finished here (Desktop plays
        // it on message.complete); a stopped or failed turn has none.
        if (live && !lastTurnFailed && !lastTurnInterrupted) {
          CompletionCuePlayer.instance.turnFinished(
            '${gateway.connection.id}|${storedId ?? runtimeId}',
          );
        }
        unawaited(_adoptPersistedIds());
      case 'turn.error':
        error = s('message') ?? ngL.ng_the_turn_failed;
        lastTurnFailed = true;
        lastTurnInterrupted = false;
        _finishTurn(failed: true);
        unawaited(_adoptPersistedIds());
      case 'request.cancel':
        final id = s('id') ?? s('request_id');
        if (id != null) {
          gateway.forgetRequest(id);
          if (request?.request.id == id) request = null;
        }
      case 'btw.complete' || 'background.complete':
        // Desktop's dispatcher: the answer to /btw or /background arrives
        // only as this event on the session that asked, so it is the one
        // place it can be shown. A replay of the same answer is not another.
        final answer = SideAnswer.fromEvent(event.type, p);
        if (answer == null || !_sideAnswers.add(answer.identity)) return;
        items.add(
          NgCommandItem(_key('c'), answer.header, time: DateTime.now())
            ..output = answer.text
            ..running = false,
        );
      case 'connection.request' || 'connection.update':
        final next = CatalogOperation.merge(
          catalog,
          p,
          opens: event.type == 'connection.request',
        );
        if (identical(next, catalog)) return;
        catalog = next;
      default:
        return;
    }
    // Terminal/lifecycle events notify immediately; streaming deltas coalesce.
    switch (event.type) {
      case 'message.complete' ||
          'turn.end' ||
          'error' ||
          'turn.error' ||
          'request.cancel' ||
          'connection.request' ||
          'connection.update' ||
          'message.start' ||
          'session.updated' ||
          'session.info' ||
          'session.title' ||
          'btw.complete' ||
          'background.complete' ||
          'notice':
        _changedNow();
      default:
        _changed();
    }
  }

  /// Takes a plan snapshot unless an older one arrived late.
  void _withTodos(NgTodoList? list) {
    if (list == null) return;
    final current = todos;
    if (current != null && list.revision < current.revision) return;
    todos = list.items.isEmpty ? null : list;
    todosLive = running;
  }

  /// Takes a control snapshot; an unchanged revision changes nothing.
  void _withControl(NgSessionControl? next) {
    final current = control;
    if (next != null &&
        current != null &&
        next.revision.isNotEmpty &&
        next.revision == current.revision) {
      return;
    }
    control = next;
  }

  /// Reads the session's goal, loop and heartbeat once, since
  /// `session.resume` doesn't carry them; later changes arrive as
  /// `session.control.update` events. A gateway without the method hides it.
  Future<void> refreshControl() async {
    final id = runtimeId;
    if (id == null || _controlUnsupported || _disposed) return;
    final before = control;
    try {
      final result = await gateway.call('session.control.read', {
        'session_id': id,
      });
      if (_disposed || !identical(control, before)) return;
      if (result.containsKey('control')) {
        _withControl(NgSessionControl.parse(result['control']));
        _changed();
      }
    } on JsonRpcError catch (e) {
      if (e.code == -32601) _controlUnsupported = true;
    } catch (_) {
      // Best effort: the strip stays as it was.
    }
  }

  /// Finished subagents beyond the newest 100 go; live ones stay.
  void _trimSubagents() {
    var finished = subagents.where((a) => !a.status.live).length;
    while (finished > 100) {
      subagents.remove(subagents.firstWhere((a) => !a.status.live));
      finished--;
    }
  }

  /// Subagents already running when this chat attached; their events only
  /// cover what comes next.
  Future<void> refreshSubagents() async {
    final id = runtimeId;
    if (id == null || _disposed) return;
    try {
      final result = await gateway.call('subagent.list', {'session_id': id});
      if (_disposed) return;
      final wasLive = subagents.any((a) => a.status.live);
      ngApplySubagentSnapshots(subagents, result['subagents']);
      if (!wasLive && subagents.any((a) => a.status.live)) {
        subagentBatchStart = subagents
            .where((a) => a.status.live)
            .map((a) => a.startedAt)
            .reduce((a, b) => a.isBefore(b) ? a : b);
      }
      _changed();
    } catch (_) {
      // Best effort: older gateways have no list; events still arrive.
    }
  }

  /// Stops one running subagent (`subagent.interrupt`).
  Future<void> stopSubagent(NgSubagent agent) async {
    final id = runtimeId;
    if (id == null) return;
    try {
      await gateway.call('subagent.interrupt', {
        'session_id': id,
        'subagent_id': agent.id,
      });
    } catch (e) {
      error = ngL.ng_couldn_t_stop(_clean(e));
      _changed();
    }
  }

  /// Runs one `session.control` action (pause a goal, add a sub-goal, ...)
  /// and applies the snapshot it returns. A resumed goal's kickoff goes out
  /// as a prompt, queued behind a running turn. Returns whether it worked;
  /// on failure [controlError] says why.
  Future<bool> runControl(
    NgControlAction action, {
    String? text,
    int? index,
  }) async {
    if (controlBusy != null) return false;
    controlBusy = action;
    controlError = null;
    _changed();
    try {
      await _ensureSession();
      final before = control;
      final result = await gateway.call('session.control', {
        'session_id': runtimeId,
        'action': action.wire,
        if (text != null)
          'args': {'text': text}
        else if (index != null)
          'args': {'index': index},
      });
      if (identical(control, before) && result.containsKey('control')) {
        _withControl(NgSessionControl.parse(result['control']));
      }
      final dispatch = result['dispatch'];
      if (dispatch is Map && dispatch['type'] == 'send') {
        final message = dispatch['message']?.toString().trim() ?? '';
        if (message.isNotEmpty) {
          if (running) {
            enqueue(message);
          } else {
            unawaited(send(message));
          }
        }
      }
      return true;
    } catch (e) {
      controlError = _clean(e);
      return false;
    } finally {
      controlBusy = null;
      _changed();
    }
  }

  /// Ends the turn. After a failure, queued prompts wait for the user rather
  /// than being sent into the same error.
  void _finishTurn({bool failed = false}) {
    for (final item in items) {
      if (item is NgAssistantItem) {
        if (item.open) item.time ??= DateTime.now();
        item.open = false;
        for (final t in item.tools) {
          t.running = false;
        }
      }
    }
    // Drop the empty reply a cancelled turn leaves behind.
    final last = _lastTurnItem;
    if (last is NgAssistantItem && last.isEmpty) items.remove(last);
    running = false;
    _replyGap = false;
    todosLive = false;
    status = null;
    thinkingFrame = null;
    turnStartedAt = null;
    request = null;
    kanban.turnEnded();
    onTurnFinished?.call();
    // The goal's judge runs after the turn; pick up its verdict.
    if (control?.goal != null) unawaited(refreshControl());
    if (failed && queued.isNotEmpty) localQueuePaused = true;
    _scheduleLocalDrain();
  }

  // These are this client's unsent entries, never admissions copied back
  // from the owner. Recheck at dispatch: a pause/removal may win the tick.
  NgQueued? _nextLocalDrain() {
    for (final row in queued) {
      if (row.key == editingLocalKey) continue;
      return row;
    }
    return null;
  }

  void _scheduleLocalDrain() {
    if (_drainScheduled ||
        localQueuePaused ||
        running ||
        _nextLocalDrain() == null) {
      return;
    }
    _drainScheduled = true;
    scheduleMicrotask(() {
      _drainScheduled = false;
      if (!draftOwnerCurrent || localQueuePaused || running) return;
      final next = _nextLocalDrain();
      if (next == null) return;
      queued.remove(next);
      unawaited(send(next.text, display: next.display));
    });
  }

  void beginLocalEdit(NgQueued row) {
    if (_disposed || !draftOwnerCurrent) return;
    editingLocalKey = row.key;
  }

  void endLocalEdit(NgQueued row) {
    if (editingLocalKey == row.key) editingLocalKey = null;
    if (_disposed) return;
    _scheduleLocalDrain();
    _changed();
  }

  void setLocalQueuePaused(bool paused) {
    if (!draftOwnerCurrent) return;
    if (paused && queued.isEmpty) return;
    localQueuePaused = paused;
    if (!paused) _scheduleLocalDrain();
    _changed();
  }

  void editLocalQueue(NgQueued original, String text) {
    if (!draftOwnerCurrent || text.trim().isEmpty || original.display != null) {
      return;
    }
    final index = queued.indexOf(original);
    if (index < 0) {
      if (!queued.any((row) => row.key == original.key)) {
        error = ngL.release_chat_unsent_prompt_gone;
        _changed();
      }
      return;
    }
    queued[index] = NgQueued(original.key, text.trim());
    _changed();
  }

  /// Drops the request [id] once it was answered elsewhere (a notification,
  /// another device) or withdrawn.
  void forgetRequest(String id) {
    if (request?.request.id != id) return;
    request = null;
    _changed();
  }

  void _onServerRequest(NgServerRequest req) {
    if (_disposed) return;
    final id = req.sessionId;
    if (id == null || (id != runtimeId && id != storedId)) return;
    final parsed = NgInputRequest.parse(req);
    if (parsed == null) return;
    request = parsed;
    _changedNow();
  }

  // ── Actions ─────────────────────────────────────────────────────────

  Future<void> _ensureSession() async {
    if (_disposed) {
      throw StateError(ngL.ng_the_gateway_connection_dropped_try_again);
    }
    if (runtimeId != null && storedId != null) return;
    // A missing or refused runtime binding is never permission to create a
    // different chat. This also joins an initial attach still in flight.
    if (storedId != null) {
      await _attach();
      if (_disposed || runtimeId == null) {
        throw StateError(ngL.ng_the_gateway_connection_dropped_try_again);
      }
      return;
    }
    if (_createUncertain) throw StateError(ngL.ng_project_create_uncertain);
    if (_creatingSession) {
      throw StateError(ngL.ng_connecting);
    }
    _creatingSession = true;
    _changed();
    try {
      await gateway.connected();
      if (_disposed) {
        throw StateError(ngL.ng_the_gateway_connection_dropped_try_again);
      }
      final cwd = workingDirectory;
      final pickedModel = _pickedModel;
      final pickedProvider = _pickedProvider;
      final pickedEffort = _pickedEffort;
      late final Map<String, dynamic> result;
      try {
        result = await gateway.call('session.create', {
          // CanonicalCreateParams.source refuses the legacy 'desktop' hint on
          // the authority route; 'gui' is the canonical graphical surface (#291).
          'source': gateway.sessionAuthority ? 'gui' : 'desktop',
          if (cwd != null && cwd.trim().isNotEmpty) ...{
            'cwd': cwd,
            // Current legacy + canonical contracts declare this. Older closed
            // validators reject before the handler: fail visibly, NEVER retry
            // without provenance and silently run in a named profile's default.
            'cwd_explicit': true,
          },
          'model': ?pickedModel,
          if (pickedProvider != null && pickedProvider.trim().isNotEmpty)
            'provider': pickedProvider,
          if (pickedEffort != null)
            if (gateway.sessionAuthority)
              'reasoning': pickedEffort
            else
              'reasoning_effort': pickedEffort,
        });
      } on JsonRpcError catch (error) {
        // Only pre-handler validation/method refusals prove no create ran.
        // An internal RPC error may have happened after a session was minted.
        if (!{-32601, -32602, 4000}.contains(error.code)) {
          _createUncertain = true;
        }
        rethrow;
      } catch (_) {
        _createUncertain = true; // A timeout/disconnect may have created it.
        rethrow;
      }
      // A scope switch can dispose this owner while the gateway creates it.
      // Do not publish IDs, call its parent, or submit a prompt after that.
      if (_disposed) {
        throw StateError(ngL.ng_the_gateway_connection_dropped_try_again);
      }
      _withAuthority(result);
      // A canonical create attaches with the same snapshot a resume returns.
      if (gateway.sessionAuthority && _cursor == null) _acceptSnapshot(result);
      runtimeId = result['session_id']?.toString();
      storedId = result['stored_session_id']?.toString() ?? runtimeId;
      if (runtimeId == null || storedId == null) {
        _createUncertain = true;
        throw StateError(ngL.ng_project_create_uncertain);
      }
      final info = result['info'];
      final actualCwd = info is Map ? info['cwd']?.toString() : null;
      if (cwd != null &&
          actualCwd != null &&
          cwd.replaceFirst(RegExp(r'[/\\]+$'), '') !=
              actualCwd.replaceFirst(RegExp(r'[/\\]+$'), '')) {
        error = ngL.ng_project_cwd_fallback(actualCwd);
      }
      if (runtimeId != null) gateway.bindRuntime(runtimeId!, storedId!);
      // Created just now: there is nothing on the board to look for yet.
      kanban.setChat(primaryId: storedId, discover: false);
      final storedDraft = result['stored_session_id'];
      if (draftOwnerCurrent &&
          storedDraft is String &&
          storedDraft.isNotEmpty) {
        gateway.draftPresentation.bind(draftKey, storedDraft);
      }
      _withInfo(result['info']);
      if (storedId != null) onCreated?.call(storedId!);
      _pickedModel = null;
      _pickedProvider = null;
      _pickedEffort = null;
      if (pickedModel != null) {
        final info = result['info'];
        final actualModel = info is Map ? info['model']?.toString() : null;
        if (actualModel != null && actualModel != pickedModel) {
          final message = ngL.ng_gateway_kept_default_model(actualModel);
          error = message;
          _changed();
          throw StateError(message);
        }
      }
    } finally {
      _creatingSession = false;
      _changed();
    }
  }

  String? _pickedModel;
  String? _pickedProvider;
  String? _pickedEffort;

  /// Attaches one draft the way Kyllene does and returns the `@file`
  /// reference the prompt must carry, or null for an image, which the
  /// gateway queues onto the next prompt itself:
  ///
  /// * an image up to [ngMaxInlineAttachmentBytes] goes inline with
  ///   `image.attach_bytes`, so the model sees it as an image;
  /// * any other file up to that size goes inline with `file.attach`;
  /// * anything larger streams over HTTP to `/api/files/upload-stream` (up
  ///   to 100 MB) and is attached by its path there, then removed.
  Future<String?> _upload(
    AttachmentDraft draft,
    List<String> queued,
    List<Map<String, String>> canonicalImages,
    void Function() checkOwner,
  ) async {
    draft.status = AttachmentDraftStatus.uploading;
    draft.error = null;
    _changed();
    try {
      if (draft.byteLength > ngMaxInlineAttachmentBytes) {
        final ref = await _uploadStaged(draft);
        draft
          ..status = AttachmentDraftStatus.attached
          ..refText = ref;
        return ref;
      }
      if (draft.isImage) {
        final staged = gateway.sessionAuthority;
        final bytes = await File(draft.cachedPath).readAsBytes();
        checkOwner();
        final result = await gateway.call('image.attach_bytes', {
          'session_id': runtimeId,
          'content_base64': base64Encode(bytes),
          'filename': draft.name,
        }, timeout: const Duration(minutes: 2));
        if (result['attached'] != true) {
          throw StateError(
            result['message']?.toString() ??
                ngL.ng_release_attachment_not_attached(draft.name),
          );
        }
        final path = result['path']?.toString();
        if (staged) {
          // gateway/session_images.py stages only on the session authority.
          // Legacy image.attach_bytes instead queues onto the next turn.
          if (path == null ||
              path.isEmpty ||
              result['mime'] != draft.mediaType) {
            throw const PreparedImageException();
          }
          canonicalImages.add({'path': path, 'mime': draft.mediaType});
        } else if (path != null && path.isNotEmpty) {
          queued.add(path);
        }
        draft.status = AttachmentDraftStatus.attached;
        return null;
      }
      final dataUrl = await attachmentService.readDataUrl(draft);
      final result = await gateway.call('file.attach', {
        'session_id': runtimeId,
        'name': draft.name,
        'path': '',
        'data_url': dataUrl,
      }, timeout: const Duration(minutes: 2));
      final ref = result['ref_text']?.toString() ?? '';
      if (result['attached'] != true || ref.isEmpty) {
        throw StateError(ngL.ng_release_attachment_not_attached(draft.name));
      }
      draft
        ..status = AttachmentDraftStatus.attached
        ..refText = ref;
      return ref;
    } catch (e) {
      draft
        ..status = AttachmentDraftStatus.failed
        ..error = _clean(e);
      rethrow;
    } finally {
      draft.uploadProgress = null;
      _changed();
    }
  }

  /// Puts a file too large for one WebSocket message on the gateway over
  /// HTTP in a folder of its own under the managed files' default folder,
  /// attaches it by that path, then removes the folder (unless `file.attach`
  /// used it in place, which the prompt then refers to).
  Future<String> _uploadStaged(AttachmentDraft draft) async {
    final dashboard = gateway.dashboard;
    final tooLarge = ngL.ng_attachment_too_large_for_gateway(draft.name);
    final listing = await dashboard.apiRequest('GET', 'files');
    if (listing.statusCode == 404 || listing.statusCode == 405) {
      throw StateError(tooLarge);
    }
    String home;
    try {
      home = (jsonDecode(listing.body) as Map)['path']?.toString() ?? '';
    } catch (_) {
      // Not JSON: a gateway from before the managed files.
      throw StateError(tooLarge);
    }
    if (listing.statusCode != 200 || home.isEmpty) {
      throw StateError(ngL.ng_couldn_t_upload(draft.name));
    }
    final sep = !home.contains('/') && home.contains(r'\') ? r'\' : '/';
    final random = Random.secure();
    final id = List.generate(
      16,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
    final base = home.replaceFirst(RegExp(r'[/\\]+$'), '');
    final folder = '$base$sep$ngUploadsFolder$sep$id';
    final target = '$folder$sep${ngSafeUploadName(draft.name)}';
    Future<void> removeFolder() async {
      try {
        await dashboard.apiRequest(
          'DELETE',
          'files',
          body: {'path': folder, 'recursive': true},
        );
      } catch (_) {
        // Best effort: a leftover is only a file in the uploads folder.
      }
    }

    var shown = -1;
    final http.Response res;
    try {
      res = await dashboard.apiUploadStream(
        File(draft.cachedPath),
        targetPath: target,
        filename: draft.name,
        mimeType: draft.mediaType,
        onProgress: (sent, total) {
          final percent = total <= 0 ? 0 : (sent * 100 ~/ total);
          if (percent == shown) return;
          shown = percent;
          draft.uploadProgress = percent / 100;
          _changed();
        },
      );
    } catch (_) {
      await removeFolder();
      rethrow;
    }
    if (res.statusCode == 404 || res.statusCode == 405) {
      throw StateError(tooLarge);
    }
    if (res.statusCode != 200) {
      await removeFolder();
      var detail = 'HTTP ${res.statusCode}';
      try {
        detail = (jsonDecode(res.body) as Map)['detail']?.toString() ?? detail;
      } catch (_) {}
      throw StateError('${ngL.ng_couldn_t_upload(draft.name)} $detail');
    }
    var staged = target;
    try {
      final path = (jsonDecode(res.body) as Map)['path']?.toString();
      if (path != null && path.isNotEmpty) staged = path;
    } catch (_) {}
    var usedInPlace = false;
    try {
      final result = await gateway.call('file.attach', {
        'session_id': runtimeId,
        'path': staged,
        'name': draft.name,
      }, timeout: const Duration(minutes: 5));
      final uploaded = result['uploaded'];
      usedInPlace = uploaded is bool
          ? !uploaded
          : result['path']?.toString() == staged;
      final ref = result['ref_text']?.toString() ?? '';
      if (result['attached'] != true || ref.isEmpty) {
        throw StateError(ngL.ng_release_attachment_not_attached(draft.name));
      }
      return ref;
    } finally {
      if (!usedInPlace) await removeFolder();
    }
  }

  /// An image queued on a session that was then un-queued must go up again.
  void _resetQueuedImages(List<AttachmentDraft> drafts) {
    for (final draft in drafts) {
      if (draft.isImage &&
          draft.refText == null &&
          draft.status == AttachmentDraftStatus.attached) {
        draft.status = AttachmentDraftStatus.ready;
      }
    }
  }

  /// Best effort: un-queues images after a send that failed part-way.
  Future<void> _detach(List<String> paths) async {
    for (final path in paths) {
      try {
        await gateway.call('image.detach', {
          'session_id': runtimeId,
          'path': path,
        });
      } catch (_) {
        return; // the socket is likely gone, and the queue with it
      }
    }
  }

  /// Sends [text] (and any [attachments]) as a new prompt. Returns whether
  /// the gateway accepted it; on failure the attachments stay with the
  /// message so Retry can send them again. A command's send/skill directive
  /// passes the gateway's [display] line: the bubble shows that, never the
  /// model-facing [text].
  Future<bool> send(
    String text, {
    List<AttachmentDraft> attachments = const [],
    String? composerImageText,
    String? submissionId,
    String? display,
    bool hidden = false,
    WorkspaceTarget? fleetTarget,
    Map<String, Object> promptParams = const {},
  }) async {
    final trimmed = text.trim();
    if (fleetTarget != null && promptParams.isNotEmpty) return false;
    // A fleet send is text only, on the exact bound route and runtime.
    if (fleetTarget != null &&
        (attachments.isNotEmpty ||
            composerImageText != null ||
            fleetTarget.route !=
                gateway.workspace.route(storedSessionId: storedId) ||
            runtimeId == null ||
            fleetTarget.runtimeSessionId != runtimeId ||
            !fleetTarget.isCurrent)) {
      return false;
    }
    if (trimmed.isEmpty && attachments.isEmpty) return false;
    // A hidden widget intent is plain text on this chat's own runtime, and
    // only starts a turn: it never steers or queues behind a running one.
    if (hidden &&
        (running ||
            attachments.isNotEmpty ||
            composerImageText != null ||
            fleetTarget != null)) {
      return false;
    }
    final shown = display?.trim() ?? '';
    if (composerImageText != null &&
        (composerImageText.trim() != trimmed || shown.isNotEmpty)) {
      return false;
    }
    final effectiveSubmissionId = submissionId ?? const Uuid().v4();
    final NgUserItem? item = hidden
        ? null
        : NgUserItem(
            _key('u'),
            shown.isEmpty ? trimmed : shown,
            time: DateTime.now(),
            pending: true,
            attachments: List.of(attachments),
            submissionId: effectiveSubmissionId,
            composerImageText: composerImageText,
            sentText: shown.isEmpty ? null : trimmed,
            promptParams: promptParams,
          );
    if (item != null) items.add(item);
    error = null;
    running = true;
    turnStartedAt = DateTime.now();
    _changed();
    final queued = <String>[];
    PreparedImageCapture? capture;
    var mayHaveSubmitted = false;
    bool Function()? sameUploadOwner;
    try {
      if (fleetTarget == null) await _ensureSession();
      final journal =
          composerImageText != null &&
          PreparedImageStore.supports(composerImageText, attachments);
      final target = journal ? imageTarget : null;
      final live = runtimeId;
      final socket = gateway.socket;
      final epoch = socket?.socketEpoch;
      sameUploadOwner = () =>
          !_disposed &&
          live == runtimeId &&
          identical(socket, gateway.socket) &&
          epoch == socket?.socketEpoch &&
          ConnectionMutationBarrier.isCurrent(
            gateway.connection.id,
            _imageEpoch,
          );
      void checkOwner() {
        if (!sameUploadOwner!() ||
            (journal && (target == null || imageTarget?.key != target.key))) {
          throw const PreparedImageException();
        }
      }

      checkOwner();
      final adopted = journal
          ? await PreparedImageStore.shared.adopt(
              target!,
              composerImageText,
              attachments,
            )
          : null;
      if (journal && adopted == null) {
        capture = await PreparedImageStore.shared.capture(
          attachments,
          beforeUpload: (target: target!, text: composerImageText),
        );
      }
      checkOwner();
      final refs = <String>[];
      final wireImages = <Map<String, String>>[];
      for (final draft
          in capture?.drafts ??
              item?.attachments ??
              const <AttachmentDraft>[]) {
        if (adopted != null) break;
        checkOwner();
        final ref =
            draft.refText ??
            await _upload(draft, queued, wireImages, checkOwner);
        if (ref != null) refs.add(ref);
      }
      // Like Desktop and Kyllene: the file references first, then the text.
      final prompt =
          adopted?.entry.prompt ??
          [
            refs.join('\n'),
            trimmed,
          ].where((part) => part.trim().isNotEmpty).join('\n\n');
      checkOwner();
      final attempt =
          adopted ??
          (journal
              ? await PreparedImageStore.shared.prepare(
                  target!,
                  composerImageText,
                  capture!,
                  prompt: prompt,
                  wireImages: wireImages,
                  copyOnly: !gateway.sessionAuthority,
                )
              : null);
      checkOwner();
      if (attempt != null && item != null) {
        item.submissionId = attempt.id;
        item.recoverInComposer = true;
      }
      final wireSubmissionId = item?.submissionId ?? effectiveSubmissionId;
      final explicitImages = adopted?.entry.wireImages ?? wireImages;
      _clearRetainedModelMutation();
      mayHaveSubmitted = true;
      final result = fleetTarget != null
          ? await fleetTarget.submitFleetText(prompt, wireSubmissionId)
          : await _submitPromptWithCompatibility(
              {
                ...promptParams,
                'session_id': runtimeId,
                'text': prompt,
                if (explicitImages.isNotEmpty) 'attachments': explicitImages,
              },
              submissionId: wireSubmissionId,
              attempt: attempt,
              checkOwner: checkOwner,
            );
      if (attempt != null) await attempt.receipt(result, live!);
      item?.pending = false;
      // A canonical receipt names the execution its admission started.
      _adoptExecutionGeneration(result['execution_generation']);
      final status = result['status']?.toString();
      if (item != null && status == 'queued' && item.sentText == null) {
        item.text = trimmed;
      }
      _changed();
      if (item != null && item.attachments.isNotEmpty) {
        unawaited(attachmentService.removeAll(item.attachments));
      }
      return true;
    } catch (e) {
      if (item != null) {
        if (!mayHaveSubmitted && sameUploadOwner?.call() == true) {
          await _detach(queued);
          _resetQueuedImages(item.attachments);
        }
        if (item.recoverInComposer) {
          await attachmentService.removeAll(item.attachments);
        }
        item.pending = false;
        item.failure = _clean(e);
      } else {
        error = _clean(e);
      }
      running = false;
      turnStartedAt = null;
      _changed();
      return false;
    } finally {
      await capture?.close();
    }
  }

  /// Steers the running turn at its next safe boundary. On the canonical
  /// session authority the guidance names the exact execution the user saw
  /// ([_executionGeneration] now); a turn that changed meanwhile refuses it
  /// (`stale_generation`). Never sent again: it has no idempotency key, and
  /// a newer turn must not get guidance meant for another.
  Future<void> steer(String text) async {
    final trimmed = text.trim();
    final id = runtimeId;
    if (trimmed.isEmpty || id == null) return;
    final canonical = gateway.sessionAuthority;
    final generation = _executionGeneration;
    final item = NgUserItem(
      _key('u'),
      trimmed,
      time: DateTime.now(),
      steered: true,
      pending: true,
    );
    items.add(item);
    _changed();
    if (canonical && generation == null) {
      item.pending = false;
      item.failure = ngL.ng_turn_not_known_yet;
      _changed();
      return;
    }
    try {
      final ack = await gateway.call('session.steer', {
        'session_id': id,
        if (canonical) 'execution_generation': generation,
        'text': trimmed,
      });
      item.pending = false;
      // Only `queued` is delivery; `rejected` (or anything unknown) is not,
      // and is not sent again either.
      if (ack['status'] != 'queued' && ack['voice_stopped'] != true) {
        item.failure = ngL.ng_steer_rejected;
      }
    } catch (e) {
      item.pending = false;
      item.failure = _controlFailure(e);
    }
    _changed();
  }

  /// A refused Stop/Steer, as the person reads it.
  static String _controlFailure(Object e) =>
      e is JsonRpcError && e.reason == 'stale_generation'
      ? ngL.ng_turn_changed
      : _clean(e);

  /// Queues [text] to send once the running turn ends.
  ///
  /// Queueing is fresh intent, so a park from Stop or a failed turn is lifted.
  /// The entry still waits while a turn is running.
  void enqueue(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty || !draftOwnerCurrent) return;
    queued.add(NgQueued(_key('q'), trimmed));
    localQueuePaused = false;
    _changed();
    _scheduleLocalDrain();
  }

  void unqueue(NgQueued item) {
    queued.remove(item);
    if (queued.isEmpty) localQueuePaused = false;
    _changed();
  }

  /// Row send. While a turn is running this unparks, moves [item] to the
  /// head and interrupts; the settle drain admits it. While idle it admits
  /// [item] now and leaves the rest to follow.
  Future<void> sendQueuedNow(NgQueued item) async {
    final index = queued.indexOf(item);
    if (!draftOwnerCurrent || index < 0 || item.key == editingLocalKey) {
      return;
    }
    if (index > 0) {
      queued.removeAt(index);
      queued.insert(0, item);
    }
    localQueuePaused = false;
    _changed();
    if (running) {
      await stop(parkLocalQueue: false);
      return;
    }
    if (queued.isEmpty || !identical(queued.first, item)) return;
    queued.removeAt(0);
    if (queued.isEmpty) localQueuePaused = false;
    await send(item.text, display: item.display);
  }

  /// Stops the running turn. On the canonical session authority the stop
  /// names the exact execution the user saw ([_executionGeneration] now): a
  /// later claim is never stopped by it, and `stale_generation` is reported,
  /// not retried against the newer turn. Legacy gateways get their own shape.
  Future<void> stop({bool parkLocalQueue = true}) async {
    if (parkLocalQueue && queued.isNotEmpty) setLocalQueuePaused(true);
    final id = runtimeId;
    if (id == null) return;
    final canonical = gateway.sessionAuthority;
    final generation = _executionGeneration;
    if (canonical && generation == null) {
      error = ngL.ng_couldn_t_stop(ngL.ng_turn_not_known_yet);
      _changed();
      return;
    }
    try {
      await gateway.call('session.interrupt', {
        'session_id': id,
        if (canonical) 'execution_generation': generation,
      });
    } catch (e) {
      error = ngL.ng_couldn_t_stop(_controlFailure(e));
      _changed();
    }
  }

  /// Stops the running turn, then sends [text].
  Future<void> stopAndSend(String text) async {
    queued.insert(0, NgQueued(_key('q'), text.trim()));
    localQueuePaused = false;
    await stop(parkLocalQueue: false);
  }

  // ── Slash commands (Kyllene's ChatSession.runCommand) ─────────────────

  /// Side answers already shown (a replayed event is not a second answer).
  final Set<String> _sideAnswers = {};

  /// Runs `/btw`, `/background` (`/bg`) or `/handoff` through its own RPC,
  /// the way Desktop does, under a command card: never through
  /// `slash.exec` (whose capture window closes before the answer) and never
  /// as a prompt. A new chat is created and a stored chat attached first,
  /// as Desktop's `ensureSessionId` does, so the RPC never names a stale id.
  /// Returns null when [command] is not one of these, or the gateway has no
  /// such method: the ordinary command path then runs it.
  Future<NgDedicatedResult?> runDedicated(NgSlashLine command) async {
    final kind = dedicatedSlash(command.name);
    if (kind == null || kind == DedicatedSlash.resume) return null;
    final card = NgCommandItem(_key('c'), command.label, time: DateTime.now());
    items.add(card);
    error = null;
    _changedNow();
    final usage = planDedicated(
      name: command.name,
      arg: command.arg,
      sessionId: 'unused',
      l10n: ngL,
    );
    if (usage.request == null) {
      card
        ..output = usage.notice ?? ''
        ..running = false;
      _changedNow();
      return NgDedicatedResult(card);
    }
    final String runtime;
    try {
      runtime = await _ensureCommandSession();
    } catch (e) {
      _commandFailed(
        card,
        NgCommandResult.failed,
        ngL.ng_slash_command_failed(_clean(e)),
      );
      return NgDedicatedResult(card);
    }
    if (_disposed) return NgDedicatedResult(card);
    final run = await runDedicatedCommand(
      name: command.name,
      arg: command.arg,
      sessionId: runtime,
      l10n: ngL,
      rpc: (method, params) =>
          gateway.call(method, params, timeout: kNgSlashCommandTimeout),
    );
    final answer = run?.answer;
    if (answer == null || answer.fallbackToExec) {
      items.remove(card);
      _changedNow();
      return null;
    }
    if (answer.failed) {
      _commandFailed(
        card,
        NgCommandResult.failed,
        ngL.ng_slash_command_failed(answer.notice),
      );
      return NgDedicatedResult(card);
    }
    card
      ..output = answer.notice
      ..running = false;
    _changedNow();
    return NgDedicatedResult(
      card,
      handoffSession: answer.watchHandoff ? runtime : null,
    );
  }

  /// Shows how a watched handoff ended on its command card.
  void settleHandoff(NgCommandItem card, String text, {bool failed = false}) {
    if (_disposed) return;
    if (!items.contains(card)) items.add(card);
    card
      ..output = card.output.isEmpty ? text : '${card.output}\n$text'
      ..running = false
      ..failed = failed;
    _changedNow();
  }

  /// Whether this connection said it has no `slash.exec` (an older gateway).
  bool get slashExecUnsupported =>
      ngSlashExecUnsupported(gateway.socket ?? gateway);

  /// Runs [command] on the gateway the way Kyllene and Classic do, under a
  /// card in the transcript: `slash.exec` first, then `command.dispatch`
  /// (the gateway's stage for skills, bundles and quick commands) only after
  /// a definite refusal. A lost reply (timeout, dropped socket) never falls
  /// back or resends: both methods reach the same executor and the first may
  /// already have run. A send/skill directive becomes a prompt through
  /// [send] (queued while a turn runs), showing the gateway's `display`.
  Future<NgCommandOutcome> runCommand(NgSlashLine command) async {
    if (slashExecUnsupported) {
      return const NgCommandOutcome(NgCommandResult.unsupported);
    }
    final card = NgCommandItem(_key('c'), command.label, time: DateTime.now());
    items.add(card);
    error = null;
    _changedNow();
    final String runtime;
    try {
      runtime = await _ensureCommandSession();
    } catch (e) {
      return _commandFailed(
        card,
        NgCommandResult.failed,
        ngL.ng_slash_command_failed(_clean(e)),
      );
    }
    return _execute(card, command, runtime, followAlias: true);
  }

  /// The live runtime id for a session-scoped call (completions, Compress,
  /// the context breakdown). A stored chat that is not attached yet attaches
  /// first: a stored id is never sent where a runtime id belongs. A new chat
  /// is created only when [create] (Desktop's `ensureSessionId`); otherwise
  /// it has no session yet and the answer is null.
  Future<String?> liveSessionId({bool create = false}) async {
    final live = runtimeId;
    if (live != null) return live;
    if (storedId == null && !create) return null;
    try {
      return await _ensureCommandSession();
    } catch (_) {
      return null;
    }
  }

  /// The live session a command runs in: a new chat is created as a prompt
  /// would create it; a stored chat that is not attached yet attaches
  /// rather than starting another session.
  Future<String> _ensureCommandSession() async {
    if (storedId == null) {
      await _ensureSession();
    } else if (runtimeId == null) {
      await _attach();
    }
    final id = runtimeId;
    if (id == null) throw StateError(error ?? ngL.ng_offline);
    return id;
  }

  Future<NgCommandOutcome> _execute(
    NgCommandItem card,
    NgSlashLine command,
    String runtime, {
    required bool followAlias,
  }) async {
    final connection = gateway.socket ?? gateway;
    Map<String, dynamic> reply;
    try {
      reply = await gateway.call('slash.exec', {
        'session_id': runtime,
        'command': command.line,
      }, timeout: kNgSlashCommandTimeout);
    } on JsonRpcError catch (e) {
      if (ngIsMethodNotFound(e)) {
        // Nothing ran: the line goes out as a prompt, as it always did here.
        ngMarkSlashExecUnsupported(connection);
        items.remove(card);
        _changedNow();
        return const NgCommandOutcome(NgCommandResult.unsupported);
      }
      if (isSlashDeliveryUnknown(e)) {
        return _commandFailed(
          card,
          NgCommandResult.deliveryUnknown,
          ngL.ng_slash_command_delivery_unknown,
        );
      }
      if (!isSlashCommandRefusal(e) && !ngIsDispatchRedirect(e)) {
        return _commandFailed(card, NgCommandResult.failed, _rpcFailure(e));
      }
      // A definite refusal: nothing ran, so the dispatch stage may try.
      try {
        reply = await gateway.call('command.dispatch', {
          'session_id': runtime,
          'name': command.name,
          if (command.arg.isNotEmpty) 'arg': command.arg,
        }, timeout: kNgSlashCommandTimeout);
      } on JsonRpcError catch (d) {
        if (isSlashDeliveryUnknown(d)) {
          return _commandFailed(
            card,
            NgCommandResult.deliveryUnknown,
            ngL.ng_slash_command_delivery_unknown,
          );
        }
        if (ngIsMethodNotFound(d) ||
            isSlashCommandRefusal(d) ||
            ngIsNotDispatchable(d)) {
          return _commandFailed(
            card,
            NgCommandResult.refused,
            _refusalText(e) ?? _refusalText(d) ?? ngL.ng_slash_command_refused,
          );
        }
        return _commandFailed(card, NgCommandResult.failed, _rpcFailure(d));
      } catch (d) {
        return _commandFailed(
          card,
          NgCommandResult.failed,
          ngL.ng_slash_command_failed(_clean(d)),
        );
      }
    } catch (e) {
      return _commandFailed(
        card,
        NgCommandResult.failed,
        ngL.ng_slash_command_failed(_clean(e)),
      );
    }
    final result = SlashCommandResult.fromResult(reply);
    if (followAlias && result.aliasTarget.isNotEmpty) {
      // Once: an alias naming another alias shows what the gateway said.
      final next = command.aliasedTo(result.aliasTarget);
      if (next != null) {
        return _execute(card, next, runtime, followAlias: false);
      }
    }
    if (result.isPrompt) {
      _settleCommandCard(card, result.notice);
      final display = result.display.isNotEmpty
          ? result.display
          : command.label;
      if (running) {
        // Like any message sent mid-turn: it waits for the turn to end.
        queued.add(NgQueued(_key('q'), result.text, display: display));
        _changedNow();
      } else {
        await send(result.text, display: display);
      }
      return NgCommandOutcome(NgCommandResult.sentAsPrompt, item: card);
    }
    if (result.isPrefill) {
      _settleCommandCard(card, result.notice, keep: true);
      // `/undo` took turns off the stored transcript: show it without them.
      await _reloadShownHistory();
      return NgCommandOutcome(
        NgCommandResult.prefill,
        text: result.text,
        item: card,
      );
    }
    card
      ..output = result.text.trim().isEmpty
          ? ngL.ng_slash_command_done
          : ngStripAnsi(result.text).trimRight()
      ..running = false;
    _changedNow();
    return NgCommandOutcome(NgCommandResult.done, item: card);
  }

  NgCommandOutcome _commandFailed(
    NgCommandItem card,
    NgCommandResult result,
    String message,
  ) {
    if (!items.contains(card)) items.add(card);
    card
      ..output = message
      ..running = false
      ..failed = true;
    _changedNow();
    return NgCommandOutcome(result, item: card);
  }

  /// Shows [notice] on the card, or drops the card when there is nothing to
  /// show (and [keep] is false).
  void _settleCommandCard(
    NgCommandItem card,
    String notice, {
    bool keep = false,
  }) {
    card.running = false;
    if (notice.trim().isNotEmpty) {
      card.output = ngStripAnsi(notice).trim();
    } else if (!keep) {
      items.remove(card);
    }
    _changedNow();
  }

  /// Puts [text] on [card] (a prefill the composer could not take because
  /// the user typed meanwhile), or drops a card with nothing to show.
  void settleCommand(NgCommandItem card, {String? text}) {
    final add = text?.trim() ?? '';
    if (add.isNotEmpty) {
      if (!items.contains(card)) items.add(card);
      card.output = card.output.isEmpty ? add : '${card.output}\n\n$add';
    } else if (card.output.isEmpty) {
      items.remove(card);
    }
    card.running = false;
    _changedNow();
  }

  static String? _refusalText(JsonRpcError error) {
    final detail = error.data['detail'];
    return detail is String && detail.trim().isNotEmpty ? detail.trim() : null;
  }

  static String _rpcFailure(JsonRpcError error) {
    final detail = _refusalText(error);
    final message = error.message.trim();
    return ngL.ng_slash_command_failed(
      detail ?? (message.isEmpty ? error.method : message),
    );
  }

  /// Reads the shown window of the stored transcript again (after `/undo`
  /// and the like), keeping the command cards since the last turn.
  Future<void> _reloadShownHistory() async {
    final id = storedId;
    if (id == null || running || _disposed) return;
    try {
      final limit = max(ngHistoryPage, _rowIds.length).clamp(1, 500);
      final rows = await _fetchRows(id, limit: limit);
      if (_disposed || storedId != id || running) return;
      final tail = <NgCommandItem>[];
      for (var i = items.length - 1; i >= 0 && items[i] is NgCommandItem; i--) {
        tail.insert(0, items[i] as NgCommandItem);
      }
      _setRows(rows, limit);
      items.addAll(tail);
      _changedNow();
    } catch (_) {
      // The transcript stays as shown; the next catch-up reads it again.
    }
  }

  Future<Map<String, dynamic>> _submitPromptWithCompatibility(
    Map<String, dynamic> baseParams, {
    required String submissionId,
    PreparedImageAttempt? attempt,
    required void Function() checkOwner,
  }) async {
    final sent = <String, dynamic>{
      ...baseParams,
      'submission_id': submissionId,
    };
    try {
      return await gateway.call(
        'prompt.submit',
        sent,
        timeout: const Duration(seconds: 60),
      );
    } on JsonRpcError catch (e) {
      // Backends predating confirm_deep_truncate reject it at contract
      // admission (4000, handler never runs). The user already confirmed, so
      // retry once without only that field — mirror of Desktop's
      // runRewindSubmit (rewind.ts).
      if (isRejectedDeepTruncatePayload(
        code: e.code,
        message: e.message,
        sentParams: sent,
      )) {
        return gateway.call(
          'prompt.submit',
          stripRejectedDeepTruncate(sent),
          timeout: const Duration(seconds: 60),
        );
      }
      if (!isRejectedSubmissionIdError(e)) rethrow;
      if (attempt != null) await attempt.beforeLegacy();
      checkOwner();
      return gateway.call(
        'prompt.submit',
        baseParams,
        timeout: const Duration(seconds: 60),
      );
    }
  }

  /// Retry for the last prompt, the way Desktop retries.
  ///
  /// A submission the gateway never accepted goes again with the SAME
  /// `submission_id`, so a gateway that did receive it answers with the turn
  /// it already has. A turn the gateway accepted is regenerated (Desktop's
  /// `runReload`): the running turn is interrupted first, then the prompt is
  /// submitted with `confirm_truncate` and its durable row
  /// (`truncate_before_row_id`), replacing the failed turn. Without a
  /// durable row nothing is sent: a plain resubmit would append the same
  /// turn twice.
  Future<NgRetryResult> retryLast() async {
    final last = items
        .whereType<NgUserItem>()
        .where((item) => !item.steered)
        .lastOrNull;
    if (last == null) return NgRetryResult.nothing;
    if (last.failure != null) {
      if (last.recoverInComposer) return NgRetryResult.nothing;
      items.remove(last);
      final sent = await send(
        last.sentText ?? last.text,
        attachments: last.attachments,
        composerImageText: last.composerImageText,
        submissionId: last.submissionId,
        display: last.sentText == null ? null : last.text,
        promptParams: last.promptParams,
      );
      return sent ? NgRetryResult.resent : NgRetryResult.failed;
    }
    final text = last.sentText ?? last.text;
    final String runtime;
    try {
      runtime = await _ensureCommandSession();
    } catch (_) {
      return NgRetryResult.notFound;
    }
    if (running) {
      await stop(parkLocalQueue: false);
      for (var i = 0; i < 50 && running && !_disposed; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      if (_disposed || running) return NgRetryResult.failed;
    }
    final target = await resolveRegenerateTarget(
      rpc: (method, params) => gateway.call(method, params),
      sessionId: runtime,
      text: text,
    );
    if (_disposed) return NgRetryResult.nothing;
    if (target == null) return NgRetryResult.notFound;
    final index = items.indexOf(last);
    if (index < 0) return NgRetryResult.nothing;
    // As Desktop's applyReloadOptimistic: the replaced turn leaves the view.
    final replaced = items.sublist(index);
    items.removeRange(index, items.length);
    final sent = await send(
      text,
      display: last.sentText == null ? null : last.text,
      // runRewindSubmit's params for the resolved row (Desktop's runReload).
      promptParams: regenerateSubmitParams(target.rowId),
    );
    if (!sent && !_disposed) {
      // Desktop's rollback: the transcript as it was, and why.
      final failed = items.whereType<NgUserItem>().lastOrNull;
      if (failed != null && failed.failure != null) {
        error = failed.failure;
        items.remove(failed);
      }
      items.addAll(replaced);
      _changedNow();
    }
    return sent ? NgRetryResult.regenerated : NgRetryResult.failed;
  }

  /// Where an edit or restore of [item] cuts, from the session's full saved
  /// transcript (`session.history`): the durable row (the bubble's own row
  /// id first, as Desktop's `source.rowId`) and whether later user turns are
  /// archived. The items on screen are a paged window and cannot answer
  /// either. Null when the saved transcript does not hold the turn yet:
  /// a cut would be a guess, so nothing may be sent.
  Future<NgRewindTarget?> rewindTargetFor(NgUserItem item) async {
    final users = items
        .whereType<NgUserItem>()
        .where((entry) => !entry.steered)
        .toList();
    final index = users.indexOf(item);
    final ordinal = index < 0 ? users.length : index;
    final shownLater = index >= 0 && index < users.length - 1;
    final String runtime;
    try {
      runtime = await _ensureCommandSession();
    } catch (_) {
      return null;
    }
    final history = await RewindHistory.read(
      (method, params) => gateway.call(method, params),
      runtime,
    );
    if (_disposed) return null;
    if (history == null) {
      // The transcript cannot be read (an old gateway): the bubble's own
      // row, or Desktop's plain resubmit.
      return (
        rowId: item.rowId,
        laterTurns: shownLater,
        ordinal: ordinal,
        maxRowId: null,
      );
    }
    final rowId = history.rowFor(
      bubbleRowId: item.rowId,
      sourceText: item.text,
      expectedOrdinal: ordinal,
    );
    if (rowId == null && history.hasRowIds) return null;
    return (
      rowId: rowId,
      laterTurns: rowId == null ? shownLater : history.laterUserTurns(rowId),
      ordinal: ordinal,
      maxRowId: history.maxRowId,
    );
  }

  /// Edit or restore a stored user turn (F17, Desktop rewind semantics):
  /// a live turn is interrupted first, then exactly ONE truncating
  /// `prompt.submit` goes out for [target] through the same owned path Retry
  /// uses. The archived turns leave the view at once (Desktop's
  /// `applyRewindOptimistic`) and come back if the send fails. The composer
  /// is never consumed.
  Future<bool> rewindUserTurn({
    required NgUserItem item,
    required String text,
    required NgRewindTarget target,
  }) async {
    final runtime = runtimeId;
    if (runtime == null) return false;
    if (running) {
      await stop(parkLocalQueue: false);
      for (var i = 0; i < 50 && running && !_disposed; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      if (_disposed || running) return false;
    } else {
      // Best-effort interrupt before the rewind, matching Classic and Desktop's
      // runRewindSubmit when a detached/remote turn may still be running.
      try {
        await gateway.call('session.interrupt', {
          'session_id': runtime,
          if (gateway.sessionAuthority)
            'execution_generation': ?_executionGeneration,
        });
      } catch (_) {
        // The submit path still gates on the gateway's own busy state.
      }
      if (_disposed) return false;
    }
    final index = target.rowId == null ? -1 : items.indexOf(item);
    final archived = index < 0 ? const <NgItem>[] : items.sublist(index);
    if (index >= 0) {
      items.removeRange(index, items.length);
      _changedNow();
    }
    final sent = await send(
      text,
      promptParams: Map<String, Object>.from(
        buildRewindParams(
          RewindPlan.resolved(
            rowId: target.rowId,
            sourceText: item.text,
            originalOrdinal: target.ordinal,
          ),
          confirmDeepTruncate: target.laterTurns,
        ),
      ),
    );
    if (!sent && !_disposed && archived.isNotEmpty) {
      // Desktop's rollback: the transcript as it was, and why.
      final failed = items.whereType<NgUserItem>().lastOrNull;
      if (failed != null && failed.failure != null) {
        error = failed.failure;
        items.remove(failed);
      }
      items.insertAll(index.clamp(0, items.length), archived);
      _changedNow();
    }
    return sent;
  }

  bool _answer(Map<String, dynamic> result) {
    final current = request;
    if (current == null) return false;
    final ok = current.request.raw.respond(result);
    gateway.forgetRequest(current.request.id);
    request = null;
    _changed();
    return ok;
  }

  bool answerApproval(String choice) => _answer({'choice': choice});

  /// Answers this chat's waiting setup card [requestId] on the socket it
  /// arrived on. False when that card is no longer the one waiting here
  /// (withdrawn, answered elsewhere, or replaced by a newer card) or the
  /// answer did not go out.
  bool answerSetupBeat(String requestId, Map<String, dynamic> result) =>
      sendSetupBeat(requestId, result) == SetupBeatSend.sent;

  /// Sends [result] for this chat's waiting setup card [requestId]. The
  /// card closes only once the answer went out; a send that failed keeps it
  /// to be answered again, as the Desktop's setup-beat store does.
  SetupBeatSend sendSetupBeat(String requestId, Map<String, dynamic> result) {
    final current = request;
    if (current == null ||
        current.kind != NgRequestKind.setupBeat ||
        current.request.id != requestId ||
        !gateway.openRequests.containsKey(requestId)) {
      return SetupBeatSend.closed;
    }
    if (!current.request.raw.respond(result)) return SetupBeatSend.failed;
    gateway.forgetRequest(current.request.id);
    request = null;
    _changed();
    return SetupBeatSend.sent;
  }

  /// A message sent while a setup card waits closes it unanswered with
  /// `{wrote_instead: true}`: the backend ends the card's turn and the
  /// message runs as the next one (Desktop's yieldSetupBeatToMessage). True
  /// when a card closed.
  bool yieldSetupBeatToMessage() {
    final current = request;
    if (current == null || current.kind != NgRequestKind.setupBeat) {
      return false;
    }
    return sendSetupBeat(current.request.id, const {'wrote_instead': true}) ==
        SetupBeatSend.sent;
  }

  bool answerClarify(List<List<String>> answers) {
    final current = request;
    if (current == null) return false;
    final texts = answers
        .map(
          (picked) => switch (picked.length) {
            0 => '',
            1 => picked.single,
            _ => jsonEncode(picked),
          },
        )
        .toList();
    final batch = current.questions.any((q) => q.qid != null);
    return _answer(
      batch
          ? {
              'answers': {
                for (var i = 0; i < current.questions.length; i++)
                  current.questions[i].qid ?? '$i': i < texts.length
                      ? texts[i]
                      : '',
              },
            }
          : {'answer': texts.isEmpty ? '' : texts.first},
    );
  }

  bool cancelClarify() => _answer(const {});

  bool answerValue(String value) => _answer({'value': value});

  bool answerSaveLogin(String identifier, String password) => _answer({
    'value': password.isEmpty
        ? ''
        : jsonEncode({'identifier': identifier, 'password': password}),
  });

  String? _modelConfirmationToken;
  String? _modelConfirmationKey;
  bool _modelConfirmationSent = false;
  String? _retainedModelKey;
  Map<String, dynamic>? _retainedModelMutation;

  /// Switches this chat's model (and provider) without showing an unconfirmed
  /// choice as though it were active.
  Future<NgModelSwitchResult> setModel({
    required String provider,
    required String model,
    bool confirm = false,
  }) async {
    final previousModel = this.model;
    final previousProvider = this.provider;
    final key = '$provider/$model';
    if (_retainedModelKey != null && _retainedModelKey != key) {
      _clearRetainedModelMutation();
      _clearModelConfirmation();
    } else if (!confirm &&
        (_modelConfirmationKey != key || !_modelConfirmationSent)) {
      _clearModelConfirmation();
    }
    if (runtimeId == null && storedId == null) {
      _pickedModel = model;
      _pickedProvider = provider;
      this.model = model;
      this.provider = provider;
      _changed();
      return const NgModelSwitchDone();
    }
    if (runtimeId == null) await _attach();
    final id = runtimeId;
    if (id == null) {
      return _finishModelSwitch(
        NgModelSwitchFailed(
          ngL.ng_model_switch_not_connected,
          clearConfirmation: false,
        ),
        previousModel,
        previousProvider,
        provider,
        model,
      );
    }
    final result = await _sendModelSwitch(
      id,
      provider: provider,
      model: model,
      confirm: confirm,
      confirmationKey: key,
    );
    return _finishModelSwitch(
      result,
      previousModel,
      previousProvider,
      provider,
      model,
    );
  }

  NgModelSwitchResult _finishModelSwitch(
    NgModelSwitchResult result,
    String? previousModel,
    String? previousProvider,
    String provider,
    String model,
  ) {
    switch (result) {
      case NgModelSwitchDone(:final resolvedModel, :final info) ||
          NgModelSwitchDeferred(:final resolvedModel, :final info):
        this.model = resolvedModel ?? model;
        this.provider = provider;
        if (info != null) _withInfo(info);
        _clearModelConfirmation();
      case NgModelSwitchNeedsConfirmation():
        this.model = previousModel ?? this.model;
        this.provider = previousProvider ?? this.provider;
      case NgModelSwitchFailed(:final message, :final clearConfirmation):
        this.model = previousModel ?? this.model;
        this.provider = previousProvider ?? this.provider;
        error = message;
        if (clearConfirmation) _clearModelConfirmation();
    }
    _changed();
    return result;
  }

  static Map<String, dynamic>? _infoMap(Object? raw) =>
      raw is Map<String, dynamic>
      ? raw
      : raw is Map
      ? Map<String, dynamic>.from(raw)
      : null;

  static String? _nonEmptyString(Object? raw) {
    final value = raw is String ? raw : null;
    return value == null || value.isEmpty ? null : value;
  }

  Future<NgModelSwitchResult> _sendModelSwitch(
    String id, {
    required String provider,
    required String model,
    required bool confirm,
    required String confirmationKey,
  }) async {
    if (gateway.sessionAuthority) {
      return _mutateModel(
        id,
        provider: provider,
        model: model,
        confirm: confirm,
        confirmationKey: confirmationKey,
      );
    }
    try {
      final result = await gateway.call('config.set', {
        'session_id': id,
        'key': 'model',
        'value': WsClient.buildSessionModelValue(
          provider: provider,
          model: model,
        ),
        if (confirm) 'confirm_expensive_model': true,
      });
      if (result['confirm_required'] == true) {
        return NgModelSwitchNeedsConfirmation(
          result['confirm_message']?.toString() ??
              result['warning']?.toString() ??
              ngL.ng_model_confirmation_required,
        );
      }
      final info = _infoMap(result['info']);
      final resolved = _nonEmptyString(result['model']);
      if (result['status']?.toString() == 'deferred') {
        return NgModelSwitchDeferred(resolvedModel: resolved, info: info);
      }
      return NgModelSwitchDone(resolvedModel: resolved, info: info);
    } on JsonRpcError catch (e) {
      if (_modelErrorIs(e, 'use_session_mutation_model')) {
        return _mutateModel(
          id,
          provider: provider,
          model: model,
          confirm: confirm,
          confirmationKey: confirmationKey,
        );
      }
      return NgModelSwitchFailed(_clean(e));
    } catch (e) {
      return NgModelSwitchFailed(_clean(e), clearConfirmation: false);
    }
  }

  static bool _modelErrorIs(JsonRpcError error, String reason) =>
      error.reason == reason || error.message == reason;

  Future<NgModelSwitchResult> _mutateModel(
    String id, {
    required String provider,
    required String model,
    required bool confirm,
    required String confirmationKey,
  }) async {
    if (_revision == null || _executionGeneration == null) await _attach();
    if (_revision == null || _executionGeneration == null) {
      return NgModelSwitchFailed(
        ngL.ng_model_switch_not_connected,
        clearConfirmation: false,
      );
    }
    var retried = false;
    while (true) {
      final useToken =
          _modelConfirmationKey == confirmationKey &&
          _modelConfirmationToken != null &&
          _modelConfirmationToken!.isNotEmpty &&
          (confirm || _modelConfirmationSent);
      if (useToken) _modelConfirmationSent = true;
      final token = useToken ? _modelConfirmationToken : null;
      final retained = _retainedModelKey == confirmationKey
          ? _retainedModelMutation
          : null;
      final retainedPayload = retained?['payload'];
      final retainedToken = retainedPayload is Map
          ? retainedPayload['confirm']?.toString()
          : null;
      final params =
          retained != null &&
              retained['session_id'] == id &&
              retainedToken == token
          ? retained
          : <String, dynamic>{
              'session_id': id,
              'request_id': const Uuid().v4(),
              'expected_revision': _revision,
              'expected_generation': _executionGeneration,
              'operation': 'model',
              'payload': <String, dynamic>{
                'model': model,
                'provider': provider,
                'confirm': ?token,
              },
            };
      _retainedModelKey = confirmationKey;
      _retainedModelMutation = params;
      try {
        final result = await gateway.call('session.mutate', params);
        _clearRetainedModelMutation();
        if (useToken) _clearModelConfirmation();
        _withAuthority(result);
        final status = result['status']?.toString();
        if (status == 'confirmation_required') {
          _modelConfirmationKey = confirmationKey;
          _modelConfirmationToken = result['confirm']?.toString();
          _modelConfirmationSent = false;
          return NgModelSwitchNeedsConfirmation(
            result['confirm_message']?.toString() ??
                result['warning']?.toString() ??
                ngL.ng_model_confirmation_required,
          );
        }
        final info = _infoMap(result['info']);
        final resolved = _nonEmptyString(result['model']);
        if (status == 'deferred') {
          return NgModelSwitchDeferred(resolvedModel: resolved, info: info);
        }
        return NgModelSwitchDone(resolvedModel: resolved, info: info);
      } on JsonRpcError catch (e) {
        final fence =
            _modelErrorIs(e, 'revision_conflict') ||
            _modelErrorIs(e, 'stale_generation');
        if (fence && !retried) {
          final sentRev = params['expected_revision'];
          final sentGen = params['expected_generation'];
          _clearRetainedModelMutation();
          _withAuthority(e.data);
          retried = true;
          if (_revision != null &&
              _executionGeneration != null &&
              (_revision != sentRev || _executionGeneration != sentGen)) {
            continue;
          }
        }
        final settledByOwner = e.reason != null;
        if (settledByOwner) _clearRetainedModelMutation();
        return NgModelSwitchFailed(
          _clean(e),
          clearConfirmation: settledByOwner,
        );
      } catch (e) {
        return NgModelSwitchFailed(_clean(e), clearConfirmation: false);
      }
    }
  }

  void _clearRetainedModelMutation() {
    _retainedModelKey = null;
    _retainedModelMutation = null;
  }

  void _clearModelConfirmation() {
    _modelConfirmationToken = null;
    _modelConfirmationKey = null;
    _modelConfirmationSent = false;
  }

  /// Switches this chat's thinking level.
  Future<void> setReasoning(String effort) async {
    final previous = reasoningEffort;
    final previousWire = reasoningEffortWire;
    reasoningEffort = effort;
    reasoningEffortWire = '';
    _changed();
    if (runtimeId == null && storedId == null) {
      _pickedEffort = effort;
      return;
    }
    if (runtimeId == null) await _attach();
    if (runtimeId == null) {
      reasoningEffort = previous;
      reasoningEffortWire = previousWire;
      _changed();
      throw StateError(ngL.ng_model_switch_not_connected);
    }
    try {
      await gateway.call('config.set', {
        'session_id': runtimeId,
        'key': 'reasoning',
        'value': effort,
      });
    } catch (_) {
      reasoningEffort = previous;
      reasoningEffortWire = previousWire;
      _changed();
      rethrow;
    }
  }

  /// Renames the chat.
  Future<void> rename(String newTitle) async {
    final id = storedId;
    if (id == null) return;
    final saved = await gateway.api.renameSession(
      sessionId: id,
      title: newTitle,
    );
    title = saved;
    _changed();
  }

  @override
  void dispose() {
    _disposed = true;
    SystemSleepGate.instance.removeListener(_onSleepGate);
    SystemSleepGate.instance.releaseReconcile(this);
    for (final sub in _subs) {
      unawaited(sub.cancel());
    }
    kanban.dispose();
    super.dispose();
  }
}

/// The events after [from] for [runtimeId], oldest first, when the replay
/// proves none is missing; null when the gap can't be trusted and the chat
/// must be read again (Kyllene's EventReplay): truncated, another or missing
/// epoch, `latest_seq` below [from], an incomplete replay, a hole in the seqs
/// or another session's event.
List<StreamEvent>? ngParseReplay(
  Map<String, dynamic> reply,
  String runtimeId,
  int from,
  String? epoch,
) {
  final latest = reply['latest_seq'];
  final events = reply['events'];
  if (latest is! num || events is! List) return null;
  if (reply['truncated'] != false) return null;
  final replyEpoch = reply['epoch']?.toString();
  if (epoch != null && replyEpoch != epoch) return null;
  if (latest < from) return null;
  var cursor = from;
  final missed = <StreamEvent>[];
  for (final raw in events) {
    if (raw is! Map) return null;
    final frame = Map<String, dynamic>.from(raw);
    if (frame['session_id'] != runtimeId) return null;
    final seq = frame['seq'];
    if (seq is! int) return null;
    if (seq <= cursor) continue;
    if (seq != cursor + 1) return null;
    cursor = seq;
    final event = WsClient.parseGatewayEvent(frame);
    if (event == null) return null;
    missed.add(event);
  }
  // A syntactically valid prefix is still incomplete when the server says it
  // had later events. Reload rather than silently advancing over missing work.
  if (cursor != latest) return null;
  return missed;
}

/// Where a canonical session's event stream stands for this chat: the
/// session's own replay epoch and the last sequence applied (or covered by
/// an accepted snapshot).
@immutable
class NgReplayCursor {
  final String epoch;
  final int sequence;
  const NgReplayCursor(this.epoch, this.sequence);

  @override
  bool operator ==(Object other) =>
      other is NgReplayCursor &&
      other.epoch == epoch &&
      other.sequence == sequence;

  @override
  int get hashCode => Object.hash(epoch, sequence);
}

/// The canonical events after [from] in [epoch] for [sessionId], oldest
/// first, when the owner's `session.events.since` reply proves none is
/// missing; null when a snapshot is needed instead: `snapshot_required` or
/// `truncated`, another epoch (a restart or new stream), a frame of another
/// epoch or session, a hole, or fewer events than `last_sequence` promises.
List<StreamEvent>? ngParseCanonicalReplay(
  Map<String, dynamic> reply,
  String sessionId,
  String epoch,
  int from,
) {
  if (reply['snapshot_required'] != false || reply['truncated'] != false) {
    return null;
  }
  final replyEpoch = reply['replay_epoch'] ?? reply['epoch'];
  if (replyEpoch != epoch) return null;
  final latest = reply['last_sequence'] ?? reply['latest_seq'];
  final events = reply['events'];
  if (latest is! int || events is! List || latest < from) return null;
  var cursor = from;
  final missed = <StreamEvent>[];
  for (final raw in events) {
    if (raw is! Map) return null;
    final frame = Map<String, dynamic>.from(raw);
    if (frame['session_id'] != sessionId) return null;
    if (frame['replay_epoch'] != epoch) return null;
    final seq = frame['seq'];
    if (seq is! int) return null;
    if (seq <= cursor) continue;
    if (seq != cursor + 1) return null;
    cursor = seq;
    final event = WsClient.parseGatewayEvent(frame);
    if (event == null) return null;
    missed.add(event);
  }
  if (cursor != latest) return null;
  return missed;
}
