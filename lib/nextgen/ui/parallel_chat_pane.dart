import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/models/session.dart';
import '../../core/utils/session_sources.dart';
import '../../core/workspace/parallel_workspace.dart';
import '../data/chat_controller.dart';
import '../data/nextgen_gateway.dart';
import 'chat_view.dart';
import 'sessions_sidebar.dart';

/// A stored chat on the workspace gateway. A new owner or stored ID gets a
/// fresh controller even when a layout reuses this pane's position.
///
/// `/resume` here lists the connection's chats (read when the picker opens)
/// and opens the pick the host's way: [onOpenSession] when given (a pop-out
/// window opens it in the window); inside a Parallel workspace, as another
/// pane of it (as a Classic pane does); anywhere else, in this pane.
class NgParallelChatPane extends StatefulWidget {
  NgParallelChatPane({
    required this.gateway,
    required this.session,
    required this.close,
    this.onOpenSession,
  }) : super(key: ValueKey((gateway, session.id)));
  final NextGenGateway gateway;
  final Session session;
  final VoidCallback close;
  final Future<void> Function(Session picked)? onOpenSession;

  @override
  State<NgParallelChatPane> createState() => _NgPaneState();
}

class _NgPaneState extends State<NgParallelChatPane>
    with WidgetsBindingObserver {
  late Session _session = widget.session;
  late NgChatController _chat = _controllerFor(_session);
  List<Session> _listed = const [];

  NgChatController _controllerFor(Session session) => NgChatController(
    widget.gateway,
    sessionId: session.id,
    title: ngSessionTitle(session),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_chat.open());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _chat.resync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _chat.dispose();
    super.dispose();
  }

  /// The connection's chats, as the workspace roster lists them: no
  /// archived, cron or internal rows.
  Future<List<Session>> _loadSessions() async {
    final api = widget.gateway.api;
    final showSubagents = await api.showSubagentSessions();
    final page = await api.getSessionsPage(
      limit: 100,
      excludeSources: kChatListingExcludedSources,
    );
    final rows = [
      for (final row in page.sessions)
        if (!row.archived &&
            !row.isLocalDraft &&
            !isCronSession(row) &&
            !isInternalListingSession(row, showSubagents: showSubagents))
          row,
    ];
    _listed = rows;
    return rows;
  }

  Session _rowFor(String id, String title) =>
      _listed.where((row) => row.id == id).firstOrNull ??
      Session(
        id: id,
        title: title,
        model: '',
        source: '',
        messageCount: 0,
        isActive: false,
        preview: '',
        startedAt: 0,
      );

  Future<void> _resume(String id, String title) async {
    final picked = _rowFor(id, title);
    final open =
        widget.onOpenSession ?? ParallelWorkspace.openSessionOf(context);
    if (open != null) {
      await open(picked);
      return;
    }
    // Nowhere else to open it: this pane shows the pick.
    if (!mounted || picked.id == _session.id) return;
    final previous = _chat;
    setState(() {
      _session = picked;
      _chat = _controllerFor(picked);
    });
    unawaited(_chat.open());
    // The old view lets go of its controller as this frame rebuilds.
    WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
  }

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    // A swapped chat is a new view: nothing (a draft, an intake) carries over.
    key: ObjectKey(_chat),
    child: NgChatView(
      chat: _chat,
      onClose: widget.close,
      loadSessions: _loadSessions,
      onResume: (id, title) => unawaited(_resume(id, title)),
    ),
  );
}
