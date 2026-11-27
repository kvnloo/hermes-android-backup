import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../workspace/profile_presentation_store.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/remote_workspace.dart';
import '../services/desktop_gateway_client.dart';
import '../services/connection_manager.dart';
import 'profile_admin_panel.dart';

/// Administration has its own selection; it never switches the active chat.
class WorkspaceProfilesScreen extends StatefulWidget {
  const WorkspaceProfilesScreen({
    super.key,
    required this.owner,
    required this.route,
    required this.label,
    required this.connection,
    this.nextGen = false,
  });
  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final String label;
  final SavedConnection connection;
  final bool nextGen;

  @override
  State<WorkspaceProfilesScreen> createState() =>
      _WorkspaceProfilesScreenState();
}

class _WorkspaceProfilesScreenState extends State<WorkspaceProfilesScreen> {
  late WorkspacePane _pane;
  late Future<ProfileRoster> _snapshot;
  DesktopGatewayClient? _scoped;
  WorkspacePane? _settingsPane;
  Future<RemoteProfileAdmin>? _settings;
  String? _selected;
  Object? _account;
  ProfilePresentationStore? _styles;

  void _bind() {
    _pane = widget.owner.pane();
    _account = ConnectionMutationBarrier.capture(widget.route.connectionId);
    _startRead();
  }

  void _startRead() {
    _clearSelection();
    _snapshot = _load();
    // A synchronous owner refusal can settle before FutureBuilder subscribes.
    // Its builder still receives the failure on the original future.
    _snapshot.ignore();
  }

  @override
  void initState() {
    super.initState();
    _bind();
    SharedPreferences.getInstance().then((p) {
      if (mounted) setState(() => _styles = ProfilePresentationStore(p));
    });
    ConnectionMutationBarrier.addListener(_accountChanged);
  }

  void _accountChanged() {
    if (ConnectionMutationBarrier.isCurrent(
      widget.route.connectionId,
      _account,
    )) {
      return;
    }
    _pane.invalidate();
    if (mounted) setState(_startRead);
  }

  @override
  void didUpdateWidget(WorkspaceProfilesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.owner != oldWidget.owner || widget.route != oldWidget.route) {
      _pane.close();
      _bind();
    }
  }

  void _clearSelection() {
    _settingsPane?.close();
    _settingsPane = null;
    _scoped?.close();
    _scoped = null;
    _settings = null;
    _selected = null;
  }

  void _select(ProfileRoster roster, String name) {
    if (!roster.target.isCurrent ||
        widget.connection.id != widget.owner.connectionId ||
        DesktopGatewayClient.normalizedGatewayBaseUrl(widget.connection) !=
            widget.owner.expectedBaseUrl) {
      roster.chooseAgain();
      setState(_startRead);
      return;
    }
    _clearSelection();
    final owner = (_scoped = DesktopGatewayClient.fromConnection(
      widget.connection.copyWith(gatewayProfile: name),
    )).workspace;
    final pane = _settingsPane = owner.pane();
    _selected = name;
    _settings = pane
        .bind(owner.route())
        .then((t) => roster.settings(t, name))
        .then((admin) {
          admin.check();
          roster.rememberSettings(name);
          return admin;
        });
    _settings!.ignore();
    setState(() {});
  }

  Future<ProfileRoster> _load() async {
    final target = await _pane.bind(widget.route);
    final roster = await ProfileRoster.read(target);
    target.checkCurrent();
    final remembered = roster.appliesTo;
    if (mounted && remembered != null) {
      _select(roster, remembered);
    }
    return roster;
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(_accountChanged);
    _pane.close();
    _clearSelection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.ng_profiles),
        actions: [
          IconButton(
            tooltip: l.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(_startRead),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(widget.label),
            subtitle: widget.route.profile == null
                ? null
                : Text(widget.route.profile!),
          ),
          Expanded(
            child: FutureBuilder<ProfileRoster>(
              future: _snapshot,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  final why = error is WorkspaceException
                      ? error.reason
                      : WorkspaceFailure.unavailable;
                  return Center(
                    child: Text(switch (why) {
                      WorkspaceFailure.denied => l.ng_notify_permission_denied,
                      WorkspaceFailure.unsupported => l.ng_unsupported,
                      WorkspaceFailure.stale || WorkspaceFailure.mismatch =>
                        l.ng_the_gateway_connection_dropped_try_again,
                      WorkspaceFailure.insecure =>
                        'HTTPS · ${l.check_the_connection_and_try_again}',
                      _ => l.check_the_connection_and_try_again,
                    }),
                  );
                }
                final roster = snapshot.requireData;
                if (_settings != null) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.arrow_back),
                        title: Text(
                          context.sharedL10n
                              .release_core_workspace_profiles_screen_applies_to(
                                (_selected).toString(),
                              ),
                        ),
                        subtitle: Text(
                          context
                              .sharedL10n
                              .release_core_workspace_profiles_screen_choose_another_profile,
                        ),
                        onTap: () {
                          roster.chooseAgain();
                          setState(_startRead);
                        },
                      ),
                      Expanded(
                        child: FutureBuilder<RemoteProfileAdmin>(
                          future: _settings,
                          builder: (_, s) {
                            if (s.connectionState != ConnectionState.done) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (s.hasError) {
                              return Center(
                                child: Text(
                                  context
                                      .sharedL10n
                                      .release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this,
                                ),
                              );
                            }
                            return ProfileAdminPanel(
                              key: ValueKey(s.requireData),
                              admin: s.requireData,
                              connection: widget.connection.copyWith(
                                gatewayProfile: _selected,
                              ),
                              nextGen: widget.nextGen,
                              label: widget.label,
                              onRosterChanged: () {
                                roster.chooseAgain();
                                setState(_startRead);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                final names = roster.names.keys.toList();
                return ListView.builder(
                  itemCount: names.length + 1,
                  itemBuilder: (_, i) => i == names.length
                      ? ListTile(
                          leading: const Icon(Icons.person_add_alt),
                          title: Text(
                            context
                                .sharedL10n
                                .release_core_workspace_profiles_screen_create_profile,
                          ),
                          onTap: () async {
                            final newName = await profileInput(
                              context,
                              context
                                  .sharedL10n
                                  .release_core_workspace_profiles_screen_create_profile,
                              context
                                  .sharedL10n
                                  .release_core_workspace_profiles_screen_new_profile_id,
                              widget.label,
                            );
                            if (newName == null || !mounted) return;
                            try {
                              await roster.create(newName);
                              if (mounted) setState(_startRead);
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(content: Text(profileError(e))),
                                );
                              }
                            }
                          },
                        )
                      : ListTile(
                          leading: Icon(
                            Icons.person_outline,
                            color: _styles
                                ?.read(
                                  widget.connection.copyWith(
                                    gatewayProfile: names[i],
                                  ),
                                )
                                ?.style
                                .rail,
                          ),
                          title: Text(names[i]),
                          subtitle: roster.names[names[i]]!.isEmpty
                              ? null
                              : Text(roster.names[names[i]]!),
                          onTap: () => _select(roster, names[i]),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
