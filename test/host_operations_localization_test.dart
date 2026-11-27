import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hermes_android/core/screens/host_operations_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/l10n/app_localizations_en.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('initial load resolves strings only during rendering', (
    tester,
  ) async {
    final fixture = _HostFixture();
    addTearDown(fixture.owner.close);
    await tester.pumpWidget(fixture.app());
    await _shown(tester, find.byKey(const Key('host-health')));
    expect(tester.takeException(), isNull);
    expect(find.text('Host'), findsOneWidget);
    expect(
      find.text('Gateway process running v-test · 2 sessions'),
      findsOneWidget,
    );
    expect(find.text('Server eligibility prose'), findsOneWidget);
    expect(find.text('SERVER LOG: unchanged'), findsOneWidget);
    expect(find.text('Host heartbeat is stale (1.5s).'), findsOneWidget);
  });

  testWidgets('maintenance output relocalizes without rerunning command', (
    tester,
  ) async {
    final fixture = _HostFixture();
    final locale = ValueNotifier(const Locale('en'));
    addTearDown(locale.dispose);
    addTearDown(fixture.owner.close);
    await tester.pumpWidget(
      ValueListenableBuilder<Locale>(
        valueListenable: locale,
        builder: (_, value, _) => fixture.app(locale: value),
      ),
    );
    await _shown(tester, find.byKey(const Key('host-health')));
    await tester.tap(find.text('Run Doctor'));
    await _shown(
      tester,
      find.text('doctor finished\nSERVER DIAGNOSTIC: unchanged'),
    );
    expect(
      find.text('doctor finished\nSERVER DIAGNOSTIC: unchanged'),
      findsOneWidget,
    );
    locale.value = const Locale('de');
    await tester.pumpAndSettle();
    expect(
      find.text('TEST translated doctor\nSERVER DIAGNOSTIC: unchanged'),
      findsOneWidget,
    );
    expect(fixture.maintenanceStarts, 1);
  });

  testWidgets('structured errors do not expose service exception prose', (
    tester,
  ) async {
    final fixture = _HostFixture(unsupported: true);
    addTearDown(fixture.owner.close);
    await tester.pumpWidget(fixture.app());
    await _shown(tester, find.byKey(const Key('host-error')));
    expect(find.text('Remote workspace: unsupported'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('disposing while initial request waits never reads context', (
    tester,
  ) async {
    final pending = Completer<void>();
    final fixture = _HostFixture(pending: pending);
    addTearDown(fixture.owner.close);
    await tester.pumpWidget(fixture.app());
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    pending.complete();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _shown(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 40 && finder.evaluate().isEmpty; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  expect(
    finder,
    findsWidgets,
    reason: tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data)
        .join(' | '),
  );
}

class _HostStrings extends AppLocalizationsEn {
  _HostStrings(this.language);
  final String language;

  @override
  // Generated ARB accessor name intentionally uses the shared key convention.
  // ignore: non_constant_identifier_names
  String rel_ops_host_maintenance_finished(String name) => language == 'de'
      ? 'TEST translated $name'
      : super.rel_ops_host_maintenance_finished(name);
}

class _HostDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _HostDelegate();
  @override
  bool isSupported(Locale locale) => true;
  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(_HostStrings(locale.languageCode));
  @override
  bool shouldReload(_HostDelegate old) => false;
}

class _HostFixture {
  _HostFixture({bool unsupported = false, Completer<void>? pending}) {
    final client = MockClient((request) async {
      final path = request.url.path;
      if (path == '/auth/password-login') {
        return http.Response(
          '{"ok":true}',
          200,
          headers: {'set-cookie': 'hermes_session_at=fixture-cookie'},
        );
      }
      if (path.endsWith('/api/status')) {
        await pending?.future;
        if (unsupported) return http.Response('{}', 404);
      }
      if (request.method == 'POST' && path.endsWith('/api/ops/doctor')) {
        maintenanceStarts++;
      }
      final body = switch (path) {
        '/api/status' => {
          'gateway_running': true,
          'version': 'v-test',
          'active_sessions': 2,
          'heartbeat_stale_s': 1.5,
          'gateway_shared_with': ['work'],
        },
        '/api/logs' => {
          'file': request.url.queryParameters['file'],
          'lines': ['SERVER LOG: unchanged'],
        },
        '/api/hermes/update/check' => {
          'install_method': 'docker',
          'can_apply': false,
          'update_available': false,
          'message': 'Server eligibility prose',
        },
        '/api/tools/computer-use/status' => {
          'platform': 'linux',
          'platform_supported': true,
          'installed': false,
          'ready': false,
          'checks': <Object>[],
        },
        '/api/curator' => {'enabled': true, 'paused': false},
        _ => {
          'ok': true,
          'name': 'doctor',
          'running': false,
          'exit_code': 0,
          'lines': ['SERVER DIAGNOSTIC: unchanged'],
        },
      };
      return http.Response(jsonEncode(body), 200);
    });
    final dashboard = DashboardClient(
      host: '127.0.0.1',
      port: 9,
      username: 'fixture',
      password: 'fixture',
      gatewayProfile: 'work',
      httpClient: client,
    );
    owner = RemoteWorkspaceOwner(
      connectionId: 'host-l10n',
      expectedBaseUrl: dashboard.baseUrl,
      profile: 'work',
      dashboard: dashboard,
      connect: () async => _ReadySocket(dashboard.baseUrl),
      ownsSocket: (_) => true,
    );
  }

  late final RemoteWorkspaceOwner owner;
  int maintenanceStarts = 0;

  Widget app({Locale locale = const Locale('en')}) => MaterialApp(
    locale: locale,
    supportedLocales: const [Locale('en'), Locale('de')],
    localizationsDelegates: const [
      _HostDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: HostOperationsScreen(
      owner: owner,
      route: owner.route(),
      connection: SavedConnection(
        id: 'host-l10n',
        label: 'User connection',
        host: '127.0.0.1',
        port: 9,
        apiKey: 'fixture',
        gatewayProfile: 'work',
      ),
    ),
  );
}

class _ReadySocket extends Fake implements WsClient {
  _ReadySocket(this.baseUrl);
  @override
  final String baseUrl;
  @override
  int get socketEpoch => 1;
  @override
  bool get isConnected => true;
  @override
  Future<Map<String, dynamic>> waitForGatewayReady({
    Duration timeout = const Duration(seconds: 15),
  }) async => {};
}
