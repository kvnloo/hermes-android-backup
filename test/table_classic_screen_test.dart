import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hermes_android/core/controllers/delegated_task_controller.dart';
import 'package:hermes_android/core/render/rich_transcript.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/widgets/delegated_task_timeline.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

import 'delegated_task_history_test.dart' show FakeHistory, task;
import 'support/fake_voice_composer_adapter.dart';
import 'table_preview_test.dart' show demoTable;

void main() {
  for (final pane in [320.0, 390.0, 640.0, 768.0, 1440.0]) {
    testWidgets(
      'Classic screen table escapes transcript cap inside pane $pane',
      (tester) async {
        SharedPreferences.setMockInitialValues({'verbose_mode': false});
        tester.view.physicalSize = const Size(1440, 1600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        const picker = MethodChannel('plugins.flutter.io/image_picker');
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          picker,
          (_) async => null,
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            picker,
            null,
          ),
        );
        final client = MockClient(
          (request) async => http.Response(
            jsonEncode(
              request.url.path.endsWith('/messages')
                  ? {
                      'data': [
                        {
                          'role': 'user',
                          'content': 'Compare these demo projects',
                        },
                        {
                          'role': 'assistant',
                          'content': demoTable,
                          'completed': true,
                        },
                      ],
                    }
                  : {},
            ),
            200,
            headers: {'content-type': 'application/json'},
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: pane,
                child: ChatScreen(
                  connection: SavedConnection(
                    id: 'table-fixture',
                    label: 'Table fixture',
                    host: 'table-fixture.invalid',
                    port: 8642,
                    apiKey: 'fixture-key',
                  ),
                  session: const Session(
                    id: 'table-session',
                    title: 'Project comparison',
                    model: 'fixture-model',
                    source: 'api_server',
                    messageCount: 2,
                    isActive: true,
                    preview: '',
                    startedAt: 1,
                  ),
                  testApiClient: ApiClient(
                    baseUrl: 'https://table-fixture.invalid',
                    apiKey: 'fixture-key',
                    httpClient: client,
                  ),
                  testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(ResizableMarkdownTable), findsOneWidget);
        final viewport = tester.getRect(
          find.byKey(const Key('table-horizontal-scroll')),
        );
        expect(viewport.width, greaterThanOrEqualTo(pane - 72));
        expect(viewport.left, greaterThanOrEqualTo(0));
        expect(viewport.right, lessThanOrEqualTo(pane));
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  testWidgets('delegated table uses shared grid and retains selectable cells', (
    tester,
  ) async {
    final history = FakeHistory()
      ..data = [
        {'id': 1, 'role': 'assistant', 'content': demoTable},
      ];
    final controller = DelegatedTaskController(task: task, history: history);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: DelegatedTaskTimeline(controller: controller)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ResizableMarkdownTable), findsOneWidget);
    expect(
      find.ancestor(
        of: find.byType(ResizableMarkdownTable),
        matching: find.byType(SelectionArea),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
