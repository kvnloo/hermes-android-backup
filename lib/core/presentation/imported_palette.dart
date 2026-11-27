import 'package:flutter/material.dart';

import '../theme/hermes_theme.dart';
import '../../nextgen/nextgen_preferences.dart';
import '../../nextgen/theme/nextgen_theme.dart';
import 'imported_theme.dart';

/// Builds the whole theme for a saved import, in the import's own brightness.
///
/// Recolouring only the scheme and the colour extensions left text styles,
/// app bars, cards, inputs and dividers on the built-in palette of the app's
/// brightness: a dark import over a light app painted dark text on a dark
/// background. The layout's own theme builder now derives every component
/// from the import. Theme extensions other than the two colour sets, and
/// the platform and density settings, are kept from [current].
ThemeData paintImportedTheme(ThemeData current, ImportedTheme imported) {
  final nextGen = current.extension<NgColors>() != null;
  // The surrounding theme animates between brightnesses frame by frame; the
  // import's own theme does not change with it, so build it once.
  final key = [
    nextGen,
    imported.brightness.name,
    for (final role in ImportedThemeColor.values) imported[role].toARGB32(),
  ].join(',');
  final built = _built[key] ??= _build(imported, nextGen: nextGen);
  if (_built.length > 8) _built.remove(_built.keys.first);
  return built.copyWith(
    platform: current.platform,
    visualDensity: current.visualDensity,
    materialTapTargetSize: current.materialTapTargetSize,
    pageTransitionsTheme: current.pageTransitionsTheme,
    extensions: [
      ...current.extensions.values.where(
        (extension) => extension is! HermesTokens && extension is! NgColors,
      ),
      ...built.extensions.values.where(
        (extension) => extension is HermesTokens || extension is NgColors,
      ),
    ],
  );
}

final _built = <String, ThemeData>{};

ThemeData _build(ImportedTheme imported, {required bool nextGen}) {
  final ink = _ReadableImport(imported);
  final scheme = _importedScheme(ink, imported.brightness, nextGen: nextGen);
  final theme = nextGen
      ? nextGenTheme(
          imported.brightness,
          NextGenLook.instance,
          profileScheme: scheme,
          colors: _paintNg(imported, ink, scheme),
        )
      : hermesTheme(imported.brightness, profileScheme: scheme);
  // Classic's status inks (also used by the Classic screens NextGen opens)
  // are fixed per brightness, not taken from the import: correct them
  // against the import's surfaces like every other ink.
  final tokens = theme.extension<HermesTokens>()!;
  return theme.copyWith(
    extensions: [
      ...theme.extensions.values.where((e) => e is! HermesTokens),
      tokens.copyWith(
        success: ink.status(tokens.success),
        warning: ink.status(tokens.warning),
        danger: ink.error,
        running: ink.status(tokens.running),
        blocked: ink.status(tokens.blocked),
      ),
    ],
  );
}

/// Text has to clear 4.5:1 on every surface it is drawn on. A theme that
/// falls short keeps its hue and moves toward black or white.
Color _legible(Color ink, List<Color> surfaces) {
  bool passes(Color color) =>
      surfaces.every((surface) => contrastRatio(color, surface) >= 4.5);
  if (passes(ink)) return ink;
  final target = foregroundFor(surfaces.first);
  for (var step = 1; step <= 32; step++) {
    final mixed = Color.lerp(ink, target, step / 32)!;
    if (passes(mixed)) return mixed;
  }
  return target;
}

Color _over(Color tint, double alpha, Color surface) =>
    Color.alphaBlend(tint.withValues(alpha: alpha), surface);

/// The tints both layouts lay over a surface to mark it selected, focused
/// or in error: NextGen's accent and danger washes (16%), Classic's selected
/// rows, chips and menu items (18%).
List<Color> _tints(Color surface, Color accent, Color error) => [
  _over(accent, 0.16, surface),
  _over(accent, 0.18, surface),
  _over(error, 0.16, surface),
];

/// The heaviest wash a status colour is laid over a surface with (NextGen
/// badges and danger fills, Classic error containers): 16%.
const _statusWash = 0.16;

/// A status ink (error, warning, success, running, blocked) has to clear
/// 4.5:1 on every surface text is drawn on, [plain] and [tinted], and on
/// its own badge wash over each plain surface. One that falls short keeps
/// its hue and moves toward black or white.
Color _readableStatus(Color ink, List<Color> plain, List<Color> tinted) {
  bool passes(Color color) => [
    ...plain,
    ...tinted,
    for (final surface in plain) _over(color, _statusWash, surface),
  ].every((surface) => contrastRatio(color, surface) >= 4.5);
  if (passes(ink)) return ink;
  final target = foregroundFor(plain.first);
  for (var step = 1; step <= 32; step++) {
    final mixed = Color.lerp(ink, target, step / 32)!;
    if (passes(mixed)) return mixed;
  }
  return target;
}

/// A surface no text could be read on alongside the background (a dark
/// activity bar in a light theme, say) moves toward the background until
/// black or white text clears 4.5:1 on it again, with some headroom.
Color _hostable(Color surface, Color background) {
  final target = foregroundFor(background);
  if (contrastRatio(target, surface) >= 4.5) return surface;
  final goal = contrastRatio(target, background).clamp(4.5, 7.0);
  for (var step = 1; step <= 32; step++) {
    final mixed = Color.lerp(surface, background, step / 32)!;
    if (contrastRatio(target, mixed) >= goal) return mixed;
  }
  return background;
}

/// An import's colours with every ink corrected against every surface it is
/// drawn on in either layout: the page, cards, raised menus and dialogs, the
/// sidebar, inputs and the composer, and the selected, focused and error
/// tints over each of them. Snack bars and tooltips invert the foreground
/// and the background, which clear 4.5:1 against each other by the same
/// correction. Status inks (the import's error, and the layouts' own
/// warning, success, running and blocked) are corrected the same way and
/// also against their own badge wash.
final class _ReadableImport {
  factory _ReadableImport(ImportedTheme t) {
    final background = t[ImportedThemeColor.background];
    Color host(ImportedThemeColor role) => _hostable(t[role], background);
    final card = host(ImportedThemeColor.card);
    final raised = host(ImportedThemeColor.raised);
    final sidebar = host(ImportedThemeColor.sidebar);
    final input = host(ImportedThemeColor.input);
    final plain = [background, card, raised, sidebar, input];
    // The accent is also text (links, selected rows, focused labels), so it
    // has to read on its own selection tint and the error wash as well.
    Color readableAccent(Color start, Color error) {
      bool passes(Color accent) => [
        for (final surface in plain) ...[
          surface,
          ..._tints(surface, accent, error),
        ],
      ].every((surface) => contrastRatio(accent, surface) >= 4.5);
      if (passes(start)) return start;
      final target = foregroundFor(background);
      var accent = start;
      for (var step = 1; step <= 32; step++) {
        accent = Color.lerp(start, target, step / 32)!;
        if (passes(accent)) break;
      }
      return accent;
    }

    // Error text sits on the accent's selection tints and the accent on the
    // error wash, so settle the two together. Each only ever moves toward
    // black or white, so this stops within a few rounds.
    var accent = t[ImportedThemeColor.accent];
    var error = t[ImportedThemeColor.error];
    for (var round = 0; round < 4; round++) {
      final nextAccent = readableAccent(accent, error);
      final nextError = _readableStatus(error, plain, [
        for (final surface in plain) ..._tints(surface, nextAccent, error),
      ]);
      final settled = nextAccent == accent && nextError == error;
      accent = nextAccent;
      error = nextError;
      if (settled) break;
    }
    final tinted = [
      for (final surface in plain) ..._tints(surface, accent, error),
    ];
    final surfaces = [...plain, ...tinted];
    final foreground = _legible(t[ImportedThemeColor.foreground], surfaces);
    return _ReadableImport._(
      background: background,
      card: card,
      raised: raised,
      sidebar: sidebar,
      input: input,
      accent: accent,
      error: error,
      border: t[ImportedThemeColor.border],
      foreground: foreground,
      muted: _legible(t[ImportedThemeColor.mutedForeground], surfaces),
      // Snack bar actions sit on the inverted foreground.
      inverseAccent: _legible(accent, [foreground]),
      plain: plain,
      tinted: tinted,
    );
  }

  const _ReadableImport._({
    required this.background,
    required this.card,
    required this.raised,
    required this.sidebar,
    required this.input,
    required this.accent,
    required this.error,
    required this.border,
    required this.foreground,
    required this.muted,
    required this.inverseAccent,
    required this.plain,
    required this.tinted,
  });

  final Color background;
  final Color card;
  final Color raised;
  final Color sidebar;
  final Color input;
  final Color accent;
  final Color error;
  final Color border;
  final Color foreground;
  final Color muted;
  final Color inverseAccent;

  /// The plain surfaces, and the selection and error tints over them.
  final List<Color> plain;
  final List<Color> tinted;

  /// A layout's built-in status colour ([ink]: warning, success, running,
  /// blocked), kept in hue and corrected for this import's surfaces.
  Color status(Color ink) => _readableStatus(ink, plain, tinted);
}

ColorScheme _importedScheme(
  _ReadableImport ink,
  Brightness brightness, {
  required bool nextGen,
}) {
  final background = ink.background;
  final accent = ink.accent;
  final error = ink.error;
  final foreground = ink.foreground;
  return ColorScheme.fromSeed(
    seedColor: accent,
    brightness: brightness,
  ).copyWith(
    primary: accent,
    onPrimary: foregroundFor(accent),
    primaryContainer: _over(accent, 0.16, background),
    onPrimaryContainer: foreground,
    inversePrimary: ink.inverseAccent,
    surfaceTint: accent,
    surface: background,
    onSurface: foreground,
    onSurfaceVariant: ink.muted,
    surfaceContainerLowest: background,
    // Classic draws cards, menus and inputs on its raised surface;
    // NextGen draws cards on `surface` and steps up from there.
    surfaceContainerLow: nextGen ? ink.card : ink.raised,
    surfaceContainer: ink.raised,
    surfaceContainerHigh: ink.raised,
    surfaceContainerHighest: ink.raised,
    outline: ink.border,
    outlineVariant: ink.border,
    error: error,
    onError: foregroundFor(error),
    errorContainer: _over(error, 0.16, background),
    onErrorContainer: foreground,
    inverseSurface: foreground,
    onInverseSurface: background,
  );
}

NgColors _paintNg(ImportedTheme imported, _ReadableImport ink, ColorScheme s) {
  // Status colours follow the import's brightness, not the app's.
  final status = NgColors.build(
    imported.brightness,
    NextGenLook.instance.accent,
    false,
    false,
  );
  final accent = s.primary;
  final background = s.surface;
  final success = ink.status(status.success);
  final warning = ink.status(status.warning);
  return NgColors(
    background: background,
    surface: ink.card,
    surface2: ink.raised,
    surface3: ink.raised,
    well: ink.input,
    thumb: ink.card,
    sheet: ink.card,
    input: ink.input,
    sidebar: ink.sidebar,
    userBubble: accent,
    onUserBubble: s.onPrimary,
    text: s.onSurface,
    text2: s.onSurface,
    text3: s.onSurfaceVariant,
    textMuted: s.onSurfaceVariant,
    accent: accent,
    onAccent: s.onPrimary,
    accentText: accent,
    accentSoft: accent.withValues(alpha: 0.16),
    inverse: s.onSurface,
    onInverse: background,
    stroke: s.outlineVariant,
    strokeStrong: s.outline,
    danger: s.error,
    success: success,
    warning: warning,
    dangerSoft: s.error.withValues(alpha: _statusWash),
    successSoft: success.withValues(alpha: status.successSoft.a),
    warningSoft: warning.withValues(alpha: status.warningSoft.a),
    glow: false,
  );
}
