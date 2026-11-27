// Covers the app-level locale resolution added for the follow-up review:
// English is the fallback for unsupported device languages (instead of the
// alphabetically first locale). Arabic uses its own catalogue. Traditional
// Chinese uses the Traditional catalogue, never Simplified Chinese.
// Portuguese outside Brazil is never served the Brazilian catalogue.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/l10n/l10n.dart';

Locale _resolve(List<Locale>? preferred) =>
    resolvePreferredLocale(preferred, preferredSupportedLocales());

void main() {
  group('preferredSupportedLocales', () {
    test('lists English first and keeps every generated locale', () {
      final locales = preferredSupportedLocales();
      expect(locales.first, const Locale('en'));
      expect(locales.length, AppLocalizations.supportedLocales.length);
      expect(locales.toSet(), AppLocalizations.supportedLocales.toSet());
    });
  });

  group('resolvePreferredLocale', () {
    test('falls back to English for an unsupported language', () {
      expect(_resolve(const [Locale('sv')]), const Locale('en'));
      expect(_resolve(const [Locale('sv', 'SE')]), const Locale('en'));
    });

    test('resolves supported languages and their regional variants', () {
      expect(_resolve(const [Locale('ja')]), const Locale('ja'));
      expect(_resolve(const [Locale('ja', 'JP')]), const Locale('ja'));
      expect(_resolve(const [Locale('de', 'AT')]), const Locale('de'));
      expect(_resolve(const [Locale('en', 'GB')]), const Locale('en'));
      expect(_resolve(const [Locale('ru', 'RU')]), const Locale('ru'));
      expect(_resolve(const [Locale('ar')]), const Locale('ar'));
      expect(_resolve(const [Locale('ar', 'SA')]), const Locale('ar'));
    });

    test('serves each Chinese script its own catalogue', () {
      const hans = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
      const hant = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
      expect(_resolve(const [hans]), hans);
      expect(
        _resolve(const [
          Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans',
            countryCode: 'CN',
          ),
        ]),
        hans,
      );
      expect(_resolve(const [hant]), hant);
      expect(_resolve(const [Locale('zh', 'TW')]), hant);
      expect(_resolve(const [Locale('zh', 'HK')]), hant);
      expect(_resolve(const [Locale('zh', 'MO')]), hant);
    });

    test('serves Brazilian Portuguese only to BR locales', () {
      expect(_resolve(const [Locale('pt', 'BR')]), const Locale('pt', 'BR'));
      expect(_resolve(const [Locale('pt', 'PT')]), const Locale('en'));
    });

    test('falls through to the next preferred locale before English', () {
      expect(
        _resolve(const [Locale('pt', 'PT'), Locale('ja')]),
        const Locale('ja'),
      );
      expect(_resolve(const [Locale('sv'), Locale('de')]), const Locale('de'));
    });
  });

  testWidgets('an unsupported device locale renders English', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('sv'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: preferredSupportedLocales(),
        localeListResolutionCallback: resolvePreferredLocale,
        home: Builder(
          builder: (context) =>
              Text(Localizations.localeOf(context).languageCode),
        ),
      ),
    );

    expect(find.text('en'), findsOneWidget);
  });

  testWidgets('an Arabic device locale stays Arabic and right to left', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar', 'SA'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: preferredSupportedLocales(),
        localeListResolutionCallback: resolvePreferredLocale,
        home: Builder(
          builder: (context) => Text(
            '${Localizations.localeOf(context).languageCode}_'
            '${Directionality.of(context).name}',
          ),
        ),
      ),
    );

    expect(find.text('ar_rtl'), findsOneWidget);
  });

  testWidgets('a Traditional Chinese device locale renders Hant, not Hans', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'TW'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: preferredSupportedLocales(),
        localeListResolutionCallback: resolvePreferredLocale,
        home: Builder(
          builder: (context) {
            final locale = Localizations.localeOf(context);
            return Text('${locale.languageCode}_${locale.scriptCode}');
          },
        ),
      ),
    );

    expect(find.text('zh_Hant'), findsOneWidget);
  });
}
