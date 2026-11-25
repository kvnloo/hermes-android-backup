// The NextGen sidebar (Kyllene's session drawer): search, shortcut tiles,
// pinned chats, All / Running / Needs you filters and the gateway switcher.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hermes_android/core/l10n/l10n.dart';

import '../../core/models/session.dart';
import '../../core/services/dashboard_api_client.dart';
import '../../core/utils/session_sources.dart';
import '../data/seen_chats.dart';
import '../theme/nextgen_theme.dart';
import 'nextgen_scope.dart';
import 'widgets.dart';
import '../nextgen_l10n.dart';

enum NgSidebarFilter { all, running, needsYou, crons }

/// How a chat row is highlighted, most urgent first: orange while the agent
/// waits on a question or approval, green when it finished with a reply
/// unread, blue while it runs with updates unread.
enum NgChatAttention { waiting, finished, updates, none }

enum NgDestination {
  scheduled,
  insights,
  capabilities,
  archived,
  more,
  settings,
}

/// Holds the sidebar's session list so it survives the drawer closing.
class NgSessionsModel extends ChangeNotifier {
  NgSessionsModel(NgScope scope) : _scope = scope {
    _listen();
  }

  NgScope _scope;
  NgScope get scope => _scope;
  set scope(NgScope value) {
    if (identical(value.gateway, _scope.gateway) &&
        value.connection.id == _scope.connection.id) {
      _scope = value;
      return;
    }
    _generation++;
    _scope = value;
    _seen = null;
    _showSubagents = null;
    sessions = [];
    _serverOffset = 0;
    hasMore = false;
    _listen();
  }

  List<Session> sessions = [];

  bool _browsingCrons = false;
  bool? _showSubagents;

  /// Search retains its existing source scope. Normal chat presentation and
  /// filling share one policy, including badges and attention summaries.
  bool includesChat(Session session) =>
      !isCronSession(session) &&
      (query.isNotEmpty ||
          !isInternalListingSession(session, showSubagents: _showSubagents));

  void browseCrons(bool value) {
    if (_browsingCrons == value) return;
    _browsingCrons = value;
    _generation++;
    unawaited(refresh());
  }

  /// The chat on screen: never unread while it's shown.
  String? currentId;

  NgSeenStore? _seen;
  NgSeenStore get seen =>
      _seen ??= NgSeenStore(scope.prefs, scope.connection.id);

  StreamSubscription<dynamic>? _changes;
  Timer? _changedDebounce;

  /// When true (app backgrounded), socket-driven refreshes are suppressed.
  bool paused = false;

  /// Whether the sidebar drawer is open: use a shorter debounce when visible.
  bool drawerOpen = false;

  /// Another client (or a background turn) moved the gateway's chats on:
  /// read the list again so new progress shows as unread. Throttled to avoid
  /// 1 Hz HTTP churn while multiple chats stream.
  void _listen() {
    _changes?.cancel();
    _changes = scope.gateway.events.listen((event) {
      if (event.type != 'sessions.changed' && event.type != 'session.title') {
        return;
      }
      if (paused) return;
      _changedDebounce?.cancel();
      final delay = drawerOpen
          ? const Duration(seconds: 2)
          : const Duration(seconds: 5);
      _changedDebounce = Timer(delay, refresh);
    });
  }

  /// Whether [s] has progress the user hasn't seen (Kyllene's unread mark).
  bool isUnread(Session s) => s.id != currentId && seen.chats.isUnread(s);

  /// The highlight [s] gets in the list.
  NgChatAttention attentionOf(Session s, {Set<String>? needsYou}) {
    if ((needsYou ?? scope.gateway.needsYou).contains(s.id)) {
      return NgChatAttention.waiting;
    }
    if (!isUnread(s)) return NgChatAttention.none;
    return s.isActive ? NgChatAttention.updates : NgChatAttention.finished;
  }

  /// Chats besides the one on screen with something to see, for the badge.
  int get unreadCount => sessions
      .where(
        (s) =>
            includesChat(s) &&
            s.id != currentId &&
            attentionOf(s) != NgChatAttention.none,
      )
      .length;

  /// The most urgent highlight among chats besides the one on screen.
  NgChatAttention get topAttention {
    final needsYou = scope.gateway.needsYou;
    var top = NgChatAttention.none;
    for (final s in sessions) {
      if (!includesChat(s) || s.id == currentId) continue;
      final a = attentionOf(s, needsYou: needsYou);
      if (a.index < top.index) top = a;
    }
    return top;
  }

  /// Records the user saw [id] up to now (or its newest activity), clearing
  /// the gateway's shared unread mark too when it keeps one.
  void markRead(String? id, {bool running = false}) {
    if (id == null || id.isEmpty) return;
    final i = sessions.indexWhere((s) => s.id == id);
    final row = i >= 0 ? sessions[i] : null;
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final activity = row == null
        ? 0.0
        : (row.lastActive > 0 ? row.lastActive : row.startedAt);
    seen.markLooked(id, activity > now ? activity : now, running: running);
    if (row != null && (row.unread || row.lastReadAt != null)) {
      sessions[i] = row.withReadState(unread: false, lastReadAt: now);
      if (row.unread || (row.lastReadAt ?? 0) < activity) {
        unawaited(
          scope.gateway.api
              .setSessionUnread(id, unread: false)
              .catchError((_) {}),
        );
      }
    }
    notifyListeners();
  }

  /// Marks [s] unread here and, when the gateway keeps read state, for every
  /// client.
  void markUnread(Session s) {
    seen.markUnread(s.id);
    final i = sessions.indexWhere((e) => e.id == s.id);
    if (i >= 0 && s.lastReadAt != null) {
      sessions[i] = s.withReadState(unread: true, lastReadAt: 0);
      unawaited(
        scope.gateway.api
            .setSessionUnread(s.id, unread: true)
            .catchError((_) {}),
      );
    }
    notifyListeners();
  }

  bool loading = false;
  bool hasMore = false;

  /// One server page. Browse reads several when cron or internal runs fill
  /// an older server's first pages with rows the chat list hides.
  static const int _pageSize = 60;

  /// Stop filling once the chat list has this many rows to show.
  static const int _targetChats = 20;

  /// Hard bound on one refresh so a cron-heavy store cannot turn it into an
  /// unbounded scan; Load more continues past it.
  static const int _maxRefreshPages = 10;

  /// Raw rows consumed from the current server scope. Shell suppression and
  /// visible-source filtering must never be used as a server offset.
  int _serverOffset = 0;

  String? error;
  String query = '';
  Timer? _debounce;
  int _generation = 0;
  Future<void>? _refreshing;
  bool _refreshPending = false;

  /// Coalesces bursts from lifecycle, drawer and socket events into one active
  /// request and at most one trailing request with the latest query.
  Future<void> refresh() {
    _refreshPending = true;
    return _refreshing ??= _drainRefreshes();
  }

  Future<void> _drainRefreshes() async {
    try {
      while (_refreshPending) {
        _refreshPending = false;
        await _refreshOnce();
      }
    } finally {
      _refreshing = null;
    }
  }

  Future<void> _refreshOnce() async {
    final generation = ++_generation;
    final api = scope.gateway.api;
    final browsingCrons = _browsingCrons;
    loading = true;
    error = null;
    notifyListeners();
    try {
      if (query.isNotEmpty) {
        // Search is one server-side read; it does not page.
        final page = await api.getSessionsPage(limit: _pageSize, title: query);
        if (generation != _generation) return;
        sessions = page.sessions.where((s) => !s.isUntitledCronShell).toList();
        _serverOffset = 0;
        hasMore = false;
      } else {
        // A profile-local read preserves the gateway's Show subagents choice
        // even on servers that ignore exclude_sources. Never write config.
        if (!browsingCrons) {
          final showSubagents = await api.showSubagentSessions();
          if (generation != _generation) return;
          _showSubagents = showSubagents;
        }
        // Older gateways may ignore exclusions. Count only visible rows, but
        // advance through raw windows so machine-heavy pages cannot starve
        // real chats (#297, #362). Crons retains its unfiltered transport.
        final collected = <Session>[];
        final seenIds = <String>{};
        var offset = 0;
        var pages = 0;
        var more = false;
        while (pages < _maxRefreshPages) {
          final page = await api.getSessionsPage(
            limit: _pageSize,
            offset: offset,
            excludeSources: browsingCrons ? null : kChatListingExcludedSources,
          );
          if (generation != _generation) return;
          pages++;
          offset += page.sessions.length;
          for (final s in page.sessions) {
            if (s.isUntitledCronShell || !seenIds.add(s.id)) continue;
            collected.add(s);
          }
          more = page.hasMore;
          if (!more || page.sessions.isEmpty) break;
          final visible = collected
              .where(browsingCrons ? isCronSession : includesChat)
              .length;
          if (visible >= _targetChats) break;
        }
        if (generation != _generation) return;
        sessions = collected;
        _serverOffset = offset;
        hasMore = more;
      }
      // The chat on screen is read through whatever the list now says.
      final current = currentId;
      if (current != null) {
        final row = sessions.where((s) => s.id == current).firstOrNull;
        if (row != null && seen.chats.isUnread(row)) {
          markRead(current);
        }
      }
    } catch (e) {
      if (generation != _generation) return;
      error = '$e'.replaceFirst('Exception: ', '');
    } finally {
      if (generation == _generation) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadMore() async {
    if (loading || !hasMore || query.isNotEmpty) return;
    final generation = _generation;
    loading = true;
    notifyListeners();
    try {
      final api = scope.gateway.api;
      final browsingCrons = _browsingCrons;
      final collected = [...sessions];
      final known = collected.map((s) => s.id).toSet();
      var addedVisible = 0;
      for (var pages = 0; pages < _maxRefreshPages; pages++) {
        final page = await api.getSessionsPage(
          limit: _pageSize,
          offset: _serverOffset,
          excludeSources: browsingCrons ? null : kChatListingExcludedSources,
        );
        if (generation != _generation) return;
        _serverOffset += page.sessions.length;
        for (final session in page.sessions) {
          if (session.isUntitledCronShell || !known.add(session.id)) continue;
          collected.add(session);
          if (browsingCrons ? isCronSession(session) : includesChat(session)) {
            addedVisible++;
          }
        }
        sessions = [...collected];
        hasMore = page.sessions.isNotEmpty && page.hasMore;
        if (!hasMore || addedVisible >= _targetChats) break;
      }
    } catch (_) {
      if (generation != _generation) return;
      hasMore = false;
    } finally {
      if (generation == _generation) {
        loading = false;
        notifyListeners();
      }
    }
  }

  void search(String value) {
    query = value.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), refresh);
  }

  void clearSearch() {
    _debounce?.cancel();
    query = '';
    unawaited(refresh());
  }

  void replace(Session updated) {
    final i = sessions.indexWhere((s) => s.id == updated.id);
    if (i >= 0) {
      sessions[i] = updated;
      notifyListeners();
    }
  }

  void remove(String id) {
    sessions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  @override
  void dispose() {
    _generation++;
    _refreshPending = false;
    _debounce?.cancel();
    _changedDebounce?.cancel();
    _changes?.cancel();
    super.dispose();
  }
}

String ngSessionTitle(Session s) {
  if (s.title.trim().isNotEmpty) return s.title.trim();
  if (s.preview.trim().isNotEmpty) return s.preview.trim();
  return ngL.ng_new_chat;
}

DateTime? ngSessionTime(Session s) {
  final t = s.lastActive > 0 ? s.lastActive : s.startedAt;
  if (t <= 0) return null;
  return DateTime.fromMillisecondsSinceEpoch((t * 1000).round());
}

/// One of a chat row's actions: the value [_NgSessionsSidebarState] runs,
/// and how both the long-press sheet and the desktop menu show it.
typedef _NgChatAction = ({
  String value,
  IconData icon,
  String label,
  bool danger,
});

/// Desktop platforms, where a mouse is the main pointer: the open chat's row
/// keeps its ⋯ button in view there.
bool get _desktopPointer => switch (defaultTargetPlatform) {
  TargetPlatform.windows ||
  TargetPlatform.macOS ||
  TargetPlatform.linux => true,
  TargetPlatform.android ||
  TargetPlatform.iOS ||
  TargetPlatform.fuchsia => false,
};

class NgSessionsSidebar extends StatefulWidget {
  const NgSessionsSidebar({
    super.key,
    required this.model,
    required this.currentSessionId,
    required this.onOpen,
    required this.onNewChat,
    required this.onDestination,
    this.docked = false,
  });

  final NgSessionsModel model;
  final String? currentSessionId;
  final ValueChanged<Session> onOpen;
  final VoidCallback onNewChat;
  final ValueChanged<NgDestination> onDestination;

  /// When true the sidebar renders as a persistent docked pane (wide windows)
  /// rather than a modal [Drawer]. The search/filter/scroll state is identical
  /// in both modes so resizing across the breakpoint preserves it.
  final bool docked;

  @override
  State<NgSessionsSidebar> createState() => _NgSessionsSidebarState();
}

class _NgSessionsSidebarState extends State<NgSessionsSidebar> {
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  final _scroll = ScrollController();
  NgSidebarFilter _filter = NgSidebarFilter.all;

  @override
  void initState() {
    super.initState();
    _search.text = widget.model.query;
    // The model and its server cursor outlive the drawer. Reopening it must
    // not show All while still paging the unfiltered Crons authority.
    _filter = widget.model._browsingCrons
        ? NgSidebarFilter.crons
        : NgSidebarFilter.all;
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 400) widget.model.loadMore();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// The actions offered for [s], in order. The long-press sheet and the
  /// mouse/keyboard menu both show exactly these.
  List<_NgChatAction> _actionItems(Session s) {
    final unread = widget.model.isUnread(s);
    return [
      if (s.pinKnown)
        (
          value: 'pin',
          icon: s.pinned ? Icons.push_pin_outlined : Icons.push_pin,
          label: s.pinned ? ngL.ng_unpin : ngL.ng_pin,
          danger: false,
        ),
      if (s.id != widget.currentSessionId)
        (
          value: 'read',
          icon: unread
              ? Icons.mark_chat_read_outlined
              : Icons.mark_chat_unread_outlined,
          label: unread ? ngL.ng_mark_as_read : ngL.ng_mark_as_unread,
          danger: false,
        ),
      (
        value: 'rename',
        icon: Icons.edit_outlined,
        label: ngL.ng_rename,
        danger: false,
      ),
      (
        value: 'archive',
        icon: Icons.archive_outlined,
        label: ngL.ng_archive,
        danger: false,
      ),
      (
        value: 'delete',
        icon: Icons.delete_outline,
        label: ngL.ng_delete,
        danger: true,
      ),
    ];
  }

  /// Opens [s]'s actions: a menu at the global point [at] for a mouse or
  /// keyboard, otherwise (long-press) the bottom sheet.
  Future<void> _actions(Session s, {Offset? at}) async {
    final api = NgScope.of(context).gateway.api;
    final choice = at == null
        ? await _actionSheet(s)
        : await _actionMenu(s, at);
    if (!mounted || choice == null) return;
    await _runAction(s, choice, api);
  }

  Future<String?> _actionSheet(Session s) {
    final c = NgColors.of(context);
    return showNgSheet<String>(
      context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(
                ngSessionTitle(s),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: NgType.heading.copyWith(color: c.text),
              ),
            ),
            for (final a in _actionItems(s))
              ListTile(
                leading: Icon(a.icon, color: a.danger ? c.danger : null),
                title: Text(
                  a.label,
                  style: a.danger ? TextStyle(color: c.danger) : null,
                ),
                onTap: () => Navigator.pop(context, a.value),
              ),
          ],
        ),
      ),
    );
  }

  /// The desktop presentation: a compact menu anchored at [at].
  Future<String?> _actionMenu(Session s, Offset at) {
    final c = NgColors.of(context);
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    return showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        overlay.globalToLocal(at) & Size.zero,
        Offset.zero & overlay.size,
      ),
      color: c.sheet,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NgRadii.md),
        side: BorderSide(color: c.stroke),
      ),
      items: [
        for (final a in _actionItems(s))
          PopupMenuItem<String>(
            value: a.value,
            height: 40,
            child: Row(
              children: [
                Icon(a.icon, size: 18, color: a.danger ? c.danger : c.text3),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    a.label,
                    style: NgType.bodySmall.copyWith(
                      color: a.danger ? c.danger : c.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _runAction(
    Session s,
    String choice,
    DashboardApiClient api,
  ) async {
    try {
      switch (choice) {
        case 'read':
          if (widget.model.isUnread(s)) {
            widget.model.markRead(s.id);
          } else {
            widget.model.markUnread(s);
          }
        case 'pin':
          await api.setSessionPinned(sessionId: s.id, pinned: !s.pinned);
          await widget.model.refresh();
        case 'rename':
          final title = await ngPromptText(
            context,
            title: ngL.ng_rename_chat,
            initial: ngSessionTitle(s),
          );
          if (title == null || title.trim().isEmpty) return;
          await api.renameSession(sessionId: s.id, title: title);
          await widget.model.refresh();
        case 'archive':
          await api.setSessionArchived(
            sessionId: s.id,
            archived: true,
            clearPin: true,
          );
          widget.model.remove(s.id);
          if (mounted) ngToast(context, ngL.ng_archived);
        case 'delete':
          final ok = await ngConfirm(
            context,
            title: ngL.ng_delete_this_chat,
            body: ngL.ng_it_is_removed_from_the_gateway,
          );
          if (!ok) return;
          await api.deleteSession(s.id);
          widget.model.remove(s.id);
      }
    } catch (e) {
      if (mounted) ngToast(context, '$e'.replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final scope = NgScope.of(context);
    final content = SafeArea(
      child: ListenableBuilder(
        listenable: Listenable.merge([widget.model, scope.gateway]),
        builder: (context, _) {
          final needsYou = scope.gateway.needsYou;
          final all = widget.model.sessions;
          final chats = all.where(widget.model.includesChat).toList();
          final filtered = switch (_filter) {
            NgSidebarFilter.all => chats,
            NgSidebarFilter.running => chats.where((s) => s.isActive).toList(),
            NgSidebarFilter.needsYou =>
              chats
                  .where(
                    (s) => needsYou.contains(s.id) || widget.model.isUnread(s),
                  )
                  .toList(),
            NgSidebarFilter.crons =>
              all.where((s) => isCronSession(s)).toList(),
          };
          final pinned =
              _filter == NgSidebarFilter.all && widget.model.query.isEmpty
              ? filtered.where((s) => s.pinned).toList()
              : <Session>[];
          final rest = filtered.where((s) => !pinned.contains(s)).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                child: TextField(
                  key: const Key('ng-session-search'),
                  controller: _search,
                  focusNode: _searchFocus,
                  onChanged: (value) {
                    widget.model.search(value);
                    setState(() {});
                  },
                  style: NgType.body.copyWith(color: c.text),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: c.input,
                    prefixIcon: Icon(Icons.search, color: c.text3, size: 20),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            key: const Key('ng-clear-search'),
                            tooltip:
                                AppLocalizations.of(context)?.clear_search ??
                                'Clear search',
                            icon: const Icon(Icons.clear, size: 18),
                            color: c.text3,
                            constraints: const BoxConstraints.tightFor(
                              width: 40,
                              height: 40,
                            ),
                            onPressed: () {
                              _search.clear();
                              widget.model.clearSearch();
                              _searchFocus.requestFocus();
                              setState(() {});
                            },
                          ),
                    hintText: ngL.ng_search_chats,
                    hintStyle: NgType.body.copyWith(color: c.textMuted),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(NgRadii.full),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: widget.model.refresh,
                  child: ListView(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 12),
                    children: [
                      _tiles(c),
                      const SizedBox(height: 8),
                      _filters(
                        c,
                        chats
                            .where(
                              (s) =>
                                  needsYou.contains(s.id) ||
                                  widget.model.isUnread(s),
                            )
                            .length,
                      ),
                      if (pinned.isNotEmpty) ...[
                        NgSectionLabel(ngL.ng_pinned),
                        for (final s in pinned) _tile(c, s, needsYou),
                      ],
                      if (pinned.isNotEmpty && rest.isNotEmpty)
                        NgSectionLabel(ngL.ng_recent),
                      if (widget.model.error != null && all.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            widget.model.error!,
                            style: NgType.bodySmall.copyWith(color: c.danger),
                          ),
                        )
                      else if (!widget.model.loading && filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            switch (_filter) {
                              _ when widget.model.query.isNotEmpty =>
                                ngL.ng_no_chats_match,
                              NgSidebarFilter.all => ngL.ng_no_chats_yet,
                              NgSidebarFilter.running =>
                                ngL.ng_nothing_is_running,
                              NgSidebarFilter.needsYou =>
                                ngL.ng_nothing_is_waiting_on_you,
                              NgSidebarFilter.crons =>
                                AppLocalizations.of(
                                      context,
                                    )?.cron_conversations_empty ??
                                    'Conversations from scheduled jobs appear here, including older runs.',
                            },
                            textAlign: TextAlign.center,
                            style: NgType.bodySmall.copyWith(color: c.text3),
                          ),
                        ),
                      for (final s in rest) _tile(c, s, needsYou),
                      // A short list has no scroll extent, so scroll-only
                      // paging cannot grow it; offer an explicit read on.
                      if (widget.model.hasMore &&
                          !widget.model.loading &&
                          widget.model.query.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Center(
                            child: TextButton.icon(
                              key: const Key('ng-sessions-load-more'),
                              onPressed: widget.model.loadMore,
                              icon: const Icon(Icons.expand_more, size: 18),
                              label: Text(
                                AppLocalizations.of(context)?.load_more ??
                                    'Load more…',
                              ),
                            ),
                          ),
                        ),
                      if (widget.model.loading)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              _footer(c, scope),
            ],
          );
        },
      ),
    );
    if (widget.docked) {
      return Material(
        color: c.sidebar,
        child: SizedBox(width: 330, child: content),
      );
    }
    return Drawer(
      backgroundColor: c.sidebar,
      width: 330,
      shape: const RoundedRectangleBorder(),
      child: content,
    );
  }

  Widget _tiles(NgColors c) {
    Widget tile(IconData icon, String label, NgDestination d) => Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Material(
          color: c.surface,
          borderRadius: BorderRadius.circular(NgRadii.md),
          child: InkWell(
            borderRadius: BorderRadius.circular(NgRadii.md),
            onTap: () => widget.onDestination(d),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Icon(icon, size: 20, color: c.text2),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: NgType.caption.copyWith(color: c.text2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return Column(
      children: [
        Row(
          children: [
            tile(Icons.schedule, ngL.ng_scheduled, NgDestination.scheduled),
            tile(
              Icons.insights_outlined,
              ngL.ng_insights,
              NgDestination.insights,
            ),
            tile(
              Icons.extension_outlined,
              ngL.ng_capabilities,
              NgDestination.capabilities,
            ),
          ],
        ),
        Row(
          children: [
            tile(
              Icons.archive_outlined,
              ngL.ng_archived,
              NgDestination.archived,
            ),
            tile(Icons.apps, ngL.ng_more, NgDestination.more),
            tile(
              Icons.settings_outlined,
              ngL.ng_settings,
              NgDestination.settings,
            ),
          ],
        ),
      ],
    );
  }

  Widget _filters(NgColors c, int waiting) {
    Widget chip(NgSidebarFilter f, String label) => Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: _filter == f,
        showCheckmark: false,
        labelStyle: NgType.label.copyWith(
          color: _filter == f ? c.text : c.text3,
        ),
        selectedColor: c.thumb,
        backgroundColor: Colors.transparent,
        side: BorderSide(color: _filter == f ? c.strokeStrong : c.stroke),
        shape: const StadiumBorder(),
        onSelected: (_) {
          setState(() => _filter = f);
          widget.model.browseCrons(f == NgSidebarFilter.crons);
        },
      ),
    );
    // Scrolls sideways when translated labels don't fit the drawer.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          chip(NgSidebarFilter.all, ngL.ng_all),
          chip(NgSidebarFilter.running, ngL.ng_running),
          chip(
            NgSidebarFilter.needsYou,
            waiting > 0 ? ngL.ng_needs_you(waiting) : ngL.ng_needs_you_2,
          ),
          chip(
            NgSidebarFilter.crons,
            AppLocalizations.of(context)?.crons ?? 'Crons',
          ),
        ],
      ),
    );
  }

  Widget _tile(NgColors c, Session s, Set<String> needsYou) {
    final selected = s.id == widget.currentSessionId;
    final waiting = needsYou.contains(s.id);
    final attention = selected
        ? NgChatAttention.none
        : widget.model.attentionOf(s, needsYou: needsYou);
    final marked = attention != NgChatAttention.none;
    final (Color tone, Color tint, String label) = switch (attention) {
      NgChatAttention.waiting => (
        c.warning,
        c.warningSoft,
        ngL.ng_hermes_is_waiting_for_you,
      ),
      NgChatAttention.finished => (
        c.success,
        c.successSoft,
        ngL.ng_unread_finished,
      ),
      NgChatAttention.updates => (
        c.accent,
        c.accentSoft,
        ngL.ng_unread_updates,
      ),
      NgChatAttention.none => (c.accent, Colors.transparent, ''),
    };
    final time = Text(
      ngAgo(ngSessionTime(s)),
      style: NgType.caption.copyWith(
        color: marked ? c.text2 : c.textMuted,
        fontWeight: marked ? FontWeight.w600 : null,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: _NgRowActions(
        alwaysShow: selected && _desktopPointer,
        onMenu: (at) => _actions(s, at: at),
        builder: (context, showMore, openMenu) => Material(
          key: ValueKey(
            'ng-session-${s.id}${marked ? '-${attention.name}' : ''}',
          ),
          color: selected ? c.surface2 : tint,
          borderRadius: BorderRadius.circular(NgRadii.sm),
          child: Stack(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(NgRadii.sm),
                onTap: () => widget.onOpen(s),
                onLongPress: () => _actions(s),
                onSecondaryTapUp: (d) => openMenu(d.globalPosition),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                  child: Row(
                    children: [
                      if (waiting)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.pan_tool_alt,
                            size: 15,
                            color: c.warning,
                          ),
                        )
                      else if (s.isActive)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.6,
                              color: c.accent,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          ngSessionTitle(s),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: NgType.label.copyWith(
                            color: selected || marked ? c.text : c.text2,
                            fontWeight: marked
                                ? FontWeight.w700
                                : selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // The ⋯ button takes the time's place rather than
                      // adding width, so the title never moves.
                      Visibility(
                        visible: !showMore,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: time,
                      ),
                      if (marked)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Semantics(
                            label: label,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: tone,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (showMore)
                Positioned(
                  top: 0,
                  bottom: 0,
                  // Over the time, clear of the unread dot.
                  right: marked ? 20 : 4,
                  child: Center(
                    child: Builder(
                      builder: (context) => IconButton(
                        key: ValueKey('ng-session-more-${s.id}'),
                        tooltip: ngL.chat_actions,
                        icon: const Icon(Icons.more_horiz),
                        iconSize: 18,
                        color: c.text2,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 28,
                          height: 28,
                        ),
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          final box = context.findRenderObject()! as RenderBox;
                          openMenu(
                            box.localToGlobal(box.size.bottomLeft(Offset.zero)),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footer(NgColors c, NgScope scope) {
    final state = scope.gateway.state;
    final tone = switch (state.phase) {
      _ when state.isConnected => c.success,
      _ => c.warning,
    };
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.stroke)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(NgRadii.md),
              onTap: () => _switcher(scope),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: tone,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scope.connection.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: NgType.label.copyWith(color: c.text),
                          ),
                          Text(
                            state.label,
                            style: NgType.caption.copyWith(color: c.text3),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.unfold_more, size: 18, color: c.text3),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: c.accent,
              foregroundColor: c.onAccent,
              shape: const StadiumBorder(),
            ),
            onPressed: widget.onNewChat,
            icon: const Icon(Icons.edit_square, size: 18),
            label: Text(ngL.ng_new_chat),
          ),
        ],
      ),
    );
  }

  Future<void> _switcher(NgScope scope) async {
    final c = NgColors.of(context);
    final picked = await showNgSheet<String>(
      context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ngL.ng_gateways,
                  style: NgType.title.copyWith(color: c.text),
                ),
              ),
            ),
            for (final conn in scope.connections)
              ListTile(
                leading: Icon(
                  conn.id == scope.connection.id
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: conn.id == scope.connection.id ? c.accent : c.text3,
                ),
                title: Text(conn.label),
                subtitle: Text(
                  conn.singleLogin
                      ? (conn.singleLoginUrl ?? conn.baseUrl)
                      : ngL.ng_classic_connection(conn.baseUrl),
                ),
                onTap: () => Navigator.pop(context, conn.id),
              ),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(ngL.ng_add_a_gateway),
              onTap: () => Navigator.pop(context, '+'),
            ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    if (picked == '+') {
      await scope.addGateway();
    } else if (picked != scope.connection.id) {
      await scope.switchTo(picked);
    }
  }
}

/// Tracks whether a chat row is under a mouse, holds keyboard focus or has
/// its menu open, which is when its ⋯ button shows, and opens the row's menu
/// from the keyboard (Shift+F10 or the context-menu key). Touch never hovers,
/// so a phone's rows look exactly as they did.
class _NgRowActions extends StatefulWidget {
  const _NgRowActions({
    required this.alwaysShow,
    required this.onMenu,
    required this.builder,
  });

  /// Show the ⋯ button even without hover or focus.
  final bool alwaysShow;

  /// Opens the row's menu at a global point and runs the chosen action.
  final Future<void> Function(Offset at) onMenu;

  /// Builds the row; `openMenu` opens its menu at a global point.
  final Widget Function(
    BuildContext context,
    bool showMore,
    ValueChanged<Offset> openMenu,
  )
  builder;

  @override
  State<_NgRowActions> createState() => _NgRowActionsState();
}

class _NgRowActionsState extends State<_NgRowActions> {
  bool _hovered = false;
  bool _focused = false;
  bool _menuOpen = false;

  void _update({bool? hovered, bool? focused, bool? menuOpen}) {
    if (!mounted) return;
    setState(() {
      _hovered = hovered ?? _hovered;
      _focused = focused ?? _focused;
      _menuOpen = menuOpen ?? _menuOpen;
    });
  }

  /// Keeps the ⋯ button up while its menu (and the chosen action) is open.
  Future<void> _openMenu(Offset at) async {
    _update(menuOpen: true);
    try {
      await widget.onMenu(at);
    } finally {
      _update(menuOpen: false);
    }
  }

  void _keyboardMenu() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    _openMenu(box.localToGlobal(box.size.bottomLeft(const Offset(12, 0))));
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => _update(hovered: true),
    onExit: (_) => _update(hovered: false),
    child: Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (focused) => _update(focused: focused),
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.f10, shift: true):
              _keyboardMenu,
          const SingleActivator(LogicalKeyboardKey.contextMenu): _keyboardMenu,
        },
        child: widget.builder(
          context,
          widget.alwaysShow || _hovered || _focused || _menuOpen,
          _openMenu,
        ),
      ),
    ),
  );
}
