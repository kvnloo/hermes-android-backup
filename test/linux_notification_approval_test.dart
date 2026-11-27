import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/notification_approval_authority.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/inert_turn_application_session.dart';
import 'support/recording_turn_notification_sink.dart';

class _MemoryCredentialStore implements CredentialStore {
  final Map<String, String> _values = {};
  @override
  Future<void> delete(String key) async => _values.remove(key);
  @override
  Future<String?> read(String key) async => _values[key];
  @override
  String? readCached(String key) => _values[key];
  @override
  Future<void> write(String key, String value) async => _values[key] = value;
}

/// The owner a notification answer reaches: records exactly what it was
/// asked to answer.
class _Owner extends InertTurnApplicationSession {
  final answers = <(String, String, String?)>[];
  @override
  Future<bool> tryRespondToApproval({
    required String sessionId,
    required String choice,
    String? requestId,
  }) async {
    answers.add((sessionId, choice, requestId));
    return true;
  }
}

/// What flutter_local_notifications_linux delivers for a pressed action
/// (NotificationsManager, ActionInvoked): the action key, the posted payload
/// and selectedNotificationAction, the same shape Android and Darwin use.
NotificationResponse _pressed(String key, Map<String, Object?> payload) =>
    NotificationResponse(
      id: 7,
      actionId: key,
      payload: jsonEncode(payload),
      notificationResponseType:
          NotificationResponseType.selectedNotificationAction,
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    pendingNotificationApprovals.value = const [];
  });

  tearDown(() {
    pendingNotificationApprovals.value = const [];
    notificationResponseHandler = null;
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'Linux approval notifications carry the same action keys as Android',
    () {
      final notification = TurnNotification(
        id: 7,
        title: 'Approval needed',
        body: 'Open the chat to review the requested action.',
        payload: '{}',
        channel: TurnNotificationService.attentionChannel,
        kind: HermesNotificationKind.approval,
        actions: [
          TurnNotificationAction(id: 'approve', label: 'Approve'),
          TurnNotificationAction(id: 'reject', label: 'Deny'),
        ],
      );
      final details = turnNotificationDetails(notification);
      expect(
        [for (final a in details.linux!.actions) a.key],
        ['approve', 'reject'],
      );
      expect(
        [for (final a in details.android!.actions!) a.id],
        ['approve', 'reject'],
      );
      expect(_pressed('approve', {}).actionId, 'approve');
    },
  );

  for (final platform in [TargetPlatform.android, TargetPlatform.linux]) {
    testWidgets(
      'on ${platform.name} an Approve/Deny press reaches the exact owner, '
      'profile and request; foreign, stale and unscoped presses are refused',
      (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        final prefs = await SharedPreferences.getInstance();
        final manager = await ConnectionManager.create(
          prefs,
          credentialStore: _MemoryCredentialStore(),
        );
        // Two profiles on one endpoint: only the saved profile may answer.
        await manager.saveConnection(
          'Profile A',
          '127.0.0.1',
          1,
          'key-a',
          gatewayProfile: 'alpha',
        );
        await manager.saveConnection(
          'Profile B',
          '127.0.0.1',
          1,
          'key-b',
          gatewayProfile: 'beta',
        );
        final saved = manager.getConnections();
        final target = saved.firstWhere((c) => c.gatewayProfile == 'beta');
        final sibling = saved.firstWhere((c) => c.gatewayProfile == 'alpha');
        final owners = <String, _Owner>{};
        final controller = GatewayTurnApplicationController(
          sessionFactory: (c) => owners[c.id] ??= _Owner(),
        );
        addTearDown(controller.close);
        await tester.pumpWidget(
          HermesApp(
            connManager: manager,
            turnApplicationController: controller,
            notifications: TurnNotificationService(
              sink: RecordingTurnNotificationSink(),
            ),
          ),
        );
        await tester.pump();
        Future<void> press(String key, Map<String, Object?> payload) async {
          notificationResponseHandler!(_pressed(key, payload));
          for (var i = 0; i < 8; i++) {
            await tester.pump();
            await tester.runAsync(() => Future<void>.delayed(Duration.zero));
          }
        }

        List<(String, String, String?)> answers(String id) =>
            owners[id]?.answers ?? const [];
        Map<String, Object?> payload(
          String request, {
          String? connectionId,
          Map<String, String>? origin,
        }) => {
          'connectionId': connectionId ?? target.id,
          'sessionId': 'shared-session',
          'requestId': request,
          ...?origin,
        };

        await press(
          'approve',
          payload(
            'request-1',
            origin: NotificationApprovalAuthority.origin(target),
          ),
        );
        await press(
          'reject',
          payload(
            'request-2',
            origin: NotificationApprovalAuthority.origin(target),
          ),
        );
        expect(answers(target.id), [
          ('shared-session', 'once', 'request-1'),
          ('shared-session', 'deny', 'request-2'),
        ]);
        expect(
          answers(sibling.id),
          isEmpty,
          reason: 'same endpoint, other profile',
        );

        // Foreign: another account's origin stamped on this connection.
        await press(
          'approve',
          payload(
            'request-3',
            origin: NotificationApprovalAuthority.origin(sibling),
          ),
        );
        // Unscoped: a legacy payload without origin never answers by itself.
        await press('approve', payload('request-4'));
        // Stale: the account was edited after the notification was posted.
        final stale = NotificationApprovalAuthority.origin(target);
        ConnectionMutationBarrier.begin([target.id]).release();
        await press('approve', payload('request-5', origin: stale));
        expect(answers(target.id), hasLength(2));
        expect(answers(sibling.id), isEmpty);
        expect(pendingNotificationApprovals.value, isEmpty);

        // The sibling's own press reaches only the sibling's owner.
        await press(
          'approve',
          payload(
            'request-6',
            connectionId: sibling.id,
            origin: NotificationApprovalAuthority.origin(sibling),
          ),
        );
        expect(answers(sibling.id), [('shared-session', 'once', 'request-6')]);
        expect(answers(target.id), hasLength(2));
        await tester.pumpWidget(const SizedBox.shrink());
        debugDefaultTargetPlatformOverride = null;
      },
    );
  }
}
