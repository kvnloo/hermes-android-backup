import 'dart:convert';

import '../services/connection_manager.dart';
import '../services/ws_client.dart';

/// One dashboard HTTP result. Bodies are decoded by [CapabilityAdmin]; callers
/// do not log them.
typedef CapabilityRest =
    Future<CapabilityResponse> Function(
      String method,
      String path, {
      Map<String, String>? query,
      Object? body,
      Duration? timeout,
    });

/// One JSON-RPC call on the connection's own gateway socket.
typedef CapabilityRpc =
    Future<Map<String, dynamic>> Function(
      String method,
      Map<String, dynamic> params,
    );

class CapabilityResponse {
  const CapabilityResponse(this.statusCode, this.body);

  final int statusCode;
  final String body;
}

enum CapabilityFailure {
  enterALabel,
  enterAValidUrlLikeHttpsExampleCom,
  enterTheIdentifierAndPassword,
  enterTheCardNameNumberExpiryAndSecurityCode,
  enterTheStreetCityPostalCodeAndCountry,
  theGatewayReturnedAResponseThatCouldNotBeRead,
  theGatewayRefusedTheRequestStatus,
  thisConnectionHasNoGatewaySocketSoMethodIsUnavailable,
  chooseASkill,
  theSkillTextWasNotReturned,
  theSkillWasNotSaved,
  theSkillWasNotArchived,
  theSkillWasNotInstalled,
  skillUpdatesDidNotStart,
  theSkillWasNotRemoved,
  enterASkillOrPluginIdentifier,
  chooseAPlugin,
  thePluginWasNotRemoved,
  theDesktopHalfWasNotRemoved,
  thisGatewayDidNotGiveThePluginAStableKey,
  thePluginWasNotChanged,
  chooseAServer,
  nameTheServer,
  giveTheServerACommandOrAnHttpSUrl,
  chooseAToolset,
  toolBackendStatusWasNotReturned,
  chooseAProvider,
  thisProviderHasNoSetupAction,
  setupDidNotStart,
  chooseATerminalBackend,
  nameTheConnector,
  chooseAnAccount,
  reloadTheConnectorPolicyBeforeChangingToolGrants,
  chooseAnItem,
  chooseASource,
  enterTheMasterPassword,
  gatewayConfigWasNotReturned,
  chooseAKnownApprovalMode,
  useAPositiveLimit,
  thePolicyWasNotSaved,
}

String _failureEnglish(
  CapabilityFailure reason, {
  int? statusCode,
  String? method,
}) => switch (reason) {
  CapabilityFailure.enterALabel => 'Enter a label.',
  CapabilityFailure.enterAValidUrlLikeHttpsExampleCom =>
    'Enter a valid URL like https://example.com.',
  CapabilityFailure.enterTheIdentifierAndPassword =>
    'Enter the identifier and password.',
  CapabilityFailure.enterTheCardNameNumberExpiryAndSecurityCode =>
    'Enter the card name, number, expiry and security code.',
  CapabilityFailure.enterTheStreetCityPostalCodeAndCountry =>
    'Enter the street, city, postal code and country.',
  CapabilityFailure.theGatewayReturnedAResponseThatCouldNotBeRead =>
    'The gateway returned a response that could not be read.',
  CapabilityFailure.theGatewayRefusedTheRequestStatus =>
    'The gateway refused the request ($statusCode).',
  CapabilityFailure.thisConnectionHasNoGatewaySocketSoMethodIsUnavailable =>
    'This connection has no gateway socket, so $method is unavailable.',
  CapabilityFailure.chooseASkill => 'Choose a skill.',
  CapabilityFailure.theSkillTextWasNotReturned =>
    'The skill text was not returned.',
  CapabilityFailure.theSkillWasNotSaved => 'The skill was not saved.',
  CapabilityFailure.theSkillWasNotArchived => 'The skill was not archived.',
  CapabilityFailure.theSkillWasNotInstalled => 'The skill was not installed.',
  CapabilityFailure.skillUpdatesDidNotStart => 'Skill updates did not start.',
  CapabilityFailure.theSkillWasNotRemoved => 'The skill was not removed.',
  CapabilityFailure.enterASkillOrPluginIdentifier =>
    'Enter a skill or plugin identifier.',
  CapabilityFailure.chooseAPlugin => 'Choose a plugin.',
  CapabilityFailure.thePluginWasNotRemoved => 'The plugin was not removed.',
  CapabilityFailure.theDesktopHalfWasNotRemoved =>
    'The desktop half was not removed.',
  CapabilityFailure.thisGatewayDidNotGiveThePluginAStableKey =>
    'This gateway did not give the plugin a stable key.',
  CapabilityFailure.thePluginWasNotChanged => 'The plugin was not changed.',
  CapabilityFailure.chooseAServer => 'Choose a server.',
  CapabilityFailure.nameTheServer => 'Name the server.',
  CapabilityFailure.giveTheServerACommandOrAnHttpSUrl =>
    'Give the server a command or an http(s) URL.',
  CapabilityFailure.chooseAToolset => 'Choose a toolset.',
  CapabilityFailure.toolBackendStatusWasNotReturned =>
    'Tool backend status was not returned.',
  CapabilityFailure.chooseAProvider => 'Choose a provider.',
  CapabilityFailure.thisProviderHasNoSetupAction =>
    'This provider has no setup action.',
  CapabilityFailure.setupDidNotStart => 'Setup did not start.',
  CapabilityFailure.chooseATerminalBackend => 'Choose a terminal backend.',
  CapabilityFailure.nameTheConnector => 'Name the connector.',
  CapabilityFailure.chooseAnAccount => 'Choose an account.',
  CapabilityFailure.reloadTheConnectorPolicyBeforeChangingToolGrants =>
    'Reload the connector policy before changing tool grants.',
  CapabilityFailure.chooseAnItem => 'Choose an item.',
  CapabilityFailure.chooseASource => 'Choose a source.',
  CapabilityFailure.enterTheMasterPassword => 'Enter the master password.',
  CapabilityFailure.gatewayConfigWasNotReturned =>
    'Gateway config was not returned.',
  CapabilityFailure.chooseAKnownApprovalMode => 'Choose a known approval mode.',
  CapabilityFailure.useAPositiveLimit => 'Use a positive limit.',
  CapabilityFailure.thePolicyWasNotSaved => 'The policy was not saved.',
};

class CapabilityException implements Exception {
  const CapabilityException(String message, {this.statusCode, this.rpcCode})
    : _message = message,
      reason = null,
      method = null;

  const CapabilityException.reason(
    this.reason, {
    this.statusCode,
    this.rpcCode,
    this.method,
  }) : _message = null;

  final String? _message;
  final CapabilityFailure? reason;
  final String? method;
  final int? statusCode;
  final int? rpcCode;
  String get message =>
      _message ??
      _failureEnglish(reason!, statusCode: statusCode, method: method);
  bool get methodMissing => rpcCode == -32601;
  @override
  String toString() => message;
}

class VaultFormException implements Exception {
  const VaultFormException(String message) : _message = message, reason = null;
  const VaultFormException.reason(this.reason) : _message = null;
  final String? _message;
  final CapabilityFailure? reason;
  String get message => _message ?? _failureEnglish(reason!);
  @override
  String toString() => message;
}

/// Learned or externally mounted skills can be rewritten. Bundled and hub
/// skills stay with their source.
bool skillIsEditable(String? provenance) =>
    provenance == 'agent' || provenance == 'external';

bool validVaultOrigin(String value) {
  final uri = Uri.tryParse(value.trim());
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) return false;
  return uri.scheme == 'https' || uri.scheme == 'http';
}

String scrubSecrets(String text, Iterable<String> secrets) {
  var out = text;
  for (final secret in secrets) {
    if (secret.length >= 4) out = out.replaceAll(secret, '[redacted]');
  }
  return out;
}

String redactLogText(String text) {
  final scheme = ['be', 'arer'].join();
  return text
      .split('\n')
      .map((line) {
        final lower = line.toLowerCase();
        var redacted = line;
        if (lower.contains('authorization:')) {
          final start = lower.indexOf(scheme);
          if (start >= 0) {
            final value = RegExp(
              r'\S+',
            ).matchAsPrefix(line.substring(start + scheme.length).trimLeft());
            if (value != null) {
              final token = value.group(0)!;
              final at = line.indexOf(token, start + scheme.length);
              redacted = line.replaceRange(at, at + token.length, '[redacted]');
            }
          }
        }
        return redacted.replaceAllMapped(
          RegExp(
            r'(password|secret|token|api_key|cvc|card_number)(\s*[:=]\s*)(\S+)',
            caseSensitive: false,
          ),
          (match) => '${match[1]}${match[2]}[redacted]',
        );
      })
      .join('\n');
}

class SkillRecord {
  const SkillRecord({
    required this.name,
    required this.description,
    required this.enabled,
    required this.locked,
    required this.provenance,
  });

  final String name;
  final String description;
  final bool enabled;
  final bool locked;
  final String provenance;

  bool get editable => skillIsEditable(provenance);
}

class SkillScan {
  const SkillScan({
    required this.verdict,
    required this.findings,
    required this.blocked,
    required this.caution,
  });

  final String verdict;
  final List<String> findings;
  final bool blocked;
  final bool caution;
}

class HubInstallResult {
  const HubInstallResult({
    required this.installed,
    required this.scan,
    this.action,
  });

  final bool installed;
  final SkillScan scan;
  final String? action;
}

class PluginRecord {
  const PluginRecord({
    required this.name,
    required this.key,
    required this.description,
    required this.status,
    required this.hasDesktopHalf,
  });

  final String name;
  final String key;
  final String description;
  final String status;
  final bool hasDesktopHalf;

  bool get enabled => status == 'enabled' || status == 'active';
}

class PluginMutation {
  const PluginMutation({
    required this.ok,
    this.consentRequired = false,
    this.scanBlocked = false,
    this.lines = const [],
    this.message,
  });

  final bool ok;
  final bool consentRequired;
  final bool scanBlocked;
  final List<String> lines;
  final String? message;
}

class McpServerRecord {
  const McpServerRecord({
    required this.name,
    required this.enabled,
    required this.detail,
  });

  final String name;
  final bool enabled;
  final String detail;
}

class McpServerSpec {
  const McpServerSpec.stdio({
    required this.command,
    this.args = const [],
    this.cwd,
  }) : url = null;

  const McpServerSpec.http({required this.url})
    : command = null,
      args = const [],
      cwd = null;

  final String? command;
  final List<String> args;
  final String? cwd;
  final String? url;

  Map<String, Object?> toJson() {
    if (url != null) return {'url': url};
    return {
      'command': command,
      'args': args,
      if (cwd != null && cwd!.isNotEmpty) 'cwd': cwd,
    };
  }

  @override
  String toString() => url != null ? 'http' : 'stdio';
}

class McpProbe {
  const McpProbe({required this.ok, required this.tools, this.error});

  final bool ok;
  final List<String> tools;
  final String? error;
}

class ToolProviderRecord {
  const ToolProviderRecord({
    required this.name,
    required this.status,
    required this.active,
    this.setupKey,
  });

  final String name;
  final String status;
  final bool active;
  final String? setupKey;
}

class ToolsetSetup {
  const ToolsetSetup({
    required this.name,
    required this.providers,
    this.activeProvider,
  });

  final String name;
  final List<ToolProviderRecord> providers;
  final String? activeProvider;
}

class TerminalBackendRecord {
  const TerminalBackendRecord({
    required this.name,
    required this.label,
    required this.status,
    required this.active,
    required this.detail,
  });

  final String name;
  final String label;
  final String status;
  final bool active;
  final String detail;
}

class ConnectorAccount {
  const ConnectorAccount({
    required this.connectionId,
    required this.connector,
    required this.alias,
  });

  final String connectionId;
  final String connector;
  final String alias;
}

class ConnectorToolGrant {
  const ConnectorToolGrant({
    required this.revision,
    required this.tools,
    required this.disabled,
  });

  /// Member-layer revision. Null means this client must not write a grant.
  final String? revision;
  final List<String> tools;
  final List<String> disabled;
}

class VaultItem {
  const VaultItem({
    required this.id,
    required this.kind,
    required this.label,
    required this.origin,
    required this.backend,
    required this.removable,
  });

  final String id;
  final String kind;
  final String label;
  final String origin;
  final String backend;
  final bool removable;
}

class VaultSource {
  const VaultSource({
    required this.name,
    required this.label,
    required this.enabled,
    required this.installed,
    required this.needsUnlock,
    required this.unlocked,
  });

  final String name;
  final String label;
  final bool enabled;
  final bool installed;
  final bool needsUnlock;
  final bool unlocked;
}

class VaultInventory {
  const VaultInventory({required this.items, required this.sources});

  final List<VaultItem> items;
  final List<VaultSource> sources;
}

class VaultDraft {
  const VaultDraft.login({
    required this.label,
    required this.origin,
    required this.identifier,
    required this.password,
    this.otpSecret = '',
  }) : kind = 'login',
       cardNumber = '',
       cardName = '',
       expMonth = '',
       expYear = '',
       cvc = '',
       postal = '',
       line1 = '',
       line2 = '',
       city = '',
       state = '',
       country = '';

  const VaultDraft.address({
    required this.label,
    required this.origin,
    required this.line1,
    required this.city,
    required this.postal,
    required this.country,
    this.line2 = '',
    this.state = '',
  }) : kind = 'address',
       identifier = '',
       password = '',
       otpSecret = '',
       cardNumber = '',
       cardName = '',
       expMonth = '',
       expYear = '',
       cvc = '';

  const VaultDraft.payment({
    required this.label,
    required this.origin,
    required this.cardNumber,
    required this.cardName,
    required this.expMonth,
    required this.expYear,
    required this.cvc,
    required this.postal,
  }) : kind = 'payment',
       identifier = '',
       password = '',
       otpSecret = '',
       line1 = '',
       line2 = '',
       city = '',
       state = '',
       country = '';

  final String kind;
  final String label;
  final String origin;
  final String identifier;
  final String password;
  final String otpSecret;
  final String cardNumber;
  final String cardName;
  final String expMonth;
  final String expYear;
  final String cvc;
  final String postal;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String country;

  Map<String, String> secret() {
    if (label.trim().isEmpty) {
      throw const VaultFormException.reason(CapabilityFailure.enterALabel);
    }
    if (!validVaultOrigin(origin)) {
      throw const VaultFormException.reason(
        CapabilityFailure.enterAValidUrlLikeHttpsExampleCom,
      );
    }
    switch (kind) {
      case 'login':
        if (identifier.trim().isEmpty || password.isEmpty) {
          throw const VaultFormException.reason(
            CapabilityFailure.enterTheIdentifierAndPassword,
          );
        }
        return {
          'identifier_type': identifier.contains('@') ? 'email' : 'username',
          'identifier': identifier.trim(),
          'password': password,
          if (otpSecret.trim().isNotEmpty) 'otp_secret': otpSecret.trim(),
        };
      case 'payment':
        final number = cardNumber.replaceAll(RegExp(r'\s+'), '');
        final month = int.tryParse(expMonth.trim());
        if (!RegExp(r'^\d{12,19}$').hasMatch(number) ||
            cardName.trim().isEmpty ||
            month == null ||
            month < 1 ||
            month > 12 ||
            !RegExp(r'^\d{2,4}$').hasMatch(expYear.trim()) ||
            !RegExp(r'^\d{3,4}$').hasMatch(cvc)) {
          throw const VaultFormException.reason(
            CapabilityFailure.enterTheCardNameNumberExpiryAndSecurityCode,
          );
        }
        return {
          'card_number': number,
          'cardholder_name': cardName.trim(),
          'exp_month': expMonth.trim(),
          'exp_year': expYear.trim(),
          'cvc': cvc,
          'billing_postal_code': postal.trim(),
        };
      default:
        if (line1.trim().isEmpty ||
            city.trim().isEmpty ||
            postal.trim().isEmpty ||
            country.trim().isEmpty) {
          throw const VaultFormException.reason(
            CapabilityFailure.enterTheStreetCityPostalCodeAndCountry,
          );
        }
        return {
          'address_line1': line1.trim(),
          'city': city.trim(),
          'postal_code': postal.trim(),
          'country': country.trim(),
          if (line2.trim().isNotEmpty) 'address_line2': line2.trim(),
          if (state.trim().isNotEmpty) 'state': state.trim(),
        };
    }
  }
}

class AgentPolicy {
  const AgentPolicy({
    required this.approvalMode,
    required this.approvalTimeout,
    required this.confirmMcpReload,
    required this.allowlist,
    required this.checkpointsEnabled,
    required this.checkpointLimit,
    required this.browserPrivateUrls,
    required this.realBrowserProfile,
  });

  final String approvalMode;
  final int approvalTimeout;
  final bool confirmMcpReload;
  final List<String> allowlist;
  final bool checkpointsEnabled;
  final int checkpointLimit;
  final bool browserPrivateUrls;
  final bool realBrowserProfile;

  static const modes = ['manual', 'smart', 'off'];

  Map<String, Object?> toWrite() => {
    'approvals': {
      'mode': approvalMode,
      'timeout': approvalTimeout,
      'mcp_reload_confirm': confirmMcpReload,
    },
    'command_allowlist': allowlist,
    'checkpoints': {
      'enabled': checkpointsEnabled,
      'max_snapshots': checkpointLimit,
    },
    'browser': {
      'allow_private_urls': browserPrivateUrls,
      'use_real_profile': realBrowserProfile,
    },
  };
}

class SharedMetricsConsent {
  const SharedMetricsConsent({
    required this.enabled,
    required this.send,
    required this.decided,
    required this.reask,
  });

  final bool enabled;
  final bool send;
  final bool decided;
  final bool reask;
}

class CapabilityAdmin {
  CapabilityAdmin({required this._rest, this._rpc, String? profile})
    : profile = _clean(profile);

  factory CapabilityAdmin.fromDashboard(
    DashboardClient dashboard, {
    CapabilityRpc? rpc,
    String? profile,
  }) {
    return CapabilityAdmin(
      profile: profile,
      rpc: rpc,
      rest: (method, path, {query, body, timeout}) async {
        final response = await dashboard.apiRequest(
          method,
          path,
          queryParameters: query,
          body: body,
          timeout: timeout ?? ApiClient.requestTimeout,
        );
        return CapabilityResponse(response.statusCode, response.body);
      },
    );
  }

  final CapabilityRest _rest;
  final CapabilityRpc? _rpc;
  final String? profile;

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  Map<String, String> _query([Map<String, String>? extra]) {
    final query = {...?extra};
    final selected = profile;
    if (selected != null) query.putIfAbsent('profile', () => selected);
    return query;
  }

  Future<Object?> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
    Duration? timeout,
  }) async {
    final response = await _rest(
      method,
      path,
      query: _query(query),
      body: body,
      timeout: timeout,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CapabilityException(
        _refusal(response),
        statusCode: response.statusCode,
      );
    }
    final raw = response.body.trim();
    if (raw.isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw const CapabilityException.reason(
        CapabilityFailure.theGatewayReturnedAResponseThatCouldNotBeRead,
      );
    }
  }

  String _refusal(CapabilityResponse response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        final message =
            decoded['error'] ?? decoded['message'] ?? decoded['detail'];
        if (message is String && message.trim().isNotEmpty) {
          return redactLogText(message.trim());
        }
      }
    } on FormatException {
      // A non-JSON refusal still must not be copied through.
    }
    throw CapabilityException.reason(
      CapabilityFailure.theGatewayRefusedTheRequestStatus,
      statusCode: response.statusCode,
    );
  }

  Future<Map<String, dynamic>> _call(
    String method,
    Map<String, dynamic> params, {
    Iterable<String> secrets = const [],
  }) async {
    final rpc = _rpc;
    if (rpc == null) {
      throw CapabilityException.reason(
        CapabilityFailure.thisConnectionHasNoGatewaySocketSoMethodIsUnavailable,
        method: method,
      );
    }
    final selected = profile;
    final payload = selected == null || params.containsKey('profile')
        ? params
        : {...params, 'profile': selected};
    try {
      return await rpc(method, payload);
    } on JsonRpcError catch (error) {
      throw CapabilityException(
        scrubSecrets(error.message, secrets),
        rpcCode: error.code,
      );
    } catch (error) {
      throw CapabilityException(scrubSecrets('$error', secrets));
    }
  }

  static String _name(Object? value, CapabilityFailure fallback) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty ||
        text.contains('/') ||
        text.contains('\\') ||
        text.contains('..')) {
      throw CapabilityException.reason(fallback);
    }
    return text;
  }

  Future<List<SkillRecord>> skills() async {
    final decoded = await _send('GET', 'skills');
    return _rows(decoded, const ['skills']).map(_skill).toList();
  }

  SkillRecord _skill(Map row) => SkillRecord(
    name: '${row['name'] ?? ''}',
    description: '${row['description'] ?? ''}',
    enabled: row['enabled'] != false,
    locked: row['locked'] == true,
    provenance: '${row['provenance'] ?? ''}',
  );

  Future<String> skillContent(String name) async {
    final skill = _name(name, CapabilityFailure.chooseASkill);
    final decoded = await _send(
      'GET',
      'skills/content',
      query: {'name': skill},
    );
    final content = decoded is Map ? decoded['content'] : null;
    if (content is! String) {
      throw const CapabilityException.reason(
        CapabilityFailure.theSkillTextWasNotReturned,
      );
    }
    return content;
  }

  Future<void> setSkillEnabled(String name, bool enabled) async {
    await _send(
      'PUT',
      'skills/toggle',
      body: {
        'name': _name(name, CapabilityFailure.chooseASkill),
        'enabled': enabled,
      },
    );
  }

  Future<void> setSkillLocked(String name, bool locked) async {
    await _send(
      'PUT',
      'skills/lock',
      body: {
        'name': _name(name, CapabilityFailure.chooseASkill),
        'locked': locked,
      },
    );
  }

  Future<String> learningContent(String name) async {
    final skill = _name(name, CapabilityFailure.chooseASkill);
    final decoded = await _send('GET', 'learning/node', query: {'id': skill});
    if (decoded is! Map ||
        decoded['ok'] == false ||
        decoded['content'] is! String) {
      throw const CapabilityException.reason(
        CapabilityFailure.theSkillTextWasNotReturned,
      );
    }
    return decoded['content'] as String;
  }

  Future<void> saveLearningContent(String name, String content) async {
    final decoded = await _send(
      'PUT',
      'learning/node',
      body: {
        'id': _name(name, CapabilityFailure.chooseASkill),
        'content': content,
      },
    );
    _requireOk(decoded, CapabilityFailure.theSkillWasNotSaved);
  }

  Future<void> archiveSkill(String name) async {
    final decoded = await _send(
      'DELETE',
      'learning/node',
      body: {'id': _name(name, CapabilityFailure.chooseASkill)},
    );
    _requireOk(decoded, CapabilityFailure.theSkillWasNotArchived);
  }

  Future<SkillScan> scanHubSkill(String identifier) async {
    final id = _identifier(identifier);
    final decoded = await _send(
      'GET',
      'skills/hub/scan',
      query: {'identifier': id},
      timeout: const Duration(seconds: 45),
    );
    return _scan(decoded);
  }

  Future<HubInstallResult> installHubSkill(
    String identifier, {
    bool force = false,
  }) async {
    final scan = await scanHubSkill(identifier);
    // policy=block never installs, including when the caller passes force.
    // policy=ask installs only after an explicit confirmation, and that
    // confirmation is the stock install's force flag.
    if (scan.blocked || (scan.caution && !force)) {
      return HubInstallResult(installed: false, scan: scan);
    }
    final decoded = await _send(
      'POST',
      'skills/hub/install',
      body: {'identifier': _identifier(identifier), if (force) 'force': true},
      timeout: const Duration(seconds: 45),
    );
    _requireOk(decoded, CapabilityFailure.theSkillWasNotInstalled);
    final action = decoded is Map
        ? (decoded['name'] ?? decoded['action'])?.toString()
        : null;
    return HubInstallResult(
      installed: _installConfirmed(decoded),
      scan: scan,
      action: action,
    );
  }

  /// A spawned action (`ok`, `pid`, `name`) has not installed the skill.
  bool _installConfirmed(Object? decoded) {
    if (decoded is! Map || decoded['ok'] == false) return false;
    if (decoded['installed'] == true) return true;
    final status = '${decoded['status'] ?? ''}'.toLowerCase();
    return status == 'installed' ||
        status == 'succeeded' ||
        status == 'success';
  }

  Future<void> updateHubSkills() async {
    final decoded = await _send(
      'POST',
      'skills/hub/update',
      body: const {},
      timeout: const Duration(seconds: 120),
    );
    _requireOk(decoded, CapabilityFailure.skillUpdatesDidNotStart);
  }

  Future<void> uninstallHubSkill(String name) async {
    final decoded = await _send(
      'POST',
      'skills/hub/uninstall',
      body: {'name': _name(name, CapabilityFailure.chooseASkill)},
    );
    _requireOk(decoded, CapabilityFailure.theSkillWasNotRemoved);
  }

  SkillScan _scan(Object? decoded) {
    final map = decoded is Map ? decoded : const {};
    final verdict = '${map['verdict'] ?? ''}'.toLowerCase();
    final policy = '${map['policy'] ?? ''}'.toLowerCase();
    final findings = <String>[
      for (final row
          in map['findings'] is List ? map['findings'] as List : const [])
        row is Map
            ? '${row['description'] ?? row['message'] ?? row['summary'] ?? row['pattern_id'] ?? row}'
            : '$row',
    ];
    final reason = '${map['policy_reason'] ?? ''}'.trim();
    if (reason.isNotEmpty && !findings.contains(reason)) {
      findings.insert(0, reason);
    }
    // Stock hub scans decide with policy: allow, ask, or block. Verdict is
    // safe, caution, or dangerous and is shown, not used as the gate.
    // Anything other than allow or ask fails closed and is never installed.
    final blocked = policy != 'allow' && policy != 'ask';
    final caution = policy == 'ask';
    return SkillScan(
      verdict: verdict.isEmpty ? (blocked ? 'blocked' : 'clean') : verdict,
      findings: findings,
      blocked: blocked,
      caution: caution,
    );
  }

  String _identifier(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.contains('\n') || trimmed.contains('\r')) {
      throw const CapabilityException.reason(
        CapabilityFailure.enterASkillOrPluginIdentifier,
      );
    }
    return trimmed;
  }

  void _requireOk(Object? decoded, CapabilityFailure fallback) {
    if (decoded is Map && decoded['ok'] == false) {
      final message = decoded['message'] ?? decoded['error'];
      if (message is String && message.trim().isNotEmpty) {
        throw CapabilityException(redactLogText(message.trim()));
      }
      throw CapabilityException.reason(fallback);
    }
  }

  Future<List<PluginRecord>> plugins() async {
    final decoded = await _call('plugins.manage', {'action': 'list'});
    return _rows(decoded, const ['plugins']).map((row) {
      return PluginRecord(
        name: '${row['name'] ?? ''}',
        key: '${row['key'] ?? ''}',
        description: '${row['description'] ?? ''}',
        status: '${row['status'] ?? ''}',
        hasDesktopHalf: row['has_desktop_half'] == true,
      );
    }).toList();
  }

  Future<PluginMutation> installPlugin(
    String identifier, {
    bool force = false,
    bool acceptCapabilities = false,
  }) {
    return _pluginAction({
      'action': 'install',
      'identifier': _identifier(identifier),
      'force': force,
      'enable': true,
      if (acceptCapabilities) 'accept_capabilities': true,
    });
  }

  /// Installs a curated catalog plugin by its catalog name: the backend
  /// resolves the repository and pinned commit from its own catalog
  /// (Desktop `installAgentPlugin` with `catalog_name`). [profile] is the
  /// profile the install goes into; null keeps this admin's profile.
  Future<PluginMutation> installCatalogPlugin(
    String catalogName, {
    String? profile,
    bool force = false,
    bool enable = true,
    String? ref,
  }) {
    final target = _clean(profile);
    return _pluginAction({
      'action': 'install',
      'identifier': '',
      'catalog_name': _name(catalogName, CapabilityFailure.chooseAPlugin),
      'force': force,
      'enable': enable,
      if (ref != null && ref.trim().isNotEmpty) 'ref': ref.trim(),
      'profile': ?target,
    });
  }

  Future<PluginMutation> updatePlugin(
    String name, {
    bool force = false,
    bool acceptCapabilities = false,
  }) {
    return _pluginAction({
      'action': 'update',
      'name': _name(name, CapabilityFailure.chooseAPlugin),
      'force': force,
      if (acceptCapabilities) 'accept_capabilities': true,
    });
  }

  Future<void> removePlugin(String name) async {
    final decoded = await _call('plugins.manage', {
      'action': 'remove',
      'name': _name(name, CapabilityFailure.chooseAPlugin),
    });
    _requireOk(decoded, CapabilityFailure.thePluginWasNotRemoved);
  }

  Future<void> removePluginDesktopHalf(String name) async {
    final decoded = await _call('plugins.manage', {
      'action': 'remove_desktop',
      'name': _name(name, CapabilityFailure.chooseAPlugin),
    });
    _requireOk(decoded, CapabilityFailure.theDesktopHalfWasNotRemoved);
  }

  Future<void> togglePlugin(String key, bool enable) async {
    final pluginKey = key.trim();
    if (pluginKey.isEmpty) {
      throw const CapabilityException.reason(
        CapabilityFailure.thisGatewayDidNotGiveThePluginAStableKey,
      );
    }
    final decoded = await _call('plugins.manage', {
      'action': 'toggle',
      'key': pluginKey,
      'enable': enable,
    });
    _requireOk(decoded, CapabilityFailure.thePluginWasNotChanged);
  }

  Future<PluginMutation> updateAllPlugins() =>
      _pluginAction({'action': 'update_all'});

  Future<PluginMutation> _pluginAction(Map<String, dynamic> params) async {
    final decoded = await _call('plugins.manage', params);
    final lines = <String>[
      for (final line
          in decoded['delta_lines'] is List
              ? decoded['delta_lines'] as List
              : const [])
        '$line',
      for (final finding
          in decoded['scan_findings'] is List
              ? decoded['scan_findings'] as List
              : const [])
        finding is Map ? '${finding['pattern_id'] ?? finding}' : '$finding',
    ];
    return PluginMutation(
      ok:
          decoded['ok'] != false &&
          decoded['consent_required'] != true &&
          decoded['scan_blocked'] != true,
      consentRequired: decoded['consent_required'] == true,
      scanBlocked: decoded['scan_blocked'] == true,
      lines: lines,
      message: decoded['error']?.toString(),
    );
  }

  Future<List<McpServerRecord>> mcpServers() async {
    final decoded = await _send('GET', 'mcp/servers');
    return _rows(decoded, const ['servers']).map((row) {
      final detail = row['url'] ?? row['command'] ?? row['description'] ?? '';
      return McpServerRecord(
        name: '${row['name'] ?? ''}',
        enabled: row['enabled'] != false,
        detail: '$detail',
      );
    }).toList();
  }

  Future<McpProbe> probeMcpServer(String name) async {
    final server = _name(name, CapabilityFailure.chooseAServer);
    final decoded = await _send(
      'POST',
      'mcp/servers/${Uri.encodeComponent(server)}/test',
      timeout: const Duration(seconds: 60),
    );
    final map = decoded is Map ? decoded : const {};
    return McpProbe(
      ok: map['ok'] == true,
      tools: [
        for (final tool
            in map['tools'] is List ? map['tools'] as List : const [])
          tool is Map ? '${tool['name']}' : '$tool',
      ],
      error: map['error']?.toString(),
    );
  }

  Future<void> setMcpEnabled(String name, bool enabled) async {
    final server = _name(name, CapabilityFailure.chooseAServer);
    await _send(
      'PUT',
      'mcp/servers/${Uri.encodeComponent(server)}/enabled',
      body: {'enabled': enabled},
    );
  }

  Future<void> addMcpServer(String name, McpServerSpec spec) async {
    final server = _name(name, CapabilityFailure.nameTheServer);
    if (spec.command == null &&
        (spec.url == null || !validVaultOrigin(spec.url!))) {
      throw const CapabilityException.reason(
        CapabilityFailure.giveTheServerACommandOrAnHttpSUrl,
      );
    }
    await _send(
      'POST',
      'mcp/servers',
      body: {'name': server, ...spec.toJson()},
    );
  }

  Future<String> mcpLogs({String? server}) async {
    final focused = _clean(server);
    final decoded = await _send(
      'GET',
      'logs',
      query: focused == null
          ? {'file': 'mcp', 'lines': '200'}
          : {'file': 'agent', 'lines': '200', 'search': focused},
    );
    return redactLogText(_logText(decoded));
  }

  String _logText(Object? decoded) {
    if (decoded is Map) {
      final lines = decoded['lines'] ?? decoded['entries'] ?? decoded['logs'];
      if (lines is List) {
        return [
          for (final line in lines)
            line is Map ? '${line['message'] ?? line['text'] ?? ''}' : '$line',
        ].join('\n');
      }
      final text = decoded['text'] ?? decoded['content'];
      if (text is String) return text;
    }
    return '';
  }

  Future<List<ToolsetSetup>> toolsets() async {
    final decoded = await _send('GET', 'tools/toolsets');
    return _rows(decoded, const ['toolsets']).map((row) {
      return ToolsetSetup(
        name: '${row['name'] ?? ''}',
        providers: const [],
        activeProvider: row['active_provider']?.toString(),
      );
    }).toList();
  }

  Future<ToolsetSetup> toolsetSetup(String name) async {
    final toolset = _name(name, CapabilityFailure.chooseAToolset);
    final decoded = await _send(
      'GET',
      'tools/toolsets/${Uri.encodeComponent(toolset)}/config',
    );
    if (decoded is! Map) {
      throw const CapabilityException.reason(
        CapabilityFailure.toolBackendStatusWasNotReturned,
      );
    }
    final providers = <ToolProviderRecord>[
      for (final row
          in decoded['providers'] is List
              ? decoded['providers'] as List
              : const [])
        if (row is Map)
          ToolProviderRecord(
            name: '${row['name'] ?? ''}',
            status: '${row['status'] ?? ''}',
            active: row['is_active'] == true,
            setupKey:
                row['post_setup'] is String &&
                    (row['post_setup'] as String).isNotEmpty
                ? row['post_setup'] as String
                : null,
          ),
    ];
    return ToolsetSetup(
      name: '${decoded['name'] ?? toolset}',
      providers: providers,
      activeProvider: decoded['active_provider']?.toString(),
    );
  }

  Future<void> selectToolsetProvider(String name, String provider) async {
    final toolset = _name(name, CapabilityFailure.chooseAToolset);
    final selected = provider.trim();
    if (selected.isEmpty) {
      throw const CapabilityException.reason(CapabilityFailure.chooseAProvider);
    }
    await _send(
      'PUT',
      'tools/toolsets/${Uri.encodeComponent(toolset)}/provider',
      body: {'provider': selected},
    );
  }

  Future<void> runToolsetSetup(String name, String key) async {
    final toolset = _name(name, CapabilityFailure.chooseAToolset);
    final setup = key.trim();
    if (setup.isEmpty) {
      throw const CapabilityException.reason(
        CapabilityFailure.thisProviderHasNoSetupAction,
      );
    }
    final decoded = await _send(
      'POST',
      'tools/toolsets/${Uri.encodeComponent(toolset)}/post-setup',
      body: {'key': setup},
    );
    _requireOk(decoded, CapabilityFailure.setupDidNotStart);
  }

  Future<List<TerminalBackendRecord>> terminalBackends() async {
    final decoded = await _send('GET', 'tools/terminal/backends');
    final rows = decoded is Map && decoded['backends'] is List
        ? decoded['backends'] as List
        : const [];
    return [
      for (final row in rows)
        if (row is Map)
          TerminalBackendRecord(
            name: '${row['name'] ?? ''}',
            label: '${row['label'] ?? row['name'] ?? ''}',
            status: '${row['status'] ?? ''}',
            active: row['active'] == true,
            detail: '${row['detail'] ?? ''}',
          ),
    ];
  }

  Future<void> selectTerminalBackend(String name) async {
    final backend = name.trim();
    if (backend.isEmpty) {
      throw const CapabilityException.reason(
        CapabilityFailure.chooseATerminalBackend,
      );
    }
    await _send('PUT', 'tools/terminal/backend', body: {'backend': backend});
  }

  Future<List<ConnectorAccount>> connectorAccounts() async {
    final decoded = await _call('connectors.accounts', {});
    final rows = decoded['accounts'] is List
        ? decoded['accounts'] as List
        : decoded['connections'] is List
        ? decoded['connections'] as List
        : const [];
    return [
      for (final row in rows)
        if (row is Map)
          ConnectorAccount(
            connectionId: '${row['connection_id'] ?? row['id'] ?? ''}',
            connector: '${row['connector'] ?? row['slug'] ?? ''}',
            alias: '${row['alias'] ?? row['name'] ?? ''}',
          ),
    ];
  }

  Future<void> connectConnector(String connector, {String? alias}) async {
    final slug = connector.trim();
    if (slug.isEmpty) {
      throw const CapabilityException.reason(
        CapabilityFailure.nameTheConnector,
      );
    }
    final named = _clean(alias);
    await _call('connectors.connect', {
      'connectors': [slug],
      'owner': {'type': 'account'},
      'reconnect': false,
      'alias': ?named,
    });
  }

  Future<void> removeConnectorAccount(String connectionId) async {
    final id = connectionId.trim();
    if (id.isEmpty) {
      throw const CapabilityException.reason(CapabilityFailure.chooseAnAccount);
    }
    await _call('connectors.accounts.remove', {'connection_id': id});
  }

  Future<ConnectorToolGrant> connectorTools(String slug) async {
    final connector = slug.trim();
    if (connector.isEmpty) {
      throw const CapabilityException.reason(
        CapabilityFailure.nameTheConnector,
      );
    }
    final policy = await _call('connectors.policy.get', {});
    final tools = await _call('connectors.tools', {
      'slug': connector,
      'refresh': false,
    });
    final layers = policy['layers'] is List
        ? policy['layers'] as List
        : const [];
    Map? member;
    for (final layer in layers) {
      if (layer is Map && layer['kind'] == 'member') member = layer;
    }
    final body = member?['body'];
    final disabled = body is Map && body['tools'] is Map
        ? ((body['tools'] as Map)[connector] is List
              ? (body['tools'] as Map)[connector] as List
              : const [])
        : const [];
    final listed = tools['tools'] is List ? tools['tools'] as List : const [];
    return ConnectorToolGrant(
      revision: member?['revision']?.toString(),
      tools: [
        for (final tool in listed)
          tool is Map ? '${tool['name'] ?? tool['slug'] ?? ''}' : '$tool',
      ].where((name) => name.isNotEmpty).toList(),
      disabled: [for (final name in disabled) '$name'],
    );
  }

  Future<void> setDisabledTools({
    required String connector,
    required List<String> disabledTools,
    required String expectedRevision,
  }) async {
    final slug = connector.trim();
    final revision = expectedRevision.trim();
    if (slug.isEmpty || revision.isEmpty) {
      throw const CapabilityException.reason(
        CapabilityFailure.reloadTheConnectorPolicyBeforeChangingToolGrants,
      );
    }
    await _call('connectors.policy.set', {
      'change': {
        'type': 'tools',
        'connector': slug,
        'disabled_tools': disabledTools,
      },
      'expected_revision': revision,
    });
  }

  Future<VaultInventory> vaultInventory() async {
    final items = await _call('vault.list', {});
    final sources = await _call('vault.sources', {});
    return VaultInventory(
      items: [
        for (final row
            in items['items'] is List ? items['items'] as List : const [])
          if (row is Map) _vaultItem(row),
      ],
      sources: [
        for (final row
            in sources['sources'] is List
                ? sources['sources'] as List
                : const [])
          if (row is Map)
            VaultSource(
              name: '${row['name'] ?? ''}',
              label: '${row['display_name'] ?? row['name'] ?? ''}',
              enabled: row['enabled'] == true,
              installed: row['installed'] == true,
              needsUnlock: row['needs_unlock'] == true,
              unlocked: row['unlocked'] == true,
            ),
      ],
    );
  }

  VaultItem _vaultItem(Map row) {
    final backend = '${row['backend'] ?? ''}'.trim();
    final local =
        backend.isEmpty ||
        backend == 'local' ||
        backend == 'hermes' ||
        backend == 'builtin';
    return VaultItem(
      id: '${row['id'] ?? ''}',
      kind: '${row['kind'] ?? ''}',
      label: '${row['label'] ?? ''}',
      origin: '${row['origin'] ?? ''}',
      backend: backend,
      removable: local && '${row['id'] ?? ''}'.trim().isNotEmpty,
    );
  }

  Future<void> addVaultItem(VaultDraft draft) async {
    final secret = draft.secret();
    try {
      await _call('vault.add', {
        'kind': draft.kind,
        'label': draft.label.trim(),
        'origin': draft.origin.trim(),
        'secret': secret,
      }, secrets: secret.values);
    } on CapabilityException catch (error) {
      if (error.reason != null) rethrow;
      throw CapabilityException(
        scrubSecrets(error.message, secret.values),
        statusCode: error.statusCode,
        rpcCode: error.rpcCode,
      );
    }
  }

  Future<void> removeVaultItem(String id) async {
    final item = id.trim();
    if (item.isEmpty) {
      throw const CapabilityException.reason(CapabilityFailure.chooseAnItem);
    }
    await _call('vault.remove', {'id': item});
  }

  Future<void> setVaultSourceEnabled(String name, bool enabled) async {
    await _call('vault.source.set', {
      'name': _name(name, CapabilityFailure.chooseASource),
      'enabled': enabled,
    });
  }

  Future<void> unlockVaultSource(String name, String password) async {
    if (password.isEmpty) {
      throw const VaultFormException.reason(
        CapabilityFailure.enterTheMasterPassword,
      );
    }
    try {
      await _call(
        'vault.unlock',
        {
          'name': _name(name, CapabilityFailure.chooseASource),
          'password': password,
        },
        secrets: [password],
      );
    } on CapabilityException catch (error) {
      if (error.reason != null) rethrow;
      throw CapabilityException(
        scrubSecrets(error.message, [password]),
        rpcCode: error.rpcCode,
      );
    }
  }

  Future<void> lockVaultSource(String name) async {
    await _call('vault.lock', {
      'name': _name(name, CapabilityFailure.chooseASource),
    });
  }

  Future<AgentPolicy> agentPolicy() async {
    final decoded = await _send('GET', 'config');
    if (decoded is! Map) {
      throw const CapabilityException.reason(
        CapabilityFailure.gatewayConfigWasNotReturned,
      );
    }
    final approvals = decoded['approvals'] is Map
        ? decoded['approvals'] as Map
        : const {};
    final checkpoints = decoded['checkpoints'] is Map
        ? decoded['checkpoints'] as Map
        : const {};
    final browser = decoded['browser'] is Map
        ? decoded['browser'] as Map
        : const {};
    final rawMode = approvals['mode'];
    final mode = rawMode == false
        ? 'off'
        : rawMode == null
        ? 'manual'
        : '$rawMode';
    return AgentPolicy(
      approvalMode: AgentPolicy.modes.contains(mode) ? mode : 'manual',
      approvalTimeout: approvals['timeout'] is num
          ? (approvals['timeout'] as num).toInt()
          : 60,
      confirmMcpReload: approvals['mcp_reload_confirm'] != false,
      allowlist: [
        for (final command
            in decoded['command_allowlist'] is List
                ? decoded['command_allowlist'] as List
                : const [])
          '$command',
      ],
      checkpointsEnabled: checkpoints['enabled'] == true,
      checkpointLimit: checkpoints['max_snapshots'] is num
          ? (checkpoints['max_snapshots'] as num).toInt()
          : 20,
      browserPrivateUrls: browser['allow_private_urls'] == true,
      realBrowserProfile: browser['use_real_profile'] == true,
    );
  }

  Future<void> saveAgentPolicy(AgentPolicy policy) async {
    if (!AgentPolicy.modes.contains(policy.approvalMode)) {
      throw const CapabilityException.reason(
        CapabilityFailure.chooseAKnownApprovalMode,
      );
    }
    if (policy.approvalTimeout < 1 || policy.checkpointLimit < 1) {
      throw const CapabilityException.reason(
        CapabilityFailure.useAPositiveLimit,
      );
    }
    final decoded = await _send(
      'PUT',
      'config',
      body: {'config': policy.toWrite()},
    );
    _requireOk(decoded, CapabilityFailure.thePolicyWasNotSaved);
  }

  Future<SharedMetricsConsent> sharedMetrics() async {
    return _metrics(await _call('shared_metrics.status', {}));
  }

  Future<SharedMetricsConsent> setSharedMetrics({
    required bool enabled,
    required bool send,
  }) async {
    return _metrics(
      await _call('shared_metrics.set', {
        'enabled': enabled,
        'send': enabled && send,
      }),
    );
  }

  SharedMetricsConsent _metrics(Map<String, dynamic> decoded) =>
      SharedMetricsConsent(
        enabled: decoded['enabled'] == true,
        send: decoded['enabled'] == true && decoded['send'] == true,
        decided: decoded['decided'] == true,
        reask: decoded['reask'] == true,
      );
}

List<Map> _rows(Object? decoded, List<String> keys) {
  if (decoded is List) return decoded.whereType<Map>().toList();
  if (decoded is Map) {
    for (final key in keys) {
      final value = decoded[key];
      if (value is List) return value.whereType<Map>().toList();
    }
  }
  return const [];
}
