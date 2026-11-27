import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/main.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Memory implements CredentialStore {
  @override
  Future<String?> read(String key) async => null;
  @override
  String? readCached(String key) => null;
  @override
  Future<void> delete(String key) async {}
  @override
  Future<void> write(String key, String value) async {}
}

void main() {
  for (final ng in [false, true]) {
    testWidgets(
      'Windows ${ng ? 'NextGen' : 'Classic'} consumes the scoped initial ticket instead of the selected sibling',
      (t) async {
        SavedConnection saved(String id) => SavedConnection(
          id: id,
          label: id,
          host: '127.0.0.1',
          port: 1,
          apiKey: '',
          gatewayProfile: id,
        );
        SharedPreferences.setMockInitialValues({
          'saved_connections': [
            for (final id in ['alpha', 'beta']) jsonEncode(saved(id).toMap()),
          ],
          NextGenPreferences.currentConnectionKey: 'alpha',
        });
        final prefs = await SharedPreferences.getInstance();
        final manager = ConnectionManager(prefs, credentialStore: _Memory());
        final beta = manager.getConnections().singleWhere(
          (c) => c.id == 'beta',
        );
        nextGenEnabled.value = ng;
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        String? ticket;
        messenger.setMockMethodCallHandler(WindowsToastSink.channel, (m) async {
          if (m.method == 'show') ticket = m.arguments['ticket'];
          if (m.method == 'listen') return ticket;
          if (m.method == 'permission') return true;
          return null;
        });
        addTearDown(() {
          nextGenEnabled.value = false;
          nextGenOpenRequest.value = null;
          pendingWindowsToastTarget = null;
          messenger.setMockMethodCallHandler(WindowsToastSink.channel, null);
          WindowsToastSink.channel.setMethodCallHandler(null);
        });
        final service = TurnNotificationService(sink: WindowsToastSink());
        await service.showKind(
          kind: HermesNotificationKind.approval,
          title: 'private',
          body: 'private',
          eventId: 'attention',
          sessionId: 'shared-session',
          connectionId: beta.id,
          origin: beta,
          actions: const [
            TurnNotificationAction(id: 'approve', label: 'approve'),
          ],
        );
        expect(ticket, isNotNull);
        final lookups = <(String, String)>[];
        await t.pumpWidget(
          HermesApp(
            connManager: manager,
            notifications: service,
            testNotificationSessionLookup: (c, id) async {
              lookups.add((c.id, id));
              return Session.fromJson({
                'id': id,
                'title': 'Fixture chat',
                'source': 'mobile',
              });
            },
          ),
        );
        for (var i = 0; i < 12; i++) {
          await t.pump(const Duration(milliseconds: 100));
        }
        if (ng) {
          expect(NextGenPreferences.currentConnectionId(prefs), 'beta');
          expect(
            NextGenPreferences.lastSession(prefs, 'beta'),
            'shared-session',
          );
          expect(nextGenNotificationAnswer.value, isNull);
        } else {
          expect(lookups, [('beta', 'shared-session')]);
          final page = t.widget<ChatScreen>(find.byType(ChatScreen));
          expect(page.connection.id, 'beta');
          expect(page.session.id, 'shared-session');
        }
        expect(pendingNotificationApprovals.value, isEmpty);
        await t.pumpWidget(const SizedBox());
        await t.pump(const Duration(seconds: 45));
      },
      variant: TargetPlatformVariant.only(TargetPlatform.windows),
    );
  }
}
