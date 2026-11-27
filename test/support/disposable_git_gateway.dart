import 'dart:convert';
import 'dart:io';

import 'package:hermes_android/core/models/connection.dart';

import 'strict_authority_gateway.dart';

/// Loopback gateway whose Git routes run real `git` in one disposable
/// repository. The route name chooses the argv; request bodies are not a
/// command line, and `gh` is never started.
class DisposableGitGateway {
  DisposableGitGateway._(this.server, this.root, this._emptyConfig);

  final HttpServer server;
  final Directory root;
  final File _emptyConfig;
  late String cwd = root.path;
  var revision = 1;
  var generation = 3;
  final executables = <String>[];
  final posts = <Map<String, Object?>>[];
  final extraReviewRows = <Map<String, Object?>>[];
  final _sockets = <WebSocket>[];
  final _tickets = <String>{};
  var _sequence = 0;
  var ghReady = false;
  String? pullRequestUrl;
  var dropResume = false;
  final _sha = RegExp(r'^[0-9a-f]{7,64}$');

  SavedConnection get connection => SavedConnection(
    id: 'fixture',
    label: 'fixture',
    host: '127.0.0.1',
    port: server.port,
    apiKey: 'never-an-api-key',
    dashboardUsername: 'fixture',
    dashboardPassword: 'secret-fixture',
    gatewayProfile: 'work',
    dashboardPortOverride: server.port,
    dashboardPrefix: '/prefix',
    desktopGatewayUrl: 'http://127.0.0.1:${server.port}/prefix',
  );

  static Future<DisposableGitGateway> start(Directory root) async {
    final config = File('${root.parent.path}/empty-gitconfig');
    await config.create(recursive: true);
    final gateway = DisposableGitGateway._(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
      root,
      config,
    );
    gateway.server.listen(gateway._handle);
    return gateway;
  }

  Future<void> close() async {
    for (final socket in _sockets) {
      await socket.close();
    }
    await server.close(force: true);
  }

  Future<void> _handle(HttpRequest request) async {
    final response = request.response;
    final path = request.uri.path;
    try {
      if (path == '/prefix/auth/password-login' && request.method == 'POST') {
        final body = jsonDecode(await utf8.decoder.bind(request).join()) as Map;
        if (body['password'] == 'secret-fixture') {
          response.cookies.add(Cookie('hermes_session_at', 'secret-cookie'));
          await _json(response, {'ok': true});
        } else {
          response.statusCode = 401;
          await response.close();
        }
        return;
      }
      if (path == '/prefix/api/ws' &&
          !request.uri.hasQuery &&
          request.headers
                  .value('sec-websocket-protocol')
                  ?.split(',')
                  .any((item) => _tickets.remove(item.trim())) ==
              true) {
        final socket = await WebSocketTransformer.upgrade(
          request,
          protocolSelector: (_) => 'hermes-gateway-v1',
        );
        _sockets.add(socket);
        socket.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'method': 'event',
            'params': {
              'type': 'gateway.ready',
              'payload': {'replay_epoch': 'fixture', 'session_authority': true},
            },
          }),
        );
        socket.listen((raw) async {
          final frame = jsonDecode(raw as String) as Map<String, dynamic>;
          final method = frame['method'];
          final params = frame['params'];
          final refused = strictAuthorityFrame(frame);
          if (refused != null) {
            socket.add(refused);
            return;
          }
          Object? result = <String, Object?>{};
          if (method == 'session.resume' && params is Map) {
            if (dropResume) {
              dropResume = false;
              await socket.close();
              return;
            }
            result = {
              'session_id': 'runtime',
              'stored_session_id': 'stored',
              'info': {
                'profile_name': 'work',
                'stored_session_id': 'stored',
                'cwd': cwd,
                'terminal_backend': 'local',
              },
            };
          } else if (method == 'session.mutate' && params is Map) {
            result = _mutate(params);
          }
          socket.add(
            jsonEncode({'jsonrpc': '2.0', 'id': frame['id'], 'result': result}),
          );
        });
        return;
      }
      if (request.headers.value('cookie') !=
              'hermes_session_at=secret-cookie' ||
          request.headers.value('authorization') != null) {
        response.statusCode = 401;
        await response.close();
        return;
      }
      if (path == '/prefix/api/auth/ws-ticket' && request.method == 'POST') {
        final ticket = 'secret-ticket-${++_sequence}';
        _tickets.add('hermes-gateway-ticket.$ticket');
        await _json(response, {'ticket': ticket});
        return;
      }
      if (request.uri.queryParameters['profile'] != 'work') {
        response.statusCode = 400;
        await response.close();
        return;
      }
      if (request.method == 'GET') {
        await _json(response, await _get(path, request.uri.queryParameters));
        return;
      }
      if (request.method == 'POST') {
        final decoded =
            jsonDecode(await utf8.decoder.bind(request).join()) as Map;
        final body = decoded.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        posts.add({'path': path, 'body': body});
        await _json(response, await _post(path, body));
        return;
      }
      response.statusCode = 405;
      await response.close();
    } on _GitReject {
      response.statusCode = 400;
      await _json(response, {'ok': false});
    } catch (error, stack) {
      stderr.writeln('git gateway $path failed: $error\n$stack');
      try {
        response.statusCode = 500;
        await response.close();
      } catch (_) {}
    }
  }

  Map<String, Object?> _mutate(Map params) {
    final payload = params['payload'];
    final requested = payload is Map ? payload['cwd'] : null;
    final allowed = _allowedDirectories();
    if (params['session_id'] != 'stored' ||
        params['operation'] != 'workspace' ||
        params['expected_revision'] != revision ||
        params['expected_generation'] != generation ||
        requested is! String ||
        !allowed.contains(requested)) {
      return {
        'session_id': 'stored',
        'operation': 'workspace',
        'revision': revision,
      };
    }
    cwd = requested;
    revision += 1;
    return {
      'session_id': 'stored',
      'operation': 'workspace',
      'revision': revision,
    };
  }

  Set<String> _allowedDirectories() {
    final allowed = {root.path};
    final listed = Process.runSync('git', [
      'worktree',
      'list',
      '--porcelain',
    ], workingDirectory: root.path);
    executables.add('git');
    for (final line in (listed.stdout as String).split('\n')) {
      if (line.startsWith('worktree ')) allowed.add(line.substring(9).trim());
    }
    return allowed;
  }

  Future<Object?> _get(String path, Map<String, String> query) async {
    switch (path) {
      case '/prefix/api/sessions/stored':
        return {
          'id': 'stored',
          'profile': 'work',
          'cwd': cwd,
          'git_metadata_generation': generation,
        };
      case '/prefix/api/sessions/stored/mutation-snapshot':
        return {
          'session_id': 'stored',
          'exists': true,
          'runtime_revision': revision,
          'runtime_generation': generation,
        };
      case '/prefix/api/tools/terminal/backends':
        return {
          'active': 'local',
          'backends': [
            {'name': 'local', 'active': true},
          ],
        };
      case '/prefix/api/git/review/list':
        _owns(query['path']);
        return _reviewList(query['scope'] ?? 'uncommitted', query['base']);
      case '/prefix/api/git/review/diff':
        _owns(query['path']);
        return {
          'diff': await _diff(
            query['file'],
            query['scope'] ?? 'uncommitted',
            query['base'],
            query['staged'] == 'true',
          ),
        };
      case '/prefix/api/git/review/commit-context':
        _owns(query['path']);
        return _commitContext();
      case '/prefix/api/git/review/rev-parse':
        _owns(query['path']);
        if (query['ref'] != null && query['ref'] != 'HEAD') throw _GitReject();
        return {
          'sha': await _line(['rev-parse', 'HEAD']),
        };
      case '/prefix/api/git/review/ship-info':
        _owns(query['path']);
        final url = pullRequestUrl;
        return {
          'ghReady': ghReady,
          'pr': url == null ? null : {'url': url, 'state': 'OPEN', 'number': 1},
        };
      case '/prefix/api/git/worktrees':
        _owns(query['path']);
        return {'worktrees': await _worktrees()};
      case '/prefix/api/git/branches':
        _owns(query['path']);
        return {'branches': await _branches()};
      case '/prefix/api/git/base-branches':
        _owns(query['path']);
        return {'branches': await _baseBranches()};
      case '/prefix/api/git/status':
        _owns(query['path']);
        final files = await _uncommitted();
        return {'changed': files.length, 'files': files};
      default:
        throw _GitReject();
    }
  }

  Future<Object?> _post(String path, Map<String, Object?> body) async {
    _owns(body['path'] as String?);
    switch (path) {
      case '/prefix/api/git/review/stage':
        await _ok(
          body['file'] == null
              ? ['add', '-A']
              : ['add', '--', _file(body['file'])],
        );
        return {'ok': true};
      case '/prefix/api/git/review/unstage':
        await _ok([
          'reset',
          '-q',
          'HEAD',
          if (body['file'] != null) ...['--', _file(body['file'])],
        ]);
        return {'ok': true};
      case '/prefix/api/git/review/revert':
        final file = body['file'] == null ? '.' : _file(body['file']);
        await _run(['checkout', 'HEAD', '--', file]);
        await _run(['clean', '-fd', '--', file]);
        return {'ok': true};
      case '/prefix/api/git/review/commit':
        final message = body['message'];
        if (message is! String || message.trim().isEmpty) throw _GitReject();
        if (!await _hasStaged()) await _ok(['add', '-A']);
        await _ok([
          '-c',
          'user.name=Ares Fixture',
          '-c',
          'user.email=ares@localhost',
          'commit',
          '-m',
          message,
        ]);
        if (body['push'] == true) await _push();
        return {'ok': true};
      case '/prefix/api/git/review/push':
        await _push();
        return {'ok': true};
      case '/prefix/api/git/review/create-pr':
        return _createPr();
      case '/prefix/api/git/worktree/add':
        return _worktreeAdd(body);
      case '/prefix/api/git/worktree/remove':
        final target = body['worktreePath'];
        if (target is! String || !await _isLinkedWorktree(target)) {
          throw _GitReject();
        }
        await _ok([
          'worktree',
          'remove',
          if (body['force'] == true) '--force',
          target,
        ]);
        return {'removed': target};
      case '/prefix/api/git/branch/switch':
        final branch = _branchName(body['branch']);
        await _ok(['switch', branch]);
        return {'branch': branch};
      default:
        throw _GitReject();
    }
  }

  Future<Map<String, Object?>> _reviewList(String scope, String? base) async {
    if (scope == 'branch' || scope == 'lastTurn') {
      final resolved = scope == 'branch' ? await _mergeBase() : _shaOnly(base);
      if (resolved == null) return {'files': <Object>[], 'base': null};
      final range = scope == 'branch' ? '$resolved...HEAD' : resolved;
      final files = await _numstatMaps([range], status: 'M');
      if (scope == 'lastTurn') {
        final seen = files.map((file) => file['path']).toSet();
        for (final path in await _untracked()) {
          if (seen.add(path)) {
            files.add({
              'path': path,
              'added': await _lineCount(path),
              'removed': 0,
              'status': '?',
              'staged': false,
            });
          }
        }
      }
      files.sort(
        (a, b) => (a['path'] as String).compareTo(b['path'] as String),
      );
      return {'files': files, 'base': resolved};
    }
    final files = await _uncommitted();
    files.addAll(extraReviewRows);
    return {'files': files, 'base': null};
  }

  Future<List<Map<String, Object?>>> _uncommitted() async {
    final staged = await _numstat(['--cached']);
    final unstaged = await _numstat([]);
    final files = <Map<String, Object?>>[];
    for (final entry in await _statusEntries()) {
      final path = entry.$3;
      final counts = (
        (staged[path]?.$1 ?? 0) + (unstaged[path]?.$1 ?? 0),
        (staged[path]?.$2 ?? 0) + (unstaged[path]?.$2 ?? 0),
      );
      final added = entry.$1 == '?' ? await _lineCount(path) : counts.$1;
      files.add({
        'path': path,
        'added': added,
        'removed': counts.$2,
        'status': _statusLetter(entry.$1, entry.$2),
        'staged':
            (entry.$1 == '1' || entry.$1 == '2') &&
            entry.$2.isNotEmpty &&
            entry.$2[0] != '.' &&
            entry.$2[0] != '?',
      });
    }
    files.sort((a, b) => (a['path'] as String).compareTo(b['path'] as String));
    return files;
  }

  /// Porcelain v2 `-z`, the shape `review_list` reads. Paths are not quoted
  /// and no row is dropped.
  Future<List<(String, String, String)>> _statusEntries() async {
    final raw = await _out(['status', '--porcelain=v2', '-z']);
    final records = raw.split('\u0000');
    final entries = <(String, String, String)>[];
    for (var i = 0; i < records.length; i++) {
      final rec = records[i];
      if (rec.isEmpty) continue;
      final tag = rec[0];
      if (tag == '?') {
        entries.add(('?', '??', rec.length < 2 ? '' : rec.substring(2)));
      } else if (tag == 'u') {
        final bits = rec.split(' ');
        entries.add(('u', bits.length > 1 ? bits[1] : 'u', bits.last));
      } else if (tag == '1' || tag == '2') {
        final parts = _splitMax(rec, ' ', tag == '1' ? 8 : 9);
        final xy = parts.length > 1 ? parts[1] : '.';
        entries.add((tag, xy, parts.last));
        if (tag == '2') i++;
      }
    }
    return entries;
  }

  Future<String> _diff(
    String? file,
    String scope,
    String? base,
    bool staged,
  ) async {
    final path = _file(file);
    if (scope == 'branch') {
      final resolved = await _mergeBase();
      if (resolved == null) return '';
      return _out(['diff', '--no-renames', '$resolved...HEAD', '--', path]);
    }
    if (scope == 'lastTurn') {
      final resolved = _shaOnly(base);
      if (resolved == null) return '';
      final text = await _out(['diff', '--no-renames', resolved, '--', path]);
      if (text.trim().isNotEmpty) return text;
    } else if (staged) {
      return _out(['diff', '--no-renames', '--cached', '--', path]);
    } else {
      final text = await _out(['diff', '--no-renames', '--', path]);
      if (text.trim().isNotEmpty) return text;
    }
    final untracked = await _out(['status', '--porcelain', '--', path]);
    if (!untracked.startsWith('??')) return '';
    final result = await _run(['diff', '--no-index', '--', '/dev/null', path]);
    return result.stdout as String;
  }

  Future<Map<String, Object?>> _commitContext() async {
    final staged = await _hasStaged();
    var diff = await _out(staged ? ['diff', '--cached'] : ['diff', 'HEAD']);
    final extra = await _untracked();
    if (extra.isNotEmpty) {
      diff += '\n# New (untracked) files:\n';
      for (final path in extra.take(80)) {
        diff += '#   $path\n';
      }
    }
    return {
      'diff': diff,
      'recent': await _out(['log', '-n', '10', '--pretty=format:%s']),
    };
  }

  Future<void> _push() async {
    final upstream = await _line([
      'rev-parse',
      '--abbrev-ref',
      '--symbolic-full-name',
      '@{u}',
    ]);
    if (upstream != null && upstream.isNotEmpty) {
      await _ok(['push']);
      return;
    }
    final branch = await _line(['rev-parse', '--abbrev-ref', 'HEAD']);
    if (branch == null || branch == 'HEAD') throw _GitReject();
    await _ok(['push', '-u', 'origin', branch]);
  }

  Future<Map<String, Object?>> _createPr() async {
    final origin = await _line(['remote', 'get-url', 'origin']);
    if (origin == null ||
        origin.contains('github.com') ||
        origin.contains('gitlab') ||
        !(origin.startsWith('/') || origin.startsWith('file:'))) {
      throw _GitReject();
    }
    try {
      await _push();
    } on _GitReject {
      // A missing upstream still leaves the local record, matching gh's
      // separate failure. This fixture never contacts a forge.
    }
    final branch = await _line(['rev-parse', '--abbrev-ref', 'HEAD']);
    final record = File('$origin/PULL_REQUEST');
    await record.writeAsString('branch: $branch\n');
    return {'url': Uri.file(record.path).toString()};
  }

  Future<Map<String, Object?>> _worktreeAdd(Map<String, Object?> body) async {
    final existing = body['existingBranch'];
    final String branch;
    final String directory;
    if (existing != null) {
      branch = _branchName(existing);
      directory = '${root.path}/.worktrees/${branch.replaceAll('/', '-')}';
      await _ok(['worktree', 'add', directory, branch]);
    } else {
      final name = body['name'] == null ? 'work' : _branchName(body['name']);
      branch = body['branch'] == null
          ? 'hermes/$name'
          : _branchName(body['branch']);
      if (!_refName(branch)) throw _GitReject();
      directory = '${root.path}/.worktrees/${name.replaceAll('/', '-')}';
      final base = body['base'] == null ? null : _branchName(body['base']);
      await _ok(['worktree', 'add', '-b', branch, directory, ?base]);
    }
    return {'path': directory, 'branch': branch, 'repoRoot': root.path};
  }

  Future<List<Map<String, Object?>>> _worktrees() async {
    final text = await _out(['worktree', 'list', '--porcelain']);
    final trees = <Map<String, Object?>>[];
    for (final line in text.split('\n')) {
      if (line.startsWith('worktree ')) {
        trees.add({
          'path': line.substring(9).trim(),
          'branch': null,
          'isMain': trees.isEmpty,
          'detached': false,
          'locked': false,
        });
      } else if (trees.isEmpty) {
        continue;
      } else if (line.startsWith('branch ')) {
        trees.last['branch'] = line
            .substring(7)
            .trim()
            .replaceFirst('refs/heads/', '');
      } else if (line == 'detached') {
        trees.last['detached'] = true;
      } else if (line.startsWith('locked')) {
        trees.last['locked'] = true;
      }
    }
    return trees;
  }

  Future<List<Map<String, Object?>>> _branches() async {
    final names = await _lines([
      'for-each-ref',
      '--format=%(refname:short)',
      'refs/heads',
    ]);
    final trees = await _worktrees();
    return [
      for (final name in names)
        {
          'name': name,
          'checkedOut': trees.any((tree) => tree['branch'] == name),
          'isDefault': name == 'main' || name == 'master',
          'isRemote': false,
          'worktreePath': trees
              .where((tree) => tree['branch'] == name)
              .map((tree) => tree['path'])
              .cast<String?>()
              .firstOrNull,
        },
    ];
  }

  Future<List<Map<String, Object?>>> _baseBranches() async {
    final names = await _lines([
      'for-each-ref',
      '--format=%(refname:short)',
      'refs/heads',
      'refs/remotes',
    ]);
    return [
      for (final name in names)
        if (!name.endsWith('/HEAD'))
          {
            'name': name,
            'isRemote': name.startsWith('origin/'),
            'isDefault': name == 'main' || name == 'origin/main',
          },
    ];
  }

  Future<String?> _mergeBase() async {
    for (final name in ['main', 'master']) {
      final exists = await _run([
        'show-ref',
        '--verify',
        '--quiet',
        'refs/heads/$name',
      ]);
      if (exists.exitCode != 0) continue;
      return _line(['merge-base', 'HEAD', name]);
    }
    return null;
  }

  Future<bool> _hasStaged() async {
    final text = await _out(['status', '--porcelain']);
    return text
        .split('\n')
        .any((line) => line.length >= 2 && line[0] != ' ' && line[0] != '?');
  }

  Future<List<String>> _untracked() async {
    final text = await _out(['status', '--porcelain']);
    return [
      for (final line in text.split('\n'))
        if (line.startsWith('?? ')) line.substring(3),
    ];
  }

  Future<int> _lineCount(String relative) async {
    final file = File('${cwd.endsWith('/') ? cwd : '$cwd/'}$relative');
    if (!file.existsSync()) return 0;
    final text = await file.readAsString();
    if (text.isEmpty) return 0;
    final lines = text.split('\n');
    return text.endsWith('\n') ? lines.length - 1 : lines.length;
  }

  Future<bool> _isLinkedWorktree(String path) async {
    final trees = await _worktrees();
    return trees.any((tree) => tree['path'] == path && tree['isMain'] != true);
  }

  Future<List<Map<String, Object?>>> _numstatMaps(
    List<String> args, {
    required String status,
  }) async {
    final counts = await _numstat(args);
    return [
      for (final entry in counts.entries)
        {
          'path': entry.key,
          'added': entry.value.$1,
          'removed': entry.value.$2,
          'status': status,
          'staged': false,
        },
    ];
  }

  Future<Map<String, (int, int)>> _numstat(List<String> args) async {
    final text = await _out(['diff', '--numstat', ...args]);
    final counts = <String, (int, int)>{};
    for (final line in text.split('\n')) {
      final bits = line.split('\t');
      if (bits.length < 3 || !_relative(bits[2])) continue;
      counts[bits[2]] = (
        int.tryParse(bits[0]) ?? 0,
        int.tryParse(bits[1]) ?? 0,
      );
    }
    return counts;
  }

  void _owns(String? path) {
    if (path != cwd) throw _GitReject();
  }

  String _file(Object? value) {
    if (value is! String || !_relative(value)) throw _GitReject();
    return value;
  }

  String _branchName(Object? value) {
    if (value is! String || !_refName(value)) throw _GitReject();
    return value;
  }

  bool _refName(String name) {
    if (name.isEmpty || name.length > 200 || name == '@') return false;
    if (name.startsWith('/') ||
        name.endsWith('/') ||
        name.endsWith('.') ||
        name.contains('..') ||
        name.contains('//') ||
        name.contains('@{') ||
        name.contains('\\')) {
      return false;
    }
    if (RegExp(r'[\x00-\x20\x7f~^:?*\[]').hasMatch(name)) return false;
    return name
        .split('/')
        .every(
          (part) =>
              part.isNotEmpty &&
              !part.startsWith('.') &&
              !part.endsWith('.lock'),
        );
  }

  String? _shaOnly(String? value) {
    if (value == null || !_sha.hasMatch(value)) throw _GitReject();
    return value;
  }

  bool _relative(String path) =>
      path.isNotEmpty &&
      !path.startsWith('/') &&
      !path.startsWith('-') &&
      !path.contains('..') &&
      !path.contains(r'\');

  String _statusLetter(String tag, String xy) {
    if (tag == '?' || tag == 'u') return tag.toUpperCase();
    final code = xy.isEmpty
        ? '.'
        : (xy[0] != '.' ? xy[0] : (xy.length > 1 ? xy[1] : '.'));
    return (code == '.' ? 'M' : code).toUpperCase();
  }

  List<String> _splitMax(String value, String separator, int max) {
    final out = <String>[];
    var rest = value;
    for (var i = 0; i < max; i++) {
      final at = rest.indexOf(separator);
      if (at < 0) break;
      out.add(rest.substring(0, at));
      rest = rest.substring(at + separator.length);
    }
    out.add(rest);
    return out;
  }

  Future<String> _out(List<String> args) async {
    final result = await _run(args);
    if (result.exitCode != 0) throw _GitReject();
    return result.stdout as String;
  }

  Future<void> _ok(List<String> args) async {
    final result = await _run(args);
    if (result.exitCode != 0) throw _GitReject();
  }

  Future<String?> _line(List<String> args) async {
    final result = await _run(args);
    if (result.exitCode != 0) return null;
    final text = (result.stdout as String).trim();
    return text.isEmpty ? null : text.split('\n').first;
  }

  Future<List<String>> _lines(List<String> args) async {
    final text = await _out(args);
    return [
      for (final line in text.split('\n'))
        if (line.trim().isNotEmpty) line.trim(),
    ];
  }

  Future<ProcessResult> _run(List<String> args) {
    executables.add('git');
    return Process.run(
      'git',
      args,
      workingDirectory: cwd,
      environment: {
        'PATH': Platform.environment['PATH'] ?? '/usr/bin:/bin',
        'GIT_CONFIG_GLOBAL': _emptyConfig.path,
        'GIT_CONFIG_NOSYSTEM': '1',
        'GIT_TERMINAL_PROMPT': '0',
        'GIT_AUTHOR_NAME': 'Ares Fixture',
        'GIT_AUTHOR_EMAIL': 'ares@localhost',
        'GIT_COMMITTER_NAME': 'Ares Fixture',
        'GIT_COMMITTER_EMAIL': 'ares@localhost',
      },
    );
  }

  Future<void> _json(HttpResponse response, Object? body) async {
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode(body));
    await response.close();
  }
}

class _GitReject implements Exception {}
