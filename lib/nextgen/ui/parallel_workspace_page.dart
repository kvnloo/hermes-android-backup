import 'package:flutter/material.dart';

import '../../core/models/session.dart';
import '../../core/services/session_browser_loader.dart';
import '../../core/utils/session_sources.dart';
import '../../core/workspace/parallel_workspace.dart';
import '../data/nextgen_gateway.dart';
import 'parallel_chat_pane.dart';

class NgParallelWorkspacePage extends StatefulWidget {
  const NgParallelWorkspacePage({required this.gateway, super.key});
  final NextGenGateway gateway;

  @override
  State<NgParallelWorkspacePage> createState() => _NgParallelState();
}

class _NgParallelState extends State<NgParallelWorkspacePage> {
  late final _api = widget.gateway.api;
  late final _roster = SessionBrowserLoader(
    api: _api,
    readPage: ({required limit, offset = 0}) => _api.getSessionsPage(
      limit: limit,
      offset: offset,
      excludeSources: kChatListingExcludedSources,
    ),
  );

  Future<List<Session>> _load() async {
    final showSubagents = await _api.showSubagentSessions();
    if (!mounted) return const [];
    final rows = await _roster.load();
    return [
      for (final row in rows)
        if (!row.archived &&
            !isCronSession(row) &&
            !isInternalListingSession(row, showSubagents: showSubagents))
          row,
    ];
  }

  @override
  void dispose() {
    _roster.close(); // The socket and HTTP client belong to NgScope.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ParallelWorkspace(
    connection: widget.gateway.connection,
    nextGen: true,
    loadSessions: _load,
    buildChat: (_, session, close) => NgParallelChatPane(
      gateway: widget.gateway,
      session: session,
      close: close,
    ),
  );
}
