import 'dart:math';

import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_en.dart';

/// Provider, route and billing decisions that do not touch the network.
///
/// A route clamp is reported only when the gateway stamps both the picked
/// effort and a different wire effort. An empty wire means the route has not
/// said what it sends, so the pick is shown unchanged.
/// App-authored failure reasons; server detail is kept separate from UI copy.
enum ModelAdminFailure {
  chooseProvider,
  knownEffort,
  endpointNameRequired,
  endpointModelRequired,
  knownApiMode,
  endpointIdInvalid,
  endpointHttps,
  keyInvalid,
  responseShape,
  limitsRequired,
  routeRequired,
  routeUnique,
  routeDefaultInvalid,
  policyRequired,
  mixtureMissing,
  mixtureSlotsRequired,
  chatIdRequired,
  httpError,
  responseUnreadable,
  connectBeforeChange,
  operationUnavailable,
  keyRequired,
  keySaveFailed,
  keyClearRequired,
  keyClearFailed,
  endpointSaveFailed,
  endpointActivateFailed,
  accountsSecureRequired,
  accountsReadFailed,
  accountDisconnectFailed,
  accountNotDisconnectable,
  backendRequired,
  backendSaveFailed,
  routesSaveFailed,
  profileRouteRequired,
  profileRouteUnique,
  profileRouteDefaultInvalid,
  profileRoutesSaveFailed,
  limitsSaveFailed,
  mixtureSaveFailed,
  creditAmountRequired,
  chargeCheckFailed,
  reloadAmountsMissing,
  planRequired,
  planScheduledOnly,
  connectBeforeBilling,
  presetRequired,
  billingRefused,
  requestRefused,
  server,
}

class ModelAdminException implements Exception {
  final ModelAdminFailure reason;
  final int? statusCode;
  final String? serverMessage;
  const ModelAdminException(this.reason, {this.statusCode})
    : serverMessage = null;
  const ModelAdminException.server(this.serverMessage)
    : reason = ModelAdminFailure.server,
      statusCode = null;

  String localized(AppLocalizations l) => switch (reason) {
    ModelAdminFailure.chooseProvider => l.rel_admin_choose_provider,
    ModelAdminFailure.knownEffort => l.rel_admin_known_effort,
    ModelAdminFailure.endpointNameRequired =>
      l.rel_admin_endpoint_name_required,
    ModelAdminFailure.endpointModelRequired =>
      l.rel_admin_endpoint_model_required,
    ModelAdminFailure.knownApiMode => l.rel_admin_known_api_mode,
    ModelAdminFailure.endpointIdInvalid => l.rel_admin_endpoint_id_invalid,
    ModelAdminFailure.endpointHttps => l.rel_admin_endpoint_https,
    ModelAdminFailure.keyInvalid => l.rel_admin_key_invalid,
    ModelAdminFailure.responseShape => l.rel_admin_response_shape,
    ModelAdminFailure.limitsRequired => l.rel_admin_limits_required,
    ModelAdminFailure.routeRequired => l.rel_admin_route_required,
    ModelAdminFailure.routeUnique => l.rel_admin_route_unique,
    ModelAdminFailure.routeDefaultInvalid => l.rel_admin_route_default_invalid,
    ModelAdminFailure.policyRequired => l.rel_admin_policy_required,
    ModelAdminFailure.mixtureMissing => l.rel_admin_mixture_missing,
    ModelAdminFailure.mixtureSlotsRequired =>
      l.rel_admin_mixture_slots_required,
    ModelAdminFailure.chatIdRequired => l.rel_admin_chat_id_required,
    ModelAdminFailure.httpError => l.rel_admin_http_error(
      (statusCode ?? 0).toString(),
    ),
    ModelAdminFailure.responseUnreadable => l.rel_admin_response_unreadable,
    ModelAdminFailure.connectBeforeChange => l.rel_admin_connect_before_change,
    ModelAdminFailure.operationUnavailable => l.rel_admin_operation_unavailable,
    ModelAdminFailure.keyRequired => l.rel_admin_key_required,
    ModelAdminFailure.keySaveFailed => l.rel_admin_key_save_failed,
    ModelAdminFailure.keyClearRequired => l.rel_admin_key_clear_required,
    ModelAdminFailure.keyClearFailed => l.rel_admin_key_clear_failed,
    ModelAdminFailure.endpointSaveFailed => l.rel_admin_endpoint_save_failed,
    ModelAdminFailure.endpointActivateFailed =>
      l.rel_admin_endpoint_activate_failed,
    ModelAdminFailure.accountsSecureRequired =>
      l.rel_admin_accounts_secure_required,
    ModelAdminFailure.accountsReadFailed => l.rel_admin_accounts_read_failed,
    ModelAdminFailure.accountDisconnectFailed =>
      l.rel_admin_account_disconnect_failed,
    ModelAdminFailure.accountNotDisconnectable =>
      l.rel_admin_account_not_disconnectable,
    ModelAdminFailure.backendRequired => l.rel_admin_backend_required,
    ModelAdminFailure.backendSaveFailed => l.rel_admin_backend_save_failed,
    ModelAdminFailure.routesSaveFailed => l.rel_admin_routes_save_failed,
    ModelAdminFailure.profileRouteRequired =>
      l.rel_admin_profile_route_required,
    ModelAdminFailure.profileRouteUnique => l.rel_admin_profile_route_unique,
    ModelAdminFailure.profileRouteDefaultInvalid =>
      l.rel_admin_profile_route_default_invalid,
    ModelAdminFailure.profileRoutesSaveFailed =>
      l.rel_admin_profile_routes_save_failed,
    ModelAdminFailure.limitsSaveFailed => l.rel_admin_limits_save_failed,
    ModelAdminFailure.mixtureSaveFailed => l.rel_admin_mixture_save_failed,
    ModelAdminFailure.creditAmountRequired =>
      l.rel_admin_credit_amount_required,
    ModelAdminFailure.chargeCheckFailed => l.rel_admin_charge_check_failed,
    ModelAdminFailure.reloadAmountsMissing =>
      l.rel_admin_reload_amounts_missing,
    ModelAdminFailure.planRequired => l.rel_admin_plan_required,
    ModelAdminFailure.planScheduledOnly => l.rel_admin_plan_scheduled_only,
    ModelAdminFailure.connectBeforeBilling =>
      l.rel_admin_connect_before_billing,
    ModelAdminFailure.presetRequired => l.rel_admin_preset_required,
    ModelAdminFailure.billingRefused => l.rel_admin_billing_refused,
    ModelAdminFailure.requestRefused => l.rel_admin_request_refused,
    ModelAdminFailure.server => safeBillingMessage(serverMessage, l: l),
  };

  /// English compatibility rendering for non-UI callers and diagnostics.
  String get message => localized(AppLocalizationsEn());
  @override
  String toString() => message;
}

const reasoningEffortLevels = <String>{
  'none',
  'minimal',
  'low',
  'medium',
  'high',
  'xhigh',
  'max',
  'ultra',
};

const customEndpointApiModes = <String>{
  '',
  'chat_completions',
  'codex_responses',
  'anthropic_messages',
};

class EffortClamp {
  final String picked;
  final String wire;
  const EffortClamp(this.picked, this.wire);
}

EffortClamp? reasoningEffortClamp(String? effort, String? wire) {
  final picked = (effort ?? '').trim().toLowerCase();
  final sent = (wire ?? '').trim().toLowerCase();
  if (sent.isEmpty || sent == picked) return null;
  if (!reasoningEffortLevels.contains(picked) ||
      !reasoningEffortLevels.contains(sent)) {
    return null;
  }
  return EffortClamp(picked, sent);
}

class ModelPreset {
  final String? effort;
  final bool? fast;
  const ModelPreset({this.effort, this.fast});

  bool get isEmpty => effort == null && fast == null;
}

abstract class ModelPresetStore {
  ModelPreset? read(String provider, String model);
  Future<void> save(String provider, String model, ModelPreset preset);
}

class MemoryModelPresetStore implements ModelPresetStore {
  final Map<String, ModelPreset> values = {};

  static String keyFor(String provider, String model) =>
      '${provider.trim()}::${model.trim()}';

  @override
  ModelPreset? read(String provider, String model) =>
      values[keyFor(provider, model)];

  @override
  Future<void> save(String provider, String model, ModelPreset preset) async {
    final key = keyFor(provider, model);
    if (provider.trim().isEmpty || model.trim().isEmpty) {
      throw const ModelAdminException(ModelAdminFailure.chooseProvider);
    }
    if (preset.effort != null &&
        !reasoningEffortLevels.contains(preset.effort)) {
      throw const ModelAdminException(ModelAdminFailure.knownEffort);
    }
    final previous = values[key] ?? const ModelPreset();
    values[key] = ModelPreset(
      effort: preset.effort ?? previous.effort,
      fast: preset.fast ?? previous.fast,
    );
  }
}

class ProviderKeyGroup {
  final String name;
  final String envKey;
  final String description;
  final bool saved;
  const ProviderKeyGroup({
    required this.name,
    required this.envKey,
    required this.description,
    required this.saved,
  });
}

bool _isKeyVar(String key, Map<String, dynamic> info) =>
    info['is_password'] == true ||
    RegExp(r'(?:_API_KEY|_TOKEN|_KEY)$').hasMatch(key);

List<ProviderKeyGroup> providerKeyGroups(Map<String, dynamic> env) {
  final buckets = <String, List<MapEntry<String, Map<String, dynamic>>>>{};
  for (final entry in env.entries) {
    final info = entry.value;
    if (info is! Map || info['category'] != 'provider') continue;
    final row = Map<String, dynamic>.from(info);
    final name =
        (row['provider_label'] ?? row['provider'])?.toString().trim() ?? '';
    if (name.isEmpty || name == 'Other') continue;
    if (!RegExp(r'^[A-Z][A-Z0-9_]{0,127}$').hasMatch(entry.key)) continue;
    buckets.putIfAbsent(name, () => []).add(MapEntry(entry.key, row));
  }
  final groups = <ProviderKeyGroup>[];
  for (final bucket in buckets.entries) {
    final entries = bucket.value;
    MapEntry<String, Map<String, dynamic>>? primary;
    for (final entry in entries) {
      if (entry.value['provider_primary'] == true &&
          _isKeyVar(entry.key, entry.value)) {
        primary = entry;
        break;
      }
    }
    if (primary == null) {
      for (final entry in entries) {
        if (entry.value['advanced'] != true &&
            _isKeyVar(entry.key, entry.value)) {
          primary = entry;
          break;
        }
      }
    }
    if (primary == null) {
      for (final entry in entries) {
        if (_isKeyVar(entry.key, entry.value)) {
          primary = entry;
          break;
        }
      }
    }
    if (primary == null) continue;
    groups.add(
      ProviderKeyGroup(
        name: bucket.key,
        envKey: primary.key,
        description: primary.value['description']?.toString() ?? '',
        saved: entries.any((entry) => entry.value['is_set'] == true),
      ),
    );
  }
  groups.sort((a, b) => a.name.compareTo(b.name));
  return groups;
}

class NamedEndpoint {
  final String id;
  final String name;
  final String baseUrl;
  final String model;
  final String apiMode;
  final bool current;
  final bool hasKey;
  const NamedEndpoint({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.model,
    required this.apiMode,
    required this.current,
    required this.hasKey,
  });
}

class EndpointDraft {
  final String? id;
  final String name;
  final String baseUrl;
  final String model;
  final String apiMode;
  final String? apiKey;
  final bool discoverModels;
  final bool makeDefault;
  const EndpointDraft({
    required this.name,
    required this.baseUrl,
    required this.model,
    required this.apiMode,
    this.id,
    this.apiKey,
    this.discoverModels = true,
    this.makeDefault = false,
  });
}

const endpointCredentialQueryKeys = <String>{
  'api_key',
  'token',
  'key',
  'secret',
  'password',
};

/// Query credentials are rejected the same way `user:pass@` is: the draft is
/// not saved. A query that cannot be decoded is rejected too, because a
/// credential could be hiding in it.
bool endpointQueryHasCredential(Uri uri) {
  try {
    for (final name in uri.queryParameters.keys) {
      if (endpointCredentialQueryKeys.contains(name.toLowerCase())) {
        return true;
      }
    }
  } on FormatException {
    return true;
  }
  return false;
}

void validateEndpointDraft(EndpointDraft draft) {
  final name = draft.name.trim();
  final model = draft.model.trim();
  if (name.isEmpty || name.length > 128 || name.contains(RegExp(r'[\r\n]'))) {
    throw const ModelAdminException(ModelAdminFailure.endpointNameRequired);
  }
  if (model.isEmpty || model.length > 256) {
    throw const ModelAdminException(ModelAdminFailure.endpointModelRequired);
  }
  if (!customEndpointApiModes.contains(draft.apiMode)) {
    throw const ModelAdminException(ModelAdminFailure.knownApiMode);
  }
  if (draft.id != null &&
      !RegExp(r'^[A-Za-z0-9_.:-]{1,128}$').hasMatch(draft.id!)) {
    throw const ModelAdminException(ModelAdminFailure.endpointIdInvalid);
  }
  final uri = Uri.tryParse(draft.baseUrl.trim());
  final host = uri?.host.toLowerCase() ?? '';
  final loopback = host == 'localhost' || host == '127.0.0.1' || host == '::1';
  if (uri == null ||
      !uri.hasScheme ||
      host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      endpointQueryHasCredential(uri) ||
      (uri.scheme != 'https' && !(uri.scheme == 'http' && loopback))) {
    throw const ModelAdminException(ModelAdminFailure.endpointHttps);
  }
  final key = draft.apiKey?.trim();
  if (key != null &&
      key.isNotEmpty &&
      (key.length > 4096 || key.contains('\n'))) {
    throw const ModelAdminException(ModelAdminFailure.keyInvalid);
  }
}

Map<String, dynamic> endpointRequestBody(EndpointDraft draft) {
  validateEndpointDraft(draft);
  final key = draft.apiKey?.trim();
  return {
    if (draft.id != null) 'id': draft.id,
    'name': draft.name.trim(),
    'base_url': draft.baseUrl.trim(),
    'model': draft.model.trim(),
    'api_mode': draft.apiMode,
    'discover_models': draft.discoverModels,
    'make_default': draft.makeDefault,
    if (key != null && key.isNotEmpty) 'api_key': key,
  };
}

List<NamedEndpoint> namedEndpoints(Map<String, dynamic> body) {
  final rows = body['endpoints'];
  if (rows is! List) {
    throw const ModelAdminException(ModelAdminFailure.responseShape);
  }
  return [
    for (final row in rows)
      if (row is Map &&
          row['id'] is String &&
          row['name'] is String &&
          row['base_url'] is String &&
          row['model'] is String)
        NamedEndpoint(
          id: row['id'] as String,
          name: row['name'] as String,
          baseUrl: row['base_url'] as String,
          model: row['model'] as String,
          apiMode: customEndpointApiModes.contains(row['api_mode'])
              ? row['api_mode'] as String
              : '',
          current: row['is_current'] == true,
          hasKey: row['has_api_key'] == true,
        ),
  ];
}

class EndpointTestResult {
  final bool reachable;
  final String? serverMessage;
  final bool answered;
  final String transport;
  final List<String> models;
  const EndpointTestResult({
    required this.reachable,
    required this.serverMessage,
    required this.answered,
    required this.transport,
    required this.models,
  });

  String localizedMessage(AppLocalizations l) =>
      serverMessage ??
      (answered
          ? l.rel_admin_endpoint_answered
          : l.rel_admin_endpoint_no_answer);
  String get message => localizedMessage(AppLocalizationsEn());
}

EndpointTestResult endpointTestResult(Map<String, dynamic> body) {
  final models = body['models'];
  return EndpointTestResult(
    reachable: body['reachable'] == true && body['ok'] != false,
    answered: body['reachable'] == true,
    serverMessage: body['message']?.toString().trim().isNotEmpty == true
        ? body['message'].toString()
        : null,
    transport: customEndpointApiModes.contains(body['transport_checked'])
        ? body['transport_checked'] as String
        : '',
    models: models is List
        ? [
            for (final model in models)
              if (model is String) model,
          ]
        : const [],
  );
}

class ProviderAccountRow {
  final String id;
  final String name;
  final bool loggedIn;
  final bool disconnectable;
  const ProviderAccountRow({
    required this.id,
    required this.name,
    required this.loggedIn,
    required this.disconnectable,
  });
}

List<ProviderAccountRow> providerAccounts(Map<String, dynamic> body) {
  final rows = body['providers'];
  if (rows is! List) {
    throw const ModelAdminException(ModelAdminFailure.responseShape);
  }
  return [
    for (final row in rows)
      if (row is Map &&
          row['id'] is String &&
          RegExp(r'^[a-zA-Z0-9_-]{1,128}$').hasMatch(row['id'] as String) &&
          row['name'] is String)
        ProviderAccountRow(
          id: row['id'] as String,
          name: row['name'] as String,
          loggedIn: row['status'] is Map && row['status']['logged_in'] == true,
          disconnectable: row['disconnectable'] == true,
        ),
  ];
}

class DelegationLimits {
  final int? maxIterations;
  final int? maxConcurrentChildren;
  final int? childTimeoutSeconds;
  final String? reasoningEffort;
  const DelegationLimits({
    this.maxIterations,
    this.maxConcurrentChildren,
    this.childTimeoutSeconds,
    this.reasoningEffort,
  });
}

int? _boundedInt(Object? value, int max) {
  final parsed = value is int ? value : int.tryParse(value?.toString() ?? '');
  if (parsed == null || parsed < 1 || parsed > max) return null;
  return parsed;
}

DelegationLimits delegationLimitsFromConfig(Map<String, dynamic> body) {
  final root = body['config'] is Map
      ? Map<String, dynamic>.from(body['config'] as Map)
      : body;
  final delegation = root['delegation'];
  if (delegation is! Map) return const DelegationLimits();
  final effort = delegation['reasoning_effort']
      ?.toString()
      .trim()
      .toLowerCase();
  return DelegationLimits(
    maxIterations: _boundedInt(delegation['max_iterations'], 10000),
    maxConcurrentChildren: _boundedInt(
      delegation['max_concurrent_children'],
      10000,
    ),
    childTimeoutSeconds: _boundedInt(
      delegation['child_timeout_seconds'],
      86400,
    ),
    reasoningEffort: effort != null && reasoningEffortLevels.contains(effort)
        ? effort
        : null,
  );
}

Map<String, dynamic> delegationLimitsPatch(DelegationLimits limits) {
  final iterations = limits.maxIterations;
  final children = limits.maxConcurrentChildren;
  final timeout = limits.childTimeoutSeconds;
  if (iterations == null || children == null || timeout == null) {
    throw const ModelAdminException(ModelAdminFailure.limitsRequired);
  }
  if (limits.reasoningEffort != null &&
      !reasoningEffortLevels.contains(limits.reasoningEffort)) {
    throw const ModelAdminException(ModelAdminFailure.knownEffort);
  }
  return {
    'max_iterations': iterations,
    'max_concurrent_children': children,
    'child_timeout_seconds': timeout,
    if (limits.reasoningEffort != null)
      'reasoning_effort': limits.reasoningEffort,
  };
}

Map<String, dynamic> modelRouteBody({
  required List<Map<String, dynamic>> routes,
  required String? defaultRoute,
}) {
  final names = <String>{};
  final options = <Map<String, dynamic>>[];
  for (final route in routes) {
    final copy = Map<String, dynamic>.from(route);
    final name = copy['name']?.toString().trim() ?? '';
    final model = copy['model']?.toString().trim() ?? '';
    if (!RegExp(r'^[A-Za-z0-9_.:-]{1,64}$').hasMatch(name) || model.isEmpty) {
      throw const ModelAdminException(ModelAdminFailure.routeRequired);
    }
    if (!names.add(name)) {
      throw const ModelAdminException(ModelAdminFailure.routeUnique);
    }
    copy['name'] = name;
    copy['model'] = model;
    final effort = copy['reasoning_effort']?.toString().trim().toLowerCase();
    if (effort == null || effort.isEmpty) {
      copy.remove('reasoning_effort');
    } else if (!reasoningEffortLevels.contains(effort)) {
      throw const ModelAdminException(ModelAdminFailure.knownEffort);
    } else {
      copy['reasoning_effort'] = effort;
    }
    options.add(copy);
  }
  if (defaultRoute != null && !names.contains(defaultRoute)) {
    throw const ModelAdminException(ModelAdminFailure.routeDefaultInvalid);
  }
  return {'options': options, 'default': defaultRoute};
}

Map<String, dynamic> editActiveMixture(
  Map<String, dynamic> source, {
  required bool enabled,
  required String policy,
  required Map<String, dynamic> aggregator,
  required List<Map<String, dynamic>> references,
}) {
  if (policy != 'loud' && policy != 'silent') {
    throw const ModelAdminException(ModelAdminFailure.policyRequired);
  }
  final copy = _jsonMap(source);
  final presets = copy['presets'];
  final active = copy['active_preset']?.toString() ?? '';
  if (presets is! Map || active.isEmpty || presets[active] is! Map) {
    throw const ModelAdminException(ModelAdminFailure.mixtureMissing);
  }
  bool complete(Map slot) {
    final provider = slot['provider']?.toString().trim() ?? '';
    final model = slot['model']?.toString().trim() ?? '';
    return provider.isNotEmpty && model.isNotEmpty;
  }

  final preset = Map<String, dynamic>.from(presets[active] as Map);
  final nextAggregator = Map<String, dynamic>.from(aggregator);
  final nextReferences = [
    for (final reference in references) Map<String, dynamic>.from(reference),
  ];
  if (!complete(nextAggregator) ||
      nextReferences.isEmpty ||
      nextReferences.any((slot) => !complete(slot))) {
    throw const ModelAdminException(ModelAdminFailure.mixtureSlotsRequired);
  }
  preset['enabled'] = enabled;
  preset['degraded_reference_policy'] = policy;
  preset['aggregator'] = nextAggregator;
  preset['reference_models'] = nextReferences;
  presets[active] = preset;
  copy['enabled'] = enabled;
  copy['degraded_reference_policy'] = policy;
  copy['aggregator'] = nextAggregator;
  copy['reference_models'] = nextReferences;
  return copy;
}

Map<String, dynamic> _jsonMap(Map<String, dynamic> source) {
  final copy = <String, dynamic>{};
  for (final entry in source.entries) {
    copy[entry.key] = _jsonValue(entry.value);
  }
  return copy;
}

Object? _jsonValue(Object? value) {
  if (value is Map) {
    return {
      for (final entry in value.entries)
        entry.key.toString(): _jsonValue(entry.value),
    };
  }
  if (value is List) return [for (final item in value) _jsonValue(item)];
  return value;
}

/// Desktop allows a charge only when the account is signed in, remote
/// spending is on, and a card or payment method is on file.
bool chargeAccountReady(Map<String, dynamic> state) {
  if (state['ok'] != true ||
      state['logged_in'] != true ||
      state['can_charge'] != true ||
      state['cli_billing_enabled'] != true) {
    return false;
  }
  return state['payment_method'] is Map || state['card'] is Map;
}

bool creditsPurchasable(Map<String, dynamic> state) {
  if (!chargeAccountReady(state)) return false;
  final presets = state['charge_presets'];
  return presets is List &&
      presets.any((amount) => amount is String && amount.isNotEmpty);
}

/// In-app auto-reload edits use the same charge gates. A distinct saved card
/// stays on the portal, matching Desktop.
bool autoReloadEditable(Map<String, dynamic> state) {
  if (!chargeAccountReady(state)) return false;
  final reload = state['auto_reload'];
  if (reload is Map) {
    final card = reload['card'];
    if (card is Map && card['kind'] == 'distinct') return false;
  }
  return true;
}

const fallbackBillingPortalUrl = 'https://portal.nousresearch.com/billing';

String billingPortalUrl(Map<String, dynamic>? state) {
  final raw = state?['portal_url']?.toString().trim() ?? '';
  final uri = Uri.tryParse(raw);
  if (uri == null ||
      !uri.hasScheme ||
      uri.scheme != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      endpointQueryHasCredential(uri)) {
    return fallbackBillingPortalUrl;
  }
  return uri.toString();
}

bool planChangeCanCommit(String? effect) => effect == 'scheduled';

/// Team plans are changed on the portal. Personal plans still need the
/// gateway's can_change_plan flag.
bool plansChangeInApp(Map<String, dynamic>? subscription) {
  return subscription?['can_change_plan'] == true &&
      subscription?['context'] != 'team';
}

const chargePollInterval = Duration(seconds: 2);
const chargePollCap = Duration(minutes: 5);
const chargePollMaxRetryAfter = Duration(seconds: 30);

/// English compatibility rendering; UI uses the shared catalogue.
String get chargeOutcomeUnknownMessage =>
    AppLocalizationsEn().rel_admin_charge_unknown;

const _ambiguousChargeErrors = <String>{
  'insufficient_scope',
  'remote_spending_revoked',
  'session_revoked',
};

const _retryChargeErrors = <String>{
  'endpoint_unavailable',
  'internal_error',
  'network_error',
  'rate_limited',
  'stripe_unavailable',
  'temporarily_unavailable',
};

/// A thrown timeout or transport error means the charge may have been
/// accepted. A typed gateway refusal is a definite answer.
bool chargeSendIsAmbiguous(Object error) {
  if (error is ModelAdminException) return false;
  final text = error.toString().toLowerCase();
  return text.contains('timeout') ||
      text.contains('timed out') ||
      text.contains('socketexception') ||
      text.contains('clientexception') ||
      text.contains('connection closed') ||
      text.contains('connection reset') ||
      text.contains('connection refused') ||
      text.contains('failed host lookup') ||
      text.contains('handshakeexception') ||
      text.contains('network is unreachable');
}

/// `settled` and `failed` are terminal. `unknown` must not start a second
/// charge. `pending` keeps polling.
String classifyChargeStatus(Map<String, dynamic> status) {
  if (status['ok'] == false) {
    final error = (status['error'] ?? '').toString();
    if (_ambiguousChargeErrors.contains(error)) return 'unknown';
    if (_retryChargeErrors.contains(error)) return 'pending';
    return 'failed';
  }
  switch (status['status']?.toString()) {
    case 'settled':
      return 'settled';
    case 'failed':
      return 'failed';
    default:
      return 'pending';
  }
}

Duration chargeStatusWait(Map<String, dynamic> status) {
  if (status['ok'] == false &&
      _retryChargeErrors.contains((status['error'] ?? '').toString())) {
    final raw = status['retry_after'];
    final seconds = raw is num
        ? raw.toDouble()
        : double.tryParse('${raw ?? ''}') ?? 5;
    final milliseconds = (seconds * 1000).round();
    if (milliseconds <= 0) return Duration.zero;
    if (milliseconds > chargePollMaxRetryAfter.inMilliseconds) {
      return chargePollMaxRetryAfter;
    }
    return Duration(milliseconds: milliseconds);
  }
  return chargePollInterval;
}

String safeBillingMessage(Object? message, {AppLocalizations? l}) {
  final text = message?.toString().trim() ?? '';
  if (text.isEmpty || text.contains('http') || text.length > 240) {
    return (l ?? AppLocalizationsEn()).rel_admin_billing_refused;
  }
  return text;
}

String newIdempotencyKey() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

String checkedSessionId(String value) {
  final id = value.trim();
  if (id.isEmpty || id.length > 256 || id.contains(RegExp(r'\s'))) {
    throw const ModelAdminException(ModelAdminFailure.chatIdRequired);
  }
  return id;
}
