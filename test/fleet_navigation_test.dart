import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/fleet_screen.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_fleet.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/more_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:hermes_android/core/services/fleet_ssh.dart';
import 'dashboard_origin_test.dart' show MemoryCredentials;
import 'support/fleet_fixture.dart';
import 'support/mtls_fixture.dart';

class _Support extends PathProviderPlatform {
  _Support(this.dir);
  final Directory dir;
  @override
  Future<String?> getApplicationSupportPath() async => dir.path;
}

void main() {
  for (final classic in [true, false]) {
    testWidgets(
      '${classic ? 'Classic' : 'NextGen'} More manages the remote Webapp and discovers an organisation without contacting the new agent',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final manager = ConnectionManager(
          await SharedPreferences.getInstance(),
          credentialStore: MemoryCredentials(),
          nativePushSupported: false,
        );
        final fleet = GatewayFleet(manager);
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(520, 1000);
        addTearDown(tester.view.reset);
        final server = (await tester.runAsync(() => FleetFixture.start('UI')))!;
        final c = server.connection;
        final support = (await tester.runAsync(
          () => Directory.systemTemp.createTemp('fleet-support-'),
        ))!;
        final platform = PathProviderPlatform.instance;
        PathProviderPlatform.instance = _Support(support);
        addTearDown(() async {
          PathProviderPlatform.instance = platform;
          await support.delete(recursive: true);
        });
        NextGenGateway? ng;
        Future<void> wait(Finder f) async {
          final clock = Stopwatch()..start();
          while (f.evaluate().isEmpty &&
              clock.elapsed < const Duration(seconds: 5)) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 10)),
            );
            await tester.pump(const Duration(milliseconds: 40));
          }
          expect(f, findsWidgets);
        }

        Future<void> tap(String title) async {
          await wait(find.text(title));
          final f = find.text(title).last;
          await tester.ensureVisible(f);
          await tester.tap(f);
          await tester.pump();
        }

        try {
          await withPlatformTrust(() async {
            if (!classic) ng = NextGenGateway(c);
            await tester.pumpWidget(
              MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: classic
                    ? hermesTheme(Brightness.dark)
                    : nextGenTheme(Brightness.dark, NextGenLook.instance),
                builder: (context, child) => FleetScope(
                  fleet: fleet,
                  child: classic
                      ? child!
                      : NgScope(
                          connManager: manager,
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
            if (classic) {
              await tap('More');
              await tester.pumpAndSettle();
            }
            await tap('Gateway fleet');
            await tester.pumpAndSettle();
            await tap('Gateway-managed SSH');
            await tester.pumpAndSettle();
            expect(find.text('Read saved SSH hosts'), findsOneWidget);
            await tester.pageBack();
            await tester.pumpAndSettle();
            if (FleetSsh.supported) {
              await tap('Verified SSH');
              await tester.pumpAndSettle();
              await tester.enterText(
                find.widgetWithText(TextField, 'SSH host'),
                'fixture.invalid',
              );
              await tester.enterText(
                find.widgetWithText(TextField, 'SSH user'),
                'fixture',
              );
              await tester.enterText(
                find.widgetWithText(
                  TextField,
                  'Public host key from administrator (ssh-ed25519)',
                ),
                'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdamAGCsQq31Uv+08lkBzoO4XLz2qYjJa8CGmj3B1Ea',
              );
              await tap('Review host key');
              await wait(
                find.textContaining(
                  'SHA256:bbXpuKG6zhzdmnxq256TlqzFBzRl2f6OOg722cYNbU8',
                ),
              );
              await tap('Cancel');
              await tester.pumpAndSettle();
              final trust = FleetSsh(
                Directory.fromUri(support.uri.resolve('ares-ssh/')),
              );
              final dest = SshDestination('fixture.invalid', 22, 'fixture');
              expect(await tester.runAsync(() => trust.enrolled(dest)), isNull);
              await tap('Review host key');
              await tap('Confirm');
              await wait(find.text('Host key pinned.'));
              expect(
                (await tester.runAsync(
                  () => trust.enrolled(dest),
                ))?.fingerprint,
                'SHA256:bbXpuKG6zhzdmnxq256TlqzFBzRl2f6OOg722cYNbU8',
              );
              await tester.pageBack();
              await tester.pumpAndSettle();
            }
            await tap('Cloud and Desktop Webapp');
            await tester.pumpAndSettle();
            await tap('Check gateway and Web Access status');
            await wait(find.text('Gateway 1.2.3 · Host-only access status'));
            await tap('Discover signed-in agents');
            await tap('Fixture team');
            await wait(find.text('Hosted UI'));
            // Opening a discovery result only prefills the new sign-in form; no probe
            // to that origin or change to the serving account happens on navigation.
            await tap('Hosted UI');
            await wait(find.widgetWithText(TextField, 'https://agent.invalid'));
            Navigator.of(tester.element(find.byType(TextField).first)).pop();
            await tester.pumpAndSettle();
            await tap('Read Webapp gateway registry');
            await wait(find.text('Workstation'));
            await tester.tap(find.byTooltip('Set primary: Workstation'));
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));
            await tap('Cancel');
            await tester.pumpAndSettle();
            expect(server.writes, isEmpty);
            await tester.tap(find.byTooltip('Set primary: Workstation'));
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));
            await tap('Set primary');
            await wait(find.text('remote · other · Primary'));
            expect(server.primary, 'other');
            await tap('Read shared display preferences');
            await tap('RTL');
            final clock = Stopwatch()..start();
            while (server.direction != 'rtl' &&
                clock.elapsed < const Duration(seconds: 4)) {
              await tester.runAsync(
                () => Future<void>.delayed(const Duration(milliseconds: 10)),
              );
              await tester.pump();
            }
            expect(server.direction, 'rtl');
            expect(find.textContaining('never-render'), findsNothing);
            await tester.pumpWidget(const SizedBox());
          });
        } finally {
          fleet.dispose();
          ng?.dispose();
          await tester.runAsync(server.close);
          await tester.pump(const Duration(seconds: 6));
        }
      },
    );
  }
}
