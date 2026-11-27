// The Kanban rows a chat shows above its composer, in both layouts, and the
// way a tap opens the board. See docs/kanban-chat-dock.md.
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../screens/kanban_board_screen.dart';
import '../services/chat_kanban_dock.dart';
import '../services/connection_manager.dart';
import '../services/remote_workspace.dart';
import '../theme/hermes_theme.dart';
import '../utils/above_composer.dart';
import 'hermes_shell.dart' show HermesPaneVisibility;

/// Rows drawn before "show all" takes over.
const kanbanDockVisibleRows = 5;

/// A chat at least this wide opens the board as a pane beside itself; a
/// narrower one (a phone, a parallel pane) pushes the board as a route.
const kanbanPaneMinChatWidth = 900.0;
const kanbanPaneWidth = 420.0;

String kanbanStatusLabel(AppLocalizations l, String status) => switch (status) {
  'triage' => l.ng_kanban_status_triage,
  'todo' => l.ng_kanban_status_todo,
  'scheduled' => l.ng_kanban_status_scheduled,
  'ready' => l.ng_kanban_status_ready,
  'running' => l.ng_kanban_status_running,
  'blocked' => l.ng_kanban_status_blocked,
  'review' => l.ng_kanban_status_review,
  'done' => l.ng_kanban_status_done,
  'archived' => l.ng_kanban_status_archived,
  // A status this app does not know yet: the gateway's own word.
  _ => status,
};

String kanbanBlockReason(AppLocalizations l, ChatKanbanBlock block) =>
    switch (block) {
      ChatKanbanBlock.noDashboard => l.ng_kanban_block_no_dashboard,
      ChatKanbanBlock.unsupported => l.ng_kanban_block_unsupported,
      ChatKanbanBlock.denied => l.ng_kanban_block_denied,
      ChatKanbanBlock.insecure => l.ng_kanban_block_insecure,
      ChatKanbanBlock.unreachable => l.ng_kanban_block_unreachable,
      ChatKanbanBlock.stale => l.ng_kanban_block_stale,
    };

/// The collapsed row's words: how many cards, and how many are finished.
String kanbanDockLabel(AppLocalizations l, List<ChatKanbanCard> cards) {
  final settled = cards.where((card) => card.settled).length;
  return [
    l.ng_dock_kanban(cards.length),
    if (settled > 0) l.ng_dock_kanban_done(settled),
  ].join(' · ');
}

IconData kanbanStatusIcon(String status) => switch (status) {
  'triage' => Icons.inbox_outlined,
  'todo' => Icons.radio_button_unchecked,
  'scheduled' => Icons.schedule,
  'ready' => Icons.play_circle_outline,
  'running' => Icons.sync,
  'blocked' => Icons.pause_circle_outline,
  'review' => Icons.rate_review_outlined,
  'done' => Icons.check_circle,
  'archived' => Icons.inventory_2_outlined,
  _ => Icons.circle_outlined,
};

/// The type and colours one layout draws the rows with.
@immutable
class KanbanDockStyle {
  const KanbanDockStyle({
    required this.title,
    required this.meta,
    required this.text,
    required this.dim,
    required this.accent,
    required this.success,
    required this.warning,
    required this.danger,
  });

  /// Classic's, from its theme tokens.
  factory KanbanDockStyle.classic(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = HermesTokens.of(context);
    return KanbanDockStyle(
      title: theme.textTheme.bodyMedium ?? const TextStyle(),
      meta: theme.textTheme.bodySmall ?? const TextStyle(),
      text: tokens.onSurface,
      dim: tokens.muted,
      accent: tokens.running,
      success: tokens.success,
      warning: tokens.warning,
      danger: tokens.danger,
    );
  }

  final TextStyle title;
  final TextStyle meta;
  final Color text;

  /// Finished cards and secondary text.
  final Color dim;
  final Color accent;
  final Color success;
  final Color warning;
  final Color danger;

  Color statusColor(ChatKanbanCard card) => switch (card.status) {
    'running' => accent,
    'blocked' => danger,
    'review' || 'scheduled' => warning,
    'done' => success,
    _ => dim,
  };
}

/// A dot per card, coloured by status, for the folded row.
class KanbanDockDots extends StatelessWidget {
  const KanbanDockDots({super.key, required this.cards, required this.style});
  final List<ChatKanbanCard> cards;
  final KanbanDockStyle style;

  @override
  Widget build(BuildContext context) {
    const max = 4;
    final extra = cards.length - max;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final card in cards.take(max))
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: style.statusColor(card),
            ),
          ),
        if (extra > 0)
          Text('+$extra', style: style.meta.copyWith(color: style.dim)),
      ],
    );
  }
}

/// The open section: a row per card, "show all" beyond
/// [kanbanDockVisibleRows], and why the board is unavailable when it is.
class KanbanDockRows extends StatelessWidget {
  const KanbanDockRows({
    super.key,
    required this.dock,
    required this.style,
    required this.onOpen,
    required this.onShowAll,
  });
  final ChatKanbanDockController dock;
  final KanbanDockStyle style;
  final ValueChanged<ChatKanbanCard> onOpen;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final cards = dock.cards;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final card in cards.take(kanbanDockVisibleRows))
          _KanbanDockRow(
            key: ValueKey('kanban-dock-row-${card.board ?? ''}/${card.id}'),
            card: card,
            style: style,
            onOpen: () => onOpen(card),
            onDismiss: () => dock.dismiss(card),
          ),
        if (cards.length > kanbanDockVisibleRows)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              key: const ValueKey('kanban-dock-show-all'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                visualDensity: VisualDensity.compact,
              ),
              onPressed: onShowAll,
              child: Text(l.ng_kanban_show_all(cards.length)),
            ),
          ),
        if (dock.block case final block?)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              kanbanBlockReason(l, block),
              key: const ValueKey('kanban-dock-reason'),
              style: style.meta.copyWith(color: style.warning),
            ),
          ),
      ],
    );
  }
}

class _KanbanDockRow extends StatelessWidget {
  const _KanbanDockRow({
    super.key,
    required this.card,
    required this.style,
    required this.onOpen,
    required this.onDismiss,
  });
  final ChatKanbanCard card;
  final KanbanDockStyle style;
  final VoidCallback onOpen;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final status = kanbanStatusLabel(l, card.status);
    // A card nothing has reported on yet has no status to show.
    final meta = [
      if (status.isNotEmpty) status,
      if (card.assignee case final assignee?) '@$assignee',
    ].join(' · ');
    return Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            label: l.ng_kanban_open_card(card.title),
            value: meta.isEmpty ? null : meta,
            onTap: onOpen,
            excludeSemantics: true,
            child: InkWell(
              key: ValueKey('kanban-dock-card-${card.id}'),
              onTap: onOpen,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 20,
                      child: Center(
                        child: Icon(
                          kanbanStatusIcon(card.status),
                          size: 15,
                          color: style.statusColor(card),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.title,
                            key: ValueKey('kanban-dock-title-${card.id}'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            // A finished card is dimmed, not hidden.
                            style: style.title.copyWith(
                              color: card.settled ? style.dim : style.text,
                            ),
                          ),
                          if (meta.isNotEmpty)
                            Text(
                              meta,
                              key: ValueKey('kanban-dock-meta-${card.id}'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: style.meta.copyWith(color: style.dim),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (card.settled)
          IconButton(
            key: ValueKey('kanban-dock-dismiss-${card.id}'),
            tooltip: l.dismiss,
            icon: Icon(Icons.close, size: 16, color: style.dim),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            onPressed: onDismiss,
          ),
      ],
    );
  }
}

/// Whether the chat around [context] is on screen: no route covers it (the
/// board the dock opened on a phone, a sheet, another screen), its pane is
/// the one shown (the Classic shell keeps visited panes in an
/// [IndexedStack] with their tickers running) and its tickers run (an
/// offstage route or tab). Each lookup makes a [State] that calls this from
/// `didChangeDependencies` hear when it changes.
bool kanbanDockOnScreen(BuildContext context) =>
    TickerMode.valuesOf(context).enabled &&
    ModalRoute.isCurrentOf(context) != false &&
    HermesPaneVisibility.of(context) &&
    Visibility.of(context);

/// Keeps a dock's [ChatKanbanDockController] attached only while the chat
/// is on screen ([kanbanDockOnScreen]): it reads the board only then
/// (docs/kanban-chat-dock.md, "Live status"). Leaving lets go of the
/// board's event stream or poll; coming back reads once and follows again.
mixin KanbanDockAttachment<T extends StatefulWidget> on State<T> {
  /// The controller the dock shows now, if any.
  ChatKanbanDockController? get attachedKanban;

  ChatKanbanDockController? _attachedKanban;
  bool _kanbanOnScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _kanbanOnScreen = kanbanDockOnScreen(context);
    _syncKanbanAttachment();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The widget may now show another chat's controller.
    _syncKanbanAttachment();
  }

  @override
  void dispose() {
    _attachedKanban?.detach();
    _attachedKanban = null;
    super.dispose();
  }

  void _syncKanbanAttachment() {
    final wanted = _kanbanOnScreen ? attachedKanban : null;
    if (identical(wanted, _attachedKanban)) return;
    _attachedKanban?.detach();
    _attachedKanban = wanted;
    wanted?.attach();
  }
}

/// Classic's Kanban strip above the composer: one row that folds open, as
/// the NextGen dock's sections do.
class ClassicKanbanDock extends StatefulWidget {
  const ClassicKanbanDock({
    super.key,
    required this.dock,
    required this.availableHeight,
    required this.onOpen,
    required this.onShowAll,
  });
  final ChatKanbanDockController dock;

  /// The chat body's height (keyboard already removed).
  final double availableHeight;
  final ValueChanged<ChatKanbanCard> onOpen;
  final VoidCallback onShowAll;

  @override
  State<ClassicKanbanDock> createState() => _ClassicKanbanDockState();
}

class _ClassicKanbanDockState extends State<ClassicKanbanDock>
    with KanbanDockAttachment<ClassicKanbanDock> {
  bool _open = false;

  @override
  ChatKanbanDockController get attachedKanban => widget.dock;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.dock,
    builder: (context, _) {
      final cards = widget.dock.cards;
      if (cards.isEmpty) return const SizedBox.shrink();
      final l = context.sharedL10n;
      final theme = Theme.of(context);
      final style = KanbanDockStyle.classic(context);
      final current = cards.where((card) => !card.settled).firstOrNull;
      // Never more than a share of what is left above the keyboard, so the
      // composer is not pushed underneath it; longer lists scroll.
      final cap = aboveComposerMaxHeight(
        context,
        available: widget.availableHeight,
        fraction: 0.4,
        withKeyboard: 0.25,
      );
      return Container(
        key: const ValueKey('classic-kanban-dock'),
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(4, 2, 4, 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              button: true,
              expanded: _open,
              label: _open ? l.ng_hide_kanban : l.ng_show_kanban,
              child: InkWell(
                key: const ValueKey('classic-kanban-dock-toggle'),
                onTap: () => setState(() => _open = !_open),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
                  child: Row(
                    children: [
                      AnimatedRotation(
                        turns: _open ? 0.25 : 0,
                        duration: const Duration(milliseconds: 150),
                        child: Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: style.dim,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.view_kanban_outlined,
                        size: 17,
                        color: style.dim,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 3,
                        child: Text(
                          kanbanDockLabel(l, cards),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: style.title.copyWith(color: style.text),
                        ),
                      ),
                      const SizedBox(width: 8),
                      KanbanDockDots(cards: cards, style: style),
                      if (current != null && !_open) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Text(
                            current.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: style.meta.copyWith(color: style.dim),
                          ),
                        ),
                      ] else
                        const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            if (_open)
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: cap),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(34, 0, 8, 8),
                  child: KanbanDockRows(
                    dock: widget.dock,
                    style: style,
                    onOpen: widget.onOpen,
                    onShowAll: widget.onShowAll,
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

/// Test seam for a chat screen: the board transport and gateway owner its
/// dock uses instead of its own connection's.
class TestChatKanban {
  const TestChatKanban({this.source, this.owner});
  final ChatKanbanSource Function()? source;
  final RemoteWorkspaceOwner? owner;
}

/// What a tap in the dock opens: one card, or the board limited to the
/// chat's cards.
@immutable
class KanbanOpenRequest {
  const KanbanOpenRequest({
    required this.owner,
    required this.route,
    required this.connection,
    this.board,
    this.cardId,
    this.cardFilter,
    this.includeArchived = false,
  });

  /// The chat's own gateway owner and the route minted on it at the tap.
  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final SavedConnection connection;
  final String? board;
  final String? cardId;
  final Set<String>? cardFilter;
  final bool includeArchived;

  Widget screen({Key? key, VoidCallback? onClose}) => KanbanBoardScreen(
    key: key,
    owner: owner,
    route: route,
    connection: connection,
    initialBoard: board,
    initialCardId: cardId,
    initialCardFilter: cardFilter,
    initialIncludeArchived: includeArchived,
    onClose: onClose,
  );
}

/// Opens the board for [card], or for every card of the chat when [card] is
/// null, on the chat's own connection and profile.
///
/// Wide chats show it as a pane ([KanbanPaneHost], found above [context]
/// unless [pane] names it); narrow ones push the board's route. When the
/// board cannot open, [explain] is given the reason and the row stays.
/// [isCurrent] is asked after the one await: a chat that was closed or
/// switched meanwhile opens nothing.
Future<void> openChatKanban(
  BuildContext context, {
  required ChatKanbanDockController dock,
  required RemoteWorkspaceOwner? owner,
  required SavedConnection connection,
  required bool Function() isCurrent,
  required void Function(String reason) explain,
  ChatKanbanCard? card,
  KanbanPaneHostState? pane,
}) async {
  final l = context.sharedL10n;
  pane ??= KanbanPaneHost.maybeOf(context);
  final navigator = Navigator.of(context);
  if (owner == null) {
    explain(kanbanBlockReason(l, ChatKanbanBlock.noDashboard));
    return;
  }
  if (dock.block != null) {
    // What stood in the way may be fixed by now: ask once more.
    await dock.refresh();
    if (!isCurrent()) return;
  }
  final block = dock.block;
  if (block != null && block.refusesOpen) {
    explain(kanbanBlockReason(l, block));
    return;
  }
  final all = card == null ? dock.showAll : null;
  final request = KanbanOpenRequest(
    owner: owner,
    route: owner.route(),
    connection: connection,
    board: card == null ? all!.board : dock.boardFor(card),
    cardId: card?.id,
    cardFilter: all?.ids,
    includeArchived: card?.archived ?? all!.archived,
  );
  if (pane != null && pane.fits) {
    pane.show(request);
    return;
  }
  await navigator.push(
    MaterialPageRoute<void>(builder: (_) => request.screen()),
  );
}

/// Wraps a chat's body so the Kanban board can open beside it when the chat
/// is wide enough. Narrow chats never show the pane: [openChatKanban] pushes
/// the board's route instead.
class KanbanPaneHost extends StatefulWidget {
  const KanbanPaneHost({super.key, required this.child});
  final Widget child;

  static KanbanPaneHostState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<KanbanPaneHostState>();

  @override
  State<KanbanPaneHost> createState() => KanbanPaneHostState();
}

class KanbanPaneHostState extends State<KanbanPaneHost> {
  KanbanOpenRequest? _request;
  double _width = 0;
  GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  /// The chat is wide enough for the board beside it.
  bool get fits => _width >= kanbanPaneMinChatWidth;

  /// What the pane shows now, if it is open.
  KanbanOpenRequest? get request => fits ? _request : null;

  void show(KanbanOpenRequest request) => setState(() {
    _request = request;
    // A new board each time, so it opens on the asked card.
    _navigator = GlobalKey<NavigatorState>();
  });

  void close() {
    if (_request != null) setState(() => _request = null);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      _width = box.maxWidth;
      final shown = request;
      if (shown == null && _request != null) {
        // The window narrowed under the pane; it does not come back by
        // itself when the window grows again.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !fits) close();
        });
      }
      return Stack(
        children: [
          Positioned.fill(
            right: shown == null ? 0 : kanbanPaneWidth,
            child: widget.child,
          ),
          if (shown != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: kanbanPaneWidth,
              child: _pane(context, shown, box.maxHeight),
            ),
        ],
      );
    },
  );

  Widget _pane(BuildContext context, KanbanOpenRequest shown, double height) {
    final media = MediaQuery.of(context);
    return DecoratedBox(
      key: const ValueKey('kanban-pane'),
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      // Back closes what the board has open, then the pane itself.
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          final navigator = _navigator.currentState;
          if (navigator != null && navigator.canPop()) {
            navigator.pop();
          } else {
            close();
          }
        },
        // The board sizes itself from the window: tell it the pane's size.
        child: MediaQuery(
          data: media.copyWith(size: Size(kanbanPaneWidth, height)),
          // Its sheets stay inside the pane instead of covering the chat.
          child: HeroControllerScope.none(
            child: Navigator(
              key: _navigator,
              onGenerateRoute: (_) => MaterialPageRoute<void>(
                builder: (_) => shown.screen(onClose: close),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
