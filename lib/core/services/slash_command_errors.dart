// How a slash-command RPC failed, shared by Classic and NextGen so both read
// a gateway refusal and a lost reply the same way.
import 'ws_client.dart';

/// The gateway refused this invocation before running it.
///
/// The exact `unsupported_command` reason is authoritative on every transport
/// (codes 4001 and 4018). A naked 4018 is not enough: the TUI gateway also
/// uses it for quick-command failures and dispatch-required skills. Only the
/// legacy not-a-command forms count without a reason.
bool isSlashCommandRefusal(JsonRpcError error) =>
    error.reason == 'unsupported_command' ||
    (error.reason == null &&
        error.code == 4018 &&
        (error.message == 'unsupported_command' ||
            error.message.startsWith(
              'not a quick/plugin/bundle/skill command:',
            )));

/// The request may have reached the gateway, but no reply came back: it
/// timed out or the socket dropped after the write. The command may still be
/// running, so the caller must never retry it or send it another way.
bool isSlashDeliveryUnknown(JsonRpcError error) =>
    error.message == 'Timeout' || error.reason == 'connection_closed';
