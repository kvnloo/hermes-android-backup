import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/reference_completion.dart';
import 'package:hermes_android/core/l10n/service_strings.dart';
import 'package:hermes_android/core/models/gateway_activity.dart';
import 'package:hermes_android/core/services/config_backup.dart';
import 'package:hermes_android/core/services/config_backup_service.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/widgets/image_recovery_capability_notice.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

Map<String, dynamic> _catalog(String code) =>
    jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  tearDown(debugResetServiceStrings);

  test(
    'every service release key has explicit translations and descriptions',
    () {
      final en = _catalog('en');
      final keys = en.keys
          .where(
            (key) =>
                key.startsWith('rel_svc_') || key.startsWith('ng_rel_svc_'),
          )
          .toList();
      expect(keys.length, greaterThanOrEqualTo(187));
      for (final key in keys) {
        expect((en['@$key'] as Map)['description'], isNotEmpty, reason: key);
      }
      for (final code in [
        'ar',
        'de',
        'es',
        'fr',
        'ja',
        'ko',
        'pt',
        'pt_BR',
        'ru',
        'uk',
        'zh',
        'zh_Hans',
        'zh_Hant',
      ]) {
        final translated = _catalog(code);
        for (final key in keys) {
          expect(translated[key], isA<String>(), reason: '$code:$key');
          expect(translated[key], isNotEmpty, reason: '$code:$key');
          // These are also the normal translated spellings in each locale,
          // not missing-catalogue English fallbacks.
          const sharedSpellings = {
            'de': {
              'rel_svc_push_status',
              'rel_svc_misc_chat',
              'rel_svc_misc_website',
            },
            'pt_BR': {'rel_svc_push_status', 'rel_svc_misc_chat'},
            'es': {'rel_svc_misc_chat'},
            'fr': {
              'rel_svc_push_diag_conversation',
              'rel_svc_misc_alert_important',
            },
          };
          if (sharedSpellings[code]?.contains(key) ?? false) {
            expect(translated[key], en[key], reason: '$code:$key');
          } else {
            expect(translated[key], isNot(en[key]), reason: '$code:$key');
          }
        }
      }
    },
  );

  test(
    'notification reasons retain exact English and unknown diagnostic data',
    () {
      final en = lookupAppLocalizations(const Locale('en'));
      for (final reason in [
        'permission denied',
        'notifications are off',
        'not initialised',
        'replies are off',
        'conversation',
        'conversation; permission denied',
        'failures are off',
        'Windows did not report its notification setting',
        'Ares was on screen',
        'the turn was stopped',
        'conversation: SERVER_42',
        'unknown_future_reason',
      ]) {
        expect(
          TurnNotificationService.localizedAttemptDetail(en, reason),
          reason,
        );
      }
    },
  );

  test('retained notification tokens render in the selected language', () {
    final de = lookupAppLocalizations(const Locale('de'));
    final catalog = _catalog('de');
    expect(
      TurnNotificationService.localizedAttemptDetail(de, 'permission denied'),
      catalog['rel_svc_notification_permission_denied'],
    );
    expect(
      TurnNotificationService.localizedAttemptDetail(
        de,
        'notifications are off',
      ),
      catalog['rel_svc_notifications_off'],
    );
    expect(
      TurnNotificationService.localizedAttemptDetail(
        de,
        'unknown_future_reason',
      ),
      'unknown_future_reason',
    );
  });

  test(
    'explicit locale parameter localises completion metadata not syntax',
    () {
      final de = lookupAppLocalizations(const Locale('de'));
      final rows = starterSuggestions('file', strings: de);
      expect(rows, hasLength(1));
      expect(rows.single.insert, '@file:');
      expect(rows.single.kind, 'file');
      expect(
        rows.single.meta,
        _catalog('de')['rel_svc_misc_attach_file_reference'],
      );
    },
  );

  testWidgets(
    'active service locale covers backup results and model fallbacks',
    (tester) async {
      const result = ConfigImportResult(
        connectionsAdded: 2,
        connectionsUpdated: 1,
        connectionsRemoved: 0,
        preferencesApplied: 3,
        preferencesSkipped: 0,
      );
      final activity = GatewayToolActivity.fromGatewayEvent('tool.complete', {
        'name': 'search_files',
        'duration_s': 0.42,
      })!;
      expect(
        result.summary,
        'Connections: 2 added, 1 updated · 3 settings restored',
      );
      expect(activity.statusLabel, 'Completed in 420 ms');
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('de'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => ServiceStringsScope(child: child!),
          home: const Scaffold(
            body: ImageRecoveryCapabilityNotice(gap: ImageRecoveryGap.restSse),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final de = _catalog('de');
      expect(
        () => ConfigBackup.fromJson({}),
        throwsA(
          isA<ConfigBackupException>().having(
            (error) => error.message,
            'localised backup format error',
            de['rel_svc_backup_not_hermes_configuration_backup'],
          ),
        ),
      );
      expect(
        activity.statusLabel,
        (de['rel_svc_misc_completed_in'] as String).replaceAll(
          '{duration}',
          '420 ms',
        ),
      );
      expect(activity.name, 'search_files');
      expect(result.summary, isNot(contains('settings restored')));
      expect(
        find.text(de['rel_svc_misc_image_recovery_rest_gap'] as String),
        findsOneWidget,
      );
      expect(
        find.textContaining('Image and text recovery is not available'),
        findsNothing,
      );
    },
  );
}
