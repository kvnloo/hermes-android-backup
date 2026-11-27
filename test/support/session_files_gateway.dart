import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:hermes_android/core/models/connection.dart';

import 'markdown_file_fixture.dart';
import 'strict_authority_gateway.dart';

/// A stored chat and its host filesystem, served only on an ephemeral loopback
/// port. No widget, workspace owner, gateway client or chat route is faked.
class SessionFilesGateway {
  SessionFilesGateway._(this._server);
  final HttpServer _server;
  final _sockets = <WebSocket>[];
  final methods = <String>[];
  final requests = <(String, Uri)>[];
  final replacements = <Map<String, dynamic>>[];
  final mutations = <Map<String, dynamic>>[];
  final reads = <String>[];
  static const session = 'stored-field-chat';
  static const profile = 'field-work';
  static const root = '/srv/field-work';
  static const folder = '$root/docs';
  static const name = 'notes.MD';
  static const path = '$folder/$name';
  static const leaf = 'field.md';
  static const leafPath = '$root/$leaf';
  static const spaced = 'my notes.txt';
  static const spacedPath = '$root/$spaced';
  static const hidden = '.secret';
  static const hiddenPath = '$root/$hidden';
  static const database = 'cache.db';
  static const databasePath = '$root/$database';
  static const transcript = 'Check the field notes';
  static const audioName = 'clip.wav';
  static const audioPath = '$root/$audioName';
  bool audioFiles = false;
  String runtime = 'live-field-chat';
  Future<void> Function()? rebindClient;
  final audioEntered = Completer<void>();
  Completer<void>? audioGate;
  String text = markdownFixture;
  String sibling = 'before.txt';
  // Simulates another writer AFTER the client's preflight GET, before the CAS.
  String? competingWrite;
  String cwd = root;
  int revision = 4;
  int generation = 9;
  String terminalBackend = 'local';
  bool stock = false;
  bool forbidSave = false;

  SavedConnection get connection => SavedConnection(
    id: 'files-fixture',
    label: 'Files fixture',
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

  static Future<SessionFilesGateway> start() async {
    final f = SessionFilesGateway._(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    f._server.listen(f._handle);
    return f;
  }

  static String hash(String text) =>
      sha256.convert(utf8.encode(text)).toString();
  Map<String, Object> _entry(
    String parent,
    String name, {
    bool directory = false,
  }) => {'name': name, 'path': '$parent/$name', 'isDirectory': directory};

  List<Map<String, Object>> _rootEntries() => [
    _entry(root, 'docs', directory: true),
    _entry(root, leaf),
    _entry(root, spaced),
    _entry(root, hidden),
    _entry(root, database),
    if (audioFiles) _entry(root, audioName),
  ];

  String? _preview(String? filePath) {
    if (filePath == SessionFilesGateway.path || filePath == leafPath) {
      return text;
    }
    if (filePath == spacedPath) return 'spaced notes\n';
    if (filePath == hiddenPath) return 'hidden\n';
    if (filePath == databasePath) return 'db\n';
    if (audioFiles && filePath == audioPath) return '';
    return null;
  }

  bool _eligibleSave(Map<String, dynamic> data) {
    final cwd = data['cwd'];
    final path = data['path'];
    if (cwd is! String || path is! String || !path.startsWith('$cwd/')) {
      return false;
    }
    final rel = path.substring(cwd.length + 1);
    if (rel.isEmpty || rel.contains('/') || rel.startsWith('.')) return false;
    final folded = rel.toLowerCase();
    const refused = ['.db', '.sqlite', '.sqlite3', '-journal', '-wal', '-shm'];
    return !refused.any(folded.endsWith);
  }

  Future<void> _handle(HttpRequest req) async {
    final uri = req.uri;
    requests.add((req.method, uri));
    final q = uri.queryParameters;
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
        _sockets.add(ws);
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
          final frame = jsonDecode(raw as String) as Map;
          final method = frame['method'] as String?;
          if (method == null) return;
          methods.add(method);
          final refused = strictAuthorityFrame(frame);
          if (refused != null) {
            ws.add(refused);
            return;
          }
          final result = switch (method) {
            'session.resume' when frame['params']['session_id'] == session => {
              'session_id': runtime,
              'stored_session_id': session,
              'info': {
                'profile_name': profile,
                // Resume keeps the directory it first reported. A later
                // session.mutate must not be ignored just because this frame
                // is stale.
                'cwd': root,
                'terminal_backend': terminalBackend,
              },
              'running': false,
            },
            'config.get' => {'config': {}},
            'session.mutate' => () {
              final params = Map<String, dynamic>.from(frame['params'] as Map);
              mutations.add(params);
              final payload = params['payload'];
              if (payload is Map && payload['cwd'] is String) {
                cwd = payload['cwd'] as String;
                revision++;
              }
              return {
                'session_id': session,
                'operation': 'workspace',
                'revision': revision,
              };
            }(),
            _ => null,
          };
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
      case ('GET', '/api/sessions/$session/messages'):
        body = {
          'session_id': session,
          'messages': [
            {'id': 1, 'role': 'user', 'content': transcript, 'timestamp': 1},
          ],
        };
      case ('GET', '/api/sessions/$session/mutation-snapshot'):
        body = {
          'session_id': session,
          'exists': true,
          'runtime_revision': revision,
          'runtime_generation': generation,
        };
      case ('GET', '/api/sessions/$session') when q['profile'] == profile:
        body = {
          'id': session,
          'profile': profile,
          'cwd': cwd,
          'git_metadata_generation': 1,
        };
      case ('GET', '/api/tools/terminal/backends') when q['profile'] == profile:
        body = {'active': terminalBackend, 'backends': []};
      case ('GET', '/api/fs/git-root') when q['profile'] == profile:
        body = {'root': null};
      case ('GET', '/api/fs/default-cwd') when q['profile'] == profile:
        body = {'cwd': root};
      case ('GET', '/api/fs/list')
          when q['profile'] == profile &&
              q['git_flags'] == 'true' &&
              (q['path'] == root || q['path'] == folder || q['path'] == cwd):
        body = {
          'entries': q['path'] == root
              ? _rootEntries()
              : q['path'] == folder
              ? [_entry(folder, name), _entry(folder, sibling)]
              : [_entry(cwd, name)],
        };
      case ('GET', '/api/fs/list')
          when q['profile'] == profile && q['path'] == root:
        body = {'entries': _rootEntries()};
      case ('GET', '/api/fs/read-text')
          when q['profile'] == profile &&
              q['session_id'] == session &&
              _preview(q['path']) != null:
        final preview = _preview(q['path'])!;
        reads.add(preview);
        body = {
          'path': q['path'],
          'text': preview,
          'byteSize': utf8.encode(preview).length,
          'truncated': false,
          'binary': q['path'] == audioPath,
        };
      case ('GET', '/api/fs/download')
          when audioFiles &&
              q['profile'] == profile &&
              q['session_id'] == session &&
              q['path'] == audioPath:
        if (!audioEntered.isCompleted) audioEntered.complete();
        await audioGate?.future;
        res.headers.contentType = ContentType('audio', 'wav');
        res.add([
          1,
          2,
          3,
        ]); // Player adapter is mocked; native probe uses valid WAV.
        await res.close();
        return;
      case ('POST', '/api/fs/replace-text-v1') when q['profile'] == profile:
        final data =
            jsonDecode(await utf8.decoder.bind(req).join())
                as Map<String, dynamic>;
        if (stock) {
          res.statusCode = 404;
          break;
        }
        if (data['content'] is! String) {
          res.statusCode = 400;
          break;
        }
        replacements.add(data);
        if (forbidSave || !_eligibleSave(data)) {
          res.statusCode = 403;
          body = {
            'detail': 'File or workspace is not eligible for confirmed editing',
          };
          break;
        }
        if (data['cwd'] != cwd ||
            data['session_id'] != session ||
            _preview(data['path'] as String?) == null) {
          res.statusCode = 400;
          break;
        }
        if (data['path'] == path || data['path'] == leafPath) {
          text = competingWrite ?? text;
          competingWrite = null;
          if (data['expected_sha256'] != hash(text)) {
            res.statusCode = HttpStatus.conflict;
          } else {
            text = data['content'] as String;
            body = {'ok': true, 'path': data['path'], 'sha256': hash(text)};
          }
        } else {
          final current = _preview(data['path'] as String)!;
          if (data['expected_sha256'] != hash(current)) {
            res.statusCode = HttpStatus.conflict;
          } else {
            body = {
              'ok': true,
              'path': data['path'],
              'sha256': hash(data['content'] as String),
            };
          }
        }
      default:
        res.statusCode = HttpStatus.notFound;
    }
    res.headers.contentType = ContentType.json;
    res.write(jsonEncode(body));
    await res.close();
  }

  Future<void> close() async {
    for (final ws in _sockets) {
      await ws.close();
    }
    await _server.close(force: true);
  }
}
