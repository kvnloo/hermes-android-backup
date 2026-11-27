import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/render/rich_transcript.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

const demoTable = '''Project comparison

| Project | Integration / sync | Practical assessment |
| --- | --- | --- |
| **Cedar** | **CSV import possible.** Includes records and notes. | **High priority.** A reliable migration path. |
| **Maple** | Use `project_id` and [documentation](https://example.com). | Review the exported data before importing. |
''';

void main() {
  for (final ng in [false, true]) {
    for (final width in [320.0, 390.0, 640.0, 768.0, 1440.0]) {
      for (final brightness in Brightness.values) {
        for (final accessible in [false, true]) {
          testWidgets(
            'table preview ${ng ? 'nextgen' : 'classic'} $width $brightness rtl/2x=$accessible',
            (tester) async {
              SharedPreferences.setMockInitialValues({});
              tester.view.physicalSize = Size(width, 1000);
              tester.view.devicePixelRatio = 1;
              addTearDown(tester.view.resetPhysicalSize);
              addTearDown(tester.view.resetDevicePixelRatio);
              final output = Platform.environment['TABLE_PREVIEW_DIR'];
              if (output != null) {
                final loader = FontLoader('TablePreview');
                loader.addFont(
                  Future.value(
                    ByteData.sublistView(
                      File('/System/Library/Fonts/SFNS.ttf').readAsBytesSync(),
                    ),
                  ),
                );
                await loader.load();
                for (final family in {
                  'Geist': [
                    'assets/fonts/geist/Geist-Regular.ttf',
                    'assets/fonts/geist/Geist-Medium.ttf',
                    'assets/fonts/geist/Geist-SemiBold.ttf',
                  ],
                  'GeistMono': ['assets/fonts/geist/GeistMono-Regular.ttf'],
                  'monospace': ['/System/Library/Fonts/SFNSMono.ttf'],
                  'MaterialIcons': [
                    '/opt/homebrew/share/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
                  ],
                }.entries) {
                  final font = FontLoader(family.key);
                  for (final path in family.value) {
                    font.addFont(
                      Future.value(
                        ByteData.sublistView(File(path).readAsBytesSync()),
                      ),
                    );
                  }
                  await font.load();
                }
              }
              final prefs = await SharedPreferences.getInstance();
              final connection = SavedConnection(
                id: 'demo',
                label: 'Demo',
                host: '127.0.0.1',
                port: 9,
                apiKey: '',
                desktopGatewayUrl: 'http://127.0.0.1:9',
                singleLogin: true,
                signInMethod: 'none',
              );
              final gateway = NextGenGateway(connection);
              final chat = NgChatController(gateway, sessionId: 'demo')
                ..runtimeId = 'demo';
              chat.debugApplyHistory([
                {'role': 'assistant', 'content': demoTable, 'id': 'demo-reply'},
              ]);
              var theme = ng
                  ? nextGenTheme(brightness, NextGenLook.instance)
                  : hermesTheme(brightness);
              if (output != null) {
                theme = theme.copyWith(
                  textTheme: theme.textTheme.apply(fontFamily: 'TablePreview'),
                );
              }
              final boundary = GlobalKey();
              await tester.pumpWidget(
                MaterialApp(
                  theme: theme,
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(accessible ? 2 : 1),
                    ),
                    child: Directionality(
                      textDirection: accessible
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: child!,
                    ),
                  ),
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: RepaintBoundary(
                    key: boundary,
                    child: Scaffold(
                      body: ng
                          ? NgScope(
                              connManager: ConnectionManager(prefs),
                              gateway: gateway,
                              connections: [connection],
                              switchTo: (_) async {},
                              addGateway: () async {},
                              signOut: (_) async {},
                              reload: () async {},
                              signInAgain: () async {},
                              child: NgChatView(chat: chat),
                            )
                          : SingleChildScrollView(
                              child: MessageBubble(
                                content: demoTable,
                                isUser: false,
                              ),
                            ),
                    ),
                  ),
                ),
              );
              await tester.pump();
              expect(find.byType(ResizableMarkdownTable), findsOneWidget);
              final viewport = find.byKey(const Key('table-horizontal-scroll'));
              final rect = tester.getRect(viewport);
              expect(rect.width, greaterThanOrEqualTo(width - 64));
              expect(rect.left, greaterThanOrEqualTo(0));
              expect(rect.right, lessThanOrEqualTo(width));
              expect(
                tester.getSize(find.byKey(const Key('table-col-0'))).width,
                greaterThanOrEqualTo(144),
              );
              var link = false;
              for (final rich in tester.widgetList<RichText>(
                find.descendant(
                  of: find.byType(ResizableMarkdownTable),
                  matching: find.byType(RichText),
                ),
              )) {
                expect(rich.text.toPlainText(), isNot(contains('**')));
                rich.text.visitChildren((span) {
                  if (span is TextSpan &&
                      span.recognizer is TapGestureRecognizer) {
                    link = true;
                  }
                  return true;
                });
              }
              expect(link, isTrue);
              expect(tester.takeException(), isNull);
              if (output != null &&
                  (width == 390 || width == 1440) &&
                  brightness == Brightness.dark &&
                  !accessible) {
                Future<void> save(String suffix) async {
                  await tester.runAsync(() async {
                    final image =
                        await (boundary.currentContext!.findRenderObject()!
                                as RenderRepaintBoundary)
                            .toImage();
                    final bytes = await image.toByteData(
                      format: ui.ImageByteFormat.png,
                    );
                    final file = File(
                      '$output/${ng ? 'nextgen' : 'classic'}-${width.toInt()}-$suffix.png',
                    );
                    file.parent.createSync(recursive: true);
                    file.writeAsBytesSync(bytes!.buffer.asUint8List());
                    image.dispose();
                  });
                }

                await save('initial');
                final scroll = find.descendant(
                  of: find.byType(ResizableMarkdownTable),
                  matching: find.byType(SingleChildScrollView),
                );
                await tester.drag(scroll.first, const Offset(-300, 0));
                await tester.pump(const Duration(seconds: 1));
                await save('scrolled');
              }
              await tester.pumpWidget(const SizedBox.shrink());
              chat.dispose();
              gateway.dispose();
              await tester.pump(const Duration(seconds: 31));
            },
          );
        }
      }
    }
  }
}
