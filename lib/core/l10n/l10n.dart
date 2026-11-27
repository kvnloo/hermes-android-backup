import 'package:flutter/widgets.dart';

import 'package:hermes_android/l10n/app_localizations.dart';

export 'package:hermes_android/l10n/app_localizations.dart'
    show AppLocalizations;

/// Convenience accessor for the generated [AppLocalizations].
///
/// Screens and widgets can read localized strings with `context.l10n.someKey`
/// instead of importing and resolving [AppLocalizations] everywhere.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// For widgets shared by Classic and NextGen. NextGen reads its strings
  /// from `ngL`, so its trees need not carry the generated delegate; fall
  /// back to the ambient locale, then English.
  AppLocalizations get sharedL10n {
    final strings = AppLocalizations.of(this);
    if (strings != null) return strings;
    final locale = Localizations.maybeLocaleOf(this);
    if (locale != null && AppLocalizations.delegate.isSupported(locale)) {
      return lookupAppLocalizations(locale);
    }
    return lookupAppLocalizations(const Locale('en'));
  }
}

/// The app's supported locales with English first.
///
/// Flutter's built-in resolution falls back to the first supported locale for
/// device languages the app does not support. The generated list is ordered
/// alphabetically (German first), so pass this list to [MaterialApp] to make
/// English the fallback.
List<Locale> preferredSupportedLocales() => <Locale>[
  const Locale('en'),
  ...AppLocalizations.supportedLocales.where(
    (final Locale locale) => locale.languageCode != 'en',
  ),
];

/// Resolves the device's preferred locales to one the app can serve.
///
/// Mirrors Flutter's basic resolution order (exact match, then
/// language+script, language+country, and a generic language match) with two
/// deliberate differences:
///
/// * English is the fallback instead of the first supported locale.
/// * A locale variant without its own catalogue is never served another
///   variant's catalogue. Traditional Chinese (`zh-Hant`, `zh_TW`, `zh_HK`,
///   `zh_MO`) uses the Traditional catalogue when it is installed, and is
///   skipped rather than served Simplified Chinese when it is not. Portuguese
///   outside Brazil is not served the Brazilian catalogue. A skipped
///   preference falls through to the next preference, then English.
Locale resolvePreferredLocale(
  List<Locale>? preferredLocales,
  Iterable<Locale> supportedLocales,
) {
  final traditional = _traditionalCatalogue(supportedLocales);
  if (preferredLocales != null) {
    for (final Locale locale in preferredLocales) {
      if (_isTraditionalChinese(locale)) {
        if (traditional != null) return traditional;
        continue;
      }
      if (_isUntranslatedVariant(locale)) {
        continue;
      }
      // Exact match (language + script + country).
      for (final Locale supported in supportedLocales) {
        if (supported == locale) {
          return supported;
        }
      }
      // Language + script.
      if (locale.scriptCode != null) {
        for (final Locale supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode &&
              supported.scriptCode == locale.scriptCode) {
            return supported;
          }
        }
      }
      // Language + country.
      if (locale.countryCode != null) {
        for (final Locale supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode &&
              supported.countryCode == locale.countryCode) {
            return supported;
          }
        }
      }
      // Generic language match (a supported locale without script/country).
      for (final Locale supported in supportedLocales) {
        if (supported.languageCode == locale.languageCode &&
            supported.scriptCode == null &&
            supported.countryCode == null) {
          return supported;
        }
      }
    }
  }
  return const Locale('en');
}

/// Traditional Chinese is its own catalogue. Regions that write Traditional
/// Chinese map to it instead of Simplified Chinese.
bool _isTraditionalChinese(Locale locale) {
  if (locale.languageCode != 'zh' || locale.scriptCode == 'Hans') {
    return false;
  }
  return locale.scriptCode == 'Hant' ||
      const <String>{'TW', 'HK', 'MO'}.contains(locale.countryCode);
}

Locale? _traditionalCatalogue(Iterable<Locale> supported) {
  for (final locale in supported) {
    if (locale.languageCode == 'zh' && locale.scriptCode == 'Hant') {
      return locale;
    }
  }
  return null;
}

/// Whether [locale] names a Portuguese variant the app does not translate,
/// so it must not be served the Brazilian catalogue.
bool _isUntranslatedVariant(Locale locale) {
  if (locale.languageCode == 'pt') {
    return locale.countryCode != null && locale.countryCode != 'BR';
  }
  return false;
}
