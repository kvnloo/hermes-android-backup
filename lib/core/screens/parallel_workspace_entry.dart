import 'package:flutter/material.dart';

import '../models/connection.dart';
import '../l10n/l10n.dart';
import '../l10n/service_strings.dart';
import '../services/connection_mutation_barrier.dart';

String get parallelWorkspaceEntryTitle =>
    serviceStrings.release_core_parallel_workspace_parallel_workspace;
String get parallelWorkspaceEntrySubtitle =>
    serviceStrings.ng_release_more_parallel_workspace_subtitle;

/// Keeps the workspace and its child routes inside the entry owner's lifetime.
/// A route pushed onto the app navigator would outlive an in-place profile
/// change. The host is keyed by the actual connection/gateway instance.
class ParallelWorkspaceEntryHost extends StatefulWidget {
  ParallelWorkspaceEntryHost({
    required Object owner,
    required this.connection,
    required this.home,
    required this.workspace,
  }) : super(key: ObjectKey(owner));

  final SavedConnection connection;
  final Widget Function(VoidCallback open) home;
  final WidgetBuilder workspace;

  /// Capture the entry's original admission, not a fresh epoch at click time:
  /// an old button may fire after an account edit and rollback but before the
  /// invalidated route has finished unmounting.
  static ({SavedConnection connection, bool Function() current})? popoutOwner(
    BuildContext context,
  ) {
    final state = context.findAncestorStateOfType<_EntryHostState>();
    if (state == null || !state._current) return null;
    final connection = state.widget.connection;
    final route = ModalRoute.of(state.context);
    // The owning route must still exist (not popped or replaced), but may be
    // covered: opening search, a notification's chat or any other page on top
    // must not close the user's pop-out windows. Account changes revoke via
    // _current above.
    return (
      connection: connection,
      current: () =>
          state.mounted &&
          state._current &&
          identical(state.widget.connection, connection) &&
          (route == null || route.isActive),
    );
  }

  @override
  State<ParallelWorkspaceEntryHost> createState() => _EntryHostState();
}

class _EntryHostState extends State<ParallelWorkspaceEntryHost> {
  final _navigator = GlobalKey<NavigatorState>();
  late final Object? _epoch;
  late final bool _admitted;
  bool _open = false;

  bool get _current =>
      _admitted &&
      ConnectionMutationBarrier.isCurrent(widget.connection.id, _epoch);

  @override
  void initState() {
    super.initState();
    // Capture before any edit, not at the first gesture after it.
    _epoch = ConnectionMutationBarrier.capture(widget.connection.id);
    _admitted = !ConnectionMutationBarrier.isPending(widget.connection.id);
    ConnectionMutationBarrier.addListener(_revoke);
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(_revoke);
    super.dispose();
  }

  void _revoke() {
    if (_open && !_current) setState(() => _open = false);
  }

  void _show() {
    if (!mounted || _open) return;
    if (!_current) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context
                .sharedL10n
                .rel_svc_misc_parallel_workspace_connection_changed,
          ),
        ),
      );
      return;
    }
    setState(() => _open = true);
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Offstage(
        offstage: _open,
        child: ExcludeFocus(excluding: _open, child: widget.home(_show)),
      ),
      if (_open)
        NavigatorPopHandler<Object?>(
          onPopWithResult: (result) =>
              _navigator.currentState?.maybePop(result),
          child: Navigator(
            key: _navigator,
            pages: [
              const MaterialPage<void>(child: SizedBox.shrink()),
              MaterialPage<void>(
                key: const ValueKey('parallel-workspace-route'),
                child: Builder(builder: widget.workspace),
              ),
            ],
            onDidRemovePage: (page) {
              if (mounted &&
                  _open &&
                  page.key == const ValueKey('parallel-workspace-route')) {
                setState(() => _open = false);
              }
            },
          ),
        ),
    ],
  );
}
