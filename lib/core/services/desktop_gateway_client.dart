import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/client_certificate.dart';
import '../models/slash_command.dart';
import 'capability_registry.dart';
import 'composer_session_rpc.dart';
import 'connection_manager.dart';
import 'gateway_turn_coordinator.dart';
import 'gateway_turn_journal.dart';
import 'gateway_wake_word.dart';
import 'gpt_live_conversation.dart';
import 'projects_gateway_client.dart';
import 'remote_workspace.dart';
import 'voice_live_mode.dart';
import 'ws_client.dart';
import 'system_sleep_gate.dart';

typedef DesktopAsyncEventCallback =
    void Function(String mobileSessionId, StreamEvent event);
typedef DesktopAsyncEventSessionPredicate = bool Function(String sessionId);
typedef DesktopConnectionCallback =
    void Function(DesktopConnectionState connectionState);

enum DesktopConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

/// Clients that serve the gateway voice surface (`wake.*`, voice mode and
/// GPT-Live): each client this file constructs, until it is closed. Kept
/// outside the class, as [SlashCommandConnectionMemory] keeps its refusals,
/// so a stand-in that implements [DesktopGatewayClient] for a chat's turns
/// only is a client without voice rather than one that throws on first use.
final Expando<bool> _servesVoice = Expando('DesktopGatewayClient voice');

/// Voice a chat may use but must never need: a chat opens on a client
/// without it, and shows no wake or voice-mode controls there.
extension DesktopGatewayVoice on DesktopGatewayClient {
  /// The wake-word controller, or null when this client serves no gateway
  /// voice (it is closed, or a stand-in): wake is then not offered.
  GatewayWakeWordController? get servedWakeWord =>
      _servesVoice[this] == true ? wakeWord : null;

  /// The GPT-Live / Chained mode controller, or null as for
  /// [servedWakeWord].
  VoiceLiveModeController? get servedVoiceLiveMode =>
      _servesVoice[this] == true ? voiceLiveMode : null;
}

/// Authenticated JSON-RPC transport for a Hermes Desktop remote gateway.
///
/// The mobile OpenAI-compatible endpoint remains available for legacy
/// profiles. When a connection supplies [SavedConnection.desktopGatewayUrl],
/// chat writes and interactive events use this one Desktop session transport.
class DesktopGatewayClient implements SlashCommandGateway, ComposerSessionRpc {
  /// How long a new socket waits for `gateway.ready` before its first
  /// request. Every current gateway greets at once.
  static const gatewayReadyGrace = Duration(seconds: 3);

  static final _localServerRequestKey = RegExp(
    r'^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}\.[0-9]+\.[0-9]+:',
  );
  // Native action payloads can outlive this process. A process-local counter
  // would collide after restart and could approve a replayed wire request id.
  final String _serverRequestNamespace = const Uuid().v4();
  final String _connectionId;
  final String _baseUrl;
  final DashboardClient _dashboard;

  /// Hermes profile the gateway socket should run chats under, or null to
  /// let the server use its own. See [SavedConnection.gatewayProfile].
  final String? _gatewayProfile;
  final ClientCertificateConfig? _clientCertificate;
  final Map<String, String> _customHeaders;
  WsClient? _ws;
  bool get sessionAuthority => _ws?.sessionAuthority == true;
  bool get isSocketConnected => !_closed && _ws?.isConnected == true;
  String get connectionId => _connectionId;
  String? get gatewayProfile => _gatewayProfile;
  final _gatewayEvents = StreamController<StreamEvent>.broadcast();
  final _socketReady = StreamController<void>.broadcast();
  Stream<StreamEvent> get gatewayEvents => _gatewayEvents.stream;
  Stream<void> get socketReady => _socketReady.stream;
  Future<WsClient>? _socketInFlight;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  final Map<String, Future<_DesktopGatewayBinding>> _bindingInFlight = {};
  bool _closed = false;
  final Map<String, String> _gatewaySessionIds = {};
  final Map<String, String> _storedSessionIds = {};
  final Set<String> _resumeOnlySessions = {};
  final Map<String, String> _workingDirectories = {};
  final Map<String, GatewayServerRequest> _serverRequests = {};
  final Map<String, WsClient> _serverRequestClients = {};
  final Map<String, String> _serverRequestMobileSessionIds = {};
  final Map<String, StreamEvent> _serverRequestEvents = {};
  final Map<WsClient, int> _serverRequestClientOrdinals = Map.identity();
  int _nextServerRequestClientOrdinal = 1;
  int _nextServerRequestOrdinal = 1;
  final Map<String, Set<String>> _serverClarifyRemaining = {};
  final Map<String, String> _serverApprovalByMobileSession = {};
  DesktopAsyncEventCallback? _asyncEventListener;
  DesktopAsyncEventCallback? _sessionEventListener;
  bool _applicationOwnsRecovery = false;
  bool _reconnectAllowed = true;
  final Map<String, Future<ResumedGatewaySession>> _resumeOnlyInFlight = {};
  DesktopAsyncEventSessionPredicate? _asyncEventAcceptsSession;
  DesktopConnectionCallback? _connectionListener;
  GatewayTurnSessionBoundCallback? _sessionBoundListener;
  GatewayTurnSessionBoundCallback? _sessionCreatedListener;
  GatewayTurnCoordinatorRegistry? _turnCoordinatorRegistry;
  ProjectsGatewayClient? _projects;
  GatewayWakeWordController? _wakeWord;
  VoiceLiveModeController? _voiceLiveMode;
  final CapabilityRegistry _capabilities = CapabilityRegistry();

  /// Gateway-backed wake-word controller scoped to this connection/profile.
  GatewayWakeWordController get wakeWord =>
      _wakeWord ??= GatewayWakeWordController(
        transport: GatewayWakeTransport.fromDesktop(this),
      );

  /// Gateway-backed GPT-Live / Chained mode controller for this profile.
  VoiceLiveModeController get voiceLiveMode =>
      _voiceLiveMode ??= VoiceLiveModeController.fromDesktop(this);

  @visibleForTesting
  set debugVoiceLiveMode(VoiceLiveModeController? controller) {
    _voiceLiveMode?.dispose();
    _voiceLiveMode = controller;
  }

  /// Non-owning GPT-Live REST transport sharing this gateway's dashboard auth.
  GptLiveTransport createGptLiveTransport() =>
      GptLiveGatewayTransport.fromDashboard(
        _dashboard,
        profile: _gatewayProfile,
      );

  static const _asyncEventTypes = {
    'background.complete',
    // The answer to /btw arrives only as this event (Desktop's dispatcher).
    'btw.complete',
    'review.summary',
    'notification.show',
    'notification.clear',
    'subagent.spawn_requested',
    'subagent.start',
    'subagent.thinking',
    'subagent.tool',
    'subagent.progress',
    'subagent.complete',
    // A detached legacy turn can settle after its prompt.submit listener was
    // rejected by socket close. Route its terminal frame to ChatScreen's
    // recovery controller; live turns ignore this duplicate async delivery.
    'message.complete',
    'turn.end',
    'turn.error',
    'error',
    'request.cancel',
  };

  DesktopGatewayClient._({
    required this._connectionId,
    required this._baseUrl,
    required this._dashboard,
    this._gatewayProfile,
    this._clientCertificate,
    this._customHeaders = const <String, String>{},
  }) {
    workspace = RemoteWorkspaceOwner(
      connectionId: _connectionId,
      expectedBaseUrl: _baseUrl,
      profile: _gatewayProfile,
      dashboard: _dashboard,
      connect: _ensureSocket,
      ownsSocket: _ownsSocket,
    );
    SystemSleepGate.instance.addListener(_onSystemSleep);
    _servesVoice[this] = true;
  }

  late final RemoteWorkspaceOwner workspace;

  /// True while the computer sleeps or the session is locked: the socket is
  /// closed and nothing reconnects until [SystemSleepGate] clears.
  bool _systemPaused = false;
  bool _reconnectAfterPause = false;

  void _onSystemSleep() {
    if (_closed) return;
    final paused = SystemSleepGate.instance.value;
    if (paused == _systemPaused) return;
    _systemPaused = paused;
    if (paused) {
      // Only a client that had a live socket reconnects on its own later;
      // an idle client reconnects lazily on its next call.
      _reconnectAfterPause =
          _ws?.isConnected == true ||
          _socketInFlight != null ||
          _reconnectTimer != null;
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      _reconnectAttempts = 0;
      final ws = _ws;
      if (ws != null) {
        // Report the drop like a lost connection; stored session ids stay,
        // so the next socket re-binds each with session.resume.
        _ws = null;
        _gatewaySessionIds.clear();
        ws.close();
        _connectionListener?.call(DesktopConnectionState.disconnected);
      }
      return;
    }
    // A background policy that holds reconnects keeps the request until
    // setReconnectAllowed(true).
    if (!_reconnectAfterPause || !_reconnectAllowed) return;
    _reconnectAfterPause = false;
    _reconnectNow();
  }

  void _checkNotPaused() {
    if (_systemPaused) {
      throw StateError('Paused while the computer sleeps.');
    }
  }

  void _reconnectNow() {
    _ensureSocket().then<void>(
      (_) {},
      onError: (Object _) {
        if (!_closed && !_systemPaused) _scheduleReconnect();
      },
    );
  }

  /// The terminal executor reported by the live resume binding, if any.
  String? boundTerminalBackend(String storedSessionId) =>
      _ws?.workspaceBinding(storedSessionId)?.backend;

  void _checkOpen() {
    if (_closed) throw StateError('DesktopGatewayClient is closed.');
  }

  bool _ownsSocket(WsClient client) =>
      !_closed && identical(client, _ws) && client.isConnected;

  void _checkSocket(WsClient client) {
    _checkOpen();
    if (!_ownsSocket(client)) {
      throw StateError('Session binding belongs to a replaced socket.');
    }
  }

  // No global client registry: the keep-alive policy is driven by
  // unresolved turns (see ConnectionKeepAliveService), not by
  // merely-live sockets.

  /// The canonical gateway origin for [connection].
  ///
  /// Extracted so the recovery-journal scope can be derived without opening a
  /// transport: an omitted default port and an explicit one must resolve to
  /// the same string, or the same gateway would be recorded under two scopes.
  static String normalizedGatewayBaseUrl(SavedConnection connection) {
    final override = connection.desktopGatewayUrl?.trim() ?? '';
    final overrideUri = override.isEmpty
        ? null
        : Uri.tryParse(
            override.contains('://') ? override : 'https://$override',
          );
    final isDistinctOverride =
        overrideUri != null &&
        overrideUri.host.isNotEmpty &&
        overrideUri.host.toLowerCase() != connection.host.toLowerCase();
    final raw = isDistinctOverride
        ? override
        : SavedConnection.joinBaseUrl(
            '${Uri(scheme: connection.useHttps ? 'https' : 'http', host: connection.host)}:${connection.dashboardPort}',
            connection.dashboardPrefix ?? '',
          );
    final normalized = raw.contains('://') ? raw : 'https://$raw';
    final uri = Uri.tryParse(normalized);
    if (uri == null ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw ArgumentError('Desktop Gateway URL must be an http(s) URL');
    }
    final baseUri = uri.replace(query: '', fragment: '');
    final pathPrefix = baseUri.path == '/' ? '' : baseUri.path;
    final port = baseUri.hasPort
        ? baseUri.port
        : baseUri.scheme == 'https'
        ? 443
        : 80;
    return SavedConnection.joinBaseUrl(
      '${Uri(scheme: baseUri.scheme, host: baseUri.host)}:$port',
      pathPrefix,
    );
  }

  static String _endpointDigest(String baseUrl) =>
      sha256.convert(utf8.encode(baseUrl)).toString();

  /// The recovery-journal endpoint scope for [connection], or `null` when the
  /// connection names no usable Desktop Gateway.
  ///
  /// Returning `null` rather than throwing keeps callers that only want to
  /// *read* journal state — such as the Home digest — free of try/catch around
  /// a plain configuration fact.
  static String? endpointDigestFor(SavedConnection connection) {
    final hasExplicitOverride =
        connection.desktopGatewayUrl?.trim().isNotEmpty == true;
    final hasDashboardAuth = connection.hasDashboardAuth;
    if (!hasExplicitOverride && !hasDashboardAuth) return null;
    try {
      return _endpointDigest(normalizedGatewayBaseUrl(connection));
    } on ArgumentError {
      return null;
    }
  }

  factory DesktopGatewayClient.fromConnection(SavedConnection connection) {
    final baseUrl = normalizedGatewayBaseUrl(connection);
    final baseUri = Uri.parse(baseUrl);
    final pathPrefix = baseUri.path == '/' ? '' : baseUri.path;
    return DesktopGatewayClient._(
      connectionId: connection.id,
      baseUrl: baseUrl,
      dashboard: DashboardClient(
        host: baseUri.host,
        // The normalized base URL always carries an explicit port, so this
        // never falls back to a scheme default.
        port: baseUri.port,
        useHttps: baseUri.scheme == 'https',
        pathPrefix: pathPrefix,
        proxied: connection.dashboardProxied,
        username: connection.dashboardUsername,
        password: connection.dashboardPassword,
        gatewayProfile: connection.gatewayProfile,
        clientCertificate: connection.clientCertificate,
        deploymentToken: connection.deploymentToken,
        customHeaders: connection.customHeaders,
      ),
      gatewayProfile: connection.gatewayProfile,
      clientCertificate: connection.clientCertificate,
      customHeaders: connection.customHeaders,
    );
  }

  Future<_DesktopGatewaySession> _connect(
    String mobileSessionId, {
    String? workingDirectory,
    Future<bool> Function()? beforeRequest,
  }) async {
    _checkOpen();
    if (beforeRequest != null && !await beforeRequest()) {
      throw StateError('Notification admission revoked');
    }
    _checkOpen();
    final requestedWorkingDirectory = workingDirectory?.trim();
    if (requestedWorkingDirectory != null &&
        requestedWorkingDirectory.isNotEmpty) {
      _workingDirectories[mobileSessionId] = requestedWorkingDirectory;
    }
    final effectiveWorkingDirectory = _workingDirectories[mobileSessionId];
    final existing = _ws;
    if (existing != null && existing.isConnected) {
      final mappedSessionId = _gatewaySessionIds[mobileSessionId];
      if (mappedSessionId != null) {
        return _DesktopGatewaySession(existing, mappedSessionId);
      }
      final binding = await _resumeOrCreateSingle(
        existing,
        mobileSessionId,
        workingDirectory: effectiveWorkingDirectory,
        beforeRequest: beforeRequest,
      );
      if (beforeRequest != null && !await beforeRequest()) {
        throw StateError('Notification admission revoked');
      }
      _rememberBinding(existing, mobileSessionId, binding);
      return _DesktopGatewaySession(existing, binding.runtimeSessionId);
    }

    final client = await _ensureSocket(beforeRequest: beforeRequest);
    if (beforeRequest != null && !await beforeRequest()) {
      throw StateError('Notification admission revoked');
    }
    _checkSocket(client);
    final binding = await _resumeOrCreateSingle(
      client,
      mobileSessionId,
      workingDirectory: effectiveWorkingDirectory,
      beforeRequest: beforeRequest,
    );
    if (beforeRequest != null && !await beforeRequest()) {
      throw StateError('Notification admission revoked');
    }
    _rememberBinding(client, mobileSessionId, binding);
    return _DesktopGatewaySession(client, binding.runtimeSessionId);
  }

  /// Single-flight wrapper for `_resumeOrCreate`: two concurrent callers for
  /// the same mobile session must not each issue a `session.create` and leave
  /// one gateway session orphaned.
  Future<_DesktopGatewayBinding> _resumeOrCreateSingle(
    WsClient client,
    String mobileSessionId, {
    String? workingDirectory,
    Future<bool> Function()? beforeRequest,
  }) {
    _checkSocket(client);
    final inFlight = _bindingInFlight[mobileSessionId];
    if (inFlight != null) return inFlight;
    final future = _resumeOrCreate(
      client,
      mobileSessionId,
      workingDirectory: workingDirectory,
      beforeRequest: beforeRequest,
    );
    _bindingInFlight[mobileSessionId] = future;
    future.whenComplete(() {
      if (identical(_bindingInFlight[mobileSessionId], future)) {
        _bindingInFlight.remove(mobileSessionId);
      }
    }).ignore();
    return future;
  }

  /// Single-flight socket establishment shared by `_connect` and
  /// `_connectControl`. Without this, concurrent callers both pass the
  /// `isConnected` check, both mint tickets, and both build sockets: the
  /// last assignment wins and the loser's socket leaks with the async-event
  /// bridge attached.
  Future<WsClient> _ensureSocket({Future<bool> Function()? beforeRequest}) {
    _checkOpen();
    if (_systemPaused) {
      // No network while the computer sleeps or the session is locked; a
      // caller retries after resume instead of racing the suspend.
      return Future.error(StateError('Paused while the computer sleeps.'));
    }
    final existing = _ws;
    if (existing != null && existing.isConnected) {
      return Future.value(existing);
    }
    final inFlight = _socketInFlight;
    if (inFlight != null) return inFlight;
    final future = _openSocket(existing, beforeRequest: beforeRequest);
    if (!_closed) _socketInFlight = future;
    future.whenComplete(() {
      if (identical(_socketInFlight, future)) _socketInFlight = null;
    }).ignore();
    return future;
  }

  Future<WsClient> _openSocket(
    WsClient? existing, {
    Future<bool> Function()? beforeRequest,
  }) async {
    _checkOpen();
    _connectionListener?.call(
      existing == null
          ? DesktopConnectionState.connecting
          : DesktopConnectionState.reconnecting,
    );
    _checkOpen();
    existing?.close();
    _checkOpen();
    _gatewaySessionIds.clear();
    _serverRequests.clear();
    _serverRequestClients.clear();
    _serverRequestMobileSessionIds.clear();
    _serverRequestEvents.clear();
    _serverClarifyRemaining.clear();
    _serverApprovalByMobileSession.clear();
    // A fresh socket means a possibly-replaced server: forget old
    // -32601 verdicts so an upgraded gateway's methods are re-discovered
    // instead of staying short-circuited until app restart. gateway.ready
    // on the new socket re-populates protocol/advertisement.
    _capabilities.reset();
    _checkOpen();
    final deploymentToken = _dashboard.deploymentToken;
    final ticket = deploymentToken != null
        ? null
        : await _dashboard.mintWebSocketTicket();
    if (beforeRequest != null && !await beforeRequest()) {
      throw StateError('Notification admission revoked');
    }
    _checkOpen();
    // The computer slept or the session locked while the ticket was minted:
    // do not open a socket during the pause. The pause remembered this dial
    // and reconnects when it lifts.
    _checkNotPaused();
    final client = _socketClient(
      deploymentToken: deploymentToken,
      ticket: ticket,
    );
    _installAsyncEventBridge(client);
    final inheritedConnectionListener = client.onConnectionChanged;
    client.onConnectionChanged = (connected) {
      if (_closed) return;
      inheritedConnectionListener?.call(connected);
      if (_closed) return;
      if (connected) {
        slashRefusals.reset();
        // Fires inside connect() before _ws is assigned, so no identical()
        // guard is possible here. The single-flight in _ensureSocket keeps
        // loser sockets from being built concurrently.
        _reconnectAttempts = 0;
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
        // The drop cleared every runtime binding and the server forgot the
        // old socket's sessions. Re-bind each stored session on this
        // fresh socket immediately — a turn that completed detached during
        // the outage must be addressable (and its history refetchable)
        // without waiting for the next user action. Initial connects have
        // no stored ids, so this is a no-op there. Individual resume
        // failures are swallowed: a later explicit call retries the same
        // single-flight path.
        if (!_closed && _storedSessionIds.isNotEmpty) {
          unawaited(_rebindStoredSessions(client));
        }
        _connectionListener?.call(DesktopConnectionState.connected);
      } else if (identical(_ws, client)) {
        slashRefusals.reset();
        _gatewaySessionIds.clear();
        _connectionListener?.call(DesktopConnectionState.disconnected);
        // A socket that was once live and then dropped (phone sleep,
        // heartbeat timeout, gateway restart) must come back on its own:
        // the user is often not looking at the chat window when it dies,
        // and every later RPC would otherwise fail until app restart.
        // Stored session ids survive the drop, so the reopened socket
        // re-binds each session via session.resume on next use.
        _scheduleReconnect();
      }
    };
    try {
      await client.connect();
      // The greeting says whether this gateway is a session authority
      // (Hermes 0.23+), and every request is shaped by that. It arrives
      // just after the upgrade; a request written before it would go out in
      // the legacy shape and be refused. A gateway that never greets is
      // served the legacy shapes after a short wait.
      try {
        await client.waitForGatewayReady(timeout: gatewayReadyGrace);
      } on TimeoutException {
        // No greeting: an older gateway.
      }
      if (_closed) {
        client.close();
        throw StateError('DesktopGatewayClient is closed.');
      }
      // A dial in flight when the pause began must not leave a live socket
      // behind it: close it and let the wake reconnect.
      _checkNotPaused();
      _ws = client;
      return client;
    } catch (_) {
      client.close();
      if (identical(_ws, client)) _ws = null;
      _connectionListener?.call(DesktopConnectionState.disconnected);
      rethrow;
    }
  }

  /// Exponential-backoff reconnect loop, started when a previously-live
  /// socket drops. Runs independently of the UI: the socket is back before
  /// the user opens the chat again. Retries until success or client close;
  /// detached-turn recovery has no safe deadline after which a reply may be
  /// abandoned. The delay remains capped so a long outage does not spin.
  void _scheduleReconnect() {
    if (_closed ||
        _systemPaused ||
        !_reconnectAllowed ||
        _reconnectTimer != null) {
      return;
    }
    _reconnectAttempts++;
    final exponent = _reconnectAttempts.clamp(1, 5);
    final delay = Duration(seconds: (1 << (exponent - 1)).clamp(2, 30));
    _reconnectTimer = Timer(delay, () async {
      _reconnectTimer = null;
      if (_closed) return;
      _connectionListener?.call(DesktopConnectionState.reconnecting);
      try {
        await _ensureSocket();
      } catch (_) {
        if (!_closed) _scheduleReconnect();
      }
    });
  }

  /// Re-establish the runtime binding for every stored session on a fresh
  /// socket. Runs fire-and-forget from the connected callback so a reply
  /// that finished server-side during an outage is immediately addressable
  /// on the new socket; the UI's resync (ensureSession + history refetch)
  /// then single-flights with these resumes instead of racing them.
  Future<void> _rebindStoredSessions(WsClient client) async {
    if (_applicationOwnsRecovery) return;
    // The connected callback fires inside WsClient.connect() before the
    // await returns; hop off that frame so the socket's message pump is
    // fully live before we issue session.resume over it.
    await Future<void>.delayed(Duration.zero);
    // Snapshot: the map may mutate while resumes are in flight.
    final mobileIds = List<String>.from(_storedSessionIds.keys);
    for (final mobileId in mobileIds) {
      if (_closed || !client.isConnected) return;
      // _ws is null only while this client's own connect() is still
      // returning — that is this socket's own pending assignment, not a
      // replacement. A non-null different client means we were superseded.
      final current = _ws;
      if (current != null && !identical(current, client)) return;
      try {
        final binding = await _resumeOrCreateSingle(
          client,
          mobileId,
          workingDirectory: _workingDirectories[mobileId],
        );
        final after = _ws;
        if (_closed || (after != null && !identical(after, client))) return;
        _rememberBinding(client, mobileId, binding);
      } catch (_) {
        // Swallow: a later explicit action retries the same single-flight
        // resume path; a resume error must never escape the socket callback.
      }
    }
  }

  Future<_DesktopGatewayBinding> _resumeOrCreate(
    WsClient client,
    String mobileSessionId, {
    String? workingDirectory,
    Future<bool> Function()? beforeRequest,
  }) async {
    _checkSocket(client);
    if (beforeRequest != null && !await beforeRequest()) {
      throw StateError('Notification admission revoked');
    }
    _checkSocket(client);
    final storedSessionId =
        _storedSessionIds[mobileSessionId] ?? mobileSessionId;
    try {
      final resumed = await client.resumeSessionDetails(storedSessionId);
      _checkSocket(client);
      return _DesktopGatewayBinding(
        runtimeSessionId: resumed.runtimeSessionId,
        storedSessionId: storedSessionId,
        resumed: resumed,
      );
    } on JsonRpcError catch (error) {
      _checkSocket(client);
      // Known durable chats never silently become new chats on reconnect.
      if (_resumeOnlySessions.contains(mobileSessionId)) rethrow;
      // A session-authority gateway names an unknown id `not_found` (4001);
      // the legacy sidecar answers 4007 "session not found".
      if (error.code != 4007 &&
          error.reason != 'not_found' &&
          !error.message.toLowerCase().contains('session not found')) {
        rethrow;
      }
      // New mobile chats do not exist in Hermes yet. Stock Hermes rejects a
      // client-supplied `session_id` on session.create, so retain both gateway-
      // minted identities: runtime for this socket and stored for reconnect.
      final created = await client.createSession(
        workingDirectory: workingDirectory,
      );
      _checkSocket(client);
      return _DesktopGatewayBinding(
        runtimeSessionId: created.runtimeSessionId,
        storedSessionId: created.storedSessionId,
        created: created.hasEmptyHistory,
      );
    }
  }

  void _rememberBinding(
    WsClient client,
    String mobileSessionId,
    _DesktopGatewayBinding binding,
  ) {
    _checkSocket(client);
    final previousRuntime = _gatewaySessionIds[mobileSessionId];
    final previousStored = _storedSessionIds[mobileSessionId];
    final bindingChanged =
        _gatewaySessionIds[mobileSessionId] != binding.runtimeSessionId ||
        _storedSessionIds[mobileSessionId] != binding.storedSessionId;
    _gatewaySessionIds[mobileSessionId] = binding.runtimeSessionId;
    _storedSessionIds[mobileSessionId] = binding.storedSessionId;
    // Validated empty creation, unlike resume or a missing HTTP transcript,
    // proves this new durable session has no earlier messages. Deliver once and
    // before binding observers can prepare a prompt or persist its receipt.
    try {
      if (binding.created && !binding.creationDelivered) {
        binding.creationDelivered = true;
        _sessionCreatedListener?.call(mobileSessionId, binding.storedSessionId);
        _checkSocket(client);
      }
      if (bindingChanged) {
        _sessionBoundListener?.call(mobileSessionId, binding.storedSessionId);
        _checkSocket(client);
      }
    } catch (_) {
      // An explicitly rejected binding must not leave the transport ahead of
      // its application owner. Normal verified alias collisions converge in
      // that owner; incompatible identities/independent wire turns fail closed.
      // An observer may close this owner or replace its binding before it
      // rejects. Never resurrect cleared maps or roll back a newer binding.
      if (_ownsSocket(client) &&
          _gatewaySessionIds[mobileSessionId] == binding.runtimeSessionId &&
          _storedSessionIds[mobileSessionId] == binding.storedSessionId) {
        if (previousRuntime == null) {
          _gatewaySessionIds.remove(mobileSessionId);
        } else {
          _gatewaySessionIds[mobileSessionId] = previousRuntime;
        }
        if (previousStored == null) {
          _storedSessionIds.remove(mobileSessionId);
        } else {
          _storedSessionIds[mobileSessionId] = previousStored;
        }
      }
      rethrow;
    }
    final resumed = binding.resumed;
    if (resumed != null && resumed.openRequests.isNotEmpty) {
      // The resume payload carries unanswered server→client requests. Deliver
      // only after the runtime sid is mapped back to this mobile chat.
      client.deliverOpenRequests(resumed.openRequests);
      _checkSocket(client);
    }
    final inflight = resumed?.inflight;
    final error = inflight?['error']?.toString().trim() ?? '';
    final status = (inflight?['status'] ?? resumed?.status)
        ?.toString()
        .trim()
        .toLowerCase();
    const terminalFailures = {
      'error',
      'failed',
      'interrupted',
      'cancelled',
      'canceled',
    };
    if (resumed != null &&
        (error.isNotEmpty || terminalFailures.contains(status))) {
      if (binding.resumeStateDelivered) return;
      binding.resumeStateDelivered = true;
      // Deliver after the binding maps are authoritative. The UI may already
      // have begun a history fetch from the connected callback; its recovery
      // generation makes that fetch harmless once this failure clears it.
      scheduleMicrotask(() {
        if (!_ownsSocket(client) ||
            _gatewaySessionIds[mobileSessionId] != binding.runtimeSessionId ||
            _storedSessionIds[mobileSessionId] != binding.storedSessionId) {
          return;
        }
        _asyncEventListener?.call(
          mobileSessionId,
          StreamEvent(
            type: 'turn.error',
            data: {
              'session_id': binding.runtimeSessionId,
              'message': error.isNotEmpty ? error : 'Detached turn $status',
              if (status != null && status.isNotEmpty) 'status': status,
            },
            isComplete: true,
            sessionId: binding.runtimeSessionId,
          ),
        );
      });
    }
  }

  /// The gateway's stored session key bound to a mobile session id, when a
  /// binding exists. Stored keys address rows in the session DB (move,
  /// resume); mobile ids do not survive into gateway-side lookups.
  String? storedSessionKeyFor(String mobileSessionId) =>
      _storedSessionIds[mobileSessionId];

  /// True when [error] says the runtime session id the gateway was handed no
  /// longer exists — the detached/orphan-reap or eviction signature. The
  /// gateway's own rejection text tells the client to resume the STORED id
  /// (`_sess_nowait`, 4001), so this is a recoverable stale-binding, not a
  /// hard failure.
  static bool _isStaleRuntimeSession(JsonRpcError error) {
    // A session-authority gateway answers every refusal with 4001 and names
    // the reason: only `not_found` means the runtime is gone. Re-resuming
    // and resending on `session_busy` or `invalid_params` would repeat a
    // request the owner already refused.
    if (error.reason != null) return error.reason == 'not_found';
    if (error.code == 4001) return true;
    final message = error.message.toLowerCase();
    return message.contains('session not found') ||
        message.contains('not in memory');
  }

  /// Runs a session-scoped gateway call with one automatic recovery from a
  /// stale runtime binding.
  ///
  /// The gateway orphan-reaps detached runtimes and LRU-evicts idle ones, so
  /// a cached runtime sid can name a session the server no longer holds even
  /// while the stored row lives on. Every session-scoped RPC then fails with
  /// 4001 "session not found" and the UI shows a dropped chat. Recovery is
  /// exactly what the gateway's rejection asks for: drop the stale runtime
  /// mapping, `session.resume` the stored key on the live socket, and retry
  /// the call once with the fresh runtime sid. A second stale failure is a
  /// real one (stored row gone too) and propagates.
  Future<T> _callSessionScoped<T>(
    String mobileSessionId,
    Future<T> Function(_DesktopGatewaySession session) call, {
    bool Function()? mayRetry,
    Future<bool> Function()? beforeRequest,
  }) async {
    final session = await _connect(
      mobileSessionId,
      beforeRequest: beforeRequest,
    );
    if (beforeRequest != null && !await beforeRequest()) {
      throw StateError('Notification admission revoked');
    }
    _checkSocket(session.client);
    try {
      final result = await call(session);
      _checkSocket(session.client);
      return result;
    } on JsonRpcError catch (error) {
      if (!_isStaleRuntimeSession(error) || mayRetry?.call() == false) rethrow;
      final client = _ws;
      if (client == null ||
          !_ownsSocket(session.client) ||
          !_rememberedRuntimeIsStale(mobileSessionId, session.sessionId)) {
        rethrow;
      }
      _gatewaySessionIds.remove(mobileSessionId);
      if (beforeRequest != null && !await beforeRequest()) {
        throw StateError('Notification admission revoked');
      }
      final binding = await _resumeOrCreateSingle(
        client,
        mobileSessionId,
        workingDirectory: _workingDirectories[mobileSessionId],
        beforeRequest: beforeRequest,
      );
      if (beforeRequest != null && !await beforeRequest()) {
        throw StateError('Notification admission revoked');
      }
      _rememberBinding(client, mobileSessionId, binding);
      return call(_DesktopGatewaySession(client, binding.runtimeSessionId));
    }
  }

  /// Guard against retrying a call whose sid was not the one we cached: if
  /// some other path already re-bound the session while the call was in
  /// flight, the error came from a different generation and a blind retry
  /// could double-execute against the new binding.
  bool _rememberedRuntimeIsStale(
    String mobileSessionId,
    String usedRuntimeId,
  ) => _gatewaySessionIds[mobileSessionId] == usedRuntimeId;

  Future<void> ensureSession(
    String sessionId, {
    String? workingDirectory,
  }) async {
    await _connect(sessionId, workingDirectory: workingDirectory);
  }

  void bindStoredSession(String localSessionId, String storedSessionId) {
    _checkOpen();
    final previous = _storedSessionIds[localSessionId];
    if (previous != null && previous != storedSessionId) {
      throw StateError('A durable session binding cannot be replaced.');
    }
    _resumeOnlySessions.add(localSessionId);
    _storedSessionIds[localSessionId] = storedSessionId;
  }

  /// Read/attach only: recovery must never fall through to session.create.
  Future<ResumedGatewaySession> resumeSubmittedSession({
    required String localSessionId,
    required String storedSessionId,
    bool Function()? acceptsResult,
    Future<bool> Function()? beforeRequest,
  }) {
    bindStoredSession(localSessionId, storedSessionId);
    final existing = _resumeOnlyInFlight[localSessionId];
    if (existing != null) return existing;
    final future = () async {
      if (beforeRequest != null && !await beforeRequest()) {
        throw StateError('Notification admission revoked');
      }
      final client = await _ensureSocket(beforeRequest: beforeRequest);
      if (beforeRequest != null && !await beforeRequest()) {
        throw StateError('Notification admission revoked');
      }
      _checkSocket(client);
      final resumed = await client.resumeSessionDetails(storedSessionId);
      if (beforeRequest != null && !await beforeRequest()) {
        throw StateError('Notification admission revoked');
      }
      if (_closed || !identical(client, _ws) || !client.isConnected) {
        throw StateError('Session resume belongs to a replaced socket.');
      }
      if (acceptsResult?.call() == false) return resumed;
      _rememberBinding(
        client,
        localSessionId,
        _DesktopGatewayBinding(
          runtimeSessionId: resumed.runtimeSessionId,
          storedSessionId: storedSessionId,
          resumed: resumed,
        ),
      );
      return resumed;
    }();
    _resumeOnlyInFlight[localSessionId] = future;
    future.whenComplete(() {
      if (identical(_resumeOnlyInFlight[localSessionId], future)) {
        _resumeOnlyInFlight.remove(localSessionId);
      }
    }).ignore();
    return future;
  }

  void setReconnectAllowed(bool allowed) {
    if (_closed) return;
    _reconnectAllowed = allowed;
    if (!allowed) {
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    } else if (_reconnectAfterPause && !_systemPaused) {
      _reconnectAfterPause = false;
      _reconnectNow();
    }
  }

  /// All stock stream frames, including deltas/tools on a resumed socket.
  void setSessionEventListener(DesktopAsyncEventCallback? listener) {
    if (_closed) return;
    _sessionEventListener = listener;
    _applicationOwnsRecovery = listener != null;
  }

  /// The dashboard client backing this gateway's auth/ticket flow.
  ///
  /// Exposed so collaborators (e.g. the Projects folder provisioner) can
  /// reuse this connection's cached auth and single-flight login instead of
  /// standing up a second unauthenticated HTTP client.
  DashboardClient get dashboard => _dashboard;

  /// One control-plane JSON-RPC call on this connection's socket.
  ///
  /// Opens the socket when the workspace has not connected yet. The call stays
  /// on this client, so a profile name cannot hop to another machine.
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 45),
  }) async {
    final client = await _ensureSocket();
    final response = await client.send(method, params, timeout: timeout);
    final error = response['error'];
    if (error != null) {
      throw JsonRpcError.fromGateway(
        method,
        error is Map ? Map<dynamic, dynamic>.from(error) : const {},
        fallbackMessage: 'The gateway refused $method.',
      );
    }
    final result = response['result'];
    if (result is Map<String, dynamic>) return result;
    if (result is Map) return Map<String, dynamic>.from(result);
    return <String, dynamic>{};
  }

  /// Server-owned Hermes Projects for this gateway.
  ///
  /// Projects are connection-scoped, not session-scoped, so this opens the
  /// shared socket without resuming or creating any chat session. An older
  /// gateway without `projects.*` surfaces a [ProjectsUnsupportedException]
  /// instead of an error state, so callers can fall back to local grouping.
  ProjectsGatewayClient get projects {
    _checkOpen();
    return _projects ??= ProjectsGatewayClient((method, params) async {
      final client = await _connectControl();
      return client.send(method, params);
    }, capabilities: _capabilities);
  }

  /// What this gateway advertises or has been proven to support.
  ///
  /// Populated from `gateway.ready` on every connect and refined by the
  /// outcome of real calls, so a feature can degrade politely on an older
  /// gateway instead of failing.
  CapabilityRegistry get capabilities => _capabilities;

  /// Presence never starts a connection or creates a missing chat.
  (WsClient, String)? presenceFor(String localSessionId) {
    final ws = _ws;
    final id = _gatewaySessionIds[localSessionId];
    return ws != null && _ownsSocket(ws) && id != null ? (ws, id) : null;
  }

  /// Opens (or reuses) the gateway socket without binding it to a session.
  Future<WsClient> _connectControl() => _ensureSocket();

  /// The gateway socket, authenticated the way Hermes Desktop does it. A
  /// deployment-token connection puts the token in `?token=`, which loopback,
  /// `--insecure` and gated gateways all accept (a loopback gateway cannot
  /// mint `POST /api/auth/ws-ticket` tickets); every other connection spends
  /// a single-use ticket in the subprotocol. The upgrade never follows a
  /// redirect either way.
  WsClient _socketClient({String? deploymentToken, String? ticket}) =>
      deploymentToken != null
      ? WsClient(
          _baseUrl,
          token: deploymentToken,
          profile: _gatewayProfile,
          clientCertificate: _clientCertificate,
          customHeaders: _customHeaders,
        )
      : WsClient(
          _baseUrl,
          ticket: ticket,
          ticketInSubprotocol: true,
          profile: _gatewayProfile,
          clientCertificate: _clientCertificate,
          customHeaders: _customHeaders,
        );

  /// Creates the source-only recovery-v2 registry without changing any legacy
  /// session, submit, interrupt, or event route in this client.
  GatewayTurnCoordinatorRegistry enableTurnRecoveryCoordinator({
    GatewayTurnJournal? journal,
  }) {
    _checkOpen();
    return _turnCoordinatorRegistry ??=
        GatewayTurnCoordinatorRegistry(
            connectionId: _connectionId,
            endpointDigest: _endpointDigest(_baseUrl),
            journal: journal ?? GatewayTurnJournal(),
            freshSocketFactory: () async {
              _checkOpen();
              final deploymentToken = _dashboard.deploymentToken;
              final ticket = deploymentToken != null
                  ? null
                  : await _dashboard.mintWebSocketTicket();
              _checkOpen();
              final client = _socketClient(
                deploymentToken: deploymentToken,
                ticket: ticket,
              );
              _installAsyncEventBridge(client);
              return client;
            },
          )
          ..onRuntimeBound = (localSessionId, runtimeSessionId) {
            if (_closed) return;
            _gatewaySessionIds[localSessionId] = runtimeSessionId;
          };
  }

  void setConnectionListener(DesktopConnectionCallback? listener) {
    if (_closed) return;
    _connectionListener = listener;
  }

  /// Observes each authoritative legacy session binding.
  ///
  /// A stock gateway can create the durable session lazily during the first
  /// attachment or prompt call, so consumers must not rely on an eager
  /// [ensureSession] having already exposed the stored identity.
  /// [onCreated] carries only explicitly proven empty creation, never resume
  /// or an incomplete/nonempty creation response.
  void setSessionBoundListener(
    GatewayTurnSessionBoundCallback? listener, {
    GatewayTurnSessionBoundCallback? onCreated,
  }) {
    if (_closed) return;
    _sessionBoundListener = listener;
    _sessionCreatedListener = onCreated;
  }

  Future<RemoteFileAttachment> attachFile({
    required String sessionId,
    required String name,
    required String dataUrl,
  }) async {
    return _callSessionScoped(
      sessionId,
      (gateway) => gateway.client.attachFile(
        sessionId: gateway.sessionId,
        name: name,
        dataUrl: dataUrl,
      ),
    );
  }

  Future<void> submitPrompt({
    required String sessionId,
    required String text,
    required StreamCallback onEvent,
    required void Function() onSent,
    bool Function()? maySend,
    Future<bool> Function()? beforeSend,
    void Function()? onAccepted,
    String? submissionId,
    Future<void> Function()? beforeLegacy,
    Future<void> Function(Object?, String)? onReceipt,
    Map<String, Object?> extraParams = const {},
  }) async {
    var emitted = false;
    if (beforeSend != null && !await beforeSend()) {
      throw StateError('Notification admission revoked');
    }
    await _callSessionScoped(
      sessionId,
      (gateway) async {
        if (beforeSend != null && !await beforeSend()) {
          throw StateError('Notification admission revoked');
        }
        // Admission can converge while _connect is suspended. Nothing awaits
        // between this fence and the socket sink write.
        if (maySend?.call() == false) {
          throw StateError('Prompt admission is no longer owned.');
        }
        _checkSocket(gateway.client);
        return gateway.client.submitPrompt(
          text,
          sessionId: gateway.sessionId,
          submissionId: submissionId,
          beforeLegacy: beforeLegacy,
          onReceipt: onReceipt,
          extraParams: extraParams,
          onEvent: (event) {
            if (!_closed) onEvent(event);
          },
          beforeSend: beforeSend,
          maySend: () => !_closed && (maySend?.call() ?? true) && !_closed,
          onAccepted: () {
            if (!_closed) onAccepted?.call();
          },
          onSent: () {
            if (_closed) return;
            emitted = true;
            _resumeOnlySessions.add(sessionId);
            onSent();
          },
        );
      },
      mayRetry: () => !emitted,
      beforeRequest: beforeSend,
    );
  }

  /// Receives durable session-scoped events plus terminal turn frames.
  ///
  /// Terminal frames are also delivered through [submitPrompt] while its
  /// listener is attached. The async path is required after socket close,
  /// when a detached turn can settle on the resumed session; ChatScreen
  /// ignores the duplicate unless legacy reattach recovery is pending.
  void setAsyncEventListener(
    DesktopAsyncEventCallback? listener, {
    DesktopAsyncEventSessionPredicate? acceptsSession,
  }) {
    if (_closed) return;
    _asyncEventListener = listener;
    _asyncEventAcceptsSession = listener == null ? null : acceptsSession;
  }

  void _installAsyncEventBridge(WsClient client) {
    _checkOpen();
    // Every socket greets us with gateway.ready; that greeting is where the
    // capability registry learns what this Hermes instance offers.
    _capabilities.bindTo(client);
    final gatewayReady = client.onGatewayReady;
    client.onGatewayReady = (frame) {
      if (_closed) return;
      gatewayReady?.call(frame);
      if (!_socketReady.isClosed) _socketReady.add(null);
    };
    _serverRequestClientOrdinals.putIfAbsent(
      client,
      () => _nextServerRequestClientOrdinal++,
    );
    client.onServerRequest = (request) => _handleServerRequest(client, request);
    client.onConnectionClosed = () => _forgetServerRequestsFrom(client);
    client.onStreamEvent = (event) {
      if (_closed) return;
      if (!_gatewayEvents.isClosed) _gatewayEvents.add(event);
      final ownerSessionId = _mobileSessionIdFor(
        event.sessionId ?? event.data['session_id']?.toString(),
      );
      if (ownerSessionId != null && event.type != 'request.cancel') {
        _sessionEventListener?.call(ownerSessionId, event);
      }
      if (_closed) return;
      if (!_asyncEventTypes.contains(event.type)) return;
      var deliveredEvent = event;
      if (event.type == 'request.cancel') {
        final wireRequestId = event.data['id']?.toString() ?? '';
        final requestId = _findServerRequestKey(client, wireRequestId);
        if (requestId != null) {
          _forgetServerRequest(requestId);
          deliveredEvent = StreamEvent(
            type: event.type,
            data: {...event.data, 'id': requestId},
            sessionId: event.sessionId,
          );
        }
      }
      final mobileSessionId = _mobileSessionIdFor(
        event.data['session_id']?.toString(),
      );
      if (mobileSessionId == null) return;
      _asyncEventListener?.call(mobileSessionId, deliveredEvent);
    };
  }

  String _serverRequestKey(WsClient client, String wireRequestId) =>
      '$_serverRequestNamespace.${_serverRequestClientOrdinals[client]}.${_nextServerRequestOrdinal++}:'
      '$wireRequestId';

  String? _findServerRequestKey(WsClient client, String wireRequestId) {
    for (final entry in _serverRequestClients.entries) {
      if (identical(entry.value, client) &&
          _serverRequests[entry.key]?.id == wireRequestId) {
        return entry.key;
      }
    }
    return null;
  }

  String? _mobileSessionIdFor(String? gatewaySessionId) {
    if (gatewaySessionId != null && gatewaySessionId.isNotEmpty) {
      for (final entry in _gatewaySessionIds.entries) {
        if (entry.value == gatewaySessionId) return entry.key;
      }
    } else if (_gatewaySessionIds.length == 1) {
      return _gatewaySessionIds.keys.single;
    }
    return null;
  }

  bool _handleServerRequest(WsClient client, GatewayServerRequest request) {
    if (_closed || !client.isConnected) return false;
    const supported = {'clarify', 'approval', 'sudo', 'secret', 'setup_beat'};
    if (!supported.contains(request.method)) return false;

    final gatewaySessionId = request.params['session_id']?.toString();
    final mobileSessionId = _mobileSessionIdFor(gatewaySessionId);
    if (mobileSessionId == null || _asyncEventListener == null) return false;
    final acceptsSession = _asyncEventAcceptsSession;
    if (acceptsSession != null && !acceptsSession(mobileSessionId)) {
      return false;
    }
    if (_closed) return false;

    final existingKey = _findServerRequestKey(client, request.id);
    if (existingKey != null) {
      final existing = _serverRequests[existingKey];
      if (existing?.method == request.method &&
          jsonEncode(existing!.params) == jsonEncode(request.params)) {
        return true; // same unresolved replay, not a new approval authority
      }
      _forgetServerRequest(existingKey);
      _asyncEventListener?.call(
        mobileSessionId,
        StreamEvent(
          type: 'request.cancel',
          // Replaced by the delivery below under the same server id.
          data: {
            'id': existingKey,
            'method': existing?.method,
            'settled': false,
          },
        ),
      );
      if (_closed) return false;
    }
    final requestId = _serverRequestKey(client, request.id);
    _serverRequests[requestId] = request;
    _serverRequestClients[requestId] = client;
    _serverRequestMobileSessionIds[requestId] = mobileSessionId;
    final data = Map<String, dynamic>.from(request.params);
    data['server_request_id'] = requestId;
    // Stable across reconnect replays, unlike the namespaced local key: one
    // server request alerts once.
    data['wire_request_id'] = request.id;

    if (request.method == 'clarify') {
      data['request_id'] = requestId;
      final questions = data['questions'];
      final lockedAnswers = data['answers'];
      final lockedQuestionIds = lockedAnswers is Map
          ? lockedAnswers.keys.map((key) => key.toString()).toSet()
          : const <String>{};
      final qids = <String>{};
      final remainingQuestions = <dynamic>[];
      if (questions is List) {
        for (final raw in questions) {
          if (raw is! Map) continue;
          final qid = raw['qid']?.toString().trim() ?? '';
          if (qid.isEmpty || lockedQuestionIds.contains(qid)) continue;
          qids.add(qid);
          remainingQuestions.add(raw);
        }
      }
      if (qids.isEmpty) {
        _forgetServerRequest(requestId);
        return false;
      }
      data['questions'] = remainingQuestions;
      _serverClarifyRemaining[requestId] = qids;
    } else if (request.method == 'approval') {
      final previous = _serverApprovalByMobileSession[mobileSessionId];
      if (previous != null && previous != requestId) {
        // ChatScreen presents one approval route at a time. Reject a concurrent
        // request instead of replacing the visible request and stranding both.
        _forgetServerRequest(requestId);
        return false;
      }
      _serverApprovalByMobileSession[mobileSessionId] = requestId;
    } else {
      // Legacy event models key sensitive prompts by `request_id`; for the
      // peer-to-peer protocol the JSON-RPC id is the response correlation.
      data['request_id'] = requestId;
    }

    final event = StreamEvent(
      type: '${request.method}.request',
      data: data,
      sessionId: gatewaySessionId,
    );
    _serverRequestEvents[requestId] = event;
    _asyncEventListener!.call(mobileSessionId, event);
    return true;
  }

  void _forgetServerRequest(String requestId) {
    _serverRequests.remove(requestId);
    _serverRequestClients.remove(requestId);
    _serverRequestMobileSessionIds.remove(requestId);
    _serverRequestEvents.remove(requestId);
    _serverClarifyRemaining.remove(requestId);
    _serverApprovalByMobileSession.removeWhere((_, id) => id == requestId);
  }

  void _forgetServerRequestsFrom(WsClient client) {
    if (_closed) return;
    final requestIds = _serverRequestClients.entries
        .where((entry) => identical(entry.value, client))
        .map((entry) => entry.key)
        .toList(growable: false);
    for (final requestId in requestIds) {
      final request = _serverRequests[requestId];
      final mobileSessionId = _serverRequestMobileSessionIds[requestId];
      if (_closed) return;
      _forgetServerRequest(requestId);
      if (request != null && mobileSessionId != null) {
        _asyncEventListener?.call(
          mobileSessionId,
          StreamEvent(
            type: 'request.cancel',
            // The socket went, not the request: the server may still wait on
            // it and replay it on the next connection.
            data: {'id': requestId, 'method': request.method, 'settled': false},
          ),
        );
      }
    }
    _serverRequestClientOrdinals.remove(client);
  }

  void _rejectServerRequest(String requestId, String message) {
    _serverRequests[requestId]?.fail(-32601, message);
    _forgetServerRequest(requestId);
  }

  /// Replays unresolved requests when a replacement route mounts.
  void replayServerRequestsForSession(String mobileSessionId) {
    if (_closed) return;
    final listener = _asyncEventListener;
    if (listener == null) return;
    for (final entry in _serverRequestMobileSessionIds.entries.toList()) {
      if (_closed || !identical(listener, _asyncEventListener)) return;
      if (entry.value != mobileSessionId) continue;
      final event = _serverRequestEvents[entry.key];
      if (event != null) listener(mobileSessionId, event);
    }
  }

  /// Rejects requests that no mounted route can answer. A `setup_beat` card
  /// is not one of them: like the Desktop, which parks it per session and
  /// shows it again on resume, it waits for its chat to be opened again
  /// ([replayServerRequestsForSession]) until the backend withdraws it.
  void rejectServerRequestsForSession(String mobileSessionId) {
    final requestIds = _serverRequestMobileSessionIds.entries
        .where(
          (entry) =>
              entry.value == mobileSessionId &&
              _serverRequests[entry.key]?.method != 'setup_beat',
        )
        .map((entry) => entry.key)
        .toList(growable: false);
    for (final requestId in requestIds) {
      _rejectServerRequest(
        requestId,
        'No mounted client can answer this request',
      );
    }
  }

  /// Drops stale local authority after an authoritative turn terminal. Unlike
  /// route disposal, this does not send denials or any other server response.
  void forgetSettledServerRequestsForSession(String mobileSessionId) {
    final ids = _serverRequestMobileSessionIds.entries
        .where((entry) => entry.value == mobileSessionId)
        .map((entry) => entry.key)
        .toList(growable: false);
    for (final id in ids) {
      _forgetServerRequest(id);
    }
  }

  /// Larger than any event seq: the read carries `open_requests` only.
  static const _probeLastSeen = 9007199254740991;

  /// Asks the gateway which of this socket's requests it still waits on and
  /// withdraws the rest locally, as a `request.cancel` to the owner. Nothing
  /// is answered or resent. Only the legacy sidecar gateway needs this: when
  /// another client answers, it settles the request without telling this one
  /// (a session-authority gateway sends `request.cancel reason: resolved` to
  /// every attached viewer, and its replay read has side effects).
  Future<void> revalidateServerRequests() async {
    final client = _ws;
    if (_closed || client == null || !client.isConnected) return;
    if (client.sessionAuthority) return;
    final byRuntime = <String, List<String>>{};
    for (final entry in _serverRequestClients.entries) {
      if (!identical(entry.value, client)) continue;
      final sid = _serverRequests[entry.key]?.params['session_id']?.toString();
      if (sid == null || sid.isEmpty) continue;
      byRuntime.putIfAbsent(sid, () => []).add(entry.key);
    }
    for (final entry in byRuntime.entries) {
      Map<String, dynamic> response;
      try {
        response = await client.send('session.events.since', {
          'session_id': entry.key,
          'last_seen': _probeLastSeen,
        }, timeout: const Duration(seconds: 10));
      } catch (_) {
        continue; // unknown: keep what the socket delivered
      }
      if (_closed || !identical(_ws, client)) return;
      final result = response['result'];
      final open = result is Map ? result['open_requests'] : null;
      if (open is! List) continue;
      final listed = {
        for (final raw in open)
          if (raw is Map && raw['id'] is String) raw['id'] as String,
      };
      for (final key in entry.value) {
        final request = _serverRequests[key];
        if (request == null || listed.contains(request.id)) continue;
        final mobileSessionId = _serverRequestMobileSessionIds[key];
        _forgetServerRequest(key);
        if (mobileSessionId == null) continue;
        _asyncEventListener?.call(
          mobileSessionId,
          StreamEvent(
            type: 'request.cancel',
            data: {'id': key, 'method': request.method, 'reason': 'resolved'},
          ),
        );
        if (_closed) return;
      }
    }
  }

  /// Whether this client owns an unresolved peer-to-peer request.
  bool ownsServerRequest(String requestId, String method) =>
      _serverRequests[requestId]?.method == method;

  /// Answers a connection operation card (`manage_catalog` rows) for the
  /// chat [sessionId] with `connection.respond`, owned by that chat's
  /// runtime session. False, with nothing sent, when the chat has no bound
  /// runtime session here; false too when the gateway does not say ok.
  Future<bool> respondToConnection({
    required String sessionId,
    required String opId,
    required Map<String, dynamic> result,
  }) async {
    if (_closed) return false;
    final runtime = _gatewaySessionIds[sessionId];
    if (runtime == null || runtime.isEmpty || opId.isEmpty) return false;
    final reply = await call('connection.respond', {
      'owner': {'type': 'session', 'session_id': runtime},
      'op_id': opId,
      'result': result,
    });
    return reply['status'] == 'ok';
  }

  /// Answers the `setup_beat` card [requestId] for the chat [sessionId] on
  /// the socket it arrived on. False, and nothing is sent, when the request
  /// is no longer open here (answered, withdrawn, its socket gone) or
  /// belongs to another chat. An answer that did not go out leaves the
  /// request held ([holdsSetupBeat]), so the card can be answered again.
  bool respondToSetupBeat({
    required String sessionId,
    required String requestId,
    required Map<String, dynamic> result,
  }) {
    if (_closed) return false;
    final request = _serverRequests[requestId];
    final client = _serverRequestClients[requestId];
    if (request?.method != 'setup_beat' ||
        _serverRequestMobileSessionIds[requestId] != sessionId ||
        client == null ||
        !client.isConnected) {
      return false;
    }
    if (!request!.respond(result)) return false;
    _forgetServerRequest(requestId);
    return true;
  }

  /// Whether the `setup_beat` card [requestId] of the chat [sessionId] is
  /// still open here.
  bool holdsSetupBeat({required String sessionId, required String requestId}) =>
      !_closed &&
      _serverRequests[requestId]?.method == 'setup_beat' &&
      _serverRequestMobileSessionIds[requestId] == sessionId;

  /// Whether this client owns the active approval for [sessionId].
  ///
  /// When [requestId] is supplied, both identities must match. This lets a
  /// queued UI callback prove the request was not answered by another route
  /// before it opens a stale approval dialog.
  bool ownsApprovalRequest(String sessionId, {String? requestId}) {
    final activeRequestId = _serverApprovalByMobileSession[sessionId];
    return activeRequestId != null &&
        (requestId == null || activeRequestId == requestId) &&
        _serverRequests[activeRequestId]?.method == 'approval';
  }

  /// Steers only the currently bound live session. Reconnect/create and
  /// automatic retries could deliver the guidance to a different turn. On
  /// the canonical session authority the socket names the execution
  /// generation it last admitted, captured as this call starts; a refusal
  /// (`stale_generation`) propagates and is never retried.
  Future<bool> steerPrompt({
    required String sessionId,
    required String text,
  }) async {
    final gatewaySessionId = _gatewaySessionIds[sessionId];
    final client = _ws;
    if (gatewaySessionId == null || client == null || !client.isConnected) {
      throw StateError('The Desktop gateway session is no longer connected');
    }
    return client.steerSession(gatewaySessionId, text);
  }

  /// Whether the connected Desktop gateway can serve slash-command RPCs.
  /// Capability is transport-level: the catalogue call itself decides whether
  /// this particular server build understands `commands.catalog`.
  @override
  bool get slashCommandsSupported => _ws?.isConnected == true;

  /// Reads the slash-command catalogue for [sessionId]. A session that is not
  /// bound yet still gets the profile catalogue (the RPC's session id is
  /// optional).
  @override
  Future<SlashCommandCatalog> fetchSlashCommands({String? sessionId}) async {
    final client = _ws;
    if (client == null || !client.isConnected) {
      throw StateError('The Desktop gateway is no longer connected');
    }
    final gatewaySessionId = sessionId == null
        ? null
        : _gatewaySessionIds[sessionId];
    return client.commandsCatalog(gatewaySessionId);
  }

  /// Runs [command] through the bound Desktop session. Only the currently
  /// bound live session may execute: a reconnect or replacement route could
  /// deliver the command to a different chat. [onSent] fires once the RPC was
  /// written, so the caller can tell "never sent" from "delivery unknown".
  @override
  Future<SlashCommandResult> runSlashCommand({
    required String sessionId,
    required String command,
    void Function()? onSent,
  }) async {
    final gatewaySessionId = _gatewaySessionIds[sessionId];
    final client = _ws;
    if (gatewaySessionId == null || client == null || !client.isConnected) {
      throw StateError('The Desktop gateway session is no longer connected');
    }
    return client.slashExec(gatewaySessionId, command, onSent: onSent);
  }

  /// Whether [mobileSessionId] is bound to a gateway session on the live
  /// socket, so a session-scoped RPC ([requestSessionRpc]) can reach it.
  @override
  bool hasLiveSession(String mobileSessionId) {
    final client = _ws;
    if (_closed || client == null || !client.isConnected) return false;
    return _gatewaySessionIds.containsKey(mobileSessionId) ||
        _gatewaySessionIds.containsValue(mobileSessionId);
  }

  /// One session-scoped JSON-RPC. The local session id in [params] is
  /// replaced with the bound gateway id. Missing methods surface as
  /// [JsonRpcError] `-32601` so the caller can fall back to slash.exec.
  @override
  Future<Map<String, dynamic>> requestSessionRpc(
    String method,
    Map<String, dynamic> params,
  ) async {
    final requested = params['session_id']?.toString();
    final gatewaySessionId = requested == null
        ? null
        : (_gatewaySessionIds[requested] ??
              (_gatewaySessionIds.containsValue(requested) ? requested : null));
    final client = _ws;
    if (gatewaySessionId == null || client == null || !client.isConnected) {
      throw StateError('The Desktop gateway session is no longer connected');
    }
    final response = await client.send(method, {
      ...params,
      'session_id': gatewaySessionId,
    });
    final error = response['error'];
    if (error != null) {
      throw JsonRpcError.fromGateway(
        method,
        error is Map ? Map<dynamic, dynamic>.from(error) : const {},
        fallbackMessage: 'The gateway refused $method',
      );
    }
    final result = response['result'];
    if (result is Map<String, dynamic>) return result;
    if (result is Map) return Map<String, dynamic>.from(result);
    return const {};
  }

  /// Interrupts the active turn in the Desktop gateway runtime. On the
  /// canonical session authority it names the execution generation the
  /// socket last admitted, so a later claim is never interrupted by it; a
  /// `stale_generation` refusal propagates and is never retried.
  Future<bool> interruptPrompt({required String sessionId}) async {
    final gatewaySessionId = _gatewaySessionIds[sessionId];
    final client = _ws;
    if (gatewaySessionId == null || client == null || !client.isConnected) {
      return false;
    }
    await client.interruptSession(gatewaySessionId);
    return true;
  }

  /// Resolves an approval against an exact peer request when available, or
  /// falls back to the legacy session-keyed approval method.
  Future<void> respondToApproval({
    required String sessionId,
    required String choice,
    String? serverRequestId,
  }) async {
    final effectiveRequestId =
        serverRequestId ?? _serverApprovalByMobileSession[sessionId];
    final serverRequest = effectiveRequestId == null
        ? null
        : _serverRequests[effectiveRequestId];
    if (serverRequest != null) {
      if (!serverRequest.respond({'choice': choice})) {
        throw StateError('The server request socket is no longer connected');
      }
      _forgetServerRequest(effectiveRequestId!);
      return;
    }
    if (serverRequestId != null) {
      throw StateError('The approval request is no longer active');
    }
    final gatewaySessionId = _gatewaySessionIds[sessionId];
    final client = _ws;
    if (gatewaySessionId == null || client == null || !client.isConnected) {
      throw StateError('The Desktop gateway session is no longer connected');
    }
    await client.respondToApproval(sessionId: gatewaySessionId, choice: choice);
  }

  Future<void> respondToSudo({
    required String requestId,
    required String password,
  }) async {
    final serverRequest = _serverRequests[requestId];
    if (serverRequest?.method == 'sudo') {
      if (!serverRequest!.respond({'value': password})) {
        throw StateError('The server request socket is no longer connected');
      }
      _forgetServerRequest(requestId);
      return;
    }
    final client = _connectedClient();
    await client.respondToSudo(requestId: requestId, password: password);
  }

  Future<void> respondToSecret({
    required String requestId,
    required String value,
  }) async {
    final serverRequest = _serverRequests[requestId];
    if (serverRequest?.method == 'secret') {
      if (!serverRequest!.respond({'value': value})) {
        throw StateError('The server request socket is no longer connected');
      }
      _forgetServerRequest(requestId);
      return;
    }
    final client = _connectedClient();
    await client.respondToSecret(requestId: requestId, value: value);
  }

  Future<void> respondToClarify({
    required String requestId,
    required String answer,
    String? questionId,
  }) async {
    _checkOpen();
    final serverRequest = _serverRequests[requestId];
    // Local peer-request handles are namespaced by owner/socket, unlike legacy
    // wire IDs. A forgotten or foreign handle must never become a wire RPC.
    if (serverRequest?.method != 'clarify' &&
        _localServerRequestKey.hasMatch(requestId)) {
      throw StateError('The clarification request is no longer active');
    }
    final client = serverRequest?.method == 'clarify'
        ? _serverRequestClients[requestId]
        : _ws;
    if (client == null || !client.isConnected) {
      throw StateError('The Desktop gateway session is no longer connected');
    }
    if (serverRequest?.method == 'clarify') {
      final qid = questionId?.trim() ?? '';
      if (qid.isEmpty) {
        throw ArgumentError('questionId is required for a clarify request');
      }
      // Current Hermes locks each batch answer through clarify.lock; the last
      // lock resolves the original server request on the backend.
      final result = await client.respondToClarify(
        requestId: serverRequest!.id,
        answer: answer,
        questionId: qid,
        lockAnswer: true,
      );
      if (_closed ||
          !client.isConnected ||
          !identical(_serverRequests[requestId], serverRequest) ||
          !identical(_serverRequestClients[requestId], client)) {
        throw StateError('The clarification request is no longer active');
      }
      final status = result['status']?.toString();
      final rawRemaining = result['remaining'];
      final remaining =
          rawRemaining is List
                ? rawRemaining.map((value) => value.toString()).toSet()
                : status == 'expired'
                ? <String>{}
                : (_serverClarifyRemaining[requestId] ?? <String>{})
            ..remove(qid);
      _serverClarifyRemaining[requestId] = remaining;
      if (remaining.isNotEmpty) {
        final replayEvent = _serverRequestEvents[requestId];
        final rawQuestions = replayEvent?.data['questions'];
        if (replayEvent != null && rawQuestions is List) {
          _serverRequestEvents[requestId] = StreamEvent(
            type: replayEvent.type,
            data: {
              ...replayEvent.data,
              'questions': rawQuestions
                  .where(
                    (raw) =>
                        raw is Map &&
                        remaining.contains(raw['qid']?.toString()),
                  )
                  .toList(growable: false),
            },
            sessionId: replayEvent.sessionId,
          );
        }
      }
      final mobileSessionId = _serverRequestMobileSessionIds[requestId];
      if (mobileSessionId != null) {
        _asyncEventListener?.call(
          mobileSessionId,
          StreamEvent(
            type: 'clarify.remaining',
            data: {'id': requestId, 'remaining': remaining.toList()},
          ),
        );
      }
      if (remaining.isEmpty) {
        _forgetServerRequest(requestId);
      }
      return;
    }
    await client.respondToClarify(
      requestId: requestId,
      answer: answer,
      questionId: questionId,
    );
  }

  WsClient _connectedClient() {
    _checkOpen();
    final client = _ws;
    if (client == null || !client.isConnected) {
      throw StateError('The Desktop gateway session is no longer connected');
    }
    return client;
  }

  /// One JSON-RPC call on the already connected gateway socket.
  /// Billing and chat presets use this; it does not open a new session.
  Future<Map<String, dynamic>> rpc(String method, Map<String, dynamic> params) {
    return _connectedClient().send(method, params);
  }

  /// The profile-scoped catalog and default shown by Hermes Desktop.  Keeping
  /// these reads on the Dashboard endpoint means Android never guesses model
  /// names or providers from the OpenAI-compatible API.
  Future<Map<String, dynamic>> getModelInfo() => _dashboard.getModelInfo();

  Future<Map<String, dynamic>> getModelOptions() =>
      _dashboard.getModelOptions();

  Future<Map<String, dynamic>> getPortal() => _dashboard.getPortal();
  Future<Map<String, dynamic>> getAnalytics({int days = 30}) =>
      _dashboard.getAnalytics(days: days);
  Future<Map<String, dynamic>> getModelsAnalytics({int days = 30}) =>
      _dashboard.getModelsAnalytics(days: days);

  Future<void> setSessionModel({
    required String sessionId,
    required String provider,
    required String model,
  }) async {
    await _callSessionScoped(
      sessionId,
      (gateway) => gateway.client.setSessionModel(
        sessionId: gateway.sessionId,
        provider: provider,
        model: model,
      ),
    );
  }

  Future<String> getSessionReasoning(String sessionId) {
    return _callSessionScoped(
      sessionId,
      (gateway) => gateway.client.getSessionReasoning(gateway.sessionId),
    );
  }

  Future<void> setSessionReasoning({
    required String sessionId,
    required String effort,
  }) async {
    await _callSessionScoped(
      sessionId,
      (gateway) => gateway.client.setSessionReasoning(
        sessionId: gateway.sessionId,
        effort: effort,
      ),
    );
  }

  Future<void> renameSession({
    required String sessionId,
    required String title,
  }) async {
    await _callSessionScoped(
      sessionId,
      (gateway) => gateway.client.setSessionTitle(gateway.sessionId, title),
    );
  }

  Future<Map<String, dynamic>> branchSession({
    required String sessionId,
    required String name,
  }) async {
    return _callSessionScoped(
      sessionId,
      (gateway) => gateway.client.branchSession(gateway.sessionId, name: name),
    );
  }

  void close() {
    // Idempotent: a double close must not re-enter or corrupt state.
    if (_closed) return;
    _closed = true;
    unawaited(_gatewayEvents.close());
    unawaited(_socketReady.close());
    SystemSleepGate.instance.removeListener(_onSystemSleep);
    workspace.close();
    slashRefusals.reset();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _asyncEventListener = null;
    _asyncEventAcceptsSession = null;
    _sessionEventListener = null;
    _sessionBoundListener = null;
    _sessionCreatedListener = null;
    _connectionListener = null;
    _projects = null;
    // A closed client serves no voice: a late read must not build a fresh
    // controller on it.
    _servesVoice[this] = null;
    _wakeWord?.dispose();
    _wakeWord = null;
    _voiceLiveMode?.dispose();
    _voiceLiveMode = null;
    _ws?.close();
    _ws = null;
    _gatewaySessionIds.clear();
    _storedSessionIds.clear();
    _resumeOnlySessions.clear();
    _bindingInFlight.clear();
    _resumeOnlyInFlight.clear();
    _socketInFlight = null;
    _workingDirectories.clear();
    _serverRequests.clear();
    _serverRequestClients.clear();
    _serverRequestMobileSessionIds.clear();
    _serverRequestEvents.clear();
    _serverRequestClientOrdinals.clear();
    _serverClarifyRemaining.clear();
    _serverApprovalByMobileSession.clear();
    final turnCoordinatorRegistry = _turnCoordinatorRegistry;
    _turnCoordinatorRegistry = null;
    if (turnCoordinatorRegistry != null) {
      final closing = turnCoordinatorRegistry.closeAll();
      unawaited(closing.then<void>((_) {}, onError: (_, _) {}));
    }
    _dashboard.close();
  }
}

String documentIntakeProfileForConnection(SavedConnection connection) {
  final candidates = <String>[
    connection.gatewayPrefix ?? '',
    Uri.tryParse(connection.desktopGatewayUrl ?? '')?.path ?? '',
  ];
  final segments = candidates
      .expand((value) => value.toLowerCase().split('/'))
      .where((value) => value.isNotEmpty)
      .toSet();
  if (segments.contains('personal')) return 'personal';
  if (segments.contains('pro') || segments.contains('professional')) {
    return 'pro';
  }
  return 'organizator';
}

class _DesktopGatewaySession {
  final WsClient client;
  final String sessionId;

  const _DesktopGatewaySession(this.client, this.sessionId);
}

class _DesktopGatewayBinding {
  final String runtimeSessionId;
  final String storedSessionId;
  final ResumedGatewaySession? resumed;
  final bool created;
  bool creationDelivered = false;
  bool resumeStateDelivered = false;

  _DesktopGatewayBinding({
    required this.runtimeSessionId,
    required this.storedSessionId,
    this.resumed,
    this.created = false,
  });
}
