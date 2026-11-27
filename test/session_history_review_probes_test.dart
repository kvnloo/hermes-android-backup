// The independent review's history-page probes (review of 172cfd30, R2-R9)
// and the gaps it listed, kept as permanent regressions. Each asserts the
// behaviour the review expected and failed on 172cfd30.
//
//  R2  a redacted export of a transcript with benign code succeeds
//  R3  a saved row that mentions "secret: ..." stays in the list
//  R4  a foreign preview with an already-redacted header opens
//  R5  the default checkpoint restore sends no `all`; the opt-in sends it,
//      the confirm says what is reverted, Restore waits for the diff
//  R7  the page is localised (de)
//  R8  320x640 at text x2.0: no overflow
//  R9  Export saves a FILE: a save dialog on desktop, a shared file on
//      Android/iOS, never megabytes of text in a share sheet
//  gaps: pre-0.23 sidecars, an authority without Claude/Codex import, the
//      chat refresh after a restore, the spinner when the owner closes
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/transcript_export_io.dart';
import 'package:hermes_android/core/widgets/session_history_page.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'support/fake_authority_gateway.dart';
import 'support/fake_history_owner.dart';

const _session = FakeHistoryBackend.session;

Future<WorkspaceTarget> _bind(FakeHistoryBackend backend) =>
    backend.owner.pane().bind(backend.owner.route(storedSessionId: _session));

Widget _page(
  FakeHistoryBackend backend, {
  Locale? locale,
  double textScale = 1,
  VoidCallback? onRestored,
  TranscriptExportSaver? saveExport,
}) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: SessionHistoryPage(
    owner: backend.owner,
    storedSessionId: _session,
    onRestored: onRestored,
    saveExport: saveExport ?? (_) async => TranscriptExportOutcome.saved,
  ),
);

Future<void> _settle(WidgetTester tester, [int rounds = 20]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  }
}

Future<void> _tap(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await _settle(tester);
}

bool _enabled(WidgetTester tester, String key) =>
    tester.widget<ButtonStyleButton>(find.byKey(ValueKey(key))).onPressed !=
    null;

List<Map<String, dynamic>> _restores(FakeHistoryBackend backend) =>
    backend.restores;

class _Paths extends PathProviderPlatform {
  _Paths(this.dir);
  final Directory dir;
  @override
  Future<String?> getTemporaryPath() async => dir.path;
}

class _SavePicker extends FilePicker {
  final saves = <({String? fileName, Uint8List? bytes})>[];
  String? answer;

  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) async {
    saves.add((fileName: fileName, bytes: bytes));
    return answer;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('R2 a redacted export succeeds for a transcript the gateway already '
      'redacted (benign code is not a secret)', () async {
    final backend = FakeHistoryBackend()
      ..exportContent =
          '# Chat\n\n```python\napi_key = os.environ["OPENAI_API_KEY"]\n```\n'
          'api_key=***\n';
    addTearDown(backend.close);
    final target = await _bind(backend);
    final exported = await target.exportTranscript(format: 'md', redact: true);
    expect(exported.content, backend.exportContent);
  });

  test(
    'R3 a saved user row mentioning "secret: ..." stays branchable',
    () async {
      final backend = FakeHistoryBackend()
        ..historyRows = [
          {'row_id': 7, 'role': 'user', 'text': 'Keep this'},
          {
            'row_id': 9,
            'role': 'user',
            'text': 'The secret: rotate-weekly-please is our policy',
          },
        ];
      addTearDown(backend.close);
      final rows = await (await _bind(backend)).transcript();
      expect(rows.map((row) => row.rowId), [7, 9]);
      expect(rows.last.text, 'The secret: rotate-weekly-please is our policy');
    },
  );

  test('R4 a foreign preview with an Authorization header opens', () async {
    final backend = FakeHistoryBackend()
      ..previewRows = [
        {'role': 'user', 'content': 'curl -H "Authorization: Bearer ***"'},
        {
          'role': 'assistant',
          'content': 'Authorization: Bearer abcdef0123456789',
        },
      ];
    addTearDown(backend.close);
    final preview = await (await _bind(
      backend,
    )).previewForeign(FakeHistoryBackend.claudeHandle);
    expect(preview.messages.first.text, 'curl -H "Authorization: Bearer ***"');
    expect(preview.messages.last.text, 'Authorization: Bearer [redacted]');
  });

  testWidgets('R5 checkpoint restore: disabled until the diff has loaded, '
      'the default sends no `all`, and the opt-in sends all:true with a '
      'confirm that says the user\'s edits are reverted', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend()..restoreRemoves = 0;
    addTearDown(backend.close);
    await tester.pumpWidget(_page(backend));
    await _settle(tester);

    expect(_enabled(tester, 'history-restore'), isFalse);
    final checkbox = tester.widget<CheckboxListTile>(
      find.byKey(const ValueKey('history-restore-own-edits')),
    );
    expect(checkbox.value, isFalse, reason: 'opt-in, off by default');

    // The diff is still loading: Restore stays disabled.
    final hold = Completer<void>();
    backend.holdRpc = hold.future;
    await tester.ensureVisible(
      find.byKey(const ValueKey('history-checkpoint-abc1234')),
    );
    await tester.tap(find.byKey(const ValueKey('history-checkpoint-abc1234')));
    await tester.pump();
    expect(find.byKey(const ValueKey('history-diff-loading')), findsOneWidget);
    expect(_enabled(tester, 'history-restore'), isFalse);
    backend.holdRpc = null;
    hold.complete();
    await _settle(tester);
    expect(find.byKey(const ValueKey('history-diff')), findsOneWidget);
    expect(_enabled(tester, 'history-restore'), isTrue);

    await _tap(tester, 'history-restore');
    expect(
      find.textContaining('Changes you made yourself are kept.'),
      findsOneWidget,
    );
    await _tap(tester, 'history-confirm');
    expect(_restores(backend).single.containsKey('all'), isFalse);
    expect(_restores(backend).single['hash'], 'abc1234');

    await _tap(tester, 'history-restore-own-edits');
    await _tap(tester, 'history-restore');
    expect(
      find.textContaining('including changes you made yourself'),
      findsOneWidget,
    );
    await _tap(tester, 'history-confirm');
    expect(_restores(backend).last['all'], isTrue);
  });

  testWidgets('R5 a diff that failed to load keeps Restore disabled and '
      'says why', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend()..diffFails = true;
    addTearDown(backend.close);
    await tester.pumpWidget(_page(backend));
    await _settle(tester);
    await _tap(tester, 'history-checkpoint-abc1234');
    expect(find.byKey(const ValueKey('history-diff-failed')), findsOneWidget);
    expect(_enabled(tester, 'history-restore'), isFalse);
    expect(_restores(backend), isEmpty);
  });

  testWidgets('R7 the history page is localised (de), and failures are '
      'sentences, never a raw enum', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 3200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend();
    addTearDown(backend.close);
    await tester.pumpWidget(_page(backend, locale: const Locale('de')));
    await _settle(tester);
    for (final english in const [
      'Lineage',
      'Related chats',
      'Messages',
      'Select a saved message to branch or rewind there.',
      'Branch from here',
      'Rewind to here',
      'Checkpoints',
      'Restore checkpoint',
      'Also revert my own edits',
      'Export',
      'Redact tokens',
      'Export transcript',
      'Import selected session',
      'All',
      'Parent',
      'user',
      'assistant',
    ]) {
      expect(find.text(english), findsNothing, reason: english);
    }
    expect(find.text('Verwandte Chats'), findsOneWidget);
    expect(find.text('Hier abzweigen'), findsOneWidget);
    expect(find.text('Sicherungspunkt wiederherstellen'), findsOneWidget);
    expect(find.text('Transkript exportieren'), findsOneWidget);

    // A confirm in German, then a refused branch as a German sentence.
    await _tap(tester, 'history-message-7');
    await _tap(tester, 'history-branch');
    expect(find.text('Von dieser Nachricht abzweigen'), findsOneWidget);
    backend.mutateFails = true; // the gateway refuses the branch
    await _tap(tester, 'history-confirm');
    final error = tester.widget<Text>(
      find.byKey(const ValueKey('history-error')),
    );
    for (final raw in const ['unavailable', 'mismatch', 'invalid', 'stale']) {
      expect(error.data, isNot(contains(raw)), reason: raw);
    }
    expect(error.data, startsWith('Nicht abgeschlossen: '));
  });

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('every history page string exists in $locale', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      final english = lookupAppLocalizations(const Locale('en'));
      String Function(AppLocalizations) pick(
        String Function(AppLocalizations) read,
      ) => read;
      final strings = [
        pick((l) => l.history_lineage),
        pick((l) => l.history_messages_hint),
        pick((l) => l.history_branch_body),
        pick((l) => l.history_rewind_body),
        pick((l) => l.history_restore_body),
        pick((l) => l.history_restore_body_all),
        pick((l) => l.history_restore_own_edits),
        pick((l) => l.history_export_action),
        pick((l) => l.history_import_unsupported),
        pick((l) => l.history_mutate_unsupported),
        pick((l) => l.history_error_unavailable),
        pick((l) => l.rewind_target_unsaved),
        pick((l) => l.rewind_turn_busy),
        pick((l) => l.edit_turn_later_turns_body),
      ];
      for (final read in strings) {
        expect(read(l10n).trim(), isNotEmpty);
        if (locale.languageCode != 'en') {
          expect(read(l10n), isNot(read(english)), reason: read(english));
        }
      }
    });
  }

  testWidgets('R8 the history page at 320x640, text x2.0: no overflow', (
    tester,
  ) async {
    final backend = FakeHistoryBackend();
    addTearDown(backend.close);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.reset);
    final errors = <String>[];
    final old = FlutterError.onError;
    FlutterError.onError = (details) => errors.add(details.exceptionAsString());
    addTearDown(() => FlutterError.onError = old);
    await tester.pumpWidget(_page(backend, textScale: 2.0));
    await _settle(tester);
    for (var i = 0; i < 40; i++) {
      await tester.drag(
        find.byKey(const ValueKey('history-scroll')),
        const Offset(0, -200),
      );
      await tester.pump();
    }
    FlutterError.onError = old;
    expect(errors.where((error) => error.contains('overflowed')), isEmpty);
  });

  testWidgets('R9 Export hands the page\'s saver a FILE (name, format, '
      'content) and never opens the share sheet with text', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend()..exportContent = 'x' * 1024;
    addTearDown(backend.close);
    final shares = <MethodCall>[];
    const channel = MethodChannel('dev.fluttercommunity.plus/share');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      shares.add(call);
      return 'dev.fluttercommunity.plus/share/unavailable';
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    final saved = <HistoryExport>[];
    await tester.pumpWidget(
      _page(
        backend,
        saveExport: (export) async {
          saved.add(export);
          return TranscriptExportOutcome.saved;
        },
      ),
    );
    await _settle(tester);
    await _tap(tester, 'history-export');

    expect(saved.single.filename, 'transcript.md');
    expect(saved.single.content, 'x' * 1024);
    expect(shares, isEmpty, reason: 'no text share');
    expect(find.text('Transcript saved.'), findsOneWidget);
  });

  group('R9 saveTranscriptExport', () {
    const export = HistoryExport(
      format: 'md',
      filename: 'transcript.md',
      content: '# Chat\n\nhello\n',
    );

    test('desktop: a save dialog with the file name; the file is written '
        '(Linux writes it itself), nothing is shared', () async {
      final dir = await Directory.systemTemp.createTemp('export-save-');
      addTearDown(() => dir.delete(recursive: true));
      final shares = <MethodCall>[];
      const channel = MethodChannel('dev.fluttercommunity.plus/share');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            shares.add(call);
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      final picker = _SavePicker();
      FilePicker.platform = picker;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      picker.answer = '${dir.path}/chosen.md';
      expect(await saveTranscriptExport(export), TranscriptExportOutcome.saved);
      expect(picker.saves.single.fileName, 'transcript.md');
      expect(utf8.decode(picker.saves.single.bytes!), export.content);

      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      expect(await saveTranscriptExport(export), TranscriptExportOutcome.saved);
      expect(picker.saves.last.bytes, isNull);
      expect(File('${dir.path}/chosen.md').readAsStringSync(), export.content);

      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      picker.answer = null;
      expect(
        await saveTranscriptExport(export),
        TranscriptExportOutcome.cancelled,
      );
      expect(shares, isEmpty);
      debugDefaultTargetPlatformOverride = null;
    });

    test('Android and iOS: shared as a file from the app cache, with no '
        'text payload, and the file is deleted afterwards', () async {
      final dir = await Directory.systemTemp.createTemp('export-share-');
      addTearDown(() => dir.delete(recursive: true));
      final paths = PathProviderPlatform.instance;
      PathProviderPlatform.instance = _Paths(dir);
      addTearDown(() => PathProviderPlatform.instance = paths);
      final shares = <Map<dynamic, dynamic>>[];
      String? sharedContent;
      const channel = MethodChannel('dev.fluttercommunity.plus/share');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            final args = call.arguments as Map;
            shares.add(args);
            final path = (args['paths'] as List).single as String;
            sharedContent = File(path).readAsStringSync();
            return 'com.example/receiver';
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
        debugDefaultTargetPlatformOverride = platform;
        shares.clear();
        expect(
          await saveTranscriptExport(export),
          TranscriptExportOutcome.shared,
        );
        final args = shares.single;
        expect(args['text'], anyOf(isNull, isEmpty));
        final path = (args['paths'] as List).single as String;
        expect(path, startsWith(dir.path));
        expect(path, endsWith('/transcript.md'));
        expect(sharedContent, export.content);
        expect(File(path).existsSync(), isFalse, reason: 'deleted afterwards');
      }
      debugDefaultTargetPlatformOverride = null;
    });
  });

  group('pre-0.23 sidecar (no session authority)', () {
    testWidgets('history uses the runtime session id, branch/rewind and '
        'export are replaced by an honest reason, and Claude/Codex import '
        'stays reachable', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 3200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final backend = FakeHistoryBackend(
        sessionAuthority: false,
        runtimeSessionId: 'runtime-7',
      );
      addTearDown(backend.close);
      await tester.pumpWidget(_page(backend));
      await _settle(tester);

      expect(find.byKey(const ValueKey('history-error')), findsNothing);
      for (final method in const ['session.history', 'rollback.list']) {
        final call = backend.rpcCalls.firstWhere((c) => c.method == method);
        expect(call.params['session_id'], 'runtime-7', reason: method);
      }
      expect(find.byKey(const ValueKey('history-message-7')), findsOneWidget);
      expect(find.byKey(const ValueKey('history-branch')), findsNothing);
      expect(find.byKey(const ValueKey('history-rewind')), findsNothing);
      expect(
        find.text(
          'Branch and rewind need Hermes 0.23 or newer on this gateway.',
        ),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('history-export')), findsNothing);
      expect(
        find.text('Export needs Hermes 0.23 or newer on this gateway.'),
        findsOneWidget,
      );
      expect(
        backend.rpcCalls.map((c) => c.method),
        isNot(anyOf(contains('session.mutate'), contains('session.export'))),
      );
      // Import still works for this saved chat.
      await _tap(tester, 'history-foreign-${FakeHistoryBackend.claudeHandle}');
      expect(_enabled(tester, 'history-import-host'), isTrue);
    });

    test('a saved chat that is not live on the socket says so instead of '
        'sending the stored id to a sidecar that does not know it', () async {
      final backend = FakeHistoryBackend(sessionAuthority: false);
      addTearDown(backend.close);
      final target = await _bind(backend);
      await expectLater(
        target.transcript(),
        throwsA(
          isA<WorkspaceException>().having(
            (e) => e.reason,
            'reason',
            WorkspaceFailure.unbound,
          ),
        ),
      );
      expect(backend.rpcCalls, isEmpty);
      await expectLater(
        target.exportTranscript(format: 'md', redact: true),
        throwsA(
          isA<WorkspaceException>().having(
            (e) => e.reason,
            'reason',
            WorkspaceFailure.unsupported,
          ),
        ),
      );
    });
  });

  testWidgets('a session authority with no Claude/Codex import handler: the '
      'rest of the page works, the import says it is not supported, and '
      'Rewind is the fenced mutation alone', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 3200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    // The strict canonical fake: session.foreign.* and rollback.* have no
    // handler there (-32601), and session.list carries no lineage.
    final gateway = FakeAuthorityGateway(
      sessionId: _session,
      cwd: FakeHistoryBackend.cwd,
    );
    final rest = FakeHistoryBackend();
    addTearDown(rest.close);
    final socket = await gateway.connect(baseUrl: rest.dashboard.baseUrl);
    final owner = RemoteWorkspaceOwner(
      connectionId: 'authority-page',
      expectedBaseUrl: rest.dashboard.baseUrl,
      profile: gateway.profile,
      dashboard: rest.dashboard,
      connect: () async => socket,
      ownsSocket: (candidate) => identical(candidate, socket),
    );
    addTearDown(owner.close);
    rest
      ..revision = gateway.revision
      ..generation = gateway.generation;
    String? rewound;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => SessionHistoryPage(
              owner: owner,
              storedSessionId: _session,
              onRewound: (text) => rewound = text,
            ),
          ),
        ),
      ),
    );
    await _settle(tester);

    expect(find.byKey(const ValueKey('history-error')), findsNothing);
    expect(
      find.text('Claude and Codex import is not supported by this gateway.'),
      findsOneWidget,
    );
    expect(
      find.text('Checkpoints are not available on this gateway.'),
      findsOneWidget,
    );
    // Lineage came from the REST rows, not the canonical session.list.
    expect(gateway.calls('session.list'), isEmpty);
    expect(
      find.byKey(const ValueKey('history-lineage-parent-parent')),
      findsOneWidget,
    );

    await _tap(tester, 'history-message-9');
    await _tap(tester, 'history-rewind');
    await _tap(tester, 'history-confirm');
    const cutAndSend = {'session.mutate', 'prompt.submit', 'session.rewind'};
    expect(gateway.methods.where(cutAndSend.contains), ['session.mutate']);
    expect(
      gateway.refusals.where((r) => cutAndSend.contains(r.method)),
      isEmpty,
    );
    final cut = gateway.calls('session.mutate').single.params;
    expect(cut['operation'], 'rewind');
    expect(cut['payload'], {'target_message_id': 9});
    expect(
      [for (final row in gateway.rows) row['text']],
      ['Keep this', 'Noted'],
    );
    expect(rewound, 'Another question');
  });

  testWidgets('a restore that removed messages tells the chat to refresh; '
      'one that removed none does not', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final backend = FakeHistoryBackend()..restoreRemoves = 0;
    addTearDown(backend.close);
    var refreshes = 0;
    await tester.pumpWidget(_page(backend, onRestored: () => refreshes++));
    await _settle(tester);
    await _tap(tester, 'history-checkpoint-abc1234');
    await _tap(tester, 'history-restore');
    await _tap(tester, 'history-confirm');
    expect(refreshes, 0);
    expect(find.text('Checkpoint restored.'), findsOneWidget);

    backend.restoreRemoves = 2;
    await _tap(tester, 'history-checkpoint-abc1234');
    await _tap(tester, 'history-restore');
    await _tap(tester, 'history-confirm');
    expect(refreshes, 1);
    expect(
      find.text('Checkpoint restored. 2 chat messages were removed.'),
      findsOneWidget,
    );
  });

  testWidgets('the spinner is cleared when the owner closes during the '
      'first load', (tester) async {
    final backend = FakeHistoryBackend();
    final hold = Completer<void>();
    backend.holdRpc = hold.future;
    await tester.pumpWidget(_page(backend));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    backend.close();
    hold.complete();
    await _settle(tester);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(const ValueKey('history-error')), findsOneWidget);
  });
}
