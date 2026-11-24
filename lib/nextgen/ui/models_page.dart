// Models: the selected profile's default model, fallback list and helper-task
// models, with what the gateway knows about each (context window, prices,
// abilities) and how much of each provider's allowance is used.
import 'package:flutter/material.dart';

import '../../core/models/fallback_config.dart';
import '../../core/screens/nous_portal_screen.dart';
import '../../core/screens/provider_oauth_screen.dart';
import '../../core/services/connection_manager.dart';
import '../data/model_catalog.dart';
import '../data/model_settings_controller.dart';
import '../nextgen_l10n.dart';
import '../theme/nextgen_theme.dart';
import 'model_choice_sheet.dart';
import 'model_sheet.dart' show ngEfforts;
import 'widgets.dart';

/// The name and one-line description of a helper task. Hermes's own tasks
/// are translated here; a plugin's task uses the names the plugin gave it.
(String, String?) ngAuxCopy(NgAuxTask task) => switch (task.task) {
  'vision' => (ngL.ng_aux_vision, ngL.ng_aux_vision_hint),
  'compression' => (ngL.ng_aux_compression, ngL.ng_aux_compression_hint),
  'approval' => (ngL.ng_aux_approval, ngL.ng_aux_approval_hint),
  'mcp' => (ngL.ng_aux_mcp, ngL.ng_aux_mcp_hint),
  'title_generation' => (
    ngL.ng_aux_title_generation,
    ngL.ng_aux_title_generation_hint,
  ),
  'review' => (ngL.ng_aux_review, ngL.ng_aux_review_hint),
  'voice_chat' => (ngL.ng_aux_voice_chat, ngL.ng_aux_voice_chat_hint),
  'triage_specifier' => (
    ngL.ng_aux_triage_specifier,
    ngL.ng_aux_triage_specifier_hint,
  ),
  'kanban_decomposer' => (
    ngL.ng_aux_kanban_decomposer,
    ngL.ng_aux_kanban_decomposer_hint,
  ),
  'profile_describer' => (
    ngL.ng_aux_profile_describer,
    ngL.ng_aux_profile_describer_hint,
  ),
  'curator' => (ngL.ng_aux_curator, ngL.ng_aux_curator_hint),
  _ => (task.label ?? _readableKey(task.task), task.hint),
};

// `web_extract` as `Web extract`, for tasks this app has no name for.
String _readableKey(String key) {
  final words = key.replaceAll(RegExp(r'[_\-]+'), ' ').trim();
  return words.isEmpty ? key : words[0].toUpperCase() + words.substring(1);
}

String _effortName(String wire) =>
    ngEfforts.where((e) => e.$1 == wire).firstOrNull?.$2 ?? wire;

class NgModelsPage extends StatefulWidget {
  const NgModelsPage({
    super.key,
    required this.connection,
    required this.client,
  });

  final SavedConnection connection;

  /// The gateway's own dashboard client. The page never closes it.
  final DashboardClient client;

  @override
  State<NgModelsPage> createState() => _NgModelsPageState();
}

class _NgModelsPageState extends State<NgModelsPage> {
  late NgModelSettingsController _c;

  @override
  void initState() {
    super.initState();
    _c = NgModelSettingsController(widget.client)..load();
  }

  @override
  void didUpdateWidget(covariant NgModelsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.client, widget.client) ||
        oldWidget.connection != widget.connection) {
      // Answers still on their way for the old gateway die with its controller.
      _c.dispose();
      _c = NgModelSettingsController(widget.client)..load();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// Runs a change and reports how it ended. When the gateway asks first,
  /// shows its warning and sends the change again only if the user agrees.
  Future<void> _commit(
    Future<NgModelSave> Function(bool confirmed) run, {
    required String saved,
  }) async {
    var result = await run(false);
    if (!mounted) return;
    if (result case NgModelNeedsConfirmation(:final message)) {
      final agreed = await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: Text(ngL.ng_confirm_model_switch),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: Text(ngL.ng_cancel),
            ),
            FilledButton(
              key: const ValueKey('ng-models-confirm'),
              onPressed: () => Navigator.pop(dialog, true),
              child: Text(ngL.ng_switch),
            ),
          ],
        ),
      );
      if (agreed != true || !mounted) return;
      result = await run(true);
      if (!mounted) return;
    }
    ngToast(
      context,
      result is NgModelSaved ? saved : ngL.model_management_unavailable,
    );
  }

  Future<void> _changeMain() async {
    final catalog = _c.catalog;
    final main = _c.main;
    if (catalog == null || main == null || !_c.canChangeMain) return;
    final pick = await showNgModelChoice(
      context,
      catalog: catalog,
      title: ngL.ng_models_default,
      selectedProvider: main.provider,
      selectedModel: main.model,
    );
    if (pick is! NgPickModel || !mounted) return;
    if (pick.provider == main.provider && pick.model == main.model) return;
    await _commit(
      (confirmed) =>
          _c.setMain(pick.provider, pick.model, confirmed: confirmed),
      saved: ngL.profile_default_set_to_chats_with_their_own_model_keep(
        pick.model,
      ),
    );
  }

  Future<void> _changeAux(NgAuxTask task) async {
    final catalog = _c.catalog;
    if (catalog == null || task.endpoint || !_c.canEditAux) return;
    final (label, hint) = ngAuxCopy(task);
    final pick = await showNgModelChoice(
      context,
      catalog: catalog,
      title: label,
      subtitle: hint,
      selectedProvider: task.usesDefault ? null : task.provider,
      selectedModel: task.usesDefault ? null : task.model,
      offerDefault: true,
      offerEffort: task.effortSupported,
      effort: task.effort,
    );
    if (pick == null || !mounted) return;
    final id = task.task;
    switch (pick) {
      case NgPickDefault():
        if (task.usesDefault) return;
        await _commit(
          (confirmed) => _c.setAux(id, 'auto', '', confirmed: confirmed),
          saved: ngL.ng_models_saved,
        );
      case NgPickModel(:final provider, :final model):
        if (provider == task.provider && model == task.model) return;
        await _commit(
          (confirmed) => _c.setAux(id, provider, model, confirmed: confirmed),
          saved: ngL.ng_models_saved,
        );
      case NgPickEffort(:final effort):
        if (effort == task.effort) return;
        await _commit(
          (confirmed) => _c.setAuxEffort(id, effort, confirmed: confirmed),
          saved: ngL.ng_models_saved,
        );
    }
  }

  Future<void> _addFallback() async {
    final catalog = _c.catalog;
    if (catalog == null || !_c.canEditFallbacks) return;
    final pick = await showNgModelChoice(
      context,
      catalog: catalog,
      title: ngL.fallback_add,
      taken: {for (final e in _c.fallbackDraft) '${e.provider}/${e.model}'},
    );
    if (pick is NgPickModel) _c.addFallback(pick.provider, pick.model);
  }

  Future<void> _saveFallbacks() async {
    final result = await _c.saveFallbacks();
    if (!mounted) return;
    ngToast(
      context,
      result is NgModelSaved ? ngL.fallback_saved : ngL.fallback_save_failed,
    );
  }

  void _browse(NgCatalogProvider provider) {
    final catalog = _c.catalog;
    if (catalog == null) return;
    showNgModelChoice(
      context,
      catalog: catalog,
      title: provider.name,
      subtitle: ngL.ng_models_count(provider.totalModels),
      selectable: false,
      onlyProvider: provider.slug,
    );
  }

  void _push(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _c,
    builder: (context, _) => NgPage(
      title: ngL.ng_models,
      actions: [
        IconButton(
          key: const ValueKey('ng-models-refresh'),
          tooltip: ngL.refresh,
          icon: const Icon(Icons.refresh),
          onPressed: _c.saving ? null : _c.load,
        ),
      ],
      body: Column(
        children: [
          SizedBox(
            height: 2,
            child: _c.saving || _c.loading
                ? const LinearProgressIndicator(minHeight: 2)
                : null,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                // A readable line length on tablets and desktop windows.
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  children: [
                    ..._defaultSection(context),
                    ..._fallbackSection(context),
                    ..._auxSection(context),
                    ..._providerSection(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // ── Default model ─────────────────────────────────────────────────────

  List<Widget> _defaultSection(BuildContext context) {
    final main = _c.main;
    return [
      NgSectionLabel(ngL.ng_models_default),
      _Intro(
        ngL.changes_the_default_for_use_the_selector_in_a_chat(
          widget.connection.label,
        ),
      ),
      if (_c.mainFailed || (main == null && !_c.mainLoading))
        _Unavailable(
          key: const ValueKey('ng-models-default-unavailable'),
          text: ngL.model_management_unavailable,
          onRetry: _c.saving ? null : _c.load,
        )
      else if (main == null)
        const _Loading()
      else
        NgCard(
          key: const ValueKey('ng-models-default'),
          child: _defaultCard(context, main),
        ),
    ];
  }

  Widget _defaultCard(BuildContext context, NgMainModel main) {
    final c = NgColors.of(context);
    final catalog = _c.catalog;
    final entry = catalog?.model(main.provider, main.model);
    final price = entry?.price;
    final reasoning = main.reasoning ?? entry?.reasoning;
    String each(String value) =>
        value == 'free' ? ngL.ng_models_free : ngL.ng_models_per_million(value);
    final pills = [
      if (main.tools == true) NgPill(ngL.ng_tools),
      if (main.vision == true) NgPill(ngL.ng_models_vision),
      if (reasoning == true) NgPill(ngL.ng_models_reasoning),
      if (entry?.fast == true) NgPill(ngL.ng_models_fast),
      if (entry?.limited == true)
        NgPill(ngL.ng_models_rate_limited, tone: NgTone.warning),
    ];
    final overridden =
        main.configContext > 0 &&
        main.autoContext > 0 &&
        main.autoContext != main.configContext;
    final facts = [
      if (main.effectiveContext > 0)
        _Fact(
          label: ngL.ng_models_context_window,
          value: ngL.ng_models_token_count(ngTokenCount(main.effectiveContext)),
          note: overridden
              ? ngL.ng_models_context_override(ngTokenCount(main.autoContext))
              : null,
        ),
      if (main.maxOutput != null)
        _Fact(
          label: ngL.ng_models_max_output,
          value: ngL.ng_models_token_count(ngTokenCount(main.maxOutput!)),
        ),
      if (price != null && price.free)
        _Fact(label: ngL.ng_models_input_price, value: ngL.ng_models_free)
      else if (price != null) ...[
        if (price.input.isNotEmpty)
          _Fact(label: ngL.ng_models_input_price, value: each(price.input)),
        if (price.output.isNotEmpty)
          _Fact(label: ngL.ng_models_output_price, value: each(price.output)),
        if (price.cache != null)
          _Fact(label: ngL.ng_models_cache_price, value: each(price.cache!)),
      ],
    ];
    // Shown while a change is possible in principle, so the button does not
    // come and go while something else is being saved.
    final changeable = _c.routeVerified && !_c.customRoute && catalog != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    main.model.isEmpty ? '—' : main.model,
                    style: NgType.title.copyWith(color: c.text),
                  ),
                  if (main.provider.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      catalog?.providerName(main.provider) ?? main.provider,
                      style: NgType.bodySmall.copyWith(color: c.text3),
                    ),
                  ],
                ],
              ),
              if (changeable)
                OutlinedButton(
                  key: const ValueKey('ng-models-change-default'),
                  onPressed: _c.canChangeMain ? _changeMain : null,
                  child: Text(ngL.ng_models_change),
                ),
            ],
          ),
        ),
        if (pills.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(spacing: 6, runSpacing: 6, children: pills),
        ],
        if (facts.isNotEmpty) ...[
          const SizedBox(height: 14),
          Divider(color: c.stroke, height: 1),
          const SizedBox(height: 6),
          ...facts,
        ],
        if (!_c.routeVerified)
          _Note(ngL.model_management_unavailable)
        else if (_c.customRoute)
          _Note(ngL.ng_models_custom_endpoint)
        else if (catalog == null && _c.catalogFailed)
          _Note(ngL.fallback_discovery_unavailable),
      ],
    );
  }

  // ── Fallback models ───────────────────────────────────────────────────

  List<Widget> _fallbackSection(BuildContext context) {
    final c = NgColors.of(context);
    final config = _c.fallback;
    final rows = _c.fallbackDraft;
    final edit = _c.canEditFallbacks;
    return [
      NgSectionLabel(ngL.fallback_title),
      _Intro(ngL.fallback_notice),
      if (_c.fallbackFailed || (config == null && !_c.fallbackLoading))
        _Unavailable(
          key: const ValueKey('ng-fallback-unavailable'),
          text: ngL.fallback_unavailable,
          onRetry: _c.saving ? null : _c.load,
        )
      else if (config == null)
        const _Loading()
      else ...[
        NgCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
                  child: Text(
                    ngL.fallback_empty,
                    style: NgType.bodySmall.copyWith(color: c.text3),
                  ),
                ),
              for (var i = 0; i < rows.length; i++) ...[
                _FallbackRow(
                  key: ValueKey('ng-fallback-row-$i'),
                  index: i,
                  entry: rows[i],
                  detail: _routeDetail(rows[i].provider, rows[i].model),
                  locked: _c.fallbackLocked(rows[i]),
                  onUp: edit && i > 0 ? () => _c.moveFallback(i, -1) : null,
                  onDown: edit && i < rows.length - 1
                      ? () => _c.moveFallback(i, 1)
                      : null,
                  onRemove: edit ? () => _c.removeFallback(i) : null,
                ),
                Divider(height: 1, color: c.stroke),
              ],
              NgRow(
                key: const ValueKey('ng-fallback-add'),
                icon: Icons.add,
                title: ngL.fallback_add,
                onTap: edit && _c.catalog != null ? _addFallback : null,
              ),
            ],
          ),
        ),
        if (_c.catalog == null && _c.catalogFailed)
          _Note(ngL.fallback_discovery_unavailable),
        if (_c.fallbackDirty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                NgPill(ngL.ng_models_unsaved, tone: NgTone.warning),
                TextButton(
                  key: const ValueKey('ng-fallback-discard'),
                  onPressed: edit ? _c.revertFallbacks : null,
                  child: Text(ngL.ng_models_discard),
                ),
                FilledButton(
                  key: const ValueKey('ng-fallback-save'),
                  onPressed: edit ? _saveFallbacks : null,
                  child: Text(ngL.fallback_save),
                ),
              ],
            ),
          ),
        if (config.legacyEntries.isNotEmpty) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              ngL.fallback_legacy_title,
              style: NgType.label.copyWith(color: c.text2),
            ),
          ),
          _Intro(ngL.fallback_legacy_notice),
          NgCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final entry in config.legacyEntries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: _RouteText(
                      model: entry.model,
                      detail: _routeDetail(entry.provider, entry.model),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    ];
  }

  /// `Anthropic · $3.00 in · $15.00 out per 1M tokens`.
  String _routeDetail(String provider, String model) {
    final catalog = _c.catalog;
    final price = ngPriceLine(catalog?.model(provider, model)?.price);
    final name = catalog?.providerName(provider) ?? provider;
    return price == null ? name : '$name · $price';
  }

  // ── Helper tasks ──────────────────────────────────────────────────────

  List<Widget> _auxSection(BuildContext context) {
    final tasks = _c.auxTasks;
    return [
      NgSectionLabel(ngL.auxiliary_models),
      _Intro(ngL.ng_models_aux_hint),
      if (_c.auxFailed || (tasks == null && !_c.auxLoading))
        _Unavailable(
          key: const ValueKey('ng-aux-unavailable'),
          text: ngL.auxiliary_unavailable,
          onRetry: _c.saving ? null : _c.load,
        )
      else if (tasks == null)
        const _Loading()
      else
        NgCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _separated(context, [
              for (final task in tasks) _auxRow(context, task),
            ]),
          ),
        ),
    ];
  }

  Widget _auxRow(BuildContext context, NgAuxTask task) {
    final c = NgColors.of(context);
    final catalog = _c.catalog;
    final (label, hint) = ngAuxCopy(task);
    final editable = !task.endpoint && catalog != null;
    // The value is a pill so it reads as a setting, apart from the task's
    // name and description above it.
    final String model;
    final String? detail;
    if (task.endpoint) {
      model = task.model;
      detail = ngL.ng_models_custom_endpoint;
    } else if (task.usesDefault && task.effectiveModel == null) {
      model = '';
      detail = null;
    } else {
      final provider = task.usesDefault
          ? task.effectiveProvider ?? ''
          : task.provider;
      model = task.usesDefault ? task.effectiveModel! : task.model;
      detail = provider.isEmpty ? null : _routeDetail(provider, model);
    }
    final value = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (model.isEmpty && !task.endpoint)
              NgPill(ngL.ng_models_uses_default)
            else if (model.isNotEmpty)
              NgPill(
                model,
                tone: task.endpoint ? NgTone.neutral : NgTone.accent,
              ),
            if (task.effort != null)
              NgPill(
                _effortName(task.effort!),
                icon: Icons.psychology_outlined,
              ),
          ],
        ),
        if (detail != null) ...[
          const SizedBox(height: 6),
          Text(detail, style: NgType.caption.copyWith(color: c.text3)),
        ],
      ],
    );
    return InkWell(
      key: ValueKey('ng-aux-${task.task}'),
      borderRadius: BorderRadius.circular(NgRadii.md),
      onTap: editable && _c.canEditAux ? () => _changeAux(task) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: _rowTitle.copyWith(color: c.text)),
                  if (hint != null && hint.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(hint, style: NgType.caption.copyWith(color: c.text3)),
                  ],
                  const SizedBox(height: 8),
                  value,
                ],
              ),
            ),
            if (editable) ...[
              const SizedBox(width: 12),
              Icon(Icons.chevron_right, size: 18, color: c.text3),
            ],
          ],
        ),
      ),
    );
  }

  // ── Providers ─────────────────────────────────────────────────────────

  List<Widget> _providerSection(BuildContext context) {
    final c = NgColors.of(context);
    final catalog = _c.catalog;
    final conn = widget.connection;
    return [
      NgSectionLabel(ngL.ng_models_providers),
      if (catalog == null && !_c.catalogLoading)
        _Unavailable(
          key: const ValueKey('ng-providers-unavailable'),
          text: ngL.fallback_discovery_unavailable,
          onRetry: _c.saving ? null : _c.load,
        )
      else if (catalog == null)
        const _Loading()
      else if (catalog.providers.isEmpty)
        NgCard(
          child: Text(
            ngL.ng_no_providers_are_set_up_on,
            style: NgType.bodySmall.copyWith(color: c.text3),
          ),
        )
      else
        NgCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _separated(context, [
              for (final provider in catalog.providers)
                _ProviderRow(
                  key: ValueKey('ng-provider-${provider.slug}'),
                  provider: provider,
                  inUse: provider.slug == _c.main?.provider,
                  onTap: provider.models.isEmpty
                      ? null
                      : () => _browse(provider),
                ),
            ]),
          ),
        ),
      const SizedBox(height: 12),
      NgCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            NgRow(
              icon: Icons.key_outlined,
              title: ngL.ng_provider_sign_in,
              subtitle: ngL.ng_connect_provider_accounts_with_oauth,
              onTap: () => _push(ProviderOAuthScreen(connection: conn)),
            ),
            NgRow(
              icon: Icons.account_balance_wallet_outlined,
              title: ngL.ng_nous_portal,
              subtitle: ngL.ng_subscription_credits_and_usage,
              onTap: () => _push(NousPortalScreen(connection: conn)),
            ),
          ],
        ),
      ),
    ];
  }
}

/// The name of a multi-line row: a step above the lines under it.
final _rowTitle = NgType.label.copyWith(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

/// [rows] with a hairline between each pair, for rows of several lines.
List<Widget> _separated(BuildContext context, List<Widget> rows) => [
  for (final (i, row) in rows.indexed) ...[
    if (i > 0) Divider(height: 1, color: NgColors.of(context).stroke),
    row,
  ],
];

/// A sentence under a section label saying what the section is for.
class _Intro extends StatelessWidget {
  const _Intro(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
    child: Text(
      text,
      style: NgType.bodySmall.copyWith(color: NgColors.of(context).text3),
    ),
  );
}

/// A sentence under a card's content explaining its state.
class _Note extends StatelessWidget {
  const _Note(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
    child: Text(
      text,
      style: NgType.bodySmall.copyWith(color: NgColors.of(context).text2),
    ),
  );
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => const NgCard(
    child: Center(
      child: SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({super.key, required this.text, required this.onRetry});
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    return NgCard(
      borderColor: c.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: NgType.bodySmall.copyWith(color: c.text)),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: onRetry, child: Text(ngL.ng_retry)),
        ],
      ),
    );
  }
}

/// One labelled value in the default model's card.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value, this.note});
  final String label;
  final String value;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: NgType.bodySmall.copyWith(color: c.text2),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: NgType.label.copyWith(color: c.text),
                ),
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: 2),
            Text(note!, style: NgType.caption.copyWith(color: c.text3)),
          ],
        ],
      ),
    );
  }
}

/// A model with its provider and price underneath.
class _RouteText extends StatelessWidget {
  const _RouteText({required this.model, this.detail});
  final String model;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(model, style: NgType.label.copyWith(color: c.text)),
        if (detail != null && detail!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(detail!, style: NgType.caption.copyWith(color: c.text3)),
        ],
      ],
    );
  }
}

class _FallbackRow extends StatelessWidget {
  const _FallbackRow({
    super.key,
    required this.index,
    required this.entry,
    required this.detail,
    required this.locked,
    required this.onUp,
    required this.onDown,
    required this.onRemove,
  });

  final int index;
  final FallbackEntry entry;
  final String detail;
  final bool locked;
  final VoidCallback? onUp;
  final VoidCallback? onDown;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    Widget button(String name, IconData icon, String tip, VoidCallback? run) =>
        IconButton(
          key: ValueKey('ng-fallback-$name-$index'),
          tooltip: tip,
          visualDensity: VisualDensity.compact,
          onPressed: run,
          color: c.text2,
          icon: Icon(icon, size: 20),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 26,
                child: Text(
                  '${index + 1}',
                  style: NgType.label.copyWith(color: c.text3),
                ),
              ),
              Expanded(
                child: _RouteText(model: entry.model, detail: detail),
              ),
              button('up', Icons.arrow_upward, ngL.fallback_move_up, onUp),
              button(
                'down',
                Icons.arrow_downward,
                ngL.fallback_move_down,
                onDown,
              ),
              button('remove', Icons.close, ngL.ng_remove, onRemove),
            ],
          ),
          if (locked)
            Padding(
              padding: const EdgeInsets.only(left: 26, top: 2),
              child: Text(
                ngL.fallback_routing_read_only,
                style: NgType.caption.copyWith(color: c.text3),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProviderRow extends StatelessWidget {
  const _ProviderRow({
    super.key,
    required this.provider,
    required this.inUse,
    required this.onTap,
  });

  final NgCatalogProvider provider;
  final bool inUse;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final p = provider;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(NgRadii.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: _rowTitle.copyWith(color: c.text)),
                      const SizedBox(height: 2),
                      Text(
                        ngL.ng_models_count(p.totalModels),
                        style: NgType.caption.copyWith(color: c.text3),
                      ),
                      if (inUse || p.limited) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (inUse)
                              NgPill(ngL.ng_models_in_use, tone: NgTone.accent),
                            if (p.limited)
                              NgPill(
                                ngL.ng_models_rate_limited,
                                tone: NgTone.warning,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 18, color: c.text3),
                ],
              ],
            ),
            if (p.limited && p.limitedUntil != null)
              _small(
                c,
                ngL.provider_quota_reset(ngStamp(context, p.limitedUntil!)),
              ),
            if (p.warning != null) _small(c, p.warning!, color: c.warning),
            for (final window in p.windows) _UsageBar(window),
            for (final (i, account) in p.accounts.indexed) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    account.label.isEmpty
                        ? '${ngL.provider_quota_account} ${i + 1}'
                        : account.label,
                    style: NgType.caption.copyWith(
                      color: c.text2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (account.state == 'limited')
                    NgPill(ngL.ng_models_rate_limited, tone: NgTone.warning),
                ],
              ),
              if (account.state == 'limited' && account.resetsAt != null)
                _small(
                  c,
                  ngL.provider_quota_reset(ngStamp(context, account.resetsAt!)),
                ),
              for (final window in account.windows) _UsageBar(window),
            ],
          ],
        ),
      ),
    );
  }

  Widget _small(NgColors c, String text, {Color? color}) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(text, style: NgType.caption.copyWith(color: color ?? c.text3)),
  );
}

/// One allowance window: its name, how much is used and when it resets.
class _UsageBar extends StatelessWidget {
  const _UsageBar(this.window);
  final NgUsageWindow window;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final used = window.usedPercent.round();
    final reset = window.resetsAt;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8,
              runSpacing: 2,
              children: [
                Text(
                  window.label,
                  style: NgType.caption.copyWith(color: c.text2),
                ),
                Text(
                  ngL.provider_quota_percent('$used', '${100 - used}'),
                  style: NgType.caption.copyWith(color: c.text3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(NgRadii.full),
            child: LinearProgressIndicator(
              value: window.usedPercent / 100,
              minHeight: 4,
              color: used >= 90 ? c.warning : c.accent,
              backgroundColor: c.surface3,
            ),
          ),
          if (reset != null) ...[
            const SizedBox(height: 4),
            Text(
              ngL.provider_quota_reset(ngStamp(context, reset)),
              style: NgType.caption.copyWith(color: c.text3),
            ),
          ],
        ],
      ),
    );
  }
}
