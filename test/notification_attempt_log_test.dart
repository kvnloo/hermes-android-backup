import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/widgets/recent_notifications_sheet.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/notification_approval_fixture.dart';
import 'support/recording_turn_notification_sink.dart';

class _FailingSink extends RecordingTurnNotificationSink {
  Object? error;
  @override
  Future<void> show(TurnNotification notification) async {
    if (error != null) throw error!;
    await super.show(notification);
  }
}

const _windowsAccessDenied = 'PlatformException(windows_toast 0x80070005)';

final _earlierRun = {
  'at': DateTime.utc(2026, 11, 24, 10).millisecondsSinceEpoch,
  'kind': 'turnDone',
  'outcome': 'failed',
  'id': 494805219,
  'error': _windowsAccessDenied,
};

Future<List<Map<String, dynamic>>> _stored() async {
  // Let the single in-flight writer drain.
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(TurnNotificationService.attemptsStorageKey);
  return raw == null
      ? []
      : (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({
      TurnNotificationService.attemptsStorageKey: jsonEncode([_earlierRun]),
    });
    TurnNotificationService.debugResetAttempts();
    notificationPrefs.value = NotificationPrefs.defaults;
  });
  tearDown(TurnNotificationService.debugResetAttempts);

  test(
    'earlier runs load behind this run and survive the next write',
    () async {
      TurnNotificationService.recordAttempt('reply', 'Now', 'skipped');
      await TurnNotificationService.loadRecentAttempts();
      final attempts = TurnNotificationService.recentAttempts.value;
      expect(attempts.map((a) => a.outcome), ['skipped', 'failed']);
      final earlier = attempts.last;
      expect(earlier.title, isEmpty);
      expect(earlier.id, 494805219);
      expect(earlier.reference, '#494805219 · $_windowsAccessDenied');
      expect((await _stored()).map((a) => a['kind']), ['reply', 'turnDone']);
    },
  );

  test(
    'only kind, id, outcome and error class are stored, at most 50',
    () async {
      final sink = _FailingSink()
        ..error = PlatformException(
          code: 'windows_toast',
          message: 'Windows notification error -2147024891',
          details: 'private body',
        );
      final service = TurnNotificationService(sink: sink);
      await service.ensureInitialized();
      expect(
        await service.showKind(
          kind: HermesNotificationKind.turnDone,
          title: 'Private chat title',
          body: 'private body',
          eventId: 'turn-1',
          sessionId: 'session',
          connectionId: 'connection',
        ),
        isFalse,
      );
      final failed = (await _stored()).first;
      expect(failed, {
        'at': isA<int>(),
        'kind': 'turnDone',
        'outcome': 'failed',
        'id': TurnNotificationService.notificationIdFor(
          jsonEncode(['turnDone', 'connection', 'session', 'turn-1']),
        ),
        'error': _windowsAccessDenied,
      });
      // This run still shows its own title and detail on screen.
      expect(
        TurnNotificationService.recentAttempts.value.first.title,
        'Private chat title',
      );

      sink.error = null;
      for (var i = 0; i < 60; i++) {
        TurnNotificationService.recordAttempt('reply', 'Chat $i', 'posted');
      }
      final stored = await _stored();
      expect(stored, hasLength(TurnNotificationService.maxAttempts));
      final text = jsonEncode(stored);
      for (final private in ['Private', 'private body', 'Chat 5', 'error -']) {
        expect(text, isNot(contains(private)));
      }
    },
  );

  test('error classes never include message text', () {
    expect(
      TurnNotificationService.errorClass(StateError('Notification withdrawn')),
      'StateError(Notification withdrawn)',
    );
    expect(
      TurnNotificationService.errorClass(StateError('Chat: secret reply')),
      'StateError',
    );
    expect(
      TurnNotificationService.errorClass(
        PlatformException(code: 'error', message: 'secret reply'),
      ),
      'PlatformException(error)',
    );
    expect(
      TurnNotificationService.errorClass(MissingPluginException('ares')),
      'MissingPluginException',
    );
  });

  group('Windows activations are recorded without their ticket', () {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    String? launch;
    setUp(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      messenger.setMockMethodCallHandler(WindowsToastSink.channel, (m) async {
        if (m.method == 'show') launch = m.arguments['ticket'] as String;
        if (m.method == 'listen') return launch;
        return null;
      });
    });
    tearDown(() {
      messenger.setMockMethodCallHandler(WindowsToastSink.channel, null);
      WindowsToastSink.channel.setMethodCallHandler(null);
      debugDefaultTargetPlatformOverride = null;
    });

    test('an unknown ticket and an opened chat', () async {
      final c = fixtureApprovalConnection('c-log');
      final sink = WindowsToastSink();
      await sink.show(
        TurnNotification(
          id: 77,
          title: 'Private chat title',
          body: 'private body',
          payload: '',
          kind: HermesNotificationKind.turnDone,
          channel: TurnNotificationService.turnChannel,
          windowsTarget: WindowsToastTarget.capture(c, c.id, 'session-log'),
        ),
      );
      final ticket = launch!;
      expect(
        await sink.takeInitialLaunchResponse(),
        isA<WindowsToastResponse>(),
      );
      expect(await sink.takeInitialLaunchResponse(), isNull); // one-shot
      final [missing, opened, ...] =
          TurnNotificationService.recentAttempts.value;
      expect(
        (missing.kind, missing.outcome, missing.id, missing.error),
        ('activation', 'failed', null, 'UnknownTicket'),
      );
      expect(
        (opened.kind, opened.outcome, opened.id),
        ('activation', 'opened', 77),
      );
      expect(jsonEncode(await _stored()), isNot(contains(ticket)));
    });
  });

  testWidgets('Classic diagnostics show earlier runs', (tester) async {
    await TurnNotificationService.loadRecentAttempts();
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: RecentNotificationsSheet()),
      ),
    );
    expect(find.textContaining('turnDone · failed'), findsOneWidget);
    expect(
      find.textContaining('#494805219 · $_windowsAccessDenied'),
      findsOneWidget,
    );
  });

  testWidgets('NextGen diagnostics show earlier runs', (tester) async {
    await TurnNotificationService.loadRecentAttempts();
    await tester.pumpWidget(
      MaterialApp(
        theme: nextGenTheme(Brightness.light, NextGenLook.instance),
        home: const Scaffold(body: NgRecentNotificationsSheet()),
      ),
    );
    expect(find.textContaining('turnDone · failed'), findsOneWidget);
    expect(find.text('#494805219 · $_windowsAccessDenied'), findsOneWidget);
  });
}
