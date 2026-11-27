// NextGen composer intake (from the c830319a re-check's probes, NR1-NR8).
// Intake races at 9 drafts: drop + Ctrl+V, Attach picker + drop, keyboard
// image insertion + drop; a failed prepare releases its slot; the queue
// survives an exception; a chat switch mid-intake never stages a draft in
// the other chat, keyed remount or not (NR6: the intake belongs to the chat
// it started in); the send refuses > maxRemoteAttachmentDrafts.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/os_intake.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/services/attachment_draft_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:image/image.dart' as image_lib;
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/native_windows_clipboard_fixture.dart';

const _fieldKey = ValueKey('ng-composer-field');

SavedConnection _connection() => SavedConnection(
  id: 'ng-race',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: '',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
  dashboardProxied: true,
  gatewayProfile: 'work',
);

class _Call {
  const _Call(this.method, this.params);
  final String method;
  final Map<String, dynamic> params;
}

class _Gateway extends NextGenGateway {
  _Gateway(DashboardClient dashboard)
    : super(_connection(), dashboard: dashboard);
  final calls = <_Call>[];
  WsClient current = WsClient('http://10.0.0.5:9119');
  @override
  WsClient? get socket => current;
  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);
  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => current;
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    calls.add(_Call(method, Map<String, dynamic>.of(params)));
    switch (method) {
      case 'commands.catalog':
        return {'pairs': const <Object>[]};
      case 'file.attach':
        return {'attached': true, 'ref_text': '@file:/up/${params['name']}'};
      case 'prompt.submit':
        return {'status': 'started'};
    }
    return const {};
  }

  List<_Call> of(String method) =>
      calls.where((c) => c.method == method).toList();
}

class _Paths extends PathProviderPlatform {
  _Paths(this.dir);
  final Directory dir;
  @override
  Future<String?> getTemporaryPath() async => dir.path;
}

class _Picker extends FilePicker {
  _Picker(this.files, {this.gate});
  final List<PlatformFile> files;
  final Completer<void>? gate;
  int calls = 0;
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
    calls++;
    if (gate != null) await gate!.future;
    return FilePickerResult(files);
  }
}

/// Swappable chat owner, as main_page keys NgChatView by its controller.
class _Host extends StatefulWidget {
  const _Host({required this.chat, required this.keyed});
  final ValueNotifier<NgChatController> chat;
  final bool keyed;
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: widget.chat,
    builder: (context, chat, _) => NgChatView(
      key: widget.keyed ? ObjectKey(chat) : null,
      chat: chat,
      onOpenSidebar: () {},
      onNewChat: () {},
    ),
  );
}

Widget _app(
  _Gateway g,
  ValueNotifier<NgChatController> chat,
  ConnectionManager m, {
  bool keyed = true,
}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
  home: NgScope(
    connManager: m,
    gateway: g,
    connections: [g.connection],
    switchTo: (_) async {},
    addGateway: () async {},
    signOut: (_) async {},
    reload: () async {},
    signInAgain: () async {},
    child: Scaffold(
      body: _Host(chat: chat, keyed: keyed),
    ),
  ),
);

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

Future<void> _drain(WidgetTester tester, {bool Function()? done}) async {
  var quiet = 0;
  for (var i = 0; i < 400 && quiet < 4; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
    if (done == null ? i >= 20 : done()) quiet++;
  }
}

List<String> _chips() => [
  for (final chip in find.byType(InputChip).evaluate())
    ((((chip.widget as InputChip).label as ConstrainedBox).child!) as Text)
        .data!,
];

String _composer(WidgetTester tester) =>
    tester.widget<TextField>(find.byKey(_fieldKey)).controller!.text;

void _log(String s) {
  // ignore: avoid_print
  print(s);
}

void main() {
  late Directory root;
  late PathProviderPlatform previousPaths;
  late Uint8List png;
  ClipboardAttachment? clip;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    NextGenLook.instance
      ..themeMode = ThemeMode.dark
      ..accent = NgAccent.blue
      ..pureBlack = false
      ..glow = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, (_) async => null);
    root = Directory.systemTemp.createTempSync('ng-race');
    previousPaths = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _Paths(root);
    png = image_lib.encodePng(image_lib.Image(width: 4, height: 4));
    clip = null;
    debugClipboardAttachmentReader = () async => clip;
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.textInput, null);
    PathProviderPlatform.instance = previousPaths;
    debugClipboardAttachmentReader = null;
    FilePicker.platform = _Picker(const []);
    try {
      root.deleteSync(recursive: true);
    } catch (_) {}
  });

  List<OsIntakeFile> make(int count, String prefix) => [
    for (var i = 0; i < count; i++)
      OsIntakeFile(
        (File('${root.path}/$prefix$i.txt')..writeAsStringSync('n$i')).path,
      ),
  ];

  Future<({_Gateway gateway, ValueNotifier<NgChatController> chat})> pump(
    WidgetTester tester, {
    bool keyed = true,
  }) async {
    tester.view.physicalSize = const Size(4000, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final prefs = await SharedPreferences.getInstance();
    final httpClient = MockClient(
      (request) async => http.Response(
        jsonEncode({'messages': const <Object>[]}),
        200,
        headers: {'content-type': 'application/json'},
      ),
    );
    final gateway = _Gateway(
      DashboardClient(host: '10.0.0.5', proxied: true, httpClient: httpClient),
    );
    final chat = NgChatController(gateway, sessionId: 'stored-1')
      ..runtimeId = 'rt-1';
    final holder = ValueNotifier(chat);
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    await tester.pumpWidget(
      _app(gateway, holder, ConnectionManager(prefs), keyed: keyed),
    );
    await tester.pump(const Duration(milliseconds: 300));
    return (gateway: gateway, chat: holder);
  }

  OsFileDropTarget target(WidgetTester tester) =>
      tester.widget<OsFileDropTarget>(find.byType(OsFileDropTarget));

  Future<void> nine(WidgetTester tester) async {
    target(tester).onFiles(make(maxRemoteAttachmentDrafts - 1, 'base'));
    await _drain(
      tester,
      done: () => _chips().length >= maxRemoteAttachmentDrafts - 1,
    );
    expect(_chips(), hasLength(maxRemoteAttachmentDrafts - 1));
  }

  Future<void> ctrlV(WidgetTester tester) async {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  }

  void insertImage(WidgetTester tester, Uint8List bytes) {
    final field = tester.widget<TextField>(find.byKey(_fieldKey));
    field.contentInsertionConfiguration!.onContentInserted(
      KeyboardInsertedContent(
        mimeType: 'image/png',
        uri: 'content://keyboard/sticker.png',
        data: bytes,
      ),
    );
  }

  testWidgets(
    'desktop focused paste appends bitmap and multiple image files; toolbar shares intake',
    (tester) async {
      useNativeWindowsClipboardFixture(
        root: root,
        current: () => clip,
        screenshotToken: png,
      );
      final env = await pump(tester, keyed: false);
      final field = find.byKey(_fieldKey);
      await tester.enterText(field, 'preserved text');
      target(tester).onFiles(make(1, 'existing'));
      await _drain(tester);
      Future<void> keyboardPaste() async {
        await tester.showKeyboard(field);
        final modifier = defaultTargetPlatform == TargetPlatform.macOS
            ? LogicalKeyboardKey.metaLeft
            : LogicalKeyboardKey.controlLeft;
        await tester.sendKeyDownEvent(modifier);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
        await tester.sendKeyUpEvent(modifier);
        await _drain(tester);
      }

      clip = ClipboardAttachment(image: png);
      await keyboardPaste();
      await keyboardPaste();
      expect(_chips().length, 3);
      final a = File('${root.path}/copied-a.png')..writeAsBytesSync(png);
      final b = File('${root.path}/copied-b.png')..writeAsBytesSync(png);
      clip = ClipboardAttachment(files: [a.path, b.path]);
      await keyboardPaste();
      expect(_chips().length, 5);
      clip = ClipboardAttachment(image: png);
      // No text on the clipboard: Flutter normally omits the Paste item.
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.hasStrings') return {'value': false};
          return null;
        },
      );
      await tester.tapAt(
        tester.getTopLeft(field) + const Offset(20, 20),
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryMouseButton,
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Paste'), findsOneWidget);
      await tester.tap(find.text('Paste'));
      await _drain(tester);
      expect(_chips().length, 6);
      clip = ClipboardAttachment(image: Uint8List.fromList([1, 2, 3]));
      await keyboardPaste();
      expect(_chips().length, 6, reason: 'unsupported bitmap must be rejected');
      clip = ClipboardAttachment(files: [a.path, b.path, a.path, b.path]);
      await keyboardPaste();
      await _drain(
        tester,
        done: () => _chips().length == maxRemoteAttachmentDrafts,
      );
      expect(_chips().length, maxRemoteAttachmentDrafts);
      clip = ClipboardAttachment(image: png);
      await keyboardPaste();
      expect(
        _chips().length,
        maxRemoteAttachmentDrafts,
        reason: 'paste respects the shared cap',
      );
      expect(
        tester.widget<TextField>(field).controller!.text,
        'preserved text',
      );
      expect(env.gateway.of('prompt.submit'), isEmpty);
      expect(tester.takeException(), isNull);
      final staged = Directory('${root.path}/composer-paste');
      expect(staged.existsSync() ? staged.listSync() : [], isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
    },
    variant: TargetPlatformVariant({
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
    }),
  );

  testWidgets(
    'desktop clipboard read started in previous composer never attaches after navigation',
    (tester) async {
      final env = await pump(tester, keyed: false);
      final pending = Completer<ClipboardAttachment?>();
      debugClipboardAttachmentReader = () => pending.future;
      await tester.showKeyboard(find.byKey(_fieldKey));
      await ctrlV(tester);
      await tester.pumpWidget(const SizedBox.shrink());
      pending.complete(ClipboardAttachment(image: png));
      await _drain(tester);
      final staged = Directory('${root.path}/composer-paste');
      expect(staged.existsSync() ? staged.listSync() : [], isEmpty);
      expect(env.gateway.of('prompt.submit'), isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('clipboard read is fenced before unkeyed NextGen owner switch', (
    tester,
  ) async {
    final env = await pump(tester, keyed: false);
    final pending = Completer<ClipboardAttachment?>();
    debugClipboardAttachmentReader = () => pending.future;
    await tester.showKeyboard(find.byKey(_fieldKey));
    await ctrlV(tester);
    final other = NgChatController(env.gateway, sessionId: 'clipboard-b')
      ..runtimeId = 'rt-b';
    addTearDown(other.dispose);
    env.chat.value = other;
    await tester.pump();
    pending.complete(ClipboardAttachment(image: png));
    await _drain(tester);
    expect(_chips(), isEmpty);
    expect(env.gateway.of('prompt.submit'), isEmpty);
    expect(tester.takeException(), isNull);
    final staged = Directory('${root.path}/composer-paste');
    expect(staged.existsSync() ? staged.listSync() : [], isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final order in ['drop-first', 'paste-first']) {
    for (final kind in ['files', 'image']) {
      testWidgets('NR1 drop + Ctrl+V ($kind on clipboard, $order) at 9 drafts '
          'give exactly 10', (tester) async {
        await pump(tester);
        await nine(tester);
        final pasted = File('${root.path}/clip.txt')..writeAsStringSync('c');
        clip = kind == 'files'
            ? ClipboardAttachment(files: [pasted.path])
            : ClipboardAttachment(image: png);
        await tester.showKeyboard(find.byKey(_fieldKey));
        await tester.pump();
        final drop = make(1, 'drop');
        if (order == 'drop-first') target(tester).onFiles(drop);
        await ctrlV(tester);
        if (order == 'paste-first') target(tester).onFiles(drop);
        await _drain(tester);
        final errors = <Object>[];
        Object? e;
        while ((e = tester.takeException()) != null) {
          errors.add(e!);
        }
        _log('NR1 $kind $order chips=${_chips()} errors=$errors');
        expect(errors, isEmpty);
        expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
      });
    }
  }

  for (final order in ['picker-first', 'drop-first']) {
    testWidgets('NR2 Attach picker (2 files) + drop ($order) at 9 drafts give '
        'exactly 10', (tester) async {
      await pump(tester);
      await nine(tester);
      final gate = Completer<void>();
      final picked = [
        for (final n in ['pa.txt', 'pb.txt'])
          (File('${root.path}/$n')..writeAsStringSync(n)),
      ];
      FilePicker.platform = _Picker([
        for (final f in picked)
          PlatformFile(name: f.uri.pathSegments.last, size: 2, path: f.path),
      ], gate: gate);
      final drop = make(1, 'drop');
      if (order == 'drop-first') target(tester).onFiles(drop);
      await tester.tap(find.byTooltip('Attach'));
      await _settle(tester);
      await tester.tap(find.text('Files'));
      await tester.pump();
      if (order == 'picker-first') target(tester).onFiles(drop);
      gate.complete();
      await _drain(tester);
      _log('NR2 $order chips=${_chips()}');
      expect(tester.takeException(), isNull);
      expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
    });
  }

  testWidgets('NR2b Attach picker returns 3 files at 8 drafts: 10, not 11', (
    tester,
  ) async {
    await pump(tester);
    target(tester).onFiles(make(8, 'base'));
    await _drain(tester, done: () => _chips().length >= 8);
    final picked = [
      for (final n in ['qa.txt', 'qb.txt', 'qc.txt'])
        (File('${root.path}/$n')..writeAsStringSync(n)),
    ];
    FilePicker.platform = _Picker([
      for (final f in picked)
        PlatformFile(name: f.uri.pathSegments.last, size: 2, path: f.path),
    ]);
    await tester.tap(find.byTooltip('Attach'));
    await _settle(tester);
    await tester.tap(find.text('Files'));
    target(tester).onFiles(make(1, 'drop'));
    await _drain(tester);
    _log('NR2b chips=${_chips()}');
    expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
  });

  for (final order in ['insert-first', 'drop-first']) {
    testWidgets('NR3 keyboard image insertion + drop ($order) at 9 drafts '
        'give exactly 10', (tester) async {
      await pump(tester);
      await nine(tester);
      final drop = make(1, 'drop');
      if (order == 'drop-first') target(tester).onFiles(drop);
      insertImage(tester, png);
      if (order == 'insert-first') target(tester).onFiles(drop);
      await _drain(tester);
      _log('NR3 $order chips=${_chips()}');
      expect(tester.takeException(), isNull);
      expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
    });
  }

  testWidgets('NR4 a failed prepare releases its slot: oversize, missing and '
      'directory-as-file drops then a good one at 9 drafts give 10', (
    tester,
  ) async {
    await pump(tester);
    await nine(tester);
    final big = File('${root.path}/big.bin');
    final raf = big.openSync(mode: FileMode.write);
    raf.truncateSync(maxNextGenAttachmentBytes + 1);
    raf.closeSync();
    final dir = Directory('${root.path}/adir')..createSync();
    target(tester).onFiles([OsIntakeFile(big.path)]);
    target(tester).onFiles([OsIntakeFile('${root.path}/missing.txt')]);
    target(tester).onFiles([OsIntakeFile(dir.path)]);
    insertImage(tester, Uint8List.fromList([1, 2, 3, 4, 5]));
    target(tester).onFiles(make(1, 'good'));
    await _drain(tester);
    final errors = <Object>[];
    Object? e;
    while ((e = tester.takeException()) != null) {
      errors.add(e!);
    }
    _log('NR4 chips=${_chips()} errors=$errors');
    expect(errors, isEmpty);
    expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
    expect(_chips().last, 'good0.txt');
  });

  testWidgets('NR5 the queue keeps running after a throwing job: a removed '
      'draft frees a slot that the next drop takes', (tester) async {
    await pump(tester);
    target(tester).onFiles(make(maxRemoteAttachmentDrafts, 'full'));
    await _drain(
      tester,
      done: () => _chips().length >= maxRemoteAttachmentDrafts,
    );
    // Full: refused (the job returns an error, not a stuck queue).
    target(tester).onFiles(make(1, 'over'));
    // A job whose prepare throws a non-AttachmentDraftException.
    target(tester).onFiles([OsIntakeFile('${root.path}/nope/none.txt')]);
    await _drain(tester);
    expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
    // Free one slot, then a drop must be staged (no deadlock).
    final chip = find.byType(InputChip).first;
    tester.widget<InputChip>(chip).onDeleted!();
    await _drain(tester);
    expect(_chips(), hasLength(maxRemoteAttachmentDrafts - 1));
    target(tester).onFiles(make(1, 'after'));
    await _drain(tester, done: () => _chips().contains('after0.txt'));
    _log('NR5 chips=${_chips()}');
    expect(_chips(), contains('after0.txt'));
    expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
  });

  for (final keyed in [true, false]) {
    testWidgets(
      'NR6 switching chat mid-intake (${keyed ? 'keyed remount, as '
                'main_page' : 'unkeyed didUpdateWidget'}) never stages the draft in '
      'the other chat',
      (tester) async {
        final h = await pump(tester, keyed: keyed);
        final other = NgChatController(h.gateway, sessionId: 'stored-2')
          ..runtimeId = 'rt-2';
        addTearDown(other.dispose);
        final first = h.chat.value;
        // Several intakes in flight on chat A.
        target(tester).onFiles(make(3, 'a'));
        insertImage(tester, png);
        // Switch before any prepare has finished.
        h.chat.value = other;
        await tester.pump();
        await _drain(tester);
        _log('NR6 keyed=$keyed chips in B=${_chips()}');
        expect(_chips(), isEmpty);
        // Back to A: the intake was dropped when its chat lost the composer,
        // never staged later either.
        h.chat.value = first;
        await tester.pump();
        await _drain(tester);
        _log('NR6 keyed=$keyed chips back in A=${_chips()}');
        expect(_chips(), isEmpty);
      },
    );
  }

  testWidgets('NR7 a send refuses more than maxRemoteAttachmentDrafts '
      '(NextGen limits)', (tester) async {
    final service = AttachmentDraftService(
      cacheDirectoryProvider: () async => root,
    );
    final drafts = <AttachmentDraft>[];
    await tester.runAsync(() async {
      for (var i = 0; i < maxRemoteAttachmentDrafts + 1; i++) {
        final f = File('${root.path}/v$i.txt')..writeAsStringSync('v$i');
        drafts.add(
          await service.prepareGenericFile(
            sourcePath: f.path,
            displayName: 'v$i.txt',
            existingDrafts: const [],
            maxFileBytes: maxNextGenAttachmentBytes,
            maxTotalBytes: maxNextGenAttachmentDraftBytes,
          ),
        );
      }
    });
    Object? error;
    try {
      service.validateRemoteDrafts(
        drafts,
        maxFileBytes: maxNextGenAttachmentBytes,
        maxTotalBytes: maxNextGenAttachmentDraftBytes,
      );
    } catch (e) {
      error = e;
    }
    _log('NR7 error=$error');
    expect(error, isA<AttachmentDraftException>());
    expect(
      () => service.validateRemoteDrafts(
        drafts.take(maxRemoteAttachmentDrafts),
        maxFileBytes: maxNextGenAttachmentBytes,
        maxTotalBytes: maxNextGenAttachmentDraftBytes,
      ),
      returnsNormally,
    );
  });

  testWidgets('NR8 at 10 drafts, drop + Ctrl+V + keyboard image + picker all '
      'refused; text paste of a path keeps its text; send carries 10', (
    tester,
  ) async {
    final h = await pump(tester);
    target(tester).onFiles(make(maxRemoteAttachmentDrafts, 'full'));
    await _drain(
      tester,
      done: () => _chips().length >= maxRemoteAttachmentDrafts,
    );
    final pasted = File('${root.path}/clip.txt')..writeAsStringSync('c');
    clip = ClipboardAttachment(files: [pasted.path]);
    FilePicker.platform = _Picker([
      PlatformFile(name: 'clip.txt', size: 1, path: pasted.path),
    ]);
    await tester.showKeyboard(find.byKey(_fieldKey));
    await tester.pump();
    target(tester).onFiles(make(1, 'x'));
    await ctrlV(tester);
    insertImage(tester, png);
    await tester.tap(find.byTooltip('Attach'));
    await _settle(tester);
    await tester.tap(find.text('Files'));
    await _drain(tester);
    expect(_chips(), hasLength(maxRemoteAttachmentDrafts));
    await tester.enterText(find.byKey(_fieldKey), 'go');
    await _settle(tester);
    await tester.tap(find.byTooltip('Send'));
    await _drain(tester, done: () => h.gateway.of('prompt.submit').isNotEmpty);
    final submits = h.gateway.of('prompt.submit');
    _log(
      'NR8 attach=${h.gateway.of('file.attach').length} submits=${submits.length} composer="${_composer(tester)}"',
    );
    expect(submits, hasLength(1));
    expect(h.gateway.of('file.attach'), hasLength(maxRemoteAttachmentDrafts));
  });
}
