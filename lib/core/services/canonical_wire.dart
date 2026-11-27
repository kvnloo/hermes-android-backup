// The one guard between an Ares producer and a session-authority (Hermes
// 0.23+) gateway's closed wire contracts.
//
// A gateway that advertises `session_authority` in `gateway.ready` routes
// session verbs through `gateway/session_controls.py::AuthorityConnection`:
// its params models forbid unknown keys (`4001 invalid_params`), several
// legacy verbs no longer exist there (`session.title`, `session.branch`,
// `session.compress` answer `-32601`), and approvals and questions are
// answered by prompt id and execution generation.
//
// [CanonicalWire] is Ares's counterpart of Hermes Desktop's
// `canonicalProducerFrame` / `CanonicalDesktopProtocol`
// (apps/desktop/src/api/canonical-protocol.ts): it translates a legacy shape
// the owner has a canonical form for and refuses the rest by name before the
// wire, so nothing a producer sends reaches the gateway in a shape it
// rejects. `WsClient.send` applies it to every request on an authority
// socket; a legacy socket never goes through it.
import 'dart:convert';
import 'dart:ui' show PlatformDispatcher;

import 'package:uuid/uuid.dart';

import '../../l10n/app_localizations.dart';
import '../l10n/l10n.dart' show resolvePreferredLocale;

/// What a refusal before the wire is about.
enum CanonicalRefusalKind {
  /// A `config.set` key (or a `scope` on a key that takes none) the owner
  /// does not serve.
  setting,

  /// A method the owner does not serve for this owner (a session-owned
  /// connector verb outside the manage_connections card).
  method,

  /// `session.create` options the owner's create contract has no field for.
  sessionOptions,

  /// An approval or question that is no longer the one the owner waits on.
  promptStale,

  /// The session's revision is not known, so a fenced edit cannot be made.
  revisionUnavailable,

  /// The session's execution generation is not known.
  generationUnavailable,

  /// A branch at a message that has no durable id yet.
  messageNotSaved,
}

/// The JSON-RPC code of a request refused before the wire. Never sent by a
/// gateway: `4001` there means its own refusal (or, on a legacy gateway, an
/// unknown session), and `-32601` drives capability fallbacks.
const canonicalRefusalCode = 4999;

/// `error.data.reason` of a request refused before the wire.
const canonicalRefusalReason = 'canonical_unavailable';

/// A request Ares did not send, because the session-authority gateway has no
/// form for it. [subject] is the setting, method or option list it names.
class CanonicalWireRefusal implements Exception {
  const CanonicalWireRefusal(this.kind, this.method, {this.subject = ''});

  final CanonicalRefusalKind kind;
  final String method;
  final String subject;

  /// The text shown to the user, in [strings]' language.
  String message(AppLocalizations strings) => switch (kind) {
    CanonicalRefusalKind.setting => strings.ng_wire_setting_unavailable(
      subject,
    ),
    CanonicalRefusalKind.method => strings.ng_wire_method_unavailable(subject),
    CanonicalRefusalKind.sessionOptions =>
      strings.ng_wire_session_options_unsupported(subject),
    CanonicalRefusalKind.promptStale => strings.ng_wire_prompt_stale,
    CanonicalRefusalKind.revisionUnavailable =>
      strings.ng_wire_revision_unavailable,
    CanonicalRefusalKind.generationUnavailable =>
      strings.ng_wire_generation_unavailable,
    CanonicalRefusalKind.messageNotSaved => strings.ng_wire_message_not_saved,
  };

  /// The JSON-RPC `error` object `WsClient.send` answers with, so every
  /// caller reads it as a definite refusal: nothing was sent.
  Map<String, dynamic> toError([AppLocalizations? strings]) => {
    'code': canonicalRefusalCode,
    'message': message(strings ?? canonicalWireStrings()),
    'data': {
      'reason': canonicalRefusalReason,
      'kind': kind.name,
      'method': method,
      if (subject.isNotEmpty) 'subject': subject,
    },
  };

  /// The refusal an `error.data` map (or a `JsonRpcError.data`) carries, or
  /// null when it is any other error. Lets a view show [message] in its own
  /// language instead of the device language the service used.
  static CanonicalWireRefusal? fromData(Object? data) {
    if (data is! Map || data['reason'] != canonicalRefusalReason) return null;
    final kind = CanonicalRefusalKind.values
        .where((value) => value.name == data['kind'])
        .firstOrNull;
    if (kind == null) return null;
    return CanonicalWireRefusal(
      kind,
      data['method']?.toString() ?? '',
      subject: data['subject']?.toString() ?? '',
    );
  }

  @override
  String toString() => 'CanonicalWireRefusal($method): ${kind.name} $subject';
}

/// The app's strings for a refusal raised outside any widget: the device
/// language, as notifications use.
AppLocalizations canonicalWireStrings() => lookupAppLocalizations(
  resolvePreferredLocale(
    PlatformDispatcher.instance.locales,
    AppLocalizations.supportedLocales,
  ),
);

/// `config.set` keys the owner serves
/// (`tui_gateway/contracts/canonical_projections.py::CanonicalConfigSetParams`,
/// `gateway/session_tui_config.py`), as Desktop's `CANONICAL_CONFIG_KEYS`.
const canonicalConfigKeys = <String>{
  'busy',
  'verbose',
  'yolo',
  'model',
  'reasoning',
  'fast',
  'daybreak',
  'personality',
  'approvals.mode',
  'voice.voice_chat_mode',
  'display.message_reactions',
  'display.in_app_tips',
  'display.in_app_tours',
};

/// The keys that take a `scope` (`reasoning --global`, the global yolo zap).
const canonicalScopedConfigKeys = <String>{'reasoning', 'yolo'};

/// The manage_connections card's calls the owner serves for a session-owned
/// operation (`gateway/session_connections.py`); any other session-owned
/// connector call is refused.
const canonicalOwnerConnectionVerbs = <String>{
  'connection.respond',
  'connectors.operation.status',
  'connectors.operation.wake',
  'connectors.connect',
};

/// Legacy RPC answers to a sensitive prompt. A session authority asks for a
/// sudo password or a secret as a server request and takes the answer as
/// that request's response frame; neither it nor its sidecar serves these.
const canonicalUnservedMethods = <String>{'sudo.respond', 'secret.respond'};

/// The levels `hermes_constants.parse_reasoning_effort` accepts.
const canonicalReasoningEfforts = <String>{
  'none',
  'false',
  'disabled',
  'minimal',
  'low',
  'medium',
  'high',
  'xhigh',
  'max',
  'ultra',
};

const _createKeys = <String>{
  'request_id',
  'source',
  'cwd',
  'model',
  'provider',
  'toolsets',
  'reasoning',
  'profile',
  'title',
  'hidden',
  'follow_profile_config',
  'service_tier',
  'cwd_explicit',
};

const _canonicalSources = <String>{
  'cli',
  'tui',
  'gui',
  'acp',
  'tool',
  'oneshot',
};

/// Whether a `config.set` for [key] can be sent on a session-authority
/// socket; a control for one that cannot is hidden or disabled there.
bool canonicalConfigAvailable(String key, {String? scope}) =>
    canonicalConfigKeys.contains(key) &&
    (scope == null || canonicalScopedConfigKeys.contains(key));

/// The composer picker's `config.set key=model` value (a model name, then
/// an optional `--provider id` and an optional `--session`) as the owner's
/// model mutation payload; null for a value with any other flag, which has
/// no canonical field.
Map<String, dynamic>? canonicalModelPick(Object? value) {
  final tokens = (value?.toString() ?? '').trim().split(RegExp(r'\s+'));
  if (tokens.isEmpty || tokens.first.isEmpty || tokens.first.startsWith('-')) {
    return null;
  }
  final model = tokens.first;
  var flags = tokens.sublist(1);
  // The canonical model mutation is always session-scoped policy.
  if (flags.isNotEmpty && flags.last == '--session') {
    flags = flags.sublist(0, flags.length - 1);
  }
  if (flags.isEmpty) return {'model': model};
  if (flags.length != 2 ||
      flags[0] != '--provider' ||
      flags[1].isEmpty ||
      flags[1].startsWith('-')) {
    return null;
  }
  return {'model': model, 'provider': flags[1]};
}

/// A request as it goes on the wire, with the producer's own call kept for
/// reading the answer back in the shape that producer expects.
class CanonicalRequest {
  CanonicalRequest._(
    this.sourceMethod,
    this.sourceParams,
    this.method,
    this.params, {
    this.operation,
  });

  final String sourceMethod;
  final Map<String, dynamic> sourceParams;
  final String method;
  final Map<String, dynamic> params;

  /// The `session.mutate` operation this request became, if it did.
  final String? operation;

  bool get translated => method != sourceMethod || operation != null;
}

/// Raised inside [CanonicalWire.prepare] when a fenced edit needs the
/// session's revision or generation and the socket has not learned it: the
/// caller reads them (`session.resume`) and prepares again.
class CanonicalFencesNeeded implements Exception {
  const CanonicalFencesNeeded(this.sessionId, this.refusal);
  final String sessionId;
  final CanonicalWireRefusal refusal;
}

class _Prompt {
  _Prompt(this.kind, this.sessionId, this.generation, this.payload);
  final String kind;
  final String sessionId;
  final int generation;
  final Map<String, dynamic> payload;
}

/// One socket's canonical state: session revisions, the prompts its owner
/// waits on, and the edits whose answer is still unknown.
class CanonicalWire {
  CanonicalWire({required this.generationFor, String Function()? newId})
    : _newId = newId ?? const Uuid().v4;

  /// The execution generation the socket last admitted for a session.
  final int? Function(String sessionId) generationFor;
  final String Function() _newId;

  final _revisions = <String, int>{};
  final _prompts = <String, _Prompt>{};
  // [owner, operation, payload] -> the request whose outcome is unknown. A
  // retry after a lost reply re-presents it with the same request id, so the
  // owner answers with its first receipt instead of editing twice.
  final _mutations = <String, Map<String, dynamic>>{};
  // [owner, model payload] -> the owner's one-time token for a guarded model.
  final _modelConfirmations = <String, ({String token, bool sent})>{};

  static String _owner(Object? sessionId, Object? profile) => jsonEncode([
    profile is String && profile.isNotEmpty ? profile : 'default',
    sessionId,
  ]);

  /// The revision the next edit of [sessionId] must present, when known.
  int? revisionFor(String sessionId, {Object? profile}) =>
      _revisions[_owner(sessionId, profile)];

  /// Whether [id] is a prompt the owner published (`approval.request` /
  /// `clarify.request`) and still waits on.
  bool holdsPrompt(String id) => _prompts.containsKey(id);

  /// The request frame Ares hands its views for a canonical prompt, shaped
  /// like the legacy server request of the same kind so both layouts show
  /// their existing card (Desktop's `canonicalPromptParams`).
  static Map<String, dynamic> promptRequestParams(
    String kind,
    String sessionId,
    Map<String, dynamic> prompt,
  ) {
    final choices = prompt['choices'] is List
        ? List<dynamic>.from(prompt['choices'] as List)
        : const <dynamic>[];
    if (kind == 'clarify') {
      return {
        'session_id': sessionId,
        if (prompt['answers'] != null) 'answers': prompt['answers'],
        'questions': prompt['questions'] is List
            ? prompt['questions']
            : [
                {
                  'qid': prompt['prompt_id'],
                  'question': prompt['question'],
                  'choices': choices,
                  'multi_select': prompt['multi_select'] == true,
                },
              ],
      };
    }
    return {
      'session_id': sessionId,
      'request_id': prompt['prompt_id'],
      'command': prompt['command'],
      'description': prompt['description'],
      'choices': choices,
      'allow_permanent': choices.contains('always'),
      if (prompt['edit'] != null) 'edit': prompt['edit'],
    };
  }

  /// The open prompts of a `session.resume` / `session.create` snapshot as
  /// `open_requests` rows, after recording them.
  List<Map<String, dynamic>> _adoptSnapshotPrompts(Map<String, dynamic> value) {
    final sessionId = value['session_id'];
    final prompts = value['prompts'];
    if (sessionId is! String || prompts is! List) return const [];
    final rows = <Map<String, dynamic>>[];
    for (final raw in prompts) {
      if (raw is! Map) continue;
      final prompt = Map<String, dynamic>.from(raw);
      final kind = prompt['kind'];
      final id = prompt['prompt_id'];
      final generation =
          prompt['execution_generation'] ?? value['execution_generation'];
      if (kind is! String || id is! String || generation is! int) continue;
      if (kind != 'approval' && kind != 'clarify') continue;
      _prompts[id] = _Prompt(kind, sessionId, generation, prompt);
      rows.add({
        'id': id,
        'method': kind,
        'params': promptRequestParams(kind, sessionId, prompt),
      });
    }
    return rows;
  }

  /// A live `approval.request` / `clarify.request` event: the server-request
  /// frame to hand the views, or null when the event is not a canonical
  /// prompt.
  ({String id, String method, Map<String, dynamic> params})? adoptPromptEvent(
    String type,
    String? sessionId,
    Map<String, dynamic> payload,
    Object? envelopeGeneration,
  ) {
    if (type != 'approval.request' && type != 'clarify.request') return null;
    final id = payload['prompt_id'];
    final generation = envelopeGeneration ?? payload['execution_generation'];
    if (sessionId == null || id is! String || generation is! int) return null;
    final kind = type.substring(0, type.length - '.request'.length);
    _prompts[id] = _Prompt(kind, sessionId, generation, payload);
    return (
      id: id,
      method: kind,
      params: promptRequestParams(kind, sessionId, payload),
    );
  }

  /// A settled prompt's id, when [type] is `approval.settled` /
  /// `clarify.settled` for one this socket holds.
  String? settlePromptEvent(String type, Map<String, dynamic> payload) {
    if (!type.endsWith('.settled')) return null;
    final id = payload['prompt_id'];
    return id is String && _prompts.remove(id) != null ? id : null;
  }

  /// Revisions the owner announces between this socket's own requests:
  /// `session.info` states it, `session.updated` is another viewer's
  /// committed edit (never moves it backwards).
  void noteEvent(String type, String? sessionId, Map<String, dynamic> payload) {
    final revision = payload['revision'];
    if (sessionId == null || revision is! int) return;
    final owner = _owner(sessionId, null);
    if (type == 'session.info') {
      _revisions[owner] = revision;
    } else if (type == 'session.updated' &&
        (payload['session_id'] ?? sessionId) == sessionId &&
        revision > (_revisions[owner] ?? -1)) {
      _revisions[owner] = revision;
      _retireSuperseded(owner, revision);
    }
    if (type == 'session.updated' &&
        payload['operation'] == 'model' &&
        payload['status'] == 'confirmation_required' &&
        payload['confirm'] is String &&
        payload['payload'] is Map) {
      _modelConfirmations[_confirmationKey(
        owner,
        Map<String, dynamic>.from(payload['payload'] as Map),
      )] = (
        token: payload['confirm'] as String,
        sent: false,
      );
    }
  }

  String _confirmationKey(String owner, Map<String, dynamic> payload) =>
      jsonEncode([
        owner,
        _sorted({...payload}..remove('confirm')),
      ]);

  static Map<String, dynamic> _sorted(Map<String, dynamic> map) => {
    for (final key in map.keys.toList()..sort()) key: map[key],
  };

  Map<String, dynamic> _mutation(
    String method,
    Object? sessionId,
    Object? profile,
    String operation,
    Map<String, dynamic> payload, {
    required bool withGeneration,
  }) {
    if (sessionId is! String || sessionId.isEmpty) {
      throw CanonicalWireRefusal(
        CanonicalRefusalKind.revisionUnavailable,
        method,
      );
    }
    final owner = _owner(sessionId, profile);
    final key = jsonEncode([owner, operation, _sorted(payload)]);
    // Only a session's very next control may retry an ambiguous one.
    _mutations.removeWhere(
      (other, _) => other != key && (jsonDecode(other) as List).first == owner,
    );
    final retained = _mutations[key];
    if (retained != null) return retained;
    final revision = _revisions[owner];
    if (revision == null) {
      throw CanonicalFencesNeeded(
        sessionId,
        CanonicalWireRefusal(CanonicalRefusalKind.revisionUnavailable, method),
      );
    }
    final generation = withGeneration ? generationFor(sessionId) : null;
    if (withGeneration && generation == null) {
      throw CanonicalFencesNeeded(
        sessionId,
        CanonicalWireRefusal(
          CanonicalRefusalKind.generationUnavailable,
          method,
        ),
      );
    }
    return _mutations[key] = {
      'session_id': sessionId,
      'request_id': _newId(),
      'expected_revision': revision,
      'expected_generation': ?generation,
      'operation': operation,
      'payload': payload,
    };
  }

  CanonicalRequest _mutate(
    String method,
    Map<String, dynamic> params,
    String operation,
    Map<String, dynamic> payload, {
    required bool withGeneration,
    Object? session,
  }) {
    final mutation = _mutation(
      method,
      session ?? params['session_id'],
      params['profile'],
      operation,
      payload,
      withGeneration: withGeneration,
    );
    return CanonicalRequest._(method, params, 'session.mutate', {
      ...mutation,
      if (params['profile'] != null) 'profile': params['profile'],
    }, operation: operation);
  }

  Map<String, dynamic> _confirmedModel(
    Map<String, dynamic> params,
    Map<String, dynamic> payload,
  ) {
    final key = _confirmationKey(
      _owner(params['session_id'], params['profile']),
      payload,
    );
    final confirmation = _modelConfirmations[key];
    if (confirmation == null ||
        !(params['confirm_expensive_model'] == true || confirmation.sent)) {
      return payload;
    }
    _modelConfirmations[key] = (token: confirmation.token, sent: true);
    return {...payload, 'confirm': confirmation.token};
  }

  /// [method] and [params] as the owner's contract takes them. Throws
  /// [CanonicalWireRefusal] for a request it has no form for, and
  /// [CanonicalFencesNeeded] when a fenced edit must first learn the
  /// session's revision or generation.
  CanonicalRequest prepare(String method, Map<String, dynamic> params) {
    CanonicalRequest same([Map<String, dynamic>? wire]) =>
        CanonicalRequest._(method, params, method, wire ?? params);
    switch (method) {
      case 'config.set':
        final key = params['key']?.toString() ?? '';
        final hasScope = params.containsKey('scope');
        if (!canonicalConfigKeys.contains(key) ||
            (hasScope && !canonicalScopedConfigKeys.contains(key))) {
          throw CanonicalWireRefusal(
            CanonicalRefusalKind.setting,
            method,
            subject: hasScope ? '$key (${params['scope']})' : key,
          );
        }
        if (key == 'model') {
          // A model pick is the owner's revision-fenced mutation; a config
          // write is refused there (`use_session_mutation_model`).
          final pick = canonicalModelPick(params['value']);
          if (pick == null) {
            throw CanonicalWireRefusal(
              CanonicalRefusalKind.setting,
              method,
              subject: key,
            );
          }
          return _mutate(
            method,
            params,
            'model',
            _confirmedModel(params, pick),
            withGeneration: true,
          );
        }
        final effort = (params['value']?.toString() ?? '').trim().toLowerCase();
        if (key == 'reasoning' &&
            params['scope'] != 'global' &&
            canonicalReasoningEfforts.contains(effort)) {
          try {
            return _mutate(method, params, 'reasoning', {
              'effort': effort,
            }, withGeneration: true);
          } on CanonicalFencesNeeded {
            // The owner also serves `config.set reasoning` itself (the
            // `/reasoning` command): send that instead of refusing.
            return same();
          } on CanonicalWireRefusal {
            return same();
          }
        }
        return same();
      case 'session.title':
        return _mutate(method, params, 'rename', {
          'title': params['title'],
        }, withGeneration: false);
      case 'session.archive':
        return _mutate(method, params, 'archive', {
          'archived': params['archived'],
        }, withGeneration: false);
      case 'session.compress':
        final focus = params['focus_topic'];
        return _mutate(method, params, 'compress', {
          if (focus is String && focus.isNotEmpty) 'focus': focus,
        }, withGeneration: true);
      case 'session.branch' ||
          'session.branch_stored' ||
          'session.branch_whole':
        final through = params['through_message_id'];
        if (through == null && params['count'] != null) {
          // Without a durable id the owner would copy the whole history.
          throw CanonicalWireRefusal(
            CanonicalRefusalKind.messageNotSaved,
            method,
          );
        }
        final title = params['title'] ?? params['name'];
        return _mutate(
          method,
          params,
          'branch',
          {
            if (title is String && title.isNotEmpty) 'title': title,
            if (through is int && through > 0) 'through_message_id': through,
          },
          withGeneration: true,
          session: params['parent_session_id'] ?? params['session_id'],
        );
      case 'session.cwd.set':
        return _mutate(method, params, 'workspace', {
          'cwd': params['cwd'],
        }, withGeneration: true);
      case 'session.workspace.move':
        return _mutate(
          method,
          params,
          'workspace',
          {'cwd': params['cwd']},
          withGeneration: true,
          session: params['session_key'] ?? params['session_id'],
        );
      case 'session.activate':
        // The canonical attach is `session.resume`.
        return CanonicalRequest._(method, params, 'session.resume', {
          'session_id': params['session_id'],
          if (params['profile'] != null) 'profile': params['profile'],
        });
      case 'session.resume':
        if (!params.containsKey('lazy') &&
            !params.containsKey('inline_images')) {
          return same();
        }
        return same({
          for (final entry in params.entries)
            if (entry.key != 'lazy' && entry.key != 'inline_images')
              entry.key: entry.value,
          // A lazy attach skipped the transcript prefetch: it takes it here.
          if (params.containsKey('lazy')) 'omit_messages': false,
        });
      case 'session.create':
        return same(_create(method, params));
      case 'session.interrupt' || 'session.redirect' || 'session.steer':
        if (params['execution_generation'] is int) return same();
        final sessionId = params['session_id'];
        final generation = sessionId is String
            ? generationFor(sessionId)
            : null;
        if (generation == null) {
          throw CanonicalWireRefusal(
            CanonicalRefusalKind.generationUnavailable,
            method,
          );
        }
        return same({...params, 'execution_generation': generation});
      case 'approval.respond' || 'clarify.respond':
        return same(_promptResponse(method, params));
      case 'clarify.lock':
        // A projected canonical question is answered by prompt id; a batch
        // request the owner sent as one frame keeps `clarify.lock`.
        final id = params['request_id'];
        if (id is! String || !_prompts.containsKey(id)) return same();
        return CanonicalRequest._(
          method,
          params,
          'clarify.respond',
          _promptResponse('clarify.respond', params),
        );
      case 'prompt.submit':
        // The owner admits identified input only.
        final id = params['submission_id'] ?? params['input_id'];
        if (id is String && id.isNotEmpty) return same();
        return same({...params, 'submission_id': _newId()});
      case 'bot_relay.deliver':
        return same(_botDelivery(params));
    }
    final owner = params['owner'];
    if (canonicalUnservedMethods.contains(method) ||
        method.startsWith('connect') &&
            owner is Map &&
            owner['type'] == 'session' &&
            !canonicalOwnerConnectionVerbs.contains(method)) {
      throw CanonicalWireRefusal(
        CanonicalRefusalKind.method,
        method,
        subject: method,
      );
    }
    return same();
  }

  Map<String, dynamic> _create(String method, Map<String, dynamic> input) {
    final params = {...input};
    final effort = params.remove('reasoning_effort');
    final fast = params.remove('fast');
    final picked = params['service_tier'];
    final roomPlumbing = params.remove('room_plumbing');
    if (roomPlumbing == true) params['follow_profile_config'] = true;
    if (effort is String && effort.isNotEmpty) params['reasoning'] = effort;
    if (!(picked is String && picked.isNotEmpty)) {
      params.remove('service_tier');
      if (fast == true) params['service_tier'] = 'priority';
      if (fast == false) params['service_tier'] = 'normal';
    }
    if (params['cwd_explicit'] is! bool) params.remove('cwd_explicit');
    final unsupported = [
      for (final key in params.keys)
        if (!_createKeys.contains(key)) key,
    ];
    if (unsupported.isNotEmpty) {
      throw CanonicalWireRefusal(
        CanonicalRefusalKind.sessionOptions,
        method,
        subject: unsupported.join(', '),
      );
    }
    // 'desktop' is the legacy surface hint; the canonical graphical-chat
    // surface is 'gui'.
    if (!_canonicalSources.contains(params['source'])) params['source'] = 'gui';
    return params;
  }

  Map<String, dynamic> _promptResponse(
    String method,
    Map<String, dynamic> params,
  ) {
    final approval = method == 'approval.respond';
    final named = params['prompt_id'] ?? params['request_id'];
    final requested = params['session_id'];
    _Prompt? prompt;
    String? id;
    if (named is String && named.isNotEmpty) {
      id = named;
      prompt = _prompts[named];
    } else if (requested is String) {
      // The legacy call names only the session: its one open prompt.
      final open = [
        for (final entry in _prompts.entries)
          if (entry.value.sessionId == requested &&
              entry.value.kind == (approval ? 'approval' : 'clarify'))
            entry,
      ];
      if (open.length == 1) {
        id = open.single.key;
        prompt = open.single.value;
      }
    }
    if (prompt == null ||
        id == null ||
        prompt.kind != (approval ? 'approval' : 'clarify') ||
        (requested is String && requested != prompt.sessionId) ||
        prompt.generation != generationFor(prompt.sessionId)) {
      throw CanonicalWireRefusal(CanonicalRefusalKind.promptStale, method);
    }
    final field = approval ? 'choice' : 'answer';
    final value = params[field];
    return {
      'session_id': prompt.sessionId,
      'execution_generation': prompt.generation,
      'prompt_id': id,
      field: approval || value is String ? value : jsonEncode(value ?? ''),
      if (approval && params['profile'] != null) 'profile': params['profile'],
    };
  }

  static final _relayHandle = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9_-]{0,63}$');
  static final _relaySenderStamp = RegExp(
    r'^(Message from 🤖 [\s\S]+? \(@)[A-Za-z0-9_-]+(\): )',
    unicode: true,
  );

  // The canonical `bot_relay.deliver` is a closed key set without the legacy
  // `from_*` sender fields: a bot author keyed by the sender's connection,
  // and the message's `(@handle)` stamp qualified with that connection.
  static Map<String, dynamic> _botDelivery(Map<String, dynamic> params) {
    if (!params.keys.any((key) => key.startsWith('from_'))) return params;
    final rest = {
      for (final entry in params.entries)
        if (!const {
          'from_profile',
          'from_handle',
          'from_connection',
        }.contains(entry.key))
          entry.key: entry.value,
    };
    final profile = (params['from_profile']?.toString() ?? '').trim();
    final connection = (params['from_connection']?.toString() ?? '').trim();
    final handle = (params['from_handle']?.toString() ?? '')
        .trim()
        .replaceFirst(RegExp('^@'), '');
    if (profile.isEmpty) return rest;
    final message = rest['message'];
    return {
      ...rest,
      if (message is String &&
          _relayHandle.hasMatch(handle) &&
          _relayHandle.hasMatch(connection))
        'message': message.replaceFirstMapped(
          _relaySenderStamp,
          (match) => '${match[1]}$handle@$connection${match[2]}',
        ),
      'author': {
        'id': connection.isEmpty ? 'bot:$profile' : 'bot:$connection/$profile',
        'name': handle.isEmpty ? profile : handle,
        'is_bot': true,
      },
    };
  }

  void _forget(Map<String, dynamic> wire) {
    _mutations.removeWhere(
      (_, mutation) => mutation['request_id'] == wire['request_id'],
    );
  }

  void _settleConfirmation(Map<String, dynamic> wire) {
    final payload = wire['payload'];
    if (wire['operation'] != 'model' ||
        payload is! Map ||
        payload['confirm'] is! String) {
      return;
    }
    final key = _confirmationKey(
      _owner(wire['session_id'], wire['profile']),
      Map<String, dynamic>.from(payload),
    );
    if (_modelConfirmations[key]?.token == payload['confirm']) {
      _modelConfirmations.remove(key);
    }
  }

  // An acknowledged edit at revision R settles every older retained
  // value-setting request of the same owner; branch/compress stay retained
  // (a new request id there would run a second time).
  void _retireSuperseded(String owner, int revision) {
    const values = {'rename', 'archive', 'model', 'reasoning', 'workspace'};
    _mutations.removeWhere((key, mutation) {
      final parts = jsonDecode(key) as List;
      return parts[0] == owner &&
          values.contains(parts[1]) &&
          (mutation['expected_revision'] as int) < revision;
    });
  }

  /// The owner's error for [request]: a typed refusal settles a retained
  /// edit; a fence refusal also names the fences the next attempt presents.
  void noteFailure(CanonicalRequest request, Object? error) {
    if (request.operation == null || error is! Map) return;
    final data = error['data'];
    final reason = data is Map ? data['reason'] : null;
    if (reason is! String) return; // transport: the outcome is unknown
    _settleConfirmation(request.params);
    _forget(request.params);
    final revision = data is Map ? data['revision'] : null;
    final owner = _owner(
      request.params['session_id'],
      request.params['profile'],
    );
    if (revision is int && revision > (_revisions[owner] ?? -1)) {
      _revisions[owner] = revision;
    }
  }

  /// Whether a fence refusal of [request] may be sent once more at the
  /// fences the owner named: re-applying a value pick is harmless.
  bool retryableFence(CanonicalRequest request, Object? error) {
    if (error is! Map) return false;
    final data = error['data'];
    return const {'model', 'reasoning'}.contains(request.operation) &&
        data is Map &&
        data['revision'] is int &&
        (data['reason'] == 'revision_conflict' ||
            data['reason'] == 'stale_generation');
  }

  /// Sends [method] through the guard over [wire] and returns the JSON-RPC
  /// reply in the shape the producer's own method answers with.
  ///
  /// [wire] writes one frame and returns its reply (`own` is false for a
  /// read the guard adds itself). A request with no canonical form is not
  /// sent: the reply is a [canonicalRefusalCode] error. A fenced edit whose
  /// revision or generation is unknown first reads the session
  /// (`session.resume`, no transcript). A value pick refused on a stale
  /// fence is presented once more at the fences the owner named.
  Future<Map<String, dynamic>> run(
    String method,
    Map<String, dynamic> params, {
    required Future<Map<String, dynamic>> Function(
      String method,
      Map<String, dynamic> params, {
      required bool own,
    })
    wire,
    required void Function(String sessionId, Object? generation) noteGeneration,
    bool Function()? current,
    AppLocalizations? strings,
  }) async {
    bool live() => current?.call() ?? true;
    void adoptGeneration(Object? value) {
      if (value is! Map) return;
      final sessionId = value['session_id'];
      if (sessionId is String) {
        noteGeneration(sessionId, value['execution_generation']);
      }
    }

    void failed(CanonicalRequest request, Object? error) {
      noteFailure(request, error);
      final data = error is Map ? error['data'] : null;
      final sessionId = request.params['session_id'];
      if (data is Map && sessionId is String) {
        noteGeneration(sessionId, data['execution_generation']);
      }
    }

    CanonicalRequest request;
    try {
      try {
        request = prepare(method, params);
      } on CanonicalFencesNeeded catch (needed) {
        final resume = prepare('session.resume', {
          'session_id': needed.sessionId,
          'omit_messages': true,
          'defer_history': true,
          if (params['profile'] != null) 'profile': params['profile'],
        });
        final reply = await wire(resume.method, resume.params, own: false);
        if (reply['error'] == null && live()) {
          adoptGeneration(reply['result']);
          adaptResult(resume, reply['result']);
        }
        try {
          request = prepare(method, params);
        } on CanonicalFencesNeeded catch (still) {
          throw still.refusal;
        }
      }
    } on CanonicalWireRefusal catch (refusal) {
      // Nothing was sent: a definite refusal, in the reply shape every
      // caller already reads.
      return {'jsonrpc': '2.0', 'error': refusal.toError(strings)};
    }
    var reply = await wire(request.method, request.params, own: true);
    if (reply['error'] != null &&
        live() &&
        retryableFence(request, reply['error'])) {
      failed(request, reply['error']);
      try {
        request = prepare(method, params);
      } on Object {
        return reply;
      }
      reply = await wire(request.method, request.params, own: false);
    }
    if (!live()) return reply;
    final error = reply['error'];
    if (error != null) {
      failed(request, error);
      return reply;
    }
    final result = reply['result'];
    adoptGeneration(result);
    final adapted = adaptResult(request, result);
    return identical(adapted, result) ? reply : {...reply, 'result': adapted};
  }

  /// The owner's result for [request], in the shape the producer's own
  /// method answered with on a legacy gateway.
  Object? adaptResult(CanonicalRequest request, Object? value) {
    if (value is! Map) return value;
    final result = Map<String, dynamic>.from(value);
    final sessionId = result['session_id'];
    final revision = result['revision'];
    final profile = request.params['profile'];
    final mutation = request.operation != null;
    if (sessionId is String && revision is int) {
      final owner = _owner(sessionId, profile);
      // An exact-retry receipt replays its original revision.
      if (!mutation || revision >= (_revisions[owner] ?? -1)) {
        _revisions[owner] = revision;
      }
    }
    if (mutation) return _receipt(request, result);
    if (request.method == 'session.resume' ||
        request.method == 'session.create') {
      final prompts = _adoptSnapshotPrompts(result);
      if (prompts.isEmpty) return result;
      final open = result['open_requests'];
      return {
        ...result,
        'open_requests': [...(open is List ? open : const []), ...prompts],
      };
    }
    if (request.sourceMethod == 'clarify.lock' &&
        request.method == 'clarify.respond') {
      // The one question of a projected prompt is now answered.
      return {...result, 'status': 'ok', 'remaining': const <String>[]};
    }
    return result;
  }

  Map<String, dynamic> _receipt(
    CanonicalRequest request,
    Map<String, dynamic> value,
  ) {
    final wire = request.params;
    _forget(wire);
    _settleConfirmation(wire);
    final revision = value['revision'];
    if (revision is int) {
      _retireSuperseded(_owner(wire['session_id'], wire['profile']), revision);
    }
    if (request.operation == 'model' &&
        value['status'] == 'confirmation_required' &&
        value['confirm'] is String) {
      // Nothing was written: answer in the legacy handshake and keep the
      // owner's token for the confirmed resend.
      _modelConfirmations[_confirmationKey(
        _owner(wire['session_id'], wire['profile']),
        Map<String, dynamic>.from(wire['payload'] as Map),
      )] = (
        token: value['confirm'] as String,
        sent: false,
      );
      return {...value, 'confirm_required': true};
    }
    if (request.operation == 'branch') {
      return {
        ...value,
        'session_id': value['branched_session_id'],
        'stored_session_id': value['branched_session_id'],
        'parent_session_id': wire['session_id'],
        'message_count': value['copied_messages'],
      };
    }
    if (request.operation == 'model' && value['status'] == 'deferred') {
      return {...value, 'ok': true, 'deferred': true};
    }
    if (request.operation == 'reasoning') {
      return {...value, 'ok': true, 'value': value['effort']};
    }
    return {...value, 'ok': true};
  }
}
