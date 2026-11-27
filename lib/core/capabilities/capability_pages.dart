import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'capability_admin.dart';

/// Pushes [page] and runs [release] when the route is gone.
///
/// A Classic capability page opened without a shared gateway owns a REST
/// dashboard client. That client is [release]d here, including when the push
/// fails, and a shared gateway client is left open by passing null.
Future<void> pushAndRelease(
  BuildContext context,
  Widget page,
  void Function()? release,
) {
  return Navigator.of(
    context,
  ).push<void>(MaterialPageRoute<void>(builder: (_) => page)).whenComplete(() {
    release?.call();
  });
}

class CapabilityAdminScreen extends StatefulWidget {
  const CapabilityAdminScreen({required this.admin, super.key});

  final CapabilityAdmin admin;

  @override
  State<CapabilityAdminScreen> createState() => _CapabilityAdminScreenState();
}

class _CapabilityAdminScreenState extends State<CapabilityAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.sharedL10n.rel_ops_cap_capabilities),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: context.sharedL10n.skills),
              Tab(text: context.sharedL10n.rel_ops_cap_plugins),
              Tab(text: context.sharedL10n.rel_ops_cap_connectors),
              Tab(text: context.sharedL10n.rel_ops_cap_backends),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _SkillsTab(admin: widget.admin),
            _PluginsTab(admin: widget.admin),
            _ConnectorsTab(admin: widget.admin),
            _BackendsTab(admin: widget.admin),
          ],
        ),
      ),
    );
  }
}

class BrowserVaultScreen extends StatefulWidget {
  const BrowserVaultScreen({required this.admin, super.key});

  final CapabilityAdmin admin;

  @override
  State<BrowserVaultScreen> createState() => _BrowserVaultScreenState();
}

class AgentPolicyScreen extends StatefulWidget {
  const AgentPolicyScreen({required this.admin, super.key});

  final CapabilityAdmin admin;

  @override
  State<AgentPolicyScreen> createState() => _AgentPolicyScreenState();
}

class _SkillsTab extends StatefulWidget {
  const _SkillsTab({required this.admin});

  final CapabilityAdmin admin;

  @override
  State<_SkillsTab> createState() => _SkillsTabState();
}

class _SkillsTabState extends State<_SkillsTab> {
  final _identifier = TextEditingController();
  List<SkillRecord> _skills = const [];
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _identifier.addListener(_onIdentifier);
    _load();
  }

  void _onIdentifier() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _identifier.removeListener(_onIdentifier);
    _identifier.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final skills = await widget.admin.skills();
      if (!mounted) return;
      setState(() {
        _skills = skills;
        _error = null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _capabilityError(context, error);
        _loading = false;
      });
    }
  }

  Future<void> _run(Future<void> action) async {
    try {
      await action;
      if (mounted) await _load();
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _capabilityError(context, error));
    }
  }

  String? _cautionFor;

  Future<void> _install({required bool force, String? identifier}) async {
    final requested = (identifier ?? _identifier.text).trim();
    try {
      final result = await widget.admin.installHubSkill(
        requested,
        force: force,
      );
      if (!mounted) return;
      if (!result.installed) {
        final verdict = _capabilityValue(context, result.scan.verdict);
        final detail = result.scan.findings.join('; ');
        setState(() {
          _cautionFor = result.scan.caution ? requested : null;
          _error = result.scan.blocked
              ? context.sharedL10n.rel_ops_cap_install_blocked(verdict, detail)
              : result.scan.caution
              ? context.sharedL10n.rel_ops_cap_scan_confirm(verdict, requested)
              : context.sharedL10n.rel_ops_cap_install_unconfirmed(requested);
        });
        return;
      }
      _identifier.clear();
      setState(() {
        _cautionFor = null;
        _error = null;
      });
      await _load();
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _capabilityError(context, error));
    }
  }

  Future<void> _edit(SkillRecord skill) async {
    final content = await widget.admin.learningContent(skill.name);
    if (!mounted) return;
    final controller = TextEditingController(text: content);
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.sharedL10n.rel_ops_cap_edit_skill(skill.name)),
        content: TextField(
          controller: controller,
          key: const Key('skill-editor'),
          maxLines: 8,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.sharedL10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.sharedL10n.rel_ops_cap_save_skill),
          ),
        ],
      ),
    );
    final next = controller.text;
    controller.dispose();
    if (saved == true) {
      await _run(widget.admin.saveLearningContent(skill.name, next));
    }
  }

  Future<void> _archive(SkillRecord skill) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.sharedL10n.rel_ops_cap_archive_skill(skill.name)),
        content: Text(
          context.sharedL10n.rel_ops_cap_archive_explanation(
            'hermes curator restore',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.sharedL10n.cancel),
          ),
          TextButton(
            key: const Key('confirm-archive'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.sharedL10n.rel_ops_cap_archive),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(widget.admin.archiveSkill(skill.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_error != null) Text(_error!, key: const Key('capability-error')),
        TextField(
          key: const Key('hub-identifier'),
          controller: _identifier,
          decoration: InputDecoration(
            labelText: context.sharedL10n.rel_ops_cap_hub_identifier,
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            TextButton(
              key: const Key('hub-install'),
              onPressed: () => _install(force: false),
              child: Text(context.sharedL10n.rel_ops_cap_install),
            ),
            if (_cautionFor != null && _identifier.text.trim() == _cautionFor)
              TextButton(
                key: const Key('hub-force'),
                onPressed: () => _install(force: true, identifier: _cautionFor),
                child: Text(
                  context.sharedL10n.rel_ops_cap_install_anyway(_cautionFor!),
                ),
              ),
            TextButton(
              key: const Key('skill-update-all'),
              onPressed: () => _run(widget.admin.updateHubSkills()),
              child: Text(context.sharedL10n.rel_ops_cap_update_all),
            ),
          ],
        ),
        if (_loading) const LinearProgressIndicator(),
        for (final skill in _skills)
          ListTile(
            title: Text(skill.name),
            subtitle: Text(skill.description),
            trailing: Wrap(
              spacing: 4,
              children: [
                Switch(
                  key: Key('skill-enable-${skill.name}'),
                  value: skill.enabled,
                  onChanged: (enabled) =>
                      _run(widget.admin.setSkillEnabled(skill.name, enabled)),
                ),
                IconButton(
                  key: Key('skill-lock-${skill.name}'),
                  tooltip: skill.locked
                      ? context.sharedL10n.rel_ops_cap_unlock
                      : context.sharedL10n.rel_ops_cap_lock,
                  onPressed: () => _run(
                    widget.admin.setSkillLocked(skill.name, !skill.locked),
                  ),
                  icon: Icon(skill.locked ? Icons.lock : Icons.lock_open),
                ),
                if (skill.editable) ...[
                  IconButton(
                    key: Key('skill-edit-${skill.name}'),
                    tooltip: context.sharedL10n.edit,
                    onPressed: () => _edit(skill),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    key: Key('skill-archive-${skill.name}'),
                    tooltip: context.sharedL10n.rel_ops_cap_archive,
                    onPressed: () => _archive(skill),
                    icon: const Icon(Icons.archive_outlined),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _PluginsTab extends StatefulWidget {
  const _PluginsTab({required this.admin});

  final CapabilityAdmin admin;

  @override
  State<_PluginsTab> createState() => _PluginsTabState();
}

class _PluginsTabState extends State<_PluginsTab> {
  final _identifier = TextEditingController();
  List<PluginRecord> _plugins = const [];
  String? _notice;
  List<String> _lines = const [];
  String? _pendingName;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _identifier.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final plugins = await widget.admin.plugins();
      if (!mounted) return;
      setState(() => _plugins = plugins);
    } catch (error) {
      if (!mounted) return;
      setState(() => _notice = _capabilityError(context, error));
    }
  }

  bool _consent = false;
  bool _scanBlocked = false;

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      if (!mounted) return;
      setState(() => _notice = _capabilityError(context, error));
    }
  }

  Future<void> _show(PluginMutation result, String name) async {
    if (!mounted) return;
    setState(() {
      _consent = result.consentRequired;
      _scanBlocked = result.scanBlocked;
      _pendingName = result.consentRequired || result.scanBlocked ? name : null;
      _lines = result.lines;
      _notice = result.ok
          ? null
          : result.consentRequired
          ? context
                .sharedL10n
                .rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet
          : result.scanBlocked
          ? context.sharedL10n.rel_ops_cap_the_scan_blocked_this_plugin
          : (result.message ??
                context.sharedL10n.rel_ops_cap_the_plugin_was_not_changed);
    });
    if (result.ok) await _load();
  }

  Future<void> _confirmScan(String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.sharedL10n.rel_ops_cap_install_despite_scan(name)),
        content: Text(context.sharedL10n.rel_ops_cap_scan_warning(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.sharedL10n.cancel),
          ),
          TextButton(
            key: const Key('plugin-scan-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.sharedL10n.rel_ops_cap_install_anyway(name)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _guard(() async {
      await _show(await widget.admin.updatePlugin(name, force: true), name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_notice != null) Text(_notice!, key: const Key('plugin-notice')),
        for (final line in _lines) Text(line),
        TextField(
          key: const Key('plugin-identifier'),
          controller: _identifier,
          decoration: InputDecoration(
            labelText: context.sharedL10n.rel_ops_cap_repository,
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            TextButton(
              key: const Key('plugin-install'),
              onPressed: () => _guard(() async {
                final result = await widget.admin.installPlugin(
                  _identifier.text,
                );
                await _show(result, _identifier.text.trim());
              }),
              child: Text(context.sharedL10n.rel_ops_cap_install_plugin),
            ),
            TextButton(
              onPressed: () => _guard(() async {
                await _show(await widget.admin.updateAllPlugins(), '');
              }),
              child: Text(context.sharedL10n.rel_ops_cap_update_plugins),
            ),
            if (_pendingName != null)
              TextButton(
                key: const Key('plugin-accept'),
                onPressed: () {
                  final name = _pendingName!;
                  if (!_consent) {
                    setState(() {
                      _notice = context.sharedL10n
                          .rel_ops_cap_accept_scan_warning(name);
                    });
                    return;
                  }
                  _guard(() async {
                    final result = await widget.admin.updatePlugin(
                      name,
                      acceptCapabilities: true,
                    );
                    await _show(result, name);
                  });
                },
                child: Text(context.sharedL10n.rel_ops_cap_accept_capabilities),
              ),
            if (_scanBlocked && _pendingName != null)
              TextButton(
                key: const Key('plugin-scan-review'),
                onPressed: () => _confirmScan(_pendingName!),
                child: Text(
                  context.sharedL10n.rel_ops_cap_review_scan(_pendingName!),
                ),
              ),
          ],
        ),
        for (final plugin in _plugins) ...[
          ListTile(
            title: Text(plugin.name),
            subtitle: Text(
              plugin.hasDesktopHalf
                  ? context.sharedL10n.rel_ops_cap_desktop_grants(
                      plugin.description,
                    )
                  : plugin.description,
            ),
            trailing: Wrap(
              children: [
                if (plugin.key.isNotEmpty)
                  Switch(
                    key: Key('plugin-enable-${plugin.name}'),
                    value: plugin.enabled,
                    onChanged: (enabled) => _guard(() async {
                      await widget.admin.togglePlugin(plugin.key, enabled);
                      await _load();
                    }),
                  ),
                IconButton(
                  key: Key('plugin-update-${plugin.name}'),
                  tooltip: context.sharedL10n.rel_ops_cap_update,
                  onPressed: () => _guard(() async {
                    await _show(
                      await widget.admin.updatePlugin(plugin.name),
                      plugin.name,
                    );
                  }),
                  icon: const Icon(Icons.system_update_alt),
                ),
                IconButton(
                  key: Key('plugin-remove-${plugin.name}'),
                  tooltip: context.sharedL10n.ng_remove,
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          context.sharedL10n.rel_ops_cap_remove_plugin(
                            plugin.name,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(context.sharedL10n.cancel),
                          ),
                          TextButton(
                            key: const Key('confirm-remove-plugin'),
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(context.sharedL10n.ng_remove),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await _guard(() async {
                        await widget.admin.removePlugin(plugin.name);
                        await _load();
                      });
                    }
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
          if (plugin.hasDesktopHalf)
            TextButton(
              key: Key('plugin-desktop-${plugin.name}'),
              onPressed: () => _guard(() async {
                await widget.admin.removePluginDesktopHalf(plugin.name);
                await _load();
              }),
              child: Text(context.sharedL10n.rel_ops_cap_remove_desktop_half),
            ),
        ],
      ],
    );
  }
}

class _ConnectorsTab extends StatefulWidget {
  const _ConnectorsTab({required this.admin});

  final CapabilityAdmin admin;

  @override
  State<_ConnectorsTab> createState() => _ConnectorsTabState();
}

class _ConnectorsTabState extends State<_ConnectorsTab> {
  final _name = TextEditingController();
  final _command = TextEditingController();
  final _url = TextEditingController();
  final _connector = TextEditingController();
  final _alias = TextEditingController();
  final _toolConnector = TextEditingController();
  List<McpServerRecord> _servers = const [];
  List<ConnectorAccount> _accounts = const [];
  ConnectorToolGrant? _grant;
  String? _grantConnector;
  final Set<String> _disabled = {};
  String? _logs;
  String? _error;

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _capabilityError(context, error));
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _command.dispose();
    _url.dispose();
    _connector.dispose();
    _alias.dispose();
    _toolConnector.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final servers = await widget.admin.mcpServers();
      if (!mounted) return;
      setState(() => _servers = servers);
    } catch (error) {
      if (mounted) setState(() => _error = _capabilityError(context, error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_error != null) Text(_error!, key: const Key('connector-error')),
        TextField(
          key: const Key('mcp-name'),
          controller: _name,
          decoration: InputDecoration(
            labelText: context.sharedL10n.rel_ops_cap_server_name,
          ),
        ),
        TextField(
          key: const Key('mcp-command'),
          controller: _command,
          decoration: InputDecoration(
            labelText: context.sharedL10n.rel_ops_cap_command,
          ),
        ),
        TextField(
          key: const Key('mcp-url'),
          controller: _url,
          decoration: InputDecoration(
            labelText: context.sharedL10n.rel_ops_cap_http_url,
          ),
        ),
        TextButton(
          key: const Key('mcp-add'),
          onPressed: () async {
            final spec = _url.text.trim().isEmpty
                ? McpServerSpec.stdio(command: _command.text.trim())
                : McpServerSpec.http(url: _url.text.trim());
            try {
              await widget.admin.addMcpServer(_name.text, spec);
              _command.clear();
              _url.clear();
              await _load();
            } catch (error) {
              if (mounted) {
                setState(() => _error = _capabilityError(context, error));
              }
            }
          },
          child: Text(context.sharedL10n.rel_ops_cap_add_server),
        ),
        for (final server in _servers)
          ListTile(
            title: Text(server.name),
            subtitle: Text(server.detail),
            trailing: Wrap(
              children: [
                Switch(
                  key: Key('mcp-enable-${server.name}'),
                  value: server.enabled,
                  onChanged: (enabled) => _guard(() async {
                    await widget.admin.setMcpEnabled(server.name, enabled);
                    await _load();
                  }),
                ),
                IconButton(
                  key: Key('mcp-probe-${server.name}'),
                  tooltip: context.sharedL10n.rel_ops_cap_probe,
                  onPressed: () => _guard(() async {
                    final probe = await widget.admin.probeMcpServer(
                      server.name,
                    );
                    if (!mounted) return;
                    setState(() {
                      _error = probe.ok
                          ? context.sharedL10n.rel_ops_cap_probe_result(
                              server.name,
                              probe.tools.join(', '),
                            )
                          : (probe.error ??
                                context.sharedL10n.rel_ops_cap_probe_failed);
                    });
                  }),
                  icon: const Icon(Icons.network_check),
                ),
                IconButton(
                  key: Key('mcp-logs-${server.name}'),
                  tooltip: context.sharedL10n.rel_ops_cap_logs,
                  onPressed: () => _guard(() async {
                    final logs = await widget.admin.mcpLogs(
                      server: server.name,
                    );
                    if (!mounted) return;
                    setState(() => _logs = logs);
                  }),
                  icon: const Icon(Icons.receipt_long),
                ),
              ],
            ),
          ),
        if (_logs != null)
          SelectableText(_logs!, key: const Key('mcp-log-text')),
        TextButton(
          key: const Key('mcp-log-file'),
          onPressed: () => _guard(() async {
            final logs = await widget.admin.mcpLogs();
            if (!mounted) return;
            setState(() => _logs = logs);
          }),
          child: Text(context.sharedL10n.rel_ops_cap_mcp_log),
        ),
        TextField(
          key: const Key('connector-slug'),
          controller: _connector,
          decoration: InputDecoration(
            labelText: context.sharedL10n.rel_ops_cap_connector,
          ),
        ),
        TextField(
          controller: _alias,
          decoration: InputDecoration(
            labelText: context.sharedL10n.rel_ops_cap_account_alias,
          ),
        ),
        TextButton(
          key: const Key('connector-link'),
          onPressed: () => _guard(() async {
            await widget.admin.connectConnector(
              _connector.text,
              alias: _alias.text,
            );
            final accounts = await widget.admin.connectorAccounts();
            if (!mounted) return;
            setState(() => _accounts = accounts);
          }),
          child: Text(context.sharedL10n.rel_ops_cap_link_account),
        ),
        for (final account in _accounts)
          ListTile(
            title: Text(
              account.alias.isEmpty ? account.connector : account.alias,
            ),
            subtitle: Text(account.connector),
            trailing: IconButton(
              key: Key('account-remove-${account.connectionId}'),
              tooltip: context.sharedL10n.rel_ops_cap_remove_account,
              onPressed: () => _guard(() async {
                await widget.admin.removeConnectorAccount(account.connectionId);
                final accounts = await widget.admin.connectorAccounts();
                if (!mounted) return;
                setState(() => _accounts = accounts);
              }),
              icon: const Icon(Icons.link_off),
            ),
          ),
        TextField(
          key: const Key('tool-connector'),
          controller: _toolConnector,
          decoration: InputDecoration(
            labelText: context.sharedL10n.rel_ops_cap_tool_connector,
          ),
        ),
        TextButton(
          key: const Key('tool-load'),
          onPressed: () => _guard(() async {
            final connector = _toolConnector.text.trim();
            final grant = await widget.admin.connectorTools(connector);
            if (!mounted) return;
            setState(() {
              _grant = grant;
              _grantConnector = connector;
              _disabled
                ..clear()
                ..addAll(grant.disabled);
            });
          }),
          child: Text(context.sharedL10n.rel_ops_cap_load_tools),
        ),
        if (_grant != null)
          for (final tool in _grant!.tools)
            CheckboxListTile(
              key: Key('tool-$tool'),
              title: Text(tool),
              value: !_disabled.contains(tool),
              onChanged: _grant!.revision == null
                  ? null
                  : (allowed) {
                      setState(() {
                        if (allowed == true) {
                          _disabled.remove(tool);
                        } else {
                          _disabled.add(tool);
                        }
                      });
                    },
            ),
        if (_grant?.revision != null)
          TextButton(
            key: const Key('tool-save'),
            onPressed: () => _guard(() async {
              final connector = _grantConnector;
              final revision = _grant?.revision;
              if (connector == null || revision == null) return;
              await widget.admin.setDisabledTools(
                connector: connector,
                disabledTools: _disabled.toList(),
                expectedRevision: revision,
              );
            }),
            child: Text(
              _grantConnector == null
                  ? context.sharedL10n.rel_ops_cap_save_tool_grants
                  : context.sharedL10n.rel_ops_cap_save_tool_grants_for(
                      _grantConnector!,
                    ),
            ),
          ),
        if (_grant != null && _grant!.revision == null)
          Text(
            context
                .sharedL10n
                .rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged,
          ),
      ],
    );
  }
}

class _BackendsTab extends StatefulWidget {
  const _BackendsTab({required this.admin});

  final CapabilityAdmin admin;

  @override
  State<_BackendsTab> createState() => _BackendsTabState();
}

class _BackendsTabState extends State<_BackendsTab> {
  List<ToolsetSetup> _toolsets = const [];
  ToolsetSetup? _setup;
  List<TerminalBackendRecord> _backends = const [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => _error = _capabilityError(context, error));
    }
  }

  Future<void> _load() async {
    try {
      final toolsets = await widget.admin.toolsets();
      final backends = await widget.admin.terminalBackends();
      if (!mounted) return;
      setState(() {
        _toolsets = toolsets;
        _backends = backends;
      });
    } catch (error) {
      if (mounted) setState(() => _error = _capabilityError(context, error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_error != null) Text(_error!),
        for (final toolset in _toolsets)
          ListTile(
            title: Text(toolset.name),
            onTap: () => _guard(() async {
              final setup = await widget.admin.toolsetSetup(toolset.name);
              if (!mounted) return;
              setState(() => _setup = setup);
            }),
          ),
        if (_setup != null) ...[
          Text(context.sharedL10n.rel_ops_cap_backends_for(_setup!.name)),
          for (final provider in _setup!.providers) ...[
            ListTile(
              title: Text(provider.name),
              subtitle: Text(_capabilityValue(context, provider.status)),
              trailing: provider.active
                  ? Text(context.sharedL10n.rel_ops_cap_active)
                  : TextButton(
                      key: Key('provider-${provider.name}'),
                      onPressed: () => _guard(() async {
                        await widget.admin.selectToolsetProvider(
                          _setup!.name,
                          provider.name,
                        );
                        final setup = await widget.admin.toolsetSetup(
                          _setup!.name,
                        );
                        if (!mounted) return;
                        setState(() => _setup = setup);
                      }),
                      child: Text(context.sharedL10n.rel_ops_cap_use),
                    ),
            ),
            if (provider.setupKey != null)
              TextButton(
                key: Key('setup-${provider.name}'),
                onPressed: () => _guard(() async {
                  await widget.admin.runToolsetSetup(
                    _setup!.name,
                    provider.setupKey!,
                  );
                }),
                child: Text(context.sharedL10n.rel_ops_cap_run_setup),
              ),
          ],
        ],
        Text(context.sharedL10n.rel_ops_cap_terminal_backends),
        for (final backend in _backends)
          ListTile(
            title: Text(backend.label),
            subtitle: Text(
              '${_capabilityValue(context, backend.status)} ${backend.detail}'
                  .trim(),
            ),
            trailing: backend.active
                ? Text(context.sharedL10n.rel_ops_cap_active)
                : TextButton(
                    key: Key('terminal-${backend.name}'),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            context.sharedL10n
                                .rel_ops_cap_use_backend_confirmation(
                                  backend.label,
                                ),
                          ),
                          content: Text(
                            backend.detail.isEmpty
                                ? context
                                      .sharedL10n
                                      .rel_ops_cap_this_changes_the_terminal_backend_for_this_profile
                                : backend.detail,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(context.sharedL10n.cancel),
                            ),
                            TextButton(
                              key: const Key('confirm-terminal'),
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                context.sharedL10n.rel_ops_cap_use_backend,
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await _guard(() async {
                          await widget.admin.selectTerminalBackend(
                            backend.name,
                          );
                          await _load();
                        });
                      }
                    },
                    child: Text(context.sharedL10n.rel_ops_cap_select),
                  ),
          ),
      ],
    );
  }
}

class _BrowserVaultScreenState extends State<BrowserVaultScreen> {
  VaultInventory? _inventory;
  String? _error;
  final _label = TextEditingController();
  final _origin = TextEditingController();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _otp = TextEditingController();
  final _line1 = TextEditingController();
  final _city = TextEditingController();
  final _postal = TextEditingController();
  final _country = TextEditingController();
  final _cardNumber = TextEditingController();
  final _cardName = TextEditingController();
  final _expMonth = TextEditingController();
  final _expYear = TextEditingController();
  final _cvc = TextEditingController();
  String _kind = 'login';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final controller in [
      _label,
      _origin,
      _identifier,
      _password,
      _otp,
      _line1,
      _city,
      _postal,
      _country,
      _cardNumber,
      _cardName,
      _expMonth,
      _expYear,
      _cvc,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final inventory = await widget.admin.vaultInventory();
      if (!mounted) return;
      setState(() {
        _inventory = inventory;
        _error = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = _capabilityError(context, error));
    }
  }

  VaultDraft _draft() {
    switch (_kind) {
      case 'address':
        return VaultDraft.address(
          label: _label.text,
          origin: _origin.text,
          line1: _line1.text,
          city: _city.text,
          postal: _postal.text,
          country: _country.text,
        );
      case 'payment':
        return VaultDraft.payment(
          label: _label.text,
          origin: _origin.text,
          cardNumber: _cardNumber.text,
          cardName: _cardName.text,
          expMonth: _expMonth.text,
          expYear: _expYear.text,
          cvc: _cvc.text,
          postal: _postal.text,
        );
      default:
        return VaultDraft.login(
          label: _label.text,
          origin: _origin.text,
          identifier: _identifier.text,
          password: _password.text,
          otpSecret: _otp.text,
        );
    }
  }

  void _clearSecrets() {
    _password.clear();
    _otp.clear();
    _cardNumber.clear();
    _cvc.clear();
  }

  @override
  Widget build(BuildContext context) {
    final inventory = _inventory;
    return Scaffold(
      appBar: AppBar(title: Text(context.sharedL10n.rel_ops_cap_browser_vault)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null) Text(_error!, key: const Key('vault-error')),
          Text(
            context
                .sharedL10n
                .rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here,
          ),
          if (inventory != null)
            for (final item in inventory.items)
              ListTile(
                title: Text(item.label),
                subtitle: Text(
                  '${_capabilityValue(context, item.kind)} ${item.origin} ${item.backend}'
                      .trim(),
                ),
                trailing: item.removable
                    ? IconButton(
                        key: Key('vault-remove-${item.id}'),
                        tooltip:
                            context.sharedL10n.rel_ops_cap_remove_saved_item,
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                context.sharedL10n.rel_ops_cap_delete_this_item,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(context.sharedL10n.cancel),
                                ),
                                TextButton(
                                  key: const Key('confirm-vault-remove'),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(context.sharedL10n.delete),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await widget.admin.removeVaultItem(item.id);
                            await _load();
                          }
                        },
                        icon: const Icon(Icons.delete_outline),
                      )
                    : null,
              ),
          if (inventory != null)
            for (final source in inventory.sources)
              SwitchListTile(
                key: Key('vault-source-${source.name}'),
                title: Text(source.label),
                subtitle: Text(
                  source.installed
                      ? (source.unlocked
                            ? context.sharedL10n.rel_ops_cap_unlocked
                            : context.sharedL10n.rel_ops_cap_locked)
                      : context.sharedL10n.rel_ops_cap_not_detected,
                ),
                value: source.enabled,
                onChanged: source.installed
                    ? (enabled) async {
                        await widget.admin.setVaultSourceEnabled(
                          source.name,
                          enabled,
                        );
                        await _load();
                      }
                    : null,
                secondary: source.needsUnlock
                    ? TextButton(
                        key: Key('vault-unlock-${source.name}'),
                        onPressed: () async {
                          final password = TextEditingController();
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                context.sharedL10n.rel_ops_cap_unlock_source(
                                  source.label,
                                ),
                              ),
                              content: TextField(
                                key: const Key('vault-master'),
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: context
                                      .sharedL10n
                                      .rel_ops_cap_master_password,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(context.sharedL10n.cancel),
                                ),
                                TextButton(
                                  key: const Key('confirm-unlock'),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    context.sharedL10n.rel_ops_cap_unlock,
                                  ),
                                ),
                              ],
                            ),
                          );
                          final secret = password.text;
                          password.dispose();
                          if (confirmed == true) {
                            if (source.unlocked) {
                              await widget.admin.lockVaultSource(source.name);
                            } else {
                              await widget.admin.unlockVaultSource(
                                source.name,
                                secret,
                              );
                            }
                            await _load();
                          }
                        },
                        child: Text(
                          source.unlocked
                              ? context.sharedL10n.rel_ops_cap_lock
                              : context.sharedL10n.rel_ops_cap_unlock,
                        ),
                      )
                    : null,
              ),
          DropdownButton<String>(
            key: const Key('vault-kind'),
            value: _kind,
            items: [
              DropdownMenuItem(
                value: 'login',
                child: Text(context.sharedL10n.rel_ops_cap_login),
              ),
              DropdownMenuItem(
                value: 'address',
                child: Text(context.sharedL10n.rel_ops_cap_address),
              ),
              DropdownMenuItem(
                value: 'payment',
                child: Text(context.sharedL10n.rel_ops_cap_card),
              ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          TextField(
            key: const Key('vault-label'),
            controller: _label,
            decoration: InputDecoration(
              labelText: context.sharedL10n.rel_ops_cap_label,
            ),
          ),
          TextField(
            key: const Key('vault-origin'),
            controller: _origin,
            decoration: InputDecoration(
              labelText: context.sharedL10n.rel_ops_cap_site_origin,
            ),
          ),
          if (_kind == 'login') ...[
            TextField(
              key: const Key('vault-identifier'),
              controller: _identifier,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_identifier,
              ),
            ),
            TextField(
              key: const Key('vault-password'),
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_password,
              ),
            ),
            TextField(
              key: const Key('vault-otp'),
              controller: _otp,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_authenticator_key,
              ),
            ),
          ],
          if (_kind == 'address') ...[
            TextField(
              controller: _line1,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_street,
              ),
            ),
            TextField(
              controller: _city,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_city,
              ),
            ),
            TextField(
              controller: _postal,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_postal_code,
              ),
            ),
            TextField(
              controller: _country,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_country,
              ),
            ),
          ],
          if (_kind == 'payment') ...[
            TextField(
              key: const Key('vault-card-name'),
              controller: _cardName,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_name_on_card,
              ),
            ),
            TextField(
              key: const Key('vault-card-number'),
              controller: _cardNumber,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_card_number,
              ),
            ),
            TextField(
              controller: _expMonth,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_expiry_month,
              ),
            ),
            TextField(
              controller: _expYear,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_expiry_year,
              ),
            ),
            TextField(
              key: const Key('vault-cvc'),
              controller: _cvc,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_cap_security_code,
              ),
            ),
          ],
          TextButton(
            key: const Key('vault-save'),
            onPressed: () async {
              try {
                await widget.admin.addVaultItem(_draft());
                _clearSecrets();
                await _load();
              } on VaultFormException catch (error) {
                if (mounted) {
                  setState(() => _error = _capabilityError(context, error));
                }
              } catch (error) {
                if (mounted) {
                  setState(() => _error = _capabilityError(context, error));
                }
              }
            },
            child: Text(context.sharedL10n.save),
          ),
        ],
      ),
    );
  }
}

class _AgentPolicyScreenState extends State<AgentPolicyScreen> {
  AgentPolicy? _policy;
  SharedMetricsConsent? _metrics;
  String? _metricsNote;
  final _allowlist = TextEditingController();
  final _timeout = TextEditingController();
  final _limit = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _allowlist.dispose();
    _timeout.dispose();
    _limit.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final policy = await widget.admin.agentPolicy();
      if (!mounted) return;
      _allowlist.text = policy.allowlist.join('\n');
      _timeout.text = '${policy.approvalTimeout}';
      _limit.text = '${policy.checkpointLimit}';
      setState(() => _policy = policy);
    } catch (error) {
      if (mounted) setState(() => _error = _capabilityError(context, error));
    }
    try {
      final metrics = await widget.admin.sharedMetrics();
      if (!mounted) return;
      setState(() => _metrics = metrics);
    } on CapabilityException catch (error) {
      if (!mounted) return;
      setState(() {
        _metricsNote = error.methodMissing
            ? context
                  .sharedL10n
                  .rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method
            : _capabilityError(context, error);
      });
    }
  }

  AgentPolicy? _edited() {
    final current = _policy;
    if (current == null) return null;
    return AgentPolicy(
      approvalMode: current.approvalMode,
      approvalTimeout: int.tryParse(_timeout.text.trim()) ?? -1,
      confirmMcpReload: current.confirmMcpReload,
      allowlist: [
        for (final line in _allowlist.text.split('\n'))
          if (line.trim().isNotEmpty) line.trim(),
      ],
      checkpointsEnabled: current.checkpointsEnabled,
      checkpointLimit: int.tryParse(_limit.text.trim()) ?? -1,
      browserPrivateUrls: current.browserPrivateUrls,
      realBrowserProfile: current.realBrowserProfile,
    );
  }

  Future<void> _save(AgentPolicy policy) async {
    await widget.admin.saveAgentPolicy(policy);
    if (!mounted) return;
    setState(() => _policy = policy);
  }

  @override
  Widget build(BuildContext context) {
    final policy = _policy;
    return Scaffold(
      appBar: AppBar(title: Text(context.sharedL10n.rel_ops_cap_agent_policy)),
      body: policy == null
          ? Center(
              child: Text(
                _error ?? context.sharedL10n.rel_ops_cap_loading_policy,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_error != null) Text(_error!),
                DropdownButton<String>(
                  key: const Key('approval-mode'),
                  value: policy.approvalMode,
                  items: [
                    for (final mode in AgentPolicy.modes)
                      DropdownMenuItem(
                        value: mode,
                        child: Text(_capabilityValue(context, mode)),
                      ),
                  ],
                  onChanged: (mode) {
                    if (mode == null) return;
                    setState(() {
                      _policy = AgentPolicy(
                        approvalMode: mode,
                        approvalTimeout: policy.approvalTimeout,
                        confirmMcpReload: policy.confirmMcpReload,
                        allowlist: policy.allowlist,
                        checkpointsEnabled: policy.checkpointsEnabled,
                        checkpointLimit: policy.checkpointLimit,
                        browserPrivateUrls: policy.browserPrivateUrls,
                        realBrowserProfile: policy.realBrowserProfile,
                      );
                    });
                  },
                ),
                TextField(
                  key: const Key('approval-timeout'),
                  controller: _timeout,
                  decoration: InputDecoration(
                    labelText: context.sharedL10n.rel_ops_cap_approval_timeout,
                  ),
                ),
                SwitchListTile(
                  key: const Key('mcp-reload-confirm'),
                  title: Text(
                    context.sharedL10n.rel_ops_cap_confirm_mcp_reloads,
                  ),
                  value: policy.confirmMcpReload,
                  onChanged: (value) => setState(() {
                    _policy = AgentPolicy(
                      approvalMode: policy.approvalMode,
                      approvalTimeout: policy.approvalTimeout,
                      confirmMcpReload: value,
                      allowlist: policy.allowlist,
                      checkpointsEnabled: policy.checkpointsEnabled,
                      checkpointLimit: policy.checkpointLimit,
                      browserPrivateUrls: policy.browserPrivateUrls,
                      realBrowserProfile: policy.realBrowserProfile,
                    );
                  }),
                ),
                TextField(
                  key: const Key('command-allowlist'),
                  controller: _allowlist,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: context.sharedL10n.rel_ops_cap_command_allowlist,
                  ),
                ),
                SwitchListTile(
                  key: const Key('checkpoints-enabled'),
                  title: Text(context.sharedL10n.rel_ops_cap_file_checkpoints),
                  value: policy.checkpointsEnabled,
                  onChanged: (value) => setState(() {
                    _policy = AgentPolicy(
                      approvalMode: policy.approvalMode,
                      approvalTimeout: policy.approvalTimeout,
                      confirmMcpReload: policy.confirmMcpReload,
                      allowlist: policy.allowlist,
                      checkpointsEnabled: value,
                      checkpointLimit: policy.checkpointLimit,
                      browserPrivateUrls: policy.browserPrivateUrls,
                      realBrowserProfile: policy.realBrowserProfile,
                    );
                  }),
                ),
                TextField(
                  key: const Key('checkpoint-limit'),
                  controller: _limit,
                  decoration: InputDecoration(
                    labelText: context.sharedL10n.rel_ops_cap_checkpoint_limit,
                  ),
                ),
                SwitchListTile(
                  key: const Key('private-urls'),
                  title: Text(
                    context.sharedL10n.rel_ops_cap_browser_private_urls,
                  ),
                  value: policy.browserPrivateUrls,
                  onChanged: (value) => setState(() {
                    _policy = AgentPolicy(
                      approvalMode: policy.approvalMode,
                      approvalTimeout: policy.approvalTimeout,
                      confirmMcpReload: policy.confirmMcpReload,
                      allowlist: policy.allowlist,
                      checkpointsEnabled: policy.checkpointsEnabled,
                      checkpointLimit: policy.checkpointLimit,
                      browserPrivateUrls: value,
                      realBrowserProfile: policy.realBrowserProfile,
                    );
                  }),
                ),
                SwitchListTile(
                  key: const Key('real-browser-profile'),
                  title: Text(
                    context.sharedL10n.rel_ops_cap_use_my_real_browser_profile,
                  ),
                  value: policy.realBrowserProfile,
                  onChanged: (value) => setState(() {
                    _policy = AgentPolicy(
                      approvalMode: policy.approvalMode,
                      approvalTimeout: policy.approvalTimeout,
                      confirmMcpReload: policy.confirmMcpReload,
                      allowlist: policy.allowlist,
                      checkpointsEnabled: policy.checkpointsEnabled,
                      checkpointLimit: policy.checkpointLimit,
                      browserPrivateUrls: policy.browserPrivateUrls,
                      realBrowserProfile: value,
                    );
                  }),
                ),
                TextButton(
                  key: const Key('policy-save'),
                  onPressed: () async {
                    final edited = _edited();
                    if (edited == null) return;
                    try {
                      await _save(edited);
                    } catch (error) {
                      if (mounted) {
                        setState(
                          () => _error = _capabilityError(context, error),
                        );
                      }
                    }
                  },
                  child: Text(context.sharedL10n.rel_ops_cap_save_policy),
                ),
                if (_metricsNote != null) Text(_metricsNote!),
                if (_metrics != null) ...[
                  SwitchListTile(
                    key: const Key('metrics-enabled'),
                    title: Text(
                      context
                          .sharedL10n
                          .rel_ops_cap_shared_metrics_for_this_profile,
                    ),
                    value: _metrics!.enabled,
                    onChanged: (enabled) async {
                      final next = await widget.admin.setSharedMetrics(
                        enabled: enabled,
                        send: enabled && _metrics!.send,
                      );
                      if (!mounted) return;
                      setState(() => _metrics = next);
                    },
                  ),
                  SwitchListTile(
                    key: const Key('metrics-send'),
                    title: Text(
                      context.sharedL10n.rel_ops_cap_send_shared_metrics,
                    ),
                    value: _metrics!.send,
                    onChanged: _metrics!.enabled
                        ? (send) async {
                            final next = await widget.admin.setSharedMetrics(
                              enabled: true,
                              send: send,
                            );
                            if (!mounted) return;
                            setState(() => _metrics = next);
                          }
                        : null,
                  ),
                ],
              ],
            ),
    );
  }
}

// Gateway-authored diagnostics and unknown wire values remain unchanged.
String _capabilityError(BuildContext context, Object error) {
  final reason = switch (error) {
    CapabilityException e => e.reason,
    VaultFormException e => e.reason,
    _ => null,
  };
  if (reason == null) return error.toString();
  return switch (reason) {
    CapabilityFailure.enterALabel =>
      context.sharedL10n.rel_ops_cap_error_enter_a_label,
    CapabilityFailure.enterAValidUrlLikeHttpsExampleCom =>
      context
          .sharedL10n
          .rel_ops_cap_error_enter_a_valid_url_like_https_example_com,
    CapabilityFailure.enterTheIdentifierAndPassword =>
      context.sharedL10n.rel_ops_cap_error_enter_the_identifier_and_password,
    CapabilityFailure.enterTheCardNameNumberExpiryAndSecurityCode =>
      context
          .sharedL10n
          .rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code,
    CapabilityFailure.enterTheStreetCityPostalCodeAndCountry =>
      context
          .sharedL10n
          .rel_ops_cap_error_enter_the_street_city_postal_code_and_country,
    CapabilityFailure.theGatewayReturnedAResponseThatCouldNotBeRead =>
      context
          .sharedL10n
          .rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read,
    CapabilityFailure.theGatewayRefusedTheRequestStatus =>
      context.sharedL10n
          .rel_ops_cap_error_the_gateway_refused_the_request_status(
            (error as CapabilityException).statusCode!,
          ),
    CapabilityFailure.thisConnectionHasNoGatewaySocketSoMethodIsUnavailable =>
      context.sharedL10n
          .rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
            (error as CapabilityException).method!,
          ),
    CapabilityFailure.chooseASkill =>
      context.sharedL10n.rel_ops_cap_error_choose_a_skill,
    CapabilityFailure.theSkillTextWasNotReturned =>
      context.sharedL10n.rel_ops_cap_error_the_skill_text_was_not_returned,
    CapabilityFailure.theSkillWasNotSaved =>
      context.sharedL10n.rel_ops_cap_error_the_skill_was_not_saved,
    CapabilityFailure.theSkillWasNotArchived =>
      context.sharedL10n.rel_ops_cap_error_the_skill_was_not_archived,
    CapabilityFailure.theSkillWasNotInstalled =>
      context.sharedL10n.rel_ops_cap_error_the_skill_was_not_installed,
    CapabilityFailure.skillUpdatesDidNotStart =>
      context.sharedL10n.rel_ops_cap_error_skill_updates_did_not_start,
    CapabilityFailure.theSkillWasNotRemoved =>
      context.sharedL10n.rel_ops_cap_error_the_skill_was_not_removed,
    CapabilityFailure.enterASkillOrPluginIdentifier =>
      context.sharedL10n.rel_ops_cap_error_enter_a_skill_or_plugin_identifier,
    CapabilityFailure.chooseAPlugin =>
      context.sharedL10n.rel_ops_cap_error_choose_a_plugin,
    CapabilityFailure.thePluginWasNotRemoved =>
      context.sharedL10n.rel_ops_cap_error_the_plugin_was_not_removed,
    CapabilityFailure.theDesktopHalfWasNotRemoved =>
      context.sharedL10n.rel_ops_cap_error_the_desktop_half_was_not_removed,
    CapabilityFailure.thisGatewayDidNotGiveThePluginAStableKey =>
      context
          .sharedL10n
          .rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key,
    CapabilityFailure.thePluginWasNotChanged =>
      context.sharedL10n.rel_ops_cap_error_the_plugin_was_not_changed,
    CapabilityFailure.chooseAServer =>
      context.sharedL10n.rel_ops_cap_error_choose_a_server,
    CapabilityFailure.nameTheServer =>
      context.sharedL10n.rel_ops_cap_error_name_the_server,
    CapabilityFailure.giveTheServerACommandOrAnHttpSUrl =>
      context
          .sharedL10n
          .rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url,
    CapabilityFailure.chooseAToolset =>
      context.sharedL10n.rel_ops_cap_error_choose_a_toolset,
    CapabilityFailure.toolBackendStatusWasNotReturned =>
      context.sharedL10n.rel_ops_cap_error_tool_backend_status_was_not_returned,
    CapabilityFailure.chooseAProvider =>
      context.sharedL10n.rel_ops_cap_error_choose_a_provider,
    CapabilityFailure.thisProviderHasNoSetupAction =>
      context.sharedL10n.rel_ops_cap_error_this_provider_has_no_setup_action,
    CapabilityFailure.setupDidNotStart =>
      context.sharedL10n.rel_ops_cap_error_setup_did_not_start,
    CapabilityFailure.chooseATerminalBackend =>
      context.sharedL10n.rel_ops_cap_error_choose_a_terminal_backend,
    CapabilityFailure.nameTheConnector =>
      context.sharedL10n.rel_ops_cap_error_name_the_connector,
    CapabilityFailure.chooseAnAccount =>
      context.sharedL10n.rel_ops_cap_error_choose_an_account,
    CapabilityFailure.reloadTheConnectorPolicyBeforeChangingToolGrants =>
      context
          .sharedL10n
          .rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants,
    CapabilityFailure.chooseAnItem =>
      context.sharedL10n.rel_ops_cap_error_choose_an_item,
    CapabilityFailure.chooseASource =>
      context.sharedL10n.rel_ops_cap_error_choose_a_source,
    CapabilityFailure.enterTheMasterPassword =>
      context.sharedL10n.rel_ops_cap_error_enter_the_master_password,
    CapabilityFailure.gatewayConfigWasNotReturned =>
      context.sharedL10n.rel_ops_cap_error_gateway_config_was_not_returned,
    CapabilityFailure.chooseAKnownApprovalMode =>
      context.sharedL10n.rel_ops_cap_error_choose_a_known_approval_mode,
    CapabilityFailure.useAPositiveLimit =>
      context.sharedL10n.rel_ops_cap_error_use_a_positive_limit,
    CapabilityFailure.thePolicyWasNotSaved =>
      context.sharedL10n.rel_ops_cap_error_the_policy_was_not_saved,
  };
}

String _capabilityValue(BuildContext context, String value) => switch (value) {
  'manual' => context.sharedL10n.rel_ops_cap_value_manual,
  'smart' => context.sharedL10n.rel_ops_cap_value_smart,
  'off' => context.sharedL10n.rel_ops_cap_value_off,
  'safe' => context.sharedL10n.rel_ops_cap_value_safe,
  'caution' => context.sharedL10n.rel_ops_cap_value_caution,
  'dangerous' => context.sharedL10n.rel_ops_cap_value_dangerous,
  'blocked' => context.sharedL10n.rel_ops_cap_value_blocked,
  'clean' => context.sharedL10n.rel_ops_cap_value_clean,
  'ready' => context.sharedL10n.rel_ops_cap_value_ready,
  'available' => context.sharedL10n.rel_ops_cap_value_available,
  'unavailable' => context.sharedL10n.rel_ops_cap_value_unavailable,
  'enabled' => context.sharedL10n.rel_ops_cap_value_enabled,
  'disabled' => context.sharedL10n.rel_ops_cap_value_disabled,
  'active' => context.sharedL10n.rel_ops_cap_value_active,
  'inactive' => context.sharedL10n.rel_ops_cap_value_inactive,
  'installed' => context.sharedL10n.rel_ops_cap_value_installed,
  'missing' => context.sharedL10n.rel_ops_cap_value_missing,
  'configured' => context.sharedL10n.rel_ops_cap_value_configured,
  'not_configured' => context.sharedL10n.rel_ops_cap_value_not_configured,
  'error' => context.sharedL10n.rel_ops_cap_value_error,
  'unknown' => context.sharedL10n.rel_ops_cap_value_unknown,
  'login' => context.sharedL10n.rel_ops_cap_value_login,
  'address' => context.sharedL10n.rel_ops_cap_value_address,
  'payment' => context.sharedL10n.rel_ops_cap_value_payment,
  _ => value,
};
