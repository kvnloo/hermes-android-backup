import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/preview/preview_evidence.dart';
import 'package:hermes_android/core/preview/reader_canvas.dart';
import 'package:hermes_android/core/preview/reader_document.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

Map<String, String> _render(AppLocalizations l) => {
  'rel_chat_preview_pin_label': l.rel_chat_preview_pin_label(2, 'NOTE'),
  'rel_chat_preview_pin_number': l.rel_chat_preview_pin_number(2),
  'ng_rel_chat_wake_status_notice': l.ng_rel_chat_wake_status_notice(
    'STATUS',
    'NOTICE',
  ),
  'ng_rel_chat_cost_amount': l.ng_rel_chat_cost_amount('1.2345'),
  'ng_rel_chat_context_ratio': l.ng_rel_chat_context_ratio('1k', '2k'),
  'ng_rel_chat_connection_reason': l.ng_rel_chat_connection_reason(
    'STATUS',
    'REASON',
  ),
  'ng_rel_chat_notice_time': l.ng_rel_chat_notice_time('MESSAGE', 'TIME'),
  'ng_rel_chat_attachment_progress': l.ng_rel_chat_attachment_progress(
    'NAME',
    'PROGRESS',
  ),
  'ng_rel_chat_tool_detail': l.ng_rel_chat_tool_detail('NAME', 'DETAIL'),
};

const _arguments = {
  'number': '2',
  'note': 'NOTE',
  'status': 'STATUS',
  'notice': 'NOTICE',
  'amount': '1.2345',
  'used': '1k',
  'maximum': '2k',
  'reason': 'REASON',
  'message': 'MESSAGE',
  'time': 'TIME',
  'name': 'NAME',
  'progress': 'PROGRESS',
  'detail': 'DETAIL',
};

void main() {
  test('remaining chat templates have explicit values in every catalogue', () {
    final english =
        jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync()) as Map;
    expect(AppLocalizations.supportedLocales, hasLength(14));
    for (final locale in AppLocalizations.supportedLocales) {
      final id = [
        locale.languageCode,
        ?locale.scriptCode,
        ?locale.countryCode,
      ].join('_');
      final catalogue =
          jsonDecode(File('lib/l10n/app_$id.arb').readAsStringSync()) as Map;
      final rendered = _render(lookupAppLocalizations(locale));
      expect(rendered, hasLength(9));
      for (final entry in rendered.entries) {
        expect(catalogue[entry.key], isA<String>(), reason: '$id ${entry.key}');
        final metadata = english['@${entry.key}'] as Map;
        expect(metadata['description'], isNotEmpty);
        var expected = catalogue[entry.key] as String;
        final placeholders = metadata['placeholders'] as Map;
        for (final name in placeholders.keys) {
          expect(expected, contains('{$name}'));
          expect(
            (placeholders[name] as Map)['type'],
            name == 'number' ? 'int' : 'String',
          );
          expected = expected.replaceAll('{$name}', _arguments[name]!);
        }
        expect(entry.value, expected, reason: '$id ${entry.key}');
      }
    }
  });

  test('English display output is byte-for-byte unchanged', () {
    expect(_render(lookupAppLocalizations(const Locale('en'))), {
      'rel_chat_preview_pin_label': '#2 NOTE',
      'rel_chat_preview_pin_number': '#2',
      'ng_rel_chat_wake_status_notice': 'STATUS — NOTICE',
      'ng_rel_chat_cost_amount': '\$1.2345',
      'ng_rel_chat_context_ratio': '1k / 2k',
      'ng_rel_chat_connection_reason': 'STATUS REASON',
      'ng_rel_chat_notice_time': 'MESSAGE · TIME',
      'ng_rel_chat_attachment_progress': 'NAME · PROGRESS',
      'ng_rel_chat_tool_detail': 'NAME · DETAIL',
    });
  });

  testWidgets('reader pin survives locale changes without an app delegate', (
    tester,
  ) async {
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    final document = ReaderDocument.parse(
      Uri.parse('https://preview.invalid'),
      '<p>Remote page content</p>',
    );
    final canvas = ReaderCanvas(
      document: document,
      annotate: false,
      pins: [
        PreviewPin(
          2,
          const Rect.fromLTWH(10, 20, 30, 40),
          'p',
          'User note',
          Uint8List(0),
        ),
      ],
      scroll: scroll,
      onLink: (_) {},
      onCrop: (_, _, _) async {},
      onError: () => fail('No capture requested'),
    );
    Object? firstState;
    for (final locale in const [Locale('en'), Locale('ar'), Locale('de')]) {
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(body: canvas),
        ),
      );
      await tester.pumpAndSettle();
      final state = tester.state(find.byType(ReaderCanvas));
      firstState ??= state;
      expect(state, same(firstState));
      expect(
        find.text(
          lookupAppLocalizations(locale).rel_chat_preview_pin_number(2),
        ),
        findsOneWidget,
      );
      expect(find.text('Remote page content'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(const SizedBox());
  });
}
