import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/l10n/l10n.dart';
import 'package:hermes_android/core/l10n/ui_message_exception.dart';
import 'package:hermes_android/core/widgets/client_held_queue_bar.dart';
import 'package:hermes_android/core/widgets/session_organisation.dart';
import 'package:hermes_android/core/widgets/transcript_reader.dart';

Map<String, dynamic> _catalog(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

String _german(String key) {
  final english = _catalog('en');
  final german = _catalog('de');
  expect(english, contains(key));
  expect(german, contains(key));
  final translated = german[key] as String;
  expect(translated, isNotEmpty);
  expect(translated, isNot(english[key]), reason: '$key must not fall back');
  return translated;
}

Widget _app(Widget child, {bool generatedDelegate = true}) => MaterialApp(
  locale: const Locale('de'),
  supportedLocales: const [Locale('de'), Locale('en')],
  localizationsDelegates: [
    if (generatedDelegate) AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ],
  home: Scaffold(body: child),
);

void main() {
  test('client-authored UI exceptions do not add English error prefixes', () {
    const exception = UiMessageException('Nicht bestätigt.');
    expect(exception.toString(), 'Nicht bestätigt.');
  });

  testWidgets(
    'transcript find and timeline localize without the app delegate',
    (tester) async {
      final key = GlobalKey<TranscriptReaderState>();
      final scroll = ScrollController();
      await tester.pumpWidget(
        _app(
          TranscriptReader(
            key: key,
            scroll: scroll,
            storageKey: null,
            entries: () => const [
              (id: 'prompt', index: 0, text: 'User fixture', prompt: true),
            ],
            child: ListView(
              controller: scroll,
              children: const [Text('User fixture')],
            ),
          ),
          generatedDelegate: false,
        ),
      );
      key.currentState!.open();
      await tester.pumpAndSettle();

      final query = tester.widget<TextField>(
        find.byKey(const Key('transcript-query')),
      );
      expect(
        query.decoration!.hintText,
        _german('release_core_transcript_reader_find_in_loaded_messages'),
      );
      for (final suffix in [
        'previous_match',
        'next_match',
        'prompt_timeline',
        'close_find',
      ]) {
        expect(
          find.byTooltip(_german('release_core_transcript_reader_$suffix')),
          findsOneWidget,
        );
      }
      expect(find.byTooltip('Previous match'), findsNothing);
      expect(find.byTooltip('Next match'), findsNothing);
      await tester.tap(
        find.byTooltip(
          _german('release_core_transcript_reader_prompt_timeline'),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(_german('release_core_transcript_reader_loaded_prompts')),
        findsOneWidget,
      );
      expect(
        find.text(_german('release_core_transcript_reader_jump_to_latest')),
        findsOneWidget,
      );
      expect(find.text('Loaded prompts'), findsNothing);
      expect(find.text('Jump to latest'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      scroll.dispose();
    },
  );

  testWidgets('chat organisation translates enum labels and detail toggle', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        SessionOrganisationMenu(
          sort: SessionSort.recent,
          group: SessionGroup.standard,
          rows: const [],
          details: false,
          projects: true,
          onSort: (_) {},
          onGroup: (_) {},
          onDetails: () {},
        ),
      ),
    );
    await tester.tap(
      find.byTooltip(
        _german('release_core_session_organisation_organise_chats'),
      ),
    );
    await tester.pumpAndSettle();
    for (final key in [
      'release_core_session_sort_recent',
      'release_core_session_sort_created',
      'release_core_session_sort_status',
      'release_core_session_sort_tokens',
      'release_core_session_sort_cost',
      'release_core_session_group_standard',
      'release_core_session_group_status',
      'release_core_session_group_project',
      'release_core_session_organisation_show_model_and_usage',
    ]) {
      expect(find.text(_german(key)), findsOneWidget);
    }
    for (final english in [
      'Recent activity',
      'Newest created',
      'Running first',
      'Show model and usage',
    ]) {
      expect(find.text(english), findsNothing);
    }
  });

  testWidgets('client-held queue count and actions share the active locale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        ClientHeldQueueBar(
          count: 3,
          parked: true,
          rows: const [ClientHeldQueueRow(id: 'draft', text: 'User fixture')],
          onResume: () {},
          onSend: (_) {},
          onRemove: (_) {},
          onEdit: (_) {},
        ),
      ),
    );
    expect(
      find.text(
        _german(
          'release_core_client_queue_paused_count',
        ).replaceAll('{count}', '3'),
      ),
      findsOneWidget,
    );
    for (final suffix in [
      'send_queued_prompt',
      'edit_unsent_prompt',
      'remove_unsent_prompt',
    ]) {
      expect(
        find.byTooltip(_german('release_core_client_held_queue_bar_$suffix')),
        findsOneWidget,
      );
    }
    expect(find.text('3 queued — paused'), findsNothing);
    expect(find.byTooltip('Send queued prompt'), findsNothing);
  });
}
