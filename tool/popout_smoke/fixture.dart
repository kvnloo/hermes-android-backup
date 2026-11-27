import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:hermes_android/core/screens/parallel_workspace_entry.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/workspace/workspace_popout.dart';
import 'package:hermes_android/core/workspace/popout_bootstrap.dart';
import 'package:hermes_android/core/workspace/popout_protocol.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';

class Paths extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async => Directory.systemTemp.path;
}

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  final ng = Platform.environment['ARES_FIXTURE_NEXTGEN'] == '1';
  final port = int.parse(Platform.environment['ARES_FIXTURE_PORT']!);
  final c = SavedConnection(
    id: 'fixture-c',
    label: 'Fixture',
    host: '127.0.0.1',
    port: port,
    apiKey: '',
    singleLogin: ng,
    dashboardProxied: ng,
    desktopGatewayUrl: ng ? 'http://127.0.0.1:$port' : null,
    // Keep optional Classic dashboard reads in this fixture too; never fall
    // back to a service already listening on the standard dashboard port.
    dashboardPortOverride: port,
  );
  // Synthetic storage only. The smoke target never loads a physical keychain.
  // ignore: invalid_use_of_visible_for_testing_member
  FlutterSecureStorage.setMockInitialValues({});
  SharedPreferencesStorePlatform.instance =
      InMemorySharedPreferencesStore.withData({
        'flutter.saved_connections': <String>[jsonEncode(c.toMap())],
      });
  PathProviderPlatform.instance = Paths();
  if (args.contains(workspacePopoutMarker)) {
    runWorkspacePopoutChild(args);
    void inspect(Duration _) {
      bool chat = false, text = false;
      void visit(Element el) {
        final w = el.widget;
        if (!ng && w is ChatScreen && w.session.id == 'fixture-s') chat = true;
        if (ng && w is NgChatView && w.chat.storedId == 'fixture-s') {
          chat = true;
        }
        final rendered = switch (w) {
          RichText() => w.text.toPlainText(),
          SelectableText() => w.data ?? w.textSpan?.toPlainText(),
          _ => null,
        };
        if (rendered?.contains('isolated-only rendered history') == true) {
          text = true;
        }
        el.visitChildElements(visit);
      }

      visit(WidgetsBinding.instance.rootElement!);
      if (chat && text) {
        // The driver reads only this receipt from its ephemeral loopback server.
        unawaited(() async {
          final client = HttpClient();
          try {
            await (await client.postUrl(
              Uri.parse('http://127.0.0.1:$port/visible/$pid'),
            )).close();
          } finally {
            client.close();
          }
        }());
      } else {
        WidgetsBinding.instance.addPostFrameCallback(inspect);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback(inspect);
    return;
  }
  nextGenEnabled.value = ng;
  var opened = false;
  runApp(
    MaterialApp(
      home: ParallelWorkspaceEntryHost(
        owner: c,
        connection: c,
        workspace: (_) => const SizedBox(),
        home: (_) => Builder(
          builder: (context) {
            if (!opened) {
              opened = true;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await openWorkspacePopout(
                  context,
                  sessionId: 'fixture-s',
                  connectionId: c.id,
                  profile: '',
                  nextGen: ng,
                );
                stdout.writeln('LAUNCH_RETURNED');
                await stdin.first;
                ConnectionMutationBarrier.begin([c.id]).release();
                stdout.writeln('REVOKED');
              });
            }
            return const Scaffold(body: Center(child: Text('Isolated owner')));
          },
        ),
      ),
    ),
  );
}
