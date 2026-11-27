// Bot Mode roster search as Desktop's filterBots (data.ts, b7ee21c14e):
// the query, trimmed, lowercased and without a leading @, matches the title
// the row shows, the profile id, the @handle, the description and the
// preview of the bot's latest activity (review of deb6f558, PROBE B-S1).
// Also keeps the review's passing New Bot form probes (B-K1, B-L1).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/bots_screen.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/bots_review_fixture.dart';

enum _Layout { classic, nextGen }

ThemeData _theme(_Layout layout) => switch (layout) {
  _Layout.classic => hermesTheme(Brightness.light),
  _Layout.nextGen => nextGenTheme(Brightness.light, NextGenLook.instance),
};

Finder _row(String name) => find.byKey(Key('bots-row-$name'));

/// The roster's search field, with the roster shown.
Future<Finder> _roster(WidgetTester tester, BotsReviewGateway gateway) async {
  tester.view.physicalSize = const Size(900, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final owner = botsReviewOwner(gateway);
  addTearDown(owner.close);
  await tester.pumpWidget(botsReviewApp(owner));
  await botsShown(tester, _row('workbot'));
  return find
      .descendant(of: find.byType(BotsScreen), matching: find.byType(TextField))
      .first;
}

Future<Set<String>> _search(
  WidgetTester tester,
  Finder field,
  String query,
) async {
  await tester.enterText(field, query);
  await botsStep(tester, 3);
  return {
    for (final name in ['workbot', 'researchbot', 'default', 'research-buddy'])
      if (_row(name).evaluate().isNotEmpty) name,
  };
}

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
    errors.add(text.split('\n').first);
  };
  try {
    await body();
  } finally {
    FlutterError.onError = previous;
  }
  return errors;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('roster search', () {
    testWidgets('B-S1: a bot is found by the title its row shows', (
      tester,
    ) async {
      // ResearchBot renamed in Edit Profile: its record's title is "Scout".
      final gateway = BotsReviewGateway()
        ..bumpRevision('researchbot', {'title': 'Scout'});
      final field = await _roster(tester, gateway);
      await botsShown(tester, find.text('Scout'));
      // Control: found by its profile id.
      expect(await _search(tester, field, 'researchbot'), {'researchbot'});
      expect(await _search(tester, field, 'Scout'), {'researchbot'});
      expect(await _search(tester, field, 'scou'), {'researchbot'});
    });

    testWidgets('a leading @ is the handle form of the same search', (
      tester,
    ) async {
      final field = await _roster(tester, BotsReviewGateway());
      expect(await _search(tester, field, '@researchbot'), {'researchbot'});
      expect(await _search(tester, field, '  @work  '), {'workbot'});
    });

    testWidgets('the default profile is found by its @hermes handle', (
      tester,
    ) async {
      final gateway = BotsReviewGateway();
      gateway.profiles.add({
        'name': 'default',
        'path': '/home/bots',
        'is_default': true,
        'model': 'claude-sonnet',
        'provider': 'anthropic',
        'description': '',
        'display_name': '',
        'skill_count': 0,
      });
      final field = await _roster(tester, gateway);
      expect(await _search(tester, field, '@hermes'), {'default'});
    });

    testWidgets('the preview of the latest activity is searched: the fresher '
        'of the Bot Chat and the last session', (tester) async {
      final gateway = BotsReviewGateway();
      gateway.profiles.firstWhere((p) => p['name'] == 'researchbot')
        ..['canonical_session'] = {
          'id': 'sess-canonical-researchbot',
          'preview': 'Triaged the inbox overnight',
          'last_active': 200,
        }
        ..['last_session'] = {'preview': 'older notes', 'last_active': 100};
      final field = await _roster(tester, gateway);
      // workbot's last session preview.
      expect(await _search(tester, field, 'coding turn'), {'workbot'});
      expect(await _search(tester, field, 'inbox'), {'researchbot'});
    });

    testWidgets('an untitled name is also found as Desktop spells it', (
      tester,
    ) async {
      final gateway = BotsReviewGateway();
      gateway.profiles.add({
        'name': 'research-buddy',
        'path': '/home/bots/research-buddy',
        'is_default': false,
        'model': 'gpt-5',
        'provider': 'openrouter',
        'description': '',
        'display_name': '',
        'skill_count': 0,
      });
      final field = await _roster(tester, gateway);
      expect(await _search(tester, field, 'research buddy'), {
        'research-buddy',
      });
      // The description still counts.
      expect(await _search(tester, field, 'primary worker'), {'workbot'});
    });
  });

  group('New Bot form (review probes that passed)', () {
    for (final layout in _Layout.values) {
      testWidgets('B-K1 ${layout.name}: dialog forms (>= 480 px) at 2.0x '
          'text with a 300 px keyboard keep every field reachable above it', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(640, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        addTearDown(tester.view.resetViewInsets);
        const keyboard = 300.0;
        final owner = botsReviewOwner(BotsReviewGateway());
        addTearDown(owner.close);
        final below = <String>[];
        final errors = await _overflows(tester, () async {
          await tester.pumpWidget(
            botsReviewApp(owner, textScale: 2, theme: _theme(layout)),
          );
          await botsShown(tester, find.text('WorkBot'));
          await tester.tap(find.byKey(const Key('bots-new-bot')));
          await botsStep(tester);
          expect(find.byType(Dialog), findsOneWidget);
          tester.view.viewInsets = const FakeViewPadding(bottom: keyboard);
          await botsStep(tester);
          final advanced = find.byKey(const Key('bots-new-advanced'));
          await tester.ensureVisible(advanced);
          await botsStep(tester, 2);
          await tester.tap(advanced);
          await botsStep(tester);
          for (final key in [
            'bots-new-name',
            'bots-new-title',
            'bots-new-description',
            'bots-new-provider',
            'bots-new-model',
            'bots-new-soul',
            'bots-form-save',
          ]) {
            final field = find.byKey(Key(key));
            await tester.ensureVisible(field);
            await botsStep(tester, 2);
            final rect = tester.getRect(field);
            if (rect.bottom > 640 - keyboard || rect.top < 0) {
              below.add('$key $rect');
            }
          }
        });
        expect(errors, isEmpty);
        expect(below, isEmpty);
      });
    }

    testWidgets('B-L1: New Bot form strings in Japanese', (tester) async {
      tester.view.physicalSize = const Size(900, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final owner = botsReviewOwner(BotsReviewGateway());
      addTearDown(owner.close);
      await tester.pumpWidget(botsReviewApp(owner, locale: const Locale('ja')));
      await botsShown(tester, find.text('WorkBot'));
      await tester.tap(find.byKey(const Key('bots-new-bot')));
      await botsStep(tester);
      await tester.tap(find.byKey(const Key('bots-new-advanced')));
      await botsStep(tester);
      final en = lookupAppLocalizations(const Locale('en'));
      final english = [
        en.ng_bots_new_bot,
        en.ng_bots_field_name,
        en.ng_bots_field_title,
        en.ng_bots_field_description,
        en.ng_bots_advanced,
        en.ng_bots_clone_from,
        en.ng_bots_create_bot,
        en.ng_bots_avatar_upload,
      ];
      expect([
        for (final text in english)
          if (find.text(text).evaluate().isNotEmpty) text,
      ], isEmpty);
    });
  });
}
