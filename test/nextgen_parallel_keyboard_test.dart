// The NextGen composer stays above the on-screen keyboard in the Parallel
// workspace (NgParallelWorkspacePage, reached from More on a phone), in
// portrait and on a landscape phone: field, Attach, Dictate and Send sit
// above the keyboard top and are hit-testable, nothing overflows, and a long
// draft scrolls inside the editor. With little room the workspace chrome
// folds while typing and comes back when the keyboard closes.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/parallel_workspace_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/parallel_workspace_fixture.dart';

const _field = ValueKey('ng-composer-field');

final _long = List.generate(
  40,
  (i) => 'line $i of a long draft that wraps on a phone',
).join('\n');

class _Case {
  const _Case(this.size, this.kb, this.scale, this.long);
  final Size size;
  final double kb;
  final double scale;
  final bool long;
  @override
  String toString() =>
      '${size.width.toInt()}x${size.height.toInt()} kb${kb.toInt()} '
      'x$scale ${long ? 'long40' : 'short'}';
}

List<_Case> _cases() => [
  for (final size in const [Size(320, 640), Size(390, 844)])
    for (final kb in const [260.0, 340.0])
      for (final scale in const [1.0, 2.0])
        for (final long in const [false, true]) _Case(size, kb, scale, long),
  for (final scale in const [1.0, 2.0])
    for (final long in const [false, true])
      _Case(const Size(844, 390), 200, scale, long),
];

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void _expectAboveKeyboard(WidgetTester tester, _Case c) {
  final errors = <String>[];
  Object? e;
  while ((e = tester.takeException()) != null) {
    errors.add(e.toString().split('\n').first);
  }
  final top = c.size.height - c.kb;
  final field = find.byKey(_field);
  final fieldRect = tester.getRect(field);
  final scrollable = find.descendant(
    of: field,
    matching: find.byType(Scrollable),
  );
  final position = scrollable.evaluate().isEmpty
      ? null
      : tester.state<ScrollableState>(scrollable.first).position;
  final where =
      'NextGen parallel $c field=${fieldRect.top.toInt()}..'
      '${fieldRect.bottom.toInt()} kbTop=${top.toInt()} errors=$errors';
  expect(errors, isEmpty, reason: where);
  expect(fieldRect.top, greaterThanOrEqualTo(0), reason: where);
  expect(fieldRect.bottom, lessThanOrEqualTo(top + 0.5), reason: where);
  expect(fieldRect.width, greaterThanOrEqualTo(80), reason: where);
  expect(fieldRect.height, greaterThanOrEqualTo(20), reason: where);
  expect(field.hitTestable(), findsOneWidget, reason: '$where field hit');
  for (final MapEntry(:key, :value) in {
    'attach': find.byTooltip('Attach'),
    'mic': find.byTooltip('Dictate'),
    'send': find.byTooltip('Send'),
  }.entries) {
    expect(value, findsWidgets, reason: '$where $key missing');
    final r = tester.getRect(value.first);
    expect(r.top, greaterThanOrEqualTo(0), reason: '$where $key $r');
    expect(r.bottom, lessThanOrEqualTo(top + 0.5), reason: '$where $key $r');
    expect(value.hitTestable(), findsWidgets, reason: '$where $key hit');
  }
  if (c.long) {
    expect(position, isNotNull, reason: '$where no editor scrollable');
    expect(
      position!.maxScrollExtent,
      greaterThan(0),
      reason: '$where editor does not scroll internally',
    );
  }
}

Future<void> _pumpWorkspace(WidgetTester tester, _Case c) async {
  NextGenLook.instance
    ..themeMode = ThemeMode.dark
    ..accent = NgAccent.blue
    ..pureBlack = false
    ..glow = true;
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = c.size;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.textScaleFactorTestValue = c.scale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final manager = ConnectionManager(await SharedPreferences.getInstance());
  final fixture = ParallelFixture(dashboard: true, profile: 'kb');
  final g = ParallelFixtureGateway(fixture);
  addTearDown(g.dispose);
  await tester.pumpWidget(
    MaterialApp(
      theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NgScope(
        connManager: manager,
        gateway: g,
        connections: [fixture.connection],
        switchTo: (_) async {},
        addGateway: () async {},
        signOut: (_) async {},
        reload: () async {},
        signInAgain: () async {},
        child: NgParallelWorkspacePage(gateway: g),
      ),
    ),
  );
  await _settle(tester);
  await tester.tap(find.byTooltip('Add chat'));
  await _settle(tester);
  await tester.tap(find.text('Chat alpha').last);
  await _settle(tester);
}

Future<void> _type(WidgetTester tester, _Case c) async {
  tester.view.viewInsets = FakeViewPadding(bottom: c.kb);
  await _settle(tester);
  await tester.showKeyboard(find.byKey(_field));
  await tester.enterText(
    find.byKey(_field),
    c.long ? _long : 'steer this please',
  );
  await _settle(tester);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, (_) async => null);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, null);
  });

  for (final c in _cases()) {
    testWidgets('NextGen Parallel workspace $c: composer above the keyboard', (
      tester,
    ) async {
      await _pumpWorkspace(tester, c);
      await _type(tester, c);
      _expectAboveKeyboard(tester, c);
    });
  }

  testWidgets('landscape: the workspace bar and tab strip fold while typing '
      'and come back when the keyboard closes', (tester) async {
    const c = _Case(Size(844, 390), 200, 1.0, false);
    await _pumpWorkspace(tester, c);
    expect(find.text('Parallel workspace'), findsOneWidget);
    expect(find.byType(InputChip), findsOneWidget);
    await _type(tester, c);
    expect(find.text('Parallel workspace'), findsNothing);
    expect(find.byType(InputChip), findsNothing);
    _expectAboveKeyboard(tester, c);
    tester.view.resetViewInsets();
    await _settle(tester);
    expect(find.text('Parallel workspace'), findsOneWidget);
    expect(find.byType(InputChip), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
