// An in-memory Hermes gateway that speaks the b7ee21c14e wire contracts, so
// a test can put the REAL transport (WsClient) on top of it without a socket.
//
// With [FakeAuthorityGateway.authority] it is a 0.23+ session authority: the
// canonical dispatcher (`gateway/session_controls.py`) refuses an unknown or
// missing key of a declared contract with `4001 invalid_params` before any
// handler runs, and answers an unknown method `-32601`.
//
//  * `prompt.submit` is `CanonicalSubmitParams`
//    (tui_gateway/contracts/canonical_sessions.py:241-266, plus `profile`
//    from `ProfileParams`): no truncation key exists there.
//  * `session.mutate` is `SessionMutateParams` / `_FIELDS`
//    (gateway/session_mutations.py:23): `session_id`, `request_id`,
//    `expected_revision`, `operation`, `payload`, optional
//    `expected_generation` (required for rewind).
//  * There is no `session.rewind` handler: Desktop's `session.rewind` is a
//    client-side name that travels as `session.mutate` operation `rewind`.
//  * `session.list` is `CanonicalListParams` / `CanonicalSessionListRow`:
//    scope `live`, no lineage fields.
//
// Without it, it is the legacy sidecar (`hermes serve`): `PromptSubmitParams`
// (tui_gateway/contracts/prompt_voice.py:26-54) takes the truncation keys
// and cuts the transcript itself; `submission_id` is refused there.
import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// `CanonicalSubmitParams` (+ `ProfileParams.profile`): the closed key set.
const canonicalSubmitKeys = <String>{
  'profile',
  'session_id',
  'text',
  'submission_id',
  'input_id',
  'queued',
  'attachments',
  'finite',
  'unattended',
  'surface',
  'voice_context',
  'interrupted',
  'voice_turn',
  'display_kind',
  'title_preview',
  'turn_author',
  'api_text',
  'model_override',
  'clarify_batch',
};

/// The legacy sidecar's `PromptSubmitParams` (+ `SessionParams`).
const legacySubmitKeys = <String>{
  'profile',
  'session_id',
  'text',
  'display_kind',
  'interrupted',
  'queued',
  'surface',
  'voice_context',
  'voice_turn',
  'title_preview',
  'truncate_before_user_ordinal',
  'truncate_before_row_id',
  'truncate_before_message_id',
  'confirm_truncate',
  'confirm_empty_truncate',
  'confirm_deep_truncate',
  'rebind_survivor_row_ids',
};

/// `gateway/session_mutations.py` `_FIELDS` (+ optional generation).
const mutateRequiredKeys = <String>{
  'session_id',
  'request_id',
  'expected_revision',
  'operation',
  'payload',
};

/// `CanonicalListParams`.
const canonicalListKeys = <String>{
  'profile',
  'scope',
  'limit',
  'title',
  'include_hidden',
  'workspace',
  'picker',
  'query',
  'cursor',
};

typedef WireCall = ({String method, Map<String, dynamic> params});

class FakeAuthorityGateway {
  FakeAuthorityGateway({
    this.authority = true,
    this.sessionId = 'authority-session',
    this.profile = 'field-work',
    this.cwd = '/srv/authority',
    List<Map<String, dynamic>>? rows,
    this.reply = 'Fresh reply',
  }) : rows =
           rows ??
           [
             {'row_id': 7, 'role': 'user', 'text': 'Keep this'},
             {'row_id': 8, 'role': 'assistant', 'text': 'Noted'},
             {'row_id': 9, 'role': 'user', 'text': 'Another question'},
             {'row_id': 10, 'role': 'assistant', 'text': 'Another answer'},
           ];

  /// A 0.23+ session authority; false is the legacy sidecar.
  final bool authority;
  final String sessionId;
  final String profile;

  /// The session's working directory, as its snapshot reports it.
  final String cwd;

  /// The session's durable transcript, as `session.history` stamps it.
  final List<Map<String, dynamic>> rows;

  /// The assistant text a turn answers with; null leaves the turn running
  /// until [finishTurn].
  String? reply;

  int revision = 4;
  int generation = 2;
  bool running = false;
  int _nextRow = 100;
  int _sequence = 0;

  /// Every request frame, in arrival order, with the params as sent.
  final wire = <WireCall>[];

  /// The frames the gateway refused, with the error it answered.
  final refusals = <({String method, Map<String, dynamic> error})>[];

  /// A session with a different id that is live here too (a branch child).
  final extraHistories = <String, List<Map<String, dynamic>>>{};

  /// Answers for methods this fake has no handler for.
  Map<String, dynamic>? Function(String method, Map<String, dynamic> params)?
  onOther;

  final _channels = <_GatewayChannel>[];

  List<WireCall> calls(String method) => [
    for (final call in wire)
      if (call.method == method) call,
  ];

  List<String> get methods => [for (final call in wire) call.method];

  /// The wire without reads, so a sequence assertion names writes only.
  List<String> get writes => [
    for (final call in wire)
      if (!const {
        'session.history',
        'session.resume',
        'session.list',
        'client.capabilities',
        'config.get',
      }.contains(call.method))
        call.method,
  ];

  /// Dials an in-memory socket to this gateway ([WsClient.debugDial]).
  WebSocketChannel dial(Uri uri) {
    final channel = _GatewayChannel(this);
    _channels.add(channel);
    return channel;
  }

  /// Routes every [WsClient] dial to this gateway until the test ends.
  void install() {
    WsClient.debugDial = dial;
    addTearDown(() => WsClient.debugDial = null);
  }

  /// A connected transport on this gateway, attached to [sessionId] as a
  /// client is after `session.resume` (it knows the session's fences).
  Future<WsClient> connect({
    bool attach = true,
    String baseUrl = 'http://authority.invalid',
  }) async {
    install();
    final client = WsClient(
      baseUrl,
      profile: profile,
      heartbeatInterval: Duration.zero,
    );
    addTearDown(client.close);
    await client.connect();
    await client.waitForGatewayReady();
    if (attach) await client.resumeSession(sessionId);
    return client;
  }

  /// Pushes one event frame to every socket.
  void emit(String type, Map<String, dynamic> payload, {String? session}) {
    final frame = jsonEncode({
      'jsonrpc': '2.0',
      'method': 'event',
      'params': {
        'type': type,
        'session_id': session ?? sessionId,
        'payload': payload,
        if (authority) 'execution_generation': generation,
      },
    });
    for (final channel in List.of(_channels)) {
      channel.push(frame);
    }
  }

  /// Ends the running turn with [text].
  void finishTurn([String text = 'Fresh reply']) {
    if (!running) return;
    running = false;
    rows.add({'row_id': _nextRow++, 'role': 'assistant', 'text': text});
    emit('message.complete', {'text': text});
    if (authority) {
      revision += 1;
      // Turns advance the CAS revision without `session.updated`: the
      // `session.info` fanout is where a viewer learns it.
      emit('session.info', {'revision': revision, 'running': false});
    }
  }

  Map<String, dynamic> _error(int code, String message, [Object? data]) => {
    'error': {
      'code': code,
      'message': message,
      'data': data ?? {'reason': message},
    },
  };

  Map<String, dynamic> _invalid(List<String> fields) => _error(
    4001,
    'invalid_params',
    {'reason': 'invalid_params', 'fields': fields},
  );

  /// The dispatcher: a JSON-RPC answer (`result` or `error`) for one frame.
  Map<String, dynamic> _dispatch(String method, Map<String, dynamic> params) {
    wire.add((method: method, params: Map<String, dynamic>.from(params)));
    final answer = authority
        ? _canonical(method, params)
        : _legacy(method, params);
    final error = answer['error'];
    if (error is Map<String, dynamic>) {
      refusals.add((method: method, error: error));
    }
    return answer;
  }

  Map<String, dynamic> _history(Map<String, dynamic> params) {
    final id = params['session_id'];
    final list = id == sessionId ? rows : extraHistories[id];
    if (list == null) return _error(4001, 'not_found');
    return {
      'result': {
        'count': list.length,
        'messages': [for (final row in list) Map<String, dynamic>.from(row)],
      },
    };
  }

  Map<String, dynamic> _snapshot() => {
    'session_id': sessionId,
    'stored_session_id': sessionId,
    'messages': const <Object>[],
    'messages_omitted': true,
    'message_count': rows.length,
    'running': running,
    'authority_epoch': 1,
    'replay_epoch': 'fixture-epoch',
    'last_sequence': _sequence,
    'subscription_id': 'sub-1',
    'revision': revision,
    'execution_generation': generation,
    'pending': const <Object>[],
    'prompts': const <Object>[],
    'open_requests': const <Object>[],
    'info': {
      'desktop_protocol': 'hermes-gateway-v1',
      'stored_session_id': sessionId,
      'profile_name': profile,
      'cwd': cwd,
      'terminal_backend': 'local',
      'model': 'fixture',
    },
  };

  Map<String, dynamic> _canonical(String method, Map<String, dynamic> raw) {
    // The scope is implicit for the strict session verbs (`_PROFILE_IMPLICIT`).
    final params = Map<String, dynamic>.from(raw)..remove('profile');
    switch (method) {
      case 'client.capabilities':
        return {'result': <String, dynamic>{}};
      case 'session.resume':
        if (params['session_id'] != sessionId) {
          return _error(4001, 'not_found');
        }
        if (params.containsKey('inline_images')) {
          return _invalid(['inline_images']);
        }
        return {'result': _snapshot()};
      case 'session.history':
        return _history(params);
      case 'session.list':
        final extra = raw.keys.toSet().difference(canonicalListKeys);
        if (extra.isNotEmpty) return _invalid(extra.toList());
        // `CanonicalSessionListRow`: no lineage fields exist on this wire.
        return {
          'result': {
            'sessions': [
              {
                'session_id': sessionId,
                'id': sessionId,
                'title': 'Authority chat',
                'source': 'gui',
                'started_at': 1.0,
                'message_count': rows.length,
                'running': running,
              },
            ],
          },
        };
      case 'session.interrupt':
        final extra = params.keys.toSet().difference({
          'session_id',
          'execution_generation',
        });
        if (extra.isNotEmpty) return _invalid(extra.toList());
        if (params['execution_generation'] is! int) {
          return _invalid(['execution_generation']);
        }
        if (params['execution_generation'] != generation) {
          return _error(4001, 'stale_generation', {
            'reason': 'stale_generation',
            'revision': revision,
            'execution_generation': generation,
          });
        }
        if (running) {
          running = false;
          revision += 1;
          emit('message.complete', {'text': '', 'status': 'interrupted'});
          emit('session.info', {'revision': revision, 'running': false});
        }
        return {
          'result': {'status': 'interrupted'},
        };
      case 'session.mutate':
        return _mutate(params);
      case 'prompt.submit':
        final extra = raw.keys.toSet().difference(canonicalSubmitKeys);
        final missing = [
          for (final key in const ['session_id', 'text'])
            if (!raw.containsKey(key)) key,
        ];
        if (extra.isNotEmpty || missing.isNotEmpty) {
          return _invalid([...extra, ...missing]);
        }
        if (params['session_id'] != sessionId) {
          return _error(4001, 'not_found');
        }
        return {'result': _admit(params['text'].toString())};
    }
    final other = onOther?.call(method, raw);
    if (other != null) return other;
    // JSON-RPC's own verdict for a method with no handler: `session.rewind`
    // is one of them (it is Desktop's name for the mutation, not a method).
    return _error(-32601, 'Method not found: $method', {
      'reason': 'unknown_method',
    });
  }

  Map<String, dynamic> _mutate(Map<String, dynamic> params) {
    final keys = params.keys.toSet()..remove('expected_generation');
    if (keys.length != mutateRequiredKeys.length ||
        !keys.containsAll(mutateRequiredKeys)) {
      return _invalid([
        ...keys.difference(mutateRequiredKeys),
        ...mutateRequiredKeys.difference(keys),
      ]);
    }
    if (params['session_id'] != sessionId) return _error(4001, 'not_found');
    final operation = params['operation'];
    final payload = params['payload'];
    if (operation is! String ||
        payload is! Map ||
        params['request_id'] is! String ||
        params['expected_revision'] is! int) {
      return _invalid(['operation']);
    }
    Map<String, dynamic> fence(String reason) => _error(4001, reason, {
      'reason': reason,
      'revision': revision,
      'execution_generation': generation,
    });
    if (params['expected_revision'] != revision) {
      return fence('revision_conflict');
    }
    if (operation == 'rewind' || operation == 'branch') {
      final expected = params['expected_generation'];
      if (expected is! int) return _invalid(['expected_generation']);
      if (expected != generation) return fence('stale_generation');
    }
    if (operation == 'rewind') {
      if (running) return _error(4001, 'session_busy');
      final target = payload['target_message_id'];
      final index = rows.indexWhere(
        (row) => row['row_id'] == target && row['role'] == 'user',
      );
      if (target is! int || index < 0) return _error(4001, 'not_found');
      final removed = rows.length - index;
      rows.removeRange(index, rows.length);
      revision += 1;
      final receipt = {
        'session_id': sessionId,
        'operation': 'rewind',
        'revision': revision,
        'removed': removed,
        'rewound_count': removed,
      };
      emit('session.updated', receipt);
      return {'result': receipt};
    }
    if (operation == 'branch') {
      revision += 1;
      return {
        'result': {
          'session_id': sessionId,
          'operation': 'branch',
          'revision': revision,
          'branched_session_id': 'branch-child',
          'title': 'Authority chat',
        },
      };
    }
    return _error(4001, 'invalid_params');
  }

  Map<String, dynamic> _admit(String text) {
    rows.add({'row_id': _nextRow++, 'role': 'user', 'text': text});
    running = true;
    generation += 1;
    final receipt = {
      'admission_id': 'admission-${++_sequence}',
      'ref': {'profile_id': profile, 'session_id': sessionId},
      'sequence': _sequence,
      'status': 'started',
      'outcome': null,
      'authority_epoch': 1,
      'execution_generation': generation,
    };
    final answer = reply;
    scheduleMicrotask(() {
      emit('message.start', const {});
      if (answer != null) finishTurn(answer);
    });
    return receipt;
  }

  Map<String, dynamic> _legacy(String method, Map<String, dynamic> params) {
    switch (method) {
      case 'client.capabilities':
        return _error(-32601, 'Method not found: $method');
      case 'session.resume':
        return {
          'result': {
            'session_id': sessionId,
            'stored_session_id': sessionId,
            'running': running,
            'info': {'stored_session_id': sessionId, 'profile_name': profile},
          },
        };
      case 'session.history':
        return _history(params);
      case 'session.interrupt':
        if (params.containsKey('execution_generation')) {
          return _error(
            4000,
            'invalid params for session.interrupt: '
            'execution_generation: Extra inputs are not permitted',
          );
        }
        if (running) {
          running = false;
          emit('message.complete', {'text': '', 'status': 'interrupted'});
        }
        return {
          'result': {'status': 'interrupted'},
        };
      case 'prompt.submit':
        for (final key in params.keys) {
          if (!legacySubmitKeys.contains(key)) {
            // The pre-0.23 refusal: the field path, 4000.
            return _error(
              4000,
              'invalid params for prompt.submit: $key: Extra inputs are not '
              'permitted',
            );
          }
        }
        if (params['confirm_truncate'] == true) {
          final target = params['truncate_before_row_id'];
          final index = rows.indexWhere((row) => row['row_id'] == target);
          if (index >= 0) rows.removeRange(index, rows.length);
        }
        rows.add({
          'row_id': _nextRow++,
          'role': 'user',
          'text': params['text'].toString(),
        });
        running = true;
        final answer = reply;
        scheduleMicrotask(() {
          emit('message.start', const {});
          if (answer != null) finishTurn(answer);
        });
        return {
          'result': {'status': 'streaming'},
        };
    }
    final other = onOther?.call(method, params);
    if (other != null) return other;
    return _error(-32601, 'Method not found: $method');
  }
}

/// One in-memory socket: frames the client writes are dispatched, answers
/// and events come back on [stream], all on microtasks (no timers, so a
/// widget test's fake clock never has to move for the wire).
class _GatewayChannel extends Fake implements WebSocketChannel {
  _GatewayChannel(this._gateway) {
    scheduleMicrotask(() {
      push(
        jsonEncode({
          'jsonrpc': '2.0',
          'method': 'event',
          'params': {
            'type': 'gateway.ready',
            'payload': {
              'change_events': true,
              'heartbeat': true,
              'replay_epoch': 'fixture-epoch',
              if (_gateway.authority) 'session_authority': true,
            },
          },
        }),
      );
    });
  }

  final FakeAuthorityGateway _gateway;
  final _inbound = StreamController<dynamic>();
  late final _GatewaySink _sink = _GatewaySink(this);
  bool _closed = false;

  void push(String frame) {
    if (!_closed) _inbound.add(frame);
  }

  void _receive(Object? raw) {
    if (_closed || raw is! String) return;
    final frame = jsonDecode(raw) as Map<String, dynamic>;
    final method = frame['method'];
    final id = frame['id'];
    if (method is! String || id == null) return;
    if (method == 'gateway.ping') {
      push(jsonEncode({'jsonrpc': '2.0', 'id': id, 'result': const {}}));
      return;
    }
    final params = frame['params'] is Map
        ? Map<String, dynamic>.from(frame['params'] as Map)
        : <String, dynamic>{};
    final answer = _gateway._dispatch(method, params);
    scheduleMicrotask(
      () => push(jsonEncode({'jsonrpc': '2.0', 'id': id, ...answer})),
    );
  }

  void _close() {
    if (_closed) return;
    _closed = true;
    _gateway._channels.remove(this);
    unawaited(_inbound.close());
  }

  @override
  Future<void> get ready => Future<void>.value();

  @override
  Stream<dynamic> get stream => _inbound.stream;

  @override
  WebSocketSink get sink => _sink;

  @override
  String? get protocol => WsClient.gatewayProtocol;

  @override
  int? get closeCode => _closed ? 1000 : null;

  @override
  String? get closeReason => null;
}

class _GatewaySink extends Fake implements WebSocketSink {
  _GatewaySink(this._channel);

  final _GatewayChannel _channel;
  final _done = Completer<void>();

  @override
  void add(Object? event) => _channel._receive(event);

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<dynamic> stream) => stream.forEach(add);

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    _channel._close();
    if (!_done.isCompleted) _done.complete();
  }

  @override
  Future<void> get done => _done.future;
}
