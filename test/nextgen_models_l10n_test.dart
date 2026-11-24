import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/l10n/l10n.dart';

import 'support/l10n_test_utils.dart';

/// Every string the Models page added, read through the generated code with
/// marker values where a message takes arguments.
Map<String, String> values(AppLocalizations l) => {
  'ng_models_default': l.ng_models_default,
  'ng_models_change': l.ng_models_change,
  'ng_models_custom_endpoint': l.ng_models_custom_endpoint,
  'ng_models_context_window': l.ng_models_context_window,
  'ng_models_token_count': l.ng_models_token_count('COUNT'),
  'ng_models_context_override': l.ng_models_context_override('COUNT'),
  'ng_models_max_output': l.ng_models_max_output,
  'ng_models_input_price': l.ng_models_input_price,
  'ng_models_output_price': l.ng_models_output_price,
  'ng_models_cache_price': l.ng_models_cache_price,
  'ng_models_per_million': l.ng_models_per_million('PRICE'),
  'ng_models_price_pair': l.ng_models_price_pair('INPUT', 'OUTPUT'),
  'ng_models_free': l.ng_models_free,
  'ng_models_vision': l.ng_models_vision,
  'ng_models_reasoning': l.ng_models_reasoning,
  'ng_models_fast': l.ng_models_fast,
  'ng_models_in_use': l.ng_models_in_use,
  'ng_models_rate_limited': l.ng_models_rate_limited,
  'ng_models_plan_locked': l.ng_models_plan_locked,
  'ng_models_unsaved': l.ng_models_unsaved,
  'ng_models_discard': l.ng_models_discard,
  'ng_models_aux_hint': l.ng_models_aux_hint,
  'ng_models_uses_default': l.ng_models_uses_default,
  'ng_models_thinking_level': l.ng_models_thinking_level,
  'ng_models_providers': l.ng_models_providers,
  'ng_models_saved': l.ng_models_saved,
  'ng_aux_vision': l.ng_aux_vision,
  'ng_aux_vision_hint': l.ng_aux_vision_hint,
  'ng_aux_compression': l.ng_aux_compression,
  'ng_aux_compression_hint': l.ng_aux_compression_hint,
  'ng_aux_approval': l.ng_aux_approval,
  'ng_aux_approval_hint': l.ng_aux_approval_hint,
  'ng_aux_mcp': l.ng_aux_mcp,
  'ng_aux_mcp_hint': l.ng_aux_mcp_hint,
  'ng_aux_title_generation': l.ng_aux_title_generation,
  'ng_aux_title_generation_hint': l.ng_aux_title_generation_hint,
  'ng_aux_review': l.ng_aux_review,
  'ng_aux_review_hint': l.ng_aux_review_hint,
  'ng_aux_voice_chat': l.ng_aux_voice_chat,
  'ng_aux_voice_chat_hint': l.ng_aux_voice_chat_hint,
  'ng_aux_triage_specifier': l.ng_aux_triage_specifier,
  'ng_aux_triage_specifier_hint': l.ng_aux_triage_specifier_hint,
  'ng_aux_kanban_decomposer': l.ng_aux_kanban_decomposer,
  'ng_aux_kanban_decomposer_hint': l.ng_aux_kanban_decomposer_hint,
  'ng_aux_profile_describer': l.ng_aux_profile_describer,
  'ng_aux_profile_describer_hint': l.ng_aux_profile_describer_hint,
  'ng_aux_curator': l.ng_aux_curator,
  'ng_aux_curator_hint': l.ng_aux_curator_hint,
};

const markers = {
  '{count}': 'COUNT',
  '{price}': 'PRICE',
  '{input}': 'INPUT',
  '{output}': 'OUTPUT',
};

// Where the right word is the English one: "MCP" is a name everywhere, and
// these languages write the others the same way.
const sameAsEnglish = {
  'ng_aux_mcp': {
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
  },
  'ng_models_token_count': {'es', 'fr', 'pt', 'pt_BR'},
  'ng_models_vision': {'fr'},
  'ng_aux_vision': {'fr'},
  'ng_aux_compression': {'fr'},
  'ng_aux_triage_specifier': {'de'},
};

void main() {
  final english =
      jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync()) as Map;

  for (final locale in AppLocalizations.supportedLocales) {
    final id = [
      locale.languageCode,
      ?locale.scriptCode,
      ?locale.countryCode,
    ].join('_');

    test('every Models page string is translated in $id', () async {
      final arb =
          jsonDecode(File('lib/l10n/app_$id.arb').readAsStringSync()) as Map;
      final actual = values(await loadTestL10n(locale));
      expect(actual, hasLength(48));
      for (final entry in actual.entries) {
        final key = entry.key;
        expect(arb.containsKey(key), isTrue, reason: '$id $key');
        final text = arb[key] as String;
        expect(text.trim(), isNotEmpty, reason: '$id $key');
        // The same arguments as the English message, so none is dropped.
        for (final marker in markers.keys) {
          expect(
            text.contains(marker),
            (english[key] as String).contains(marker),
            reason: '$id $key $marker',
          );
        }
        if (id != 'en') {
          expect(
            text == english[key],
            sameAsEnglish[key]?.contains(id) ?? false,
            reason: '$id $key',
          );
        }
        var expected = text;
        markers.forEach((marker, value) {
          expected = expected.replaceAll(marker, value);
        });
        expect(entry.value, expected, reason: '$id $key');
      }
    });

    test('model counts follow the plural rules of $id', () async {
      final arb =
          jsonDecode(File('lib/l10n/app_$id.arb').readAsStringSync()) as Map;
      final l = await loadTestL10n(locale);
      final message = arb['ng_models_count'] as String;
      expect(message, startsWith('{count, plural,'), reason: id);
      if (id != 'en') {
        expect(message, isNot(english['ng_models_count']), reason: id);
      }
      for (final count in [1, 2, 5, 21, 340]) {
        expect(l.ng_models_count(count), contains('$count'), reason: id);
      }
    });
  }

  test('plural forms read correctly where they differ most', () async {
    final en = await loadTestL10n(const Locale('en'));
    expect(en.ng_models_count(1), '1 model');
    expect(en.ng_models_count(2), '2 models');
    final ru = await loadTestL10n(const Locale('ru'));
    expect(ru.ng_models_count(1), '1 модель');
    expect(ru.ng_models_count(3), '3 модели');
    expect(ru.ng_models_count(5), '5 моделей');
    expect(ru.ng_models_count(21), '21 модель');
    final uk = await loadTestL10n(const Locale('uk'));
    expect(uk.ng_models_count(2), '2 моделі');
    expect(uk.ng_models_count(11), '11 моделей');
    final ja = await loadTestL10n(const Locale('ja'));
    expect(ja.ng_models_count(3), '3 個のモデル');
  });
}
