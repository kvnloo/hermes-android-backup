import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/presentation/petdex.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> wide(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(900, 2200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

Widget host(Widget child, {bool still = true}) => MaterialApp(
  home: Scaffold(
    body: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: still),
        child: Center(child: SingleChildScrollView(child: child)),
      ),
    ),
  ),
);

Uint8List portrait({
  int width = 64,
  int height = 32,
  bool visible = true,
  bool jpeg = false,
}) {
  final image = img.Image(
    width: width,
    height: height,
    numChannels: 4,
    textData: {'Comment': 'Private fixture metadata'},
  );
  if (visible) img.fill(image, color: img.ColorRgba8(255, 0, 0, 255));
  return jpeg ? img.encodeJpg(image) : img.encodePng(image);
}

class _Picker extends FilePicker {
  _Picker(this.selection);
  final PlatformFile? selection;
  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    expect(type, FileType.custom);
    expect(allowedExtensions, ['png', 'jpg', 'jpeg']);
    expect(withData, isFalse);
    expect(withReadStream, isTrue);
    expect(allowMultiple, isFalse);
    return selection == null ? null : FilePickerResult([selection!]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;
  late PetdexController controller;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    controller = PetdexController(prefs);
  });
  tearDown(() {
    controller.dispose();
  });

  Future<void> rebind() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    controller.dispose();
    controller = PetdexController(prefs);
  }

  test(
    'local picker streams only bounded input, including dishonest size declarations',
    () async {
      addTearDown(() => FilePicker.platform = FilePickerIO());
      FilePicker.platform = _Picker(null);
      expect(await PetDraft.pick(), isNull);
      FilePicker.platform = _Picker(
        PlatformFile(
          name: 'oversize.png',
          size: PetDraft.maxFileBytes + 1,
          readStream: Stream.multi(
            (sink) => fail('should not read oversized input'),
          ),
        ),
      );
      await expectLater(PetDraft.pick(), throwsFormatException);
      FilePicker.platform = _Picker(
        PlatformFile(
          name: 'too-long.png',
          size: 1,
          readStream: Stream.fromIterable([
            Uint8List(PetDraft.maxFileBytes),
            [1],
          ]),
        ),
      );
      await expectLater(PetDraft.pick(), throwsFormatException);
      final bytes = portrait();
      final parts = [bytes.sublist(0, 8), bytes.sublist(8)];
      FilePicker.platform = _Picker(
        PlatformFile(
          name: 'private-name.png',
          path: '/private/example',
          size: bytes.length,
          readStream: Stream.fromIterable(parts),
        ),
      );
      final picked = await TestWidgetsFlutterBinding.instance.runAsync(
        PetDraft.pick,
      );
      await controller.hatch(picked!);
      final saved = prefs.getString(PetdexController.preferenceKey)!;
      final record = jsonDecode(saved) as Map<String, dynamic>;
      expect(record.keys.toSet(), {
        'enabled',
        'roam',
        'size',
        'species',
        'portrait',
      });
      expect(saved, isNot(contains('private-name')));
      expect(saved, isNot(contains('/private')));
      expect(saved, isNot(contains('metadata')));
      expect(saved, isNot(contains(base64Encode(bytes))));
      final pixels = base64Decode(record['portrait']);
      expect(pixels.length, 24 * 24);
      // Letterboxed 2:1 source, opaque pure red in the 216-color palette.
      expect(pixels.toSet(), {0, 181});
      expect(pixels.where((p) => p == 181).length, 24 * 12);
      final restored = PetdexController(prefs);
      expect(restored.enabled, isTrue);
      expect(restored.hasHatch, isTrue);
      expect(restored.species, PetSpecies.hatchling);
      expect(restored.snapshot, controller.snapshot);
      restored.dispose();
    },
  );

  test(
    'decoder rejects non-images, transparent and oversize input; JPEG works',
    () async {
      for (final bytes in [
        utf8.encode('https://example.invalid/image.png'),
        utf8.encode('<svg><script></script></svg>'),
        Uint8List(PetDraft.maxFileBytes + 1),
        portrait(visible: false),
        portrait(width: 4097, height: 1),
      ]) {
        Object? error;
        await TestWidgetsFlutterBinding.instance.runAsync(() async {
          try {
            await PetDraft.fromImageBytes(bytes);
          } catch (caught) {
            error = caught;
          }
        });
        expect(error, isA<FormatException>());
      }
      final hatched = await TestWidgetsFlutterBinding.instance.runAsync(
        () => PetDraft.fromImageBytes(portrait(jpeg: true)),
      );
      await controller.hatch(hatched!);
      expect(controller.hasHatch, isTrue);
    },
  );

  test(
    'invalid local preferences and detached snapshots fail closed',
    () async {
      final valid = jsonDecode(controller.snapshot) as Map<String, dynamic>;
      for (final input in [
        42,
        '{',
        '.' * 1025,
        jsonEncode({...valid, 'enabled': 'yes'}),
        jsonEncode({
          ...valid,
          'enabled': true,
          'species': 'https://example.invalid/x',
        }),
        jsonEncode({...valid, 'enabled': true, 'species': 'hatchling'}),
        jsonEncode({
          ...valid,
          'enabled': true,
          'portrait': base64Encode(List.filled(576, 255)),
        }),
      ]) {
        final mirror = PetdexController.preview(input);
        expect(mirror.enabled, isFalse);
        expect(mirror.hasHatch, isFalse);
        mirror.dispose();
      }
      await Future.wait([
        controller.adopt(PetSpecies.tideling),
        controller.setRoaming(true),
        controller.setSize(PetSize.large),
      ]);
      final mirror = PetdexController.preview(controller.snapshot);
      expect(mirror.enabled, isTrue);
      expect(mirror.species, PetSpecies.tideling);
      expect(mirror.roaming, isTrue);
      expect(mirror.size, PetSize.large);
      await mirror.setEnabled(false);
      expect(controller.enabled, isTrue);
      mirror.dispose();
    },
  );

  testWidgets('adopt completes inside a widget test', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final localPrefs = await SharedPreferences.getInstance();
    final local = PetdexController(localPrefs);
    addTearDown(local.dispose);
    await local.adopt(PetSpecies.mosskip);
    expect(local.enabled, isTrue);
  });

  testWidgets(
    'settings browse, adopt, resize and opt out with persisted choices',
    (tester) async {
      await rebind();
      await wide(tester);
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          host(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PetCompanion.compact(controller: controller),
                PetdexSettings(controller: controller),
              ],
            ),
          ),
        );
        expect(prefs.getKeys(), isEmpty);
        expect(find.bySemanticsLabel('Mosskip · At rest'), findsNothing);
        for (final name in ['Mosskip', 'Emberbun', 'Tideling']) {
          await tester.tap(find.widgetWithText(ChoiceChip, name));
          await tester.pump();
          if (!controller.enabled ||
              controller.species.name != name.toLowerCase()) {
            final chip = tester.widget<ChoiceChip>(
              find.widgetWithText(ChoiceChip, name),
            );
            chip.onSelected?.call(true);
            await tester.pump();
          }
          expect(controller.enabled, isTrue, reason: name);
          expect(controller.species.name, name.toLowerCase(), reason: name);
          expect(find.bySemanticsLabel('$name · At rest'), findsOneWidget);
        }
        await tester.tap(find.text('Roam when idle'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Large'));
        await tester.pumpAndSettle();
        final art = find.descendant(
          of: find.byType(PetCompanion),
          matching: find.byType(CustomPaint),
        );
        expect(tester.getSize(art.last), const Size.square(36));
        await tester.tap(find.text('Pet companion'));
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel('Tideling · At rest'), findsNothing);
        final restored = PetdexController(prefs);
        expect(restored.enabled, isFalse);
        expect(restored.roaming, isTrue);
        expect(restored.size, PetSize.large);
        expect(restored.species, PetSpecies.tideling);
        restored.dispose();
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets(
    'draft preview is disposable; confirm saves and Forget removes it',
    (tester) async {
      await rebind();
      await wide(tester);
      final draft = await tester.runAsync(
        () => PetDraft.fromImageBytes(portrait()),
      );
      expect(draft, isNotNull);
      await tester.pumpWidget(
        host(
          PetdexSettings(controller: controller, pickDraft: () async => draft),
        ),
      );
      await tester.tap(find.text('Choose picture'));
      await tester.pumpAndSettle();
      expect(find.text('Hatch and adopt'), findsOneWidget);
      expect(prefs.getKeys(), isEmpty);
      await tester.tap(find.text('Discard draft'));
      await tester.pumpAndSettle();
      expect(controller.hasHatch, isFalse);
      expect(prefs.getKeys(), isEmpty);
      await tester.tap(find.text('Choose picture'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hatch and adopt'));
      await tester.pumpAndSettle();
      expect(controller.species, PetSpecies.hatchling);
      expect(controller.enabled, isTrue);
      expect(find.text('My hatchling'), findsOneWidget);
      await tester.tap(find.text('Forget saved hatchling'));
      await tester.pumpAndSettle();
      expect(find.text('My hatchling'), findsNothing);
      expect(controller.enabled, isFalse);
      expect(
        prefs.getString(PetdexController.preferenceKey),
        isNot(contains('portrait')),
      );
    },
  );

  testWidgets(
    'invalid picker input has local, path-free feedback; replaced owner cannot adopt stale draft',
    (tester) async {
      await rebind();
      await wide(tester);
      final draft = await tester.runAsync(
        () => PetDraft.fromImageBytes(portrait()),
      );
      final pending = Completer<PetDraft?>();
      await tester.pumpWidget(
        host(
          PetdexSettings(
            controller: controller,
            pickDraft: () async =>
                throw const FormatException('/private/example.png'),
          ),
        ),
      );
      await tester.tap(find.text('Choose picture'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Could not open that image'), findsOneWidget);
      expect(find.textContaining('/private'), findsNothing);
      await tester.pumpWidget(
        host(
          PetdexSettings(
            controller: controller,
            pickDraft: () => pending.future,
          ),
        ),
      );
      await tester.tap(find.text('Choose picture'));
      await tester.pump();
      final other = PetdexController.preview(null);
      addTearDown(other.dispose);
      await tester.pumpWidget(host(PetdexSettings(controller: other)));
      pending.complete(draft);
      await tester.pumpAndSettle();
      expect(find.text('Hatch and adopt'), findsNothing);
      expect(prefs.getKeys(), isEmpty);
    },
  );

  testWidgets(
    'full pet greets, composes and reads changing activity and unread signals',
    (tester) async {
      await rebind();
      await wide(tester);
      final semantics = tester.ensureSemantics();
      try {
        await controller.adopt(PetSpecies.emberbun);
        final before = controller.snapshot;
        var taps = 0;
        Widget full(PetActivity activity, bool unread) => host(
          PetCompanion.full(
            controller: controller,
            activity: activity,
            anyUnread: unread,
            onCompose: () => taps++,
          ),
        );
        await tester.pumpWidget(full(PetActivity.working, true));
        final stage = find.bySemanticsLabel(
          'Emberbun · Working · Unread reply',
        );
        expect(stage, findsOneWidget);
        await tester.tap(stage);
        await tester.pump();
        expect(find.textContaining('Hello!'), findsOneWidget);
        await tester.pump(const Duration(seconds: 3));
        expect(find.textContaining('Hello!'), findsNothing);
        await tester.tap(find.text('Compose'));
        expect(taps, 1);
        await tester.pumpWidget(full(PetActivity.waiting, false));
        expect(
          find.bySemanticsLabel('Emberbun · Waiting for you'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.mark_email_unread_outlined), findsNothing);
        await tester.pumpWidget(
          host(
            PetCompanion.compact(
              controller: controller,
              activity: PetActivity.failed,
              onCompose: () => taps++,
            ),
          ),
        );
        await tester.tap(find.bySemanticsLabel('Emberbun · Turn failed'));
        expect(taps, 2);
        expect(controller.snapshot, before);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets(
    'roaming stays inside its stage; reduced motion and unread stop travel',
    (tester) async {
      await rebind();
      await wide(tester);
      await controller.adopt(PetSpecies.mosskip);
      await controller.setRoaming(true);
      Widget pet({bool still = false, bool unread = false}) => host(
        PetCompanion.full(controller: controller, anyUnread: unread),
        still: still,
      );
      await tester.pumpWidget(pet());
      await tester.pump();
      final art = find
          .descendant(
            of: find.byType(AnimatedBuilder),
            matching: find.byType(CustomPaint),
          )
          .last;
      final start = tester.getCenter(art);
      await tester.pump(const Duration(milliseconds: 1500));
      final right = tester.getCenter(art);
      expect(right.dx, greaterThan(start.dx + 30));
      final stage = tester.getRect(find.byType(InkWell).first);
      expect(stage.contains(tester.getBottomRight(art)), isTrue);
      await tester.pumpWidget(pet(unread: true));
      expect(tester.getCenter(art).dx, closeTo(start.dx, 0.1));
      await tester.pumpWidget(pet(still: true));
      await tester.pump();
      final reduced = tester.getCenter(art);
      await tester.pump(const Duration(milliseconds: 1400));
      expect(tester.getCenter(art), reduced);
      expect(tester.binding.transientCallbackCount, 0);
    },
  );
}
