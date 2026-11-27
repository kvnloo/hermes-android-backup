// Probes K5 and B8 of the review of v5/bots @ d74ba224: the Kanban board and
// the bots screen at 320x640 with 2.0x text, in the Classic and the NextGen
// theme, with a 300 px keyboard over their forms.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/bots_screen.dart';
import 'package:hermes_android/core/screens/kanban_board_screen.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/bots_review_fixture.dart';
import 'support/kanban_review_fixture.dart';

const _keyboard = 300.0;
const _visibleBottom = 640.0 - _keyboard;

enum _Layout { classic, nextGen }

ThemeData _theme(_Layout layout) => switch (layout) {
  _Layout.classic => hermesTheme(Brightness.light),
  _Layout.nextGen => nextGenTheme(Brightness.light, NextGenLook.instance),
};

Widget _app(_Layout layout, Widget home) => MaterialApp(
  theme: _theme(layout),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: const TextScaler.linear(2.0)),
    child: child!,
  ),
  home: home,
);

/// Every layout error while [body] runs, as `message @ first source line`.
Future<List<String>> _overflows(
  WidgetTester tester,
  Future<void> Function() body,
) async {
  final errors = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final text = details.exceptionAsString();
    if (!text.contains('overflowed')) {
      previous?.call(details);
      return;
    }
    final source = details
        .toString()
        .split('\n')
        .firstWhere((l) => l.contains('lib/'), orElse: () => '');
    errors.add('${text.split('\n').first} @ ${source.trim()}');
  };
  try {
    await body();
  } finally {
    FlutterError.onError = previous;
  }
  return errors;
}

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(320, 640);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  addTearDown(tester.view.resetViewInsets);
}

/// The focused field's box must end above the keyboard.
void _expectAboveKeyboard(WidgetTester tester, Finder field) {
  final rect = tester.getRect(field);
  expect(
    rect.bottom,
    lessThanOrEqualTo(_visibleBottom),
    reason: 'field at $rect is under a $_keyboard px keyboard',
  );
  expect(rect.top, greaterThanOrEqualTo(0));
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    // A tap that lands on nothing is a layout failure here, not a warning.
    WidgetController.hitTestWarningShouldBeFatal = true;
  });
  tearDown(() => WidgetController.hitTestWarningShouldBeFatal = false);

  for (final layout in _Layout.values) {
    group(layout.name, () {
      testWidgets('K5 the Kanban board, its filters and the New task form', (
        tester,
      ) async {
        _phone(tester);
        final api = KanbanReviewApi();
        final owner = kanbanReviewOwner(api.client);
        addTearDown(owner.close);
        final errors = await _overflows(tester, () async {
          await tester.pumpWidget(
            _app(
              layout,
              KanbanBoardScreen(
                owner: owner,
                route: owner.route(),
                connection: kanbanReviewConnection,
                enableLivePolling: false,
              ),
            ),
          );
          await kanbanShown(
            tester,
            find.byKey(const Key('kanban-new-task-button')),
          );
          await kanbanStep(tester);
          // The selection bar.
          await tester.longPress(
            find.byKey(const Key('kanban-card-t_ready_0')),
          );
          await kanbanStep(tester, 3);
          expect(find.byKey(const Key('kanban-selection-bar')), findsOneWidget);

          await tester.tap(find.byKey(const Key('kanban-new-task-button')));
          await kanbanStep(tester);
          tester.view.viewInsets = const FakeViewPadding(bottom: _keyboard);
          await kanbanStep(tester);
          _expectAboveKeyboard(
            tester,
            find.byKey(const Key('kanban-new-title')),
          );
          // Each later field can be brought above the keyboard too.
          for (final key in [
            'kanban-new-column',
            'kanban-new-assignee',
            'kanban-new-workspace-kind',
            'kanban-new-parent',
            'kanban-new-model',
          ]) {
            final field = find.byKey(Key(key));
            await tester.ensureVisible(field);
            await kanbanStep(tester, 2);
            _expectAboveKeyboard(tester, field);
          }
          await tester.ensureVisible(
            find.byKey(const Key('kanban-new-assignee')),
          );
          await kanbanStep(tester, 2);
          await tester.tap(find.byKey(const Key('kanban-new-assignee')));
          await kanbanStep(tester, 3);
          await tester.tapAt(const Offset(4, 4));
          await kanbanStep(tester, 3);
        });
        expect(errors, isEmpty, reason: errors.join('\n'));
      });

      testWidgets('B8 the bots screen, every tab, and the routine form', (
        tester,
      ) async {
        _phone(tester);
        final gateway = BotsReviewGateway();
        final owner = botsReviewOwner(gateway);
        addTearDown(owner.close);
        final errors = await _overflows(tester, () async {
          await tester.pumpWidget(
            _app(
              layout,
              BotsScreen(
                owner: owner,
                route: owner.route(),
                connection: botsReviewConnection,
              ),
            ),
          );
          await botsShown(tester, find.text('WorkBot'));
          for (final tab in const [
            Icons.groups_outlined,
            Icons.desktop_windows_outlined,
            Icons.schedule_outlined,
            Icons.people_outline,
            Icons.schedule_outlined,
          ]) {
            await tester.tap(find.byIcon(tab).first);
            await botsStep(tester);
          }
          final add = find.byTooltip('Add routine');
          expect(add.hitTestable(), findsOneWidget);
          await tester.tap(add);
          await botsStep(tester);
          tester.view.viewInsets = const FakeViewPadding(bottom: _keyboard);
          await botsStep(tester);
          _expectAboveKeyboard(
            tester,
            find.byKey(const Key('bots-routine-title')),
          );
          for (final key in [
            'bots-routine-instruction',
            'bots-routine-schedule-kind',
            'bots-routine-cron',
            'bots-routine-repeat',
            'bots-routine-deliver',
          ]) {
            final field = find.byKey(Key(key));
            await tester.ensureVisible(field);
            await botsStep(tester, 2);
            _expectAboveKeyboard(tester, field);
          }
          final addButton = find.byKey(const Key('bots-routine-add'));
          await tester.ensureVisible(addButton);
          await botsStep(tester, 2);
          expect(tester.getRect(addButton).bottom, lessThanOrEqualTo(640));
        });
        expect(errors, isEmpty, reason: errors.join('\n'));
      });

      testWidgets('F11 roster sections, Move to section and the section name '
          'above the keyboard', (tester) async {
        _phone(tester);
        SharedPreferences.setMockInitialValues({
          'bot-sections-v1:c-bots:work':
              '[{"id":"sec-a","name":"Clients and long-running partnerships"}]',
        });
        final gateway = BotsReviewGateway()
          ..bumpRevision('workbot', {
            'sectionId': 'sec-a',
            'sectionName': 'Clients and long-running partnerships',
          });
        final owner = botsReviewOwner(gateway);
        addTearDown(owner.close);
        final errors = await _overflows(tester, () async {
          await tester.pumpWidget(
            _app(
              layout,
              BotsScreen(
                owner: owner,
                route: owner.route(),
                connection: botsReviewConnection,
              ),
            ),
          );
          await botsShown(tester, find.text('WorkBot'));
          await botsStep(tester);
          for (final key in [
            'bots-new-section',
            'bots-section-sec-a',
            'bots-section-menu-sec-a',
            'bots-section-unassigned',
            'bots-row-menu-researchbot',
          ]) {
            // The roster is a lazy list: scroll each one in.
            final target = find.byKey(Key(key));
            await tester.scrollUntilVisible(
              target,
              80,
              scrollable: find
                  .descendant(
                    of: find.byType(ListView),
                    matching: find.byType(Scrollable),
                  )
                  .first,
            );
            await botsStep(tester, 2);
            expect(target.hitTestable(), findsOneWidget, reason: key);
          }
          await tester.tap(find.byKey(const Key('bots-row-menu-researchbot')));
          await botsStep(tester);
          await tester.tap(find.byKey(const Key('bots-row-move')));
          await botsStep(tester);
          final fresh = find.byKey(const Key('bots-move-to-new'));
          await tester.ensureVisible(fresh);
          await botsStep(tester, 2);
          await tester.tap(fresh);
          await botsStep(tester);
          tester.view.viewInsets = const FakeViewPadding(bottom: _keyboard);
          await botsStep(tester);
          for (final key in ['bots-section-name', 'bots-section-ok']) {
            final field = find.byKey(Key(key));
            await tester.ensureVisible(field);
            await botsStep(tester, 2);
            _expectAboveKeyboard(tester, field);
          }
        });
        expect(errors, isEmpty, reason: errors.join('\n'));
      });

      testWidgets('F11 the bot sheet and Edit Profile, every field above the '
          'keyboard', (tester) async {
        _phone(tester);
        final gateway = BotsReviewGateway();
        final owner = botsReviewOwner(gateway);
        addTearDown(owner.close);
        final errors = await _overflows(tester, () async {
          await tester.pumpWidget(
            _app(
              layout,
              BotsScreen(
                owner: owner,
                route: owner.route(),
                connection: botsReviewConnection,
              ),
            ),
          );
          await botsShown(tester, find.text('WorkBot'));
          await tester.tap(find.text('WorkBot'));
          await botsStep(tester);
          final edit = find.byKey(const Key('bots-edit-profile'));
          await tester.ensureVisible(edit);
          await botsStep(tester, 2);
          await tester.tap(edit);
          await botsStep(tester);
          tester.view.viewInsets = const FakeViewPadding(bottom: _keyboard);
          await botsStep(tester);
          final advanced = find.byKey(const Key('bots-edit-advanced'));
          await tester.ensureVisible(advanced);
          await botsStep(tester, 2);
          await tester.tap(advanced);
          await botsStep(tester);
          for (final key in [
            'bots-edit-title',
            'bots-edit-description',
            'bots-edit-provider',
            'bots-edit-model',
            'bots-edit-soul',
            'bots-form-save',
          ]) {
            final field = find.byKey(Key(key));
            await tester.ensureVisible(field);
            await botsStep(tester, 2);
            _expectAboveKeyboard(tester, field);
          }
          for (final key in [
            'bots-avatar-remove',
            'bots-edit-skill-git-helper',
            'bots-edit-toolset-terminal',
            'bots-edit-mcp-github',
          ]) {
            final field = find.byKey(Key(key));
            await tester.ensureVisible(field);
            await botsStep(tester, 2);
            expect(field.hitTestable(), findsOneWidget, reason: key);
          }
        });
        expect(errors, isEmpty, reason: errors.join('\n'));
      });

      testWidgets('F11 the New Bot form, every field above the keyboard', (
        tester,
      ) async {
        _phone(tester);
        final gateway = BotsReviewGateway();
        final owner = botsReviewOwner(gateway);
        addTearDown(owner.close);
        final errors = await _overflows(tester, () async {
          await tester.pumpWidget(
            _app(
              layout,
              BotsScreen(
                owner: owner,
                route: owner.route(),
                connection: botsReviewConnection,
                pickAvatarImage: () async =>
                    'data:image/png;base64,$botsFixturePng',
              ),
            ),
          );
          await botsShown(tester, find.text('WorkBot'));
          await tester.tap(find.byKey(const Key('bots-new-bot')));
          await botsStep(tester);
          await tester.enterText(
            find.byKey(const Key('bots-new-name')),
            'Smørrebrød Research Assistant',
          );
          await botsStep(tester, 2);
          tester.view.viewInsets = const FakeViewPadding(bottom: _keyboard);
          await botsStep(tester);
          await tester.ensureVisible(
            find.byKey(const Key('bots-avatar-upload')),
          );
          await botsStep(tester, 2);
          await tester.tap(find.byKey(const Key('bots-avatar-upload')));
          await botsStep(tester, 2);
          await tester.ensureVisible(
            find.byKey(const Key('bots-new-advanced')),
          );
          await botsStep(tester, 2);
          await tester.tap(find.byKey(const Key('bots-new-advanced')));
          await botsStep(tester);
          // Whatever takes the keyboard, and Create, fits above it.
          for (final key in [
            'bots-new-name',
            'bots-new-title',
            'bots-new-description',
            'bots-new-clone',
            'bots-new-provider',
            'bots-new-model',
            'bots-new-soul',
            'bots-form-save',
          ]) {
            final field = find.byKey(Key(key));
            await tester.ensureVisible(field);
            await botsStep(tester, 2);
            _expectAboveKeyboard(tester, field);
          }
          // The pickers and switches scroll into reach (at 2.0x a long
          // label can be taller than what the keyboard leaves).
          for (final key in [
            'bots-avatar-shape-drop',
            'bots-avatar-colour-11',
            'bots-avatar-remove',
            'bots-new-no-skills',
            'bots-new-share-auth',
          ]) {
            final field = find.byKey(Key(key));
            await tester.ensureVisible(field);
            await botsStep(tester, 2);
            expect(field.hitTestable(), findsOneWidget, reason: key);
          }
        });
        expect(errors, isEmpty, reason: errors.join('\n'));
      });
    });
  }
}
