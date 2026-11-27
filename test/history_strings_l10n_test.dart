// F17 localisation regression test:
// - 'Session history' and 'Import Claude or Codex' come from ARB in Classic,
//   NextGen and SessionHistoryPage (never hard-coded in UI files).
// - Every new history string (including mandatory ng_ keys) is translated in
//   all 13 non-English ARB catalogues.
// - Shared rewind dialogs render in a non-English locale in both Classic
//   (generated delegate present) and NextGen (ambient locale via sharedL10n).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/widgets/rewind_dialogs.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

const _historyKeys = [
  'session_history',
  'import_claude_or_codex',
  'edit_and_resend',
  'edit_turn_title',
  'edit_turn_body',
  'edit_turn_send',
  'restore_turn_title',
  'restore_turn_body',
  'restore_turn_confirm',
  'edit_turn_later_turns_body',
  'ng_session_history',
  'ng_import_claude_or_codex',
  'ng_edit_and_resend',
  'ng_restore_turn_confirm',
];

void main() {
  test('every history ARB key is translated in all 13 non-English locales', () {
    final dir = Directory('lib/l10n');
    final en =
        jsonDecode(File('${dir.path}/app_en.arb').readAsStringSync())
            as Map<String, dynamic>;
    for (final key in _historyKeys) {
      expect(en[key], isA<String>(), reason: 'app_en.arb $key');
      expect((en[key] as String).trim(), isNotEmpty, reason: 'app_en.arb $key');
    }

    final localeFiles =
        dir
            .listSync()
            .whereType<File>()
            .where(
              (f) => f.path.endsWith('.arb') && !f.path.endsWith('app_en.arb'),
            )
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    expect(localeFiles, hasLength(13));

    for (final file in localeFiles) {
      final map = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      for (final key in _historyKeys) {
        final value = map[key];
        expect(value, isA<String>(), reason: '${file.path} missing $key');
        expect(
          (value as String).trim(),
          isNotEmpty,
          reason: '${file.path} empty $key',
        );
        expect(
          value,
          isNot(en[key]),
          reason: '${file.path} left $key in English',
        );
      }
    }
  });

  test('chat_screen, chat_view and session_history_page have no hard-coded '
      'Session history or Import Claude or Codex literals', () {
    for (final path in [
      'lib/core/screens/chat_screen.dart',
      'lib/nextgen/ui/chat_view.dart',
      'lib/core/widgets/session_history_page.dart',
    ]) {
      final source = File(path).readAsStringSync();
      expect(
        source.contains("'Session history'"),
        isFalse,
        reason: '$path still hard-codes Session history',
      );
      expect(
        source.contains("'Import Claude or Codex'"),
        isFalse,
        reason: '$path still hard-codes Import Claude or Codex',
      );
    }
  });

  for (final classic in [true, false]) {
    final layout = classic ? 'Classic' : 'NextGen';
    testWidgets(
      '$layout renders EditTurnDialog and showRestoreTurnConfirm in German',
      (tester) async {
        final de = lookupAppLocalizations(const Locale('de'));
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('de'),
            localizationsDelegates: classic
                ? AppLocalizations.localizationsDelegates
                : const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => Column(
                  children: [
                    ElevatedButton(
                      key: const Key('open-edit'),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (_) =>
                            const EditTurnDialog(initialText: 'Hallo'),
                      ),
                      child: const Text('edit'),
                    ),
                    ElevatedButton(
                      key: const Key('open-restore'),
                      onPressed: () => showRestoreTurnConfirm(context),
                      child: const Text('restore'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('open-edit')));
        await tester.pumpAndSettle();
        expect(find.text(de.edit_turn_title), findsOneWidget);
        expect(find.text(de.edit_turn_send), findsOneWidget);
        await tester.tap(find.byKey(const Key('edit-turn-cancel')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('open-restore')));
        await tester.pumpAndSettle();
        expect(find.text(de.restore_turn_title), findsOneWidget);
        expect(find.text(de.restore_turn_confirm), findsOneWidget);
        await tester.tap(find.byKey(const Key('restore-turn-cancel')));
        await tester.pumpAndSettle();
      },
    );
  }
}
