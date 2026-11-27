import 'dart:convert';

/// The OS command line contains this marker only. No deep links or account
/// data are accepted there. Identity and the parent's lifetime use stdin.
const workspacePopoutMarker = '--ares-workspace-chat-v1';
const workspacePopoutReady = 'ARES_WORKSPACE_CHAT_READY_V1';
const workspacePopoutFailed = 'ARES_WORKSPACE_CHAT_FAILED_V1';

class PopoutTarget {
  final String connectionId;
  final String profile;
  final String sessionId;
  final bool nextGen;

  PopoutTarget({
    required this.connectionId,
    required this.profile,
    required this.sessionId,
    required this.nextGen,
  }) {
    if (!_id(connectionId) ||
        !_id(sessionId) ||
        (profile.isNotEmpty && !_id(profile))) {
      throw const FormatException('Invalid chat identity.');
    }
  }

  // Fail closed on unsupported IDs instead of interpreting paths, URLs,
  // switches, free text or an empty string as a stored session.
  static bool _id(String value) =>
      value.length <= 200 &&
      RegExp(r'^[A-Za-z0-9_][A-Za-z0-9_.-]*$').stringMatch(value) == value;

  Map<String, Object> toJson() => {
    'connectionId': connectionId,
    'sessionId': sessionId,
    'profile': profile,
    'nextGen': nextGen,
  };

  static PopoutTarget decode(Object? map) {
    if (map case {
      'connectionId': final String c,
      'sessionId': final String s,
      'profile': final String p,
      'nextGen': final bool n,
    } when map.length == 4) {
      return PopoutTarget(
        connectionId: c,
        sessionId: s,
        profile: p,
        nextGen: n,
      );
    }
    throw const FormatException('Invalid chat identity.');
  }

  String get key => jsonEncode(toJson());

  /// The chat as its completion cue names it in either window.
  String get cueKey => '$connectionId|$sessionId';
}

/// A line a parent may send after the launch frame: the user turned off
/// sharing chat activity. It can only take authority away.
const workspacePopoutStopActivity = '{"share_activity":false}';

/// Lines a parent may send after the launch frame about the chat's in-app
/// completion cue: the main window plays it, or the pop-out does. Only one
/// window plays a cue. These move a local sound, never gateway authority.
const workspacePopoutCueMain = '{"cue":"main"}';
const workspacePopoutCuePopout = '{"cue":"popout"}';

/// Lines a pop-out writes after [workspacePopoutReady]: whether it holds
/// presence for its chat (see `ChatPresenceCoordinator.holds`).
const workspacePopoutPresenceHeld = 'ARES_WORKSPACE_CHAT_PRESENCE_V1:1';
const workspacePopoutPresenceFree = 'ARES_WORKSPACE_CHAT_PRESENCE_V1:0';

/// Read precisely one small JSON frame. EOF (including parent crash), errors,
/// and attempted renegotiation permanently revoke this child. Never rebind.
/// After the launch frame only whole [workspacePopoutStopActivity] lines
/// (each calls [onStopActivity]) and, with [onCue], [workspacePopoutCueMain]
/// and [workspacePopoutCuePopout] lines (`onCue(false)`/`onCue(true)`) are
/// accepted; any other byte revokes at once.
Future<void> watchPopoutPipe(
  Stream<List<int>> pipe, {
  required void Function(Map<String, dynamic>) onLaunch,
  required void Function() onRevoked,
  void Function()? onStopActivity,
  void Function(bool popoutPlays)? onCue,
}) async {
  final bytes = <int>[];
  final lines = <List<int>, void Function()>{
    utf8.encode(workspacePopoutStopActivity): ?onStopActivity,
    if (onCue != null) ...{
      utf8.encode(workspacePopoutCueMain): () => onCue(false),
      utf8.encode(workspacePopoutCuePopout): () => onCue(true),
    },
  };
  bool prefix(List<int> line) {
    if (bytes.length > line.length) return false;
    for (var i = 0; i < bytes.length; i++) {
      if (bytes[i] != line[i]) return false;
    }
    return true;
  }

  var received = false;
  try {
    await for (final chunk in pipe) {
      for (final b in chunk) {
        if (!received) {
          if (bytes.length >= 2048) return;
          if (b == 10) {
            received = true;
            onLaunch(jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>);
            bytes.clear();
          } else {
            bytes.add(b);
          }
        } else if (b == 10) {
          final whole = lines.entries
              .where((e) => e.key.length == bytes.length && prefix(e.key))
              .firstOrNull;
          if (whole == null) return;
          bytes.clear();
          whole.value();
        } else {
          bytes.add(b);
          if (!lines.keys.any(prefix)) return;
        }
      }
    }
  } catch (_) {
    // A malformed frame or a broken pipe has no authority.
  } finally {
    onRevoked();
  }
}
