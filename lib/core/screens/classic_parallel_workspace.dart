import 'package:flutter/material.dart';

import '../services/connection_manager.dart';
import '../services/gateway_turn_application_controller.dart';
import '../services/session_browser_loader.dart';
import '../utils/session_sources.dart';
import '../workspace/parallel_workspace.dart';
import 'classic_parallel_chat_pane.dart';

/// Each pane mounts the native Classic chat. Only the application turn owner
/// is shared; the roster and each view own separate REST clients.
class ClassicParallelWorkspace extends StatefulWidget {
  const ClassicParallelWorkspace({
    required this.connection,
    this.turnController,
    this.clientFactory,
    super.key,
  });

  final SavedConnection connection;
  final GatewayTurnApplicationController? turnController;
  @visibleForTesting
  final ApiClient Function()? clientFactory;

  @override
  State<ClassicParallelWorkspace> createState() => _ClassicParallelState();
}

class _ClassicParallelState extends State<ClassicParallelWorkspace> {
  late final _api =
      widget.clientFactory?.call() ??
      ApiClient.forConnection(widget.connection);
  late final _roster = SessionBrowserLoader(api: _api);

  Future<List<Session>> _load() async {
    // The legacy API's /api/sessions and history do not carry a profile.
    // Never fall back to a machine-wide roster for a named profile.
    if (!widget.connection.singleLogin &&
        (widget.connection.gatewayProfile?.trim().isNotEmpty ?? false)) {
      throw StateError('A profile-scoped history connection is required.');
    }
    final rows = await _roster.load();
    return [
      for (final row in rows)
        if (!row.archived && !row.isLocalDraft && !isMachineSession(row)) row,
    ];
  }

  @override
  void dispose() {
    _roster.close();
    _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ParallelWorkspace(
    connection: widget.connection,
    nextGen: false,
    loadSessions: _load,
    buildChat: (context, session, close) => ClassicParallelChatPane(
      connection: widget.connection,
      session: session,
      controller: widget.turnController,
      testClientFactory: widget.clientFactory,
      close: close,
    ),
  );
}
