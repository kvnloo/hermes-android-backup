import 'dart:io';

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/desktop/screen_capture.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/attachment_draft_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';
import 'support/strict_nextgen_gateway.dart';

const _channel = MethodChannel('test/desktop_capture');

/// A smallest valid PNG (1x1).
const _png = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0xF8, 0xCF, 0xC0, 0xF0,
  0x1F, 0x00, 0x05, 0x00, 0x01, 0xFF, 0x89, 0x99, 0x3D, 0x1D, 0x00, 0x00,
  0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

/// A fake runner. [capture] decides what a capture call does with the
/// folder Dart passed.
class _FakeCaptureRunner {
  _FakeCaptureRunner({
    this.status = const {'supported': true, 'permission': 'not-required'},
    this.afterRequest,
    Future<Object?> Function(String directory)? capture,
  }) : capture = capture ?? _writePng {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          calls.add(call.method);
          switch (call.method) {
            case 'status':
              return status;
            case 'requestPermission':
              return afterRequest ?? status;
            case 'openSettings':
              return true;
            case 'capture':
              directories.add((call.arguments as Map)['directory'] as String);
              return this.capture(directories.last);
          }
          return null;
        });
  }

  final Map<String, Object> status;
  final Map<String, Object>? afterRequest;
  final Future<Object?> Function(String directory) capture;
  final calls = <String>[];
  final directories = <String>[];

  static Future<Object?> _writePng(String directory) async {
    final file = File('$directory/screenshot-1.png');
    await file.writeAsBytes(_png);
    return file.path;
  }
}

/// A connected NextGen gateway that records prompts instead of sending.
class _Ng extends NextGenGateway {
  _Ng(super.connection);
  final prompts = <Map<String, dynamic>>[];
  @override
  bool get sessionAuthority => true;
  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

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
    if (method == 'prompt.submit') prompts.add(Map.of(params));
    return {};
  }
}

class _Paths extends PathProviderPlatform {
  _Paths(this.dir);
  final Directory dir;
  @override
  Future<String?> getTemporaryPath() async => dir.path;
  @override
  Future<String?> getApplicationSupportPath() async => dir.path;
  @override
  Future<String?> getApplicationDocumentsPath() async => dir.path;
}

ScreenCaptureController _controller(Directory root) => ScreenCaptureController(
  channel: _channel,
  temporaryDirectory: () async => root,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('ares-capture-test-');
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
    if (await root.exists()) await root.delete(recursive: true);
  });

  group('ScreenCaptureController', () {
    test('reads status and degrades without a runner', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      _FakeCaptureRunner(status: {'supported': true, 'permission': 'denied'});
      final status = await _controller(root).status();
      expect(status.supported, isTrue);
      expect(status.permission, CapturePermission.denied);
      expect(status.ready, isFalse);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_channel, null);
      expect((await _controller(root).status()).supported, isFalse);
      // Phones never ask a runner.
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      _FakeCaptureRunner();
      expect((await _controller(root).status()).supported, isFalse);
    });

    test('accepts only a PNG inside its private folder', () async {
      final runner = _FakeCaptureRunner();
      final result = await _controller(root).capture();
      final file = result.file!;
      expect(await file.readAsBytes(), _png);
      expect(file.parent.path, runner.directories.single);
      expect(file.parent.path, contains('ares-capture-'));
      await ScreenCaptureController.discard(file);
      expect(await file.parent.exists(), isFalse);
    });

    test(
      'rejects paths outside the folder, non-PNGs and empty files',
      () async {
        final outside = File('${root.path}/elsewhere.png')
          ..writeAsBytesSync(_png);
        for (final capture in <Future<Object?> Function(String)>[
          (_) async => outside.path,
          (d) async {
            final f = File('$d/../escape.png')..writeAsBytesSync(_png);
            return f.path;
          },
          (d) async {
            final f = File('$d/shot.png')..writeAsStringSync('not a png');
            return f.path;
          },
          (d) async {
            final f = File('$d/shot.png')..writeAsBytesSync(const []);
            return f.path;
          },
          (d) async {
            final f = File('$d/shot.jpg')..writeAsBytesSync(_png);
            return f.path;
          },
          (_) async => 42,
        ]) {
          final runner = _FakeCaptureRunner(capture: capture);
          final result = await _controller(root).capture();
          expect(result.file, isNull);
          expect(result.failure, CaptureFailure.failed);
          // The private folder never outlives a rejected capture.
          expect(Directory(runner.directories.single).existsSync(), isFalse);
        }
        expect(outside.existsSync(), isTrue);
      },
    );

    test('maps runner errors', () async {
      for (final (code, failure) in [
        ('cancelled', CaptureFailure.cancelled),
        ('permission-denied', CaptureFailure.permissionDenied),
        ('unsupported', CaptureFailure.unsupported),
        ('failed', CaptureFailure.failed),
      ]) {
        final runner = _FakeCaptureRunner(
          capture: (_) async => throw PlatformException(code: code),
        );
        final result = await _controller(root).capture();
        expect(result.failure, failure);
        expect(Directory(runner.directories.single).existsSync(), isFalse);
      }
    });
  });

  group('captureScreenIntoDraft', () {
    Future<BuildContext> host(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: SizedBox.expand()),
        ),
      );
      return tester.element(find.byType(SizedBox).last);
    }

    testWidgets(
      'asks for macOS permission and explains the setting',
      (tester) async {
        final runner = _FakeCaptureRunner(
          status: {'supported': true, 'permission': 'prompt'},
          afterRequest: {'supported': true, 'permission': 'denied'},
        );
        final context = await host(tester);
        final attached = <String>[];
        final done = captureScreenIntoDraft(
          context,
          controller: _controller(root),
          attach: (png, name) async => attached.add(name),
        );
        await tester.pumpAndSettle();
        expect(runner.calls, ['status', 'requestPermission']);
        expect(find.byKey(const Key('capture-permission-dialog')), findsOne);
        expect(find.textContaining('Screen Recording'), findsOneWidget);
        await tester.tap(find.byKey(const Key('capture-open-settings')));
        await tester.pumpAndSettle();
        expect(await done, isFalse);
        expect(runner.calls.last, 'openSettings');
        expect(runner.calls, isNot(contains('capture')));
        expect(attached, isEmpty);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.macOS),
    );

    testWidgets(
      'a capture becomes a draft and its folder is removed',
      (tester) async {
        final runner = _FakeCaptureRunner();
        final context = await host(tester);
        final attached = <(String, List<int>)>[];
        final done = await tester.runAsync(
          () => captureScreenIntoDraft(
            context,
            controller: _controller(root),
            attach: (png, name) async =>
                attached.add((name, await png.readAsBytes())),
          ),
        );
        expect(done, isTrue);
        expect(attached.single.$1, startsWith('Screenshot '));
        expect(attached.single.$1, endsWith('.png'));
        expect(attached.single.$2, _png);
        expect(Directory(runner.directories.single).existsSync(), isFalse);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.windows),
    );

    testWidgets(
      'cancel is silent; unsupported says so',
      (tester) async {
        _FakeCaptureRunner(
          capture: (_) async => throw PlatformException(code: 'cancelled'),
        );
        final context = await host(tester);
        final attached = <String>[];
        final cancelled = await tester.runAsync(
          () => captureScreenIntoDraft(
            context,
            controller: _controller(root),
            attach: (png, name) async => attached.add(name),
          ),
        );
        await tester.pump();
        expect(cancelled, isFalse);
        expect(find.byType(SnackBar), findsNothing);

        _FakeCaptureRunner(status: {'supported': false, 'permission': 'x'});
        final unsupported = await tester.runAsync(
          () => captureScreenIntoDraft(
            context,
            controller: _controller(root),
            attach: (png, name) async => attached.add(name),
          ),
        );
        await tester.pump();
        expect(unsupported, isFalse);
        expect(
          find.text("Screen capture isn't available on this desktop."),
          findsOneWidget,
        );
        expect(attached, isEmpty);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.linux),
    );
  });

  testWidgets(
    'Classic: Capture screen adds an image draft and sends nothing',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final runner = _FakeCaptureRunner();
      // Real file I/O runs outside the test clock.
      final cache = (await tester.runAsync(
        () => Directory(root.path).createTemp('drafts-'),
      ))!;
      var submissions = 0;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChatScreen(
            connection: SavedConnection(
              id: 'capture-classic',
              label: 'Capture',
              host: 'capture.invalid',
              port: 8642,
              apiKey: 'test-key',
            ),
            session: Session(
              id: 'capture-classic-1',
              title: 'Capture chat',
              model: 'fixture-model',
              source: 'test',
              messageCount: 0,
              isActive: true,
              preview: '',
              startedAt: 1,
            ),
            testApiClient: ApiClient(
              baseUrl: 'http://capture.invalid',
              apiKey: 'test-key',
              httpClient: MockClient(
                (_) async => http.Response('{"data":[]}', 200),
              ),
            ),
            testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
            testAttachmentDraftService: AttachmentDraftService(
              cacheDirectoryProvider: () async => cache,
            ),
            testRemotePromptSubmit:
                ({
                  required sessionId,
                  required text,
                  required onEvent,
                  required onSent,
                }) async {
                  submissions++;
                },
            screenCapture: _controller(root),
          ),
        ),
      );
      await pumpChatUpdates(tester);
      await tester.tap(find.byTooltip('Attach image or file'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      final action = find.byKey(const Key('classic-attach-capture-screen'));
      expect(action, findsOneWidget);
      expect(find.text('Capture screen'), findsOneWidget);
      await tester.tap(action);
      // The capture and the draft copy are real file I/O.
      List<File> drafts() =>
          cache.listSync(recursive: true).whereType<File>().toList();
      for (var i = 0; i < 150 && drafts().isEmpty; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump(const Duration(milliseconds: 20));
      }
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump(const Duration(milliseconds: 20));
      }
      expect(runner.calls, containsAllInOrder(['status', 'capture']));
      // The draft service holds its own copy; the capture folder is gone.
      expect(drafts(), isNotEmpty);
      expect(Directory(runner.directories.single).existsSync(), isFalse);
      expect(submissions, 0);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    },
    variant: TargetPlatformVariant.only(TargetPlatform.linux),
  );

  testWidgets(
    'NextGen: Capture screen adds an image draft and sends nothing',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final paths = PathProviderPlatform.instance;
      PathProviderPlatform.instance = _Paths(root);
      addTearDown(() => PathProviderPlatform.instance = paths);
      final runner = _FakeCaptureRunner();
      final g = _Ng(
        SavedConnection(
          id: 'capture-ng',
          label: 'Capture',
          host: '127.0.0.1',
          port: 9,
          apiKey: '',
          dashboardProxied: true,
          dashboardPortOverride: 9,
        ),
      );
      final ng = NgChatController(g, sessionId: 'stored')..runtimeId = 'rt';
      addTearDown(() {
        ng.dispose();
        g.dispose();
      });
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          home: NgScope(
            connManager: ConnectionManager(
              await SharedPreferences.getInstance(),
            ),
            gateway: g,
            connections: [g.connection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: Scaffold(
              body: NgChatView(
                chat: ng,
                onOpenSidebar: () {},
                onNewChat: () {},
                screenCapture: _controller(root),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byTooltip('Attach'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      final action = find.byKey(const Key('ng-attach-capture-screen'));
      expect(action, findsOneWidget);
      await tester.tap(action);
      final chip = find.textContaining('Screenshot ');
      for (var i = 0; i < 150 && chip.evaluate().isEmpty; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump(const Duration(milliseconds: 20));
      }
      expect(chip, findsOneWidget);
      expect(runner.calls, containsAllInOrder(['status', 'capture']));
      expect(Directory(runner.directories.single).existsSync(), isFalse);
      expect(g.prompts, isEmpty);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    },
    variant: TargetPlatformVariant.only(TargetPlatform.macOS),
  );

  testWidgets(
    'PROBE-6 Classic: no Capture screen where the runner cannot capture',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final runner = _FakeCaptureRunner(
        status: const {'supported': false, 'permission': 'not-required'},
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChatScreen(
            connection: SavedConnection(
              id: 'capture-classic-off',
              label: 'Capture',
              host: 'capture.invalid',
              port: 8642,
              apiKey: 'k',
            ),
            session: Session(
              id: 'capture-classic-off-1',
              title: 'Capture chat',
              model: 'fixture-model',
              source: 'test',
              messageCount: 0,
              isActive: true,
              preview: '',
              startedAt: 1,
            ),
            testApiClient: ApiClient(
              baseUrl: 'http://capture.invalid',
              apiKey: 'k',
              httpClient: MockClient(
                (_) async => http.Response('{"data":[]}', 200),
              ),
            ),
            testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
            screenCapture: _controller(root),
          ),
        ),
      );
      await pumpChatUpdates(tester);
      await tester.tap(find.byTooltip('Attach image or file'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      // The sheet is open (its other actions are there) but offers no
      // capture: the runner said it cannot.
      expect(find.text('Take photo'), findsOneWidget);
      expect(
        find.byKey(const Key('classic-attach-capture-screen')),
        findsNothing,
      );
      expect(runner.calls, ['status']);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    },
    variant: TargetPlatformVariant.only(TargetPlatform.linux),
  );

  testWidgets(
    'PROBE-6 NextGen: no Capture screen where the runner cannot capture',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final runner = _FakeCaptureRunner(
        status: const {'supported': false, 'permission': 'not-required'},
      );
      final g = _Ng(
        SavedConnection(
          id: 'capture-ng-off',
          label: 'Capture',
          host: '127.0.0.1',
          port: 9,
          apiKey: 'k',
          dashboardProxied: true,
          dashboardPortOverride: 9,
        ),
      );
      final ng = NgChatController(g, sessionId: 'stored')..runtimeId = 'rt';
      addTearDown(() {
        ng.dispose();
        g.dispose();
      });
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          home: NgScope(
            connManager: ConnectionManager(
              await SharedPreferences.getInstance(),
            ),
            gateway: g,
            connections: [g.connection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: Scaffold(
              body: NgChatView(
                chat: ng,
                onOpenSidebar: () {},
                onNewChat: () {},
                screenCapture: _controller(root),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byTooltip('Attach'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.text('Photos'), findsOneWidget);
      expect(find.byKey(const Key('ng-attach-capture-screen')), findsNothing);
      expect(runner.calls, ['status']);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    },
    variant: TargetPlatformVariant.only(TargetPlatform.linux),
  );
}
