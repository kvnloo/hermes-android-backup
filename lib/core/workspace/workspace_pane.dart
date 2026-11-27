import 'package:flutter/material.dart';

/// Dialogs and detail routes belong to one tab, not to the underlying app or
/// to the neighbouring conversation. Hiding keeps its route stack mounted.
class WorkspacePane extends StatefulWidget {
  const WorkspacePane({
    super.key,
    required this.handleBack,
    required this.child,
  });
  final bool handleBack;
  final Widget child;
  @override
  State<WorkspacePane> createState() => _PaneState();
}

class _PaneState extends State<WorkspacePane> {
  final _navigator = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) => NavigatorPopHandler<Object?>(
    enabled: widget.handleBack,
    onPopWithResult: (result) {
      final nav = _navigator.currentState;
      if (widget.handleBack && nav != null && nav.canPop()) {
        nav.maybePop(result);
      }
    },
    child: Navigator(
      key: _navigator,
      pages: [MaterialPage<void>(child: widget.child)],
      onDidRemovePage: (_) {}, // The tab strip owns closing the base page.
    ),
  );
}
