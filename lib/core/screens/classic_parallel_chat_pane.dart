import 'package:flutter/material.dart';

import '../services/connection_manager.dart';
import '../services/gateway_turn_application_controller.dart';
import '../workspace/parallel_workspace.dart';
import 'chat_screen.dart';

class ClassicParallelChatPane extends StatefulWidget {
  ClassicParallelChatPane({
    required this.connection,
    required this.session,
    this.controller,
    this.testClientFactory,
    required this.close,
  }) : super(key: ValueKey((connection, session.id)));
  final SavedConnection connection;
  final Session session;
  final GatewayTurnApplicationController? controller;
  @visibleForTesting
  final ApiClient Function()? testClientFactory;
  final VoidCallback close;

  @override
  State<ClassicParallelChatPane> createState() => _ClassicPaneState();
}

class _ClassicPaneState extends State<ClassicParallelChatPane> {
  // ChatScreen owns and closes this client once any detached stream settles.
  late final _testClient = widget.testClientFactory?.call();
  @override
  Widget build(BuildContext context) => ChatScreen(
    connection: widget.connection,
    session: widget.session,
    singleSession: true,
    active: TickerMode.valuesOf(context).enabled,
    turnApplicationController: widget.controller,
    onClose: widget.close,
    // /resume opens the pick as a pane of this workspace, which stays.
    onOpenSession: ParallelWorkspace.openSessionOf(context),
    testApiClient: _testClient,
  );
}
