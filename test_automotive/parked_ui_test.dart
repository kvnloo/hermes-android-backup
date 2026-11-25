import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hermes_android/core/screens/settings_screen.dart';
import 'package:hermes_android/core/services/attachment_controller.dart';
import 'package:hermes_android/core/services/remote_files_client.dart';
import 'package:hermes_android/core/utils/media_tags.dart';
import 'package:hermes_android/core/widgets/attachment_preview_dialog.dart';
import 'package:hermes_android/core/widgets/attachment_video_preview.dart';
import 'package:hermes_android/main.dart' show HermesApp, HomeScreen;
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/parked_automotive.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/widgets/voice_composer_controls.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/support/completed_stock_turn.dart';

void main() {
  setUpAll(() => expect(isParkedAutomotive, isTrue));
  // The analyzer does not recognize test_automotive as a test directory.
  // ignore: invalid_use_of_visible_for_testing_member
  setUp(() => SharedPreferences.setMockInitialValues({}));
  final connection = SavedConnection(
    id: 'fixture',
    label: 'Parked chat',
    host: 'fixture.invalid',
    port: 8642,
    apiKey: '',
  );

  testWidgets('Classic sends typed text without showing audio controls', (
    tester,
  ) async {
    final sent = <String>[];
    final api = ApiClient(
      baseUrl: 'http://fixture.invalid',
      apiKey: '',
      httpClient: MockClient((_) async => http.Response('{"data":[]}', 200)),
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatScreen(
          connection: connection,
          session: const Session(
            id: 'chat',
            title: 'Session',
            model: 'test',
            source: 'test',
            messageCount: 0,
            isActive: true,
            preview: '',
            startedAt: 1,
          ),
          testApiClient: api,
          testRemotePromptSubmit: completedStockTurn(({
            required sessionId,
            required text,
            required onEvent,
            required onSent,
          }) async {
            sent.add(text);
            onSent();
          }),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(VoiceComposerStartButton), findsNothing);
    expect(find.byIcon(Icons.volume_up), findsNothing);
    expect(find.byIcon(Icons.volume_off), findsNothing);
    await tester.enterText(find.byType(TextField), 'Typed while parked');
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();
    expect(sent, ['Typed while parked']);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('NextGen keeps reply, copy, composer and attachment actions', (
    tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final gateway = NextGenGateway(connection);
    final chat = NgChatController(gateway, sessionId: 'stored')
      ..runtimeId = 'stored';
    // ignore: invalid_use_of_visible_for_testing_member
    chat.debugApplyHistory([
      {'role': 'assistant', 'content': 'Readable reply'},
    ]);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: nextGenTheme(Brightness.light, NextGenLook.instance),
        home: NgScope(
          connManager: ConnectionManager(prefs),
          gateway: gateway,
          connections: [connection],
          switchTo: (_) async {},
          addGateway: () async {},
          signOut: (_) async {},
          reload: () async {},
          signInAgain: () async {},
          child: Scaffold(
            body: NgChatView(
              chat: chat,
              onOpenSidebar: () {},
              onNewChat: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byTooltip('Copy'), findsOneWidget);
    expect(find.byTooltip('Read aloud'), findsNothing);
    expect(find.byIcon(Icons.mic_none), findsNothing);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Still editable');
    expect(find.text('Still editable'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    chat.dispose();
    gateway.dispose();
  });

  testWidgets(
    'text files preview; media files stay downloadable without a player',
    (tester) async {
      for (final ext in ['txt', 'mp4', 'm4a']) {
        final controller = AttachmentController(
          ref: MediaTagRef(path: '/out/note.$ext'),
          filesClient: _Files.new,
        );
        await controller.ensureBytes();
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AttachmentPreviewDialog(controller: controller),
          ),
        );
        expect(find.byType(AttachmentVideoPreview), findsNothing);
        expect(
          find.byKey(const Key('attachment-text-preview')),
          ext == 'txt' ? findsOneWidget : findsNothing,
        );
        expect(
          tester
              .widget<FilledButton>(
                find.byKey(const Key('attachment-preview-save')),
              )
              .onPressed,
          isNotNull,
        );
        await tester.pumpWidget(const SizedBox.shrink());
        controller.dispose();
      }
    },
  );

  testWidgets('local settings remain accessible without updater controls', (
    tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(HermesApp(connManager: ConnectionManager(prefs)));
    await tester.pumpAndSettle();
    unawaited(
      Navigator.of(tester.element(find.byType(HomeScreen))).push(
        MaterialPageRoute<void>(
          builder: (_) => SettingsScreen(connection: connection),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final scrollable = find
        .descendant(
          of: find.byType(SettingsScreen),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('Chat density'),
      250,
      scrollable: scrollable,
    );
    await tester.scrollUntilVisible(
      find.text('About'),
      300,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
    expect(find.text('Check for updates'), findsNothing);
    expect(find.text('Check for updates on launch'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

class _Files extends Fake implements RemoteFilesDataSource {
  @override
  Future<RemoteFileDownload> download(String path) async =>
      RemoteFileDownload(filename: path, bytes: 'File contents'.codeUnits);
}
