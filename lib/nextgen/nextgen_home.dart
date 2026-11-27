// Root of the NextGen interface. Picks the gateway in use (or shows the
// connect screen when there is none), keeps its live connection running and
// hosts NextGen's own navigator so every screen sees [NgScope].
import 'dart:async';

import 'package:flutter/material.dart';

import '../core/services/android_share_intent_service.dart';
import '../core/services/android_launch_intent_service.dart';
import '../core/services/client_direct_voice.dart';
import '../core/services/connection_manager.dart';
import '../core/services/gateway_fleet.dart';
import '../core/services/hermes_sign_in.dart';
import '../core/workspace/profile_presentation_store.dart';
import 'data/nextgen_gateway.dart';
import 'nextgen_preferences.dart';
import 'theme/nextgen_theme.dart';
import 'ui/connect_screen.dart';
import 'ui/main_page.dart';
import 'ui/nextgen_scope.dart';
import 'nextgen_l10n.dart';

class NextGenHome extends StatefulWidget {
  const NextGenHome({
    super.key,
    required this.connManager,
    this.testGatewayFactory,
    this.shareIntents,
    this.launchIntents,
  });
  final AndroidShareIntentService? shareIntents;
  final AndroidLaunchIntentService? launchIntents;
  final ConnectionManager connManager;
  @visibleForTesting
  final NextGenGateway Function(SavedConnection)? testGatewayFactory;

  @override
  State<NextGenHome> createState() => _NextGenHomeState();
}

class _NextGenHomeState extends State<NextGenHome> {
  var _navigator = GlobalKey<NavigatorState>();
  List<SavedConnection>? _connections;
  NextGenGateway? _gateway;
  String? _loadError;

  bool _coldStart = true;

  NgMainPage _mainPage() {
    final cold = _coldStart;
    _coldStart = false;
    return NgMainPage(
      coldStart: cold,
      shareIntents: widget.shareIntents,
      launchIntents: widget.launchIntents,
    );
  }

  ConnectionManager get _manager => widget.connManager;

  @override
  void initState() {
    super.initState();
    nextGenOpenRequest.addListener(_onOpenRequest);
    nextGenConnectionRequest.addListener(_onConnectionRequest);
    unawaited(_reload());
  }

  /// Switches to the connection something owned by it is waiting for.
  void _onConnectionRequest() {
    final id = nextGenConnectionRequest.value;
    final connections = _connections;
    if (id == null || connections == null) return;
    nextGenConnectionRequest.value = null;
    if (_gateway?.connection.id == id) {
      _navigator.currentState?.popUntil((r) => r.isFirst);
      return;
    }
    unawaited(_switchTo(id));
  }

  String? _pendingConnection(List<SavedConnection> list) {
    final request = nextGenOpenRequest.value;
    if (request == null) return null;
    final saved = list.where((c) => c.id == request.connectionId).firstOrNull;
    final scope = pendingWindowsToastTarget;
    if (saved == null ||
        (scope != null &&
            (!scope.matches(saved) ||
                !scope.matches(
                  _manager
                      .getConnections()
                      .where((c) => c.id == saved.id)
                      .firstOrNull,
                )))) {
      pendingWindowsToastTarget = null;
      nextGenOpenRequest.value = null;
      return null;
    }
    return saved.id;
  }

  /// A notification named a chat: switch to its connection first; the main
  /// page opens the chat once that connection is showing.
  void _onOpenRequest() {
    final request = nextGenOpenRequest.value;
    final connections = _connections;
    if (request == null || connections == null) return;
    if (_pendingConnection(connections) == null) return;
    if (_gateway?.connection.id != request.connectionId) {
      unawaited(_switchTo(request.connectionId));
    } else {
      _navigator.currentState?.popUntil((r) => r.isFirst);
    }
  }

  @override
  void dispose() {
    nextGenOpenRequest.removeListener(_onOpenRequest);
    nextGenConnectionRequest.removeListener(_onConnectionRequest);
    _gateway?.dispose();
    super.dispose();
  }

  Future<void> _reload({String? select, bool force = false}) async {
    try {
      final list = await _manager.loadConnectionsWithSecrets();
      if (!mounted) return;
      // A notification's connection is an explicit choice. Always evaluate
      // it: _pendingConnection also clears a stale request.
      final pending = _pendingConnection(list);
      final explicit = select ?? pending;
      final primary = GatewayFleet.primaryId(_manager, list);
      final wanted =
          explicit ??
          _gateway?.connection.id ??
          primary ??
          NextGenPreferences.currentConnectionId(_manager.prefs);
      final pick =
          list.where((c) => c.id == wanted).firstOrNull ??
          list.where((c) => c.singleLogin).firstOrNull ??
          list.firstOrNull;
      // Launching on the primary is routing, not a last-used choice. Keep that
      // true across later reloads of the same automatically chosen gateway.
      final automatic =
          explicit == null &&
          pick != null &&
          pick.id == primary &&
          (_gateway == null || _startedOnPrimary);
      setState(() {
        _connections = list;
        _loadError = null;
      });
      _use(pick, force: force, remember: !automatic);
      // A connection request that arrived before the list loaded.
      if (nextGenConnectionRequest.value != null) _onConnectionRequest();
    } catch (e) {
      if (mounted) setState(() => _loadError = '$e');
    }
  }

  bool _startedOnPrimary = false;

  void _use(
    SavedConnection? connection, {
    bool force = false,
    bool remember = true,
  }) {
    final current = _gateway;
    if (connection == null) {
      current?.dispose();
      _startedOnPrimary = false;
      setState(() => _gateway = null);
      unawaited(
        NextGenPreferences.setCurrentConnectionId(_manager.prefs, null),
      );
      return;
    }
    _startedOnPrimary = !remember;
    if (remember) {
      unawaited(
        NextGenPreferences.setCurrentConnectionId(
          _manager.prefs,
          connection.id,
        ),
      );
    }
    if (!force &&
        current != null &&
        current.connection.id == connection.id &&
        _sameAccess(current.connection, connection)) {
      return;
    }
    final next =
        (widget.testGatewayFactory?.call(connection) ??
              NextGenGateway(connection))
          ..start();
    setState(() {
      _gateway = next;
      // A different gateway starts from a fresh navigator and chat.
      _navigator = GlobalKey<NavigatorState>();
    });
    current?.dispose();
  }

  static bool _sameAccess(SavedConnection a, SavedConnection b) =>
      a.host == b.host &&
      a.port == b.port &&
      a.useHttps == b.useHttps &&
      a.gatewayPrefix == b.gatewayPrefix &&
      a.dashboardPrefix == b.dashboardPrefix &&
      a.dashboardPortOverride == b.dashboardPortOverride &&
      a.dashboardProxied == b.dashboardProxied &&
      a.singleLogin == b.singleLogin &&
      a.apiKey == b.apiKey &&
      a.clientCertificate == b.clientCertificate &&
      a.desktopGatewayUrl == b.desktopGatewayUrl &&
      a.dashboardUsername == b.dashboardUsername &&
      a.dashboardPassword == b.dashboardPassword &&
      a.gatewayProfile == b.gatewayProfile &&
      a.signInMethod == b.signInMethod;

  Future<void> _switchTo(String id) async {
    final target = _connections?.where((c) => c.id == id).firstOrNull;
    if (target == null) return;
    _navigator.currentState?.popUntil((r) => r.isFirst);
    _use(target);
  }

  Future<void> _connectFlow({SavedConnection? existing}) async {
    final nav = _navigator.currentState;
    if (nav == null) return;
    await nav.push(
      MaterialPageRoute<void>(
        builder: (context) => NgConnectScreen(
          connManager: _manager,
          existing: existing,
          firstRun: false,
          onCancel: () => Navigator.of(context).pop(),
          onConnected: (saved) async {
            Navigator.of(context).popUntil((r) => r.isFirst);
            // A fresh sign-in replaces the gateway even when the id matches.
            await _reload(select: saved.id, force: true);
          },
        ),
      ),
    );
  }

  Future<void> _signOut(SavedConnection connection) async {
    // Client-direct voice keys held in memory go first: nothing fetched for
    // this account may outlive the sign-out.
    VoiceClientRuntime.closeAll();
    final gateway = _gateway;
    if (gateway != null && gateway.connection.id == connection.id) {
      try {
        final headers = await gateway.dashboard.authHeaders();
        await HermesSignIn().signOut(
          gateway.url,
          authHeaders: headers,
          certificate: connection.clientCertificate,
          customHeaders: connection.customHeaders,
        );
      } catch (_) {
        // Forgetting locally still signs this phone out.
      }
    }
    await _manager.deleteConnection(connection.id);
    _navigator.currentState?.popUntil((r) => r.isFirst);
    await _reload(force: true);
  }

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final connections = _connections;
    if (_loadError != null) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              ngL.ng_couldn_t_read_your_saved_gateways(_loadError ?? ''),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    if (connections == null) {
      return Scaffold(
        backgroundColor: c.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final gateway = _gateway;
    if (gateway == null) {
      return NgConnectScreen(
        connManager: _manager,
        firstRun: true,
        onConnected: (saved) => _reload(select: saved.id),
        onUseClassic: () =>
            NextGenPreferences.setEnabled(_manager.prefs, false),
      );
    }
    return NgScope(
      connManager: _manager,
      gateway: gateway,
      connections: connections,
      switchTo: _switchTo,
      addGateway: () => _connectFlow(),
      signOut: _signOut,
      reload: _reload,
      signInAgain: () => _connectFlow(existing: gateway.connection),
      child: ProfileTheme(
        connection: gateway.connection,
        nextGen: true,
        child: NavigatorPopHandler(
          onPopWithResult: (_) => _navigator.currentState?.maybePop(),
          child: Navigator(
            key: _navigator,
            onGenerateInitialRoutes: (_, _) {
              final page = _mainPage();
              return [MaterialPageRoute<void>(builder: (_) => page)];
            },
          ),
        ),
      ),
    );
  }
}
