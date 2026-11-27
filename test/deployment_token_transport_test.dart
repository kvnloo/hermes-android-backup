// Deployment-token connections (review of 8d733edd, "also" gaps):
//
// * The live chat socket authenticates with `?token=` exactly as Hermes
//   Desktop does. A loopback-mode gateway (hermes-agent b7ee21c14e,
//   web_server_chat._ws_auth_reason) accepts `?token=<session token>` but
//   cannot mint `POST /api/auth/ws-ticket` tickets (routes._require_session
//   returns a plain dict there), so the old ticket path never connected.
// * Token sign-in fails closed on an older gateway without `/api/auth/me`
//   whose routes answer without any credential (no sign-in at all).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/nextgen/data/connection_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _token = 'loopback-session-token-1';

/// A loopback-mode gateway: REST gated by X-Hermes-Session-Token (unless
/// [openRest]), `/api/auth/ws-ticket` failing, `/api/ws` gated by `?token=`.
class _LoopbackGateway {
  _LoopbackGateway._(this.server, {required this.openRest, required this.me});

  final HttpServer server;
  final bool openRest;
  final bool me;
  final List<String> restCalls = [];
  final List<Uri> upgrades = [];
  int ticketMints = 0;
  int refusedUpgrades = 0;

  String get baseUrl => 'http://127.0.0.1:${server.port}';

  static Future<_LoopbackGateway> start({
    bool openRest = false,
    bool me = true,
  }) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final gateway = _LoopbackGateway._(server, openRest: openRest, me: me);
    server.listen(gateway._handle);
    return gateway;
  }

  Future<void> _json(HttpRequest req, int status, Object body) async {
    req.response.statusCode = status;
    req.response.headers.contentType = ContentType.json;
    req.response.write(jsonEncode(body));
    await req.response.close();
  }

  Future<void> _handle(HttpRequest req) async {
    final path = req.uri.path;
    if (path == '/api/ws') {
      upgrades.add(req.uri);
      if (req.uri.queryParameters['token'] != _token) {
        refusedUpgrades++;
        req.response.statusCode = 403;
        await req.response.close();
        return;
      }
      final ws = await WebSocketTransformer.upgrade(req);
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
        if (msg['id'] != null) {
          ws.add(
            jsonEncode({
              'jsonrpc': '2.0',
              'id': msg['id'],
              'result': {'ok': true},
            }),
          );
        }
      });
      return;
    }
    restCalls.add('${req.method} $path');
    if (path == '/api/status') {
      return _json(req, 200, {
        'version': '0.24.0-loopback',
        'gateway_running': true,
        'auth_required': false,
        'auth_providers': <String>[],
        'auth_flows': <String>[],
      });
    }
    if (path == '/api/auth/ws-ticket') {
      ticketMints++;
      // b7ee21c14e loopback: _require_session returns a dict, then
      // `sess.user_id` raises.
      return _json(req, 500, {'detail': 'Internal Server Error'});
    }
    final authorised =
        openRest || req.headers.value('x-hermes-session-token') == _token;
    if (path == '/api/auth/me' && !me) {
      return _json(req, 404, {'detail': 'Not Found'});
    }
    if (!authorised) return _json(req, 401, {'detail': 'Unauthorized'});
    if (path == '/api/auth/me') {
      return _json(req, 200, {
        'user_id': 'local',
        'display_name': 'Local',
        'provider': 'loopback',
      });
    }
    if (path == '/api/model/info') {
      return _json(req, 200, {'model': 'gpt-test'});
    }
    return _json(req, 404, {'detail': 'Not Found'});
  }

  Future<void> close() => server.close(force: true);
}

SavedConnection _connection(_LoopbackGateway gateway, {String? token}) =>
    SavedConnection(
      id: 'loopback-token',
      label: 'Loopback',
      host: '127.0.0.1',
      port: gateway.server.port,
      dashboardPortOverride: gateway.server.port,
      apiKey: '',
      desktopGatewayUrl: gateway.baseUrl,
      singleLogin: true,
      signInMethod: 'token',
      deploymentToken: token ?? _token,
    );

void main() {
  late HttpOverrides? previous;

  setUp(() {
    previous = HttpOverrides.current;
    HttpOverrides.global = null;
    SharedPreferences.setMockInitialValues(<String, Object>{});
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
  });

  tearDown(() {
    HermesSignInVault.resetForTesting();
    HttpOverrides.global = previous;
  });

  group('live socket on a loopback-mode gateway', () {
    test('Classic opens the socket with ?token= and mints no ticket', () async {
      final gateway = await _LoopbackGateway.start();
      addTearDown(gateway.close);
      final client = DesktopGatewayClient.fromConnection(_connection(gateway));
      addTearDown(client.close);

      final result = await client.call('ping.test', const {});

      expect(result['ok'], isTrue);
      expect(gateway.ticketMints, 0);
      expect(gateway.upgrades, isNotEmpty);
      expect(gateway.upgrades.last.queryParameters['token'], _token);
      expect(gateway.refusedUpgrades, 0);
    });

    test(
      'NextGen connection check reaches the live stage the same way',
      () async {
        final gateway = await _LoopbackGateway.start();
        addTearDown(gateway.close);

        final report = await runConnectionCheck(_connection(gateway));

        expect(
          report.results[CheckStage.live]?.outcome,
          CheckOutcome.passed,
          reason: '${report.results[CheckStage.live]?.detail}',
        );
        expect(gateway.ticketMints, 0);
        expect(gateway.upgrades.last.queryParameters['token'], _token);
      },
    );

    test('a wrong token is refused at the upgrade, not papered over', () async {
      final gateway = await _LoopbackGateway.start();
      addTearDown(gateway.close);
      final client = DesktopGatewayClient.fromConnection(
        _connection(gateway, token: 'wrong-token'),
      );
      addTearDown(client.close);

      await expectLater(client.call('ping.test', const {}), throwsA(anything));
      expect(gateway.refusedUpgrades, greaterThan(0));
      expect(gateway.ticketMints, 0);
    });
  });

  group('token sign-in on a gateway without /api/auth/me', () {
    test(
      'fails closed when the gateway answers without any credential',
      () async {
        final gateway = await _LoopbackGateway.start(openRest: true, me: false);
        addTearDown(gateway.close);

        final result = await HermesSignIn().tokenSignIn(
          GatewayUrl.parse(gateway.baseUrl),
          token: 'literally-anything',
        );

        expect(result, isA<SignInGatewayHasNoAuth>());
      },
    );

    test('verifies a token the gateway actually checks', () async {
      final gateway = await _LoopbackGateway.start(me: false);
      addTearDown(gateway.close);

      final ok = await HermesSignIn().tokenSignIn(
        GatewayUrl.parse(gateway.baseUrl),
        token: _token,
      );
      expect(ok, isA<SignInOk>());

      final wrong = await HermesSignIn().tokenSignIn(
        GatewayUrl.parse(gateway.baseUrl),
        token: 'wrong-token',
      );
      expect(wrong, isA<SignInInvalidCredentials>());
    });
  });
}
