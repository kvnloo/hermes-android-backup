import 'dart:convert';

import 'connection_manager.dart';
import 'model_admin.dart';

/// Profile-scoped provider, delegation, mixture and billing calls.
///
/// Billing mutations are ordinary gateway methods. This type does not decide
/// that the user consented; the screen asks first and then calls them once.
class RemoteModelAdmin {
  final DashboardClient client;
  final Future<Map<String, dynamic>> Function(
    String method,
    Map<String, dynamic> params,
  )?
  rpc;

  RemoteModelAdmin(this.client, {this.rpc});

  Map<String, String>? get _profileQuery {
    final profile = client.gatewayProfile;
    if (profile == null || profile.isEmpty) return null;
    return {'profile': profile};
  }

  Future<Map<String, dynamic>> _exchange(
    String method,
    String path, {
    Object? body,
    bool profileQuery = true,
  }) async {
    final response = await client.apiRequest(
      method,
      path,
      body: body,
      queryParameters: profileQuery ? _profileQuery : null,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ModelAdminException(
        ModelAdminFailure.httpError,
        statusCode: response.statusCode,
      );
    }
    if (response.body.trim().isEmpty) return {};
    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw const ModelAdminException(ModelAdminFailure.responseUnreadable);
    }
    if (decoded is! Map) {
      throw const ModelAdminException(ModelAdminFailure.responseShape);
    }
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }

  Future<Map<String, dynamic>> _call(
    String method,
    Map<String, dynamic> params,
  ) async {
    final send = rpc;
    if (send == null) {
      throw const ModelAdminException(ModelAdminFailure.connectBeforeChange);
    }
    final response = await send(method, params);
    final error = response['error'];
    final rpcError = error is Map && error['code'] != null;
    final envelope =
        response.containsKey('jsonrpc') ||
        response.containsKey('result') ||
        rpcError;
    if (!envelope) return response;
    if (error is Map && error['code'] == -32601) {
      throw const ModelAdminException(ModelAdminFailure.operationUnavailable);
    }
    if (error != null) {
      if (error is Map) {
        throw ModelAdminException.server(error['message']?.toString());
      }
      throw const ModelAdminException(ModelAdminFailure.requestRefused);
    }
    final result = response['result'];
    if (result is Map) {
      return result.map((key, value) => MapEntry(key.toString(), value));
    }
    throw const ModelAdminException(ModelAdminFailure.responseShape);
  }

  Future<List<ProviderKeyGroup>> keys() async =>
      providerKeyGroups(await _exchange('GET', 'env'));

  Future<void> saveKey(String envKey, String value) async {
    final key = envKey.trim();
    final secret = value.trim();
    if (!RegExp(r'^[A-Z][A-Z0-9_]{0,127}$').hasMatch(key) ||
        secret.isEmpty ||
        secret.length > 4096) {
      throw const ModelAdminException(ModelAdminFailure.keyRequired);
    }
    final saved = await _exchange(
      'PUT',
      'env',
      body: {'key': key, 'value': secret, 'provider_setup': true},
    );
    if (saved['ok'] == false) {
      throw const ModelAdminException(ModelAdminFailure.keySaveFailed);
    }
  }

  Future<void> clearKey(String envKey) async {
    final key = envKey.trim();
    if (!RegExp(r'^[A-Z][A-Z0-9_]{0,127}$').hasMatch(key)) {
      throw const ModelAdminException(ModelAdminFailure.keyClearRequired);
    }
    final cleared = await _exchange('DELETE', 'env', body: {'key': key});
    if (cleared['ok'] == false) {
      throw const ModelAdminException(ModelAdminFailure.keyClearFailed);
    }
  }

  Future<List<NamedEndpoint>> endpoints() async =>
      namedEndpoints(await _exchange('GET', 'providers/custom-endpoints'));

  Future<EndpointTestResult> testEndpoint(EndpointDraft draft) async {
    final body = await _exchange(
      'POST',
      'providers/custom-endpoints/validate',
      body: endpointRequestBody(draft),
    );
    return endpointTestResult(body);
  }

  Future<void> saveEndpoint(EndpointDraft draft) async {
    final saved = await _exchange(
      'POST',
      'providers/custom-endpoints',
      body: endpointRequestBody(draft),
    );
    if (saved['ok'] == false) {
      throw const ModelAdminException(ModelAdminFailure.endpointSaveFailed);
    }
  }

  Future<void> activateEndpoint(String id) async {
    if (!RegExp(r'^[A-Za-z0-9_.:-]{1,128}$').hasMatch(id)) {
      throw const ModelAdminException(ModelAdminFailure.endpointIdInvalid);
    }
    final activated = await _exchange(
      'POST',
      'providers/custom-endpoints/${Uri.encodeComponent(id)}/activate',
    );
    if (activated['ok'] != true || activated['model'] is! String) {
      throw const ModelAdminException(ModelAdminFailure.endpointActivateFailed);
    }
  }

  Future<void> deleteEndpoint(String id) async {
    if (!RegExp(r'^[A-Za-z0-9_.:-]{1,128}$').hasMatch(id)) {
      throw const ModelAdminException(ModelAdminFailure.endpointIdInvalid);
    }
    await _exchange(
      'DELETE',
      'providers/custom-endpoints/${Uri.encodeComponent(id)}',
    );
  }

  Future<List<ProviderAccountRow>> accounts() async {
    if (client.providerOAuthUnavailableReason != null) {
      throw const ModelAdminException(ModelAdminFailure.accountsSecureRequired);
    }
    try {
      return providerAccounts(await client.getProviderOAuthCatalog());
    } on StateError {
      throw const ModelAdminException(ModelAdminFailure.accountsReadFailed);
    }
  }

  Future<void> disconnectAccount(String providerId) async {
    try {
      await client.disconnectProviderOAuth(providerId);
    } on StateError {
      throw const ModelAdminException(
        ModelAdminFailure.accountDisconnectFailed,
      );
    } on ArgumentError {
      throw const ModelAdminException(
        ModelAdminFailure.accountNotDisconnectable,
      );
    }
  }

  Future<Map<String, dynamic>> delegation() =>
      _exchange('GET', 'delegation/routing');

  Future<void> selectDelegationBackend(
    String backend,
    List<String> allowed,
  ) async {
    if (!allowed.contains(backend)) {
      throw const ModelAdminException(ModelAdminFailure.backendRequired);
    }
    final saved = await _exchange(
      'PUT',
      'delegation/backend',
      body: {'backend': backend},
    );
    if (saved['ok'] != true) {
      throw const ModelAdminException(ModelAdminFailure.backendSaveFailed);
    }
  }

  Future<void> saveModelRoutes({
    required List<Map<String, dynamic>> routes,
    required String? defaultRoute,
  }) async {
    final saved = await _exchange(
      'PUT',
      'delegation/backends/model_map',
      body: modelRouteBody(routes: routes, defaultRoute: defaultRoute),
    );
    if (saved['ok'] != true) {
      throw const ModelAdminException(ModelAdminFailure.routesSaveFailed);
    }
  }

  Future<void> saveProfileRoutes({
    required List<Map<String, dynamic>> profiles,
    required String? defaultProfile,
  }) async {
    final names = <String>{};
    final rows = <Map<String, dynamic>>[];
    for (final profile in profiles) {
      final name = profile['name']?.toString().trim() ?? '';
      if (name.isEmpty || name.length > 128) {
        throw const ModelAdminException(ModelAdminFailure.profileRouteRequired);
      }
      if (!names.add(name)) {
        throw const ModelAdminException(ModelAdminFailure.profileRouteUnique);
      }
      rows.add({
        ...profile,
        'name': name,
        'description': profile['description']?.toString() ?? '',
      });
    }
    if (defaultProfile != null && !names.contains(defaultProfile)) {
      throw const ModelAdminException(
        ModelAdminFailure.profileRouteDefaultInvalid,
      );
    }
    final saved = await _exchange(
      'PUT',
      'delegation/backends/profile_routes',
      body: {'profiles': rows, 'default': defaultProfile},
    );
    if (saved['ok'] != true) {
      throw const ModelAdminException(
        ModelAdminFailure.profileRoutesSaveFailed,
      );
    }
  }

  Future<DelegationLimits> limits() async =>
      delegationLimitsFromConfig(await _exchange('GET', 'config'));

  Future<void> saveLimits(DelegationLimits limits) async {
    final profile = client.gatewayProfile;
    final saved = await _exchange(
      'PUT',
      'config',
      profileQuery: false,
      body: {
        'config': {'delegation': delegationLimitsPatch(limits)},
        if (profile != null && profile.isNotEmpty) 'profile': profile,
      },
    );
    if (saved['ok'] == false) {
      throw const ModelAdminException(ModelAdminFailure.limitsSaveFailed);
    }
  }

  Future<Map<String, dynamic>> mixture() => _exchange('GET', 'model/moa');

  Future<void> saveMixture(Map<String, dynamic> body) async {
    final saved = await _exchange('PUT', 'model/moa', body: body);
    if (saved['ok'] == false) {
      throw const ModelAdminException(ModelAdminFailure.mixtureSaveFailed);
    }
  }

  Future<void> applyPreset({
    required String sessionId,
    required ModelPreset preset,
  }) async {
    final id = checkedSessionId(sessionId);
    if (preset.effort != null) {
      await _call('config.set', {
        'key': 'reasoning',
        'session_id': id,
        'value': preset.effort,
      });
    }
    if (preset.fast != null) {
      await _call('config.set', {
        'key': 'fast',
        'session_id': id,
        'value': preset.fast! ? 'fast' : 'normal',
      });
    }
  }

  Future<EffortClamp?> routeClamp(String sessionId) async {
    final info = await _call('session.info', {
      'session_id': checkedSessionId(sessionId),
    });
    final nested = info['info'] is Map
        ? Map<String, dynamic>.from(info['info'] as Map)
        : info;
    return reasoningEffortClamp(
      nested['reasoning_effort']?.toString(),
      nested['reasoning_effort_wire']?.toString(),
    );
  }

  Future<Map<String, dynamic>> billingState() => _call('billing.state', {});

  Future<Map<String, dynamic>> subscriptionState() =>
      _call('subscription.state', {});

  Future<Map<String, dynamic>> buyCredits(
    String amount, {
    String? idempotencyKey,
  }) {
    final selected = amount.trim();
    if (selected.isEmpty) {
      throw const ModelAdminException(ModelAdminFailure.creditAmountRequired);
    }
    final supplied = idempotencyKey?.trim() ?? '';
    final key = supplied.isEmpty ? newIdempotencyKey() : supplied;
    return _call('billing.charge', {
      'amount_usd': selected,
      'idempotency_key': key,
    }).then((result) => {...result, 'idempotency_key': key});
  }

  Future<Map<String, dynamic>> chargeStatus(String chargeId) {
    final id = chargeId.trim();
    if (id.isEmpty) {
      throw const ModelAdminException(ModelAdminFailure.chargeCheckFailed);
    }
    return _call('billing.charge_status', {'charge_id': id});
  }

  /// Poll `billing.charge_status` the way Desktop does: every 2 seconds, for
  /// at most 5 minutes, honouring a retry_after on a retryable refusal.
  /// A timeout or transport error stops as unknown so the same charge can be
  /// retried without minting another one.
  Future<Map<String, dynamic>> watchCharge(String chargeId) async {
    final started = DateTime.now();
    while (true) {
      Map<String, dynamic> status;
      try {
        status = await chargeStatus(chargeId);
      } catch (error) {
        if (chargeSendIsAmbiguous(error)) {
          return {'outcome': 'unknown'};
        }
        rethrow;
      }
      final outcome = classifyChargeStatus(status);
      if (outcome == 'settled' || outcome == 'failed' || outcome == 'unknown') {
        return {...status, 'outcome': outcome};
      }
      if (DateTime.now().difference(started) >= chargePollCap) {
        return {...status, 'outcome': 'unknown'};
      }
      await Future<void>.delayed(chargeStatusWait(status));
    }
  }

  Future<Map<String, dynamic>> setAutoReload({
    required bool enabled,
    required String thresholdUsd,
    required String reloadToUsd,
  }) {
    if (thresholdUsd.trim().isEmpty || reloadToUsd.trim().isEmpty) {
      throw const ModelAdminException(ModelAdminFailure.reloadAmountsMissing);
    }
    return _call('billing.auto_reload', {
      'enabled': enabled,
      'threshold': thresholdUsd,
      'top_up_amount': reloadToUsd,
    });
  }

  Future<Map<String, dynamic>> setKeepGoing(bool enabled) =>
      _call('billing.keep_going_on_credits', {'enabled': enabled});

  Future<Map<String, dynamic>> previewPlan(String tierId) {
    if (tierId.trim().isEmpty) {
      throw const ModelAdminException(ModelAdminFailure.planRequired);
    }
    return _call('subscription.preview', {'subscription_type_id': tierId});
  }

  Future<Map<String, dynamic>> schedulePlan(String tierId, String? effect) {
    if (!planChangeCanCommit(effect)) {
      throw const ModelAdminException(ModelAdminFailure.planScheduledOnly);
    }
    return _call('subscription.change', {'subscription_type_id': tierId});
  }
}
