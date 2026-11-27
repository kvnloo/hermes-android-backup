import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../nextgen/nextgen_preferences.dart';
import '../../nextgen/theme/nextgen_theme.dart';
import '../models/connection.dart';
import '../services/theme_preference.dart';
import '../theme/hermes_theme.dart';
import 'profile_presentation.dart';
import 'workspace_layout.dart';

typedef InstalledPresentation = ({
  String generation,
  ProfilePresentation style,
});

/// Same non-secret partition as the workspace. Preserve original shell keys.
String _digest(SavedConnection c, bool? nextGen) => sha256
    .convert(
      utf8.encode(
        jsonEncode([
          c.id,
          c.baseUrl,
          c.gatewayPrefix,
          c.desktopGatewayUrl,
          c.dashboardPort,
          c.dashboardPrefix,
          c.dashboardProxied,
          c.singleLogin,
          c.signInMethod,
          c.dashboardUsername,
          c.gatewayProfile,
          nextGen,
        ]),
      ),
    )
    .toString();

String workspaceLayoutKey(
  SavedConnection c,
  bool nextGen,
  InstalledPresentation? installed,
) =>
    'parallel.workspace.v1.${_digest(c, nextGen)}${installed?.style.geometry == null ? '' : '.${installed!.generation}'}';

class ProfilePresentationStore {
  ProfilePresentationStore(this.prefs);
  final SharedPreferences prefs;
  static final revision = ValueNotifier<int>(0);
  String _key(SavedConnection c) =>
      'profile.presentation.v1.${_digest(c, null)}';

  InstalledPresentation? read(SavedConnection c) {
    final raw = prefs.get(_key(c));
    if (raw is! String || raw.length > ProfilePresentation.sizeLimit) {
      return null;
    }
    try {
      final r = jsonDecode(raw);
      if (r is! Map ||
          r['generation'] is! String ||
          !Uuid.isValidUUID(fromString: r['generation'] as String)) {
        return null;
      }
      final style = ProfilePresentation.parse(r['desktop']);
      return style == null
          ? null
          : (generation: r['generation'] as String, style: style);
    } on FormatException {
      return null;
    }
  }

  /// A new local generation cannot reopen a tab/PTY of an earlier profile
  /// with a recycled name. Owner-specific history remains untouched.
  Future<void> apply(
    SavedConnection c,
    ProfilePresentation style,
    void Function() check,
  ) async {
    if (c.gatewayProfile?.isNotEmpty != true) {
      throw ArgumentError('Explicit profile required');
    }
    final raw = jsonEncode({
      'generation': const Uuid().v4(),
      'desktop': jsonDecode(style.encode()),
    });
    final key = _key(c), previous = prefs.get(key);
    check();
    try {
      if (!await prefs.setString(key, raw) || prefs.get(key) != raw) {
        throw StateError('Presentation not saved');
      }
    } catch (_) {
      if (prefs.get(key) == raw) {
        if (previous is String) {
          await prefs.setString(key, previous);
        } else {
          await prefs.remove(key);
        }
      }
      rethrow;
    }
    revision.value++;
    check();
  }

  ProfilePresentation snapshot(SavedConnection c, bool nextGen) {
    final installed = read(c);
    final raw = prefs.get(workspaceLayoutKey(c, nextGen, installed));
    final g = raw is String
        ? geometryOf(WorkspaceLayout.decode(raw))
        : installed?.style.geometry ?? geometryOf(WorkspaceLayout());
    final device = ThemePreferenceStore(prefs), ng = NextGenLook.instance;
    final palette = device.readPalette();
    final imported = installed?.style;
    ProfileColors colors(Brightness b) {
      final base = nextGen
          ? nextGenTheme(b, ng)
          : hermesTheme(b, palette: palette);
      final s = imported?.scheme(b) ?? base.colorScheme;
      return (
        background: s.surface,
        foreground: s.onSurface,
        primary: s.primary,
      );
    }

    return ProfilePresentation(
      skin: imported?.skin ?? 'ares-${nextGen ? ng.accent.name : palette.name}',
      mode: imported?.mode ?? (nextGen ? ng.themeMode : device.readMode()),
      light: imported?.light ?? colors(Brightness.light),
      dark: imported?.dark ?? colors(Brightness.dark),
      rail: imported?.rail,
      geometry: g,
    );
  }
}

/// The device settings remain defaults; an imported appearance never recolours
/// a different profile, the account selector, or the other interface globally.
class ProfileTheme extends StatefulWidget {
  const ProfileTheme({
    super.key,
    required this.connection,
    required this.nextGen,
    required this.child,
  });
  final SavedConnection connection;
  final bool nextGen;
  final Widget child;
  @override
  State<ProfileTheme> createState() => _ProfileThemeState();
}

class _ProfileThemeState extends State<ProfileTheme> {
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      if (mounted) setState(() => prefs = p);
    }, onError: (Object _) {});
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: ProfilePresentationStore.revision,
    child: widget.child,
    builder: (ctx, _, child) {
      final parent = Theme.of(ctx), p = prefs;
      final style = p == null
          ? null
          : ProfilePresentationStore(p).read(widget.connection)?.style;
      if (style?.skin == null && style?.mode == null) {
        return Theme(data: parent, child: child!);
      }
      final b = switch (style!.mode) {
        ThemeMode.system => MediaQuery.platformBrightnessOf(ctx),
        ThemeMode.dark => Brightness.dark,
        ThemeMode.light => Brightness.light,
        null => parent.brightness,
      };
      final s = style.scheme(b);
      final data = widget.nextGen
          ? nextGenTheme(b, NextGenLook.instance, profileScheme: s)
          : hermesTheme(
              b,
              palette: ThemePreferenceStore(p!).readPalette(),
              profileScheme: s,
            );
      return Theme(data: data, child: child!);
    },
  );
}
