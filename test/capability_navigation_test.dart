import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/more_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/mtls_fixture.dart';

void main() {
  for (final classic in [true, false]) {
    testWidgets(
      '${classic ? 'Classic' : 'NextGen'} More opens capability controls',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(480, 1200);
        addTearDown(tester.view.reset);
        final locks = <Object?>[];
        final rpc = <String>[];
        var skillLocked = false;
        late HttpServer server;
        final sockets = <WebSocket>[];
        await tester.runAsync(() async {
          server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
          server.listen((req) async {
            final response = req.response;
            if (req.uri.path == '/auth/password-login') {
              response.cookies.add(
                Cookie('hermes_session_at', 'fixture-cookie'),
              );
              response.write('{}');
            } else if (req.uri.path == '/api/auth/ws-ticket') {
              response.write('{"ticket":"fixture-ticket"}');
            } else if (req.uri.path == '/api/ws') {
              final ws = await WebSocketTransformer.upgrade(req);
              sockets.add(ws);
              ws.add(
                jsonEncode({
                  'jsonrpc': '2.0',
                  'method': 'event',
                  'params': {
                    'type': 'gateway.ready',
                    'payload': {'replay_epoch': 'fixture'},
                  },
                }),
              );
              ws.listen((raw) {
                final frame = jsonDecode(raw as String) as Map;
                final method = frame['method'];
                if (method is String) rpc.add(method);
                ws.add(
                  jsonEncode({
                    'jsonrpc': '2.0',
                    'id': frame['id'],
                    'result': _rpcResult(method),
                  }),
                );
              });
              return;
            } else if (req.uri.path == '/api/skills' && req.method == 'GET') {
              response.write(
                jsonEncode([
                  {
                    'name': 'fixture-skill',
                    'description': 'A fixture skill',
                    'enabled': true,
                    'locked': skillLocked,
                    'provenance': 'agent',
                  },
                ]),
              );
            } else if (req.uri.path == '/api/skills/lock') {
              final body =
                  jsonDecode(await utf8.decoder.bind(req).join()) as Map;
              locks.add(body);
              skillLocked = body['locked'] == true;
              response.write('{"ok":true}');
            } else if (req.uri.path == '/api/config') {
              response.write(
                jsonEncode({
                  'ok': true,
                  'approvals': {
                    'mode': 'manual',
                    'timeout': 30,
                    'mcp_reload_confirm': true,
                  },
                  'command_allowlist': ['git status'],
                  'checkpoints': {'enabled': false, 'max_snapshots': 5},
                  'browser': {
                    'allow_private_urls': false,
                    'use_real_profile': false,
                  },
                }),
              );
            } else {
              response.write('{}');
            }
            await response.close();
          });
        });
        final connection = SavedConnection(
          id: 'fixture',
          label: 'Fixture gateway',
          host: '127.0.0.1',
          port: server.port,
          apiKey: '',
          dashboardPortOverride: server.port,
          desktopGatewayUrl: 'http://127.0.0.1:${server.port}',
          dashboardUsername: 'fixture',
          dashboardPassword: 'fixture',
          gatewayProfile: 'work',
        );
        NextGenGateway? gateway;
        final preferences = await SharedPreferences.getInstance();
        addTearDown(() async {
          gateway?.dispose();
          for (final socket in sockets) {
            await socket.close();
          }
          await server.close(force: true);
        });

        Future<void> waitFor(Finder finder) async {
          final clock = Stopwatch()..start();
          while (finder.evaluate().isEmpty &&
              clock.elapsed < const Duration(seconds: 8)) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 20)),
            );
            await tester.pump(const Duration(milliseconds: 40));
          }
          expect(
            finder,
            findsWidgets,
            reason: tester
                .widgetList<Text>(find.byType(Text))
                .map((text) => text.data)
                .whereType<String>()
                .join(' | '),
          );
        }

        await withPlatformTrust(() async {
          if (!classic) gateway = NextGenGateway(connection);
          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: classic
                  ? hermesTheme(Brightness.dark)
                  : nextGenTheme(Brightness.dark, NextGenLook.instance),
              builder: (context, child) => classic
                  ? child!
                  : NgLocalizationScope(
                      child: NgScope(
                        connManager: ConnectionManager(preferences),
                        gateway: gateway!,
                        connections: [connection],
                        switchTo: (_) async {},
                        addGateway: () async {},
                        signOut: (_) async {},
                        reload: () async {},
                        signInAgain: () async {},
                        child: child!,
                      ),
                    ),
              home: classic
                  ? WorkspaceScreen(
                      connection: connection,
                      sessionsLoader: () async => [],
                    )
                  : NgMorePage(onOpenSession: (_) {}),
            ),
          );
          await tester.pump();
          if (classic) {
            await waitFor(find.text('More'));
            await tester.tap(find.text('More').last);
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));
            final menu = find.byType(Scrollable).last;
            await tester.scrollUntilVisible(
              find.text('Capabilities'),
              240,
              scrollable: menu,
            );
          }
          await tester.tap(find.text('Capabilities').first);
          await tester.pump();
          await waitFor(find.text('fixture-skill'));
          await tester.tap(find.byKey(const Key('skill-lock-fixture-skill')));
          await waitFor(find.byTooltip('Unlock'));
          expect(locks, [
            {'name': 'fixture-skill', 'locked': true},
          ]);
          expect(locks.toString(), isNot(contains('fixture-password')));

          await tester.pageBack();
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text('Browser vault').first);
          await tester.tap(find.text('Browser vault').first);
          await tester.pump();
          await waitFor(find.text('Fixture login'));
          expect(find.text('fixture-password'), findsNothing);
          expect(rpc, contains('vault.list'));
          await tester.pumpWidget(const SizedBox());
          gateway?.dispose();
          gateway = null;
          await tester.runAsync(() async {
            for (final socket in sockets) {
              await socket.close();
            }
          });
          await tester.pump(const Duration(seconds: 6));
        });
      },
    );
  }
}

Object _rpcResult(Object? method) {
  if (method == 'vault.list') {
    return {
      'items': [
        {
          'id': 'vault-1',
          'kind': 'login',
          'label': 'Fixture login',
          'origin': 'https://fixture.example',
        },
      ],
    };
  }
  if (method == 'vault.sources') return {'sources': <Object?>[]};
  return <String, Object?>{};
}
