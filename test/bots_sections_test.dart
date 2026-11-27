// F11 roster sections (t_8d18f507 item 3): Desktop's user-sections.ts at
// b7ee21c14e. Membership rides each bot's ui_meta record; the section list
// is this device's (per connection); collapse lasts for the visit; a search
// looks in every section. Classic and NextGen.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/bot_sections.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/bots_review_fixture.dart';

enum _Layout { classic, nextGen }

ThemeData _theme(_Layout layout) => switch (layout) {
  _Layout.classic => hermesTheme(Brightness.light),
  _Layout.nextGen => nextGenTheme(Brightness.light, NextGenLook.instance),
};

final _scope = BotSectionStore.key('c-bots', 'work');

BotRosterProfile _bot(String name, Map<String, dynamic> extra) =>
    BotRosterProfile.fromJson({'name': name, 'path': '/p/$name', ...extra});

Map<String, dynamic> _session(double at) => {
  'id': 's-$at',
  'resolved_id': 's-$at',
  'last_active': at,
};

/// The fixture's two bots plus a pinned one and an older one.
BotsReviewGateway _gateway() {
  final gateway = BotsReviewGateway();
  gateway.profiles[1]['canonical_session'] = _session(2000);
  gateway.profiles.addAll([
    {
      'name': 'pinnedbot',
      'path': '/home/bots/pinnedbot',
      'display_name': 'PinnedBot',
    },
    {
      'name': 'oldbot',
      'path': '/home/bots/oldbot',
      'display_name': 'OldBot',
      'last_session': _session(1000),
    },
  ]);
  gateway.bumpRevision('pinnedbot', {'pinned': true});
  return gateway;
}

Future<void> _sections(List<Map<String, String>> sections) async {
  SharedPreferences.setMockInitialValues({_scope: jsonEncode(sections)});
}

Future<List<BotSection>> _stored() async => normalizeBotSections(
  jsonDecode((await SharedPreferences.getInstance()).getString(_scope) ?? '[]'),
);

double _y(WidgetTester tester, String key) =>
    tester.getTopLeft(find.byKey(Key(key))).dy;

Future<void> _tapKey(WidgetTester tester, String key) async {
  final target = find.byKey(Key(key));
  await tester.ensureVisible(target);
  await botsStep(tester, 1);
  await tester.tap(target);
  await botsStep(tester, 3);
}

/// Opens [menu] and picks [item] once the menu has finished opening.
Future<void> _pick(WidgetTester tester, String menu, String item) async {
  await _tapKey(tester, menu);
  await botsStep(tester, 4);
  await tester.tap(find.byKey(Key(item)));
  await botsStep(tester, 4);
}

Future<void> _moveTo(WidgetTester tester, String bot, String option) async {
  await _pick(tester, 'bots-row-menu-$bot', 'bots-row-move');
  await tester.tap(find.byKey(Key(option)));
  await botsStep(tester, 6);
}

Map<String, dynamic> _written(BotsReviewGateway gateway) =>
    (gateway.named('profiles.configure').last.params['ui_meta']
            as Map)['hermes-bots']
        as Map<String, dynamic>;

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    WidgetController.hitTestWarningShouldBeFatal = true;
  });
  tearDown(() => WidgetController.hitTestWarningShouldBeFatal = false);

  group('model (user-sections.ts)', () {
    test('every row lands once: sections in order, Unassigned last, a gone '
        'section\'s members Unassigned', () {
      final rows = [
        _bot('a', {
          'ui_meta': {
            'hermes-bots': {'sectionId': 's2'},
          },
        }),
        _bot('b', {
          'ui_meta': {
            'hermes-bots': {'sectionId': 'gone'},
          },
        }),
        _bot('c', {}),
      ];
      final blocks = groupBotsBySection(rows, const [
        BotSection('s1', 'One'),
        BotSection('s2', 'Two'),
      ]);
      expect([for (final b in blocks) b.id], ['s1', 's2', null]);
      expect(
        [for (final b in blocks) b.rows.map((r) => r.name).toList()],
        [
          <String>[],
          ['a'],
          ['b', 'c'],
        ],
      );
    });

    test('pinned first, then newest of created and last message', () {
      final sorted = sortBotRoster([
        _bot('old', {'last_session': _session(10)}),
        _bot('new', {
          'ui_meta': {
            'hermes-bots': {'created': 50000},
          },
        }),
        _bot('pin', {
          'ui_meta': {
            'hermes-bots': {'pinned': true},
          },
        }),
        _bot('chat', {'canonical_session': _session(40)}),
      ]);
      expect(sorted.map((b) => b.name), ['pin', 'new', 'chat', 'old']);
    });

    test('adopts sections other devices made; a name changes only when '
        'every member agrees; a pending delete is not rebuilt', () {
      Map<String, dynamic> filed(String id, String name) => {
        'ui_meta': {
          'hermes-bots': {'sectionId': id, 'sectionName': name},
        },
      };
      final roster = [
        _bot('a', filed('s1', 'Renamed')),
        _bot('b', filed('s2', 'X')),
        _bot('c', filed('s2', 'Y')),
        _bot('d', filed('s3', 'Remote')),
        _bot('e', filed('s4', 'Deleting')),
      ];
      expect(
        adoptBotSections(
          const [BotSection('s1', 'Old'), BotSection('s2', 'Local')],
          roster,
          {'s4'},
        ),
        const [
          BotSection('s1', 'Renamed'),
          BotSection('s2', 'Local'),
          BotSection('s3', 'Remote'),
        ],
      );
      expect(
        normalizeBotSections([
          {'id': ' s1 ', 'name': ' A '},
          {'id': 's1', 'name': 'dup'},
          {'id': '', 'name': 'x'},
          {'id': 's2', 'name': ''},
        ]),
        const [BotSection('s1', 'A')],
      );
      expect(
        newBotSectionId(),
        matches(RegExp(r'^sec-[0-9a-z]+-[0-9a-z]{5}$')),
      );
    });
  });

  for (final layout in _Layout.values) {
    group(layout.name, () {
      Future<BotsReviewGateway> pump(
        WidgetTester tester, {
        BotsReviewGateway? gateway,
        Key? key,
      }) async {
        tester.view.physicalSize = const Size(900, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        final g = gateway ?? _gateway();
        final owner = botsReviewOwner(g);
        addTearDown(owner.close);
        await tester.pumpWidget(
          KeyedSubtree(
            key: key ?? UniqueKey(),
            child: botsReviewApp(owner, theme: _theme(layout)),
          ),
        );
        await botsShown(tester, find.text('WorkBot'));
        await botsStep(tester, 4);
        return g;
      }

      testWidgets('sections in their order, an empty one kept, Unassigned '
          'last; pinned first, then newest activity', (tester) async {
        await _sections([
          {'id': 'sec-a', 'name': 'Clients'},
          {'id': 'sec-b', 'name': 'Ops'},
        ]);
        final gateway = _gateway()
          ..bumpRevision('workbot', {
            'sectionId': 'sec-b',
            'sectionName': 'Ops',
          });
        await pump(tester, gateway: gateway);
        final order = [
          'bots-section-sec-a',
          'bots-section-empty-sec-a',
          'bots-section-sec-b',
          'bots-row-workbot',
          'bots-section-unassigned',
          'bots-row-pinnedbot',
          'bots-row-researchbot',
          'bots-row-oldbot',
        ];
        for (var i = 1; i < order.length; i++) {
          expect(
            _y(tester, order[i - 1]),
            lessThan(_y(tester, order[i])),
            reason: '${order[i - 1]} above ${order[i]}',
          );
        }
        expect(find.text('Unassigned'), findsOneWidget);
        // Reading the roster writes nothing.
        expect(gateway.named('profiles.configure'), isEmpty);
      });

      testWidgets('collapsing lasts for the visit and is not stored; a search '
          'looks in every section', (tester) async {
        await _sections([
          {'id': 'sec-b', 'name': 'Ops'},
        ]);
        final gateway = _gateway()
          ..bumpRevision('workbot', {
            'sectionId': 'sec-b',
            'sectionName': 'Ops',
          });
        await pump(tester, gateway: gateway);
        await _tapKey(tester, 'bots-section-sec-b');
        expect(find.byKey(const Key('bots-row-workbot')), findsNothing);
        await tester.enterText(find.byType(TextField).first, 'work');
        await botsStep(tester, 3);
        expect(find.byKey(const Key('bots-row-workbot')), findsOneWidget);
        expect(find.byKey(const Key('bots-row-researchbot')), findsNothing);
        await tester.enterText(find.byType(TextField).first, '');
        await botsStep(tester, 3);
        expect(find.byKey(const Key('bots-row-workbot')), findsNothing);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getKeys(), {_scope});
        // A new visit starts with everything open.
        await pump(tester, gateway: gateway);
        expect(find.byKey(const Key('bots-row-workbot')), findsOneWidget);
      });

      testWidgets('Move to section files the bot on its own record, with the '
          'section\'s name', (tester) async {
        await _sections([
          {'id': 'sec-a', 'name': 'Clients'},
        ]);
        final gateway = await pump(tester);
        await _moveTo(tester, 'researchbot', 'bots-move-to-sec-a');
        expect(gateway.refusals, isEmpty);
        final write = gateway.named('profiles.configure').single.params;
        expect(write['name'], 'researchbot');
        expect(write['ui_meta_expected_revisions'], {'hermes-bots': 0});
        expect(_written(gateway), {
          'sectionId': 'sec-a',
          'sectionName': 'Clients',
        });
        expect(
          _y(tester, 'bots-row-researchbot'),
          lessThan(_y(tester, 'bots-section-unassigned')),
        );
        // Remove from section clears both fields.
        await _moveTo(tester, 'researchbot', 'bots-move-to-none');
        expect(_written(gateway), {'sectionId': null, 'sectionName': null});
        expect(
          _y(tester, 'bots-row-researchbot'),
          greaterThan(_y(tester, 'bots-section-unassigned')),
        );
      });

      testWidgets('New section… from a bot\'s menu makes this device\'s '
          'record and files the bot', (tester) async {
        final gateway = await pump(tester);
        expect(find.byKey(const Key('bots-section-unassigned')), findsNothing);
        await _moveTo(tester, 'workbot', 'bots-move-to-new');
        await tester.enterText(
          find.byKey(const Key('bots-section-name')),
          '  Partners ',
        );
        await tester.tap(find.byKey(const Key('bots-section-ok')));
        await botsStep(tester, 6);
        final stored = await _stored();
        expect(stored.single.name, 'Partners');
        expect(stored.single.id, startsWith('sec-'));
        expect(_written(gateway), {
          'sectionId': stored.single.id,
          'sectionName': 'Partners',
        });
        expect(find.text('Partners'), findsOneWidget);
        expect(
          find.byKey(const Key('bots-section-unassigned')),
          findsOneWidget,
        );
      });

      testWidgets('a section another device made is rebuilt from what its '
          'members carry', (tester) async {
        final gateway = _gateway()
          ..bumpRevision('oldbot', {
            'sectionId': 'sec-remote',
            'sectionName': 'Remote',
          });
        await pump(tester, gateway: gateway);
        expect(find.text('Remote'), findsOneWidget);
        expect(await _stored(), const [BotSection('sec-remote', 'Remote')]);
        expect(gateway.named('profiles.configure'), isEmpty);
      });

      testWidgets('Rename re-stamps members; Delete files them Unassigned and '
          'Undo puts them back', (tester) async {
        await _sections([
          {'id': 'sec-b', 'name': 'Ops'},
        ]);
        final gateway = _gateway()
          ..bumpRevision('workbot', {
            'sectionId': 'sec-b',
            'sectionName': 'Ops',
          });
        await pump(tester, gateway: gateway);
        await _pick(tester, 'bots-section-menu-sec-b', 'bots-section-rename');
        await tester.enterText(
          find.byKey(const Key('bots-section-name')),
          'Operations',
        );
        await tester.tap(find.byKey(const Key('bots-section-ok')));
        await botsStep(tester, 6);
        expect(_written(gateway), {
          'sectionId': 'sec-b',
          'sectionName': 'Operations',
        });
        expect(await _stored(), const [BotSection('sec-b', 'Operations')]);

        await _pick(tester, 'bots-section-menu-sec-b', 'bots-section-delete');
        await botsStep(tester, 4);
        expect(_written(gateway), {'sectionId': null, 'sectionName': null});
        expect(await _stored(), isEmpty);
        expect(
          find.text('Deleted “Operations” — 1 bot moved to Unassigned'),
          findsOneWidget,
        );
        expect(find.byKey(const Key('bots-section-sec-b')), findsNothing);
        await tester.tap(find.byKey(const Key('bots-section-undo')));
        await botsStep(tester, 6);
        expect(await _stored(), const [BotSection('sec-b', 'Operations')]);
        expect(_written(gateway), {
          'sectionId': 'sec-b',
          'sectionName': 'Operations',
        });
        expect(gateway.refusals, isEmpty);
      });

      testWidgets('a filing the gateway does not apply is reported and the '
          'roster re-read', (tester) async {
        await _sections([
          {'id': 'sec-a', 'name': 'Clients'},
        ]);
        final gateway = _gateway()..failSections.add('ui_meta');
        await pump(tester, gateway: gateway);
        final reads = gateway.named('profiles.list').length;
        await _moveTo(tester, 'researchbot', 'bots-move-to-sec-a');
        expect(find.text('Could not move the bot (ui_meta).'), findsOneWidget);
        expect(gateway.named('profiles.list').length, greaterThan(reads + 1));
        expect(
          _y(tester, 'bots-row-researchbot'),
          greaterThan(_y(tester, 'bots-section-unassigned')),
        );
      });

      testWidgets('a filing reply after the connection changed is dropped', (
        tester,
      ) async {
        await _sections([
          {'id': 'sec-a', 'name': 'Clients'},
        ]);
        tester.view.physicalSize = const Size(900, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        final first = _gateway()..failSections.add('ui_meta');
        final second = _gateway();
        final owner = botsReviewOwner(first);
        final other = botsReviewOwner(second);
        addTearDown(owner.close);
        addTearDown(other.close);
        await tester.pumpWidget(botsReviewApp(owner, theme: _theme(layout)));
        await botsShown(tester, find.text('WorkBot'));
        await botsStep(tester, 4);
        final hold = Completer<void>();
        first.holds['profiles.configure:null:'] = hold;
        await _moveTo(tester, 'researchbot', 'bots-move-to-sec-a');
        final reads = first.named('profiles.list').length;
        await tester.pumpWidget(botsReviewApp(other, theme: _theme(layout)));
        await botsStep(tester, 4);
        hold.complete();
        await botsStep(tester, 8);
        expect(find.textContaining('Could not move the bot'), findsNothing);
        expect(first.named('profiles.list').length, reads);
        expect(second.named('profiles.configure'), isEmpty);
      });
    });
  }
}
