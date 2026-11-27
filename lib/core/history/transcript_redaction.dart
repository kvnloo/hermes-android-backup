/// Removes credential-shaped text before a transcript is shown, exported or
/// sent.
///
/// The shapes follow the gateway's force-mode export redaction
/// (b7ee21c14e `agent/redact.py`, what `session.export --redact` runs):
/// known token prefixes, secret-named assignments, `Authorization` headers,
/// credentials in URLs and private key blocks. Like the gateway it leaves
/// benign text alone: prose that merely mentions a secret, code that looks
/// a key up (`api_key = os.environ["OPENAI_API_KEY"]`) and text that is
/// already redacted (`api_key=***`).
///
/// [containsSecret] is defined by [redactSecrets] itself, so redacted
/// output can never be judged to still hold a secret.
library;

/// What a redacted value becomes.
const redactedMark = '[redacted]';

/// The gateway's known token prefixes (`_PREFIX_PATTERNS`).
const _prefixes = <String>[
  r'sk-[A-Za-z0-9_-](?:\.?[A-Za-z0-9_-]){7,}',
  r'ctx7sk-[A-Za-z0-9_-]{10,}',
  r'ghp_[A-Za-z0-9]{8,}',
  r'github_pat_[A-Za-z0-9_]{8,}',
  r'gh[ousr]_[A-Za-z0-9]{10,}',
  r'xapp-\d+-[A-Za-z0-9-]{10,}',
  r'xox[baprs]-[A-Za-z0-9-]{8,}',
  r'AIza[A-Za-z0-9_-]{30,}',
  r'GOCSPX-[A-Za-z0-9_-]{8,}',
  r'ya29\.(?:[a-z]\.)?[A-Za-z0-9_-]{20,}',
  r'AQ\.[A-Za-z0-9_-]{40,}',
  r'1//0[A-Za-z0-9_-]{20,}',
  r'pplx-[A-Za-z0-9]{10,}',
  r'fal_[A-Za-z0-9_-]{10,}',
  r'fc-[A-Za-z0-9]{10,}',
  r'bb_live_[A-Za-z0-9_-]{10,}',
  r'gAAAA[A-Za-z0-9_=-]{20,}',
  r'AKIA[A-Z0-9]{16}',
  r'sk_live_[A-Za-z0-9]{10,}',
  r'sk_test_[A-Za-z0-9]{10,}',
  r'rk_live_[A-Za-z0-9]{10,}',
  r'SG\.[A-Za-z0-9_-]{10,}(?:\.[A-Za-z0-9_-]{10,})?',
  r'hf_[A-Za-z0-9]{10,}',
  r'r8_[A-Za-z0-9]{10,}',
  r'npm_[A-Za-z0-9]{10,}',
  r'pypi-[A-Za-z0-9_-]{10,}',
  r'do[op]_v1_[A-Za-z0-9]{10,}',
  r'tvly-(?:(?:dev|prod)-)?[A-Za-z0-9]{10,}',
  r'exa_[A-Za-z0-9]{10,}',
  r'gsk_[A-Za-z0-9]{10,}',
  r'syt_[A-Za-z0-9]{10,}',
  r'xai-[A-Za-z0-9]{30,}',
  r'ntn_[A-Za-z0-9]{10,}',
  r'gl(?:pat|oas|dt|cbt|ptt|ft|imt|agent|soat|ffct|wt)-[A-Za-z0-9_-]{10,}',
  r'glrtr?-[A-Za-z0-9_.-]{10,}',
  r'glsa_[A-Za-z0-9]{10,}',
];

final _token = RegExp(
  '(?<![A-Za-z0-9_-])(?:${_prefixes.join('|')})(?![A-Za-z0-9_-])',
);

/// `Bearer <credential>` outside a header line.
final _bearer = RegExp(r'\b(Bearer\s+)([A-Za-z0-9._~+/-]{8,}=*)');

/// `Authorization: [scheme] <credential>`, wherever it is quoted.
final _authorization = RegExp(
  r'''(authorization\s*:\s*)((?:bearer|basic|token)\s+)?([^\s'"]+)''',
  caseSensitive: false,
);

/// The gateway's `_SECRET_ENV_NAMES`: `OPENAI_API_KEY=...`.
final _envAssigned = RegExp(
  r'(?<![A-Za-z0-9_])'
  r'([A-Z0-9_]{0,50}?'
  r'(?:API_?KEY|TOKEN|SECRET|PASSWORD|PASSWD|CREDENTIAL)'
  r'[A-Z0-9_]{0,50})'
  r'(\s*=\s*)'
  r'''(['"]?)([^\s'"]+)''',
);

const _secretNames =
    r'(?:[a-z0-9]+[_-])*'
    r'(?:api[_-]?key|token|secret|password|passwd|credentials?)';

/// `access_token = ...` (the gateway's lower-case assignment rule).
final _assigned = RegExp(
  '(?<![A-Za-z0-9_-])($_secretNames)'
  r'(\s*=\s*)'
  r'''(['"]?)([^\s'"]+)''',
  caseSensitive: false,
);

/// A YAML, JSON or header-style `key: value` whose key starts the line.
/// Prose such as "The secret: rotate it weekly" is not one.
final _keyed = RegExp(
  '^([ \\t]*[{,]?[ \\t]*["\']?)($_secretNames)'
  r'''(["']?\s*:\s*)(["']?)([^\s'",}]+)''',
  caseSensitive: false,
  multiLine: true,
);

/// `scheme://user:password@host`.
final _urlPassword = RegExp(r'(://[^/\s:@]+:)([^@\s/]+)(@)');

/// A credential in a URL query (the gateway's `_SENSITIVE_QUERY_PARAMS`).
final _queryParam = RegExp(
  r'([?&](?:access_token|refresh_token|id_token|token|api_key|apikey|'
  r'client_secret|password|secret|signature|sig)=)([^&\s#]+)',
  caseSensitive: false,
);

final _privateKey = RegExp(
  r'-----BEGIN [A-Z ]*PRIVATE KEY-----[\s\S]*?'
  r'-----END [A-Z ]*PRIVATE KEY-----',
);

/// Values that are not a secret: already redacted, empty, or code that
/// looks the secret up somewhere else.
final _benignValue = RegExp(
  r'^(?:\*{3,}|\[redacted\]|<redacted>|\.{3}|…|'
  r'none|null|nil|undefined|true|false|'
  r'os\.environ|os\.getenv|getenv\(|process\.env|import\.meta\.env|'
  r'env\[|env\(|System\.getenv|Platform\.environment|'
  r'\$|\{\{|<[A-Za-z_]|%[A-Za-z_])',
  caseSensitive: false,
);

bool _isSecretValue(String value) =>
    value.length >= 4 && !_benignValue.hasMatch(value);

/// Whether [input] can hold anything this file redacts. One cheap scan
/// keeps ordinary prose (and megabytes of it) off the slower rules.
final _candidate = RegExp(
  r'key|token|secret|passw|credential|authorization|bearer|://|'
  r'PRIVATE KEY|sk-|sk_|gh[pousr]_|github_pat_|xox|xapp-|AIza|AKIA|ya29\.|'
  r'GOCSPX-|hf_|npm_|pypi-|gl[a-z]+-|glsa_|gAAAA|SG\.|AQ\.|1//0|pplx-|'
  r'fal_|fc-|bb_live_|rk_live_|r8_|do[op]_v1_|tvly-|exa_|gsk_|syt_|xai-|'
  r'ntn_',
  caseSensitive: false,
);

String redactSecrets(String input) {
  if (!_candidate.hasMatch(input)) return input;
  var out = input.replaceAll(_privateKey, redactedMark);
  out = out.replaceAll(_token, redactedMark);
  out = out.replaceAllMapped(_authorization, (match) {
    final value = match[3]!;
    if (!_isSecretValue(value)) return match[0]!;
    return '${match[1]}${match[2] ?? ''}$redactedMark';
  });
  out = out.replaceAllMapped(
    _bearer,
    (match) =>
        _isSecretValue(match[2]!) ? '${match[1]}$redactedMark' : match[0]!,
  );
  String assigned(Match match) => _isSecretValue(match[4]!)
      ? '${match[1]}${match[2]}${match[3]}$redactedMark'
      : match[0]!;
  out = out.replaceAllMapped(_envAssigned, assigned);
  out = out.replaceAllMapped(_assigned, assigned);
  out = out.replaceAllMapped(
    _keyed,
    (match) => _isSecretValue(match[5]!)
        ? '${match[1]}${match[2]}${match[3]}${match[4]}$redactedMark'
        : match[0]!,
  );
  out = out.replaceAllMapped(
    _urlPassword,
    (match) => _isSecretValue(match[2]!)
        ? '${match[1]}$redactedMark${match[3]}'
        : match[0]!,
  );
  return out.replaceAllMapped(
    _queryParam,
    (match) =>
        _isSecretValue(match[2]!) ? '${match[1]}$redactedMark' : match[0]!,
  );
}

/// Whether [input] still holds something [redactSecrets] would remove.
/// Redacted output never does: the check is the redaction itself.
bool containsSecret(String input) => redactSecrets(input) != input;
