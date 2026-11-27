/// Where a transcript video was and how fast it played, per chat.
///
/// The Desktop's transcript-video.tsx remembers the position per source
/// (`rememberVideoPosition`, process memory, 24 sources) and the playback
/// rate (`$videoPlaybackSpeed`) so a player that opens again continues
/// where it was. Ares keys both by the chat the video belongs to
/// ([RenderScope.chatKey]: connection, gateway profile and stored chat), so
/// the same file name in another chat or on another gateway starts fresh.
library;

class VideoPlayback {
  const VideoPlayback({required this.position, required this.speed});

  final Duration position;
  final double speed;
}

/// Playback rates the player offers.
const videoPlaybackSpeeds = <double>[0.5, 1, 1.25, 1.5, 2];

bool isVideoPlaybackSpeed(double speed) =>
    speed.isFinite && speed >= 0.25 && speed <= 4;

class VideoPlaybackMemory {
  VideoPlaybackMemory._();

  /// Sources remembered per chat, and chats remembered, most recent last.
  static const maxSourcesPerChat = 24;
  static const maxChats = 32;

  static final _chats = <String, Map<String, VideoPlayback>>{};
  static final _chatSpeeds = <String, double>{};

  /// What [source] in [chat] last did, or null. A source this chat has not
  /// played starts at zero, at the speed last picked in this chat.
  static VideoPlayback? recall(String chat, String source) =>
      _chats[chat]?[source];

  /// The speed a new player in [chat] starts at.
  static double startSpeed(String chat, String source) =>
      _chats[chat]?[source]?.speed ?? _chatSpeeds[chat] ?? 1;

  static void remember(
    String chat,
    String source, {
    required Duration position,
    required double speed,
  }) {
    if (chat.isEmpty || source.isEmpty || !isVideoPlaybackSpeed(speed)) {
      return;
    }
    final sources = _chats.remove(chat) ?? <String, VideoPlayback>{};
    _chats[chat] = sources;
    sources.remove(source);
    sources[source] = VideoPlayback(
      position: position.isNegative ? Duration.zero : position,
      speed: speed,
    );
    while (sources.length > maxSourcesPerChat) {
      sources.remove(sources.keys.first);
    }
    while (_chats.length > maxChats) {
      final oldest = _chats.keys.first;
      _chats.remove(oldest);
      _chatSpeeds.remove(oldest);
    }
  }

  /// The user picked [speed] in [chat]: later players there start at it.
  static void rememberSpeed(String chat, double speed) {
    if (chat.isEmpty || !isVideoPlaybackSpeed(speed)) return;
    _chatSpeeds[chat] = speed;
  }

  /// Forgets everything, for tests.
  static void reset() {
    _chats.clear();
    _chatSpeeds.clear();
  }
}
