import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/bots_screen.dart';
import 'package:hermes_android/core/services/bot_desktop_session.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A 1x1 PNG, base64 (what a picked and normalised avatar looks like).
const botsFixturePng =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';

/// Waits (real and fake time) until [finder] matches, then asserts it does.
Future<void> botsShown(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 60 && finder.evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  expect(finder, findsWidgets);
}

/// Lets queued gateway replies and their rebuilds land.
Future<void> botsStep(WidgetTester tester, [int n = 8]) async {
  for (var i = 0; i < n; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 80));
  }
}

final botsReviewConnection = SavedConnection(
  id: 'c-bots',
  label: 'Review Bots Host',
  host: '127.0.0.1',
  port: 9,
  apiKey: 'fixture-key',
  dashboardUsername: 'fixture',
  dashboardPassword: 'fixture-password',
  desktopGatewayUrl: 'http://127.0.0.1:9',
  gatewayProfile: 'work',
);

class BotsReviewCall {
  BotsReviewCall(this.method, this.params);
  final String method;
  final Map<String, dynamic> params;

  @override
  String toString() => '$method $params';
}

/// A gateway that answers the Bot Mode RPCs the way `tui_gateway` does at
/// b7ee21c14e, and REFUSES what the real one refuses: a call with a missing
/// or malformed param fails here too, so a test cannot pass against a wire
/// shape the gateway would reject. An unknown method is method-not-found.
class BotsReviewGateway {
  final calls = <BotsReviewCall>[];

  /// Every call this gateway refused, with its reply.
  final refusals = <String>[];

  /// `method:profile:action` to a completer the reply waits on.
  final holds = <String, Completer<void>>{};

  /// Merged into every display status (e.g. a pending `image_switch`).
  Map<String, dynamic>? displayOverride;

  /// Profiles whose host has the screen packages / a running screen.
  final installed = <String>{'workbot'};
  final running = <String>{'workbot'};

  /// What `display.thumbnail` returns while the agent holds the screen.
  String? thumbnailDataUrl;

  /// Per-profile cron stores, rows as `cron/job_args.py::_format_job`.
  final jobs = <String, List<Map<String, dynamic>>>{
    'workbot': [
      {
        'job_id': 'job-standup',
        'name': '[bot:workbot] Stand-up',
        'prompt_preview': 'Post the stand-up summary',
        'schedule': '0 9 * * 1-5',
        'repeat': 'forever',
        'deliver': 'local',
        'enabled': true,
        'state': 'scheduled',
        'last_status': 'ok',
      },
    ],
    'researchbot': [],
  };

  /// Viewer ids `display.observe` minted on this connection.
  final minted = <String>{};
  final _leases = <String, Map<String, dynamic>>{};
  var _viewerSeq = 0;
  var _jobSeq = 0;

  Iterable<BotsReviewCall> named(String method) =>
      calls.where((c) => c.method == method);

  /// The lease the gateway holds for [profile] right now.
  Map<String, dynamic> leaseOf(String profile) =>
      _leases[profile] ??
      {
        'holder': 'agent',
        'viewer_hash': null,
        'since': 1,
        'epoch': 1,
        'reason': '',
      };

  String? leaseViewer(String profile) =>
      _leases[profile]?['_viewer_id'] as String?;

  Map<String, dynamic> _publicLease(String profile) =>
      Map<String, dynamic>.from(leaseOf(profile))..remove('_viewer_id');

  void _setLease(String profile, String holder, {String? viewer, String? why}) {
    final epoch = (leaseOf(profile)['epoch'] as int) + 1;
    _leases[profile] = {
      'holder': holder,
      'viewer_hash': viewer == null ? null : botDisplayViewerHash(viewer),
      '_viewer_id': viewer,
      'since': epoch,
      'epoch': epoch,
      'reason': why ?? '',
    };
  }

  Future<Map<String, dynamic>> handle(
    String method,
    Map<String, dynamic> params,
  ) async {
    calls.add(BotsReviewCall(method, Map<String, dynamic>.from(params)));
    final key = '$method:${params['profile']}:${params['action'] ?? ''}';
    final hold = holds[key];
    if (hold != null) await hold.future;
    final reply = _respond(method, params);
    if (reply['error'] != null) refusals.add('$method $params -> $reply');
    return reply;
  }

  static Map<String, dynamic> _error(
    int code,
    String message, {
    Map<String, dynamic>? data,
  }) => {
    'error': {'code': code, 'message': message, 'data': ?data},
  };

  static Map<String, dynamic> _ok(Map<String, dynamic> result) => {
    'result': result,
  };

  /// Pydantic `Params` models are closed: an unknown key is invalid params.
  static Map<String, dynamic>? _closed(
    Map<String, dynamic> params,
    Set<String> allowed,
  ) {
    final extra = params.keys.where((k) => !allowed.contains(k)).toList();
    return extra.isEmpty ? null : _error(-32602, 'invalid params: $extra');
  }

  final _eventTaps = <StreamCallback>[];
  final _requestHandlers = <String, List<ServerRequestCallback>>{};
  var _requestSeq = 0;

  /// Pushes one gateway event to everything watching this connection.
  void emit(String type, Map<String, dynamic> payload) {
    for (final tap in List.of(_eventTaps)) {
      tap(StreamEvent(type: type, data: payload));
    }
  }

  /// A server→client request. Completes with the client's response, or with
  /// null when nothing on the connection takes [method] (-32601 on the wire).
  Future<Map<String, dynamic>?> ask(
    String method,
    Map<String, dynamic> params,
  ) {
    final answer = Completer<Map<String, dynamic>?>();
    final request = GatewayServerRequest.forTesting(
      id: 'srq-${++_requestSeq}',
      method: method,
      params: params,
      respond: (result) {
        if (answer.isCompleted) return false;
        answer.complete(result);
        return true;
      },
    );
    for (final handler in List.of(_requestHandlers[method] ?? const [])) {
      if (handler(request)) return answer.future;
    }
    answer.complete(null);
    return answer.future;
  }

  Map<String, dynamic> statusOf(String profile) => _status(profile);

  Map<String, dynamic> _status(String profile) => {
    'profile': profile,
    'profile_key': 'key-$profile',
    'supported': true,
    'installed': installed.contains(profile),
    'missing': installed.contains(profile) ? const <String>[] : ['xvnc'],
    'running': running.contains(profile),
    'pid': running.contains(profile) ? 4242 : null,
    'geometry': '1280x800',
    'placement': 'gateway',
    'lease': _publicLease(profile),
    ...?displayOverride,
  };

  static String repeatDisplay(String schedule, int? repeat) {
    final recurring =
        schedule.startsWith('every ') || schedule.trim().contains(' ');
    final times = repeat ?? (recurring ? null : 1);
    if (times == null) return 'forever';
    return times == 1 ? 'once' : '$times times';
  }

  /// The roster `profiles.list` answers, rows as `methods_profiles.py`
  /// builds them. `profiles.create` adds to it.
  final profiles = <Map<String, dynamic>>[
    {
      'name': 'workbot',
      'path': '/home/bots/workbot',
      'is_default': false,
      'model': 'claude-sonnet',
      'provider': 'anthropic',
      'description': 'Primary worker bot',
      'display_name': 'WorkBot',
      'skill_count': 4,
      'has_avatar': true,
      'canonical_session': {'id': 'sess-canonical-workbot'},
      'last_session': {'preview': 'last coding turn'},
    },
    {
      'name': 'researchbot',
      'path': '/home/bots/researchbot',
      'is_default': false,
      'model': 'gpt-5',
      'provider': 'openrouter',
      'description': 'Research bot',
      'display_name': 'ResearchBot',
      'skill_count': 2,
    },
  ];

  /// Per-profile `profile.yaml` `ui_meta` and `_ui_meta_revisions`.
  final uiMeta = <String, Map<String, dynamic>>{};
  final uiMetaRevisions = <String, Map<String, int>>{};

  /// Stored avatars (data URLs) by profile.
  final avatars = <String, String>{
    'workbot': 'data:image/png;base64,$botsFixturePng',
  };

  /// What `profiles.describe` reports, by profile.
  final described = <String, Map<String, dynamic>>{};

  /// Models whose pick answers `confirm_required` until confirmed.
  final guardedModels = <String>{};

  /// Sections `profiles.configure` reports as not applied.
  final failSections = <String>{};

  /// Bumped behind the client's back: another Desktop wrote the record.
  void bumpRevision(String profile, Map<String, dynamic> meta) {
    uiMeta[profile] = {...?uiMeta[profile], 'hermes-bots': meta};
    final revs = uiMetaRevisions.putIfAbsent(profile, () => {});
    revs['hermes-bots'] = (revs['hermes-bots'] ?? 0) + 1;
  }

  Map<String, dynamic> describeOf(String profile) =>
      described[profile] ??
      {
        'name': profile,
        'description': '',
        'soul': '# $profile\n',
        'model': {'provider': 'anthropic', 'default': 'claude-sonnet'},
        'skills': [
          {'name': 'web-research', 'enabled': true},
          {'name': 'git-helper', 'enabled': true},
        ],
        'toolsets': [
          {
            'name': 'web',
            'label': 'Web',
            'description': 'Search and fetch',
            'tool_count': 2,
            'enabled': true,
          },
          {
            'name': 'terminal',
            'label': 'Terminal',
            'description': 'Run commands',
            'tool_count': 1,
            'enabled': true,
          },
        ],
        'toolsets_pinned': false,
        'mcp_servers': [
          {'name': 'github', 'enabled': false, 'transport': 'http'},
        ],
      };

  Map<String, dynamic>? _row(String? name) =>
      profiles.where((r) => r['name'] == name).firstOrNull;

  static final _profileId = RegExp(r'^[a-z0-9][a-z0-9_-]{0,63}$');
  static const _reserved = {'hermes', 'test', 'tmp', 'root', 'sudo'};

  /// `params` against a contract's typed fields: `{key: (type check)}`.
  static Map<String, dynamic>? _typed(
    Map<String, dynamic> params,
    Map<String, bool Function(Object?)> fields,
  ) {
    final refused = _closed(params, {...fields.keys, 'profile'});
    if (refused != null) return refused;
    for (final MapEntry(:key, :value) in params.entries) {
      final ok = key == 'profile'
          ? value == null || value is String
          : fields[key]!(value);
      if (!ok) return _error(-32602, 'invalid params: $key');
    }
    return null;
  }

  static bool _str(Object? v) => v == null || v is String;
  static bool _flag(Object? v) => v == null || v is bool || v is String;
  static bool _names(Object? v) =>
      v == null || v is List && v.every((e) => e is String);

  /// `tui_gateway/methods_profiles.py` at b7ee21c14e, with the contracts in
  /// `tui_gateway/contracts/profiles_vault_complete_foreign_subagents.py`.
  Map<String, dynamic> _profiles(String method, Map<String, dynamic> p) {
    switch (method) {
      case 'profiles.list':
        final refused = _typed(p, {'include_sessions': _flag});
        if (refused != null) return refused;
        return _ok({
          'profiles': [
            for (final row in profiles)
              {
                ...row,
                'has_avatar': avatars.containsKey(row['name']),
                'ui_meta_revisions': {...?uiMetaRevisions[row['name']]},
                if (uiMeta[row['name']]?.isNotEmpty == true)
                  'ui_meta': jsonDecode(jsonEncode(uiMeta[row['name']])),
              },
          ],
          'bot_mode_protocol': true,
          'install_id': 'fixture-install-1',
        });
      case 'profiles.create':
        final refused = _typed(p, {
          'name': (v) => v is String,
          'description': _str,
          'clone_from': _str,
          'clone_all': _flag,
          'clone_channels': _flag,
          'no_skills': _flag,
          'no_alias': _flag,
          'soul': _str,
          'model': _str,
          'provider': _str,
          'share_auth': _flag,
          'mirror_credentials': _flag,
          'clone_config': _flag,
          'sync_imports': _flag,
          'report': _flag,
        });
        if (refused != null) return refused;
        final name = (p['name'] as String).trim();
        if (name.isEmpty) return _error(4061, 'name required');
        if (!_profileId.hasMatch(name)) {
          return _error(4062, "Invalid profile name '$name'.");
        }
        if (_reserved.contains(name)) {
          return _error(
            4062,
            "Profile name '$name' is reserved — it collides with either the "
            'Hermes installation itself or a common system binary.  Pick a '
            'different name.',
          );
        }
        if (_row(name) != null || name == 'default') {
          return _error(
            4062,
            "A profile named '$name' already exists. Switch to it with "
            '`hermes profile use $name`, see all profiles with `hermes '
            'profile list`, or choose a different name.',
          );
        }
        final clone = p['clone_from'] as String?;
        if (clone != null && clone != 'default' && _row(clone) == null) {
          return _error(4062, "Profile '$clone' does not exist.");
        }
        final model = (p['model'] as String? ?? '').trim();
        final provider = (p['provider'] as String? ?? '').trim();
        profiles.add({
          'name': name,
          'path': '/home/bots/$name',
          'is_default': false,
          'model': model.isEmpty ? 'claude-sonnet' : model,
          'provider': provider.isEmpty ? 'anthropic' : provider,
          'description': (p['description'] as String? ?? '').trim(),
          'display_name': '',
          'skill_count': p['no_skills'] == true ? 0 : 3,
        });
        return _ok({
          'ok': true,
          'name': name,
          'path': '/home/bots/$name',
          'soul_written': p['soul'] is String,
          'model_set': model.isNotEmpty && provider.isNotEmpty,
          'mirrored': {'env': true, 'auth': 'shared'},
          'warnings': <String>[],
        });
      case 'profiles.describe':
        final refused = _typed(p, {'name': _str});
        if (refused != null) return refused;
        final name = (p['name'] as String? ?? '').trim();
        if (name.isEmpty) return _error(4063, 'name required');
        if (_row(name) == null) {
          return _error(4064, "profile '$name' not found");
        }
        return _ok({
          ...describeOf(name),
          'description': _row(name)!['description'],
        });
      case 'profiles.configure':
        final refused = _typed(p, {
          'name': _str,
          'ui_meta': (v) => v == null || v is Map,
          'ui_meta_expected_revisions': (v) =>
              v == null || v is Map && v.values.every((e) => e is int),
          'soul': _str,
          'description': _str,
          'model': _str,
          'provider': _str,
          'confirm_expensive_model': _flag,
          'disabled_skills': _names,
          'enabled_toolsets': _names,
          'enabled_mcp_servers': _names,
        });
        if (refused != null) return refused;
        final name = (p['name'] as String? ?? '').trim();
        if (name.isEmpty) return _error(4063, 'name required');
        final row = _row(name);
        if (row == null) return _error(4064, "profile '$name' not found");
        final applied = <String, dynamic>{};
        bool ok(String section) => !failSections.contains(section);
        final incoming = p['ui_meta'];
        if (incoming is Map) {
          final revs = uiMetaRevisions.putIfAbsent(name, () => {});
          final expected = p['ui_meta_expected_revisions'] as Map?;
          final conflicts = {
            if (expected != null)
              for (final key in incoming.keys)
                if (expected[key] != (revs[key] ?? 0))
                  key: {'expected': expected[key], 'actual': revs[key] ?? 0},
          };
          if (conflicts.isNotEmpty) {
            applied['ui_meta'] = false;
            applied['ui_meta_conflicts'] = conflicts;
            applied['ui_meta_revisions'] = {
              for (final key in incoming.keys) key: revs[key] ?? 0,
            };
          } else if (!ok('ui_meta')) {
            applied['ui_meta'] = false;
          } else {
            final current = uiMeta.putIfAbsent(name, () => {});
            for (final MapEntry(:key, :value) in incoming.entries) {
              if (value == null) {
                current.remove(key);
              } else {
                current['$key'] = jsonDecode(jsonEncode(value));
              }
              revs['$key'] = (revs['$key'] ?? 0) + 1;
            }
            applied['ui_meta'] = true;
            applied['ui_meta_revisions'] = {
              for (final key in incoming.keys) key: revs[key],
            };
          }
        }
        final described = Map<String, dynamic>.from(describeOf(name));
        if (p['soul'] is String) {
          applied['soul'] = ok('soul');
          if (ok('soul')) described['soul'] = p['soul'];
        }
        if (p['description'] is String) {
          applied['description'] = ok('description');
          if (ok('description')) {
            row['description'] = (p['description'] as String).trim();
          }
        }
        String? confirm;
        final model = (p['model'] as String? ?? '').trim();
        final provider = (p['provider'] as String? ?? '').trim();
        if (model.isNotEmpty && provider.isNotEmpty) {
          if (guardedModels.contains(model) &&
              p['confirm_expensive_model'] != true) {
            confirm = '$model costs more than your current model.';
          } else {
            applied['model'] = ok('model');
            if (ok('model')) {
              row['model'] = model;
              row['provider'] = provider;
              described['model'] = {'provider': provider, 'default': model};
            }
          }
        }
        for (final (param, section, list) in [
          ('disabled_skills', 'skills', 'skills'),
          ('enabled_toolsets', 'toolsets', 'toolsets'),
          ('enabled_mcp_servers', 'mcp_servers', 'mcp_servers'),
        ]) {
          final names = p[param];
          if (names is! List) continue;
          applied[section] = ok(section);
          if (!ok(section)) continue;
          final items = [
            for (final item in described[list] as List)
              Map<String, dynamic>.from(item as Map),
          ];
          for (final item in items) {
            final listed = names.contains(item['name']);
            item['enabled'] = param == 'disabled_skills'
                ? !listed
                : (param == 'enabled_toolsets' && names.isEmpty) || listed;
          }
          described[list] = items;
        }
        this.described[name] = described;
        final flags = [
          for (final v in applied.values)
            if (v is bool) v,
        ];
        return _ok({
          'ok': flags.every((v) => v),
          'applied': applied,
          if (confirm != null) ...{
            'confirm_required': true,
            'confirm_message': confirm,
          },
        });
      case 'profiles.set_asset':
        final refused = _typed(p, {
          'name': _str,
          'asset': _str,
          'data': _str,
          'clear': _flag,
        });
        if (refused != null) return refused;
        final asset = (p['asset'] as String? ?? 'avatar').trim().toLowerCase();
        final name = (p['name'] as String? ?? '').trim();
        if (name.isEmpty) return _error(4063, 'name required');
        if (asset != 'avatar') {
          return _error(4066, "unknown asset '$asset' (supported: avatar)");
        }
        if (_row(name) == null) {
          return _error(4064, "profile '$name' not found");
        }
        if (p['clear'] == true) {
          final removed = avatars.remove(name) == null ? 0 : 1;
          return _ok({
            'ok': true,
            'asset': asset,
            'size': 0,
            'removed': removed,
          });
        }
        final data = p['data'] as String? ?? '';
        if (data.isEmpty) {
          return _error(4067, 'data required (data URL or base64)');
        }
        final match = RegExp(
          r'^data:(image/(?:png|jpeg|webp));base64,(.*)$',
        ).firstMatch(data);
        final List<int> blob;
        try {
          blob = base64Decode(match != null ? match[2]! : data);
        } on FormatException {
          return _error(4068, 'data is not valid base64');
        }
        if (blob.length > 2000000) {
          return _error(
            4069,
            'asset too large (${blob.length} bytes; max 2MB)',
          );
        }
        const png = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];
        if (blob.length < 8 ||
            !List.generate(8, (i) => blob[i] == png[i]).every((b) => b)) {
          return _error(4070, 'unsupported image format (PNG/JPEG/WebP only)');
        }
        avatars[name] = data;
        return _ok({'ok': true, 'asset': asset, 'size': blob.length});
      case 'profiles.get_asset':
        final refused = _typed(p, {'name': _str, 'asset': _str});
        if (refused != null) return refused;
        final name = (p['name'] as String? ?? '').trim();
        if (name.isEmpty) return _error(4063, 'name required');
        if (_row(name) == null) {
          return _error(4064, "profile '$name' not found");
        }
        final data = avatars[name];
        if (data == null) return _ok({'found': false});
        return _ok({
          'found': true,
          'mime': 'image/png',
          'size': base64Decode(data.split(',').last).length,
          'data': data,
        });
    }
    return _error(-32601, 'method not found: $method');
  }

  Map<String, dynamic> _respond(String method, Map<String, dynamic> p) {
    final profile = p['profile'] is String ? p['profile'] as String : 'workbot';
    if (method.startsWith('profiles.')) return _profiles(method, p);
    switch (method) {
      case 'session.list':
        return _ok({
          'sessions': [
            if (profile == 'workbot')
              {'id': 'sess-canonical-workbot', 'title': 'Bot Chat'},
          ],
        });
      case 'session.create':
        return _ok({
          'session_id': 'runtime-$profile',
          'stored_session_id': 'sess-canonical-$profile',
        });
      case 'session.title':
        return _ok({'ok': true});
      case 'groups.capabilities':
        return _ok({
          'protocol_version': 2,
          'driver': true,
          'persistent_process': true,
          'authority_gateway_id': 'fixture-gateway',
          'room_link': {'viewer_id': 'fixture-view'},
          'features': ['send', 'rename', 'context', 'stop'],
          'methods': [
            'groups.list',
            'groups.create',
            'groups.state',
            'groups.send',
            'groups.log',
            'groups.stop',
          ],
          'max_log_limit': 500,
          'seatable_profiles': ['workbot', 'researchbot'],
        });
      case 'groups.list':
        return _ok({
          'rooms': [_room('room-ops', 'Ops Room')],
          'next_offset': null,
        });
      case 'groups.state':
        return _ok({
          'room': _room('room-ops', 'Ops Room'),
          'driver_status': {
            'running': true,
            'working': true,
            'counts': {'active': 2},
          },
          'context': {'purpose': 'Ship v5', 'routing': 'everyone'},
        });
      case 'groups.create':
        if (p['room_id'] is! String || p['name'] is! String) {
          return _error(-32602, 'invalid params');
        }
        return _ok({
          'room': {
            'room_id': p['room_id'],
            'name': p['name'],
            'members': p['members'],
            'revision': 1,
          },
        });
      case 'groups.log':
        return _ok({
          'events': [
            {
              'seq': 1,
              'event_id': 'ev-1',
              'kind': 'message',
              'actor': 'workbot',
            },
          ],
          'cursor': 1,
          'latest_seq': 1,
          'has_more': false,
        });
      case 'groups.send':
        return _ok({'client_event_id': 'evt-1', 'accepted': true});
      case 'groups.stop':
        return _ok({'cancelled': 0});
      case 'cron.manage':
        return _cron(profile, p);
      case 'display.status':
        return _ok(_status(profile));
      case 'display.start':
        if (!installed.contains(profile)) {
          return _error(5031, 'Bot Desktop is not installed on this host');
        }
        running.add(profile);
        return _ok(_status(profile));
      case 'display.stop':
        // methods_display.py: refused while a human holds unless `force`.
        if (leaseOf(profile)['holder'] == 'human' && p['force'] != true) {
          return _error(
            5031,
            'a human holds this screen; pass force: true to stop it anyway',
            data: {'code': 'viewer_mismatch'},
          );
        }
        _setLease(profile, 'agent');
        running.remove(profile);
        return _ok({..._status(profile), 'stopped': true});
      case 'display.observe':
        if (!running.contains(profile)) {
          return _error(
            5031,
            "this profile's Bot Desktop is not running; "
            'call display.start first',
          );
        }
        final asked = p['viewer_id'];
        final viewer = asked is String && minted.contains(asked)
            ? asked
            : 'viewer-${++_viewerSeq}';
        minted.add(viewer);
        return _ok({
          'ticket': 'ticket-$viewer',
          'path': '/api/display/ws',
          'viewer_id': viewer,
          ..._status(profile),
        });
      case 'display.thumbnail':
        return _ok(
          leaseOf(profile)['holder'] == 'human'
              ? {'data_url': null, 'suppressed': 'human_has_control'}
              : {
                  'data_url': running.contains(profile)
                      ? thumbnailDataUrl
                      : null,
                },
        );
      case 'display.lease.acquire':
        final viewer = p['viewer_id'];
        if (viewer is! String || viewer.trim().isEmpty) {
          return _error(5031, 'viewer_id required');
        }
        if (!minted.contains(viewer)) return _foreignViewer();
        _setLease(
          profile,
          'human',
          viewer: viewer,
          why: p['reason'] as String?,
        );
        return _ok({'lease': _publicLease(profile)});
      case 'display.lease.release':
        final viewer = p['viewer_id'] is String
            ? p['viewer_id'] as String
            : null;
        final force = p['force'] == true;
        if (viewer != null && !force && !minted.contains(viewer)) {
          return _foreignViewer();
        }
        final lease = leaseOf(profile);
        if (lease['holder'] == 'human') {
          if (viewer == null && !force) {
            return _error(
              5031,
              "viewer_id required to release another viewer's lease "
              '(or pass force: true)',
              data: {'code': 'viewer_mismatch'},
            );
          }
          // lease.release(viewer): only the holder (or force) hands back.
          if (force || lease['_viewer_id'] == viewer) {
            _setLease(profile, 'agent');
          }
        }
        return _ok({'lease': _publicLease(profile)});
      case 'display.install':
        if (installed.contains(profile)) {
          return _error(5031, 'already installed');
        }
        return _ok({
          'started': true,
          'command': 'sudo apt-get install -y tigervnc-standalone-server',
          'profile_key': 'key-$profile',
        });
      case 'display.switchSandboxImage':
        if (displayOverride?['image_switch'] == null) {
          return _error(
            5031,
            'no sandbox image switch is pending for this profile',
          );
        }
        final target =
            (displayOverride!['image_switch'] as Map)[p['approve'] == false
                ? 'current_image'
                : 'target_image'];
        displayOverride = {...displayOverride!}..remove('image_switch');
        return _ok({'docker_image': target, ..._status(profile)});
      case 'bot_relay.deliver':
        // tools/bot_live_delivery.py `_delivery_id`: 32-64 lowercase hex.
        final id = p['id'];
        if (id is! String || !RegExp(r'^[0-9a-f]{32,64}$').hasMatch(id)) {
          return _error(
            4090,
            'invalid_params',
            data: {'reason': 'invalid_params'},
          );
        }
        return _ok({'status': 'settled', 'reply': 'ok'});
      default:
        return _error(-32601, 'method not found: $method');
    }
  }

  static Map<String, dynamic> _foreignViewer() => _error(
    5031,
    'viewer_id was not minted for this connection; call display.observe first',
    data: {'code': 'viewer_mismatch'},
  );

  static Map<String, dynamic> _room(String id, String name) => {
    'room_id': id,
    'name': name,
    'members': [
      {'member_id': 'workbot', 'profile': 'workbot', 'handle': 'workbot'},
      {
        'member_id': 'researchbot',
        'profile': 'researchbot',
        'handle': 'researchbot',
      },
    ],
    'revision': 3,
  };

  /// `tui_gateway/methods_tools.py` cron.manage with `CronManageParams`.
  Map<String, dynamic> _cron(String profile, Map<String, dynamic> p) {
    final refused = _closed(p, const {
      'action',
      'name',
      'include_disabled',
      'schedule',
      'prompt',
      'repeat',
      'continuity',
      'deliver',
      'profile',
    });
    if (refused != null) return refused;
    final store = jobs.putIfAbsent(profile, () => []);
    final action = p['action'] as String? ?? 'list';
    final name = p['name'];
    switch (action) {
      case 'list':
        return _ok({
          'jobs': [
            for (final job in store)
              if (p['include_disabled'] == true || job['enabled'] != false)
                Map<String, dynamic>.from(job),
          ],
          'scoped': ?(p['profile'] as String?),
        });
      case 'add':
        final schedule = p['schedule'];
        final prompt = p['prompt'];
        if (name is! String ||
            name.trim().isEmpty ||
            schedule is! String ||
            schedule.trim().isEmpty ||
            prompt is! String ||
            prompt.trim().isEmpty) {
          return _error(5023, 'name, schedule and prompt are required');
        }
        final rawRepeat = p['repeat'];
        if (rawRepeat != null && (rawRepeat is! int || rawRepeat < 1)) {
          return _error(-32602, 'repeat must be a positive run count');
        }
        final row = {
          'job_id': 'job-${++_jobSeq}',
          'name': name,
          'prompt_preview': prompt,
          'schedule': schedule,
          'repeat': repeatDisplay(schedule, rawRepeat as int?),
          'deliver': p['deliver'] ?? 'local',
          'continuity': p['continuity'] == true,
          'enabled': true,
          'state': 'scheduled',
        };
        store.add(row);
        return _ok({
          'success': true,
          'job_id': row['job_id'],
          'name': name,
          'schedule': schedule,
          'repeat': row['repeat'],
        });
      case 'pause':
      case 'resume':
      case 'remove':
        final job = store.where((j) => j['job_id'] == name).firstOrNull;
        if (job == null) return _error(5023, 'job not found: $name');
        if (action == 'remove') {
          store.remove(job);
        } else {
          job['enabled'] = action == 'resume';
          job['state'] = action == 'resume' ? 'scheduled' : 'paused';
        }
        return _ok({'success': true, 'job_id': name});
      default:
        return _error(4016, 'unknown cron action: $action');
    }
  }
}

class BotsReviewSocket extends Fake implements WsClient {
  BotsReviewSocket(this.baseUrl, this.gateway);
  @override
  final String baseUrl;
  final BotsReviewGateway gateway;
  @override
  int get socketEpoch => 1;
  @override
  bool get isConnected => true;
  @override
  Future<Map<String, dynamic>> waitForGatewayReady({
    Duration timeout = const Duration(seconds: 15),
  }) async => {};
  @override
  Future<Map<String, dynamic>> send(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
    void Function()? onSent,
    bool includeProfile = true,
  }) => gateway.handle(method, params);

  @override
  void Function() watchEvents(StreamCallback listener) {
    gateway._eventTaps.add(listener);
    return () => gateway._eventTaps.remove(listener);
  }

  @override
  void Function() handleServerRequests(
    String method,
    ServerRequestCallback handler,
  ) {
    final handlers = gateway._requestHandlers.putIfAbsent(method, () => []);
    handlers.add(handler);
    return () => handlers.remove(handler);
  }
}

RemoteWorkspaceOwner botsReviewOwner(BotsReviewGateway gateway) {
  final dashboard = DashboardClient(
    host: '127.0.0.1',
    port: 9,
    username: 'fixture',
    password: 'fixture-password',
    gatewayProfile: 'work',
    httpClient: MockClient((_) async => http.Response('{}', 200)),
  );
  final socket = BotsReviewSocket(dashboard.baseUrl, gateway);
  return RemoteWorkspaceOwner(
    connectionId: 'c-bots',
    expectedBaseUrl: dashboard.baseUrl,
    profile: 'work',
    dashboard: dashboard,
    connect: () async => socket,
    ownsSocket: (_) => true,
  );
}

Widget botsReviewApp(
  RemoteWorkspaceOwner owner, {
  double textScale = 1.0,
  Locale? locale,
  BotDisplayConnector? displayConnector,
  ThemeData? theme,
  Future<String?> Function()? pickAvatarImage,
}) => MaterialApp(
  theme: theme,
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: BotsScreen(
    owner: owner,
    route: owner.route(),
    connection: botsReviewConnection,
    displayConnector: displayConnector,
    pickAvatarImage: pickAvatarImage,
  ),
);

/// Opens the Screen tab on the first bot (workbot: installed and running).
Future<void> openBotsScreenTab(WidgetTester tester) async {
  await botsShown(tester, find.text('WorkBot'));
  await tester.tap(find.text('Screen'));
  await botsShown(tester, find.text('Running'));
  await botsStep(tester);
}

/// Opens the Routines tab on the first bot (workbot: one routine).
Future<void> openBotsRoutinesTab(WidgetTester tester) async {
  await botsShown(tester, find.text('WorkBot'));
  await tester.tap(find.text('Routines'));
  await botsShown(tester, find.text('Stand-up'));
  await botsStep(tester);
}
