// The NextGen main screen: the sidebar drawer beside one open chat.
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/services/android_share_intent_service.dart';
import '../../core/services/android_launch_intent_service.dart';
import '../../core/models/hermes_project.dart';
import '../../core/models/session.dart';
import '../../core/services/notification_prefs.dart';
import '../../core/services/connection_mutation_barrier.dart';
import '../../core/services/turn_notification_service.dart';
import '../../core/utils/adaptive_layout.dart';
import '../../core/utils/platform_capabilities.dart';
import '../../core/widgets/desktop_shortcuts.dart';
import '../../core/widgets/command_palette.dart';
import '../../core/services/hermes_deeplink.dart';
import '../data/nextgen_gateway.dart';
import '../data/chat_controller.dart';
import '../nextgen_preferences.dart';
import '../theme/nextgen_theme.dart';
import 'capabilities_page.dart';
import 'brand.dart';
import 'chat_view.dart';
import 'insights_page.dart';
import 'more_page.dart';
import 'nextgen_scope.dart';
import 'scheduled_page.dart';
import 'sessions_sidebar.dart';
import 'widgets.dart';
import 'settings_page.dart';
import '../../core/settings/settings_browser.dart';
import 'slash_suggestions.dart';
import '../nextgen_l10n.dart';
import '../../core/desktop/desktop_integration.dart';
import '../../core/desktop/quick_entry.dart';

class NgMainPage extends StatefulWidget {
  const NgMainPage({
    super.key,
    this.shareIntents,
    this.launchIntents,
    this.coldStart = true,
  });

  final AndroidShareIntentService? shareIntents;
  final AndroidLaunchIntentService? launchIntents;
  final bool coldStart;

  @override
  State<NgMainPage> createState() => _NgMainPageVisitState();
}

class _NgMainPageVisitState extends State<NgMainPage> {
  bool _coldStart = true;

  bool _takeColdStart() {
    final cold = _coldStart;
    _coldStart = false;
    return cold && widget.coldStart;
  }

  @override
  Widget build(BuildContext context) => _NgMainContent(
    key: ObjectKey(NgScope.of(context).gateway),
    takeColdStart: _takeColdStart,
    shareIntents: widget.shareIntents,
    launchIntents: widget.launchIntents,
  );
}

class _NgMainContent extends StatefulWidget {
  const _NgMainContent({
    super.key,
    required this.takeColdStart,
    this.shareIntents,
    this.launchIntents,
  });

  final AndroidShareIntentService? shareIntents;
  final AndroidLaunchIntentService? launchIntents;
  final bool Function() takeColdStart;

  @override
  State<_NgMainContent> createState() => _NgMainPageState();
}

class _NgMainPageState extends State<_NgMainContent>
    with WidgetsBindingObserver {
  final _scaffold = GlobalKey<ScaffoldState>();

  /// Keeps the sidebar's search/filter/scroll state alive when it moves
  /// between the modal drawer (compact) and the docked pane (wide) as the
  /// window crosses the expanded breakpoint.
  final _sidebarKey = GlobalKey<NgSessionsSidebarState>();
  bool _focusDrawerSearch = false;

  /// Whether the user collapsed the docked sidebar on a wide window. Reset
  /// implicitly when the window leaves the expanded class.
  bool _dockedSidebarCollapsed = false;

  /// Desktop keyboard shortcut subscription (no-op on touch platforms).
  StreamSubscription<DesktopShortcut>? _desktopShortcutSub;
  VoidCallback? _deepLinkListener;
  VoidCallback? _quickEntryTargets;

  NgSessionsModel? _sessions;
  NgChatController? _chat;

  /// The launch landing is dismissed permanently for this main-page visit
  /// when a chat is opened, started, or an external action is handled.
  AndroidSharePayload? _sharedPayload;
  bool _landing = false;
  bool _foreground = true;
  NextGenGateway? _notificationGateway;
  Object? _notificationMutation;

  /// LRU cache of recently-viewed chat controllers. Keeps parsed transcripts
  /// in memory so switching back doesn't re-fetch multi-MB history pages.
  /// Max 3 parked + 1 active = 4 total.
  final LinkedHashMap<String, NgChatController> _cache = LinkedHashMap();
  static const _maxCached = 3;

  @override
  void initState() {
    super.initState();
    widget.shareIntents?.pendingShare.addListener(_onExternalAction);
    widget.launchIntents?.pendingQuickChat.addListener(_onExternalAction);
    WidgetsBinding.instance.addObserver(this);
    _desktopShortcutSub = desktopShortcutBus.stream.listen(_onDesktopShortcut);
    _quickEntryTargets = QuickEntryTargets.register(
      _quickEntryChats,
      owner: _quickEntryOwner,
    );
    _deepLinkListener = _onPendingDeepLink;
    HermesDeepLinkService.shared.pendingLink.addListener(_deepLinkListener!);
    if (HermesDeepLinkService.shared.pendingLink.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _onPendingDeepLink();
      });
    }
    nextGenOpenRequest.addListener(_onOpenRequest);
    nextGenNotificationAnswer.addListener(_onNotificationAnswer);
  }

  @override
  void dispose() {
    widget.shareIntents?.pendingShare.removeListener(_onExternalAction);
    widget.launchIntents?.pendingQuickChat.removeListener(_onExternalAction);
    _desktopShortcutSub?.cancel();
    _quickEntryTargets?.call();
    final deepLinkListener = _deepLinkListener;
    if (deepLinkListener != null) {
      HermesDeepLinkService.shared.pendingLink.removeListener(deepLinkListener);
    }
    nextGenOpenRequest.removeListener(_onOpenRequest);
    nextGenNotificationAnswer.removeListener(_onNotificationAnswer);
    _requestSub?.cancel();
    _withdrawnSub?.cancel();
    _watchedGateway?.removeListener(_onGatewayChanged);
    _pendingAnswerTimeout?.cancel();
    _chat?.removeListener(_onChatChanged);
    nextGenTurnActive.value = false;
    WidgetsBinding.instance.removeObserver(this);
    _chat?.dispose();
    for (final c in _cache.values) {
      // A just-created Project chat may already be indexed by its stored id.
      if (!identical(c, _chat)) c.dispose();
    }
    _cache.clear();
    _sessions?.removeListener(_onSessionsChanged);
    _sessions?.dispose();
    super.dispose();
  }

  void _onExternalAction() {
    if (!mounted || _sessions == null) return;
    final share = widget.shareIntents?.takePendingShare();
    final quick = widget.launchIntents?.takePendingQuickChat() ?? false;
    if (share == null && !quick) return;
    _scaffold.currentState?.closeDrawer();
    _openId(null, '', initialText: share?.text);
    _sharedPayload = share;
  }

  /// The chat a notification tap asked for, when it belongs to this
  /// connection. Consumed so it opens once.
  String? _takeOpenRequest(String connectionId) {
    final request = nextGenOpenRequest.value;
    if (request == null || request.connectionId != connectionId) return null;
    final target = pendingWindowsToastTarget;
    pendingWindowsToastTarget = null;
    nextGenOpenRequest.value = null;
    if (target != null) {
      final scope = NgScope.of(context);
      if (!target.matches(scope.connection) ||
          !target.matches(
            scope.connManager
                .getConnections()
                .where((c) => c.id == connectionId)
                .firstOrNull,
          )) {
        return null;
      }
    }
    return request.sessionId;
  }

  void _onOpenRequest() {
    if (!mounted) return;
    final scope = NgScope.of(context);
    final id = _takeOpenRequest(scope.connection.id);
    if (id == null) return;
    _scaffold.currentState?.closeDrawer();
    if (id == _chat?.storedId) return;
    _openId(id, '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = NgScope.of(context);
    if (!identical(_notificationGateway, scope.gateway)) {
      _notificationGateway = scope.gateway;
      _notificationMutation = ConnectionMutationBarrier.capture(
        scope.connection.id,
      );
    }
    final sessions = _sessions;
    if (sessions == null) {
      _sessions = NgSessionsModel(scope)..addListener(_onSessionsChanged);
      final requested = _takeOpenRequest(scope.connection.id);
      final link = HermesDeepLinkService.shared.pendingLink.value;
      final action =
          link != null &&
          !link.isIgnored &&
          link.isFor(scope.connection.id, scope.connection.gatewayProfile);
      final external =
          widget.shareIntents?.pendingShare.value != null ||
          (widget.launchIntents?.pendingQuickChat.value ?? false);
      final answer = nextGenNotificationAnswer.value;
      final answering = answer?.connectionId == scope.connection.id;
      final coldStart = widget.takeColdStart();
      if (coldStart &&
          requested == null &&
          !action &&
          !external &&
          !answering) {
        _landing = true;
      } else {
        // Explicit activations never restore an unrelated last chat while
        // waiting for the link's session list or action destination.
        final id = !coldStart && !action && !external && !answering
            ? NextGenPreferences.launchSession(
                scope.prefs,
                scope.connection.id,
                requested: requested,
              )
            : requested ?? (answering ? answer?.sessionId : null);
        _openId(id, '', initial: true);
      }
      _listenForRequests(scope);
      unawaited(_sessions!.refresh());
      if (external) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _onExternalAction(),
        );
      }
    } else {
      sessions.scope = scope;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final wasForeground = _foreground;
    // In sight while resumed or only covered (the notification shade).
    _foreground =
        state == AppLifecycleState.resumed ||
        (!isWindowsPlatform && state == AppLifecycleState.inactive);
    final chat = _chat;
    if (!_foreground && wasForeground && chat != null) {
      // Out of sight: what arrives from now on is news when the user is back.
      _sessions?.markRead(chat.storedId, running: chat.running);
      _sessions?.currentId = null;
    }
    // Pause socket-driven session list refreshes while backgrounded.
    _sessions?.paused = !_foreground;
    if (!_foreground && wasForeground) {
      // A question that came in while in sight still needs its notification
      // now that the app isn't — if the server still waits on it.
      unawaited(_notifyOpenOnBackground(NgScope.of(context)));
    }
    if (_foreground && !wasForeground) {
      _lifecycleTurn++;
      _cancelAttention();
      // Catch the open chat up on what the socket may have missed, and drop
      // questions another device answered meanwhile (the needs-you mark).
      chat?.resync();
      unawaited(NgScope.of(context).gateway.revalidateOpenRequests());
    }
    if (_foreground) {
      _sessions?.currentId = chat?.storedId;
      final scope = NgScope.of(context);
      if (!scope.gateway.state.isConnected) scope.gateway.retry();
      unawaited(_sessions?.refresh());
    }
  }

  void _openId(
    String? id,
    String title, {
    bool initial = false,
    String? workingDirectory,
    String? initialText,
  }) {
    final scope = NgScope.of(context);
    final old = _chat;
    if (initialText == null) _sharedPayload = null;

    // Try the LRU cache first: reuse the parsed transcript, just resync.
    NgChatController? cached;
    if (id != null && _cache.containsKey(id)) {
      cached = _cache.remove(id);
    }

    late final NgChatController chat;
    if (cached != null) {
      chat = cached;
      // Update the title in case it changed while parked.
      if (title.isNotEmpty) chat.title = title;
      // A parked chat keeps its draft; a link's prefill is appended to it
      // when the view mounts.
      if (initialText != null) chat.offerInitialText(initialText);
    } else {
      chat = NgChatController(
        scope.gateway,
        sessionId: id,
        title: title,
        workingDirectory: workingDirectory,
        initialText: initialText,
        onCreated: (stored) {
          unawaited(
            NextGenPreferences.setLastSession(
              scope.prefs,
              scope.connection.id,
              stored,
            ),
          );
          if (identical(_chat, chat)) _sessions?.currentId = stored;
          // Move into the cache under the new stored id.
          if (stored.isNotEmpty) _cache[stored] = chat;
          unawaited(_sessions?.refresh());
        },
        onTurnFinished: () => _turnFinished(chat),
      );
    }

    // Leaving a chat counts as having seen it so far; one left mid-turn shows
    // unread when its reply lands.
    _sessions?.markRead(old?.storedId, running: old?.running ?? false);
    _sessions?.currentId = id;
    if (id != null) _sessions?.markRead(id);
    old?.removeListener(_onChatChanged);
    chat.addListener(_onChatChanged);
    _chatWasRunning = false;
    nextGenTurnActive.value = false;
    if (initial) {
      _chat = chat;
    } else {
      setState(() {
        _chat = chat;
        _landing = false;
      });
    }

    // Park the old controller in the LRU cache instead of disposing it.
    if (old != null && !identical(old, chat)) {
      final oldId = old.storedId;
      if (oldId != null && oldId.isNotEmpty) {
        _cache[oldId] = old;
        // Evict oldest parked controllers beyond the limit.
        while (_cache.length > _maxCached) {
          final evictKey = _cache.keys.first;
          final evicted = _cache.remove(evictKey);
          evicted?.dispose();
        }
      } else {
        old.dispose();
      }
    }

    if (cached != null) {
      // Cached transcript is already parsed; just catch up on missed events.
      chat.resync();
    } else {
      unawaited(chat.open());
    }
    unawaited(
      NextGenPreferences.setLastSession(scope.prefs, scope.connection.id, id),
    );
  }

  // ── Notifications (Kyllene's ChatNotifier) ──────────────────────────
  //
  // Out of sight: a heads-up for every approval, question or secret the agent
  // waits on (approvals with Allow once / Deny buttons), and the open chat's
  // reply when its turn ends. Each comes down once answered, when a new turn
  // starts in that chat, or when the app is back in sight. While the open
  // chat's turn runs, the app root keeps the process up (foreground service)
  // so the socket survives the background.

  StreamSubscription<NgServerRequest>? _requestSub;
  StreamSubscription<String>? _withdrawnSub;
  NextGenGateway? _watchedGateway;

  /// Requests posted, by request id: what to cancel once each is gone.
  final Map<
    String,
    ({HermesNotificationKind kind, String? sessionId, String connectionId})
  >
  _postedRequests = {};

  /// Every request already notified (most recent last). Each one alerts at
  /// most once: coming back in sight takes it down, and leaving again must not
  /// post it anew.
  final LinkedHashSet<String> _notifiedRequests = LinkedHashSet();
  static const _maxNotifiedRequests = 256;

  /// Bumped on every trip out of and back into sight, so a background
  /// re-check that finishes after the app came back posts nothing.
  int _lifecycleTurn = 0;

  Future<void> _notifyOpenOnBackground(NgScope scope) async {
    final turn = ++_lifecycleTurn;
    // The socket only hears that a request was answered when the gateway says
    // so; ask it which are still open before posting any of them.
    await scope.gateway.revalidateOpenRequests();
    if (!mounted || _foreground || turn != _lifecycleTurn) return;
    for (final raw in scope.gateway.openRequests.values.toList()) {
      await _notifyRequest(scope, raw);
    }
  }

  /// Chats whose reply notification is up.
  final Set<String> _postedReplies = {};

  static const _replyTurnId = 'nextgen-reply';

  void _listenForRequests(NgScope scope) {
    _requestSub?.cancel();
    _requestSub = scope.gateway.serverRequests.listen(
      (raw) => unawaited(_notifyRequest(scope, raw)),
    );
    // Answered here or elsewhere, withdrawn, or found settled by the server:
    // its notification comes down. A dropped socket alone settles nothing.
    _withdrawnSub?.cancel();
    _withdrawnSub = scope.gateway.withdrawnRequests.listen(_cancelRequest);
    _watchedGateway?.removeListener(_onGatewayChanged);
    _watchedGateway = scope.gateway..addListener(_onGatewayChanged);
  }

  String? _storedFor(NgScope scope, String? runtime) => runtime == null
      ? _chat?.storedId
      : scope.gateway.storedIdFor(runtime) ?? runtime;

  Future<void> _notifyRequest(NgScope scope, NgServerRequest raw) async {
    if (_foreground || !mounted) return;
    if (_postedRequests.containsKey(raw.id)) return;
    if (_notifiedRequests.contains(raw.id)) return;
    // Answered elsewhere or withdrawn already: nothing to ask about.
    if (!scope.gateway.openRequests.containsKey(raw.id)) return;
    final input = NgInputRequest.parse(raw);
    if (input == null) return;
    _notifiedRequests.add(raw.id);
    while (_notifiedRequests.length > _maxNotifiedRequests) {
      _notifiedRequests.remove(_notifiedRequests.first);
    }
    // A missing session or unmapped runtime is not proof of the visible chat.
    // Keep the native alert, but make its activation focus-only in that case.
    final runtime = raw.sessionId;
    final stored = isWindowsPlatform
        ? (runtime == null ? null : scope.gateway.storedIdFor(runtime))
        : _storedFor(scope, runtime);
    final turn = _lifecycleTurn;
    bool stillNeeded() =>
        mounted &&
        !_foreground &&
        turn == _lifecycleTurn &&
        identical(_watchedGateway, scope.gateway) &&
        (!isWindowsPlatform ||
            ConnectionMutationBarrier.isCurrent(
              scope.connection.id,
              _notificationMutation,
            )) &&
        scope.gateway.awaitsAnswer(raw.id);
    final approval = input.kind == NgRequestKind.approval;
    final kind = approval
        ? HermesNotificationKind.approval
        : HermesNotificationKind.input;
    final posted = await TurnNotificationService.shared.showKind(
      origin: scope.connection,
      kind: kind,
      title: input.title,
      body: input.body.isNotEmpty
          ? input.body
          : (input.command ?? ngL.ng_hermes_is_waiting_for_you),
      eventId: raw.id,
      windowsStillNeeded: isWindowsPlatform ? stillNeeded : null,
      sessionId: stored,
      connectionId: scope.connection.id,
      actions: approval
          ? [
              TurnNotificationAction(id: 'approve', label: ngL.ng_allow_once),
              TurnNotificationAction(id: 'reject', label: ngL.ng_deny),
            ]
          : const [],
      payload: jsonEncode({
        'connectionId': scope.connection.id,
        'sessionId': stored,
        'requestId': raw.id,
      }),
    );
    if (!posted) return;
    // Re-check after the last await. Cancel on the issuing connection, not a
    // replacement scope, even if the route has already been disposed.
    if (!stillNeeded()) {
      await TurnNotificationService.shared.cancelKind(
        kind: kind,
        eventId: raw.id,
        sessionId: stored,
        connectionId: scope.connection.id,
      );
      return;
    }
    _postedRequests[raw.id] = (
      kind: kind,
      sessionId: stored,
      connectionId: scope.connection.id,
    );
  }

  /// A request redelivered after a reconnect may be the one an approval
  /// button is waiting for.
  void _onGatewayChanged() => _answerPending();

  void _cancelRequest(String id) {
    final posted = _postedRequests.remove(id);
    if (posted == null || !mounted) return;
    unawaited(
      TurnNotificationService.shared.cancelKind(
        kind: posted.kind,
        eventId: id,
        sessionId: posted.sessionId,
        connectionId: posted.connectionId,
      ),
    );
  }

  void _cancelReply(String storedId) {
    if (!_postedReplies.remove(storedId) || !mounted) return;
    unawaited(
      TurnNotificationService.shared.cancelTurnCompleted(
        _replyTurnId,
        sessionId: storedId,
        connectionId: NgScope.of(context).connection.id,
      ),
    );
  }

  /// Back in sight: what was posted is on screen now.
  void _cancelAttention() {
    for (final id in _postedRequests.keys.toList()) {
      _cancelRequest(id);
    }
    for (final id in _postedReplies.toList()) {
      _cancelReply(id);
    }
  }

  // An approval button pressed, answered on this socket once the request is
  // there (it is redelivered when the socket comes back).
  NgNotificationAnswer? _pendingAnswer;
  Timer? _pendingAnswerTimeout;

  void _onNotificationAnswer() {
    final answer = nextGenNotificationAnswer.value;
    if (answer == null || !mounted) return;
    if (answer.connectionId != NgScope.of(context).connection.id) return;
    nextGenNotificationAnswer.value = null;
    _pendingAnswer = answer;
    _pendingAnswerTimeout?.cancel();
    _pendingAnswerTimeout = Timer(
      const Duration(seconds: 30),
      () => _pendingAnswer = null,
    );
    _answerPending();
  }

  void _answerPending() {
    final answer = _pendingAnswer;
    final gateway = _watchedGateway;
    if (answer == null || gateway == null) return;
    final request = gateway.openRequests[answer.requestId];
    if (request == null) return;
    _pendingAnswer = null;
    _pendingAnswerTimeout?.cancel();
    request.raw.respond({'choice': answer.choice});
    gateway.forgetRequest(answer.requestId);
    _chat?.forgetRequest(answer.requestId);
    _cancelRequest(answer.requestId);
  }

  bool _chatWasRunning = false;

  void _onChatChanged() {
    final chat = _chat;
    if (chat == null) return;
    if (chat.running && !_chatWasRunning) {
      final stored = chat.storedId;
      if (stored != null) _cancelReply(stored);
    }
    _chatWasRunning = chat.running;
    nextGenTurnActive.value = chat.running;
  }

  void _turnFinished(NgChatController chat) {
    unawaited(_sessions?.refresh());
    if (!mounted) return;
    final label = chat.title.isEmpty ? ngL.ng_hermes_replied : chat.title;
    if (_foreground) {
      TurnNotificationService.recordAttempt(
        'reply',
        label,
        'skipped',
        detail: 'Ares was on screen',
      );
      return;
    }
    if (chat.lastTurnInterrupted) {
      TurnNotificationService.recordAttempt(
        'reply',
        label,
        'skipped',
        detail: 'the turn was stopped',
      );
      return;
    }
    final stored = chat.storedId;
    final reply = chat.items.whereType<NgAssistantItem>().lastOrNull;
    var text = reply?.text.trim() ?? '';
    final failed = chat.lastTurnFailed;
    if (failed && (chat.error?.isNotEmpty ?? false)) text = chat.error!;
    final title = chat.title.isEmpty ? ngL.ng_hermes_replied : chat.title;
    final body = text.isEmpty
        ? (failed ? ngL.ng_the_turn_failed : ngL.ng_the_turn_finished)
        : text.length > 180
        ? '${text.substring(0, 180)}…'
        : text;
    final scope = NgScope.of(context);
    final connectionId = chat.gateway.connection.id;
    final conversation =
        identical(chat.gateway, scope.gateway) &&
            ConnectionMutationBarrier.isCurrent(
              connectionId,
              _notificationMutation,
            ) &&
            text.isNotEmpty
        ? TurnNotificationService.conversationTarget(
            scope.connManager,
            chat.gateway.connection,
            stored,
          )
        : null;
    final notifications = TurnNotificationService.shared;
    unawaited(
      failed
          ? notifications.showTurnFailed(
              origin: chat.gateway.connection,
              title: title,
              turnSummary: body,
              turnId: _replyTurnId,
              sessionId: stored,
              connectionId: connectionId,
            )
          : notifications.showTurnCompleted(
              origin: chat.gateway.connection,
              title: title,
              turnSummary: body,
              turnId: _replyTurnId,
              sessionId: stored,
              connectionId: connectionId,
              conversation: conversation,
            ),
    );
    if (stored != null) _postedReplies.add(stored);
  }

  /// Handles desktop keyboard shortcuts routed from the app root.
  void _onDesktopShortcut(DesktopShortcut shortcut) {
    if (!mounted) return;
    switch (shortcut) {
      case DesktopShortcut.commandPalette:
        _openCommandPalette();
      case DesktopShortcut.newChat:
        _newChat();
      case DesktopShortcut.search:
        if (isExpandedWindow(context)) {
          setState(() => _dockedSidebarCollapsed = false);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _sidebarKey.currentState?.focusSearch();
          });
        } else if (_scaffold.currentState?.isDrawerOpen ?? false) {
          _sidebarKey.currentState?.focusSearch();
        } else {
          _focusDrawerSearch = true;
          _scaffold.currentState?.openDrawer();
        }
      case DesktopShortcut.settings:
        _go(NgDestination.settings);
      case DesktopShortcut.tab1:
        if (!isExpandedWindow(context)) _scaffold.currentState?.openDrawer();
      case DesktopShortcut.tab2:
        _go(NgDestination.scheduled);
      case DesktopShortcut.tab3:
        _go(NgDestination.insights);
      case DesktopShortcut.tab4:
        _go(NgDestination.capabilities);
    }
  }

  void _onSessionsChanged() {
    if (!mounted) return;
    if (HermesDeepLinkService.shared.pendingLink.value != null) {
      _onPendingDeepLink();
    }
  }

  /// The connection and profile whose chats quick entry offers.
  HermesLinkOwner? _quickEntryOwner() {
    final connection = _notificationGateway?.connection;
    if (!mounted || connection == null) return null;
    return HermesLinkOwner(
      connectionId: connection.id,
      profile: connection.gatewayProfile,
    );
  }

  /// Recent chats offered to the desktop quick-entry window.
  List<QuickEntryChat> _quickEntryChats() => [
    for (final session in _sessions?.sessions ?? const <Session>[])
      QuickEntryChat(id: session.id, title: ngSessionTitle(session)),
  ];

  Future<void> _openQuickEntry() async {
    final desktop = DesktopIntegration.current;
    if (desktop == null) return;
    final opened = await desktop.openQuickEntry();
    if (opened || !mounted) return;
    ngToast(context, ngL.quick_entry_unavailable);
  }

  /// Opens the shared app-wide command palette (same widget as Classic).
  void _openCommandPalette() {
    final sessions = _sessions?.sessions ?? const <Session>[];
    showAppCommandPalette(
      context,
      actions: [
        PaletteAction(
          id: 'new-chat',
          label: ngL.ng_new_chat,
          icon: Icons.add_comment_outlined,
          keywords: const ['compose', 'start', 'new', 'chat'],
        ),
        PaletteAction(
          id: 'search',
          label: ngL.palette_search_sessions,
          icon: Icons.search,
          keywords: const ['find', 'sessions', 'chats', 'search'],
        ),
        if (DesktopIntegration.current != null)
          PaletteAction(
            id: 'quick-entry',
            label: ngL.quick_entry_title,
            icon: Icons.edit_note_outlined,
            keywords: const ['hud', 'quick', 'prompt', 'entry', 'hotkey'],
          ),
        PaletteAction(
          id: 'nav-scheduled',
          label: ngL.ng_scheduled,
          icon: Icons.schedule,
          keywords: const ['cron', 'scheduled', 'jobs'],
        ),
        PaletteAction(
          id: 'nav-insights',
          label: ngL.palette_insights_usage,
          icon: Icons.insights_outlined,
          keywords: const ['usage', 'analytics', 'stats'],
        ),
        PaletteAction(
          id: 'nav-capabilities',
          label: ngL.ng_capabilities,
          icon: Icons.extension_outlined,
          keywords: const ['skills', 'plugins', 'mcp', 'tools'],
        ),
        PaletteAction(
          id: 'nav-archived',
          label: ngL.ng_archived_chats,
          icon: Icons.archive_outlined,
          keywords: const ['archive', 'archived'],
        ),
        PaletteAction(
          id: 'nav-more',
          label: ngL.palette_more_projects,
          icon: Icons.more_horiz,
          keywords: const ['projects', 'files', 'memory', 'models'],
        ),
        PaletteAction(
          id: 'settings',
          label: ngL.ng_settings,
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
            label: ngSessionTitle(session),
            hint: session.id,
            icon: Icons.forum_outlined,
            keywords: [session.id, if (session.model.isNotEmpty) session.model],
          ),
      ],
      onSelected: (action) {
        if (!mounted) return;
        if (action.id.startsWith('session:')) {
          final id = action.id.substring('session:'.length);
          final match = _sessions?.sessions
              .where((s) => s.id == id)
              .firstOrNull;
          if (match != null) {
            _open(match);
          }
          return;
        }
        switch (action.id) {
          case 'new-chat':
            _newChat();
          case 'search':
            if (isExpandedWindow(context)) {
              setState(() => _dockedSidebarCollapsed = false);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _sidebarKey.currentState?.focusSearch();
              });
            } else {
              _focusDrawerSearch = true;
              _scaffold.currentState?.openDrawer();
            }
          case 'quick-entry':
            unawaited(_openQuickEntry());
          case 'nav-scheduled':
            _go(NgDestination.scheduled);
          case 'nav-insights':
            _go(NgDestination.insights);
          case 'nav-capabilities':
            _go(NgDestination.capabilities);
          case 'nav-archived':
            _go(NgDestination.archived);
          case 'nav-more':
            _go(NgDestination.more);
          case 'settings':
            _go(NgDestination.settings);
        }
      },
    );
  }

  /// Consumes a validated `hermes://` link. Never sends, never executes.
  void _onPendingDeepLink() {
    final peek = HermesDeepLinkService.shared.pendingLink.value;
    if (peek == null || !mounted) return;
    // A link that belongs to another connection or profile (a quick-entry
    // hand-back) waits until NextGen shows that connection.
    final shown = NgScope.of(context).connection;
    if (!peek.isFor(shown.id, shown.gatewayProfile)) return;
    if (peek.kind == HermesDeepLinkKind.session) {
      final id = peek.sessionId;
      final sessions = _sessions;
      if (id != null &&
          (sessions == null ||
              (sessions.loading &&
                  !sessions.sessions.any((s) => s.id == id)))) {
        // Wait for the initial session list load before deciding whether this
        // session exists on the connected gateway.
        return;
      }
    }
    final link = HermesDeepLinkService.shared.takePendingLink();
    if (link == null || !mounted || link.isIgnored) return;
    if (_landing) _openId(null, '');
    switch (link.kind) {
      case HermesDeepLinkKind.launch:
        return; // focus-only; no route, no prefill
      case HermesDeepLinkKind.settings:
        _go(
          NgDestination.settings,
          settingsCategory: SettingsCategory.fromPath(link.path),
        );
        return;
      case HermesDeepLinkKind.install:
        // Navigation-only: open Capabilities for explicit user review, never
        // auto-installing a skill, plugin or MCP server on link open.
        _go(NgDestination.capabilities);
        return;
      case HermesDeepLinkKind.open:
        final path = link.path ?? '';
        if (path.startsWith('/settings')) {
          _go(
            NgDestination.settings,
            settingsCategory: SettingsCategory.fromPath(path),
          );
        } else if (path == '/scheduled' ||
            path == '/crons' ||
            path == '/cron') {
          _go(NgDestination.scheduled);
        } else if (path == '/insights' || path == '/activity') {
          _go(NgDestination.insights);
        } else if (path == '/capabilities' ||
            path == '/skills' ||
            path == '/plugins' ||
            path == '/mcp') {
          _go(NgDestination.capabilities);
        } else if (path == '/archived') {
          _go(NgDestination.archived);
        } else if (path == '/more' || path == '/projects') {
          _go(NgDestination.more);
        } else if (path == '/chat' || path == '/chats') {
          if (link.prefill != null) {
            _scaffold.currentState?.closeDrawer();
            _openId(null, '', initialText: link.prefill);
          }
        }
        return;
      case HermesDeepLinkKind.session:
        final id = link.sessionId;
        if (id == null) return;
        final sessions = _sessions;
        final match = sessions?.sessions.where((s) => s.id == id).firstOrNull;
        if (match == null) {
          // A validated but unknown id must not create a chat — it would
          // either silently open an empty chat or pretend the session
          // exists. Surface honesty instead.
          ngToast(context, ngL.deeplink_chat_not_found);
          unawaited(sessions?.refresh());
          return;
        }
        _scaffold.currentState?.closeDrawer();
        final open = _chat;
        final prefill = link.prefill;
        if (open != null && open.storedId == id) {
          // Already open: the view appends the prefill to its draft.
          if (prefill != null) open.offerInitialText(prefill);
          return;
        }
        _openId(id, ngSessionTitle(match), initialText: prefill);
        return;
      case HermesDeepLinkKind.ignore:
        return;
    }
  }

  void _onBack(bool didPop) {
    if (didPop) return;
    final scaffold = _scaffold.currentState;
    if (scaffold == null) return;
    if (scaffold.isDrawerOpen) {
      // Back dismisses the open sidebar; it must not leave the app. The
      // drawer's local-history entry is cleared by the close animation.
      scaffold.closeDrawer();
    } else if (!NgSlashSuggestions.dismissForBack()) {
      // (An open `/` suggestions box takes Back first.)
      scaffold.openDrawer();
    }
  }

  void _open(Session s) {
    _scaffold.currentState?.closeDrawer();
    if (s.id == _chat?.storedId) {
      if (_landing) setState(() => _landing = false);
      return;
    }
    _openId(s.id, ngSessionTitle(s));
  }

  void _newChat() {
    _scaffold.currentState?.closeDrawer();
    if (_landing) setState(() => _landing = false);
    if (_chat?.isNew == true &&
        _chat!.items.isEmpty &&
        _chat!.workingDirectory == null) {
      return;
    }
    _openId(null, '');
  }

  void _newProjectChat(HermesProject project) {
    // Never let a stale/folderless Project silently become an unassigned chat.
    final cwd = project.workingDirectory;
    if (cwd == null || cwd.trim().isEmpty) return;
    _scaffold.currentState?.closeDrawer();
    _openId(null, '', workingDirectory: cwd);
  }

  void _go(NgDestination d, {SettingsCategory? settingsCategory}) {
    _scaffold.currentState?.closeDrawer();
    final Widget page = switch (d) {
      NgDestination.scheduled => NgScheduledPage(onOpenSession: _open),
      NgDestination.insights => const NgInsightsPage(),
      NgDestination.capabilities => const NgCapabilitiesPage(),
      NgDestination.archived => NgArchivedPage(onOpenSession: _open),
      NgDestination.more => NgMorePage(
        onOpenSession: _open,
        onNewProjectChat: _newProjectChat,
      ),
      NgDestination.settings => NgSettingsPage(
        initialCategory: settingsCategory,
      ),
    };
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final chat = _chat;
    final c = NgColors.of(context);
    final expanded = isExpandedWindow(context);
    // Wide windows dock the sessions sidebar beside the chat; compact and
    // medium windows keep the modal drawer. The same sidebar State (search,
    // filter, scroll) is reused across the breakpoint via [_sidebarKey].
    final docked = expanded && !_dockedSidebarCollapsed;
    _sessions?.drawerOpen = docked;

    final sidebar = NgSessionsSidebar(
      key: _sidebarKey,
      model: _sessions!,
      currentSessionId: chat?.storedId,
      onOpen: _open,
      onNewChat: _newChat,
      onDestination: _go,
      docked: docked,
    );

    void toggleSidebar() {
      if (expanded) {
        setState(() => _dockedSidebarCollapsed = !_dockedSidebarCollapsed);
      } else {
        _scaffold.currentState?.openDrawer();
      }
    }

    final view = _landing
        ? NgBrandLanding(
            sessions: _sessions!,
            docked: docked,
            onNewChat: _newChat,
            onOpen: _open,
            onOpenChats: toggleSidebar,
          )
        : chat == null
        ? const SizedBox.shrink()
        : NgChatView(
            key: ObjectKey(chat),
            chat: chat,
            initialSharedPayload: _sharedPayload,
            onOpenSidebar: toggleSidebar,
            sessions: _sessions,
            onNewChat: _newChat,
            onOpenSessionId: (id, {title}) {
              unawaited(_sessions?.refresh());
              _openId(id, title ?? '');
            },
            onResume: (id, title) => _openId(id, title),
            onOpenCommandPalette: _openCommandPalette,
          );

    final chatView = view;

    // Back opens the sidebar; back again with the sidebar open closes it.
    // Pushed pages (settings, scheduled...) still pop normally first.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _onBack(didPop),
      child: Scaffold(
        key: _scaffold,
        drawerEdgeDragWidth: 48,
        onDrawerChanged: (open) {
          _sessions?.drawerOpen = open || docked;
          if (open) {
            if (_focusDrawerSearch) _sidebarKey.currentState?.focusSearch();
            _focusDrawerSearch = false;
            unawaited(_sessions?.refresh());
          }
        },
        drawer: docked ? null : sidebar,
        body: docked
            ? Row(
                children: [
                  sidebar,
                  VerticalDivider(width: 1, thickness: 1, color: c.stroke),
                  Expanded(child: chatView),
                ],
              )
            : chatView,
      ),
    );
  }
}
