import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/attachment_draft_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/local_voice_recorder.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_hands_free_voice.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/mtls_fixture.dart';
import 'support/pump_chat_updates.dart';
import 'support/strict_authority_gateway.dart';

class _IdleRecorder implements VoiceRecorder {
  @override
  Future<void> close() async {}
  @override
  Future<void> discard() async {}
  @override
  Future<Duration> get duration async => Duration.zero;
  @override
  Future<bool> hasPermission({bool request = false}) async => false;
  @override
  Future<void> pause() async {}
  @override
  Future<String> get path async => '';
  @override
  Future<void> play(void Function() onComplete) async {}
  @override
  Future<String> prepareForSend() async => '';
  @override
  Future<void> resumeRecording() async {}
  @override
  Future<bool> restore() async => false;
  @override
  Future<void> start() async {}
  @override
  Future<void> stop() async {}
}

class _Servers {
  late HttpServer owner, guest;
  final peers = <WebSocket>[];
  final calls = <String>[];
  final replies = <String, Map>{};
  final requests = <String>[];
  String? sessionCookie, sessionProfile;
  bool guestSawCredential = false;
  String get site => 'http://127.0.0.1:${guest.port}';
  Future<void> start() async {
    owner = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    guest = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    guest.listen((r) async {
      requests.add(r.uri.path);
      if (r.headers['cookie'] != null || r.headers['authorization'] != null) {
        guestSawCredential = true;
      }
      r.response.headers.contentType = ContentType.html;
      r.response.write(
        '<h1>Painted ${r.uri.path}</h1><p>A session-owned page</p><a href="/second">Second page</a>',
      );
      await r.response.close();
    });
    owner.listen((r) async {
      final p = r.uri.path;
      if (p == '/api/ws') {
        final ws = await WebSocketTransformer.upgrade(r);
        peers.add(ws);
        ws.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'method': 'event',
            'params': {
              'type': 'gateway.ready',
              'payload': {'replay_epoch': 'test', 'session_authority': true},
            },
          }),
        );
        ws.listen((raw) {
          final f = jsonDecode(raw) as Map;
          if (f['method'] == null) {
            replies[f['id']] = f;
            return;
          }
          calls.add(f['method']);
          final refused = strictAuthorityFrame(f);
          if (refused != null) {
            ws.add(refused);
            return;
          }
          ws.add(
            jsonEncode({
              'jsonrpc': '2.0',
              'id': f['id'],
              'result': f['method'] == 'session.resume'
                  ? {
                      'session_id': 'runtime',
                      'stored_session_id': 'stored',
                      'info': {'profile_name': 'work'},
                    }
                  : {},
            }),
          );
        });
        return;
      }
      var result = <String, Object?>{};
      if (p == '/auth/password-login') {
        r.response.cookies.add(Cookie('hermes_session_at', 'fixture'));
      }
      if (p == '/api/auth/ws-ticket') result = {'ticket': 'fixture'};
      if (p == '/api/sessions/stored') {
        sessionCookie = r.headers.value('cookie');
        sessionProfile = r.uri.queryParameters['profile'];
        result = {'id': 'stored', 'profile': 'work'};
      }
      if (p.endsWith('/messages')) result = {'messages': [], 'data': []};
      r.response.headers.contentType = ContentType.json;
      r.response.write(jsonEncode(result));
      await r.response.close();
    });
  }

  bool _closed = false;
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    for (final ws in peers) {
      await ws.close();
    }
    await guest.close(force: true);
    await owner.close(force: true);
  }

  void ask(String id, String method, String runtime, {String? action}) {
    peers.last.add(
      jsonEncode({
        'jsonrpc': '2.0',
        'id': id,
        'method': method,
        'params': {'session_id': runtime, 'action': ?action},
      }),
    );
  }
}

void main() {
  setUp(mockChatImageRecovery);
  // 390 is a phone: the app bar keeps from overflowing by moving the browser
  // preview into More chat tools.
  for (final (classic, width) in [
    (true, 480.0),
    (true, 390.0),
    (false, 1240.0),
  ]) {
    testWidgets(
      '${classic ? 'Classic narrow' : 'NextGen wide'} at $width: real chat → authorised preview → rendered comment and crop in draft',
      (t) async {
        SharedPreferences.setMockInitialValues({});
        t.view.devicePixelRatio = 1;
        t.view.physicalSize = Size(width, 960);
        addTearDown(t.view.reset);
        final servers = _Servers();
        late final Directory dir;
        await t.runAsync(() async {
          await servers.start();
          dir = await Directory.systemTemp.createTemp('preview-crops');
        });
        addTearDown(servers.close);
        addTearDown(() => dir.delete(recursive: true));
        final service = AttachmentDraftService(
          cacheDirectoryProvider: () async => dir,
        );
        final c = SavedConnection(
          id: 'fixture-$classic',
          label: 'Fixture',
          host: '127.0.0.1',
          port: servers.owner.port,
          apiKey: '',
          desktopGatewayUrl: 'http://127.0.0.1:${servers.owner.port}',
          dashboardPortOverride: servers.owner.port,
          dashboardUsername: 'fixture',
          dashboardPassword: 'fixture',
          gatewayProfile: 'work',
        );
        final manager = ConnectionManager(
          (await t.runAsync(SharedPreferences.getInstance))!,
        );
        final controller = GatewayTurnApplicationController();
        DesktopGatewayClient? desktop;
        NextGenGateway? gateway;
        NgChatController? ng;
        var released = false;
        void releaseClients() {
          if (released) return;
          released = true;
          desktop?.close();
          ng?.dispose();
          gateway?.dispose();
        }

        addTearDown(controller.close);
        addTearDown(releaseClients);
        Future<void> until(bool Function() ready, String hint) async {
          final clock = Stopwatch()..start();
          while (!ready() && clock.elapsed < const Duration(seconds: 15)) {
            await t.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 8)),
            );
            await t.pump(const Duration(milliseconds: 20));
          }
          expect(
            ready(),
            true,
            reason:
                'Waiting for $hint. Visible: ${find.byType(Text).evaluate().map((e) => (e.widget as Text).data).whereType<String>().take(24).join(' | ')}',
          );
        }

        Future<void> tap(Finder f) async {
          await t.tap(f);
          await t.pump();
        }

        // A phone-width pane offers the preview from More chat tools.
        Future<void> openPreview() async {
          if (find.byTooltip('Open browser preview').evaluate().isNotEmpty) {
            return tap(find.byTooltip('Open browser preview'));
          }
          // tap() pumps the frame that starts the menu animation; the next
          // pump completes it. Settling would run the fixture clocks.
          await tap(find.byTooltip('More chat tools'));
          await t.pump(const Duration(milliseconds: 400));
          await tap(find.text('Open browser preview'));
          await t.pump(const Duration(milliseconds: 400));
        }

        Future<void> shown(String text) =>
            until(() => find.text(text).evaluate().isNotEmpty, text);

        await withPlatformTrust(() async {
          gateway = NextGenGateway(c);
          ng = NgChatController(
            gateway!,
            sessionId: 'stored',
            attachmentService: service,
          );
          if (!classic) {
            await t.runAsync(() async {
              await gateway!.connected();
              await gateway!.call('session.resume', {'session_id': 'stored'});
            });
          }
          final composer = find.byKey(
            Key(classic ? 'chat-message-composer' : 'ng-composer-field'),
          );
          await t.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: classic
                  ? hermesTheme(Brightness.dark)
                  : nextGenTheme(Brightness.dark, NextGenLook.instance),
              home: classic
                  ? ChatScreen(
                      connection: c,
                      session: Session.fromJson({
                        'id': 'stored',
                        'title': 'Test',
                        'source': 'desktop',
                        'started_at': 1700000000,
                      }),
                      testAttachmentDraftService: service,
                      testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
                      testVoiceRecorder: _IdleRecorder(),
                      testHandsFreePlatform: FakeHandsFreeVoicePlatform(),
                      testVoiceReplySpeaker: FakeVoiceReplySpeaker(),
                      testDesktopGateway: (gateway) => desktop = gateway,
                      turnApplicationController: controller,
                      initialComposerText: 'Keep me',
                    )
                  : NgScope(
                      connManager: manager,
                      gateway: gateway!,
                      connections: [c],
                      switchTo: (_) async {},
                      addGateway: () async {},
                      signOut: (_) async {},
                      reload: () async {},
                      signInAgain: () async {},
                      child: NgChatView(chat: ng!),
                    ),
            ),
          );
          await t.pump();
          if (!classic) await t.enterText(composer, 'Keep me');
          await openPreview();
          final address = find.byKey(const Key('preview-address'));
          await until(() {
            final fields = t.widgetList<TextField>(address);
            return fields.length == 1 && fields.single.enabled == true;
          }, 'owner bind');
          expect(servers.sessionCookie, 'hermes_session_at=fixture');
          expect(servers.sessionProfile, 'work');
          await t.enterText(address, '${servers.site}/first');
          await tap(find.byTooltip('Go to address'));
          await shown('Open site');
          expect(servers.requests, isEmpty);
          await tap(find.text('Open site'));
          await until(
            () => find.text('Painted /first').evaluate().isNotEmpty,
            'reader document',
          );
          expect(servers.guestSawCredential, isFalse);
          await tap(find.text('Second page'));
          await until(
            () => find.text('Painted /second').evaluate().isNotEmpty,
            'same-origin link',
          );
          await tap(find.byTooltip('Back'));
          await until(
            () => find.text('Painted /first').evaluate().isNotEmpty,
            'history back',
          );
          if (!classic) {
            await tap(find.byTooltip('Share page with Hermes'));
            await shown('Share page');
            await tap(find.text('Share page'));
            await until(
              () => find.byTooltip('Stop sharing page').evaluate().isNotEmpty,
              'share grant',
            );
            servers.ask('srq-ok', 'preview.read', 'runtime');
            servers.ask('srq-deny', 'preview.read', 'another');
            servers.ask('srq-vault', 'preview.act', 'runtime', action: 'vault');
            await until(() => servers.replies.length == 3, 'wire replies');
            expect(
              servers.replies['srq-ok']!['result']['value'],
              contains('Painted /first'),
            );
            expect(servers.replies['srq-deny']!['error'], isNotNull);
            expect(servers.replies['srq-vault']!['error'], isNotNull);
          }
          await tap(find.byTooltip('Hide preview'));
          await openPreview();
          expect(find.text('Painted /first'), findsOneWidget);
          await tap(find.byTooltip('Annotate element or region'));
          await t.pump();
          if (classic) {
            await t.tapAt(t.getCenter(find.text('Painted /first')));
          } else {
            await t.dragFrom(
              t.getTopLeft(
                    find.byKey(const Key('preview-annotation-surface')),
                  ) +
                  const Offset(12, 12),
              const Offset(150, 80),
            );
          }
          await t.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 40)),
          );
          await shown('Keep pin');
          await t.enterText(
            find.widgetWithText(TextField, 'Note'),
            'Review this heading',
          );
          await tap(find.text('Keep pin'));
          await shown('Add 1 to draft');
          await tap(find.text('Add 1 to draft'));
          await until(() {
            final fields = t.widgetList<TextField>(composer);
            return fields.isNotEmpty &&
                (fields.first.controller?.text.contains(
                      'Review these comments',
                    ) ??
                    false);
          }, 'composer handoff');
          expect(
            t.widget<TextField>(composer).controller!.text,
            contains('Review this heading'),
          );
          expect(servers.calls.where((m) => m.startsWith('prompt.')), isEmpty);
          final files = (await t.runAsync(
            () => dir.list().where((e) => e is File).toList(),
          ))!;
          expect(files, hasLength(1));
          expect(
            await t.runAsync(() => (files.single as File).length()),
            greaterThan(64),
          );
          await openPreview();
          final lease = ConnectionMutationBarrier.begin([c.id]);
          lease.release();
          await t.pump();
          expect(find.text('Painted /first'), findsNothing);
          await t.pumpWidget(const SizedBox());
          await t.pump();
          await t.runAsync(() async {
            releaseClients();
            await servers.close();
          });
        });
      },
    );
  }
}
