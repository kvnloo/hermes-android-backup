import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/parallel_chat_pane.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/parallel_workspace_fixture.dart';

void main() {
  testWidgets(
    'two native NextGen panes route interleaved socket deltas and edits independently',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1500, 920);
      addTearDown(tester.view.reset);
      final manager = ConnectionManager(await SharedPreferences.getInstance());
      final fixture = ParallelFixture(dashboard: true, profile: 'pane-test');
      final g = ParallelFixtureGateway(fixture);
      addTearDown(g.dispose);
      final rows = (await g.api.getSessionsPage()).sessions;
      final closed = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NgScope(
            connManager: manager,
            gateway: g,
            connections: [fixture.connection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: Row(
              children: [
                for (final row in rows)
                  Expanded(
                    child: NgParallelChatPane(
                      gateway: g,
                      session: row,
                      close: () => closed.add(row.id),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(g.resumes, unorderedEquals(['alpha', 'beta']));
      Finder pane(String id) => find.byWidgetPredicate(
        (w) => w is NgParallelChatPane && w.session.id == id,
      );
      Finder within(String id, Finder what) =>
          find.descendant(of: pane(id), matching: what);
      for (final id in ['alpha', 'beta']) {
        expect(
          within(id, find.text('History pane-test $id', findRichText: true)),
          findsOneWidget,
        );
        await tester.enterText(
          within(id, find.byKey(const ValueKey('ng-composer-field'))),
          'Draft $id',
        );
        g.debugEmit(
          StreamEvent(
            type: 'message.start',
            sessionId: 'runtime-$id',
            data: {},
          ),
        );
      }
      for (final id in ['beta', 'alpha']) {
        g.debugEmit(
          StreamEvent(
            type: 'message.delta',
            sessionId: 'runtime-$id',
            data: {'text': 'Reply $id'},
          ),
        );
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      for (final id in ['alpha', 'beta']) {
        expect(within(id, find.text('Draft $id')), findsOneWidget);
        expect(
          within(id, find.text('Reply $id', findRichText: true)),
          findsOneWidget,
        );
        expect(find.text('Reply $id', findRichText: true), findsOneWidget);
      }
      await tester.tap(within('alpha', find.byType(CloseButton)));
      expect(closed, ['alpha']);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );
}
