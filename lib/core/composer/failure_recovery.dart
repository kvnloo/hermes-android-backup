/// Failure-card actions, following Desktop's one-primary-plus-one-link table.
/// Actions this client cannot perform (billing, sign-in, local folders) are
/// named and then left off the card rather than shown as dead buttons.
const kMaxTimerDelayMs = 2147483647;

const kFailureLayers = {
  'provider',
  'endpoint',
  'streaming',
  'auth',
  'billing',
  'gateway',
  'runtime',
  'disk',
};

const kKnownFailureCodes = {
  'auth',
  'auth_permanent',
  'billing',
  'rate_limit',
  'upstream_rate_limit',
  'overloaded',
  'server_error',
  'timeout',
  'stream_drop',
  'ssl_cert_verification',
  'upstream_blocked',
  'context_overflow',
  'payload_too_large',
  'model_not_found',
  'provider_policy_blocked',
  'content_policy_blocked',
  'format_error',
  'truncated',
  'invalid_response',
  'empty_response',
  'loop_error',
  'SESSION_NOT_OWNED',
  'SESSION_OWNER_BUSY',
  'cron_session_read_only',
  'session_read_only',
  'workspace_unavailable',
  'launch_credentials_unavailable',
  'local_runtime_unavailable',
  'SESSION_OWNER_UNCONFIRMED',
  'agent_init_failed',
  'disk_full',
  'no_reply',
  'free_tier_disabled',
  'free_tier_rate_limited',
  'free_tier_at_capacity',
  'free_tier_model_not_free',
  'free_tier_route',
  'free_tier_outage',
  'free_tier_refused',
  'usage_window',
};

enum RecoveryAction {
  retry,
  retryAtReset,
  compress,
  chooseModel,
  switchToModel,
  switchProvider,
  startNewSession,
  editMessage,
  continueReply,
  updateApiKey,
  signInAgain,
  signInFreeTier,
  openBilling,
  useCredits,
  openProviderSettings,
  openSetupGuideTls,
  openSetupGuideLocal,
  openModelSettings,
  openHermesFolder,
}

class FailureActions {
  const FailureActions(this.primary, [this.secondary]);

  final RecoveryAction? primary;
  final RecoveryAction? secondary;
}

class ModelSuggestion {
  const ModelSuggestion({
    required this.model,
    required this.label,
    this.provider,
    this.note = '',
  });

  final String model;
  final String label;
  final String? provider;
  final String note;
}

class UsageLimitInfo {
  const UsageLimitInfo({this.suggestions = const [], this.credits});

  final List<ModelSuggestion> suggestions;

  /// `use_credits`, `add_credits` or `add_credits_and_keep_going` when sent.
  final String? credits;
}

class FailureSurface {
  const FailureSurface({
    required this.layer,
    required this.code,
    required this.retryable,
    this.provider,
    this.model,
    this.authKind,
    this.message,
    this.resetsAt,
    this.usageLimit,
    this.failedAt,
  });

  final String layer;
  final String code;
  final bool retryable;
  final String? provider;
  final String? model;
  final String? authKind;
  final String? message;
  final int? resetsAt;
  final UsageLimitInfo? usageLimit;
  final int? failedAt;

  /// Null when the payload has no recognised layer. Callers keep the plain
  /// error string and do not invent a code from its wording.
  static FailureSurface? parse(Object? raw) {
    if (raw is! Map) return null;
    final layer = raw['layer'];
    if (layer is! String || !kFailureLayers.contains(layer)) return null;
    final code = raw['code'];
    final provider = raw['provider'];
    final model = raw['model'];
    final auth = raw['auth_kind'];
    final message = raw['message'];
    final resets = raw['resets_at'];
    final failed = raw['failed_at'];
    return FailureSurface(
      layer: layer,
      code: code is String && code.isNotEmpty ? code : 'unknown',
      retryable: raw['retryable'] != false,
      provider: provider is String && provider.isNotEmpty ? provider : null,
      model: model is String && model.isNotEmpty ? model : null,
      authKind: auth == 'oauth' || auth == 'api_key' ? auth : null,
      message: message is String && message.trim().isNotEmpty
          ? message.trim()
          : null,
      resetsAt: resets is num && resets.isFinite && resets > 0
          ? resets.round()
          : null,
      usageLimit: _usageLimit(raw['usage_limit']),
      failedAt: failed is num && failed.isFinite && failed > 0
          ? failed.round()
          : null,
    );
  }
}

UsageLimitInfo? _usageLimit(Object? raw) {
  if (raw is! Map) return null;
  final suggestions = <ModelSuggestion>[];
  final listed = raw['suggestions'];
  if (listed is List) {
    for (final item in listed) {
      if (item is! Map) continue;
      final model = item['model'];
      if (model is! String || model.isEmpty) continue;
      final label = item['label'];
      final note = item['note'];
      final provider = item['provider'];
      suggestions.add(
        ModelSuggestion(
          model: model,
          label: label is String && label.isNotEmpty ? label : model,
          provider: provider is String && provider.isNotEmpty ? provider : null,
          note: note is String ? note : '',
        ),
      );
    }
  }
  final credits = raw['credits'];
  final action = credits is Map ? credits['action'] : null;
  const allowed = {'use_credits', 'add_credits', 'add_credits_and_keep_going'};
  final credit = action is String && allowed.contains(action) ? action : null;
  if (suggestions.isEmpty && credit == null) return null;
  return UsageLimitInfo(suggestions: suggestions, credits: credit);
}

String? providerSettingsUrl(String? provider) {
  return switch (provider?.toLowerCase()) {
    'openrouter' => 'https://openrouter.ai/settings/privacy',
    'nous' => 'https://portal.nousresearch.com',
    _ => null,
  };
}

int? scheduledRetryDelayMs(int? resetsAtSeconds, int nowMs) {
  if (resetsAtSeconds == null) return null;
  final delay = resetsAtSeconds * 1000 - nowMs;
  if (delay <= 0 || delay > kMaxTimerDelayMs) return null;
  return delay;
}

String formatResetClock(int resetsAtSeconds) {
  final at = DateTime.fromMillisecondsSinceEpoch(
    resetsAtSeconds * 1000,
    isUtc: false,
  );
  final hour = at.hour.toString().padLeft(2, '0');
  final minute = at.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

bool showsDiagnostics(FailureSurface? surface) =>
    surface?.code != 'usage_window';

bool _known(String code) => kKnownFailureCodes.contains(code);

FailureActions actionsFor(FailureSurface? surface, {required int nowMs}) {
  if (surface == null) return const FailureActions(RecoveryAction.retry);
  if (surface.layer == 'auth') {
    return FailureActions(
      surface.authKind == 'oauth' && surface.provider != null
          ? RecoveryAction.signInAgain
          : RecoveryAction.updateApiKey,
      RecoveryAction.retry,
    );
  }
  final endpoint = _endpoint(surface);
  if (endpoint != null) return endpoint;
  if (surface.code == 'usage_window') return _usageWindow(surface, nowMs);
  if (surface.code == 'provider_policy_blocked' &&
      providerSettingsUrl(surface.provider) == null) {
    return const FailureActions(RecoveryAction.chooseModel);
  }
  final byCode = _byCode[surface.code];
  if (_known(surface.code) && byCode != null) return byCode;
  if (surface.code.startsWith('free_tier_')) {
    return surface.retryable
        ? const FailureActions(
            RecoveryAction.signInFreeTier,
            RecoveryAction.retry,
          )
        : const FailureActions(RecoveryAction.signInFreeTier);
  }
  if ((surface.code == 'rate_limit' || surface.code == 'upstream_rate_limit') &&
      scheduledRetryDelayMs(surface.resetsAt, nowMs) != null) {
    return const FailureActions(
      RecoveryAction.retryAtReset,
      RecoveryAction.retry,
    );
  }
  if (surface.retryable) return const FailureActions(RecoveryAction.retry);
  const switchLayers = {'auth', 'billing', 'endpoint', 'provider'};
  return FailureActions(
    switchLayers.contains(surface.layer) ? RecoveryAction.switchProvider : null,
  );
}

FailureActions? _endpoint(FailureSurface surface) {
  if (surface.code == 'local_runtime_unavailable') {
    return surface.retryable
        ? const FailureActions(
            RecoveryAction.retry,
            RecoveryAction.switchProvider,
          )
        : const FailureActions(RecoveryAction.switchProvider);
  }
  final endpointCopy =
      surface.layer == 'endpoint' &&
      (surface.code == 'timeout' || surface.code == 'ssl_cert_verification');
  if (!endpointCopy) return null;
  return surface.code == 'timeout'
      ? const FailureActions(
          RecoveryAction.retry,
          RecoveryAction.openSetupGuideLocal,
        )
      : const FailureActions(RecoveryAction.openSetupGuideLocal);
}

FailureActions _usageWindow(FailureSurface surface, int nowMs) {
  final limit = surface.usageLimit;
  final credits = limit?.credits == 'use_credits'
      ? RecoveryAction.useCredits
      : RecoveryAction.openBilling;
  if (limit != null && limit.suggestions.isNotEmpty) {
    return FailureActions(RecoveryAction.switchToModel, credits);
  }
  if (limit == null) {
    return FailureActions(credits, RecoveryAction.chooseModel);
  }
  if (surface.resetsAt == null) return FailureActions(credits);
  if (surface.resetsAt! * 1000 <= nowMs) {
    return FailureActions(credits, RecoveryAction.retry);
  }
  return scheduledRetryDelayMs(surface.resetsAt, nowMs) == null
      ? FailureActions(credits)
      : FailureActions(credits, RecoveryAction.retryAtReset);
}

const _byCode = <String, FailureActions>{
  'billing': FailureActions(
    RecoveryAction.openBilling,
    RecoveryAction.switchProvider,
  ),
  'content_policy_blocked': FailureActions(RecoveryAction.editMessage),
  'context_overflow': FailureActions(
    RecoveryAction.compress,
    RecoveryAction.startNewSession,
  ),
  'disk_full': FailureActions(
    RecoveryAction.openHermesFolder,
    RecoveryAction.retry,
  ),
  'free_tier_at_capacity': FailureActions(
    RecoveryAction.signInFreeTier,
    RecoveryAction.retry,
  ),
  'format_error': FailureActions(
    RecoveryAction.switchProvider,
    RecoveryAction.startNewSession,
  ),
  'free_tier_outage': FailureActions(RecoveryAction.retry),
  'model_not_found': FailureActions(RecoveryAction.chooseModel),
  'payload_too_large': FailureActions(
    RecoveryAction.compress,
    RecoveryAction.startNewSession,
  ),
  'provider_policy_blocked': FailureActions(
    RecoveryAction.openProviderSettings,
    RecoveryAction.chooseModel,
  ),
  'SESSION_NOT_OWNED': FailureActions(RecoveryAction.startNewSession),
  'ssl_cert_verification': FailureActions(RecoveryAction.openSetupGuideTls),
  'truncated': FailureActions(RecoveryAction.continueReply),
  'upstream_blocked': FailureActions(RecoveryAction.switchProvider),
  'agent_init_failed': FailureActions(
    RecoveryAction.retry,
    RecoveryAction.openModelSettings,
  ),
  'SESSION_OWNER_BUSY': FailureActions(RecoveryAction.retry),
  'SESSION_OWNER_UNCONFIRMED': FailureActions(null),
  'cron_session_read_only': FailureActions(RecoveryAction.startNewSession),
  'session_read_only': FailureActions(RecoveryAction.startNewSession),
  'workspace_unavailable': FailureActions(
    RecoveryAction.retry,
    RecoveryAction.startNewSession,
  ),
  'launch_credentials_unavailable': FailureActions(
    RecoveryAction.startNewSession,
  ),
  'loop_error': FailureActions(
    RecoveryAction.retry,
    RecoveryAction.startNewSession,
  ),
};

class RecoveryHost {
  const RecoveryHost({
    this.retry = true,
    this.compress = true,
    this.switchModel = true,
    this.newSession = true,
    this.edit = true,
  });

  final bool retry;
  final bool compress;
  final bool switchModel;
  final bool newSession;
  final bool edit;

  static const chat = RecoveryHost();

  bool allows(RecoveryAction action) {
    return switch (action) {
      RecoveryAction.retry || RecoveryAction.retryAtReset => retry,
      RecoveryAction.compress => compress,
      RecoveryAction.chooseModel ||
      RecoveryAction.switchToModel ||
      RecoveryAction.switchProvider ||
      RecoveryAction.openModelSettings => switchModel,
      RecoveryAction.startNewSession => newSession,
      RecoveryAction.editMessage || RecoveryAction.continueReply => edit,
      _ => false,
    };
  }
}

class PresentedRecovery {
  const PresentedRecovery({
    required this.primary,
    required this.secondary,
    required this.omittedExternal,
    this.suggestion,
  });

  final RecoveryAction? primary;
  final RecoveryAction? secondary;

  /// A Desktop action was dropped because this client cannot perform it.
  final bool omittedExternal;
  final ModelSuggestion? suggestion;
}

PresentedRecovery presentRecovery(
  FailureSurface? surface, {
  required int nowMs,
  RecoveryHost host = RecoveryHost.chat,
}) {
  final raw = actionsFor(surface, nowMs: nowMs);
  final primaryOk = raw.primary != null && host.allows(raw.primary!);
  final secondaryOk = raw.secondary != null && host.allows(raw.secondary!);
  final RecoveryAction? primary;
  final RecoveryAction? secondary;
  if (primaryOk) {
    primary = raw.primary;
    secondary = secondaryOk ? raw.secondary : null;
  } else if (secondaryOk) {
    primary = raw.secondary;
    secondary = null;
  } else {
    primary = null;
    secondary = null;
  }
  bool external(RecoveryAction? action) =>
      action != null && !host.allows(action);
  final suggestion = surface?.usageLimit?.suggestions.isNotEmpty == true
      ? surface!.usageLimit!.suggestions.first
      : null;
  return PresentedRecovery(
    primary: primary,
    secondary: secondary,
    omittedExternal: external(raw.primary) || external(raw.secondary),
    suggestion: primary == RecoveryAction.switchToModel ? suggestion : null,
  );
}

String formatErrorDiagnostics({
  required String errorText,
  FailureSurface? surface,
  String? provider,
  String? model,
  String? appVersion,
}) {
  final lines = <String>['\u2500\u2500 Hermes error details \u2500\u2500'];
  void add(String? line) {
    if (line != null && line.isNotEmpty) lines.add(line);
  }

  if (surface?.failedAt != null) {
    add(
      'time: ${DateTime.fromMillisecondsSinceEpoch(surface!.failedAt! * 1000, isUtc: true).toIso8601String()}',
    );
  }
  add(surface == null ? null : 'layer: ${surface.layer}');
  add(surface == null ? null : 'code: ${surface.code}');
  add(surface == null ? null : 'retryable: ${surface.retryable}');
  if (surface?.resetsAt != null) {
    add(
      'resets_at: ${DateTime.fromMillisecondsSinceEpoch(surface!.resetsAt! * 1000, isUtc: true).toIso8601String()}',
    );
  }
  final who = surface?.provider ?? provider;
  final which = surface?.model ?? model;
  add(who == null || who.isEmpty ? null : 'provider: $who');
  add(which == null || which.isEmpty ? null : 'model: $which');
  add(appVersion == null || appVersion.isEmpty ? null : 'app: $appVersion');
  lines.add('error: $errorText');
  return lines.join('\n');
}
