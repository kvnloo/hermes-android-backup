// Imported VS Code themes keep every kind of text readable on every surface
// it is drawn on, in both layouts and both app brightness modes (re-check
// probe R2). Solarized Light fills NextGen inputs and the composer with its
// own `input.background`, which the first fix never measured.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/l10n/l10n.dart';
import 'package:hermes_android/core/presentation/imported_palette.dart';
import 'package:hermes_android/core/presentation/imported_theme.dart';
import 'package:hermes_android/core/presentation/presentation_scope.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/workspace/popout_bootstrap.dart';
import 'package:hermes_android/core/workspace/popout_protocol.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

// ------------------------------------------------------------------ themes --

const _oneDark = {
  'name': 'One Dark',
  'type': 'dark',
  'colors': {
    'editor.background': '#282c34',
    'editor.foreground': '#abb2bf',
    'button.background': '#404754',
    'focusBorder': '#3e4452',
    'editorWidget.background': '#21252b',
    'sideBarSectionHeader.background': '#282c34',
    'sideBar.background': '#21252b',
    'panel.border': '#3e4452',
    'input.background': '#1d1f23',
    'descriptionForeground': '#7f848e',
    'errorForeground': '#c24038',
  },
};

// Its body text is only ~4.1:1 on its own background and 3.8:1 on its
// input fill; its description text is far lower.
const _solarizedLight = {
  'name': 'Solarized Light',
  'type': 'light',
  'colors': {
    'editor.background': '#fdf6e3',
    'editor.foreground': '#657b83',
    'button.background': '#ac9d57',
    'editorWidget.background': '#eee8d5',
    'sideBarSectionHeader.background': '#eee8d5',
    'sideBar.background': '#eee8d5',
    'panel.border': '#ddd6c1',
    'input.background': '#ddd6c1',
    'descriptionForeground': '#93a1a1',
    'errorForeground': '#dc322f',
  },
};

// GitHub Light Default's workbench roles.
const _gitHubLight = {
  'name': 'GitHub Light',
  'type': 'light',
  'colors': {
    'editor.background': '#ffffff',
    'editor.foreground': '#1f2328',
    'button.background': '#1f883d',
    'focusBorder': '#0969da',
    'editorWidget.background': '#f6f8fa',
    'sideBarSectionHeader.background': '#f6f8fa',
    'sideBar.background': '#f6f8fa',
    'panel.border': '#d0d7de',
    'input.background': '#ffffff',
    'descriptionForeground': '#656d76',
    'errorForeground': '#d1242f',
  },
};

const _themes = [_oneDark, _solarizedLight, _gitHubLight];

ImportedTheme _parse(Map<String, Object> file) => ImportedThemeParser.parse(
  'theme.json',
  utf8.encode(jsonEncode(file)),
).single;

Future<ImportedTheme> _saveImport(
  SharedPreferences prefs,
  Map<String, Object> file,
) async {
  final theme = _parse(file);
  await ImportedThemeStore(prefs).save(theme);
  return theme;
}

ThemeData _base(String layout, Brightness app) => layout == 'classic'
    ? hermesTheme(app)
    : nextGenTheme(app, NextGenLook.instance);

// ------------------------------------------------------------- measuring --

Finder _rich(String needle) => find.byWidgetPredicate(
  (w) => w is RichText && w.text.toPlainText().contains(needle),
);

Element _textElement(String needle) {
  final rich = _rich(needle).evaluate();
  if (rich.isNotEmpty) return rich.last;
  final any = find.textContaining(needle, findRichText: true).evaluate();
  expect(any, isNotEmpty, reason: 'text "$needle" not found');
  return any.last;
}

/// The colour [needle] is painted in, following inherited span styles.
/// Selectable transcript rows are read-only EditableTexts.
Color _inkOf(String needle) {
  final element = _textElement(needle);
  RenderParagraph? paragraph;
  EditableText? editable;
  void visit(Element e) {
    if (paragraph != null || editable != null) return;
    final w = e.widget;
    if (w is RichText) {
      paragraph = e.renderObject as RenderParagraph;
      return;
    }
    if (w is EditableText) {
      editable = w;
      return;
    }
    e.visitChildren(visit);
  }

  visit(element);
  if (editable != null) return editable!.style.color!;
  expect(paragraph, isNotNull, reason: 'no paragraph for "$needle"');
  Color? found;
  void walk(InlineSpan span, TextStyle? inherited) {
    if (found != null) return;
    final style = inherited == null
        ? span.style
        : (span.style == null ? inherited : inherited.merge(span.style));
    if (span is TextSpan) {
      if ((span.text ?? '').contains(needle)) {
        found = style?.color;
        return;
      }
      for (final child in span.children ?? const <InlineSpan>[]) {
        walk(child, style);
      }
    }
  }

  walk(paragraph!.text, null);
  found ??= paragraph!.text.style?.color;
  expect(found, isNotNull, reason: 'no colour for "$needle"');
  return found!;
}

Color? _decorationColor(Decoration? d) => switch (d) {
  BoxDecoration(:final color) => color,
  ShapeDecoration(:final color) => color,
  _ => null,
};

/// The opaque colour actually behind [element]: every coloured ancestor up
/// to the nearest Scaffold (or the root), composited outermost first.
Color _behindElement(Element element) {
  final layers = <Color>[];
  Color? base;
  element.visitAncestorElements((ancestor) {
    final w = ancestor.widget;
    Color? c;
    if (w is Scaffold) {
      base = w.backgroundColor ?? Theme.of(ancestor).scaffoldBackgroundColor;
      return false;
    }
    if (w is Material && w.type != MaterialType.transparency) {
      c =
          w.color ??
          (w.type == MaterialType.canvas
              ? Theme.of(ancestor).canvasColor
              : w.type == MaterialType.card
              ? Theme.of(ancestor).cardColor
              : null);
    } else if (w is ColoredBox) {
      c = w.color;
    } else if (w is Container) {
      c = w.color ?? _decorationColor(w.decoration);
    } else if (w is DecoratedBox &&
        w.position == DecorationPosition.background) {
      c = _decorationColor(w.decoration);
    } else if (w is Ink) {
      c = _decorationColor(w.decoration);
    } else if (w is InputDecorator) {
      final themed = Theme.of(ancestor).inputDecorationTheme;
      if (w.decoration.filled ?? themed.filled) {
        c = w.decoration.fillColor ?? themed.fillColor;
      }
    }
    if (c != null && c.a > 0) layers.add(c);
    return true;
  });
  var painted = base ?? const Color(0xFFFFFFFF);
  for (final c in layers.reversed) {
    painted = Color.alphaBlend(c, painted);
  }
  return painted;
}

double _measure(String needle) =>
    contrastRatio(_inkOf(needle), _behindElement(_textElement(needle)));

// ------------------------------------------------------------- network ---

class _Refusing implements HttpClient {
  _Refusing(this.log);
  final List<String> log;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isSetter || invocation.isGetter) return null;
    if (invocation.memberName == #close) return null;
    log.add('${invocation.memberName} ${invocation.positionalArguments}');
    throw const SocketException('Network access is not allowed here.');
  }
}

class _NoNetwork extends HttpOverrides {
  final log = <String>[];
  @override
  HttpClient createHttpClient(SecurityContext? context) => _Refusing(log);
}

_NoNetwork _forbidNetwork() {
  final guard = _NoNetwork();
  final previous = HttpOverrides.current;
  HttpOverrides.global = guard;
  addTearDown(() => HttpOverrides.global = previous);
  return guard;
}

// ------------------------------------------------------------- fixtures --

NextGenGateway _gateway() => NextGenGateway(
  SavedConnection(
    id: 'c1',
    label: 'Home',
    host: '10.0.0.5',
    port: 9119,
    apiKey: 'k',
    desktopGatewayUrl: 'http://10.0.0.5:9119',
    singleLogin: true,
    signInMethod: 'none',
  ),
);

class _History extends http.BaseClient {
  _History(this.rows);
  final List<Map<String, dynamic>> rows;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.method == 'GET' && request.url.path.endsWith('/messages')) {
      return http.StreamedResponse(
        Stream.value(utf8.encode(jsonEncode({'data': rows}))),
        200,
        headers: {'content-type': 'application/json'},
      );
    }
    return http.StreamedResponse(Stream.value(utf8.encode('{}')), 404);
  }
}

/// Every surface the app draws text on, each carrying body, secondary,
/// hint and disabled text.
class _Surfaces extends StatelessWidget {
  const _Surfaces({
    required this.scaffold,
    required this.tooltip,
    required this.typed,
  });

  final GlobalKey<ScaffoldState> scaffold;
  final GlobalKey<TooltipState> tooltip;
  final TextEditingController typed;

  @override
  Widget build(BuildContext context) {
    TextStyle? secondary(BuildContext c) => Theme.of(c).textTheme.bodySmall;
    return Scaffold(
      key: scaffold,
      appBar: AppBar(title: const Text('Bar title')),
      drawer: Drawer(
        child: Builder(
          builder: (c) => ListView(
            children: [
              const ListTile(
                title: Text('Sidebar body'),
                subtitle: Text('Sidebar secondary'),
              ),
              const ListTile(
                selected: true,
                title: Text('Sidebar selected'),
                subtitle: Text('Sidebar selected secondary'),
              ),
              const ListTile(enabled: false, title: Text('Sidebar disabled')),
              const TextField(
                decoration: InputDecoration(hintText: 'Sidebar hint'),
              ),
              // NextGen's chat list marks the open chat with surface2.
              if (Theme.of(c).extension<NgColors>() case final ng?)
                Material(
                  color: ng.surface2,
                  child: Column(
                    children: [
                      Text('Row open', style: TextStyle(color: ng.text)),
                      Text(
                        'Row open detail',
                        style: TextStyle(color: ng.text3),
                      ),
                      Text(
                        'Row open time',
                        style: TextStyle(color: ng.textMuted),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      // Everything built at once, so each sample can be found and measured.
      body: Builder(
        builder: (c) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Page body'),
            Text('Page secondary', style: secondary(c)),
            const ListTile(
              title: Text('Row title'),
              subtitle: Text('Row subtitle'),
            ),
            const ListTile(
              selected: true,
              title: Text('Selected title'),
              subtitle: Text('Selected subtitle'),
            ),
            const ListTile(enabled: false, title: Text('Disabled row')),
            const TextButton(onPressed: null, child: Text('Disabled button')),
            const OutlinedButton(
              onPressed: null,
              child: Text('Disabled outline'),
            ),
            const FilledButton(onPressed: null, child: Text('Disabled filled')),
            TextButton(onPressed: () {}, child: const Text('Link button')),
            Card(
              child: Column(
                children: [
                  const Text('Card body'),
                  Text('Card secondary', style: secondary(c)),
                ],
              ),
            ),
            TextField(
              controller: typed,
              decoration: const InputDecoration(
                labelText: 'Field label',
                helperText: 'Helper text',
              ),
            ),
            const TextField(decoration: InputDecoration(hintText: 'Hint text')),
            const TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Disabled label',
                hintText: 'Disabled hint',
              ),
            ),
            Wrap(
              children: [
                const Chip(label: Text('Chip label')),
                ChoiceChip(
                  label: const Text('Chip selected'),
                  selected: true,
                  onSelected: (_) {},
                ),
                ChoiceChip(
                  label: const Text('Chip open'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            PopupMenuButton<int>(
              itemBuilder: (_) => const [
                PopupMenuItem(value: 1, child: Text('Menu item')),
                PopupMenuItem(
                  value: 2,
                  enabled: false,
                  child: Text('Menu disabled'),
                ),
              ],
              child: const Text('Open menu'),
            ),
            Tooltip(
              key: tooltip,
              message: 'Tooltip text',
              child: const Text('Has tooltip'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Map<String, double>> _measureSurfaces(
  WidgetTester tester,
  GlobalKey<ScaffoldState> scaffold,
  GlobalKey<TooltipState> tooltip,
) async {
  final r = <String, double>{};
  void take(List<String> needles) {
    for (final n in needles) {
      r[n] = _measure(n);
    }
  }

  // Page, cards, inputs, chips, selected and disabled rows and buttons.
  take([
    'Bar title',
    'Page body',
    'Page secondary',
    'Row title',
    'Row subtitle',
    'Selected title',
    'Selected subtitle',
    'Disabled row',
    'Disabled button',
    'Disabled outline',
    'Disabled filled',
    'Link button',
    'Card body',
    'Card secondary',
    'Field label',
    'Helper text',
    'Hint text',
    'Disabled label',
    'Chip label',
    'Chip selected',
    'Chip open',
  ]);
  final typed = find.byWidgetPredicate(
    (w) => w is EditableText && w.controller.text == 'Typed text',
  );
  r['Typed text'] = contrastRatio(
    tester.widget<EditableText>(typed).style.color!,
    _behindElement(tester.element(typed)),
  );

  // Sidebar.
  scaffold.currentState!.openDrawer();
  await tester.pumpAndSettle();
  take([
    'Sidebar body',
    'Sidebar secondary',
    'Sidebar selected',
    'Sidebar selected secondary',
    'Sidebar disabled',
    'Sidebar hint',
  ]);
  if (find.text('Row open').evaluate().isNotEmpty) {
    take(['Row open', 'Row open detail', 'Row open time']);
  }
  scaffold.currentState!.closeDrawer();
  await tester.pumpAndSettle();

  // Menu.
  await tester.tap(find.text('Open menu'));
  await tester.pumpAndSettle();
  take(['Menu item', 'Menu disabled']);
  await tester.tapAt(const Offset(4, 4));
  await tester.pumpAndSettle();

  // Dialog.
  final context = tester.element(find.text('Page body'));
  unawaited(
    showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Dialog title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Dialog body'),
            Text('Dialog secondary', style: Theme.of(c).textTheme.bodySmall),
            const TextField(
              decoration: InputDecoration(hintText: 'Dialog hint'),
            ),
          ],
        ),
        actions: [
          const TextButton(onPressed: null, child: Text('Dialog disabled')),
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Dialog action'),
          ),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();
  take([
    'Dialog title',
    'Dialog body',
    'Dialog secondary',
    'Dialog hint',
    'Dialog disabled',
    'Dialog action',
  ]);
  await tester.tap(find.text('Dialog action'));
  await tester.pumpAndSettle();

  // Snack bar.
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Snack body'),
      action: SnackBarAction(label: 'Snack action', onPressed: () {}),
    ),
  );
  await tester.pumpAndSettle();
  take(['Snack body', 'Snack action']);
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  await tester.pumpAndSettle();

  // Tooltip.
  tooltip.currentState!.ensureTooltipVisible();
  await tester.pumpAndSettle();
  take(['Tooltip text']);
  return r;
}

void _expectReadable(Map<String, double> ratios, String label) {
  final low = {
    for (final e in ratios.entries)
      if (e.value < 4.5) e.key: e.value.toStringAsFixed(2),
  };
  expect(low, isEmpty, reason: '$label: below 4.5:1');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => HermesSignInVault.resetForTesting(MemorySignInSecretStore()));

  group('theme roles', () {
    for (final layout in ['classic', 'nextgen']) {
      for (final app in Brightness.values) {
        for (final file in _themes) {
          test('${file['name']} over $layout ${app.name}: every text role '
              'clears 4.5:1 on every surface', () {
            final imported = _parse(file);
            final theme = paintImportedTheme(_base(layout, app), imported);
            expect(theme.brightness, imported.brightness);
            final s = theme.colorScheme;
            final tokens = theme.extension<HermesTokens>()!;
            final ng = theme.extension<NgColors>();
            Color over(Color tint, Color surface) =>
                Color.alphaBlend(tint, surface);
            final surfaces = <String, Color>{
              'scaffold': theme.scaffoldBackgroundColor,
              'canvas': theme.canvasColor,
              'card': theme.cardTheme.color!,
              'input': Color.alphaBlend(
                theme.inputDecorationTheme.fillColor!,
                theme.scaffoldBackgroundColor,
              ),
              'drawer': theme.drawerTheme.backgroundColor!,
              'menu': theme.popupMenuTheme.color!,
              'dialog': theme.dialogTheme.backgroundColor!,
              'sheet': theme.bottomSheetTheme.backgroundColor!,
              'chip': theme.chipTheme.backgroundColor!,
              'chip.selected': over(
                theme.chipTheme.selectedColor!,
                theme.canvasColor,
              ),
              'primaryContainer': s.primaryContainer,
              'errorContainer': s.errorContainer,
              'surfaceContainerLow': s.surfaceContainerLow,
              'surfaceContainer': s.surfaceContainer,
              'surfaceContainerHigh': s.surfaceContainerHigh,
              'surfaceContainerHighest': s.surfaceContainerHighest,
              'tokens.raised': tokens.raised,
              'row.selected': ?theme.listTileTheme.selectedTileColor,
              if (ng != null) ...{
                'ng.background': ng.background,
                'ng.surface': ng.surface,
                'ng.surface2': ng.surface2,
                'ng.surface3': ng.surface3,
                'ng.well': ng.well,
                'ng.thumb': ng.thumb,
                'ng.sheet': ng.sheet,
                'ng.input': ng.input,
                'ng.sidebar': ng.sidebar,
                'ng.sidebar.selected': ng.surface2,
                'ng.accentSoft/background': over(ng.accentSoft, ng.background),
                'ng.accentSoft/sheet': over(ng.accentSoft, ng.sheet),
                'ng.accentSoft/sidebar': over(ng.accentSoft, ng.sidebar),
                'ng.dangerSoft/background': over(ng.dangerSoft, ng.background),
              },
            };
            final inks = <String, Color>{
              'body': theme.textTheme.bodyLarge!.color!,
              'body.medium': theme.textTheme.bodyMedium!.color!,
              'secondary': theme.textTheme.bodySmall!.color!,
              'onSurfaceVariant': s.onSurfaceVariant,
              'hint': theme.inputDecorationTheme.hintStyle!.color!,
              'label': theme.inputDecorationTheme.labelStyle!.color!,
              'disabled': theme.disabledColor,
              'accent': s.primary,
              if (ng != null) ...{
                'ng.text': ng.text,
                'ng.text2': ng.text2,
                'ng.text3': ng.text3,
                'ng.textMuted': ng.textMuted,
                'ng.accentText': ng.accentText,
              },
            };
            // Status inks keep their hue and read wherever text does, and
            // on their own badge wash over each opaque surface.
            final status = <String, (Color, Color)>{
              'error': (s.error, s.error.withValues(alpha: 0.16)),
              'errorStyle': (
                theme.inputDecorationTheme.errorStyle?.color ?? s.error,
                s.error.withValues(alpha: 0.16),
              ),
              for (final (name, ink) in [
                ('tokens.danger', tokens.danger),
                ('tokens.success', tokens.success),
                ('tokens.warning', tokens.warning),
                ('tokens.running', tokens.running),
                ('tokens.blocked', tokens.blocked),
              ])
                name: (ink, ink.withValues(alpha: 0.16)),
              if (ng != null) ...{
                'ng.danger': (ng.danger, ng.dangerSoft),
                'ng.success': (ng.success, ng.successSoft),
                'ng.warning': (ng.warning, ng.warningSoft),
              },
            };
            // Badges sit on the plain surfaces, not on a selection or
            // error tint.
            const tints = {
              'chip.selected',
              'primaryContainer',
              'errorContainer',
              'row.selected',
            };
            final opaque = {
              for (final e in surfaces.entries)
                if (e.value.a == 1 &&
                    !tints.contains(e.key) &&
                    !e.key.contains('Soft/'))
                  e.key: e.value,
            };
            final ratios = <String, double>{
              for (final ink in {
                ...inks,
                for (final e in status.entries) e.key: e.value.$1,
              }.entries)
                for (final surface in surfaces.entries)
                  '${ink.key} on ${surface.key}': contrastRatio(
                    ink.value,
                    // Translucent washes sit on the page.
                    Color.alphaBlend(
                      surface.value,
                      theme.scaffoldBackgroundColor,
                    ),
                  ),
              for (final ink in status.entries)
                for (final surface in opaque.entries)
                  '${ink.key} badge on ${surface.key}': contrastRatio(
                    ink.value.$1,
                    over(ink.value.$2, surface.value),
                  ),
              // Inverted chrome: snack bars and tooltips.
              'snack': contrastRatio(
                theme.snackBarTheme.contentTextStyle!.color!,
                theme.snackBarTheme.backgroundColor!,
              ),
              'tooltip': contrastRatio(
                theme.tooltipTheme.textStyle!.color!,
                (theme.tooltipTheme.decoration! as BoxDecoration).color!,
              ),
              'onPrimary': contrastRatio(s.onPrimary, s.primary),
              'onInverseSurface': contrastRatio(
                s.onInverseSurface,
                s.inverseSurface,
              ),
              if (ng != null) ...{
                'ng.onUserBubble': contrastRatio(
                  ng.onUserBubble,
                  ng.userBubble,
                ),
                'ng.onAccent': contrastRatio(ng.onAccent, ng.accent),
                'ng.onInverse': contrastRatio(ng.onInverse, ng.inverse),
              },
            };
            _expectReadable(ratios, '${file['name']} $layout ${app.name}');
          });
        }
      }
    }

    test('a surface of the opposite brightness is brought into range', () {
      // A light theme whose only side-bar colour is a dark activity bar.
      final imported = _parse({
        'name': 'Dark rail',
        'type': 'light',
        'colors': {
          'editor.background': '#ffffff',
          'editor.foreground': '#333333',
          'activityBar.background': '#2c2c2c',
          'input.background': '#3c3c3c',
        },
      });
      for (final layout in ['classic', 'nextgen']) {
        final theme = paintImportedTheme(
          _base(layout, Brightness.dark),
          imported,
        );
        final ng = theme.extension<NgColors>();
        final fill = Color.alphaBlend(
          theme.inputDecorationTheme.fillColor!,
          theme.scaffoldBackgroundColor,
        );
        for (final ink in [
          theme.colorScheme.onSurface,
          theme.colorScheme.onSurfaceVariant,
          theme.inputDecorationTheme.hintStyle!.color!,
        ]) {
          expect(contrastRatio(ink, fill), greaterThanOrEqualTo(4.5));
          if (ng != null) {
            expect(contrastRatio(ink, ng.sidebar), greaterThanOrEqualTo(4.5));
            expect(contrastRatio(ink, ng.input), greaterThanOrEqualTo(4.5));
          }
        }
      }
    });
  });

  group('painted widgets', () {
    for (final layout in ['classic', 'nextgen']) {
      for (final app in Brightness.values) {
        for (final file in _themes) {
          testWidgets(
            '${file['name']} over $layout ${app.name}: page, card, input, '
            'sidebar, chips, menu, dialog, snack bar and tooltip',
            (tester) async {
              SharedPreferences.setMockInitialValues({});
              final prefs = await SharedPreferences.getInstance();
              final imported = await _saveImport(prefs, file);
              final scaffold = GlobalKey<ScaffoldState>();
              final tooltip = GlobalKey<TooltipState>();
              final typed = TextEditingController(text: 'Typed text');
              addTearDown(typed.dispose);
              tester.view.physicalSize = const Size(900, 2000);
              tester.view.devicePixelRatio = 1;
              addTearDown(tester.view.reset);
              await tester.pumpWidget(
                MaterialApp(
                  theme: _base(layout, app),
                  builder: (context, child) =>
                      PresentationRoot(preferences: prefs, child: child!),
                  home: _Surfaces(
                    scaffold: scaffold,
                    tooltip: tooltip,
                    typed: typed,
                  ),
                ),
              );
              await tester.pump();
              expect(
                Theme.of(tester.element(find.text('Page body'))).brightness,
                imported.brightness,
              );
              final ratios = await _measureSurfaces(tester, scaffold, tooltip);
              _expectReadable(ratios, '${file['name']} $layout ${app.name}');
              await tester.pumpWidget(const SizedBox());
            },
          );
        }
      }
    }
  });

  group('real chat views', () {
    for (final app in Brightness.values) {
      for (final file in _themes) {
        testWidgets('NextGen composer and transcript: ${file['name']} over '
            '${app.name}', (tester) async {
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();
          final imported = await _saveImport(prefs, file);
          final gateway = _gateway();
          final chat = NgChatController(gateway, sessionId: 's')
            ..runtimeId = 'runtime-s'
            ..debugApplyHistory([
              {'role': 'user', 'content': 'User words'},
              {'role': 'assistant', 'content': 'Assistant words'},
            ]);
          addTearDown(() {
            chat.dispose();
            gateway.dispose();
          });
          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: _base('nextgen', app),
              builder: (context, child) =>
                  PresentationRoot(preferences: prefs, child: child!),
              home: NgScope(
                connManager: ConnectionManager(prefs),
                gateway: gateway,
                connections: [gateway.connection],
                switchTo: (_) async {},
                addGateway: () async {},
                signOut: (_) async {},
                reload: () async {},
                signInAgain: () async {},
                child: Scaffold(
                  body: NgChatView(
                    key: ObjectKey(chat),
                    chat: chat,
                    onOpenSidebar: () {},
                    onNewChat: () {},
                  ),
                ),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 300));
          expect(
            Theme.of(tester.element(find.byType(NgChatView))).brightness,
            imported.brightness,
          );
          final ratios = await _composerRatios(
            tester,
            find.byKey(const ValueKey('ng-composer-field')),
          );
          ratios['user'] = _measure('User words');
          ratios['assistant'] = _measure('Assistant words');
          _expectReadable(ratios, 'NextGen ${file['name']} ${app.name}');
          await tester.pumpWidget(const SizedBox());
        });

        testWidgets('Classic composer and transcript: ${file['name']} over '
            '${app.name}', (tester) async {
          mockChatImageRecovery();
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();
          final imported = await _saveImport(prefs, file);
          final rows = [
            {'id': '1', 'role': 'user', 'content': 'User words'},
            {
              'id': '2',
              'role': 'assistant',
              'content': 'Assistant words',
              'completed': true,
            },
          ];
          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: preferredSupportedLocales(),
              localeListResolutionCallback: resolvePreferredLocale,
              theme: _base('classic', app),
              builder: (context, child) =>
                  PresentationRoot(preferences: prefs, child: child!),
              home: ChatScreen(
                connection: SavedConnection(
                  id: 'home',
                  label: 'Fixture',
                  host: 'contrast.fixture',
                  port: 8642,
                  apiKey: 'k',
                ),
                session: Session(
                  id: 'contrast',
                  title: 'Fixture',
                  model: 'fixture-model',
                  source: 'api_server',
                  messageCount: rows.length,
                  isActive: false,
                  preview: '',
                  startedAt: 1,
                ),
                testApiClient: ApiClient(
                  baseUrl: 'http://contrast.fixture',
                  apiKey: 'k',
                  httpClient: _History(rows),
                ),
                testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
              ),
            ),
          );
          await pumpChatUpdates(tester);
          expect(
            Theme.of(tester.element(find.byType(ChatScreen))).brightness,
            imported.brightness,
          );
          final ratios = await _composerRatios(
            tester,
            find
                .descendant(
                  of: find.byType(ChatScreen),
                  matching: find.byWidgetPredicate(
                    (w) => w is TextField && w.readOnly == false,
                  ),
                )
                .last,
          );
          ratios['user'] = _measure('User words');
          _expectReadable(ratios, 'Classic ${file['name']} ${app.name}');
          await tester.pumpWidget(const SizedBox());
        });
      }
    }

    for (final file in [_solarizedLight, _gitHubLight, _oneDark]) {
      testWidgets('NextGen pop-out window: ${file['name']}', (tester) async {
        SharedPreferences.setMockInitialValues({});
        final main = await SharedPreferences.getInstance();
        final imported = await _saveImport(main, file);
        final connection = SavedConnection(
          id: 'home',
          label: 'Fixture',
          host: '10.0.0.5',
          port: 9119,
          apiKey: '',
          desktopGatewayUrl: 'http://10.0.0.5:9119',
          singleLogin: true,
          signInMethod: 'none',
        );
        // The main window's preferences, filtered the way a pop-out copies
        // them.
        final copied = popoutPreferences(
          {
            'flutter.saved_connections': <String>[
              jsonEncode(connection.toMap()..remove('api_key')),
            ],
            'flutter.${ImportedThemeStore.preferenceKey}': main.getString(
              ImportedThemeStore.preferenceKey,
            )!,
          },
          PopoutTarget(
            connectionId: 'home',
            sessionId: 's1',
            profile: '',
            nextGen: true,
          ),
        );
        expect(
          copied.keys,
          contains('flutter.${ImportedThemeStore.preferenceKey}'),
        );
        SharedPreferences.setMockInitialValues(copied);
        final child = await SharedPreferences.getInstance();
        final network = _forbidNetwork();
        final gateway = NextGenGateway(connection);
        await tester.pumpWidget(
          PopoutChatApp(
            manager: ConnectionManager(child),
            connection: connection,
            session: Session(
              id: 's1',
              title: 'Fixture',
              model: 'm',
              source: 'api_server',
              messageCount: 0,
              isActive: false,
              preview: '',
              startedAt: 1,
            ),
            gateway: gateway,
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        final view = find.byType(NgChatView);
        expect(view, findsOneWidget);
        final painted = Theme.of(tester.element(view));
        expect(painted.brightness, imported.brightness);
        expect(
          painted.scaffoldBackgroundColor,
          imported[ImportedThemeColor.background],
        );
        final ratios = await _composerRatios(
          tester,
          find.byKey(const ValueKey('ng-composer-field')),
        );
        _expectReadable(ratios, 'pop-out ${file['name']}');
        // The pane tries its own gateway (refused here), nothing else.
        expect(
          network.log.where((line) => !line.contains('10.0.0.5')),
          isEmpty,
        );
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 1));
      });
    }
  });
}

/// The composer's hint (empty) and typed text, against what is painted
/// behind them.
Future<Map<String, double>> _composerRatios(
  WidgetTester tester,
  Finder field,
) async {
  expect(field, findsOneWidget);
  final r = <String, double>{};
  final decorator = tester.widget<InputDecorator>(
    find.descendant(of: field, matching: find.byType(InputDecorator)),
  );
  final hint = decorator.decoration.hintText;
  expect(hint, isNotNull);
  r['composer hint'] = _measure(hint!);
  await tester.enterText(field, 'Composer words');
  await tester.pump();
  final editable = find.descendant(
    of: field,
    matching: find.byType(EditableText),
  );
  r['composer typed'] = contrastRatio(
    tester.widget<EditableText>(editable).style.color!,
    _behindElement(tester.element(editable)),
  );
  return r;
}
