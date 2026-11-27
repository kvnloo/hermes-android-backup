import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/chat_density_preference.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

Map<String, dynamic> _catalogue(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

// Exercise each generated getter independently of its actual ARB value. The
// release coordinator integrates and generates the catalogues before running
// this test; the chat worker does not run a second generator in the worktree.
Map<String, String> _messages(AppLocalizations l10n) => {
  'release_chat_unknown_model': l10n.release_chat_unknown_model,
  'release_chat_profile_default': l10n.release_chat_profile_default('MODEL'),
  'release_chat_profile_default_provider': l10n
      .release_chat_profile_default_provider('MODEL', 'PROVIDER'),
  'release_chat_choose_provider': l10n.release_chat_choose_provider,
  'release_chat_slash_needs_gateway': l10n.release_chat_slash_needs_gateway,
  'release_chat_recovering_without_resending':
      l10n.release_chat_recovering_without_resending,
  'release_chat_live_request_unreachable':
      l10n.release_chat_live_request_unreachable,
  'release_chat_live_working': l10n.release_chat_live_working('TOOL'),
  'release_chat_live_finished_without_spoken_result':
      l10n.release_chat_live_finished_without_spoken_result,
  'release_chat_reply_language_unavailable':
      l10n.release_chat_reply_language_unavailable,
  'release_chat_reply_voice_unavailable':
      l10n.release_chat_reply_voice_unavailable,
  'release_chat_reply_voice_configuration_unavailable':
      l10n.release_chat_reply_voice_configuration_unavailable,
  'release_chat_notification_review_action':
      l10n.release_chat_notification_review_action,
  'release_chat_notification_respond': l10n.release_chat_notification_respond,
  'release_chat_start_new_main_window': l10n.release_chat_start_new_main_window,
  'release_chat_no_desktop_gateway': l10n.release_chat_no_desktop_gateway,
  'release_chat_attachment_preparation_cancelled':
      l10n.release_chat_attachment_preparation_cancelled,
  'release_chat_approval_authority_revoked':
      l10n.release_chat_approval_authority_revoked,
  'release_chat_gateway_session_disconnected':
      l10n.release_chat_gateway_session_disconnected,
  'release_chat_stop_requested': l10n.release_chat_stop_requested,
  'release_chat_stop_request_failed': l10n.release_chat_stop_request_failed(
    'ERROR',
  ),
  'release_chat_queued_prompt_not_sent':
      l10n.release_chat_queued_prompt_not_sent,
  'release_chat_running_turn_unreachable':
      l10n.release_chat_running_turn_unreachable,
  'release_chat_wait_for_composer': l10n.release_chat_wait_for_composer,
  'release_chat_find_in_transcript': l10n.release_chat_find_in_transcript,
  'release_chat_open_browser_preview': l10n.release_chat_open_browser_preview,
  'release_chat_more_tools': l10n.release_chat_more_tools,
  'release_chat_queue_until_finished': l10n.release_chat_queue_until_finished,
  'release_chat_format_bold': l10n.release_chat_format_bold,
  'release_chat_format_italic': l10n.release_chat_format_italic,
  'ng_release_chat_gateway_queue_requirements':
      l10n.ng_release_chat_gateway_queue_requirements,
  'ng_release_chat_start_new_main_screen':
      l10n.ng_release_chat_start_new_main_screen,
  'ng_release_chat_image': l10n.ng_release_chat_image,
  'ng_release_chat_tool_seconds': l10n.ng_release_chat_tool_seconds('1.5'),
};

const _arguments = {
  'model': 'MODEL',
  'provider': 'PROVIDER',
  'tool': 'TOOL',
  'error': 'ERROR',
  'seconds': '1.5',
};

Widget _app(String locale, Widget child) => MaterialApp(
  locale: Locale(locale),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  test(
    'chat release messages have explicit catalogues and generated values',
    () {
      final english = _catalogue('en');
      final keys = _messages(lookupAppLocalizations(const Locale('en'))).keys;
      expect(keys, hasLength(34));
      for (final locale in AppLocalizations.supportedLocales) {
        final id = [
          locale.languageCode,
          ?locale.scriptCode,
          ?locale.countryCode,
        ].join('_');
        final catalogue = _catalogue(id);
        final generated = _messages(lookupAppLocalizations(locale));
        for (final key in keys) {
          expect(catalogue[key], isA<String>(), reason: '$id $key');
          var expected = catalogue[key] as String;
          expect(expected.trim(), isNotEmpty, reason: '$id $key');
          final metadata = english['@$key'] as Map<String, dynamic>;
          expect(metadata['description'], isNotEmpty, reason: key);
          final placeholders = metadata['placeholders'] as Map;
          for (final name in placeholders.keys) {
            expect(expected, contains('{$name}'), reason: '$id $key $name');
            expect((placeholders[name] as Map)['type'], 'String', reason: key);
            expected = expected.replaceAll('{$name}', _arguments[name]!);
          }
          expect(generated[key], expected, reason: '$id $key');
          // The compact seconds symbol may legitimately be unchanged.
          if (id == 'de' && key != 'ng_release_chat_tool_seconds') {
            expect(catalogue[key], isNot(english[key]), reason: '$id $key');
          }
        }
      }
    },
  );

  test('both chat toolbars use shared keys, including compact menus', () {
    for (final path in [
      'lib/core/screens/chat_screen.dart',
      'lib/nextgen/ui/chat_view.dart',
    ]) {
      final source = File(path).readAsStringSync();
      for (final key in [
        'release_chat_more_tools',
        'release_chat_find_in_transcript',
        'release_chat_open_browser_preview',
        'release_core_session_files_view_session_files',
        'release_core_gateway_queue_screen_gateway_queue',
        'release_core_client_held_queue_bar_edit_unsent_prompt',
        'composer_snippets',
      ]) {
        expect(source, contains(key), reason: '$path $key');
      }
      for (final text in [
        'More chat tools',
        'Session files',
        'Find in transcript',
        'Open browser preview',
        'Gateway queue',
        'Edit unsent prompt',
        'Cancel',
        'Save',
      ]) {
        expect(source, isNot(contains("'$text'")), reason: '$path $text');
      }
      if (path.contains('/core/')) {
        expect(source, contains('release_chat_unsent_prompt_gone'));
        expect(source, isNot(contains('Text(heldPromptMissingMessage)')));
      }
    }
  });

  testWidgets('Classic sender labels follow live language changes', (
    tester,
  ) async {
    for (final locale in ['en', 'de', 'en']) {
      await tester.pumpWidget(
        _app(
          locale,
          const MessageBubble(content: 'Fixture prompt', isUser: true),
        ),
      );
      await tester.pumpAndSettle();
      final sender = _catalogue(locale)['history_role_user'] as String;
      expect(find.text(sender), findsOneWidget);
      if (locale == 'de') expect(find.text('You'), findsNothing);
    }
  });

  testWidgets('compact Classic bubbles localize the accessible sender', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        'de',
        const MessageBubble(
          content: 'Fixture prompt',
          isUser: true,
          density: ChatDensity.compact,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final sender = _catalogue('de')['history_role_user'] as String;
    expect(find.text(sender), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == sender,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'You',
      ),
      findsNothing,
    );
  });
}
