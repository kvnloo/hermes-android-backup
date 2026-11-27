// Voice text is localised in every shipped locale: the voice engine and live
// voice keys, the NextGen auto-read title, and the notices and errors the
// voice services build outside any widget, which follow the app's language
// (voice review of 46683e29, card B item 8).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/core/l10n/service_strings.dart';
import 'package:hermes_android/core/services/gateway_wake_word.dart';

const _locales = [
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
];

const _voiceKeys = [
  'voice_engine_title',
  'voice_engine_subtitle',
  'voice_engine_chained',
  'voice_engine_chained_short',
  'voice_engine_live',
  'voice_engine_live_short',
  'voice_engine_live_needs_key',
  'voice_engine_fallback_chained',
  'voice_live_start',
  'voice_live_stop',
  'voice_live_mute',
  'voice_live_unmute',
  'voice_live_interrupt',
  'voice_live_listening',
  'voice_live_speaking',
  'voice_live_thinking',
  'voice_live_muted',
  'ng_auto_read_replies_title',
];

/// Strings the voice services used to build in English only.
const _serviceKeys = [
  'wake_word_reason_disabled',
  'wake_word_reason_surface',
  'wake_word_reason_owned',
  'wake_word_reason_owned_by',
  'wake_word_reason_unavailable',
  'wake_word_reason_permission_denied',
  'wake_word_reason_permission_required',
  'voice_live_not_enabled',
  'voice_live_not_available',
  'voice_live_start_failed',
  'voice_direct_stt_timeout',
  'voice_direct_stt_error',
  'voice_direct_tts_failed',
  'voice_direct_tts_error',
  'ng_wake_status_listening',
  'ng_wake_status_off',
];

/// A product name reads the same in every language.
const _sameEverywhere = {'voice_engine_live_short'};

Map<String, dynamic> _arb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

Set<String> _placeholders(String text) =>
    RegExp(r'\{(\w+)\}').allMatches(text).map((m) => m[1]!).toSet();

Locale _locale(String code) {
  final parts = code.split('_');
  if (parts.length == 1) return Locale(code);
  return parts[1].length == 4
      ? Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1])
      : Locale.fromSubtags(languageCode: parts[0], countryCode: parts[1]);
}

void main() {
  final en = _arb('en');

  test('every voice key is translated in every locale', () {
    for (final locale in _locales) {
      final arb = _arb(locale);
      for (final key in [..._voiceKeys, ..._serviceKeys]) {
        expect(en[key], isA<String>(), reason: 'en $key');
        expect(arb[key], isA<String>(), reason: '$locale $key');
        expect(
          _placeholders(arb[key] as String),
          _placeholders(en[key] as String),
          reason: '$locale $key',
        );
        if (!_sameEverywhere.contains(key)) {
          expect(arb[key], isNot(en[key]), reason: '$locale $key');
        }
      }
    }
  });

  test('the generated strings serve them', () {
    final english = lookupAppLocalizations(const Locale('en'));
    for (final code in _locales) {
      final strings = lookupAppLocalizations(_locale(code));
      expect(strings.voice_live_start, isNot(english.voice_live_start));
      expect(
        strings.voice_engine_fallback_chained('X1'),
        allOf(
          contains('X1'),
          isNot(english.voice_engine_fallback_chained('X1')),
        ),
      );
      expect(
        strings.wake_word_reason_unavailable,
        isNot(english.wake_word_reason_unavailable),
      );
    }
  });

  testWidgets('service notices follow the app language', (tester) async {
    addTearDown(debugResetServiceStrings);
    expect(
      formatWakeRefusalReason('unavailable'),
      'Wake word unavailable on this gateway',
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => ServiceStringsScope(child: child!),
        home: const SizedBox(),
      ),
    );
    final german = lookupAppLocalizations(const Locale('de'));
    expect(serviceStrings.localeName, 'de');
    expect(
      formatWakeRefusalReason('unavailable'),
      german.wake_word_reason_unavailable,
    );
    expect(
      formatWakeRefusalReason('owned', ownerSurface: 'cli'),
      german.wake_word_reason_owned_by('cli'),
    );
    // An unknown code is shown as the gateway sent it.
    expect(formatWakeRefusalReason('brand_new_reason'), 'brand_new_reason');
  });

  test('the voice services no longer build English text themselves', () {
    final sources = {
      'lib/core/services/gateway_wake_word.dart': [
        "'Off — tap to enable'",
        'Arming wake word…',
        'owns the wake-word listener',
        'Wake word unavailable on this gateway',
        "'Microphone permission denied'",
        'Microphone permission required',
      ],
      'lib/core/services/voice_live_engine.dart': [
        'GPT-Live is not enabled for this profile.',
        "'GPT-Live is not available'",
      ],
      'lib/core/services/gpt_live_conversation.dart': [
        'GPT-Live could not start',
      ],
      'lib/core/services/client_direct_voice.dart': [
        'Transcription timed out after',
        'STT error (HTTP',
        'TTS error (HTTP',
        'TTS request failed',
      ],
      'lib/nextgen/ui/chat_view.dart': ['"Listening" : "Off"'],
    };
    for (final MapEntry(key: path, value: literals) in sources.entries) {
      final text = File(path).readAsStringSync();
      for (final literal in literals) {
        expect(text, isNot(contains(literal)), reason: '$path: $literal');
      }
    }
  });
}
