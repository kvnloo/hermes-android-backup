import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/widgets/transcript_reader.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final retainReader in [false, true]) {
    testWidgets(
      'departed prompt timeline dismisses (retained reader: $retainReader)',
      (t) async {
        SharedPreferences.setMockInitialValues({});
        final key = GlobalKey<TranscriptReaderState>();
        final scroll = ScrollController();
        final active = ValueNotifier(true);
        var actions = 0;
        await t.pumpWidget(
          MaterialApp(
            home: ValueListenableBuilder<bool>(
              valueListenable: active,
              builder: (c, old, _) => Scaffold(
                body: (old || retainReader)
                    ? TranscriptReader(
                        key: key,
                        owner: old,
                        scroll: scroll,
                        storageKey: null,
                        onLatest: () => actions++,
                        onNavigate: () => actions++,
                        entries: () => [
                          (
                            id: 'one',
                            index: 0,
                            text: old
                                ? 'departed prompt'
                                : 'replacement prompt',
                            prompt: true,
                          ),
                        ],
                        child: ListView(
                          controller: scroll,
                          children: const [Text('Transcript')],
                        ),
                      )
                    : const Text('Replacement chat'),
              ),
            ),
          ),
        );
        key.currentState!.open();
        await t.pumpAndSettle();
        await t.tap(find.byTooltip('Prompt timeline'));
        await t.pumpAndSettle();
        final oldLatest = t
            .widget<TextButton>(
              find.widgetWithText(TextButton, 'Jump to latest'),
            )
            .onPressed!;
        final oldPrompt = t
            .widget<ListTile>(find.widgetWithText(ListTile, 'departed prompt'))
            .onTap!;
        active.value = false;
        await t.pumpAndSettle();
        expect(find.text('departed prompt'), findsNothing);
        expect(find.byType(AlertDialog), findsNothing);
        if (!retainReader) expect(key.currentState, isNull);
        oldLatest();
        oldPrompt();
        await t.pumpAndSettle();
        expect(actions, 0);
        expect(t.takeException(), isNull);
        expect(
          find.text(retainReader ? 'Transcript' : 'Replacement chat'),
          findsOneWidget,
        );
        await t.pumpWidget(const SizedBox());
        scroll.dispose();
        active.dispose();
      },
    );
  }
}
