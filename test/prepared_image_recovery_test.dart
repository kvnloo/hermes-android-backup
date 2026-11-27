import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/prepared_image_store.dart';

import 'package:hermes_android/core/widgets/prepared_image_recovery.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/strict_nextgen_gateway.dart';

class _Paths extends PathProviderPlatform {
  _Paths(this.root);
  final Directory root;
  @override
  Future<String?> getApplicationSupportPath() async => root.path;
  @override
  Future<String?> getTemporaryPath() async => root.path;
}

final fixture = SavedConnection(
  id: 'fixture',
  label: 'fixture',
  host: '127.0.0.1',
  port: 1,
  apiKey: 'synthetic-secret',
  gatewayProfile: 'fixture',
);

class _Gateway extends NextGenGateway {
  _Gateway(this.canonical) : super(fixture);
  final bool canonical;
  @override
  bool get sessionAuthority => canonical;
  final calls = <Map<String, dynamic>>[];
  bool ack = false;
  int uploads = 0;

  /// On an authority gateway the call goes through the client's guard and
  /// the strict contract check, as the real socket does.
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) => sessionAuthority
      ? strictCall(this, method, params, _answer)
      : _answer(method, params);

  Future<Map<String, dynamic>> _answer(
    String method,
    Map<String, dynamic> params,
  ) async {
    if (method == 'image.attach_bytes') {
      return {
        'attached': true,
        'path': '/fixture/${++uploads}',
        'mime': 'image/png',
      };
    }
    if (method == 'prompt.submit') {
      calls.add(Map.of(params));
      return {
        'submission_id': ack ? params['submission_id'] : 'wrong',
        'session_id': params['session_id'],
        'status': 'queued',
      };
    }
    throw StateError('unexpected method $method');
  }
}

class _SlowStore extends PreparedImageStore {
  final checks = <({String key, Completer<bool> result})>[];
  @override
  Future<bool> hasRecoverable(PreparedImageTarget target) {
    final result = Completer<bool>();
    checks.add((key: target.key, result: result));
    return result.future;
  }
}

void main() {
  final connection = fixture;
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory dir;
  late PathProviderPlatform oldPaths;
  final store = PreparedImageStore.shared;
  late PreparedImageTarget target;
  Future<AttachmentDraft> image(String name, List<int> bytes) async {
    final f = await File('${dir.path}/$name').writeAsBytes(bytes);
    return AttachmentDraft(
      id: name,
      cachedPath: f.path,
      name: 'photo.png',
      byteLength: bytes.length,
      mediaType: 'image/png',
      kind: AttachmentDraftKind.image,
      sanitized: true,
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    dir = await Directory.systemTemp.createTemp('prepared-fixture-');
    oldPaths = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _Paths(dir);
    target = PreparedImageTarget(
      connection,
      'stored',
      PreparedImageTransport.classicRefs,
    );
  });
  tearDown(() async {
    PathProviderPlatform.instance = oldPaths;
    await dir.delete(recursive: true);
  });
  Future<void> flush(WidgetTester t) async {
    for (var i = 0; i < 30; i++) {
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 2)),
      );
      await t.pump();
    }
  }

  Widget recovery({
    PreparedImageTarget? chat,
    PreparedImageStore? reader,
    Object? Function()? revision,
  }) => MaterialApp(
    home: Scaffold(
      body: PreparedImageRecovery(
        target: chat ?? target,
        store: reader ?? store,
        revision: revision ?? () => 0,
        install: (_, _) {},
      ),
    ),
  );

  for (final discard in [false, true]) {
    testWidgets(
      'journal signal shows published entry and hides after ${discard ? 'discard' : 'retire'}',
      (t) async {
        await t.pumpWidget(recovery());
        await flush(t);
        expect(find.text('Recover image draft…'), findsNothing);
        expect(t.getSize(find.byType(PreparedImageRecovery)).height, 0);
        final entry = (await t.runAsync(() async {
          final cap = await store.capture([
            await image('signal', [1, 2]),
          ]);
          return (await store.prepare(
            target,
            'signal caption',
            cap,
            prompt: 'caption',
          )).entry;
        }))!;
        await flush(t);
        expect(find.text('Recover image draft…'), findsOneWidget);
        if (discard) {
          await t.tap(find.text('Recover image draft…'));
          await flush(t);
          await t.pumpAndSettle();
          await t.tap(find.byTooltip('Discard local copy'));
          await t.pumpAndSettle();
          await t.tap(find.text('Discard'));
          await t.pumpAndSettle();
          await flush(t);
        } else {
          await t.runAsync(() => PreparedImageStore.retire(entry));
          await flush(t);
        }
        expect(find.text('Recover image draft…'), findsNothing);
        expect(t.getSize(find.byType(PreparedImageRecovery)).height, 0);
      },
    );
  }

  testWidgets('closing copy-only capture signals availability', (t) async {
    final cap = (await t.runAsync(
      () async => store.capture(
        [
          await image('copy', [3]),
        ],
        beforeUpload: (target: target, text: 'copy'),
      ),
    ))!;
    await t.pumpWidget(recovery());
    await flush(t);
    expect(find.byType(TextButton), findsNothing);
    await t.runAsync(cap.close);
    await flush(t);
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets(
    'target switch hides an existing draft and ignores old slow result',
    (t) async {
      final slow = _SlowStore();
      final other = PreparedImageTarget(connection, 'empty', target.transport);
      await t.pumpWidget(recovery(reader: slow));
      slow.checks.last.result.complete(true);
      await t.pump();
      expect(find.byType(TextButton), findsOneWidget);
      PreparedImageStore.changes.value++;
      final old = slow.checks.last.result;
      await t.pumpWidget(recovery(chat: other, reader: slow));
      expect(find.byType(TextButton), findsNothing);
      slow.checks.last.result.complete(false);
      await t.pump();
      old.complete(true);
      await t.pump();
      expect(find.byType(TextButton), findsNothing);
    },
  );

  testWidgets('checks revision values and store replacement, not rebuilds', (
    t,
  ) async {
    final slow = _SlowStore();
    var revision = 0;
    await t.pumpWidget(recovery(reader: slow, revision: () => revision));
    slow.checks.last.result.complete(false);
    await t.pump();
    await t.pumpWidget(recovery(reader: slow, revision: () => revision));
    expect(slow.checks, hasLength(1));
    revision++;
    await t.pumpWidget(recovery(reader: slow, revision: () => revision));
    expect(slow.checks, hasLength(2));
    final replacement = _SlowStore();
    await t.pumpWidget(recovery(reader: replacement, revision: () => revision));
    replacement.checks.single.result.complete(false);
    slow.checks.last.result.complete(true);
    await t.pump();
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('corrupt manifest or unreadable scope offers no recovery', (
    t,
  ) async {
    await t.runAsync(() async {
      final cap = await store.capture([
        await image('corrupt', [1]),
      ]);
      await store.prepare(target, 'caption', cap, prompt: 'caption');
      final manifest =
          await dir
                  .list(recursive: true)
                  .where((f) => f.path.endsWith('entry.json'))
                  .single
              as File;
      await manifest.writeAsString('{broken');
    });
    await t.pumpWidget(recovery());
    await flush(t);
    expect(find.byType(TextButton), findsNothing);
    await t.pumpWidget(
      recovery(
        reader: PreparedImageStore(
          support: () async => throw const FileSystemException('unreadable'),
        ),
      ),
    );
    await flush(t);
    expect(find.byType(TextButton), findsNothing);
  });

  test(
    'only explicitly restored, unchanged occurrences can adopt frozen refs',
    () async {
      final a = await image('a', [1, 2]), b = await image('b', [3, 4]);
      final snap = await store.capture([a, b]);
      await File(a.cachedPath).writeAsBytes([9, 9]);
      const prompt = 'caption\n\n@file:/one\n@file:/two';
      final prepared = await store.prepare(
        target,
        ' caption ',
        snap,
        prompt: prompt,
      );
      await snap.close();
      await File(b.cachedPath).delete();
      final fresh = PreparedImageStore();
      final entry = (await fresh.list(target)).single;
      expect(entry.id, prepared.id);
      expect(entry.prompt, prompt);
      final drafts = (await fresh.restore(entry, () => true))!;
      expect(await File(drafts.first.cachedPath).readAsBytes(), [1, 2]);
      expect(await File(drafts.last.cachedPath).readAsBytes(), [3, 4]);
      expect((await fresh.adopt(target, ' caption ', drafts))!.id, entry.id);
      expect(await fresh.adopt(target, 'caption', drafts), isNull);
      expect(
        await fresh.adopt(target, entry.text, drafts.reversed.toList()),
        isNull,
      );
      expect(
        await fresh.adopt(target, entry.text, [drafts[0], drafts[0]]),
        isNull,
      );
      expect(await fresh.adopt(target, entry.text, [a, b]), isNull);
      await File(drafts[0].cachedPath).writeAsBytes([2, 1]);
      expect(await fresh.adopt(target, entry.text, drafts), isNull);
      for (final other in [
        PreparedImageTarget(
          connection.copyWith(apiKey: 'another-secret'),
          'stored',
          target.transport,
        ),
        PreparedImageTarget(
          connection.copyWith(gatewayProfile: 'other'),
          'stored',
          target.transport,
        ),
        PreparedImageTarget(connection, 'other', target.transport),
        PreparedImageTarget(
          connection,
          'stored',
          PreparedImageTransport.nextgenCanonical,
        ),
      ]) {
        expect(await fresh.list(other), isEmpty);
        await expectLater(
          fresh.adopt(other, entry.text, drafts),
          throwsA(isA<PreparedImageException>()),
        );
      }
      final manifest =
          await dir
                  .list(recursive: true)
                  .where((f) => f.path.endsWith('entry.json'))
                  .single
              as File;
      expect(
        await manifest.readAsString(),
        isNot(contains('synthetic-secret')),
      );
      expect(manifest.path, isNot(contains('synthetic-secret')));
      await expectLater(
        prepared.receipt({
          'submission_id': entry.id,
          'session_id': 'other',
          'status': 'queued',
        }, 'rt'),
        throwsA(isA<PreparedImageException>()),
      );
      expect(await fresh.list(target), hasLength(1));
      final receipt = {
        // The canonical server mints this independently of submission_id.
        'admission_id': 'host-generated-not-the-request-uuid',
        'ref': {'session_id': 'rt', 'profile_id': '/fixture/work'},
        'sequence': 11, 'authority_epoch': 7, 'execution_generation': null,
        'status': 'queued', 'outcome': null,
      };
      await expectLater(
        prepared.receipt(receipt, 'another'),
        throwsA(isA<PreparedImageException>()),
      );
      expect(await fresh.list(target), hasLength(1));
      await prepared.receipt(receipt, 'rt');
      expect(await fresh.list(target), isEmpty);
    },
  );
  test(
    'upload interrupted before submit retains caption and original bytes as a copy, not a replay',
    () async {
      final draft = await image('interrupted', [3, 2, 1]);
      final capture = await store.capture(
        [draft],
        beforeUpload: (target: target, text: 'caption before upload'),
      );
      expect(
        await store.list(target),
        isEmpty,
      ); // Producer still owns the upload.
      await File(draft.cachedPath).delete();
      await capture.close();
      final reopened = PreparedImageStore();
      final entry = (await reopened.list(target)).single;
      expect(entry.copyOnly, isTrue);
      expect(entry.text, 'caption before upload');
      final recovered = (await reopened.restore(entry, () => true))!;
      expect(await File(recovered.single.cachedPath).readAsBytes(), [3, 2, 1]);
      expect(await reopened.adopt(target, entry.text, recovered), isNull);
    },
  );
  test('identityless fallback is durably copy-only before its write', () async {
    final snap = await store.capture([
      await image('a', [1]),
    ]);
    final attempt = await store.prepare(
      target,
      'one',
      snap,
      prompt: 'one\n@file',
    );
    final drafts = (await store.restore(attempt.entry, () => true))!;
    final adopted = (await store.adopt(target, 'one', drafts))!;
    await expectLater(
      adopted.beforeLegacy(),
      throwsA(isA<PreparedImageException>()),
    );
    await attempt.beforeLegacy();
    final entry = (await PreparedImageStore().list(target)).single;
    expect(entry.copyOnly, isTrue);
    expect(
      await store.adopt(
        target,
        'one',
        (await store.restore(entry, () => true))!,
      ),
      isNull,
    );
    await expectLater(
      store.adopt(target, 'one', drafts),
      throwsA(isA<PreparedImageException>()),
    );
  });
  for (final canonical in [true, false]) {
    test(
      'NextGen sends retained identity and correct image transport (canonical=$canonical)',
      () async {
        final g = _Gateway(canonical);
        final chat = NgChatController(g, sessionId: 'stored')..runtimeId = 'rt';
        addTearDown(() {
          chat.dispose();
          g.dispose();
        });
        final original = await image('a', [1, 2, 3]);
        final sent = await chat.send(
          'caption',
          composerImageText: ' caption ',
          attachments: [original],
        );
        expect(sent, isFalse);
        expect(g.uploads, 1);
        expect(g.calls, hasLength(1));
        final entry = (await store.list(chat.imageTarget!)).single;
        expect(entry.id, g.calls.single['submission_id']);
        expect(entry.copyOnly, !canonical);
        expect(await File(original.cachedPath).exists(), isFalse);
        final removed = await store.restore(entry, () => false);
        expect(removed, isNull);
        final copies = (await store.restore(entry, () => true))!;
        expect(g.calls, hasLength(1));
        await chat.retryLast();
        expect(g.calls, hasLength(1));
        g.ack = true;
        expect(
          await chat.send(
            'caption',
            composerImageText: entry.text,
            attachments: copies,
          ),
          isTrue,
        );
        expect(g.calls, hasLength(2));
        if (canonical) {
          expect(g.uploads, 1);
          expect(g.calls[1], g.calls[0]);
          expect(g.calls[0]['attachments'], [
            {'path': '/fixture/1', 'mime': 'image/png'},
          ]);
          expect(await store.list(chat.imageTarget!), isEmpty);
        } else {
          expect(g.uploads, 2);
          expect(g.calls[1]['submission_id'], isNot(entry.id));
          expect(g.calls[1].containsKey('attachments'), isFalse);
          expect((await store.list(chat.imageTarget!)).single.id, entry.id);
        }
      },
    );
  }
  testWidgets(
    'gesture restore refuses edit-then-clear while disk read is held',
    (tester) async {
      final gate = Completer<Directory>();
      final reader = PreparedImageStore(cache: () => gate.future);
      final entry = (await tester.runAsync(() async {
        final snap = await store.capture([
          await image('a', [1, 2, 3]),
        ]);
        return (await store.prepare(
          target,
          'caption',
          snap,
          prompt: 'caption',
        )).entry;
      }))!;
      int revision = 0, installed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PreparedImageRecovery(
              target: target,
              store: reader,
              revision: () => revision,
              install: (text, drafts) {
                installed++;
              },
            ),
          ),
        ),
      );
      Future<void> waitFor(Finder finder) async {
        for (var i = 0; i < 100 && finder.evaluate().isEmpty; i++) {
          await tester.pump(const Duration(milliseconds: 20));
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 2)),
          );
        }
        expect(finder, findsOneWidget);
      }

      expect(installed, 0);
      await waitFor(find.byType(TextButton));
      await tester.tap(find.byType(TextButton));
      await waitFor(find.text('caption'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('caption'));
      await tester.pumpAndSettle();
      revision += 2;
      gate.complete(dir);
      await tester.pumpAndSettle();
      expect(installed, 0);
      expect(
        await tester.runAsync(
          () => store.list(target).then((v) => v.single.id),
        ),
        entry.id,
      );
    },
  );
}
