import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/presentation/imported_palette.dart';
import 'package:hermes_android/core/presentation/imported_theme.dart';
import 'package:hermes_android/core/presentation/presentation_scope.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

// An imported theme drives the whole ThemeData in its own brightness: body
// text, list rows, the app bar, cards and inputs stay readable whatever the
// app's own brightness is (review probe A1).

const _oneDark = {
  'name': 'One Dark',
  'type': 'dark',
  'colors': {
    'editor.background': '#282c34',
    'editor.foreground': '#abb2bf',
    'button.background': '#4d78cc',
  },
};

const _paper = {
  'name': 'Paper',
  'type': 'light',
  'colors': {
    'editor.background': '#ffffff',
    'editor.foreground': '#1f1f1f',
    'button.background': '#005fb8',
  },
};

Color _textColor(WidgetTester tester, String text) =>
    tester.renderObject<RenderParagraph>(find.text(text)).text.style!.color!;

Color _material(WidgetTester tester, Type owner) => tester
    .widget<Material>(
      find
          .descendant(of: find.byType(owner), matching: find.byType(Material))
          .first,
    )
    .color!;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final layout in ['classic', 'nextgen']) {
    for (final app in Brightness.values) {
      for (final file in [_oneDark, _paper]) {
        final name = file['name'];
        testWidgets(
          '$name over a $layout ${app.name} app keeps text readable',
          (tester) async {
            SharedPreferences.setMockInitialValues({});
            final prefs = await SharedPreferences.getInstance();
            final theme = ImportedThemeParser.parse(
              'theme.json',
              utf8.encode(jsonEncode(file)),
            ).single;
            await ImportedThemeStore(prefs).save(theme);
            final typed = TextEditingController(text: 'Typed text');
            addTearDown(typed.dispose);
            await tester.pumpWidget(
              MaterialApp(
                theme: layout == 'classic'
                    ? hermesTheme(app)
                    : nextGenTheme(app, NextGenLook.instance),
                builder: (context, child) =>
                    PresentationRoot(preferences: prefs, child: child!),
                home: Scaffold(
                  appBar: AppBar(title: const Text('Title')),
                  body: ListView(
                    children: [
                      const ListTile(title: Text('Row title')),
                      const Text('Body text'),
                      const Card(child: Text('Card text')),
                      const Divider(),
                      TextField(controller: typed),
                    ],
                  ),
                ),
              ),
            );
            await tester.pump();

            final context = tester.element(find.text('Body text'));
            final painted = Theme.of(context);
            expect(painted.brightness, theme.brightness);
            final background = painted.scaffoldBackgroundColor;
            expect(background, theme[ImportedThemeColor.background]);
            final input = tester.widget<EditableText>(
              find.byType(EditableText),
            );
            final ratios = {
              'body/scaffold': contrastRatio(
                _textColor(tester, 'Body text'),
                background,
              ),
              'listTile/scaffold': contrastRatio(
                _textColor(tester, 'Row title'),
                background,
              ),
              'appBarTitle/appBar': contrastRatio(
                _textColor(tester, 'Title'),
                _material(tester, AppBar),
              ),
              'card/card': contrastRatio(
                _textColor(tester, 'Card text'),
                _material(tester, Card),
              ),
              'input/fill': contrastRatio(
                input.style.color!,
                Color.alphaBlend(
                  painted.inputDecorationTheme.fillColor!,
                  background,
                ),
              ),
            };
            if (layout == 'nextgen') {
              final ng = NgColors.of(context);
              ratios['ngText/ngBackground'] = contrastRatio(
                ng.text,
                ng.background,
              );
              ratios['ngText/ngSurface'] = contrastRatio(ng.text, ng.surface);
            }
            for (final entry in ratios.entries) {
              expect(
                entry.value,
                greaterThanOrEqualTo(4.5),
                reason: '${entry.key} ${entry.value.toStringAsFixed(2)}',
              );
            }
            // Dividers come from the import too, not the built-in palette.
            expect(
              painted.dividerTheme.color,
              theme[ImportedThemeColor.border],
            );
            expect(
              HermesTokens.of(context).surface,
              theme[ImportedThemeColor.background],
            );
            if (layout == 'nextgen') {
              expect(NgColors.of(context).background, background);
              expect(
                NgColors.of(context).stroke,
                theme[ImportedThemeColor.border],
              );
            }
          },
        );
      }
    }
  }

  test('a low-contrast import keeps its hue and still clears 4.5:1', () {
    final theme = ImportedThemeParser.parse(
      'murky.json',
      utf8.encode(
        jsonEncode({
          'name': 'Murky',
          'type': 'dark',
          'colors': {
            'editor.background': '#202020',
            'editor.foreground': '#505050',
            'descriptionForeground': '#383838',
          },
        }),
      ),
    ).single;
    for (final base in [
      hermesTheme(Brightness.light),
      nextGenTheme(Brightness.light, NextGenLook.instance),
    ]) {
      final painted = paintImportedTheme(base, theme);
      final scheme = painted.colorScheme;
      expect(
        contrastRatio(scheme.onSurface, scheme.surface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrastRatio(scheme.onSurfaceVariant, scheme.surface),
        greaterThanOrEqualTo(4.5),
      );
    }
  });
}
