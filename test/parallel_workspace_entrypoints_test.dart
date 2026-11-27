import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';

import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/utils/home_turn_signals.dart';
import 'package:hermes_android/core/workspace/parallel_workspace.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

import 'package:hermes_android/nextgen/nextgen_home.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/parallel_workspace_fixture.dart';

typedef _Fixture = ParallelFixture;
typedef _Gateway = ParallelFixtureGateway;

Widget _classic(_Fixture f) => MaterialApp(
  theme: hermesTheme(Brightness.dark),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: WorkspaceScreen(
    connection: f.connection,
    sessionsLoader: () async => [],
    testChatApiClientFactory: f.api,
    testDashboardHttpClient: f.client(),
    turnSignalsLoader: (_) async => HomeTurnSignals.empty,
  ),
);

class _Accounts extends ConnectionManager {
  _Accounts(super.prefs, this.selected);
  _Gateway selected;
  @override
  Future<List<SavedConnection>> loadConnectionsWithSecrets() async => [
    selected.connection,
  ];
}

Widget _next(_Accounts manager) => MaterialApp(
  theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: NextGenHome(
    connManager: manager,
    testGatewayFactory: (_) => manager.selected,
  ),
);

Future<void> _frames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pump(const Duration(milliseconds: 350));
}

Future<void> _open(
  WidgetTester tester, {
  required bool nextGen,
  required bool wide,
}) async {
  if (nextGen && !wide) {
    await tester.tap(find.byKey(const ValueKey('ng-sidebar-button')));
    await _frames(tester);
  }
  final more = find.text('More').last;
  await tester.ensureVisible(more);
  await tester.tap(more);
  await _frames(tester);
  final entry = find.text('Parallel workspace');
  await tester.ensureVisible(entry);
  await tester.tap(entry);
  await _frames(tester);
  expect(find.byType(ParallelWorkspace), findsOneWidget);
}

Future<void> _pick(WidgetTester tester, String id) async {
  await tester.tap(find.byTooltip('Add chat'));
  await _frames(tester);
  await tester.tap(find.text('Chat $id').last);
  await _frames(tester);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets(
    'held roster cannot restore the workspace of a replaced NextGen profile',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1600, 920);
      addTearDown(tester.view.reset);
      final a = _Fixture(profile: 'profile A', dashboard: true);
      final b = _Fixture(profile: 'profile B', dashboard: true);
      final old = _Gateway(a);
      final current = _Gateway(b);
      final manager = _Accounts(await SharedPreferences.getInstance(), old);
      await tester.pumpWidget(_next(manager));
      await _frames(tester);
      final pending = a.rosterGate = Completer<void>();
      addTearDown(() {
        if (!pending.isCompleted) pending.complete();
      });
      final prior = a.requests.length;
      await _open(tester, nextGen: true, wide: true);
      expect(
        a.requests.skip(prior).where((u) => u.path == '/api/sessions'),
        isNotEmpty,
      );
      manager.selected = current;
      final scope = tester.widget<NgScope>(find.byType(NgScope));
      await scope.reload();
      await _frames(tester);
      expect(find.byType(ParallelWorkspace, skipOffstage: false), findsNothing);
      await _open(tester, nextGen: true, wide: true);
      await _pick(tester, 'alpha');
      pending.complete();
      await _frames(tester);
      expect(old.resumes, isEmpty);
      expect(current.resumes, ['alpha']);
      expect(
        find.text('History profile A alpha', findRichText: true),
        findsNothing,
      );
      expect(
        find.text('History profile B alpha', findRichText: true),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
      await _frames(tester);
      expect(tester.takeException(), isNull);
    },
  );
  for (final nextGen in [false, true]) {
    for (final wide in [false, true]) {
      testWidgets(
        '${nextGen ? "NextGen" : "Classic"} More opens real ${wide ? "wide" : "phone"} chat',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(wide ? 1600 : 400, 920);
          addTearDown(tester.view.reset);
          final f = _Fixture(
            profile: nextGen ? 'profile A' : null,
            dashboard: nextGen,
          );
          final g = nextGen ? _Gateway(f) : null;
          final prefs = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            g == null ? _classic(f) : _next(_Accounts(prefs, g)),
          );
          await _frames(tester);
          await _open(tester, nextGen: nextGen, wide: wide);
          await _pick(tester, 'alpha');
          final chat = find.byType(nextGen ? NgChatView : ChatScreen);
          expect(chat, findsOneWidget);
          final msg = 'History ${f.profile ?? "legacy"} alpha';
          expect(
            find.descendant(
              of: chat,
              matching: find.text(msg, findRichText: true),
            ),
            findsOneWidget,
          );
          final composer = find.descendant(
            of: chat,
            matching: find.byKey(
              ValueKey(nextGen ? 'ng-composer-field' : 'chat-message-composer'),
            ),
          );
          await tester.enterText(composer, 'Draft only');
          expect(
            find.descendant(of: chat, matching: find.text('Draft only')),
            findsOneWidget,
          );
          await tester.tap(find.byTooltip('Workspace options'));
          await _frames(tester);
          await tester.tap(find.text('Dock another pane'));
          await _frames(tester);
          await tester.tap(find.text('Chat beta').last);
          await _frames(tester);
          expect(chat, wide ? findsNWidgets(2) : findsOneWidget);
          final other = 'History ${f.profile ?? "legacy"} beta';
          if (wide) {
            expect(
              tester.getTopLeft(chat.first).dx,
              lessThan(tester.getTopLeft(chat.last).dx),
            );
          } else {
            await tester.tap(find.text('Switch pane: Chat beta'));
            await _frames(tester);
          }
          expect(find.text(other, findRichText: true), findsOneWidget);
          if (!wide) {
            await tester.tap(find.text('Switch pane: Chat alpha'));
            await _frames(tester);
          }
          expect(find.text('Draft only'), findsOneWidget);
          if (g != null) {
            expect(g.resumes, contains('alpha'));
            final reads = f.requests.where(
              (uri) =>
                  uri.path == '/api/sessions' || uri.path.endsWith('/messages'),
            );
            expect(reads, isNotEmpty);
            expect(
              reads.every((uri) => uri.queryParameters['profile'] == f.profile),
              isTrue,
            );
          }
          // A same-ID account edit revokes mounted panes and the old menu's
          // authority to reopen them, even if the mutation already finished.
          ConnectionMutationBarrier.begin([f.connection.id]).release();
          await _frames(tester);
          expect(
            find.byType(ParallelWorkspace, skipOffstage: false),
            findsNothing,
          );
          expect(
            find.text(msg, findRichText: true, skipOffstage: false),
            findsNothing,
          );
          await tester.pumpWidget(const SizedBox());
          await _frames(tester);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
