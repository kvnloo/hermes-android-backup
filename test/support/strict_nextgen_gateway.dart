// For fakes that override `NextGenGateway.call` and so never reach the
// socket: what the real `call` does on a session-authority gateway, with the
// fake's own answers standing in for the wire.
//
// The real path is `NextGenGateway.call` -> `WsClient.send` -> the canonical
// guard ([CanonicalWire.run]) -> the gateway, whose closed contracts refuse
// unknown keys. A fake that answers `call` directly skips both ends, so a
// legacy shape passes in the test and fails in production. [strictCall] puts
// both back: the request goes through the same guard, the frame it would
// write is checked by [strictAuthorityRefusal], and only then does the fake
// answer.
import 'package:hermes_android/core/services/canonical_wire.dart';
import 'package:hermes_android/core/services/ws_client.dart';

import 'strict_authority_gateway.dart';

/// Answers one frame as the gateway would: the result map, or a thrown
/// [JsonRpcError].
typedef StrictAnswer =
    Future<Map<String, dynamic>> Function(
      String method,
      Map<String, dynamic> params,
    );

class _Socket {
  final generations = <String, int>{};
  late final wire = CanonicalWire(generationFor: (id) => generations[id]);

  void note(String sessionId, Object? value) {
    if (value is! int) return;
    final known = generations[sessionId];
    if (known == null || value > known) generations[sessionId] = value;
  }
}

final _sockets = Expando<_Socket>('strict nextgen socket');

/// A fake's socket state starts over, as a reconnect's does.
void strictCallReset(Object owner) => _sockets[owner] = null;

/// Tells the fake socket of [owner] about a server event, as the real socket
/// learns revisions and generations from the frames it receives.
void strictCallEvent(
  Object owner,
  String type,
  String sessionId,
  Map<String, dynamic> payload,
) {
  final socket = _sockets[owner] ??= _Socket();
  socket.note(sessionId, payload['execution_generation']);
  socket.wire.noteEvent(type, sessionId, payload);
}

/// One `call` of a fake that stands for a session-authority gateway.
///
/// [answer] receives the frame as it would go on the wire (after the
/// guard's translation) and only when the pinned gateway would accept it; a
/// refused frame throws the gateway's own error instead.
Future<Map<String, dynamic>> strictCall(
  Object owner,
  String method,
  Map<String, dynamic> params,
  StrictAnswer answer,
) async {
  final socket = _sockets[owner] ??= _Socket();
  final reply = await socket.wire.run(
    method,
    params,
    wire: (wireMethod, wireParams, {required bool own}) async {
      final refusal = strictAuthorityRefusal(wireMethod, wireParams);
      strictAuthorityTap(wireMethod, wireParams, refusal);
      if (refusal != null) return {'error': refusal};
      try {
        return {'result': await answer(wireMethod, wireParams)};
      } on JsonRpcError catch (error) {
        return {
          'error': {
            'code': error.code,
            'message': error.message,
            'data': error.data,
          },
        };
      }
    },
    noteGeneration: socket.note,
  );
  final error = reply['error'];
  if (error != null) {
    throw JsonRpcError.fromGateway(
      method,
      error as Map,
      fallbackMessage: 'The gateway refused $method.',
    );
  }
  final result = reply['result'];
  return result is Map<String, dynamic>
      ? result
      : result is Map
      ? Map<String, dynamic>.from(result)
      : <String, dynamic>{};
}
