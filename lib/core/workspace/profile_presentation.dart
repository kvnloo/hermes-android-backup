import 'dart:convert';

import 'package:flutter/material.dart';

import 'workspace_layout.dart';

/// Presentation is data, never a persisted WorkspaceLayout. In particular,
/// Desktop pane IDs can identify chats, plugins or processes on another host.
typedef WorkspaceGeometry = ({bool paired, bool stacked, int percent});

WorkspaceGeometry geometryOf(WorkspaceLayout layout) => (
  paired: layout.secondary != null,
  stacked: layout.stacked,
  percent: layout.percent,
);

const _single = (paired: false, stacked: false, percent: 50);

/// Three explicitly typed colour roles. No CSS, fonts, URLs or file paths.
typedef ProfileColors = ({Color background, Color foreground, Color primary});

String _hex(Color c) => '#${c.toARGB32().toRadixString(16).substring(2)}';
Color? profileColor(Object? s) =>
    s is String && RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(s)
    ? Color(0xff000000 | int.parse(s.substring(1), radix: 16))
    : null;

ProfileColors? _colors(Object? raw) {
  if (raw is! Map) return null;
  final bg = profileColor(raw['background']),
      fg = profileColor(raw['foreground']),
      p = profileColor(raw['primary']);
  if (bg == null || fg == null || p == null) return null;
  return (background: bg, foreground: fg, primary: p);
}

// Three display roles from the pinned Desktop/shared theme presets. Missing
// light variants are generated from the seed, not styled with remote CSS.
const _presets = {
  'nous': 'ffffff 1f2328 0053fd 0d1117 e6edf3 4a84fe',
  'github': 'ffffff 1f2328 196d31 0d1117 e6edf3 4f9e5e',
  'catppuccin': 'eff1f5 4c4f69 6d2ebf 1e1e2e cdd6f4 cba6f7',
  'everforest': 'fdf6e3 5c6a72 586b35 2d353b d3c6aa a7c080',
  'solarized': 'fdf6e3 1f1f1f 675e34 002b36 839496 6ea1c4',
  'nous-alt': 'f8faff 17171a 0053fd 0d2f86 ffe6cb ffe6cb',
  'classic': 'f5f5f5 2b2109 d89b04 1a1a2e fff8dc ffbf00',
  'midnight': '08081c ddd6ff ddd6ff',
  'ember': '160800 ffd8b0 ffd8b0',
  'mono': '0e0e0e eaeaea eaeaea',
  'cyberpunk': '000a00 00ff41 00ff41',
  'slate': '0d1117 c9d1d9 c9d1d9',
};

class ProfilePresentation {
  const ProfilePresentation({
    required this.skin,
    required this.mode,
    required this.light,
    required this.dark,
    this.rail,
    this.geometry,
  });
  final String? skin;
  final ThemeMode? mode;
  final ProfileColors? light, dark;
  final Color? rail;
  final WorkspaceGeometry? geometry;

  static const sizeLimit = 64 * 1024;
  static ProfilePresentation? parseText(String? text) {
    if (text == null || text.length > sizeLimit) return null;
    try {
      return parse(jsonDecode(text));
    } on FormatException {
      return null;
    }
  }

  static ProfilePresentation? parse(Object? raw) {
    if (raw is! Map || raw['version'] != 1) return null;
    final id = raw['skin'];
    String? skin;
    ProfileColors? light, dark;
    if (id is String && RegExp(r'^[a-zA-Z0-9_-]{1,64}$').hasMatch(id)) {
      final preset = _presets[id];
      if (preset != null) {
        final c = preset.split(' ').map((s) => profileColor('#$s')!).toList();
        ProfileColors at(int i) =>
            (background: c[i], foreground: c[i + 1], primary: c[i + 2]);
        light = at(0);
        dark = c.length == 6 ? at(3) : light;
      } else if (raw['themes'] case final Map themes) {
        final def = themes[id];
        if (def is Map && def['name'] == id) {
          light = _colors(def['colors']);
          dark = _colors(def['darkColors']) ?? light;
        }
      }
      if (light != null) skin = id;
    }
    final mode = ThemeMode.values
        .where((m) => m.name == raw['mode'])
        .firstOrNull;
    final rail = profileColor(raw['profileColor']);
    final geometry = _geometry(raw['layoutTree']);
    if (mode == null && skin == null && rail == null && geometry == null) {
      return null;
    }
    return ProfilePresentation(
      skin: skin,
      light: light,
      dark: dark,
      mode: mode,
      rail: rail,
      geometry: geometry,
    );
  }

  static WorkspaceGeometry? _geometry(Object? tree) {
    // Accept bounded, well-formed trees. Project the outer split onto the
    // shell's two slots. Never resolve ANY ID or activate a contribution.
    var nodes = 0;
    bool valid(Object? n, int depth) {
      if (++nodes > 128 || depth > 12 || n is! Map || n['id'] is! String) {
        return false;
      }
      if (n['type'] == 'group') {
        final panes = n['panes'];
        return panes is List &&
            panes.isNotEmpty &&
            panes.length <= 64 &&
            panes.every((p) => p is String) &&
            panes.contains(n['active']);
      }
      final children = n['children'], weights = n['weights'];
      return n['type'] == 'split' &&
          const {'row', 'column'}.contains(n['orientation']) &&
          children is List &&
          children.length >= 2 &&
          children.length <= 32 &&
          weights is List &&
          weights.length == children.length &&
          weights.every((w) => w is num && w.isFinite && w > 0 && w <= 1e9) &&
          children.every((c) => valid(c, depth + 1));
    }

    if (!valid(tree, 0) || tree is! Map) return null;
    if (tree['type'] == 'group') return _single;
    final weights = (tree['weights'] as List).cast<num>();
    final pct = weights.first / weights.fold<double>(0, (a, b) => a + b) * 100;
    return (
      paired: true,
      stacked: tree['orientation'] == 'column',
      percent: pct < 45
          ? 40
          : pct > 55
          ? 60
          : 50,
    );
  }

  ProfilePresentation withGeometry(WorkspaceGeometry g) => ProfilePresentation(
    skin: skin,
    mode: mode,
    light: light,
    dark: dark,
    rail: rail,
    geometry: g,
  );

  ColorScheme? scheme(Brightness brightness) {
    final c = brightness == Brightness.dark ? dark : light;
    if (c == null) return null;
    final generated = ColorScheme.fromSeed(
      seedColor: c.primary,
      brightness: brightness,
    );
    final matches =
        ThemeData.estimateBrightnessForColor(c.background) == brightness;
    if (!matches) return generated;
    Color ink(Color bg) =>
        bg.computeLuminance() > 0.179 ? Colors.black : Colors.white;
    final contrast =
        (c.background.computeLuminance() + 0.05) /
        (c.foreground.computeLuminance() + 0.05);
    return generated.copyWith(
      surface: c.background,
      onSurface: contrast >= 4.5 || contrast <= 1 / 4.5
          ? c.foreground
          : ink(c.background),
      primary: c.primary,
      onPrimary: ink(c.primary),
    );
  }

  String encode() {
    Map<String, Object?> group(String pane) => {
      'type': 'group',
      'id': 'group-$pane',
      'panes': [pane],
      'active': pane,
    };
    Map<String, String> palette(ProfileColors c) {
      final s = ColorScheme.fromSeed(
        seedColor: c.primary,
        brightness: ThemeData.estimateBrightnessForColor(c.background),
      );
      return {
        'background': _hex(c.background),
        'foreground': _hex(c.foreground),
        'primary': _hex(c.primary),
        'primaryForeground': _hex(
          c.primary.computeLuminance() > 0.179 ? Colors.black : Colors.white,
        ),
        'card': _hex(s.surfaceContainerLow),
        'cardForeground': _hex(s.onSurface),
        'muted': _hex(s.surfaceContainer),
        'mutedForeground': _hex(s.onSurfaceVariant),
        'popover': _hex(s.surfaceContainerHigh),
        'popoverForeground': _hex(s.onSurface),
        'secondary': _hex(s.secondaryContainer),
        'secondaryForeground': _hex(s.onSecondaryContainer),
        'accent': _hex(s.primaryContainer),
        'accentForeground': _hex(s.onPrimaryContainer),
        'border': _hex(s.outlineVariant),
        'input': _hex(s.surfaceContainerLow),
        'ring': _hex(c.primary),
        'destructive': _hex(s.error),
        'destructiveForeground': _hex(s.onError),
      };
    }

    final g = geometry;
    return jsonEncode({
      'version': 1,
      'skin': ?skin,
      'mode': ?mode?.name,
      if (rail != null) 'profileColor': _hex(rail!),
      if (skin != null && !_presets.containsKey(skin) && light != null)
        'themes': {
          skin: {
            'name': skin,
            'label': skin,
            'colors': palette(light!),
            if (dark != null) 'darkColors': palette(dark!),
          },
        },
      if (g != null)
        'layoutTree': g.paired
            ? {
                'type': 'split',
                'id': 'split',
                'orientation': g.stacked ? 'column' : 'row',
                'weights': [g.percent, 100 - g.percent],
                'children': [group('workspace'), group('sessions')],
              }
            : group('workspace'),
    });
  }
}
