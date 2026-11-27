import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/widgets/more_pane.dart';
import 'package:hermes_android/core/workspace/profile_presentation_store.dart';
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
      '${classic ? 'Classic' : 'NextGen'} More opens and refreshes this gateway roster',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(480, 1000);
        addTearDown(tester.view.reset);
        late HttpServer server;
        final sockets = <WebSocket>[];
        final rosterCalls = <Object?>[];
        var tickets = 0;
        var persona = 'Initial fixture persona';
        final soulRequests = <String>[];
        final backupRequests = <String>[];
        await tester.runAsync(() async {
          server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
          server.listen((req) async {
            final response = req.response;
            if (req.uri.path == '/auth/password-login') {
              response.cookies.add(
                Cookie('hermes_session_at', 'fixture-cookie'),
              );
              response.write('{}');
            } else if (req.uri.path == '/api/auth/ws-ticket' &&
                req.headers.value('cookie') ==
                    'hermes_session_at=fixture-cookie') {
              tickets++;
              response.write('{"ticket":"fixture-ticket"}');
            } else if (req.uri.path == '/api/ws' &&
                !req.uri.hasQuery &&
                (req.headers.value('sec-websocket-protocol') ?? '').contains(
                  'hermes-gateway-ticket.fixture-ticket',
                )) {
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
                final roster = frame['method'] == 'profiles.list';
                if (roster) rosterCalls.add(frame['params']);
                ws.add(
                  jsonEncode({
                    'jsonrpc': '2.0',
                    'id': frame['id'],
                    'result': roster
                        ? {
                            'install_id': 'fixture-machine',
                            'profiles': [
                              {'name': 'fixture-profile-${rosterCalls.length}'},
                              {'name': 'editor'},
                            ],
                          }
                        : <String, Object?>{},
                  }),
                );
              });
              return;
            } else if (req.uri.path == '/api/profiles/editor/desktop-overlay' &&
                req.uri.queryParameters['profile'] == 'editor' &&
                req.headers.value('cookie') ==
                    'hermes_session_at=fixture-cookie') {
              response.write(
                jsonEncode({
                  'exists': true,
                  'desktop': {
                    'version': 1,
                    'skin': 'catppuccin',
                    'mode': 'dark',
                    'layoutTree': {
                      'type': 'group',
                      'id': 'never-bind',
                      'panes': ['private-session'],
                      'active': 'private-session',
                    },
                  },
                }),
              );
            } else if (req.uri.path == '/api/profiles/editor/soul' &&
                req.uri.queryParameters['profile'] == 'editor' &&
                req.headers.value('cookie') ==
                    'hermes_session_at=fixture-cookie') {
              soulRequests.add(req.method);
              if (req.method == 'PUT') {
                persona =
                    jsonDecode(await utf8.decoder.bind(req).join())['content']
                        as String;
                response.write('{"ok":true}');
              } else {
                response.write(
                  jsonEncode({'content': persona, 'exists': true}),
                );
              }
            } else if (req.uri.path == '/api/cloud/agents' &&
                req.uri.queryParameters['profile'] == 'editor' &&
                req.headers.value('cookie') ==
                    'hermes_session_at=fixture-cookie') {
              response.write(
                '{"agents":[{"id":"qa1","name":"Disposable cloud destination","dashboardUrl":"https://fixture-only.agents.nousresearch.com","dashboardGatewayState":"up"}]}',
              );
            } else if (req.uri.queryParameters['profile'] == 'editor' &&
                req.headers.value('cookie') ==
                    'hermes_session_at=fixture-cookie' &&
                req.uri.path.startsWith('/api/ops/backup')) {
              backupRequests.add(req.method);
              response.write(
                '{"ok":true,"name":"backup","pid":33,"archive":"/fixture/home.zip"}',
              );
            } else if (req.uri.queryParameters['profile'] == 'editor' &&
                req.uri.path == '/api/actions/backup/status') {
              backupRequests.add(req.method);
              response.write(
                '{"name":"backup","pid":33,"running":false,"exit_code":0}',
              );
            } else {
              response.write('{}');
            }
            await response.close();
          });
        });
        final c = SavedConnection(
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
        NextGenGateway? ng;
        final prefs = await SharedPreferences.getInstance();
        addTearDown(() async {
          ng?.dispose();
          for (final ws in sockets) {
            await ws.close();
          }
          await server.close(force: true);
        });
        Future<void> waitForText(String text) async {
          final clock = Stopwatch()..start();
          while (find.text(text).evaluate().isEmpty &&
              clock.elapsed < const Duration(seconds: 6)) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 10)),
            );
            await tester.pump(const Duration(milliseconds: 25));
          }
          expect(find.text(text), findsWidgets);
        }

        await withPlatformTrust(() async {
          if (!classic) ng = NextGenGateway(c);
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
                        connManager: ConnectionManager(prefs),
                        gateway: ng!,
                        connections: [c],
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
                      connection: c,
                      sessionsLoader: () async => [],
                    )
                  : NgMorePage(onOpenSession: (_) {}),
            ),
          );
          await tester.pump();
          if (classic) {
            await tester.tap(find.text('More').last);
            await tester.pumpAndSettle();
            // The phone's More list builds rows lazily. Use the actual scroll
            // gesture before expecting the Profiles row to have an element.
            await tester.scrollUntilVisible(
              find.text('Profiles'),
              180,
              scrollable: find.descendant(
                of: find.byType(MorePane),
                matching: find.byType(Scrollable),
              ),
            );
          }
          await tester.ensureVisible(find.text('Profiles'));
          await tester.tap(find.text('Profiles'));
          await waitForText('fixture-profile-1');
          await tester.tap(find.byTooltip('Refresh'));
          await waitForText('fixture-profile-2');
          expect(find.text('fixture-profile-1'), findsNothing);
          await tester.tap(find.text('editor'));
          await waitForText('Edit persona');
          await tester.tap(find.text('Edit persona'));
          await waitForText('Initial fixture persona');
          await tester.enterText(
            find.widgetWithText(TextFormField, 'Persona'),
            'Changed by the fixture',
          );
          await tester.tap(find.text('Confirm'));
          await waitForText('Persona saved.');
          expect(persona, 'Changed by the fixture');
          expect(soulRequests, ['GET', 'GET', 'PUT', 'GET']);
          await tester.tap(find.text('Portable profile bundle'));
          await tester.pumpAndSettle();
          await tester.tap(
            find.text('Review appearance saved with this profile'),
          );
          await waitForText('Skin: catppuccin · Mode: dark · One pane');
          final styleStore = ProfilePresentationStore(prefs),
              editor = c.copyWith(gatewayProfile: 'editor');
          expect(styleStore.read(editor), isNull);
          await tester.tap(find.text('Apply to this profile on this device'));
          await waitForText('Appearance applied to Fixture gateway / editor.');
          expect(styleStore.read(editor)!.style.skin, 'catppuccin');
          expect(styleStore.read(c), isNull);
          expect(
            prefs.getKeys().map((k) => prefs.get(k)).join(),
            isNot(contains('private-session')),
          );
          await tester.pageBack();
          await tester.pumpAndSettle();
          Future<void> tapRow(String name) async {
            final scrollable = find
                .descendant(
                  of: find.byType(ListView).last,
                  matching: find.byType(Scrollable),
                )
                .first;
            await tester.scrollUntilVisible(
              find.text(name),
              160,
              scrollable: scrollable,
            );
            await tester.ensureVisible(find.text(name));
            await tester.pumpAndSettle();
            if (find.text(name).hitTestable().evaluate().isEmpty) {
              await tester.drag(scrollable, const Offset(0, -200));
              await tester.pumpAndSettle();
            }
            expect(find.text(name).hitTestable(), findsOneWidget);
            await tester.tap(find.text(name));
            await tester.pump();
          }

          await tapRow('Back up entire agent home');
          await tester.tap(find.text('Cancel'));
          await tester.pump();
          expect(backupRequests, isEmpty);
          await tapRow('Back up entire agent home');
          await tester.tap(find.text('Confirm'));
          await waitForText('Backup started on Fixture gateway.');
          await tapRow('Check backup progress');
          // A successful start is not a completed backup: a PID-matched owner
          // status read is required before a local save is offered.
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 50)),
          );
          await tester.pump();
          await tester.pump();
          await waitForText('Save backup to this device');
          expect(backupRequests, ['POST', 'GET']);
          await tapRow('Transfer to a Cloud agent');
          await tester.pumpAndSettle();
          await tester.tap(find.text('Find my Cloud agents'));
          await waitForText('Disposable cloud destination');
          await tester.tap(find.text('Disposable cloud destination'));
          await waitForText(
            'Sign in to exactly one saved Ares connection for https://fixture-only.agents.nousresearch.com, then return here.',
          );
          await tester.pageBack();
          await tester.pumpAndSettle();
          final edit = ConnectionMutationBarrier.begin(['fixture']);
          edit.release();
          await waitForText('The gateway connection dropped. Try again.');
          expect(find.text('fixture-profile-2'), findsNothing);
          expect(tickets, 2);
          expect(rosterCalls, [
            for (var i = 0; i < 2; i++)
              {'include_sessions': false, 'profile': 'work'},
            {'include_sessions': false, 'profile': 'editor'},
          ]);
          await tester.pumpWidget(const SizedBox());
          ng?.dispose();
          ng = null;
          await tester.runAsync(() async {
            for (final ws in sockets) {
              await ws.close();
            }
          });
          await tester.pump(const Duration(seconds: 6));
        });
      },
    );
  }
}
