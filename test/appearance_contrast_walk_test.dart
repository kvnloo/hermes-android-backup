// Contrast re-check of 29f578c5 (probe RC29 made permanent). Instead of a
// list of chosen strings, this walks EVERY painted paragraph and editable
// field in the tree and measures each one against the colour actually
// composited behind it (Scaffold, Material/PhysicalModel, ColoredBox,
// DecoratedBox, Ink and filled InputDecorator), on the page and in the
// drawer, menus, dialog, sheet, snack bar and tooltip. It uses real VS Code
// theme files (test/fixtures/themes, licences in LICENSES.md): One Dark Pro
// 3.20.7, Solarized Light (VS Code's own JSON, no `type` key) and GitHub
// Light Default 6.3.5 (no `type` key either). Every run of text must clear
// 4.5:1, status inks (error, warning, success, danger) included.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/l10n/l10n.dart';
import 'package:hermes_android/core/presentation/imported_theme.dart';
import 'package:hermes_android/core/presentation/presentation_scope.dart';
import 'package:hermes_android/core/presentation/presentation_settings.dart';
import 'package:hermes_android/core/presentation/reading_controls.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/dashboard_api_client.dart';
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
import 'package:hermes_android/nextgen/ui/sessions_sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _dir = 'test/fixtures/themes';

ImportedTheme _load(String file) => ImportedThemeParser.parse(
  file,
  Uint8List.fromList(File('$_dir/$file').readAsBytesSync()),
).single;

final _themes = <String, ImportedTheme Function()>{
  'One Dark Pro': () => _load('OneDark-Pro.json'),
  'Solarized Light': () => _load('solarized-light-color-theme.json'),
  'GitHub Light Default': () => _load('light-default.json'),
};

double _ratio(Color a, Color b) {
  double lum(Color c) => c.computeLuminance() + 0.05;
  final x = lum(a), y = lum(b);
  return x > y ? x / y : y / x;
}

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}'
    '${c.a < 1 ? '@${c.a.toStringAsFixed(2)}' : ''}';

// ------------------------------------------------------------- measuring --

class _Hit {
  _Hit(this.text, this.ink, this.bg, this.ratio, this.where);
  final String text;
  final Color ink;
  final Color bg;
  final double ratio;
  final String where;
  Map<String, Object> toJson() => {
    'text': text,
    'ratio': double.parse(ratio.toStringAsFixed(2)),
    'ink': _hex(ink),
    'bg': _hex(bg),
    'where': where,
  };
}

bool _readable(String s) => s.runes.any(
  (r) =>
      (r >= 0x30 && r <= 0x39) ||
      (r >= 0x41 && r <= 0x5a) ||
      (r >= 0x61 && r <= 0x7a) ||
      r >= 0x0600 && r < 0x1F000 && !(r >= 0x2190 && r < 0x2c00),
);

/// The composited background behind [element], plus the opacity applied to
/// it and a short description of the painting ancestors.
({Color bg, double opacity, String path}) _behind(
  Element element, {
  required String text,
}) {
  final layers = <Color>[];
  final path = <String>[];
  Color? base;
  var opacity = 1.0;
  element.visitAncestorElements((a) {
    final w = a.widget;
    Color? c;
    if (w is Scaffold) {
      base = w.backgroundColor ?? Theme.of(a).scaffoldBackgroundColor;
      path.add('Scaffold');
      return false;
    }
    if (w is Opacity) opacity *= w.opacity;
    if (w is FadeTransition) opacity *= w.opacity.value;
    if (w is PhysicalModel) c = w.color;
    if (w is PhysicalShape) c = w.color;
    if (w is ColoredBox) c = w.color;
    if (w is DecoratedBox && w.position == DecorationPosition.background) {
      final d = w.decoration;
      if (d is BoxDecoration) c = d.color;
      if (d is ShapeDecoration) c = d.color;
    }
    if (w is Ink) {
      final d = w.decoration;
      if (d is BoxDecoration) c = d.color;
      if (d is ShapeDecoration) c = d.color;
    }
    if (w is InputDecorator) {
      final theme = Theme.of(a);
      final d = w.decoration.applyDefaults(theme.inputDecorationTheme);
      final sub = {d.helperText, d.errorText, d.counterText};
      if (d.filled == true && !sub.contains(text)) {
        final states = <WidgetState>{
          if (!d.enabled) WidgetState.disabled,
          if (w.isFocused) WidgetState.focused,
          if (w.isHovering) WidgetState.hovered,
          if (d.errorText != null) WidgetState.error,
        };
        final raw = d.fillColor;
        c = raw != null
            ? WidgetStateProperty.resolveAs<Color>(raw, states)
            : (d.enabled
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.onSurface.withValues(alpha: 0.04));
      }
    }
    if (c != null && c.a > 0) {
      layers.add(c);
      path.add('${w.runtimeType}${_hex(c)}');
    }
    return true;
  });
  var painted = base ?? Theme.of(element).scaffoldBackgroundColor;
  if (painted.a < 1) {
    painted = Color.alphaBlend(painted, const Color(0xFF000000));
  }
  for (final c in layers.reversed) {
    painted = Color.alphaBlend(c, painted);
  }
  return (bg: painted, opacity: opacity, path: path.take(4).join('<'));
}

bool _underIcon(Element e) {
  var icon = false;
  e.visitAncestorElements((a) {
    if (a.widget is Icon || a.widget is ImageIcon) {
      icon = true;
      return false;
    }
    return true;
  });
  return icon;
}

/// Every visible run of text in the tree, measured.
List<_Hit> _measureAll(WidgetTester tester) {
  final hits = <_Hit>[];
  for (final e in find.byType(RichText).evaluate()) {
    if (_underIcon(e)) continue;
    final ro = e.renderObject;
    if (ro is! RenderParagraph || !ro.hasSize || ro.size.isEmpty) continue;
    final plain = ro.text.toPlainText();
    if (plain.trim().isEmpty || !_readable(plain)) continue;
    final behind = _behind(e, text: plain);
    if (behind.opacity <= 0.01) continue;
    void walk(InlineSpan span, TextStyle? inherited) {
      final style = inherited == null
          ? span.style
          : (span.style == null ? inherited : inherited.merge(span.style));
      if (span is TextSpan) {
        final t = span.text ?? '';
        if (t.trim().isNotEmpty && _readable(t)) {
          var ink = style?.color ?? const Color(0xFF000000);
          if (style?.foreground != null) ink = style!.foreground!.color;
          final a = ink.a * behind.opacity;
          final shown = Color.alphaBlend(ink.withValues(alpha: a), behind.bg);
          hits.add(
            _Hit(
              t.length > 48 ? '${t.substring(0, 48)}…' : t,
              ink,
              behind.bg,
              _ratio(shown, behind.bg),
              behind.path,
            ),
          );
        }
        for (final child in span.children ?? const <InlineSpan>[]) {
          walk(child, style);
        }
      }
    }

    walk(ro.text, null);
  }
  for (final e in find.byType(EditableText).evaluate()) {
    final w = e.widget as EditableText;
    final t = w.controller.text;
    if (t.trim().isEmpty) continue;
    // Typed text in a disabled field is Material's onSurface at 38%, with
    // no theme hook; WCAG 1.4.3 exempts text in an inactive control. Its
    // label and hint are themed and still measured above.
    if (e.findAncestorWidgetOfExactType<TextField>()?.enabled == false) {
      continue;
    }
    final behind = _behind(e, text: t);
    final ink = w.style.color ?? const Color(0xFF000000);
    final shown = Color.alphaBlend(
      ink.withValues(alpha: ink.a * behind.opacity),
      behind.bg,
    );
    hits.add(
      _Hit(
        'typed:${t.length > 40 ? t.substring(0, 40) : t}'
        '${w.readOnly ? '(ro)' : ''}',
        ink,
        behind.bg,
        _ratio(shown, behind.bg),
        behind.path,
      ),
    );
  }
  return hits;
}

class _Report {
  _Report(this.label);
  final String label;
  final seen = <String>{};
  var measured = 0;
  final low = <_Hit>[];
  void add(List<_Hit> hits, String stage) {
    for (final h in hits) {
      final key = '${h.text}|${_hex(h.ink)}|${_hex(h.bg)}';
      if (!seen.add(key)) continue;
      measured++;
      if (h.ratio < 4.5) low.add(h);
    }
  }

  /// Every run below 4.5:1, after checking that the walk saw text at all.
  List<Map<String, Object>> get lowRuns {
    expect(measured, greaterThan(0), reason: '$label measured nothing');
    return [for (final h in low) h.toJson()];
  }
}

// ---------------------------------------------------------------- fixtures --

class _Refusing implements HttpClient {
  _Refusing(this.log);
  final List<String> log;
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isSetter || invocation.isGetter) return null;
    if (invocation.memberName == #close) return null;
    log.add('${invocation.memberName} ${invocation.positionalArguments}');
    throw const SocketException('probe: network forbidden');
  }
}

class _NoNet extends HttpOverrides {
  final log = <String>[];
  @override
  HttpClient createHttpClient(SecurityContext? context) => _Refusing(log);
}

_NoNet _forbidNetwork() {
  final guard = _NoNet();
  final previous = HttpOverrides.current;
  HttpOverrides.global = guard;
  addTearDown(() => HttpOverrides.global = previous);
  return guard;
}

ThemeData _base(String layout, Brightness app) => layout == 'classic'
    ? hermesTheme(app)
    : nextGenTheme(app, NextGenLook.instance);

/// Preferences holding [theme] as the import, or none for a built-in look.
Future<SharedPreferences> _prefsWith(
  ImportedTheme? theme, [
  Map<String, Object> extra = const {},
]) async {
  SharedPreferences.setMockInitialValues(extra);
  final prefs = await SharedPreferences.getInstance();
  if (theme != null) await ImportedThemeStore(prefs).save(theme);
  return prefs;
}

/// The real NextGen views are also walked with no import: the built-in
/// NextGen tokens have to clear 4.5:1 as well.
const _builtIn = 'the built-in look';

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

const _reply =
    'Assistant prose with `inline code` and a [labelled link](https://example.org/doc).\n\n'
    '> A quoted line\n\n'
    '| Col A | Col B |\n|---|---|\n| cell one | cell two |\n\n'
    '![chart](https://images.example.org/chart.png)\n';

// A kitchen sink of every component that carries body, secondary, hint and
// disabled text.
class _Sink extends StatelessWidget {
  const _Sink({required this.scaffold, required this.tooltip});
  final GlobalKey<ScaffoldState> scaffold;
  final GlobalKey<TooltipState> tooltip;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffold,
        appBar: AppBar(
          title: const Text('Bar title'),
          actions: [TextButton(onPressed: () {}, child: const Text('Bar act'))],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tab selected'),
              Tab(text: 'Tab other'),
            ],
          ),
        ),
        drawer: NavigationDrawer(
          selectedIndex: 0,
          children: const [
            NavigationDrawerDestination(
              icon: Icon(Icons.chat),
              label: Text('Dsel'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.settings),
              label: Text('Doth'),
            ),
            NavigationDrawerDestination(
              enabled: false,
              icon: Icon(Icons.block),
              label: Text('Doff'),
            ),
            ListTile(
              title: Text('Drawer row'),
              subtitle: Text('Drawer row secondary'),
            ),
            ListTile(
              selected: true,
              title: Text('Drawer row selected'),
              subtitle: Text('Drawer selected secondary'),
            ),
            ListTile(enabled: false, title: Text('Drawer row disabled')),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(hintText: 'Drawer search hint'),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 0,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.chat), label: 'Nav sel'),
            NavigationDestination(icon: Icon(Icons.folder), label: 'Nav other'),
          ],
        ),
        body: Builder(
          builder: (c) {
            final tt = Theme.of(c).textTheme;
            return ListView(
              children: [
                const Text('Page body'),
                Text(
                  'Status error ink',
                  style: TextStyle(color: Theme.of(c).colorScheme.error),
                ),
                Card(
                  child: Text(
                    'Status error ink on card',
                    style: TextStyle(color: Theme.of(c).colorScheme.error),
                  ),
                ),
                Material(
                  color: Theme.of(c).colorScheme.errorContainer,
                  child: Text(
                    'Status error ink on errorContainer',
                    style: TextStyle(color: Theme.of(c).colorScheme.error),
                  ),
                ),
                for (final (name, ink) in [
                  ('success', HermesTokens.of(c).success),
                  ('warning', HermesTokens.of(c).warning),
                  ('danger', HermesTokens.of(c).danger),
                  ('running', HermesTokens.of(c).running),
                  ('blocked', HermesTokens.of(c).blocked),
                ]) ...[
                  Text('Status token $name', style: TextStyle(color: ink)),
                  Card(
                    child: Text(
                      'Status token $name on card',
                      style: TextStyle(color: ink),
                    ),
                  ),
                  Material(
                    color: HermesTokens.of(c).raised,
                    child: Material(
                      color: ink.withValues(alpha: 0.16),
                      child: Text(
                        'Status token $name badge',
                        style: TextStyle(color: ink),
                      ),
                    ),
                  ),
                ],
                if (Theme.of(c).extension<NgColors>() case final ng?)
                  for (final (name, ink, soft) in [
                    ('warning', ng.warning, ng.warningSoft),
                    ('success', ng.success, ng.successSoft),
                    ('danger', ng.danger, ng.dangerSoft),
                  ]) ...[
                    Text('Status ng $name', style: TextStyle(color: ink)),
                    for (final (surface, fill) in [
                      ('surface', ng.surface),
                      ('surface2', ng.surface2),
                      ('surface3', ng.surface3),
                      ('sheet', ng.sheet),
                      ('sidebar', ng.sidebar),
                      ('input', ng.input),
                    ]) ...[
                      Material(
                        color: fill,
                        child: Text(
                          'Status ng $name on $surface',
                          style: TextStyle(color: ink),
                        ),
                      ),
                      Material(
                        color: fill,
                        child: Material(
                          color: soft,
                          child: Text(
                            'Status ng $name badge on $surface',
                            style: TextStyle(color: ink),
                          ),
                        ),
                      ),
                    ],
                  ],
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Err label',
                    errorText: 'Status field error',
                  ),
                ),
                Text('Page secondary small', style: tt.bodySmall),
                Text('Page label small', style: tt.labelSmall),
                Text('Page title medium', style: tt.titleMedium),
                const ListTile(
                  title: Text('Row title'),
                  subtitle: Text('Row subtitle'),
                  trailing: Text('Row trailing'),
                ),
                const ListTile(
                  selected: true,
                  title: Text('Selected row title'),
                  subtitle: Text('Selected row subtitle'),
                ),
                const ListTile(
                  enabled: false,
                  title: Text('Disabled row title'),
                  subtitle: Text('Disabled row subtitle'),
                ),
                const SwitchListTile(
                  value: true,
                  onChanged: null,
                  title: Text('Disabled switch title'),
                  subtitle: Text('Disabled switch subtitle'),
                ),
                CheckboxListTile(
                  value: false,
                  onChanged: (_) {},
                  title: const Text('Checkbox title'),
                  subtitle: const Text('Checkbox subtitle'),
                ),
                Card(
                  child: Column(
                    children: [
                      const Text('Card body'),
                      Text('Card secondary', style: tt.bodySmall),
                      const ListTile(
                        selected: true,
                        title: Text('Card selected row'),
                      ),
                    ],
                  ),
                ),
                Card.outlined(child: const Text('Outlined card body')),
                Card.filled(child: const Text('Filled card body')),
                TextField(
                  controller: TextEditingController(text: 'Typed value'),
                  decoration: const InputDecoration(
                    labelText: 'Field label',
                    helperText: 'Field helper',
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(hintText: 'Field hint'),
                ),
                TextField(
                  enabled: false,
                  controller: TextEditingController(text: 'Disabled typed'),
                  decoration: const InputDecoration(
                    labelText: 'Disabled label',
                  ),
                ),
                const TextField(
                  enabled: false,
                  decoration: InputDecoration(hintText: 'Disabled hint'),
                ),
                Wrap(
                  children: [
                    const Chip(label: Text('Plain chip')),
                    ChoiceChip(
                      label: const Text('Choice selected'),
                      selected: true,
                      onSelected: (_) {},
                    ),
                    ChoiceChip(
                      label: const Text('Choice open'),
                      selected: false,
                      onSelected: (_) {},
                    ),
                    const ChoiceChip(
                      label: Text('Choice disabled'),
                      selected: false,
                    ),
                    FilterChip(
                      label: const Text('Filter selected'),
                      selected: true,
                      onSelected: (_) {},
                    ),
                    ActionChip(
                      label: const Text('Action chip'),
                      onPressed: () {},
                    ),
                    InputChip(
                      label: const Text('Input chip'),
                      onPressed: () {},
                    ),
                  ],
                ),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Seg ask')),
                    ButtonSegment(value: 1, label: Text('Seg always')),
                    ButtonSegment(value: 2, label: Text('Seg off')),
                  ],
                  selected: const {0},
                  onSelectionChanged: (_) {},
                ),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Seg disabled a')),
                    ButtonSegment(value: 1, label: Text('Seg disabled b')),
                  ],
                  selected: const {0},
                  onSelectionChanged: null,
                ),
                Wrap(
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Text btn')),
                    const TextButton(
                      onPressed: null,
                      child: Text('Text btn off'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Outline btn'),
                    ),
                    const OutlinedButton(
                      onPressed: null,
                      child: Text('Outline btn off'),
                    ),
                    FilledButton(
                      onPressed: () {},
                      child: const Text('Filled btn'),
                    ),
                    const FilledButton(
                      onPressed: null,
                      child: Text('Filled btn off'),
                    ),
                    FilledButton.tonal(
                      onPressed: () {},
                      child: const Text('Tonal btn'),
                    ),
                    const ElevatedButton(
                      onPressed: null,
                      child: Text('Elevated btn off'),
                    ),
                  ],
                ),
                const ExpansionTile(
                  title: Text('Expansion title'),
                  subtitle: Text('Expansion subtitle'),
                ),
                PopupMenuButton<int>(
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 1, child: Text('Popup item')),
                    PopupMenuItem(
                      value: 2,
                      enabled: false,
                      child: Text('Popup disabled'),
                    ),
                    CheckedPopupMenuItem(
                      value: 3,
                      checked: true,
                      child: Text('Popup checked'),
                    ),
                  ],
                  child: const Text('Open popup'),
                ),
                MenuAnchor(
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () {},
                      child: const Text('Anchor item'),
                    ),
                    const MenuItemButton(
                      onPressed: null,
                      child: Text('Anchor disabled'),
                    ),
                  ],
                  builder: (context, controller, _) => TextButton(
                    onPressed: controller.open,
                    child: const Text('Open anchor'),
                  ),
                ),
                Tooltip(
                  key: tooltip,
                  message: 'Tooltip words',
                  child: const Text('Has tooltip'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> _measureSink(
  WidgetTester tester,
  _Report report,
  GlobalKey<ScaffoldState> scaffold,
  GlobalKey<TooltipState> tooltip,
) async {
  report.add(_measureAll(tester), 'page');
  scaffold.currentState!.openDrawer();
  await tester.pumpAndSettle();
  report.add(_measureAll(tester), 'drawer');
  scaffold.currentState!.closeDrawer();
  await tester.pumpAndSettle();

  await tester.tap(find.text('Open popup'));
  await tester.pumpAndSettle();
  report.add(_measureAll(tester), 'popup');
  await tester.tapAt(const Offset(2, 2));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Open anchor'));
  await tester.pumpAndSettle();
  report.add(_measureAll(tester), 'anchor');
  await tester.tapAt(const Offset(2, 2));
  await tester.pumpAndSettle();

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
            const ListTile(selected: true, title: Text('Dialog selected row')),
          ],
        ),
        actions: [
          const TextButton(onPressed: null, child: Text('Dialog off')),
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Dialog close'),
          ),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();
  report.add(_measureAll(tester), 'dialog');
  await tester.tap(find.text('Dialog close'));
  await tester.pumpAndSettle();

  unawaited(
    showModalBottomSheet<void>(
      context: context,
      builder: (c) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text('Sheet row'),
            subtitle: Text('Sheet secondary'),
          ),
          const ListTile(selected: true, title: Text('Sheet selected')),
          const ListTile(enabled: false, title: Text('Sheet disabled')),
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Sheet close'),
          ),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();
  report.add(_measureAll(tester), 'sheet');
  await tester.tap(find.text('Sheet close'));
  await tester.pumpAndSettle();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Snack words'),
      action: SnackBarAction(label: 'Snack action', onPressed: () {}),
    ),
  );
  await tester.pumpAndSettle();
  report.add(_measureAll(tester), 'snack');
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  await tester.pumpAndSettle();

  tooltip.currentState!.ensureTooltipVisible();
  await tester.pumpAndSettle();
  report.add(_measureAll(tester), 'tooltip');
  Tooltip.dismissAllToolTips();
  await tester.pumpAndSettle();
}

// Sidebar harness (as nextgen_chat_row_menu_test).
final double _now = DateTime.now().millisecondsSinceEpoch / 1000.0;

Session _row(
  String id,
  String title, {
  double ago = 300,
  bool active = false,
  bool pinned = false,
}) => Session(
  id: id,
  title: title,
  model: 'm',
  source: 'desktop',
  messageCount: 2,
  isActive: active,
  preview: '',
  startedAt: 1000,
  lastActive: _now - ago,
  pinned: pinned,
);

class _FakeApi extends DashboardApiClient {
  _FakeApi(super.dashboard, this.rows) : super.withDashboard();
  List<Session> rows;
  @override
  Future<bool?> showSubagentSessions({String? profile}) async => false;
  @override
  Future<SessionListPage> getSessionsPage({
    int limit = 50,
    int offset = 0,
    String? title,
    String? excludeSources,
    bool Function()? maySendSearch,
    Duration timeout = ApiClient.requestTimeout,
  }) async =>
      SessionListPage(sessions: offset == 0 ? rows : const [], hasMore: false);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => HermesSignInVault.resetForTesting(MemorySignInSecretStore()));

  test('the real theme files parse in their own brightness', () {
    expect(
      {for (final e in _themes.entries) e.key: e.value().brightness},
      {
        'One Dark Pro': Brightness.dark,
        'Solarized Light': Brightness.light,
        'GitHub Light Default': Brightness.light,
      },
    );
    // The raw status colours these themes ship below 4.5:1 on their own
    // background, so the walk below proves a correction, not a lucky file.
    double raw(String name) {
      final t = _themes[name]!();
      return _ratio(
        t[ImportedThemeColor.error],
        t[ImportedThemeColor.background],
      );
    }

    expect(raw('One Dark Pro'), lessThan(4.5));
    expect(raw('Solarized Light'), lessThan(4.5));
  });

  // ---------------------------------------------------- kitchen sink -----
  for (final layout in ['classic', 'nextgen']) {
    for (final app in Brightness.values) {
      for (final name in _themes.keys) {
        testWidgets('sink $name over $layout ${app.name}', (tester) async {
          final theme = _themes[name]!();
          final prefs = await _prefsWith(theme);
          tester.view.physicalSize = const Size(1000, 2600);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          final scaffold = GlobalKey<ScaffoldState>();
          final tooltip = GlobalKey<TooltipState>();
          await tester.pumpWidget(
            MaterialApp(
              theme: _base(layout, app),
              builder: (context, child) =>
                  PresentationRoot(preferences: prefs, child: child!),
              home: _Sink(scaffold: scaffold, tooltip: tooltip),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            Theme.of(tester.element(find.text('Page body'))).brightness,
            theme.brightness,
          );
          final report = _Report('sink $name $layout ${app.name}');
          await _measureSink(tester, report, scaffold, tooltip);
          await tester.pumpWidget(const SizedBox());
          expect(report.lowRuns, isEmpty, reason: report.label);
        });
      }
    }
  }

  // ------------------------------------------- real NextGen chat view -----
  for (final app in Brightness.values) {
    for (final name in [..._themes.keys, _builtIn]) {
      testWidgets('NgChatView $name over ${app.name}', (tester) async {
        final theme = _themes[name]?.call();
        final prefs = await _prefsWith(theme);
        tester.view.physicalSize = const Size(1000, 3000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        _forbidNetwork();
        final gateway = _gateway();
        final chat = NgChatController(gateway, sessionId: 's')
          ..runtimeId = 'runtime-s'
          ..debugApplyHistory([
            {'role': 'user', 'content': 'User words here'},
            {'role': 'assistant', 'content': _reply},
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
        final report = _Report('NgChatView $name ${app.name}');
        report.add(_measureAll(tester), 'empty composer');
        final field = find.byKey(const ValueKey('ng-composer-field'));
        expect(field, findsOneWidget);
        await tester.enterText(field, 'Composer typed words');
        await tester.pump();
        report.add(_measureAll(tester), 'typed');
        await tester.pumpWidget(const SizedBox());
        expect(report.lowRuns, isEmpty, reason: report.label);
      });
    }
  }

  // -------------------------------------------- real NextGen sidebar ------
  for (final app in Brightness.values) {
    for (final name in [..._themes.keys, _builtIn]) {
      testWidgets('NgSessionsSidebar $name over ${app.name}', (tester) async {
        final theme = _themes[name]?.call();
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final seen = ['open', 'a', 'run'].map((id) => '"$id": $_now');
        final prefs = await _prefsWith(theme, {
          'nextgen.seen_chats.c1':
              '{"since": ${_now - 3600}, "chats": {${seen.join(', ')}}}',
        });
        final gateway = _gateway();
        final rows = [
          _row('open', 'Open chat title'),
          _row('a', 'Read chat title'),
          _row('u', 'Unread chat title', ago: 120),
          _row('run', 'Running chat title', active: true),
          _row('p', 'Pinned chat title', pinned: true),
        ];
        final api = _FakeApi(gateway.dashboard, rows);
        gateway.api = api;
        NgScope scope(Widget child) => NgScope(
          connManager: ConnectionManager(prefs),
          gateway: gateway,
          connections: [gateway.connection],
          switchTo: (_) async {},
          addGateway: () async {},
          signOut: (_) async {},
          reload: () async {},
          signInAgain: () async {},
          child: child,
        );
        final model = NgSessionsModel(scope(const SizedBox()))
          ..sessions = rows
          ..currentId = 'open';
        addTearDown(() {
          model.dispose();
          gateway.dispose();
        });
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: _base('nextgen', app),
            builder: (context, child) =>
                PresentationRoot(preferences: prefs, child: child!),
            home: scope(
              Scaffold(
                body: NgSessionsSidebar(
                  model: model,
                  currentSessionId: 'open',
                  onOpen: (_) {},
                  onNewChat: () {},
                  onDestination: (_) {},
                  docked: true,
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        final report = _Report('NgSessionsSidebar $name ${app.name}');
        report.add(_measureAll(tester), 'sidebar');
        final search = find.descendant(
          of: find.byType(NgSessionsSidebar),
          matching: find.byType(TextField),
        );
        if (search.evaluate().isNotEmpty) {
          await tester.enterText(search.first, 'zzz');
          await tester.pump(const Duration(milliseconds: 50));
          report.add(_measureAll(tester), 'search typed');
        }
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 1));
        expect(report.lowRuns, isEmpty, reason: report.label);
      });
    }
  }

  // ---------------------------------------------- real Classic chat -------
  for (final app in Brightness.values) {
    for (final name in _themes.keys) {
      testWidgets('Classic ChatScreen $name over ${app.name}', (tester) async {
        mockChatImageRecovery();
        final theme = _themes[name]!();
        final prefs = await _prefsWith(theme);
        tester.view.physicalSize = const Size(1000, 3000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final rows = [
          {'id': '1', 'role': 'user', 'content': 'User words here'},
          {
            'id': '2',
            'role': 'assistant',
            'content': _reply,
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
        _forbidNetwork();
        await pumpChatUpdates(tester);
        final report = _Report('Classic ChatScreen $name ${app.name}');
        report.add(_measureAll(tester), 'transcript');
        final composer = find.descendant(
          of: find.byType(ChatScreen),
          matching: find.byWidgetPredicate(
            (w) => w is EditableText && !w.readOnly,
          ),
        );
        if (composer.evaluate().isNotEmpty) {
          await tester.enterText(composer.last, 'Composer typed words');
          await tester.pump();
          report.add(_measureAll(tester), 'typed');
        }
        await tester.pumpWidget(const SizedBox());
        expect(report.lowRuns, isEmpty, reason: report.label);
      });
    }
  }

  // ----------------------------------------- Appearance settings panel ----
  for (final layout in ['classic', 'nextgen']) {
    for (final app in Brightness.values) {
      for (final name in _themes.keys) {
        testWidgets('settings panel $name over $layout ${app.name}', (
          tester,
        ) async {
          final theme = _themes[name]!();
          final prefs = await _prefsWith(theme);
          await ReadingControls(prefs).allowEmbedService('youtube');
          tester.view.physicalSize = const Size(900, 6000);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: _base(layout, app),
              builder: (context, child) =>
                  PresentationRoot(preferences: prefs, child: child!),
              home: Scaffold(
                body: ListView(
                  children: [PresentationSettingsPanel(preferences: prefs)],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final report = _Report('settings $name $layout ${app.name}');
          report.add(_measureAll(tester), 'panel');
          await tester.pumpWidget(const SizedBox());
          expect(report.lowRuns, isEmpty, reason: report.label);
        });
      }
    }
  }

  // ------------------------------------------------ NextGen pop-out -------
  for (final name in _themes.keys) {
    testWidgets('NextGen pop-out $name', (tester) async {
      final theme = _themes[name]!();
      SharedPreferences.setMockInitialValues({});
      final main = await SharedPreferences.getInstance();
      await ImportedThemeStore(main).save(theme);
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
      SharedPreferences.setMockInitialValues(copied);
      final child = await SharedPreferences.getInstance();
      _forbidNetwork();
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
      expect(Theme.of(tester.element(view)).brightness, theme.brightness);
      final report = _Report('pop-out $name');
      report.add(_measureAll(tester), 'empty');
      await tester.enterText(
        find.byKey(const ValueKey('ng-composer-field')),
        'Composer typed words',
      );
      await tester.pump();
      report.add(_measureAll(tester), 'typed');
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      expect(report.lowRuns, isEmpty, reason: report.label);
    });
  }

  // ------------------------------------------ built-in NextGen tokens -----
  // Every built-in NextGen ink clears 4.5:1 where it is drawn: every ink on
  // every plain surface (the segmented thumb carries only `text`); body
  // inks also on the accent and status washes that tint sidebar rows and
  // pills; accentText on its own wash; each status ink on its own badge
  // wash. Every accent, both brightnesses, and pure black.
  test('built-in NextGen tokens clear 4.5:1 where each ink is drawn', () {
    final low = <String, String>{};
    for (final brightness in Brightness.values) {
      for (final pureBlack in [false, true]) {
        for (final accent in NgAccent.values) {
          final c = NgColors.build(brightness, accent, pureBlack, true);
          final look =
              '${brightness.name}${pureBlack ? ' pure black' : ''} '
              '${accent.name}';
          void check(String ink, Color color, String surface, Color fill) {
            final ratio = _ratio(color, fill);
            if (ratio < 4.5) {
              low['$look: $ink on $surface'] = ratio.toStringAsFixed(2);
            }
          }

          final plain = {
            'background': c.background,
            'surface': c.surface,
            'surface2': c.surface2,
            'surface3': c.surface3,
            'well': c.well,
            'sheet': c.sheet,
            'input': c.input,
            'sidebar': c.sidebar,
          };
          final washes = {
            'accentSoft': c.accentSoft,
            'dangerSoft': c.dangerSoft,
            'successSoft': c.successSoft,
            'warningSoft': c.warningSoft,
          };
          final inks = {
            'text': c.text,
            'text2': c.text2,
            'text3': c.text3,
            'textMuted': c.textMuted,
            'accentText': c.accentText,
            'danger': c.danger,
            'success': c.success,
            'warning': c.warning,
          };
          check('text', c.text, 'thumb', c.thumb);
          for (final surface in plain.entries) {
            for (final ink in inks.entries) {
              check(ink.key, ink.value, surface.key, surface.value);
            }
            for (final wash in washes.entries) {
              final tinted = Color.alphaBlend(wash.value, surface.value);
              for (final body in ['text', 'text2', 'text3']) {
                check(body, inks[body]!, '${wash.key}/${surface.key}', tinted);
              }
            }
            for (final (ink, wash) in [
              ('accentText', 'accentSoft'),
              ('danger', 'dangerSoft'),
              ('success', 'successSoft'),
              ('warning', 'warningSoft'),
            ]) {
              check(
                ink,
                inks[ink]!,
                '$wash/${surface.key}',
                Color.alphaBlend(washes[wash]!, surface.value),
              );
            }
          }
          check('onAccent', c.onAccent, 'accent', c.accent);
          check('onUserBubble', c.onUserBubble, 'userBubble', c.userBubble);
          check('onInverse', c.onInverse, 'inverse', c.inverse);
        }
      }
    }
    expect(low, isEmpty);
  });

  // ------------------------- the embed UI on the built-in looks -----------
  const embedReply =
      'Embeds:\n\n![chart](https://images.example.org/chart.png)\n\n'
      'https://youtu.be/dQw4w9WgXcQ\n\n'
      'https://maps.google.com/maps?q=Sydney+Opera+House\n';
  for (final layout in ['classic', 'nextgen']) {
    for (final app in Brightness.values) {
      for (final mode in InlineEmbedMode.values) {
        testWidgets('embed UI on the built-in $layout ${app.name} look, '
            '${mode.name}', (tester) async {
          SharedPreferences.setMockInitialValues({
            ReadingControls.preferenceKey: jsonEncode({
              'chatFont': 'platform',
              'terminalFont': 'geistMono',
              'direction': 'automatic',
              'bubbleOpacity': 1,
              'embedMode': mode.name,
              'allowedEmbeds': <String>[],
              'emojiReactions': false,
              'celebrationHearts': false,
            }),
          });
          final prefs = await SharedPreferences.getInstance();
          tester.view.physicalSize = const Size(1000, 3000);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          if (layout == 'nextgen') {
            _forbidNetwork();
            final gateway = _gateway();
            final chat = NgChatController(gateway, sessionId: 's')
              ..runtimeId = 'runtime-s'
              ..debugApplyHistory([
                {'role': 'user', 'content': 'User words here'},
                {'role': 'assistant', 'content': embedReply},
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
          } else {
            mockChatImageRecovery();
            final rows = [
              {'id': '1', 'role': 'user', 'content': 'User words here'},
              {
                'id': '2',
                'role': 'assistant',
                'content': embedReply,
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
            _forbidNetwork();
            await pumpChatUpdates(tester);
          }
          for (var i = 0; i < 8; i++) {
            await tester.pump(const Duration(milliseconds: 50));
          }
          final report = _Report('embed UI $layout ${app.name} ${mode.name}');
          report.add(_measureAll(tester), 'embeds');
          await tester.pumpWidget(const SizedBox());
          await tester.pump(const Duration(seconds: 1));
          expect(report.lowRuns, isEmpty, reason: report.label);
        });
      }
    }
  }
}
