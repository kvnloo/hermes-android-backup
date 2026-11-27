import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether replies are read aloud automatically after a turn completes.
///
/// Opt-in, off by default: reading a reply aloud out loud is a visible side
/// effect, so it is never on until the user asks for it. Stored in
/// [SharedPreferences] so it survives restarts and never leaves the device.
/// Separate from the per-chat in-chat "Spoken replies" toggle, which still
/// governs hands-free/voice-turn playback.
final ValueNotifier<bool> autoSpeakRepliesEnabled = ValueNotifier(false);

/// Loads and persists [autoSpeakRepliesEnabled] on this device.
abstract final class AutoSpeakRepliesStore {
  static const storageKey = 'hermes_auto_speak_replies';

  /// Reads the persisted value into [autoSpeakRepliesEnabled]. Safe to call on
  /// every startup; a failed read keeps the default instead of blocking
  /// startup.
  static Future<void> load() async {
    try {
      final store = await SharedPreferences.getInstance();
      final value = store.getBool(storageKey);
      if (value != null) autoSpeakRepliesEnabled.value = value;
    } catch (_) {
      // A failed read must never block startup; the default stays in place.
    }
  }

  static Future<void> setEnabled(bool enabled) async {
    autoSpeakRepliesEnabled.value = enabled;
    try {
      final store = await SharedPreferences.getInstance();
      await store.setBool(storageKey, enabled);
    } catch (_) {
      // The live value already changed; persistence can retry on a later write.
    }
  }
}

/// The replies Classic auto-read has read, per chat, for as long as the app
/// runs (memory only): each reply is read at most once, however often its
/// snapshot is applied again or its chat route comes back.
///
/// A reply is named by its turn/submission id and/or its durable row id,
/// never by its text: two turns can both say "Done.". Bounded, oldest chats
/// and replies first out.
abstract final class AutoReadLedger {
  static const _maxChats = 64;
  static const _maxPerChat = 64;

  /// Chat key → reply keys: chats least recently used first, replies oldest
  /// first.
  static final _chats = <String, Set<String>>{};

  /// Claims the reply named by [replyKeys] in [chatKey]. True only the first
  /// time: false when any of the keys was claimed before, and false with no
  /// key at all (a reply with no identity cannot be read at most once).
  static bool claim(String chatKey, Iterable<String> replyKeys) {
    final keys = replyKeys.where((key) => key.isNotEmpty).toSet();
    if (keys.isEmpty) return false;
    final spoken = _chats.remove(chatKey) ?? <String>{};
    _chats[chatKey] = spoken;
    while (_chats.length > _maxChats) {
      _chats.remove(_chats.keys.first);
    }
    if (keys.any(spoken.contains)) {
      spoken.addAll(keys);
      return false;
    }
    spoken.addAll(keys);
    while (spoken.length > _maxPerChat) {
      spoken.remove(spoken.first);
    }
    return true;
  }

  @visibleForTesting
  static void reset() => _chats.clear();
}
