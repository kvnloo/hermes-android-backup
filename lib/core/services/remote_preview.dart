part of 'remote_workspace.dart';

extension PreviewWorkspace on WorkspaceTarget {
  /// Register only on the live chat socket that acknowledged this runtime.
  /// No credential, RPC handle or privileged API is given to page content.
  Future<void Function()> sharePreview(PreviewAnswer answer) async {
    await verifySession();
    checkCurrent();
    final id = runtimeSessionId;
    if (id == null) _fail(WorkspaceFailure.unbound);
    try {
      return _socket.previewPeers.attach(id, effectiveProfile!, (
        action, {
        required start,
        required count,
        required amount,
        required direction,
      }) {
        if (!isCurrent) return null;
        return answer(
          action,
          start: start,
          count: count,
          amount: amount,
          direction: direction,
        );
      });
    } on StateError {
      _fail(WorkspaceFailure.denied);
    }
  }
}
