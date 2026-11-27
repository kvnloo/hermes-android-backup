import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/widgets/markdown_file_preview.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

Future<void> _show(WidgetTester tester, String text) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: MarkdownFilePreview(text: text)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  // A real README shape: GFM pads delimiter rows to the column width.
  const wideTable = '''# Config

| Option               | Description                              | Default |
| -------------------- | ---------------------------------------- | ------- |
| `timeout`            | Seconds before the request is abandoned  | `30`    |

---------------------------------------------------------------------------

## After table
''';

  testWidgets('padded table delimiter rows and long rules render in full', (
    tester,
  ) async {
    await _show(tester, wideTable);
    expect(find.text('Preview truncated'), findsNothing);
    expect(find.byType(Table), findsOneWidget);
    expect(
      find.text('Seconds before the request is abandoned'),
      findsOneWidget,
    );
    expect(find.text('After table'), findsOneWidget);
  });

  testWidgets('deeply nested markers still stop rich formatting', (
    tester,
  ) async {
    await _show(tester, '# Safe\n\n${'>' * 200} deep\n\n## Later\n');
    expect(find.text('Safe'), findsOneWidget);
    expect(find.text('Later'), findsNothing);
    expect(find.text('Preview truncated'), findsOneWidget);
  });
}
