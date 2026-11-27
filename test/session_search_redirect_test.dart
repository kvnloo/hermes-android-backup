// Regression (review of 8d733edd, PROBE-1): Classic server search must never
// carry the deployment token or the connection's custom headers across a
// redirect to another origin. dart:io strips only Authorization and Cookie
// when it follows a redirect, so the client has to refuse redirects itself.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/services/session_search_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, String> _headersOf(HttpRequest req) {
  final h = <String, String>{};
  req.headers.forEach((k, v) => h[k.toLowerCase()] = v.join(', '));
  return h;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    HermesSignInVault.resetForTesting(MemorySignInSecretStore());
  });
  tearDown(HermesSignInVault.resetForTesting);

  test('a 302 to another origin never delivers the deployment token or the '
      'custom headers, and search reports the redirect', () async {
    final previous = HttpOverrides.current;
    HttpOverrides.global = null;
    addTearDown(() => HttpOverrides.global = previous);

    final reachedOtherOrigin = <Map<String, String>>[];
    final target = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    target.listen((req) async {
      reachedOtherOrigin.add({'path': req.uri.path, ..._headersOf(req)});
      req.response.statusCode = 200;
      req.response.headers.contentType = ContentType.json;
      req.response.write('{"results": []}');
      await req.response.close();
    });
    addTearDown(() => target.close(force: true));

    final reachedGateway = <Map<String, String>>[];
    final redirector = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    redirector.listen((req) async {
      reachedGateway.add({'path': req.uri.path, ..._headersOf(req)});
      req.response.statusCode = 302;
      req.response.headers.set(
        HttpHeaders.locationHeader,
        'http://127.0.0.1:${target.port}${req.uri.path}?${req.uri.query}',
      );
      await req.response.close();
    });
    addTearDown(() => redirector.close(force: true));

    final base = 'http://127.0.0.1:${redirector.port}';
    final connection = SavedConnection(
      id: 'redirect-probe',
      label: 'Probe',
      host: '127.0.0.1',
      port: redirector.port,
      dashboardPortOverride: redirector.port,
      apiKey: '',
      desktopGatewayUrl: base,
      singleLogin: true,
      signInMethod: 'token',
      deploymentToken: 'probe-deploy-token',
      customHeaders: const {'X-Edge-Secret': 'probe-edge-secret'},
    );
    // The construction in SessionListScreen._ensureSearchClient().
    final dashboard = DashboardClient.fromConnection(connection);
    final search = SessionSearchClient(
      baseUrl: dashboard.baseUrl,
      headers: dashboard.authHeaders,
      profile: dashboard.gatewayProfile,
      clientCertificate: connection.clientCertificate,
    );
    addTearDown(search.close);

    Object? failure;
    try {
      await search.search('anything');
    } catch (error) {
      failure = error;
    }

    // The gateway itself got the credentials (the test is meaningful) …
    expect(reachedGateway, hasLength(1));
    expect(
      reachedGateway.single['x-hermes-session-token'],
      'probe-deploy-token',
    );
    expect(reachedGateway.single['x-edge-secret'], 'probe-edge-secret');
    // … the other origin got nothing at all …
    expect(
      reachedOtherOrigin,
      isEmpty,
      reason: 'custom headers / X-Hermes-Session-Token followed a 302',
    );
    // … and the user sees a redirect failure, not an empty result set.
    expect(failure, isA<SessionSearchException>());
    expect('$failure', contains('302'));
  });
}
