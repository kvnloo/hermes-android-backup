import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/models/session.dart';
import 'package:hermes_android/core/services/portable_profile_bundle.dart';
import 'package:hermes_android/core/services/profile_file_save.dart';
import 'package:hermes_android/core/workspace/parallel_workspace.dart';
import 'package:hermes_android/core/workspace/profile_presentation.dart';
import 'package:hermes_android/core/workspace/profile_presentation_store.dart';
import 'package:hermes_android/core/workspace/workspace_layout.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'portable_profile_bundle_test.dart' show tar;

final owner = SavedConnection(
  id: 'fixture',
  label: 'Test',
  host: 'localhost',
  port: 1234,
  apiKey: '',
  gatewayProfile: 'recipient',
);
Map<String, Object?> desktop() => {
  'version': 1,
  'skin': 'studio',
  'mode': 'dark',
  'profileColor': '#123456',
  'themes': {
    'studio': {
      'name': 'studio',
      'label': 'Test',
      'colors': {
        'background': '#041222',
        'foreground': '#fafafa',
        'primary': '#44c4da',
      },
      'customCSS': 'never-copied',
      'typography': {'fontUrl': 'https://fixture.invalid/font'},
    },
  },
  'layoutTree': {
    'type': 'split',
    'orientation': 'row',
    'id': 'private-draft',
    'weights': [2, 3],
    'children': [
      {
        'type': 'group',
        'id': 'a',
        'panes': ['collision'],
        'active': 'collision',
      },
      {
        'type': 'group',
        'id': 'b',
        'panes': ['plugin.private-tool'],
        'active': 'plugin.private-tool',
      },
    ],
  },
};

void main() {
  test('only display data travels in a reviewed CLI archive', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance(), incoming = desktop();
    final store = ProfilePresentationStore(prefs);
    await store.apply(owner, ProfilePresentation.parse(incoming)!, () {});
    final local = WorkspaceLayout()
      ..open(chatPane('private-draft'))
      ..open(chatPane('collision'), split: true)
      ..stacked = true
      ..percent = 60
      ..save('private layout');
    await prefs.setString(
      workspaceLayoutKey(owner, false, store.read(owner)),
      local.encode(),
    );
    final style = store.snapshot(owner, false);
    expect(style.geometry, (paired: true, stacked: true, percent: 60));
    final bundle = (await PortableProfileBundle.inspect(
      tar({'qa/SOUL.md': 'fixture', 'qa/desktop.json': 'stale'}),
    )).withDesktop(style.encode());
    final received = await PortableProfileBundle.inspect(
      bundle.encode({'desktop.json', 'SOUL.md'}),
    );
    final text = received.files['desktop.json']!;
    for (final s in [
      'private-draft',
      'collision',
      'plugin.private-tool',
      'private layout',
      'never-copied',
      'fixture.invalid',
      'stale',
    ]) {
      expect(text, isNot(contains(s)));
    }
    expect(ProfilePresentation.parseText(text)!.encode(), text);
    expect(
      (jsonDecode(text)['themes']['studio']['colors'] as Map).keys,
      containsAll(['input', 'ring', 'muted', 'destructiveForeground']),
    );
    expect(ProfilePresentation.parse({...incoming, 'version': 2}), isNull);
    expect(
      ProfilePresentation.parse({
        ...incoming,
        'layoutTree': {'type': 'split', 'children': []},
      })!.geometry,
      isNull,
    );
    expect(
      ProfilePresentation.parse({'version': 1, 'skin': 'nosuchskin'}),
      isNull,
    );
    expect(
      ProfilePresentation.parse({
        'version': 1,
        'skin': 'nous',
        'themes': {'nous': incoming['themes']},
      })!.dark!.primary,
      const Color(0xff4a84fe),
    );
    expect(store.read(owner.copyWith(gatewayProfile: 'other')), isNull);
    expect(store.read(owner.copyWith(dashboardUsername: 'other')), isNull);
    expect(
      () => store.apply(owner, style, () => throw StateError('revoked')),
      throwsStateError,
    );
    expect(prefs.getKeys(), hasLength(2));
  });

  for (final ng in [false, true]) {
    testWidgets(
      '${ng ? 'NextGen' : 'Classic'} layout opens no colliding chat until chosen on this recipient',
      (t) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance(),
            style = ProfilePresentation.parse(desktop())!;
        final store = ProfilePresentationStore(prefs);
        // A new profile may recycle the name of one deleted here.
        await prefs.setString(
          workspaceLayoutKey(owner, ng, null),
          (WorkspaceLayout()..open(chatPane('collision'))).encode(),
        );
        await store.apply(owner, style, () {});
        t.view.devicePixelRatio = 1;
        t.view.physicalSize = const Size(1280, 880);
        addTearDown(t.view.reset);
        final opened = <String>[];
        Widget app() => MaterialApp(
          theme: ThemeData.light(),
          home: ProfileTheme(
            connection: owner,
            nextGen: ng,
            child: ParallelWorkspace(
              connection: owner,
              nextGen: ng,
              loadSessions: () async => [
                for (final s in ['collision', 'mine'])
                  Session.fromJson({'id': s, 'title': 'Local $s'}),
              ],
              buildChat: (_, s, _) {
                opened.add(s.id);
                return Text('Opened ${s.id}');
              },
            ),
          ),
        );
        await t.pumpWidget(app());
        await t.pumpAndSettle();
        final l10n = lookupAppLocalizations(const Locale('en'));
        final first = find.text(
          l10n.release_core_parallel_workspace_choose_chat_for(
            l10n.release_core_parallel_workspace_first_pane,
          ),
        );
        final second = find.text(
          l10n.release_core_parallel_workspace_choose_chat_for(
            l10n.release_core_parallel_workspace_second_pane,
          ),
        );
        expect(first, findsOneWidget);
        expect(second, findsOneWidget);
        expect(opened, isEmpty);
        final ctx = t.element(first), theme = Theme.of(ctx);
        expect(theme.brightness, Brightness.dark);
        expect(theme.colorScheme.primary, const Color(0xff44c4da));
        if (ng) expect(NgColors.of(ctx).accent, theme.colorScheme.primary);
        expect(t.getCenter(first).dx, lessThan(t.getCenter(second).dx));
        await t.tap(first);
        await t.pumpAndSettle();
        await t.tap(find.text('Local mine'));
        await t.pumpAndSettle();
        expect(find.text('Opened mine'), findsOneWidget);
        expect(opened, isNot(contains('collision')));
        t.view.physicalSize = const Size(430, 820);
        await t.pumpAndSettle();
        expect(second, findsNothing);
        await t.tap(
          find.text(
            l10n.release_core_parallel_workspace_switch_pane(
              l10n.release_core_parallel_workspace_second_pane,
            ),
          ),
        );
        await t.pumpAndSettle();
        expect(second, findsOneWidget);
        await t.pumpWidget(const SizedBox());
        await t.pumpAndSettle();
        await t.pumpWidget(app());
        await t.pumpAndSettle();
        expect(second, findsOneWidget);
        expect(opened, isNot(contains('collision')));
      },
    );
  }

  test(
    'path-only chooser writes private bytes, rejects links and retains old file on revocation',
    () async {
      final dir = await Directory.systemTemp.createTemp('profile-save-');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/backup.zip');
      final bytes = Uint8List.fromList([2, 4, 6, 8]);
      await writeSelectedProfileFile(file.path, bytes, () {});
      expect(await file.readAsBytes(), bytes);
      expect((await file.stat()).mode & 0x1ff, 0x180);
      var n = 0;
      await expectLater(
        writeSelectedProfileFile(file.path, Uint8List.fromList([9]), () {
          if (++n == 3) throw StateError('revoked');
        }),
        throwsStateError,
      );
      expect(await file.readAsBytes(), bytes);
      final link = await Link('${dir.path}/another').create(file.path);
      await expectLater(
        writeSelectedProfileFile(link.path, bytes, () {}),
        throwsA(isA<FileSystemException>()),
      );
      expect(await dir.list().length, 2);
    },
    skip: Platform.isWindows ? 'POSIX writer is Linux-specific' : false,
  );
}
