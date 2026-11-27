// Localized text built outside any widget.
//
// Some services (wake word, live voice, client-direct voice) build notices
// and errors that the UI shows later, with no BuildContext at hand. They read
// the app's current strings here: [ServiceStringsScope], placed in the app's
// builder for both layouts, keeps them in step with the app's language.
// English is used until then (and in tests).
import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

final AppLocalizations _english = lookupAppLocalizations(const Locale('en'));
AppLocalizations _current = _english;

/// The app's strings for text a service builds outside any widget.
AppLocalizations get serviceStrings => _current;

@visibleForTesting
void debugResetServiceStrings() => _current = _english;

/// Keeps [serviceStrings] in step with the app's language. Sits under the
/// app's Localizations (the MaterialApp builder). Text a service built
/// earlier keeps its language; the next notice uses the new one.
class ServiceStringsScope extends StatefulWidget {
  const ServiceStringsScope({super.key, required this.child});

  final Widget child;

  @override
  State<ServiceStringsScope> createState() => _ServiceStringsScopeState();
}

class _ServiceStringsScopeState extends State<ServiceStringsScope> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final strings = AppLocalizations.of(context);
    if (strings != null) _current = strings;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
