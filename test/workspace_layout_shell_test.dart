import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/models/session.dart';
import 'package:hermes_android/core/workspace/parallel_workspace.dart';
import 'package:hermes_android/core/workspace/workspace_layout.dart';
import 'package:hermes_android/core/workspace/workspace_registry.dart';
import 'package:shared_preferences/shared_preferences.dart';

final owner = SavedConnection(
  id: 'local',
  label: 'Fixture',
  host: 'fixture.invalid',
  port: 1234,
  apiKey: 'do-not-persist',
);
Session row(String id) => Session.fromJson({
  'id': id,
  'title': 'Title $id',
  'preview': 'private preview',
});

void main() {
  test(
    'restore tolerates invalid data, never aliases a missing primary, bounds recents',
    () {
      for (final raw in [
        null,
        'broken',
        '{"version":2}',
        '{"version":1,"tabs":[1,["a", ""],["a", ""]],"primary":["b", ""],"secondary":["a", ""]}',
      ]) {
        final s = WorkspaceLayout.decode(raw);
        expect(s.primary, isNull);
        expect(s.secondary, isNull);
        expect(s.tabs.length, lessThanOrEqualTo(1));
      }
      final s = WorkspaceLayout();
      for (var i = 0; i < WorkspaceLayout.maxTabs; i++) {
        expect(s.open(chatPane('s$i')), isTrue);
      }
      expect(s.open(chatPane('extra')), isFalse);
      s.open(chatPane('s0'), split: true);
      s.move(chatPane('s0'), 1);
      s.stacked = true;
      s.percent = 40;
      expect(s.save('Work'), isTrue);
      for (final p in [...s.tabs]) {
        s.close(p);
      }
      expect(s.primary, isNull);
      final back = WorkspaceLayout.decode(s.encode());
      expect(back.reopen(), isTrue);
      back.restore('Work');
      expect(back.tabs.first, chatPane('s1'));
      expect(back.secondary, chatPane('s0'));
      expect(back.stacked, isTrue);
      expect(back.percent, 40);
      expect(back.closed, isEmpty);
      expect(back.save(' '), isFalse);
    },
  );

  test(
    'registry rejects duplicate IDs, including action vs page collisions',
    () {
      final p = WorkspacePage(
        'tool.test',
        'Test',
        Icons.info,
        (_, _) => const SizedBox(),
      );
      expect(
        () => WorkspaceRegistry([
          p,
          WorkspaceAction('tool.test', 'Again', Icons.add, (_, _) {}),
        ]),
        throwsArgumentError,
      );
    },
  );

  testWidgets(
    'hide retains the contributed pane, reopen revokes old authority, named layout restores across launches',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 920);
      addTearDown(tester.view.reset);
      final captured = <WorkspaceTarget>[];
      final actions = <String>[];
      final registry = WorkspaceRegistry([
        WorkspacePage('test.buffer', 'Buffer', Icons.text_snippet, (_, target) {
          captured.add(target);
          return const TextField(key: ValueKey('buffer'));
        }),
        WorkspaceAction('test.id', 'Read current ID', Icons.info, (_, t) {
          actions.add(t.session!.id);
        }),
        WorkspaceAction(
          'test.deny',
          'Requires owner capability',
          Icons.lock,
          (_, _) => fail('disabled action ran'),
          unavailable: (_) => 'Not advertised',
        ),
      ]);
      var missing = false;
      Future<void> start() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ParallelWorkspace(
              connection: owner,
              nextGen: false,
              registry: registry,
              loadSessions: () async => missing ? [] : [row('a'), row('b')],
              buildChat: (_, s, _) => Text('Chat body ${s.id}'),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      Future<void> tap(Finder f) async {
        await tester.ensureVisible(f);
        await tester.tap(f);
        await tester.pumpAndSettle();
      }

      Future<void> menu(String label, {bool tool = false}) async {
        await tap(
          find.byTooltip(tool ? 'Workspace tools' : 'Workspace options'),
        );
        await tap(find.text(label).last);
      }

      await start();
      await tap(find.byTooltip('Add chat'));
      await tap(find.text('Title a'));
      await menu('Read current ID', tool: true);
      expect(actions, ['a']);
      await tap(find.byTooltip('Workspace tools'));
      expect(find.text('Not advertised'), findsOneWidget);
      await tap(find.text('Buffer'));
      final field = find.byKey(const ValueKey('buffer'));
      await tester.enterText(field, 'live contents');
      final old = captured.last;
      await tap(find.text('Switch pane: Buffer'));
      await menu('Hide pane (keep running)');
      expect(field, findsNothing);
      expect(
        find.byKey(const ValueKey('buffer'), skipOffstage: false),
        findsOneWidget,
      );
      expect(old.current(), isTrue);
      await tap(find.text('Buffer'));
      expect(find.text('live contents'), findsOneWidget);
      await menu('Dock another pane');
      await tap(find.text('Title a').last);
      await menu('Save named layout');
      await tester.enterText(
        find.widgetWithText(TextField, 'Layout name'),
        'Pair',
      );
      await tester.pump(); // Rebuild the Save button after the valid name.
      await tap(find.text('Save'));
      expect(find.byType(AlertDialog), findsNothing);
      final prefs = await SharedPreferences.getInstance();
      final store = prefs.getString(
        prefs.getKeys().singleWhere(
          (key) => key.startsWith('parallel.workspace.'),
        ),
      )!;
      for (final secret in [
        'live contents',
        'do-not-persist',
        'private preview',
        'fixture.invalid',
        'Title a',
      ]) {
        expect(store, isNot(contains(secret)));
      }
      await menu('Close tab');
      expect(old.current(), isFalse);
      await menu('Reopen closed tab');
      expect(field, findsOneWidget);
      expect(old.current(), isFalse);
      await menu('Restore named layout');
      await tap(find.text('Pair'));
      expect(find.text('Chat body a'), findsOneWidget);
      expect(field, findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await start();
      expect(find.text('Chat body a'), findsOneWidget);
      expect(field, findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      missing = true;
      await start();
      expect(find.text('Chat body a'), findsNothing);
      expect(field, findsNothing);
      expect(
        find.textContaining('not available for this connection'),
        findsNWidgets(2),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
