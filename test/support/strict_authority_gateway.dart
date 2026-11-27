// The one strict stand-in for a session-authority (Hermes 0.23+) gateway.
//
// A fake that answers every frame hides the requests the real gateway
// refuses: its params models are closed (`extra="forbid"`) and its handlers
// check their key sets by hand. [strictAuthorityRefusal] gives the same
// verdict the pinned gateway gives, from the table
// `tool/canonical_wire_check.py --emit-dart` generates out of the gateway's
// own contracts, so an authority-mode test fails where production would.
//
// Use it in three ways:
// * `StrictAuthorityGateway` (strict_authority_server.dart): a loopback
//   gateway for tests that drive the real clients end to end.
// * [strictAuthorityRefusal] / [strictAuthorityReply]: inside an existing
//   fake socket's request handler, before it answers.
// * [strictAuthorityCheck]: inside a fake that overrides
//   `NextGenGateway.call` (strict_nextgen_gateway.dart wraps it with the
//   client's own guard).
import 'dart:convert';
import 'dart:io';

import 'package:hermes_android/core/services/ws_client.dart';

import 'canonical_wire_contracts.g.dart';

export 'canonical_wire_contracts.g.dart' show canonicalWirePin;

/// The JSON-RPC `error` object the pinned gateway answers [method] with on a
/// session-authority socket, or null when it accepts the request's shape.
///
/// Mirrors `gateway/session_controls.py::AuthorityConnection.dispatch` and
/// `tui_gateway/ws.py::_dispatch_request`: `4001 invalid_params` from the
/// authority (naming the fields for a canonical contract), `-32601` for a
/// method it does not serve, `4000` from the legacy sidecar it falls back to.
Map<String, dynamic>? strictAuthorityRefusal(String method, Object? rawParams) {
  if (method == 'gateway.ping') return null; // answered by the read loop
  if (rawParams is! Map) return _invalidParams();
  final params = <String, dynamic>{
    for (final entry in rawParams.entries) entry.key.toString(): entry.value,
  };
  final contract = canonicalWireContracts[method];
  if (contract == null) return _unknownMethod(method);
  final profile = params['profile'];
  if (profile is String && profile.isNotEmpty && contract.profileImplicit) {
    params.remove('profile');
  }
  if (contract.canonical) {
    final fields = <String>[
      for (final key in params.keys)
        if (!contract.types.containsKey(key)) key,
      if (!contract.shared)
        for (final key in contract.required)
          if (!params.containsKey(key)) key,
      if (contract.shared)
        for (final entry in params.entries)
          if (!_typed(contract.types[entry.key], entry.value)) entry.key,
    ];
    if (fields.isNotEmpty) return _invalidParams(fields: fields);
  }
  var route = contract.route;
  if (contract.sessionOwnedOnly) {
    final owner = params['owner'];
    if (owner is! Map || owner['type'] != 'session') route = WireRoute.legacy;
  }
  switch (route) {
    case WireRoute.unknown:
      return _unknownMethod(method);
    case WireRoute.legacy:
      final keys = contract.legacyKeys ?? contract.keys;
      for (final key in params.keys) {
        if (!keys.contains(key)) {
          return {
            'code': 4000,
            'message':
                'invalid params for $method: $key: Extra inputs are not '
                'permitted',
          };
        }
      }
      return null;
    case WireRoute.authority:
    case WireRoute.group:
      break;
  }
  if (contract.exact
      ? !(params.length == contract.keys.length &&
            params.keys.every(contract.keys.contains))
      : params.keys.any((key) => !contract.keys.contains(key))) {
    return _invalidParams();
  }
  for (final key in contract.required) {
    final value = params[key];
    if (value == null || value == '') return _invalidParams();
  }
  for (final entry in params.entries) {
    if (contract.strings && entry.value is! String) return _invalidParams();
    if (!_typed(contract.types[entry.key], entry.value)) {
      return _invalidParams();
    }
  }
  return switch (method) {
    'config.set' => _configSet(params),
    'session.mutate' => _mutate(params),
    'prompt.submit' =>
      _nonEmpty(params['submission_id']) || _nonEmpty(params['input_id'])
          ? null
          : _invalidParams(),
    'session.control' => _control(params),
    _ => null,
  };
}

/// The whole reply frame for a refused request, or null when it is accepted.
Map<String, dynamic>? strictAuthorityReply(
  Object? id,
  String method,
  Object? params,
) {
  final error = strictAuthorityRefusal(method, params);
  strictAuthorityTap(method, params, error);
  return error == null ? null : {'jsonrpc': '2.0', 'id': id, 'error': error};
}

/// With `ARES_WIRE_TAP_FILE` set, every frame an existing suite's authority
/// fake receives is appended there (one JSON object per line) with this
/// fake's verdict, so `tool/canonical_wire_check.py` can validate what the
/// suite's real producers sent, and check this fake against the gateway.
void strictAuthorityTap(
  String method,
  Object? params,
  Map<String, dynamic>? refusal,
) {
  final path = Platform.environment['ARES_WIRE_TAP_FILE'];
  if (path == null || path.isEmpty || method == 'gateway.ping') return;
  File(path)
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(
      '${jsonEncode({'socket': 'authority', 'method': method, 'params': params, 'strict_fake': refusal == null ? 'accepted' : 'refused'})}\n',
      mode: FileMode.append,
    );
}

/// For a fake socket's frame handler: the encoded reply to write back when
/// the pinned gateway refuses [frame], or null when [frame] is not a request
/// (a response to a server request) or the gateway accepts its shape.
String? strictAuthorityFrame(Object? frame) {
  if (frame is! Map || frame['method'] is! String) return null;
  final reply = strictAuthorityReply(
    frame['id'],
    frame['method'] as String,
    frame['params'] ?? const <String, dynamic>{},
  );
  return reply == null ? null : jsonEncode(reply);
}

/// For a fake that overrides `NextGenGateway.call`: throws the error the
/// gateway would answer, exactly as the real `call` surfaces it.
void strictAuthorityCheck(String method, Map<String, dynamic> params) {
  final error = strictAuthorityRefusal(method, params);
  strictAuthorityTap(method, params, error);
  if (error == null) return;
  throw JsonRpcError.fromGateway(
    method,
    error,
    fallbackMessage: 'The gateway refused $method.',
  );
}

bool _nonEmpty(Object? value) => value is String && value.isNotEmpty;

Map<String, dynamic> _invalidParams({List<String>? fields, String? reason}) => {
  'code': 4001,
  'message': reason ?? 'invalid_params',
  'data': {'reason': reason ?? 'invalid_params', 'fields': ?fields},
};

Map<String, dynamic> _unknownMethod(String method) => {
  'code': -32601,
  'message': 'unknown method: $method — not available on this Hermes backend',
  'data': {'reason': 'unknown_method'},
};

bool _typed(String? tag, Object? value) {
  if (tag == null) return true;
  final nullable = tag.endsWith('?');
  final base = nullable ? tag.substring(0, tag.length - 1) : tag;
  if (value == null) return nullable || base == 'any';
  if (base.startsWith('enum:')) {
    return base.substring(5).split('|').contains(value);
  }
  return switch (base) {
    'str' => value is String,
    'int' => value is int,
    'num' => value is num,
    'bool' => value is bool,
    'list' => value is List,
    'map' => value is Map,
    _ => true,
  };
}

// gateway/session_tui_config.py::config_set and
// gateway/session_busy_controls.py::busy_config.
Map<String, dynamic>? _configSet(Map<String, dynamic> params) {
  final key = params['key'];
  if (key == 'model') {
    return _invalidParams(reason: 'use_session_mutation_model');
  }
  if (key == 'reasoning' || (key == 'yolo' && params.containsKey('scope'))) {
    final scope = params['scope'] ?? 'session';
    if (!_nonEmpty(params['session_id']) ||
        (scope != 'session' && scope != 'global') ||
        (key == 'yolo' && scope != 'global') ||
        (key == 'reasoning' &&
            (params['value']?.toString().trim() ?? '').isEmpty)) {
      return _invalidParams();
    }
    return null;
  }
  if (params.containsKey('scope')) return _invalidParams();
  if (configSetSessionKeys.contains(key)) {
    if (!_nonEmpty(params['session_id'])) return _invalidParams();
    if (key == 'busy' &&
        !const {'interrupt', 'steer', 'queue'}.contains(params['value'])) {
      return _invalidParams();
    }
    return null;
  }
  return configSetProfileKeys.contains(key) ? null : _invalidParams();
}

// gateway/session_mutations.py::_mutate_session,
// persistence/authority/runtime.py::parse_mutation and the generation fence in
// persistence/sqlite/authority/_mutation.py.
Map<String, dynamic>? _mutate(Map<String, dynamic> params) {
  final operation = params['operation'];
  final payload = params['payload'];
  if (operation is! String || payload is! Map) return _invalidParams();
  if (mutationPolicyOperations.contains(operation) &&
      params['expected_generation'] == null) {
    return _invalidParams();
  }
  bool only(Set<String> keys) => payload.keys.every(keys.contains);
  bool text(Object? value) => value is String && value.trim().isNotEmpty;
  final valid = switch (operation) {
    'rename' => payload.length == 1 && payload['title'] is String,
    'archive' => payload.length == 1 && payload['archived'] is bool,
    'model' =>
      payload.containsKey('model') &&
          only(const {'model', 'provider', 'confirm', 'reasoning'}) &&
          payload.values.every(text),
    'reasoning' =>
      payload.length == 1 &&
          payload.containsKey('effort') &&
          (payload['effort'] == null || text(payload['effort'])),
    'workspace' => payload.length == 1 && text(payload['cwd']),
    'branch' =>
      only(const {'title', 'through_message_id', 'mcp_servers'}) &&
          (!payload.containsKey('title') || payload['title'] is String) &&
          (!payload.containsKey('through_message_id') ||
              (payload['through_message_id'] is int &&
                  (payload['through_message_id'] as int) > 0)),
    'compress' =>
      only(const {'focus', 'preview', 'partial', 'keep_last'}) &&
          (!payload.containsKey('focus') || payload['focus'] is String) &&
          (!payload.containsKey('preview') || payload['preview'] is bool) &&
          (!payload.containsKey('partial') || payload['partial'] is bool) &&
          (!payload.containsKey('keep_last') ||
              (payload['keep_last'] is int && payload['partial'] == true)),
    'rewind' =>
      only(const {'target_message_id', 'preserve_compaction_handoff'}) &&
          payload['target_message_id'] is int &&
          (payload['target_message_id'] as int) > 0,
    'delete' || 'reset' => payload.isEmpty,
    'sidebar' => payload.isNotEmpty,
    'import' => payload.length == 1 && payload['sessions'] is List,
    'editor_mcp' || 'edit_policy' => payload.length == 1,
    _ => false,
  };
  return valid ? null : _invalidParams();
}

// gateway/session_control_actions.py::_validate.
Map<String, dynamic>? _control(Map<String, dynamic> params) {
  final action = params['action'];
  final args = params['args'] ?? const <String, dynamic>{};
  if (action is! String ||
      !sessionControlActions.contains(action.trim()) ||
      args is! Map ||
      args.keys.any((key) => key != 'text' && key != 'index')) {
    return _invalidParams();
  }
  final index = args['index'];
  final text = args['text'];
  if (action.trim() == 'subgoal.remove' && (index is! int || index < 1)) {
    return _invalidParams();
  }
  if (action.trim() == 'subgoal.add' &&
      (text is! String || text.trim().isEmpty)) {
    return _invalidParams();
  }
  return null;
}
