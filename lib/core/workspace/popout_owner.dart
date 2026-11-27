import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/connection.dart';
import '../services/desktop_gateway_client.dart';
import '../services/hermes_sign_in.dart';
import 'popout_protocol.dart';

/// A one-launch comparison, never a persistent fingerprint. Neither the key
/// nor the proof is exposed in argv, logs or window titles. The child must
/// independently resolve the same saved credentials before making *any* call.
String popoutOwnerProof(String nonce, SavedConnection connection) {
  final url = DesktopGatewayClient.normalizedGatewayBaseUrl(connection);
  final vault = HermesSignInVault.instance;
  final bearer = vault.sessionFor(url);
  if (connection.usesBrowserSignIn && bearer == null) {
    throw StateError('Browser sign-in is unavailable.');
  }
  final proof = Hmac(sha256, utf8.encode(nonce)).convert(
    utf8.encode(
      jsonEncode([
        connection.toMap(),
        connection.apiKey,
        connection.dashboardPassword,
        connection.clientCertificate?.privateKeyPassword,
        connection.deploymentToken,
        {
          for (final k in connection.customHeaders.keys.toList()..sort())
            k: connection.customHeaders[k],
        },
        bearer?.toJson(),
        vault
            .accessTokenFor(Uri.tryParse(url)?.host ?? connection.host)
            ?.toJson(),
      ]),
    ),
  );
  return proof.toString();
}

bool matchesPopoutOwner(PopoutTarget target, SavedConnection connection) =>
    connection.id == target.connectionId &&
    (connection.gatewayProfile ?? '') == target.profile &&
    // Classic's legacy API has no profile-qualified history read.
    (target.nextGen || connection.singleLogin || target.profile.isEmpty);
