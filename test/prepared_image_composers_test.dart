import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/prepared_image_store.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'normal_gateway_alias_handoff_wire_test.dart' show widgetUntil;
import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';
import 'support/strict_nextgen_gateway.dart';

class _Paths extends PathProviderPlatform {
  _Paths(this.dir);
  final Directory dir;
  @override
  Future<String?> getApplicationSupportPath() async => dir.path;
  @override
  Future<String?> getTemporaryPath() async => dir.path;
}

class _Peer {
  _Peer(this.http);
  final HttpServer http;
  final sockets = <WebSocket>[];
  final prompts = <Map>[];
  final uploads = <String>[];
  bool ack = false;
  SavedConnection get connection => SavedConnection(
    id: 'image-test',
    label: 'fixture',
    host: '127.0.0.1',
    port: http.port,
    apiKey: 'fixture',
    dashboardProxied: true,
    dashboardPortOverride: http.port,
  );
  Future<void> handle(HttpRequest request) async {
    if (!WebSocketTransformer.isUpgradeRequest(request)) {
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode(
          request.uri.path.endsWith('ws-ticket')
              ? {'ticket': 'fixture'}
              : {'data': []},
        ),
      );
      await request.response.close();
      return;
    }
    final ws = await WebSocketTransformer.upgrade(request);
    sockets.add(ws);
    ws.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'method': 'event',
        'params': {'type': 'gateway.ready', 'payload': {}},
      }),
    );
    ws.listen((raw) {
      if (ws.readyState != WebSocket.open) return;
      final f = jsonDecode(raw as String) as Map;
      final p = f['params'] as Map? ?? {};
      Object result = {};
      switch (f['method']) {
        case 'session.resume':
          result = {
            'session_id': 'runtime',
            'stored_session_id': 'stored',
            'running': false,
            'status': 'idle',
          };
        case 'file.attach':
          uploads.add(p['data_url'] as String);
          result = {'attached': true, 'ref_text': '@file:/fixture/ref'};
        case 'prompt.submit':
          prompts.add(Map.of(p));
          result = {
            'session_id': 'runtime',
            'submission_id': ack ? p['submission_id'] : 'wrong',
            'status': 'queued',
          };
        case 'config.get':
          result = {'config': {}};
      }
      ws.add(jsonEncode({'jsonrpc': '2.0', 'id': f['id'], 'result': result}));
      if (f['method'] == 'prompt.submit' && ack) {
        ws.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'method': 'event',
            'params': {
              'type': 'turn.end',
              'session_id': 'runtime',
              'payload': {},
            },
          }),
        );
      }
    });
  }

  Future<void> close() async {
    for (final ws in sockets) {
      await ws.close();
    }
    await http.close(force: true);
  }
}

class _Ng extends NextGenGateway {
  _Ng(super.connection);
  @override
  bool get sessionAuthority => true;
  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);
  final prompts = <Map>[];

  /// On an authority gateway the call goes through the client's guard and
  /// the strict contract check, as the real socket does.
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) => sessionAuthority
      ? strictCall(this, method, params, _answer)
      : _answer(method, params);

  Future<Map<String, dynamic>> _answer(
    String method,
    Map<String, dynamic> params,
  ) async {
    if (method == 'prompt.submit') {
      prompts.add(Map.of(params));
      return {'submission_id': params['submission_id'], 'status': 'started'};
    }
    if (method == 'image.attach_bytes') {
      return {'attached': true, 'path': '/new/path', 'mime': 'image/png'};
    }
    return {};
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;
  late PathProviderPlatform old;
  late HttpOverrides? overrides;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    root = await Directory.systemTemp.createTemp('composer-wire-');
    old = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _Paths(root);
    overrides = HttpOverrides.current;
    HttpOverrides.global = null;
  });
  tearDown(() async {
    HttpOverrides.global = overrides;
    PathProviderPlatform.instance = old;
    await root.delete(recursive: true);
  });
  for (final mode in [
    'classic-empty',
    'nextgen-empty',
    'classic-first',
    'classic-restore',
    'nextgen-restore',
    'classic-edited',
    'nextgen-edited',
  ]) {
    testWidgets('$mode: real composer tap and stock submission identity', (
      t,
    ) async {
      mockChatImageRecovery();
      await t.binding.setSurfaceSize(const Size(900, 1200));
      addTearDown(() => t.binding.setSurfaceSize(null));
      final peer = (await t.runAsync(() async {
        final p = _Peer(await HttpServer.bind(InternetAddress.loopbackIPv4, 0));
        p.http.listen(p.handle);
        return p;
      }))!;
      final c = GatewayTurnApplicationController();
      final g = _Ng(peer.connection);
      final ng = NgChatController(g, sessionId: 'stored')
        ..runtimeId = 'runtime';
      addTearDown(() async {
        ng.dispose();
        g.dispose();
        await c.close();
        await peer.close();
      });
      final classic = mode.startsWith('classic'),
          empty = mode.endsWith('empty'),
          restore = !mode.endsWith('first') && !mode.endsWith('empty'),
          edited = mode.endsWith('edited');
      final target = PreparedImageTarget(
        peer.connection,
        'stored',
        classic
            ? PreparedImageTransport.classicRefs
            : PreparedImageTransport.nextgenCanonical,
      );
      final png = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+j4L8AAAAASUVORK5CYII=',
      );
      final f = await t.runAsync(
        () => File('${root.path}/source.png').writeAsBytes(png),
      );
      final image = AttachmentDraft(
        id: 'image',
        cachedPath: f!.path,
        name: 'photo.png',
        byteLength: png.length,
        mediaType: 'image/png',
        kind: AttachmentDraftKind.image,
        sanitized: true,
      );
      const caption = '  My image  ';
      const ref = 'My image\n\n@file:/fixture/ref';
      PreparedImageAttempt? prepared;
      if (restore) {
        prepared = await t.runAsync(() async {
          final s = PreparedImageStore.shared;
          final cap = await s.capture([image]);
          final result = await s.prepare(
            target,
            caption,
            cap,
            prompt: classic ? ref : caption.trim(),
            wireImages: classic
                ? []
                : [
                    {'path': '/frozen/path', 'mime': 'image/png'},
                  ],
          );
          await f.delete();
          return result;
        });
      }
      peer.ack = restore;
      await t.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          home: classic
              ? ChatScreen(
                  connection: peer.connection,
                  session: const Session(
                    id: 'stored',
                    title: 'Fixture',
                    model: 'fixture',
                    source: 'test',
                    messageCount: 1,
                    isActive: false,
                    preview: '',
                    startedAt: 1,
                  ),
                  turnApplicationController: c,
                  testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
                  initialAttachmentDrafts: restore || empty ? [] : [image],
                  initialComposerText: restore || empty ? null : caption,
                )
              : NgScope(
                  connManager: ConnectionManager(
                    await SharedPreferences.getInstance(),
                  ),
                  gateway: g,
                  connections: [g.connection],
                  switchTo: (_) async {},
                  addGateway: () async {},
                  signOut: (_) async {},
                  reload: () async {},
                  signInAgain: () async {},
                  child: Scaffold(
                    body: NgChatView(
                      chat: ng,
                      onOpenSidebar: () {},
                      onNewChat: () {},
                    ),
                  ),
                ),
        ),
      );
      if (empty) {
        await pumpChatUpdates(t);
        for (var i = 0; i < 30; i++) {
          await t.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 5)),
          );
          await t.pump();
        }
        expect(find.text('Recover image draft…'), findsNothing);
        expect(find.byType(TextField), findsWidgets);
        await t.pumpWidget(const SizedBox());
        await c.close();
        await t.pump(const Duration(minutes: 1));
        return;
      }
      final field = find.byType(TextField).first;
      String text() => t.widget<TextField>(field).controller!.text;
      final calls = classic ? peer.prompts : g.prompts;
      if (restore) {
        await widgetUntil(
          t,
          () => find.text('Recover image draft…').evaluate().isNotEmpty,
        );
        expect(text(), isEmpty);
        await t.tap(find.text('Recover image draft…'));
        await widgetUntil(
          t,
          () => find.text('Unacknowledged image drafts').evaluate().isNotEmpty,
        );
        await t.pump(const Duration(milliseconds: 400));
        await t.tap(find.text(caption));
        await widgetUntil(t, () => text() == caption);
        await t.pump(const Duration(milliseconds: 400));
        expect(calls, isEmpty);
        if (edited) {
          await t.enterText(field, 'Edited');
          await t.pump();
        }
      }
      await t.tap(find.byTooltip('Send'));
      await widgetUntil(t, () => calls.isNotEmpty);
      expect(calls, hasLength(1));
      final visible = edited ? 'Edited' : 'My image';
      expect(
        calls.single['text'],
        classic ? '$visible\n\n@file:/fixture/ref' : visible,
      );
      if (edited) {
        expect(calls.single['submission_id'], isNot(prepared!.id));
        if (classic) {
          expect(peer.uploads, hasLength(1));
        } else {
          expect(calls.single['attachments'], [
            {'path': '/new/path', 'mime': 'image/png'},
          ]);
        }
      } else if (restore) {
        expect(calls.single['submission_id'], prepared!.id);
        expect(peer.uploads, isEmpty);
        if (!classic) {
          expect(calls.single['attachments'], [
            {'path': '/frozen/path', 'mime': 'image/png'},
          ]);
        }
      } else {
        final entry = (await t.runAsync(
          () => PreparedImageStore.shared.list(target),
        ))!.single;
        expect(entry.id, calls.single['submission_id']);
        expect(entry.text, caption);
        expect(entry.prompt, ref);
        final recovered = await t.runAsync(() async {
          final drafts = (await PreparedImageStore.shared.restore(
            entry,
            () => true,
          ))!;
          return File(drafts.single.cachedPath).readAsBytes();
        });
        expect(
          recovered,
          png,
          reason: 'Classic upload cleanup must not consume the recovery bytes',
        );
        expect(
          peer.uploads.single,
          'data:image/png;base64,${base64Encode(png)}',
        );
      }
      if (restore) {
        // A received frame isn't the persisted ACK. Let the real receipt
        // handler retire its journal and release the socket waiter first.
        for (var i = 0; i < 100; i++) {
          await t.pump();
          final entries = await t.runAsync(
            () => PreparedImageStore.shared.list(target),
          );
          if (entries!.every((e) => e.id != calls.single['submission_id'])) {
            break;
          }
          await t.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 5)),
          );
        }
        expect(
          await t.runAsync(
            () async => (await PreparedImageStore.shared.list(
              target,
            )).map((e) => e.id).toList(),
          ),
          edited ? [prepared!.id] : isEmpty,
        );
        if (classic) {
          await widgetUntil(
            t,
            () =>
                c
                    .normalSessionFor(peer.connection)
                    .findChat('stored')
                    ?.snapshot
                    .hasActiveTurn ==
                false,
          );
        }
      }
      await t.pumpWidget(const SizedBox());
      await t.pump();
      await c.close();
      await t.pump(const Duration(minutes: 1));
    });
  }
}
