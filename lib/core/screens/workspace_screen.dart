/// The Hermes workspace: the navigation shell bound to one saved connection.
///
/// Chats / Crons / Projects / Activity / More, bound to one saved connection.
/// Human conversations and scheduled runs share history loading, not a tab.
///
/// See `docs/ANDROID_DAILY_DRIVER_ROADMAP.md`.
library;

import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/attachment_draft.dart';
import '../models/hermes_project.dart';
import '../models/projects_tree_overview.dart';
import '../presentation/presentation_chrome.dart';
import '../render/render_scope.dart';
import '../services/android_share_intent_service.dart';
import '../services/attachment_draft_service.dart';
import '../services/chat_space_store.dart';
import '../services/chat_assets_client.dart';
import '../services/connection_manager.dart';
import '../services/desktop_gateway_client.dart';
import '../capabilities/capability_admin.dart';
import '../capabilities/capability_pages.dart';
import 'workspace_profiles_screen.dart';
import 'fleet_screen.dart';
import 'workspace_workers_screen.dart';
import 'host_operations_screen.dart';
import 'kanban_board_screen.dart';
import 'bots_screen.dart';
import 'schedule_desk_screen.dart';
import 'memory_graph_screen.dart';
import '../services/gateway_turn_application_controller.dart';
import '../services/gateway_turn_journal.dart';
import '../services/local_chat_pin_store.dart';
import '../services/operational_activity_store.dart';
import '../services/project_folder_discovery.dart';
import '../services/project_folder_provisioner.dart';
import '../services/projects_repository.dart';
import '../services/projects_root_preference.dart';
import '../services/projects_root_resolver.dart';
import '../services/quick_chat_store.dart';
import '../services/session_archive_ledger.dart';
import '../services/remote_files_client.dart';
import '../services/shared_attachment_preparer.dart';
import '../services/session_browser_loader.dart';
import '../services/session_search_client.dart';
import '../models/session_search_hit.dart';
import '../theme/hermes_theme.dart';
import '../workspace/profile_presentation_store.dart';
import '../utils/activity_feed.dart';
import '../utils/adaptive_layout.dart';
import '../utils/operational_activity_feed.dart';
import '../utils/home_turn_signals.dart';
import '../utils/new_chat_options.dart';
import '../widgets/activity_pane.dart';
import '../widgets/cron_upcoming_pane.dart';
import '../widgets/crons_pane.dart';
import '../widgets/hermes_components.dart';
import '../widgets/hermes_shell.dart';
import '../widgets/more_pane.dart';
import 'classic_parallel_workspace.dart';
import 'parallel_workspace_entry.dart';
import 'projects_root_screen.dart';
import '../widgets/new_chat_sheet.dart';
import '../widgets/project_detail_screen.dart';
import '../widgets/projects_pane.dart';
import 'chat_screen.dart';
import 'assets_screen.dart';
import 'files_screen.dart';
import 'cron_screen.dart';
import 'memory_screen.dart';
import 'settings_screen.dart';
import '../settings/settings_browser.dart';
import 'model_management_screen.dart';
import 'open_router_screen.dart';
import 'model_admin_screen.dart';
import 'nous_portal_screen.dart';
import 'provider_oauth_screen.dart';
import 'provider_screen.dart';
import 'skills_screen.dart';
import '../widgets/share_text_review_sheet.dart';
import 'workspace_sessions_screen.dart';

import 'package:hermes_android/core/l10n/l10n.dart';
import '../widgets/desktop_shortcuts.dart';
import '../widgets/command_palette.dart';
import '../services/hermes_deeplink.dart';
import '../desktop/desktop_integration.dart';
import '../desktop/quick_entry.dart';

/// Builds the Projects repository for a connection. Injectable for tests.
typedef ProjectsRepositoryFactory =
    ProjectsRepository Function(SavedConnection connection);

/// Opens the authenticated Hermes dashboard for a URL. Injectable for tests so
/// the fallback can be asserted without launching a real browser.
typedef DashboardLauncher = Future<void> Function(String url);

/// Builds the screen a conversation row opens. Injectable so the navigation contract
/// can be asserted without constructing a live chat transport.
typedef WorkspaceSessionScreenBuilder = Widget Function(Session session);
typedef WorkspaceSessionListLoader = Future<List<Session>> Function();

/// Builds the native remote Files destination. Injectable for navigation tests.
typedef WorkspaceFilesScreenBuilder =
    Widget Function(SavedConnection connection);

/// Reads the attention/running signals Home ranks by. Injectable so the
/// ranking can be asserted without a real recovery journal.
typedef WorkspaceTurnSignalsLoader =
    Future<HomeTurnSignals> Function(SavedConnection connection);

/// Reads the Activity timeline. Injectable so the destination can be asserted
/// without a real recovery journal.
///
/// Receives the session titles the screen has cached, because the turn
/// journal deliberately stores no prose: the titles are an input to the feed,
/// not something it can discover.
typedef WorkspaceActivityFeedLoader =
    Future<ActivityFeed> Function(
      SavedConnection connection,
      Map<String, String> sessionTitles,
    );

/// Identifies Chats' New button, so a test asserts the affordance
/// itself rather than an icon that another widget could also draw.
const Key kWorkspaceNewChatButtonKey = Key('workspace-new-chat');

/// Generates the id a new chat is created under. Injectable so a test can pin
/// it; the app uses the same generator the session list already uses.
typedef NewChatSessionIdFactory = String Function();
typedef SharedAttachmentPreparer =
    Future<List<AttachmentDraft>> Function(List<AndroidSharedFile> files);

/// The chat screen a conversation row opens by default.
///
/// Exposed so a test can assert what actually ships rather than only the
/// injected stand-in. [turnApplicationController] is threaded through
/// deliberately: it owns durable turn recovery above the Navigator, so a chat
/// opened from Chats must resume exactly like one opened from the session list.
Widget buildWorkspaceChatScreen({
  required SavedConnection connection,
  required Session session,
  String? projectName,
  String? projectWorkingDirectory,
  String? initialComposerText,
  bool initialComposerAppends = false,
  List<AttachmentDraft> initialAttachmentDrafts = const [],
  GatewayTurnApplicationController? turnApplicationController,
  Future<void> Function(String sessionId, bool archived)? onArchiveChanged,
  Future<bool> Function(String sessionId, bool archived)? sessionArchiver,
  ApiClient? testApiClient,
  VoidCallback? onClose,
  Future<void> Function(Session session)? onOpenSession,
  VoidCallback? onOpenAppCommandPalette,
}) {
  return ChatScreen(
    connection: connection,
    session: session,
    projectName: projectName,
    projectWorkingDirectory: projectWorkingDirectory,
    initialComposerText: initialComposerText,
    initialComposerAppends: initialComposerAppends,
    initialAttachmentDrafts: initialAttachmentDrafts,
    turnApplicationController: turnApplicationController,
    onArchiveChanged: onArchiveChanged,
    sessionArchiver: sessionArchiver,
    testApiClient: testApiClient,
    onClose: onClose,
    onOpenSession: onOpenSession,
    onOpenAppCommandPalette: onOpenAppCommandPalette,
  );
}

class WorkspaceScreen extends StatefulWidget {
  final SavedConnection connection;

  static final Map<String, int> _openConnections = <String, int>{};

  /// Whether a workspace for [connectionId] is mounted (the app root routes
  /// a quick-entry hand-back there instead of opening another).
  static bool isOpenFor(String connectionId) =>
      (_openConnections[connectionId] ?? 0) > 0;

  /// Overrides repository construction. When provided, the caller keeps
  /// ownership of the repository lifecycle and this screen will not close it.
  final ProjectsRepositoryFactory? repositoryFactory;

  /// Called when the user opens a project.
  final ValueChanged<String>? onOpenProject;

  /// Called when the user opens a chat from the conversation browser. When null, this
  /// screen pushes the chat itself, so the shell is never a dead end.
  final ValueChanged<Session>? onOpenSession;

  /// Periodic silent refresh for the session lists (running/idle chips).
  /// Null (tests) disables the timer; the app passes a modest interval.
  final Duration? sessionsRefreshInterval;

  /// Owns durable turn recovery above this screen's lifetime. Passed to every
  /// chat opened from Chats so a turn survives leaving the chat.
  final GatewayTurnApplicationController? turnApplicationController;

  /// Overrides how the browser reads the sessions it ranks. Injectable for tests so
  /// the digest can be asserted without a live gateway.
  final WorkspaceSessionListLoader? sessionsLoader;

  /// Test-only HTTP client injected into the session-list [ApiClient] so
  /// the real paging loop (pinned back-fills, offset advance, dedupe) can
  /// be driven against a fake server without a live gateway. Ignored when
  /// [sessionsLoader] is set.
  final http.Client? testSessionsHttpClient;

  /// Injects the dashboard archive transport in loader regression tests.
  final http.Client? testArchivedSessionsHttpClient;

  /// A separately owned chat transport for real navigation regressions.
  final ApiClient Function()? testChatApiClientFactory;

  /// Drives archive paging/authentication without a live dashboard in tests.
  final http.Client? testDashboardHttpClient;

  /// Overrides the screen a conversation row opens.
  final WorkspaceSessionScreenBuilder? sessionScreenBuilder;

  /// Overrides the native Files screen.
  final WorkspaceFilesScreenBuilder? filesScreenBuilder;

  /// Optional injected history reader; the caller retains its lifecycle.
  final ChatAssetsDataSource Function(SavedConnection)? assetsSourceFactory;

  /// Overrides how the browser reads its attention and running signals.
  final WorkspaceTurnSignalsLoader? turnSignalsLoader;

  /// Overrides how Activity reads its timeline.
  final WorkspaceActivityFeedLoader? activityFeedLoader;

  /// Called when the user starts a chat from Chats' New button. When null,
  /// this screen opens the chat itself, so New is never an inert affordance.
  final ValueChanged<NewChatDraft>? onNewChat;

  /// Overrides the id a new chat is created under.
  final NewChatSessionIdFactory? newChatSessionIdFactory;

  /// Text received through Android's share sheet. Kept for callers that only
  /// support the original text-only contract.
  final String? initialSharedText;

  /// Text and files received through Android's ACTION_SEND contract.
  final AndroidSharePayload? initialSharedPayload;

  /// Opens a fresh Quick Chat immediately, as requested by an Android launcher
  /// shortcut. The value is consumed by the caller before this screen opens.
  final bool initialQuickChat;

  /// Converts native-cached shared files into validated composer drafts.
  final SharedAttachmentPreparer? sharedAttachmentPreparer;

  /// Overrides how the Hermes dashboard fallback is opened.
  final DashboardLauncher? onOpenDashboard;

  const WorkspaceScreen({
    required this.connection,
    this.repositoryFactory,
    this.onOpenProject,
    this.onOpenSession,
    this.turnApplicationController,
    this.sessionsLoader,
    this.testSessionsHttpClient,
    this.testArchivedSessionsHttpClient,
    this.testChatApiClientFactory,
    this.testDashboardHttpClient,
    this.sessionScreenBuilder,
    this.filesScreenBuilder,
    this.assetsSourceFactory,
    this.turnSignalsLoader,
    this.activityFeedLoader,
    this.onNewChat,
    this.newChatSessionIdFactory,
    this.initialSharedText,
    this.initialSharedPayload,
    this.initialQuickChat = false,
    this.sharedAttachmentPreparer,
    this.onOpenDashboard,
    this.sessionsRefreshInterval,
    super.key,
  });

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  /// The connection counted in [WorkspaceScreen.isOpenFor] (stable even if
  /// the widget is rebuilt with another connection object).
  late final String _openConnectionId = widget.connection.id;

  ProjectsRepository? _repository;
  DesktopGatewayClient? _ownedGateway;
  ChatSpaceStore? _spaceStore;

  /// Lists server folders that are not Projects yet (issue #232). Built only
  /// when this screen owns a gateway, because it rides that gateway's
  /// dashboard client; a connection without one gets no affordance.
  ProjectFolderDiscovery? _folderDiscovery;
  QuickChatStore? _quickChats;
  ApiClient? _sessionsApi;
  DashboardClient? _archivedSessionsClient;
  bool _ownsRepository = false;
  bool _initialized = false;
  Set<String> _providerIds = const {};
  bool _providerDiscoveryBusy = false;
  late final Future<void> _initialization;

  /// Reaches the live Activity pane for the same reason.
  final _activityKey = GlobalKey<ActivityPaneState>();

  /// Reaches the action-only Activity view opened from Chats.
  final _inboxKey = GlobalKey<ActivityPaneState>();

  /// The destination currently on screen. New is a Chats-only
  /// affordance: over Projects or More it would be ambiguous what it creates.
  HermesDestination _destination = HermesDestination.chats;

  /// The chat shown in the inline detail pane on wide (expanded) windows.
  /// Null means the Chats list fills the pane. Compact windows keep pushing
  /// chats as full-screen routes instead.
  Session? _detailSession;
  String? _detailProjectName;
  String? _detailWorkingDirectory;
  String? _detailComposerText;
  bool _detailComposerAppends = false;
  List<AttachmentDraft> _detailAttachments = const [];

  /// Tracks the previous window class so folding a wide window back to compact
  /// re-homes an open inline detail chat as a full-screen route.
  bool _wasExpanded = false;

  /// Desktop keyboard shortcut subscription (no-op on touch platforms).
  StreamSubscription<DesktopShortcut>? _desktopShortcutSub;
  VoidCallback? _deepLinkListener;
  VoidCallback? _quickEntryTargets;
  final _shellKey = GlobalKey<HermesShellState>();

  /// The last known attention/running signals. The compact attention section uses these; an
  /// empty value simply means everything falls back to `Continue working`.
  HomeTurnSignals _turnSignals = HomeTurnSignals.empty;

  /// How much work Activity reports as blocked, for the shell badge. Held
  /// separately from the feed so the badge survives a destination switch that
  /// disposes the pane.
  int _activityBlockedCount = 0;
  int _activityRead = 0;
  int _activitySessionRead = 0;
  int _sessionMetadataRead = 0;
  int _activityRecordsRead = 0;
  int _activityJournalRead = 0;
  bool _activitySessionsStale = false;
  bool _activitySessionsPartial = true;
  final _activitySessions = ActivitySessionCache();
  List<OperationalActivityRecord> _lastActivityRecords = const [];
  Map<String, String> _lastJournalAliases = const {};
  ActivityFeed _lastJournalFeed = const ActivityFeed(
    groups: [],
    blockedCount: 0,
    runningCount: 0,
  );
  Object? _activityListener;
  Timer? _activityDebounce;
  GatewayTurnApplicationController get _turnController =>
      widget.turnApplicationController ??
      GatewayTurnApplicationController.standalone;

  /// Blocked plus failed turns shown by the Home Inbox action.
  int _inboxActionCount = 0;

  /// Session id to title, from the last successful session read.
  ///
  /// The turn journal deliberately stores no prose, so Activity has no titles
  /// of its own. Reusing the session browser already fetched costs no extra request and
  /// no new gateway contract; a turn whose chat is absent simply stays
  /// untitled rather than being dropped or given a fabricated name.
  Map<String, String> get _sessionTitles => _activitySessions.titles;
  final _chatsKey = GlobalKey<WorkspaceSessionsScreenState>();
  final _cronsKey = GlobalKey<WorkspaceSessionsScreenState>();
  final _cronsPaneKey = GlobalKey<CronsPaneState>();
  CronsView _cronsView = CronsView.upcoming;
  final _cronUpcomingKey = GlobalKey<CronUpcomingPaneState>();
  SessionBrowserLoader? _browserLoader;
  List<Session> _knownSessions = const [];
  bool _sessionsKnown = false;
  int _signalsGeneration = 0;
  SharedSessionScan? _archiveLoader;
  int _sessionTitleRevision = 0;
  final _confirmedTitles = <String, ({int revision, String title})>{};

  /// Best-effort Project labels learned from the latest projects.tree read,
  /// used to carry context into chats opened from the global Chats browser.
  Map<String, String> _chatProjectLabels = const {};
  int _placementRevision = 0;
  int _placementRead = 0;
  final _savedPlacements =
      <String, ({int revision, String projectId, String label})>{};
  final _movingChats = <String, Session>{};
  final _archivingChats = <String, Session>{};
  final _pinningChats = <String, Session>{};
  final _archiveChanges = SessionArchiveLedger();
  Future<void> _quickPromotionTail = Future<void>.value();

  /// Read lazily so a connection that never opens Chats never touches secure
  /// storage, and so tests that inject a loader never construct one at all.
  GatewayTurnJournal? _journal;

  SessionBrowserLoader get _sessionLoader =>
      _browserLoader ??= SessionBrowserLoader(
        api: _sessionClient,
        sessionsLoader: widget.sessionsLoader == null
            ? null
            : _loadInjectedSessions,
        readPage: _readSessionPage,
      );

  late final WorkspaceTurnSignalsLoader _loadTurnSignals =
      widget.turnSignalsLoader ?? _loadTurnSignalsFromJournal;

  ApiClient get _sessionClient {
    final connection = widget.connection;
    return _sessionsApi ??= ApiClient.forConnection(
      connection,
      httpClient: widget.testSessionsHttpClient,
    );
  }

  /// Derives conversation attention signals from the durable turn recovery journal.
  ///
  /// The journal is the only store that already survives process death and
  /// knows what a chat was doing, so no new gateway contract is required and
  /// legacy REST connections keep working — they simply have no scope, and
  /// [readHomeTurnSignals] then reports nothing.
  Future<HomeTurnSignals> _loadTurnSignalsFromJournal(
    SavedConnection connection,
  ) {
    final endpointDigest = endpointDigestForConnection(connection);
    if (endpointDigest == null) {
      return Future.value(HomeTurnSignals.empty);
    }
    return readHomeTurnSignals(
      journal: _journal ??= GatewayTurnJournal(),
      connectionId: connection.id,
      endpointDigest: endpointDigest,
    );
  }

  SharedSessionScan get _archivesLoader => _archiveLoader ??= SharedSessionScan(
    (publish) => _dashboardClient.getArchivedSessions(
      gatewayProfile: widget.connection.gatewayProfile,
      maxPages: null,
      firstPageSize: 5,
      isCancelled: () => !mounted,
      onProgress: publish,
    ),
  );

  Future<List<Session>> _loadArchivedSessions({
    SessionScanProgress? onProgress,
    bool fresh = false,
  }) async {
    final revision = _sessionTitleRevision;
    final owner = _archivesLoader;
    // Passive pane loads coalesce; an explicit refresh needs new physical I/O.
    if (fresh) owner.invalidate();
    final rows = await owner.load(
      onProgress: onProgress == null
          ? null
          : (rows) => onProgress(_withConfirmedTitles(rows, revision)),
    );
    return _withConfirmedTitles(rows, revision);
  }

  Future<List<Session>> _loadActiveSessions({
    SessionScanProgress? onProgress,
    bool fresh = false,
  }) async {
    final titleRevision = _sessionTitleRevision;
    final owner = _sessionLoader;
    if (fresh) owner.invalidate();
    late int readRevision;
    List<Session> accept(List<Session> rows, {bool complete = false}) {
      final sessions = _withConfirmedTitles(rows, titleRevision);
      if (mounted &&
          owner.isCurrent(readRevision) &&
          titleRevision == _sessionTitleRevision) {
        setState(() => _knownSessions = sessions);
        if (complete) _sessionsKnown = true;
        if (HermesDeepLinkService.shared.pendingLink.value != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _onPendingDeepLink();
          });
        }
      }
      return sessions;
    }

    final rows = await owner.load(
      onRevision: (revision) => readRevision = revision,
      onProgress: (rows) => onProgress?.call(accept(rows)),
    );
    return accept(rows, complete: true);
  }

  List<Session> _withConfirmedTitles(List<Session> rows, int readRevision) => [
    for (final row in rows)
      if (_confirmedTitles[row.id] case final saved?
          when saved.revision > readRevision)
        row.withTitle(saved.title)
      else
        row,
  ];

  /// Opens the Quick chat lifecycle store for this connection.
  ///
  /// Lazy so a connection that never starts a Quick chat never touches
  /// SharedPreferences for one.
  Future<QuickChatStore> _quickChatStore() async {
    final existing = _quickChats;
    if (existing != null) return existing;
    final preferences = await SharedPreferences.getInstance();
    return _quickChats ??= QuickChatStore(
      preferences,
      connectionId: widget.connection.id,
    );
  }

  /// Reads the timeline purely to keep the shell badge honest.
  ///
  /// Failures are swallowed: an unreadable journal costs a badge, and must
  /// never surface as an error on a destination the user is not looking at.
  Future<void> _refreshActivityBadge() async {
    try {
      await _loadActivity(refreshSessions: false);
    } catch (_) {
      // An unreadable source is not proof that known blocked work disappeared.
    }
  }

  Future<SessionListPage> _readSessionPage({
    required int limit,
    int offset = 0,
  }) async {
    final read = _activitySessions.beginRead();
    _sessionMetadataRead = read;
    try {
      final page = await _sessionClient.getSessionsPage(
        limit: limit,
        offset: offset,
      );
      if (mounted) {
        _activitySessions.merge(page.sessions, read: read);
        if (read == _sessionMetadataRead) _activitySessionsStale = false;
      }
      return page;
    } catch (_) {
      if (mounted && read == _sessionMetadataRead) {
        _activitySessionsStale = true;
      }
      rethrow;
    }
  }

  Future<List<Session>> _loadInjectedSessions() async {
    final read = _activitySessions.beginRead();
    _sessionMetadataRead = read;
    try {
      final sessions = await widget.sessionsLoader!();
      if (mounted) {
        _activitySessions.merge(sessions, read: read);
        if (read == _sessionMetadataRead) _activitySessionsStale = false;
      }
      return sessions;
    } catch (_) {
      if (mounted && read == _sessionMetadataRead) {
        _activitySessionsStale = true;
      }
      rethrow;
    }
  }

  /// Seek useful recent rows without turning each poll into Home's full scan.
  /// A request budget or a filled preview is not exhaustive absence proof.
  Future<void> _refreshActivitySessions() async {
    final scan = ++_activitySessionRead;
    var partial = true;
    try {
      if (widget.sessionsLoader != null) {
        await _loadInjectedSessions();
        partial = false; // The injected loader supplies a complete fixture.
        return;
      }
      const pageSize = 100;
      const maxPages = 3;
      final usefulRoots = <String>{};
      final floor =
          DateTime.now()
              .subtract(kActivityCompletedWindow)
              .millisecondsSinceEpoch /
          1000;
      for (var page = 0; page < maxPages; page++) {
        final result = await _readSessionPage(
          limit: pageSize,
          offset: page * pageSize,
        );
        if (!mounted || scan != _activitySessionRead) return;
        for (final session in result.sessions) {
          final at = session.lastActive > 0
              ? session.lastActive
              : session.startedAt;
          if (!session.isLocalDraft &&
              session.messageCount > 0 &&
              at.isFinite &&
              at >= floor) {
            usefulRoots.add(session.lineageRootId ?? session.id);
          }
        }
        // Stock can under-report has_more when pins sit inside its window.
        // A full/back-filled response is therefore still partial even when
        // has_more=false; advance by the requested size, not response length.
        if (!result.hasMore && result.sessions.length < pageSize) {
          partial = false;
          break;
        }
        if (usefulRoots.length >= kActivityGroupLimit) break;
      }
    } finally {
      if (mounted && scan == _activitySessionRead) {
        _activitySessionsPartial = partial;
      }
    }
  }

  /// Read actual app-owned turns plus the gateway's recent session metadata.
  /// A stock/REST connection must not depend on a recovery-v2 journal existing.
  Future<ActivityFeed> _loadOperationalActivity({
    required bool refreshSessions,
  }) async {
    final connection = widget.connection;
    final l10n = context.l10n;
    var stale = false;
    if (refreshSessions) {
      try {
        await _refreshActivitySessions();
      } catch (_) {
        if (!mounted) rethrow;
        // Read ownership (shared with Home) decides freshness. An obsolete
        // failure must not mark a newer successful metadata read offline.
      }
    }
    if (!mounted) throw StateError('Workspace disposed');
    try {
      final read = ++_activityRecordsRead;
      final records = await _turnController.readActivityRecords(
        connection,
        sessionRoots: _activitySessions.lineageRoots,
      );
      if (!mounted) throw StateError('Workspace disposed');
      if (read == _activityRecordsRead) _lastActivityRecords = records;
    } catch (_) {
      if (!mounted) rethrow;
      stale = true;
    }
    final endpointDigest = endpointDigestForConnection(connection);
    if (endpointDigest != null) {
      try {
        final read = ++_activityJournalRead;
        final snapshot = await (_journal ??= GatewayTurnJournal())
            .loadSnapshot();
        if (!mounted) throw StateError('Workspace disposed');
        if (read == _activityJournalRead) {
          _lastJournalAliases = {
            for (final binding in snapshot.bindings)
              if (binding.connectionId == connection.id &&
                  binding.endpointDigest == endpointDigest)
                binding.localSessionId: binding.storedSessionId,
          };
          _lastJournalFeed = buildActivityFeed(
            snapshot: snapshot,
            now: DateTime.now(),
            connectionId: connection.id,
            endpointDigest: endpointDigest,
            sessionTitles: _sessionTitles,
            // Apply the cap only after all sources have been combined.
            groupLimit: snapshot.entries.length + 1,
          );
        }
      } catch (_) {
        if (!mounted) rethrow;
        stale = true;
      }
    }
    final feed = buildOperationalActivityFeed(
      journalFeed: _lastJournalFeed,
      journalSessionAliases: _lastJournalAliases,
      sessionAliases: _activitySessions.aliases,
      records: _lastActivityRecords,
      sessions: _activitySessions.sessions,
      now: DateTime.now(),
      l10n: l10n,
      isPartial: _activitySessionsPartial,
    );
    return ActivityFeed(
      groups: feed.groups,
      blockedCount: feed.blockedCount,
      runningCount: feed.runningCount,
      isStale: stale || _activitySessionsStale,
      isPartial: feed.isPartial,
    );
  }

  void _onTurnActivityChanged() {
    if (!mounted || _activityDebounce != null) return;
    // Streaming tokens also notify observers. Coalesce them without issuing
    // session-list requests; the visible pane's periodic/manual refresh owns I/O.
    _activityDebounce = Timer(const Duration(milliseconds: 250), () {
      _activityDebounce = null;
      if (!mounted) return;
      Future<ActivityFeed> read() => _loadActivity(refreshSessions: false);
      final activity =
          _destination == HermesDestination.activity &&
              (ModalRoute.of(context)?.isCurrent ?? true)
          ? _activityKey.currentState
          : null;
      final inbox = _inboxKey.currentState;
      if (activity != null) unawaited(activity.refresh(loader: read));
      if (inbox != null) unawaited(inbox.refresh(loader: read));
      // IndexedStack retains Activity and an Inbox route can also be covered.
      // Neither mounted key is proof a pane accepted this observer refresh.
      if (activity == null) unawaited(_refreshActivityBadge());
    });
  }

  /// Reads the feed and keeps the shell badge in step with it.
  Future<ActivityFeed> _loadActivity({bool refreshSessions = true}) async {
    final read = ++_activityRead;
    final loader = widget.activityFeedLoader;
    // Titles may not be cached yet when Activity is the first destination the
    // user opens; read the sessions once so rows are not all untitled. A
    // failed read degrades a row's title, never the timeline itself.
    if (loader != null && !_sessionsKnown) {
      try {
        await _loadActiveSessions();
      } catch (_) {}
    }
    final feed = loader != null
        ? await loader(widget.connection, _sessionTitles)
        : await _loadOperationalActivity(refreshSessions: refreshSessions);
    final inboxCount = feed.groups
        .where(
          (group) =>
              group.kind == ActivityGroupKind.needsYou ||
              group.kind == ActivityGroupKind.failed,
        )
        .fold<int>(0, (count, group) => count + group.totalCount);
    if (mounted &&
        (feed.blockedCount != _activityBlockedCount ||
            inboxCount != _inboxActionCount)) {
      // Deferred: the pane calls this from its own build-triggered load, and
      // setState during that frame would rebuild the shell mid-layout.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || read != _activityRead) return;
        setState(() {
          _activityBlockedCount = feed.blockedCount;
          _inboxActionCount = inboxCount;
        });
      });
      // A hidden-pane observer read has no loading widget to request a frame.
      // Ensure its deferred badge projection actually runs while idle.
      WidgetsBinding.instance.scheduleFrame();
    }
    return feed;
  }

  Future<void> _refreshTurnSignals(int generation) async {
    HomeTurnSignals signals;
    try {
      signals = await _loadTurnSignals(widget.connection);
    } catch (_) {
      // A journal that cannot be read degrades the ranking, never the screen.
      signals = HomeTurnSignals.empty;
    }
    if (!mounted || generation != _signalsGeneration) return;
    setState(() => _turnSignals = signals);
  }

  @override
  void initState() {
    super.initState();
    _desktopShortcutSub = desktopShortcutBus.stream.listen(_onDesktopShortcut);
    WorkspaceScreen._openConnections.update(
      _openConnectionId,
      (count) => count + 1,
      ifAbsent: () => 1,
    );
    _quickEntryTargets = QuickEntryTargets.register(
      _quickEntryChats,
      owner: () => HermesLinkOwner(
        connectionId: widget.connection.id,
        profile: widget.connection.gatewayProfile,
      ),
    );
    _deepLinkListener = _onPendingDeepLink;
    HermesDeepLinkService.shared.pendingLink.addListener(_deepLinkListener!);
    if (HermesDeepLinkService.shared.pendingLink.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _onPendingDeepLink();
      });
    }
    _initialization = _initialize();
    _activityListener = _turnController.addTurnActivityListener(
      _onTurnActivityChanged,
    );
    final legacyText = widget.initialSharedText?.trim();
    final sharedPayload =
        widget.initialSharedPayload ??
        (legacyText == null || legacyText.isEmpty
            ? null
            : AndroidSharePayload(text: legacyText));
    if (sharedPayload != null && !sharedPayload.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_startSharedChat(sharedPayload));
      });
    } else if (widget.initialQuickChat) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_startQuickChat());
      });
    }
  }

  Future<void> _startQuickChat() async {
    await _initialization;
    if (!mounted) return;
    final draft = buildNewChatDraft(
      l10n: context.l10n,
      mode: NewChatMode.quickChat,
      sessionId:
          (widget.newChatSessionIdFactory ??
                  GatewayChatClient.generateSessionId)
              .call(),
      now: DateTime.now(),
    );
    final expiresAt = draft.expiresAt;
    if (expiresAt != null) {
      try {
        await (await _quickChatStore()).record(
          draft.session.id,
          expiresAt: expiresAt,
        );
      } catch (_) {}
    }
    if (!mounted) return;
    await _finishNewChat(draft);
  }

  Future<void> _startSharedChat(AndroidSharePayload payload) async {
    await _initialization;
    if (!mounted) return;

    final text = payload.text ?? '';
    final projectsView = await _projectsForNewChat();
    if (!mounted) return;
    final activeProjects = projectsView.projects
        .where((project) => !project.archived)
        .toList();
    final decision = await showModalBottomSheet<ShareTextDecision>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ShareTextReviewSheet(
        sharedText: text,
        sharedFiles: payload.files,
        projectChatEnabled: activeProjects.isNotEmpty,
      ),
    );
    if (decision == null || !mounted) return;

    HermesProject? project;
    if (decision.mode == NewChatMode.projectChat) {
      project = activeProjects.length == 1
          ? activeProjects.single
          : await showModalBottomSheet<HermesProject>(
              context: context,
              isScrollControlled: true,
              builder: (_) => ProjectPickerSheet(projects: activeProjects),
            );
      if (project == null || !mounted) return;
    }

    List<AttachmentDraft> attachments;
    try {
      attachments = payload.files.isEmpty
          ? const []
          : await (widget.sharedAttachmentPreparer ??
                    (files) => prepareAndroidSharedFiles(files))
                .call(payload.files);
    } on AttachmentDraftException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
      return;
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.couldn_t_prepare_the_shared_files)),
      );
      return;
    }
    if (!mounted) return;

    final draft = buildNewChatDraft(
      l10n: context.l10n,
      mode: decision.mode,
      sessionId:
          (widget.newChatSessionIdFactory ??
                  GatewayChatClient.generateSessionId)
              .call(),
      now: DateTime.now(),
      project: project,
    );
    final expiresAt = draft.expiresAt;
    if (draft.isQuick && expiresAt != null) {
      try {
        final store = await _quickChatStore();
        await store.record(draft.session.id, expiresAt: expiresAt);
      } catch (_) {}
    }
    if (!mounted) return;
    await _finishNewChat(
      draft,
      initialComposerText: buildSharedPrompt(
        decision.action,
        text,
        hasAttachments: attachments.isNotEmpty,
        l10n: context.l10n,
      ),
      initialAttachmentDrafts: attachments,
    );
  }

  @override
  void dispose() {
    _desktopShortcutSub?.cancel();
    final open = WorkspaceScreen._openConnections;
    if ((open[_openConnectionId] ?? 0) <= 1) {
      open.remove(_openConnectionId);
    } else {
      open[_openConnectionId] = open[_openConnectionId]! - 1;
    }
    _quickEntryTargets?.call();
    final deepLinkListener = _deepLinkListener;
    if (deepLinkListener != null) {
      HermesDeepLinkService.shared.pendingLink.removeListener(deepLinkListener);
    }
    _activityRead++;
    _activitySessionRead++;
    _activityDebounce?.cancel();
    final listener = _activityListener;
    if (listener != null) _turnController.removeTurnActivityListener(listener);
    _signalsGeneration++;
    _browserLoader?.close();
    _archiveLoader?.close();
    // Only tear down what this screen created; an injected repository stays
    // owned by whoever supplied it.
    if (_ownsRepository) {
      unawaited(_repository?.close());
      _ownedGateway?.close();
    }
    // Screen-owned transport clients close with the screen — both hold live
    // http.Client pools that leak otherwise.
    _sessionsApi?.close();
    _archivedSessionsClient?.close();
    super.dispose();
  }

  /// Shows a shell destination. A chat or another screen pushed on top of the
  /// shell (the narrow layout pushes chats) is popped first; switching only
  /// the hidden tab underneath would look like nothing happened.
  void _showShellDestination(HermesDestination destination) {
    if (!mounted) return;
    final route = ModalRoute.of(context);
    final navigator = Navigator.maybeOf(context);
    if (route != null && navigator != null && !route.isCurrent) {
      navigator.popUntil((candidate) => candidate == route);
    }
    _shellKey.currentState?.select(destination);
  }

  /// Handles desktop keyboard shortcuts routed from the app root.
  void _onDesktopShortcut(DesktopShortcut shortcut) {
    if (!mounted) return;
    switch (shortcut) {
      case DesktopShortcut.commandPalette:
        _openCommandPalette();
      case DesktopShortcut.newChat:
        unawaited(_startNewChat());
      case DesktopShortcut.search:
        _openWorkspaceSessionView(WorkspaceSessionView.search);
      case DesktopShortcut.settings:
        _push(SettingsScreen(connection: widget.connection));
      case DesktopShortcut.tab1:
        _showShellDestination(HermesDestination.chats);
      case DesktopShortcut.tab2:
        _showShellDestination(HermesDestination.crons);
      case DesktopShortcut.tab3:
        _showShellDestination(HermesDestination.projects);
      case DesktopShortcut.tab4:
        _showShellDestination(HermesDestination.activity);
    }
  }

  /// Recent human chats offered to the desktop quick-entry window.
  List<QuickEntryChat> _quickEntryChats() {
    if (!mounted) return const [];
    final untitled = context.l10n.untitled_chat;
    return [
      for (final session in _knownSessions.where((s) => !isMachineSession(s)))
        QuickEntryChat(
          id: session.id,
          title: session.title.trim().isEmpty ? untitled : session.title,
        ),
    ];
  }

  Future<void> _openQuickEntry() async {
    final desktop = DesktopIntegration.current;
    if (desktop == null) return;
    final opened = await desktop.openQuickEntry();
    if (opened || !mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(context.l10n.quick_entry_unavailable)),
    );
  }

  /// Opens the shared app-wide command palette (Classic: same widget as NextGen).
  void _openCommandPalette() {
    final sessions = _knownSessions.where((s) => !isMachineSession(s)).toList();
    showAppCommandPalette(
      context,
      actions: [
        PaletteAction(
          id: 'new-chat',
          label: context.l10n.command_palette_new_chat,
          icon: Icons.add_comment_outlined,
          keywords: const ['compose', 'start', 'new', 'chat'],
        ),
        PaletteAction(
          id: 'search',
          label: context.l10n.palette_search_sessions,
          icon: Icons.search,
          keywords: const ['find', 'sessions', 'chats', 'search'],
        ),
        if (DesktopIntegration.current != null)
          PaletteAction(
            id: 'quick-entry',
            label: context.l10n.quick_entry_title,
            icon: Icons.edit_note_outlined,
            keywords: const ['hud', 'quick', 'prompt', 'entry', 'hotkey'],
          ),
        PaletteAction(
          id: 'nav-chats',
          label: context.l10n.chats,
          icon: Icons.chat_bubble_outline,
          keywords: const ['conversations', 'home'],
        ),
        PaletteAction(
          id: 'nav-crons',
          label: context.l10n.palette_scheduled_crons,
          icon: Icons.schedule_outlined,
          keywords: const ['cron', 'scheduled', 'jobs'],
        ),
        PaletteAction(
          id: 'nav-projects',
          label: context.l10n.projects,
          icon: Icons.folder_outlined,
          keywords: const ['folders', 'workspaces'],
        ),
        PaletteAction(
          id: 'nav-activity',
          label: context.l10n.nav_activity,
          icon: Icons.bolt_outlined,
          keywords: const ['timeline', 'runs', 'inbox'],
        ),
        PaletteAction(
          id: 'capabilities',
          label: context.l10n.palette_capabilities_skills,
          icon: Icons.extension_outlined,
          keywords: const ['skills', 'plugins', 'mcp', 'tools'],
        ),
        PaletteAction(
          id: 'settings',
          label: context.l10n.settings,
          icon: Icons.settings,
          keywords: const [
            'preferences',
            'options',
            'shortcuts',
            'keep awake',
            'appearance',
            'notifications',
          ],
        ),
        for (final session in sessions)
          PaletteAction(
            id: 'session:${session.id}',
            label: session.title.trim().isEmpty
                ? context.l10n.untitled_chat
                : session.title,
            hint: session.id,
            icon: Icons.forum_outlined,
            keywords: [session.id, if (session.model.isNotEmpty) session.model],
          ),
      ],
      onSelected: (action) {
        if (!mounted) return;
        if (action.id.startsWith('session:')) {
          final id = action.id.substring('session:'.length);
          final match = _knownSessions.where((s) => s.id == id).firstOrNull;
          if (match != null) {
            unawaited(_openSession(match));
          }
          return;
        }
        switch (action.id) {
          case 'new-chat':
            unawaited(_startNewChat());
          case 'search':
            _openWorkspaceSessionView(WorkspaceSessionView.search);
          case 'quick-entry':
            unawaited(_openQuickEntry());
          case 'nav-chats':
            _showShellDestination(HermesDestination.chats);
          case 'nav-crons':
            _showShellDestination(HermesDestination.crons);
          case 'nav-projects':
            _showShellDestination(HermesDestination.projects);
          case 'nav-activity':
            _showShellDestination(HermesDestination.activity);
          case 'capabilities':
            _openCapability('capability-admin');
          case 'settings':
            _push(SettingsScreen(connection: widget.connection));
        }
      },
    );
  }

  /// Opens a prefilled draft without sending or executing anything.
  void _openPrefilledDraft(String prefill) {
    final draft = buildNewChatDraft(
      l10n: context.l10n,
      mode: NewChatMode.quickChat,
      sessionId:
          (widget.newChatSessionIdFactory ??
                  GatewayChatClient.generateSessionId)
              .call(),
      now: DateTime.now(),
    );
    unawaited(_openSession(draft.session, initialComposerText: prefill));
  }

  /// Consumes a validated `hermes://` link. Never sends, never executes.
  void _onPendingDeepLink() {
    final peek = HermesDeepLinkService.shared.pendingLink.value;
    if (peek == null || !mounted) return;
    // A link that belongs to another connection or profile (a quick-entry
    // hand-back) is left for that owner's workspace.
    if (!peek.isFor(widget.connection.id, widget.connection.gatewayProfile)) {
      return;
    }
    if (peek.kind == HermesDeepLinkKind.session && !_sessionsKnown) {
      final id = peek.sessionId;
      if (id != null && !_knownSessions.any((s) => s.id == id)) {
        // Wait for the initial session list load before deciding whether this
        // session exists on the connected gateway.
        return;
      }
    }
    final link = HermesDeepLinkService.shared.takePendingLink();
    if (link == null || !mounted || link.isIgnored) return;
    switch (link.kind) {
      case HermesDeepLinkKind.launch:
        return; // focus-only; no route, no prefill
      case HermesDeepLinkKind.settings:
        _push(
          SettingsScreen(
            connection: widget.connection,
            initialCategory: SettingsCategory.fromPath(link.path),
          ),
        );
        return;
      case HermesDeepLinkKind.install:
        // Navigation-only: open Capabilities for explicit user review, never
        // auto-installing a skill, plugin or MCP server on link open.
        _openCapability('capability-admin');
        return;
      case HermesDeepLinkKind.open:
        // In-app route only; never following an external/raw URL.
        final path = link.path ?? '';
        if (path.startsWith('/settings')) {
          _push(
            SettingsScreen(
              connection: widget.connection,
              initialCategory: SettingsCategory.fromPath(path),
            ),
          );
        } else if (path == '/crons' ||
            path == '/scheduled' ||
            path == '/cron') {
          _showShellDestination(HermesDestination.crons);
        } else if (path == '/projects') {
          _showShellDestination(HermesDestination.projects);
        } else if (path == '/activity' || path == '/insights') {
          _showShellDestination(HermesDestination.activity);
        } else if (path == '/capabilities' ||
            path == '/skills' ||
            path == '/plugins' ||
            path == '/mcp') {
          _openCapability('capability-admin');
        } else {
          _showShellDestination(HermesDestination.chats);
          if (link.prefill != null) {
            _openPrefilledDraft(link.prefill!);
          }
        }
        return;
      case HermesDeepLinkKind.session:
        final id = link.sessionId;
        if (id == null) return;
        final match = _knownSessions.where((s) => s.id == id).firstOrNull;
        if (match == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.deeplink_chat_not_found)),
          );
          return;
        }
        final prefill = link.prefill;
        if (prefill != null) {
          // Already open (pushed, or in the wide detail pane): append to its
          // live composer and bring it forward instead of a second copy.
          final open = ChatScreen.appendToOpenChat(
            connectionId: widget.connection.id,
            sessionId: match.id,
            text: prefill,
          );
          if (open != null) {
            if (!open.isCurrent) {
              Navigator.of(context).popUntil((route) => route == open);
            }
            return;
          }
        }
        // A link never replaces the chat's unsent draft: append to it.
        unawaited(
          _openSession(
            match,
            initialComposerText: prefill,
            initialComposerAppends: prefill != null,
          ),
        );
        return;
      case HermesDeepLinkKind.ignore:
        return;
    }
  }

  Future<void> _initialize() async {
    final factory = widget.repositoryFactory;
    // The legacy local Spaces store is read-only here: it exists so the
    // migration preview can show what still lives on the phone.
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    final spaceStore = ChatSpaceStore(
      preferences,
      connectionId: widget.connection.id,
    );
    unawaited(
      _migrateLegacyPins(
        LocalChatPinStore(preferences, connectionId: widget.connection.id),
      ),
    );

    if (factory != null) {
      final repository = factory(widget.connection);
      if (!mounted) return;
      setState(() {
        _repository = repository;
        _spaceStore = spaceStore;
        _ownsRepository = false;
        _initialized = true;
      });
      return;
    }

    // Projects live on the Desktop Gateway JSON-RPC transport; a legacy REST
    // connection simply has nowhere to ask.
    final gatewayUrl = widget.connection.desktopGatewayUrl?.trim() ?? '';
    if (gatewayUrl.isEmpty) {
      if (mounted) setState(() => _initialized = true);
      return;
    }

    try {
      final gateway = DesktopGatewayClient.fromConnection(widget.connection);
      if (!mounted) {
        gateway.close();
        return;
      }
      // The per-connection Projects root the user opted into, or null to keep
      // the server's conventional `<home>/Projects`. A dashboard `locked_root`
      // still outranks it (see ProjectsRootResolver).
      final rootPreference = ProjectsRootPreference(preferences);
      final rootIdentity = ProjectsRootPreference.identityOf(widget.connection);
      String? readConfiguredRoot() =>
          rootPreference.read(connectionIdentity: rootIdentity);
      // Reuses the dashboard's existing `GET /api/fs/list` route through
      // RemoteFilesClient. Deliberately never closed: closing it would close
      // the gateway's shared dashboard client, and nothing on this path
      // allocates the separate URL download client.
      final files = RemoteFilesClient(
        dashboard: gateway.dashboard,
        profile: widget.connection.gatewayProfile,
      );
      setState(() {
        _ownedGateway = gateway;
        _repository = ProjectsRepository(
          client: gateway.projects,
          preferences: preferences,
          connectionId: widget.connection.id,
          folderProvisioner: DashboardFolderProvisioner(
            gateway.dashboard,
            readConfiguredRoot: readConfiguredRoot,
          ),
        );
        _folderDiscovery = DashboardProjectFolderDiscovery(
          listDirectory: files.listDirectory,
          roots: ProjectsRootResolver(
            dashboard: gateway.dashboard,
            readConfiguredRoot: readConfiguredRoot,
          ),
        );
        _spaceStore = spaceStore;
        _ownsRepository = true;
        _initialized = true;
      });
    } catch (_) {
      // A malformed gateway URL is a configuration problem, not a crash: fall
      // through to the same explanation a legacy connection gets.
      if (mounted) setState(() => _initialized = true);
    }
  }

  Widget _pane(
    BuildContext context,
    HermesDestination destination,
    VoidCallback openParallel,
  ) {
    final tokens = HermesTokens.of(context);
    switch (destination) {
      case HermesDestination.chats:
        final chatsList = WorkspaceSessionsScreen(
          key: _chatsKey,
          searchMessages: _searchMessages,
          searchScope: widget.connection,
          title: context.l10n.chats,
          view: WorkspaceSessionView.all,
          embedded: true,
          onPin: _pinSession,
          attention: _turnSignals.attention,
          running: _turnSignals.running,
          onOpenActivity: _openActivityOverview,
          refreshInterval: widget.sessionsRefreshInterval,
          load: _loadWorkspaceSessionsData,
          loadProgressively: (onProgress) =>
              _loadWorkspaceSessionsData(onProgress: onProgress),
          // The passive tick keeps the coalescing contract (no freshActive)
          // and simply stops asking the archive router (#149).
          loadWithoutArchives: (onProgress) => _loadWorkspaceSessionsData(
            onProgress: onProgress,
            includeArchives: false,
          ),
          reloadActive: (onProgress) => _loadWorkspaceSessionsData(
            onProgress: onProgress,
            freshActive: true,
            includeArchives: false,
          ),
          reloadArchives: (onProgress) =>
              _loadArchivedSessions(onProgress: onProgress, fresh: true),
          onOpenSession: (session) => unawaited(
            _openSession(session, projectName: _chatProjectLabels[session.id]),
          ),
          onPromote: (session) => _moveChatToProject(
            session,
            sourceContext: _chatsKey.currentContext,
          ),
          onRename: _renameSession,
          onArchive: _archiveSession,
        );
        if (isExpandedWindow(context)) {
          final detail = _detailSession;
          return Row(
            children: [
              SizedBox(width: 380, child: chatsList),
              VerticalDivider(width: 1, thickness: 1, color: tokens.border),
              Expanded(
                child: detail == null
                    ? _detailPlaceholder()
                    : KeyedSubtree(
                        key: ValueKey('classic-detail-${detail.id}'),
                        child: buildWorkspaceChatScreen(
                          connection: widget.connection,
                          session: detail,
                          projectName: _detailProjectName,
                          projectWorkingDirectory: _detailWorkingDirectory,
                          initialComposerText: _detailComposerText,
                          initialComposerAppends: _detailComposerAppends,
                          initialAttachmentDrafts: _detailAttachments,
                          turnApplicationController:
                              widget.turnApplicationController,
                          sessionArchiver: (storedId, archived) =>
                              _archiveSession(
                                detail.withStoredId(storedId),
                                archived,
                              ),
                          testApiClient: widget.testChatApiClientFactory
                              ?.call(),
                          onClose: _closeDetail,
                          // /resume swaps the detail pane, keeping the list.
                          onOpenSession: (picked) => _openSession(
                            picked,
                            projectName: _chatProjectLabels[picked.id],
                          ),
                        ),
                      ),
              ),
            ],
          );
        }
        return chatsList;
      case HermesDestination.crons:
        // Issue #259: Upcoming (scheduled job definitions, read from the
        // cron manager's own dashboard route) beside History (the cron run
        // conversations this destination always showed). A job scheduled for
        // next week is therefore visible before it has ever run.
        return CronsPane(
          key: _cronsPaneKey,
          onViewChanged: (view) => setState(() => _cronsView = view),
          upcoming: CronUpcomingPane(
            key: _cronUpcomingKey,
            connection: widget.connection,
            testDashboardHttpClient: widget.testDashboardHttpClient,
            refreshInterval: widget.sessionsRefreshInterval,
            onOpenManager: _openCronJobs,
          ),
          history: WorkspaceSessionsScreen(
            key: _cronsKey,
            searchMessages: _searchMessages,
            searchScope: widget.connection,
            archiveSurfaceVisible: _cronsView == CronsView.history,
            title: context.l10n.crons,
            kind: WorkspaceSessionKind.crons,
            view: WorkspaceSessionView.all,
            embedded: true,
            onPin: _pinSession,
            refreshInterval: widget.sessionsRefreshInterval,
            load: () =>
                _loadWorkspaceSessionsData(kind: WorkspaceSessionKind.crons),
            loadProgressively: (onProgress) => _loadWorkspaceSessionsData(
              kind: WorkspaceSessionKind.crons,
              onProgress: onProgress,
            ),
            // The passive tick keeps the coalescing contract (no
            // freshActive) and simply stops asking the archive router
            // (#149).
            loadWithoutArchives: (onProgress) => _loadWorkspaceSessionsData(
              kind: WorkspaceSessionKind.crons,
              onProgress: onProgress,
              includeArchives: false,
            ),
            reloadActive: (onProgress) => _loadWorkspaceSessionsData(
              kind: WorkspaceSessionKind.crons,
              onProgress: onProgress,
              freshActive: true,
              includeArchives: false,
            ),
            reloadArchives: (onProgress) =>
                _loadArchivedSessions(onProgress: onProgress, fresh: true),
            onOpenSession: (session) => unawaited(_openSession(session)),
            onRename: _renameSession,
          ),
        );
      case HermesDestination.projects:
        final repository = _repository;
        if (!_initialized) {
          return const Padding(
            padding: EdgeInsets.only(top: HermesSpacing.lg),
            child: LoadingSkeleton(rows: 4),
          );
        }
        if (repository == null) {
          return ErrorState.unsupported(
            title: context.l10n.projects_unavailable,
            message: context
                .l10n
                .projects_need_a_desktop_gateway_connection_add_the_desktop_gateway,
          );
        }
        return ProjectsPane(
          workspace: _ownedGateway?.workspace,
          repository: repository,
          onProjectSelected: (projectId) => _openProject(repository, projectId),
          spaceStore: _spaceStore,
          folderDiscovery: _folderDiscovery,
        );
      case HermesDestination.activity:
        return ActivityPane(
          key: _activityKey,
          active: _destination == HermesDestination.activity,
          refreshInterval: widget.sessionsRefreshInterval,
          loadFeed: _loadActivity,
          onOpenItem: _openActivityItem,
        );
      case HermesDestination.more:
        final gateway = _ownedGateway;
        final workers = gateway == null
            ? null
            : WorkspaceWorkersScreen.capture(
                gateway.workspace,
                widget.connection.label,
              );
        return MorePane(
          sections: buildMoreSections(
            providerIds: _providerIds,
            profileScopedHistory:
                widget.connection.singleLogin ||
                (widget.connection.gatewayProfile?.trim().isEmpty ?? true),
            dashboardReachable: _dashboardReachable,
            workspaceAvailable: _ownedGateway != null,
            l10n: context.l10n,
          ),
          onSelect: (entry) {
            if (entry.id == 'parallel-workspace') {
              openParallel();
            } else if (entry.id == 'workspace-workers') {
              workers?.open(context);
            } else {
              _openMoreEntry(entry);
            }
          },
        );
    }
  }

  /// The dashboard only exists when the connection names a host to reach it
  /// on. Without one, every dashboard-backed entry is disabled *with a reason*
  /// rather than hidden, per the roadmap's capability-discovery rule.
  Future<List<SessionSearchHit>> _searchMessages(
    String term,
    bool Function() maySend,
  ) => SessionSearchClient.searchDashboard(
    _dashboardClient,
    term,
    maySend: maySend,
  );

  bool get _dashboardReachable => widget.connection.host.trim().isNotEmpty;

  /// The dashboard origin, which is not the gateway chat origin: it has its
  /// own port and optional path prefix.
  String get _dashboardUrl =>
      DesktopGatewayClient.normalizedGatewayBaseUrl(widget.connection);

  DashboardClient get _dashboardClient {
    final origin = Uri.parse(_dashboardUrl);
    return _archivedSessionsClient ??= DashboardClient(
      host: origin.host,
      port: origin.port,
      useHttps: origin.scheme == 'https',
      pathPrefix: origin.path == '/' ? '' : origin.path,
      proxied: widget.connection.dashboardProxied,
      username: widget.connection.dashboardUsername,
      password: widget.connection.dashboardPassword,
      clientCertificate: widget.connection.clientCertificate,
      gatewayProfile: widget.connection.gatewayProfile,
      deploymentToken: widget.connection.deploymentToken,
      customHeaders: widget.connection.customHeaders,
      httpClient:
          widget.testArchivedSessionsHttpClient ??
          widget.testDashboardHttpClient,
    );
  }

  Future<void> _detectProviders() async {
    if (!_dashboardReachable || _providerDiscoveryBusy) return;
    _providerDiscoveryBusy = true;
    try {
      final options = await _dashboardClient.getModelOptions();
      final providers = options['providers'];
      if (!mounted || providers is! List) return;
      setState(() {
        _providerIds = providers
            .whereType<Map>()
            .map((p) => p['slug'] ?? p['id'])
            .whereType<String>()
            .toSet();
      });
    } on Exception {
      // Optional discovery must not prevent local settings or chats opening.
    } finally {
      _providerDiscoveryBusy = false;
    }
  }

  Future<void> _openDashboard() async {
    final launcher = widget.onOpenDashboard;
    if (launcher != null) {
      await launcher(_dashboardUrl);
      return;
    }
    final uri = Uri.tryParse(_dashboardUrl);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (launched || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.could_not_open_the_hermes_dashboard)),
    );
  }

  void _push(Widget screen) {
    final themed = ProfileTheme(
      connection: widget.connection,
      nextGen: false,
      child: screen,
    );
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => themed));
  }

  /// Clears the inline detail pane on a wide window.
  void _closeDetail() {
    setState(() {
      _detailSession = null;
      _detailProjectName = null;
      _detailWorkingDirectory = null;
      _detailComposerText = null;
      _detailComposerAppends = false;
      _detailAttachments = const [];
    });
  }

  /// The empty right-hand pane shown on a wide window before a chat is picked.
  Widget _detailPlaceholder() {
    final tokens = HermesTokens.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 48, color: tokens.muted),
          const SizedBox(height: HermesSpacing.md),
          Text(
            context.l10n.chats,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: tokens.muted),
          ),
        ],
      ),
    );
  }

  /// Opens a chat from the conversation browser.
  ///
  /// A host that supplied [WorkspaceScreen.onOpenSession] owns navigation, so
  /// this screen must not also push a route underneath it. Otherwise it opens
  /// the chat itself and refreshes the browser on return, because the reason a chat
  /// was blocked usually stops being true while the user is inside it.
  Future<void> _openSession(
    Session session, {
    String? projectName,
    String? projectWorkingDirectory,
    String? initialComposerText,
    bool initialComposerAppends = false,
    List<AttachmentDraft> initialAttachmentDrafts = const [],
    VoidCallback? onArchiveCommitted,
    Future<void> Function()? refreshBrowser,
  }) async {
    final report = widget.onOpenSession;
    if (report != null) {
      report(session);
      return;
    }

    // Wide windows show the chat in an inline detail pane beside the list
    // (list+detail), preserving the list's filters and scroll. The legacy
    // sessionScreenBuilder test seam and compact windows keep the pushed
    // full-screen route.
    if (widget.sessionScreenBuilder == null &&
        _destination == HermesDestination.chats &&
        isExpandedWindow(context)) {
      setState(() {
        _detailSession = session;
        _detailProjectName = projectName;
        _detailWorkingDirectory = projectWorkingDirectory;
        _detailComposerText = initialComposerText;
        _detailComposerAppends = initialComposerAppends;
        _detailAttachments = initialAttachmentDrafts;
      });
      return;
    }

    final builder = widget.sessionScreenBuilder;
    late final MaterialPageRoute<void> route;
    route = MaterialPageRoute<void>(
      builder: (_) => ProfileTheme(
        connection: widget.connection,
        nextGen: false,
        child:
            builder?.call(session) ??
            buildWorkspaceChatScreen(
              connection: widget.connection,
              session: session,
              projectName: projectName,
              projectWorkingDirectory: projectWorkingDirectory,
              initialComposerText: initialComposerText,
              initialComposerAppends: initialComposerAppends,
              initialAttachmentDrafts: initialAttachmentDrafts,
              turnApplicationController: widget.turnApplicationController,
              sessionArchiver: (storedId, archived) async {
                final saved = await _archiveSession(
                  session.withStoredId(storedId),
                  archived,
                );
                onArchiveCommitted?.call();
                return saved;
              },
              testApiClient: widget.testChatApiClientFactory?.call(),
              onOpenAppCommandPalette: _openCommandPalette,
              // /resume opens the pick here, in place of this chat route.
              onOpenSession: (picked) async {
                if (!mounted) return;
                if (route.isActive) Navigator.of(context).removeRoute(route);
                await _openSession(
                  picked,
                  projectName: _chatProjectLabels[picked.id],
                );
              },
            ),
      ),
    );
    await Navigator.of(context).push(route);
    if (!mounted) return;
    if (refreshBrowser != null) {
      unawaited(refreshBrowser());
      return;
    }
    final browser = isCronSession(session) ? _cronsKey : _chatsKey;
    unawaited(browser.currentState?.refresh() ?? Future<void>.value());
  }

  /// Opens one project's detail screen.
  ///
  /// A host that supplied [WorkspaceScreen.onOpenProject] owns navigation, so
  /// this screen must not also push a route underneath it — the same rule
  /// [_openSession] follows. Otherwise it opens the project itself, because a
  /// project card that does nothing is a dead end in the shell.
  Future<void> _openProject(
    ProjectsRepository repository,
    String projectId,
  ) async {
    final report = widget.onOpenProject;
    if (report != null) {
      report(projectId);
      return;
    }

    // The name is read from the list we already hold, so the screen opens with
    // the real title instead of "Untitled" until the drill-in lands.
    final known = repository.current.projects
        .where((project) => project.id == projectId)
        .firstOrNull;

    final connection = widget.connection;
    final projectOwner = _ownedGateway?.workspace;
    final project =
        known ??
        HermesProject(
          id: projectId,
          slug: projectId,
          name: context.l10n.project,
        );

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProjectDetailScreen(
          workspace: projectOwner,
          onNewLaneChat: (path) {
            if (mounted &&
                projectOwner != null &&
                identical(projectOwner, _ownedGateway?.workspace)) {
              _startProjectChat(project.inLane(path));
            }
          },
          projectId: projectId,
          projectName: project.name,
          createFilesClient: () => _createFilesClient(connection),
          loadSessions: ({required bool refresh}) =>
              repository.projectSessions(projectId, refresh: refresh),
          onOpenSession: (session) => _openSession(
            session,
            projectName: project.name,
            projectWorkingDirectory: project.workingDirectory,
          ),
          onNewChat: () => _startProjectChat(project),
          projects: repository.current.projects,
          onMoveSession: (session, targetProjectId) =>
              repository.moveSessionToProject(
                session.id,
                targetProjectId,
                storedSessionKey: _ownedGateway?.storedSessionKeyFor(
                  session.id,
                ),
              ),
          onRenameProject: (name) => repository.rename(projectId, name),
          onArchiveProject: () => repository.archive(projectId),
          onDeleteProject: () => repository.delete(projectId),
        ),
      ),
    );
  }

  /// Opens the action Inbox. It deliberately reuses the Activity feed but
  /// filters out informational Running/Completed rows, so this route contains
  /// only work that can change what the user does next.
  void _openActivityOverview() {
    _push(
      Scaffold(
        appBar: AppBar(title: Text(context.l10n.nav_activity)),
        body: ActivityPane(
          loadFeed: _loadActivity,
          onOpenItem: _openActivityItem,
        ),
      ),
    );
  }

  void _openInbox() {
    _push(
      Scaffold(
        appBar: AppBar(title: Text(context.l10n.inbox)),
        body: ActivityPane(
          key: _inboxKey,
          refreshInterval: widget.sessionsRefreshInterval,
          loadFeed: _loadActivity,
          onOpenItem: _openActivityItem,
          actionableOnly: true,
        ),
      ),
    );
  }

  /// Opens the chat an Activity row belongs to.
  ///
  /// The journal outlives a deleted session, so a row can name a chat the
  /// gateway no longer has. Pushing a chat screen for it would open a surface
  /// that can never load, so an unknown session is a deliberate no-op rather
  /// than a broken navigation.
  Future<void> _openActivityItem(ActivityItem item) async {
    var session =
        _activitySessions[item.sessionId] ?? _sessionForActivity(item);
    if (session == null) {
      try {
        session = await _sessionClient.getSessionById(item.sessionId);
      } catch (_) {}
      if (!mounted) return;
    }
    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.activity_chat_unavailable)),
      );
      return;
    }
    await _openSession(session);
    if (!mounted) return;
    unawaited(_activityKey.currentState?.refresh() ?? Future<void>.value());
    unawaited(_inboxKey.currentState?.refresh() ?? Future<void>.value());
  }

  /// The live session an Activity row points at, or `null` when the chat is
  /// no longer known.
  Session? _sessionForActivity(ActivityItem item) {
    final title = _sessionTitles[item.sessionId];
    if (title == null) return null;
    return Session(
      id: item.sessionId,
      title: title,
      model: '',
      source: '',
      messageCount: 0,
      isActive: true,
      preview: '',
      startedAt: item.updatedAt.millisecondsSinceEpoch / 1000.0,
    );
  }

  /// The Projects state the New sheet reasons about.
  ///
  /// A connection with no Desktop Gateway has nowhere to host projects, which
  /// is the same situation for the user as a gateway that predates them: the
  /// mode is offered, disabled, with a reason.
  Future<ProjectsView> _projectsForNewChat() async {
    final repository = _repository;
    if (repository == null) {
      return const ProjectsView(support: ProjectsSupport.unsupported);
    }
    // Chats may be the first screen the user ever opens, in which case nothing
    // has probed the gateway yet. Probe now rather than claiming `unknown`.
    if (repository.current.support == ProjectsSupport.unknown) {
      return repository.refresh();
    }
    return repository.current;
  }

  /// Starts directly inside a Project without asking the user to choose the
  /// mode or Project again. The same commit-before-open path is reused.
  Future<void> _startProjectChat(HermesProject project) async {
    final draft = buildNewChatDraft(
      l10n: context.l10n,
      mode: NewChatMode.projectChat,
      sessionId:
          (widget.newChatSessionIdFactory ??
                  GatewayChatClient.generateSessionId)
              .call(),
      now: DateTime.now(),
      project: project,
    );
    await _finishNewChat(draft);
  }

  /// Runs Chats' New affordance.
  ///
  /// Every product rule it depends on lives in `new_chat_options.dart`; this
  /// method only sequences the two questions (which mode, then which project)
  /// and opens the result.
  Future<void> _startNewChat() async {
    final view = await _projectsForNewChat();
    if (!mounted) return;

    final mode = await showModalBottomSheet<NewChatMode>(
      context: context,
      builder: (_) =>
          NewChatSheet(options: buildNewChatOptionsFor(context.l10n, view)),
    );
    if (mode == null || !mounted) return;

    HermesProject? project;
    if (mode == NewChatMode.projectChat) {
      final projects = view.projects
          .where((candidate) => !candidate.archived)
          .toList();
      if (projects.isEmpty) return;
      // A single project carries no decision, so do not charge a tap for it.
      project = projects.length == 1
          ? projects.single
          : await showModalBottomSheet<HermesProject>(
              context: context,
              isScrollControlled: true,
              builder: (_) => ProjectPickerSheet(projects: projects),
            );
      if (project == null || !mounted) return;
    }

    final draft = buildNewChatDraft(
      l10n: context.l10n,
      mode: mode,
      sessionId:
          (widget.newChatSessionIdFactory ??
                  GatewayChatClient.generateSessionId)
              .call(),
      now: DateTime.now(),
      project: project,
    );

    // Start the retention clock now, before the chat opens. Recorded even
    // when a host owns navigation: the lifecycle belongs to the chat, not to
    // whoever displays it. A failure costs the archive rule for this chat,
    // never the chat itself.
    final expiresAt = draft.expiresAt;
    if (draft.isQuick && expiresAt != null) {
      try {
        final store = await _quickChatStore();
        await store.record(draft.session.id, expiresAt: expiresAt);
      } catch (_) {}
      if (!mounted) return;
    }

    await _finishNewChat(draft);
  }

  /// Commits a drafted Project chat before exposing it to navigation.
  ///
  /// Stock-gateway-only path: the chat is opened with the Project's folder as
  /// its session `cwd` (threaded via `draft.projectWorkingDirectory` into
  /// `session.create`), and the gateway derives project membership from cwd
  /// (`project_for_path`) — the same way Hermes Desktop files chats. There
  /// is no pre-open assignment RPC to commit: `projects.assign_session`
  /// never shipped upstream, so there is nothing to fail or retry here.
  ///
  /// A Project with no folder cannot be bound this way (Android allows
  /// name-only Projects). Do not create a misleading unassigned chat under
  /// a Project header; ask the user to add a folder first.
  Future<void> _finishNewChat(
    NewChatDraft draft, {
    String? initialComposerText,
    List<AttachmentDraft> initialAttachmentDrafts = const [],
  }) async {
    if (draft.projectId != null) {
      final hasFolder =
          (draft.projectWorkingDirectory?.trim().isNotEmpty ?? false);
      if (!hasFolder) {
        if (!mounted) return;
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.this_project_has_no_folder_to_open_the_chat_in,
            ),
            duration: Duration(seconds: 6),
          ),
        );
        return;
      }
    }

    final report = widget.onNewChat;
    if (report != null) {
      report(draft);
      return;
    }
    await _openSession(
      draft.session,
      projectName: draft.projectName,
      projectWorkingDirectory: draft.projectWorkingDirectory,
      initialComposerText: initialComposerText,
      initialAttachmentDrafts: initialAttachmentDrafts,
    );
  }

  Future<WorkspaceSessionsData> _loadWorkspaceSessionsData({
    WorkspaceSessionKind kind = WorkspaceSessionKind.chats,
    void Function(WorkspaceSessionsData data)? onProgress,
    bool freshActive = false,
    bool includeArchives = true,
  }) async {
    final generation = ++_signalsGeneration;
    unawaited(_refreshTurnSignals(generation));
    await _initialization;
    final placementRevision = _placementRevision;
    final archiveRevision = _archiveChanges.revision;
    final placementRead = kind == WorkspaceSessionKind.chats
        ? ++_placementRead
        : _placementRead;
    var sessions = <Session>[];
    var archivedSessions = <Session>[];
    var activeLoading = true;
    var archiveLoading = includeArchives && _dashboardReachable;
    var projectsLoading =
        kind == WorkspaceSessionKind.chats && _repository != null;
    var projectsKnown = !projectsLoading;
    Object? sessionsError;
    Object? archiveError;
    var claimed = <String>{};
    var projectLabels = <String, String>{};
    var quickArchives = <String>{};

    WorkspaceSessionsData snapshot() {
      // A metadata response begun before a move may contribute unrelated new
      // rows, but may not undo that chat's confirmed ownership.
      final moved = {
        for (final entry in _savedPlacements.entries)
          if (!projectsKnown || entry.value.revision > placementRevision)
            entry.key: entry.value,
      };
      final labels = {
        ...projectLabels,
        for (final entry in moved.entries) entry.key: entry.value.label,
      };
      if (mounted &&
          kind == WorkspaceSessionKind.chats &&
          placementRead == _placementRead) {
        _chatProjectLabels = Map.unmodifiable(labels);
      }
      return applySessionArchiveChanges(
        WorkspaceSessionsData(
          sessions: List.unmodifiable(sessions),
          archivedSessions: List.unmodifiable(archivedSessions),
          isPartial: activeLoading,
          archivedIsPartial: archiveLoading,
          sessionsError: sessionsError,
          archiveError: archiveError,
          projectsLoading: projectsLoading,
          claimedSessionIds: Set.unmodifiable({...claimed, ...moved.keys}),
          archivedQuickChatIds: Set.unmodifiable(
            quickArchives.difference(moved.keys.toSet()),
          ),
          projectLabels: Map.unmodifiable(labels),
          projectsKnown: projectsKnown,
        ),
        _archiveChanges,
        archiveRevision,
      );
    }

    void publish() {
      if (mounted) onProgress?.call(snapshot());
    }

    Future<void> readActive() async {
      void accept(List<Session> rows) {
        if (!mounted) return;
        sessions = rows;
        publish();
      }

      try {
        accept(
          await _loadActiveSessions(onProgress: accept, fresh: freshActive),
        );
      } catch (error) {
        sessionsError = error;
      } finally {
        activeLoading = false;
        publish();
      }
      if (mounted) unawaited(_refreshActivityBadge());
    }

    Future<void> readArchives() async {
      if (!archiveLoading) return;
      try {
        archivedSessions = await _loadArchivedSessions(
          onProgress: (rows) {
            archivedSessions = rows;
            publish();
          },
        );
      } catch (error) {
        archiveError = error;
      } finally {
        archiveLoading = false;
        publish();
      }
    }

    Future<void> readProjects() async {
      if (!projectsLoading) return;
      try {
        final overview = await _repository!
            .overview(refresh: true)
            .timeout(const Duration(seconds: 8));
        claimed = {
          for (final entry in overview.sessionProjects.entries)
            if (entry.value != ProjectsTreeOverview.noProjectId) entry.key,
        };
        projectLabels = {
          for (final entry in overview.sessionProjects.entries)
            if (overview.ownerLabelOf(entry.key) != null)
              entry.key: overview.ownerLabelOf(entry.key)!,
        };
        projectsKnown = true;
      } catch (_) {
        projectsKnown = false;
      } finally {
        projectsLoading = false;
        publish();
      }
    }

    Future<void> readQuickArchives() async {
      try {
        final store = await _quickChatStore();
        quickArchives = (await store.load()).archivedAt(DateTime.now());
      } catch (_) {
        // Additive device metadata must never hide stored conversations.
      }
      publish();
    }

    await Future.wait([
      readActive(),
      readArchives(),
      readProjects(),
      readQuickArchives(),
    ]);
    return snapshot();
  }

  bool _chatMutationPending(Session session) => [
    ..._movingChats.values,
    ..._archivingChats.values,
    ..._pinningChats.values,
  ].any((active) => _archiveChanges.sameConversation(active, session));

  Future<bool> _archiveSession(Session session, bool archived) async {
    if (_chatMutationPending(session)) {
      throw StateError('Chat is already being updated');
    }
    _archivingChats[session.id] = session;
    try {
      final confirmed = await _sessionClient.setSessionArchived(
        sessionId: session.id,
        archived: archived,
        clearPin: session.pinned,
      );
      if (confirmed && mounted) {
        // A confirmed archive leaves the chat unpinned on the server (see
        // setSessionArchived), so panes holding an older pinned copy must
        // not bring it back under Pinned if it is restored.
        _chatsKey.currentState?.reconcilePin(session, false);
        _cronsKey.currentState?.reconcilePin(session, false);
      }
      await _rememberConfirmedArchive(
        confirmed ? session.withPinned(false) : session,
        confirmed,
      );
      return confirmed;
    } finally {
      _archivingChats.remove(session.id);
    }
  }

  Future<void> _rememberConfirmedArchive(Session session, bool archived) async {
    if (!archived) {
      // Explicit restoration must also clear a matching local Quick Chat
      // deadline, or the Archived view would immediately hide it again.
      final cleanup = _quickPromotionTail.then((_) async {
        final store = await _quickChatStore();
        final state = await store.load();
        for (final id in {session.id, ?session.lineageRootId}) {
          if (state.expiries.containsKey(id)) await store.promote(id);
        }
      });
      // Keep the shared queue usable after a failure, but let this caller
      // report it and retry the same intent rather than claim success.
      _quickPromotionTail = cleanup.catchError((Object _) {});
      await cleanup;
    }
    if (!mounted) return;
    final before = _archiveChanges.revision;
    _archiveChanges.record(session, archived);
    _browserLoader?.invalidate();
    _archiveLoader?.invalidate();
    setState(() {
      _knownSessions = _archiveChanges.apply(
        _knownSessions,
        before,
        includeMissing: !archived,
      );
    });
    _chatsKey.currentState?.reconcileArchive(session, archived);
    _cronsKey.currentState?.reconcileArchive(session, archived);
    // Other mounted chat surfaces refresh without borrowing a pre-action scan.
    unawaited(_chatsKey.currentState?.refresh() ?? Future<void>.value());
  }

  /// Writes the server pin flag that Hermes Desktop reads and writes, then
  /// tells every mounted Chats/Crons pane so older reads cannot revert it.
  Future<bool> _pinSession(Session session, bool pinned) async {
    if (_chatMutationPending(session)) {
      throw StateError('Chat is already being updated');
    }
    _pinningChats[session.id] = session;
    try {
      final confirmed = await _sessionClient.setSessionPinned(
        sessionId: session.id,
        pinned: pinned,
      );
      if (mounted) {
        // Later list reads must start a new physical scan, not join one that
        // began before the write.
        _browserLoader?.invalidate();
        _archiveLoader?.invalidate();
        _chatsKey.currentState?.reconcilePin(session, confirmed);
        _cronsKey.currentState?.reconcilePin(session, confirmed);
      }
      return confirmed;
    } finally {
      _pinningChats.remove(session.id);
    }
  }

  /// Moves pins saved on this device by older releases to the server flag
  /// once, then refreshes Chats so they appear in the shared Pinned section.
  Future<void> _migrateLegacyPins(LocalChatPinStore store) async {
    try {
      final migrated = await migrateLegacyChatPins(_sessionClient, store);
      if (!mounted || migrated == 0) return;
      _browserLoader?.invalidate();
      await _chatsKey.currentState?.refresh();
    } catch (_) {
      // Unmigrated device pins stay stored and are retried on the next open.
    }
  }

  Future<String> _renameSession(Session session, String title) async {
    final savedTitle = await _sessionClient.renameSession(
      sessionId: session.id,
      title: title,
    );
    if (mounted) {
      final current = _activitySessions[session.id] ?? session;
      _activitySessions.merge([
        current.withTitle(savedTitle),
      ], read: _activitySessions.beginRead());
      _confirmedTitles[session.id] = (
        revision: ++_sessionTitleRevision,
        title: savedTitle,
      );
      _browserLoader?.invalidate();
      _archiveLoader?.invalidate();
      _chatsKey.currentState?.reconcileTitle(session, savedTitle);
      _cronsKey.currentState?.reconcileTitle(session, savedTitle);
      _knownSessions = [
        for (final row in _knownSessions)
          if (row.id == session.id) row.withTitle(savedTitle) else row,
      ];
    }
    return savedTitle;
  }

  void _openWorkspaceSessionView(WorkspaceSessionView view) {
    final key = GlobalKey<WorkspaceSessionsScreenState>();
    final title = switch (view) {
      WorkspaceSessionView.all => context.l10n.all_chats,
      WorkspaceSessionView.unassigned => context.l10n.unassigned_chats,
      WorkspaceSessionView.archivedQuick => context.l10n.archived_quick_chats,
      WorkspaceSessionView.search => context.l10n.search,
    };
    _push(
      WorkspaceSessionsScreen(
        key: key,
        searchMessages: _searchMessages,
        searchScope: widget.connection,
        title: title,
        view: view,
        onPin: _pinSession,
        refreshInterval: widget.sessionsRefreshInterval,
        load: _loadWorkspaceSessionsData,
        loadProgressively: (onProgress) =>
            _loadWorkspaceSessionsData(onProgress: onProgress),
        loadWithoutArchives: (onProgress) => _loadWorkspaceSessionsData(
          onProgress: onProgress,
          includeArchives: false,
        ),
        reloadActive: (onProgress) => _loadWorkspaceSessionsData(
          onProgress: onProgress,
          freshActive: true,
          includeArchives: false,
        ),
        onOpenSession: (session) => unawaited(
          _openSession(
            session,
            onArchiveCommitted: () {
              unawaited(key.currentState?.refresh() ?? Future<void>.value());
            },
            refreshBrowser: () =>
                key.currentState?.refresh() ?? Future<void>.value(),
          ),
        ),
        onRename: _renameSession,
        onArchive: _archiveSession,
        onPromote: (session) =>
            _moveChatToProject(session, sourceContext: key.currentContext),
      ),
    );
  }

  /// Move human chats using the stock, durable cwd-based filing contract.
  /// The caller owns row flight/teardown; this guard also covers other views.
  Future<String> _moveChatToProject(
    Session session, {
    BuildContext? sourceContext,
  }) async {
    final repository = _repository;
    if (repository == null) {
      throw StateError(context.l10n.projects_unavailable);
    }
    if (_chatMutationPending(session)) {
      throw const QuickChatPromotionCancelled();
    }
    _movingChats[session.id] = session;
    bool canContinue() =>
        mounted &&
        sourceContext != null &&
        sourceContext.mounted &&
        (!(sourceContext.widget is WorkspaceSessionsScreen &&
                (sourceContext.widget as WorkspaceSessionsScreen).embedded) ||
            _destination == HermesDestination.chats) &&
        (ModalRoute.of(sourceContext)?.isCurrent ?? true);
    try {
      final revision = _placementRevision;
      final view = await repository.refresh();
      String? currentProjectId;
      try {
        final overview = await repository
            .overview(refresh: true)
            .timeout(const Duration(seconds: 8));
        currentProjectId = overview.sessionProjects[session.id];
      } catch (_) {
        // Unknown membership must not prevent filing an otherwise usable chat.
      }
      final saved = _savedPlacements[session.id];
      if (saved != null &&
          (saved.revision > revision || currentProjectId == null)) {
        currentProjectId = saved.projectId;
      }
      final projects = view.projects
          .where(
            (project) => !project.archived && project.id != currentProjectId,
          )
          .toList(growable: false);
      if (!mounted ||
          sourceContext == null ||
          !sourceContext.mounted ||
          !canContinue()) {
        throw const QuickChatPromotionCancelled();
      }
      if (projects.isEmpty) {
        throw StateError(
          context.l10n.create_a_project_first_then_chats_can_live_inside_it,
        );
      }
      // Even a single target requires intentional confirmation for a move.
      final project = await showModalBottomSheet<HermesProject>(
        context: sourceContext,
        isScrollControlled: true,
        builder: (_) =>
            ProjectPickerSheet(projects: projects, requireFolder: true),
      );
      if (project == null || !canContinue()) {
        throw const QuickChatPromotionCancelled();
      }
      final reason = await repository.moveSessionToProject(
        session.id,
        project.id,
        storedSessionKey: _ownedGateway?.storedSessionKeyFor(session.id),
      );
      if (reason != null) throw StateError(reason);
      // Record the commit before optional follow-up reads. An older list must
      // not undo this label, and refresh failures must not report a failed move.
      _savedPlacements[session.id] = (
        revision: ++_placementRevision,
        projectId: project.id,
        label: project.name,
      );
      _chatProjectLabels = Map.unmodifiable({
        ..._chatProjectLabels,
        session.id: project.name,
      });
      await _promoteQuickChat(session);
      unawaited(_refreshMoveMetadata(repository));
      if (mounted && sourceContext != _chatsKey.currentContext) {
        unawaited(_chatsKey.currentState?.refresh() ?? Future<void>.value());
      }
      return project.name;
    } finally {
      _movingChats.remove(session.id);
    }
  }

  /// Serialise the local read/modify/write across concurrent row moves. The
  /// existing store is a no-op for normal chats and is touched only after RPC
  /// success, including when an active Quick Chat is moved from All.
  Future<void> _promoteQuickChat(Session session) {
    return _quickPromotionTail = _quickPromotionTail.then((_) async {
      try {
        await (await _quickChatStore()).promote(session.id);
      } catch (error) {
        debugPrint('[workspace] moved chat retention save failed: $error');
      }
    });
  }

  Future<void> _refreshMoveMetadata(ProjectsRepository repository) async {
    try {
      await repository
          .overview(refresh: true)
          .timeout(const Duration(seconds: 8));
    } catch (error) {
      debugPrint('[workspace] moved chat metadata refresh failed: $error');
    }
  }

  RemoteFilesClient _createFilesClient(
    SavedConnection connection, {
    String? sessionId,
    int? maxDownloadBytes,
  }) => RemoteFilesClient.fromConnection(
    connection,
    sessionId: sessionId,
    maxDownloadBytes: maxDownloadBytes,
    httpClient: widget.testDashboardHttpClient,
  );

  Future<void> _openFiles() async {
    final builder = widget.filesScreenBuilder;
    if (builder != null) {
      _push(builder(widget.connection));
      return;
    }
    await FilesScreen.open(context, _createFilesClient(widget.connection));
  }

  /// Opens the full cron manager, which owns every schedule mutation.
  ///
  /// The Upcoming view is re-read on return: a job created, paused or deleted
  /// in the manager must not leave the destination showing the old schedule.
  void _openCronJobs() {
    unawaited(
      Navigator.of(context)
          .push(
            MaterialPageRoute<void>(
              builder: (_) => CronScreen(
                connection: widget.connection,
                turnApplicationController: widget.turnApplicationController,
              ),
            ),
          )
          .then((_) => _cronUpcomingKey.currentState?.refresh()),
    );
  }

  Future<void> _openAssets() async {
    final connection = widget.connection;
    final factory = widget.assetsSourceFactory;
    final source =
        factory?.call(connection) ??
        ChatAssetsClient.fromConnection(
          connection,
          httpClient: widget.testDashboardHttpClient,
        );
    try {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => AssetsScreen(
            source: source,
            filesClient: (session) => _createFilesClient(
              connection,
              sessionId: session.id,
              maxDownloadBytes: maxAttachmentDownloadBytes,
            ),
            onOpenSession: (session) => unawaited(_openSession(session)),
            contributionsScope: renderConnectionKey(connection),
          ),
        ),
      );
    } finally {
      if (factory == null && source is ChatAssetsClient) source.close();
    }
  }

  void _openCapability(String id) {
    final connection = widget.connection;
    final gateway = _ownedGateway;
    final owned = gateway == null
        ? DashboardClient.fromConnection(connection)
        : null;
    final admin = CapabilityAdmin.fromDashboard(
      gateway?.dashboard ?? owned!,
      profile: connection.gatewayProfile,
      rpc: gateway == null
          ? null
          : (method, params) => gateway.call(method, params),
    );
    final page = switch (id) {
      'browser-vault' => BrowserVaultScreen(admin: admin),
      'agent-policy' => AgentPolicyScreen(admin: admin),
      _ => CapabilityAdminScreen(admin: admin),
    };
    unawaited(
      pushAndRelease(
        context,
        ProfileTheme(connection: connection, nextGen: false, child: page),
        owned?.close,
      ),
    );
  }

  void _openMoreEntry(MoreEntry entry) {
    final connection = widget.connection;
    switch (entry.id) {
      case 'gateway-fleet':
        _push(
          FleetScreen(
            serving: _ownedGateway?.workspace,
            label: connection.label,
          ),
        );
      case 'workspace-profiles':
        final gateway = _ownedGateway;
        if (gateway == null) return;
        _push(
          WorkspaceProfilesScreen(
            owner: gateway.workspace,
            connection: connection,
            label: connection.label,
            route: gateway.workspace.route(),
          ),
        );
      case 'unassigned':
        _openWorkspaceSessionView(WorkspaceSessionView.unassigned);
      case 'files':
        unawaited(_openFiles());
      case 'projects-root':
        _push(ProjectsRootScreen(connection: connection));
      case 'assets':
        unawaited(_openAssets());
      case 'cron':
        _openCronJobs();
      case 'skills':
        _push(SkillsScreen(connection: connection));
      case 'capability-admin':
      case 'browser-vault':
      case 'agent-policy':
        _openCapability(entry.id);
      case 'memory':
        _push(MemoryScreen(connection: connection));
      case 'host-operations':
        final host = _ownedGateway;
        if (host == null) return;
        _push(
          HostOperationsScreen(
            owner: host.workspace,
            route: host.workspace.route(),
            connection: connection,
          ),
        );
      case 'kanban':
        final kanban = _ownedGateway;
        if (kanban == null) return;
        _push(
          KanbanBoardScreen(
            owner: kanban.workspace,
            route: kanban.workspace.route(),
            connection: connection,
          ),
        );
      case 'bots':
        final bots = _ownedGateway;
        if (bots == null) return;
        _push(
          BotsScreen(
            owner: bots.workspace,
            route: bots.workspace.route(),
            connection: connection,
          ),
        );
      case 'schedule-desk':
        final schedules = _ownedGateway;
        if (schedules == null) return;
        _push(
          ScheduleDeskScreen(
            owner: schedules.workspace,
            route: schedules.workspace.route(),
            connection: connection,
          ),
        );
      case 'memory-graph':
        final memory = _ownedGateway;
        if (memory == null) return;
        _push(
          MemoryGraphScreen(
            owner: memory.workspace,
            route: memory.workspace.route(),
            connection: connection,
          ),
        );
      case 'provider-sign-in':
        _push(ProviderOAuthScreen(connection: connection));
      case 'nous-portal':
        _push(NousPortalScreen(connection: connection));
      case 'provider-admin':
        _push(
          ModelAdminScreen(connection: connection, rpc: _ownedGateway?.rpc),
        );
      case 'nous-billing':
        _push(
          ModelAdminScreen(
            connection: connection,
            initialSection: ModelAdminSection.billing,
            rpc: _ownedGateway?.rpc,
          ),
        );
      case 'openrouter':
        _push(OpenRouterScreen(connection: widget.connection));
      case 'openai':
      case 'anthropic':
      case 'deepseek':
        _push(
          ProviderScreen(
            connection: widget.connection,
            providerId: entry.id,
            title: providerTitles[entry.id]!,
          ),
        );
      case 'model':
        _push(ModelManagementScreen(connection: connection));
      case 'settings':
        _push(SettingsScreen(connection: connection));
      case 'dashboard':
        unawaited(_openDashboard());
    }
  }

  @override
  Widget build(BuildContext context) {
    final expanded = isExpandedWindow(context);
    // Folding a wide window back to compact re-homes an open inline detail
    // chat as a full-screen route so the conversation is not lost. The list
    // keeps its filters/scroll either way (it stays mounted in the shell).
    if (_wasExpanded && !expanded && _detailSession != null) {
      final session = _detailSession!;
      final projectName = _detailProjectName;
      final workingDir = _detailWorkingDirectory;
      final composerText = _detailComposerText;
      final composerAppends = _detailComposerAppends;
      final attachments = _detailAttachments;
      _detailSession = null;
      _detailProjectName = null;
      _detailWorkingDirectory = null;
      _detailComposerText = null;
      _detailComposerAppends = false;
      _detailAttachments = const [];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        unawaited(
          _openSession(
            session,
            projectName: projectName,
            projectWorkingDirectory: workingDir,
            initialComposerText: composerText,
            initialComposerAppends: composerAppends,
            initialAttachmentDrafts: attachments,
          ),
        );
      });
    }
    _wasExpanded = expanded;

    return ProfileTheme(
      connection: widget.connection,
      nextGen: false,
      child: ParallelWorkspaceEntryHost(
        owner: widget.connection,
        connection: widget.connection,
        workspace: (_) => ClassicParallelWorkspace(
          connection: widget.connection,
          turnController: widget.turnApplicationController,
          clientFactory: widget.testChatApiClientFactory,
        ),
        home: (openParallel) =>
            Builder(builder: (ctx) => _buildHome(ctx, openParallel)),
      ),
    );
  }

  Widget _buildHome(BuildContext context, VoidCallback openParallel) {
    final tokens = HermesTokens.of(context);
    return Scaffold(
      // The nested HermesShell owns keyboard resizing and the bottom navigation.
      resizeToAvoidBottomInset: false,
      backgroundColor: tokens.surface,
      appBar: AppBar(
        title: Text(widget.connection.label),
        centerTitle: false,
        actions: [
          const PresentationChrome(),
          IconButton(
            key: const ValueKey('app-command-palette-button'),
            tooltip: context.l10n.palette_open,
            onPressed: _openCommandPalette,
            icon: const Icon(Icons.keyboard_command_key),
          ),
          if (_destination == HermesDestination.chats) ...[
            IconButton(
              tooltip: _inboxActionCount == 0
                  ? context.l10n.open_inbox
                  : context.l10n.open_inbox_2(_inboxActionCount),
              onPressed: _openInbox,
              icon: Badge(
                isLabelVisible: _inboxActionCount > 0,
                label: Text('$_inboxActionCount'),
                child: const Icon(Icons.inbox_outlined),
              ),
            ),
            IconButton(
              tooltip: context.l10n.search_all_chats,
              onPressed: () =>
                  _openWorkspaceSessionView(WorkspaceSessionView.search),
              icon: const Icon(Icons.search),
            ),
          ],
          if (_destination == HermesDestination.crons)
            IconButton(
              tooltip: context.l10n.cron_jobs,
              onPressed: _openCronJobs,
              icon: const Icon(Icons.settings_outlined),
            ),
        ],
      ),
      body: HermesShell(
        key: _shellKey,
        initialDestination: HermesDestination.chats,
        // The badge is the only attention signal visible from another
        // destination, so blocked work has to raise it even while the user is
        // in Projects or More.
        badges: {
          HermesDestination.chats: _knownSessions
              .where(
                (session) =>
                    !isMachineSession(session) &&
                    _turnSignals.attention.containsKey(session.id),
              )
              .length,
          HermesDestination.activity: _activityBlockedCount,
        },
        onDestinationChanged: (destination) {
          setState(() => _destination = destination);
          if (destination == HermesDestination.more) {
            unawaited(_detectProviders());
          }
        },
        // The FAB belongs to the shell, not to this Scaffold: above the shell
        // it would float over the bottom bar and swallow taps on More.
        floatingActionButton: _destination == HermesDestination.chats
            ? FloatingActionButton.extended(
                key: kWorkspaceNewChatButtonKey,
                onPressed: () => unawaited(_startNewChat()),
                icon: const Icon(Icons.add),
                label: Text(context.l10n.new_label),
              )
            : null,
        builder: (context, destination) =>
            _pane(context, destination, openParallel),
      ),
    );
  }
}
