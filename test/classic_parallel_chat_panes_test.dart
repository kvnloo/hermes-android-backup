import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/classic_parallel_chat_pane.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/parallel_workspace_fixture.dart';

void main() {
  testWidgets(
    'two native Classic panes send concurrent turns with distinct session headers',
    (tester) async {
      // Classic deliberately withholds partial prose in quiet mode.
      SharedPreferences.setMockInitialValues({'verbose_mode': true});
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1600, 940);
      addTearDown(tester.view.reset);
      final f = ParallelFixture();
      final roster = f.api();
      addTearDown(roster.close);
      final rows = (await roster.getSessionsPage()).sessions;
      final streams = <String, StreamController<List<int>>>{};
      ApiClient paneApi() => ApiClient.forConnection(
        f.connection,
        httpClient: MockClient.streaming((req, body) async {
          if (req.method == 'POST' && req.url.path == '/v1/chat/completions') {
            final id = req.headers['X-Hermes-Session-Id']!;
            final stream = StreamController<List<int>>();
            streams[id] = stream;
            return http.StreamedResponse(
              stream.stream,
              200,
              headers: {'content-type': 'text/event-stream'},
            );
          }
          return http.StreamedResponse(
            Stream.value(utf8.encode('{"data":[]}')),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final turnOwner = GatewayTurnApplicationController();
      addTearDown(turnOwner.close);
      await tester.pumpWidget(
        MaterialApp(
          theme: hermesTheme(Brightness.dark),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Row(
            children: [
              for (final row in rows)
                Expanded(
                  child: ClassicParallelChatPane(
                    connection: f.connection,
                    session: row,
                    controller: turnOwner,
                    testClientFactory: paneApi,
                    close: () {},
                  ),
                ),
            ],
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      Finder within(String id, Finder what) => find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is ClassicParallelChatPane && w.session.id == id,
        ),
        matching: what,
      );
      for (final id in ['alpha', 'beta']) {
        await tester.enterText(
          within(id, find.byKey(const Key('chat-message-composer'))),
          'Prompt $id',
        );
        await tester.pump();
        await tester.tap(
          within(id, find.byKey(const Key('chat-send-message'))),
        );
        await tester.pump();
      }
      expect(streams.keys, unorderedEquals(['alpha', 'beta']));
      for (final id in ['beta', 'alpha']) {
        streams[id]!.add(
          utf8.encode(
            'data: {"choices":[{"delta":{"content":"Stream $id"}}]}\n\n',
          ),
        );
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      for (final id in ['alpha', 'beta']) {
        expect(
          within(id, find.text('Stream $id', findRichText: true)),
          findsOneWidget,
        );
        expect(find.text('Stream $id', findRichText: true), findsOneWidget);
        streams[id]!
          ..add(utf8.encode('data: [DONE]\n\n'))
          ..close();
      }
      // Joining the stream cancellation may complete in the root async zone.
      for (var i = 0; turnOwner.hasActiveTurn && i < 12; i++) {
        await tester.pump();
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      }
      expect(turnOwner.hasActiveTurn, isFalse);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );
}
