import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/config_backup.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/main.dart';
import 'package:hermes_android/nextgen/data/connection_check.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/connect_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MemoryCredentialStore implements CredentialStore {
  final values = <String, String>{};
  @override
  String? readCached(String key) => values[key];
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async => values[key] = value;
  @override
  Future<void> delete(String key) async => values.remove(key);
}

class _RecordedRequest {
  _RecordedRequest({
    required this.method,
    required this.path,
    required this.headers,
  });
  final String method;
  final String path;
  final Map<String, String> headers;
}

class _TokenGatewayFixture {
  _TokenGatewayFixture._(this.server, {required this.expectedToken});

  final HttpServer server;
  final String expectedToken;
  final List<_RecordedRequest> requests = [];
  bool meEndpoint404 = false;

  int get port => server.port;
  String get baseUrl => 'http://127.0.0.1:$port';

  static Future<_TokenGatewayFixture> start({
    String expectedToken = 'fixture-deploy-token-99',
  }) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final fixture = _TokenGatewayFixture._(
      server,
      expectedToken: expectedToken,
    );
    server.listen((req) async {
      final headers = <String, String>{};
      req.headers.forEach((name, values) {
        headers[name.toLowerCase()] = values.join(', ');
      });
      fixture.requests.add(
        _RecordedRequest(
          method: req.method,
          path: req.uri.path,
          headers: headers,
        ),
      );

      final path = req.uri.path;
      if (path == '/health' || path == '/v1/models') {
        req.response.statusCode = 200;
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({'status': 'ok', 'data': []}));
        await req.response.close();
        return;
      }

      if (path == '/api/status') {
        req.response.statusCode = 200;
        req.response.headers.contentType = ContentType.json;
        req.response.write(
          jsonEncode({
            'version': '0.23.4-fixture',
            'gateway_running': true,
            'auth_required': true,
            'auth_providers': <String>[],
            'auth_flows': <String>[],
            'profiles': ['default'],
          }),
        );
        await req.response.close();
        return;
      }

      if (path == '/api/ws' && WebSocketTransformer.isUpgradeRequest(req)) {
        final ws = await WebSocketTransformer.upgrade(
          req,
          protocolSelector: (protocols) =>
              protocols.contains('hermes-gateway-v1')
              ? 'hermes-gateway-v1'
              : null,
        );
        ws.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'method': 'event',
            'params': {
              'type': 'gateway.ready',
              'payload': {
                'protocol': {'name': 'hermes-jsonrpc', 'major': 2},
              },
            },
          }),
        );
        ws.listen((raw) {
          final msg = jsonDecode(raw as String) as Map<String, dynamic>;
          if (msg['method'] == 'client.capabilities') {
            ws.add(
              jsonEncode({
                'jsonrpc': '2.0',
                'id': msg['id'],
                'result': {'accepted': true},
              }),
            );
          }
        });
        return;
      }

      final token = headers['x-hermes-session-token'];
      final bearerOk = headers['authorization'] == 'Bearer classic-api-key';
      if (token != fixture.expectedToken &&
          !(bearerOk && path == '/api/sessions')) {
        req.response.statusCode = 401;
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({'detail': 'Unauthorized'}));
        await req.response.close();
        return;
      }

      if (path == '/api/auth/me') {
        if (fixture.meEndpoint404) {
          req.response.statusCode = 404;
          req.response.headers.contentType = ContentType.json;
          req.response.write(jsonEncode({'detail': 'Not Found'}));
          await req.response.close();
          return;
        }
        req.response.statusCode = 200;
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({'username': 'ops-token'}));
        await req.response.close();
        return;
      }

      if (path == '/api/model/info') {
        req.response.statusCode = 200;
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({'model': 'gpt-test'}));
        await req.response.close();
        return;
      }

      if (path == '/api/profiles') {
        req.response.statusCode = 200;
        req.response.headers.contentType = ContentType.json;
        req.response.write(
          jsonEncode({
            'profiles': [
              {'name': 'default', 'is_default': true},
            ],
          }),
        );
        await req.response.close();
        return;
      }

      if (path == '/api/sessions') {
        req.response.statusCode = 200;
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({'sessions': <Object>[], 'total': 0}));
        await req.response.close();
        return;
      }

      if (path == '/api/auth/ws-ticket') {
        req.response.statusCode = 200;
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({'ticket': 'fixture-ws-ticket-1'}));
        await req.response.close();
        return;
      }

      req.response.statusCode = 404;
      await req.response.close();
    });
    return fixture;
  }

  Future<void> close() => server.close(force: true);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
    PackageInfo.setMockInitialValues(
      appName: 'Ares',
      packageName: 'com.hermesagent.hermes_android',
      version: '5.0.0-test',
      buildNumber: '5000',
      buildSignature: '',
    );
  });

  tearDown(HermesSignInVault.resetForTesting);

  test(
    'deploymentToken and customHeaders stay in secure store and encrypted backup, never plaintext prefs',
    () async {
      final prefs = await SharedPreferences.getInstance();
      final secrets = _MemoryCredentialStore();
      final manager = ConnectionManager(prefs, credentialStore: secrets);

      await manager.saveConnection(
        'Edge Gateway',
        '127.0.0.1',
        8642,
        'api-secret',
        deploymentToken: 'deploy-secret-token',
        customHeaders: const {
          'X-Edge-Tenant': 'acme',
          'Authorization': 'spoof-attempt',
        },
      );

      final rawPrefs = (prefs.getStringList('saved_connections') ?? const [])
          .join('\n');
      expect(rawPrefs, isNot(contains('deploy-secret-token')));
      expect(rawPrefs, isNot(contains('X-Edge-Tenant')));
      expect(rawPrefs, isNot(contains('acme')));

      final reloaded = ConnectionManager(prefs, credentialStore: secrets);
      await reloaded.initialize();
      final saved = reloaded.getConnections().single;
      expect(saved.deploymentToken, 'deploy-secret-token');
      expect(saved.customHeaders, {'X-Edge-Tenant': 'acme'});
      expect(saved.customHeaders.containsKey('Authorization'), isFalse);

      // Encrypted ConfigBackup preserves both secrets across export/import.
      final archive = await ConfigBackupCodec.encrypt(
        ConfigBackup(
          createdAt: DateTime.utc(2026, 11, 26),
          appVersion: '5.0.0',
          connections: [saved],
          preferences: const {},
        ),
        passphrase: 'strong-fixture-passphrase',
        iterations: 100,
      );
      final restored = await ConfigBackupCodec.decrypt(
        archive,
        passphrase: 'strong-fixture-passphrase',
      );
      expect(
        restored.connections.single.deploymentToken,
        'deploy-secret-token',
      );
      expect(restored.connections.single.customHeaders, {
        'X-Edge-Tenant': 'acme',
      });
    },
  );

  test(
    'DashboardClient, ApiClient and WsClient scope custom headers, enforce auth precedence, and refuse cross-origin redirects',
    () async {
      final previousOverrides = HttpOverrides.current;
      HttpOverrides.global = null;
      addTearDown(() => HttpOverrides.global = previousOverrides);

      final fixture = await _TokenGatewayFixture.start(
        expectedToken: 'tok-live-1',
      );
      addTearDown(fixture.close);

      // Second server to prove a 302 redirect NEVER receives custom headers or tokens.
      final target = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final leaked = <_RecordedRequest>[];
      target.listen((req) async {
        final h = <String, String>{};
        req.headers.forEach((k, v) => h[k.toLowerCase()] = v.join(', '));
        leaked.add(
          _RecordedRequest(method: req.method, path: req.uri.path, headers: h),
        );
        req.response.statusCode = 200;
        await req.response.close();
      });
      addTearDown(() => target.close(force: true));

      final redirector = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      redirector.listen((req) async {
        req.response.statusCode = 302;
        req.response.headers.set(
          HttpHeaders.locationHeader,
          'http://127.0.0.1:${target.port}${req.uri.path}',
        );
        await req.response.close();
      });
      addTearDown(() => redirector.close(force: true));

      final dashboard = DashboardClient(
        host: '127.0.0.1',
        port: fixture.port,
        deploymentToken: 'tok-live-1',
        customHeaders: const {
          'X-Proxy-Scope': 'lane-a',
          'X-Hermes-Session-Token': 'spoofed',
        },
      );
      addTearDown(dashboard.close);

      final info = await dashboard.getModelInfo();
      expect(info['model'], 'gpt-test');
      final dashReq = fixture.requests.lastWhere(
        (r) => r.path == '/api/model/info',
      );
      expect(dashReq.headers['x-hermes-session-token'], 'tok-live-1');
      expect(dashReq.headers['x-proxy-scope'], 'lane-a');

      // Wrong deployment token does not retry or fall back to SPA token scraping.
      final wrongDash = DashboardClient(
        host: '127.0.0.1',
        port: fixture.port,
        deploymentToken: 'wrong-token',
        customHeaders: const {'X-Proxy-Scope': 'lane-a'},
      );
      addTearDown(wrongDash.close);
      final beforeCount = fixture.requests.length;
      final unauthorized = await wrongDash.apiRequest('GET', 'model/info');
      expect(unauthorized.statusCode, 401);
      expect(
        fixture.requests.length - beforeCount,
        1,
        reason: 'deployment-token 401 must not replay or scrape /',
      );

      // Redirecting DashboardClient, ApiClient and WsClient must never hit target.
      final redirectDash = DashboardClient(
        host: '127.0.0.1',
        port: redirector.port,
        deploymentToken: 'tok-live-1',
        customHeaders: const {'X-Proxy-Scope': 'secret-edge'},
      );
      addTearDown(redirectDash.close);
      final redirRes = await redirectDash.apiRequest('GET', 'model/info');
      expect(redirRes.statusCode, 302);

      final redirectApi = ApiClient(
        baseUrl: 'http://127.0.0.1:${redirector.port}',
        apiKey: 'bearer-secret',
        customHeaders: const {'X-Proxy-Scope': 'secret-edge'},
      );
      addTearDown(redirectApi.close);
      final health = await redirectApi.checkHealth();
      expect(health.isHealthy, isFalse);

      final redirectWs = WsClient(
        'http://127.0.0.1:${redirector.port}',
        ticket: 't-1',
        ticketInSubprotocol: false,
        customHeaders: const {'X-Proxy-Scope': 'secret-edge'},
      );
      await expectLater(redirectWs.connect(), throwsA(anything));
      redirectWs.close();
      expect(
        leaked,
        isEmpty,
        reason: 'custom headers must never cross redirects',
      );

      // Session-token-only 404 /api/auth/me falls back to /api/model-info in
      // both HermesSignIn.tokenSignIn and NextGen runConnectionCheck, and WS
      // upgrade forwards customHeaders.
      fixture.meEndpoint404 = true;
      final signIn = await HermesSignIn().tokenSignIn(
        GatewayUrl.parse(fixture.baseUrl),
        token: 'tok-live-1',
        customHeaders: const {'X-Proxy-Scope': 'ws-check'},
      );
      expect(signIn, isA<SignInOk>());

      final conn = SavedConnection(
        id: 'ng-tok',
        label: 'Token Host',
        host: '127.0.0.1',
        port: fixture.port,
        dashboardPortOverride: fixture.port,
        apiKey: '',
        desktopGatewayUrl: fixture.baseUrl,
        singleLogin: true,
        signInMethod: 'token',
        deploymentToken: 'tok-live-1',
        customHeaders: const {'X-Proxy-Scope': 'ws-check'},
      );
      final report = await runConnectionCheck(conn);
      expect(
        report.allPassed,
        isTrue,
        reason:
            '${report.results.map((k, v) => MapEntry(k, "${v.outcome}: ${v.detail}"))}',
      );
      final wsReq = fixture.requests.lastWhere((r) => r.path == '/api/ws');
      expect(wsReq.headers['x-proxy-scope'], 'ws-check');
    },
  );

  testWidgets(
    'Classic connection dialog validates custom headers and saves deployment token + headers securely',
    (tester) async {
      final previousOverrides = HttpOverrides.current;
      HttpOverrides.global = null;
      addTearDown(() => HttpOverrides.global = previousOverrides);

      final fixture = await tester.runAsync(
        () => _TokenGatewayFixture.start(expectedToken: 'classic-tok-7'),
      );
      addTearDown(() => fixture!.close());

      tester.view.physicalSize = const Size(1000, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final prefs = await SharedPreferences.getInstance();
      await NextGenPreferences.setEnabled(prefs, false);
      final secrets = _MemoryCredentialStore();
      final manager = ConnectionManager(prefs, credentialStore: secrets);

      await tester.pumpWidget(HermesApp(connManager: manager));
      await tester.pumpAndSettle();

      // Open Add Connection -> Classic API + Dashboard dialog.
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();
      if (find
          .byKey(const ValueKey('add-classic-connection'))
          .evaluate()
          .isNotEmpty) {
        await tester.tap(find.byKey(const ValueKey('add-classic-connection')));
        await tester.pumpAndSettle();
      }

      await tester.enterText(
        find.widgetWithText(TextField, 'Host'),
        '127.0.0.1',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Port'),
        '${fixture!.port}',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'API Key'),
        'classic-api-key',
      );

      // Expand proxy & dashboard details.
      await tester.tap(find.text('Custom proxy and dashboard details'));
      await tester.pumpAndSettle();

      final dashPortField = find.widgetWithText(TextField, 'Dashboard Port');
      await tester.ensureVisible(dashPortField);
      await tester.enterText(dashPortField, '${fixture.port}');
      final deployTokenField = find.widgetWithText(
        TextField,
        'Deployment token (optional)',
      );
      await tester.ensureVisible(deployTokenField);
      await tester.enterText(deployTokenField, 'classic-tok-7');

      // Forbidden header is rejected before any save.
      final headersField = find.byKey(
        const Key('connection_custom_headers_field'),
      );
      await tester.ensureVisible(headersField);
      await tester.enterText(headersField, 'Authorization: Bearer bad');
      await tester.tap(find.text('Connect'));
      await tester.pumpAndSettle();
      expect(find.textContaining('is reserved'), findsOneWidget);
      expect(manager.getConnections(), isEmpty);

      // Valid custom header + deployment token passes health + dashboard check and saves.
      await tester.enterText(headersField, 'X-Classic-Edge: ok-value');
      await tester.tap(find.text('Connect'));
      for (var i = 0; i < 30; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 15)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(manager.getConnections(), hasLength(1));
      final saved = manager.getConnections().single;
      expect(saved.deploymentToken, 'classic-tok-7');
      expect(saved.customHeaders, {'X-Classic-Edge': 'ok-value'});
      expect(
        (prefs.getStringList('saved_connections') ?? const []).join('\n'),
        isNot(contains('classic-tok-7')),
      );
      expect(
        fixture.requests.any(
          (r) =>
              r.path == '/api/model/info' &&
              r.headers['x-hermes-session-token'] == 'classic-tok-7' &&
              r.headers['x-classic-edge'] == 'ok-value',
        ),
        isTrue,
      );
    },
  );

  testWidgets(
    'NextGen NgConnectScreen validates custom headers and signs in with a deployment token',
    (tester) async {
      tester.view.physicalSize = const Size(1000, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final previousOverrides = HttpOverrides.current;
      HttpOverrides.global = null;
      addTearDown(() => HttpOverrides.global = previousOverrides);

      final fixture = await tester.runAsync(
        () => _TokenGatewayFixture.start(expectedToken: 'ng-deploy-tok-5'),
      );
      addTearDown(() => fixture!.close());

      final prefs = await SharedPreferences.getInstance();
      final secrets = _MemoryCredentialStore();
      final manager = ConnectionManager(prefs, credentialStore: secrets);
      final connected = <SavedConnection>[];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          home: NgConnectScreen(
            connManager: manager,
            onConnected: connected.add,
          ),
        ),
      );
      await tester.pump();

      Future<void> settleIo() async {
        for (var i = 0; i < 25; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 15)),
          );
          await tester.pump(const Duration(milliseconds: 50));
        }
      }

      await tester.enterText(find.byType(TextField).first, fixture!.baseUrl);
      await tester.tap(find.text('Custom headers'));
      await tester.pumpAndSettle();

      final customField = find.byKey(
        const Key('ng-connect-custom-headers-field'),
      );
      await tester.enterText(customField, 'Cookie: forbidden=1');
      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();
      expect(find.textContaining('is reserved'), findsWidgets);

      await tester.enterText(customField, 'X-Ng-Edge: routed-1');
      await tester.tap(find.text('Test'));
      await settleIo();
      expect(find.textContaining('is reachable'), findsOneWidget);

      await tester.tap(find.text('Continue to sign in'));
      await tester.pumpAndSettle();

      // Since the fixture advertises no basic/OAuth providers, the deployment
      // token field is offered directly on the sign-in step.
      final tokenField = find.descendant(
        of: find.byKey(const Key('ng-connect-deployment-token-field')),
        matching: find.byType(TextField),
      );
      await tester.enterText(tokenField, 'ng-deploy-tok-5');
      final submitButton = find.byKey(
        const Key('ng-connect-deployment-token-submit'),
      );
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await settleIo();

      expect(connected, hasLength(1));
      expect(connected.single.signInMethod, 'token');
      expect(connected.single.deploymentToken, 'ng-deploy-tok-5');
      expect(connected.single.customHeaders, {'X-Ng-Edge': 'routed-1'});
      expect(
        (prefs.getStringList('saved_connections') ?? const []).join('\n'),
        isNot(contains('ng-deploy-tok-5')),
      );
    },
  );
}
