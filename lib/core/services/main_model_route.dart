// Reviewed canonical defaults from Hermes auth.PROVIDER_REGISTRY (bf0203a).
// This is deliberately an exact provider + URL allowlist, not host inference.
// New/changed defaults remain read-only until reviewed; never accept catalogue
// api_url as a default because that field describes user-defined routes.
const _canonicalEndpoints = <String, String>{
  'nous': 'https://inference-api.nousresearch.com/v1',
  'openrouter': 'https://openrouter.ai/api/v1',
  'vercel': 'https://ai-gateway.vercel.sh/v1',
  'opencode': 'https://opencode.ai/zen/v1',
  'opencode-go': 'https://opencode.ai/zen/go/v1',
  'kilo': 'https://api.kilo.ai/api/gateway',
  'openai-api': 'https://api.openai.com/v1',
  'openai-codex': 'https://chatgpt.com/backend-api/codex',
  'anthropic': 'https://api.anthropic.com',
  'deepseek': 'https://api.deepseek.com/v1',
  'xai': 'https://api.x.ai/v1',
  'xai-oauth': 'https://api.x.ai/v1',
  'qwen-oauth': 'https://portal.qwen.ai/v1',
  'gemini': 'https://generativelanguage.googleapis.com/v1beta',
  'zai': 'https://api.z.ai/api/paas/v4',
  'minimax': 'https://api.minimax.io/anthropic',
  'minimax-oauth': 'https://api.minimax.io/anthropic',
  'minimax-cn': 'https://api.minimaxi.com/anthropic',
  'alibaba': 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1',
  'alibaba-coding-plan': 'https://coding-intl.dashscope.aliyuncs.com/v1',
  'nvidia': 'https://integrate.api.nvidia.com/v1',
  'huggingface': 'https://router.huggingface.co/v1',
  'xiaomi': 'https://api.xiaomimimo.com/v1',
  'tencent-tokenhub': 'https://tokenhub.tencentmaas.com/v1',
  'tencent-tokenplan': 'https://api.lkeap.cloud.tencent.com/plan/anthropic',
  'stepfun': 'https://api.stepfun.ai/step_plan/v1',
  'arcee': 'https://api.arcee.ai/api/v1',
  'gmi': 'https://api.gmi-serving.com/v1',
  'actual': 'https://api.actual.inc/v1',
  'ollama-cloud': 'https://ollama.com/v1',
  'commandcode': 'https://api.commandcode.ai/provider/v1',
  'deepinfra': 'https://api.deepinfra.com/v1/openai',
  'fireworks': 'https://api.fireworks.ai/inference/v1',
  'nebius-token-factory': 'https://api.tokenfactory.nebius.com/v1',
  'novita': 'https://api.novita.ai/openai/v1',
  'upstage': 'https://api.upstage.ai/v1',
};

/// A persisted canonical standard URL is not an endpoint override. Named active
/// endpoints still take precedence, even when they use a canonical URL.
/// Only trailing slashes are equivalent: paths, query, userinfo and fragments
/// must never be discarded to turn an override into a standard assignment.
bool mainModelUsesCustomEndpoint(String provider, String baseUrl) {
  if (provider == 'custom' ||
      provider == 'local' ||
      provider.startsWith('custom:')) {
    return true;
  }
  if (baseUrl.isEmpty) return false;
  final canonical = _canonicalEndpoints[provider];
  return canonical == null ||
      baseUrl.replaceFirst(RegExp(r'/+$'), '') != canonical;
}

/// Provider names the gateway routes as an endpoint with no name of its own
/// (`auth._PROVIDER_ALIASES` sends the local-server names to `custom`). It
/// matches them in any letter case.
const _unnamedEndpointProviders = {
  'custom',
  'local',
  'ollama',
  'vllm',
  'llamacpp',
  'llama.cpp',
  'llama-cpp',
};

bool isUnnamedEndpointProvider(String provider) =>
    _unnamedEndpointProviders.contains(provider.trim().toLowerCase());

/// An endpoint address as the gateway compares them: no surrounding space,
/// no trailing slash, any letter case.
String normaliseEndpointAddress(Object? raw) => raw is String
    ? raw.trim().replaceFirst(RegExp(r'/+$'), '').toLowerCase()
    : '';

/// [provider] has a reviewed standard address and [baseUrl] is that address.
/// Null when the app has no reviewed address for [provider].
bool? isReviewedStandardEndpoint(String provider, String baseUrl) {
  final canonical = _canonicalEndpoints[provider.trim().toLowerCase()];
  if (canonical == null) return null;
  return normaliseEndpointAddress(baseUrl) ==
      normaliseEndpointAddress(canonical);
}

/// `process://<provider>`: the address an external-process provider plugin
/// registers for itself (`agent/process_transport.py`). The gateway writes it
/// back whenever that provider is chosen, so it is never lost.
bool isProviderOwnProcessAddress(String provider, String baseUrl) {
  final uri = Uri.tryParse(baseUrl.trim());
  return uri != null &&
      uri.scheme.toLowerCase() == 'process' &&
      uri.host.toLowerCase() == provider.trim().toLowerCase() &&
      uri.path.replaceAll('/', '').isEmpty;
}
