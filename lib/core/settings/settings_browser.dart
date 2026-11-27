import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../nextgen/theme/nextgen_theme.dart';
import '../l10n/l10n.dart';

/// Rendering context, never the active application layout preference.
enum SettingsMode { classic, nextgen }

enum SettingsScope { classic, nextgen, shared }

enum SettingsCategory {
  general,
  appearance,
  chat,
  voice,
  notifications,
  device,
  connections,
  security,
  about;

  static SettingsCategory? fromPath(String? path) =>
      switch (path?.split('/').last) {
        'gateway' || 'connection' || 'connections' || 'models' => connections,
        'shortcuts' || 'desktop' || 'device' || 'advanced' => device,
        'privacy' || 'security' || 'backup' => security,
        'appearance' => appearance,
        'notifications' => notifications,
        'voice' => voice,
        'chat' || 'sessions' => chat,
        'general' || 'language' => general,
        'about' || 'help' => about,
        _ => null,
      };

  String title(AppLocalizations l) => switch (this) {
    general => l.settings_category_general,
    appearance => l.appearance,
    chat => l.settings_category_chat,
    voice => l.voice,
    notifications => l.notifications,
    device => l.settings_category_device,
    connections => l.settings_category_connections,
    security => l.settings_category_security,
    about => l.settings_category_about,
  };

  IconData get icon => switch (this) {
    general => Icons.tune,
    appearance => Icons.palette_outlined,
    chat => Icons.chat_bubble_outline,
    voice => Icons.mic_none,
    notifications => Icons.notifications_outlined,
    device => Icons.devices_outlined,
    connections => Icons.dns_outlined,
    security => Icons.shield_outlined,
    about => Icons.help_outline,
  };
}

/// A live control group with one stable navigation target. Leaf controls keep
/// their existing widget keys and services within the group's builder.
class SettingsTarget {
  const SettingsTarget(this.id, this.title, this.key);
  final String id;
  final String Function(AppLocalizations) title;
  final Key key;
}

class SettingsItem {
  const SettingsItem({
    required this.id,
    required this.category,
    required this.title,
    required this.builder,
    this.scope = SettingsScope.shared,
    this.summary,
    this.terms,
    this.targets = const [],
  });
  final String id;
  final SettingsCategory category;
  final SettingsScope scope;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations)? summary;
  final String Function(AppLocalizations)? terms;
  final WidgetBuilder builder;
  final List<SettingsTarget> targets;

  bool visibleIn(SettingsMode mode) =>
      scope == SettingsScope.shared || scope.name == mode.name;
}

class SettingsBrowser extends StatefulWidget {
  const SettingsBrowser({
    super.key,
    required this.mode,
    required this.items,
    this.initialCategory,
    this.initialTarget,
  });
  final SettingsMode mode;
  final List<SettingsItem> items;
  final SettingsCategory? initialCategory;
  final String? initialTarget;

  @override
  State<SettingsBrowser> createState() => _SettingsBrowserState();
}

class _SettingsBrowserState extends State<SettingsBrowser> {
  late SettingsCategory? _category = widget.initialCategory;
  String _query = '';
  final _search = TextEditingController();
  final _targets = <String, GlobalKey>{};
  final _scroll = ScrollController();
  List<SettingsItem> get _items =>
      widget.items.where((e) => e.visibleIn(widget.mode)).toList();
  String get _title => widget.mode == SettingsMode.classic
      ? context.l10n.settings_classic_title
      : context.l10n.settings_nextgen_title;

  @override
  void initState() {
    super.initState();
    if (widget.initialTarget case final target?) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openTarget(target));
    }
  }

  @override
  void didUpdateWidget(SettingsBrowser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategory != widget.initialCategory ||
        oldWidget.initialTarget != widget.initialTarget) {
      _category = widget.initialCategory;
      if (widget.initialTarget case final target?) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _openTarget(target),
        );
      }
    }
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _openTarget(String id, [Key? controlKey]) {
    final matches = _items.where(
      (e) => e.id == id || e.targets.any((t) => t.id == id),
    );
    if (controlKey == null && matches.isNotEmpty) {
      final nested = matches.first.targets.where((t) => t.id == id);
      if (nested.isNotEmpty) controlKey = nested.first.key;
    }
    if (!mounted || matches.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _category = matches.first.category);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BuildContext? target = _targets[matches.first.id]?.currentContext;
      if (target != null && controlKey != null) {
        void visit(Element element) {
          if (element.widget.key == controlKey) {
            target = element;
            return;
          }
          element.visitChildElements(visit);
        }

        (target! as Element).visitChildElements(visit);
      }
      if (target != null) {
        Scrollable.ensureVisible(
          target!,
          alignment: 0,
          duration: const Duration(milliseconds: 200),
        );
      }
    });
  }

  void _back() {
    setState(() => _category = null);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final english = lookupAppLocalizations(const Locale('en'));
    final items = _items;
    final category = _category;
    final ng = widget.mode == SettingsMode.nextgen;
    final c = ng ? NgColors.of(context) : null;
    final results = <({SettingsItem item, String id, String title, Key? key})>[
      for (final item in items) ...[
        if ('${item.title(l)} ${item.title(english)} ${item.category.title(l)} '
                '${item.category.title(english)} ${item.terms?.call(l) ?? ''} '
                '${item.terms?.call(english) ?? ''}'
            .toLowerCase()
            .contains(_query.toLowerCase().trim()))
          (item: item, id: item.id, title: item.title(l), key: null),
        for (final target in item.targets)
          if ('${target.title(l)} ${target.title(english)}'
              .toLowerCase()
              .contains(_query.toLowerCase().trim()))
            (
              item: item,
              id: target.id,
              title: target.title(l),
              key: target.key,
            ),
      ],
    ];
    Widget row({
      required Key key,
      required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
    }) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      child: ListTile(
        key: key,
        minVerticalPadding: 16,
        minTileHeight: 64,
        leading: Icon(icon, color: c?.accentText),
        title: Text(
          title,
          style: ng ? NgType.heading.copyWith(color: c!.text) : null,
        ),
        subtitle: Text(
          subtitle,
          style: ng ? NgType.bodySmall.copyWith(color: c!.text2) : null,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
    return PopScope(
      canPop: category == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && category != null) _back();
      },
      child: Scaffold(
        backgroundColor: c?.background,
        appBar: AppBar(
          leading: category == null ? null : BackButton(onPressed: _back),
          title: Text(
            category?.title(l) ?? _title,
            style: ng ? NgType.title.copyWith(color: c!.text) : null,
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: ListView(
              controller: _scroll,
              key: ValueKey('settings-list-${category?.name ?? 'home'}'),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (category != null) ...[
                      Text(
                        _title,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      for (final item in items.where(
                        (e) => e.category == category,
                      ))
                        Padding(
                          key: _targets.putIfAbsent(item.id, GlobalKey.new),
                          padding: const EdgeInsets.only(bottom: 16),
                          child: KeyedSubtree(
                            key: ValueKey('settings-control-${item.id}'),
                            child: Builder(builder: item.builder),
                          ),
                        ),
                    ] else ...[
                      TextField(
                        key: const ValueKey('settings-search'),
                        controller: _search,
                        onChanged: (value) => setState(() => _query = value),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          labelText: l.appearance_search_settings,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_query.trim().isNotEmpty) ...[
                        if (results.isEmpty)
                          Text(l.appearance_no_matching_setting),
                        for (final result in results)
                          row(
                            key: ValueKey('settings-result-${result.id}'),
                            icon: result.item.category.icon,
                            title: result.title,
                            subtitle:
                                '$_title › ${result.item.category.title(l)}',
                            onTap: () =>
                                _openTarget(result.item.id, result.key),
                          ),
                      ] else
                        for (final group in SettingsCategory.values)
                          if (items.any((e) => e.category == group))
                            row(
                              key: ValueKey('settings-category-${group.name}'),
                              icon: group.icon,
                              title: group.title(l),
                              subtitle: items
                                  .where((e) => e.category == group)
                                  .take(3)
                                  .map((e) => e.summary?.call(l) ?? e.title(l))
                                  .join(' · '),
                              onTap: () {
                                setState(() => _category = group);
                                _scroll.jumpTo(0);
                              },
                            ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
