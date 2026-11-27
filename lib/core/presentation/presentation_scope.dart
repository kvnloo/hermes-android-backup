import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'imported_theme.dart';
import 'imported_palette.dart';
import 'petdex.dart';
import 'radio.dart';
import 'reading_controls.dart';

/// The one presentation owner for a widget tree. Settings and the status
/// chrome share it so enabling the radio or the companion cannot start a
/// second player or a second pet.
class PresentationHost {
  PresentationHost(SharedPreferences preferences)
    : reading = ReadingControls(preferences),
      pet = PetdexController(preferences),
      radio = AresRadio.fromPreferences(preferences),
      themes = ImportedThemeStore(preferences) {
    radioEnabled.value = radio.enabled;
    radio.addListener(_syncRadioEnabled);
  }

  final ReadingControls reading;
  final PetdexController pet;
  final AresRadio radio;
  final ImportedThemeStore themes;

  /// Changes only when the radio is switched on or off, so a chat's tools
  /// menu need not rebuild for every station or playback update.
  final radioEnabled = ValueNotifier<bool>(false);

  void _syncRadioEnabled() => radioEnabled.value = radio.enabled;

  /// Bumps when the saved import selection changes. Reading and playback
  /// have their own listeners and must not repaint the whole theme.
  final themeRevision = ValueNotifier<int>(0);

  void themeChanged() => themeRevision.value++;

  void dispose() {
    radio.removeListener(_syncRadioEnabled);
    reading.dispose();
    pet.dispose();
    radio.dispose();
    themeRevision.dispose();
    radioEnabled.dispose();
  }
}

class PresentationScope extends InheritedWidget {
  const PresentationScope({
    super.key,
    required this.host,
    required super.child,
  });

  final PresentationHost host;

  static PresentationHost? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PresentationScope>()?.host;

  @override
  bool updateShouldNotify(PresentationScope oldWidget) =>
      oldWidget.host != host;
}

/// Owns the host for the lifetime of the surrounding app.
class PresentationRoot extends StatefulWidget {
  const PresentationRoot({
    super.key,
    required this.preferences,
    required this.child,
  });

  final SharedPreferences preferences;
  final Widget child;

  @override
  State<PresentationRoot> createState() => _PresentationRootState();
}

class _PresentationRootState extends State<PresentationRoot> {
  late final PresentationHost _host = PresentationHost(widget.preferences);

  @override
  void dispose() {
    _host.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PresentationScope(
    host: _host,
    child: ReadingScope(
      controls: _host.reading,
      child: ValueListenableBuilder<int>(
        valueListenable: _host.themeRevision,
        builder: (context, _, _) {
          final selected = _host.themes.read().selected;
          if (selected == null) return widget.child;
          return Theme(
            data: paintImportedTheme(Theme.of(context), selected),
            child: widget.child,
          );
        },
      ),
    ),
  );
}
