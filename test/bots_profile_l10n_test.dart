// F11 New Bot, Edit Profile and roster sections (t_8d18f507): every string
// comes from the ARBs, in every locale, and a German render shows none of
// the English.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/bots_review_fixture.dart';

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

void _expectLocalised(Set<String> seen, List<String> keys, String where) {
  final en = _arb('en');
  final de = _arb('de');
  for (final key in keys) {
    expect(de[key], isA<String>(), reason: 'app_de.arb has no $key');
    expect(seen, contains(de[key]), reason: '$where does not show $key');
    if (de[key] != en[key]) {
      expect(
        seen,
        isNot(contains(en[key])),
        reason: '$where shows $key in English',
      );
    }
  }
}

void _wide(WidgetTester tester) {
  tester.view.physicalSize = const Size(1000, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('every ng_bots_ key is in all 14 ARBs', () {
    final en = _arb('en');
    final keys = en.keys.where((k) => k.startsWith('ng_bots_')).toList();
    expect(keys, contains('ng_bots_new_bot'));
    final locales = Directory('lib/l10n')
        .listSync()
        .map((f) => f.path.split('/').last)
        .where((n) => n.startsWith('app_') && n.endsWith('.arb'))
        .toList();
    expect(locales, hasLength(14));
    for (final name in locales) {
      final arb = _arb(name.substring(4, name.length - 4));
      final missing = keys.where((k) => arb[k] is! String).toList();
      expect(missing, isEmpty, reason: '$name lacks $missing');
    }
  });

  testWidgets('New Bot in German', (tester) async {
    _wide(tester);
    final gateway = BotsReviewGateway();
    final owner = botsReviewOwner(gateway);
    addTearDown(owner.close);
    await tester.pumpWidget(
      botsReviewApp(
        owner,
        locale: _german,
        pickAvatarImage: () async => 'data:image/png;base64,$botsFixturePng',
      ),
    );
    await botsShown(tester, find.text('WorkBot'));
    await tester.tap(find.byKey(const Key('bots-new-bot')));
    await botsStep(tester, 4);
    await tester.enterText(find.byKey(const Key('bots-new-name')), 'workbot');
    await botsStep(tester, 2);
    await tester.tap(find.byKey(const Key('bots-avatar-upload')));
    await botsStep(tester, 2);
    await tester.ensureVisible(find.byKey(const Key('bots-new-advanced')));
    await tester.tap(find.byKey(const Key('bots-new-advanced')));
    await botsStep(tester, 4);
    final seen = _shown();
    _expectLocalised(seen, const [
      'ng_bots_new_bot',
      'ng_bots_new_bot_hint',
      'ng_bots_field_name',
      'ng_bots_field_title',
      'ng_bots_field_description',
      'ng_bots_avatar_shape',
      'ng_bots_avatar_colour',
      'ng_bots_avatar_match_name',
      'ng_bots_avatar_upload',
      'ng_bots_avatar_remove',
      'ng_bots_advanced',
      'ng_bots_clone_from',
      'ng_bots_clone_main',
      'ng_bots_create_empty',
      'ng_bots_share_keys',
      'ng_bots_provider',
      'ng_bots_model',
      'ng_bots_soul',
      'ng_bots_create_bot',
    ], 'New Bot');
    expect(seen, contains('Ein Agent namens „workbot“ existiert bereits.'));
  });

  testWidgets('Edit Profile and its confirmation in German', (tester) async {
    _wide(tester);
    final gateway = BotsReviewGateway();
    final owner = botsReviewOwner(gateway);
    addTearDown(owner.close);
    await tester.pumpWidget(botsReviewApp(owner, locale: _german));
    await botsShown(tester, find.text('WorkBot'));
    await botsStep(tester, 3);
    await tester.tap(find.text('WorkBot'));
    await botsStep(tester, 3);
    await tester.tap(find.byKey(const Key('bots-edit-profile')));
    await botsStep(tester, 4);
    await tester.ensureVisible(find.byKey(const Key('bots-edit-advanced')));
    await tester.tap(find.byKey(const Key('bots-edit-advanced')));
    await botsStep(tester, 4);
    var seen = _shown();
    _expectLocalised(seen, const [
      'ng_bots_edit_profile',
      'ng_bots_avatar_remove',
      'ng_bots_advanced',
      'ng_bots_provider',
      'ng_bots_model',
      'ng_bots_skills',
      'ng_bots_toolsets',
      'ng_bots_toolsets_hint',
      'ng_bots_mcp_servers',
    ], 'Edit Profile');
    expect(seen, contains('Aussehen und Rolle von WorkBot (workbot).'));
    await tester.ensureVisible(find.byKey(const Key('bots-avatar-remove')));
    await tester.tap(find.byKey(const Key('bots-avatar-remove')));
    await botsStep(tester, 2);
    await tester.ensureVisible(find.byKey(const Key('bots-form-save')));
    await tester.tap(find.byKey(const Key('bots-form-save')));
    await botsStep(tester, 3);
    seen = _shown();
    _expectLocalised(seen, const [
      'ng_bots_confirm_changes_title',
    ], 'the save confirmation');
    expect(seen, contains('• Das Bild des Bots entfernen'));
  });

  testWidgets('roster sections and their menus in German', (tester) async {
    _wide(tester);
    SharedPreferences.setMockInitialValues({
      'bot-sections-v1:c-bots:work': '[{"id":"sec-a","name":"Kunden"}]',
    });
    final gateway = BotsReviewGateway()
      ..bumpRevision('workbot', {
        'sectionId': 'sec-a',
        'sectionName': 'Kunden',
      });
    final owner = botsReviewOwner(gateway);
    addTearDown(owner.close);
    await tester.pumpWidget(botsReviewApp(owner, locale: _german));
    await botsShown(tester, find.text('WorkBot'));
    await botsStep(tester, 4);
    final seen = _shown();
    await tester.tap(find.byKey(const Key('bots-section-menu-sec-a')));
    await botsStep(tester, 6);
    seen.addAll(_shown());
    await tester.tapAt(const Offset(4, 4));
    await botsStep(tester, 6);
    await tester.tap(find.byKey(const Key('bots-row-menu-workbot')));
    await botsStep(tester, 6);
    seen.addAll(_shown());
    await tester.tap(find.byKey(const Key('bots-row-move')));
    await botsStep(tester, 6);
    seen.addAll(_shown());
    _expectLocalised(seen, const [
      'ng_bots_section_new',
      'ng_bots_section_unassigned',
      'ng_bots_section_rename',
      'ng_bots_section_move_up',
      'ng_bots_section_move_down',
      'ng_bots_section_delete',
      'ng_bots_edit_profile',
      'ng_bots_section_move_to',
      'ng_bots_section_new_ellipsis',
      'ng_bots_section_remove',
    ], 'the sections');
    expect(seen, contains('Optionen für Bereich Kunden'));
    expect(seen, contains('Aktionen für WorkBot'));
  });
}
