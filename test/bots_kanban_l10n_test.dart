// Blocker 11 of the review of v5/bots @ d74ba224: the Kanban board, the bots
// screen and their More entries were English whatever the app's language.
// Each surface is rendered in German; none of the English the screens used to
// hard-code may show, and the German comes from app_de.arb.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/widgets/more_pane.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/more_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/bots_review_fixture.dart';
import 'support/kanban_review_fixture.dart';
import 'support/l10n_test_utils.dart';

const _german = Locale('de');

Map<String, dynamic> _arb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

/// Every string on screen: text, tooltips, field labels and hints.
Set<String> _shown() => {
  for (final e in find.byType(RichText, skipOffstage: false).evaluate())
    (e.widget as RichText).text.toPlainText(),
  for (final e in find.byType(Tooltip, skipOffstage: false).evaluate())
    ?(e.widget as Tooltip).message,
};

/// The English that [where] used to show; every one differs in German.
void _expectNoEnglish(Set<String> seen, List<String> english, String where) {
  final left = [
    for (final text in english)
      if (seen.contains(text)) text,
  ];
  expect(left, isEmpty, reason: 'English left on $where: $left');
}

void _expectGerman(Set<String> seen, List<String> keys, String where) {
  final de = _arb('de');
  for (final key in keys) {
    final text = de[key];
    expect(text, isA<String>(), reason: 'app_de.arb has no $key');
    expect(seen, contains(text), reason: '$where does not show $key');
  }
}

void _wide(WidgetTester tester) {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('the Kanban board, its selection bar and New task form', (
    tester,
  ) async {
    _wide(tester);
    final api = KanbanReviewApi();
    final owner = kanbanReviewOwner(api.client);
    addTearDown(owner.close);
    await tester.pumpWidget(kanbanReviewApp(owner, locale: _german));
    await kanbanShown(tester, find.byKey(const Key('kanban-new-task-button')));
    await kanbanStep(tester);
    var seen = _shown();
    _expectNoEnglish(seen, const [
      'Filter tasks…',
      'All assignees',
      'Unassigned',
      'Archived',
      'Running by profile',
      'Select',
      'Dispatch ready tasks now',
      'Orchestration & workers',
      'New task',
      'Drop or + task',
      'Card actions',
      'Managed column — drag drop disabled',
      'Ready · 2',
      'Running · 1',
      'Collapse Ready',
      'Add to Ready',
    ], 'the board');
    _expectGerman(seen, const [
      'ng_board_filter',
      'ng_board_new_task',
      'ng_board_running_by_profile',
      'ng_board_drop_here',
    ], 'the board');

    await tester.longPress(find.byKey(const Key('kanban-card-t_ready_0')));
    await kanbanStep(tester, 3);
    seen = _shown();
    _expectNoEnglish(seen, const [
      '1 selected',
      'Selected (1)',
      'Move…',
      'Assign…',
      'Archive',
      'Delete',
    ], 'the selection bar');
    _expectGerman(seen, const [
      'ng_board_move_menu',
      'ng_board_assign_menu',
    ], 'the selection bar');

    await tester.tap(find.byKey(const Key('kanban-new-task-button')));
    await kanbanStep(tester);
    seen = _shown();
    _expectNoEnglish(seen, const [
      'New Kanban task',
      'Title *',
      'Spec & acceptance criteria',
      'Estimate',
      'Initial column',
      'Worker assignee',
      'Parked (unassigned)',
      'Priority',
      'Workspace',
      'Scratch',
      'Parent dependency (optional)',
      'Pinned skills (comma-separated, optional)',
      'Provider override',
      'Model override',
      'Reasoning effort',
      'Profile default',
      'Goal loop mode',
      'Create task',
    ], 'the New task form');
    _expectGerman(seen, const [
      'ng_board_new_task_title',
      'ng_board_create_task',
      'ng_board_reasoning',
    ], 'the New task form');
  });

  testWidgets('a Kanban task’s detail and its status', (tester) async {
    _wide(tester);
    final api = KanbanReviewApi();
    final owner = kanbanReviewOwner(api.client);
    addTearDown(owner.close);
    await tester.pumpWidget(kanbanReviewApp(owner, locale: _german));
    await kanbanShown(tester, find.byKey(const Key('kanban-card-t_run_1')));
    await tester.tap(find.byKey(const Key('kanban-card-t_run_1')));
    await kanbanStep(tester);
    final seen = _shown();
    _expectNoEnglish(seen, const [
      't_run_1 · running',
      'Overview',
      'Comments & Links',
      'Runs & Log',
      'Events',
      'Decompose',
      'Attach file',
      'Requeue',
      'Body / specification',
      'Save changes',
      'Refresh task',
    ], 'the task detail');
    _expectGerman(seen, const [
      'ng_board_tab_overview',
      'ng_board_save_changes',
    ], 'the task detail');
  });

  testWidgets('the bots screen, each tab and the routine form', (tester) async {
    _wide(tester);
    final gateway = BotsReviewGateway();
    final owner = botsReviewOwner(gateway);
    addTearDown(owner.close);
    await tester.pumpWidget(botsReviewApp(owner, locale: _german));
    await botsShown(tester, find.text('WorkBot'));
    final seen = <String>{..._shown()};
    for (final tab in const [
      Icons.groups_outlined,
      Icons.desktop_windows_outlined,
      Icons.schedule_outlined,
    ]) {
      await tester.tap(find.byIcon(tab).first);
      await botsStep(tester);
      seen.addAll(_shown());
    }
    final de = _arb('de');
    expect(de['ng_bots_add_routine'], isA<String>());
    await tester.tap(find.byTooltip(de['ng_bots_add_routine'] as String));
    await botsStep(tester);
    seen.addAll(_shown());
    _expectNoEnglish(seen, const [
      'Roster',
      'Rooms',
      'Screen',
      'Routines',
      'Search bots',
      'Refresh',
      'Create room',
      'Refresh rooms',
      'Gateway rooms',
      '2 members',
      'Running',
      'Take over',
      'Stop',
      'Screen thumbnail (live)',
      'Thumbnail not available yet.',
      'Add routine',
      'Pause',
      'Remove',
      'New routine',
      'Title',
      'Instruction',
      'Schedule',
      'Cron expression',
      'Stop after (runs)',
      'Leave blank to keep running',
      'Send results to',
      'Run history only',
      'Continue from the previous run',
      'Cancel',
      'Add',
    ], 'the bots screen');
    expect(
      seen.where((text) => text.contains('the bot is in control')),
      isEmpty,
    );
    _expectGerman(seen, const [
      'ng_bots_tab_roster',
      'ng_bots_tab_screen',
      'ng_bots_search',
      'ng_bots_take_over',
      'ng_bots_new_routine',
      'ng_bots_stop_after',
    ], 'the bots screen');
  });

  test('the Classic More entries are translated in every locale', () async {
    final english = buildMoreSections(
      dashboardReachable: true,
      workspaceAvailable: true,
      l10n: await loadTestL10n(),
    ).expand((section) => section.entries).toList();
    MoreEntry entry(List<MoreEntry> entries, String id) =>
        entries.singleWhere((e) => e.id == id);
    for (final locale in AppLocalizations.supportedLocales) {
      if (locale.languageCode == 'en') continue;
      final entries = buildMoreSections(
        dashboardReachable: true,
        workspaceAvailable: true,
        l10n: await loadTestL10n(locale),
      ).expand((section) => section.entries).toList();
      for (final id in const ['kanban', 'bots']) {
        expect(
          entry(entries, id).subtitle,
          isNot(entry(english, id).subtitle),
          reason: '$locale $id',
        );
      }
    }
  });

  testWidgets('the NextGen More page shows Kanban and Bots in German', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final connection = SavedConnection(
      id: 'c-l10n',
      label: 'Disposable Host',
      host: '127.0.0.1',
      port: 9,
      apiKey: 'fixture-key',
      dashboardUsername: 'fixture',
      dashboardPassword: 'fixture-password',
      desktopGatewayUrl: 'http://127.0.0.1:9',
      gatewayProfile: 'work',
    );
    final gateway = NextGenGateway(connection);
    addTearDown(gateway.dispose);
    final connManager = ConnectionManager(
      await SharedPreferences.getInstance(),
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: _german,
        theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // As the app does: NextGen text follows the app's locale through this.
        builder: (context, child) => NgLocalizationScope(child: child!),
        home: NgScope(
          gateway: gateway,
          connManager: connManager,
          connections: [connection],
          switchTo: (_) async {},
          addGateway: () async {},
          signOut: (_) async {},
          reload: () async {},
          signInAgain: () async {},
          child: NgMorePage(onOpenSession: (_) {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final seen = _shown();
    _expectNoEnglish(seen, const [
      'Boards, task dependencies, worker assignment and logs',
      'Roster, rooms, routines and Bot Desktop',
    ], 'the NextGen More page');
    _expectGerman(seen, const [
      'ng_more_kanban_subtitle',
      'ng_more_bots_subtitle',
    ], 'the NextGen More page');

    // NextGen's strings are global: put English back for later tests.
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => NgLocalizationScope(child: child!),
        home: const SizedBox(),
      ),
    );
  });
}
