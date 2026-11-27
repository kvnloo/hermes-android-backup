// The NextGen chat: Kyllene's transcript (markdown replies with collapsible
// thinking and tool rows), status line, inline approval/question panel and the
// pill composer (model chip, dictation, send/stop, steer or queue while busy).
import 'dart:async';
import 'dart:io';
import '../../core/workspace/terminal_chat_link.dart';
import '../../core/services/hermes_deeplink.dart' show appendComposerPrefill;
import '../../core/services/connection_manager.dart';
import '../../core/services/remote_workspace.dart' show RemoteWorkspaceOwner;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/parked_automotive.dart';
import '../../core/models/attachment_draft.dart';
import '../../core/preview/chat_preview.dart';
import '../../core/render/render_scope.dart';
import '../../core/capabilities/capability_admin.dart';
import '../../core/render/catalog_install.dart';
import '../../core/render/rich_transcript.dart';
import '../../core/render/setup_beat.dart';
import '../../core/screens/workspace_workers_screen.dart';
import '../../core/screens/gateway_queue_screen.dart';
import '../../core/screens/kanban_board_screen.dart';
import '../../core/widgets/kanban_dock.dart';
import '../../core/screens/bots_screen.dart';
import '../../core/services/remote_files_client.dart';
import '../../core/services/legal_links.dart';
import '../../core/utils/delivered_files.dart';
import '../../core/utils/media_tags.dart';
import '../../core/widgets/chat_presence.dart';
import '../../core/widgets/desktop_shortcuts.dart';
import '../../core/widgets/transcript_reader.dart';
import '../../core/widgets/transcript_body.dart';
import '../../core/services/chat_presentation_state.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/composer_prompt_recall.dart';
import '../../core/widgets/rewind_dialogs.dart';
import '../../core/composer/composer_commands.dart';
import '../../core/composer/composer_drag.dart';
import '../../core/composer/composer_intake.dart';
import '../../core/composer/os_intake.dart';
import '../../core/services/ws_client.dart' show JsonRpcError;
import '../../core/composer/context_status.dart';
import '../../core/composer/reference_completion.dart';
import '../../core/composer/failure_recovery.dart';
import '../../core/widgets/composer_context_status.dart';
import '../../core/widgets/composer_drop_surface.dart';
import '../../core/widgets/composer_reference_assist.dart';
import '../../core/widgets/failure_recovery_card.dart';
import '../../core/widgets/prompt_snippet_sheet.dart';
import '../../core/widgets/resume_session_picker.dart';
import '../../core/widgets/orphan_draft_recovery.dart';
import '../../core/widgets/markdown_code_block.dart';
import '../../core/widgets/media_artifact_card.dart';
import '../../core/widgets/attachment_audio_preview.dart';
import '../../core/utils/audio_file_references.dart';
import '../../core/widgets/slash_command_highlight.dart';
import '../../core/presentation/companion_draft.dart';
import '../../core/presentation/petdex.dart';
import '../../core/presentation/presentation_chrome.dart';
import '../../core/presentation/radio.dart' show showAresRadioSheet;
import '../../core/presentation/reading_controls.dart';
import '../../core/presentation/transcript_reading.dart';
import '../../core/widgets/session_files_view.dart';
import '../../core/widgets/session_history_page.dart';
import '../../core/widgets/git_review_pane.dart';
import '../../core/models/turn_changed_files.dart';
import '../../core/services/android_voice_composer_adapter.dart';
import '../../core/services/auto_speak_replies.dart';
import '../../core/services/client_direct_voice.dart';
import '../../core/services/client_direct_voice_speaker.dart';
import '../../core/services/connection_mutation_barrier.dart';
import '../../core/services/gateway_wake_word.dart';
import '../../core/services/gpt_live_conversation.dart';
import '../../core/services/voice_live_engine.dart';
import '../../core/services/voice_live_mode.dart';
import '../../core/services/wake_voice_request.dart';
import '../../core/utils/voice_stop_word.dart';
import '../../core/widgets/barge_in_indicator.dart';
import '../../core/widgets/gateway_wake_controls.dart';
import '../../core/widgets/voice_live_controls.dart';
import '../../core/services/attachment_controller.dart' show attachmentMimeType;
import '../../core/services/attachment_draft_service.dart';
import '../../core/widgets/client_held_queue_bar.dart';
import '../../core/widgets/prepared_image_recovery.dart';
import '../../core/services/prepared_image_store.dart';
import '../../core/services/voice_composer_adapter.dart';
import '../data/chat_controller.dart';
import '../data/nextgen_gateway.dart';
import '../data/read_aloud.dart';
import '../data/slash_catalog.dart';
import '../data/slash_exec.dart';
import '../theme/nextgen_theme.dart';
import 'model_sheet.dart';
import 'nextgen_scope.dart';
import 'project_greeting.dart';
import 'session_dock.dart';
import 'sessions_sidebar.dart';
import 'slash_command_info.dart';
import 'brand.dart';
import 'slash_suggestions.dart';
import 'widgets.dart';
import '../nextgen_l10n.dart';
import '../../core/services/android_share_intent_service.dart';
import '../../core/desktop/screen_capture.dart';

class NgChatView extends StatefulWidget {
  const NgChatView({
    super.key,
    required this.chat,
    this.onOpenSidebar,
    this.onClose,
    this.sessions,
    this.loadSessions,
    this.onNewChat,
    this.onOpenSessionId,
    this.onResume,
    this.onOpenCommandPalette,
    this.readAloudFactory,
    this.wakeController,
    this.voiceModeController,
    this.voiceLiveEngineFactory,
    this.screenCapture,
    this.initialSharedPayload,
  });

  /// One-shot share intake, owned by this freshly opened draft.
  final AndroidSharePayload? initialSharedPayload;

  final NgChatController chat;
  final VoidCallback? onOpenSidebar;
  final VoidCallback? onClose;

  /// The sidebar's list, for a dot on its button while other chats are unread.
  final NgSessionsModel? sessions;

  /// The connection's chats for `/resume`, read when the picker opens, for a
  /// view with no sidebar list of its own (a parallel pane, a pop-out).
  final Future<List<Session>> Function()? loadSessions;
  final VoidCallback? onNewChat;
  final void Function(String sessionId, {String? title})? onOpenSessionId;
  final void Function(String id, String title)? onResume;
  final VoidCallback? onOpenCommandPalette;

  /// Test hook: supplies the read-aloud controller (e.g. a fake speaker).
  @visibleForTesting
  final NgReadAloud Function()? readAloudFactory;

  /// Test hook: overrides `chat.gateway.wakeWord`.
  @visibleForTesting
  final GatewayWakeWordController? wakeController;

  /// Test hook: overrides `chat.gateway.voiceLiveMode`.
  @visibleForTesting
  final VoiceLiveModeController? voiceModeController;

  /// Test hook: overrides the per-chat [VoiceLiveEngine].
  @visibleForTesting
  final VoiceLiveEngine Function(GptLiveTransport transport)?
  voiceLiveEngineFactory;

  /// Desktop screen capture; tests pass a fake-channel controller.
  final ScreenCaptureController? screenCapture;

  @override
  State<NgChatView> createState() => _NgChatViewState();
}

class _NgChatViewState extends State<NgChatView>
    with WidgetsBindingObserver, TerminalComposerAttachment<NgChatView> {
  bool _companionLeftDuringTurn = false;
  bool _companionUnread = false;

  @override
  SavedConnection get terminalConnection => chat.gateway.connection;
  @override
  String? get terminalSession => chat.storedId;
  @override
  RemoteWorkspaceOwner get terminalOwner => chat.gateway.workspace;
  @override
  TextEditingController get terminalComposer => _input;

  /// A fresh files client per card: cards close theirs when done, so they
  /// must not share the gateway's own dashboard connection.
  RemoteFilesDataSource _filesClient() {
    return NgScope.of(context).gateway.createFilesClient(
      sessionId: chat.storedId,
      maxDownloadBytes: maxAttachmentDownloadBytes,
    );
  }

  Future<WidgetHtmlSource?> _readWidgetHtml(String path) async {
    if (!mounted) return null;
    final client = _filesClient();
    try {
      final preview = await client.readText(path);
      if (preview.binary) return null;
      return WidgetHtmlSource(preview.text, truncated: preview.truncated);
    } catch (_) {
      return null;
    } finally {
      if (client is RemoteFilesClient) client.close();
    }
  }

  /// Installs a failed catalog plugin again after its operation settled,
  /// through the capabilities install of the chat's own connection and
  /// profile (not the active one, which may be another connection) into the
  /// row's own target profile, as Desktop's retrySettled does through the
  /// owner of the request's session.
  Future<CatalogRetryResult> _retryCatalogRow(CatalogRow row) async {
    final gateway = chat.gateway;
    final admin = CapabilityAdmin.fromDashboard(
      gateway.dashboard,
      profile: gateway.profile,
      // The chat's own socket: a settled card belongs to a live chat.
      rpc: (method, params) =>
          gateway.call(method, params, timeout: const Duration(minutes: 3)),
    );
    final mutation = await admin.installCatalogPlugin(
      row.name,
      profile: row.targetProfile,
      force: row.approvedForce,
      enable: row.approvedEnable,
      ref: row.approvedRef,
    );
    return CatalogRetryResult(
      ok: mutation.ok,
      message:
          mutation.message ??
          (mutation.lines.isEmpty ? null : mutation.lines.join('\n')),
    );
  }

  /// A widget may continue only an idle chat, as in Classic: a running
  /// turn, dictation, an attachment being prepared or a stale owner
  /// refuses it rather than steering or queueing a hidden prompt.
  Future<void> _deliverWidgetIntent(String prompt) async {
    if (!mounted ||
        chat.running ||
        _listening ||
        _preparing ||
        !chat.draftOwnerCurrent) {
      throw StateError('undelivered');
    }
    final accepted = await chat.send(prompt, hidden: true);
    if (!accepted) throw StateError('undelivered');
  }

  final _input = SlashCommandHighlightController();
  bool _showSessionFiles = false;
  final _promptRecall = ComposerPromptRecall();
  StatusBarLayout _status = StatusBarLayout.defaults();
  ContextReading? _breakdown;
  bool _breakdownLoading = false;
  late ComposerDraftWriter _draftWriter;
  String _lastText = '';
  bool _hydrating = false;
  Timer? _checkpoint;

  void _openDraft() {
    _draftWriter = chat.gateway.draftPresentation
        .chatFor(chat.draftKey)
        .openWriter(
          deviceLocal: chat.isNew,
          onBindingChanged: () => unawaited(_restoreDraft()),
        );
    unawaited(_restoreDraft());
  }

  /// Puts a `hermes://` link's prefill after whatever the composer holds or
  /// the draft store has (an unsent draft is never replaced). Reads the
  /// draft first so a restore that has not landed yet is not lost.
  Future<void> _applyLinkPrefill(String prefill) async {
    final writer = _draftWriter;
    String? draft;
    try {
      draft = await writer
          .read(requireProvenance: true)
          .timeout(const Duration(seconds: 5));
    } catch (_) {
      draft = null;
    }
    if (!mounted || !identical(writer, _draftWriter)) return;
    final current = _input.text;
    final base = current.trim().isNotEmpty ? current : (draft ?? '');
    final text = appendComposerPrefill(base, prefill);
    if (text == current) return;
    _input.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  Future<void> _restoreDraft() async {
    final writer = _draftWriter;
    final revision = writer.revision;
    final text = await writer.read(requireProvenance: true);
    if (!mounted ||
        !writer.isCurrent ||
        !chat.draftOwnerCurrent ||
        text == null ||
        revision != writer.revision ||
        _input.text.isNotEmpty ||
        text.isEmpty) {
      return;
    }
    _hydrating = true;
    try {
      _input.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } finally {
      _hydrating = false;
    }
  }

  void _onDraftEdit() {
    _promptRecall.editorChanged();
    final paste = _pendingPaste;
    _pendingPaste = null;
    if (paste != null && !_hydrating && _input.text.contains(paste.text)) {
      // The pasted text is committed now; intake may replace it safely.
      unawaited(_consumePaste(paste));
    }
    final text = _input.text;
    if (text == _lastText) return;
    _lastText = text;
    if (_hydrating || !chat.draftOwnerCurrent) return;
    _draftWriter.edit(text);
    _checkpoint?.cancel();
    _checkpoint = Timer(
      const Duration(milliseconds: 300),
      () => unawaited(_draftWriter.flush()),
    );
  }

  bool _openGit = false;
  String? _gitFocus;

  /// The composer's command catalogue: it decides both the highlight and
  /// whether a sent `/command` runs on the gateway.
  final _slashCatalog = NgSlashCatalog();

  /// Whether the `/` suggestions box is showing (it keeps the command info
  /// card away).
  bool _suggestionsOpen = false;
  final _focus = FocusNode();
  final _reader = GlobalKey<TranscriptReaderState>();
  final _scroll = ScrollController();
  Timer? _ticker;

  /// Files picked for the next message.
  final List<AttachmentDraft> _drafts = [];
  final _preview = PreviewSlot();
  int _imageDraftRevision = 0;
  Object? _imageRestoreRevision() =>
      mounted &&
          !_preparing &&
          !_listening &&
          !chat.running &&
          _drafts.isEmpty &&
          _input.text.isEmpty &&
          chat.imageTarget != null
      ? (
          chat,
          chat.imageTarget!.key,
          _imageDraftRevision,
          _draftWriter.revision,
        )
      : null;
  bool _preparing = false;
  final _imagePicker = ImagePicker();

  VoiceComposerAdapter? _voice;
  bool _listening = false;
  String _beforeDictation = '';

  VoiceLiveEngine? _liveEngine;
  VoiceLiveModeController? _boundVoiceMode;
  Timer? _liveReplyTimer;
  String? _liveDelegationId;
  int _livePriorItemCount = 0;
  bool _liveTurnObserved = false;
  DateTime? _liveSubmittedAt;

  /// Counts live-voice teardowns, so a start that was cancelled by one is
  /// told apart from a start the host refused.
  int _liveTeardowns = 0;

  /// One read-aloud engine for this transcript: the reading reply's action
  /// row shows Stop, and starting another reply stops the current one.
  late final NgReadAloud _readAloud;

  NgChatController get chat => widget.chat;

  // The gateway's voice controllers, read once per gateway. A view can
  // outlive its gateway by a frame (a connection switch disposes it first):
  // it keeps the controllers it bound, which are inert once disposed, and
  // never builds a fresh one on the disposed gateway.
  NextGenGateway? _voiceGateway;
  GatewayWakeWordController? _gatewayWake;
  VoiceLiveModeController? _gatewayVoiceMode;

  NextGenGateway _currentVoiceGateway() {
    final gateway = chat.gateway;
    if (!identical(gateway, _voiceGateway)) {
      _voiceGateway = gateway;
      _gatewayWake = null;
      _gatewayVoiceMode = null;
    }
    return gateway;
  }

  GatewayWakeWordController get _wake {
    if (widget.wakeController case final controller?) return controller;
    final gateway = _currentVoiceGateway();
    return _gatewayWake ??= gateway.wakeWord;
  }

  VoiceLiveModeController get _voiceMode {
    if (widget.voiceModeController case final controller?) return controller;
    final gateway = _currentVoiceGateway();
    return _gatewayVoiceMode ??= gateway.voiceLiveMode;
  }

  void _bindWake() {
    _wake.bindSessionId(chat.storedId ?? chat.runtimeId);
    _wake.onWakeDetected = _onWakeDetected;
    _syncWakeVoicePause();
  }

  void _syncWakeVoicePause() {
    // A stopped session keeps the capture device until the vendor answers
    // its goodbye (or the 15 s fallback): wake resumes only once it is free.
    _wake.setPausedForVoice(
      _listening ||
          _readAloud.readingKey != null ||
          (_liveEngine?.active ?? false) ||
          (_liveEngine?.holdsMicrophone ?? false),
    );
  }

  /// As Desktop's `wake.detected` handling (app/contrib/wiring.tsx): a phrase
  /// enrolled by another profile is answered in THAT profile's chat, and a
  /// fresh session is a new view. Either way the voice starts on the new
  /// view once it is showing, never in the chat that merely heard it.
  void _onWakeDetected(WakeDetectedEvent event) {
    if (!mounted) return;
    final gateway = chat.gateway;
    final target = event.profile;
    if (target != null &&
        wakeProfileKey(target) != wakeProfileKey(gateway.profile)) {
      _routeWakeToProfile(target, freshSession: event.startNewSession);
      return;
    }
    if (event.startNewSession && !chat.isNew && widget.onNewChat != null) {
      WakeVoiceRequest.request(
        connectionId: gateway.connection.id,
        profile: gateway.profile,
        freshSession: true,
      );
      widget.onNewChat!();
      // The fresh chat is another view; it takes the request once it shows.
      // Should the shell keep this view instead, nothing starts here and
      // wake goes back to listening.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncWakeVoicePause();
      });
      return;
    }
    _startWakeVoice();
  }

  /// Hands a wake phrase of another profile to the saved gateway that
  /// reaches it on the same machine. With none saved, nothing starts.
  void _routeWakeToProfile(String profile, {required bool freshSession}) {
    final scope = context.getInheritedWidgetOfExactType<NgScope>();
    final match = scope == null
        ? null
        : wakeConnectionForProfile(
            scope.connections,
            from: chat.gateway.connection,
            profile: profile,
          );
    if (scope == null ||
        match == null ||
        ConnectionMutationBarrier.isPending(match.id)) {
      ngToast(context, ngL.wake_word_other_profile(profile.trim()));
      // Nothing took the microphone: wake listens again.
      _syncWakeVoicePause();
      return;
    }
    WakeVoiceRequest.request(
      connectionId: match.id,
      profile: match.gatewayProfile,
      freshSession: freshSession,
    );
    unawaited(
      scope.switchTo(match.id).catchError((Object _) {
        WakeVoiceRequest.clear();
      }),
    );
  }

  /// Takes a wake request routed to this view's owner: after a profile
  /// switch or a new chat, the view that now shows the chat starts voice.
  void _maybeTakeWakeVoice() {
    if (!mounted) return;
    final gateway = chat.gateway;
    final pending = WakeVoiceRequest.pendingFor(
      connectionId: gateway.connection.id,
      profile: gateway.profile,
    );
    if (pending == null) return;
    if (ModalRoute.isCurrentOf(context) == false) return;
    if (pending.freshSession && !chat.isNew) {
      // The gateway opened on an existing chat: ask for the fresh one; its
      // view takes the request.
      final openNew = widget.onNewChat;
      if (openNew != null) {
        openNew();
        return;
      }
    }
    if (!WakeVoiceRequest.take(
      connectionId: gateway.connection.id,
      profile: gateway.profile,
      isNewChat: chat.isNew || widget.onNewChat == null,
    )) {
      return;
    }
    _startWakeVoice();
  }

  void _startWakeVoice() {
    if (!mounted) return;
    if (_liveEngine?.active == true) return;
    // A view that has only just mounted does not know the host's voice mode
    // yet; the conversation start reads it first and then picks the engine.
    if (!_voiceMode.hasStatus || _voiceMode.effectiveMode == 'gpt-live') {
      unawaited(_startVoiceConversation());
      return;
    }
    if (!_listening) {
      unawaited(_toggleDictation());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    CompanionDraft.pending.addListener(_applyCompanionDraft);
    _openDraft();
    _input.addListener(_onDraftEdit);
    // Validated deep-link prefill: one-shot, never sent — it only populates
    // the composer, which the user still edits before anything is sent. It
    // goes after the chat's unsent draft, never over it.
    final initial = chat.consumeInitialText();
    if (initial != null) unawaited(_applyLinkPrefill(initial));
    final shared = widget.initialSharedPayload;
    if (shared != null && shared.files.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_receiveSharedFiles(shared));
      });
    }
    chat.addListener(_onChat);
    _wasRunning = chat.running;
    // Opening a chat never reads the reply already at its bottom; one that
    // completes while the chat is open (even a turn running now) is read.
    _autoReadTurnSeen = chat.running;
    _markBottomReplySpoken();
    unawaited(
      loadStatusLayout().then((layout) {
        if (!mounted) return;
        setState(() => _status = layout);
        if (layout.visible('context-usage')) unawaited(_loadBreakdown());
      }),
    );
    final gateway = chat.gateway;
    final scopeKey = '${gateway.connection.id}::${gateway.profile ?? ''}';
    _readAloud =
        (widget.readAloudFactory ??
        () {
          return NgReadAloud(
            directSpeakerFactory: (fallback) => ClientDirectVoiceReplySpeaker(
              store: VoiceClientRuntime.storeFor(
                gateway.connection,
                connectionId: gateway.connection.id,
                profile: gateway.profile,
              ),
              scopeKey: scopeKey,
              fallback: fallback,
            ),
          );
        })();
    _readAloud.addListener(_onReadAloud);
    _bindWake();
    _readAloud.onUnavailable = () {
      if (mounted) {
        ngToast(context, ngL.read_aloud_is_unavailable_on_this_device);
      }
    };
    _input.addListener(
      () => setState(() {
        _imageDraftRevision++;
      }),
    );
    _scroll.addListener(() {
      if (_scroll.hasClients &&
          _scroll.position.userScrollDirection != ScrollDirection.idle) {
        _autoPages = 0;
      }
      _maybeLoadOlder();
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (chat.running && mounted) setState(() {});
    });
    _bindLiveEngine();
    // A wake word routed here (a fresh chat, or this profile after a
    // switch) starts its voice once this view is showing.
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeTakeWakeVoice());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ModalRoute makes this depend on visibility. As Classic's _revokeVoice:
    // once another route covers the chat (a pushed page, a sheet, a dialog,
    // a menu), it may not keep a live microphone behind it.
    if (ModalRoute.isCurrentOf(context) == false) {
      _teardownLiveVoice('routeChanged');
    }
  }

  @override
  void didUpdateWidget(covariant NgChatView old) {
    super.didUpdateWidget(old);
    if (old.chat != chat) {
      _showSessionFiles = false;
      _preview.close();
      _imageDraftRevision++;
      final recovered = _drafts.where(PreparedImageStore.isRestored).toList();
      if (recovered.isNotEmpty) {
        _drafts.removeWhere(PreparedImageStore.isRestored);
        _input.clear();
        unawaited(old.chat.attachmentService.removeAll(recovered));
      }
      old.chat.removeListener(_onChat);
      _checkpoint?.cancel();
      unawaited(_draftWriter.close());
      _hydrating = true;
      _input.clear();
      _hydrating = false;
      _promptRecall.editorChanged();
      _openDraft();
      chat.addListener(_onChat);
      // A reply being read belongs to the chat we left.
      unawaited(_readAloud.stop());
      // Switching to a chat never reads the reply already at its bottom.
      _autoReadServed.clear();
      _autoReadTurnSeen = chat.running;
      _markBottomReplySpoken();
      _bindWake();
      _disposeLiveEngine();
      _bindLiveEngine();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _maybeTakeWakeVoice(),
      );
    } else {
      if (old.wakeController != widget.wakeController) {
        _bindWake();
      }
      if (old.voiceModeController != widget.voiceModeController ||
          old.voiceLiveEngineFactory != widget.voiceLiveEngineFactory) {
        _disposeLiveEngine();
        _bindLiveEngine();
      }
    }
  }

  void _bindLiveEngine() {
    _disposeLiveEngine();
    final mode = _voiceMode;
    _boundVoiceMode = mode;
    mode.addListener(_onLiveEngineChanged);
    if (widget.voiceModeController != null || chat.gateway.state.isConnected) {
      unawaited(mode.refresh());
    }
    final transport = mode.transport;
    final engine =
        widget.voiceLiveEngineFactory?.call(transport) ??
        VoiceLiveEngine(
          transport: transport,
          connectionId: chat.gateway.connection.id,
        );
    engine.onDelegation = _onLiveDelegation;
    engine.onError = (message) {
      if (!mounted) return;
      ngToast(context, message);
    };
    engine.onClosed = (reason) {
      if (!mounted) return;
      // The session ended under us (connection lost, closed by the service):
      // drop the turn it was feeding and say why.
      _stopLiveReplyFeed();
      _syncWakeVoicePause();
      setState(() {});
      final notice = voiceLiveEndedNotice(context, reason);
      if (notice != null) ngToast(context, notice);
    };
    engine.onStopWord = () {
      if (!mounted) return;
      _syncWakeVoicePause();
      setState(() {});
    };
    engine.addListener(_onLiveEngineChanged);
    _liveEngine = engine;
  }

  void _disposeLiveEngine() {
    _stopLiveReplyFeed();
    _boundVoiceMode?.removeListener(_onLiveEngineChanged);
    _boundVoiceMode = null;
    final engine = _liveEngine;
    _liveEngine = null;
    if (engine != null) {
      engine.removeListener(_onLiveEngineChanged);
      engine.dispose();
    }
  }

  void _startLiveReplyFeed() {
    _liveReplyTimer?.cancel();
    _liveReplyTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!mounted) return;
      _feedNextGenLiveReply();
    });
  }

  void _stopLiveReplyFeed() {
    _liveReplyTimer?.cancel();
    _liveReplyTimer = null;
    _liveDelegationId = null;
    _livePriorItemCount = 0;
    _liveTurnObserved = false;
    _liveSubmittedAt = null;
  }

  void _feedNextGenLiveReply() {
    final engine = _liveEngine;
    final delegationId = _liveDelegationId;
    if (engine == null || !engine.active || delegationId == null) return;

    final start = _livePriorItemCount.clamp(0, chat.items.length);
    final parts = <String>[];
    String? runningTool;
    for (var i = start; i < chat.items.length; i++) {
      final item = chat.items[i];
      if (item is! NgAssistantItem) continue;
      if (!item.isEmpty) {
        parts.add(item.text.trim());
        _autoReadServed.add(item.key);
      }
      if (chat.running) {
        for (final tool in item.tools.reversed) {
          if (tool.running && tool.name.trim().isNotEmpty) {
            runningTool = tool.name.trim();
            break;
          }
        }
      }
    }
    final turnReply = parts.where((p) => p.isNotEmpty).join('\n\n');

    if (chat.running) {
      _liveTurnObserved = true;
      if (runningTool != null) {
        engine.think(
          context.sharedL10n.release_chat_live_working(runningTool),
          delegationId: delegationId,
        );
      }
      if (turnReply.isNotEmpty) {
        engine.speak(turnReply, delegationId: delegationId);
      }
      return;
    }

    if (turnReply.isNotEmpty) {
      _liveTurnObserved = true;
      engine.speak(turnReply, delegationId: delegationId, flush: true);
      _stopLiveReplyFeed();
      engine.settle();
      return;
    }

    final submittedAt = _liveSubmittedAt;
    final graceExpired =
        submittedAt != null &&
        DateTime.now().difference(submittedAt) > const Duration(seconds: 15);
    if (_liveTurnObserved || graceExpired) {
      if (engine.spokenCursor == 0) {
        engine.think(
          context.sharedL10n.release_chat_live_finished_without_spoken_result,
          delegationId: delegationId,
        );
      }
      _stopLiveReplyFeed();
      engine.settle();
    }
  }

  /// Ends the live session at once, with no wait for the vendor: this chat is
  /// in the background, hidden or covered, so it may not keep a microphone.
  /// The engine stays bound; Start opens a new session when the chat is back.
  void _teardownLiveVoice(String reason) {
    _liveTeardowns++;
    _stopLiveReplyFeed();
    final engine = _liveEngine;
    if (engine == null || !engine.engaged) return;
    unawaited(engine.stopNow(reason));
  }

  void _onLiveEngineChanged() {
    if (!mounted) return;
    _syncWakeVoicePause();
    setState(() {});
  }

  List<Map<String, dynamic>> _seedLiveHistory() {
    final turns = <({String role, String text})>[];
    for (final item in chat.items) {
      if (item is NgUserItem && item.failure == null) {
        final text = (item.sentText ?? item.text).trim();
        if (text.isNotEmpty) turns.add((role: 'user', text: text));
      } else if (item is NgAssistantItem && !item.isEmpty) {
        final text = item.text.trim();
        if (text.isNotEmpty) turns.add((role: 'assistant', text: text));
      }
    }
    return toLiveHistory(turns);
  }

  Future<void> _startVoiceConversation() async {
    if (isParkedAutomotive) return;
    final mode = _voiceMode;
    // One status read per start: a read made here to choose the engine is
    // handed to it; with a cached status the engine reads a fresh one.
    GptLiveStatus? fresh;
    if (!mode.hasStatus) {
      fresh = await mode.refresh();
    }
    if (!mounted) return;
    if (mode.selectedMode == 'gpt-live') {
      // A background teardown nulls the engine; rebind on demand so the
      // start button still opens a live conversation after app resume.
      if (_liveEngine == null) _bindLiveEngine();
      final engine = _liveEngine;
      if (mode.liveAvailable && engine != null) {
        await _wake.pauseForVoice();
        if (!mounted) return;
        final teardowns = _liveTeardowns;
        final started = await engine.start(
          history: _seedLiveHistory(),
          status: fresh,
        );
        if (started && mounted) {
          _syncWakeVoicePause();
          setState(() {});
          return;
        }
        if (!mounted) return;
        // Cancelled by a teardown (background, hidden or covered chat), not
        // refused by the host: no fallback, and no other microphone path.
        if (teardowns != _liveTeardowns || !identical(engine, _liveEngine)) {
          _syncWakeVoicePause();
          return;
        }
      }
      final reason =
          mode.unavailableReason ??
          engine?.reason ??
          ngL.voice_engine_live_needs_key;
      ngToast(context, ngL.voice_engine_fallback_chained(reason));
    }
    if (!_listening) {
      await _toggleDictation();
    }
  }

  Future<void> _stopLiveVoice() async {
    _stopLiveReplyFeed();
    final engine = _liveEngine;
    if (engine == null) return;
    await engine.stop();
    if (!mounted) return;
    _syncWakeVoicePause();
    setState(() {});
  }

  void _toggleLiveMute() {
    final engine = _liveEngine;
    if (engine == null || !engine.active) return;
    engine.setMuted(!engine.muted);
  }

  void _interruptLiveVoice() {
    if (chat.running) {
      unawaited(chat.stop());
    }
    _liveEngine?.stopTurn();
  }

  void _onLiveDelegation(String id, Map<String, String> prompt) {
    final engine = _liveEngine;
    if (engine == null || !engine.active) return;
    final utterance = (prompt['prompt'] ?? '').trim();
    final voiceContext = (prompt['context'] ?? '').trim();
    if (utterance.isEmpty) return;
    if (isVoiceStopCommand(utterance)) {
      unawaited(_stopLiveVoice());
      return;
    }
    // Capture owner identity BEFORE any await so a late event for a switched,
    // closed or re-scoped chat never lands in another session.
    final ownerChat = chat;
    final ownerEngine = engine;
    final ownerEpoch = engine.startEpoch;
    final ownerConnectionId = ownerChat.gateway.connection.id;
    final ownerProfile = ownerChat.gateway.profile;
    final ownerAccountEpoch = ConnectionMutationBarrier.capture(
      ownerConnectionId,
    );

    bool stillOwned() =>
        mounted &&
        identical(chat, ownerChat) &&
        identical(_liveEngine, ownerEngine) &&
        ownerEngine.active &&
        ownerEngine.startEpoch == ownerEpoch &&
        ownerChat.gateway.connection.id == ownerConnectionId &&
        ownerChat.gateway.profile == ownerProfile &&
        ConnectionMutationBarrier.isCurrent(
          ownerConnectionId,
          ownerAccountEpoch,
        );

    unawaited(
      _submitNextGenLiveDelegation(
        delegationId: id,
        utterance: utterance,
        voiceContext: voiceContext,
        ownerChat: ownerChat,
        ownerEngine: ownerEngine,
        stillOwned: stillOwned,
      ),
    );
  }

  Future<void> _submitNextGenLiveDelegation({
    required String delegationId,
    required String utterance,
    required String voiceContext,
    required NgChatController ownerChat,
    required VoiceLiveEngine ownerEngine,
    required bool Function() stillOwned,
  }) async {
    if (!stillOwned()) return;
    final l10n = context.sharedL10n;
    if (ownerChat.running) {
      try {
        await ownerChat.stop(parkLocalQueue: false);
      } catch (_) {}
      for (var i = 0; i < 30 && stillOwned() && ownerChat.running; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    }
    if (!stillOwned()) return;
    _liveDelegationId = delegationId;
    _livePriorItemCount = ownerChat.items.length;
    _liveTurnObserved = false;
    _liveSubmittedAt = DateTime.now();
    _startLiveReplyFeed();
    var sent = false;
    try {
      sent = await ownerChat.send(
        utterance,
        promptParams: <String, Object>{
          'surface': 'voice-live',
          if (voiceContext.isNotEmpty) 'voice_context': voiceContext,
        },
      );
    } catch (_) {
      sent = false;
    }
    if (!sent && stillOwned() && _liveDelegationId == delegationId) {
      _stopLiveReplyFeed();
      ownerEngine.speak(
        l10n.release_chat_live_request_unreachable,
        delegationId: delegationId,
        flush: true,
      );
      ownerEngine.settle();
    } else if (stillOwned()) {
      _feedNextGenLiveReply();
    }
  }

  void _onReadAloud() {
    if (!mounted) return;
    // Classic settles dictation before reading a reply aloud; do not let
    // the mic keep listening to the engine's own playback.
    if (_readAloud.readingKey != null && _listening) {
      _listening = false;
      final voice = _voice;
      if (voice != null) unawaited(voice.stop());
    }
    _syncWakeVoicePause();
    setState(() {});
  }

  void _onChat() {
    if (!mounted) return;
    _wake.bindSessionId(chat.storedId ?? chat.runtimeId);
    // A link for this already-open chat (main page offers it here).
    final offered = chat.consumeInitialText();
    if (offered != null) unawaited(_applyLinkPrefill(offered));
    if (_companionLeftDuringTurn && !chat.running) {
      _companionLeftDuringTurn = false;
      _companionUnread = true;
    }
    // A retry or history reload can remove the reply being read; do not
    // keep speaking a row that no longer has a Stop affordance.
    final reading = _readAloud.readingKey;
    if (reading != null && !chat.items.any((item) => item.key == reading)) {
      unawaited(_readAloud.stop());
    }
    _feedNextGenLiveReply();
    _maybeAutoReadReply();
    // Each finished turn changes the context: read the breakdown again.
    final ended = _wasRunning && !chat.running;
    _wasRunning = chat.running;
    if (ended && _status.visible('context-usage')) {
      unawaited(_loadBreakdown());
    }
    setState(() {});
  }

  /// Replies auto-read has dealt with: read once, or already at the bottom
  /// when the chat was opened or switched to. Item keys restart in every
  /// chat controller, so a switch starts a fresh set.
  final Set<String> _autoReadServed = <String>{};

  /// A turn of this chat was seen running while it was open. Only the reply
  /// that ends such a turn is read: as Desktop (use-auto-speak-replies), a
  /// reply that was already there (opening the chat, switching to it, a
  /// history reload) is marked spoken, never read.
  bool _autoReadTurnSeen = false;

  /// Marks the reply now at the bottom as spoken, without reading it.
  void _markBottomReplySpoken() {
    final last = chat.items.isEmpty ? null : chat.items.last;
    if (last is NgAssistantItem) _autoReadServed.add(last.key);
  }

  /// Auto-reads the reply that completes a turn while this chat is open,
  /// once.
  void _maybeAutoReadReply() {
    if (chat.running) {
      _autoReadTurnSeen = true;
      return;
    }
    if (chat.items.isEmpty) return;
    final last = chat.items.last;
    if (last is! NgAssistantItem || last.isEmpty) return;
    final completedHere = _autoReadTurnSeen;
    _autoReadTurnSeen = false;
    if (!completedHere) {
      _autoReadServed.add(last.key);
      return;
    }
    if (_liveEngine?.active == true) return;
    if (!autoSpeakRepliesEnabled.value) return;
    if (_autoReadServed.contains(last.key)) return;
    _autoReadServed.add(last.key);
    final text = last.text.trim();
    if (text.isEmpty) return;
    unawaited(_readAloud.read(last.key, text));
  }

  bool _wasRunning = false;

  /// Applies and keeps the person's status bar choice.
  void _setStatus(StatusBarLayout layout) {
    setState(() => _status = layout);
    unawaited(saveStatusLayout(layout));
    if (layout.visible('context-usage')) unawaited(_loadBreakdown());
  }

  Future<void> _openStatusSheet() => showComposerStatusSheet(
    context: context,
    layout: _status,
    usage: _usageReading,
    breakdown: _breakdown,
    runningSinceMs: _runningSinceMs,
    sessionSinceMs: null,
    onLayout: _setStatus,
  );

  UsageReading get _usageReading => UsageReading(
    cacheHitPct: chat.usage?.cacheHitPct,
    avgTps: chat.usage?.avgTps,
    contextUsed: chat.usage?.contextUsed,
    contextMax: chat.usage?.contextMax,
    estimated: chat.usage?.contextEstimated ?? false,
    compressions: chat.usage?.compressions,
  );

  int? get _runningSinceMs => chat.running && chat.turnStartedAt != null
      ? chat.turnStartedAt!.millisecondsSinceEpoch
      : null;

  /// The transcript is reversed, so its top is the scroll's far end: fetch
  /// the page before when the reader gets near it.
  void _maybeLoadOlder({bool auto = false}) {
    if (!_scroll.hasClients || !chat.hasOlder || chat.loadingOlder) return;
    if (_scroll.position.extentAfter >= 800) return;
    if (auto) {
      // Pages of tool rows can add little to show: fetch a few on our own
      // to fill the screen, then wait for the reader to scroll.
      if (_autoPages >= 3) return;
      _autoPages++;
    }
    unawaited(chat.loadOlder());
  }

  /// Older pages fetched since the reader last scrolled.
  int _autoPages = 0;

  @override
  void dispose() {
    if (identical(_wake.onWakeDetected, _onWakeDetected)) {
      _wake.onWakeDetected = null;
    }
    _wake.setPausedForVoice(false);
    WidgetsBinding.instance.removeObserver(this);
    CompanionDraft.pending.removeListener(_applyCompanionDraft);
    chat.removeListener(_onChat);
    _checkpoint?.cancel();
    unawaited(_draftWriter.close());
    _readAloud.removeListener(_onReadAloud);
    _readAloud.dispose();
    _ticker?.cancel();
    _input.dispose();
    _slashCatalog.dispose();
    _focus.dispose();
    _scroll.dispose();
    _voice?.dispose();
    _disposeLiveEngine();
    // Unsent picks only live in the app cache.
    if (_drafts.isNotEmpty) {
      unawaited(chat.attachmentService.removeAll(List.of(_drafts)));
    }
    super.dispose();
  }

  void _applyCompanionDraft() {
    if (!mounted) return;
    CompanionDraft.applyTo(_input);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _wake.setAppForeground(state == AppLifecycleState.resumed);
    if (state != AppLifecycleState.resumed) {
      _checkpoint?.cancel();
      unawaited(_draftWriter.flush());
    }
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      // The live session is tied to the foreground screen: close the peer
      // and stop the tracks on a real background. `inactive` alone is not
      // one: the OS microphone prompt on first use puts the app there while
      // the session it is granting is still starting.
      _teardownLiveVoice('background');
      if (chat.running) _companionLeftDuringTurn = true;
    } else if (state == AppLifecycleState.resumed &&
        _companionLeftDuringTurn &&
        !chat.running &&
        mounted) {
      setState(() {
        _companionLeftDuringTurn = false;
        _companionUnread = true;
      });
    }
  }

  int get _slotsLeft => maxRemoteAttachmentDrafts - _drafts.length;

  Future<void> _receiveSharedFiles(AndroidSharePayload payload) async {
    final owner = chat;
    setState(() => _preparing = true);
    final errors = <String>[];
    try {
      for (final file in payload.files) {
        if (!mounted || !identical(owner, chat)) break;
        final error = await _queueDraft(
          owner: owner,
          () => file.isImage
              ? owner.attachmentService.prepareImage(
                  sourcePath: file.path,
                  displayName: file.name,
                  existingDrafts: List.of(_drafts),
                  mode: AttachmentDraftMode.remoteGateway,
                  maxTotalBytes: maxNextGenAttachmentDraftBytes,
                )
              : owner.attachmentService.prepareGenericFile(
                  sourcePath: file.path,
                  displayName: file.name,
                  mediaType: file.mediaType,
                  existingDrafts: List.of(_drafts),
                  maxFileBytes: maxNextGenAttachmentBytes,
                  maxTotalBytes: maxNextGenAttachmentDraftBytes,
                ),
        );
        if (error != null) errors.add(error);
      }
    } finally {
      if (mounted) setState(() => _preparing = false);
    }
    if (mounted && errors.isNotEmpty) ngToast(context, errors.join('\n'));
  }

  Future<void> _attach() async {
    // The chat this intake starts in owns its drafts (see [_queueDraft]).
    final owner = chat;
    final offerCapture = await screenCaptureOffered(widget.screenCapture);
    if (!mounted) return;
    _imageDraftRevision++;
    final c = NgColors.of(context);
    final choice = await showNgSheet<String>(
      context,
      // Scrolls: at large text on a small phone the rows outgrow the sheet.
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library_outlined, color: c.text2),
                title: Text(ngL.ng_photos),
                onTap: () => Navigator.pop(context, 'photos'),
              ),
              ListTile(
                leading: Icon(Icons.photo_camera_outlined, color: c.text2),
                title: Text(ngL.ng_camera),
                onTap: () => Navigator.pop(context, 'camera'),
              ),
              ListTile(
                leading: Icon(Icons.attach_file, color: c.text2),
                title: Text(ngL.ng_files),
                onTap: () => Navigator.pop(context, 'files'),
              ),
              if (offerCapture)
                ListTile(
                  key: const Key('ng-attach-capture-screen'),
                  leading: Icon(
                    Icons.screenshot_monitor_outlined,
                    color: c.text2,
                  ),
                  title: Text(ngL.capture_screen_action),
                  subtitle: Text(ngL.capture_screen_help),
                  onTap: () => Navigator.pop(context, 'screen'),
                ),
              ListTile(
                leading: Icon(Icons.notes_outlined, color: c.text2),
                title: Text(context.sharedL10n.composer_snippets),
                onTap: () => Navigator.pop(context, 'snippets'),
              ),
              ListTile(
                key: const ValueKey('ng-composer-status'),
                leading: Icon(Icons.tune, color: c.text2),
                title: Text(context.sharedL10n.composer_status),
                onTap: () => Navigator.pop(context, 'status'),
              ),
            ],
          ),
        ),
      ),
    );
    if (choice == null || !mounted) return;
    if (choice == 'snippets') {
      await showPromptSnippets(context: context, editor: _input);
      return;
    }
    if (choice == 'status') {
      await _openStatusSheet();
      return;
    }
    if (choice == 'screen') {
      await _captureScreen();
      return;
    }
    if (_slotsLeft <= 0) {
      ngToast(
        context,
        ngL.ng_you_can_attach_up_to_files(maxRemoteAttachmentDrafts),
      );
      return;
    }
    setState(() => _preparing = true);
    final errors = <String>[];
    try {
      switch (choice) {
        case 'photos' || 'camera':
          final images = choice == 'camera'
              ? [
                  ?await _imagePicker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 75,
                    maxWidth: 1600,
                    maxHeight: 1600,
                  ),
                ]
              : await _imagePicker.pickMultiImage(
                  imageQuality: 75,
                  maxWidth: 1600,
                  maxHeight: 1600,
                );
          for (final image in images) {
            final error = await _queueDraft(
              owner: owner,
              () => owner.attachmentService.prepareImage(
                sourcePath: image.path,
                displayName: image.name,
                existingDrafts: List.of(_drafts),
                mode: AttachmentDraftMode.remoteGateway,
                maxTotalBytes: maxNextGenAttachmentDraftBytes,
              ),
            );
            if (error != null) errors.add(error);
            if (_slotsLeft <= 0 || !mounted) break;
          }
        case 'files':
          final result = await FilePicker.platform.pickFiles(
            type: FileType.any,
            allowMultiple: true,
            withData: false,
          );
          for (final file in result?.files ?? const <PlatformFile>[]) {
            final path = file.path;
            if (path == null) {
              errors.add(ngL.ng_couldn_t_read(file.name));
              continue;
            }
            final error = await _queueDraft(
              owner: owner,
              () => owner.attachmentService.prepareGenericFile(
                sourcePath: path,
                displayName: file.name,
                mediaType:
                    attachmentMimeType((file.extension ?? '').toLowerCase()) ??
                    'application/octet-stream',
                existingDrafts: List.of(_drafts),
                // Kyllene's limit: files past the inline size stream to the
                // gateway's upload, which takes up to 100 MB each.
                maxFileBytes: maxNextGenAttachmentBytes,
                maxTotalBytes: maxNextGenAttachmentDraftBytes,
              ),
            );
            if (error != null) errors.add(error);
            if (_slotsLeft <= 0 || !mounted) break;
          }
      }
    } catch (e) {
      errors.add(ngL.ng_couldn_t_prepare_that_file(e));
    } finally {
      if (mounted) setState(() => _preparing = false);
    }
    if (errors.isNotEmpty && mounted) ngToast(context, errors.first);
  }

  /// Adds a screen capture as an image draft. Never sends.
  Future<void> _captureScreen() async {
    if (_slotsLeft <= 0) {
      ngToast(
        context,
        ngL.ng_you_can_attach_up_to_files(maxRemoteAttachmentDrafts),
      );
      return;
    }
    await captureScreenIntoDraft(
      context,
      controller: widget.screenCapture,
      attach: (png, name) async {
        if (!mounted) return;
        setState(() => _preparing = true);
        try {
          final draft = await chat.attachmentService.prepareImage(
            sourcePath: png.path,
            displayName: name,
            existingDrafts: _drafts,
            mode: AttachmentDraftMode.remoteGateway,
            maxTotalBytes: maxNextGenAttachmentDraftBytes,
          );
          if (mounted) setState(() => _drafts.add(draft));
        } on AttachmentDraftException catch (e) {
          if (mounted) ngToast(context, e.message);
        } finally {
          if (mounted) setState(() => _preparing = false);
        }
      },
    );
  }

  Future<void> _removeDraft(AttachmentDraft draft) async {
    setState(() => _drafts.remove(draft));
    await chat.attachmentService.removeCachedFile(draft);
  }

  /// Set while a sent `/command` waits to learn whether the gateway runs it,
  /// so a second tap cannot run it twice.
  bool _decidingCommand = false;

  Future<void> _send() async {
    if (_decidingCommand) return;
    final l10n = context.sharedL10n;
    final text = _input.text.trim();
    if (text.isEmpty && _drafts.isEmpty) {
      // Empty Enter delivers the client-held head. While idle it drains;
      // while a turn is running it is send-now (unpark, then interrupt).
      // Nothing queued does not stop the turn — Stop and Esc do that.
      if (!_listening &&
          chat.queued.isNotEmpty &&
          chat.draftOwnerCurrent &&
          _draftWriter.isCurrent) {
        if (chat.running) {
          await chat.sendQueuedNow(chat.queued.first);
        } else {
          chat.setLocalQueuePaused(false);
        }
      }
      return;
    }
    // A command runs at once, mid-turn too; with files it is a prompt.
    final command = _drafts.isEmpty ? NgSlashLine.parse(text) : null;
    if (command != null) {
      if (await _runCommand(command, text)) return;
      // Not a command the gateway runs: it goes out as a prompt, exactly as
      // before, provided the draft is still the one that was decided on.
      if (!mounted || _input.text.trim() != text) return;
    }
    // A message sent while a setup card waits closes the card with
    // {wrote_instead}; the backend ends the card's turn, so the message
    // waits for that turn to end and runs as the next one, never a steer
    // (Desktop's yieldParkedCardsToMessage).
    if (chat.yieldSetupBeatToMessage() &&
        chat.running &&
        _drafts.isEmpty &&
        text.isNotEmpty) {
      _input.clear();
      chat.enqueue(text);
      return;
    }
    if (_drafts.isNotEmpty && !chat.running) {
      // The whole draft against the limits, as Classic checks it before an
      // upload: a refused draft keeps its text and files.
      try {
        chat.attachmentService.validateRemoteDrafts(
          _drafts,
          maxFileBytes: maxNextGenAttachmentBytes,
          maxTotalBytes: maxNextGenAttachmentDraftBytes,
        );
      } on AttachmentDraftException catch (error) {
        ngToast(context, error.message);
        return;
      }
      final raw = _input.text;
      final drafts = List.of(_drafts);
      _input.clear();
      setState(_drafts.clear);
      // A refused prompt keeps its files on the message for Retry.
      await chat.send(text, attachments: drafts, composerImageText: raw);
      return;
    }
    if (text.isEmpty) return;
    if (chat.running) {
      final source = chat;
      final writer = _draftWriter, revision = writer.revision;
      final stored = source.storedId;
      final choice = await _busyChoice();
      if (!mounted ||
          choice == null ||
          source != chat ||
          writer != _draftWriter ||
          writer.revision != revision ||
          stored != source.storedId ||
          !source.draftOwnerCurrent) {
        return;
      }
      if (choice == 'queue' && source.gateway.sessionAuthority) {
        if (stored == null || _drafts.isNotEmpty) {
          ngToast(context, l10n.ng_release_chat_gateway_queue_requirements);
          return;
        }
        _openGatewayQueue(source, stored);
        return;
      }
      _input.clear();
      switch (choice) {
        case 'steer':
          await chat.steer(text);
        case 'queue':
          chat.enqueue(text);
        case 'stop':
          await chat.stopAndSend(text);
      }
      return;
    }
    _input.clear();
    await chat.send(text);
  }

  /// `/resume`, `/btw`, `/background` and `/handoff`, run the way Desktop
  /// runs them. False when [command] is none of these, or the gateway has
  /// no dedicated method (the ordinary command path then runs it).
  Future<bool> _runDedicated(NgSlashLine command, String text) async {
    final kind = dedicatedSlash(command.name);
    if (kind == null) return false;
    if (kind == DedicatedSlash.resume) {
      await _resume(command.arg.trim(), text);
      return true;
    }
    final owner = chat;
    _input.clear();
    final writer = _draftWriter, cleared = writer.revision;
    final result = await owner.runDedicated(command);
    if (!mounted || !identical(owner, widget.chat)) return true;
    if (result == null) {
      // No dedicated method on this gateway: the ordinary path runs it,
      // provided nobody typed meanwhile.
      if (writer == _draftWriter &&
          writer.revision == cleared &&
          _input.text.isEmpty) {
        _setComposer(text);
        return false;
      }
      return true;
    }
    final session = result.handoffSession;
    if (session != null) {
      unawaited(_watchHandoff(owner, result.card, session, command.arg.trim()));
    }
    return true;
  }

  /// Desktop's resume picker. Cancelling it gives back the typed command.
  Future<void> _resume(String query, String text) async {
    _input.clear();
    final writer = _draftWriter, cleared = writer.revision;
    final loadSessions = widget.loadSessions;
    final picked = await showResumePicker(
      context: context,
      initialQuery: query,
      listAvailable: widget.sessions != null || loadSessions != null,
      load: (_) async => [
        for (final row
            in loadSessions != null
                ? await loadSessions()
                : widget.sessions?.sessions ?? const <Session>[])
          ResumeCandidate(id: row.id, title: row.title, preview: row.preview),
      ],
    );
    if (!mounted) return;
    final open = widget.onResume;
    if (picked != null && open != null) {
      open(picked.id, picked.title);
      return;
    }
    if (picked != null) {
      chat.showCommandNotice(context.sharedL10n.composer_resume_unavailable);
    }
    // Cancelled (or nowhere to open it): the typed command comes back,
    // unless the user has typed something else since.
    if (writer == _draftWriter &&
        writer.revision == cleared &&
        _input.text.isEmpty) {
      _setComposer(text);
    }
  }

  Future<void> _watchHandoff(
    NgChatController owner,
    NgCommandItem card,
    String sessionId,
    String platform,
  ) async {
    final l10n = context.sharedL10n;
    final outcome = await watchHandoff(
      rpc: (method, params) => owner.gateway.call(method, params),
      sessionId: sessionId,
      timeoutMessage: l10n.composer_handoff_timeout,
      alive: () => mounted && identical(owner, widget.chat),
    );
    switch (outcome.phase) {
      case HandoffPhase.pending:
        return;
      case HandoffPhase.completed:
        owner.settleHandoff(card, l10n.composer_handoff_done(platform));
      case HandoffPhase.failed:
        owner.settleHandoff(
          card,
          outcome.error.isEmpty ? l10n.composer_handoff_failed : outcome.error,
          failed: true,
        );
      case HandoffPhase.timedOut:
        owner.settleHandoff(card, l10n.composer_handoff_timeout, failed: true);
    }
  }

  /// Compress from the failure card: on the live session (a stored chat
  /// attaches first). A failure is shown, never swallowed.
  Future<void> _compressChat() async {
    final owner = chat;
    final shared = context.sharedL10n;
    final id = await owner.liveSessionId();
    if (!mounted) return;
    if (id == null) {
      ngToast(context, shared.composer_command_needs_session);
      return;
    }
    try {
      await owner.gateway.call('session.compress', {
        'session_id': id,
      }, timeout: const Duration(minutes: 2));
      await owner.reloadTranscript();
    } catch (error) {
      if (!mounted) return;
      owner.showCommandNotice(
        ngL.ng_slash_command_failed(
          error is JsonRpcError ? error.message : error.toString(),
        ),
      );
      return;
    }
    if (!mounted) return;
    owner.showCommandNotice(shared.composer_compress_done);
    await _loadBreakdown();
  }

  Future<void> _switchToSuggested(ModelSuggestion suggestion) async {
    final provider = suggestion.provider ?? chat.provider;
    if (provider == null || provider.isEmpty) {
      await showNgModelSheet(context, chat);
      return;
    }
    final result = await chat.setModel(
      provider: provider,
      model: suggestion.model,
    );
    if (!mounted) return;
    if (result is NgModelSwitchNeedsConfirmation) {
      final again = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(result.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.sharedL10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.sharedL10n.composer_failure_switch_model),
            ),
          ],
        ),
      );
      if (again != true) return;
      final confirmed = await chat.setModel(
        provider: provider,
        model: suggestion.model,
        confirm: true,
      );
      if (!mounted) return;
      if (confirmed is NgModelSwitchFailed) {
        chat.showCommandNotice(confirmed.message);
        return;
      }
      if (confirmed is NgModelSwitchDone) await _retry();
    } else if (result is NgModelSwitchFailed) {
      chat.showCommandNotice(result.message);
    } else if (result is NgModelSwitchDone) {
      // Desktop's switchAndRetry: the failed turn runs again on the model.
      await _retry();
    }
  }

  void _editFailedPrompt() {
    final last = chat.items.whereType<NgUserItem>().lastOrNull;
    final text = last?.sentText ?? last?.text;
    if (text == null || text.trim().isEmpty) return;
    _setComposer(text);
  }

  Future<void> _loadBreakdown() async {
    if (!_status.visible('context-usage')) return;
    final id = await chat.liveSessionId();
    if (!mounted) return;
    if (id == null) {
      setState(() => _breakdown = ContextReading.empty);
      return;
    }
    setState(() => _breakdownLoading = true);
    try {
      final result = await chat.gateway.call('session.context_breakdown', {
        'session_id': id,
      });
      if (!mounted) return;
      setState(() {
        _breakdown = parseContextBreakdown(result);
        _breakdownLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _breakdown = ContextReading.empty;
        _breakdownLoading = false;
      });
    }
  }

  Future<void> _acceptDrop(ComposerDrag drag) async {
    final owner = chat;
    final plan = classifyDrag(drag);
    final path = plan.path ?? '';
    if (plan.kind == LocalIntake.reference) {
      appendWorkspaceReference(
        _input,
        gatewayContextReference(folder: plan.directory, path: path),
      );
      return;
    }
    if (!File(path).existsSync()) {
      ngToast(context, context.sharedL10n.composer_file_missing);
      return;
    }
    await _stageLocal(plan.kind, path, owner: owner);
  }

  /// The paste the editor's formatter saw, handled once the text is in the
  /// controller (see [_onDraftEdit]): a formatter must not edit the field.
  PastedChunk? _pendingPaste;

  Future<void> _consumePaste(PastedChunk chunk) async {
    final owner = chat;
    final path = clipboardPath(chunk.text);
    var exists = false;
    var directory = false;
    if (path != null) {
      final type = FileSystemEntity.typeSync(path);
      exists = type != FileSystemEntityType.notFound;
      directory = type == FileSystemEntityType.directory;
    }
    final plan = classifyPaste(
      chunk.text,
      pathExists: exists,
      directory: directory,
    );
    // A folder on this device is not a folder on the gateway: the pasted
    // path stays text rather than becoming a gateway @folder: reference.
    if (plan.kind == LocalIntake.leaveText ||
        plan.kind == LocalIntake.reference) {
      return;
    }
    if (plan.kind == LocalIntake.pastedText) {
      final error = await _queueDraft(
        owner: owner,
        () => owner.attachmentService.preparePastedText(
          text: chunk.text,
          existingDrafts: List.of(_drafts),
        ),
        onStaged: () => _removePasted(chunk),
      );
      if (error != null && mounted) ngToast(context, error);
      return;
    }
    final staged = plan.path;
    if (staged == null) return;
    // The path leaves the text only once its draft is staged: a refused
    // file (no slot, too large, unreadable) keeps what was pasted.
    await _stageLocal(
      plan.kind,
      staged,
      owner: owner,
      onStaged: () => _removePasted(chunk),
    );
  }

  /// Takes the paste out where it was pasted (its caret), never an earlier
  /// copy of the same text; edits since the paste stay.
  void _removePasted(PastedChunk chunk) {
    final next = chunk.removeFrom(_input.text);
    if (next != null) _input.value = next;
  }

  /// Stages one local file as an attachment draft: never sent until the
  /// person sends, within the draft count and size limits the Attach button
  /// uses. [onStaged] runs in the frame the draft appears.
  Future<bool> _stageLocal(
    LocalIntake kind,
    String path, {
    required NgChatController owner,
    VoidCallback? onStaged,
  }) async {
    final name = path.split(RegExp(r'[\\/]')).where((p) => p.isNotEmpty).last;
    final error = await _queueDraft(
      owner: owner,
      () => kind == LocalIntake.imageFile
          ? owner.attachmentService.prepareImage(
              sourcePath: path,
              displayName: name,
              existingDrafts: List.of(_drafts),
              mode: AttachmentDraftMode.remoteGateway,
              maxTotalBytes: maxNextGenAttachmentDraftBytes,
            )
          : owner.attachmentService.prepareGenericFile(
              sourcePath: path,
              displayName: name,
              mediaType:
                  attachmentMimeType(
                    name.contains('.')
                        ? name.split('.').last.toLowerCase()
                        : '',
                  ) ??
                  'application/octet-stream',
              existingDrafts: List.of(_drafts),
              maxFileBytes: maxNextGenAttachmentBytes,
              maxTotalBytes: maxNextGenAttachmentDraftBytes,
            ),
      onStaged: onStaged,
      unreadable: ngL.ng_couldn_t_read(path),
    );
    if (error == null) return true;
    if (mounted) ngToast(context, error);
    return false;
  }

  /// This composer's intake, one draft at a time (see
  /// [ComposerIntakeQueue]): drops, pastes, keyboard images, the Attach
  /// picker and files-panel drags all stage through it.
  final _intake = ComposerIntakeQueue();

  /// Prepares one draft in the intake queue: the free-slot check and the
  /// prepare see every draft staged before this one, so overlapping intake
  /// never passes [maxRemoteAttachmentDrafts] together. Returns null once
  /// the draft is staged ([onStaged] runs in the same frame), else why not.
  ///
  /// [owner] is the chat the intake started in. If this composer belongs to
  /// another chat by the time the job runs or its prepare finishes (a host
  /// that swaps the chat without remounting the view), the draft is dropped,
  /// never staged in the other chat.
  Future<String?> _queueDraft(
    Future<AttachmentDraft> Function() prepare, {
    required NgChatController owner,
    VoidCallback? onStaged,
    String? unreadable,
  }) => _intake.run(() async {
    if (!mounted || !identical(owner, chat)) return '';
    if (_slotsLeft <= 0) {
      return ngL.ng_you_can_attach_up_to_files(maxRemoteAttachmentDrafts);
    }
    final AttachmentDraft draft;
    try {
      draft = await prepare();
    } on AttachmentDraftException catch (error) {
      return error.message;
    } catch (error) {
      return unreadable ?? ngL.ng_couldn_t_prepare_that_file(error);
    }
    if (!mounted || !identical(owner, chat) || _slotsLeft <= 0) {
      await owner.attachmentService.removeAll([draft]);
      return mounted && identical(owner, chat)
          ? ngL.ng_you_can_attach_up_to_files(maxRemoteAttachmentDrafts)
          : '';
    }
    setState(() => _drafts.add(draft));
    onStaged?.call();
    return null;
  });

  /// Files dropped from the OS: each file becomes a draft; a folder cannot.
  Future<void> _acceptOsFiles(
    List<OsIntakeFile> files, {
    NgChatController? owner,
  }) async {
    final intakeOwner = owner ?? chat;
    for (final file in files) {
      if (!mounted || !identical(intakeOwner, chat)) return;
      if (file.directory) {
        ngToast(context, context.sharedL10n.composer_drop_folder_unsupported);
        continue;
      }
      final kind = looksLikeImagePath(file.path)
          ? LocalIntake.imageFile
          : LocalIntake.genericFile;
      final staged = await withDroppedFileAccess(
        file,
        () => _stageLocal(kind, file.path, owner: intakeOwner),
      );
      if (!staged && _slotsLeft <= 0) return;
    }
  }

  /// Cmd/Ctrl+V with files or an image on the clipboard.
  Future<void> _acceptClipboard(ClipboardAttachment found) async {
    final owner = chat;
    final image = found.image;
    if (image != null) {
      await _acceptImageBytes(image, 'image/png', owner: owner);
      return;
    }
    await _acceptOsFiles(await osIntakeFilesFor(found.files), owner: owner);
  }

  /// A pasted or keyboard-inserted image.
  Future<void> _acceptImageBytes(
    Uint8List bytes,
    String mimeType, {
    NgChatController? owner,
  }) async {
    final intakeOwner = owner ?? chat;
    final String path;
    try {
      path = await stageComposerImageBytes(bytes, mimeType: mimeType);
    } catch (_) {
      if (mounted) {
        ngToast(
          context,
          ngL.ng_couldn_t_prepare_that_file(ngL.ng_release_chat_image),
        );
      }
      return;
    }
    try {
      if (mounted) {
        await _stageLocal(LocalIntake.imageFile, path, owner: intakeOwner);
      }
    } finally {
      // The draft holds its own sanitised copy (or there is no draft).
      await discardStagedComposerImage(path);
    }
  }

  /// Runs a typed `/command`, the way Kyllene does: NextGen's own `/new`,
  /// `/reset`, `/stop` and bare `/model` here, anything the gateway would
  /// run there (see [NgSlashCatalog.runsOnGateway]). Returns false when
  /// [text] is ordinary text to send as a prompt.
  Future<bool> _runCommand(NgSlashLine command, String text) async {
    if (await _runDedicated(command, text)) return true;
    if (!mounted || _input.text.trim() != text) return true;
    switch (command.name) {
      case 'new' || 'reset':
        if (widget.onNewChat == null) {
          ngToast(context, ngL.ng_release_chat_start_new_main_screen);
          return true;
        }
        _input.clear();
        widget.onNewChat!();
        return true;
      case 'stop':
        _input.clear();
        if (chat.running) {
          await chat.stop();
        } else {
          ngToast(context, ngL.ng_slash_command_nothing_running);
        }
        return true;
      case 'model' when command.arg.isEmpty:
        _input.clear();
        await showNgModelSheet(context, chat);
        return true;
      case 'kanban' when command.arg.isEmpty:
        _input.clear();
        final gateway = chat.gateway;
        final conn = gateway.connection;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => KanbanBoardScreen(
              owner: gateway.workspace,
              route: gateway.workspace.route(),
              connection: conn,
            ),
          ),
        );
        return true;
      case 'bots' when command.arg.isEmpty:
        _input.clear();
        final gateway = chat.gateway;
        final conn = gateway.connection;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BotsScreen(
              owner: gateway.workspace,
              route: gateway.workspace.route(),
              connection: conn,
            ),
          ),
        );
        return true;
      case 'wake':
        final arg = command.arg.trim().toLowerCase();
        _input.clear();
        final sid = chat.storedId ?? chat.runtimeId;
        switch (arg) {
          case '' || 'toggle':
            final ok = await _wake.toggle(sessionId: sid);
            if (!ok && mounted && _wake.state.notice.isNotEmpty) {
              ngToast(context, _wake.state.notice);
            }
          case 'on' || 'start':
            final ok = await _wake.startExplicit(sessionId: sid);
            if (!ok && mounted && _wake.state.notice.isNotEmpty) {
              ngToast(context, _wake.state.notice);
            }
          case 'off' || 'stop':
            await _wake.stopExplicit();
          case 'status':
            final st = await _wake.refreshStatus();
            if (mounted) {
              final status = st.listening
                  ? ngL.ng_wake_status_listening(st.phrase)
                  : ngL.ng_wake_status_off(st.phrase);
              ngToast(
                context,
                st.notice.isNotEmpty
                    ? ngL.ng_rel_chat_wake_status_notice(status, st.notice)
                    : status,
              );
            }
          default:
            await showGatewayWakeSheet(
              context,
              controller: _wake,
              sessionId: sid,
            );
        }
        return true;
    }
    final owner = chat;
    _decidingCommand = true;
    final bool runs;
    try {
      _slashCatalog.scopeTo(owner.gateway, sessionId: owner.runtimeId);
      runs = await _slashCatalog.runsOnGateway(command.name);
    } finally {
      _decidingCommand = false;
    }
    if (!runs) return false;
    // Edited or switched while deciding: run nothing; the new draft stays.
    if (!mounted ||
        !identical(owner, widget.chat) ||
        _input.text.trim() != text) {
      return true;
    }
    _input.clear();
    final outcome = await owner.runCommand(command);
    if (!mounted || !identical(owner, widget.chat)) return true;
    final composerFree = _input.text.trim().isEmpty;
    switch (outcome.result) {
      case NgCommandResult.unsupported:
        // An older gateway without `slash.exec`: nothing ran, so the line is
        // sent as the prompt it always was.
        if (composerFree) {
          _setComposer(text);
          return false;
        }
        if (owner.running) {
          owner.enqueue(text);
        } else {
          await owner.send(text);
        }
      case NgCommandResult.prefill:
        final card = outcome.item;
        if (composerFree) {
          _setComposer(outcome.text);
          if (card != null) owner.settleCommand(card);
        } else if (card != null) {
          // Never write over newer typing: the text stays on the card.
          owner.settleCommand(card, text: outcome.text);
        }
      case _ when outcome.keepsDraft:
        // Nothing ran, or it may not have: never resend, keep the line.
        if (composerFree) _setComposer(text);
      case _:
        break;
    }
    return true;
  }

  void _setComposer(String text) {
    _input.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _openGatewayQueue(NgChatController source, String stored) {
    final writer = _draftWriter, revision = writer.revision;
    final text = _drafts.isEmpty ? _input.text : '';
    final owner = source.gateway.workspace;
    GatewayQueueScreen.open(
      context,
      owner,
      owner.route(storedSessionId: stored),
      draft: text,
      onAdmitted: (sent) {
        if (mounted &&
            chat == source &&
            writer == _draftWriter &&
            source.draftOwnerCurrent &&
            source.storedId == stored &&
            writer.revision == revision &&
            sent == text &&
            text.isNotEmpty &&
            _drafts.isEmpty) {
          _input.clear();
        }
      },
    );
  }

  Future<String?> _busyChoice() {
    final c = NgColors.of(context);
    return showNgSheet<String>(
      context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                ngL.ng_hermes_is_still_working,
                style: NgType.title.copyWith(color: c.text),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.alt_route),
              title: Text(ngL.ng_steer),
              subtitle: Text(ngL.ng_adds_this_to_the_running_turn),
              onTap: () => Navigator.pop(context, 'steer'),
            ),
            ListTile(
              leading: const Icon(Icons.queue),
              title: Text(ngL.ng_queue),
              subtitle: Text(ngL.ng_sends_it_when_the_turn_finishes),
              onTap: () => Navigator.pop(context, 'queue'),
            ),
            ListTile(
              leading: Icon(Icons.stop_circle_outlined, color: c.danger),
              title: Text(ngL.ng_stop_and_send),
              subtitle: Text(ngL.ng_stops_the_turn_then_sends_this),
              onTap: () => Navigator.pop(context, 'stop'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleDictation() async {
    if (isParkedAutomotive) return;
    if (_listening) {
      await _voice?.stop();
      setState(() => _listening = false);
      _syncWakeVoicePause();
      return;
    }
    await _wake.pauseForVoice();
    final voice = _voice ??= createVoiceComposerAdapter();
    final ok = await voice.initialize(
      onStatus: (status) {
        if ((status == 'done' || status == 'notListening') && mounted) {
          setState(() => _listening = false);
          _syncWakeVoicePause();
        }
      },
      onError: (message) {
        if (!mounted) return;
        setState(() => _listening = false);
        _syncWakeVoicePause();
        ngToast(context, ngL.ng_dictation_stopped(message));
      },
    );
    if (!ok) {
      _syncWakeVoicePause();
      if (mounted) ngToast(context, ngL.ng_speech_recognition_isn_t_available);
      return;
    }
    _beforeDictation = _input.text.trim();
    setState(() => _listening = true);
    _syncWakeVoicePause();
    await voice.listen(
      onResult: ({required transcript, required isFinal}) {
        final joined = [
          if (_beforeDictation.isNotEmpty) _beforeDictation,
          transcript,
        ].join(' ');
        _input.value = TextEditingValue(
          text: joined,
          selection: TextSelection.collapsed(offset: joined.length),
        );
        if (isFinal && mounted) {
          setState(() => _listening = false);
          _syncWakeVoicePause();
        }
      },
    );
  }

  String _subtitle(NgConnectionState state) {
    if (!state.isConnected) return state.label;
    if (chat.running) {
      final started = chat.turnStartedAt;
      final secs = started == null
          ? 0
          : DateTime.now().difference(started).inSeconds;
      final step = chat.status?.trim();
      return [
        ngL.ng_working,
        if (step != null && step.isNotEmpty) step,
        if (secs > 0) ngL.ng_release_elapsed_seconds(secs),
      ].join(' · ');
    }
    return chat.model ?? ngL.ng_ready;
  }

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final gateway = NgScope.of(context).gateway;
    // Render state (embed consent, revisions, video memory) is scoped per
    // connection and chat; presence reports only this chat's own socket.
    return RenderScope(
      connection: renderConnectionKey(chat.gateway.connection),
      chat: chat.storedId ?? 'draft:${identityHashCode(chat)}',
      child: ChatPresence(
        target: () {
          final socket = chat.gateway.socket;
          final runtime = chat.runtimeId;
          return socket != null &&
                  runtime != null &&
                  chat.gateway.storedIdFor(runtime) == chat.storedId
              ? (socket, runtime)
              : null;
        },
        // As the controller names it for the completion cue.
        cueKey: () {
          final id = chat.storedId ?? chat.runtimeId;
          return id == null ? null : '${chat.gateway.connection.id}|$id';
        },
        // A wide chat opens the Kanban board beside itself (the dock's rows).
        child: KanbanPaneHost(child: _buildScoped(c, gateway)),
      ),
    );
  }

  Widget _buildScoped(NgColors c, NextGenGateway gateway) {
    return _preview.layout(
      chat: _buildChat(c, gateway),
      storedId: chat.storedId,
      service: chat.attachmentService,
      existing: _drafts,
      update: setState,
      commit: (text, crops) {
        if (_preparing || chat.running) {
          throw AttachmentDraftException(
            context.sharedL10n.release_chat_wait_for_composer,
          );
        }
        // A drop or paste may have staged drafts while the crops prepared.
        chat.attachmentService.validateRemoteDrafts(
          [..._drafts, ...crops],
          maxFileBytes: maxNextGenAttachmentBytes,
          maxTotalBytes: maxNextGenAttachmentDraftBytes,
        );
        setState(() {
          _drafts.addAll(crops);
          appendPreviewText(_input, text);
        });
      },
    );
  }

  Widget _buildChat(NgColors c, NextGenGateway gateway) {
    final view = ListenableBuilder(
      // The radio switching on or off adds or drops its narrow-pane entry.
      listenable: Listenable.merge([
        gateway,
        presentationToolsListenable(context),
      ]),
      builder: (context, _) {
        final state = gateway.state;
        final fileChat = chat;
        final fileId = chat.storedId;
        final fileOwner = identical(fileChat.gateway, gateway)
            ? gateway.workspace
            : null;
        final parentId = chat.storedId;
        final workers = parentId == null || chat.runtimeId == null
            ? null
            : WorkspaceWorkersScreen.capture(
                chat.gateway.workspace,
                chat.gateway.connection.label,
                storedSessionId: parentId,
              );
        final showQueue = workers != null && gateway.sessionAuthority;
        // Measure the pane, not the window: phones and narrow parallel panes
        // get one tools menu so the app bar never overflows.
        return LayoutBuilder(
          builder: (context, box) {
            final compactTools = box.maxWidth < 480;
            final radio = compactTools ? compactRadioTool(context) : null;
            return Scaffold(
              backgroundColor: c.background,
              appBar: AppBar(
                backgroundColor: c.background,
                surfaceTintColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: widget.onClose != null
                    ? CloseButton(onPressed: widget.onClose)
                    : widget.onOpenSidebar == null
                    ? null
                    : ListenableBuilder(
                        listenable: widget.sessions == null
                            ? const _NoListenable()
                            : Listenable.merge([widget.sessions, gateway]),
                        builder: (context, _) {
                          final unread = widget.sessions?.unreadCount ?? 0;
                          final dot = switch (widget.sessions?.topAttention) {
                            NgChatAttention.waiting => c.warning,
                            NgChatAttention.finished => c.success,
                            _ => c.accent,
                          };
                          return IconButton(
                            key: const ValueKey('ng-sidebar-button'),
                            tooltip: unread > 0
                                ? ngL.ng_chats_unread(unread)
                                : ngL.ng_chats,
                            icon: Badge(
                              isLabelVisible: unread > 0,
                              smallSize: 8,
                              backgroundColor: dot,
                              child: const Icon(Icons.view_sidebar_outlined),
                            ),
                            onPressed: widget.onOpenSidebar,
                          );
                        },
                      ),
                titleSpacing: 0,
                title: GestureDetector(
                  onTap: chat.isNew ? null : _rename,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.title.isEmpty ? ngL.ng_new_chat : chat.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NgType.heading.copyWith(color: c.text),
                      ),
                      Text(
                        _subtitle(state),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NgType.caption.copyWith(
                          color: state.isConnected ? c.text3 : c.warning,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  PresentationChrome(
                    compact: compactTools,
                    activity: chat.running
                        ? PetActivity.working
                        : _companionUnread
                        ? PetActivity.completed
                        : PetActivity.idle,
                    unread: _companionUnread,
                    onCompose: () {
                      setState(() => _companionUnread = false);
                      _focus.requestFocus();
                    },
                  ),
                  if (chat.items.isNotEmpty)
                    IconButton(
                      tooltip:
                          context.sharedL10n.release_chat_find_in_transcript,
                      icon: const Icon(Icons.find_in_page_outlined),
                      onPressed: () => _reader.currentState?.open(),
                    ),
                  if (fileId != null && fileOwner != null && !_showSessionFiles)
                    IconButton(
                      tooltip: context
                          .sharedL10n
                          .release_core_session_files_view_session_files,
                      icon: const Icon(Icons.account_tree_outlined),
                      onPressed: () => setState(() => _showSessionFiles = true),
                    ),
                  if (!compactTools) ...[
                    GatewayWakeToolbarButton(
                      controller: _wake,
                      sessionId: chat.storedId ?? chat.runtimeId,
                      onNotice: (msg) => ngToast(context, msg),
                    ),
                    if (_voiceMode.hasStatus)
                      IconButton(
                        key: const ValueKey('voice-engine-toolbar'),
                        tooltip: ngL.voice_engine_title,
                        icon: const Icon(Icons.graphic_eq),
                        onPressed: () => unawaited(
                          showVoiceEngineSheet(
                            context,
                            controller: _voiceMode,
                            disabled: _liveEngine?.active == true,
                          ),
                        ),
                      ),
                    if (widget.onOpenCommandPalette != null)
                      IconButton(
                        key: const ValueKey('app-command-palette-button'),
                        tooltip: ngL.palette_open,
                        icon: const Icon(Icons.keyboard_command_key),
                        onPressed: widget.onOpenCommandPalette,
                      ),
                    if (chat.storedId case final id?)
                      IconButton(
                        tooltip: context
                            .sharedL10n
                            .release_chat_open_browser_preview,
                        icon: const Icon(Icons.web_asset),
                        onPressed: () => setState(
                          () => _preview.open(chat.gateway.workspace, id),
                        ),
                      ),
                    if (showQueue)
                      IconButton(
                        tooltip: context
                            .sharedL10n
                            .release_core_gateway_queue_screen_gateway_queue,
                        icon: const Icon(Icons.queue),
                        onPressed: () => _openGatewayQueue(chat, parentId!),
                      ),
                    if (workers != null)
                      IconButton(
                        tooltip: ngL.workspace_workers,
                        icon: const Icon(Icons.hub_outlined),
                        onPressed: () => workers.open(context),
                      ),
                    IconButton(
                      key: const ValueKey('session-history'),
                      tooltip: chat.storedId == null
                          ? ngL.ng_import_claude_or_codex
                          : ngL.ng_session_history,
                      // Its own icon: Session files next to it is the tree.
                      icon: const Icon(Icons.manage_history),
                      onPressed: () => _openHistory(chat.storedId),
                    ),
                  ] else
                    // Narrow panes (< 480 px) fold chat tools into one menu.
                    ListenableBuilder(
                      listenable: Listenable.merge([_wake, _voiceMode]),
                      builder: (context, _) => PopupMenuButton<String>(
                        key: const ValueKey('chat-tools-menu'),
                        tooltip: context.sharedL10n.release_chat_more_tools,
                        icon: const Icon(Icons.widgets_outlined),
                        onSelected: (tool) async {
                          if (tool == 'app-command-palette') {
                            widget.onOpenCommandPalette?.call();
                            return;
                          }
                          if (tool == voiceEngineToolValue) {
                            await showVoiceEngineSheet(
                              context,
                              controller: _voiceMode,
                              disabled: _liveEngine?.active == true,
                            );
                            return;
                          }
                          if (tool == wakeWordToolValue) {
                            final sid = chat.storedId ?? chat.runtimeId;
                            final wasOn =
                                _wake.state.listening ||
                                (_wake.state.enabled && _wake.state.paused);
                            final ok = await _wake.toggle(sessionId: sid);
                            if (!ok &&
                                !wasOn &&
                                context.mounted &&
                                _wake.state.notice.isNotEmpty) {
                              ngToast(context, _wake.state.notice);
                            }
                            return;
                          }
                          if (tool == radioToolValue) {
                            final current = compactRadioTool(context);
                            if (current != null) {
                              unawaited(showAresRadioSheet(context, current));
                            }
                            return;
                          }
                          final id = chat.storedId;
                          if (tool == 'browser' && id != null) {
                            setState(
                              () => _preview.open(chat.gateway.workspace, id),
                            );
                          }
                          if (tool == 'queue' && showQueue) {
                            _openGatewayQueue(chat, parentId!);
                          }
                          if (tool == 'workers') workers?.open(context);
                          if (tool == 'history') _openHistory(id);
                        },
                        itemBuilder: (_) => [
                          if (widget.onOpenCommandPalette != null)
                            PopupMenuItem(
                              value: 'app-command-palette',
                              child: ListTile(
                                leading: const Icon(Icons.keyboard_command_key),
                                title: Text(ngL.palette_open),
                              ),
                            ),
                          if (_wake.state.offered)
                            wakeWordToolItem(context, _wake.state),
                          if (_voiceMode.hasStatus)
                            voiceEngineToolItem(context, _voiceMode),
                          if (chat.storedId != null)
                            PopupMenuItem(
                              value: 'browser',
                              child: ListTile(
                                leading: const Icon(Icons.web_asset),
                                title: Text(
                                  context
                                      .sharedL10n
                                      .release_chat_open_browser_preview,
                                ),
                              ),
                            ),
                          if (showQueue)
                            PopupMenuItem(
                              value: 'queue',
                              child: ListTile(
                                leading: const Icon(Icons.queue),
                                title: Text(
                                  context
                                      .sharedL10n
                                      .release_core_gateway_queue_screen_gateway_queue,
                                ),
                              ),
                            ),
                          if (workers != null)
                            PopupMenuItem(
                              value: 'workers',
                              child: ListTile(
                                leading: const Icon(Icons.hub_outlined),
                                title: Text(ngL.workspace_workers),
                              ),
                            ),
                          PopupMenuItem(
                            value: 'history',
                            child: ListTile(
                              leading: const Icon(Icons.manage_history),
                              title: Text(
                                chat.storedId == null
                                    ? ngL.ng_import_claude_or_codex
                                    : ngL.ng_session_history,
                              ),
                            ),
                          ),
                          if (radio != null) radioToolItem(context),
                        ],
                      ),
                    ),
                  if (chat.usage != null)
                    IconButton(
                      tooltip: ngL.ng_usage,
                      icon: const Icon(Icons.data_usage),
                      onPressed: _showUsage,
                    ),
                  if (widget.onNewChat != null)
                    IconButton(
                      tooltip: ngL.ng_new_chat,
                      icon: const Icon(Icons.edit_square),
                      onPressed: widget.onNewChat,
                    ),
                ],
              ),
              body: SessionFilesLayout(
                files: !_showSessionFiles || fileId == null || fileOwner == null
                    ? null
                    : SessionFilesView(
                        owner: fileOwner,
                        route: fileOwner.route(storedSessionId: fileId),
                        audioFilesClient: _filesClient,
                        startOnGit: _openGit,
                        focusGitFile: _gitFocus,
                        onGitClosed: () => setState(() => _openGit = false),
                        onHandOff: (text) {
                          final current = _input.text.trim();
                          _input.text = current.isEmpty
                              ? text
                              : '$current\n$text';
                          setState(() {
                            _openGit = false;
                            _showSessionFiles = false;
                          });
                        },
                        onClose: () =>
                            setState(() => _showSessionFiles = false),
                        onReference: (ref) {
                          if (chat != fileChat ||
                              chat.storedId != fileId ||
                              !identical(
                                NgScope.of(context).gateway,
                                gateway,
                              )) {
                            return;
                          }
                          appendWorkspaceReference(_input, ref);
                          setState(() => _showSessionFiles = false);
                        },
                      ),
                child: Column(
                  children: [
                    if (!state.isConnected) _connectionBanner(c, gateway),
                    // The body's real height under the connection banner:
                    // Scaffold has already taken the keyboard off it, so
                    // cards above the composer size from it.
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, body) => Column(
                          children: [
                            Expanded(child: _transcript(c)),
                            // Everything under the transcript shares one
                            // strip bounded by the body (which the keyboard
                            // has already shrunk): the cards keep their own
                            // caps and the composer takes what is left, so
                            // it is never pushed under the keyboard.
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: ngComposerStripMaxHeight(
                                  body.maxHeight,
                                ),
                              ),
                              child: _bottomStrip(
                                c,
                                state,
                                gateway,
                                body.maxHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    // Item keys restart in every chat controller, so reactions live with
    // this chat's controller and never in a map shared by all chats.
    return ReactionScope(chat: chat, child: transcriptShortcuts(_reader, view));
  }

  /// The dock, the cards and the composer below the transcript. The
  /// composer is flexible within the strip when the strip is bounded.
  Widget _bottomStrip(
    NgColors c,
    NgConnectionState state,
    NextGenGateway gateway,
    double available,
  ) {
    final bounded = available.isFinite;
    final composer = NgSlashCommandInfo(
      chat: chat,
      controller: _input,
      focusNode: _focus,
      catalog: _slashCatalog,
      // Commands run here now, so the card no longer says they are sent as
      // a message.
      showsSentAsMessageNote: false,
      suppressed: _suggestionsOpen,
      child: NgSlashSuggestions(
        // Keep 5.0 argument insertion semantics, with one completion owner.
        appendArgumentSpace: false,
        argumentDebounce: const Duration(milliseconds: 60),
        chat: chat,
        controller: _input,
        focusNode: _focus,
        catalog: _slashCatalog,
        onOpenChanged: (open) {
          if (mounted) setState(() => _suggestionsOpen = open);
        },
        child: _composer(c, state),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NgSessionDock(chat: chat, available: available),
        if (chat.canPickProject && _drafts.isEmpty && !_preparing)
          OrphanDraftRecovery(
            key: ObjectKey(_draftWriter),
            writer: _draftWriter,
            editor: _input,
            lookup: chat.gateway.api.getSession,
            isCurrent: () =>
                chat.draftOwnerCurrent &&
                identical(chat.gateway, gateway) &&
                chat.canPickProject &&
                _drafts.isEmpty &&
                !_preparing &&
                !_listening,
          ),
        if (chat.error != null) _errorBar(c),
        if (chat.queued.isNotEmpty) _queue(c),
        GatewayWakeListeningBanner(
          controller: _wake,
          available: available,
          sessionId: chat.storedId ?? chat.runtimeId,
        ),
        // Barge-in keeps the microphone on while a reply is read: say so.
        if (_readAloud.bargeInListening)
          BargeInMicLiveIndicator(
            label: ngL.ng_barge_in_mic_live,
            maxHeight: ngAboveComposerMaxHeight(
              context,
              available: available,
              fraction: 0.15,
              withKeyboard: 0.1,
            ),
          ),
        if (chat.catalog case final operation?)
          CatalogInstallCard(
            key: ValueKey(operation.opId),
            operation: operation,
            respond: (answer) => chat.respondCatalog(operation, answer),
            retry: _retryCatalogRow,
            onDismiss: () => chat.dismissCatalog(operation.opId),
          ),
        // The composer stays below a setup card: a message
        // sent instead of an answer closes the card.
        if (chat.request?.setupBeat case final card?)
          SetupBeatCard(
            key: ValueKey(card.requestId),
            request: card,
            onAnswer: (result) async =>
                chat.sendSetupBeat(card.requestId, result),
          ),
        if (chat.request != null &&
            chat.request!.kind != NgRequestKind.setupBeat)
          _InputPanel(chat: chat, request: chat.request!, available: available)
        else if (bounded)
          Flexible(child: composer)
        else
          composer,
      ],
    );
  }

  Future<void> _rename() async {
    final title = await ngPromptText(
      context,
      title: ngL.ng_rename_chat,
      initial: chat.title,
    );
    if (!mounted || title == null || title.trim().isEmpty) return;
    try {
      await chat.rename(title);
    } catch (e) {
      if (mounted) ngToast(context, ngL.ng_couldn_t_rename(e));
    }
  }

  void _openHistory(String? storedId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SessionHistoryPage(
          owner: chat.gateway.workspace,
          storedSessionId: storedId,
          onRewound: (text) {
            if (!mounted) return;
            chat.resync();
            _input.text = text;
            _input.selection = TextSelection.collapsed(offset: text.length);
          },
          onRestored: () {
            if (mounted) chat.resync();
          },
          onOpenSession: widget.onOpenSessionId == null
              ? null
              : (sessionId, {title}) {
                  unawaited(widget.sessions?.refresh());
                  widget.onOpenSessionId!(sessionId, title: title);
                },
        ),
      ),
    );
  }

  void _showUsage() {
    final u = chat.usage!;
    final c = NgColors.of(context);
    Widget row(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(k, style: NgType.label.copyWith(color: c.text2)),
          ),
          Text(v, style: NgType.label.copyWith(color: c.text)),
        ],
      ),
    );
    showNgSheet<void>(
      context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ngL.ng_this_chat,
                style: NgType.title.copyWith(color: c.text),
              ),
              const SizedBox(height: 12),
              row(ngL.ng_input_tokens, ngCompactNumber(u.input)),
              row(ngL.ng_output_tokens, ngCompactNumber(u.output)),
              if (u.reasoning > 0)
                row(ngL.ng_reasoning_tokens, ngCompactNumber(u.reasoning)),
              if (u.cacheRead > 0)
                row(ngL.ng_cache_reads, ngCompactNumber(u.cacheRead)),
              if (u.calls > 0) row(ngL.ng_api_calls, '${u.calls}'),
              if (u.cost != null)
                row(
                  ngL.ng_cost,
                  ngL.ng_rel_chat_cost_amount(u.cost!.toStringAsFixed(4)),
                ),
              if (u.contextUsed != null &&
                  u.contextMax != null &&
                  u.contextMax! > 0) ...[
                row(
                  ngL.ng_context,
                  ngL.ng_rel_chat_context_ratio(
                    ngCompactNumber(u.contextUsed!),
                    ngCompactNumber(u.contextMax!),
                  ),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: (u.contextUsed! / u.contextMax!).clamp(0, 1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _connectionBanner(NgColors c, NextGenGateway gateway) {
    final state = gateway.state;
    final expired = state.phase == NgConnectionPhase.sessionExpired;
    final failed = state.phase == NgConnectionPhase.failed;
    return Container(
      width: double.infinity,
      color: (expired || failed ? c.dangerSoft : c.warningSoft),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              expired
                  ? ngL.ng_your_sign_in_expired
                  : state.reason == null
                  ? state.label
                  : ngL.ng_rel_chat_connection_reason(
                      state.label,
                      state.reason!,
                    ),
              style: NgType.bodySmall.copyWith(color: c.text),
            ),
          ),
          if (expired)
            TextButton(
              onPressed: NgScope.of(context).signInAgain,
              child: Text(ngL.ng_sign_in_2),
            )
          else
            TextButton(onPressed: gateway.retry, child: Text(ngL.ng_retry)),
        ],
      ),
    );
  }

  /// Retry, the way Desktop retries (see [NgChatController.retryLast]).
  /// When an accepted turn has no durable row to replace, nothing is sent:
  /// the prompt comes back to an empty composer so the person can send it
  /// deliberately, and newer typing is never replaced.
  Future<void> _retry() async {
    final owner = chat;
    final last = owner.items
        .whereType<NgUserItem>()
        .where((item) => !item.steered)
        .lastOrNull;
    final result = await owner.retryLast();
    if (!mounted || !identical(owner, widget.chat)) return;
    if (result != NgRetryResult.notFound) return;
    ngToast(context, context.sharedL10n.composer_retry_not_found);
    final text = last?.sentText ?? last?.text;
    if (text != null && _input.text.trim().isEmpty && _drafts.isEmpty) {
      _setComposer(text);
    }
  }

  /// The cut an edit or restore of [item] makes, or null (with a notice)
  /// when the saved transcript does not hold the turn yet.
  Future<NgRewindTarget?> _rewindTarget(
    NgChatController owner,
    NgUserItem item,
  ) async {
    final target = await owner.rewindTargetFor(item);
    if (!mounted || !identical(owner, widget.chat)) return null;
    if (target == null) {
      ngToast(context, context.sharedL10n.rewind_target_unsaved);
    }
    return target;
  }

  Future<void> _editTurn(NgUserItem item) async {
    final owner = chat;
    final edited = await showDialog<String>(
      context: context,
      builder: (_) => EditTurnDialog(initialText: item.text),
    );
    if (!mounted || edited == null) return;
    final text = edited.trim();
    if (text.isEmpty || text == item.text.trim()) return;
    final target = await _rewindTarget(owner, item);
    if (target == null || !mounted) return;
    if (target.laterTurns &&
        !await showRestoreTurnConfirm(
          context,
          body: context.sharedL10n.edit_turn_later_turns_body,
        )) {
      return;
    }
    if (!mounted || !identical(owner, widget.chat)) return;
    await owner.rewindUserTurn(item: item, text: text, target: target);
  }

  Future<void> _restoreTurn(NgUserItem item) async {
    final owner = chat;
    final target = await _rewindTarget(owner, item);
    if (target == null || !mounted) return;
    if (!await showRestoreTurnConfirm(context)) return;
    if (!mounted || !identical(owner, widget.chat)) return;
    await owner.rewindUserTurn(
      item: item,
      text: item.text.trim(),
      target: target,
    );
  }

  Widget _errorBar(NgColors c) {
    final message = chat.error ?? '';
    final surface = chat.turnFailure;
    final aligned =
        surface != null &&
            (surface.message == null || surface.message == message)
        ? surface
        : null;
    final now = DateTime.now().millisecondsSinceEpoch;
    return Padding(
      key: ValueKey(c.dangerSoft),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: FailureRecoveryCard(
        message: message,
        recovery: presentRecovery(aligned, nowMs: now),
        diagnosticsText: formatErrorDiagnostics(
          errorText: message,
          surface: aligned,
          model: chat.model,
          provider: chat.provider,
        ),
        showDiagnostics: showsDiagnostics(aligned),
        resetsAt: aligned?.resetsAt,
        onDismiss: () => setState(() {
          chat.error = null;
          chat.turnFailure = null;
        }),
        onRetry: () {
          setState(() {
            chat.error = null;
            chat.turnFailure = null;
          });
          unawaited(_retry());
        },
        onCompress: _compressChat,
        onChooseModel: () => showNgModelSheet(context, chat),
        onSwitchTo: _switchToSuggested,
        onNewSession: widget.onNewChat,
        onEdit: _editFailedPrompt,
      ),
    );
  }

  Future<void> _editLocal(NgQueued row) async {
    final source = chat;
    source.beginLocalEdit(row);
    var draft = row.text;
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            context
                .sharedL10n
                .release_core_client_held_queue_bar_edit_unsent_prompt,
          ),
          content: TextFormField(
            initialValue: draft,
            onChanged: (v) => draft = v,
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.sharedL10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, draft),
              child: Text(context.sharedL10n.save),
            ),
          ],
        ),
      );
      if (mounted && source == chat && result != null) {
        source.editLocalQueue(row, result);
      }
    } finally {
      source.endLocalEdit(row);
    }
  }

  NgQueued? _queuedByKey(String id) {
    for (final row in chat.queued) {
      if (row.key == id) return row;
    }
    return null;
  }

  Widget _queue(NgColors _) => ClientHeldQueueBar(
    count: chat.queued.length,
    parked: chat.localQueuePaused,
    rows: [
      for (final row in chat.queued)
        ClientHeldQueueRow(
          id: row.key,
          text: row.display ?? row.text,
          canEdit: row.display == null,
        ),
    ],
    onResume: () => chat.setLocalQueuePaused(false),
    onSend: (id) {
      final row = _queuedByKey(id);
      if (row != null) unawaited(chat.sendQueuedNow(row));
    },
    onRemove: (id) {
      final row = _queuedByKey(id);
      if (row != null) chat.unqueue(row);
    },
    onEdit: (id) {
      final row = _queuedByKey(id);
      if (row != null) unawaited(_editLocal(row));
    },
  );

  Widget _transcript(NgColors c) {
    if (chat.loadingHistory && chat.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (chat.items.isEmpty) {
      final brand = chat.isNew && chat.historyError == null;
      return NgGlow(
        child: LayoutBuilder(
          builder: (context, box) {
            final header = brand
                ? ngNewChatBrand(
                    box.maxHeight,
                    textScale: MediaQuery.textScalerOf(context).scale(1),
                  )
                : null;
            return NgEmpty(
              header: header,
              icon: Icons.auto_awesome,
              title: chat.historyError ?? ngL.ng_what_should_we_work_on,
              titleWidget: chat.canPickProject && chat.historyError == null
                  ? NgProjectGreeting(chat: chat)
                  : null,
              body: chat.historyError == null
                  ? ngL.ng_ask_hermes_anything_it_can_run
                  : null,
            );
          },
        ),
      );
    }
    final items = chat.items;
    final lastUserIndex = items.lastIndexWhere((i) => i is NgUserItem);
    final lead = chat.running ? 1 : 0;
    final older = chat.hasOlder || chat.loadingOlder ? 1 : 0;
    // Stable keys let rows keep their state (open tool rows, thinking) and
    // their place when a reply grows or an earlier page arrives.
    final indexOf = <Object, int>{
      for (var i = 0; i < items.length; i++)
        ValueKey(items[i].key): items.length - 1 - i + lead,
    };
    if (older == 1 && chat.hasOlder && !chat.loadingOlder) {
      // A short first page may not fill the screen to scroll.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _maybeLoadOlder(auto: true);
      });
    }
    final scope = NgScope.of(context);
    return TranscriptReader(
      key: _reader,
      owner: chat,
      scroll: _scroll,
      reverse: true,
      storageKey: chat.storedId == null
          ? null
          : readingPositionKey(
              'nextgen',
              scope.connection.id,
              scope.gateway.profile,
              chat.storedId!,
            ),
      entries: () => [
        for (final (i, item) in items.indexed)
          if (item is NgUserItem ||
              item is NgAssistantItem ||
              item is NgNoticeItem)
            (
              id: item.key,
              index: items.length - 1 - i + lead,
              text: switch (item) {
                NgUserItem() => item.text,
                NgAssistantItem() => item.text,
                NgNoticeItem() => item.text,
                _ => '',
              },
              prompt: item is NgUserItem,
            ),
      ],
      child: ListView.builder(
        key: const ValueKey('ng-transcript'),
        controller: _scroll,
        reverse: true,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        itemCount: items.length + lead + older,
        findChildIndexCallback: (key) => indexOf[key],
        itemBuilder: (context, index) {
          if (chat.running && index == 0) return _statusLine(c);
          if (older == 1 && index == items.length + lead) {
            return const Padding(
              key: ValueKey('ng-loading-older'),
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          final i = items.length - 1 - (index - lead);
          final item = items[i];
          return KeyedSubtree(
            key: ValueKey(item.key),
            child: _row(c, item, i, lastUserIndex),
          );
        },
      ),
    );
  }

  bool _latestAssistant(List<NgItem> items, NgAssistantItem item) {
    final index = items.indexOf(item);
    if (index < 0) return false;
    final lastUser = items.lastIndexWhere((entry) => entry is NgUserItem);
    if (index < lastUser) return false;
    return !items.skip(index + 1).any((entry) => entry is NgAssistantItem);
  }

  Widget _row(NgColors c, NgItem item, int i, int lastUserIndex) {
    final items = chat.items;
    return switch (item) {
      NgUserItem() => _UserBubble(
        item: item,
        files: _filesClient,
        filesIdentity: (NgScope.of(context).gateway, chat.storedId),
        onRetry: i == lastUserIndex && !chat.running && !item.recoverInComposer
            ? () => unawaited(_retry())
            : null,
        onEdit: !item.pending && item.failure == null
            ? () => unawaited(_editTurn(item))
            : null,
        onRestore: !item.pending && item.failure == null
            ? () => unawaited(_restoreTurn(item))
            : null,
      ),
      NgAssistantItem() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AssistantBlock(
            item: item,
            files: _filesClient,
            filesIdentity: (NgScope.of(context).gateway, chat.storedId),
            last: i == items.length - 1,
            onRetry: i == items.length - 1 && !chat.running
                ? () => unawaited(_retry())
                : null,
            readAloud: _readAloud,
            readHtml: _readWidgetHtml,
            onIntent: _deliverWidgetIntent,
          ),
          if (!item.open &&
              _latestAssistant(items, item) &&
              chat.storedId != null &&
              identical(chat.gateway, NgScope.of(context).gateway))
            TurnChangedFilesCard(
              files: changedFilesFromToolParts([
                for (final tool in item.tools)
                  (
                    name: tool.name,
                    args: tool.input,
                    result: tool.output,
                    failed: tool.failed,
                    running: tool.running,
                  ),
              ]),
              onOpen: (file) => setState(() {
                _showSessionFiles = true;
                _openGit = true;
                _gitFocus = file.path;
              }),
            ),
        ],
      ),
      NgSystemItem() => _SystemCard(item: item),
      NgCommandItem() => _CommandCard(item: item),
      NgNoticeItem() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: transcriptBody(
          Text(
            item.time == null
                ? item.text
                : ngL.ng_rel_chat_notice_time(
                    item.text,
                    ngStamp(context, item.time!),
                  ),
            textAlign: TextAlign.center,
            style: NgType.caption.copyWith(
              color: item.error ? c.danger : c.text3,
            ),
          ),
        ),
      ),
    };
  }

  Widget _statusLine(NgColors c) {
    final frame = chat.thinkingFrame ?? chat.status;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 1.8, color: c.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              frame == null || frame.isEmpty
                  ? ngL.ng_working
                  : ngL.ng_working_2(frame),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: NgType.bodySmall.copyWith(color: c.text3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _composer(NgColors c, NgConnectionState state) {
    final hasText = _input.text.trim().isNotEmpty;
    final canSend = hasText || (_drafts.isNotEmpty && !chat.running);
    final modelLabel = [
      chat.model == null ? ngL.ng_default_model : _shortModel(chat.model!),
      if (chat.reasoningEffort != null && chat.reasoningEffort!.isNotEmpty)
        ngRouteEffortLabel(chat.reasoningEffort, chat.reasoningEffortWire),
    ].join(' · ');
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (chat.running && chat.draftOwnerCurrent) {
            unawaited(chat.stop());
          }
        },
      },
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
          child: Container(
            decoration: BoxDecoration(
              color: c.input,
              borderRadius: BorderRadius.circular(NgRadii.xl),
              border: Border.all(color: c.stroke),
            ),
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
            child: LayoutBuilder(
              builder: (context, box) => _composerColumn(
                box.maxHeight,
                extras: [
                  if (_imageRestoreRevision() != null)
                    PreparedImageRecovery(
                      target: chat.imageTarget!,
                      revision: () => _draftWriter.hasConfirmedEmptyDraft
                          ? _imageRestoreRevision()
                          : null,
                      install: (text, drafts) {
                        setState(() => _drafts.addAll(drafts));
                        _setComposer(text);
                      },
                    ),
                  if (_drafts.isNotEmpty || _preparing)
                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                        children: [
                          for (final d in _drafts)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InputChip(
                                avatar: Icon(
                                  d.kind == AttachmentDraftKind.image
                                      ? Icons.image_outlined
                                      : Icons.insert_drive_file_outlined,
                                  size: 16,
                                ),
                                label: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 160,
                                  ),
                                  child: Text(
                                    d.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                onDeleted: () => _removeDraft(d),
                              ),
                            ),
                          if (_preparing)
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  for (final draft in _drafts)
                    AttachmentDraftAudioPreview(
                      key: ValueKey(('audio', draft.id)),
                      draft: draft,
                      showName: true,
                      owner: chat,
                    ),
                  // Stacked above the editor: bounded by the keyboard-aware
                  // share and scrolling inside, so the editor stays above the
                  // keyboard. Status lives in the composer menu (no extra row
                  // until an item is on); a narrow pane folds the breakdown.
                  LayoutBuilder(
                    builder: (context, box) => ComposerContextStatus(
                      layout: _status,
                      usage: _usageReading,
                      breakdown: _breakdown,
                      breakdownLoading: _breakdownLoading,
                      runningSinceMs: _runningSinceMs,
                      showMenu: false,
                      compact: box.maxWidth < 480,
                      maxHeight: ngAboveComposerMaxHeight(
                        context,
                        fraction: 0.25,
                        withKeyboard: 0.15,
                      ),
                      onLayout: _setStatus,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: ngAboveComposerMaxHeight(
                        context,
                        fraction: 0.35,
                        withKeyboard: 0.2,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: ComposerReferenceAssist(
                        controller: _input,
                        cacheScope: (chat.gateway, chat.storedId),
                        completePath: (query) async {
                          final owner = chat;
                          final result = await owner.gateway.call(
                            'complete.path',
                            pathCompletionParams(
                              query: query,
                              sessionId: await owner.liveSessionId(),
                            ),
                          );
                          final rows = parseReferenceCompletions(result);
                          return rows.isEmpty
                              ? starterSuggestions(query)
                              : rows;
                        },
                      ),
                    ),
                  ),
                ],
                editor: SendOnEnter(
                  enabled:
                      _input.text.trim().isNotEmpty ||
                      (!_listening &&
                          _drafts.isEmpty &&
                          chat.queued.isNotEmpty),
                  onNavigate: (event) =>
                      !chat.draftOwnerCurrent ||
                          !_draftWriter.isCurrent ||
                          _drafts.isNotEmpty ||
                          _listening
                      ? KeyEventResult.ignored
                      : _promptRecall.handle(
                          event,
                          _input,
                          () => chat.items
                              .whereType<NgUserItem>()
                              .where(
                                (item) => !item.pending && item.failure == null,
                              )
                              .map((item) => item.text),
                        ),
                  onSend: () => unawaited(_send()),
                  child: OsFileDropTarget(
                    onFiles: (files) => unawaited(_acceptOsFiles(files)),
                    child: ClipboardAttachmentPaste(
                      owner: chat,
                      onAttachment: _acceptClipboard,
                      child: ComposerDropSurface(
                        onDrop: (drag) => unawaited(_acceptDrop(drag)),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: ngComposerEditorMaxHeight(box.maxHeight),
                          ),
                          child: ChatPresenceComposer(
                            builder: (_, input) => TextField(
                              key: const ValueKey('ng-composer-field'),
                              onChanged: (_) => input(),
                              controller: _input,
                              contextMenuBuilder:
                                  ClipboardAttachmentPaste.contextMenuBuilder,
                              focusNode: _focus,
                              contentInsertionConfiguration:
                                  composerImageInsertion(_acceptImageBytes),
                              inputFormatters: [
                                // Detects a paste only; it is handled after the
                                // text is committed ([_onDraftEdit]), never from
                                // here.
                                TextInputFormatter.withFunction((
                                  oldValue,
                                  newValue,
                                ) {
                                  final selection = oldValue.selection;
                                  if (!selection.isValid) return newValue;
                                  _pendingPaste = PastedChunk.detect(
                                    oldValue.text,
                                    selection.start,
                                    selection.end,
                                    newValue.text,
                                  );
                                  return newValue;
                                }),
                              ],
                              onTap: () {
                                // Android can hide the keyboard with Back while
                                // this node retains focus. Explicitly show it on
                                // every composer tap.
                                _focus.requestFocus();
                                unawaited(
                                  SystemChannels.textInput.invokeMethod<void>(
                                    'TextInput.show',
                                  ),
                                );
                              },
                              minLines: 1,
                              maxLines: 8,
                              textCapitalization: TextCapitalization.sentences,
                              style: NgType.body.copyWith(color: c.text),
                              decoration: InputDecoration(
                                hintText: _listening
                                    ? ngL.ng_listening
                                    : chat.running
                                    ? ngL.ng_steer_or_queue_a_message
                                    : ngL.ng_message_hermes,
                                // One line: at large text a wrapped hint made
                                // an empty composer two lines tall.
                                hintMaxLines: 1,
                                hintStyle: NgType.body.copyWith(
                                  color: c.textMuted,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.fromLTRB(
                                  12,
                                  12,
                                  12,
                                  6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                actions: Row(
                  children: [
                    IconButton(
                      tooltip: ngL.ng_attach,
                      icon: Icon(Icons.add_circle_outline, color: c.text2),
                      onPressed: _preparing ? null : _attach,
                    ),
                    // Expanded + Spacer split the free width evenly, so the
                    // pill keeps its half-width cap while the row is always
                    // filled and mic/send end flush right. A loose Flexible
                    // left its unused share after the send button instead,
                    // which on wide desktop windows put both buttons mid-row.
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: NgPill(
                          key: const ValueKey('ng-model-picker'),
                          modelLabel,
                          icon: Icons.auto_awesome,
                          onTap: () => showNgModelSheet(context, chat),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (_liveEngine case final live? when live.active) ...[
                      VoiceLiveInlineControls(
                        engine: live,
                        compact: MediaQuery.sizeOf(context).width < 480,
                        onToggleMute: _toggleLiveMute,
                        onInterrupt: _interruptLiveVoice,
                        onStop: () => unawaited(_stopLiveVoice()),
                      ),
                      if (hasText)
                        IconButton.filled(
                          tooltip: ngL.ng_send,
                          style: IconButton.styleFrom(
                            backgroundColor: c.accent,
                            foregroundColor: c.onAccent,
                            disabledBackgroundColor: c.surface3,
                          ),
                          icon: const Icon(Icons.arrow_upward_rounded),
                          onPressed: canSend ? _send : null,
                        ),
                    ] else ...[
                      if (!isParkedAutomotive)
                        IconButton(
                          tooltip: _listening
                              ? ngL.ng_stop_dictation
                              : ngL.ng_dictate,
                          icon: Icon(
                            _listening ? Icons.mic : Icons.mic_none,
                            color: _listening ? c.accent : c.text2,
                          ),
                          onPressed: _toggleDictation,
                        ),
                      if (!isParkedAutomotive &&
                          _voiceMode.hasStatus &&
                          !chat.running &&
                          !hasText &&
                          !_listening)
                        GestureDetector(
                          onLongPress: () => unawaited(
                            showVoiceEngineSheet(
                              context,
                              controller: _voiceMode,
                            ),
                          ),
                          child: IconButton(
                            key: const ValueKey('voice-live-start'),
                            tooltip: ngL.voice_live_start,
                            icon: Icon(
                              Icons.graphic_eq,
                              color: _voiceMode.effectiveMode == 'gpt-live'
                                  ? c.accent
                                  : c.text2,
                            ),
                            onPressed: () =>
                                unawaited(_startVoiceConversation()),
                          ),
                        ),
                      if (chat.running && !hasText)
                        IconButton.filled(
                          tooltip: ngL.ng_stop,
                          style: IconButton.styleFrom(
                            backgroundColor: c.inverse,
                            foregroundColor: c.onInverse,
                          ),
                          icon: const Icon(Icons.stop_rounded),
                          onPressed: chat.stop,
                        )
                      else
                        IconButton.filled(
                          tooltip: ngL.ng_send,
                          style: IconButton.styleFrom(
                            backgroundColor: c.accent,
                            foregroundColor: c.onAccent,
                            disabledBackgroundColor: c.surface3,
                          ),
                          icon: const Icon(Icons.arrow_upward_rounded),
                          onPressed: canSend ? _send : null,
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The composer's rows within [maxHeight], the space the strip under the
  /// transcript left it (the keyboard is already off it). The send row
  /// always shows; the editor (bounded by [ngComposerEditorMaxHeight] where
  /// it is built) scrolls inside; the rows above it (chips, status, completions) share
  /// what is left and scroll, the row nearest the editor in view first.
  Widget _composerColumn(
    double maxHeight, {
    required List<Widget> extras,
    required Widget editor,
    required Widget actions,
  }) {
    if (!maxHeight.isFinite) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [...extras, editor, actions],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (extras.isNotEmpty)
          Flexible(
            child: SingleChildScrollView(
              key: const ValueKey('ng-composer-extras'),
              reverse: true,
              child: Column(mainAxisSize: MainAxisSize.min, children: extras),
            ),
          ),
        editor,
        actions,
      ],
    );
  }

  static String _shortModel(String model) {
    final slash = model.lastIndexOf('/');
    return slash >= 0 ? model.substring(slash + 1) : model;
  }
}

/// A background result or runtime notice, collapsed to one line. Tap to
/// read the whole message; long-press copies it.
class _SystemCard extends StatefulWidget {
  const _SystemCard({required this.item});

  final NgSystemItem item;

  @override
  State<_SystemCard> createState() => _SystemCardState();
}

class _SystemCardState extends State<_SystemCard> {
  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final item = widget.item;
    final (icon, title) = switch (item.kind) {
      NgSystemKind.task => (Icons.task_alt, ngL.ng_background_task_finished),
      NgSystemKind.process => (
        Icons.terminal,
        ngL.ng_background_process_finished,
      ),
      NgSystemKind.note => (Icons.info_outline, ngL.ng_system_message),
      NgSystemKind.summary => (Icons.summarize_outlined, ngL.ng_summary),
    };
    final tint = item.hasIssues ? c.warning : c.text3;
    final preview = item.preview;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: c.surface2,
        borderRadius: BorderRadius.circular(NgRadii.md),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => setState(() => item.expanded = !item.expanded),
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: item.body));
            ngToast(context, ngL.ng_copied);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: tint),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NgType.label.copyWith(color: c.text2),
                      ),
                    ),
                    if (item.time != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          ngStamp(context, item.time!),
                          style: NgType.caption.copyWith(color: c.textMuted),
                        ),
                      ),
                    Icon(
                      item.expanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: c.text3,
                    ),
                  ],
                ),
                if (!item.expanded && preview.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 8),
                    child: Text(
                      preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: NgType.caption.copyWith(color: c.text3),
                    ),
                  ),
                ],
                if (item.expanded) ...[
                  const SizedBox(height: 8),
                  SelectableText(
                    ngCapShown(item.body),
                    style: NgType.caption.copyWith(
                      color: c.text2,
                      fontFamily: NgType.mono,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A `/command` run on the gateway: the command, then its output (or why it
/// failed). Open when it arrives; tap folds it, long-press copies the output.
class _CommandCard extends StatefulWidget {
  const _CommandCard({required this.item});

  final NgCommandItem item;

  @override
  State<_CommandCard> createState() => _CommandCardState();
}

class _CommandCardState extends State<_CommandCard> {
  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final item = widget.item;
    final output = item.output;
    final hasOutput = output.isNotEmpty;
    final tint = item.failed ? c.danger : c.text3;
    final bodyStyle = NgType.caption.copyWith(
      color: item.failed ? c.danger : c.text2,
      fontFamily: NgType.mono,
      height: 1.45,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Semantics(
        container: true,
        label: ngL.ng_slash_command_output,
        child: Material(
          key: const ValueKey('ng-command-card'),
          color: c.surface2,
          borderRadius: BorderRadius.circular(NgRadii.md),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: hasOutput
                ? () => setState(() => item.expanded = !item.expanded)
                : null,
            onLongPress: hasOutput
                ? () {
                    Clipboard.setData(ClipboardData(text: output));
                    ngToast(context, ngL.ng_copied);
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        item.failed ? Icons.error_outline : Icons.terminal,
                        size: 16,
                        color: tint,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.command,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: NgType.label.copyWith(
                            color: c.text2,
                            fontFamily: NgType.mono,
                          ),
                        ),
                      ),
                      if (item.running)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              color: c.accent,
                              semanticsLabel: ngL.ng_slash_command_running,
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            ngStamp(context, item.time),
                            style: NgType.caption.copyWith(color: c.textMuted),
                          ),
                        ),
                      if (hasOutput)
                        Icon(
                          item.expanded ? Icons.expand_less : Icons.expand_more,
                          size: 18,
                          color: c.text3,
                        ),
                    ],
                  ),
                  if (hasOutput && item.expanded) ...[
                    const SizedBox(height: 8),
                    SelectableText(ngCapShown(output), style: bodyStyle),
                  ] else if (hasOutput) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 8),
                      child: Text(
                        output,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: bodyStyle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({
    required this.item,
    required this.files,
    required this.filesIdentity,
    this.onRetry,
    this.onEdit,
    this.onRestore,
  });
  final NgUserItem item;
  final RemoteFilesDataSource Function() files;
  final Object filesIdentity;
  final VoidCallback? onRetry;
  final VoidCallback? onEdit;
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    return transcriptDirection(
      context,
      Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 4, left: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (item.steered)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, right: 4),
                child: Text(
                  ngL.ng_steered,
                  style: NgType.caption.copyWith(color: c.text3),
                ),
              ),
            if (item.text.isNotEmpty)
              GestureDetector(
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: item.text));
                  ngToast(context, ngL.ng_copied);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: userBubbleFill(context, c.userBubble),
                    borderRadius: BorderRadius.circular(NgRadii.lg),
                  ),
                  child: transcriptBody(
                    SelectableText(
                      ngCapShown(item.text),
                      style: chatTypeface(
                        context,
                        NgType.body.copyWith(
                          color: c.onUserBubble.withValues(
                            alpha: item.pending ? 0.6 : 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (item.attachments.isEmpty && item.files.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.end,
                  children: [
                    for (final f in item.files)
                      NgPill(f, icon: Icons.attach_file),
                  ],
                ),
              ),
            if (item.attachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.end,
                  children: [
                    for (final a in item.attachments)
                      NgPill(
                        a.uploadProgress == null
                            ? a.name
                            : ngL.ng_rel_chat_attachment_progress(
                                a.name,
                                ngL.ng_uploading_percent(
                                  (a.uploadProgress! * 100).round(),
                                ),
                              ),
                        icon: a.status == AttachmentDraftStatus.failed
                            ? Icons.error_outline
                            : a.kind == AttachmentDraftKind.image
                            ? Icons.image_outlined
                            : Icons.attach_file,
                        tone: a.status == AttachmentDraftStatus.failed
                            ? NgTone.danger
                            : NgTone.neutral,
                      ),
                  ],
                ),
              ),
            for (final ref in {
              for (final ref in audioPromptFileRefs(
                item.fileReferenceText ?? item.text,
              ))
                ref.path: ref,
              for (final attachment in item.attachments)
                for (final ref in audioPromptFileRefs(attachment.refText ?? ''))
                  ref.path: ref,
            }.values)
              MediaArtifactCard(
                key: ValueKey((filesIdentity, ref.path)),
                ref: ref,
                filesClient: files,
                sourceIdentity: filesIdentity,
              ),
            // One footer line: the history actions sit to the left of the
            // time, not stacked underneath it. A narrow screen or large text
            // wraps the line, and the time stays last.
            if (onEdit != null ||
                onRestore != null ||
                (item.time != null && !item.pending))
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: Wrap(
                  key: const ValueKey('ng-user-footer'),
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    if (onEdit != null)
                      TextButton(
                        key: const Key('ng-user-edit'),
                        onPressed: onEdit,
                        child: Text(ngL.ng_edit_and_resend),
                      ),
                    if (onRestore != null)
                      TextButton(
                        key: const Key('ng-user-restore'),
                        onPressed: onRestore,
                        child: Text(ngL.ng_restore_turn_confirm),
                      ),
                    if (item.time != null && !item.pending)
                      Text(
                        ngStamp(context, item.time!),
                        key: const ValueKey('ng-user-time'),
                        style: NgType.caption.copyWith(color: c.textMuted),
                      ),
                  ],
                ),
              ),
            MessageReaction(messageId: item.key),
            if (item.failure != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        ngL.ng_not_sent(item.failure ?? ''),
                        style: NgType.caption.copyWith(color: c.danger),
                      ),
                    ),
                    if (onRetry != null)
                      TextButton(onPressed: onRetry, child: Text(ngL.ng_retry)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Splits Markdown into (text, isCode) runs on fenced code blocks, keeping
/// each fence verbatim. An unclosed fence runs to the end, as Markdown does.
@visibleForTesting
List<(String, bool)> ngSplitCodeFences(String text) {
  final out = <(String, bool)>[];
  final buffer = StringBuffer();
  String? fence;
  void flush(bool code) {
    if (buffer.isEmpty) return;
    out.add((buffer.toString(), code));
    buffer.clear();
  }

  final lines = text.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final eol = i == lines.length - 1 ? '' : '\n';
    final marker = RegExp(r'^\s{0,3}(`{3,}|~{3,})').firstMatch(line)?.group(1);
    if (fence == null && marker != null) {
      flush(false);
      fence = marker;
      buffer.write('$line$eol');
    } else if (fence != null &&
        marker != null &&
        marker[0] == fence[0] &&
        marker.length >= fence.length &&
        line.trim() == marker) {
      buffer.write('$line$eol');
      flush(true);
      fence = null;
    } else {
      buffer.write('$line$eol');
    }
  }
  flush(fence != null);
  return out;
}

/// Extracts the selectable source and optional language from one run produced
/// by [ngSplitCodeFences]. Open fences are supported too, so a reply keeps its
/// copy control while Hermes is still streaming the code.
@visibleForTesting
({String code, String? language}) ngCodeFenceParts(String block) {
  final firstBreak = block.indexOf('\n');
  if (firstBreak < 0) return (code: '', language: null);
  final firstLine = block
      .substring(0, firstBreak)
      .replaceFirst(RegExp(r'\r$'), '');
  final opening = RegExp(r'^\s{0,3}(`{3,}|~{3,})(.*)$').firstMatch(firstLine);
  if (opening == null) return (code: block, language: null);
  final fence = opening.group(1)!;
  final info = opening.group(2)!.trim();
  final language = info.isEmpty ? null : info.split(RegExp(r'\s+')).first;
  final contentStart = firstBreak + 1;

  // A closing fence is the final non-empty line of a split code run. Keep the
  // line break before it in the copied source, matching Classic's renderer.
  var lastLineEnd = block.length;
  if (block.endsWith('\n')) lastLineEnd--;
  if (lastLineEnd > contentStart && block[lastLineEnd - 1] == '\r') {
    lastLineEnd--;
  }
  if (lastLineEnd >= contentStart) {
    final lastLineStart = block.lastIndexOf('\n', lastLineEnd - 1) + 1;
    final lastLine = block.substring(lastLineStart, lastLineEnd);
    final closing = RegExp(
      r'^\s{0,3}(`{3,}|~{3,})',
    ).firstMatch(lastLine)?.group(1);
    if (closing != null &&
        closing[0] == fence[0] &&
        closing.length >= fence.length &&
        lastLine.trim() == closing) {
      return (
        code: block.substring(contentStart, lastLineStart),
        language: language,
      );
    }
  }
  return (code: block.substring(contentStart), language: language);
}

/// Characters of a prompt or system body shown inline; long-press copy
/// still takes the whole text.
const ngShownChars = 20000;

String ngCapShown(String text) => text.length <= ngShownChars
    ? text
    : '${text.substring(0, ngShownChars)}\n…';

/// Splits long Markdown prose at paragraph breaks into chunks of roughly
/// [target] characters, so a long reply lays out and re-parses piecewise.
/// It only breaks before an unindented line, keeping list continuations
/// and indented code with their item. Short text stays whole.
@visibleForTesting
List<String> ngMarkdownChunks(String text, {int target = 1500}) {
  if (text.length <= target * 2) return [text];
  final out = <String>[];
  final parts = text.split('\n\n');
  final buffer = StringBuffer();
  for (final part in parts) {
    final breakable =
        buffer.length >= target &&
        part.isNotEmpty &&
        !part.startsWith(' ') &&
        !part.startsWith('\t');
    if (breakable) {
      out.add(buffer.toString());
      buffer.clear();
    }
    if (buffer.isNotEmpty) buffer.write('\n\n');
    buffer.write(part);
  }
  if (buffer.isNotEmpty) out.add(buffer.toString());
  return out;
}

class _AssistantBlock extends StatefulWidget {
  const _AssistantBlock({
    required this.item,
    required this.last,
    required this.files,
    required this.filesIdentity,
    required this.readAloud,
    this.readHtml,
    this.onIntent,
    this.onRetry,
  });
  final WidgetHtmlReader? readHtml;
  final Future<void> Function(String prompt)? onIntent;
  final NgAssistantItem item;

  /// Opens a files client for this chat, for `MEDIA:` deliveries.
  final RemoteFilesDataSource Function() files;
  final Object filesIdentity;
  final bool last;
  final VoidCallback? onRetry;

  /// Shared transcript playback: this reply's row shows Stop while it reads.
  final NgReadAloud readAloud;

  @override
  State<_AssistantBlock> createState() => _AssistantBlockState();
}

class _AssistantBlockState extends State<_AssistantBlock> {
  final _previewOwner = GlobalKey<InlineMediaPreviewOwner>();
  bool _showThinking = false;
  bool _showTools = false;

  /// Rendered content by source text. Returning the same widget lets Flutter
  /// skip it, so typing, the turn timer and streamed tokens re-parse only
  /// the block that changed instead of the whole transcript.
  final Map<String, Widget> _prose = {};
  int? _proseLook;

  /// The reply text with the agent's `MEDIA:/path` deliveries as file cards
  /// (download, open, share), like the classic chat. Mid-line refs and
  /// Markdown links to delivered files stay links that open the same card.
  List<Widget> _content(NgColors c, NgAssistantItem item) {
    final isFinal = !item.open;
    // Theme.of can hand back an equal but new ThemeData on each build, so
    // the cache keys on what the style sheet below reads.
    final theme = Theme.of(context);
    final reading = ReadingControls.maybeOf(context);
    final look = Object.hash(
      theme.brightness,
      theme.textTheme.bodyMedium,
      c.text,
      c.text3,
      c.accentText,
      c.well,
      c.stroke,
      c.strokeStrong,
      reading?.chatFont,
      reading?.terminalFont,
      reading?.embedMode,
      isFinal,
    );
    if (look != _proseLook) {
      _prose.clear();
      _proseLook = look;
    }
    final used = <String>{};
    Widget parse(String text) => MarkdownBody(
      data: text,
      // Plain text inside the reply's one SelectionArea so a drag can run
      // across paragraphs and code fences; a SelectableText here would be
      // its own island and confine the selection to a single block.
      selectable: false,
      // Remote images follow Inline Embeds, as in Classic: a link when Off,
      // a placeholder until Load or Always allow when Ask, the image (https
      // only, capped) when Always or allowed.
      sizedImageBuilder: (image) => externalEmbed(
        context,
        uri: '${image.uri}',
        alt: image.alt ?? image.title,
        blocked: Text(
          image.alt ?? image.title ?? '',
          style: NgType.body.copyWith(color: c.text3),
        ),
        linkColor: c.accentText,
      ),
      onTapLink: (_, href, _) {
        if (_openDelivered(href)) return;
        final uri = href == null ? null : Uri.tryParse(href);
        if (uri != null) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        p: chatTypeface(context, NgType.body.copyWith(color: c.text)),
        listBullet: NgType.body.copyWith(color: c.text),
        h1: NgType.title.copyWith(color: c.text),
        h2: NgType.heading.copyWith(color: c.text, fontSize: 18),
        h3: NgType.heading.copyWith(color: c.text),
        code: terminalTypeface(
          context,
          NgType.code.copyWith(color: c.text, backgroundColor: c.well),
        ),
        codeblockDecoration: BoxDecoration(
          color: c.well,
          borderRadius: BorderRadius.circular(NgRadii.md),
          border: Border.all(color: c.stroke),
        ),
        codeblockPadding: const EdgeInsets.all(12),
        blockquoteDecoration: BoxDecoration(
          border: Border(left: BorderSide(color: c.strokeStrong, width: 3)),
        ),
        a: NgType.body.copyWith(color: c.accentText),
        tableBorder: TableBorder.all(color: c.stroke),
      ),
    );
    Widget cached(String text) {
      used.add(text);
      return _prose.putIfAbsent(
        text,
        () => transcriptEmbeds(
          context,
          text,
          transcriptBody(parse(text)),
          complete: isFinal,
        ),
      );
    }

    Widget codeBlock(String text) {
      used.add(text);
      return _prose.putIfAbsent(text, () {
        final fence = ngCodeFenceParts(text);
        return MarkdownCodeBlock(
          code: fence.code,
          language: fence.language,
          selectable: false,
          // A labelled Copy button: one obvious tap on a phone, no need to
          // discover the icon or drag a selection across the fence (#288).
          showCopyLabel: true,
        );
      });
    }

    Widget prose(String text) {
      final chunks = ngMarkdownChunks(text);
      if (chunks.length == 1) return cached(text);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [for (final chunk in chunks) cached(chunk)],
      );
    }

    Widget card(MediaTagRef ref, Object slot) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: MediaArtifactCard(
        key: ValueKey((widget.filesIdentity, ref.path, slot)),
        ref: ref,
        filesClient: widget.files,
        sourceIdentity: widget.filesIdentity,
      ),
    );

    final text = item.text;
    final out = <Widget>[];
    final cardPaths = <String>{};
    final seen = <String, int>{};
    for (final (block, code) in ngSplitCodeFences(text)) {
      if (code) {
        final fence = ngCodeFenceParts(block);
        out.add(
          RichFence(
            language: fence.language,
            code: fence.code,
            corpus: text,
            fallback: codeBlock(block),
            readHtml: widget.readHtml,
            onIntent: widget.onIntent,
          ),
        );
        continue;
      }
      final segments = splitMediaTags(block, isFinal: isFinal);
      if (!segments.any((s) => s.isMedia)) {
        out.addAll(
          richProseWidgets(
            text: inlineMediaTagsAsLinks(block, isFinal: isFinal),
            markdown: (chunk) => prose(chunk),
            readHtml: widget.readHtml,
            onIntent: widget.onIntent,
          ),
        );
        continue;
      }
      for (final segment in segments) {
        final media = segment.media;
        if (media != null) {
          cardPaths.add(media.path);
          final n = seen.update(media.path, (v) => v + 1, ifAbsent: () => 0);
          out.add(card(media, n));
        } else if (segment.text.trim().isNotEmpty) {
          out.addAll(
            richProseWidgets(
              text: inlineMediaTagsAsLinks(segment.text, isFinal: isFinal),
              markdown: (chunk) => prose(chunk),
              readHtml: widget.readHtml,
              onIntent: widget.onIntent,
            ),
          );
        }
      }
    }
    // Markdown links to host files the agent delivered, once each.
    for (final ref in extractMarkdownFileRefs(text, isFinal: isFinal)) {
      if (cardPaths.add(ref.path)) out.add(card(ref, 'link'));
    }
    _prose.removeWhere((key, _) => !used.contains(key));
    return out;
  }

  /// A tapped link to a delivered file opens its card in a sheet.
  bool _openDelivered(String? href) {
    final path = href == null ? null : deliveredFilePathFromHref(href);
    if (path == null) return false;
    unawaited(
      openMediaFilePreview(
        context: context,
        filesClient: widget.files,
        ref: MediaTagRef(path: path),
        sourceIdentity: widget.filesIdentity,
        owner: _previewOwner.currentState,
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) => InlineMediaPreviewScope(
    key: _previewOwner,
    filesClient: widget.files,
    sourceIdentity: widget.filesIdentity,
    references: extractDeliveredFileRefs(
      widget.item.text,
      isFinal: !widget.item.open,
    ),
    builder: _build,
  );

  Widget _build(BuildContext context) {
    final c = NgColors.of(context);
    final item = widget.item;
    final tools = item.tools;
    final runningTool = tools.where((t) => t.running).lastOrNull;
    final reading = widget.readAloud.isReading(item.key);
    return transcriptDirection(
      context,
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.reasoning.trim().isNotEmpty)
              _Disclosure(
                icon: Icons.psychology_outlined,
                label: item.open && item.text.isEmpty
                    ? ngL.ng_thinking
                    : ngL.ng_thought,
                open: _showThinking,
                onTap: () => setState(() => _showThinking = !_showThinking),
                child: Text(
                  item.reasoning.trim(),
                  style: NgType.bodySmall.copyWith(color: c.text3),
                ),
              ),
            if (tools.isNotEmpty)
              _Disclosure(
                icon: Icons.build_outlined,
                label: runningTool != null
                    ? runningTool.detail == null
                          ? runningTool.name
                          : ngL.ng_rel_chat_tool_detail(
                              runningTool.name,
                              runningTool.detail!,
                            )
                    : tools.length == 1
                    ? ngL.ng_used(tools.first.name)
                    : ngL.ng_used_tools(tools.length),
                busy: runningTool != null,
                open: _showTools,
                onTap: () => setState(() => _showTools = !_showTools),
                child: Column(
                  children: [for (final t in tools) _ToolRow(tool: t)],
                ),
              ),
            if (item.text.isNotEmpty)
              // One SelectionArea spans the whole reply so a single drag can
              // select across paragraphs, lists and code fences — as much of
              // the response as the user wants, not just one block.
              SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: _content(c, item),
                ),
              ),
            if (!item.open && item.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _ActionIcon(
                      icon: Icons.copy_rounded,
                      tooltip: ngL.ng_copy,
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: item.text));
                        ngToast(context, ngL.ng_copied);
                      },
                    ),
                    if (!isParkedAutomotive)
                      _ActionIcon(
                        icon: reading
                            ? Icons.stop_circle_outlined
                            : Icons.volume_up_outlined,
                        tooltip: reading ? ngL.ng_stop : ngL.ng_read_aloud,
                        onTap: () {
                          if (reading) {
                            unawaited(widget.readAloud.stop());
                          } else {
                            unawaited(
                              widget.readAloud.read(item.key, item.text),
                            );
                          }
                        },
                      ),
                    _ActionIcon(
                      icon: Icons.flag_outlined,
                      tooltip: ngL.report_ai_output,
                      onTap: reportAresAiOutput,
                    ),
                    if (widget.onRetry != null)
                      _ActionIcon(
                        icon: Icons.refresh_rounded,
                        tooltip: ngL.ng_retry,
                        onTap: widget.onRetry!,
                      ),
                    if (item.outputTokens != null && item.outputTokens! > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          ngL.ng_models_token_count(
                            ngCompactNumber(item.outputTokens!),
                          ),
                          style: NgType.caption.copyWith(color: c.textMuted),
                        ),
                      ),
                    if (item.time != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          ngStamp(context, item.time!),
                          key: const ValueKey('ng-reply-time'),
                          style: NgType.caption.copyWith(color: c.textMuted),
                        ),
                      ),
                  ],
                ),
              ),
            MessageReaction(messageId: item.key),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      iconSize: 17,
      color: c.text3,
      icon: Icon(icon),
      onPressed: onTap,
    );
  }
}

class _Disclosure extends StatelessWidget {
  const _Disclosure({
    required this.icon,
    required this.label,
    required this.open,
    required this.onTap,
    required this.child,
    this.busy = false,
  });

  final IconData icon;
  final String label;
  final bool open;
  final bool busy;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(NgRadii.sm),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (busy)
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.6,
                        color: c.accent,
                      ),
                    )
                  else
                    Icon(icon, size: 16, color: c.text3),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: NgType.label.copyWith(color: c.text3),
                    ),
                  ),
                  Icon(
                    open ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: c.text3,
                  ),
                ],
              ),
            ),
          ),
          if (open)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(NgRadii.md),
                border: Border.all(color: c.stroke),
              ),
              child: child,
            ),
        ],
      ),
    );
  }
}

class _ToolRow extends StatefulWidget {
  const _ToolRow({required this.tool});
  final NgTool tool;

  @override
  State<_ToolRow> createState() => _ToolRowState();
}

class _ToolRowState extends State<_ToolRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final t = widget.tool;
    final detail = t.summary ?? t.detail;
    final hasBody =
        (t.input?.isNotEmpty ?? false) || (t.output?.isNotEmpty ?? false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: hasBody ? () => setState(() => _open = !_open) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(
                  t.running
                      ? Icons.more_horiz
                      : t.failed
                      ? Icons.error_outline
                      : Icons.check,
                  size: 15,
                  color: t.failed ? c.danger : c.text3,
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: Text(
                    t.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: NgType.label.copyWith(color: c.text2),
                  ),
                ),
                if (detail != null && detail.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: NgType.caption.copyWith(color: c.text3),
                    ),
                  ),
                ] else
                  const Spacer(),
                if (t.startedAt != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      ngStamp(context, t.startedAt!, seconds: true),
                      key: const ValueKey('ng-tool-time'),
                      style: NgType.caption.copyWith(color: c.textMuted),
                    ),
                  ),
                if (t.durationSeconds != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      ngL.ng_release_chat_tool_seconds(
                        t.durationSeconds!.toStringAsFixed(1),
                      ),
                      style: NgType.caption.copyWith(color: c.textMuted),
                    ),
                  )
                else if (t.startedAt != null &&
                    t.finishedAt != null &&
                    t.finishedAt!.isAfter(t.startedAt!))
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      ngL.ng_release_chat_tool_seconds(
                        (t.finishedAt!.difference(t.startedAt!).inMilliseconds /
                                1000)
                            .toStringAsFixed(1),
                      ),
                      style: NgType.caption.copyWith(color: c.textMuted),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_open) ...[
          if (t.input?.isNotEmpty ?? false) _codeBlock(c, t.input!),
          if (t.output?.isNotEmpty ?? false) _codeBlock(c, t.output!),
          if (t.name == 'vision_analyze' || t.name == 'image_generate')
            InspectedImageTile(source: t.input ?? '', output: t.output),
        ],
      ],
    );
  }

  Widget _codeBlock(NgColors c, String text) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: c.well,
      borderRadius: BorderRadius.circular(NgRadii.sm),
    ),
    child: SelectableText(
      text.length > 4000 ? '${text.substring(0, 4000)}…' : text,
      style: NgType.code.copyWith(color: c.text2, fontSize: 11.5),
    ),
  );
}

/// What the agent is waiting on: approval, a question or a secret.
class _InputPanel extends StatefulWidget {
  const _InputPanel({
    required this.chat,
    required this.request,
    this.available = double.infinity,
  });
  final NgChatController chat;
  final NgInputRequest request;

  /// The chat body's height (keyboard already removed).
  final double available;

  @override
  State<_InputPanel> createState() => _InputPanelState();
}

class _InputPanelState extends State<_InputPanel> {
  final _text = TextEditingController();
  final _user = TextEditingController();
  late List<Set<String>> _picked;
  late List<TextEditingController> _answers;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void didUpdateWidget(covariant _InputPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.request != widget.request) {
      for (final a in _answers) {
        a.dispose();
      }
      _text.clear();
      _user.clear();
      _reset();
    }
  }

  void _reset() {
    _picked = [for (final _ in widget.request.questions) <String>{}];
    _answers = [
      for (final _ in widget.request.questions) TextEditingController(),
    ];
  }

  @override
  void dispose() {
    _text.dispose();
    _user.dispose();
    for (final a in _answers) {
      a.dispose();
    }
    super.dispose();
  }

  void _done(bool ok) {
    if (!ok && mounted) {
      ngToast(context, ngL.ng_the_gateway_connection_dropped_try_again);
    }
  }

  static String _choiceLabel(String choice) => switch (choice) {
    'once' => ngL.ng_allow_once,
    'session' => ngL.ng_allow_for_this_chat,
    'always' => ngL.ng_always_allow,
    'deny' => ngL.ng_deny,
    _ => choice,
  };

  Widget _choiceChild(String choice) {
    final grant = widget.request.request.params['kind']?.toString();
    final sandboxGrant = grant == 'access' || grant == 'network';
    if (choice != 'once' || !sandboxGrant) {
      return Text(_choiceLabel(choice));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_choiceLabel(choice)),
        Text(ngL.ng_allow_until_sandbox_off),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final r = widget.request;
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(NgRadii.xl),
          border: Border.all(color: c.accent.withValues(alpha: 0.5)),
        ),
        // A share of the space above the keyboard, so the answer field
        // stays in sight while typing.
        constraints: BoxConstraints(
          maxHeight: ngAboveComposerMaxHeight(
            context,
            available: widget.available,
            fraction: 0.6,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.pan_tool_alt, size: 18, color: c.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      r.title,
                      style: NgType.heading.copyWith(color: c.text),
                    ),
                  ),
                ],
              ),
              if (r.body.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(r.body, style: NgType.bodySmall.copyWith(color: c.text2)),
              ],
              if (r.command != null && r.command!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.well,
                    borderRadius: BorderRadius.circular(NgRadii.sm),
                  ),
                  child: SelectableText(
                    r.command!,
                    style: NgType.code.copyWith(color: c.text),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              ..._body(c, r),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _body(NgColors c, NgInputRequest r) {
    switch (r.kind) {
      case NgRequestKind.setupBeat:
        // Drawn by SetupBeatCard instead of this panel.
        return const [];
      case NgRequestKind.approval:
        return [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final choice in r.choices)
                choice == 'deny'
                    ? OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: c.danger,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () =>
                            _done(widget.chat.answerApproval(choice)),
                        child: _choiceChild(choice),
                      )
                    : FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: choice == 'once'
                              ? c.accent
                              : c.surface3,
                          foregroundColor: choice == 'once'
                              ? c.onAccent
                              : c.text,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () =>
                            _done(widget.chat.answerApproval(choice)),
                        child: _choiceChild(choice),
                      ),
            ],
          ),
        ];
      case NgRequestKind.clarify:
        return [
          for (var i = 0; i < r.questions.length; i++) ...[
            if (r.questions.length > 1 || r.questions[i].question.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  r.questions[i].question,
                  style: NgType.label.copyWith(color: c.text),
                ),
              ),
            if (r.questions[i].choices.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final choice in r.questions[i].choices)
                    FilterChip(
                      label: Text(choice),
                      selected: _picked[i].contains(choice),
                      onSelected: (on) => setState(() {
                        if (!r.questions[i].multiSelect) _picked[i].clear();
                        on ? _picked[i].add(choice) : _picked[i].remove(choice);
                      }),
                    ),
                ],
              ),
            const SizedBox(height: 8),
            NgField(
              controller: _answers[i],
              hint: r.questions[i].choices.isEmpty
                  ? ngL.ng_your_answer
                  : ngL.ng_or_type_an_answer,
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              TextButton(
                onPressed: () => _done(widget.chat.cancelClarify()),
                child: Text(ngL.ng_skip),
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: c.accent,
                  foregroundColor: c.onAccent,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => _done(
                  widget.chat.answerClarify([
                    for (var i = 0; i < r.questions.length; i++)
                      _answers[i].text.trim().isNotEmpty
                          ? [_answers[i].text.trim()]
                          : _picked[i].toList(),
                  ]),
                ),
                child: Text(ngL.ng_answer),
              ),
            ],
          ),
        ];
      case NgRequestKind.secret:
        return [
          NgField(controller: _text, obscure: r.masked, autofocus: true),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: () => _done(widget.chat.answerValue('')),
                child: Text(ngL.ng_cancel),
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: c.accent,
                  foregroundColor: c.onAccent,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => _done(widget.chat.answerValue(_text.text)),
                child: Text(ngL.ng_send),
              ),
            ],
          ),
        ];
      case NgRequestKind.saveLogin:
        return [
          NgField(controller: _user, label: ngL.ng_username_or_email),
          const SizedBox(height: 10),
          NgField(controller: _text, label: ngL.ng_password, obscure: true),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: () => _done(widget.chat.answerSaveLogin('', '')),
                child: Text(ngL.ng_not_now),
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: c.accent,
                  foregroundColor: c.onAccent,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => _done(
                  widget.chat.answerSaveLogin(_user.text.trim(), _text.text),
                ),
                child: Text(ngL.ng_save),
              ),
            ],
          ),
        ];
    }
  }
}

class _NoListenable implements Listenable {
  const _NoListenable();
  @override
  void addListener(VoidCallback listener) {}
  @override
  void removeListener(VoidCallback listener) {}
}
