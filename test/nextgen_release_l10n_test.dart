import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/model_catalog.dart';
import 'package:hermes_android/nextgen/data/slash_exec.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/scheduled_page.dart';
import 'package:hermes_android/nextgen/ui/settings_page.dart';
import 'package:hermes_android/nextgen/ui/widgets.dart';

import 'support/l10n_test_utils.dart';

// Read the real catalogues independently of the generated accessors. These tests
// are ready for the release integrator's ARB merge and generation, not a second
// generator run in the shared worktree.
Map<String, dynamic> _arb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

const _releaseKeys = [
  'ng_release_more_contributions_subtitle',
  'ng_release_more_gateway_fleet',
  'ng_release_more_memory_graph',
  'ng_release_more_memory_graph_subtitle',
  'ng_release_more_capabilities_subtitle',
  'ng_release_more_browser_vault',
  'ng_release_more_browser_vault_subtitle',
  'ng_release_more_agent_policy',
  'ng_release_more_agent_policy_subtitle',
  'ng_release_more_schedules',
  'ng_release_more_schedules_subtitle',
  'ng_release_more_host_subtitle',
  'ng_release_more_providers_routes',
  'ng_release_more_providers_routes_subtitle',
  'ng_release_more_credits_plans',
  'ng_release_more_credits_plans_subtitle',
  'ng_release_sign_in_or',
  'ng_release_deployment_sign_in_hint',
  'ng_release_message_search_unavailable',
  'ng_release_insights_days',
  'ng_release_signed_in_you',
  'release_chat_unsent_prompt_gone',
  'ng_release_attachment_not_attached',
  'ng_release_gateway_not_connected',
  'ng_release_gateway_unreachable',
  'ng_release_projects_scope_changed',
  'ng_release_missing_providers',
  'ng_release_missing_tasks',
  'ng_release_age_minutes',
  'ng_release_age_hours',
  'ng_release_age_days',
  'ng_release_age_weeks',
  'ng_release_age_years',
  'ng_release_compact_billions',
  'ng_release_compact_millions',
  'ng_release_compact_thousands',
  'ng_release_token_thousands',
  'ng_release_elapsed_minutes_seconds',
  'ng_release_elapsed_seconds',
  'ng_release_notification_foreground',
  'ng_release_notification_stopped',
  'ng_release_more_parallel_workspace',
  'ng_release_more_parallel_workspace_subtitle',
];

String _substitute(
  Map<String, dynamic> catalogue,
  String key,
  Map<String, Object> arguments,
) {
  var text = catalogue[key] as String;
  arguments.forEach((name, value) {
    text = text.replaceAll('{$name}', '$value');
  });
  return text;
}

Widget _app(Locale locale, {Widget? child}) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  theme: nextGenTheme(Brightness.light, NextGenLook.instance),
  builder: (_, child) => NgLocalizationScope(child: child!),
  home: Scaffold(body: child ?? const SizedBox.shrink()),
);

void main() {
  test('NextGen release entries exist in every supported catalogue', () {
    final english = _arb('en');
    expect(_releaseKeys.toSet(), hasLength(43));
    for (final locale in AppLocalizations.supportedLocales) {
      final id = [
        locale.languageCode,
        ?locale.scriptCode,
        ?locale.countryCode,
      ].join('_');
      final catalogue = _arb(id);
      for (final key in _releaseKeys) {
        expect(catalogue[key], isA<String>(), reason: '$id $key');
        final text = catalogue[key] as String;
        expect(text.trim(), isNotEmpty, reason: '$id $key');
        final metadata = english['@$key'] as Map<String, dynamic>;
        expect(metadata['description'], isNotEmpty, reason: key);
        final placeholders = metadata['placeholders'] as Map;
        for (final name in placeholders.keys) {
          expect(
            text.contains('{$name}') || text.contains('{$name,'),
            isTrue,
            reason: '$id $key must preserve $name',
          );
        }
        // Compact unit symbols may legitimately match English. Natural-language
        // German labels must not silently fall back to the English catalogue.
        if (id == 'de' &&
            !key.startsWith('ng_release_age_') &&
            !key.startsWith('ng_release_compact_') &&
            !key.startsWith('ng_release_token_') &&
            !key.startsWith('ng_release_elapsed_')) {
          expect(text, isNot(english[key]), reason: '$id $key');
        }
      }
    }
  });

  testWidgets(
    'relative ages and slash descriptions follow a live locale change',
    (tester) async {
      addTearDown(() async => tester.pumpWidget(_app(const Locale('en'))));
      for (final id in ['en', 'de']) {
        await tester.pumpWidget(_app(Locale(id)));
        await tester.pumpAndSettle();
        final catalogue = _arb(id);
        expect(ngAgo(null), isEmpty);
        expect(ngAgo(DateTime.now()), catalogue['now_label']);
        for (final (age, key, count) in [
          (const Duration(minutes: 5, seconds: 10), 'minutes', 5),
          (const Duration(hours: 2, minutes: 1), 'hours', 2),
          (const Duration(days: 3, hours: 1), 'days', 3),
          (const Duration(days: 15), 'weeks', 2),
          (const Duration(days: 800), 'years', 2),
        ]) {
          expect(
            ngAgo(DateTime.now().subtract(age)),
            _substitute(catalogue, 'ng_release_age_$key', {'count': count}),
          );
        }
        expect(kNgScreenSlashCommands['kanban'], catalogue['ng_slash_kanban']);
        expect(kNgScreenSlashCommands['bots'], catalogue['ng_slash_bots']);
        expect(
          ngCompactNumber(1200000),
          _substitute(catalogue, 'ng_release_compact_millions', {
            'count': '1.2',
          }),
        );
        expect(
          ngTokenCount(1048576),
          _substitute(catalogue, 'ng_release_compact_millions', {
            'count': '1.05',
          }),
        );
        expect(
          ngTokenCount(8192),
          _substitute(catalogue, 'ng_release_token_thousands', {
            'count': '8.2',
          }),
        );
      }
    },
  );

  testWidgets('catalogue failures and cron statuses use the active language', (
    tester,
  ) async {
    addTearDown(() async => tester.pumpWidget(_app(const Locale('en'))));
    await tester.pumpWidget(_app(const Locale('de')));
    await tester.pumpAndSettle();
    final german = _arb('de');
    expect(
      () => NgModelCatalog.fromOptions({}),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'localized provider failure',
          german['ng_release_missing_providers'],
        ),
      ),
    );
    expect(
      () => NgAuxTask.parseAll({}),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'localized auxiliary-task failure',
          german['ng_release_missing_tasks'],
        ),
      ),
    );
    for (final (wire, key) in [
      ('success', 'status_completed'),
      ('failed', 'status_failed'),
      ('running', 'status_running'),
      ('idle', 'status_idle'),
      ('skipped', 'catalog_skipped'),
      ('cancelled', 'task_status_cancelled'),
    ]) {
      expect(ngScheduledStatusLabel(wire), german[key]);
      expect(ngScheduledStatusLabel(wire), isNot(wire));
    }
    expect(
      ngScheduledStatusLabel('future_code'),
      _substitute(german, 'task_status_unknown', {'status': 'future_code'}),
    );
  });

  test(
    'deployment-token guidance preserves the translated refusal prefix',
    () async {
      for (final locale in AppLocalizations.supportedLocales) {
        final strings = await loadTestL10n(locale);
        final original = strings.ng_this_dashboard_offers_neither_a_username;
        final combined = strings.ng_release_deployment_sign_in_hint(original);
        expect(combined, startsWith(original));
        expect(combined.length, greaterThan(original.length));
      }
    },
  );

  testWidgets(
    'retained notification reasons translate when the locale changes',
    (tester) async {
      final previous = TurnNotificationService.recentAttempts.value;
      addTearDown(() async {
        TurnNotificationService.recentAttempts.value = previous;
        await tester.pumpWidget(_app(const Locale('en')));
      });
      TurnNotificationService.recentAttempts.value = [
        NotificationAttempt(
          at: DateTime.utc(2026, 1, 1),
          kind: 'reply',
          title: '',
          outcome: 'skipped',
          detail: 'Ares was on screen',
        ),
        NotificationAttempt(
          at: DateTime.utc(2026, 1, 1),
          kind: 'reply',
          title: '',
          outcome: 'skipped',
          detail: 'the turn was stopped',
        ),
      ];
      for (final id in ['en', 'de']) {
        await tester.pumpWidget(
          _app(Locale(id), child: const NgRecentNotificationsSheet()),
        );
        await tester.pumpAndSettle();
        final catalogue = _arb(id);
        expect(
          find.text(catalogue['ng_release_notification_foreground'] as String),
          findsOneWidget,
        );
        expect(
          find.text(catalogue['ng_release_notification_stopped'] as String),
          findsOneWidget,
        );
        if (id != 'en') {
          expect(find.text('Ares was on screen'), findsNothing);
          expect(find.text('the turn was stopped'), findsNothing);
        }
      }
      expect(TurnNotificationService.recentAttempts.value.first.kind, 'reply');
      expect(
        TurnNotificationService.recentAttempts.value.first.outcome,
        'skipped',
      );
    },
  );
}
