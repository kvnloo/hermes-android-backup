import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/presentation/companion_draft.dart';
import 'package:hermes_android/core/presentation/imported_theme.dart';
import 'package:hermes_android/core/presentation/pet_window.dart';
import 'package:hermes_android/core/presentation/petdex.dart';
import 'package:hermes_android/core/presentation/presentation_settings.dart';
import 'package:hermes_android/core/presentation/reading_controls.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _theme = '''
{
  "name": "Fixture",
  "type": "dark",
  "colors": {
    "editor.background": "#1E1E1E",
    "editor.foreground": "#D4D4D4",
    "button.background": "#0E639C"
  }
}
''';

Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('reading choices round-trip and reject a swapped face', () async {
    final controls = ReadingControls(await _prefs());
    addTearDown(controls.dispose);
    await controls.setChatFont(AresTypeface.cinzel);
    await controls.setTerminalFont(AresTypeface.geistMono);
    await controls.setDirection(TranscriptDirection.rightToLeft);
    await controls.setBubbleOpacity(0.2);
    await controls.setEmbedMode(InlineEmbedMode.always);
    await controls.allowEmbedService('youtube');
    await controls.allowEmbedService('image:images.example.org');
    await controls.allowEmbedService('not a service');
    final again = ReadingControls(await SharedPreferences.getInstance());
    addTearDown(again.dispose);
    expect(again.chatFont, AresTypeface.cinzel);
    expect(again.terminalFont, AresTypeface.geistMono);
    expect(again.direction, TranscriptDirection.rightToLeft);
    expect(again.bubbleOpacity, ReadingControls.minBubbleOpacity);
    expect(again.embedMode, InlineEmbedMode.always);
    expect(again.allowedEmbeds, {'youtube', 'image:images.example.org'});
  });

  test(
    'Pop out reuses the companion window that is open or starting',
    () async {
      var launches = 0;
      final exits = <Completer<void>>[];
      final ready = Completer<void>();
      final slot = PetWindowSlot(() async {
        launches++;
        await ready.future;
        final exit = Completer<void>();
        exits.add(exit);
        return (exited: exit.future);
      });
      final first = slot.open();
      final second = slot.open();
      ready.complete();
      await Future.wait([first, second]);
      expect(launches, 1);
      await slot.open();
      expect(launches, 1);
      expect(slot.isOpen, isTrue);
      exits.single.complete();
      await pumpEventQueue();
      expect(slot.isOpen, isFalse);
      await slot.open();
      expect(launches, 2);
    },
  );

  testWidgets('search jumps to the radio control in a narrow RTL pane', (
    tester,
  ) async {
    final prefs = await _prefs();
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SizedBox(
              width: 320,
              child: ListView(
                children: [PresentationSettingsPanel(preferences: prefs)],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField).first, 'radio');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();
    expect(find.text('Radio'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the tour spotlights the next control and can be closed', (
    tester,
  ) async {
    final prefs = await _prefs();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [PresentationSettingsPanel(preferences: prefs)],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('presentation-replay-tour')));
    await tester.pumpAndSettle();
    expect(find.text('Imported themes'), findsWidgets);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Reading fonts'), findsWidgets);
    await tester.tap(find.text('Close tour'));
    await tester.pumpAndSettle();
    expect(find.text('Close tour'), findsNothing);
  });

  testWidgets('importing a theme keeps colours and clears the selection', (
    tester,
  ) async {
    final prefs = await _prefs();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              PresentationSettingsPanel(
                preferences: prefs,
                pickTheme: () async => (
                  name: 'fixture.json',
                  bytes: Uint8List.fromList(_theme.codeUnits),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('presentation-import-theme')));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Fixture'));
    await tester.pumpAndSettle();
    final saved = ImportedThemeStore(prefs).read();
    expect(saved.selected?.label, 'Fixture');
    expect(
      saved.selected?[ImportedThemeColor.background],
      const Color(0xff1e1e1e),
    );
    await tester.tap(find.byTooltip('Remove theme'));
    await tester.pumpAndSettle();
    expect(ImportedThemeStore(prefs).read().themes, isEmpty);
  });

  testWidgets('the companion overlay hands a draft to the open composer', (
    tester,
  ) async {
    final prefs = await _prefs();
    final pet = PetdexController(prefs);
    addTearDown(pet.dispose);
    await pet.setEnabled(true);
    final composer = TextEditingController();
    addTearDown(composer.dispose);
    CompanionDraft.pending.addListener(() {
      CompanionDraft.applyTo(composer);
    });
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showCompanionOverlay(context, pet),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Hello from the pet');
    await tester.tap(find.text('Send to the open chat'));
    await tester.pumpAndSettle();
    expect(composer.text, 'Hello from the pet');
  });
}
