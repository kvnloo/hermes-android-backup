import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/connection.dart';
import '../models/session.dart';
import '../services/connection_mutation_barrier.dart';
import '../widgets/keyboard_room.dart';
import 'workspace_layout.dart';
import 'profile_presentation_store.dart';
import 'terminal_chat_link.dart';
import 'workspace_pane.dart';
import 'workspace_picker.dart';
import 'workspace_popout.dart';
import 'workspace_registry.dart';

class ParallelWorkspace extends StatefulWidget {
  ParallelWorkspace({
    required this.connection,
    required this.nextGen,
    required this.loadSessions,
    required this.buildChat,
    this.registry,
  }) : super(key: ValueKey((connection, nextGen)));
  final SavedConnection connection;
  final bool nextGen;
  final Future<List<Session>> Function() loadSessions;
  final Widget Function(BuildContext, Session, VoidCallback) buildChat;
  final WorkspaceRegistry? registry;

  /// The workspace's own way of opening a chat, for a pane's `/resume`: the
  /// pick opens as a pane of this workspace, which stays. Null outside one.
  static Future<void> Function(Session session)? openSessionOf(
    BuildContext context,
  ) => context
      .dependOnInheritedWidgetOfExactType<_WorkspaceOpener>()
      ?.openSession;

  @override
  State<ParallelWorkspace> createState() => _WorkspaceState();
}

class _WorkspaceOpener extends InheritedWidget {
  const _WorkspaceOpener({required this.openSession, required super.child});

  final Future<void> Function(Session session) openSession;

  @override
  bool updateShouldNotify(_WorkspaceOpener old) =>
      openSession != old.openSession;
}

enum _Command {
  split,
  swap,
  undock,
  stack,
  ratio,
  focus,
  hide,
  reload,
  close,
  others,
  right,
  all,
  reopen,
  previous,
  next,
  moveLeft,
  moveRight,
  save,
  restore,
  refresh,
  popout,
}

class _WorkspaceState extends State<ParallelWorkspace> {
  final _chatLinks = <String, TerminalChatLink>{};
  TerminalChatLink _link(String id) =>
      _chatLinks.putIfAbsent(id, () => TerminalChatLink(widget.connection, id));
  final _versions = <PaneRef, Object>{};
  Object _version(PaneRef pane) => _versions.putIfAbsent(pane, Object.new);
  WorkspaceLayout _layout = WorkspaceLayout();
  SharedPreferences? _prefs;
  Map<String, Session> _roster = {};
  late final _epoch = ConnectionMutationBarrier.capture(widget.connection.id);
  late String _key;
  bool _loading = true, _failed = false, _focus = false;
  PaneRef? _lastTouched;
  bool get _current =>
      mounted &&
      ConnectionMutationBarrier.isCurrent(widget.connection.id, _epoch);
  WorkspaceRegistry get _registry => widget.registry ?? aresWorkspaceRegistry;
  PaneRef? get _primary => _layout.primary;

  void _readLayout(SharedPreferences prefs) {
    final installed = ProfilePresentationStore(prefs).read(widget.connection);
    _key = workspaceLayoutKey(widget.connection, widget.nextGen, installed);
    final raw = prefs.get(_key), g = installed?.style.geometry;
    _layout = raw is String
        ? WorkspaceLayout.decode(raw)
        : g == null
        ? WorkspaceLayout()
        : WorkspaceLayout.unbound(
            paired: g.paired,
            stacked: g.stacked,
            percent: g.percent,
          );
  }

  void _presentationChanged() {
    final prefs = _prefs;
    if (!_current || prefs == null) return;
    final installed = ProfilePresentationStore(prefs).read(widget.connection);
    if (workspaceLayoutKey(widget.connection, widget.nextGen, installed) ==
        _key) {
      return;
    }
    setState(() {
      _versions.clear();
      _focus = false;
      _lastTouched = null;
      _readLayout(prefs);
    });
  }

  @override
  void dispose() {
    ProfilePresentationStore.revision.removeListener(_presentationChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ProfilePresentationStore.revision.addListener(_presentationChanged);
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      // An unavailable roster must not disable connection-level tools or
      // discard the user's layout. Restored chats wait for exact live rows.
      if (_prefs == null) {
        final prefs = await SharedPreferences.getInstance();
        if (!_current) return;
        setState(() {
          _prefs = prefs;
          _readLayout(prefs);
        });
      }
      final rows = await widget.loadSessions();
      if (!_current) return;
      setState(() {
        _roster = {
          for (final row in rows)
            if (!row.isLocalDraft && !row.archived && row.id.isNotEmpty)
              row.id: row,
        };
        _failed = false;
        _loading = false;
      });
    } catch (_) {
      if (_current) {
        setState(() {
          _failed = true;
          _loading = false;
        });
      }
    }
  }

  void _refresh() {
    if (_loading) return;
    setState(() => _loading = true);
    unawaited(_load());
  }

  void _message(String text) => ScaffoldMessenger.maybeOf(
    context,
  )?.showSnackBar(SnackBar(content: Text(text)));
  void _edit(VoidCallback apply) {
    if (!_current || _prefs == null) return;
    setState(() {
      apply();
      _versions.removeWhere((pane, _) => !_layout.tabs.contains(pane));
      _chatLinks.removeWhere(
        (id, _) => !_layout.tabs.any((pane) => pane.sessionId == id),
      );
      if (_primary == null) _focus = false;
    });
    // SharedPreferences updates its in-process cache synchronously and sends
    // writes on the ordered preferences channel. Do not retain account objects.
    unawaited(_persist(_prefs!, _key, _layout.encode()));
  }

  Future<void> _persist(
    SharedPreferences prefs,
    String key,
    String value,
  ) async {
    final l10n = context.sharedL10n;
    try {
      if (await prefs.setString(key, value)) return;
    } catch (_) {
      /* Show a local-only failure. */
    }
    if (_current) {
      _message(
        l10n.release_core_parallel_workspace_layout_changed_in_this_window_but_could_not,
      );
    }
  }

  String _title(PaneRef ref) {
    if (isWorkspaceSlot(ref)) {
      return ref == firstWorkspaceSlot
          ? context.sharedL10n.release_core_parallel_workspace_first_pane
          : context.sharedL10n.release_core_parallel_workspace_second_pane;
    }
    if (ref.page.isNotEmpty) {
      return _registry.page(ref.page)?.localizedLabel(context.sharedL10n) ??
          context.sharedL10n.release_core_parallel_workspace_unavailable_page;
    }
    final title = _roster[ref.sessionId]?.title;
    return title == null || title.isEmpty ? ref.sessionId : title;
  }

  void _open(PaneRef ref, {bool split = false}) => _edit(() {
    if (!_layout.open(ref, split: split)) {
      _message(
        context.sharedL10n
            .release_core_parallel_workspace_close_a_tab_first_maximum(
              (WorkspaceLayout.maxTabs).toString(),
            ),
      );
    }
  });

  /// `/resume` from a pane: the picked chat opens as a pane here.
  Future<void> _openSession(Session session) async {
    if (!_current || session.id.isEmpty || session.isLocalDraft) return;
    // The pick may be outside the live roster this pane was chosen from.
    _roster = {..._roster, session.id: session};
    _open(chatPane(session.id));
  }

  void _close(PaneRef pane) => _edit(() {
    _layout.close(pane);
    _versions.remove(pane);
  });

  Future<void> _pick({bool split = false}) async {
    final items = <PaneRef>{
      if (split) ..._layout.tabs,
      for (final id in _roster.keys) chatPane(id),
    }..removeWhere((r) => split && r == _primary);
    final ref = await pickWorkspaceItem(
      context,
      split
          ? context
                .sharedL10n
                .release_core_parallel_workspace_dock_beside_current_pane
          : context.sharedL10n.release_core_parallel_workspace_add_chat,
      [
        for (final ref in items)
          (value: ref, label: _title(ref), detail: ref.sessionId),
      ],
    );
    if (_current && ref != null) _open(ref, split: split);
  }

  WorkspaceTarget _target(String id, {PaneRef? owner}) {
    final row = _roster[id];
    final version = owner == null ? null : _version(owner);
    return WorkspaceTarget(
      widget.connection,
      row,
      widget.nextGen,
      () =>
          _current &&
          (owner == null || identical(version, _versions[owner])) &&
          (id.isEmpty || (row != null && identical(_roster[id], row))),
      row == null ? null : _link(id),
    );
  }

  Future<void> _run(WorkspaceContribution item, WorkspaceTarget target) async {
    if (!_current) return;
    final reason = item.reason(target);
    if (reason != null) {
      _message(reason);
      return;
    }
    switch (item) {
      case WorkspacePage():
        _open((
          sessionId: item.requiresSession ? target.session!.id : '',
          page: item.id,
        ), split: _primary != null);
      case WorkspaceAction():
        try {
          await item.run(context, target);
        } catch (_) {
          if (mounted && _current) {
            _message(
              context
                  .sharedL10n
                  .release_core_parallel_workspace_action_failed_check_the_connection_and_try_again,
            );
          }
        }
    }
  }

  Future<void> _command(_Command command) async {
    final l10n = context.sharedL10n;
    final p = _primary;
    switch (command) {
      case _Command.split:
        await _pick(split: true);
      case _Command.swap:
        if (_layout.secondary case final s?) _open(s);
      case _Command.undock:
        _edit(() => _layout.secondary = null);
      case _Command.stack:
        _edit(() => _layout.stacked = !_layout.stacked);
      case _Command.ratio:
        _edit(
          () => _layout.percent = switch (_layout.percent) {
            50 => 60,
            60 => 40,
            _ => 50,
          },
        );
      case _Command.focus:
        setState(() => _focus = true);
      case _Command.hide:
        if (p != null) _edit(() => _layout.hide(p));
      case _Command.reload:
        if (p != null) _edit(() => _versions[p] = Object());
      case _Command.previous:
        _edit(() => _layout.cycle(-1));
      case _Command.next:
        _edit(() => _layout.cycle(1));
      case _Command.moveLeft:
        if (p != null) _edit(() => _layout.move(p, -1));
      case _Command.moveRight:
        if (p != null) _edit(() => _layout.move(p, 1));
      case _Command.close:
        if (p != null) _close(p);
      case _Command.others || _Command.right || _Command.all:
        final tabs = _layout.tabs.toList();
        final remove = switch (command) {
          _Command.others => tabs.where((r) => r != p),
          _Command.right => tabs.skip(tabs.indexOf(p!) + 1),
          _ => tabs,
        };
        _edit(() {
          for (final r in remove.toList().reversed) {
            _layout.close(r);
            _versions.remove(r);
          }
        });
      case _Command.reopen:
        _edit(() {
          if (!_layout.reopen()) {
            _message(
              l10n.release_core_parallel_workspace_close_a_tab_before_reopening_another,
            );
          }
        });
      case _Command.save:
        final name = await nameWorkspaceLayout(context);
        if (!mounted || !_current || name == null) return;
        if (_layout.saved.containsKey(name)) {
          final overwrite = await showDialog<bool>(
            context: context,
            useRootNavigator: false,
            builder: (context) => AlertDialog(
              title: Text(
                l10n.release_core_parallel_workspace_replace_layout(
                  (name).toString(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.replace),
                ),
              ],
            ),
          );
          if (overwrite != true || !_current) return;
        }
        _edit(() {
          if (!_layout.save(name)) {
            _message(
              l10n.release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout,
            );
          }
        });
      case _Command.restore:
        final name = await pickWorkspaceItem(
          context,
          l10n.release_core_parallel_workspace_restore_layout,
          [
            for (final name in _layout.saved.keys)
              (value: name, label: name, detail: ''),
          ],
        );
        if (_current && name != null) _edit(() => _layout.restore(name));
      case _Command.refresh:
        _refresh();
      case _Command.popout:
        if (p != null && p.page.isEmpty && _roster.containsKey(p.sessionId)) {
          await openWorkspacePopout(
            context,
            sessionId: p.sessionId,
            connectionId: widget.connection.id,
            profile: widget.connection.gatewayProfile ?? '',
            nextGen: widget.nextGen,
          );
        }
    }
  }

  Widget _menu() {
    final p = _primary, pair = _layout.secondary != null, tabs = _layout.tabs;
    PopupMenuItem<_Command> item(
      _Command cmd,
      String label, [
      bool enabled = true,
    ]) => PopupMenuItem(value: cmd, enabled: enabled, child: Text(label));
    return PopupMenuButton<_Command>(
      tooltip:
          context.sharedL10n.release_core_parallel_workspace_workspace_options,
      onSelected: _command,
      itemBuilder: (_) => [
        item(
          _Command.split,
          context.sharedL10n.release_core_parallel_workspace_dock_another_pane,
          p != null,
        ),
        item(
          _Command.swap,
          context.sharedL10n.release_core_parallel_workspace_swap_panes,
          pair,
        ),
        item(
          _Command.undock,
          context.sharedL10n.release_core_parallel_workspace_undock_second_pane,
          pair,
        ),
        item(
          _Command.stack,
          _layout.stacked
              ? context
                    .sharedL10n
                    .release_core_parallel_workspace_arrange_side_by_side
              : context
                    .sharedL10n
                    .release_core_parallel_workspace_arrange_top_to_bottom,
          pair,
        ),
        item(
          _Command.ratio,
          context.sharedL10n.release_core_parallel_workspace_change_split_size(
            (_layout.percent).toString(),
          ),
          pair,
        ),
        item(
          _Command.focus,
          context
              .sharedL10n
              .release_core_parallel_workspace_focus_pane_full_screen,
          p != null,
        ),
        if (supportsWorkspacePopout)
          item(
            _Command.popout,
            context
                .sharedL10n
                .release_core_parallel_workspace_open_chat_in_new_window,
            p != null && p.page.isEmpty && _roster.containsKey(p.sessionId),
          ),
        item(
          _Command.hide,
          context
              .sharedL10n
              .release_core_parallel_workspace_hide_pane_keep_running,
          p != null,
        ),
        item(
          _Command.previous,
          context.sharedL10n.release_core_parallel_workspace_previous_tab,
          tabs.length > 1,
        ),
        item(
          _Command.next,
          context.sharedL10n.release_core_parallel_workspace_next_tab,
          tabs.length > 1,
        ),
        item(
          _Command.moveLeft,
          context.sharedL10n.release_core_parallel_workspace_move_tab_left,
          p != null && tabs.indexOf(p) > 0,
        ),
        item(
          _Command.moveRight,
          context.sharedL10n.release_core_parallel_workspace_move_tab_right,
          p != null && tabs.indexOf(p) < tabs.length - 1,
        ),
        item(
          _Command.reload,
          context.sharedL10n.release_core_parallel_workspace_reload_current_tab,
          p != null,
        ),
        item(
          _Command.close,
          context.sharedL10n.release_core_parallel_workspace_close_tab,
          p != null,
        ),
        item(
          _Command.others,
          context.sharedL10n.release_core_parallel_workspace_close_other_tabs,
          p != null && tabs.length > 1,
        ),
        item(
          _Command.right,
          context
              .sharedL10n
              .release_core_parallel_workspace_close_tabs_to_the_right,
          p != null && tabs.indexOf(p) < tabs.length - 1,
        ),
        item(
          _Command.all,
          context.sharedL10n.release_core_parallel_workspace_close_all_tabs,
          tabs.isNotEmpty,
        ),
        item(
          _Command.reopen,
          context.sharedL10n.release_core_parallel_workspace_reopen_closed_tab,
          _layout.closed.isNotEmpty,
        ),
        item(
          _Command.save,
          context.sharedL10n.release_core_parallel_workspace_save_named_layout,
          _prefs != null,
        ),
        item(
          _Command.restore,
          context
              .sharedL10n
              .release_core_parallel_workspace_restore_named_layout,
          _layout.saved.isNotEmpty,
        ),
        item(
          _Command.refresh,
          context.sharedL10n.release_core_parallel_workspace_refresh_chat_list,
          !_loading,
        ),
      ],
    );
  }

  Widget _tools() {
    final target = _target(_primary?.sessionId ?? '', owner: _primary);
    return PopupMenuButton<WorkspaceContribution>(
      tooltip:
          context.sharedL10n.release_core_parallel_workspace_workspace_tools,
      icon: const Icon(Icons.extension_outlined),
      onSelected: (c) => _run(c, target),
      itemBuilder: (_) => [
        for (final c in _registry.entries)
          PopupMenuItem(
            value: c,
            enabled: c.reason(target) == null,
            child: ListTile(
              leading: Icon(c.icon),
              title: Text(c.localizedLabel(context.sharedL10n)),
              subtitle: c.reason(target) == null
                  ? null
                  : Text(c.reason(target)!),
            ),
          ),
      ],
    );
  }

  Future<void> _chooseForSlot(PaneRef slot) async {
    final version = _version(slot);
    final rows = {
      for (final r in _roster.values)
        if (!_layout.tabs.contains(chatPane(r.id))) r.id: r,
    };
    final selected = await pickWorkspaceItem(
      context,
      context
          .sharedL10n
          .release_core_parallel_workspace_choose_a_chat_for_this_pane,
      [
        for (final r in rows.values)
          (value: r.id, label: r.title, detail: r.id),
      ],
    );
    if (!_current ||
        selected == null ||
        !identical(rows[selected], _roster[selected]) ||
        !identical(_versions[slot], version)) {
      return;
    }
    _edit(() => _layout.fillSlot(slot, selected));
  }

  Widget _content(BuildContext context, PaneRef ref) {
    if (isWorkspaceSlot(ref)) {
      return Center(
        child: TextButton.icon(
          onPressed: () => _chooseForSlot(ref),
          icon: const Icon(Icons.add_comment_outlined),
          label: Text(
            context.sharedL10n.release_core_parallel_workspace_choose_chat_for(
              _title(ref),
            ),
          ),
        ),
      );
    }
    final row = _roster[ref.sessionId];
    if (ref.page.isEmpty && row != null) {
      return TerminalChatSlot(
        link: _link(row.id),
        child: widget.buildChat(context, row, () => _close(ref)),
      );
    }
    final page = _registry.page(ref.page);
    if (page != null) {
      final target = _target(ref.sessionId, owner: ref);
      final reason = page.reason(target);
      if (reason == null) {
        return Builder(builder: (ctx) => page.build(ctx, target));
      }
    }
    return Center(
      child: Text(
        ref.page.isEmpty
            ? context.sharedL10n.release_core_workspace_chat_unavailable
            : context.sharedL10n.release_core_workspace_page_unavailable,
      ),
    );
  }

  Widget _panes(BoxConstraints box, {required bool typing}) {
    final p = _primary, s = _layout.secondary;
    final vertical = _layout.stacked;
    final minSide =
        (vertical ? box.maxHeight : box.maxWidth) *
        (_layout.percent <= 50 ? _layout.percent : 100 - _layout.percent) /
        100;
    final both =
        !_focus &&
        s != null &&
        (vertical ? minSide >= 340 && box.maxWidth >= 360 : minSide >= 440);
    // The keyboard can squeeze a stacked pair down to one pane. The pane
    // being typed in stays the one shown, or its field would lose focus
    // (and the keyboard close) the moment the keyboard opened.
    final shown = !both && typing && s != null && _lastTouched == s ? s : p;
    final first =
        (vertical ? box.maxHeight : box.maxWidth) * _layout.percent / 100;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (p == null)
          Center(
            child: Text(
              _layout.tabs.isEmpty
                  ? context
                        .sharedL10n
                        .release_core_parallel_workspace_add_a_chat_to_start_a_workspace
                  : context
                        .sharedL10n
                        .release_core_parallel_workspace_select_a_tab_to_show_its_pane,
            ),
          ),
        for (final ref in _layout.tabs)
          Positioned(
            key: ValueKey(ref),
            left: both && !vertical && ref == s ? first + 1 : 0,
            right: both && !vertical && ref == p ? box.maxWidth - first : 0,
            top: both && vertical && ref == s ? first + 1 : 0,
            bottom: both && vertical && ref == p ? box.maxHeight - first : 0,
            child: Offstage(
              offstage: ref != shown && !(both && ref == s),
              child: ExcludeFocus(
                excluding: ref != shown && !(both && ref == s),
                child: TickerMode(
                  enabled: ref == shown || (both && ref == s),
                  child: LayoutBuilder(
                    builder: (ctx, local) => MediaQuery(
                      data: MediaQuery.of(ctx).copyWith(size: local.biggest),
                      child: Listener(
                        onPointerDown: (_) {
                          if (_lastTouched != ref) {
                            setState(() => _lastTouched = ref);
                          }
                        },
                        child: WorkspacePane(
                          key: ObjectKey(_version(ref)),
                          handleBack:
                              ref == (both && _lastTouched == s ? s : shown),
                          child: Builder(builder: (ctx) => _content(ctx, ref)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) =>
      _WorkspaceOpener(openSession: _openSession, child: _build(context));

  /// The Scaffold resizes the panes for the keyboard. With little room left
  /// above it, the tab strip and pane switcher fold away while typing (and,
  /// on a landscape phone, the workspace bar too), so a pane's composer is
  /// never pushed under the keyboard. They come back when it closes.
  Widget _build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final typing = keyboardHeightOf(context) > 0;
      final room =
          box.maxHeight -
          MediaQuery.viewInsetsOf(context).bottom -
          MediaQuery.paddingOf(context).top;
      return _scaffold(
        context,
        typing: typing,
        foldStrip: typing && room < foldWorkspaceStripBelow,
        foldBar: typing && room < foldWorkspaceBarBelow,
      );
    },
  );

  Widget _scaffold(
    BuildContext context, {
    required bool typing,
    required bool foldStrip,
    required bool foldBar,
  }) {
    final p = _primary;
    return Scaffold(
      appBar: foldBar
          ? null
          : AppBar(
              title: Text(
                _focus && p != null
                    ? _title(p)
                    : context
                          .sharedL10n
                          .release_core_parallel_workspace_parallel_workspace,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: _focus
                  ? IconButton(
                      tooltip: context
                          .sharedL10n
                          .release_core_parallel_workspace_show_workspace,
                      icon: const Icon(Icons.fullscreen_exit),
                      onPressed: () => setState(() => _focus = false),
                    )
                  : null,
              actions: _focus
                  ? null
                  : [
                      IconButton(
                        tooltip: context
                            .sharedL10n
                            .release_core_parallel_workspace_add_chat,
                        icon: const Icon(Icons.add_comment_outlined),
                        onPressed: _prefs == null ? null : () => _pick(),
                      ),
                      _tools(),
                      _menu(),
                    ],
            ),
      body: SafeArea(
        // With the bar folded, the body keeps clear of the status bar.
        top: foldBar,
        child: Column(
          children: [
            if (_loading) const LinearProgressIndicator(),
            if (_failed && !foldStrip)
              TextButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: Text(
                  context
                      .sharedL10n
                      .release_core_parallel_workspace_could_not_load_chats_retry,
                ),
              ),
            if (!_focus && !foldStrip && _layout.tabs.isNotEmpty)
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final ref in _layout.tabs)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: InputChip(
                          selected: p == ref,
                          label: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Text(
                              _title(ref),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          avatar: ref == _layout.secondary
                              ? const Icon(Icons.splitscreen, size: 16)
                              : null,
                          onPressed: () => _open(ref),
                          onDeleted: () => _close(ref),
                          deleteButtonTooltipMessage: context.sharedL10n
                              .release_core_parallel_workspace_close(
                                (_title(ref)).toString(),
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            if (_layout.secondary case final s? when !_focus && !foldStrip)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: () => _open(s),
                  icon: const Icon(Icons.swap_horiz),
                  label: Text(
                    context.sharedL10n
                        .release_core_parallel_workspace_switch_pane(
                          (_title(s)).toString(),
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            Expanded(
              child: LayoutBuilder(
                builder: (_, box) => _panes(box, typing: typing),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
