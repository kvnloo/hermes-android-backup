import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/widgets/markdown_file_preview.dart';
import 'package:http/http.dart' as http;

const markdownPlatforms = TargetPlatformVariant({
  TargetPlatform.android,
  TargetPlatform.iOS,
  TargetPlatform.macOS,
  TargetPlatform.linux,
  TargetPlatform.windows,
});

Size get markdownViewport => switch (defaultTargetPlatform) {
  TargetPlatform.android || TargetPlatform.iOS => const Size(390, 844),
  _ => const Size(1150, 820),
};

// The same UTF-8 document must survive every route, not just the chat renderer.
const markdownFixture =
    '# Field notes\r\n\r\n'
    '## Observations\n\n- **Alpha** and *beta*\n- Gamma\n\n'
    '> Quoted observation\n\n'
    '| Sample | Result |\n| --- | --- |\n| A | Passed |\n\n'
    '```dart\nfinal sample = 7;\n```\n\n'
    '[Handbook](https://docs.example.invalid/guide)\n\n'
    '[Local](file:///private/report)\n\n[Script](javascript:alert)\n\n'
    '[Credentialed](https://user@tracker.invalid/)\n\n'
    '![Tracking pixel](https://tracker.invalid/pixel.png)\n\n'
    '<script>active()</script>\n';

class MarkdownDashboardFixture {
  static const directory = '/srv/work/project';
  static const filename = 'notes.MD';
  static const path = '$directory/$filename';
  static const session = 'stored-project-chat';
  final requests = <Uri>[];

  Future<http.Response> respond(http.Request request) async {
    final uri = request.url;
    requests.add(uri);
    if (uri.path.endsWith('/fs/download')) {
      expectSync(uri.queryParameters['path'], path);
      return http.Response.bytes(utf8.encode(markdownFixture), 200);
    }
    final Object data;
    if (uri.path.endsWith('/fs/default-cwd')) {
      data = {'cwd': directory};
    } else if (uri.path.endsWith('/fs/list')) {
      expect(uri.queryParameters['path'], directory);
      data = {
        'entries': [
          {'name': filename, 'path': path, 'isDirectory': false},
        ],
      };
    } else if (uri.path.endsWith('/fs/read-text')) {
      expect(uri.queryParameters['path'], path);
      data = {'path': path, 'text': markdownFixture, 'language': 'markdown'};
    } else if (uri.path.endsWith('/messages')) {
      data = {
        'session_id': session,
        'messages': [
          {'role': 'user', 'content': 'Send notes'},
          {'role': 'assistant', 'content': 'MEDIA:$path', 'timestamp': 10},
        ],
      };
    } else if (uri.path.endsWith('/sessions')) {
      data = {
        'sessions': [
          {'id': session, 'title': 'Field chat'},
        ],
        'total': 1,
      };
    } else {
      data = {'model': 'fixture'};
    }
    return http.Response(
      jsonEncode(data),
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
}

/// The bounded HTTP stream may finish on a real event-loop turn rather than
/// Flutter's fake animation clock. Do not mock the actual download or viewer.
Future<void> waitForMarkdownDownload(WidgetTester tester) async {
  for (var i = 0; i < 60; i++) {
    if (find.byType(MarkdownFilePreview).evaluate().isNotEmpty) break;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 5)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> verifyMarkdownPreview(WidgetTester tester) async {
  final preview = find.byType(MarkdownFilePreview);
  expect(preview, findsOneWidget);
  Finder inside(Finder finder) =>
      find.descendant(of: preview, matching: finder);
  for (final text in [
    'Field notes',
    'Observations',
    'Alpha and beta',
    'Gamma',
    'Quoted observation',
    'Passed',
    'Handbook',
  ]) {
    expect(
      inside(find.text(text, findRichText: true)),
      findsOneWidget,
      reason: text,
    );
  }
  expect(
    inside(find.textContaining('final sample = 7;', findRichText: true)),
    findsOneWidget,
  );
  expect(inside(find.byType(Table)), findsOneWidget);
  expect(inside(find.byType(Image)), findsNothing);
  expect(inside(find.text('Tracking pixel')), findsOneWidget);
  await tester.tap(inside(find.text('Source')));
  await tester.pumpAndSettle();
  expect(inside(find.text(markdownFixture)), findsOneWidget);
  expect(inside(find.byType(Table)), findsNothing);
  await tester.tap(inside(find.text('Source')));
  await tester.pumpAndSettle();
  expect(inside(find.byType(Table)), findsOneWidget);
  expect(tester.takeException(), isNull);
}
