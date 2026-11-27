// Isolated native acceptance entry point. Never build this as Ares. Its runner
// must have a distinct binary name, version-resource product name, app ID and
// URI scheme. Never read an installed user's Ares preferences or credentials.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isWindows ||
      !Platform.resolvedExecutable.toLowerCase().endsWith(
        r'\ares_toast_probe.exe',
      )) {
    exit(2);
  }
  final dir = await getApplicationSupportDirectory();
  if (!dir.path.toLowerCase().endsWith(r'\ares toast probe')) exit(3);
  final receipt = File('${dir.path}/receipt.jsonl');
  void note(Map<String, Object?> event) => receipt.writeAsStringSync(
    '${jsonEncode({'pid': pid, ...event})}\n',
    mode: FileMode.append,
    flush: true,
  );
  final connection = SavedConnection(
    id: 'qa-connection',
    label: 'Synthetic',
    host: 'invalid.invalid',
    port: 1,
    apiKey: '',
    gatewayProfile: 'qa',
  );
  final sink = WindowsToastSink();
  final service = TurnNotificationService(sink: sink);
  final status = ValueNotifier<String>('Synthetic Windows toast check');
  void receive(Object response) {
    if (response is WindowsToastResponse &&
        response.target.matches(connection)) {
      note({
        'route': response.target.sessionId,
        'connection': response.target.connectionId,
        'profile': connection.gatewayProfile,
      });
      status.value = response.target.sessionId;
    } else {
      note({'error': 'unmatched target'});
    }
  }

  notificationResponseHandler = receive;
  final initial = await service.takeInitialNotificationResponse();
  if (initial != null) receive(initial);
  runApp(
    MaterialApp(
      home: ValueListenableBuilder<String>(
        valueListenable: status,
        builder: (_, s, _) => Scaffold(body: Text(s)),
      ),
    ),
  );
  await service.ensureInitialized(requestPermission: true);
  note({
    'started': true,
    'permission': service.permissionGranted,
    'initial': initial != null,
  });
  // Automation only selects from these fixed commands, in the test app's own
  // data directory. No arbitrary arguments, network, file paths or commands.
  final command = File('${dir.path}/command.txt');
  var busy = false;
  Timer.periodic(const Duration(milliseconds: 250), (_) async {
    if (busy || !command.existsSync()) return;
    busy = true;
    try {
      final action = command.readAsStringSync().trim();
      command.deleteSync();
      if (action == 'exit') {
        note({'exit': true});
        exit(0);
      }
      if (action == 'clear') {
        await sink.cancelAll();
        note({'clear': true});
      }
      if (action != 'warm' && action != 'cold' && action != 'active') return;
      final ok = await service.showKind(
        kind: HermesNotificationKind.input,
        title: 'Fixture',
        body: 'Fixture',
        eventId: action,
        sessionId: 'qa-$action',
        connectionId: connection.id,
        origin: connection,
      );
      note({
        'posted': ok,
        'session': 'qa-$action',
        'outcome': TurnNotificationService.recentAttempts.value.first.detail,
      });
    } catch (_) {
      note({'error': 'probe operation failed'});
    } finally {
      busy = false;
    }
  });
}
