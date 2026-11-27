import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../services/connection_manager.dart';
import '../services/model_admin.dart';
import '../services/remote_model_admin.dart';

enum ModelAdminSection {
  keys,
  endpoints,
  accounts,
  presets,
  delegation,
  mixture,
  billing,
}

class PreferencesModelPresetStore implements ModelPresetStore {
  PreferencesModelPresetStore(this.prefs);
  final SharedPreferences prefs;
  static const storageKey = 'hermes.model-presets';

  Map<String, dynamic> _all() {
    final raw = prefs.getString(storageKey);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (_) {
      return {};
    }
    return {};
  }

  @override
  ModelPreset? read(String provider, String model) {
    final row = _all()[MemoryModelPresetStore.keyFor(provider, model)];
    if (row is! Map) return null;
    final effort = row['effort']?.toString();
    return ModelPreset(
      effort: reasoningEffortLevels.contains(effort) ? effort : null,
      fast: row['fast'] is bool ? row['fast'] as bool : null,
    );
  }

  @override
  Future<void> save(String provider, String model, ModelPreset preset) async {
    final memory = MemoryModelPresetStore()
      ..values.addAll({
        for (final entry in _all().entries)
          if (entry.value is Map)
            entry.key: ModelPreset(
              effort: reasoningEffortLevels.contains(entry.value['effort'])
                  ? entry.value['effort'] as String
                  : null,
              fast: entry.value['fast'] is bool
                  ? entry.value['fast'] as bool
                  : null,
            ),
      });
    await memory.save(provider, model, preset);
    final stored =
        memory.values[MemoryModelPresetStore.keyFor(provider, model)];
    final next = _all();
    next[MemoryModelPresetStore.keyFor(provider, model)] = {
      if (stored?.effort != null) 'effort': stored!.effort,
      if (stored?.fast != null) 'fast': stored!.fast,
    };
    await prefs.setString(storageKey, jsonEncode(next));
  }
}

class _SlotFields {
  _SlotFields({String provider = '', String model = ''})
    : provider = TextEditingController(text: provider),
      model = TextEditingController(text: model);
  final TextEditingController provider;
  final TextEditingController model;
  void dispose() {
    provider.dispose();
    model.dispose();
  }

  Map<String, dynamic> toSlot({Map<String, dynamic>? base}) => {
    ...?base,
    'provider': provider.text.trim(),
    'model': model.text.trim(),
    'enabled': base?['enabled'] ?? true,
  };
}

/// Provider keys, named endpoints, delegation, mixtures and consented billing.
class ModelAdminScreen extends StatefulWidget {
  final SavedConnection connection;
  final DashboardClient? dashboard;
  final Future<Map<String, dynamic>> Function(
    String method,
    Map<String, dynamic> params,
  )?
  rpc;
  final ModelPresetStore? presets;
  final ModelAdminSection initialSection;

  const ModelAdminScreen({
    required this.connection,
    this.dashboard,
    this.rpc,
    this.presets,
    this.initialSection = ModelAdminSection.keys,
    super.key,
  });

  @override
  State<ModelAdminScreen> createState() => _ModelAdminScreenState();
}

class _ModelAdminScreenState extends State<ModelAdminScreen> {
  Map<String, String> get _modeLabels => {
    '': context.sharedL10n.rel_admin_auto,
    'chat_completions': context.sharedL10n.rel_admin_chat_completions,
    'codex_responses': context.sharedL10n.rel_admin_codex_responses,
    'anthropic_messages': context.sharedL10n.rel_admin_anthropic_messages,
  };

  late final DashboardClient _client =
      widget.dashboard ?? DashboardClient.fromConnection(widget.connection);
  late final RemoteModelAdmin _admin = RemoteModelAdmin(
    _client,
    rpc: widget.rpc,
  );
  late ModelPresetStore _presets = widget.presets ?? MemoryModelPresetStore();
  late ModelAdminSection _section = widget.initialSection;
  final _keyValue = TextEditingController();
  final _endpointName = TextEditingController();
  final _endpointUrl = TextEditingController();
  final _endpointModel = TextEditingController();
  final _endpointKey = TextEditingController();
  final _iterations = TextEditingController();
  final _children = TextEditingController();
  final _timeout = TextEditingController();
  final _routeName = TextEditingController();
  final _routeProvider = TextEditingController();
  final _routeModel = TextEditingController();
  final _presetProvider = TextEditingController();
  final _presetModel = TextEditingController();
  final _sessionId = TextEditingController();
  final _aggregator = _SlotFields();
  bool _busy = false;
  String? _error;
  String? _notice;
  List<ProviderKeyGroup> _keys = const [];
  String? _selectedKey;
  List<NamedEndpoint> _endpoints = const [];
  String _endpointId = '';
  String _apiMode = '';
  String? _testResult;
  List<ProviderAccountRow> _accounts = const [];
  String? _blocked;
  List<Map<String, dynamic>> _backends = const [];
  String? _backend;
  List<Map<String, dynamic>> _routes = const [];
  String? _defaultRoute;
  List<String> _hostProfiles = const [];
  List<Map<String, dynamic>> _profileRoutes = const [];
  String? _defaultProfile;
  String? _limitEffort;
  String _routeEffort = '';
  Map<String, dynamic>? _mixture;
  bool _mixtureEnabled = false;
  String _policy = 'loud';
  List<_SlotFields> _references = [];
  String _presetEffort = 'medium';
  bool _presetFast = false;
  String? _clamp;
  Map<String, dynamic>? _billing;
  Map<String, dynamic>? _subscription;
  String? _amount;
  String? _previewEffect;
  String? _previewTier;
  String? _previewName;
  String? _previewPrice;
  String? _previewWhen;
  String? _chargeKey;
  String? _chargeAmount;
  bool _chargeUnknown = false;

  @override
  void initState() {
    super.initState();
    if (widget.presets == null) {
      SharedPreferences.getInstance().then((prefs) {
        if (!mounted || widget.presets != null) return;
        setState(() => _presets = PreferencesModelPresetStore(prefs));
      }, onError: (_) {});
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _load();
    });
  }

  @override
  void dispose() {
    if (widget.dashboard == null) _client.close();
    for (final controller in [
      _keyValue,
      _endpointName,
      _endpointUrl,
      _endpointModel,
      _endpointKey,
      _iterations,
      _children,
      _timeout,
      _routeName,
      _routeProvider,
      _routeModel,
      _presetProvider,
      _presetModel,
      _sessionId,
    ]) {
      controller.dispose();
    }
    _aggregator.dispose();
    for (final row in _references) {
      row.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    await _run(() async {
      switch (_section) {
        case ModelAdminSection.keys:
          final keys = await _admin.keys();
          if (!mounted) return;
          setState(() {
            _keys = keys;
            _selectedKey = keys.any((key) => key.envKey == _selectedKey)
                ? _selectedKey
                : keys.firstOrNull?.envKey;
          });
        case ModelAdminSection.endpoints:
          final endpoints = await _admin.endpoints();
          if (!mounted) return;
          setState(() => _endpoints = endpoints);
        case ModelAdminSection.accounts:
          final accounts = await _admin.accounts();
          if (!mounted) return;
          setState(() => _accounts = accounts);
        case ModelAdminSection.presets:
          break;
        case ModelAdminSection.delegation:
          final routing = await _admin.delegation();
          final limits = await _admin.limits();
          if (!mounted) return;
          _applyRouting(routing, limits);
        case ModelAdminSection.mixture:
          final mixture = await _admin.mixture();
          if (!mounted) return;
          _applyMixture(mixture);
        case ModelAdminSection.billing:
          if (widget.rpc == null) {
            throw const ModelAdminException(
              ModelAdminFailure.connectBeforeBilling,
            );
          }
          final state = await _admin.billingState();
          final subscription = await _admin.subscriptionState();
          if (!mounted) return;
          setState(() {
            _billing = state;
            _subscription = subscription;
            _previewEffect = null;
            _previewTier = null;
            _previewName = null;
            _previewPrice = null;
            _previewWhen = null;
            final presets = _amounts(state);
            _amount = presets.contains(_amount) ? _amount : presets.firstOrNull;
          });
      }
    });
  }

  void _applyRouting(Map<String, dynamic> routing, DelegationLimits limits) {
    final backends = [
      for (final row
          in routing['backends'] is List
              ? routing['backends'] as List
              : const [])
        if (row is Map) Map<String, dynamic>.from(row),
    ];
    final modelMap = routing['model_map'] is Map
        ? Map<String, dynamic>.from(routing['model_map'] as Map)
        : const <String, dynamic>{};
    final routes = [
      for (final row
          in modelMap['options'] is List
              ? modelMap['options'] as List
              : const [])
        if (row is Map) Map<String, dynamic>.from(row),
    ];
    final profileRoutes = routing['profile_routes'] is Map
        ? Map<String, dynamic>.from(routing['profile_routes'] as Map)
        : const <String, dynamic>{};
    final selectedProfiles = [
      for (final row
          in profileRoutes['profiles'] is List
              ? profileRoutes['profiles'] as List
              : const [])
        if (row is Map) Map<String, dynamic>.from(row),
    ];
    setState(() {
      _backends = backends;
      _blocked = routing['blocked_reason']?.toString();
      _backend = routing['configured']?.toString();
      _routes = routes;
      _defaultRoute = modelMap['default']?.toString();
      _hostProfiles = [
        for (final name
            in routing['profiles'] is List
                ? routing['profiles'] as List
                : const [])
          if (name is String) name,
      ];
      _profileRoutes = selectedProfiles;
      _defaultProfile = profileRoutes['default']?.toString();
      _iterations.text = limits.maxIterations?.toString() ?? '';
      _children.text = limits.maxConcurrentChildren?.toString() ?? '';
      _timeout.text = limits.childTimeoutSeconds?.toString() ?? '';
      _limitEffort = limits.reasoningEffort;
    });
  }

  void _applyMixture(Map<String, dynamic> mixture) {
    final presets = mixture['presets'];
    final active = mixture['active_preset']?.toString();
    final preset = presets is Map && active != null && presets[active] is Map
        ? Map<String, dynamic>.from(presets[active] as Map)
        : mixture;
    final aggregator = preset['aggregator'] is Map
        ? Map<String, dynamic>.from(preset['aggregator'] as Map)
        : const <String, dynamic>{};
    for (final row in _references) {
      row.dispose();
    }
    setState(() {
      _mixture = mixture;
      _mixtureEnabled = preset['enabled'] == true;
      _policy = preset['degraded_reference_policy'] == 'silent'
          ? 'silent'
          : 'loud';
      _aggregator.provider.text = aggregator['provider']?.toString() ?? '';
      _aggregator.model.text = aggregator['model']?.toString() ?? '';
      _references = [
        for (final row
            in preset['reference_models'] is List
                ? preset['reference_models'] as List
                : const [])
          if (row is Map)
            _SlotFields(
              provider: row['provider']?.toString() ?? '',
              model: row['model']?.toString() ?? '',
            ),
      ];
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    final l = context.sharedL10n;
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });
    try {
      await action();
    } on ModelAdminException catch (error) {
      if (mounted) setState(() => _error = error.localized(l));
    } catch (_) {
      if (mounted) {
        setState(() => _error = l.rel_admin_could_not_complete_that_request);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm(String title, String body) async {
    final l = context.sharedL10n;
    final agreed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        key: const Key('admin-confirm'),
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(l.rel_admin_cancel),
          ),
          FilledButton(
            key: const Key('admin-confirm-yes'),
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(l.rel_admin_confirm),
          ),
        ],
      ),
    );
    return agreed == true && mounted;
  }

  EndpointDraft _draft({bool makeDefault = false}) => EndpointDraft(
    id: _endpointId.isEmpty ? null : _endpointId,
    name: _endpointName.text,
    baseUrl: _endpointUrl.text,
    model: _endpointModel.text,
    apiMode: _apiMode,
    apiKey: _endpointKey.text,
    makeDefault: makeDefault,
  );

  List<String> _amounts(Map<String, dynamic>? state) => [
    for (final amount
        in state?['charge_presets'] is List
            ? state!['charge_presets'] as List
            : const [])
      if (amount is String && amount.isNotEmpty) amount,
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.rel_admin_providers_and_billing),
        actions: [
          IconButton(
            tooltip: l.rel_admin_refresh,
            onPressed: _busy ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButton<ModelAdminSection>(
            key: const Key('model-admin-section'),
            isExpanded: true,
            value: _section,
            items: [
              DropdownMenuItem(
                value: ModelAdminSection.keys,
                child: Text(l.rel_admin_api_keys),
              ),
              DropdownMenuItem(
                value: ModelAdminSection.endpoints,
                child: Text(l.rel_admin_custom_endpoints),
              ),
              DropdownMenuItem(
                value: ModelAdminSection.accounts,
                child: Text(l.rel_admin_provider_accounts),
              ),
              DropdownMenuItem(
                value: ModelAdminSection.presets,
                child: Text(l.rel_admin_effort_and_speed_presets),
              ),
              DropdownMenuItem(
                value: ModelAdminSection.delegation,
                child: Text(l.rel_admin_delegation),
              ),
              DropdownMenuItem(
                value: ModelAdminSection.mixture,
                child: Text(l.rel_admin_mixture_of_agents),
              ),
              DropdownMenuItem(
                value: ModelAdminSection.billing,
                child: Text(l.rel_admin_credits_and_plans),
              ),
            ],
            onChanged: _busy
                ? null
                : (section) {
                    if (section == null) return;
                    setState(() => _section = section);
                    _load();
                  },
          ),
          if (_error != null) Text(_error!, key: const Key('admin-error')),
          if (_notice != null) Text(_notice!, key: const Key('admin-notice')),
          const SizedBox(height: 12),
          ...switch (_section) {
            ModelAdminSection.keys => _keySection(),
            ModelAdminSection.endpoints => _endpointSection(),
            ModelAdminSection.accounts => _accountSection(),
            ModelAdminSection.presets => _presetSection(),
            ModelAdminSection.delegation => _delegationSection(),
            ModelAdminSection.mixture => _mixtureSection(),
            ModelAdminSection.billing => _billingSection(),
          },
        ],
      ),
    );
  }

  List<Widget> _keySection() {
    final l = context.sharedL10n;
    return [
      if (_keys.isEmpty)
        Text(l.rel_admin_no_provider_keys_were_reported_for_this_profile),
      if (_keys.isNotEmpty)
        DropdownButton<String>(
          key: const Key('provider-key'),
          isExpanded: true,
          value: _selectedKey,
          items: [
            for (final key in _keys)
              DropdownMenuItem(
                value: key.envKey,
                child: Text(
                  '${key.name} · ${key.envKey} · ${key.saved ? l.rel_admin_saved : l.rel_admin_not_saved}',
                ),
              ),
          ],
          onChanged: (value) => setState(() => _selectedKey = value),
        ),
      TextField(
        key: const Key('provider-key-value'),
        controller: _keyValue,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(labelText: l.rel_admin_new_key_value),
      ),
      FilledButton(
        key: const Key('provider-key-save'),
        onPressed: _busy || _selectedKey == null
            ? null
            : () => _run(() async {
                await _admin.saveKey(_selectedKey!, _keyValue.text);
                _keyValue.clear();
                if (mounted) {
                  setState(() => _notice = l.rel_admin_provider_key_saved);
                }
                final keys = await _admin.keys();
                if (mounted) setState(() => _keys = keys);
              }),
        child: Text(l.rel_admin_save_key),
      ),
      TextButton(
        key: const Key('provider-key-clear'),
        onPressed: _busy || _selectedKey == null
            ? null
            : () => _run(() async {
                final key = _selectedKey!;
                final agreed = await _confirm(
                  l.rel_admin_clear_provider_key,
                  l.rel_admin_remove_key_confirm(key),
                );
                if (!agreed) return;
                await _admin.clearKey(key);
                if (mounted) {
                  setState(() => _notice = l.rel_admin_provider_key_cleared);
                }
                final keys = await _admin.keys();
                if (mounted) setState(() => _keys = keys);
              }),
        child: Text(l.rel_admin_clear_key),
      ),
    ];
  }

  List<Widget> _endpointSection() {
    final l = context.sharedL10n;
    return [
      DropdownButton<String>(
        key: const Key('endpoint-existing'),
        isExpanded: true,
        value: _endpointId,
        items: [
          DropdownMenuItem(value: '', child: Text(l.rel_admin_new_endpoint)),
          for (final endpoint in _endpoints)
            DropdownMenuItem(
              value: endpoint.id,
              child: Text(
                endpoint.current
                    ? l.rel_admin_current_endpoint(endpoint.name)
                    : endpoint.name,
              ),
            ),
        ],
        onChanged: (value) {
          final endpoint = _endpoints
              .where((row) => row.id == value)
              .firstOrNull;
          setState(() {
            _endpointId = value ?? '';
            _testResult = null;
            if (endpoint != null) {
              _endpointName.text = endpoint.name;
              _endpointUrl.text = endpoint.baseUrl;
              _endpointModel.text = endpoint.model;
              _apiMode = endpoint.apiMode;
              _endpointKey.clear();
            }
          });
        },
      ),
      TextField(
        key: const Key('endpoint-name'),
        controller: _endpointName,
        decoration: InputDecoration(labelText: l.rel_admin_name),
      ),
      TextField(
        key: const Key('endpoint-url'),
        controller: _endpointUrl,
        decoration: InputDecoration(labelText: l.rel_admin_base_url),
      ),
      TextField(
        key: const Key('endpoint-model'),
        controller: _endpointModel,
        decoration: InputDecoration(labelText: l.rel_admin_model),
      ),
      DropdownButton<String>(
        key: const Key('endpoint-mode'),
        isExpanded: true,
        value: _apiMode,
        items: [
          for (final mode in customEndpointApiModes)
            DropdownMenuItem(value: mode, child: Text(_modeLabels[mode]!)),
        ],
        onChanged: (value) => setState(() => _apiMode = value ?? ''),
      ),
      TextField(
        controller: _endpointKey,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: l.rel_admin_api_key,
          helperText:
              l.rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has,
        ),
      ),
      FilledButton(
        key: const Key('endpoint-test'),
        onPressed: _busy
            ? null
            : () => _run(() async {
                final result = await _admin.testEndpoint(_draft());
                if (!mounted) return;
                final transport = result.transport.isEmpty
                    ? l.rel_admin_auto_lower
                    : result.transport;
                setState(() {
                  _testResult = l.rel_admin_endpoint_result(
                    result.reachable
                        ? l.rel_admin_reachable
                        : l.rel_admin_unreachable,
                    transport,
                    result.models.length.toString(),
                    result.localizedMessage(l),
                  );
                });
              }),
        child: Text(l.rel_admin_test_endpoint),
      ),
      if (_testResult != null)
        Text(_testResult!, key: const Key('endpoint-test-result')),
      FilledButton(
        key: const Key('endpoint-save'),
        onPressed: _busy
            ? null
            : () => _run(() async {
                await _admin.saveEndpoint(_draft());
                _endpointKey.clear();
                if (mounted) {
                  setState(() => _notice = l.rel_admin_endpoint_saved);
                }
                final endpoints = await _admin.endpoints();
                if (mounted) setState(() => _endpoints = endpoints);
              }),
        child: Text(l.rel_admin_save_endpoint),
      ),
      TextButton(
        key: const Key('endpoint-activate'),
        onPressed: _busy || _endpointId.isEmpty
            ? null
            : () => _run(() async {
                final agreed = await _confirm(
                  l.rel_admin_use_this_endpoint,
                  l.rel_admin_make_this_named_endpoint_the_current_model_for_this_profile,
                );
                if (!agreed) return;
                await _admin.activateEndpoint(_endpointId);
                if (mounted) {
                  setState(() => _notice = l.rel_admin_endpoint_is_now_current);
                }
              }),
        child: Text(l.rel_admin_use_endpoint),
      ),
      TextButton(
        key: const Key('endpoint-delete'),
        onPressed: _busy || _endpointId.isEmpty
            ? null
            : () => _run(() async {
                final agreed = await _confirm(
                  l.rel_admin_delete_endpoint,
                  l.rel_admin_delete_this_named_endpoint_from_the_profile,
                );
                if (!agreed) return;
                await _admin.deleteEndpoint(_endpointId);
                if (mounted) {
                  setState(() {
                    _endpointId = '';
                    _notice = l.rel_admin_endpoint_deleted;
                  });
                }
                final endpoints = await _admin.endpoints();
                if (mounted) setState(() => _endpoints = endpoints);
              }),
        child: Text(l.rel_admin_delete_endpoint),
      ),
    ];
  }

  List<Widget> _accountSection() {
    final l = context.sharedL10n;
    return [
      Text(l.rel_admin_signing_in_stays_on_the_provider_sign_in_screen),
      for (final account in _accounts)
        ListTile(
          title: Text(account.name),
          subtitle: Text(
            account.loggedIn
                ? l.rel_admin_signed_in
                : l.rel_admin_not_signed_in,
          ),
          trailing: account.disconnectable && account.loggedIn
              ? TextButton(
                  key: Key('disconnect-${account.id}'),
                  onPressed: _busy
                      ? null
                      : () => _run(() async {
                          final agreed = await _confirm(
                            l.rel_admin_disconnect_account(account.name),
                            l.rel_admin_disconnect_this_provider_account_on_the_gateway,
                          );
                          if (!agreed) return;
                          await _admin.disconnectAccount(account.id);
                          final accounts = await _admin.accounts();
                          if (mounted) {
                            setState(() {
                              _accounts = accounts;
                              _notice =
                                  l.rel_admin_provider_account_disconnected;
                            });
                          }
                        }),
                  child: Text(l.rel_admin_disconnect),
                )
              : Text(l.rel_admin_not_disconnectable),
        ),
    ];
  }

  String _effortLabel(String effort) => switch (effort) {
    'none' => context.sharedL10n.rel_admin_effort_none,
    'minimal' => context.sharedL10n.rel_admin_effort_minimal,
    'low' => context.sharedL10n.rel_admin_effort_low,
    'medium' => context.sharedL10n.rel_admin_effort_medium,
    'high' => context.sharedL10n.rel_admin_effort_high,
    'xhigh' => context.sharedL10n.rel_admin_effort_xhigh,
    'max' => context.sharedL10n.rel_admin_effort_max,
    'ultra' => context.sharedL10n.rel_admin_effort_ultra,
    _ => effort,
  };

  List<Widget> _presetSection() {
    final l = context.sharedL10n;
    return [
      TextField(
        controller: _presetProvider,
        decoration: InputDecoration(labelText: l.rel_admin_provider),
      ),
      TextField(
        key: const Key('preset-model'),
        controller: _presetModel,
        decoration: InputDecoration(labelText: l.rel_admin_model),
      ),
      DropdownButton<String>(
        key: const Key('preset-effort'),
        isExpanded: true,
        value: _presetEffort,
        items: [
          for (final effort in reasoningEffortLevels)
            DropdownMenuItem(value: effort, child: Text(_effortLabel(effort))),
        ],
        onChanged: (value) => setState(() => _presetEffort = value ?? 'medium'),
      ),
      SwitchListTile(
        key: const Key('preset-fast'),
        title: Text(l.rel_admin_fast),
        value: _presetFast,
        onChanged: (value) => setState(() => _presetFast = value),
      ),
      FilledButton(
        key: const Key('preset-save'),
        onPressed: _busy
            ? null
            : () => _run(() async {
                await _presets.save(
                  _presetProvider.text,
                  _presetModel.text,
                  ModelPreset(effort: _presetEffort, fast: _presetFast),
                );
                if (mounted) {
                  setState(
                    () => _notice = l.rel_admin_preset_saved_for_this_model,
                  );
                }
              }),
        child: Text(l.rel_admin_save_preset),
      ),
      TextField(
        key: const Key('preset-session'),
        controller: _sessionId,
        decoration: InputDecoration(labelText: l.rel_admin_chat_id),
      ),
      FilledButton(
        key: const Key('preset-apply'),
        onPressed: _busy
            ? null
            : () => _run(() async {
                final preset = _presets.read(
                  _presetProvider.text,
                  _presetModel.text,
                );
                if (preset == null || preset.isEmpty) {
                  throw const ModelAdminException(
                    ModelAdminFailure.presetRequired,
                  );
                }
                final agreed = await _confirm(
                  l.rel_admin_apply_preset,
                  l.rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset,
                );
                if (!agreed) return;
                await _admin.applyPreset(
                  sessionId: _sessionId.text,
                  preset: preset,
                );
                if (mounted) {
                  setState(
                    () => _notice = l.rel_admin_preset_applied_to_this_chat,
                  );
                }
              }),
        child: Text(l.rel_admin_apply_to_this_chat),
      ),
      TextButton(
        key: const Key('route-clamp'),
        onPressed: _busy
            ? null
            : () => _run(() async {
                final clamp = await _admin.routeClamp(_sessionId.text);
                if (!mounted) return;
                setState(() {
                  _clamp = clamp == null
                      ? l.rel_admin_this_route_sends_the_picked_effort_unchanged
                      : '${_effortLabel(clamp.picked)}→${_effortLabel(clamp.wire)}';
                });
              }),
        child: Text(l.rel_admin_show_route_clamp),
      ),
      if (_clamp != null) Text(_clamp!, key: const Key('route-clamp-label')),
    ];
  }

  List<Widget> _delegationSection() {
    final l = context.sharedL10n;
    return [
      if (_blocked != null && _blocked!.isNotEmpty)
        Text(
          l.rel_admin_delegation_blocked(_blocked!),
          key: const Key('delegation-blocked'),
        ),
      DropdownButton<String>(
        key: const Key('delegation-backend'),
        isExpanded: true,
        value: _backends.any((row) => row['name'] == _backend)
            ? _backend
            : null,
        hint: Text(l.rel_admin_delegation_backend),
        items: [
          for (final backend in _backends)
            DropdownMenuItem(
              value: backend['name']?.toString(),
              enabled: backend['available'] == true,
              child: Text(
                backend['available'] == true
                    ? '${backend['label'] ?? backend['name']}'
                    : l.rel_admin_backend_unavailable(
                        '${backend['label'] ?? backend['name']}',
                      ),
              ),
            ),
        ],
        onChanged: (value) => setState(() => _backend = value),
      ),
      FilledButton(
        key: const Key('delegation-backend-save'),
        onPressed: _busy || _backend == null
            ? null
            : () => _run(() async {
                await _admin.selectDelegationBackend(_backend!, [
                  for (final backend in _backends)
                    if (backend['available'] == true &&
                        backend['name'] is String)
                      backend['name'] as String,
                ]);
                if (mounted) {
                  setState(
                    () => _notice = l.rel_admin_delegation_backend_saved,
                  );
                }
              }),
        child: Text(l.rel_admin_save_backend),
      ),
      TextField(
        controller: _iterations,
        decoration: InputDecoration(labelText: l.rel_admin_max_iterations),
        keyboardType: TextInputType.number,
      ),
      TextField(
        controller: _children,
        decoration: InputDecoration(
          labelText: l.rel_admin_max_concurrent_children,
        ),
        keyboardType: TextInputType.number,
      ),
      TextField(
        controller: _timeout,
        decoration: InputDecoration(
          labelText: l.rel_admin_child_timeout_seconds,
        ),
        keyboardType: TextInputType.number,
      ),
      DropdownButton<String>(
        key: const Key('delegation-effort'),
        isExpanded: true,
        value: _limitEffort,
        hint: Text(l.rel_admin_delegation_effort_leave_unchanged),
        items: [
          for (final effort in reasoningEffortLevels)
            DropdownMenuItem(value: effort, child: Text(_effortLabel(effort))),
        ],
        onChanged: (value) => setState(() => _limitEffort = value),
      ),
      FilledButton(
        key: const Key('delegation-limits-save'),
        onPressed: _busy
            ? null
            : () => _run(() async {
                await _admin.saveLimits(
                  DelegationLimits(
                    maxIterations: int.tryParse(_iterations.text.trim()),
                    maxConcurrentChildren: int.tryParse(_children.text.trim()),
                    childTimeoutSeconds: int.tryParse(_timeout.text.trim()),
                    reasoningEffort: _limitEffort,
                  ),
                );
                if (mounted) {
                  setState(() => _notice = l.rel_admin_delegation_limits_saved);
                }
              }),
        child: Text(l.rel_admin_save_limits),
      ),
      for (final route in _routes)
        ListTile(
          title: Text(
            '${route['name']} · ${route['provider'] ?? ''} · ${route['model']}',
          ),
          trailing: IconButton(
            tooltip: l.rel_admin_remove_route,
            onPressed: () => setState(() {
              _routes = [
                for (final item in _routes)
                  if (item['name'] != route['name']) item,
              ];
              if (_defaultRoute == route['name']) _defaultRoute = null;
            }),
            icon: const Icon(Icons.delete_outline),
          ),
        ),
      TextField(
        controller: _routeName,
        decoration: InputDecoration(labelText: l.rel_admin_route_name),
      ),
      TextField(
        controller: _routeProvider,
        decoration: InputDecoration(labelText: l.rel_admin_route_provider),
      ),
      TextField(
        controller: _routeModel,
        decoration: InputDecoration(labelText: l.rel_admin_route_model),
      ),
      DropdownButton<String>(
        isExpanded: true,
        value: _routeEffort,
        items: [
          DropdownMenuItem(
            value: '',
            child: Text(l.rel_admin_route_effort_unchanged),
          ),
          for (final effort in reasoningEffortLevels)
            DropdownMenuItem(value: effort, child: Text(_effortLabel(effort))),
        ],
        onChanged: (value) => setState(() => _routeEffort = value ?? ''),
      ),
      TextButton(
        key: const Key('delegation-route-add'),
        onPressed: () => setState(() {
          _routes = [
            ..._routes,
            {
              'name': _routeName.text.trim(),
              'provider': _routeProvider.text.trim(),
              'model': _routeModel.text.trim(),
              'description': '',
              if (_routeEffort.isNotEmpty) 'reasoning_effort': _routeEffort,
            },
          ];
        }),
        child: Text(l.rel_admin_add_route),
      ),
      DropdownButton<String>(
        key: const Key('delegation-default'),
        isExpanded: true,
        value: _routes.any((route) => route['name'] == _defaultRoute)
            ? _defaultRoute
            : null,
        hint: Text(l.rel_admin_default_route),
        items: [
          for (final route in _routes)
            if (route['name'] is String)
              DropdownMenuItem(
                value: route['name'] as String,
                child: Text(route['name'] as String),
              ),
        ],
        onChanged: (value) => setState(() => _defaultRoute = value),
      ),
      FilledButton(
        key: const Key('delegation-routes-save'),
        onPressed: _busy
            ? null
            : () => _run(() async {
                await _admin.saveModelRoutes(
                  routes: _routes,
                  defaultRoute: _defaultRoute,
                );
                if (mounted) {
                  setState(() => _notice = l.rel_admin_delegation_routes_saved);
                }
              }),
        child: Text(l.rel_admin_save_routes),
      ),
      for (final name in _hostProfiles)
        CheckboxListTile(
          key: Key('profile-route-$name'),
          title: Text(name),
          value: _profileRoutes.any((route) => route['name'] == name),
          onChanged: (checked) => setState(() {
            _profileRoutes = [
              for (final route in _profileRoutes)
                if (route['name'] != name) route,
              if (checked == true)
                _profileRoutes
                        .where((route) => route['name'] == name)
                        .firstOrNull ??
                    {'name': name, 'description': ''},
            ];
          }),
        ),
      FilledButton(
        key: const Key('profile-routes-save'),
        onPressed: _busy
            ? null
            : () => _run(() async {
                await _admin.saveProfileRoutes(
                  profiles: _profileRoutes,
                  defaultProfile:
                      _profileRoutes.any(
                        (route) => route['name'] == _defaultProfile,
                      )
                      ? _defaultProfile
                      : null,
                );
                if (mounted) {
                  setState(() => _notice = l.rel_admin_profile_routes_saved);
                }
              }),
        child: Text(l.rel_admin_save_profile_routes),
      ),
    ];
  }

  List<Widget> _mixtureSection() {
    final l = context.sharedL10n;
    return [
      if (_mixture == null) Text(l.rel_admin_no_mixture_is_loaded),
      SwitchListTile(
        key: const Key('moa-enabled'),
        title: Text(l.rel_admin_mixture_enabled),
        value: _mixtureEnabled,
        onChanged: (value) => setState(() => _mixtureEnabled = value),
      ),
      DropdownButton<String>(
        key: const Key('moa-policy'),
        isExpanded: true,
        value: _policy,
        items: [
          DropdownMenuItem(
            value: 'loud',
            child: Text(l.rel_admin_loud_degraded_references),
          ),
          DropdownMenuItem(
            value: 'silent',
            child: Text(l.rel_admin_silent_degraded_references),
          ),
        ],
        onChanged: (value) => setState(() => _policy = value ?? 'loud'),
      ),
      Text(
        l.rel_admin_aggregator,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      TextField(
        controller: _aggregator.provider,
        decoration: InputDecoration(labelText: l.rel_admin_aggregator_provider),
      ),
      TextField(
        key: const Key('moa-aggregator-model'),
        controller: _aggregator.model,
        decoration: InputDecoration(labelText: l.rel_admin_aggregator_model),
      ),
      for (var index = 0; index < _references.length; index++) ...[
        Text(l.rel_admin_reference_number('${index + 1}')),
        TextField(
          controller: _references[index].provider,
          decoration: InputDecoration(
            labelText: l.rel_admin_reference_provider,
          ),
        ),
        TextField(
          controller: _references[index].model,
          decoration: InputDecoration(labelText: l.rel_admin_reference_model),
        ),
      ],
      TextButton(
        onPressed: () =>
            setState(() => _references = [..._references, _SlotFields()]),
        child: Text(l.rel_admin_add_reference_model),
      ),
      FilledButton(
        key: const Key('moa-save'),
        onPressed: _busy || _mixture == null
            ? null
            : () => _run(() async {
                final source = Map<String, dynamic>.from(_mixture!);
                final preset =
                    source['presets'] is Map &&
                        source['active_preset'] is String
                    ? (source['presets'] as Map)[source['active_preset']]
                    : null;
                final baseReferences =
                    preset is Map && preset['reference_models'] is List
                    ? preset['reference_models'] as List
                    : const [];
                final edited = editActiveMixture(
                  source,
                  enabled: _mixtureEnabled,
                  policy: _policy,
                  aggregator: _aggregator.toSlot(
                    base: preset is Map && preset['aggregator'] is Map
                        ? Map<String, dynamic>.from(preset['aggregator'] as Map)
                        : null,
                  ),
                  references: [
                    for (var index = 0; index < _references.length; index++)
                      _references[index].toSlot(
                        base:
                            index < baseReferences.length &&
                                baseReferences[index] is Map
                            ? Map<String, dynamic>.from(
                                baseReferences[index] as Map,
                              )
                            : null,
                      ),
                  ],
                );
                await _admin.saveMixture(edited);
                if (mounted) {
                  setState(() => _notice = l.rel_admin_mixture_saved);
                }
              }),
        child: Text(l.rel_admin_save_mixture),
      ),
    ];
  }

  void _clearPreview() {
    _previewTier = null;
    _previewEffect = null;
    _previewName = null;
    _previewPrice = null;
    _previewWhen = null;
  }

  String? _nonEmpty(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  String _usdLabel(Object? display, Object? raw) {
    const dollar = r'$';
    final shown = display?.toString().trim() ?? '';
    var base = shown;
    if (base.isEmpty) {
      final amount = raw?.toString().trim() ?? '';
      if (amount.isEmpty) return '';
      base = amount.startsWith(dollar) ? amount : '$dollar$amount';
    }
    if (base.toUpperCase().contains('USD')) return base;
    return '$base USD';
  }

  String _autoReloadConfirm(bool enabled, Map<dynamic, dynamic> reload) {
    final l = context.sharedL10n;
    final threshold = _usdLabel(
      reload['threshold_display'],
      reload['threshold_usd'],
    );
    final amount = _usdLabel(
      reload['reload_to_display'],
      reload['reload_to_usd'],
    );
    if (enabled) {
      return l.rel_admin_reload_enable_confirm(amount, threshold);
    }
    return l.rel_admin_reload_disable_confirm(amount, threshold);
  }

  String _planConfirmBody() {
    final l = context.sharedL10n;
    final name = (_previewName ?? _previewTier ?? l.rel_admin_this_plan).trim();
    final price = (_previewPrice ?? '').trim();
    final when = (_previewWhen ?? '').trim();
    if (price.isEmpty) {
      return when.isEmpty
          ? l.rel_admin_plan_confirm(name)
          : l.rel_admin_plan_confirm_when(name, when);
    }
    return when.isEmpty
        ? l.rel_admin_plan_confirm_price(name, price)
        : l.rel_admin_plan_confirm_price_when(name, price, when);
  }

  Future<void> _buyCredits(String amount, {required bool retry}) async {
    final l = context.sharedL10n;
    if (_chargeUnknown && !retry) return;
    final stored = _chargeKey?.trim() ?? '';
    final key = retry && stored.isNotEmpty ? stored : newIdempotencyKey();
    if (mounted) {
      setState(() {
        _chargeKey = key;
        _chargeAmount = amount;
      });
    }
    try {
      final result = await _admin.buyCredits(amount, idempotencyKey: key);
      if (!mounted) return;
      final chargeId = result['charge_id']?.toString().trim() ?? '';
      if (chargeId.isNotEmpty) {
        final watched = await _admin.watchCharge(chargeId);
        if (!mounted) return;
        setState(() => _applyWatchedCharge(watched, key, amount));
        return;
      }
      setState(() {
        _chargeUnknown = false;
        _chargeKey = null;
        _notice = result['ok'] == true
            ? l.rel_admin_credit_purchase_submitted
            : safeBillingMessage(result['message'] ?? result['error'], l: l);
      });
    } catch (error) {
      if (!chargeSendIsAmbiguous(error)) {
        if (mounted) {
          setState(() {
            _chargeUnknown = false;
            _chargeKey = null;
          });
        }
        rethrow;
      }
      if (!mounted) return;
      setState(() {
        _chargeUnknown = true;
        _chargeKey = key;
        _chargeAmount = amount;
      });
    }
  }

  void _applyWatchedCharge(
    Map<String, dynamic> watched,
    String key,
    String amount,
  ) {
    final l = context.sharedL10n;
    final outcome = watched['outcome']?.toString();
    if (outcome == 'settled') {
      _chargeUnknown = false;
      _chargeKey = null;
      _notice = l.rel_admin_credit_purchase_settled;
      return;
    }
    if (outcome == 'unknown') {
      _chargeUnknown = true;
      _chargeKey = key;
      _chargeAmount = amount;
      return;
    }
    _chargeUnknown = false;
    _chargeKey = null;
    _notice = safeBillingMessage(
      watched['message'] ?? watched['reason'] ?? watched['error'],
      l: l,
    );
  }

  List<Widget> _billingSection() {
    final l = context.sharedL10n;
    final billing = _billing;
    final subscription = _subscription;
    final tiers = [
      for (final tier
          in subscription?['tiers'] is List
              ? subscription!['tiers'] as List
              : const [])
        if (tier is Map) Map<String, dynamic>.from(tier),
    ];
    final reload = billing?['auto_reload'];
    final keepGoing = billing?['keep_going_on_credits'];
    return [
      Text(l.rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan),
      if (billing != null)
        Text(l.rel_admin_balance('${billing['balance_display'] ?? '—'}')),
      if (billing != null && creditsPurchasable(billing)) ...[
        DropdownButton<String>(
          key: const Key('billing-amount'),
          isExpanded: true,
          value: _amount,
          items: [
            for (final amount in _amounts(billing))
              DropdownMenuItem(value: amount, child: Text('\$$amount')),
          ],
          onChanged: (value) => setState(() => _amount = value),
        ),
        FilledButton(
          key: const Key('billing-buy'),
          onPressed: _busy || _amount == null || _chargeUnknown
              ? null
              : () => _run(() async {
                  final amount = _amount!;
                  final agreed = await _confirm(
                    l.rel_admin_buy_credits,
                    l.rel_admin_buy_confirm(amount),
                  );
                  if (!agreed) return;
                  await _buyCredits(amount, retry: false);
                }),
          child: Text(l.rel_admin_buy_credits),
        ),
        if (_chargeUnknown) ...[
          Text(
            l.rel_admin_charge_unknown,
            key: const Key('billing-charge-unknown'),
          ),
          TextButton(
            key: const Key('billing-charge-retry'),
            onPressed: _busy || _chargeKey == null || _chargeAmount == null
                ? null
                : () => _run(() async {
                    final agreed = await _confirm(
                      l.rel_admin_retry_same_charge,
                      l.rel_admin_retry_the_same_credit_charge_this_does_not_start,
                    );
                    if (!agreed) return;
                    await _buyCredits(_chargeAmount!, retry: true);
                  }),
            child: Text(l.rel_admin_retry_same_charge),
          ),
        ],
      ] else if (billing != null)
        Text(
          l.rel_admin_credit_purchases_are_not_available_for_this_account,
          key: Key('billing-unavailable'),
        ),
      if (reload is Map &&
          reload['threshold_usd'] is String &&
          reload['reload_to_usd'] is String) ...[
        SwitchListTile(
          key: const Key('billing-auto-reload'),
          title: Text(l.rel_admin_auto_reload),
          subtitle: billing != null && autoReloadEditable(billing)
              ? null
              : Text(l.rel_admin_read_only_until_this_account_can_charge),
          value: reload['enabled'] == true,
          onChanged: _busy || billing == null || !autoReloadEditable(billing)
              ? null
              : (enabled) => _run(() async {
                  final agreed = await _confirm(
                    l.rel_admin_auto_reload,
                    _autoReloadConfirm(enabled, reload),
                  );
                  if (!agreed) return;
                  final result = await _admin.setAutoReload(
                    enabled: enabled,
                    thresholdUsd: reload['threshold_usd'] as String,
                    reloadToUsd: reload['reload_to_usd'] as String,
                  );
                  if (!mounted) return;
                  setState(() {
                    _notice = result['ok'] == true
                        ? l.rel_admin_auto_reload_updated
                        : safeBillingMessage(
                            result['message'] ?? result['error'],
                            l: l,
                          );
                  });
                }),
        ),
        if (billing == null || !autoReloadEditable(billing))
          Text(
            l.rel_admin_reload_portal(billingPortalUrl(billing)),
            key: const Key('billing-portal'),
          ),
      ],
      if (keepGoing is bool)
        SwitchListTile(
          key: const Key('billing-keep-going'),
          title: Text(l.rel_admin_keep_going_on_credits),
          value: keepGoing,
          onChanged: _busy
              ? null
              : (enabled) => _run(() async {
                  final agreed = await _confirm(
                    l.rel_admin_keep_going_on_credits,
                    enabled
                        ? l.rel_admin_continue_on_credits_when_the_plan_window_is_used_up
                        : l.rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up,
                  );
                  if (!agreed) return;
                  final result = await _admin.setKeepGoing(enabled);
                  if (!mounted) return;
                  setState(() {
                    _notice = result['ok'] == true
                        ? l.rel_admin_credit_continuation_updated
                        : safeBillingMessage(
                            result['message'] ?? result['error'],
                            l: l,
                          );
                  });
                }),
        ),
      if (plansChangeInApp(subscription))
        for (final tier in tiers)
          if (tier['is_enabled'] == true &&
              tier['is_current'] != true &&
              tier['tier_id'] is String)
            ListTile(
              title: Text(
                tier['name']?.toString() ?? tier['tier_id'] as String,
              ),
              trailing: TextButton(
                key: Key('plan-${tier['tier_id']}'),
                onPressed: _busy
                    ? null
                    : () => _run(() async {
                        final id = tier['tier_id'] as String;
                        if (mounted) setState(_clearPreview);
                        final preview = await _admin.previewPlan(id);
                        if (!mounted) return;
                        final effect = preview['effect']?.toString();
                        final committable =
                            preview['ok'] == true &&
                            planChangeCanCommit(effect);
                        setState(() {
                          if (!committable) {
                            _clearPreview();
                            _notice = preview['ok'] == true
                                ? l.rel_admin_this_plan_change_is_not_confirmed_from_ares
                                : safeBillingMessage(
                                    preview['message'] ?? preview['error'],
                                    l: l,
                                  );
                            return;
                          }
                          _previewTier = id;
                          _previewEffect = effect;
                          _previewName =
                              _nonEmpty(preview['target_tier_name']) ??
                              _nonEmpty(tier['name']) ??
                              id;
                          _previewPrice = _nonEmpty(
                            tier['dollars_per_month_display'],
                          );
                          _previewWhen =
                              _nonEmpty(preview['effective_display']) ??
                              _nonEmpty(preview['effective_at']);
                          _notice = l
                              .rel_admin_this_change_is_scheduled_confirm_to_apply_it;
                        });
                      }),
                child: Text(l.rel_admin_preview_plan),
              ),
            ),
      if (subscription?['context'] == 'team')
        Text(
          l.rel_admin_team_portal(billingPortalUrl(billing)),
          key: const Key('plan-portal'),
        ),
      if (planChangeCanCommit(_previewEffect) && _previewTier != null)
        FilledButton(
          key: const Key('plan-confirm'),
          onPressed: _busy
              ? null
              : () => _run(() async {
                  final agreed = await _confirm(
                    l.rel_admin_schedule_plan_change,
                    _planConfirmBody(),
                  );
                  if (!agreed) return;
                  final result = await _admin.schedulePlan(
                    _previewTier!,
                    _previewEffect,
                  );
                  if (!mounted) return;
                  setState(() {
                    _clearPreview();
                    _notice = result['ok'] == true
                        ? l.rel_admin_plan_change_scheduled
                        : safeBillingMessage(
                            result['message'] ?? result['error'],
                            l: l,
                          );
                  });
                }),
          child: Text(l.rel_admin_confirm_scheduled_plan_change),
        ),
    ];
  }
}
