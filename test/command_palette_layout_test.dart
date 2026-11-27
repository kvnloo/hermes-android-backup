// Regressions (review of 8d733edd, PROBE-9a/9b/9c and PROBE-11): the command
// palette sizes itself from the space above the keyboard, never overflows on
// landscape phones and tablets, scrolls, and keeps the keyboard selection
// visible.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/widgets/command_palette.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

const _count = 12;

Future<List<String>> _pumpPaletteAt(
  WidgetTester tester,
  Size size,
  double keyboard,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
  addTearDown(tester.view.reset);
  final picked = <String>[];
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showAppCommandPalette(
                context,
                actions: [
                  for (var i = 0; i < _count; i++)
                    PaletteAction(
                      id: 'a$i',
                      label: 'Action $i',
                      icon: Icons.bolt,
                    ),
                ],
                onSelected: (a) => picked.add(a.id),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return picked;
}

void _expectAboveKeyboard(WidgetTester tester, Size size, double keyboard) {
  // The dialog's surface (the Dialog widget itself fills the route).
  final dialog = tester.getRect(
    find
        .descendant(of: find.byType(Dialog), matching: find.byType(Material))
        .first,
  );
  expect(dialog.bottom, lessThanOrEqualTo(size.height - keyboard + 0.5));
  final list = tester.getRect(
    find.byKey(const Key('app-command-palette-list')),
  );
  expect(list.bottom, lessThanOrEqualTo(size.height - keyboard + 0.5));
}

void main() {
  testWidgets('phone portrait, keyboard up: full-screen palette, no overflow '
      '(PROBE-9a)', (tester) async {
    await _pumpPaletteAt(tester, const Size(390, 844), 336);
    expect(find.byType(CommandPalette), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tablet landscape, keyboard up: the dialog fits above the '
      'keyboard and the list scrolls (PROBE-9b)', (tester) async {
    const size = Size(1024, 768);
    final picked = await _pumpPaletteAt(tester, size, 380);
    expect(find.byType(Dialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    _expectAboveKeyboard(tester, size, 380);
    // The last action is reachable by scrolling and runs once when tapped.
    final last = find.text('Action ${_count - 1}');
    await tester.scrollUntilVisible(
      last,
      80,
      scrollable: find.descendant(
        of: find.byKey(const Key('app-command-palette-list')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(last);
    await tester.pumpAndSettle();
    expect(picked, ['a${_count - 1}']);
  });

  testWidgets('phone landscape 844x390, keyboard down: no overflow '
      '(PROBE-9c)', (tester) async {
    const size = Size(844, 390);
    await _pumpPaletteAt(tester, size, 0);
    expect(find.byType(Dialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    _expectAboveKeyboard(tester, size, 0);
  });

  testWidgets('phone landscape 844x390, keyboard up: no overflow', (
    tester,
  ) async {
    const size = Size(844, 390);
    await _pumpPaletteAt(tester, size, 200);
    expect(find.byType(Dialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    _expectAboveKeyboard(tester, size, 200);
  });

  testWidgets('a roomy desktop window keeps the 320 px list', (tester) async {
    await _pumpPaletteAt(tester, const Size(1280, 900), 0);
    expect(
      tester.getSize(find.byKey(const Key('app-command-palette-list'))).height,
      CommandPaletteState.maxListHeight,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('arrow keys wrap, keep the selection visible in a short list, '
      'and Enter runs exactly one action once (PROBE-11)', (tester) async {
    const size = Size(844, 390);
    final picked = await _pumpPaletteAt(tester, size, 200);
    // Up from the first wraps to the last action, which must be scrolled in.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    final list = tester.getRect(
      find.byKey(const Key('app-command-palette-list')),
    );
    final lastRow = tester.getRect(find.text('Action ${_count - 1}'));
    expect(list.contains(lastRow.center), isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown); // a0
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown); // a1
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(picked, ['a1']);
    expect(find.byType(CommandPalette), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });
}
