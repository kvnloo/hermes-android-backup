import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../parked_automotive.dart';
import '../../nextgen/data/seen_chats.dart';
import '../../nextgen/nextgen_preferences.dart';
import 'connection_manager.dart';
import 'connection_mutation_barrier.dart';
import 'gateway_turn_application_controller.dart';
import 'dashboard_api_client.dart';
import 'mobile_push_service.dart';
import 'normal_gateway_application_session.dart';
import 'notification_prefs.dart';

/// Existing-session actions only. Native claims are sealed, expiring and
/// single-use BEFORE network work. Uncertain delivery never triggers a UI resend.
class AutoMessagingService {
  AutoMessagingService({
    required this.manager,
    required this.turns,
    this.onOpen,
    MethodChannel? channel,
    NormalGatewayApplicationSession Function(SavedConnection)? sessionFor,
    Future<Session?> Function(
      SavedConnection,
      String,
      Future<bool> Function(),
      bool Function(),
    )?
    lookup,
    bool? supported,
  }) : channel = channel ?? platform,
       supported =
           !isParkedAutomotive &&
           (supported ?? defaultTargetPlatform == TargetPlatform.android),
       _sessionFor = sessionFor ?? turns.normalSessionFor,
       _lookup = lookup ?? _findSession;
  static const platform = MethodChannel('com.hermesagent.hermes_android/auto');

  /// Whether this engine's native conversation owner has actually answered.
  /// Car conversations are attempted only after that proof; until then (other
  /// platforms, or an engine without the owner registered) completed turns
  /// keep their existing ordinary alerts instead of waiting on, or being lost
  /// to, an absent native channel.
  static bool get ownerAvailable => _ownerAvailable;
  static bool _ownerAvailable = false;
  @visibleForTesting
  static set debugOwnerAvailable(bool value) => _ownerAvailable = value;

  bool get _ownsPlatform => identical(channel, platform);
  final ConnectionManager manager;
  final GatewayTurnApplicationController turns;
  final Future<void> Function(SavedConnection, String)? onOpen;
  final MethodChannel channel;
  final bool supported;
  final NormalGatewayApplicationSession Function(SavedConnection) _sessionFor;
  final Future<Session?> Function(
    SavedConnection,
    String,
    Future<bool> Function(),
    bool Function(),
  )
  _lookup;
  bool _closed = false;
  Future<void>? _flight;
  bool _dirty = false;
  static Future<Session?> _findSession(
    SavedConnection c,
    String id,
    Future<bool> Function() allowed,
    bool Function() current,
  ) async {
    final api = DashboardApiClient.fromConnection(c);
    try {
      return await api.getSessionById(
        id,
        canContinue: allowed,
        isCurrent: current,
      );
    } finally {
      api.close();
    }
  }

  void initialize() {
    if (!supported) return;
    channel.setMethodCallHandler((call) async {
      if (call.method == 'changed') {
        if (_ownsPlatform) _ownerAvailable = true;
        unawaited(drain());
      }
    });
    unawaited(drain());
  }

  Future<void> drain() {
    if (_closed || !supported) return Future.value();
    _dirty = true;
    return _flight ??= _drain().whenComplete(() => _flight = null);
  }

  Future<void> _drain() async {
    try {
      while (_dirty && !_closed) {
        _dirty = false;
        while (!_closed) {
          final raw = await channel.invokeMapMethod<String, dynamic>('claim');
          if (_ownsPlatform && !_closed) _ownerAvailable = true;
          if (raw == null || _closed) break;
          await _consume(Map<String, dynamic>.from(raw));
        }
      }
    } on MissingPluginException {
      // No native owner in this engine: it cannot have minted a conversation.
      if (_ownsPlatform) _ownerAvailable = false;
    } catch (_) {
      // A lost claim acknowledgement is uncertain, not permission to retry.
    }
  }

  Future<void> _consume(Map<String, dynamic> action) async {
    final token = action['token'] as String?;
    final id = action['connectionId'] as String?;
    final sessionId = action['sessionId'] as String?;
    if (token == null ||
        id == null ||
        sessionId == null ||
        sessionId == '__new__') {
      return;
    }
    final mutation = ConnectionMutationBarrier.capture(id);
    SavedConnection? connection() =>
        manager.getConnections().where((c) => c.id == id).firstOrNull;
    bool current() =>
        !_closed &&
        !nextGenTurnActive.value &&
        ConnectionMutationBarrier.isCurrent(id, mutation) &&
        notificationKindEnabled(HermesNotificationKind.turnDone) &&
        connection() != null &&
        MobilePushService.binding(connection()!) == action['binding'];
    Future<bool> allowed() async {
      if (!current()) return false;
      final native = await channel.invokeMethod<bool>('current', {
        'token': token,
      });
      return native == true && current();
    }

    try {
      await NotificationPrefsStore.load();
      if (!await allowed()) return;
      await manager.refreshConnectionCredentials(id);
      if (!await allowed()) return;
      final c = connection()!;
      final session = await _lookup(c, sessionId, allowed, current);
      if (!await allowed() ||
          session == null ||
          session.id != sessionId ||
          session.isLocalDraft) {
        return;
      }
      if (action['kind'] == 'read') {
        NgSeenStore(
          manager.prefs,
          id,
        ).markLooked(sessionId, DateTime.now().millisecondsSinceEpoch / 1000.0);
        return;
      }
      if (action['kind'] == 'open') {
        await onOpen?.call(c, sessionId);
        return;
      }
      if (action['kind'] != 'reply') return;
      final text = action['text'] as String?;
      if (text == null || text.trim().isEmpty || text.length > 16000) return;
      final owner = _sessionFor(c);
      await owner.ready;
      if (!await allowed()) return;
      final transport = owner.client;
      if (transport != null) {
        final resumed = await transport.resumeSubmittedSession(
          localSessionId: sessionId,
          storedSessionId: sessionId,
          beforeRequest: allowed,
          acceptsResult: current,
        );
        if (!await allowed() ||
            resumed.running != false ||
            resumed.openRequests.isNotEmpty) {
          return;
        }
      }
      final chat = owner.chatFor(
        sessionId,
        storedSessionId: sessionId,
        title: session.title,
      );
      final reservation = chat.reserve();
      if (reservation == null) return;
      try {
        if (!await allowed()) return;
        await chat.submitPrepared(
          reservation: reservation,
          text: text,
          localContent: text,
          knownStoredSessionId: sessionId,
          maySubmit: current,
          beforeSend: allowed,
        );
      } finally {
        chat.cancelPreparation(reservation);
      }
    } catch (_) {
      // Never log content/credentials/provider errors, create a session or resend.
    } finally {
      try {
        await channel.invokeMethod<void>('finish', {'token': token});
      } catch (_) {
        /* no resend */
      }
    }
  }

  void dispose() {
    _closed = true;
    if (supported) channel.setMethodCallHandler(null);
    // A later owner must prove the native channel again.
    if (supported && _ownsPlatform) _ownerAvailable = false;
  }
}
