import 'dart:convert';

import 'package:http/http.dart' as http;

import '../l10n/service_strings.dart';
import '../models/client_certificate.dart';
import '../models/session_search_hit.dart';
import 'connection_manager.dart';
import 'hermes_sign_in.dart' show NoGatewayRedirects;
import 'tls_client_factory.dart';

/// Raised when a server-side session search cannot be completed.
///
/// Carries a human-readable reason so the session list can explain the failure
/// and offer local search instead of silently returning nothing.
class SessionSearchException implements Exception {
  final String message;

  const SessionSearchException(this.message);

  @override
  String toString() => message;
}

/// Queries the dashboard's full-text session search.
///
/// The Hermes dashboard exposes `GET /api/sessions/search`, which runs an FTS5
/// query across stored message content, applies prefix wildcards so partial
/// words match, and de-duplicates results by compression lineage. That is
/// strictly more capable than filtering the loaded list on device, which only
/// sees titles, previews, and model names.
///
/// This client owns HTTP only. Deciding *whether* to use it belongs to
/// [SessionSearchPreferences]; rendering belongs to the session list.
class SessionSearchClient {
  /// Upper bound accepted by the dashboard endpoint. Larger values are clamped
  /// server-side; clamping here keeps the request honest and the UI bounded.
  static const int maxLimit = 100;

  final http.Client _http;
  final String _baseUrl;
  final String? profile;
  final Future<Map<String, String>> Function() _authHeaders;

  SessionSearchClient({
    required String baseUrl,
    this.profile,
    required Future<Map<String, String>> Function() headers,
    ClientCertificateConfig? clientCertificate,
    TlsClientFactory tlsClientFactory = const TlsClientFactory(),
    http.Client? httpClient,
  }) : // Trailing slashes would produce `//api/...` once joined below.
       _baseUrl = baseUrl.endsWith('/')
           ? baseUrl.substring(0, baseUrl.length - 1)
           : baseUrl,
       _authHeaders = headers,
       // Reuse the connection's mTLS identity. Passing only the dashboard's
       // auth headers would send a cookie over a transport that cannot present
       // the client certificate, so a proxy enforcing mTLS would reject search
       // even though the session list loaded.
       //
       // The headers carry the deployment token (X-Hermes-Session-Token) and
       // the connection's custom headers. dart:io strips only Authorization
       // and Cookie when it follows a redirect, so a 3xx to another origin
       // would hand those to a third party. Refuse every redirect, as the
       // gateway's own clients do, and report the 3xx as a failure.
       _http = NoGatewayRedirects(
         httpClient ?? tlsClientFactory.createRestClient(clientCertificate),
       );

  /// Runs a full-text search and returns the matching sessions.
  ///
  /// Returns an empty list for a blank query rather than asking the server for
  /// everything. Throws [SessionSearchException] when the dashboard is
  /// unreachable, rejects the credentials, or answers with an unexpected shape
  /// — the caller surfaces that instead of showing an empty result set that
  /// would read as "no matches".
  Future<List<SessionSearchHit>> search(String query, {int limit = 20}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final safeLimit = limit.clamp(1, maxLimit);
    final uri = Uri.parse('$_baseUrl/api/sessions/search').replace(
      queryParameters: {
        'q': trimmed,
        'limit': '$safeLimit',
        'profile': ?profile,
      },
    );

    final http.Response response;
    try {
      response = await _http.get(uri, headers: await _authHeaders());
    } catch (error) {
      throw SessionSearchException(
        serviceStrings.rel_svc_backup_search_dashboard_unreachable('$error'),
      );
    }

    return _readResponse(response, trimmed, profile, safeLimit);
  }

  /// The active browsers borrow the selected dashboard's authenticated,
  /// mTLS-aware transport rather than opening a second client.
  static Future<List<SessionSearchHit>> searchDashboard(
    DashboardClient dashboard,
    String query, {
    String? profile,
    int limit = 60,
    bool Function()? maySend,
    Duration timeout = ApiClient.requestTimeout,
  }) async {
    final term = query.trim();
    if (term.isEmpty) return const [];
    final selected = profile ?? dashboard.gatewayProfile;
    final safeLimit = limit.clamp(1, maxLimit);
    final response = await dashboard.apiRequest(
      'GET',
      'sessions/search',
      queryParameters: {'q': term, 'limit': '$safeLimit', 'profile': ?selected},
      timeout: timeout,
      maySend: maySend,
    );
    return _readResponse(response, term, selected, safeLimit);
  }

  static List<SessionSearchHit> _readResponse(
    http.Response response,
    String query,
    String? profile,
    int limit,
  ) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw SessionSearchException(
        serviceStrings.rel_svc_backup_search_credentials_rejected,
      );
    }
    if (response.statusCode == 404 ||
        response.statusCode == 405 ||
        response.statusCode == 501) {
      throw SessionSearchException(
        serviceStrings.rel_svc_backup_search_not_supported,
      );
    }
    if (response.statusCode >= 300 && response.statusCode < 400) {
      throw SessionSearchException(
        serviceStrings.rel_svc_backup_search_redirected(response.statusCode),
      );
    }
    if (response.statusCode != 200) {
      throw SessionSearchException(
        serviceStrings.rel_svc_backup_search_http_failed(response.statusCode),
      );
    }

    return _decodeHits(response.body, query, profile, limit);
  }

  static List<SessionSearchHit> _decodeHits(
    String body,
    String query,
    String? profile,
    int limit,
  ) {
    final Object? decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      throw SessionSearchException(
        serviceStrings.rel_svc_backup_search_malformed_response,
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw SessionSearchException(
        serviceStrings.rel_svc_backup_search_unexpected_response,
      );
    }

    final results = decoded['results'];
    bool wrongProfile(Map<String, dynamic> data) =>
        data['profile'] != null && data['profile'] != (profile ?? 'default');
    if (results is List && results.length > limit) {
      throw SessionSearchException(
        serviceStrings.rel_svc_backup_search_too_many_results,
      );
    }
    if (results is! List ||
        wrongProfile(decoded) ||
        [
          decoded['q'],
          decoded['query'],
        ].any((echo) => echo != null && echo != query)) {
      throw SessionSearchException(
        serviceStrings.rel_svc_backup_message_search_unexpected_response,
      );
    }
    for (final row in results) {
      if (row is! Map<String, dynamic> ||
          wrongProfile(row) ||
          (row['session_id'] ?? row['id']) is! String ||
          ((row['session_id'] ?? row['id']) as String).trim().isEmpty ||
          (row['id'] is String &&
              row['session_id'] != null &&
              row['id'] != row['session_id'])) {
        throw SessionSearchException(
          serviceStrings.rel_svc_backup_message_search_unexpected_result,
        );
      }
    }

    return results
        .whereType<Map<String, dynamic>>()
        .map(SessionSearchHit.fromJson)
        .toList(growable: false);
  }

  void close() => _http.close();
}
