/// The gateway calls the Classic composer makes for F19/F25: complete.path,
/// complete.slash, session.context_breakdown and session.compress.
///
/// [DesktopGatewayClient] provides them over its socket; tests pass a double
/// through the ChatScreen constructor instead of a socket.
abstract interface class ComposerSessionRpc {
  /// Whether the chat is bound to a gateway session on a live socket.
  bool hasLiveSession(String mobileSessionId);

  /// A session-scoped call; the chat's id in `session_id` is mapped to the
  /// bound gateway session.
  Future<Map<String, dynamic>> requestSessionRpc(
    String method,
    Map<String, dynamic> params,
  );

  /// A connection-level call (no session yet).
  Future<Map<String, dynamic>> call(String method, Map<String, dynamic> params);
}
