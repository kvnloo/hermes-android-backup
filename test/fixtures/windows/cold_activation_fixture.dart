import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/windows_receipt_credentials.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'cold activation follows the stored Windows ticket after restart',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final c = SavedConnection(
        id: 'fixture',
        label: 'Fixture',
        host: 'fixture.invalid',
        port: 1,
        apiKey: '',
      );
      final receiptFile = File(Platform.environment['ARES_TEST_RECEIPT_FILE']!);
      final issuing = Platform.environment['RECEIPT_PHASE'] == 'issue';
      final edit = Platform.environment['RECEIPT_EDIT'] == 'yes';
      final saved = issuing
          ? <String, dynamic>{}
          : jsonDecode(receiptFile.readAsStringSync()) as Map<String, dynamic>;
      SharedPreferences.setMockInitialValues({
        'saved_connections': [
          issuing ? jsonEncode(c.toMap()) : saved['row'] as String,
        ],
        if (!issuing) WindowsToastSink.ledgerKey: saved['ledger'] as String,
      });
      final prefs = await SharedPreferences.getInstance();
      final manager = ConnectionManager(
        prefs,
        credentialStore: WindowsReceiptCredentials(),
      );
      final sink = WindowsToastSink();
      String? token = saved['ticket'] as String?;
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(WindowsToastSink.channel, (m) async {
        if (m.method == 'show') token = m.arguments['ticket'];
        if (m.method == 'listen') return token;
        return null;
      });
      if (issuing) {
        final target = WindowsToastTarget.capture(
          manager.getConnections().single,
          c.id,
          'fixture-chat',
        )!;
        expect(target.matches(manager.getConnections().single), isTrue);
        await sink.show(
          TurnNotification(
            id: 1,
            title: 'Fixture',
            body: 'Fixture',
            payload: '',
            kind: HermesNotificationKind.turnDone,
            channel: TurnNotificationService.turnChannel,
            windowsTarget: target,
          ),
        );
        if (edit) {
          await manager.updateApiKey(c.id, 'local-fixture-placeholder');
          expect(target.matches(manager.getConnections().single), isFalse);
          await manager.updateApiKey(c.id, '');
          expect(target.matches(manager.getConnections().single), isFalse);
        }
        receiptFile.writeAsStringSync(
          jsonEncode({
            'ticket': token,
            'ledger': prefs.getString(WindowsToastSink.ledgerKey),
            'row': prefs.getStringList('saved_connections')!.single,
          }),
        );
      } else {
        final response =
            await sink.takeInitialLaunchResponse() as WindowsToastResponse?;
        final admits =
            response?.target.matches(manager.getConnections().single) ?? false;

        expect(
          admits,
          !edit,
          reason:
              'Only a never-mutated account may accept its prior-process ticket',
        );
      }
    },
  );
}
