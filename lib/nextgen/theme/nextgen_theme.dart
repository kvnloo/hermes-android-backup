// NextGen design tokens: graphite surfaces that step up in lightness instead
// of casting shadows, one accent, generous radii and Geist-sized type.
// Colour values follow Kyllene's "modern" palette (MIT).
import 'package:flutter/material.dart';

import '../../core/theme/hermes_theme.dart';
import '../nextgen_preferences.dart';

class _AccentColors {
  final Color accent;
  final Color onAccent;
  final Color text;
  final Color soft;
  const _AccentColors(this.accent, this.onAccent, this.text, this.soft);
}

const _darkText = Color(0xFF0A0A0C);
const _heraldBlue = Color(0xFF2F6BF5);

_AccentColors _accentColors(NgAccent accent, Brightness brightness) {
  final dark = brightness == Brightness.dark;
  if (accent == NgAccent.blue) {
    return dark
        ? _AccentColors(
            _heraldBlue,
            Colors.white,
            const Color(0xFF7AA5FF),
            const Color(0xFF4A84FE).withValues(alpha: 0.14),
          )
        : _AccentColors(
            _heraldBlue,
            Colors.white,
            const Color(0xFF1F56D6),
            _heraldBlue.withValues(alpha: 0.10),
          );
  }
  // Light mode's link and label ink is a shade darker than the fill, so it
  // still clears 4.5:1 on its own 10% wash over the raised surfaces.
  final (light, lightText, darkColor) = switch (accent) {
    NgAccent.violet => (
      const Color(0xFF7C3AED),
      const Color(0xFF7436DE),
      const Color(0xFFA78BFA),
    ),
    NgAccent.green => (
      const Color(0xFF137538),
      const Color(0xFF126F35),
      const Color(0xFF3FB950),
    ),
    NgAccent.orange => (
      const Color(0xFFB04700),
      const Color(0xFFA44200),
      const Color(0xFFF0883E),
    ),
    NgAccent.pink => (
      const Color(0xFFB0327E),
      const Color(0xFFA62F77),
      const Color(0xFFF778BA),
    ),
    NgAccent.teal => (
      const Color(0xFF0C6A84),
      const Color(0xFF0C6882),
      const Color(0xFF22D3EE),
    ),
    NgAccent.blue => (_heraldBlue, _heraldBlue, _heraldBlue),
  };
  return dark
      ? _AccentColors(
          darkColor,
          _darkText,
          darkColor,
          darkColor.withValues(alpha: 0.14),
        )
      : _AccentColors(
          light,
          Colors.white,
          lightText,
          light.withValues(alpha: 0.10),
        );
}

/// The swatch shown for an accent in Settings.
Color ngAccentSwatch(NgAccent accent, Brightness brightness) =>
    _accentColors(accent, brightness).accent;

/// NextGen colour roles. Widgets read these, never raw literals.
@immutable
class NgColors extends ThemeExtension<NgColors> {
  final Color background;
  final Color surface;
  final Color surface2;
  final Color surface3;
  final Color well;
  final Color thumb;
  final Color sheet;
  final Color input;
  final Color sidebar;
  final Color userBubble;
  final Color onUserBubble;
  final Color text;
  final Color text2;
  final Color text3;
  final Color textMuted;
  final Color accent;
  final Color onAccent;
  final Color accentText;
  final Color accentSoft;
  final Color inverse;
  final Color onInverse;
  final Color stroke;
  final Color strokeStrong;
  final Color danger;
  final Color success;
  final Color warning;
  final Color dangerSoft;
  final Color successSoft;
  final Color warningSoft;
  final bool glow;

  const NgColors({
    required this.background,
    required this.surface,
    required this.surface2,
    required this.surface3,
    required this.well,
    required this.thumb,
    required this.sheet,
    required this.input,
    required this.sidebar,
    required this.userBubble,
    required this.onUserBubble,
    required this.text,
    required this.text2,
    required this.text3,
    required this.textMuted,
    required this.accent,
    required this.onAccent,
    required this.accentText,
    required this.accentSoft,
    required this.inverse,
    required this.onInverse,
    required this.stroke,
    required this.strokeStrong,
    required this.danger,
    required this.success,
    required this.warning,
    required this.dangerSoft,
    required this.successSoft,
    required this.warningSoft,
    required this.glow,
  });

  static NgColors of(BuildContext context) =>
      Theme.of(context).extension<NgColors>() ??
      NgColors.build(Brightness.dark, NgAccent.blue, false, true);

  factory NgColors.build(
    Brightness brightness,
    NgAccent accent,
    bool pureBlack,
    bool glow,
  ) {
    final a = _accentColors(accent, brightness);
    // Every ink clears 4.5:1 where it is drawn, for every accent: secondary
    // and muted text (hints, times, details) on every surface and on the
    // accent and status washes that tint rows; status inks on their own
    // badge wash. Muted text stays a step lighter than secondary text.
    if (brightness == Brightness.light) {
      const danger = Color(0xFFBA1F29);
      const success = Color(0xFF176F30);
      const warning = Color(0xFF8B5300);
      final line = const Color(0xFF0A0A1E);
      return NgColors(
        background: const Color(0xFFF7F7F9),
        surface: Colors.white,
        surface2: const Color(0xFFF1F1F5),
        surface3: const Color(0xFFE9E9EF),
        well: const Color(0xFFF3F3F7),
        thumb: Colors.white,
        sheet: Colors.white,
        input: Colors.white,
        sidebar: Colors.white,
        userBubble: a.accent,
        onUserBubble: a.onAccent,
        text: const Color(0xFF0A0A0C),
        text2: const Color(0xFF27272A),
        text3: const Color(0xFF5F5F68),
        textMuted: const Color(0xFF686870),
        accent: a.accent,
        onAccent: a.onAccent,
        accentText: a.text,
        accentSoft: a.soft,
        inverse: const Color(0xFF0A0A0C),
        onInverse: Colors.white,
        stroke: line.withValues(alpha: 0.08),
        strokeStrong: line.withValues(alpha: 0.14),
        danger: danger,
        success: success,
        warning: warning,
        dangerSoft: danger.withValues(alpha: 0.09),
        successSoft: success.withValues(alpha: 0.10),
        warningSoft: warning.withValues(alpha: 0.10),
        glow: glow,
      );
    }
    const danger = Color(0xFFF96F68);
    const success = Color(0xFF3FB950);
    const warning = Color(0xFFF5A524);
    final bg = pureBlack ? Colors.black : const Color(0xFF0A0A0C);
    final surface = pureBlack
        ? const Color(0xFF111114)
        : const Color(0xFF16161A);
    return NgColors(
      background: bg,
      surface: surface,
      surface2: pureBlack ? const Color(0xFF17171C) : const Color(0xFF1C1C22),
      surface3: pureBlack ? const Color(0xFF1E1E24) : const Color(0xFF232329),
      well: pureBlack ? const Color(0xFF0C0C0E) : const Color(0xFF121215),
      thumb: const Color(0xFF2C2C33),
      sheet: pureBlack ? const Color(0xFF141418) : const Color(0xFF18181D),
      input: surface,
      sidebar: surface,
      userBubble: a.accent,
      onUserBubble: a.onAccent,
      text: const Color(0xFFF4F4F6),
      text2: const Color(0xFFD4D4D8),
      text3: const Color(0xFFA1A1A9),
      textMuted: const Color(0xFF898991),
      accent: a.accent,
      onAccent: a.onAccent,
      accentText: a.text,
      accentSoft: a.soft,
      inverse: const Color(0xFFF4F4F6),
      onInverse: const Color(0xFF0A0A0C),
      stroke: Colors.white.withValues(alpha: 0.07),
      strokeStrong: Colors.white.withValues(alpha: 0.12),
      danger: danger,
      success: success,
      warning: warning,
      dangerSoft: danger.withValues(alpha: 0.14),
      successSoft: success.withValues(alpha: 0.13),
      warningSoft: warning.withValues(alpha: 0.13),
      glow: glow,
    );
  }

  @override
  NgColors copyWith() => this;

  @override
  NgColors lerp(ThemeExtension<NgColors>? other, double t) {
    if (other is! NgColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return NgColors(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surface2: l(surface2, other.surface2),
      surface3: l(surface3, other.surface3),
      well: l(well, other.well),
      thumb: l(thumb, other.thumb),
      sheet: l(sheet, other.sheet),
      input: l(input, other.input),
      sidebar: l(sidebar, other.sidebar),
      userBubble: l(userBubble, other.userBubble),
      onUserBubble: l(onUserBubble, other.onUserBubble),
      text: l(text, other.text),
      text2: l(text2, other.text2),
      text3: l(text3, other.text3),
      textMuted: l(textMuted, other.textMuted),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      accentText: l(accentText, other.accentText),
      accentSoft: l(accentSoft, other.accentSoft),
      inverse: l(inverse, other.inverse),
      onInverse: l(onInverse, other.onInverse),
      stroke: l(stroke, other.stroke),
      strokeStrong: l(strokeStrong, other.strokeStrong),
      danger: l(danger, other.danger),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      dangerSoft: l(dangerSoft, other.dangerSoft),
      successSoft: l(successSoft, other.successSoft),
      warningSoft: l(warningSoft, other.warningSoft),
      glow: t < 0.5 ? glow : other.glow,
    );
  }
}

/// NextGen radii.
abstract final class NgRadii {
  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 20.0;
  static const xl = 26.0;
  static const full = 999.0;
}

/// NextGen type scale (Geist; hierarchy from size and colour steps).
abstract final class NgType {
  static const family = 'Geist';
  static const mono = 'GeistMono';

  static const display = TextStyle(
    fontFamily: family,
    fontSize: 32,
    height: 35 / 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.96,
  );
  static const title = TextStyle(
    fontFamily: family,
    fontSize: 22,
    height: 26 / 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.44,
  );
  static const heading = TextStyle(
    fontFamily: family,
    fontSize: 16,
    height: 21 / 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.16,
  );
  static const body = TextStyle(
    fontFamily: family,
    fontSize: 15,
    height: 1.5,
    letterSpacing: -0.075,
  );
  static const bodySmall = TextStyle(
    fontFamily: family,
    fontSize: 13.5,
    height: 19.5 / 13.5,
    letterSpacing: -0.07,
  );
  static const label = TextStyle(
    fontFamily: family,
    fontSize: 13,
    height: 17 / 13,
    fontWeight: FontWeight.w500,
  );
  static const caption = TextStyle(
    fontFamily: family,
    fontSize: 12,
    height: 16 / 12,
  );
  static const code = TextStyle(
    fontFamily: mono,
    fontSize: 12.5,
    height: 19.5 / 12.5,
  );
  static const eyebrow = TextStyle(
    fontFamily: family,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.88,
  );
}

/// Builds the NextGen [ThemeData] for [brightness]. It keeps the classic
/// [HermesTokens] extension (re-tinted to NextGen's palette) so every classic
/// screen opened from NextGen still renders correctly. [colors], when given,
/// is a complete NextGen palette (an imported theme) and every component is
/// derived from it instead of from [look] or [profileScheme].
ThemeData nextGenTheme(
  Brightness brightness,
  NextGenLook look, {
  ColorScheme? profileScheme,
  NgColors? colors,
}) {
  final base = hermesTheme(brightness, profileScheme: profileScheme);
  final hermesThemeStatus = base.extension<HermesTokens>()!;
  final s = profileScheme;
  final fromLook = s == null
      ? NgColors.build(brightness, look.accent, look.pureBlack, look.glow)
      : NgColors(
          background: s.surface,
          surface: s.surfaceContainerLow,
          surface2: s.surfaceContainer,
          surface3: s.surfaceContainerHigh,
          well: s.surfaceContainerLowest,
          thumb: s.surfaceContainerHighest,
          sheet: s.surfaceContainerLow,
          input: s.surfaceContainerLow,
          sidebar: s.surfaceContainerLow,
          userBubble: s.primary,
          onUserBubble: s.onPrimary,
          text: s.onSurface,
          text2: s.onSurface,
          text3: s.onSurfaceVariant,
          textMuted: s.onSurfaceVariant,
          accent: s.primary,
          onAccent: s.onPrimary,
          accentText: s.primary,
          accentSoft: s.primaryContainer,
          inverse: s.inverseSurface,
          onInverse: s.onInverseSurface,
          stroke: s.outlineVariant,
          strokeStrong: s.outline,
          danger: s.error,
          success: hermesThemeStatus.success,
          warning: hermesThemeStatus.warning,
          dangerSoft: s.errorContainer,
          successSoft: hermesThemeStatus.success.withValues(alpha: 0.13),
          warningSoft: hermesThemeStatus.warning.withValues(alpha: 0.13),
          glow: look.glow,
        );
  final c = colors ?? fromLook;
  // An imported palette has its muted ink corrected against every surface,
  // so disabled text uses it instead of Material's 38% wash, which falls
  // below 4.5:1 on a theme's own fills. Built-in looks keep the default.
  final disabledInk = colors?.text3;

  final scheme = base.colorScheme.copyWith(
    brightness: brightness,
    primary: c.accent,
    onPrimary: c.onAccent,
    primaryContainer: c.accentSoft,
    onPrimaryContainer: c.accentText,
    secondary: c.accentText,
    onSecondary: c.onAccent,
    secondaryContainer: c.surface3,
    onSecondaryContainer: c.text,
    tertiary: c.accentText,
    surface: c.background,
    onSurface: c.text,
    onSurfaceVariant: c.text3,
    surfaceContainerLowest: c.background,
    surfaceContainerLow: c.surface,
    surfaceContainer: c.surface,
    surfaceContainerHigh: c.surface2,
    surfaceContainerHighest: c.surface3,
    outline: c.strokeStrong,
    outlineVariant: c.stroke,
    error: c.danger,
    onError: Colors.white,
    inverseSurface: c.inverse,
    onInverseSurface: c.onInverse,
  );
  // Shared settings controls (radio sheets, sliders, segmented selectors and
  // legacy HermesTokens readers) must inherit this experience's scheme too.
  // Rebuild the Material defaults after resolving NextGen/imported colours.
  final material = hermesTheme(brightness, profileScheme: scheme);
  // Complete (inherit: false) styles, so Material's animated text styles can
  // lerp between theme values without an inherit mismatch.
  final fullBase = base.textTheme.bodyMedium!;
  TextStyle t(TextStyle s, [Color? color]) =>
      fullBase.merge(s).copyWith(color: color ?? c.text);
  final textTheme = base.textTheme
      .apply(fontFamily: NgType.family, bodyColor: c.text, displayColor: c.text)
      .copyWith(
        displaySmall: t(NgType.display),
        headlineSmall: t(NgType.title),
        titleLarge: t(NgType.title),
        titleMedium: t(NgType.heading),
        titleSmall: t(NgType.label),
        bodyLarge: t(NgType.body),
        bodyMedium: t(NgType.bodySmall),
        bodySmall: t(NgType.caption, c.text3),
        labelLarge: t(NgType.label),
        labelMedium: t(NgType.caption),
        labelSmall: t(NgType.eyebrow, c.text3),
      );
  final pill = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(NgRadii.full),
  );
  final List<ThemeExtension<dynamic>> extensions = [
    ...material.extensions.values.where((e) => e is! NgColors),
    c,
  ];
  return material.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: c.background,
    canvasColor: c.background,
    disabledColor: disabledInk ?? material.disabledColor,
    cardColor: c.surface,
    dividerColor: c.stroke,
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    extensions: extensions,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: t(NgType.heading),
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NgRadii.lg),
        side: BorderSide(color: c.stroke),
      ),
    ),
    dividerTheme: DividerThemeData(color: c.stroke, space: 1, thickness: 1),
    listTileTheme: ListTileThemeData(
      iconColor: c.text3,
      textColor: c.text,
      titleTextStyle: t(NgType.body),
      subtitleTextStyle: t(NgType.caption, c.text3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NgRadii.md),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.input,
      hintStyle: t(NgType.body, c.textMuted),
      labelStyle: t(NgType.bodySmall, c.text3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(NgRadii.md),
        borderSide: BorderSide(color: c.stroke),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(NgRadii.md),
        borderSide: BorderSide(color: c.stroke),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(NgRadii.md),
        borderSide: BorderSide(color: c.accent, width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.accent,
        foregroundColor: c.onAccent,
        disabledBackgroundColor: disabledInk == null ? null : c.surface2,
        disabledForegroundColor: disabledInk,
        shape: pill,
        minimumSize: const Size(0, 48),
        textStyle: t(NgType.label.copyWith(fontSize: 15)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.text,
        disabledForegroundColor: disabledInk,
        side: BorderSide(color: c.strokeStrong),
        shape: pill,
        minimumSize: const Size(0, 44),
        textStyle: t(NgType.label),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.accentText,
        disabledForegroundColor: disabledInk,
        shape: pill,
        textStyle: t(NgType.label),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? Colors.white : c.text3,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.accent : c.surface3,
      ),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.sheet,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: c.sheet,
      showDragHandle: true,
      dragHandleColor: c.strokeStrong,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(NgRadii.xl)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.sheet,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NgRadii.lg),
      ),
      titleTextStyle: t(NgType.heading),
      contentTextStyle: t(NgType.bodySmall, c.text2),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: c.sidebar,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: c.sheet,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NgRadii.md),
        side: BorderSide(color: c.stroke),
      ),
      textStyle: t(NgType.bodySmall),
      labelTextStyle: disabledInk == null
          ? null
          : WidgetStateProperty.resolveWith(
              (states) => t(
                NgType.label,
                states.contains(WidgetState.disabled) ? disabledInk : c.text,
              ),
            ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.inverse,
      contentTextStyle: t(NgType.bodySmall, c.onInverse),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NgRadii.md),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: c.surface2,
      // Never pair the near-white dark-mode inverse surface with the default
      // light label. Selected chips use a tinted surface and explicit text.
      selectedColor: c.accentSoft,
      labelStyle: t(NgType.label, c.text),
      secondaryLabelStyle: t(NgType.label, c.text),
      checkmarkColor: c.text,
      side: BorderSide(color: c.stroke),
      shape: pill,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.accent,
      linearTrackColor: c.surface3,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: c.inverse,
        borderRadius: BorderRadius.circular(NgRadii.sm),
      ),
      textStyle: t(NgType.caption, c.onInverse),
    ),
  );
}
