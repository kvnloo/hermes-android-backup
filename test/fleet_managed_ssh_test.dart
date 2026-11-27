import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/fleet_managed_ssh_screen.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';

import 'support/fleet_fixture.dart';
import 'support/mtls_fixture.dart';

void main() {
  test(
    'REST contract is bodyless, machine scoped and rejects changed host and late owner',
    () => withPlatformTrust(() async {
      final f = (await FleetFixture.start('ssh-contract'))..includeSsh = true;
      final gateway = NextGenGateway(f.connection);
      final pane = gateway.workspace.pane();
      try {
        final t = await pane.bind(gateway.workspace.route());
        final row = (await t.managedSshHosts()).single;
        expect(await t.managedSsh(row), isNull);
        final connected = await t.managedSsh(row, method: 'POST');
        expect(connected?.host, row.host);
        expect(connected?.localPort, 40001);
        expect(connected?.remotePort, 9119);
        expect(connected?.reused, true);
        expect(connected?.version, '1.2.3');
        f.sshVersion = '';
        expect((await t.managedSsh(row))?.version, '');
        expect(f.sshWrites.single, (
          method: 'POST',
          body: '',
          origin: 'http://127.0.0.1:${f.server.port}',
        ));
        f.sshHost = 'edited.invalid';
        await expectLater(
          t.managedSsh(row, method: 'POST'),
          throwsA(isA<WorkspaceException>()),
        );
        expect(f.sshWrites, hasLength(1));
        f.sshHost = row.host;
        f.sshErrorKind = 'host-key-changed';
        await expectLater(
          t.managedSsh(row, method: 'POST'),
          throwsA(isA<ManagedSshKeyChanged>()),
        );
        f.sshErrorKind = 'authentication-failed';
        await expectLater(
          t.managedSsh(row, method: 'POST'),
          throwsA(
            isA<WorkspaceException>().having(
              (e) => e.reason,
              'reason',
              WorkspaceFailure.unavailable,
            ),
          ),
        );
        f.sshErrorKind = null;
        f.holdSsh = Completer<void>();
        final late = t.managedSsh(row, method: 'POST');
        final rejected = expectLater(
          late,
          throwsA(
            isA<WorkspaceException>().having(
              (e) => e.reason,
              'reason',
              WorkspaceFailure.stale,
            ),
          ),
        );
        while (f.sshWrites.length < 4) {
          await Future<void>.delayed(const Duration(milliseconds: 5));
        }
        pane.invalidate();
        f.holdSsh!.complete();
        await rejected;
        expect(
          f.requests
              .where((r) => r.uri.path.endsWith('/ssh'))
              .every((r) => !r.uri.hasQuery),
          isTrue,
        );
        expect(f.prompts, isEmpty);
      } finally {
        pane.close();
        gateway.dispose();
        await f.close();
      }
    }),
  );

  testWidgets(
    'A→B→A drops late bootstrap status without disconnecting or re-routing it',
    (tester) async {
      final a = (await tester.runAsync(
        () => FleetFixture.start('ssh-owner-a'),
      ))!..includeSsh = true;
      final b = (await tester.runAsync(
        () => FleetFixture.start('ssh-owner-b'),
      ))!..includeSsh = true;
      late NextGenGateway ga, gb;
      late ValueNotifier<RemoteWorkspaceOwner> selected;
      Future<void> until(bool Function() done) async {
        final clock = Stopwatch()..start();
        while (!done() && clock.elapsed < const Duration(seconds: 5)) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 10)),
          );
          await tester.pump(const Duration(milliseconds: 50));
        }
        expect(done(), true);
      }

      try {
        await withPlatformTrust(() async {
          ga = NextGenGateway(a.connection);
          gb = NextGenGateway(b.connection);
          selected = ValueNotifier(ga.workspace);
          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: ValueListenableBuilder(
                valueListenable: selected,
                builder: (_, owner, _) =>
                    FleetManagedSshScreen(owner: owner, label: 'Selected'),
              ),
            ),
          );
          await tester.tap(find.text('Read saved SSH hosts'));
          await until(() => find.text('Fixture SSH').evaluate().isNotEmpty);
          final connect = find.widgetWithText(FilledButton, 'Connect');
          await tester.ensureVisible(connect);
          await tester.tap(connect);
          await tester.pumpAndSettle();
          a.holdSsh = Completer<void>();
          await tester.tap(
            find.descendant(of: find.byType(AlertDialog), matching: connect),
          );
          await until(() => a.sshWrites.isNotEmpty);
          selected.value = gb.workspace;
          await tester.pump();
          selected.value = ga.workspace;
          await tester.pump();
          a.holdSsh!.complete();
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)),
          );
          await tester.pumpAndSettle();
          expect(find.textContaining('Gateway loopback port'), findsNothing);
          expect(find.text('Fixture SSH'), findsNothing);
          expect(b.requests, isEmpty);
          expect(a.sshWrites.map((r) => r.method), ['POST']);
        });
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        selected.dispose();
        ga.dispose();
        gb.dispose();
        await tester.runAsync(() async {
          await a.close();
          await b.close();
        });
      }
    },
  );

  for (final classic in [true, false]) {
    testWidgets(
      '${classic ? "Classic" : "NextGen"} TOFU cancel, mismatch repair, elapsed progress and confirmed disconnect at 320px / 2x',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 640);
        addTearDown(tester.view.reset);
        final f = (await tester.runAsync(
          () => FleetFixture.start('ssh-ui-$classic'),
        ))!..includeSsh = true;
        late final NextGenGateway gateway;
        Future<void> wait(bool Function() done) async {
          final clock = Stopwatch()..start();
          while (!done() && clock.elapsed < const Duration(seconds: 8)) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 10)),
            );
            await tester.pump(const Duration(milliseconds: 50));
          }
          expect(done(), isTrue);
        }

        Future<void> tap(Finder finder) async {
          if (finder.evaluate().isEmpty) {
            await tester.scrollUntilVisible(
              finder,
              160,
              scrollable: find.byType(Scrollable).first,
            );
          }
          await tester.ensureVisible(finder.last);
          await tester.tap(finder.last);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
        }

        Finder button(String text) => find.widgetWithText(FilledButton, text);
        try {
          await withPlatformTrust(() async {
            gateway = NextGenGateway(f.connection);
            await tester.pumpWidget(
              MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: classic
                    ? hermesTheme(Brightness.dark)
                    : nextGenTheme(Brightness.dark, NextGenLook.instance),
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(2),
                    viewInsets: const EdgeInsets.only(bottom: 180),
                  ),
                  child: child!,
                ),
                home: FleetManagedSshScreen(
                  owner: gateway.workspace,
                  label: 'Fixture gateway',
                ),
              ),
            );
            await tap(find.text('Read saved SSH hosts'));
            await wait(() => find.text('Fixture SSH').evaluate().isNotEmpty);
            await tap(button('Connect'));
            expect(find.text('fixture.invalid:2222'), findsWidgets);
            expect(find.textContaining('trust and remember'), findsOneWidget);
            expect(
              find.textContaining('does not report the key fingerprint'),
              findsOneWidget,
            );
            await tap(find.text('Cancel'));
            expect(f.sshWrites, isEmpty);
            await tap(button('Connect'));
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.sendKeyEvent(LogicalKeyboardKey.escape);
            await tester.pumpAndSettle();
            expect(find.byType(AlertDialog), findsNothing);
            expect(f.sshWrites, isEmpty);
            f.sshErrorKind = 'host-key-changed';
            await tap(button('Connect'));
            await tap(
              find.descendant(
                of: find.byType(AlertDialog),
                matching: button('Connect'),
              ),
            );
            await wait(() => button('Retry').evaluate().isNotEmpty);
            expect(
              find.textContaining('must independently verify'),
              findsWidgets,
            );
            expect(find.textContaining('never-render-this'), findsNothing);
            expect(f.sshWrites, hasLength(1));
            await tap(button('Retry'));
            expect(
              find.descendant(
                of: find.byType(AlertDialog),
                matching: find.textContaining('remove the old trusted key'),
              ),
              findsOneWidget,
            );
            await tap(find.text('Cancel'));
            expect(f.sshWrites, hasLength(1));
            f.sshErrorKind = null;
            f.holdSsh = Completer<void>();
            await tap(button('Retry'));
            await tap(
              find.descendant(
                of: find.byType(AlertDialog),
                matching: button('Retry'),
              ),
            );
            await wait(() => f.sshWrites.length == 2);
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 1100)),
            );
            await tester.pump(const Duration(seconds: 2));
            final pending = tester.widget<Text>(
              find.textContaining('Waiting for the gateway:'),
            );
            expect(
              int.parse(
                RegExp(
                  r'gateway: (\d+) s',
                ).firstMatch(pending.data!)!.group(1)!,
              ),
              greaterThanOrEqualTo(1),
            );
            expect(find.text('Cancel'), findsNothing);
            f.holdSsh!.complete();
            await wait(
              () => find
                  .textContaining('Gateway loopback port: 40001')
                  .evaluate()
                  .isNotEmpty,
            );
            await tap(find.text('Disconnect'));
            expect(
              find.textContaining('interrupt other clients'),
              findsOneWidget,
            );
            await tap(find.text('Cancel'));
            expect(f.sshWrites, hasLength(2));
            await tap(find.text('Disconnect'));
            await tap(
              find.descendant(
                of: find.byType(AlertDialog),
                matching: button('Disconnect'),
              ),
            );
            await wait(
              () => find
                  .textContaining('Gateway loopback port: 40001')
                  .evaluate()
                  .isEmpty,
            );
            expect(f.sshWrites.last.method, 'DELETE');
            expect(f.sshWrites.every((r) => r.body.isEmpty), true);
            expect(tester.takeException(), isNull);
          });
        } finally {
          await tester.pumpWidget(const SizedBox.shrink());
          gateway.dispose();
          await tester.runAsync(f.close);
        }
      },
    );
  }
}
