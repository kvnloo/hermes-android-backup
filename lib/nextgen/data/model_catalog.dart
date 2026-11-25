// What the gateway reports about models, in the shape the Models page shows.
//
// Built from `model/options`, `model/info` and `model/auxiliary`. Endpoint
// addresses and key names in those payloads are never kept, so nothing on
// the page can show one.
import '../../core/services/main_model_route.dart';

/// Prices as the gateway formats them: `$3.00`, `free`, or empty when unknown.
class NgModelPrice {
  const NgModelPrice({
    required this.input,
    required this.output,
    this.cache,
    required this.free,
  });

  final String input;
  final String output;
  final String? cache;
  final bool free;

  bool get known => free || input.isNotEmpty || output.isNotEmpty;

  static NgModelPrice? parse(Object? raw) {
    if (raw is! Map) return null;
    String text(Object? v) {
      final s = v is String ? v.trim() : '';
      return s == '?' ? '' : s;
    }

    final cache = text(raw['cache']);
    final price = NgModelPrice(
      input: text(raw['input']),
      output: text(raw['output']),
      cache: cache.isEmpty ? null : cache,
      free: raw['free'] == true,
    );
    return price.known ? price : null;
  }
}

class NgCatalogModel {
  const NgCatalogModel({
    required this.id,
    this.price,
    this.reasoning,
    this.fast = false,
    this.locked = false,
    this.limited = false,
    this.limitedUntil,
  });

  final String id;
  final NgModelPrice? price;

  /// Whether the model has thinking controls; null when not reported.
  final bool? reasoning;
  final bool fast;

  /// Not included in the signed-in plan.
  final bool locked;

  /// Rate-limited right now, on its own or with its whole provider.
  final bool limited;
  final DateTime? limitedUntil;
}

/// One subscription window: how much is used and when it starts again.
class NgUsageWindow {
  const NgUsageWindow({
    required this.label,
    required this.usedPercent,
    this.resetsAt,
  });

  final String label;
  final double usedPercent;
  final DateTime? resetsAt;

  static List<NgUsageWindow> parseAll(Object? raw) => [
    for (final row in raw is List ? raw : const [])
      if (row is Map && row['used_percent'] is num)
        NgUsageWindow(
          label: row['label'] is String ? row['label'] as String : '',
          usedPercent: (row['used_percent'] as num).clamp(0, 100).toDouble(),
          resetsAt: _time(row['resets_at']),
        ),
  ];
}

/// One signed-in account of a provider that has several.
class NgUsageAccount {
  const NgUsageAccount({
    required this.label,
    required this.state,
    required this.windows,
    this.resetsAt,
  });

  final String label;

  /// `ready`, `limited`, `unknown` or `unavailable`.
  final String state;
  final List<NgUsageWindow> windows;
  final DateTime? resetsAt;
}

class NgCatalogProvider {
  const NgCatalogProvider({
    required this.slug,
    required this.name,
    required this.models,
    required this.totalModels,
    required this.gatewayOnly,
    this.warning,
    this.windows = const [],
    this.accounts = const [],
    this.limited = false,
    this.limitedUntil,
  });

  final String slug;
  final String name;
  final List<NgCatalogModel> models;
  final int totalModels;

  /// Shown but not chosen from the app: an endpoint with no name (`custom`,
  /// `local` and the local-server names the gateway routes there), and the
  /// `custom:` slugs the picker makes up for legacy `custom_providers`
  /// entries, which the gateway's fallback and helper-task resolvers do not
  /// all accept. A `providers:` entry is an ordinary provider here: the
  /// gateway keeps its address and key and applies them when one of its
  /// models is assigned.
  final bool gatewayOnly;
  final String? warning;
  final List<NgUsageWindow> windows;
  final List<NgUsageAccount> accounts;

  /// The whole sign-in is rate-limited.
  final bool limited;
  final DateTime? limitedUntil;

  NgCatalogModel? model(String id) {
    for (final m in models) {
      if (m.id == id) return m;
    }
    return null;
  }
}

class NgModelCatalog {
  const NgModelCatalog(this.providers);

  final List<NgCatalogProvider> providers;

  /// Providers a model can be assigned from.
  Iterable<NgCatalogProvider> get assignable =>
      providers.where((p) => !p.gatewayOnly && p.models.isNotEmpty);

  NgCatalogProvider? provider(String slug) {
    for (final p in providers) {
      if (p.slug == slug) return p;
    }
    return null;
  }

  String providerName(String slug) => provider(slug)?.name ?? slug;

  NgCatalogModel? model(String provider, String id) =>
      this.provider(provider)?.model(id);

  bool canAssign(String provider, String model) {
    final row = this.provider(provider);
    final entry = row?.model(model);
    return row != null && !row.gatewayOnly && entry != null && !entry.locked;
  }

  factory NgModelCatalog.fromOptions(Map<String, dynamic> data) {
    final rows = data['providers'];
    if (rows is! List) throw const FormatException('Missing providers');
    final out = <NgCatalogProvider>[];
    final seen = <String>{};
    for (final row in rows) {
      if (row is! Map) continue;
      final slug = row['slug'] is String
          ? row['slug'] as String
          : row['id'] is String
          ? row['id'] as String
          : '';
      if (slug.isEmpty || slug == 'auto' || !seen.add(slug)) continue;

      final locked = {
        for (final m
            in row['unavailable_models'] is List
                ? row['unavailable_models'] as List
                : const [])
          if (m is String) m,
      };
      final limit = row['limit'];
      final accountLimited = limit is Map && limit['scope'] == 'account';
      final accountLimitedUntil = accountLimited
          ? _time(limit['resets_at'])
          : null;
      final limitedModels = limit is Map && limit['models'] is Map
          ? limit['models'] as Map
          : const {};
      final pricing = row['pricing'] is Map ? row['pricing'] as Map : const {};
      final caps = row['capabilities'] is Map
          ? row['capabilities'] as Map
          : const {};

      final models = <NgCatalogModel>[];
      final ids = <String>{};
      for (final m
          in row['models'] is List ? row['models'] as List : const []) {
        final id = m is String
            ? m
            : m is Map && m['id'] is String
            ? m['id'] as String
            : '';
        if (id.isEmpty || !ids.add(id)) continue;
        final cap = caps[id];
        final ownLimit = limitedModels.containsKey(id);
        models.add(
          NgCatalogModel(
            id: id,
            price: NgModelPrice.parse(pricing[id]),
            reasoning: cap is Map && cap['reasoning'] is bool
                ? cap['reasoning'] as bool
                : null,
            fast: cap is Map && cap['fast'] == true,
            locked: locked.contains(id),
            limited: accountLimited || ownLimit,
            limitedUntil: ownLimit
                ? _time(limitedModels[id])
                : accountLimitedUntil,
          ),
        );
      }

      final usage = row['usage'];
      final accounts = <NgUsageAccount>[];
      if (usage is Map && usage['accounts'] is List) {
        for (final account in usage['accounts'] as List) {
          if (account is! Map) continue;
          accounts.add(
            NgUsageAccount(
              label: account['label'] is String
                  ? (account['label'] as String).trim()
                  : '',
              state: account['state'] is String
                  ? account['state'] as String
                  : 'unknown',
              windows: NgUsageWindow.parseAll(account['windows']),
              resetsAt: _time(account['resets_at']),
            ),
          );
        }
      }

      final name = row['name'] is String ? (row['name'] as String).trim() : '';
      final warning = row['warning'] is String
          ? (row['warning'] as String).trim()
          : '';
      final total = row['total_models'];
      out.add(
        NgCatalogProvider(
          slug: slug,
          name: name.isEmpty ? slug : name,
          models: List.unmodifiable(models),
          totalModels: total is int && total > models.length
              ? total
              : models.length,
          gatewayOnly:
              isUnnamedEndpointProvider(slug) ||
              slug.trim().toLowerCase().startsWith('custom:'),
          warning: warning.isEmpty ? null : warning,
          windows: usage is Map
              ? NgUsageWindow.parseAll(usage['windows'])
              : const [],
          accounts: List.unmodifiable(accounts),
          limited: accountLimited,
          limitedUntil: accountLimitedUntil,
        ),
      );
    }
    return NgModelCatalog(List.unmodifiable(out));
  }
}

DateTime? _time(Object? raw) =>
    raw is String && raw.isNotEmpty ? DateTime.tryParse(raw) : null;

/// The profile's default model, from `model/info`.
class NgMainModel {
  const NgMainModel({
    required this.provider,
    required this.model,
    required this.autoContext,
    required this.configContext,
    required this.effectiveContext,
    this.tools,
    this.vision,
    this.reasoning,
    this.maxOutput,
  });

  final String provider;
  final String model;
  final int autoContext;
  final int configContext;
  final int effectiveContext;

  final bool? tools;
  final bool? vision;
  final bool? reasoning;
  final int? maxOutput;

  bool get assigned => provider.isNotEmpty && model.isNotEmpty;

  factory NgMainModel.fromInfo(Map<String, dynamic> info) {
    String text(String key) => info[key] is String ? info[key] as String : '';
    int count(Object? v) => v is int && v > 0 ? v : 0;
    final caps = info['capabilities'] is Map
        ? info['capabilities'] as Map
        : const {};
    bool? flag(String key) => caps[key] is bool ? caps[key] as bool : null;
    final maxOutput = count(caps['max_output_tokens']);
    return NgMainModel(
      provider: text('provider'),
      model: text('model'),
      autoContext: count(info['auto_context_length']),
      configContext: count(info['config_context_length']),
      effectiveContext: count(info['effective_context_length']),
      tools: flag('supports_tools'),
      vision: flag('supports_vision'),
      reasoning: flag('supports_reasoning'),
      maxOutput: maxOutput == 0 ? null : maxOutput,
    );
  }
}

/// One helper task and the model it is set to.
class NgAuxTask {
  const NgAuxTask({
    required this.task,
    required this.provider,
    required this.model,
    required this.endpoint,
    required this.effortSupported,
    this.effort,
    this.label,
    this.hint,
    this.effectiveProvider,
    this.effectiveModel,
  });

  final String task;
  final String provider;
  final String model;

  /// Carries its own endpoint address, or uses an endpoint with no name:
  /// shown, never changed from the app, because the gateway drops that
  /// endpoint when the task is given another model.
  final bool endpoint;

  /// The gateway reports a thinking level for helper tasks.
  final bool effortSupported;
  final String? effort;

  /// Names a plugin gave its own task.
  final String? label;
  final String? hint;

  /// What a plugin task resolves to while it follows another task.
  final String? effectiveProvider;
  final String? effectiveModel;

  /// No model of its own.
  bool get usesDefault => provider == 'auto' && model.isEmpty;

  static List<NgAuxTask> parseAll(Map<String, dynamic> data) {
    final rows = data['tasks'];
    if (rows is! List) throw const FormatException('Missing tasks');
    final out = <NgAuxTask>[];
    final seen = <String>{};
    for (final row in rows) {
      if (row is! Map) continue;
      final task = row['task'];
      if (task is! String || task.isEmpty || !seen.add(task)) continue;
      String? text(Object? v) =>
          v is String && v.trim().isNotEmpty ? v.trim() : null;
      final provider = row['provider'] is String && row['provider'] != ''
          ? row['provider'] as String
          : 'auto';
      final effective = row['effective'];
      out.add(
        NgAuxTask(
          task: task,
          provider: provider,
          model: row['model'] is String ? row['model'] as String : '',
          endpoint:
              (row['base_url'] ?? '') != '' ||
              isUnnamedEndpointProvider(provider),
          effortSupported: row.containsKey('reasoning_effort'),
          effort: text(row['reasoning_effort']),
          label: text(row['label']),
          hint: text(row['hint']),
          effectiveProvider: effective is Map
              ? text(effective['provider'])
              : null,
          effectiveModel: effective is Map ? text(effective['model']) : null,
        ),
      );
    }
    return List.unmodifiable(out);
  }
}

/// `200000` as `200K`, `1048576` as `1.05M`.
String ngTokenCount(int n) {
  String trim(double v, int digits) {
    final s = v.toStringAsFixed(digits);
    return s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;
  }

  if (n >= 1000000) return '${trim(n / 1000000, 2)}M';
  if (n >= 1000) return '${trim(n / 1000, 1)}K';
  return '$n';
}
