import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hermes_android/core/screens/profile_bundle_screen.dart';
import 'package:hermes_android/core/services/portable_profile_bundle.dart';
import 'package:hermes_android/core/workspace/profile_presentation_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'support/profile_bundle_picker.dart';

Future<void> _checkTile(WidgetTester tester, String title) async {
  final box = find.descendant(
    of: find.widgetWithText(CheckboxListTile, title),
    matching: find.byType(Checkbox),
  );
  await tester.scrollUntilVisible(
    box,
    160,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(box.hitTestable());
  await tester.pump();
}

Future<void> _shown(WidgetTester tester, Finder finder) async {
  // Dashboard futures and their timeouts are real async; the widget binding's
  // fake clock does not complete them.
  for (var attempt = 0; attempt < 200 && finder.evaluate().isEmpty; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 25)),
    );
    await tester.pump();
  }
  if (finder.evaluate().isEmpty) {
    final visible = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data)
        .whereType<String>()
        .join(' | ');
    final busy = find.byType(LinearProgressIndicator).evaluate().isNotEmpty;
    fail('Missing widget. busy=$busy Visible text: $visible');
  }
}

class _RosterSocket extends Fake implements WsClient {
  _RosterSocket(this.baseUrl, this.machine, this.names);
  @override
  final String baseUrl;
  final String machine;
  final Map<String, String> names;
  @override
  int get socketEpoch => 1;
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
  }) async {
    if (method == 'profiles.create') {
      expect(params['mirror_credentials'], false);
      expect(params['share_auth'], false);
      expect(params['clone_channels'], false);
      names[params['name'] as String] = '';
      return {
        'result': {'ok': true, 'name': params['name']},
      };
    }
    expect(method, 'profiles.list');
    return {
      'result': {
        'install_id': machine,
        'profiles': [
          for (final n in names.entries)
            {
              'name': n.key,
              'display_name': n.value,
              'path': '/fixture/${n.key}',
            },
        ],
      },
    };
  }
}

typedef _Reply =
    Object Function(
      String path,
      String method,
      Map data,
      Map<String, String> query,
    );
Future<RemoteProfileAdmin> _fixture(
  String host,
  String name,
  String machine,
  Map<String, String> names,
  _Reply handle, {
  Future<http.Response?> Function(http.Request)? binary,
}) async {
  final client = MockClient((req) async {
    expect(req.followRedirects, false);
    expect(req.url.host, host);
    final raw = await binary?.call(req);
    if (raw != null) return raw;
    expect(req.url.queryParameters['profile'], name);
    final body = req.bodyBytes.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(utf8.decode(req.bodyBytes)) as Map<String, dynamic>;
    final r = handle(req.url.path, req.method, body, req.url.queryParameters);
    return http.Response.bytes(utf8.encode(jsonEncode(r)), 200);
  });
  final db = DashboardClient(
    host: host,
    port: 443,
    useHttps: true,
    proxied: true,
    gatewayProfile: name,
    httpClient: client,
  );
  final ws = _RosterSocket(db.baseUrl, machine, names);
  final o = RemoteWorkspaceOwner(
    connectionId: machine,
    expectedBaseUrl: db.baseUrl,
    profile: name,
    dashboard: db,
    connect: () async => ws,
    ownsSocket: (s) => s == ws,
  );
  addTearDown(o.close);
  final t = await o.pane().bind(o.route());
  final roster = await ProfileRoster.read(t);
  return roster.settings(t, name);
}

Matcher get rejected => throwsA(isA<WorkspaceException>());
void main() {
  test(
    'download and stage only reviewed bytes; a foreign upload receipt never reaches import',
    () async {
      final src = Archive()
        ..addFile(ArchiveFile.string('qa/SOUL.md', 'fixture persona'))
        ..addFile(ArchiveFile.string('qa/.env', 'fixture-private'));
      final bytes = gzip.encode(TarEncoder().encodeBytes(src));
      const archive = '/private/profile-exports/qa-20261125-120000.tar.gz',
          staged = '/fixture/qa/uploads/web-aaaaaaaaaaaaaaaa-profile.tar.gz';
      var wrong = true, imports = 0;
      final names = {'qa': ''};
      final a = await _fixture(
        'source.invalid',
        'qa',
        'src',
        names,
        (p, m, b, q) {
          if (p == '/api/profiles/qa/export') {
            return {'ok': true, 'archive': archive};
          }
          expect(p, '/api/profiles/import');
          expect(b, {'archive': staged, 'name': 'received'});
          imports++;
          names['received'] = '';
          return {'ok': true, 'name': 'received'};
        },
        binary: (req) async {
          if (req.url.path == '/api/files/download') {
            expect(req.url.queryParameters, {'path': archive});
            return http.Response.bytes(bytes, 200);
          }
          if (req.url.path != '/api/chat/file-upload') return null;
          expect(req.url.queryParameters, {'profile': 'qa'});
          final raw = latin1.decode(req.bodyBytes);
          final start = raw.indexOf('\r\n\r\n') + 4;
          final end = raw.lastIndexOf('\r\n--');
          final payload = Uint8List.fromList(
            latin1.encode(raw.substring(start, end)),
          );
          final checked = await PortableProfileBundle.inspect(payload);
          expect(checked.files, {'SOUL.md': 'fixture persona'});
          expect(checked.omitted, 0);
          return http.Response(
            jsonEncode({
              'ok': true,
              'path': staged,
              'size': payload.length,
              'staged_upload': {
                'install_id': wrong ? 'other' : 'src',
                'path': staged,
                'profile_home': '/fixture/qa',
              },
            }),
            200,
          );
        },
      );
      final bundle = await a.portableExport(() {});
      expect(bundle.omitted, 1);
      await expectLater(
        a.importPortable(bundle, {'SOUL.md'}, 'received', () {}),
        rejected,
      );
      expect(imports, 0);
      wrong = false;
      await a.importPortable(bundle, {'SOUL.md'}, 'received', () {});
      expect(imports, 1);
    },
  );
  test(
    'lifecycle confirms exact names; host profile import/export use no client path fallback',
    () async {
      final names = {'default': '', 'qa': ''};
      var path = '';
      final writes = <String>[];
      final admin = await _fixture('source.invalid', 'qa', 's', names, (
        p,
        m,
        b,
        q,
      ) {
        writes.add('$m $p');
        switch (p) {
          case '/api/profiles/qa/export':
            expect(b, isEmpty);
            return {'ok': true, 'archive': '/private/qa.tar.gz'};
          case '/api/profiles/import':
            path = b['archive'] as String;
            names[b['name'] as String] = '';
            return {'ok': true, 'name': b['name']};
          case '/api/profiles/qa':
            if (m == 'PATCH') {
              names.remove('qa');
              names[b['new_name'] as String] = '';
              return {'ok': true, 'name': b['new_name']};
            }
            expect(m, 'DELETE');
            names.remove('qa');
            return {'ok': true, 'settlement_pending': true};
          default:
            throw StateError(p);
        }
      });
      await admin.roster.create('new');
      await admin.roster.create('cloned', clone: 'qa');
      expect(names.keys, containsAll(['new', 'cloned']));
      await expectLater(admin.roster.create('../invalid'), rejected);
      await expectLater(admin.rename('cloned'), rejected);
      expect(writes, isEmpty);
      final archive = await admin.exportProfile();
      await admin.importProfile(archive, 'imported');
      expect(path, '/private/qa.tar.gz');
      expect(names, contains('imported'));
      await admin.rename('renamed');
      expect(names, contains('renamed'));
      expect(names, isNot(contains('qa')));
      await expectLater(admin.remove(), rejected);
      final other = await _fixture('source.invalid', 'default', 's2', names, (
        p,
        m,
        b,
        q,
      ) {
        expect(p, '/api/profiles/default');
        expect(m, 'PATCH');
        names['default'] = b['new_name'] as String;
        return {'ok': true, 'name': 'default'};
      });
      await other.rename('My agent');
      await expectLater(other.remove(), rejected);
      names['qa'] = '';
      expect(await admin.remove(), false);
      expect(names, isNot(contains('qa')));
    },
  );
  test(
    'channels patch only entered fields; pair approvals have body scope; QR never receives bot token',
    () async {
      var enabled = false, ids = '', token = false, approved = false;
      final fields = <String, dynamic>{};
      final admin = await _fixture('source.invalid', 'qa', 's', {'qa': ''}, (
        p,
        m,
        b,
        q,
      ) {
        switch (p) {
          case '/api/messaging/platforms':
            return {
              'platforms': [
                {
                  'id': 'telegram',
                  'name': 'Telegram',
                  'enabled': enabled,
                  'state': 'pending_restart',
                  'env_vars': [
                    {
                      'key': 'TELEGRAM_BOT_TOKEN',
                      'is_set': token,
                      'is_list': false,
                      'is_password': true,
                      'value': 'never project this',
                    },
                    {
                      'key': 'TELEGRAM_ALLOWED_USERS',
                      'is_set': ids.isNotEmpty,
                      'is_list': true,
                      'is_password': false,
                      'value': ids,
                    },
                  ],
                },
              ],
            };
          case '/api/messaging/platforms/telegram':
            fields.addAll(b as Map<String, dynamic>);
            enabled = b['enabled'] as bool;
            token = true;
            ids = b['env']['TELEGRAM_ALLOWED_USERS'] as String;
            return {'ok': true, 'platform': 'telegram', 'hot_served': false};
          case '/api/pairing':
            return {
              'pending': approved
                  ? []
                  : [
                      {
                        'platform': 'telegram',
                        'request_id': '0123456789abcdef',
                        'user_id': '7',
                      },
                    ],
              'approved': approved
                  ? [
                      {'platform': 'telegram', 'user_id': '7'},
                    ]
                  : [],
            };
          case '/api/pairing/approve':
            expect(b, {
              'profile': 'qa',
              'request_id': '0123456789abcdef',
              'platform': 'telegram',
            });
            approved = true;
            return {
              'ok': true,
              'user': {'user_id': '7'},
            };
          case '/api/pairing/revoke':
            expect(b, {
              'profile': 'qa',
              'user_id': '7',
              'platform': 'telegram',
            });
            approved = false;
            return {'ok': true};
          case '/api/messaging/telegram/onboarding/start':
            return {
              'pairing_id': 'qr-1',
              'qr_payload': 'https://t.me/newbot/FixtureBot/examplebot',
              'deep_link': 'https://t.me/newbot/FixtureBot/examplebot',
              'expires_at': DateTime.now()
                  .toUtc()
                  .add(const Duration(minutes: 2))
                  .toIso8601String(),
            };
          case '/api/messaging/telegram/onboarding/qr-1':
            return {
              'status': 'ready',
              'bot_username': 'examplebot',
              'owner_user_id': '7',
            };
          case '/api/messaging/telegram/onboarding/qr-1/apply':
            expect(b, {
              'profile': 'qa',
              'allowed_user_ids': ['8'],
            });
            ids = '8';
            return {'ok': true, 'platform': 'telegram', 'needs_restart': true};
          default:
            throw StateError(p);
        }
      });
      final channel = (await admin.channels()).single;
      expect(channel.fields.first.listValue, isNull);
      expect(
        await admin.updateChannel(channel, true, {
          'TELEGRAM_BOT_TOKEN': 'fixture-only',
          'TELEGRAM_ALLOWED_USERS': '7',
        }, []),
        false,
      );
      expect(fields['clear_env'], isEmpty);
      await admin.changePair((await admin.pairs()).single);
      expect(approved, true);
      await admin.changePair((await admin.pairs()).single);
      expect(approved, false);
      final setup = await admin.startTelegram('Fixture');
      await expectLater(admin.applyTelegram(setup, []), rejected);
      expect(await admin.applyTelegram(setup, ['8']), true);
    },
  );
  test(
    'signed route is scoped; duplicate create cannot silently rotate existing signing secret',
    () async {
      final hooks = <String, Map<String, Object?>>{};
      var enabled = false, count = 0;
      final admin = await _fixture('source.invalid', 'qa', 's', {'qa': ''}, (
        p,
        m,
        b,
        q,
      ) {
        if (p == '/api/webhooks/enable') {
          enabled = true;
          return {'ok': true, 'needs_restart': true};
        }
        if (m == 'GET') {
          return {'enabled': enabled, 'subscriptions': hooks.values.toList()};
        }
        if (m == 'POST') {
          count++;
          expect(b['events'], ['push']);
          expect(b['deliver'], 'telegram');
          expect(b['skills'], ['fixture']);
          hooks['ci'] = {
            'name': 'ci',
            'signature': b['signature'],
            'enabled': true,
            'url': 'https://fixture.invalid/webhooks/ci',
          };
          return {...hooks['ci']!, 'secret': 'fixture-signing-secret'};
        }
        if (m == 'PUT') {
          hooks['ci']!['enabled'] = b['enabled'];
        } else {
          hooks.remove('ci');
        }
        return {'ok': true};
      });
      expect(await admin.enableHooks(), true);
      Future<({String url, String secret})> create() => admin.createHook(
        route: 'ci',
        signature: 'github',
        events: ['push'],
        delivery: 'telegram',
        prompt: 'summarise',
        skills: ['fixture'],
      );
      expect((await create()).secret, 'fixture-signing-secret');
      await expectLater(create(), rejected);
      expect(count, 1);
      await admin.changeHook(
        (await admin.hooks()).entries.single,
        delete: false,
      );
      expect(hooks['ci']!['enabled'], false);
      await admin.changeHook(
        (await admin.hooks()).entries.single,
        delete: true,
      );
      expect(hooks, isEmpty);
    },
  );
  for (final fail in ['none', 'wrongPID', 'wrongReceipt', 'partial']) {
    test('Cloud transfer: $fail', () async {
      const host = 'fixture-only.agents.nousresearch.com',
          undo = '/private/backups/pre-transfer-2026-11-25-120000-aaaaaa.zip';
      final payload = Uint8List.fromList(List.generate(600000, (i) => i % 255));
      final uploaded = BytesBuilder();
      var replaced = false, undone = false, backupStarts = 0;
      final source = await _fixture('source.invalid', 'qa', 'src', {'qa': ''}, (
        p,
        m,
        b,
        q,
      ) {
        switch (p) {
          case '/api/cloud/agents':
            return {
              'agents': [
                {
                  'name': 'Fixture',
                  'id': 'agent-1',
                  'dashboardUrl': 'https://$host',
                  'dashboardGatewayState': 'up',
                },
                {
                  'id': 'bad',
                  'dashboardUrl': 'https://$host.invalid',
                  'name': 'Other',
                },
              ],
            };
          case '/api/ops/backup':
            backupStarts++;
            return {
              'ok': true,
              'pid': 12,
              'name': 'backup',
              'archive': '/fixture/backup.zip',
            };
          case '/api/actions/backup/status':
            return {
              'pid': fail == 'wrongPID' ? 13 : 12,
              'name': 'backup',
              'running': false,
              'exit_code': 0,
            };
          case '/api/ops/backup/chunk':
            final at = int.parse(q['offset']!),
                end = (at + int.parse(q['length']!)).clamp(0, payload.length);
            return {
              'offset': at,
              'size': payload.length,
              'done': end == payload.length,
              'data': base64Encode(payload.sublist(at, end)),
            };
          default:
            throw StateError(p);
        }
      });
      final target = await _fixture(host, 'default', 'dst', {'default': ''}, (
        p,
        m,
        b,
        q,
      ) {
        switch (p) {
          case '/api/status':
            return {'import_keep_host': 1};
          case '/api/ops/transfer/chunk':
            expect(b['offset'], uploaded.length);
            uploaded.add(base64Decode(b['data'] as String));
            return {
              'received': uploaded.length + (fail == 'wrongReceipt' ? 1 : 0),
              'upload_id': 'aaaaaaaaaaaaaaaaaaaaaaaa',
            };
          case '/api/ops/transfer/restore':
            expect(b, {
              'size': payload.length,
              'upload_id': 'aaaaaaaaaaaaaaaaaaaaaaaa',
            });
            expect(uploaded.toBytes(), payload);
            replaced = true;
            return {'ok': true, 'pid': 20, 'name': 'import', 'keep_host': true};
          case '/api/actions/import/status':
            return {
              'name': 'import',
              'pid': undone ? 21 : 20,
              'running': false,
              'exit_code': fail == 'partial' && !undone ? 1 : 0,
              'undo_archive': undo,
              'messaging_off': ['telegram'],
            };
          case '/api/ops/import':
            expect(b, {'archive': undo, 'force': true, 'keep_host': true});
            undone = true;
            return {'ok': true, 'pid': 21, 'name': 'import'};
          default:
            throw StateError(p);
        }
      });
      final row = (await source.cloudAgents()).agents.single;
      final op = await AgentTransfer.prepare(source, target, row);
      await expectLater(op.replace('wrong-id', () {}), rejected);
      expect(backupStarts, 0);
      final updates = <double?>[];
      final run = op.replace('agent-1', () => updates.add(op.fraction));
      if (fail == 'none') {
        await run;
      } else {
        await expectLater(run, rejected);
      }
      expect(backupStarts, 1);
      expect(replaced, ['none', 'partial'].contains(fail));
      expect(op.canUndo, replaced);
      if (replaced) {
        expect(updates.whereType<double>().any((v) => v > 0 && v < 1), true);
        await expectLater(op.undo('wrong-id', () {}), rejected);
        expect(undone, false);
        final reopened = await AgentTransfer.prepare(source, target, row);
        await expectLater(
          reopened.recoverUndo('not the recorded receipt'),
          rejected,
        );
        await reopened.recoverUndo(op.undoFingerprint!);
        await reopened.undo('agent-1', () {});
        expect(undone, true);
        expect(reopened.canUndo, false);
        await expectLater(op.undo('agent-1', () {}), rejected);
      }
    });
  }
  testWidgets(
    'bundle review replaces a host overlay and omits its pane identifiers',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1400);
      addTearDown(tester.view.reset);
      final dir = Directory.systemTemp.createTempSync('profile-bundle-');
      addTearDown(() => dir.deleteSync(recursive: true));
      final saved = File('${dir.path}/reviewed.tar.gz');
      FilePicker? previous;
      try {
        previous = FilePicker.platform;
      } on Object {
        previous = null;
      }
      FilePicker.platform = ProfileBundlePicker(saved);
      addTearDown(() {
        if (previous != null) FilePicker.platform = previous;
      });
      const archive = '/private/profile-exports/qa-20261125-120000.tar.gz';
      final foreign = jsonEncode({
        'version': 1,
        'skin': 'catppuccin',
        'mode': 'dark',
        'layoutTree': {
          'type': 'group',
          'id': 'foreign',
          'panes': ['private-session'],
          'active': 'private-session',
        },
      });
      final hosted = gzip.encode(
        TarEncoder().encodeBytes(
          Archive()
            ..addFile(ArchiveFile.string('qa/desktop.json', foreign))
            ..addFile(ArchiveFile.string('qa/SOUL.md', 'persona')),
        ),
      );
      final admin = await _fixture(
        'source.invalid',
        'qa',
        'src',
        {'qa': ''},
        (path, method, body, query) {
          expect(path, '/api/profiles/qa/export');
          return {'ok': true, 'archive': archive};
        },
        binary: (req) async {
          if (req.url.path != '/api/files/download') return null;
          expect(req.url.queryParameters, {'path': archive});
          return http.Response.bytes(hosted, 200);
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          home: ProfileBundleScreen(
            admin: admin,
            gateway: 'Fixture',
            connection: SavedConnection(
              id: 'ui-fixture',
              label: 'Fixture',
              host: '127.0.0.1',
              port: 9,
              apiKey: '',
              gatewayProfile: 'qa',
            ),
            nextGen: false,
          ),
        ),
      );
      await tester.tap(find.text('Prepare profile export'));
      await _shown(tester, find.text('desktop.json'));
      expect(find.textContaining('private-session'), findsNothing);
      await tester.ensureVisible(find.text('desktop.json'));
      await tester.tap(find.text('desktop.json'));
      await tester.pumpAndSettle();
      expect(find.textContaining('ares-gold'), findsOneWidget);
      await _checkTile(tester, 'Include this reviewed file');
      await tester.ensureVisible(find.text('Save selected files to device'));
      // Linux saves through real file I/O and a chmod subprocess. Start that
      // work outside the widget binding's fake async zone; longer fake-clock
      // polling cannot complete a process launched inside that zone.
      await tester.runAsync(() async {
        await tester.tap(
          find.text('Save selected files to device').hitTestable(),
        );
      });
      await _shown(tester, find.text('Profile bundle saved.'));
      if (Platform.isLinux) {
        expect(saved.statSync().mode & 0x1ff, 0x180); // private mode 0600
      }
      final reviewed = await PortableProfileBundle.inspect(
        saved.readAsBytesSync(),
      );
      expect(reviewed.files.keys, ['desktop.json']);
      expect(reviewed.files['desktop.json'], contains('ares-gold'));
      expect(
        reviewed.files['desktop.json'],
        isNot(contains('private-session')),
      );
      expect(reviewed.files['desktop.json'], isNot(contains('persona')));
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
  for (final confirmed in [true, false]) {
    testWidgets(
      confirmed
          ? 'import applies the reviewed appearance only after the gateway confirms it'
          : 'a substituted import receipt does not change this device',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(800, 1600);
        addTearDown(tester.view.reset);
        final dir = Directory.systemTemp.createTempSync('profile-import-');
        addTearDown(() => dir.deleteSync(recursive: true));
        final incoming = File('${dir.path}/incoming.tar.gz');
        incoming.writeAsBytesSync(
          gzip.encode(
            TarEncoder().encodeBytes(
              Archive()..addFile(
                ArchiveFile.string(
                  'qa/desktop.json',
                  jsonEncode({
                    'version': 1,
                    'skin': 'catppuccin',
                    'mode': 'dark',
                    'profileColor': '#123456',
                    'customCSS':
                        'body{background:url(https://fixture.invalid)}',
                    'layoutTree': {
                      'type': 'split',
                      'id': 'foreign-layout',
                      'orientation': 'column',
                      'weights': [1, 1],
                      'children': [
                        {
                          'type': 'group',
                          'id': 'one',
                          'panes': ['private-session'],
                          'active': 'private-session',
                        },
                        {
                          'type': 'group',
                          'id': 'two',
                          'panes': ['plugin.secret'],
                          'active': 'plugin.secret',
                        },
                      ],
                    },
                  }),
                ),
              ),
            ),
          ),
        );
        FilePicker? previous;
        try {
          previous = FilePicker.platform;
        } on Object {
          previous = null;
        }
        FilePicker.platform = ProfileBundlePicker(incoming);
        addTearDown(() {
          if (previous != null) FilePicker.platform = previous;
        });
        Object? reviewed;
        const staged =
            '/fixture/qa/uploads/web-aaaaaaaaaaaaaaaa-profile.tar.gz';
        final names = {'qa': ''};
        final admin = await _fixture(
          'source.invalid',
          'qa',
          'src',
          names,
          (path, method, body, query) {
            expect(path, '/api/profiles/import');
            expect(body, {'archive': staged, 'name': 'received'});
            names['received'] = '';
            return {
              'ok': true,
              'name': 'received',
              'desktop': confirmed
                  ? reviewed
                  : {'version': 1, 'skin': 'mono', 'mode': 'light'},
            };
          },
          binary: (req) async {
            if (req.url.path != '/api/chat/file-upload') return null;
            final raw = latin1.decode(req.bodyBytes);
            final start = raw.indexOf('\r\n\r\n') + 4;
            final end = raw.lastIndexOf('\r\n--');
            final payload = Uint8List.fromList(
              latin1.encode(raw.substring(start, end)),
            );
            final bundle = await PortableProfileBundle.inspect(payload);
            final overlay = bundle.files['desktop.json']!;
            expect(overlay, isNot(contains('private-session')));
            expect(overlay, isNot(contains('plugin.secret')));
            expect(overlay, isNot(contains('fixture.invalid')));
            expect(overlay, contains('catppuccin'));
            reviewed = jsonDecode(overlay);
            return http.Response(
              jsonEncode({
                'ok': true,
                'path': staged,
                'size': payload.length,
                'staged_upload': {
                  'install_id': 'src',
                  'path': staged,
                  'profile_home': '/fixture/qa',
                },
              }),
              200,
            );
          },
        );
        final connection = SavedConnection(
          id: 'ui-fixture',
          label: 'Fixture',
          host: '127.0.0.1',
          port: 9,
          apiKey: '',
          gatewayProfile: 'qa',
        );
        await tester.pumpWidget(
          MaterialApp(
            home: ProfileBundleScreen(
              admin: admin,
              gateway: 'Fixture',
              connection: connection,
              nextGen: false,
            ),
          ),
        );
        await tester.tap(find.text('Open .tar.gz from this device'));
        await _shown(tester, find.text('desktop.json'));
        expect(find.textContaining('private-session'), findsNothing);
        expect(find.textContaining('plugin.secret'), findsNothing);
        await tester.ensureVisible(find.text('desktop.json'));
        await tester.tap(find.text('desktop.json'));
        await tester.pumpAndSettle();
        expect(find.textContaining('catppuccin'), findsOneWidget);
        await _checkTile(tester, 'Include this reviewed file');
        await _checkTile(
          tester,
          'Apply appearance to the new profile on this device',
        );
        await tester.enterText(find.byType(TextField), 'received');
        await tester.ensureVisible(find.text('Import selected files'));
        await tester.tap(find.text('Import selected files').hitTestable());
        await _shown(
          tester,
          find.textContaining(
            confirmed ? 'Appearance applied' : 'did not confirm',
          ),
        );
        final store = ProfilePresentationStore(
          await SharedPreferences.getInstance(),
        );
        final installed = store.read(
          connection.copyWith(gatewayProfile: 'received'),
        );
        if (confirmed) {
          expect(
            find.textContaining('Appearance applied on this device.'),
            findsOneWidget,
          );
          expect(installed!.style.skin, 'catppuccin');
          expect(installed.style.mode, ThemeMode.dark);
          expect(installed.style.geometry, (
            paired: true,
            stacked: true,
            percent: 50,
          ));
        } else {
          expect(find.textContaining('did not confirm'), findsOneWidget);
          expect(installed, isNull);
        }
        expect(store.read(connection), isNull);
        final prefs = await SharedPreferences.getInstance();
        expect(
          prefs.getKeys().map((key) => prefs.get(key)).join(),
          isNot(contains('private-session')),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  }
}
