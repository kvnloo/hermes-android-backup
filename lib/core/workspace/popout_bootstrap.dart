import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

import '../../nextgen/data/nextgen_gateway.dart';
import '../../nextgen/nextgen_l10n.dart';
import '../../nextgen/nextgen_preferences.dart';
import '../../nextgen/theme/nextgen_theme.dart';
import '../../nextgen/ui/parallel_chat_pane.dart';
import '../../nextgen/ui/nextgen_scope.dart';
import '../l10n/l10n.dart';
import '../l10n/service_strings.dart';
import '../presentation/imported_theme.dart' show ImportedThemeStore;
import '../presentation/presentation_scope.dart';
import '../presentation/reading_controls.dart';
import '../screens/chat_screen.dart';
import '../services/completion_cue_player.dart';
import '../services/connection_manager.dart';
import '../services/desktop_gateway_client.dart';
import '../services/hermes_sign_in.dart';
import '../services/locale_preference.dart';
import '../services/notification_prefs.dart';
import '../services/theme_preference.dart';
import '../services/turn_notification_service.dart';
import '../theme/hermes_theme.dart';
import '../widgets/chat_presence.dart';
import 'popout_owner.dart';
import 'popout_protocol.dart';

/// Other modes never open a pipe or install these process-local adapters.
void runWorkspacePopoutChild(List<String> args) {
  if (args.length != 1 ||
      args.single != workspacePopoutMarker ||
      !(Platform.isLinux || Platform.isWindows || Platform.isMacOS) ||
      stdioType(stdin) != StdioType.pipe) {
    exit(1);
  }
  final timeout = Timer(const Duration(seconds: 45), () => exit(1));
  var activityStopped = false;
  PopoutCueFollower? cue;
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
  );
  unawaited(
    watchPopoutPipe(
      stdin,
      onLaunch: (frame) async {
        try {
          final target = PopoutTarget.decode(frame['target']);
          // Before any await: the parent's first cue line follows the frame.
          cue = PopoutCueFollower(target.cueKey);
          final nonce = frame['nonce'];
          final proof = frame['proof'];
          if (frame.length != 3 ||
              nonce is! String ||
              nonce.length != 36 ||
              proof is! String ||
              proof.length != 64) {
            throw const FormatException();
          }
          final directory = Directory.current;
          if (!directory.uri.pathSegments
              .where((s) => s.isNotEmpty)
              .last
              .startsWith('ares-chat-')) {
            throw StateError('No private cache');
          }
          final app = await preparePopout(target, nonce, proof, directory);
          // An opt-out that arrived while the copied preference loaded wins.
          if (activityStopped) stopPopoutActivity();
          timeout.cancel();
          runApp(app);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            stdout.writeln(workspacePopoutReady);
            // The parent reads presence lines only after ready.
            cue?.report(stdout.writeln);
          });
        } catch (_) {
          stdout.writeln(workspacePopoutFailed);
          await stdout.flush();
          exit(1);
        }
      },
      onRevoked: () => exit(0),
      onStopActivity: () {
        activityStopped = true;
        stopPopoutActivity();
      },
      onCue: (popoutPlays) => cue?.plays = popoutPlays,
    ),
  );
}

/// The pop-out's half of the cue hand-off (see `PopoutCueLink` in the main
/// window): it reports whether it holds presence for its chat, and plays
/// that chat's completion cue only while the main window's last cue line
/// gave the cue to the pop-out. Until the first line it plays, as the only
/// window known to show the chat.
@visibleForTesting
class PopoutCueFollower {
  PopoutCueFollower(this.cueKey) {
    CompletionCuePlayer.instance.ownership = _owns;
  }

  final String cueKey;

  /// The main window's latest [workspacePopoutCuePopout] (true) or
  /// [workspacePopoutCueMain] (false) line.
  bool plays = true;

  void Function(String line)? _write;
  bool? _held;

  bool _owns(String key) => key != cueKey || plays;

  /// Writes [workspacePopoutPresenceHeld] or [workspacePopoutPresenceFree]
  /// now and whenever it changes.
  void report(void Function(String line) write) {
    _write = write;
    ChatPresenceCoordinator.instance.changes.addListener(_sync);
    _sync();
  }

  void _sync() {
    final write = _write;
    if (write == null) return;
    final held = ChatPresenceCoordinator.instance.holds(cueKey);
    if (held == _held) return;
    _held = held;
    try {
      write(held ? workspacePopoutPresenceHeld : workspacePopoutPresenceFree);
    } on Object {
      // The parent has gone; this window is about to be revoked.
    }
  }

  void dispose() {
    ChatPresenceCoordinator.instance.changes.removeListener(_sync);
    _write = null;
    final player = CompletionCuePlayer.instance;
    if (player.ownership == _owns) player.ownership = null;
  }
}

/// The parent turned activity sharing off. Only the live value changes:
/// this can arrive before the child's in-memory store is installed, and a
/// write then would land in the main app's real preferences.
@visibleForTesting
void stopPopoutActivity() => notificationPrefs.value = notificationPrefs.value
    .copyWith(shareWindowActivity: false);

const _carriedKeys = {
  LocalePreference.key,
  ThemePreferenceStore.modeKey,
  ThemePreferenceStore.paletteKey,
  NextGenPreferences.themeModeKey,
  NextGenPreferences.accentKey,
  NextGenPreferences.pureBlackKey,
  NextGenPreferences.glowKey,
  // Device-local notification choices (no secrets): the chat-activity
  // opt-in, reply kinds and the completion sound. The parent can only turn
  // activity sharing off afterwards ([workspacePopoutStopActivity]).
  NotificationPrefsStore.storageKey,
  // The selected imported theme (colours and labels only) and the reading
  // choices. The companion and radio stay with the main window.
  ImportedThemeStore.preferenceKey,
  ReadingControls.preferenceKey,
};

/// Only the selected sanitized metadata row, cosmetic preferences and the
/// notification choices enter the child store. Existing transcripts, composer drafts and write-ahead
/// markers are neither imported nor overwritten by a second process.
Map<String, Object> popoutPreferences(
  Map<String, Object> source,
  PopoutTarget target,
) {
  const savedKey = 'flutter.saved_connections';
  final rows = (source[savedKey] as List).cast<String>().map(
    (encoded) => jsonDecode(encoded) as Map<String, dynamic>,
  );
  final row = rows.singleWhere((r) => r['id'] == target.connectionId);
  if (row.containsKey('api_key') ||
      row.containsKey('dashboard_password') ||
      (row['client_certificate'] is Map &&
          (row['client_certificate'] as Map).containsKey(
            'private_key_password',
          )) ||
      !matchesPopoutOwner(target, SavedConnection.fromMap(row))) {
    throw StateError('Connection is not eligible');
  }
  return {
    savedKey: <String>[jsonEncode(row)],
    for (final key in _carriedKeys)
      if (source.containsKey('flutter.$key'))
        'flutter.$key': source['flutter.$key']!,
  };
}

/// Install only AFTER reading native credentials. Voice drafts, attachments
/// and scratch previews must not address files owned by the main process.
class PopoutPaths extends PathProviderPlatform {
  PopoutPaths(this.directory, this.original);
  final Directory directory;
  final PathProviderPlatform original;
  @override
  Future<String?> getTemporaryPath() async => directory.path;
  @override
  Future<String?> getApplicationCachePath() async => directory.path;
  @override
  Future<String?> getApplicationSupportPath() async => directory.path;
  @override
  Future<String?> getApplicationDocumentsPath() async => directory.path;
  @override
  Future<String?> getLibraryPath() async => directory.path;
  @override
  Future<String?> getDownloadsPath() => original.getDownloadsPath();
}

Future<Widget> preparePopout(
  PopoutTarget target,
  String nonce,
  String proof,
  Directory cache,
) async {
  final data = await SharedPreferencesStorePlatform.instance
      .getAllWithParameters(
        GetAllParameters(
          filter: PreferencesFilter(
            prefix: 'flutter.',
            allowList: {
              'flutter.saved_connections',
              for (final key in _carriedKeys) 'flutter.$key',
            },
          ),
        ),
      );
  SharedPreferencesStorePlatform.instance =
      InMemorySharedPreferencesStore.withData(popoutPreferences(data, target));
  final prefs = await SharedPreferences.getInstance();
  final manager = ConnectionManager(prefs);
  // Deliberately no ConnectionManager.create/initialize: those migrate/write.
  final connection = (await manager.loadConnectionsWithSecrets()).single;
  HermesSignInVault.useReadOnlyWindowStore(
    DesktopGatewayClient.normalizedGatewayBaseUrl(connection),
  );
  await HermesSignInVault.instance.load();
  if (!matchesPopoutOwner(target, connection) ||
      popoutOwnerProof(nonce, connection) != proof) {
    throw StateError('Saved owner changed');
  }
  PathProviderPlatform.instance = PopoutPaths(
    cache,
    PathProviderPlatform.instance,
  );
  NextGenPreferences.load(prefs);
  // The child reports chat activity through its own socket, under the same
  // opt-in as the main window.
  await NotificationPrefsStore.load();
  final gateway = target.nextGen ? NextGenGateway(connection) : null;
  final api = gateway?.api ?? ApiClient.forConnection(connection);
  late Session session;
  try {
    session = await exactPopoutSession(target, api.getSession);
  } catch (_) {
    gateway?.dispose();
    rethrow;
  } finally {
    if (gateway == null) api.close();
  }
  return PopoutChatApp(
    manager: manager,
    connection: connection,
    session: session,
    gateway: gateway,
  );
}

Future<Session> exactPopoutSession(
  PopoutTarget target,
  Future<Map<String, dynamic>> Function(String) get,
) async {
  final row = await get(target.sessionId);
  // An older gateway may ignore a profile query. An ID shared by two
  // profiles is not enough to open a named profile's transcript.
  final profile = row['profile'];
  final matchesProfile = target.profile.isNotEmpty
      ? profile == target.profile
      : profile == null || profile == '' || profile == 'default';
  if (row['id'] != target.sessionId ||
      row['is_local_draft'] == true ||
      !matchesProfile) {
    throw StateError('Stored chat unavailable');
  }
  return Session.fromJson(row);
}

/// A single route using the real interfaces; not Home, the workspace, or a
/// fallback new chat. NextGen also requires NgScope above pushed sheets.
class PopoutChatApp extends StatefulWidget {
  const PopoutChatApp({
    super.key,
    required this.manager,
    required this.connection,
    required this.session,
    required this.gateway,
  });
  final ConnectionManager manager;
  final SavedConnection connection;
  final Session session;
  final NextGenGateway? gateway;
  @override
  State<PopoutChatApp> createState() => _PopoutChatAppState();
}

/// A child window has no notification authority. Only the primary window
/// posts/dismisses OS alerts and consumes startup or live activations.
class _PopoutNotificationSink implements TurnNotificationSink {
  const _PopoutNotificationSink();

  @override
  Future<void> initialize() async {}
  @override
  Future<bool> checkPermission() async => false;
  @override
  Future<bool> requestPermission() async => false;
  @override
  Future<Null> takeInitialLaunchResponse() async => null;
  @override
  Future<void> show(TurnNotification notification) async =>
      throw StateError('Notifications belong to the primary window.');
  @override
  Future<void> cancel(int id) async {}
  @override
  Future<void> cancelAll() async {}
}

class _PopoutChatAppState extends State<PopoutChatApp> {
  final notifications = TurnNotificationService(
    sink: const _PopoutNotificationSink(),
  );
  @override
  void initState() {
    super.initState();
    widget.gateway?.start();
  }

  @override
  void dispose() {
    widget.gateway?.dispose();
    super.dispose();
  }

  final _messenger = GlobalKey<ScaffoldMessengerState>();
  final _navigator = GlobalKey<NavigatorState>();

  /// A Classic pop-out's chat. `/resume` from the window's own chat opens
  /// the pick over it; from a picked chat, in its place. The window and its
  /// own chat stay.
  Widget _classicChat(
    Session session,
    Future<void> Function(Session picked) onOpenSession, {
    VoidCallback? onClose,
  }) => ChatScreen(
    connection: widget.connection,
    session: session,
    singleSession: true,
    notifications: notifications,
    onClose: onClose,
    onOpenSession: onOpenSession,
  );

  Future<void> _openPicked(Session picked) async {
    final navigator = _navigator.currentState;
    if (navigator == null) return;
    unawaited(navigator.push(resumableChatRoute(picked, _classicChat)));
  }

  /// A NextGen pop-out's chat: as the Classic one, `/resume` from the
  /// window's own chat opens the pick over it, and from a picked chat in its
  /// place. A picked chat closes back to the window's own.
  Widget _nextGenChat(
    NextGenGateway gateway,
    Session session,
    Future<void> Function(Session picked) onOpenSession, {
    VoidCallback? onClose,
  }) => NgParallelChatPane(
    gateway: gateway,
    session: session,
    close: onClose ?? () => _navigator.currentState?.maybePop(),
    onOpenSession: onOpenSession,
  );

  Future<void> _openPickedNextGen(
    NextGenGateway gateway,
    Session picked,
  ) async {
    final navigator = _navigator.currentState;
    if (navigator == null) return;
    unawaited(
      navigator.push(
        resumableChatRoute(
          picked,
          (session, open) => _nextGenChat(gateway, session, open),
        ),
      ),
    );
  }

  Future<void> mainOnly() async {
    _messenger.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          context
              .sharedL10n
              .release_core_popout_bootstrap_use_the_main_window_to_change_your_connection,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = widget.manager.prefs;
    final gateway = widget.gateway;
    final theme = ThemePreferenceStore(prefs);
    final look = NextGenLook.instance;
    final app = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ares — Chat',
      scaffoldMessengerKey: _messenger,
      navigatorKey: _navigator,
      supportedLocales: preferredSupportedLocales(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: resolvePreferredLocale,
      locale: LocalePreference.read(prefs),
      themeMode: gateway == null ? theme.readMode() : look.themeMode,
      theme: gateway == null
          ? hermesTheme(Brightness.light, palette: theme.readPalette())
          : nextGenTheme(Brightness.light, look),
      darkTheme: gateway == null
          ? hermesTheme(Brightness.dark, palette: theme.readPalette())
          : nextGenTheme(Brightness.dark, look),
      // The same imported theme and reading choices as the main window.
      builder: (_, child) => PresentationRoot(
        preferences: prefs,
        child: ServiceStringsScope(child: NgLocalizationScope(child: child!)),
      ),
      home: gateway == null
          ? _classicChat(
              widget.session,
              (picked) => _openPicked(picked),
              onClose: () => exit(0),
            )
          : _nextGenChat(
              gateway,
              widget.session,
              (picked) => _openPickedNextGen(gateway, picked),
              onClose: () => exit(0),
            ),
    );
    if (gateway == null) return app;
    return NgScope(
      connManager: widget.manager,
      gateway: gateway,
      connections: [widget.connection],
      switchTo: (_) => mainOnly(),
      addGateway: mainOnly,
      signOut: (_) => mainOnly(),
      reload: mainOnly,
      signInAgain: mainOnly,
      child: app,
    );
  }
}
