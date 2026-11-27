import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/files_screen.dart';
import 'package:hermes_android/core/services/remote_files_client.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

import 'support/markdown_file_fixture.dart';

class _FakeFilesDataSource implements RemoteFilesDataSource {
  Object? listError;
  String content = markdownFixture;
  bool truncated = false;
  Completer<RemoteTextPreview>? pending;
  final openedDirectories = <String>[];

  @override
  Future<RemoteDirectory> defaultDirectory() async =>
      const RemoteDirectory(path: '/srv/project', branch: 'main');

  @override
  Future<List<RemoteFileEntry>> listDirectory(String path) async {
    openedDirectories.add(path);
    if (listError != null) throw listError!;
    if (path == '/srv/project/lib') {
      return const [
        RemoteFileEntry(
          name: 'main.dart',
          path: '/srv/project/lib/main.dart',
          isDirectory: false,
        ),
      ];
    }
    return const [
      RemoteFileEntry(name: 'lib', path: '/srv/project/lib', isDirectory: true),
      RemoteFileEntry(
        name: 'README.md',
        path: '/srv/project/README.md',
        isDirectory: false,
      ),
    ];
  }

  @override
  Future<RemoteTextPreview> readText(String path) async =>
      pending?.future ??
      RemoteTextPreview(
        path: path,
        text: content,
        language: 'markdown',
        mimeType: 'text/markdown',
        byteSize: 23,
        binary: false,
        truncated: truncated,
      );

  @override
  Future<RemoteFileDownload> download(String path) async =>
      RemoteFileDownload(filename: path.split('/').last, bytes: [1, 2, 3]);
}

Future<void> _pump(
  WidgetTester tester,
  _FakeFilesDataSource source, {
  ValueChanged<String>? onAddToChat,
  Future<void> Function(RemoteFileDownload download)? onSaveDownload,
}) => tester.pumpWidget(
  MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: hermesTheme(Brightness.dark),
    home: FilesScreen(
      files: source,
      onAddToChat: onAddToChat,
      onSaveDownload: onSaveDownload,
    ),
  ),
);

void main() {
  testWidgets('shows the server root and navigates into a directory', (
    tester,
  ) async {
    final source = _FakeFilesDataSource();
    await _pump(tester, source);
    await tester.pumpAndSettle();

    expect(find.text('Files'), findsOneWidget);
    expect(find.text('/srv/project'), findsOneWidget);
    expect(find.text('main'), findsOneWidget);
    expect(find.text('lib'), findsOneWidget);
    expect(find.text('README.md'), findsOneWidget);

    await tester.tap(find.text('lib'));
    await tester.pumpAndSettle();

    expect(source.openedDirectories, contains('/srv/project/lib'));
    expect(find.text('main.dart'), findsOneWidget);
  });

  testWidgets(
    'previews text and adds its server reference to chat',
    (tester) async {
      final source = _FakeFilesDataSource();
      final references = <String>[];
      await _pump(tester, source, onAddToChat: references.add);
      await tester.pumpAndSettle();

      await tester.tap(find.text('README.md'));
      await tester.pumpAndSettle();

      await verifyMarkdownPreview(tester);
      expect(find.text('markdown'), findsOneWidget);
      await tester.tap(find.text('Add to chat'));
      await tester.pumpAndSettle();

      expect(references, ['/srv/project/README.md']);
    },
    variant: markdownPlatforms,
  );

  testWidgets('plain text stays literal despite server markdown metadata', (
    tester,
  ) async {
    final source = _FakeFilesDataSource()..truncated = true;
    await _pump(tester, source);
    await tester.pumpAndSettle();
    await tester.tap(find.text('lib'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('main.dart'));
    await tester.pumpAndSettle();
    expect(find.text(markdownFixture), findsOneWidget);
    expect(find.text('Source'), findsNothing);
    expect(find.text('Preview truncated'), findsOneWidget);
  });

  testWidgets('links require an explicit safe web tap, images never load', (
    tester,
  ) async {
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    final launches = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      launches.add(call);
      return true;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    await _pump(tester, _FakeFilesDataSource());
    await tester.pumpAndSettle();
    await tester.tap(find.text('README.md'));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsNothing);
    expect(launches, isEmpty);
    for (final label in ['Script', 'Local', 'Credentialed', 'Handbook']) {
      final link = find.text(label, findRichText: true);
      await tester.ensureVisible(link);
      await tester.pumpAndSettle();
      await tester.tapAt(tester.getTopLeft(link) + const Offset(6, 7));
      await tester.pump();
    }
    expect(launches.map((call) => call.arguments['url']), [
      'https://docs.example.invalid/guide',
    ]);
    expect(launches.single.arguments['headers'], isEmpty);
    expect(launches.single.arguments['useWebView'], false);
  });

  testWidgets(
    'rich budget stops dense markup; source preserves the bounded prefix',
    (tester) async {
      final source = _FakeFilesDataSource()
        ..content = '# Safe\n\n${'>' * 200} deep\n${'x' * 70000}';
      await _pump(tester, source);
      await tester.pumpAndSettle();
      await tester.tap(find.text('README.md'));
      await tester.pumpAndSettle();
      expect(find.text('Safe', findRichText: true), findsOneWidget);
      expect(find.text('Preview truncated'), findsOneWidget);
      await tester.tap(find.text('Source'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<SelectableText>(find.byType(SelectableText)).data,
        source.content.substring(0, 65536),
      );
      expect(find.text('Download'), findsOneWidget);
    },
  );

  testWidgets('changing file authority drops a pending read', (tester) async {
    final first = _FakeFilesDataSource()
      ..pending = Completer<RemoteTextPreview>();
    await _pump(tester, first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('README.md'));
    await tester.pump();
    await _pump(tester, _FakeFilesDataSource());
    await tester.pumpAndSettle();
    await tester.tap(find.text('README.md'));
    await tester.pumpAndSettle();
    first.pending!.complete(
      const RemoteTextPreview(
        path: '/srv/project/README.md',
        text: '# Old host',
        language: 'markdown',
        mimeType: 'text/markdown',
        byteSize: 10,
        binary: false,
        truncated: false,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Old host', findRichText: true), findsNothing);
    await verifyMarkdownPreview(tester);
  });

  testWidgets('downloads the selected file through the platform seam', (
    tester,
  ) async {
    final source = _FakeFilesDataSource();
    final downloads = <RemoteFileDownload>[];
    await _pump(
      tester,
      source,
      onSaveDownload: (download) async => downloads.add(download),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('README.md'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Download'));
    await tester.pumpAndSettle();

    expect(downloads.single.filename, 'README.md');
    expect(downloads.single.bytes, [1, 2, 3]);
  });

  testWidgets('unreadable Markdown still offers original download', (
    tester,
  ) async {
    final source = _FakeFilesDataSource()..pending = Completer();
    final downloads = <RemoteFileDownload>[];
    await _pump(
      tester,
      source,
      onSaveDownload: (file) async => downloads.add(file),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('README.md'));
    await tester.pump();
    source.pending!.completeError(StateError('preview unavailable'));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Source'), findsNothing);
    await tester.tap(find.text('Download'));
    await tester.pumpAndSettle();
    expect(downloads.single.bytes, [1, 2, 3]);
  });

  testWidgets('shows a retryable error when the directory cannot load', (
    tester,
  ) async {
    final source = _FakeFilesDataSource()..listError = Exception('offline');
    await _pump(tester, source);
    await tester.pumpAndSettle();

    expect(find.text('Could not load files'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
