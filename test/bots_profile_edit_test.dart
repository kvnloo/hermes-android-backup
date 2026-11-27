// F11 Edit Profile (t_8d18f507 item 2): Desktop's edit-profile-dialog.tsx at
// b7ee21c14e. Only what changed is written; the look goes over the bot's
// current record with the gateway's compare-and-set; destructive changes
// ask first; the gateway's refusals show in the form. Classic and NextGen.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

void _size(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _openEdit(WidgetTester tester, String title) async {
  await botsShown(tester, find.text(title));
  await botsStep(tester, 3);
  await tester.tap(find.text(title));
  await botsStep(tester, 3);
  await tester.tap(find.byKey(const Key('bots-edit-profile')));
  await botsStep(tester, 4);
  expect(find.byKey(const Key('bots-edit-title')), findsOneWidget);
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  final target = find.byKey(Key(key));
  await tester.ensureVisible(target);
  await botsStep(tester, 1);
  await tester.tap(target);
  await botsStep(tester, 3);
}

Future<void> _type(WidgetTester tester, String key, String text) async {
  final field = find.byKey(Key(key));
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
  await botsStep(tester, 2);
}

Future<void> _openAdvanced(WidgetTester tester) async {
  await _tapKey(tester, 'bots-edit-advanced');
  await botsStep(tester, 3);
  expect(find.byKey(const Key('bots-edit-soul')), findsOneWidget);
}

String? _formError(WidgetTester tester) {
  final error = find.byKey(const Key('bots-form-error'));
  return error.evaluate().isEmpty ? null : tester.widget<Text>(error).data;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final layout in _Layout.values) {
    group(layout.name, () {
      Future<BotsReviewGateway> pump(
        WidgetTester tester, [
        BotsReviewGateway? given,
      ]) async {
        _size(tester);
        final gateway = given ?? BotsReviewGateway();
        final owner = botsReviewOwner(gateway);
        addTearDown(owner.close);
        await tester.pumpWidget(botsReviewApp(owner, theme: _theme(layout)));
        return gateway;
      }

      testWidgets('only the changed fields are written, over the current '
          'record, with its revision; nothing else is sent', (tester) async {
        final gateway = BotsReviewGateway()
          ..bumpRevision('researchbot', {
            'title': 'Old',
            'shape': 'circle',
            'pinned': true,
            'sectionId': 'sec-1',
            'sectionName': 'Clients',
          });
        await pump(tester, gateway);
        await _openEdit(tester, 'Old');
        // Another Desktop changes the colour while the form is open; a
        // title edit must not undo it.
        gateway.bumpRevision('researchbot', {
          ...gateway.uiMeta['researchbot']!['hermes-bots']
              as Map<String, dynamic>,
          'color': 'hsl(90 68% 58%)',
        });
        await _type(tester, 'bots-edit-title', 'Scholar');
        await _tapKey(tester, 'bots-form-save');
        await botsStep(tester, 6);

        expect(gateway.refusals, isEmpty);
        final configure = gateway.named('profiles.configure').single.params;
        expect(configure['ui_meta_expected_revisions'], {'hermes-bots': 2});
        expect((configure['ui_meta'] as Map)['hermes-bots'], {
          'title': 'Scholar',
          'shape': 'circle',
          'pinned': true,
          'sectionId': 'sec-1',
          'sectionName': 'Clients',
          'color': 'hsl(90 68% 58%)',
        });
        expect(
          configure.keys,
          unorderedEquals(['name', 'ui_meta', 'ui_meta_expected_revisions']),
        );
        expect(gateway.named('profiles.set_asset'), isEmpty);
        expect(gateway.named('profiles.describe'), isEmpty);
        expect(find.byKey(const Key('bots-edit-title')), findsNothing);
        expect(find.textContaining('Scholar updated'), findsOneWidget);
      });

      testWidgets('a write that loses the compare-and-set is re-read and '
          'retried, keeping the other writer\'s change', (tester) async {
        final gateway = await pump(tester);
        await _openEdit(tester, 'ResearchBot');
        await _tapKey(tester, 'bots-avatar-shape-cloud');
        final hold = Completer<void>();
        gateway.holds['profiles.configure:null:'] = hold;
        await _tapKey(tester, 'bots-form-save');
        gateway.bumpRevision('researchbot', {'pinned': true});
        hold.complete();
        await botsStep(tester, 8);
        final writes = gateway.named('profiles.configure').toList();
        expect(writes, hasLength(2));
        expect(writes.first.params['ui_meta_expected_revisions'], {
          'hermes-bots': 0,
        });
        expect(writes.last.params['ui_meta_expected_revisions'], {
          'hermes-bots': 1,
        });
        expect(gateway.uiMeta['researchbot']!['hermes-bots'], {
          'pinned': true,
          'shape': 'cloud',
          'custom': true,
        });
      });

      testWidgets('Advanced loads profiles.describe and saves only the dirty '
          'sections; turning things off asks first and Cancel sends '
          'nothing', (tester) async {
        final gateway = await pump(tester);
        await _openEdit(tester, 'ResearchBot');
        await _openAdvanced(tester);
        expect(gateway.named('profiles.describe').single.params, {
          'name': 'researchbot',
        });
        await _tapKey(tester, 'bots-edit-skill-git-helper');
        await _tapKey(tester, 'bots-edit-mcp-github');
        await _type(tester, 'bots-edit-soul', '# Scholar\nReads papers.');
        await _tapKey(tester, 'bots-form-save');
        expect(find.byKey(const Key('bots-confirm-dialog')), findsOneWidget);
        expect(find.textContaining('Replace its SOUL.md'), findsOneWidget);
        expect(
          find.textContaining('Turn off 1 skill, toolset or MCP server'),
          findsOneWidget,
        );
        await tester.tap(find.byKey(const Key('bots-confirm-cancel')));
        await botsStep(tester, 3);
        expect(gateway.named('profiles.configure'), isEmpty);
        expect(find.byKey(const Key('bots-edit-soul')), findsOneWidget);

        await _tapKey(tester, 'bots-form-save');
        await tester.tap(find.byKey(const Key('bots-confirm-ok')));
        await botsStep(tester, 6);
        expect(gateway.refusals, isEmpty);
        final configure = gateway.named('profiles.configure').single.params;
        expect(configure, {
          'name': 'researchbot',
          'soul': '# Scholar\nReads papers.',
          'disabled_skills': ['git-helper'],
          'enabled_mcp_servers': ['github'],
        });
        expect(find.byKey(const Key('bots-edit-soul')), findsNothing);
      });

      testWidgets('turning every toolset off clears the pin ([]), as Desktop '
          'does', (tester) async {
        final gateway = await pump(tester);
        await _openEdit(tester, 'ResearchBot');
        await _openAdvanced(tester);
        await _tapKey(tester, 'bots-edit-toolset-terminal');
        await _tapKey(tester, 'bots-form-save');
        await tester.tap(find.byKey(const Key('bots-confirm-ok')));
        await botsStep(tester, 6);
        expect(gateway.named('profiles.configure').single.params, {
          'name': 'researchbot',
          'enabled_toolsets': ['web'],
        });
      });

      testWidgets('a guarded model asks with the gateway\'s message; OK '
          'resends the model alone with confirm_expensive_model', (
        tester,
      ) async {
        final gateway = BotsReviewGateway()..guardedModels.add('opus-max');
        await pump(tester, gateway);
        await _openEdit(tester, 'ResearchBot');
        await _openAdvanced(tester);
        await _type(tester, 'bots-edit-model', 'opus-max');
        await _tapKey(tester, 'bots-form-save');
        await botsStep(tester, 4);
        expect(
          find.text('opus-max costs more than your current model.'),
          findsOneWidget,
        );
        await tester.tap(find.byKey(const Key('bots-confirm-ok')));
        await botsStep(tester, 6);
        final writes = gateway.named('profiles.configure').toList();
        expect(writes.first.params, {
          'name': 'researchbot',
          'model': 'opus-max',
          'provider': 'anthropic',
        });
        expect(writes.last.params, {
          'name': 'researchbot',
          'model': 'opus-max',
          'provider': 'anthropic',
          'confirm_expensive_model': true,
        });
        expect(gateway.profiles[1]['model'], 'opus-max');
        expect(find.byKey(const Key('bots-edit-model')), findsNothing);
      });

      testWidgets('a section the gateway did not apply, and a refusal, are '
          'shown in the form, which stays open', (tester) async {
        final gateway = BotsReviewGateway()..failSections.add('description');
        await pump(tester, gateway);
        await _openEdit(tester, 'ResearchBot');
        await _type(tester, 'bots-edit-description', 'Reads papers');
        await _tapKey(tester, 'bots-form-save');
        await botsStep(tester, 4);
        expect(_formError(tester), 'Some sections failed: description');
        expect(find.byKey(const Key('bots-edit-title')), findsOneWidget);

        // The profile went away under the form: the gateway's own words.
        gateway.failSections.clear();
        gateway.profiles.removeAt(1);
        await _tapKey(tester, 'bots-form-save');
        await botsStep(tester, 4);
        expect(_formError(tester), "profile 'researchbot' not found");
        expect(find.byKey(const Key('bots-edit-title')), findsOneWidget);
      });

      testWidgets('removing the picture asks first, then clears the asset '
          'and records a shape look', (tester) async {
        final gateway = await pump(tester);
        await _openEdit(tester, 'WorkBot');
        expect(find.byKey(const Key('bots-avatar-remove')), findsOneWidget);
        await _tapKey(tester, 'bots-avatar-remove');
        await _tapKey(tester, 'bots-form-save');
        expect(find.textContaining('Remove the bot’s picture'), findsOneWidget);
        await tester.tap(find.byKey(const Key('bots-confirm-ok')));
        await botsStep(tester, 6);
        expect(gateway.named('profiles.set_asset').single.params, {
          'name': 'workbot',
          'asset': 'avatar',
          'clear': true,
        });
        expect(gateway.avatars.containsKey('workbot'), isFalse);
        final look =
            (gateway.named('profiles.configure').single.params['ui_meta']
                as Map)['hermes-bots'];
        expect(look, {'imageKind': 'shape', 'custom': true});
      });

      testWidgets('a save reply that lands after the connection changed is '
          'dropped: nothing more is sent and nothing is reported', (
        tester,
      ) async {
        _size(tester);
        final first = BotsReviewGateway();
        final second = BotsReviewGateway();
        final owner = botsReviewOwner(first);
        final other = botsReviewOwner(second);
        addTearDown(owner.close);
        addTearDown(other.close);
        await tester.pumpWidget(botsReviewApp(owner, theme: _theme(layout)));
        await _openEdit(tester, 'ResearchBot');
        await _type(tester, 'bots-edit-title', 'Scholar');
        await _type(tester, 'bots-edit-description', 'Reads papers');
        final hold = Completer<void>();
        first.holds['profiles.configure:null:'] = hold;
        await _tapKey(tester, 'bots-form-save');
        await tester.pumpWidget(botsReviewApp(other, theme: _theme(layout)));
        await botsStep(tester, 4);
        hold.complete();
        await botsStep(tester, 8);
        // The look write was out; the description write never followed.
        expect(first.named('profiles.configure'), hasLength(1));
        expect(second.named('profiles.configure'), isEmpty);
        expect(find.textContaining('updated'), findsNothing);
        expect(find.byKey(const Key('bots-edit-title')), findsNothing);
      });
    });
  }
}
