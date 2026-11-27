import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UI colours come from active tokens, not fixed branding or brightness', () {
    // Palette seeds and semantic ramps belong in the single design-system root.
    const themeRoot = 'lib/core/theme/hermes_theme.dart';
    // NextGen's palette (Kyllene's tokens) is the second design-system root.
    const nextGenThemeRoot = 'lib/nextgen/theme/nextgen_theme.dart';
    const mediaViewer = 'lib/core/widgets/attachment_preview_dialog.dart';
    // Exact image-only cinema exceptions, not a blanket preview exemption.
    // Documents continue to use the active application's ColorScheme.
    const mediaExceptions = {
      'final foreground = image ? Colors.white : scheme.onSurface;',
      'backgroundColor: image ? Colors.black : scheme.surface,',
    };
    // Data colours with a documented reason, by exact file and line. Stale
    // entries fail below, so an exception cannot outlive its code.
    const dataExceptions = {
      'lib/nextgen/ui/brand.dart': {
        // Approved logo artwork and silver/graphite ink are invariant brand
        // data, not application surfaces. The surround uses active tokens.
        'const ngBrandSilver = [Color(0xFFFFFFFF), Color(0xFFC3C7CE)];',
        'const ngBrandGraphite = [Color(0xFF3A3D44), Color(0xFF7D828C)];',
        'color: Colors.white,',
        ': Border.all(color: const Color(0x2E0A0A1E), width: 1),',
        'color: Colors.black.withValues(alpha: 0.07),',
      },
      'lib/core/presentation/imported_theme.dart': {
        // The one constructor for an imported VS Code theme's own colours.
        'Color _imported(int argb) => Color(argb);',
      },
      'lib/core/presentation/petdex.dart': {
        // A hatchling's pixels: the user's picture reduced to a colour cube.
        'paint.color = Color.fromARGB(',
      },
      'lib/core/screens/profile_admin_panel.dart': {
        // A scannable QR code needs black modules on a white quiet zone.
        'canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);',
        '..color = Colors.black',
      },
      'lib/core/workspace/profile_presentation.dart': {
        // The user's own profile colours (#RRGGBB) and the black/white ink
        // that keeps text on them readable; not app branding.
        '? Color(0xff000000 | int.parse(s.substring(1), radix: 16))',
        'bg.computeLuminance() > 0.179 ? Colors.black : Colors.white;',
        'c.primary.computeLuminance() > 0.179 ? Colors.black : Colors.white,',
      },
    };
    final dataSeen = <String>{};
    final literalColor = RegExp(
      r'\b(?:Color|MaterialColor|MaterialAccentColor)\s*\('
      r'|\bColor\.(?:fromARGB|fromRGBO)\s*\('
      r'|\bColors\.(?!transparent\b)\w+'
      r'|#[0-9a-fA-F]{6}\b',
    );
    final packedColor = RegExp(r'\b0x[0-9a-fA-F]{8}\b');
    final bypassedTheme = RegExp(
      r'\bHermesTokens\.(?:hermesGold|dark|light|forBrightness)\b',
    );
    final violations = <String>[];
    final exceptionsSeen = <String, int>{};
    final sources =
        Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    expect(sources, isNotEmpty);
    for (final file in sources) {
      final path = file.path.replaceAll('\\', '/');
      if (path == themeRoot || path == nextGenThemeRoot) continue;
      // Integers in services also encode non-colour bitmasks and file headers.
      final presentation =
          path == 'lib/main.dart' ||
          path.contains('/screens/') ||
          path.contains('/widgets/');
      final lines = file.readAsLinesSync();
      for (var index = 0; index < lines.length; index++) {
        final line = lines[index].trim();
        if (line.startsWith('//')) continue;
        if (dataExceptions[path]?.contains(line) == true) {
          dataSeen.add('$path|$line');
          continue;
        }
        if (path == mediaViewer && mediaExceptions.contains(line)) {
          exceptionsSeen.update(line, (count) => count + 1, ifAbsent: () => 1);
          continue;
        }
        if (literalColor.hasMatch(line) ||
            bypassedTheme.hasMatch(line) ||
            (presentation && packedColor.hasMatch(line))) {
          violations.add('$path:${index + 1}: $line');
        }
      }
    }
    expect(
      violations,
      isEmpty,
      reason:
          'Use HermesTokens.of(context) or the active ColorScheme; '
          'keep media-only exceptions narrow and documented.\n${violations.join('\n')}',
    );
    expect(exceptionsSeen, {for (final line in mediaExceptions) line: 1});
    expect(dataSeen, {
      for (final entry in dataExceptions.entries)
        for (final line in entry.value) '${entry.key}|$line',
    });
  });
}
