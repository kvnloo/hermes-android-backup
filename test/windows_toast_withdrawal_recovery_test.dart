import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'helpers/notification_approval_fixture.dart';

class _Preferences extends InMemorySharedPreferencesStore {
  _Preferences() : super.empty();
  bool rejectNext = false;
  int rejections = 0;

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    if (rejectNext && key == 'flutter.${WindowsToastSink.ledgerKey}') {
      rejectNext = false;
      rejections++;
      return false;
    }
    return super.setValue(valueType, key, value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final failOnce in [false, true]) {
    test(
      'withdraw an acknowledged toast, first ledger rejection: $failOnce',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        SharedPreferences.setMockInitialValues({});
        final original = SharedPreferencesStorePlatform.instance;
        final store = _Preferences();
        SharedPreferencesStorePlatform.instance = store;
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        addTearDown(() {
          messenger.setMockMethodCallHandler(WindowsToastSink.channel, null);
          WindowsToastSink.channel.setMethodCallHandler(null);
          SharedPreferencesStorePlatform.instance = original;
          debugDefaultTargetPlatformOverride = null;
        });
        final arrived = Completer<void>(), ack = Completer<void>();
        final seen = <int, String>{},
            deleted = <int>[],
            durableOnCancel = <Set<String>>[];
        var needed = true, focuses = 0;
        int? selected;
        messenger.setMockMethodCallHandler(WindowsToastSink.channel, (m) async {
          switch (m.method) {
            case 'show':
              final id = m.arguments['id'] as int;
              seen[id] = m.arguments['ticket'] as String;
              if (id == 77) {
                arrived.complete();
                await ack.future;
                store.rejectNext = failOnce;
              }
            case 'cancel':
              deleted.add(m.arguments as int);
              final disk = await store.getAll();
              final ledger =
                  jsonDecode(
                        disk['flutter.${WindowsToastSink.ledgerKey}'] as String,
                      )
                      as Map;
              durableOnCancel.add(ledger.keys.cast<String>().toSet());
            case 'cancelAll':
              fail('A sibling notification must not be cancelled');
            case 'listen':
              return seen[selected];
            case 'focus':
              focuses++;
          }
          return null;
        });
        final sink = WindowsToastSink();
        Future<void> post(
          int id,
          String connectionId, {
          bool Function()? stillNeeded,
        }) {
          final c = fixtureApprovalConnection(connectionId);
          return sink.show(
            TurnNotification(
              id: id,
              title: 'Fixture',
              body: 'Input needed',
              payload: '',
              channel: TurnNotificationService.attentionChannel,
              kind: HermesNotificationKind.input,
              windowsTarget: WindowsToastTarget.capture(
                c,
                c.id,
                'same-session-id',
              ),
              windowsStillNeeded: stillNeeded,
            ),
          );
        }

        await post(23, 'sibling');
        final withdrawal = expectLater(
          post(77, 'returning', stillNeeded: () => needed),
          throwsStateError,
        );
        await arrived.future;
        needed = false;
        selected = 77;
        final click = sink.takeInitialLaunchResponse();
        ack.complete();
        await withdrawal;
        expect(await click, isNull);
        expect(focuses, 0);
        expect(store.rejections, failOnce ? 1 : 0);
        expect(deleted, [77]);
        expect(durableOnCancel.single, {seen[23]!});
        selected = 23;
        final other =
            await sink.takeInitialLaunchResponse() as WindowsToastResponse;
        expect(other.target.connectionId, 'sibling');
      },
    );
  }
}
