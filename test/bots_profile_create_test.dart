// F11 New Bot (t_8d18f507 item 1): Desktop's create-dialog.tsx at
// b7ee21c14e against a gateway that validates `profiles.*` the way
// tui_gateway/methods_profiles.py does, in the Classic and NextGen themes.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/bot_profile_forms.dart';
import 'package:hermes_android/core/services/remote_workspace.dart'
    show botProfileIdPattern, botProfileIdentity, botProfileSlug;
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

void _size(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

const _pickedAvatar = 'data:image/png;base64,$botsFixturePng';

Future<void> _openNewBot(WidgetTester tester) async {
  await botsShown(tester, find.text('WorkBot'));
  await tester.tap(find.byKey(const Key('bots-new-bot')));
  await botsStep(tester, 4);
  expect(find.byKey(const Key('bots-new-name')), findsOneWidget);
}

Future<void> _type(WidgetTester tester, String key, String text) async {
  final field = find.byKey(Key(key));
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
  await botsStep(tester, 2);
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  final target = find.byKey(Key(key));
  await tester.ensureVisible(target);
  await botsStep(tester, 1);
  await tester.tap(target);
  await botsStep(tester, 3);
}

bool _enabled(WidgetTester tester, String key) =>
    tester.widget<FilledButton>(find.byKey(Key(key))).onPressed != null;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('the profile id is Desktop\'s slugifyProfileName', () {
    expect(botProfileSlug('Research Buddy'), 'research-buddy');
    expect(botProfileSlug('Résumé  Bot!'), 'resume-bot');
    expect(botProfileSlug('小助手'), 'u5c0f-u52a9-u624b');
    expect(botProfileSlug('Smørrebrød'), 'sm-uf8-rrebr-uf8-d');
    expect(botProfileSlug('_x'), '_x');
    expect(botProfileIdPattern.hasMatch(botProfileSlug('_x')), isFalse);
    expect(botProfileSlug('a' * 70).length, 64);
    expect(botProfileIdentity('小助手', '').title, '小助手');
    expect(botProfileIdentity('Ada', '').title, '');
  });

  for (final layout in _Layout.values) {
    group(layout.name, () {
      testWidgets('Cancel sends nothing: the profile is made on Create only', (
        tester,
      ) async {
        _size(tester, const Size(900, 1200));
        final gateway = BotsReviewGateway();
        final owner = botsReviewOwner(gateway);
        addTearDown(owner.close);
        await tester.pumpWidget(botsReviewApp(owner, theme: _theme(layout)));
        await _openNewBot(tester);
        await _type(tester, 'bots-new-name', 'scout');
        await _tapKey(tester, 'bots-form-cancel');
        expect(find.byKey(const Key('bots-new-name')), findsNothing);
        expect(gateway.named('profiles.create'), isEmpty);
        expect(gateway.named('profiles.configure'), isEmpty);
        expect(gateway.named('profiles.set_asset'), isEmpty);
      });

      testWidgets('Create sends profiles.create as Desktop does, then the '
          'look (CAS) and the picture', (tester) async {
        _size(tester, const Size(900, 1400));
        final gateway = BotsReviewGateway();
        final owner = botsReviewOwner(gateway);
        addTearDown(owner.close);
        await tester.pumpWidget(
          botsReviewApp(
            owner,
            theme: _theme(layout),
            pickAvatarImage: () async => _pickedAvatar,
          ),
        );
        await _openNewBot(tester);
        expect(_enabled(tester, 'bots-form-save'), isFalse);
        await _type(tester, 'bots-new-name', 'Research Buddy');
        expect(find.text('Profile id: research-buddy'), findsOneWidget);
        await _type(tester, 'bots-new-title', 'Scout');
        await _type(tester, 'bots-new-description', 'Finds papers');
        await _tapKey(tester, 'bots-avatar-shape-hexagon');
        await _tapKey(tester, 'bots-avatar-colour-2');
        await _tapKey(tester, 'bots-avatar-upload');
        expect(find.byKey(const Key('bots-avatar-remove')), findsOneWidget);
        await _tapKey(tester, 'bots-new-advanced');
        await _tapKey(tester, 'bots-new-no-skills');
        await _tapKey(tester, 'bots-form-save');
        await botsStep(tester, 6);

        expect(gateway.refusals, isEmpty);
        final create = gateway.named('profiles.create').single.params;
        expect(create['name'], 'research-buddy');
        expect(create['description'], 'Scout — Finds papers');
        expect(create['clone_from'], 'default');
        expect(create['no_skills'], isTrue);
        expect(create['share_auth'], isTrue);
        expect(create.containsKey('profile'), isFalse);
        expect(create['soul'], contains('# Scout'));
        expect(create['soul'], contains('**Mission:** Finds papers'));
        expect(create['soul'], contains('(profile `research-buddy`)'));
        expect(create.containsKey('model'), isFalse);

        final configure = gateway.named('profiles.configure').single.params;
        expect(configure['name'], 'research-buddy');
        expect(configure['ui_meta_expected_revisions'], {'hermes-bots': 0});
        final look = (configure['ui_meta'] as Map)['hermes-bots'] as Map;
        expect(look['shape'], 'hexagon');
        expect(look['color'], 'hsl(60 68% 58%)');
        expect(look['imageKind'], 'photo');
        expect(look['title'], 'Scout');
        expect(look['created'], isA<int>());
        expect(look.containsKey('image'), isFalse);
        expect(gateway.avatars['research-buddy'], _pickedAvatar);

        // The form closed and the roster shows the new bot by its title.
        expect(find.byKey(const Key('bots-new-name')), findsNothing);
        await botsShown(tester, find.text('Scout'));
        expect(find.textContaining('Bot “Scout” created'), findsOneWidget);
      });

      testWidgets('name rules: an invalid or taken id keeps Create off, with '
          'the reason under the field', (tester) async {
        _size(tester, const Size(900, 1200));
        final gateway = BotsReviewGateway();
        final owner = botsReviewOwner(gateway);
        addTearDown(owner.close);
        await tester.pumpWidget(botsReviewApp(owner, theme: _theme(layout)));
        await _openNewBot(tester);
        await _type(tester, 'bots-new-name', '_x');
        expect(
          find.textContaining('starting with a letter or number'),
          findsOneWidget,
        );
        expect(_enabled(tester, 'bots-form-save'), isFalse);
        await _type(tester, 'bots-new-name', 'WorkBot');
        expect(
          find.text('An agent named “workbot” already exists.'),
          findsOneWidget,
        );
        expect(_enabled(tester, 'bots-form-save'), isFalse);
        await _type(tester, 'bots-new-name', '小助手');
        expect(find.text('Profile id: u5c0f-u52a9-u624b'), findsOneWidget);
        expect(_enabled(tester, 'bots-form-save'), isTrue);
        // A provider without a model is not a pick.
        await _tapKey(tester, 'bots-new-advanced');
        await _type(tester, 'bots-new-provider', 'anthropic');
        expect(find.text('Enter both a provider and a model.'), findsOneWidget);
        expect(_enabled(tester, 'bots-form-save'), isFalse);
        expect(gateway.named('profiles.create'), isEmpty);
      });

      testWidgets('the gateway\'s refusal is shown in the form, which stays '
          'open and writes nothing else', (tester) async {
        _size(tester, const Size(900, 1200));
        final gateway = BotsReviewGateway();
        final owner = botsReviewOwner(gateway);
        addTearDown(owner.close);
        await tester.pumpWidget(botsReviewApp(owner, theme: _theme(layout)));
        await _openNewBot(tester);
        // `test` passes the id grammar; the gateway reserves it.
        await _type(tester, 'bots-new-name', 'test');
        await _tapKey(tester, 'bots-form-save');
        await botsStep(tester, 4);
        expect(gateway.named('profiles.create'), hasLength(1));
        expect(
          tester.widget<Text>(find.byKey(const Key('bots-form-error'))).data,
          contains("Profile name 'test' is reserved"),
        );
        expect(find.byKey(const Key('bots-new-name')), findsOneWidget);
        expect(_enabled(tester, 'bots-form-save'), isTrue);
        expect(gateway.named('profiles.configure'), isEmpty);
        expect(gateway.named('profiles.set_asset'), isEmpty);
      });

      testWidgets('a create reply that lands after the connection changed is '
          'dropped: no look, no picture, no report', (tester) async {
        _size(tester, const Size(900, 1200));
        final first = BotsReviewGateway();
        final second = BotsReviewGateway();
        final hold = Completer<void>();
        first.holds['profiles.create:null:'] = hold;
        final owner = botsReviewOwner(first);
        final other = botsReviewOwner(second);
        addTearDown(owner.close);
        addTearDown(other.close);
        await tester.pumpWidget(
          botsReviewApp(
            owner,
            theme: _theme(layout),
            pickAvatarImage: () async => _pickedAvatar,
          ),
        );
        await _openNewBot(tester);
        await _type(tester, 'bots-new-name', 'latebot');
        await _tapKey(tester, 'bots-avatar-upload');
        await _tapKey(tester, 'bots-form-save');
        expect(first.named('profiles.create'), hasLength(1));

        // Switch the screen to another connection, then let the reply in.
        await tester.pumpWidget(
          botsReviewApp(
            other,
            theme: _theme(layout),
            pickAvatarImage: () async => _pickedAvatar,
          ),
        );
        await botsStep(tester, 4);
        hold.complete();
        await botsStep(tester, 8);

        expect(first.named('profiles.configure'), isEmpty);
        expect(first.named('profiles.set_asset'), isEmpty);
        expect(second.named('profiles.create'), isEmpty);
        expect(second.named('profiles.configure'), isEmpty);
        expect(find.textContaining('created'), findsNothing);
        expect(find.byKey(const Key('bots-new-name')), findsNothing);
        expect(find.text('latebot'), findsNothing);
      });

      testWidgets('below 480 px New Bot is a pushed page, not a dialog', (
        tester,
      ) async {
        _size(tester, const Size(400, 800));
        final gateway = BotsReviewGateway();
        final owner = botsReviewOwner(gateway);
        addTearDown(owner.close);
        await tester.pumpWidget(botsReviewApp(owner, theme: _theme(layout)));
        await _openNewBot(tester);
        expect(find.byType(Dialog), findsNothing);
        expect(
          ModalRoute.of(tester.element(find.byKey(const Key('bots-new-name'))))
              is PageRoute,
          isTrue,
        );
      });
    });
  }

  testWidgets('the roster draws each bot\'s face from its record and its '
      'stored picture', (tester) async {
    _size(tester, const Size(900, 1200));
    final gateway = BotsReviewGateway()
      ..bumpRevision('researchbot', {
        'shape': 'drop',
        'color': 'hsl(120 68% 58%)',
      });
    final owner = botsReviewOwner(gateway);
    addTearDown(owner.close);
    await tester.pumpWidget(botsReviewApp(owner));
    await botsShown(tester, find.text('WorkBot'));
    await botsStep(tester, 4);
    final research = tester.widget<BotFace>(
      find.byKey(const Key('bots-face-researchbot')),
    );
    expect(research.shape, 'drop');
    expect(research.color, 'hsl(120 68% 58%)');
    expect(research.image, isNull);
    final work = tester.widget<BotFace>(
      find.byKey(const Key('bots-face-workbot')),
    );
    expect(work.image, isNotNull);
    expect(gateway.named('profiles.get_asset').single.params, {
      'name': 'workbot',
      'asset': 'avatar',
    });
    expect(gateway.refusals, isEmpty);
  });
}
