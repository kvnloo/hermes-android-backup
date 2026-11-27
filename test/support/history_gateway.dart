import 'dart:convert';
import 'dart:io';

import 'package:hermes_android/core/models/connection.dart';

/// Loopback gateway for history, checkpoint and foreign-import calls.
class HistoryGateway {
  HistoryGateway._(this._server);

  final HttpServer _server;
  final methods = <String>[];
  final mutations = <Map<String, dynamic>>[];
  final exports = <Map<String, dynamic>>[];
  final restores = <Map<String, dynamic>>[];
  final foreignLists = <Map<String, dynamic>>[];
  final foreignPreviews = <Map<String, dynamic>>[];
  final imports = <Map<String, dynamic>>[];
  final sessionLists = <Map<String, String>>[];
  bool foreignSupported = true;
  static const session = 'stored-history';
  static const profile = 'field-work';
  static const cwd = '/srv/history';
  static const handle =
      'abababababababababababababababababababababababababababababababab';
  static const secondHandle =
      'cdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd';
  static const secret = 'sk-ant-api03-SECRETVALUE12';
  int revision = 4;
  final generation = 9;

  SavedConnection get connection => SavedConnection(
    id: 'history-fixture',
    label: 'History fixture',
    host: '127.0.0.1',
    port: _server.port,
    dashboardPortOverride: _server.port,
    desktopGatewayUrl: 'http://127.0.0.1:${_server.port}',
    gatewayProfile: profile,
    singleLogin: true,
    signInMethod: 'none',
    apiKey: '',
    dashboardProxied: true,
  );

  static Future<HistoryGateway> start() async {
    final gateway = HistoryGateway._(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    gateway._server.listen(gateway._handle);
    return gateway;
  }

  Future<void> close() async {
    await _server.close(force: true);
  }

  Future<void> _handle(HttpRequest req) async {
    final uri = req.uri;
    final res = req.response;
    Object? body;
    switch ((req.method, uri.path)) {
      case ('POST', '/api/auth/ws-ticket'):
        body = {'ticket': 'loopback-fixture'};
      case ('GET', '/api/ws'):
        final ws = await WebSocketTransformer.upgrade(
          req,
          protocolSelector: (_) => 'hermes-gateway-v1',
        );
        ws.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'method': 'event',
            'params': {
              'type': 'gateway.ready',
              'payload': {'session_authority': true},
            },
          }),
        );
        ws.listen((raw) {
          final frame = jsonDecode(raw as String) as Map<String, dynamic>;
          final method = frame['method'] as String?;
          if (method == null) return;
          methods.add(method);
          final params = frame['params'] is Map
              ? Map<String, dynamic>.from(frame['params'] as Map)
              : <String, dynamic>{};
          final result = _rpc(method, params);
          ws.add(
            jsonEncode({
              'jsonrpc': '2.0',
              'id': frame['id'],
              if (result != null)
                'result': result
              else
                'error': {'code': -32601, 'message': 'unsupported in fixture'},
            }),
          );
        });
        return;
      case ('GET', '/api/sessions/$session')
          when uri.queryParameters['profile'] == profile:
        body = {
          'id': session,
          'profile': profile,
          'cwd': cwd,
          'git_metadata_generation': 1,
        };
      case ('GET', '/api/sessions')
          when uri.queryParameters['profile'] == profile:
        // What Hermes Desktop reads lineage from (session-branch-tree.ts).
        sessionLists.add(Map<String, String>.from(uri.queryParameters));
        body = {
          'sessions': [
            {'id': 'parent', 'title': 'Parent chat', 'last_active': 1},
            {
              'id': session,
              'title': 'Current',
              '_branched_from': 'parent',
              'last_active': 3,
            },
            {
              'id': 'sibling',
              'title': 'Sibling',
              '_branched_from': 'parent',
              'last_active': 4,
            },
            {
              'id': 'reset-child',
              'title': 'Reset',
              'parent_session_id': session,
              '_reset_from': session,
              'last_active': 5,
            },
          ],
        };
      case ('GET', '/api/sessions/$session/mutation-snapshot'):
        body = {
          'session_id': session,
          'exists': true,
          'runtime_revision': revision,
          'runtime_generation': generation,
        };
      default:
        res.statusCode = HttpStatus.notFound;
    }
    res.headers.contentType = ContentType.json;
    res.write(jsonEncode(body));
    await res.close();
  }

  Map<String, dynamic>? _rpc(String method, Map<String, dynamic> params) {
    switch (method) {
      case 'session.resume':
        return {
          'session_id': 'live-history',
          'stored_session_id': session,
          'info': {
            'stored_session_id': session,
            'profile_name': profile,
            'cwd': cwd,
            'terminal_backend': 'local',
          },
        };
      case 'config.get':
        return {'config': {}};
      case 'session.history':
        return {
          'count': 2,
          'messages': [
            {'row_id': 7, 'role': 'user', 'text': 'Keep this'},
            {'row_id': 8, 'role': 'assistant', 'text': 'Noted'},
          ],
        };
      case 'session.list':
        // The canonical contract (gateway/session_controls.py list_sessions,
        // CanonicalSessionListRow): live sessions only, a closed row with no
        // lineage fields. Lineage is the REST session rows' (below).
        return {
          'sessions': [
            {
              'session_id': session,
              'id': session,
              'title': 'Current',
              'source': 'gui',
              'started_at': 1.0,
              'message_count': 2,
              'running': false,
            },
          ],
        };
      case 'session.mutate':
        mutations.add(params);
        revision += 1;
        final operation = params['operation'];
        return {
          'session_id': session,
          'operation': operation,
          'revision': revision,
          if (operation == 'branch') 'branched_session_id': 'child-1',
          if (operation == 'branch') 'title': 'Current',
          if (operation == 'rewind') 'removed': 2,
        };
      case 'rollback.list':
        return {
          'enabled': true,
          'checkpoints': [
            {
              'hash': 'abc1234',
              'timestamp': '2026-11-25T00:00:00Z',
              'message': 'before edit',
            },
          ],
        };
      case 'rollback.diff':
        return {'diff': 'token AKIAIOSFODNN7EXAMPLE\n'};
      case 'rollback.restore':
        restores.add(params);
        return {'success': true, 'history_removed': 1, 'restored_files': []};
      case 'session.export':
        exports.add(params);
        return {
          'format': params['format'],
          'filename': 'transcript.${params['format']}',
          'content': 'note ghp_ABCDEFGH12345678 end',
        };
      case 'session.foreign.list':
        if (!foreignSupported) return null;
        foreignLists.add(params);
        final offset = params['offset'] is int ? params['offset'] as int : 0;
        final source = params['source'] as String?;
        if (offset > 0) {
          return {
            'sessions': [
              if (source == null || source == 'codex')
                {
                  'id': secondHandle,
                  'source': 'codex',
                  'label': 'Codex',
                  'title': 'Audit migration',
                  'cwd': '/srv/codex',
                  'mtime': 1700000100.0,
                  'turn_count': 4,
                  'excerpt': 'Inspect schema $secret',
                },
            ],
            'host': 'fixture',
            'unreadable': 1,
            'next_offset': null,
          };
        }
        return {
          'sessions': [
            if (source == null || source == 'claude')
              {
                'id': handle,
                'source': 'claude',
                'label': 'Claude Code',
                'title': 'Plan the release',
                'cwd': '/srv/claude',
                'mtime': 1700000200.0,
                'turn_count': 2,
                'excerpt': 'Draft checklist',
              },
          ],
          'host': 'fixture',
          'unreadable': 0,
          'next_offset': source == null ? 25 : null,
        };
      case 'session.foreign.preview':
        if (!foreignSupported) return null;
        foreignPreviews.add(params);
        return {
          'messages': [
            {'role': 'user', 'content': 'token $secret'},
          ],
          'total': 1,
          'truncated': false,
          'already_imported': null,
          'cwd': '/srv/claude',
        };
      case 'session.foreign.import':
        if (!foreignSupported) return null;
        imports.add(params);
        return {'session_id': 'imported-host', 'already_imported': false};
      default:
        return null;
    }
  }
}
