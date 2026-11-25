// The gateway's models as a searchable list, each with its price and what it
// can do. The Models page uses it to choose a default, a fallback or a
// helper-task model, and to look through one provider's models.
import 'package:flutter/material.dart';

import '../data/model_catalog.dart';
import '../nextgen_l10n.dart';
import '../theme/nextgen_theme.dart';
import 'model_sheet.dart' show ngEfforts;
import 'widgets.dart';

/// What was tapped in the sheet.
sealed class NgModelPick {
  const NgModelPick();
}

class NgPickModel extends NgModelPick {
  const NgPickModel(this.provider, this.model);
  final String provider;
  final String model;
}

/// "Uses the default model".
class NgPickDefault extends NgModelPick {
  const NgPickDefault();
}

/// A thinking level; null is the level the default model uses.
class NgPickEffort extends NgModelPick {
  const NgPickEffort(this.effort);
  final String? effort;
}

/// `$3.00 in · $15.00 out per 1M tokens`, or null when no price is known.
String? ngPriceLine(NgModelPrice? price) {
  if (price == null) return null;
  if (price.free) return ngL.ng_models_free;
  String show(String v) => v == 'free' ? ngL.ng_models_free : v;
  if (price.input.isNotEmpty && price.output.isNotEmpty) {
    return ngL.ng_models_price_pair(show(price.input), show(price.output));
  }
  final one = price.input.isNotEmpty ? price.input : price.output;
  if (one.isEmpty) return null;
  return one == 'free' ? ngL.ng_models_free : ngL.ng_models_per_million(one);
}

/// Opens the list. With [selectable] off it only shows [onlyProvider]'s
/// models. [taken] holds `provider/model` keys that cannot be picked again.
Future<NgModelPick?> showNgModelChoice(
  BuildContext context, {
  required NgModelCatalog catalog,
  required String title,
  String? subtitle,
  String? selectedProvider,
  String? selectedModel,
  bool selectable = true,
  String? onlyProvider,
  bool offerDefault = false,
  bool offerEffort = false,
  String? effort,
  Set<String> taken = const {},
}) => showNgSheet<NgModelPick>(
  context,
  builder: (_) => _ModelChoiceSheet(
    catalog: catalog,
    title: title,
    subtitle: subtitle,
    selectedProvider: selectedProvider,
    selectedModel: selectedModel,
    selectable: selectable,
    onlyProvider: onlyProvider,
    offerDefault: offerDefault,
    offerEffort: offerEffort,
    effort: effort,
    taken: taken,
  ),
);

class _ModelChoiceSheet extends StatefulWidget {
  const _ModelChoiceSheet({
    required this.catalog,
    required this.title,
    required this.subtitle,
    required this.selectedProvider,
    required this.selectedModel,
    required this.selectable,
    required this.onlyProvider,
    required this.offerDefault,
    required this.offerEffort,
    required this.effort,
    required this.taken,
  });

  final NgModelCatalog catalog;
  final String title;
  final String? subtitle;
  final String? selectedProvider;
  final String? selectedModel;
  final bool selectable;
  final String? onlyProvider;
  final bool offerDefault;
  final bool offerEffort;
  final String? effort;
  final Set<String> taken;

  @override
  State<_ModelChoiceSheet> createState() => _ModelChoiceSheetState();
}

class _ModelChoiceSheetState extends State<_ModelChoiceSheet> {
  String _query = '';
  String? _providerFilter;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final only = widget.onlyProvider;
    final providers = [
      for (final p in widget.catalog.providers)
        if (only != null
            ? p.slug == only
            : widget.selectable
            ? !p.gatewayOnly && p.models.isNotEmpty
            : p.models.isNotEmpty)
          p,
    ];
    final visible = [
      for (final p in providers)
        if (_providerFilter == null || p.slug == _providerFilter) p,
    ];
    final q = _query.toLowerCase();
    bool matches(NgCatalogProvider p, NgCatalogModel m) =>
        q.isEmpty ||
        m.id.toLowerCase().contains(q) ||
        p.name.toLowerCase().contains(q) ||
        p.slug.toLowerCase().contains(q);

    Widget tile(NgCatalogProvider p, NgCatalogModel m) {
      final current =
          widget.selectedModel == m.id && widget.selectedProvider == p.slug;
      final enabled =
          widget.selectable &&
          !p.gatewayOnly &&
          !m.locked &&
          !widget.taken.contains('${p.slug}/${m.id}');
      final price = ngPriceLine(m.price);
      final pills = [
        if (m.fast) NgPill(ngL.ng_models_fast),
        if (m.locked) NgPill(ngL.ng_models_plan_locked, tone: NgTone.warning),
        if (m.limited) NgPill(ngL.ng_models_rate_limited, tone: NgTone.warning),
      ];
      return ListTile(
        key: ValueKey('ng-choice-${p.slug}/${m.id}'),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: widget.selectable
            ? Icon(
                current ? Icons.check_circle : Icons.circle_outlined,
                size: 20,
                color: current ? c.accent : c.text3,
              )
            : null,
        title: Text(
          m.id,
          style: NgType.label.copyWith(
            color: enabled || !widget.selectable ? c.text : c.text3,
          ),
        ),
        subtitle: price == null && pills.isEmpty
            ? null
            : Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (price != null)
                      Text(
                        price,
                        style: NgType.caption.copyWith(color: c.text3),
                      ),
                    if (pills.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Wrap(spacing: 6, runSpacing: 4, children: pills),
                      ),
                  ],
                ),
              ),
        onTap: enabled
            ? () => Navigator.pop(context, NgPickModel(p.slug, m.id))
            : null,
      );
    }

    final anyMatch = visible.any((p) => p.models.any((m) => matches(p, m)));
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (context, scroll) => ListView(
        controller: scroll,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
            child: Text(
              widget.title,
              style: NgType.title.copyWith(color: c.text),
            ),
          ),
          if (widget.subtitle != null && widget.subtitle!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                widget.subtitle!,
                style: NgType.bodySmall.copyWith(color: c.text3),
              ),
            ),
          if (widget.offerDefault)
            ListTile(
              key: const ValueKey('ng-choice-default'),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(
                widget.selectedModel == null
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                size: 20,
                color: widget.selectedModel == null ? c.accent : c.text3,
              ),
              title: Text(
                ngL.ng_models_uses_default,
                style: NgType.label.copyWith(color: c.text),
              ),
              onTap: () => Navigator.pop(context, const NgPickDefault()),
            ),
          if (widget.offerEffort) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: NgSectionLabel(ngL.ng_models_thinking_level),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  for (final (wire, label) in <(String?, String)>[
                    (null, ngL.ng_default),
                    ...ngEfforts,
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        key: ValueKey('ng-choice-effort-${wire ?? 'default'}'),
                        label: Text(label),
                        selected: widget.effort == wire,
                        showCheckmark: false,
                        shape: const StadiumBorder(),
                        onSelected: (_) =>
                            Navigator.pop(context, NgPickEffort(wire)),
                      ),
                    ),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
            child: TextField(
              key: const ValueKey('ng-choice-search'),
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: c.input,
                prefixIcon: const Icon(Icons.search, size: 20),
                hintText: ngL.ng_search_models,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(NgRadii.full),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (providers.length > 1)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 2),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      key: const ValueKey('ng-choice-provider-all'),
                      label: Text(ngL.ng_all),
                      selected: _providerFilter == null,
                      showCheckmark: false,
                      shape: const StadiumBorder(),
                      onSelected: (_) => setState(() => _providerFilter = null),
                    ),
                  ),
                  for (final p in providers)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        key: ValueKey('ng-choice-provider-${p.slug}'),
                        label: Text(p.name),
                        selected: _providerFilter == p.slug,
                        showCheckmark: false,
                        shape: const StadiumBorder(),
                        onSelected: (_) => setState(() {
                          _providerFilter = _providerFilter == p.slug
                              ? null
                              : p.slug;
                        }),
                      ),
                    ),
                ],
              ),
            ),
          if (providers.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                ngL.ng_no_providers_are_set_up_on,
                style: NgType.bodySmall.copyWith(color: c.text3),
              ),
            )
          else if (!anyMatch)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                ngL.ng_no_models_match,
                style: NgType.bodySmall.copyWith(color: c.text3),
              ),
            ),
          for (final p in visible)
            if (p.models.any((m) => matches(p, m))) ...[
              if (providers.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: NgSectionLabel(p.name),
                ),
              for (final m in p.models)
                if (matches(p, m)) tile(p, m),
            ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
