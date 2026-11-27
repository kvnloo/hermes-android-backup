import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/config_backup_service.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/notification_approval_fixture.dart';
import 'helpers/windows_receipt_credentials.dart';
import 'package:hermes_android/core/services/connection_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final c = fixtureApprovalConnection('c-beta');
  late WindowsToastSink sink;
  Map posted = {};
  String? initial, delivery;
  var focuses = 0, denied = false;
  final cancelled = <int>[];
  late SharedPreferences prefs;
  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    sink = WindowsToastSink();
    notificationPrefs.value = NotificationPrefs.defaults;
    posted = {};
    initial = null;
    delivery = null;
    focuses = 0;
    denied = false;
    cancelled.clear();
    messenger.setMockMethodCallHandler(WindowsToastSink.channel, (m) async {
      switch (m.method) {
        case 'listen':
          return initial;
        case 'permission':
          return !denied;
        case 'show':
          posted = m.arguments as Map;
          if (denied) throw PlatformException(code: 'windows_toast');
          return delivery;
        case 'cancel':
          cancelled.add(m.arguments as int);
        case 'focus':
          focuses++;
      }
      return null;
    });
  });
  tearDown(() {
    WindowsToastSink.channel.setMethodCallHandler(null);
    messenger.setMockMethodCallHandler(WindowsToastSink.channel, null);
    debugDefaultTargetPlatformOverride = null;
    notificationPrefs.value = NotificationPrefs.defaults;
  });
  Future<String> show({
    int id = 17,
    HermesNotificationKind kind = HermesNotificationKind.approval,
  }) async {
    await sink.show(
      TurnNotification(
        id: id,
        title: 'private title',
        body: 'private command',
        payload: 'private transcript',
        kind: kind,
        actions: const [
          TurnNotificationAction(id: 'approve', label: 'Authorize'),
        ],
        channel: TurnNotificationService.attentionChannel,
        windowsTarget: WindowsToastTarget.capture(c, c.id, 'session-beta'),
      ),
    );
    return posted['ticket'] as String;
  }

  test(
    'only generic text and a random navigation ticket cross the platform channel',
    () async {
      initial = await show();
      expect(initial, matches(r'^[0-9a-f]{32}$'));
      expect(posted.keys.toSet(), {'id', 'ticket', 'body', 'quiet', 'sound'});
      final shell = jsonEncode(posted);
      final ledger = prefs.getString(WindowsToastSink.ledgerKey)!;
      for (final v in [
        c.apiKey,
        'Approve',
        'private title',
        'private command',
        'private transcript',
        'Authorize',
      ]) {
        expect(shell, isNot(contains(v)));
        expect(ledger, isNot(contains(v)));
      }
      expect(shell, isNot(contains(c.id)));
      expect(shell, isNot(contains('session-beta')));
      expect(
        ConfigBackupService.isBackedUpKey(WindowsToastSink.ledgerKey),
        isFalse,
      );
      final response =
          await WindowsToastSink().takeInitialLaunchResponse()
              as WindowsToastResponse;
      expect(response.target.matches(c), isTrue);
      expect(response.target.sessionId, 'session-beta');
      expect(
        response.target.matches(fixtureApprovalConnection('sibling')),
        isFalse,
      );
      expect(response.actionId, isNull);
      expect(response.payload, isNull);
      expect(response.target.matches(null), isFalse);
      final lease = ConnectionMutationBarrier.begin([c.id]);
      lease.release();
      expect(response.target.matches(c), isFalse);
      expect(await sink.takeInitialLaunchResponse(), isNull);
      expect(focuses, 1);
    },
  );
  test(
    'replaced, cancelled, expired, malformed and unknown tickets do not navigate or focus',
    () async {
      final old = await show();
      final current = await show();
      expect(old, isNot(current));
      for (final invalid in [old, 'approve', '$current?x', 'a' * 32]) {
        initial = invalid;
        expect(await sink.takeInitialLaunchResponse(), isNull);
      }
      await sink.cancel(17);
      initial = current;
      expect(await sink.takeInitialLaunchResponse(), isNull);
      initial = await show();
      final map =
          jsonDecode(prefs.getString(WindowsToastSink.ledgerKey)!) as Map;
      map[initial]['expires'] = 1;
      await prefs.setString(WindowsToastSink.ledgerKey, jsonEncode(map));
      expect(await sink.takeInitialLaunchResponse(), isNull);
      initial = await show();
      await sink.cancelAll();
      expect(await sink.takeInitialLaunchResponse(), isNull);
      expect(focuses, 0);
    },
  );
  test(
    'edits durably revoke only this account, even after restoring its credentials',
    () async {
      final edit = fixtureApprovalConnection('edit');
      await prefs.setStringList('saved_connections', [
        jsonEncode(edit.toMap()),
        jsonEncode(c.toMap()),
      ]);
      final manager = ConnectionManager(
        prefs,
        credentialStore: WindowsReceiptCredentials(),
      );
      final survivingTicket = await show();
      final captured = WindowsToastTarget.capture(edit, edit.id, 'old')!;
      final notification = TurnNotification(
        id: 99,
        title: 'example',
        body: 'example',
        payload: '',
        kind: HermesNotificationKind.input,
        channel: TurnNotificationService.attentionChannel,
        windowsTarget: captured,
      );
      await sink.show(notification);
      final revokedTicket = posted['ticket'];
      await manager.updateApiKey(edit.id, 'temporary-fixture-value');
      await manager.updateApiKey(edit.id, edit.apiKey);
      await prefs.reload();
      expect(
        (jsonDecode(prefs.getString(WindowsToastSink.ledgerKey)!) as Map).keys,
        [survivingTicket],
      );
      await expectLater(
        WindowsToastSink().show(notification),
        throwsStateError,
      );
      initial = revokedTicket;
      expect(await WindowsToastSink().takeInitialLaunchResponse(), isNull);
      initial = survivingTicket;
      final response =
          await WindowsToastSink().takeInitialLaunchResponse()
              as WindowsToastResponse;
      expect(response.target.matches(c), isTrue);
    },
  );

  test(
    'OS refusal is not recorded as delivery and does not leave a live ticket',
    () async {
      denied = true;
      final service = TurnNotificationService(sink: sink);
      expect(
        await service.sendTestNotification(title: 't', body: 'b'),
        isFalse,
      );
      expect(service.permissionGranted, isFalse);
      expect(posted, isEmpty);
      expect(
        await service.showKind(
          kind: HermesNotificationKind.input,
          title: 't',
          body: 'b',
          eventId: 'event',
          origin: c,
          sessionId: 's',
          connectionId: c.id,
        ),
        isFalse,
      );
      initial = posted['ticket'];
      expect(await sink.takeInitialLaunchResponse(), isNull);
      expect(focuses, 0);
    },
  );
  test(
    'a toast Windows accepted but will not display is withdrawn; an unknown setting stays live',
    () async {
      delivery = 'blocked';
      await expectLater(show(id: 31), throwsStateError);
      final blocked = posted['ticket'] as String;
      // The runner may already have the toast: take it down by its own id.
      expect(cancelled, [31]);
      initial = blocked;
      expect(await sink.takeInitialLaunchResponse(), isNull);

      delivery = 'unknown';
      initial = await show(id: 32);
      expect(cancelled, [31]);
      final response =
          await WindowsToastSink().takeInitialLaunchResponse()
              as WindowsToastResponse;
      expect(response.target.sessionId, 'session-beta');
      expect(focuses, 1);
    },
  );
  test(
    'per-kind preferences suppress posting and revoke a pending click; sound persists',
    () async {
      await NotificationPrefsStore.setWindowsSound(WindowsCompletionSound.mail);
      initial = await show(kind: HermesNotificationKind.turnDone);
      expect(posted['sound'], 'mail');
      notificationPrefs.value = NotificationPrefs.defaults;
      await NotificationPrefsStore.load();
      expect(
        notificationPrefs.value.completionSound,
        WindowsCompletionSound.mail,
      );
      await NotificationPrefsStore.setKind(
        HermesNotificationKind.turnDone,
        false,
      );
      expect(await sink.takeInitialLaunchResponse(), isNull);
      await expectLater(
        show(kind: HermesNotificationKind.turnDone),
        throwsStateError,
      );
      initial = await show();
      await NotificationPrefsStore.setEnabled(false);
      expect(await sink.takeInitialLaunchResponse(), isNull);
      expect(focuses, 0);
    },
  );
}
