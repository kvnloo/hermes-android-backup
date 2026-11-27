import 'package:flutter/foundation.dart';

import '../models/connection.dart';

/// Canonical key for a Hermes profile: trimmed, empty means `default`
/// (Hermes Desktop's `normalizeProfileKey`). Only for comparing the profile a
/// wake phrase belongs to with the profile a chat is scoped to.
String wakeProfileKey(String? name) {
  final value = (name ?? '').trim();
  return value.isEmpty ? 'default' : value;
}

/// The saved connection that reaches [profile] on the same gateway as [from],
/// or null when none is saved. A wake phrase enrolled by another profile may
/// only be answered there, never on a different machine.
SavedConnection? wakeConnectionForProfile(
  Iterable<SavedConnection> connections, {
  required SavedConnection from,
  required String profile,
}) {
  final wanted = wakeProfileKey(profile);
  for (final candidate in connections) {
    if (candidate.id == from.id) continue;
    if (wakeProfileKey(candidate.gatewayProfile) != wanted) continue;
    if (candidate.host.trim().toLowerCase() != from.host.trim().toLowerCase()) {
      continue;
    }
    if (candidate.port != from.port ||
        candidate.useHttps != from.useHttps ||
        candidate.dashboardPort != from.dashboardPort ||
        (candidate.dashboardPrefix ?? '') != (from.dashboardPrefix ?? '') ||
        (candidate.desktopGatewayUrl ?? '') != (from.desktopGatewayUrl ?? '')) {
      continue;
    }
    return candidate;
  }
  return null;
}

/// A wake word asked for a voice conversation in a chat that is not on
/// screen yet: a fresh session, or another profile's gateway. The request is
/// taken exactly once, by the composer that shows that owner's chat, after
/// the switch (Hermes Desktop's `requestVoiceConversationStart` /
/// `takeVoiceConversationStart`). It never starts a microphone in the chat
/// that heard the phrase.
class WakeVoiceRequest {
  WakeVoiceRequest._();

  /// A switch that never lands must not open a microphone much later.
  static const Duration lifetime = Duration(seconds: 20);

  static _PendingWakeVoice? _pending;

  @visibleForTesting
  static DateTime Function() clock = DateTime.now;

  /// Asks the composer showing ([connectionId], [profile]) to start voice.
  /// With [freshSession] only a chat with no stored session may take it.
  static void request({
    required String connectionId,
    required String? profile,
    required bool freshSession,
  }) {
    _pending = _PendingWakeVoice(
      connectionId: connectionId,
      profileKey: wakeProfileKey(profile),
      freshSession: freshSession,
      at: clock(),
    );
  }

  static _PendingWakeVoice? _current() {
    final pending = _pending;
    if (pending == null) return null;
    if (clock().difference(pending.at) > lifetime) {
      _pending = null;
      return null;
    }
    return pending;
  }

  /// Whether a live request waits for this owner, and whether it wants a
  /// fresh session. Does not consume it.
  static ({bool freshSession})? pendingFor({
    required String connectionId,
    required String? profile,
  }) {
    final pending = _current();
    if (pending == null ||
        pending.connectionId != connectionId ||
        pending.profileKey != wakeProfileKey(profile)) {
      return null;
    }
    return (freshSession: pending.freshSession);
  }

  /// Consumes the request when it is for this owner and, if it asked for a
  /// fresh session, [isNewChat] holds. True exactly once.
  static bool take({
    required String connectionId,
    required String? profile,
    required bool isNewChat,
  }) {
    final pending = pendingFor(connectionId: connectionId, profile: profile);
    if (pending == null) return false;
    if (pending.freshSession && !isNewChat) return false;
    _pending = null;
    return true;
  }

  static void clear() => _pending = null;
}

class _PendingWakeVoice {
  const _PendingWakeVoice({
    required this.connectionId,
    required this.profileKey,
    required this.freshSession,
    required this.at,
  });
  final String connectionId;
  final String profileKey;
  final bool freshSession;
  final DateTime at;
}
