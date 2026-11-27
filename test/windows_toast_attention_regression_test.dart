import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/windows_receipt_credentials.dart';

class _Offline extends NextGenGateway {
  _Offline(super.connection)
    : super(
        dashboard: DashboardClient.fromConnection(
          connection,
          httpClient: MockClient((_) async => http.Response('{}', 503)),
        ),
      );
  @override
  void start() {}
  @override
  void retry() {}
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async => throw StateError('fixture offline');
}

void main() {
  for (final mode in ['missing', 'unmapped', 'withdrawn', 'unchanged']) {
    final noSession = mode == 'missing';
    final withdraw = mode == 'withdrawn';
    testWidgets(
      'Windows attention routing: $mode',
      (t) async {
        final c = SavedConnection(
          id: 'fixture',
          label: 'Fixture',
          host: 'fixture.invalid',
          port: 9119,
          apiKey: '',
        );
        SharedPreferences.setMockInitialValues({
          '${NextGenPreferences.lastSessionKeyPrefix}fixture': 'visible-chat',
          'saved_connections': [jsonEncode(c.toMap())],
        });
        final prefs = await SharedPreferences.getInstance();
        final gateway = _Offline(c)..bindRuntime('runtime-1', 'visible-chat');
        final sink = WindowsToastSink();
        final service = TurnNotificationService(sink: sink);
        TurnNotificationService.debugShared = service;
        addTearDown(() => TurnNotificationService.debugShared = null);
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        final gate = Completer<void>();
        String? ticket;
        int cancels = 0;
        messenger.setMockMethodCallHandler(WindowsToastSink.channel, (m) async {
          if (m.method == 'permission') return true;
          if (m.method == 'show') {
            ticket = m.arguments['ticket'];
            if (withdraw) await gate.future;
          }
          if (m.method == 'cancel') cancels++;
          if (m.method == 'listen') return ticket;
          return null;
        });
        await service.ensureInitialized();
        await t.pumpWidget(
          MaterialApp(
            theme: nextGenTheme(Brightness.light, NextGenLook.instance),
            home: NgScope(
              connManager: ConnectionManager(
                prefs,
                credentialStore: WindowsReceiptCredentials(),
              ),
              gateway: gateway,
              connections: [c],
              switchTo: (_) async {},
              addGateway: () async {},
              signOut: (_) async {},
              reload: () async {},
              signInAgain: () async {},
              child: const NgMainPage(),
            ),
          ),
        );
        await t.pump(const Duration(milliseconds: 300));
        t.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        await t.pump();
        expect(
          gateway.acceptServerRequest(
            GatewayServerRequest.forTesting(
              id: 'fixture-request',
              method: 'clarify',
              params: {
                'question': 'Fixture question',
                if (!noSession)
                  'session_id': mode == 'unmapped'
                      ? 'some-unknown-runtime'
                      : 'runtime-1',
              },
            ),
          ),
          isTrue,
        );
        await t.pump();
        await t.pump();
        expect(ticket, isNotNull);
        if (withdraw) {
          t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
          await t.pump();
          gate.complete();
          await t.pump();
          await t.pump();
        }
        final response =
            await sink.takeInitialLaunchResponse() as WindowsToastResponse?;
        final session = response?.target.sessionId;
        expect(cancels, withdraw ? 1 : 0);
        await t.pumpWidget(const SizedBox());
        gateway.dispose();
        await t.pump(const Duration(seconds: 45));
        expect(session, mode == 'unchanged' ? 'visible-chat' : null);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.windows),
    );
  }
}
