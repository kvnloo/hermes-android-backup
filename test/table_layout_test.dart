import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/render/rich_blocks.dart';
import 'package:hermes_android/core/render/rich_transcript.dart';
import 'package:hermes_android/core/widgets/markdown_file_preview.dart';
import 'package:hermes_android/core/widgets/markdown_code_block.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

const comparison = TablePiece(
  ['Project', 'Integration / sync', 'Practical assessment'],
  [
    [
      '**Cedar**',
      '**CSV import possible.** Includes records and notes.',
      '**High priority.** A reliable migration path.',
    ],
    [
      '**Maple**',
      'Use `project_id` and [documentation](https://example.com).',
      'Review the exported data before importing.',
    ],
  ],
);

Widget app(
  Widget child, {
  Brightness brightness = Brightness.light,
  bool accessible = false,
}) => MaterialApp(
  theme: ThemeData(brightness: brightness),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(accessible ? 2 : 1)),
      child: Directionality(
        textDirection: accessible ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  ),
);

void main() {
  for (final width in [320.0, 390.0, 640.0, 768.0, 1440.0]) {
    for (final brightness in Brightness.values) {
      for (final accessible in [false, true]) {
        testWidgets('table fills pane $width $brightness rtl/2x=$accessible', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(const Size(1440, 1600));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            app(
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: width,
                  child: const ResizableMarkdownTable(table: comparison),
                ),
              ),
              brightness: brightness,
              accessible: accessible,
            ),
          );
          final table = find.byType(Table);
          expect(table, findsOneWidget);
          final viewport = find.byKey(const Key('table-horizontal-scroll'));
          expect(tester.getSize(viewport).width, width);
          expect(tester.getRect(viewport).left, greaterThanOrEqualTo(0));
          expect(tester.getRect(viewport).right, lessThanOrEqualTo(1440));
          expect(tester.getSize(table).width, greaterThanOrEqualTo(width));
          final grid = tester.widget<Table>(table).border!;
          expect(grid.horizontalInside.style, BorderStyle.solid);
          expect(grid.verticalInside.style, BorderStyle.solid);
          expect(
            grid.horizontalInside.color,
            ThemeData(brightness: brightness).colorScheme.outline,
          );
          expect(tester.widget<Table>(table).children.length, 3);
          expect(
            tester.getSize(find.byKey(const Key('table-col-0'))).width,
            greaterThanOrEqualTo(accessible ? 288 : 144),
          );
          // Uniform column geometry on every row, including multiline content.
          final rows = tester.widget<Table>(table).children;
          for (final row in rows) {
            final rects = row.children
                .map((w) => tester.getRect(find.byWidget(w)))
                .toList();
            expect(rects.map((r) => r.top).toSet().length, 1);
            expect(
              rects[0].width,
              closeTo(
                tester.getSize(find.byKey(const Key('table-col-0'))).width,
                .01,
              ),
            );
          }
          final texts = tester
              .widgetList<RichText>(find.byType(RichText))
              .map((w) => w.text.toPlainText())
              .join(' ');
          expect(texts, contains('Cedar'));
          expect(texts, isNot(contains('**')));
          final controller = tester
              .widget<SingleChildScrollView>(viewport)
              .controller!;
          if (tester.getSize(table).width > width) {
            expect(controller.position.maxScrollExtent, greaterThan(0));
            controller.jumpTo(controller.position.maxScrollExtent);
            await tester.pump();
            expect(controller.offset, greaterThan(0));
            expect(
              tester.widget<Scrollbar>(find.byType(Scrollbar)).thumbVisibility,
              isTrue,
            );
          } else {
            expect(controller.position.maxScrollExtent, 0);
          }
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets(
    'short table fills width; resize survives streamed rows and schema changes',
    (tester) async {
      const key = Key('streaming-table');
      Widget table(TablePiece value) => app(
        SizedBox(
          width: 640,
          child: ResizableMarkdownTable(key: key, table: value),
        ),
      );
      await tester.pumpWidget(
        table(
          const TablePiece(
            ['A', 'B'],
            [
              ['1', '2'],
            ],
          ),
        ),
      );
      expect(tester.getSize(find.byType(Table)).width, 640);
      final before = tester.getSize(find.byKey(const Key('table-col-0'))).width;
      await tester.drag(
        find.byKey(const Key('table-resize-0')),
        const Offset(40, 0),
      );
      await tester.pump();
      final resized = tester
          .getSize(find.byKey(const Key('table-col-0')))
          .width;
      expect(resized, greaterThan(before));
      await tester.pumpWidget(
        table(
          const TablePiece(
            ['A', 'B'],
            [
              ['1', '2'],
              ['3'],
            ],
          ),
        ),
      );
      expect(
        tester.getSize(find.byKey(const Key('table-col-0'))).width,
        resized,
      );
      expect(tester.widget<Table>(find.byType(Table)).children.length, 3);
      await tester.pumpWidget(
        table(
          const TablePiece(
            ['A', 'B', 'C'],
            [
              ['1'],
            ],
          ),
        ),
      );
      expect(find.byKey(const Key('table-col-2')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('cell spans retain bold code links and selection registration', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const SelectionArea(child: ResizableMarkdownTable(table: comparison)),
      ),
    );
    var bold = false;
    var code = false;
    for (final rich in tester.widgetList<RichText>(find.byType(RichText))) {
      rich.text.visitChildren((span) {
        if (span is TextSpan) {
          if (span.text == 'Cedar') {
            bold = span.style?.fontWeight == FontWeight.bold;
          }
          if (span.text == 'project_id') code = span.style?.fontFamily != null;
        }
        return true;
      });
      expect(rich.selectionRegistrar, isNotNull);
    }
    expect(bold, isTrue);
    expect(code, isTrue);
    expect(find.byType(SelectionArea), findsOneWidget);
  });

  test(
    'GFM escaped pipes and code cells; fence parser remains authoritative',
    () {
      const text = r'''Project | Notes
--- | ---
**Cedar** | `a\|b` and escaped \| text
Maple | streaming
''';
      final table =
          (splitRichProse(text).whereType<RichPiece>().single.value
              as TablePiece);
      expect(table.headers, ['Project', 'Notes']);
      expect(table.rows.first, ['**Cedar**', '`a|b` and escaped | text']);
      expect(table.rows.length, 2);
      final fenced = splitMarkdownCodeBlocks('```text\n$text\n```');
      expect(fenced.whereType<MarkdownCodeBlock>().length, 1);
      expect(fenced.whereType<String>().any(richProseContainsTable), isFalse);
    },
  );

  testWidgets(
    'Markdown file preview shares grid without enabling chat directives',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: MarkdownFilePreview(
              text:
                  '| A | B |\n| --- | --- |\n| **Value** | `code` |\n\n::preview{file="demo.html"}',
            ),
          ),
        ),
      );
      expect(find.byType(ResizableMarkdownTable), findsOneWidget);
      expect(find.byType(SandboxPreviewCard), findsNothing);
      expect(find.byType(SelectionArea), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
